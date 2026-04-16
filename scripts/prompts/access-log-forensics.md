I have an Apache access log at __ACCESS_LOG_FILE__
Run the following triage in order, stopping to flag anomalies before proceeding:                                                                             
**STEP 1 — Baseline (run all at once)**                                                                                                                   
- Date range of the log                                                                                                                                   
- Total request count                                                                                                                                     
- HTTP status code distribution (flag if 4xx+5xx > 10% of total)                                                                                          
- Requests per hour (flag any hour > 3x the median)                                                                                                       
                                                                                                                                                          
**STEP 2 — Top offenders**                                                                                                                                
- Top 30 source IPs with request counts                                                                                                                   
- Group IPs by /24 subnet and flag any subnet with > 500 requests                                                                                         
- Top 20 user agents (flag empty UAs, known scanners, rotating browser strings                                                                            
  doing uniform behaviour)                                                                                                                                
- Top 20 requested URLs (flag if one URL accounts for > 20% of traffic)                                                                                   
                                                                                                                                                          
**STEP 3 — Attack signatures (only on IPs/subnets flagged above)**                                                                                        
- What URLs are they hitting? Uniform = likely DDoS/flood. Varied = crawler/scraper.                                                                      
- What referrers are they sending? Flag non-existent domains.                                                                                             
- What is their request rate per hour? Coordinated spikes = botnet.                                                                                       
- Run whois on the top flagged /24 to identify the owning organisation and country.                                                                       
                                                                                                                                                          
**STEP 4 — Verdict**                                                                                                                                      
Produce a short report:                                                                                                                                   
- Is an attack ongoing right now? (check last 30 mins of log)                                                                                             
- Was there a past attack? When did it peak, when did it stop?                                                                                            
- What is the blast radius? (did it cause 500/502s for legitimate users?)                                                                                 
- What is the source? (ASN, country, likely actor type)                                                                                                   
- Immediate action: list of CIDR ranges to block                                                                                                          
- Abuse contact if available from whois                                                                                                                   
                                                                                                                                                          
Keep responses concise. Lead with the verdict, support with numbers.  

<!-- #ddev-generated -->
