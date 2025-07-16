#!/bin/bash

# Set up the API key and environment for Google AI Studio
export GOOGLE_API_KEY="F0Q"
export VERTEXAI=false

echo "✅ Using Google AI Studio with API key"

echo "==============================================================================="
echo "| Starting your agent playground with Google AI Studio...                    |"
echo "|                                                                             |"
echo "| Try asking: What's the weather in San Francisco?                           |"
echo "| Frontend will be available at: http://localhost:8501                       |"
echo "| Backend API will be available at: http://localhost:8000                    |"
echo "==============================================================================="

# Start the backend
echo "Starting backend server..."
cd /workspaces/agent-starter-pack/my-awesome-agent
uv run uvicorn app.server:app --host 0.0.0.0 --port 8000 --reload &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Start the frontend
echo "Starting frontend..."
PORT=8501 npm --prefix frontend start &
FRONTEND_PID=$!

# Function to cleanup on exit
cleanup() {
    echo "Stopping servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Wait for both processes
wait
