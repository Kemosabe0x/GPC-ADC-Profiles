# Google Cloud Platform (GCP) Profile & ADC Switcher

A streamlined setup for managing multiple Google Cloud CLI configuration profiles and their corresponding Application Default Credentials (ADC) on macOS.

---

## The Problem
By default, the Google Cloud CLI (`gcloud`) supports multiple configurations via `gcloud config configurations`. However, Application Default Credentials (ADC) — which are used by application code, client libraries, and tools like Terraform — always write to and read from a single global file: `~/.config/gcloud/application_default_credentials.json`. 

As a result, switching your `gcloud` CLI profile does **not** automatically switch your ADC, causing permission conflicts when running local development servers or scripts.

## The Solution
This setup segregates your ADC credential files and uses shell functions to switch both your `gcloud` configuration and the `GOOGLE_APPLICATION_CREDENTIALS` environment variable dynamically.

---

## Directory Structure

```text
gpc-adc-profiles/
├── README.md
└── setup/
    └── setup_gcp_profiles.sh      # Automation script for credentials initialization
```

---

## Installation & Setup

### 1. Initialize Profiles and Credentials
Run the setup script in your interactive terminal. It will guide you through authenticating both accounts:

```bash
bash setup/setup_gcp_profiles.sh
```

**What the script does:**
1. Backs up your current default credentials (`kemosabedeveloper@gmail.com`) to `~/.config/gcloud/application_default_credentials_default.json`.
2. Creates and activates a new `gcloud` configuration profile named `org`.
3. Prompts you to log in with your **Google organization account** via the browser.
4. Saves the organization credentials to `~/.config/gcloud/application_default_credentials_org.json`.
5. Restores your active `gcloud` CLI configuration back to `default`.

---

## Usage

Reload your terminal session to load the aliases:
```bash
source ~/.zshrc
```

Use the following helper functions to switch between your profiles:

### Switch to Default / Personal profile
```bash
gcp-default
```
*   Activates the `default` CLI profile (`kemosabedeveloper@gmail.com`).
*   Sets `GOOGLE_APPLICATION_CREDENTIALS` to point to `application_default_credentials_default.json`.

### Switch to Organization profile
```bash
gcp-org
```
*   Activates the `org` CLI profile (your organization account).
*   Sets `GOOGLE_APPLICATION_CREDENTIALS` to point to `application_default_credentials_org.json`.

---

## Verification

To verify which credentials your application or local scripts are using, run:

```bash
# Check current active gcloud CLI identity
gcloud config list

# Check where ADC is pointing
echo $GOOGLE_APPLICATION_CREDENTIALS
```
