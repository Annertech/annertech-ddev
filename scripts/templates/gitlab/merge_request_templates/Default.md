## Pre-merge checklist

### Prerequisites
- [ ] **I pulled the latest `main|master` branch**
- [ ] Verified correct branch via `ddev branch` 
- [ ] Synced fresh DB (`ddev remote-db`) or confirmed no prod config changes
- [ ] Commits follow `T-[teamworkId] description` description format
- [ ] MR title updated to match `T-[teamworkId]`, with auto-link to Teamwork
- [ ] `CHANGELOG.md` updated
- [ ] Teamwork card commented/updated and MR link added

### Documentation
- [ ] **Code documented, READMEs updated as required!**

### Automated tests
- [ ] **I have added and/or updated tests as required!**
- [ ] I've run `ddev backstop test` locally and inspected the visual output
- [ ] I've run `ddev behat` locally if applicable
- [ ] I've run `ddev cypress run` locally if applicable

### QA
- [ ] Clear Testing Notes with steps and URLs provided in card/issue/MR
- [ ] Screenshots provided in card/issue/MR
- [ ] Code Review performed & MR Approved
- [ ] Internal QA on `dev` (or own environment) performed
- [ ] Complies with [Best Practises](https://knowledge.annertech.com/coding/) & [Coding Standards](https://www.drupal.org/docs/develop/standards/coding-standards)
- [ ] No debug code (console.log, dpm)
- [ ] No redundant code (e.g. commented out code, no longer in use)
- [ ] Interactive elements correctly implement ['aria' patterns](https://www.w3.org/TR/wai-aria-practices-1.2/#aria_ex)

### Accessibility

- [ ] Pages under review pass AXE/Wave accessibility testing  
  _See Knowledge [Accessibility section](https://knowledge.annertech.com/accessibility) for guidance on testing and implementation_


---
#ddev-generated
#annertech-ddev
---
