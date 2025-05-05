`#ddev-generated`

# Varnish Bot Blocker

## Install

```bash
ddev install-varnish
```

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

and then copy/use the `varnish.feature` file in this folder.

## Authors

- VCL File: Valentin Zsigmond (drupal.org/u/vzsigmond)
- Annertech (annertech.com)