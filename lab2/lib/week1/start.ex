defmodule Week1.Start do
  alias Week1.Reader
  alias Week1.Printer
  alias Week1.Analytics
  alias Week1.Pool
  alias Week1.LoadBalancer
  alias Week1.AutoScaling
  alias Week1.MessageStore

  def start_link() do
    Pool.start_link({50, 100})
    LoadBalancer.start_link()
    AutoScaling.start_link({100, 3, 20})
    MessageStore.start_link()
    Analytics.start_link()
    Reader.start_link("localhost:4000/tweets/1", :tweet_reader1)
    Reader.start_link("localhost:4000/tweets/2", :tweet_reader2)
  end
end
