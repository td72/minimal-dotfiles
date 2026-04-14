#!/usr/bin/env bash

# Test script for minimal dotfiles
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"

    echo -n "Testing $test_name... "
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC}"
        echo "  Command: $test_command"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo -e "${YELLOW}Running dotfiles tests...${NC}\n"

# Test XDG directories exist
echo -e "${YELLOW}1. Checking XDG directories...${NC}"
run_test "XDG_CONFIG_HOME exists" "[ -d \"\${XDG_CONFIG_HOME:-\$HOME/.config}\" ]"
run_test "XDG_DATA_HOME exists" "[ -d \"\${XDG_DATA_HOME:-\$HOME/.local/share}\" ]"
run_test "XDG_STATE_HOME exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}\" ]"
run_test "XDG_CACHE_HOME exists" "[ -d \"\${XDG_CACHE_HOME:-\$HOME/.cache}\" ]"

# Test Bash configuration
echo -e "\n${YELLOW}2. Checking Bash configuration...${NC}"
run_test "Bash config directory exists" "[ -d \"\${XDG_CONFIG_HOME:-\$HOME/.config}/bash\" ]"
run_test "bashrc exists in XDG_CONFIG_HOME" "[ -f \"\${XDG_CONFIG_HOME:-\$HOME/.config}/bash/bashrc\" ]"
run_test "bash_profile exists in XDG_CONFIG_HOME" "[ -f \"\${XDG_CONFIG_HOME:-\$HOME/.config}/bash/bash_profile\" ]"
run_test ".bashrc symlink exists" "[ -L \"\$HOME/.bashrc\" ]"
run_test ".bash_profile symlink exists" "[ -L \"\$HOME/.bash_profile\" ]"
run_test "Bash state directory exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}/bash\" ]"

# Test Fish configuration
echo -e "\n${YELLOW}3. Checking Fish configuration...${NC}"
run_test "Fish config directory exists" "[ -d \"\${XDG_CONFIG_HOME:-\$HOME/.config}/fish\" ]"
run_test "config.fish exists" "[ -f \"\${XDG_CONFIG_HOME:-\$HOME/.config}/fish/config.fish\" ]"
run_test "Fish state directory exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}/fish\" ]"

# Test Vim configuration
echo -e "\n${YELLOW}4. Checking Vim configuration...${NC}"
run_test "Vim config directory exists" "[ -d \"\${XDG_CONFIG_HOME:-\$HOME/.config}/vim\" ]"
run_test "vimrc exists in XDG_CONFIG_HOME" "[ -f \"\${XDG_CONFIG_HOME:-\$HOME/.config}/vim/vimrc\" ]"
run_test ".vimrc exists" "[ -f \"\$HOME/.vimrc\" ]"
run_test "Vim backup directory exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}/vim/backup\" ]"
run_test "Vim swap directory exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}/vim/swap\" ]"
run_test "Vim undo directory exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}/vim/undo\" ]"
run_test "Vim view directory exists" "[ -d \"\${XDG_STATE_HOME:-\$HOME/.local/state}/vim/view\" ]"

# Test Tmux configuration
echo -e "\n${YELLOW}5. Checking Tmux configuration...${NC}"
run_test "Tmux config directory exists" "[ -d \"\${XDG_CONFIG_HOME:-\$HOME/.config}/tmux\" ]"
run_test "tmux.conf exists in XDG_CONFIG_HOME" "[ -f \"\${XDG_CONFIG_HOME:-\$HOME/.config}/tmux/tmux.conf\" ]"
run_test ".tmux.conf symlink exists" "[ -L \"\$HOME/.tmux.conf\" ]"

# Test shell commands
echo -e "\n${YELLOW}6. Checking shell commands...${NC}"
run_test "Bash is executable" "command -v bash"
run_test "Fish is executable" "command -v fish"
run_test "Vim is executable" "command -v vim"
run_test "Tmux is executable" "command -v tmux"

# Shellcheck validation (if available)
if command -v shellcheck > /dev/null 2>&1; then
    echo -e "\n${YELLOW}7. Running shellcheck validation...${NC}"
    run_test "setup.sh passes shellcheck" "shellcheck setup.sh"
    run_test "test.sh passes shellcheck" "shellcheck test.sh"
fi

# Test setup script idempotency
echo -e "\n${YELLOW}8. Testing setup script idempotency...${NC}"
run_test "Re-running setup.sh succeeds" "bash setup.sh"

# Results summary
echo -e "\n${YELLOW}Test Results:${NC}"
echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
fi
