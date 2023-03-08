# FAF.PTR16.1 -- Project 0

> **Performed by:** Vasile Ignat, group FAF-202
> **Verified by:** asist. univ. Alexandru Osadcenco

## P0W1

**Task 1**

```elixir
@doc """
This is a function that determines whether an input integer is prime.

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
```

The function uses recursion to iterate over all the possible divisors of the input number starting from 2. It checks whether the remainder of dividing n by i is zero. If it is, then n is not a prime number and the function returns false. Otherwise, it calls itself with the next possible divisor i+1 until i becomes greater than or equal to n/2.

If the function completes the recursion without finding any divisor of n that evenly divides it, then n is a prime number, and the function returns true.

**Task 2**

```elixir
@doc """
  This is a function to calculate the area of a cylinder, given it’s height and radius.

  ## Examples

      iex> Lab1.cylinder_area(3, 4)
      175.92918860102841
  """
  def cylinder_area(h, r) do
    2 * :math.pi * r * h + 2 * :math.pi * :math.pow(r, 2)
  end
```

The function uses the formula 2 \* pi \* r \* h + 2 \* pi \* r^2 to calculate the surface area of a cylinder, where pi is the mathematical constant for the ratio of a circle's circumference to its diameter, r is the cylinder's radius, and h is its height.

**Task 3**

```elixir
@doc """
  This is a function to reverse a list

  ## Examples

      iex> Lab1.reverse([1, 2, 4, 8, 4])
      [4, 8, 4, 2, 1]
  """
  def reverse([]), do: []

  def reverse([head | tail]), do: reverse(tail) ++ [head]
```

The reverse function uses pattern matching to define two clauses: one for an empty list, which returns an empty list, and one for a non-empty list, which recursively reverses the tail of the list and appends the head to the end.

**Task 4**

```elixir
@doc """
  This is a function to calculate the sum of unique elements in a list

  ## Examples

      iex> Lab1.unique_sum([1, 2, 4, 8, 4, 2])
      15
  """
  def unique_sum(arr) do
    Enum.uniq(arr) |> Enum.sum
  end
```

This is an Elixir function that takes a list arr as input, removes duplicate elements using Enum.uniq/1 and returns the sum of the remaining unique elements using Enum.sum/1.

**Task 5**

```elixir
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
```

The function works recursively by first selecting a random element from the input list using Enum.random/1, and then calling the helper function extract_random_n_helper/3 to remove the selected element from the input list and continue selecting elements until n elements have been selected.

**Task 6**

```elixir
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
```

The function uses recursion to generate the sequence, where the base case is when n is equal to 2, in which case the function returns the list [1, 1]. Otherwise, it calls the first_fibonacci_elements_helper/1 function, which takes the previously generated sequence as input and generates the next number in the sequence using the formula F(n) = F(n-1) + F(n-2).

**Task 7**

```elixir
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
```

The translation replaces each word in the input string that has a corresponding key in the dictionary with the associated value in the dictionary. Words that do not have a key in the dictionary are not translated.

The function first splits the input string into a list of words using the String.split/2 function. It then uses the Enum.map/2 function to map over the list of words, applying a function to each word. The function checks whether the current word has a corresponding key in the dictionary by using the dict[String.to_atom(&1)] expression. If there is a corresponding key, it returns the associated value using do: dict[String.to_atom(&1)]. If there is no corresponding key, it returns the original word using else: &1. Finally, the translated list of words is joined back into a string using the Enum.join/2 function.

**Task 8**

```elixir
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
```

This is a function that receives three digits as input and arranges them in an order that creates the smallest possible number. The numbers cannot start with 0.

**Task 9**

```elixir
@doc """
  This is a function that would rotate a list n places to the left.

  ## Examples

      iex> Lab1.rotate_left([1, 2, 4, 8, 4], 3)
      [8, 4, 1, 2, 4]
  """
  def rotate_left(arr, 0), do: arr

  def rotate_left([head | tail], n) when n > 0, do: rotate_left(tail ++ [head], n - 1)
```

It returns the same list rotated n places to the left. The rotate_left/2 function uses pattern matching to define two function clauses:

The first clause states that when n is 0, it returns the original list.
The second clause states that when n is greater than 0, it recursively calls rotate_left/2 with the tail of the list concatenated with the head of the list, and n decremented by 1.

**Task 10**

```elixir
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
```

The implementation generates all possible values for a and b using nested Enum.map functions, and computes c using the Pythagorean theorem. If c is an integer, then the tuple (a, b, c) is returned.

The implementation uses Enum.flat_map to flatten the list of lists generated by the nested Enum.map calls, and then uses Enum.filter to remove any nil values that may have been generated.

**Task 11**

```elixir
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
```

The implementation uses a recursive approach where the current head element is compared with the head of the remaining list. If they are different, the head is added to the result list and the function is called recursively with the tail. If they are the same, the function is called recursively with the tail only, effectively removing the consecutive duplicate.

**Task 12**

```elixir
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
```

The line_words function takes an array of strings and checks if each string can be typed using only one row of letters on an English keyboard layout. It uses the Enum.flat_map function to create a Cartesian product of the input array and the keyboard lines, and then maps over each pair of the word and the keyboard line to check if all the characters in the word are present in the keyboard line using the Enum.all? function.

The line_words_helper function is used to split the string into characters, convert it to lowercase, and then check if all characters in the word are present in the keyboard line.

**Task 13**

```elixir
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
```

The encode function takes a string and a shift amount, and returns the encoded string by shifting each character in the input string to the right by n characters in the alphabet. The decode function takes an encoded string and a shift amount, and returns the original string by shifting each character in the input string to the left by n characters in the alphabet.

The encoding and decoding is done by first converting the input string to a char list using String.to_charlist, and then applying the encode_helper and decode_helper functions to each character in the list using Enum.map. The encode_helper function shifts the character to the right by n characters in the alphabet, while the decode_helper function shifts the character to the left by n characters.

The implementation uses the ASCII code of the characters to perform the shift, assuming that the input string only contains lowercase letters and spaces. Characters that are not lowercase letters (i.e., have ASCII code less than 97 or greater than 122) are left unchanged. Spaces are also left unchanged.

**Task 14**

```elixir
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
```

The function uses a recursive helper function, letters_combinations_helper/3, which takes the remaining digits, an accumulator for the letters that have been found so far, and a list of the letters that correspond to each digit.

In the base case, when the string of digits is empty, the accumulator is returned as the result. In the recursive case, the first digit of the string is converted to an integer, and the corresponding letters are fetched from the number_letters list. Each of these letters is appended to the accumulator, and the recursive function is called again with the remaining digits and the updated accumulator.

