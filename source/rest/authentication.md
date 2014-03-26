---
title: Authentication
layout: rest_layout
---

The Firmafon v2 REST API can only be accessed via [OAuth 2.0](http://oauth.net/2/). This helps us track the usage of your application as well as providing the best possible security and safety to our users' data. OAuth 2.0 is a modern standard used by most providers, large and small.

## Sign up

To use the Firmafon v2 REST API you need to first [register your application](http://app.firmafon.dk/developers/applications/new). Given that each application is tied to it's own URL you might want to register one for development and one for production.

## Obtaining an Access Token

Every request to a user's data is authenticated by an access token. To get one the user must accept that they want to use your app. They do this on our domain. Start by redirecting your user to the following address:

    https://app.firmafon.dk/api/v2/authorize
      ?client_id=YOUR_APPLICATIONS_ID
      &response_type=code
      &redirect_uri=YOUR_APPLICATIONS_REDIRECT_URI

Users will be prompted to login (if they aren't already) and then asked if they want to grant you access to their account. If they agree, they are taken to your `redirect_uri` with a request token as a parameter.

    http://example.com/callback?code=REQUEST_TOKEN

Your app then makes a POST request like this:

    https://app.firmafon.dk/api/v2/token
      ?client_id=YOUR_APPLICATIONS_ID
      &client_secret=YOUR_APPLICATIONS_SECRET
      &grant_type=authorization_code
      &redirect_uri=YOUR_APPLICATIONS_REDIRECT_URI
      &code=REQUEST_TOKEN

The response will be JSON:

```json
{ "access_token": "ACCESS_TOKEN" }
```

And there you have it.

## Making requests

Once all that is done and you've successfully obtained an access token you need to send it along with every request.

This can be done in several ways:

As a header:

```sh
$ curl https://app.firmafon.dk/api/v2/calls -H "Authorization: Bearer ACCESS_TOKEN"
```

As a parameter:

```sh
$ curl https://app.firmafon.dk/api/v2/calls?access_token=ACCESS_TOKEN
```

## Notes on access tokens

* Please note that a user may at any time destroy their access tokens. You might want to take this into account when you're building your application.
