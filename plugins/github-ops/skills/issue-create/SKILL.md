---
name: issue-create
description: Draft and open one or more well-structured GitHub issues (questions, tasks, decisions, bugs) from the conversation or a list, after the user confirms them. Use when asked to open, file, raise or log an issue, or to turn open questions or a to-do list into issues.
argument-hint: "[topic, list or repo]"
---

Open GitHub issues for: $ARGUMENTS

Issues are visible to everyone with access to the repository, so nothing is
posted until the user has seen and approved each draft.

## Phase 1: Context

1. Identify the repository: the one named in the request, otherwise the
   current repository (`gh repo view --json nameWithOwner -q .nameWithOwner`).
2. Collect the items to file from the request or the conversation: one issue
   per question, decision, task or bug. Merge items that would be answered
   together; split items that need different people.
3. Check for duplicates: `gh issue list --repo <repo> --state all --search "<keywords>"`.
   Where an open issue covers an item, propose a comment on it
   (`issue-reply`) instead of a new issue.
4. List existing labels and milestones (`gh label list --repo <repo>`,
   `gh api repos/<repo>/milestones`) and use only those; do not create labels
   unless asked.

## Phase 2: Drafting

For each issue:

- **Title**: specific and self-contained, under about 70 characters, a
  question for questions ("Should month of onset be a stratum or a
  covariate?") or an imperative for tasks ("Add Elikya PARTNERS exclusion
  using trial IDs").
- **Body**, in plain prose and short lists:
  - *Context*: what prompted it, with links to files (`path/to/file.R#L10`),
    commits or other issues, so it stands alone without the conversation.
  - *Question* or *Task*: exactly what is needed, and from whom.
  - *Options* considered, with a recommendation where there is one.
  - *Done when*: what answer or change closes the issue.
- **Assignee or @mention**: only GitHub handles the user gives or that appear
  in the repository's history; never guess a handle from a name.
- **Labels**: from the existing set (e.g. `question`, `decision`,
  `enhancement`, `bug`, `data`).

Follow the user's writing style. Never include patient-level data,
identifiers, credentials or unpublished results the user has not cleared for
the repository's audience; describe such findings qualitatively or point to
where authorised readers can find them.

## Phase 3: Review

Show all drafts together (title, labels, assignees, body) and ask the user to
approve, edit or drop each. Post nothing before approval; approval of one set
of drafts does not cover later ones.

## Phase 4: Posting

For each approved draft, write the body to a temporary file and run:

```bash
gh issue create --repo <repo> --title "<title>" --body-file <file> [--label <label>] [--assignee <handle>]
```

Then report the created issue numbers and URLs in a short table.
