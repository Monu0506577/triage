---
name: bird-twitter-moderation
description: Review X accounts with bird before blocking or muting.
---

# Bird Twitter Moderation

Primary review skill for X mention triage.

Use this before block/mute decisions.

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