**Task 15**

```elixir
@doc """
  This is a function that, given an array of strings, would group the anagrams together.

  ## Examples

      iex> Lab1.group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"])
      %{"abt" => ["bat"], "aet" => ["eat", "tea", "ate"], "ant" => ["tan", "nat"]}
  """
  def group_anagrams(arr) do
    Enum.group_by(arr, &(String.split(&1, "", trim: true) |> Enum.sort |> Enum.join("")))
  end
```

The function takes an array of strings as input and groups all anagrams together. It does this by sorting each string in the array alphabetically and using the sorted string as the key to group the anagrams together. The result is a map with keys that are the sorted strings and values that are lists of the original strings that are anagrams.

The implementation is simple and easy to understand. It makes use of the Enum.group_by function to group the strings based on their sorted counterparts. The use of String.split/3, Enum.sort/1, and Enum.join/2 to sort the strings is a clever way of comparing them without having to use complex algorithms like hash tables or binary search trees.

**Task 16**

```elixir
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
```

The function first calls a helper function that takes the length of the shortest string in the list and recursively checks if the prefix of each string in the list with length n is equal. If the prefix is equal for all strings, the prefix is returned as the longest common prefix. If not, the function recursively reduces the length of the prefix by 1 and checks again until it finds the longest common prefix or returns an empty string if no common prefix is found.

**Task 17**

```elixir
@doc """
  This is a helper function to get the shortest string length in an array

  ## Examples

      iex> Lab1.shortest_string_length(["flower", "flow", "flight"])
      4
  """
  def shortest_string_length(arr) do
    Enum.min_by(arr, &String.length/1) |> String.length
  end
```

It is used in the common_prefix function to determine the maximum possible length of the common prefix.

The implementation is straightforward - it uses the Enum.min_by function to find the element with the smallest length, and then applies String.length to get the length of that string.

**Task 18**

```elixir
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
```

It makes use of a list of tuples containing pairs of Arabic numbers and their corresponding Roman numeral representations.

The function uses a helper function, to_roman_helper, to recursively iterate through the list of pairs until the appropriate Roman numeral is found. The function then concatenates the Roman numeral to the result of the recursive call to to_roman_helper with the remaining Arabic number.

**Task 19**

```elixir
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
```

It starts by dividing the given number by the smallest possible prime factor (2), and then continues recursively with the result until it is no longer divisible by the current factor.

## P0W2

**Task 1**

```elixir
def print_actor_spawn(), do: spawn(&print_actor_loop/0)

def print_actor_loop() do
    receive do
        msg -> IO.inspect(msg)
        print_actor_loop()
    end
end
```

The print_actor_spawn/0 function creates a new process by invoking the spawn/1 function, passing in a reference to the print_actor_loop/0 function as an anonymous function. This creates a new process that will execute the print_actor_loop/0 function in the background.

The print_actor_loop/0 function defines the behavior of the actor process. It uses the receive keyword to wait for a message to be sent to it. When a message is received, the function will print the message to the console using IO.inspect/1, and then recursively call itself to continue waiting for messages.

**Task 2**

```elixir
def transform_actor_spawn(), do: spawn(&transform_actor_loop/0)

def transform_actor_loop() do
    receive do
        num when is_integer(num) -> IO.inspect("Received: #{num + 1}")
        transform_actor_loop()
        str when is_bitstring(str) -> IO.inspect("Received: #{String.downcase(str)}")
        transform_actor_loop()
        _ -> IO.inspect("Received: I dont know how to HANDLE this!")
        transform_actor_loop()
    end
end
```

This code defines an actor process that listens for messages and performs different transformations based on the type of message received. If the message is an integer, the actor adds one to it and prints the result. If the message is a string, the actor converts it to lowercase and prints the result. If the message is of any other type, the actor prints a default message.

The transform_actor_spawn function uses the spawn function to create a new process that executes the transform_actor_loop function. The transform_actor_loop function uses the receive function to wait for messages, and then pattern matches on the type of the message to determine how to handle it. The IO.inspect function is used to print out the transformed message. The function then calls itself recursively to wait for the next message.

**Task 3**

```elixir
def average_actor_spawn(initial_state), do: spawn(fn -> average_actor_loop(initial_state) end)

def average_actor_increase(pid, val), do: send(pid, val)

def average_actor_loop(state) do
    receive do
        num when is_number(num) ->
        IO.inspect("Current average is #{(num + state) / 2}")
        average_actor_loop((num + state) / 2)
        _ -> average_actor_loop(state)
    end
end
```

This code defines an Elixir module named Lab2 with a function average_actor_spawn that spawns a new process running the average_actor_loop function with the given initial_state. The average_actor_increase function sends a message with the val to the pid process. The average_actor_loop function receives messages and updates the state accordingly, printing the current average whenever it receives a number message.

**Task 4**

```elixir
# defmodule Lab2.Semaphore do
#   def create_semaphore(count), do: spawn(fn -> semaphore_loop(count, []) end)

#   def semaphore_loop(count, queue) do
#     receive do
#       {:acquire, sender} ->
#         if count > 0 do
#           send(sender, :ok)
#           semaphore_loop(count - 1, queue)
#         else
#           send(sender, :wait)
#           semaphore_loop(count, queue ++ [sender])
#         end

#       :release ->
#         {sent, new_queue} = release_helper(queue)

#         case sent do
#           true -> semaphore_loop(count, new_queue)
#           false -> semaphore_loop(count + 1, new_queue)
#         end
#     end
#   end

#   defp release_helper([]), do: {false, []}

#   defp release_helper([head | tail]) do
#     if Process.alive?(head) do
#       send(head, :ok)

#       {true, tail}
#     else
#       release_helper(tail)
#     end
#   end

#   def acquire(pid) do
#     send(pid, {:acquire, self()})

#     receive do
#       :ok -> :ok
#       :wait ->
#         IO.inspect("#{:erlang.pid_to_list(self())} tried to acquire semaphore, waiting...")

#         receive do
#           :ok -> :ok
#         end
#     end
#   end

#   def release(pid) do
#     send(pid, :release)
#   end
# end

defmodule Lab2.Semaphore do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def create_semaphore(count) do
    GenServer.start_link(__MODULE__, {count, []})
  end

  def handle_call(:acquire, {pid, _ref}, {count, queue}) do
    case count > 0 do
      true -> {:reply, :ok, {count - 1, queue}}
      false -> {:reply, :wait, {count, queue ++ [pid]}}
    end
  end

  def handle_cast(:release, {count, queue}) do
    {sent, new_queue} = release_helper(queue)

    case sent do
      true -> {:noreply, {count, new_queue}}
      false -> {:noreply, {count + 1, new_queue}}
    end
  end

  defp release_helper([]), do: {false, []}

  defp release_helper([head | tail]) do
    if Process.alive?(head) do
      send(head, :ok)

      {true, tail}
    else
      release_helper(tail)
    end
  end

  def acquire(pid) do
    response = GenServer.call(pid, :acquire)

    case response do
      :ok -> :ok
      :wait ->
        IO.inspect("#{:erlang.pid_to_list(self())} tried to acquire semaphore, waiting...")

        receive do
          :ok -> :ok
        end
    end
  end
  def release(pid) do
    GenServer.cast(pid, :release)
  end
end
```

