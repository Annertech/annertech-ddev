# Contribute to the Annertech-DDEV add-on

## How to work on the add-on locally

1. Get this repo locally. If you are not a member of the annertech group you
have to through the GitHub process of forking.
```
git clone git@github.com:Annertech/annertech-ddev.git
```
2. `git branch -b YOUR_FEATURE`
3. Do your changes

## How to test your changes before making a merge request

You need to install your version of the add-on to a project to test it out.
This is done using `ddev add-on get` but instead of pointing to a github
repo you point it to a local path:
```
ddev add-on get /path/to/annertech-ddev/
```
> **NOTE**  
> Do not commit your version of the add-on to the project!