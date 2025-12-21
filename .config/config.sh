# Local Configuration Example
# Copy this file to .config/config.sh and customize for your local machine
# This file is not tracked by git and will be sourced by shell configs if it exists

# =====================================================
# Example: Machine-specific environment variables
# =====================================================

# Uncomment and modify for your local needs:
# export MY_CUSTOM_VAR="value"
# export LOCAL_PATH="/some/local/path"

# =====================================================
# Example: Conditional configurations based on hostname
# =====================================================

# if [[ "$HOSTNAME" == "my-server" ]]; then
#     export ROS_MASTER_URI=http://192.168.1.100:11311
#     export ROS_HOSTNAME=my-local-ip
# fi

# =====================================================
# Example: Proxy settings (if needed)
# =====================================================

# if [[ -n "$HTTP_PROXY" ]]; then
#     export http_proxy="$HTTP_PROXY"
#     export https_proxy="$HTTP_PROXY"
# fi

# =====================================================
# Example: Custom local aliases
# =====================================================

# alias mylocal='echo "This is a local alias"'

# =====================================================
# Example: Local PATH additions
# =====================================================

# export PATH="$PATH:$HOME/.local/bin:/opt/custom/bin"

# =====================================================
# Example: Development environment setup
# =====================================================

# if command -v nvm &>/dev/null; then
#     export NVM_DIR="$HOME/.nvm"
# fi
