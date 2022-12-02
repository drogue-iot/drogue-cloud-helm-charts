# Drogue Cloud Helm charts

This repository contains the Drogue IoT Cloud Helm charts.

You can add this repository be executing:

    helm repo add drogue-iot https://drogue-iot.github.io/drogue-cloud-helm-charts/

## Releases

Changes are automatically released when one of the release branches is updated. The release process
is described [here](https://github.com/drogue-iot/drogue-cloud/blob/main/RELEASE.md).

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