This code defines a Semaphore module with two implementations of a semaphore using two different OTP behaviors: spawn and GenServer.

The first implementation uses spawn to create a semaphore. The semaphore_loop function receives messages to either acquire or release the semaphore. If the count is greater than zero, the semaphore is immediately acquired and an "ok" message is sent to the sender. If the count is zero, the sender is added to a queue and sent a "wait" message. When a release message is received, the release_helper function tries to send "ok" messages to each process in the queue. If a process is not alive, it is removed from the queue. Finally, the acquire and release functions are defined to send messages to the semaphore process to either acquire or release the semaphore.

The second implementation uses GenServer to create a semaphore. The init function initializes the state of the GenServer with a count and an empty queue. The handle_call function receives calls to acquire the semaphore and either replies with an "ok" or "wait" message depending on the count. The handle_cast function receives cast messages to release the semaphore and updates the state by trying to send "ok" messages to processes in the queue. The acquire and release functions are defined to call or cast to the GenServer process to acquire or release the semaphore.

Overall, the second implementation using GenServer is more robust and provides better error handling than the first implementation using spawn.

**Task 5**

```elixir
defmodule Lab2.Scheduler do
  use GenServer

  alias Lab2.Worker

  def init(specs) do
    Process.flag(:trap_exit, true)

    {:ok, specs}
  end

  def start() do
    GenServer.start_link(__MODULE__, %{})
  end

  def handle_cast({:create_worker, msg}, specs) do
    pid = Worker.start(msg)

    {:noreply, Map.put(specs, pid, msg)}
  end

  def handle_info({:EXIT, pid, :normal}, specs) do
    Process.alive?(pid)

    {:noreply, Map.delete(specs, pid)}
  end

  def handle_info({:EXIT, pid, reason}, specs) when reason != :normal do
    old_value = Map.get(specs, pid)
    new_pid = Worker.start(old_value)

    IO.inspect "#{old_value} -> Task fail"

    {:noreply, Map.delete(specs, pid) |> Map.put(new_pid, old_value)}
  end

  def create_worker(pid, msg) do
    GenServer.cast(pid, {:create_worker, msg})
  end
end

```

This code defines a custom supervisor module named Lab2.Scheduler that uses the GenServer behavior. The Scheduler initializes by setting the :trap_exit flag of the current process to true, which causes the process to receive exit signals from its child processes.

The start() function starts the GenServer process and returns its PID.

The handle_cast/2 function handles a {:create_worker, msg} message by calling the Worker.start/1 function and adding the resulting Worker PID and its message to the specs map. The specs map is a mapping between the Worker PIDs and their associated messages.

The handle_info/2 function handles an {:EXIT, pid, :normal} message by simply removing the pid from the specs map. If the pid is not alive, the function will do nothing. If the {:EXIT, pid, reason} message indicates that the Worker process failed for some reason other than a normal exit, the function restarts the worker process by calling Worker.start/1 with the old message value. The new Worker PID is then added to the specs map, replacing the old one.

Finally, the create_worker/2 function is a convenience function that allows other processes to send a {:create_worker, msg} message to the Scheduler process using GenServer.cast/2. This function takes the Scheduler PID and the msg argument that will be passed to the Worker.start/1 function.

**Task 6**

```elixir
# defmodule Lab2.DoublyLinkedList do
#   def create_dllist(arr) do
#     pid = spawn(fn -> dllist_actor_loop(nil, nil) end)
#     first_pid = dllist_actor_create_helper(nil, arr, pid)

#     dllist_set_first(pid, first_pid)
#     pid
#   end

#   defp dllist_actor_create_helper(prev, [head | []], dll_pid) do
#     current_pid = node_actor_spawn(head, nil, prev)
#     dllist_set_last(dll_pid, current_pid)

#     current_pid
#   end

#   defp dllist_actor_create_helper(prev, [head | tail], dll_pid) do
#     current_pid = node_actor_spawn(head, nil, prev)
#     next_pid = dllist_actor_create_helper(current_pid, tail, dll_pid)
#     node_set_next(current_pid, next_pid)

#     current_pid
#   end

#   def dllist_actor_loop(first, last) do
#     receive do
#       {:traverse, sender} ->
#         send(sender, traverse_helper(first))
#         dllist_actor_loop(first, last)
#       {:inverse, sender} ->
#         send(sender, inverse_helper(last))
#         dllist_actor_loop(first, last)
#       {:set_first, first_pid} ->
#         dllist_actor_loop(first_pid, last)
#       {:set_last, last_pid} ->
#         dllist_actor_loop(first, last_pid)
#     end
#   end

#   def dllist_set_first(pid, first_pid), do: send(pid, {:set_first, first_pid})

#   def dllist_set_last(pid, last_pid), do: send(pid, {:set_last, last_pid})

#   def node_actor_spawn(val, next, prev), do: spawn(fn -> node_actor_loop(val, next, prev) end)

#   def node_actor_loop(val, next, prev) do
#     receive do
#       {:next, sender} ->
#         send(sender, {next, val})
#         node_actor_loop(val, next, prev)
#       {:prev, sender} ->
#         send(sender, {prev, val})
#         node_actor_loop(val, next, prev)
#       {:set_next, next_pid} ->
#         node_actor_loop(val, next_pid, prev)
#     end
#   end

#   def node_set_next(pid, next_pid) do
#     send(pid, {:set_next, next_pid})
#   end

#   defp traverse_helper(node) do
#     send(node, {:next, self()})

#     receive do
#       {nil, val} ->
#         [val]
#       {next, val} ->
#         [val] ++ traverse_helper(next)
#     end
#   end

#   defp inverse_helper(node) do
#     send(node, {:prev, self()})

#     receive do
#       {nil, val} ->
#         [val]
#       {prev, val} ->
#         [val] ++ inverse_helper(prev)
#     end
#   end

#   def traverse(pid) do
#     send(pid, {:traverse, self()})

#     receive do
#       res -> res
#     end

#   end

#   def inverse(pid) do
#     send(pid, {:inverse, self()})

#     receive do
#       res -> res
#     end
#   end
# end

defmodule Lab2.DoublyLinkedList do
  use GenServer

  alias Lab2.Node

  def init(state) do
    {:ok, state}
  end

  def create_dllist(arr) do
    state = create_dllist_helper(arr)

    GenServer.start_link(__MODULE__, state)
  end

  defp create_dllist_helper([head | tail]) do
    {:ok, first} = Node.create_node(nil, head)
    last = add_nodes_helper(first, tail)

    {first, last}
  end

  defp add_nodes_helper(prev, []), do: prev

  defp add_nodes_helper(prev, [head | tail]) do
    pid = Node.add_node(prev, head)

    add_nodes_helper(pid, tail)
  end

  def handle_call(:traverse, _from, {first, last}) do
    {:reply, traverse_helper(first), {first, last}}
  end

  defp traverse_helper(node) do
    {next, val} = Node.get_next(node)

    case next do
      nil ->
        [val]
      _ ->
        [val] ++ traverse_helper(next)
    end
  end

  def handle_call(:inverse, _from, {first, last}) do
    {:reply, inverse_helper(last), {first, last}}
  end

  defp inverse_helper(node) do
    {next, val} = Node.get_prev(node)

    case next do
      nil ->
        [val]
      _ ->
        [val] ++ inverse_helper(next)
    end
  end

  def traverse(pid) do
    GenServer.call(pid, :traverse)
  end

  def inverse(pid) do
    GenServer.call(pid, :inverse)
  end
end

```

