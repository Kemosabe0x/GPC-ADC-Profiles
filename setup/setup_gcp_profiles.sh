#!/bin/bash
# Script to automate Google Cloud profiles and ADC configuration
# Run this script in your interactive terminal using: bash setup_gcp_profiles.sh

set -e

echo "=== Google Cloud CLI & ADC Profile Configurator ==="

# 1. Back up current default ADC
DEFAULT_ADC_PATH="$HOME/.config/gcloud/application_default_credentials.json"
TARGET_DEFAULT_ADC="$HOME/.config/gcloud/application_default_credentials_default.json"

if [ -f "$DEFAULT_ADC_PATH" ]; then
    echo "Copying current default ADC to $TARGET_DEFAULT_ADC..."
    cp "$DEFAULT_ADC_PATH" "$TARGET_DEFAULT_ADC"
else
    echo "Warning: No current ADC file found at $DEFAULT_ADC_PATH."
    echo "Setting up 'default' configuration..."
    # Ensure default config is active
    gcloud config configurations activate default 2>/dev/null || gcloud config configurations create default
    echo "Please authenticate with your main/personal account:"
    gcloud auth login
    echo "Generating default ADC..."
    gcloud auth application-default login
    cp "$DEFAULT_ADC_PATH" "$TARGET_DEFAULT_ADC"
fi

# 2. Create and configure org profile
echo ""
echo "Creating/switching to 'org' configuration..."
if gcloud config configurations list --format="value(name)" 2>/dev/null | grep -q "^org$"; then
    echo "Configuration 'org' already exists. Activating..."
    gcloud config configurations activate org
else
    echo "Creating configuration 'org'..."
    gcloud config configurations create org
fi

echo ""
echo "Please authenticate with your GOOGLE ORGANIZATION account:"
gcloud auth login

echo ""
echo "Generating Application Default Credentials (ADC) for your organization account..."
gcloud auth application-default login

TARGET_ORG_ADC="$HOME/.config/gcloud/application_default_credentials_org.json"
echo "Moving organization ADC to $TARGET_ORG_ADC..."
mv "$DEFAULT_ADC_PATH" "$TARGET_ORG_ADC"

# 3. Restore default configuration
echo ""
echo "Restoring active configuration to 'default'..."
gcloud config configurations activate default

echo ""
echo "=== Success! ==="
echo "Default credentials saved to: $TARGET_DEFAULT_ADC"
echo "Organization credentials saved to: $TARGET_ORG_ADC"
echo ""
echo "To apply, please reload your terminal by running: source ~/.zshrc"
echo "Then use 'gcp-org' or 'gcp-default' to switch between your profiles!"
