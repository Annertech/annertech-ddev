# Varnish Bot Blocker

## Install

```bash
ddev install-varnish
```

## Bruno Testing

_[Bruno](https://www.usebruno.com/) is an open-source alternative to Postman_

There is a sample Bruno collection in this folder. Copy it to your project, 
edit the environment URLs and run the requests.

You can run:
```bash
ddev install-bruno
```
To get these files installed and configured in your project automatically.

## Behat Testing

You need to add the following in your `FeatureContext.php`

```php
  /**
   * @Given I set the user agent to :userAgent
   */
  public function iSetTheUserAgentTo($userAgent)
  {
    $session = $this->getSession();
    $driver = $session->getDriver();

    // GoutteDriver or BrowserKitDriver
    if (method_exists($driver, 'getClient')) {
      $client = $driver->getClient();
      $client->setServerParameter('HTTP_USER_AGENT', $userAgent);
    } else {
      throw new \Exception("Driver does not support setting User-Agent header.");
    }
  }
```

## But Why?

Platform.sh are not doing anything against botnet attacks to their customers,
instead they themselves suggest blocking IPs manually from their UI and/or 
using 
Varnish to block 
user agents:

> You could if needed, add Varnish to your stack. With that you can then control the traffic to your application via VCL, see an example of using Varnish for rate limit: https://support.platform.sh/hc/en-us/community/posts/16439617864722-Rate-limit-connections-to-your-application-using-Varnish
> But it can also be used to inspect and block user agents and or protect 
> paths etc.
> 
> _platform.sh support team in 2025_


## Authors

- VCL File: Valentin Zsigmond (drupal.org/u/vzsigmond)
- Installer: Bill Seremetis (drupal.org/u/bserem)
- Annertech (annertech.com)

```
#ddev-generated
```