This is an implementation of a doubly linked list in Elixir, using GenServers for the nodes and the list itself.

The list is initialized with the `create_dllist` function, which takes an array as an argument and returns a process ID representing the list. The list is built by spawning a GenServer process for each node and linking them together.

The `traverse` and `inverse` functions are used to traverse the list and return the values in order, or in reverse order, respectively.

The implementation is split into two modules: `Lab2.DoublyLinkedList` and `Lab2.Node`.

The `Node` module contains the implementation for a single node in the linked list, while the `DoublyLinkedList` module contains the logic for the entire list.

The `DoublyLinkedList` module uses the `GenServer` behaviour, which is a behavior that allows you to create processes that can receive and respond to messages.

The `create_dllist` function spawns the first node process and then recursively spawns processes for the remaining nodes, linking them together to form a doubly linked list.

The `traverse` and `inverse` functions send messages to the process ID representing the list, which then recursively traverses the list and returns the values in the desired order.

## P0W3

**Task 1**

```elixir
defmodule Lab3.SupervisedWorker do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_cast(:kill, _state) do
    Process.exit(self(), :kill)

    {:noreply, nil}
  end

  def handle_cast({:echo, message}, _state) do
    IO.inspect("#{:erlang.pid_to_list(self())}: #{message}")

    {:noreply, nil}
  end

  def kill(pid) do
    GenServer.cast(pid, :kill)
  end

  def echo(pid, message) do
    GenServer.cast(pid, {:echo, message})
  end
end

defmodule Lab3.SupervisedPool do
  use Supervisor

  alias Lab3.SupervisedWorker

  def init(workers_count) do
    children = Enum.map(1..workers_count, fn x -> Supervisor.child_spec(SupervisedWorker, id: "my_worker_#{x}") end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(workers_count) do
    Supervisor.start_link(__MODULE__, workers_count, name: __MODULE__)

  end

  def get_workers(pid) do
    Supervisor.which_children(pid) |> Enum.map(fn x -> elem(x, 1) end) |> List.to_tuple
  end
end

```

The code defines two modules: Lab3.SupervisedWorker and Lab3.SupervisedPool.

Lab3.SupervisedWorker is a GenServer process that can handle two types of cast messages: :kill and {:echo, message}. When it receives :kill, it exits the process with the :kill reason. When it receives {:echo, message}, it prints out the process ID of the worker and the message. It provides two functions to interface with this process: kill/1 and echo/2.

Lab3.SupervisedPool is a supervisor module that uses Lab3.SupervisedWorker as a child process. It takes in the number of workers to spawn as an argument and creates a child specification for each worker. It then starts a supervisor process for these children, using the :one_for_one strategy. It provides a function get_workers/1 to get the list of children worker processes for the supervisor.

**Task 2**

