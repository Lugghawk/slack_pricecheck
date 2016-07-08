# SlackPricecheck

Slack bot which responds to mentions by searching IsThereAnyDeal.com for the mentioned game and responding with the best price and what store it's on.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add slack_pricecheck to your list of dependencies in `mix.exs`:

        def deps do
          [{:slack_pricecheck, "~> 0.0.1"}]
        end

  2. Ensure slack_pricecheck is started before your application:

        def application do
          [applications: [:slack_pricecheck]]
        end

