defmodule Week4.Start do
  alias Week4.GenericPool
  alias Week4.LoadBalancer
  alias Week4.Printer
  alias Week4.Sentiment
  alias Week4.Engagement
  alias Week4.EngagementUser
  alias Week4.Batcher
  alias Week4.Aggregator
  alias Week4.Database
  alias Week1.Reader

  def start_link() do
    EngagementUser.start_link()

    Batcher.start_link(30, 500)
    Aggregator.start_link()
    Database.start_link()

    GenericPool.start_link(:ps, Printer, "printer", 3)
    GenericPool.start_link(:ss, Sentiment, "sentiment", 3)
    GenericPool.start_link(:er, Engagement, "engagement", 3)

    LoadBalancer.start_link()

    Reader.start_link("localhost:4000/tweets/1", :tweet_reader1)
    Reader.start_link("localhost:4000/tweets/2", :tweet_reader2)
  end
end