```elixir
defmodule Lab3.ProcessingLine do
  use GenServer

  alias Lab3.ProcessingLineJoiner
  alias Lab3.ProcessingLineSpliter
  alias Lab3.ProcessingLineSwaper

  def init(_state) do
    Process.flag(:trap_exit, true)

    {:ok, spliter} = ProcessingLineSpliter.start_link(1, self())
    {:ok, swaper} = ProcessingLineSwaper.start_link(2, self())
    {:ok, joiner} = ProcessingLineJoiner.start_link(3, self())

    {:ok, {"",
      %{
        spliter => {1, ProcessingLineSpliter},
        swaper => {2, ProcessingLineSwaper},
        joiner => {3, ProcessingLineJoiner}
      }
    }}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_call({:get_next_worker, worker_id}, _receiver, {processing_word, workers}) do
    {next_worker, {_id, module}} = Enum.find(workers, fn {_k, {id, module}} -> id == worker_id + 1 end)

    {:reply, {next_worker, module}, {processing_word, workers}}
  end

  def handle_cast({:start_processing, str}, {processing_word, workers}) do
    {:noreply, {str, workers}}
  end

  def handle_info({:EXIT, pid, :killed}, {processing_word, workers}) do
    {failed_worker_id, failed_module} = Map.get(workers, pid)
    {:ok, new_pid} = failed_module.start_link(failed_worker_id, self())

    Process.sleep(10)

    if failed_worker_id == 1 do
      failed_module.process_message(new_pid, processing_word)
    else
      {first_worker_pid, {_, first_worker_module}} = Enum.find(workers, fn {_k, {id, module}} -> id == 1 end)
      first_worker_module.process_message(first_worker_pid, processing_word)
    end

    IO.inspect "Task fail at #{failed_module}"

    {:noreply, {processing_word, Map.delete(workers, pid) |> Map.put(new_pid, {failed_worker_id, failed_module})}}
  end

  def get_next_worker(pid, worker_id) do
    GenServer.call(pid, {:get_next_worker, worker_id})
  end

  def start_processing(pid, str) do
    GenServer.cast(pid, {:start_processing, str})
  end
end

defmodule Lab3.ProcessingLineSwaper do
  use GenServer

  alias Lab3.ProcessingLine

  def init(state) do
    {:ok, state}
  end

  def start_link(worker_id, processing_line_pid) do
    GenServer.start_link(__MODULE__, {worker_id, processing_line_pid})
  end

  def handle_cast({:process_message, data}, {worker_id, processing_line_pid}) do
    case :rand.uniform(2) do
      1 -> Process.exit(self(), :kill)
      2 -> nil
    end

    swapedStrs = Enum.map(data, fn str -> String.replace(str, ["m", "n"], fn ch ->
        case ch do
          "m" -> "n"
          "n" -> "m"
        end
      end)
    end)
    {next_worker, module} = ProcessingLine.get_next_worker(processing_line_pid, worker_id)

    module.process_message(next_worker, swapedStrs)

    {:noreply, {worker_id, processing_line_pid}}
  end

  def process_message(pid, data) do
    GenServer.cast(pid, {:process_message, data})
  end
end

defmodule Lab3.ProcessingLineSpliter do
  use GenServer

  alias Lab3.ProcessingLine

  def init(state) do
    {:ok, state}
  end

  def start_link(worker_id, processing_line_pid) do
    GenServer.start_link(__MODULE__, {worker_id, processing_line_pid})
  end

  def handle_cast({:process_message, data}, {worker_id, processing_line_pid}) do
    ProcessingLine.start_processing(processing_line_pid, data)

    case :rand.uniform(2) do
      1 -> Process.exit(self(), :kill)
      2 -> nil
    end

    splitedStr = String.split(data, ~r/\s+/)
    {next_worker, module} = ProcessingLine.get_next_worker(processing_line_pid, worker_id)

    module.process_message(next_worker, splitedStr)

    {:noreply, {worker_id, processing_line_pid}}
  end

  def process_message(pid, data) do
    GenServer.cast(pid, {:process_message, data})
  end
end

defmodule Lab3.ProcessingLineJoiner do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def start_link(worker_id, processing_line_pid) do
    GenServer.start_link(__MODULE__, {worker_id, processing_line_pid})
  end

  def handle_cast({:process_message, data}, {worker_id, _processing_line_pid}) do
    case :rand.uniform(2) do
      1 -> Process.exit(self(), :kill)
      2 -> nil
    end

    Enum.join(data, " ") |> IO.inspect

    {:noreply, worker_id}
  end

  def process_message(pid, data) do
    GenServer.cast(pid, {:process_message, data})
  end
end
```

This is a module that implements a processing line using GenServer in Elixir. The processing line consists of three worker processes: a spliter, a swaper, and a joiner.

In the init/1 function, the three worker processes are started and their PIDs are stored in a map with their corresponding IDs. Then, the map is returned as the initial state of the main process.

The handle_call/3 function is not used in this implementation.

The handle_cast/2 function of the ProcessingLineSpliter module receives a message with a string, splits it into words, and sends the resulting list of words to the next worker in the processing line.

The handle_cast/2 function of the ProcessingLineSwaper module receives a message with a list of strings, swaps all "m"s with "n"s and vice versa in each string, and sends the resulting list of strings to the next worker in the processing line.

The handle_cast/2 function of the ProcessingLineJoiner module receives a message with a list of strings, joins them into a single string separated by spaces, and prints the result to the console.

If any worker process crashes, the main process receives an EXIT message and restarts the failed process with a new PID.

The module provides two functions that can be called from other modules to start the processing line and send messages to it: start_link/0 and start_processing/2.

**Task 3**

