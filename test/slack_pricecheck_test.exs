defmodule SlackPricecheckTest do
  use ExUnit.Case
  doctest SlackPricecheck

  test "should return true if message mentions me first" do
    myId = "MyBotId"
    message = "<@#{myId}> hello"
    slack_map = %{me: %{id: myId} }
    assert PriceCheck.Slack.mentions_me?(message, slack_map) == true
  end

  test "should return true if message mentions me anywhere in the message" do
    myId = "MyBotId"
    message = "Early in the message <@#{myId}> late in the message"
    slack_map = %{me: %{id: myId} }
    assert PriceCheck.Slack.mentions_me?(message, slack_map) == true
  end

  test "should return false if message does not contain my name anywhere in the message" do
    myId = "MyBotId"
    message = "Does not contain my bot's linked name anywhere"
    slack_map = %{me: %{id: myId} }
    assert PriceCheck.Slack.mentions_me?(message, slack_map) == false
  end

end
