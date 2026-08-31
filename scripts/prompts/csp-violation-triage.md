Run this against the site database to pull the latest 100 CSP violation log entries (no drush required):

```sql
SELECT message, variables
FROM watchdog
WHERE type = 'seckit'
ORDER BY wid DESC
LIMIT 100;
```

(e.g. via `ddev drush sql-query "..."`, `ddev mysql -e "..."`, or any DB client pointed at the site's database — `type = 'seckit'` is the dblog category the Security Kit module logs CSP violation reports under.)

For each entry, parse the `Blocked URI` and `Directive` fields from the message (and `variables`, if the message uses placeholders). Determine whether the blocked URI's origin is already covered by the corresponding directive in config/sync/seckit.settings.yml (under seckit_xss.csp). Same-origin `www.example.com` violations are almost always already covered by `'self'` and don't need action - flag them separately as likely stale/pre-deploy noise rather than adding new entries. For genuinely new third-party origins, add the exact scheme+host (no paths/query strings) to the relevant directive(s):

- script-src-elem / script-src-attr → script-src
- style-src-elem / style-src-attr → style-src
- otherwise map directly (img-src, connect-src, font-src, frame-src, media-src, object-src, connect-src, etc.)

Note: seckit only exposes base directives, not the granular -elem/-attr CSP3 suffixes - merge violations for either suffix into the base directive.

Preserve the existing 'self' keyword quoting (must stay as 'self', not bare self) and 'unsafe-inline' where already present. Keep entries space-separated on one line per directive, don't introduce YAML block scalars (>-), and don't touch any other keys in the file.

After editing, summarize: what was added per directive, what was skipped as already-covered/stale, and flag any blocked URI whose owning team/tag should be asked to fix at the source (e.g. rotating locale subdomains like www.google.<cctld> that will keep recurring) rather than chased in CSP.