```elixir
defmodule Lab3.MainSensorSupervisor do
  use GenServer

  alias Lab3.CabinSensor
  alias Lab3.ChassisSensor
  alias Lab3.MotorSensor
  alias Lab3.WheelsSensorSupervisor

  def init(_state) do
    Process.flag(:trap_exit, true)

    {:ok, cabinSensor} = CabinSensor.start_link(self())
    {:ok, chassisSensor} = ChassisSensor.start_link(self())
    {:ok, motorSensor} = MotorSensor.start_link(self())
    {:ok, wheelsSensorSupervisor} = WheelsSensorSupervisor.start_link(self())

    {:ok,
      {
        7,
        %{
          cabinSensor => {"CabinSensor", CabinSensor},
          chassisSensor => {"ChassisSensor", ChassisSensor},
          motorSensor => {"MotorSensor", MotorSensor}
        }
      }
    }
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_info({:EXIT, pid, :killed}, {sensors_down, sensors}) do
    {failed_sensor_id, failed_module} = Map.get(sensors, pid)
    sensors_down = sensors_down + 1

    IO.inspect "#{failed_sensor_id} failed"
    IO.inspect "[Sensors down: #{sensors_down}]"

    if sensors_down == 3 do
      deploy_airbag()
    else
      {:ok, new_pid} = failed_module.start_link(self())

      send(self(), {:update_failed_sensors, pid, new_pid})

      {:noreply, {sensors_down, sensors}}
    end

  end

  def handle_info({:update_failed_sensors, failed_pid, new_pid}, {sensors_down, sensors}) do
    {failed_sensor_id, failed_module} = Map.get(sensors, failed_pid)

    IO.inspect "#{failed_sensor_id} sensor failed"

    {:noreply, {sensors_down, Map.delete(sensors, failed_pid) |> Map.put(new_pid, {failed_sensor_id, failed_module})}}
  end

  def handle_info({:update_sensors, new_sensors}, {sensors_down, sensors}) do
    {:noreply, {sensors_down, Map.merge(sensors, new_sensors)}}
  end

  defp deploy_airbag() do
    IO.inspect("Airbags deployed")

    Process.exit(self(), :kill)
  end

  def handle_cast(:notify_sensor_up, {sensors_down, sensors}) do
    {:noreply, {sensors_down - 1, sensors}}
  end

  def handle_cast(:notify_sensor_down, {sensors_down, sensors}) do
    sensors_down = sensors_down + 1

    IO.inspect "[Sensors down: #{sensors_down}]"

    if sensors_down == 3 do
      deploy_airbag()
    else
      {:noreply, {sensors_down, sensors}}
    end
  end

  def notify_sensor_up(pid) do
    GenServer.cast(pid, :notify_sensor_up)
  end

  def notify_sensor_down(pid) do
    GenServer.cast(pid, :notify_sensor_down)
  end

  def update_failed_sensors(pid, failed_pid, new_pid) do
    send(pid, {:update_failed_sensors, failed_pid, new_pid})
  end

  def update_sensors(pid, new_sensors) do
    send(pid, {:update_sensors, new_sensors})
  end
end

defmodule Lab3.MotorSensor do
  use GenServer

  alias Lab3.MainSensorSupervisor

  def init(sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_up(sensor_supervisor_pid)

    measure()

    {:ok, sensor_supervisor_pid}
  end

  def start_link(sensor_supervisor_pid) do
    GenServer.start_link(__MODULE__, sensor_supervisor_pid)
  end

  def handle_info(:measure, sensor_supervisor_pid) do
    case :rand.uniform(5) do
      1 -> Process.exit(self(), :kill)
      _ -> nil
    end

    IO.inspect("Motor sensor performs measurement")

    measure()

    {:noreply, sensor_supervisor_pid}
  end

  defp measure() do
    Process.send_after(self(), :measure, 500)
  end
end

defmodule Lab3.CabinSensor do
  use GenServer

  alias Lab3.MainSensorSupervisor

  def init(sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_up(sensor_supervisor_pid)

    measure()

    {:ok, sensor_supervisor_pid}
  end

  def start_link(sensor_supervisor_pid) do
    GenServer.start_link(__MODULE__, sensor_supervisor_pid)
  end

  def handle_info(:measure, sensor_supervisor_pid) do
    case :rand.uniform(5) do
      1 -> Process.exit(self(), :kill)
      _ -> nil
    end

    IO.inspect("Cabin sensor performs measurement")

    measure()

    {:noreply, sensor_supervisor_pid}
  end

  defp measure() do
    Process.send_after(self(), :measure, 500)
  end
end

defmodule Lab3.WheelsSensorSupervisor do
  use GenServer

  alias Lab3.WheelSensor
  alias Lab3.MainSensorSupervisor

  def init(sensor_supervisor_pid) do
    Process.flag(:trap_exit, true)

    {:ok, wheel1} = WheelSensor.start_link(self())
    {:ok, wheel2} = WheelSensor.start_link(self())
    {:ok, wheel3} = WheelSensor.start_link(self())
    {:ok, wheel4} = WheelSensor.start_link(self())

    MainSensorSupervisor.update_sensors(sensor_supervisor_pid,
    %{
      wheel1 => {"Wheel1", WheelSensor},
      wheel2 => {"Wheel2", WheelSensor},
      wheel3 => {"Wheel3", WheelSensor},
      wheel4 => {"Wheel4", WheelSensor}
    })

    {:ok, sensor_supervisor_pid}
  end

  def start_link(sensor_supervisor_pid) do
    GenServer.start_link(__MODULE__, sensor_supervisor_pid)
  end

  def handle_info({:EXIT, pid, :killed}, sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_down(sensor_supervisor_pid)

    {:ok, new_pid} = WheelSensor.start_link(self())

    MainSensorSupervisor.update_failed_sensors(sensor_supervisor_pid, pid, new_pid)

    {:noreply, sensor_supervisor_pid}
  end

  def handle_cast(:notify_sensor_up, sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_up(sensor_supervisor_pid)

    {:noreply, sensor_supervisor_pid}
  end

  def notify_sensor_up(pid) do
    GenServer.cast(pid, :notify_sensor_up)
  end
end

defmodule Lab3.WheelSensor do
  use GenServer

  alias Lab3.WheelsSensorSupervisor

  def init(sensor_supervisor_pid) do
    WheelsSensorSupervisor.notify_sensor_up(sensor_supervisor_pid)

    measure()

    {:ok, sensor_supervisor_pid}
  end

  def start_link(sensor_supervisor_pid) do
    GenServer.start_link(__MODULE__, sensor_supervisor_pid)
  end

  def handle_info(:measure, sensor_supervisor_pid) do
    case :rand.uniform(5) do
      1 -> Process.exit(self(), :kill)
      _ -> nil
    end

    IO.inspect("Wheel sensor performs measurement")

    measure()

    {:noreply, sensor_supervisor_pid}
  end

  defp measure() do
    Process.send_after(self(), :measure, 500)
  end
end
```

This is a set of Elixir modules for a sensor supervisor system. There are four modules: Lab3.MainSensorSupervisor, Lab3.MotorSensor, Lab3.CabinSensor, and Lab3.WheelsSensorSupervisor.

The Lab3.MainSensorSupervisor is a GenServer module that supervises the other sensor modules. When a sensor fails, the supervisor handles the :EXIT message and starts a new process for the failed sensor. If three sensors fail, the supervisor deploys an airbag and kills itself.

The Lab3.MotorSensor and Lab3.CabinSensor modules are also GenServer modules that simulate the behavior of sensors. They periodically measure the state of the system and send the results to the supervisor.

The Lab3.WheelsSensorSupervisor is a GenServer module that supervises the Lab3.WheelSensor modules. It starts three instances of Lab3.WheelSensor and restarts them if they fail.

Overall, this system is designed to monitor the state of a vehicle's chassis, cabin, motor, and wheels. If too many sensors fail, the system will deploy an airbag to protect the driver.

**Task 4**

```elixir

```

This Elixir code represents the famous scene from Pulp Fiction where Jules interrogates Brett with the help of Brett's friend Marvin.

The code defines two modules: Lab3.Jules and Lab3.Brett. Jules is a GenServer process that starts a Brett process and then initiates a dialog with him by sending the first question. If Brett fails to provide a satisfactory answer, Jules starts a new Brett process and tries again. After five failed attempts, Jules threatens Brett by repeating his iconic "Say 'What' again!" line. If Brett still fails to provide a satisfactory answer after six attempts, Jules kills him. If Brett successfully answers all the questions, the dialog ends and Jules kills him anyway.

Brett is a GenServer process that stores a map of expected answers to Jules' questions. When Jules asks a question, Brett either provides the expected answer or responds with "What?" and fails, depending on the randomness of a generated number.

## P0W4

**Task 1**

```elixir
def get_quotes_headers_and_status() do
    url = "https://quotes.toscrape.com"

    {:ok, response} = HTTPoison.get(url)
    status_code = response.status_code
    headers = response.headers
    body = response.body

    IO.puts "Status code: #{status_code}"
    IO.puts "\nHeaders:\n"
    Enum.each(headers, fn {x, y} -> IO.inspect "#{x}: #{y}" end)
    IO.puts "\nBody:\n"
    IO.puts body
end
```

This is an Elixir function that sends an HTTP GET request to the website "https://quotes.toscrape.com" using the HTTPoison library. The function then extracts the status code, headers, and body of the response, and prints them to the console using IO.puts and IO.inspect.

