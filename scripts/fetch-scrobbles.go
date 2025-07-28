package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/shkh/lastfm-go/lastfm"
)

type Scrobble struct {
	Artist    string    `json:"artist"`
	Track     string    `json:"track"`
	Album     string    `json:"album"`
	Timestamp time.Time `json:"timestamp"`
	URL       string    `json:"url"`
}

// loadEnvFile loads environment variables from a .env file
func loadEnvFile(filename string) error {
	file, err := os.Open(filename)
	if err != nil {
		return err // File doesn't exist, which is okay
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())

		// Skip empty lines and comments
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		// Parse key=value pairs
		if strings.Contains(line, "=") {
			parts := strings.SplitN(line, "=", 2)
			if len(parts) == 2 {
				key := strings.TrimSpace(parts[0])
				value := strings.TrimSpace(parts[1])

				// Only set if not already set in environment
				if os.Getenv(key) == "" {
					os.Setenv(key, value)
				}
			}
		}
	}

	return scanner.Err()
}

func main() {
	// Try to load .env file
	if err := loadEnvFile(".env"); err != nil {
		log.Printf("Warning: Could not load .env file: %v", err)
	}

	// Get credentials from environment variables
	apiKey := os.Getenv("LASTFM_API_KEY")
	apiSecret := os.Getenv("LASTFM_API_SECRET")
	username := os.Getenv("LASTFM_USERNAME")

	// Validate that all required environment variables are set
	if apiKey == "" || apiSecret == "" || username == "" {
		log.Fatal("Missing required environment variables: LASTFM_API_KEY, LASTFM_API_SECRET, LASTFM_USERNAME")
	}

	// Create API instance
	api := lastfm.New(apiKey, apiSecret)

	// Get recent tracks (last 20 scrobbles)
	result, err := api.User.GetRecentTracks(lastfm.P{
		"user":  username,
		"limit": 20,
	})

	if err != nil {
		log.Fatalf("Error fetching recent tracks: %v", err)
	}

	// Convert to our format
	var scrobbles []Scrobble
	for _, track := range result.Tracks {
		// Skip currently playing track (no timestamp)
		if track.Date.Uts == "" {
			continue
		}

		// Parse Unix timestamp
		timestamp, err := strconv.ParseInt(track.Date.Uts, 10, 64)
		if err != nil {
			log.Printf("Error parsing timestamp for %s: %v", track.Name, err)
			continue
		}

		scrobble := Scrobble{
			Artist:    track.Artist.Name,
			Track:     track.Name,
			Album:     track.Album.Name,
			Timestamp: time.Unix(timestamp, 0),
			URL:       track.Url,
		}
		scrobbles = append(scrobbles, scrobble)
	}

	// Create assets/data directory if it doesn't exist
	if err := os.MkdirAll("assets/data", 0755); err != nil {
		log.Fatalf("Error creating assets/data directory: %v", err)
	}

	// Write to Hugo assets data file
	outputFile := "assets/data/scrobbles.json"
	file, err := os.Create(outputFile)
	if err != nil {
		log.Fatalf("Error creating output file: %v", err)
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(scrobbles); err != nil {
		log.Fatalf("Error encoding JSON: %v", err)
	}

	fmt.Printf("Successfully fetched %d scrobbles and saved to %s\n", len(scrobbles), outputFile)
}
