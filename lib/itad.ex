defmodule PriceCheck.IsThereAnyDeal do

  def start_link(key) do
    Agent.start_link(fn -> key end, name: __MODULE__ )
  end

  def api_key do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def get_best_price(title) do
    title = URI.encode(title)
    case get_price_list(title) do
      {:ok, price_list} -> 
        game = lowest_price(price_list)
        {:ok, %{:price => game["price_new"], :store => game["shop"]["name"]}}
      {:error} ->
        {:error}
    end
  end

  defp lowest_price(game_list) do
    Enum.min_by(game_list, fn(x) -> x["price_new"] end)
  end

  defp get_price_list(title) do
    case game_plain(title) do
      {:noplain} ->
        {:error}
      plain -> 
        url = "https://api.isthereanydeal.com/v01/game/prices?key=#{api_key}&plains=#{plain}&country=CA"
        response_body = HTTPotion.get(url).body
                    |> Poison.Parser.parse!
        {:ok, response_body["data"][plain]["list"]}
      
    end
  end

  defp game_plain(title) do
    url = "https://api.isthereanydeal.com/v02/game/plain/?key=#{api_key}&title=#{title}"
    response_body = HTTPotion.get(url).body 
                    |> Poison.Parser.parse!
    case response_body do
      %{"data" => %{"plain" => plain} } ->
        plain
      _ ->
        {:noplain}
    end
  end

end
