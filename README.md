# Temperature Alert

[![CircleCI](https://circleci.com/gh/KidA001/TempAlert.svg?style=shield&circle-token=c726e367db72a34e92c9e28ddd23db4c99d1a286)](https://circleci.com/gh/KidA001/TempAlert)

## Summary
TempAlert is an application that receives temperature notifications from an outside source as a webhook and records them. It has a light front-end that displays the current temperature. TempAlert also allows you to login and subscribe to certain notifications, for example, when the temperature of the hot tub reaches 104 Degrees!

## Setup
### Prerequisites

* [Git](http://git-scm.com/)
* [Ruby 2.4.1](https://www.ruby-lang.org/en/)
* [Rubygems](https://rubygems.org/)
* [Bundler](http://bundler.io/)

### Installation
 - Clone the repo: `git clone git@github.com:KidA001/TempAlert.git`
 - Instantiate rails secrets with `$ rails secrets`
 - Add your rails secrets with `$ rails secrets:edit` - you'll need the following:
   - `api_key` - Auth Key for _incoming_ webhooks to this server
   - `sendgrid_api_key` - Sendgrid key for sending emails
   - `google_client_id` - Google Client ID for OAuth
   - `google_client_secret` - Google Client Secret for OAuth
   - `production_url` - the URL you plan to host the application from in `Production`
   - `twillio_account_sid` - Twillio Account SID for sending SMS
   - `twillio_auth_token` - Twillio Auth Token for sending SMS
 - Install gem dependencies: `$ bundle install`
 - Setup the database `$ rake db:setup`
 - Start the server with `rails s`
 - View the application at `http://localhost:3000`
 - In order to properly load the variables for the Arduino.ico file, you need to create a `config.h` file with the following:
 ```c++
char ssid[] = "YourSSID";
char pass[] = "SuperSecretPW";
String host = "somehost.herokuapp.com";
char server[] = "http://somehost.herokuapp.com";
String authToken = "youllneverguess123";
 ```

## Other Notes
The [Arduino.ico](https://github.com/KidA001/TempAlert/tree/master/arduino) file contains the Arduino code I used to for the temperature sensor that connects and sends temperatures to this server. I used the following parts: [TinyDuino Processor](https://tinycircuits.com/collections/processors/products/tinyduino-processor-board) as the main Arduino board, [USB TinyShield](https://tinycircuits.com/collections/communication/products/usb-tinyshield) which allows me to connect/power the Arduino via USB, [WIFI TinyShield](https://tinycircuits.com/collections/communication/products/wifi-tinyshield-atwinc1500) for connecting to WiFi, [Proto Board TinyShield](https://tinycircuits.com/collections/proto-boards/products/proto-board-tinyshield) for adding on external sensors, and lastly the [DS18b20](https://www.adafruit.com/product/381?gclid=CjwKCAjwzMbLBRBzEiwAfFz4gXXOVZ71c3pl2pPJhgH1iXZA5AFAQqQFiNNHE4ydiYU3rq6vc56Y3xoCeTIQAvD_BwE) waterproof digital temperature sensor w/4.7k resistor.

At some point I'll make a blog post on how I created this. Please feel free to use this software freely and reach out if you have any questions.

## Testing
We use [rspec](http://rspec.info/documentation/3.5/rspec-rails/) for testing.

Run `rspec` in the terminal to run all tests.
