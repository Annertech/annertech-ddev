## 1. Scan and collect URLs

- Fetch homepage from __REFERENCE_DOMAIN__
- Extract random set of pages linked on homepage main area
- Extract pages linked in in homepage main menu
- Extract pages linked in in homepage footer
- Fetch sitemap from __REFERENCE_DOMAIN__/sitemap.xml
- Extract 10-12 diverse page types from sitemap (services, planning, housing, events, etc.)
- Include all language versions
- Add search page: __REFERENCE_DOMAIN__/search?s=test

## 2. Configure backstop.json

- Use the default `backstop.json` file in this folder as a starting point
- Test environment domain: __TEST_DOMAIN__
- Reference domain: __REFERENCE_DOMAIN__
- Viewports: phone (320×480) and HD (1920×1080). Remove other viewports.
- Remove any scenarios pointing to patternlab!

## 3. Per-scenario configuration (add to EACH scenario, not globally)

- removeSelectors: "#CybotCookiebotDialog", ".anrt-gdpr-floating-cookie"
- requireSameDimensions: true
- Do not use any delay on scenarios

## 4. Deliverables

- Updated backstop.json with all scenarios
- Provide changelog-ready list grouped by category using bold formatting (no headings, no backticks around paths)
- Clean-up any temporary files afterwards

**Note:** Use curl with browser user agent for sitemap access to avoid 403 errors.

<!-- #ddev-generated -->