The function can be used to demonstrate how to make an HTTP request using Elixir and how to extract information from the response. It is also useful for testing purposes, as it allows one to verify that the website is up and responding correctly, and to examine the headers and body of the response.

**Task 2**

```elixir
def extract_quotes() do
    url = "https://quotes.toscrape.com"

    {:ok, response} = HTTPoison.get(url)
    body = response.body

    {:ok, html} = Floki.parse_fragment(body)
    quotes = Floki.find(html, ".quote")

    Enum.map(quotes, fn {_, _, x} ->
      [quote_elem | rest] = x
      quote_content = hd(elem(quote_elem, 2))
      tags = Floki.find(rest, "a.tag") |> Enum.map(fn x -> hd(elem(x, 2)) end)

      %{:quote_text => String.slice(quote_content, 1..-2), :quote_tags => tags}
    end)
end
```

This function extracts quotes and their tags from the website "https://quotes.toscrape.com".

The function starts by sending a GET request to the website and retrieving the response body. Then, it uses Floki, an HTML parsing library for Elixir, to parse the HTML content.

The function then finds all the HTML elements with the class "quote" using Floki's find function. For each quote, it extracts the quote content and the associated tags. Finally, it maps over the list of quotes and returns a list of maps where each map contains the quote text and tags.

**Task 3**

```elixir
def persist_data(data) do
    json = Poison.encode!(data, pretty: true)

    File.write("quotes.json", json)
end
```

This function takes in some data and persists it to a file named "quotes.json" in JSON format. The data is first encoded into a JSON string using the Poison library's encode! function. The pretty: true option formats the JSON string with indentation and line breaks to make it more human-readable. Finally, the encoded JSON string is written to the file using the File.write function.

**Task 4**

```elixir
def spotify_actor_spawn() do
    {:ok, config} = File.read!("spotify_config.json") |> Poison.decode()

    spawn(fn -> spotify_actor_loop(config, nil, nil) end)
  end

  defp spotify_actor_loop(config, access_token, playlist_id) do
    receive do
      {:authenticate, sender} ->
        get_auth_code(config)
        access_token = IO.gets("") |> String.trim() |> Lab4.get_token(config)

        send(sender, :ok)

        spotify_actor_loop(config, access_token, playlist_id)

      :get_songs ->
        {:ok, response} = HTTPoison.get(
          "https://api.spotify.com/v1/me/tracks?offset=50",
          [{"Authorization", "Bearer #{access_token}"}]
        )

        {:ok, %{"items" => items}} = response.body |> Poison.decode()

        IO.inspect Enum.map(items, fn %{"track" => track} -> %{:track_name => track["name"], :track_id => track["id"]} end)

        spotify_actor_loop(config, access_token, playlist_id)

      {:add_song, song_id} ->
        song_id = String.trim(song_id)

        {:ok, response} = HTTPoison.post(
          "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks?uris=spotify:track:#{song_id}",
          "",
          [{"Authorization", "Bearer #{access_token}"}]
        )

        spotify_actor_loop(config, access_token, playlist_id)

      {:create_playlist, name, description} ->
        %{"user_id" => user_id} = config

        {:ok, response} = HTTPoison.post(
          "https://api.spotify.com/v1/users/#{user_id}/playlists",
          %{name: name, description: description, public: true} |> Poison.encode!(),
          [{"Content-Type", "application/json"}, {"Authorization", "Bearer #{access_token}"}]
        )

        {:ok, %{"uri" => uri}} = response.body |> Poison.decode()
        [_, _, playlist_id] = uri |> String.split(":")

        spotify_actor_loop(config, access_token, playlist_id)

      {:upload_image, img_path} ->
        {:ok, response} = HTTPoison.put(
          "https://api.spotify.com/v1/playlists/#{playlist_id}/images",
          img_to_base64(img_path),
          [{"Authorization", "Bearer #{access_token}"}]
        )

        spotify_actor_loop(config, access_token, playlist_id)
    end
  end

  def get_auth_code(config) do
    url = "https://accounts.spotify.com/authorize"

    %{
      "redirect_uri" => redirect_uri,
      "client_id" => client_id,
      "scope" => scope,
    } = config

    scope = String.replace(scope, " ", "%20")
    encoded_redirect_uri = URI.encode_www_form(redirect_uri)

    auth_url = "#{url}?response_type=code&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{encoded_redirect_uri}"

    IO.puts auth_url
  end

  def get_token(authorization_code, config) do
    url = "https://accounts.spotify.com/api/token"

    %{
      "redirect_uri" => redirect_uri,
      "client_id" => client_id,
      "client_secret" => client_secret,
      "grant_type" => grant_type,
    } = config

    {:ok, response} = HTTPoison.post(
      url,
      "grant_type=#{grant_type}&code=#{authorization_code}&redirect_uri=#{redirect_uri}",
      [
        {"Content-Type", "application/x-www-form-urlencoded"},
        {"Authorization", "Basic #{Base.encode64("#{client_id}:#{client_secret}")}"}
      ]
    )

    {:ok, body} = response.body |> Poison.decode()

    access_token = body["access_token"]

    access_token
  end

  def spotify_authenticate(pid, sender) do
    send(pid, {:authenticate, sender})
  end

  def spotify_get_songs(pid) do
    send(pid, :get_songs)
  end

  def spotify_create_playlist(pid, name, description) do
    send(pid, {:create_playlist, name, description})
  end

  def spotify_add_song(pid, song_id) do
    send(pid, {:add_song, song_id})
  end

  def spotify_upload_image(pid, img_path) do
    send(pid, {:upload_image, img_path})
  end
```

This is an implementation of a Spotify client in Elixir using actors. The code defines a Spotify actor loop that receives messages to perform various Spotify API operations, such as authenticating, getting songs, creating playlists, adding songs to a playlist, and uploading an image for a playlist.

The spotify_actor_spawn function spawns a new actor that will start the spotify_actor_loop function, passing it the Spotify configuration, access token, and playlist ID (initially set to nil).

The spotify_actor_loop function uses the receive expression to listen for messages. When it receives a :authenticate message, it calls the get_auth_code function to get an authentication code and use it to get an access token. It then sends an :ok message back to the sender and restarts the loop with the new access token.

When it receives a :get_songs message, it makes an HTTP GET request to the Spotify API to get the authenticated user's saved tracks, extracts the track name and ID from the response, and prints them to the console. It then restarts the loop with the same access token and playlist ID.

When it receives an :add_song message, it makes an HTTP POST request to the Spotify API to add a song to the specified playlist, using the provided access token and song ID. It then restarts the loop with the same Spotify configuration and playlist ID.

