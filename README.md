# AntigateApi

Antigate (Decode captcha service - antigate.com) wrapper

## Installation

Add this line to your application's Gemfile:

    gem 'antigate_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install antigate_api

## Usage

```
options = {
  recognition_time: 5, # First waiting time
  sleep_time: 1, # Sleep time for every check interval
  timeout: 60, # Max time out for decoding captcha
  debug: false # Verborse or not
}
client = AntigateApi::Client.new(ANTIGATE_KEY, options)
captcha_id, captcha_answer = client.decode("captcha.gif")
puts captcha_id + " " + captcha_answer
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
