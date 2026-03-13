Email Triage

Purpose: review Peter's Gmail inbox with `gog`. Careful first. Observe-first. Surface real work. Suppress sludge.

Run contract:
- Read `./triage/EMAILRULES.md` first every run.
- Read `./state/email.json` before triage.
- Use `gog` only for Gmail access.
- Observe-first only: no archive, no mark-read, no labels, no reply, no delete.
- Check unread inbox, recent inbox mail, security mail, and GitHub mail.
- Re-report older unread security/human/time-bound mail still sitting in inbox.
- Do not repeat the same low-value noise every run if it was already reported.
- Write one audit note to `./audit/email/YYYY-MM-DD.md`.
- Update `./state/email.json` with `lastRunAt` and capped reported thread ids.
- End with one terse digest.

Commands:
- unread: `gog -a steipete@gmail.com gmail search 'in:inbox is:unread' --json`
- recent: `gog -a steipete@gmail.com gmail search 'in:inbox newer_than:3d' --json`
- security: `gog -a steipete@gmail.com gmail search 'in:inbox (security OR vulnerability OR GHSA OR CVE OR incident OR breach)' --json`
- github: `gog -a steipete@gmail.com gmail search 'in:inbox from:notifications@github.com' --json`
- get: `gog -a steipete@gmail.com gmail get MESSAGE_ID --json`
- thread: `gog -a steipete@gmail.com gmail thread get THREAD_ID --json`

Decision rules:
- Security / incident / abuse: keep. never auto-archive.
- Time-bound ops: keep.
- Real human / needs reply: keep.
- GitHub direct action: keep.
- Unknown / unclear class: keep.
- Newsletter / event / broadcast: archive candidate only.
- Auto-reply / confirmation / machine noise: archive candidate only.
- Unknown low-context tasking mail with no relationship/context: archive candidate only.
- Prefer false positive over false negative for security/human mail.
- If unsure whether a sender is human or whether a thread has context, fetch the full thread before deciding.
