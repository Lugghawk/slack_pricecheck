defmodule PriceCheck.Slack do
  use Slack
  import Number.Currency

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
    PriceCheck.IsThereAnyDeal.start_link(Application.get_env(:slack_pricecheck, :itad_token))
  end

  def handle_message(%{subtype: _subtype}, _slack), do: :ok

  def handle_message(message = %{type: "message"}, slack) do
    if mentions_me?(message.text, slack) do
      spawn_link(fn -> 
       get_game_price(message.text, slack)
      end)
    end
    :ok
  end

  def handle_message(_,_), do: :ok

  defp get_game_price(message, slack) do
    title = game_title(message, slack)
    reply = case best_price(title) do
      {:ok, %{price: price, store: store, url: url}} ->
        "Best price is #{number_to_currency(price)} CAD at #{store}\n#{url}"
      _ ->
        "Couldn't find #{title}. Try a more specific title."
      end
    send_message(reply, message.channel, slack)
    :ok
  end

  defp best_price(title) do
    PriceCheck.IsThereAnyDeal.get_best_price(title)
  end

  def game_title(message, slack) do
    title = String.replace(message, "<@#{slack.me.id}>", "")
    String.trim title
  end

  def mentions_me?(messagetext, slack) do
    String.contains? messagetext, "<@#{slack.me.id}>"
  end

  def handle_close(reason, _slack) do
    raise reason
  end

  def handle_info({:message, text, channel}, slack) do
    send_message(text, channel, slack)
    {:ok, slack}
  end

  def handle_info(_, _), do: :ok
end
