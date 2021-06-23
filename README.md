# Drogue Cloud Helm charts

This repository contains the Drogue IoT Cloud Helm charts.

## Releases

Changes are automatically released when the main branch is updated.

## Changes

### Linting

PRs and the main branch are linted. It is recommended to create a PR if you aren't sure that your changes are good.

### Local linting

You can do the linting locally. For this you need:

* Install `yamale`: `pip install yamale`
* Install `yamllint`: `dnf install yamllint`
* Install `ct`: https://github.com/helm/chart-testing/releases

Then do:

    ct lint --config .github/ct.yaml --all
