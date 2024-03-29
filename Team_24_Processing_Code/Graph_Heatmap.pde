class DensityGraph extends Graph {

    void draw(ArrayList<RouteDataPoint> values) {
        // Set up variables for drawing
        float topMargin = 50;
        float leftMargin = 50;
        float cellSize = 30;

        // Find the unique origin and destination airports
        ArrayList<String> airports = new ArrayList<>();
        for (RouteDataPoint data : values) {
            if (!airports.contains(data.ORIGIN)) {
                airports.add(data.ORIGIN);
            }
            if (!airports.contains(data.DEST)) {
                airports.add(data.DEST);
            }
        }
        airports.sort(String::compareTo);

        // Calculate the maximum flight count
        int maxFlightCount = 0;
        for (RouteDataPoint data : values) {
            maxFlightCount = Math.max(maxFlightCount, data.FLIGHT_COUNT);
        }

        // Create a hashmap to store frequencies for each route
        HashMap<String, Integer> frequencyMap = new HashMap<>();
        for (RouteDataPoint data : values) {
            String route = data.ORIGIN + "-" + data.DEST;
            frequencyMap.put(route, data.FLIGHT_COUNT);
        }

        // Draw the grid
        for (int i = 0; i < airports.size(); i++) {
            for (int j = 0; j < airports.size(); j++) {
                String route = airports.get(i) + "-" + airports.get(j);
                float x = leftMargin + i * cellSize;
                float y = topMargin + j * cellSize;

                // Fill the cell with appropriate shade of grey based on frequency
                int frequency = frequencyMap.getOrDefault(route, 0);
                int shade = (int) map(frequency, 0, maxFlightCount, 255, 0);
                fill(shade);
                rect(x, y, cellSize, cellSize);

                // Determine text color based on shade
                if (shade > 200) {
                    fill(0); // Dark text for light background
                } else {
                    fill(255); // Light text for dark background
                }
                textAlign(CENTER, CENTER);
                if (frequency > 0) {
                    text(frequency, x + cellSize / 2, y + cellSize / 2);
                } else {
                    text("X", x + cellSize / 2, y + cellSize / 2);
                }
            }
        }

        // Draw labels
        textAlign(CENTER, TOP); // Adjusted textAlign for x-labels
        for (int i = 0; i < airports.size(); i++) {
            float x = leftMargin + i * cellSize + cellSize / 2;
            float y = topMargin - 10; // Adjusted y-coordinate for x-labels
            text(airports.get(i), x, y);
        }
        textAlign(LEFT, CENTER);
        for (int j = 0; j < airports.size(); j++) {
            float y = topMargin + j * cellSize + cellSize / 2;
            text(airports.get(j), 30, y);
        }
    }
}
