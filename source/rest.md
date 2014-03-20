---
title: REST Intro
layout: rest_layout
---

## Base URI

All paths in this document should be prepended with `https://app.firmafon.dk/api/v2`.

## Content Type

At the moment only `application/json` is available, except for a few resources, in which case it is explicitly stated. This may change in the future, and all requests should include the `Accept` HTTP header:

    Accept: application/json

## Phone numbers

All phone numbers include the country calling code, without `00` or `+` prefix. E.g. a Danish number would be: `4571999999`.
