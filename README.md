Workarea Klarna
================================================================================

Workarea Commerce plugin that adds [Klarna](https://www.klarna.com/) payment options for customers including pay later, pay installments, and more.

Overview
--------------------------------------------------------------------------------
* Adds Klarna tender type.
* Dynamically provides payment options in checkout based on customer's eligible payment options determined by geographic location.
* Supports authorizations, captures, cancellations, and refunds.
* Enables On-Site Messaging through admin configuration.

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

## On-Site Messaging

Klarna allows you to strategically place information about Klarna payments on your website through On-Site Messaging. The workarea-klarna plugin simplifies the installation process by including the required script tag and some common placements when an admin user configures on-site messaging in the admin.

### Enabling

Workarea provides two configuration fields in the admin under the "Klarna" section to allow the use of messaging. The first field is the on-site messaging client ID. To obtain an ID, [go through the activation process](https://developers.klarna.com/documentation/on-site-messaging/integration/platform-activation/) on your Klarna merchant portal. This will provide a code sample of the script tag that Workarea will automatically generate. Copy the client ID from that code sample and set it within the Workarea configuration page, select the region that corresponds to the region of your merchant portal (North America, Europe, or Oceania), and you're done!

### Automated Placements

Once you provide the client ID, Workarea will automatically enable two placements on your site. The first is the "info-page" placement, which is used to generate the page at **yoursite.com/klarna** and a link to that page will be added to the footer navigation. The second placement is on product detail pages, where a message will display under the add to cart button advertising Klarna as a payment option. The price within this message will update if/when the price of the product changes as a user selects product options.

### Custom Placements

To add more placements to your site, you can utilize the various system and content pages by adding a HTML content block and copying the placement code from your [Klarna merchant portal placements page](https://developers.klarna.com/documentation/on-site-messaging/integration/installation/#adding-placements).

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea platform documentation.

License
--------------------------------------------------------------------------------

Workarea Klarna is released under the [Business Software License](LICENSE)
