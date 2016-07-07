defmodule PriceCheck do
  use Slack

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message( message = %{type: "message"}, slack) do
    IO.puts ("I got a message from #{message.channel}:  #{message.text}")
  end

  def handle_message(_,_), do: :ok


  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)
    {:ok, slack}
  end

  def handle_info(_, _), do: :ok
end
