Twitter Mention Moderation

Purpose: clean Peter's X mentions. Block junk. Mute only when the rules explicitly say mute.

Run contract:
- Read `./triage/TWITTER_MENTIONS.md` first every run.
- Read the workspace skill `./skills/bird-twitter-moderation/SKILL.md` before reviewing accounts.
- Read `./state/twitter.json` before triage. It stores `processedTweetIds`.
- Fetch mentions with bird, not xurl.
- Work newest-first.
- Process at most 20 new mentions per pass. Leave the rest for the next cron run.
- Work mention-by-mention. No bulk prefetch loops over many accounts.
- Skip tweet ids already processed.
- Apply the rules. Review accounts with bird first. If still unsure, inspect the mention/thread directly.
- Block obvious crap. Mute only for the explicit human/non-English low-value bucket.
- If someone is nice/supportive/genuinely engaged with Peter, do not block them just for crypto/AI-ish identity markers.
- If a mention contains self-promo, product pitch, platform/site plug, or link-drop marketing, inspect profile replies/activity before deciding.
- If a token/project account pitches OpenClaw/agent/lobster competitions, sponsorships, treasury/reward schemes, mining, or earnings: treat it as shill/promo and usually block.
- If a mention contains direct abuse/profanity, load `bird thread` to confirm who the abuse is aimed at before deciding.
- Append every reviewed tweet to `./audit/twitter/YYYY-MM-DD.md` with timestamp, action, handle, URL, reasons, and transport result when relevant.
- If block/mute fails, record FAIL and do not mark the tweet as processed.
- Keep `processedTweetIds` capped to 4000 newest ids.
- End with one terse summary line.

Commands:
- mentions: `$HOME/Projects/bird/bird mentions -n 80 --json | jq '{items: [.[] | {id, text, createdAt, authorId, conversationId, username: .author.username, name: .author.name}], meta: {count: length}}'`
- review: `$HOME/Projects/bird/bird user AUTHOR_ID -n 8 --json`
- status: `$HOME/Projects/bird/bird status AUTHOR_ID --json`
- read: `$HOME/Projects/bird/bird read TWEET_ID --json`
- thread: `$HOME/Projects/bird/bird thread TWEET_ID --json`
- block: `$HOME/Projects/bird/bird block AUTHOR_ID`
- mute: `$HOME/Projects/bird/bird mute AUTHOR_ID`
- block fallback: `$HOME/.openclaw/bin/bird-gui block AUTHOR_ID`
- mute fallback: `$HOME/.openclaw/bin/bird-gui mute AUTHOR_ID`
