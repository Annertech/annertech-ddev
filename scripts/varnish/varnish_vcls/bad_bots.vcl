#ddev-generated
# bad_bots.vcl
sub detect_bad_bots {
    # Generic bad bot signatures
    if (req.http.User-Agent ~ "(?i)(zgrab|proximic|spamdexer|spambot|scrapinghub|htmlparser|libwww|lipperhey|dotnetclr|indy library|emailcollector|fetch|mfc|HTMLEditor)") {
        set req.http.is-bad-bot = "true";
    }

    # Aggressive crawlers and scrapers
    if (req.http.User-Agent ~ "(?i)(ahrefsbot|semrushbot|mj12bot|dotbot|rogerbot|linkdex|screaming|babbar|serpstat|seokicks|seoscanners|seobility|crawler4j|megaindex|wbsearchbot|ltx71)") {
        set req.http.is-bad-bot = "true";
    }

    # Content theft and spam tools
    if (req.http.User-Agent ~ "(?i)(httrack|teleport|webcopier|webripper|webstripper|webzinger|webcollector|site sucker|offline explorer|backstreet browser|black widow|grab-a-site)") {
        set req.http.is-bad-bot = "true";
    }

    # Suspicious libraries and tools
    if (req.http.User-Agent ~ "(?i)(scrapy|phantomjs|headless|selenium|wget|curl|python-requests|python-urllib|java|go-http|httpclient|libcurl|node-fetch|axios|aiohttp|okhttp)") {
        set req.http.is-bad-bot = "true";
    }

    # Scanners and vulnerability testers
    if (req.http.User-Agent ~ "(?i)(masscan|nmap|nikto|acunetix|burpsuite|sqlmap|grabber|nessus|netsparker|w3af|metasploit|fimap|rat|xsscrapy|zaproxy|arachni)") {
        set req.http.is-bad-bot = "true";
    }

    # Miscellaneous bad actors and toolkits
    if (req.http.User-Agent ~ "(?i)(binlar|masspost|autoit|scanalert|emailSiphon|extractorpro|autohttp|python-http|linkchecker|netsparker|unknown)") {
        set req.http.is-bad-bot = "true";
    }
}
