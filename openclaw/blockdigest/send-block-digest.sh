#!/bin/bash
set -euo pipefail

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace-twitter-block-digest}"
STATE_FILE="${STATE_FILE:-$WORKSPACE/state.json}"
AUDIT_DIR="${AUDIT_DIR:-$HOME/.openclaw/workspace-clawblocker/audit/twitter}"
ACCOUNT="${GOG_ACCOUNT:-steipete@gmail.com}"
TO_EMAIL="${BLOCK_DIGEST_TO:-steipete@gmail.com}"
GOG_BIN="${GOG_BIN:-gog}"
NOW_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

TMPDIR_PATH="$(mktemp -d /tmp/block-digest.XXXXXX)"
BODY_FILE="$TMPDIR_PATH/body.txt"
META_FILE="$TMPDIR_PATH/meta.json"
cleanup() {
  rm -rf "$TMPDIR_PATH"
}
trap cleanup EXIT

/usr/bin/python3 - "$STATE_FILE" "$AUDIT_DIR" "$NOW_UTC" "$BODY_FILE" "$META_FILE" <<'PY'
import json
import re
import sys
from collections import OrderedDict
from datetime import datetime, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

state_path = Path(sys.argv[1])
audit_dir = Path(sys.argv[2])
now_utc = datetime.fromisoformat(sys.argv[3].replace("Z", "+00:00"))
body_path = Path(sys.argv[4])
meta_path = Path(sys.argv[5])

london = ZoneInfo("Europe/London")

def parse_ts(raw: str) -> datetime:
    raw = raw.strip()
    for fmt in ("%Y-%m-%dT%H:%M:%S.%fZ", "%Y-%m-%dT%H:%M:%SZ"):
        try:
            return datetime.strptime(raw, fmt).replace(tzinfo=timezone.utc)
        except ValueError:
            pass
    if raw.endswith(" GMT"):
        return datetime.strptime(raw, "%Y-%m-%d %H:%M:%S GMT").replace(tzinfo=timezone.utc)
    if raw.endswith(" Europe/London"):
        base = raw[: -len(" Europe/London")]
        return datetime.strptime(base, "%Y-%m-%d %H:%M").replace(tzinfo=london).astimezone(timezone.utc)
    try:
        return datetime.fromisoformat(raw)
    except ValueError:
        return datetime.strptime(raw, "%Y-%m-%d %H:%M:%S").replace(tzinfo=timezone.utc)

state = {"lastSentAt": None, "lastSubject": None, "lastCount": 0}
if state_path.exists():
    try:
        state.update(json.loads(state_path.read_text()))
    except Exception:
        pass

last_sent_raw = state.get("lastSentAt")
if last_sent_raw:
    window_start = datetime.fromisoformat(str(last_sent_raw).replace("Z", "+00:00"))
else:
    window_start = now_utc - timedelta(days=1)

line_re = re.compile(
    r"^- (?P<ts>[^|]+?) \| (?P<action>[^|]+?) \| (?P<handle>[^|]+?) \| (?P<url>[^|]+?) \| reasons: (?P<reasons>.*?)(?: \| transport: (?P<transport>.*))?$"
)

entries: OrderedDict[str, dict] = OrderedDict()
for path in sorted(audit_dir.glob("*.md")):
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        match = line_re.match(raw_line.strip())
        if not match:
            continue
        if match.group("action").strip() != "block":
            continue
        ts = parse_ts(match.group("ts"))
        if ts <= window_start or ts > now_utc:
            continue
        handle = match.group("handle").strip()
        if handle not in entries:
            entries[handle] = {
                "timestamp": ts,
                "url": match.group("url").strip(),
                "reasons": match.group("reasons").strip(),
                "transport": (match.group("transport") or "").strip(),
            }

local_date = now_utc.astimezone(london).strftime("%Y-%m-%d")
window_label = (
    f"{window_start.astimezone(london).strftime('%Y-%m-%d %H:%M %Z')} "
    f"to {now_utc.astimezone(london).strftime('%Y-%m-%d %H:%M %Z')}"
)

if entries:
    subject = f"Daily X Block Digest - {local_date} ({len(entries)})"
    lines = [
        f"Blocked profiles since last digest: {len(entries)}",
        f"Window: {window_label}",
        "",
    ]
    for handle, item in entries.items():
        when = item["timestamp"].astimezone(london).strftime("%Y-%m-%d %H:%M %Z")
        lines.append(f"- {handle} - {item['reasons']}")
        lines.append(f"  When: {when}")
        lines.append(f"  URL: {item['url']}")
        if item["transport"]:
            lines.append(f"  Transport: {item['transport']}")
        lines.append("")
else:
    subject = f"Daily X Block Digest - {local_date} (0)"
    lines = [
        "Blocked profiles since last digest: 0",
        f"Window: {window_label}",
        "",
        "No new blocked profiles in this window.",
        "",
    ]

body_path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
meta_path.write_text(
    json.dumps(
        {
            "subject": subject,
            "count": len(entries),
            "windowStart": window_start.astimezone(timezone.utc).isoformat().replace("+00:00", "Z"),
            "windowEnd": now_utc.astimezone(timezone.utc).isoformat().replace("+00:00", "Z"),
        },
        indent=2,
    )
    + "\n",
    encoding="utf-8",
)
PY

SUBJECT="$(/usr/bin/python3 - "$META_FILE" <<'PY'
import json
import sys
print(json.load(open(sys.argv[1], encoding="utf-8"))["subject"])
PY
)"
COUNT="$(/usr/bin/python3 - "$META_FILE" <<'PY'
import json
import sys
print(json.load(open(sys.argv[1], encoding="utf-8"))["count"])
PY
)"

"$GOG_BIN" gmail send \
  --account "$ACCOUNT" \
  --to "$TO_EMAIL" \
  --subject "$SUBJECT" \
  --body-file "$BODY_FILE" \
  --json >/dev/null

/usr/bin/python3 - "$STATE_FILE" "$NOW_UTC" "$SUBJECT" "$COUNT" <<'PY'
import json
import sys
from pathlib import Path

state_path = Path(sys.argv[1])
state = {"lastSentAt": None, "lastSubject": None, "lastCount": 0}
if state_path.exists():
    try:
        state.update(json.loads(state_path.read_text()))
    except Exception:
        pass
state["lastSentAt"] = sys.argv[2]
state["lastSubject"] = sys.argv[3]
state["lastCount"] = int(sys.argv[4])
state_path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
PY

echo "sent block digest: subject=\"$SUBJECT\" count=$COUNT"
