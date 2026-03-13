Twitter Block Digest

Purpose: send one daily email to Peter with profiles newly blocked by the twitter moderation cron.

Run contract:
- Run `./send-block-digest.sh` exactly.
- Do not improvise parsing or email formatting outside the script.
- End with one terse summary.

Files:
- state: `./state.json`
- script: `./send-block-digest.sh`
- source audit: `$HOME/.openclaw/workspace-clawblocker/audit/twitter/*.md`
