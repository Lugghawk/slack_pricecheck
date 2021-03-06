defmodule SlackPricecheck do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []
    if (Application.get_env(:slack_pricecheck, :start_slack)) do
      children = children ++ [worker(PriceCheck.Slack, [Application.get_env(:slack_pricecheck, :slack_token)])]
    end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackPricecheck.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
