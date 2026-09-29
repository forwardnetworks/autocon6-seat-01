# AutoCon6 — Know Before You Deploy

Your own lab: four routers, a client and a service, and a Forward network that models them.

**The loop:** Baseline → Change → Predict → Approve → Deploy → Verify.

| Step | Where | Command / action |
|---|---|---|
| 0. Check your setup | Codespace terminal | `workshop doctor` |
| 1. Start the lab | Codespace terminal | `workshop up` |
| 2. Baseline | Codespace terminal | `workshop baseline` |
| 3. Change | Editor → `candidate/r4-bgp.eos` | edit, commit on a branch, open a pull request |
| 4. Predict | GitHub → your pull request | read the **forward/predict** check |
| 5. Approve | GitHub | merge only a green check |
| 6. Deploy | Codespace terminal | `git pull`, then `workshop deploy --pr <number> --confirm <sha>` |
| 7. Verify | Codespace terminal | `workshop verify` |


The goal is written down in `intent.md`. The tests that prove it are in `requirements/`.

## Forward AI advisers (optional)

Forward AI can help at every step, but it only advises. Forward Predict, evaluated against the requirements,
decides whether a change is safe, and only you approve and deploy.

| Adviser | Command | What it does |
|---|---|---|
| Analyst | `workshop ask --list`, `workshop ask --prompt baseline-stale` | answers questions about a snapshot (baseline, predicted or post) |
| Author | `workshop propose [--write]` | Predict's config assist drafts `candidate/r4-bgp.eos` from `intent.md` |
| Reviewer and Troubleshooter | `workshop explain`, and the **forward/advice** check on your PR | summarises what a predicted change alters and affects and, if it failed, asks why |
| All of them, in a loop | `workshop agent` | draft → predict → take advice → draft again, stopping at a passing prediction |

Forward AI answers one chat question per person at a time, and a chat answer takes a minute or two. Read the
evidence while you wait.
