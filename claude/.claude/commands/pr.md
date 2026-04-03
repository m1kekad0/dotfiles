---
allowed-tools: Bash(git push:*), Bash(git log:*), Bash(git branch:*), Bash(git status:*), Bash(gh pr create:*), Bash(gh pr view:*)
description: Push current branch and create a pull request
---

## Context

- Current branch: !`git branch --show-current`
- Remote tracking: !`git status -sb | head -1`
- Commits ahead of main: !`git log main..HEAD --oneline 2>/dev/null || git log origin/main..HEAD --oneline`
- Current git diff summary: !`git diff --stat HEAD~1 HEAD 2>/dev/null | tail -5`

## Your task

1. Push the current branch to origin if not already pushed
2. Create a pull request to main with a clear title and body

Follow these rules:
- PR title: concise (under 70 chars), uses conventional commit prefix if appropriate
- PR body: use the template below
- Do not send any other text or messages besides the tool calls

## PR body template

```
## Summary

<1-3 bullet points describing what changed and why>

## Test plan

- [ ] <test step>
- [ ] <test step>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```
