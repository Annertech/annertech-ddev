## Pre-merge checklist

### Prerequisites
- [ ] **Pulled the latest `main|master` branch**
- [ ] Synced fresh DB (`ddev remote-db`) or confirmed no outstanding configuration changes on production
- [ ] Naming conventions are respected
  - Using correct branch name via `ddev branch` (`202509_T-[id]__maintenance`)
  - Commits follow `T-[teamworkId] description` format
  - MR title updated to match `T-[teamworkId] description`, with auto-link to Teamwork
- [ ] `CHANGELOG.md` updated

### Documentation
- [ ] **Code documented, READMEs updated as required!**

### Automated tests
- [ ] **I have added and/or updated tests as required!**
- [ ] I've run automated tests (if applicable)
  - `ddev backstop test` and inspected the visual output
  - `ddev behat`
  - `ddev cypress run`
- [ ] There is no need for tests for this one / There are no tests yet

### QA
- [ ] Clear Testing Notes with steps, URLs and screenshots provided in card/issue/MR
- [ ] Code Review and/or Internal QA performed & MR Approved
- Complies with [Best Practises](https://knowledge.annertech.com/coding/) & [Coding Standards](https://www.drupal.org/docs/develop/standards/coding-standards)
- No debug code (console.log, dpm)
- No redundant code (e.g. commented out code, no longer in use)

### Accessibility
- [ ] Pages under review pass AXE/Wave accessibility testing  
  _See Knowledge [Accessibility section](https://knowledge.annertech.com/accessibility) for guidance on testing and implementation_
- [ ] Interactive elements correctly implement ['aria' patterns](https://www.w3.org/TR/wai-aria-practices-1.2/#aria_ex)


---
<sup><sub>
#ddev-generated
#annertech-ddev
</sub></sup>
