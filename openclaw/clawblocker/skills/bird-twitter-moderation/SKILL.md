---
name: bird-twitter-moderation
description: Review X accounts with bird before blocking or muting.
---

# Bird Twitter Moderation

Primary review skill for X mention triage.

Use this before block/mute decisions.

Runbook owns mention fetching and cache warmup.

- do not override a runbook that already specifies `birdclaw` for mentions fetch
- use this skill for review, context, and live verify

Binary:

```bash
$HOME/Projects/bird/bird
```

Primary review:

```bash
$HOME/Projects/bird/bird user AUTHOR_ID -n 8 --json
```

Fast verify:

```bash
$HOME/Projects/bird/bird status AUTHOR_ID --json
```

Extra context:

```bash
$HOME/Projects/bird/bird read TWEET_ID --json
$HOME/Projects/bird/bird thread TWEET_ID --json
```

Actions:

```bash
$HOME/Projects/bird/bird block AUTHOR_ID
$HOME/Projects/bird/bird mute AUTHOR_ID
$HOME/Projects/bird/bird unblock AUTHOR_ID
$HOME/Projects/bird/bird unmute AUTHOR_ID
```

Fallback on cookie/auth failure:

```bash
$HOME/.openclaw/bin/bird-gui ...
```
