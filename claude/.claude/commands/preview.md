---
allowed-tools: mcp__playwright__browser_navigate, mcp__playwright__browser_take_screenshot, mcp__playwright__browser_snapshot, mcp__playwright__browser_console_messages, Bash(lsof:*), Bash(git:*)
description: Open a local dev server in the browser and visually verify the app is working correctly
---

## Context

- Recent changes: !`git diff --name-only HEAD~1 HEAD`

## Your task

1. Determine the local dev server URL from the context above (prefer :3000, fallback :3001)
2. If the server is not running, tell the user to start it first and stop
3. Navigate to the top page of the app using the browser
4. Take a screenshot of the top page
5. Based on the recent changes, navigate to the most relevant pages and take screenshots
6. Check the browser console for any errors or warnings
7. Report the verification results in a concise table format:
   - Page visited
   - Visual result (✅ / ⚠️ / ❌)
   - Console errors (if any)

Do not take more than 4 screenshots total. Focus on pages most affected by recent changes.
