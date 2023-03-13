defmodule Week1.Start do
  alias Week1.Reader
  alias Week1.Printer
  alias Week1.Analytics
  alias Week1.Pool
  alias Week1.LoadBalancer

  def start_link() do
    Pool.start_link({500, 1000})
    LoadBalancer.start_link()
    Analytics.start_link()
    Reader.start_link("localhost:4000/tweets/1", :tweet_reader1)
    Reader.start_link("localhost:4000/tweets/2", :tweet_reader2)
  end
end
