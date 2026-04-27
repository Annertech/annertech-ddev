I have an Apache access log at __ACCESS_LOG_FILE__

**IMPORTANT - IPs in this file are masked for GDPR compliance.**
Every IPv4 address has been replaced with a prefix-preserving pseudonym before
this prompt was generated. This means:
- IPs sharing a real /8, /16 or /24 prefix **also share the same masked prefix**,
  so subnet grouping, CIDR recommendations, and botnet-from-subnet detection
  remain fully reliable.
- The masked IPs are **not real** and do **not** correspond to any real owner.
  Do NOT attempt WHOIS, ASN lookup, geolocation, or reputation lookup on them -
  results would be meaningless or misleading. Skip any step that requires this.
- The operator has a local sidecar mapping file to reverse any masked IP back
  to the original for blocklist application. Your job is to identify the
  **masked** IPs / CIDR ranges that should be blocked; the operator handles the
  translation back to real IPs.
- User-Agent strings, URLs, referrers, timestamps, and status codes are NOT
  masked and are fully reliable.

Run the following triage in order, stopping to flag anomalies before proceeding:
**STEP 1 - Baseline (run all at once)**
- Date range of the log
- Total request count
- HTTP status code distribution (flag if 4xx+5xx > 10% of total)
- Requests per hour (flag any hour > 3x the median)

**STEP 2 - Top offenders**
- Top 30 source IPs with request counts (masked IPs - report as-is)
- Group IPs by /24 subnet and flag any subnet with > 500 requests
- Top 20 user agents (flag empty UAs, known scanners, rotating browser strings
  doing uniform behaviour)
- Top 20 requested URLs (flag if one URL accounts for > 20% of traffic)

**STEP 3 - Attack signatures (only on IPs/subnets flagged above)**
- What URLs are they hitting? Uniform = likely DDoS/flood. Varied = crawler/scraper.
- What referrers are they sending? Flag non-existent domains.
- What is their request rate per hour? Coordinated spikes = botnet.
- Do NOT run whois - the IPs are masked. Instead, infer actor type from
  behaviour (UA patterns, URL patterns, request cadence, subnet spread).

**STEP 4 - Verdict**
Produce a short report:
- Is an attack ongoing right now? (check last 30 mins of log)
- Was there a past attack? When did it peak, when did it stop?
- What is the blast radius? (did it cause 500/502s for legitimate users?)
- Likely actor type inferred from behavioural signals (no ASN/country - masked)
- Immediate action: list of **masked** CIDR ranges to block. The operator will
  translate these to real ranges via the local mapping file.

Keep responses concise. Lead with the verdict, support with numbers.

**Output**
- Save the full report to `Forensic_report.md` in your current working directory
  (which is `./logs`). Overwrite it if it already exists.
- After saving, print to stdout this exact block so the operator can reveal the
  real IPs locally (the mapping file `__MAPPING_FILE__` never leaves the machine):

```
# Run from the project root to produce an unmasked copy of the report.
# Emits both /32 (exact IP) and /24 (subnet prefix) substitutions, so CIDR
# ranges like "53.84.208.0/24" in the report are unmasked even though the
# network address itself never appeared in any log line.
cd logs && awk -F'\t' '
NR == 1 { next }
{
  p = $1; gsub(/\./, "\\.", p)
  out[++n] = "s|" p "|" $2 "|g"
  split($1, mo, "."); split($2, ro, ".")
  k = mo[1] "." mo[2] "." mo[3]
  if (!(k in seen)) {
    seen[k] = 1
    pp = k; gsub(/\./, "\\.", pp)
    pre[++m] = "s|" pp "\\.|" ro[1] "." ro[2] "." ro[3] ".|g"
  }
}
END {
  for (i=1; i<=n; i++) print out[i]
  for (i=1; i<=m; i++) print pre[i]
}' __MAPPING_FILE__ | sed -f - Forensic_report.md > Forensic_report_unmasked.md && cd -
```


<!-- #ddev-generated -->
