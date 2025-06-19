#ddev-generated
# config.vcl

# import vsthrottle; # Throttling is currently disabled.

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

sub vcl_recv {
    # Set backend for the request
    set req.backend_hint = main.backend();

    # Use the real IP for allowlist check
    if (client.ip ~ allowlist) {
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
    call detect_ai_bots;
    call detect_bad_bots;
    call detect_exploit_paths;

    # Pass requests from verified good bots
    if (req.method == "GET" && req.http.Accept && req.http.Accept ~ "text/html" && req.http.is-good-bot == "true") {
        # Apply a very lenient throttle even to good bots to prevent abuse
        # if (vsthrottle.is_denied("goodbot_" + req.http.User-Agent, 120, 60s, 300s)) {
        #    return (synth(429, "Too Many Requests - Bot Rate Limited"));
        # }
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
}
