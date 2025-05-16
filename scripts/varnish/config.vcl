#ddev-generated

import vsthrottle;

# IP-based ACL for whitelisted addresses
acl whitelist {
}

# Define bot detection subroutines
sub bot_detection_init {
    # Make sure User-Agent is set
    if (!req.http.User-Agent) {
        set req.http.User-Agent = "";
    }

    # Initialize bot detection flags
    set req.http.is-bad-bot = "false";
    set req.http.is-good-bot = "false";
    set req.http.is-exploit-path = "false";

    # Set rate limit key
    set req.http.rate_limit_key = client.ip + req.http.User-Agent;
}

sub detect_good_bots {
    # Search engines and crawlers
    if (req.http.User-Agent ~ "(?i)(googlebot|bingbot|yandexbot|applebot|duckduckbot|baiduspider|yahoo|sogou)") {
        set req.http.is-good-bot = "true";
    }

    # Social media bots
    if (req.http.User-Agent ~ "(?i)(facebookexternalhit|twitterbot|linkedinbot|pinterest|slackbot|discordbot|whatsapp)") {
        set req.http.is-good-bot = "true";
    }

    # Feed readers and validators
    if (req.http.User-Agent ~ "(?i)(feedly|feedburner|validator|w3c|feedvalidator)") {
        set req.http.is-good-bot = "true";
    }

    # Monitoring services
    if (req.http.User-Agent ~ "(?i)(pingdom|uptimerobot|newrelic|datadog|statuspage|statuscake|pingback)") {
        set req.http.is-good-bot = "true";
    }

    # CDNs and security services
    if (req.http.User-Agent ~ "(?i)(cloudflare|akamai|fastly|cloudfront|sucuri)") {
        set req.http.is-good-bot = "true";
    }
}

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

# Detect exploit paths typically used to probe for vulnerabilities
sub detect_exploit_paths {
    # WordPress paths (not relevant for Drupal but commonly probed)
    if (req.url ~ "(?i)(/wp-admin|/wp-login\.php|/wp-content/|/wp-includes/)") {
        set req.http.is-exploit-path = "true";
    }

    # Joomla paths
    if (req.url ~ "(?i)(/index\.php\?option=com_|/components/com_)") {
        set req.http.is-exploit-path = "true";
    }

    # Database admin tools
    if (req.url ~ "(?i)(/phpmyadmin|/myadmin|/mysql|/pma|/adminer|/mysqladmin)") {
        set req.http.is-exploit-path = "true";
    }

    # Information disclosure and config files
    if (req.url ~ "(?i)(\.env|\.git|\.svn|\.htaccess|\.htpasswd|\.config|config\.php|settings\.php)") {
        # Exclude Drupal's legitimate settings.php access if needed
        if (req.url !~ "(?i)^/core/rebuild\.php") {
            set req.http.is-exploit-path = "true";
        }
    }

    # Common exploits paths
    if (req.url ~ "(?i)(/cgi-bin/|/xmlrpc\.php|/wlwmanifest\.xml|/HNAP1/)") {
        set req.http.is-exploit-path = "true";
    }

    # File uploads and includes
    if (req.url ~ "(?i)(file_upload|file_manager|elfinder|upload\.php|uploadify|filemanager)") {
        set req.http.is-exploit-path = "true";
    }
}

sub vcl_recv {
    # Set backend for the request
    set req.backend_hint = main.backend();

    # Bypass for whitelisted IPs
    if (client.ip ~ whitelist) {
        return (pass);
    }

    # Bypass admin URLs and Drupal logged-in users
    if (req.url ~ "^/admin/") {
        return (pass);
    }

    # Pass other authenticated requests
    if (req.http.Cookie && req.http.Cookie ~ "S?SESS[a-z0-9]+") {
        return (pass);
    }

    # Initialize bot detection
    call bot_detection_init;

    # Run bot detection
    call detect_good_bots;
    call detect_bad_bots;
    call detect_exploit_paths;

    # Pass requests from verified good bots
    if (req.http.is-good-bot == "true") {
        # Apply a very lenient throttle even to good bots to prevent abuse
        if (vsthrottle.is_denied("goodbot_" + req.http.User-Agent, 120, 60s, 300s)) {
            return (synth(429, "Too Many Requests - Bot Rate Limited"));
        }
        return (pass);
    }

    # Block bad bots
    if (req.http.is-bad-bot == "true") {
        return (synth(403, "Forbidden - Bad Bot"));
    }

    # Block exploit path probes
    if (req.http.is-exploit-path == "true") {
        return (synth(404, "Not Found"));
    }

    # Create more specific rate limit keys
    # Format: [type]_[IP]_[optional UA hash]
    set req.http.ua_hash = regsub(req.http.User-Agent, "^(.{16}).*", "\1");
    set req.http.global_key = client.ip + "_" + req.http.ua_hash;

    # --- Begin advanced throttling system ---

    # Global request throttling across all URLs (catch DoS or aggressive crawling)
    if (vsthrottle.is_denied("global_" + req.http.global_key, 300, 60s, 600s)) {
        return (synth(429, "Too Many Requests - Global Limit"));
    }

    # Throttle high-risk and sensitive operations

    # 1. User operations - registration, password reset, login
    if (req.url ~ "(?i)(/user/register|/user/password|/user/login)" && req.method == "POST") {
        if (vsthrottle.is_denied("user_ops_" + req.http.global_key, 5, 60s, 600s)) {
            return (synth(429, "Too Many Requests - Account Operations"));
        }
    }

    # 2. Search functionality (often abused)
    if (req.url ~ "(?i)(/search|\?q=search/)") {
        if (vsthrottle.is_denied("search_" + req.http.global_key, 60, 60s, 300s)) {
            return (synth(429, "Too Many Requests - Search"));
        }
    }

    # 3. File downloads - protect against aggressive downloaders
    if (req.url ~ "(?i)(\.pdf|\.docx?|\.xlsx?|\.pptx?|\.zip|\.rar|\.gz|\.tar|\.mp4|\.mov|\.avi)") {
        if (vsthrottle.is_denied("large_downloads_" + req.http.global_key, 60, 60s, 300s)) {
            return (synth(429, "Too Many Requests - Downloads"));
        }
    }

    # HTTP method-based throttling with more precise limits

    # GET requests for dynamic pages (exclude static assets for better performance)
    if (req.method == "GET" && req.http.Accept && req.http.Accept ~ "text/html") {
      # Distinguish between "browsing" pattern and aggressive pattern
      if (vsthrottle.is_denied("browse_" + req.http.global_key, 40, 20s, 120s)) {
          return (synth(429, "Too Many Requests - Browsing"));
      }
    }

    # POST/PUT/DELETE requests - more aggressive throttling
    if (req.method == "POST" || req.method == "PUT" || req.method == "DELETE") {
        if (vsthrottle.is_denied("write_" + req.http.global_key, 20, 20s, 180s)) {
            return (synth(429, "Too Many Requests - Write Operations"));
        }
    }
}
