Workarea Klarna
================================================================================

Workarea Commerce plugin that adds [Klarna](https://www.klarna.com/) payment options for customers including pay later, pay installments, and more.

Overview
--------------------------------------------------------------------------------
* Adds Klarna tender type.
* Dynamically provides payment options in checkout based on customer's eligible payment options determined by geographic location.
* Supports authorizations, captures, cancellations, and refunds.

Getting Started
--------------------------------------------------------------------------------

This gem contains a Rails engine that must be mounted onto a host Rails application.

Then add the gem to your application's Gemfile specifying the source:

    # ...
    gem 'workarea-klarna'
    # ...

Update your application's bundle.

    cd path/to/application
    bundle

Configure Klarna credentials. See below.

Support & Configuration
--------------------------------------------------------------------------------

Klarna support is based on a customer's location. Klarna currently accepts payment from customers of North America, Europe, and will soon support Oceania(Australia).

You must provide credentials for each region you would like to support. The plugin allows multiple options to provide credentials to communicate with Klarna -- environment variables, rails credentials, or admin configurable fields.

### North America

* Test Environment: https://playground.us.portal.klarna.com/developer-sign-up
* Plugin environment variables:

   `WORKAREA_KLARNA_NA_USERNAME`    
   `WORKAREA_KLARNA_NA_PASSWORD`
* Rails credentials:
  ```
  klarna:
    na:
      username:
      password:
  ```
* Or, you can log into the admin and go to Settings > Configuration, and add the North America username and password.

### Europe

* Test Environment: https://playground.eu.portal.klarna.com/developer-sign-up
* Plugin environment variables:

   `WORKAREA_KLARNA_EUR_USERNAME`    
   `WORKAREA_KLARNA_EUR_PASSWORD`
* Rails credentials:
  ```
  klarna:
    eur:
      username:
      password:
  ```
* Or, you can log into the admin and go to Settings > Configuration, and add the Europe username and password.

You can get more specific information from the [Klarna Developer](https://developers.klarna.com/) portal.

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea platform documentation.

License
--------------------------------------------------------------------------------

Workarea Klarna is released under the [Business Software License](LICENSE)
