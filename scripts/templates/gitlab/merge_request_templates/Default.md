## Pre-merge checklist

### Prerequisites
- [ ] **I pulled the latest `main|master` branch**
- [ ] I've used `ddev branch` to get the expected branch name
- [ ] I've pulled a fresh DB (`ddev remote-db`) or verified that there are 
  no outstanding configuration changes on the production site
- [ ] My commits start with `T-[teamworkId] description`
- [ ] I've renamed the MR title to match `T-[teamworkId] description` and an
  automatic link has been generated towards teamwork
- [ ] I have updated the `CHANGELOG.md` file with the changes I've made
- [ ] I have commented/updated the Teamwork card
- [ ] MR link added to the Teamwork card description under Deployment Notes

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