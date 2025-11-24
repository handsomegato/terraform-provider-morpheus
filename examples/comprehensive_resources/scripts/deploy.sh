#!/bin/bash

# Application deployment script
# This script is used by the Morpheus deployment task

set -e

# Variables (these would be passed from Morpheus)
APP_NAME=${APP_NAME:-"myapp"}
APP_VERSION=${APP_VERSION:-"latest"}
DEPLOY_DIR=${DEPLOY_DIR:-"/opt/myapp"}
SERVICE_USER=${SERVICE_USER:-"appuser"}

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting deployment of $APP_NAME version $APP_VERSION"

# Create application directory
if [ ! -d "$DEPLOY_DIR" ]; then
    log "Creating application directory: $DEPLOY_DIR"
    mkdir -p "$DEPLOY_DIR"
fi

# Create service user if it doesn't exist
if ! id "$SERVICE_USER" &>/dev/null; then
    log "Creating service user: $SERVICE_USER"
    useradd -r -s /bin/false -d "$DEPLOY_DIR" "$SERVICE_USER"
fi

# Download and extract application
log "Downloading application version $APP_VERSION"
cd /tmp
wget "https://releases.example.com/$APP_NAME-$APP_VERSION.tar.gz"
tar -xzf "$APP_NAME-$APP_VERSION.tar.gz"

# Install application
log "Installing application files"
cp -r "$APP_NAME-$APP_VERSION"/* "$DEPLOY_DIR/"
chown -R "$SERVICE_USER:$SERVICE_USER" "$DEPLOY_DIR"
chmod +x "$DEPLOY_DIR/bin/$APP_NAME"

# Install systemd service
log "Installing systemd service"
cat > "/etc/systemd/system/$APP_NAME.service" << EOF
[Unit]
Description=$APP_NAME application
After=network.target

[Service]
Type=simple
User=$SERVICE_USER
WorkingDirectory=$DEPLOY_DIR
ExecStart=$DEPLOY_DIR/bin/$APP_NAME
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
log "Enabling and starting service"
systemctl daemon-reload
systemctl enable "$APP_NAME"
systemctl start "$APP_NAME"

# Verify deployment
log "Verifying deployment"
sleep 5
if systemctl is-active --quiet "$APP_NAME"; then
    log "Deployment successful - $APP_NAME is running"
else
    log "Deployment failed - $APP_NAME is not running"
    exit 1
fi

# Cleanup
log "Cleaning up temporary files"
rm -rf "/tmp/$APP_NAME-$APP_VERSION"*

log "Deployment completed successfully"