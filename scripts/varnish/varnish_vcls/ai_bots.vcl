#ddev-generated
# ai_bots.vcl
sub detect_ai_bots {
    # Generic AI bot signatures
    if (req.http.User-Agent ~ "(?i)(Applebot|OAI-SearchBot|ChatGPT-User|GPTBot|Meta-ExternalFetcher|Bytespider|CCBot|ClaudeBot|FacebookBot|Meta-ExternalAgent|Amazonbot|PerplexityBot|YouBot|Arquivo-web-crawler|heritrix|ia-archiver|ia_archiver-web.archive.org|Nicecrawler|anthropic-ai|Claude-Web|cohere-ai)") {
        # We identify them as bad because they are DDoSing our servers, especially OpenAI.
        # @todo: consider allowing agents that are actually nice and only block OpenAI.
        # Note: `archive.org_bot` is not in the list. We like archive.org.
        set req.http.is-bad-bot = "true";
    }
}

