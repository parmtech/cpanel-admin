from pathlib import Path
import re
import sys

manifest = Path("android/app/src/main/AndroidManifest.xml")
if not manifest.exists():
    print("Generated Android manifest not found.", file=sys.stderr)
    raise SystemExit(1)

text = manifest.read_text(encoding="utf-8")
permission = '    <uses-permission android:name="android.permission.INTERNET" />'
if "android.permission.INTERNET" not in text:
    root = re.search(r"<manifest\b[^>]*>", text)
    if root is None:
        print("Android manifest has no manifest root element.", file=sys.stderr)
        raise SystemExit(1)
    text = text[: root.end()] + "\n" + permission + text[root.end() :]
    manifest.write_text(text, encoding="utf-8")

print("Android INTERNET permission is present.")
