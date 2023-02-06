defmodule Lab1 do
  def hello(), do: "Hello PTR"

  @doc """
  This is a helper function to push an element at the end of the list

  ## Examples

      iex> Lab1.push_element(1, [3, 2])
      [3, 2, 1]
  """
  def push_element(el, arr), do: arr ++ [el]

  @doc """
  This is a function that determines whether an input integer is prime

  ## Examples

      iex> Lab1.is_prime?(13)
      true

      iex> Lab1.is_prime?(6)
      false
  """
  def is_prime?(n), do: is_prime?(n, 2)

  defp is_prime?(n, i) when i < n / 2 do
    if rem(n, i) == 0 do
      false
    else
      is_prime?(n, i + 1)
    end
  end

  defp is_prime?(_n, _i), do: true

  @doc """
  This is a function to calculate the area of a cylinder, given it’s height and radius.

  ## Examples

      iex> Lab1.cylinder_area(3, 4)
      175.92918860102841
  """
  def cylinder_area(h, r) do
    2 * :math.pi * r * h + 2 * :math.pi * :math.pow(r, 2)
  end

  @doc """
  This is a function to reverse a list

  ## Examples

      iex> Lab1.reverse([1, 2, 4, 8, 4])
      [4, 8, 4, 2, 1]
  """
  def reverse([]), do: []

  def reverse([head | tail]), do: reverse(tail) ++ [head]

  @doc """
  This is a function to calculate the sum of unique elements in a list

  ## Examples

      iex> Lab1.unique_sum([1, 2, 4, 8, 4, 2])
      15
  """
  def unique_sum(arr) do
    Enum.uniq(arr) |> Enum.sum
  end

  @doc """
  This is a function that extracts a given number of randomly selected elements from a list
  """
  def extract_random_n(arr, n) when n > 0 do
    Enum.random(arr) |> extract_random_n_helper(arr, n)
  end

  def extract_random_n(_arr, 0), do: []

  defp extract_random_n_helper(randElem, arr, n) do
    [randElem] ++ extract_random_n(arr -- [randElem], n - 1)
  end

  @doc """
  This is a function that returns the first n elements of the Fibonacci sequence

  ## Examples

      iex> Lab1.first_fibonacci_elements(7)
      [1, 1, 2, 3, 5, 8, 13]
  """
  def first_fibonacci_elements(2), do: [1, 1]

  def first_fibonacci_elements(n) when n > 2 do
    first_fibonacci_elements(n - 1) |> first_fibonacci_elements_helper
  end

  defp first_fibonacci_elements_helper(arr) do
    Enum.take(arr, -2) |> Enum.sum |> push_element(arr)
  end

  @doc """
  This is a function that, given a dictionary, would translate a sentence. Words not found in the dictionary need not be translated

  ## Examples

      iex> Lab1.translator(%{mama: "mother", papa: "father"}, "mama is with papa")
      "mother is with father"
  """
  def translator(dict, str) do
    String.split(str, " ") |>
    Enum.map(&(if dict[String.to_atom(&1)] != nil, do: dict[String.to_atom(&1)], else: &1)) |>
    Enum.join(" ")
  end

  @doc """
  This is a function that receives as input three digits and arranges them in an order that would create the smallest possible number.
  Numbers cannot start with a 0.

  ## Examples

      iex> Lab1.smallest_number(4, 5, 3)
      345

      iex> Lab1.smallest_number(0, 3, 4)
      304
  """
  def smallest_number(a, b, c) do
    [a, b, c] |> Enum.filter(&(&1 != 0)) |> Enum.sort |> smallest_number_helper |> Enum.join("") |> String.to_integer
  end

  defp smallest_number_helper(arr) when length(arr) == 3, do: arr

  defp smallest_number_helper([head | tail]), do: smallest_number_helper([head] ++ [0] ++ tail)

  @doc """
  This is a function that would rotate a list n places to the left.

  ## Examples

      iex> Lab1.rotate_left([1, 2, 4, 8, 4], 3)
      [8, 4, 1, 2, 4]
  """
  def rotate_left(arr, 0), do: arr

  def rotate_left([head | tail], n) when n > 0, do: rotate_left(tail ++ [head], n - 1)

  @doc """
  This is a function that lists all tuples a, b, c such that a^2 + b^2 = c^2 a, b ≤ 20

  ## Examples

      iex> Lab1.list_right_angle_triangles()
      [
        {3, 4, 5},
        {4, 3, 5},
        {5, 12, 13},
        {6, 8, 10},
        {8, 6, 10},
        {8, 15, 17},
        {9, 12, 15},
        {12, 5, 13},
        {12, 9, 15},
        {12, 16, 20},
        {15, 8, 17},
        {15, 20, 25},
        {16, 12, 20},
        {20, 15, 25}
      ]
  """
  def list_right_angle_triangles() do
    Enum.flat_map(1..20, fn a ->
      Enum.map(1..20, fn b ->
        c = :math.sqrt(a * a + b * b)

        if (c - trunc(c) < 1.0e-7), do: {a, b, trunc(c)}
      end)
    end) |> Enum.filter(&(&1 != nil))
  end

  @doc """
  This is a function that eliminates consecutive duplicates in a list.

  ## Examples

      iex> Lab1.remove_consecutive_duplicates([1, 2, 2, 2, 4, 8, 4])
      [1, 2, 4, 8, 4]
  """
  def remove_consecutive_duplicates(arr), do: remove_consecutive_duplicates_helper(arr)

  defp remove_consecutive_duplicates_helper([]), do: []

  defp remove_consecutive_duplicates_helper([head | []]) do
    [head] ++ remove_consecutive_duplicates_helper([])
  end

  defp remove_consecutive_duplicates_helper([head | tail]) do
    if head != hd(tail) do
      [head] ++ remove_consecutive_duplicates_helper(tail)
    else
      remove_consecutive_duplicates_helper(tail)
    end
  end

  @doc """
  This is a function that, given an array of strings, will return the words that can be typed using only one row of the letters on an English keyboard layout.

  ## Examples

      iex> Lab1.line_words(["Hello", "Alaska", "Dad", "Peace"])
      ["Alaska", "Dad"]
  """
  def line_words(arr) do
    lines = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]

    Enum.flat_map(arr, fn word ->
      Enum.map(lines, fn line ->
        {word, line}
      end)
    end) |> Enum.map(fn {word, line} ->
      String.downcase(word) |> String.split("", trim: true) |> line_words_helper(word, line)
    end) |> Enum.filter(&(&1 != nil))
  end

  defp line_words_helper(charArr, word, line) do
    if Enum.all?(charArr, &(String.contains?(line, &1))), do: word
  end

  @doc """
  This is a pair of functions to encode and decode strings using the Caesar cipher.

  ## Examples

      iex> Lab1.encode("lorem", 3)
      "oruhp"

      iex> Lab1.decode("oruhp", 3)
      "lorem"
  """
  def encode(str, n) do
    String.to_charlist(str) |> Enum.map(&(encode_helper(&1, n))) |> List.to_string
  end

  defp encode_helper(ch, n) do
    if ch != 32, do: rem((ch - ?a + n), 26) + ?a, else: ch
  end

  def decode(str, n) do
    String.to_charlist(str) |> Enum.map(&(decode_helper(&1, n))) |> List.to_string
  end

  defp decode_helper(ch, n) do
    if ch != 32, do: rem((ch - ?a - n + 26), 26) + ?a, else: ch
  end

  @doc """
  This is a function that, given a string of digits from 2 to 9, would return all possible letter combinations that the number could
  represent (think phones with buttons).

  ## Examples

      iex> Lab1.letters_combinations("23")
      [["ad", "ae", "af"], ["bd", "be", "bf"], ["cd", "ce", "cf"]]
  """
  def letters_combinations(str) do
    number_letters = [[], [], ["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"], ["j", "k", "l"], ["m", "n", "o"], ["p", "q", "r", "s"], ["t", "u", "v"], ["w", "x", "y", "z"]]

    letters_combinations_helper(str, "", number_letters)
  end

  defp letters_combinations_helper(str, acc, _number_letters) when str == "", do: acc

  defp letters_combinations_helper(str, acc, number_letters) do
    index = String.first(str) |> String.to_integer

    Enum.fetch!(number_letters, index) |> Enum.map(&(letters_combinations_helper(String.slice(str, 1..-1//1), acc <> &1, number_letters)))
  end

  @doc """
  This is a function that, given an array of strings, would group the anagrams together.

  ## Examples

      iex> Lab1.group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"])
      %{"abt" => ["bat"], "aet" => ["eat", "tea", "ate"], "ant" => ["tan", "nat"]}
  """
  def group_anagrams(arr) do
    Enum.group_by(arr, &(String.split(&1, "", trim: true) |> Enum.sort |> Enum.join("")))
  end

  @doc """
  This is a function to find the longest common prefix string amongst a list of strings.

  ## Examples

      iex> Lab1.common_prefix(["flower", "flow", "flight"])
      "fl"

      iex> Lab1.common_prefix(["alpha", "beta", "gamma"])
      ""
  """
  def common_prefix(arr) do
    shortest_string_length(arr) |> common_prefix_helper(arr)
  end

  defp common_prefix_helper(0, _arr), do: ""

  defp common_prefix_helper(_n, [head | []]), do: head

  defp common_prefix_helper(n, arr) when n > 0 do
    prefix = String.slice(hd(arr), 0..(n - 1))

    if Enum.all?(arr, &(String.slice(&1, 0..(n - 1)) == prefix)), do: prefix, else: common_prefix_helper(n - 1, arr)
  end

  @doc """
  This is a helper function to get the shortest string length in an array

  ## Examples

      iex> Lab1.shortest_string_length(["flower", "flow", "flight"])
      4
  """
  def shortest_string_length(arr) do
    Enum.min_by(arr, &String.length/1) |> String.length
  end

  @doc """
  This is a function to convert arabic numbers to roman numerals.

  ## Examples

      iex> Lab1.to_roman(13)
      "XIII"
  """
  def to_roman(num) do
    arabic_roman = [
      [1000, "M"], [900, "CM"], [500, "D"], [400, "CD"],
      [100, "C"], [90, "XC"], [50, "L"], [40, "XL"],
      [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]
    ]

    to_roman_helper(num, 0, arabic_roman)
  end

  defp to_roman_helper(num, _i, _arabic_roman) when num <= 0, do: ""

  defp to_roman_helper(num, i, arabic_roman) when num > 0 do
    [arabic, roman] = Enum.fetch!(arabic_roman, i)

    if num >= arabic do
      roman <> to_roman_helper(num - arabic, i, arabic_roman)
    else
      to_roman_helper(num, i + 1, arabic_roman)
    end
  end

  @doc """
  This is a function to calculate the prime factorization of an integer.

  ## Examples

      iex> Lab1.factorize(13)
      [13]

      iex> Lab1.factorize(42)
      [2, 3, 7]
  """
  def factorize(num) do
    factorize_helper(num, 2)
  end

  defp factorize_helper(1, _factor), do: []

  defp factorize_helper(num, factor) do
    if rem(num, factor) == 0 and is_prime?(factor) do
      [factor] ++ factorize_helper(div(num, factor), factor)
    else
      factorize_helper(num, factor + 1)
    end
  end
end
