# 4 · Fix it, and let it through the gate (12:00–12:30)

*About 30 minutes. Goal: a corrected change whose prediction passes every test, and an approval.*

## Core

### Correct the change (10 min)

On your `retire-all` branch, correct `candidate/r4-bgp.eos` so it retires only the stale advertisements, then push:
```
git commit -am "Keep the live service advertisement" && git push
```
The **forward/predict** check re-runs by itself. This is a regression test on every commit.

### Prove it (10 min)

When it's green, read the summary again. Confirm each of these:

- The required reachability still works (APP-EXISTING)
- The prohibited port is still blocked (MGMT-DENY)
- r1 still has the service route through r2 (ROUTE-SERVICE)
- Traffic takes the same path (PATH-SERVICE)
- No stale advertisements remain (STALE-CLEARED)

### Approve (10 min)

Merge the pull request. The repository only allows it once **forward/predict** has passed; try merging `retire-one`
to see the refusal. Then close `retire-one`.

## Finished early?

- Run your own `HTTPS-DENY` test (exercise 2) against the fixed change:
  `workshop predict --requirements requirements/mine.yml`.
- `workshop agent`: on a scratch branch, put the broken change back in the candidate and let the advisers iterate to
  a passing change. It stops before approval, so compare its answer with yours.
