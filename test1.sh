#!/bin/bash

# Function to display all processes
display_all_processes() {
    echo "----------------------------------"
    echo "Displaying all processes:"
    echo "----------------------------------"
    ps aux | less
}

# Function to display a specific process by PID
display_process_by_pid() {
    local pid=$1
    if [[ -z $pid ]]; then
        echo "Error: No PID specified."
        exit 1
    fi
    echo "----------------------------------"
    echo "Displaying information for PID: $pid"
    echo "----------------------------------"
    ps -p $pid -o pid,ppid,cmd,%mem,%cpu
}

# Function to display top processes in real-time
display_top_processes() {
    echo "----------------------------------"
    echo "Displaying top processes in real-time:"
    echo "----------------------------------"
    top
}

# Function to kill a specific process by PID
kill_process_by_pid() {
    local pid=$1
    if [[ -z $pid ]]; then
        echo "Error: No PID specified."
        exit 1
    fi
    echo "----------------------------------"
    echo "Killing process with PID: $pid"
    echo "----------------------------------"
    kill $pid
    if [[ $? -eq 0 ]]; then
        echo "Process $pid has been terminated."
    else
        echo "Failed to terminate process $pid."
    fi
}

# Function to search for a process by name
search_process_by_name() {
    local pname=$1
    if [[ -z $pname ]]; then
        echo "Error: No process name specified."
        exit 1
    fi
    echo "----------------------------------"
    echo "Searching for processes with name: $pname"
    echo "----------------------------------"
    pids=$(pgrep -f $pname)
    if [[ -z $pids ]]; then
        echo "No processes found with name: $pname"
        exit 0
    fi
    for pid in $pids; do
        display_process_by_pid $pid
    done
}

# Function to display the help message
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -a, --all          Display all processes"
    echo "  -p, --pid <PID>    Display information for a specific process ID (PID)"
    echo "  -t, --top          Display top processes in real-time"
    echo "  -k, --kill <PID>   Kill a specific process by PID"
    echo "  -s, --search <NAME> Search for a process by name"
    echo "  -h, --help         Display this help message"
    echo
}

# Main script logic
if [[ $# -eq 0 ]]; then
    display_help
    exit 0
fi

case $1 in
    -a|--all)
        display_all_processes
        ;;
    -p|--pid)
        shift
        display_process_by_pid $1
        ;;
    -t|--top)
        display_top_processes
        ;;
    -k|--kill)
        shift
        kill_process_by_pid $1
        ;;
    -s|--search)
        shift
        search_process_by_name $1
        ;;
    -h|--help)
        display_help
        ;;
    *)
        echo "Error: Invalid option."
        display_help
        ;;
esac
