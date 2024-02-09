#!/bin/bash

# Read API_KEY from .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found"
    exit 1
fi

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --city) city="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if city is provided
if [ -z "$city" ]; then
    echo "Please provide a city using --city flag"
    exit 1
fi

# Fetch weather data
weather_info=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$API_KEY&units=imperial")

# Check if API response contains weather data
if [ -z "$weather_info" ]; then
    echo "Error: Unable to fetch weather data"
    exit 1
fi

# Extract temperature and description from weather_info
temperature=$(echo "$weather_info" | grep -o '"temp":[^,]*' | cut -d ':' -f 2)
description=$(echo "$weather_info" | grep -o '"description":"[^"]*' | cut -d '"' -f 3)

# Print weather information
echo "Currently, the weather in $city is $description with a temperature of $temperature°F — have a nice day!"