When it receives a :create_playlist message, it makes an HTTP POST request to the Spotify API to create a new playlist for the authenticated user, using the provided name, description, and access token. It extracts the new playlist ID from the response and restarts the loop with the same Spotify configuration and new playlist ID.

When it receives an :upload_image message, it makes an HTTP PUT request to the Spotify API to upload an image for the specified playlist, using the provided access token and image file path. It then restarts the loop with the same Spotify configuration and playlist ID.

The remaining functions (get_auth_code, get_token, spotify_authenticate, spotify_get_songs, spotify_create_playlist, spotify_add_song, and spotify_upload_image) are just convenience functions for sending messages to the Spotify actor loop.

**Task 5**

```elixir
defmodule Lab4.Database do
  use GenServer

  def init(_) do
    {:ok, movies} = File.read!("movies.json") |> Poison.decode()

    {:ok, movies}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def handle_call(:get_all, _from, movies) do
    {:reply, movies, movies}
  end

  def handle_call({:get_by_id, id}, _from, movies) do
    {:reply, Enum.find(movies, nil, fn %{"id" => value} -> value == id end), movies}
  end

  def handle_cast({:add_movie, title, release_year, director}, movies) do
    movie = %{
      "id" => length(movies) * 2 + 11,
      "title" => title,
      "release_year" => release_year,
      "director" => director,
    }

    {:noreply, movies ++ [movie]}
  end

  def handle_cast({:update_movie, id, title, release_year, director}, movies) do
    movie = %{
      "id" => id,
      "title" => title,
      "release_year" => release_year,
      "director" => director,
    }

    {:noreply, Enum.filter(movies, fn %{"id" => value} -> value != id end) ++ [movie]}
  end

  def handle_cast({:delete_movie, id}, movies) do
    {:noreply, Enum.filter(movies, fn %{"id" => value} -> value != id end)}
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  def get_by_id(id) do
    GenServer.call(__MODULE__, {:get_by_id, id})
  end

  def add_movie(title, release_year, director) do
    GenServer.cast(__MODULE__, {:add_movie, title, release_year, director})
  end

  def update_movie(id, title, release_year, director) do
    GenServer.cast(__MODULE__, {:update_movie, id, title, release_year, director})
  end

  def delete_movie(id) do
    GenServer.cast(__MODULE__, {:delete_movie, id})
  end
end

defmodule Lab4.Api do
  use Plug.Router

  alias Lab4.Database

  plug(:match)
  plug(:dispatch)

  get "/movies" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Database.get_all() |> Poison.encode!())
  end

  get "/movies/:id" do
    movie =
      conn.path_params["id"]
      |> String.to_integer()
      |> Database.get_by_id()

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, movie |> Poison.encode!())
  end

  post "/movies" do
    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok,
     %{
       "title" => title,
       "release_year" => release_year,
       "director" => director
     }} = body |> Poison.decode()

    Database.add_movie(title, release_year, director)

    send_resp(conn, 201, "")
  end

  put "/movies/:id" do
    id =
      conn.path_params["id"]
      |> String.to_integer()

    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok,
     %{
       "title" => title,
       "release_year" => release_year,
       "director" => director
     }} = body |> Poison.decode()

    Database.update_movie(id, title, release_year, director)

    send_resp(conn, 200, "")
  end

  delete "/movies/:id" do
    conn.path_params["id"]
    |> String.to_integer()
    |> Database.delete_movie()

    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

defmodule Lab4.Start do
  alias Lab4.Database
  alias Lab4.Api

  def run do
    {:ok, _} = Database.start_link()
    {:ok, _} = Plug.Cowboy.http(Api, [])

    IO.puts("The server started on port 4000")
  end
end

```

This code defines three modules: Lab4.Database, Lab4.Api, and Lab4.Start.

The Lab4.Database module uses the GenServer behavior to define a server that reads a JSON file of movies and provides functions to get, add, update, and delete movies from its state. The start_link function is used to start the server, and the other functions are used to handle calls and casts to the server.

The Lab4.Api module uses the Plug.Router behavior to define an HTTP server that provides RESTful endpoints to interact with the Lab4.Database server. The get, post, put, and delete functions are used to define the endpoints, which call the corresponding functions in the Lab4.Database module to get, add, update, or delete movies.

The Lab4.Start module is used to start the Lab4.Database and Lab4.Api servers and prints a message to the console when they have started.

Overall, this code is an example of how to create an HTTP server using the Plug library and a stateful server using the GenServer behavior, and how to use them together to create a RESTful API.

## Pros and Cons

### Pros

- The implementation uses GenServers, which makes it easy to manage and manipulate the nodes in the list.
- The use of messages to communicate between nodes allows for concurrency and non-blocking I/O.
- The use of a functional language like Elixir makes the implementation concise and easy to understand.
- The use of GenServer allows for concurrency and scalability, which is important when dealing with a large number of requests.
- The use of Poison for encoding and decoding JSON data simplifies the handling of JSON data in the application.
- The separation of concerns between the database module and the API module allows for easier maintenance and testing of the application.

### Cons

- The implementation may not be as performant as a more traditional implementation of a doubly linked list.
- The use of GenServers may add additional overhead and complexity to the implementation.
- The implementation uses a JSON file as the data store, which may not be suitable for large-scale or high-traffic applications.
- The application does not have any authentication or authorization mechanisms, which may be a security concern.
- The error handling is limited, and the application does not provide meaningful error messages to the client in case of failures.

## Conclusion

Throughout my journey of exploring the actor model and functional programming paradigm, I have gained extensive knowledge about the principles, concepts, and techniques of these approaches. Although it was initially challenging to adapt to these new programming paradigms, I persevered and developed proficiency in using them. Furthermore, I have learned the fundamentals of Elixir programming language, and I have even developed a functional REST API that can communicate with Spotify API, which is a significant accomplishment for me. Overall, this experience has been a valuable learning opportunity for me, and I look forward to continuing to improve my skills in these areas.

## Bibliography

1. String: https://hexdocs.pm/elixir/String.html
2. Map: https://hexdocs.pm/elixir/Map.html
3. GenServer: https://hexdocs.pm/elixir/GenServer.html
4. Supervisor: https://hexdocs.pm/elixir/Supervisor.html
5. Enum: https://hexdocs.pm/elixir/Enum.html
6. Plug: https://hexdocs.pm/plug/readme.html
7. Poison: https://hexdocs.pm/poison/readme.html
8. HTTPoison: https://hexdocs.pm/httpoison/readme.html
