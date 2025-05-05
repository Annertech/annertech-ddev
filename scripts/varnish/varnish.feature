#ddev-generated

@varnish
Feature: Bot detection via User-Agent header
  Scenario: Visit a website as Scrapinghub bot
    Given I set the user agent to "Scrapy/2.5.1 (+https://scrapy.org)"
    When I go to "CHANGE_WITH_URL"
    Then the response status code should be 403
    Then the response should contain "403 Forbidden - Bad Bot"
    Then the response should contain "Varnish cache server"

  Scenario Outline: Visit site as bot: <bot>
    Given I set the user agent to "<user_agent>"
    When I go to "CHANGE_WITH_URL"
    Then the response status code should be 403
    Then the response should contain "403 Forbidden - Bad Bot"
    Then the response should contain "Varnish cache server"

    # Commented lines need fixing with the correct user_agent as is checked by varnish.
    # Right now, the user_agents in commented lines will be allowed!

    Examples:
      | bot            | user_agent                          |
      | zgrab          | zgrab/0.1                           |
      | proximic       | proximic                            |
      | spamdexer      | spamdexer                           |
      | spambot        | spambot                             |
      | scrapinghub    | Scrapy/2.5.1 (+https://scrapy.org)  |
      | htmlparser     | HTMLParser/1.0                      |
      | libwww         | libwww-perl/6.05                    |
      | lipperhey      | Lipperhey-Kaus-AI                   |
      #| dotnetclr      | Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; .NET CLR 2.0.50727) |
      | indy library   | Mozilla/4.0 (compatible; Indy Library) |
      | emailcollector | EmailCollector                      |
      | fetch          | fetch libfetch/1.0                  |
      | mfc            | MFC_Tool/1.0                        |
      | HTMLEditor     | HTMLEditor/2.0                      |
      | ahrefsbot      | AhrefsBot/6.1 (+http://ahrefs.com/robot/) |
      | semrushbot     | SemrushBot                          |
      | mj12bot        | MJ12bot/v1.4.8 (http://mj12bot.com) |
      | dotbot         | DotBot/1.1                          |
      | rogerbot       | rogerbot/1.0                        |
      | linkdex         | linkdexbot/1.0                     |
      | screaming      | Screaming Frog SEO Spider/15.0     |
      | babbar         | Babbar.tech/1.1                     |
      | serpstat       | SerpstatBot/2.0                     |
      #| seokicks       | SEO-Kicks                           |
      | seoscanners    | seoscanners.net                     |
      | seobility      | SeobilityBot/1.0                    |
      | crawler4j      | crawler4j                           |
      | megaindex      | MegaIndex.ru/2.0                    |
      | wbsearchbot    | wbsearchbot                         |
      | ltx71          | ltx71                               |
      | httrack        | httrack/3.0                         |
      | teleport       | Teleport Pro/1.29                   |
      | webcopier      | WebCopier v5.3                      |
      | webripper      | WebRipper/1.0                       |
      | webstripper    | WebStripper/2.0                     |
      | webzinger      | WebZinger/1.0                       |
      | webcollector   | WebCollector/2.0                    |
      #| site sucker    | SiteSucker/3.2.6                    |
      | offline explorer | Offline Explorer/7.0              |
      | backstreet browser | BackStreet Browser 3.2         |
      #| black widow    | BlackWidow/6.3                      |
      | grab-a-site    | Grab-a-site/1.0                     |
      | scrapy         | Scrapy/2.5.1 (+https://scrapy.org)  |
      | phantomjs      | PhantomJS/2.1.1                     |
      | headless       | HeadlessChrome/98.0.4758.80         |
      | selenium       | selenium-webdriver/4.0              |
      | wget           | Wget/1.21                           |
      | curl           | curl/7.64.1                         |
      | python-requests| python-requests/2.25.1              |
      | python-urllib  | Python-urllib/3.7                   |
      | java           | Java/1.8.0_131                      |
      | go-http        | Go-http-client/1.1                  |
      | httpclient     | Apache-HttpClient/4.5.2             |
      | libcurl        | libcurl/7.58.0                      |
      | node-fetch     | node-fetch/1.0                      |
      | axios          | axios/0.21.1                        |
      | aiohttp        | aiohttp/3.7.4                       |
      | okhttp         | okhttp/3.14.9                       |
      | masscan        | masscan/1.0                         |
      | nmap           | nmap/7.80                           |
      | nikto          | Nikto/2.1.6                         |
      | acunetix       | Acunetix/13.0                       |
      #| burpsuite      | Mozilla/5.0 (compatible; Burp Suite Professional) |
      | sqlmap         | sqlmap/1.5.2                        |
      | grabber        | grabber/1.0                         |
      | nessus         | Nessus/8.0                          |
      | netsparker     | Netsparker/5.8                      |
      | w3af           | w3af.org                            |
      | metasploit     | Metasploit                          |
      | fimap          | fimap/1.0                           |
      | rat            | RATScanner                          |
      | xsscrapy       | XSScrapy/0.4                        |
      #| zaproxy        | ZAP/2.10.0                          |
      | arachni        | Arachni/v1.5.1                      |
      | binlar         | binlar/1.0                          |
      | masspost       | MassPost/1.0                        |
      | autoit         | AutoIt/3.3.14.5                     |
      | scanalert      | ScanAlert/1.0                       |
      | emailSiphon    | EmailSiphon/1.0                     |
      | extractorpro   | ExtractorPro/1.0                    |
      | autohttp       | autohttp/1.0                        |
      | python-http    | Python-httplib/2.7                  |
      | linkchecker    | LinkChecker/9.3                     |
      | unknown        | unknown                             |

  Scenario Outline: Visit forbidden paths
    When I go to "CHANGE_WITH_URL<path>"
    Then the response status code should be 404
    Then the response should contain "404 Forbidden - Not Found"
    Then the response should contain "Varnish cache server"

    Examples:
      | path    |
      | cgi-bin |
      | xmlrpc.php  |
      | wlwmanifest.xml |
      | HNAP1           |
      | .env            |
      | .git            |
      | .svn            |
      | .htaccess       |
      | .htpasswd       |
      | .config         |
      | config.php      |
      | settings.php    |
      | file_upload     |
      | file_manager    |
      | elfinder        |
      | upload.php      |
      | uploadify       |
      | filemanager     |
      | phpmyadmin      |
      | myadmin         |
      | mysql           |
      | pma             |
      | adminer         |
      | mysqladmin      |
      | wp-admin        |
      | wp-login        |
      | wp-content      |
      | wp-includes     |

