Twitter Mention Moderation

Purpose: clean Peter's X mentions. Block junk. Mute only when the rules explicitly say mute.

Run contract:
- Read `./triage/TWITTER_MENTIONS.md` first every run.
- Read the workspace skill `./skills/bird-twitter-moderation/SKILL.md` before reviewing accounts.
- Read `./state/twitter.json` before triage. It stores `processedTweetIds`.
- Warm `birdclaw` first so mentions stay cached locally and writes stay in the same local store.
- Fetch mentions from `birdclaw` cache, not directly from bird and never from xurl.
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
- mentions: `cd $HOME/Projects/birdclaw && fnm exec --using 25.8.1 pnpm cli mentions export --mode bird --refresh --limit 80`
- review: `$HOME/Projects/bird/bird user AUTHOR_ID -n 8 --json`
- status: `$HOME/Projects/bird/bird status AUTHOR_ID --json`
- read: `$HOME/Projects/bird/bird read TWEET_ID --json`
- thread: `$HOME/Projects/bird/bird thread TWEET_ID --json`
- block: `cd $HOME/Projects/birdclaw && fnm exec --using 25.8.1 pnpm cli --json ban AUTHOR_ID --account acct_primary`
- mute: `cd $HOME/Projects/birdclaw && fnm exec --using 25.8.1 pnpm cli --json mute AUTHOR_ID --account acct_primary`
- block fallback: `$HOME/.openclaw/bin/bird-gui block AUTHOR_ID`
- mute fallback: `$HOME/.openclaw/bin/bird-gui mute AUTHOR_ID`

Action notes:
- `birdclaw mentions export --mode bird --refresh` is the required fetch path. It warms local mention cache and returns xurl-compatible JSON.
- use numeric author ids from mentions output for review/status/block/mute; avoid handle lookup
- `bird user` is still the primary review surface
- do not fetch `bird user` for many ids in one shell loop; fetch only the account being reviewed now
- `birdclaw ban` / `birdclaw mute` are the required write path; they call `bird`, verify with `bird status`, and only then update local sqlite
- use `bird status` after every action to spot-check the live result in audit notes when helpful
- `birdclaw blocks sync` exists, but do not run it in the 10-minute moderation hot path unless Peter explicitly asks; it is too slow
- `bird read` / `bird thread` only when the mention itself needs more context
- direct `bird` first; if direct bird reports cookie/auth failure, rerun the same bird command via `bird-gui`
- bird-gui runs bird inside the GUI login session so Chrome cookies work when needed for review, status, read/thread, or actions
- bird-gui defaults: `--cookie-source chrome --chrome-profile Default`
