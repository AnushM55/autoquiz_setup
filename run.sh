BACKEND_LOG="backend.log"
FRONTEND_LOG="frontend.log"

run_service() {
  local name=$1
  local command=$2
  local log_file=$3

  echo "Starting $name..."
  nohup bash -c "$command" >"$log_file" 2>&1 &
  local pid=$!
  echo "$name started with PID $pid (Logs: $log_file)"
  echo $pid >"${name}.pid"
}

# Function to stop a service
stop_service() {
  local name=$1

  if [ -f "${name}.pid" ]; then
    local pid=$(cat "${name}.pid")
    echo "Stopping $name (PID $pid)..."
    kill "$pid" && rm "${name}.pid"
    echo "$name stopped."
  else
    echo "$name is not running."
  fi
}

# Function to check logs
view_logs() {
  local name=$1
  local log_file=$2

  echo "Viewing logs for $name..."
  tail -f "$log_file"
}

BACKEND_REPO="https://github.com/anushm55/autoquiz_backend.git"
FRONTEND_REPO="https://github.com/anushm55/autoquiz_frontend.git"

BACKEND_DIR="autoquiz_backend"
FRONTEND_DIR="autoquiz_frontend"

cd $FRONTEND_DIR
run_service "frontend" "npm run dev" "../$FRONTEND_LOG"
cd ..
cd $BACKEND_DIR
source venv/bin/activate
run_service "backend" "python main.py" "../$BACKEND_LOG"
cd ..

while true; do
  echo ""
  echo "===== AutoQuiz Manager ====="
  echo "1) View Backend Logs"
  echo "2) View Frontend Logs"
  echo "3) Stop Backend"
  echo "4) Stop Frontend"
  echo "5) Stop Both"
  echo "6) Exit"
  read -p "Enter your choice: " choice

  case $choice in
  1) view_logs "backend" "$BACKEND_LOG" ;;
  2) view_logs "frontend" "$FRONTEND_LOG" ;;
  3) stop_service "backend" ;;
  4) stop_service "frontend" ;;
  5)
    stop_service "backend"
    stop_service "frontend"
    ;;
  6)
    echo "Exiting..."
    exit 0
    ;;
  *) echo "Invalid choice. Please try again." ;;
  esac
done
