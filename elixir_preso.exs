# So anyone used Elixir?



# Let's start with a story...


# ???
# What are the cool bits?
# How does it work?
# When would it use it?



# Erlang VM (scalable, distributed, fast)
# (WhatsApp 2M connections/node, WoW, FB Chat)
# Actor model
# Distribution across nodes


# Functional, but not so pure it...



# No mutable state
# Pattern matching
# No monads



# Created by José Valim circa 2012. 
# Former Rails Core Team member.



# Love child of Ruby & Erlang
# Good looks of Ruby and the muscle of Erlang
# Call Erlang libs, compiled to BEAM bytecode



# Install
[mac: "brew install elixir", windows_choclatey: "cinst elixir", windows_installer: "Click next, next, ..., finish"]



# Let's get started on the language...


# Functional rather than OO ( data separate to functions )
# Modules rather than classes

IO.puts "hello world"
String.capitalize("james")
String.length("hello")



# Kernel module is imported automatically and gives types, core functionality,
hd [1,2,3]
tl [1,2,3]



# Equip with a few basics... 


# Linked lists
[1,2,3] ++ [4,5,6]

# Tuples
tuple = {1,2,3}
put_elem(tuple, 1, "fred")

# Atoms
my_atoms = {:a, :b, :c, :d}

args = [{:a, 1}, {:b, 2}]

query = from w in Weather,
      where: w.prcp > 0,
      where: w.temp < 20,
      select: w

# regex
"HELLO" =~ ~r/hello/i

# hashes
map = %{:a => 1, 2 => :b}


# combos
users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]

# structs

defmodule User do
  defstruct name: '', age: nil
end

james = %User{name: "James", age: 21}



# anonymous functions

Enum.map([1, 2, 3], fn x -> x * 2 end)

doubler = fn x -> x * 2 end
doubler.(5)



# methods/modules

defmodule Demo do
  def greet(name) do
    "Hi #{name}!"
  end
end


defmodule IGotPrivates do
  def do_the_thing, do: private_thing
  defp private_thing, do: IO.puts("private hi")
end



# attributes & behaviours

# Behaviours like interfaces
defmodule Parser do
  @callback parse(String.t) :: {:ok, term} | {:error, String.t}
  @callback extensions() :: [String.t]
end

defmodule JSONParser do
  @behaviour Parser

  def parse(str), do: # ... parse JSON
  def extensions, do: ["json"]
end

# type checking
# static analysis with Dialyzer 
@spec round(number) :: integer
def round(number), do: # implementation...



# More special...


# = match

{a, b, c} = {:hello, "world", 42}

{:ok, result} = {:ok, 13}

{:ok, result} = {:fail, 100}

[head | tail] = [1, 2, 3]

[head | tail] = []

x = 1 
{y, ^x} = {2, 1} # pinning




# control flow

# if / else / unless / case 

defmodule Demo do
  def greet(name) do
    cond do
      name == "altnet"        -> "hi everyone at altnet"
      name == ""              -> "No name"
      String.length(name) > 6 -> "some other place"
    end
  end
end



# pattern matching functions

defmodule Demo do
  def greet("altnet"), do: "hi everyone at altnet!"
  def greet(""), do: "No name!"
end


defmodule Fib do 
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end
end


# pattern matching and files

case File.read "hello.txt" do
  {:ok, body}      -> IO.puts "Success: #{body}"
  {:error, reason} -> IO.puts "Oh NOES!! An ERROR! #{reason}"
end


# guards

defmodule Demo do
  def larger_than_two?(n) when n > 2 do
    true
  end

  def larger_than_two?(n) do
    false
  end
end



# fancy functions and pipes

odd? = &(rem(&1, 2) != 0)
1..10 |> Enum.filter(odd?) |> Enum.sum
1..10 |> Enum.filter(odd?) |> IO.inspect |> Enum.sum




# streams / infinites
stream = Stream.cycle([1, 2, 3])
Enum.take(stream, 100)

stream = File.stream!("path/to/file")



# list comprehensions

for n <- 1..4, do: n * n

# a*a + b*b = c*c
defmodule Triple do
  def pythagorean(n) when n > 0 do
    for a <- 1..n,        # generator
        b <- 1..n,        # generator
        c <- 1..n,        # generator
        a + b + c <= n,   # filter
        a*a + b*b == c*c, # filter
        do: {a, b, c}     # collectable
  end
end

Triple.pythagorean(12)



# Fancy pants metaprogramming 

expr = quote do
  langth([1,2,3])
end

IO.inspect(expr)

Code.eval_quoted(expr)

expr = put_elem(expr, 0, :length)

Code.eval_quoted(expr)




# ACTOR MODEL & PROCESSES (and state!)


# new process

spawn fn -> 1 + 2 end

for num <- 1..1000, do: spawn fn -> IO.puts "#{num * 2}" end

spawn_link fn -> raise "oops" end

Task.start fn -> raise "oops" end


# mailboxes
send self, "hi"
send self, "g'day"
send self, "bye"

receive do
  "hello" -> IO.write("hello it's me")
  "bye" -> IO.write("byeee")
end

flush


defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end

{:ok, pid} = KV.start_link

send pid, {:put, :altnet, "is cool"}
flush

send pid, {:get, :altnet, self()}
send pid, {:get, :altnet, self()}
flush


Process.register(pid, :kv)
send :kv, {:get, :altnet, self()}


# abstractions..

# Agent - Simple wrappers around state.
{:ok, pid} = Agent.start_link(fn -> %{} end, name: :kv2)
Agent.update(:kv2, fn map -> Map.put(map, :hello, :world) end)
Agent.get(:kv2, fn map -> Map.get(map, :hello) end)


# GenServer - “Generic servers”, Agent + more control, async etc





# Stateless.. ???????!




# !! State as nanoservices !!
# App = lots and lots of these spread across nodes




# Non web app..
# Registry for processes
# Supervisor 
# Routers for sharding, distributed nodes etc




# Buld tooling: MIX
# Cake/psake/msbuild/VS

mix new kv --module KV
mix test
mix help



# PHOENIX

# Install
mix local.hex # pkg mgr
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# create app
mix phoenix.new hello_phoenix --database mysql
mix ecto.create # setup db



# run server
mix phoenix.server


# files
router.ex
page_controller.ex
index.html.eex
index_with_params.html.eex
page_controller_test.ex

http://localhost:4000/
http://localhost:4000/index_with_error
http://localhost:4000/index_with_params?name=alt.net



## Resources

https://github.com/jcrisp/elixir_preso

https://elixir-lang.org/getting-started/

https://hexdocs.pm/phoenix/overview.html



























































## Pre-Setup
CREATE USER 'phoenix'@'localhost';
GRANT ALL PRIVILEGES ON hello_phoenix_dev.* to 'phoenix'@'localhost' 

