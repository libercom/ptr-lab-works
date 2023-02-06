defmodule Main do
  use Application

  def start(_type, _args) do
    # IO.puts(Lab1.is_prime?(4))
    # IO.puts(Lab1.cylinder_area(3, 4))
    # IO.inspect(Lab1.reverse([1, 2, 3]))
    # IO.puts(Lab1.unique_sum([1, 1, 2, 2, 3]))
    # IO.inspect(Lab1.extract_random_n([1, 2, 3, 4, 5, 6, 7, 2], 5))
    # IO.inspect(Lab1.first_fibonacci_elements(5))
    # IO.inspect(Lab1.translator(%{"Hello": "Hi"}, "Hello world"))
    # IO.inspect(Lab1.smallest_number(0, 2, 3))
    # IO.inspect(Lab1.rotate_left([1, 2, 4, 8, 4], 3))
    # IO.inspect(Lab1.list_right_angle_triangles())
    # IO.inspect(Lab1.remove_consecutive_duplicates([1, 2, 2, 2, 4, 8, 4]))
    # IO.inspect(Lab1.encode("lorem", 3))
    # IO.inspect(Lab1.decode("oruhp", 3))
    # IO.inspect(Lab1.line_words(["Hello", "Alaska", "Dad", "Peace"]))
    # IO.inspect(Lab1.letters_combinations("23"))
    # IO.inspect(Lab1.group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"]))
    # IO.inspect(Lab1.common_prefix(["flower", "flow", "flight"]))
    # IO.inspect(Lab1.common_prefix(["alpha"]))
    # IO.inspect(Lab1.to_roman(13))
    # IO.inspect(Lab1.factorize(13), charlists: :as_lists)

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
