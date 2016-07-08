defmodule PriceCheck.Slack do
  use Slack

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message( message = %{type: "message"}, slack) do
    if mentions_me?(message.text, slack) do
      IO.puts "message directed at me!"
    end
  end

  def mentions_me?(messagetext, slack) do
    String.contains? messagetext, "<@#{slack.me.id}>"
  end

  def handle_message(_,_), do: :ok

  def handle_info({:message, text, channel}, slack) do
    send_message(text, channel, slack)
    {:ok, slack}
  end

  def handle_info(_, _), do: :ok
end
