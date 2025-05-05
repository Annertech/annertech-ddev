# Varnish Bot Blocker

## Install

```bash
ddev install-varnish
```

## Bruno Testing

_Bruno is an open-source alternative to Postman_

There is a sample Bruno collection in this folder. Copy it to your project, 
edit the environment URLs and run the requests.

The sample collection files have the `#ddev-generated` comment in them. You 
might have to remove this manually.

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

## Authors

- VCL File: Valentin Zsigmond (drupal.org/u/vzsigmond)
- Annertech (annertech.com)

```
#ddev-generated
```
