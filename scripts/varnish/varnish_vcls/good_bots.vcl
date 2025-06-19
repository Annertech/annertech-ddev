#ddev-generated
# good_bots.vcl
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
