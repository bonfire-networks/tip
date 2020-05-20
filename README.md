# Tip

Less than a type system, just the tip of the typeberg.

A minimal runtime type checker for elixir with toggleable checks.

## Status: experimental

New, possibly buggy, definitely badly tested.

## Usage

The heart of this library is the `Tip.the/2` macro. By default, it
returns the data unchanged:

```
❯ iex -S mix
iex(1)> import Tip
Tip
iex(2)> the Atom, []
[]
```

When explicitly enabled, it asserts the type matches:

```
iex(3)> Application.put_env(Tip, :enabled, true) 
:ok
iex(4)> the List, []
[]
iex(5)> the Atom, []
** (Tip.Error) ********************
Context: (no module)
Location: iex:5
Expected type: Atom
Got data: []

    (tip 0.1.0) lib/tip.ex:87: Tip.check!/3
```

## Installation

Dependency: `{:tip, "~> 0.1"}`

Configuration (dev and test): `config Tip, enabled: true`

Compiler registration (protocol_ex):

```elixir
def project do
  [ # ...
    compilers: Mix.compilers ++ [:protocol_ex],
    # ...
  ]
end
```

## Predefined types:

* (anonymous function) - A value for which the function returns a truthy result.
* `Atom` - An atom.
* `BitString` - A bitstring or binary.
* `Float` - A float
* `Float.Positive` - A positive float.
* `Float.Negative` - A negative float.
* `Float.NonNegative` - A float that is not negative.
* `Float.NonPositive` - A float that is not positive.
* `Function` - A function.
* `{Function, arity} when is_integer(arity) and arity >= 0` - A function with given arity.
* `Integer` - An integer.
* `Integer.Positive` - A positive integer.
* `Integer.Negative` - A negative integer.
* `Integer.NonNegative` - An integer that is not negative.
* `Integer.NonPositive` - An integer that is not positive.
* `List` - A list.
* `{List, size} when is_integer(size) and size >= 0` - A list of given size.
* `{List, of}` - A list where all elements are of type `of`.
* `Map` - A map.
* `{Map, k, v}` - A map where keys are of type `k` and values are of type `v`.
* `Pid` - A process ID.
* `Port` - A port.
* `Reference` - A reference.
* `Struct` - A struct.
* `Tuple` - A tuple.
* `{Tuple, size} when is_integer(size) and size >= 0` - A tuple of size `size`.
* `{Tuple, of} when is_list(of)` - A tuple of size count(of) where the
  items in the tuple match the predicates in the list `of`, one per field.

## Registering a type

The type `Atom` is very simple to define:

```elixir
defimpl_ex Atom, Atom, for: Tip.Check do
  def check(Atom, x), do: is_atom(x)
end
```

Let's break that apart...

`defimpl_ex Atom` - an implementation named `Atom` (names must be globally unique)

`Atom` - the first argument must match `Atom`

`for: Tip.Check` - the protocol_ex we are implementing is `Tip.Check`

`def check` - we are implementing the method `check`

`(Atom, x)` - which takes `Atom` and x as arguments

`do: is_atom(x)` - and returns whether x is an atom.

Let's try something slightly more complicated:

```elixir
defimpl_ex Tuple.Sized, {Tuple, n} when is_integer(n) and n >= 0, for: Tip.Check do
  def check({Tuple.Sized, size}, x), do: is_tuple(x) and tuple_size(x) == size
end
```

`defimpl_ex Tuple.Sized` - an implementation named `Tuple.Sized`

`{Tuple, n} when is_integer(n) and n >= 0` - the first argument must
   match `{Tuple, n}` where n is a non-negative integer.

`for: Tip.Check` - the protocol_ex we are implementing is `Tip.Check`

`def check` - we are implementing the method `check`

`({Tuple.Sized, n}, x)` - which takes `{Tuple, n}` and x as arguments

`do: is_tuple(x) and tuple_size(x) == size` - and returns whether x is
  a correctly-sized tuple.

There are many more implementations in `lib/tips.ex` to see.

## Notes

This library is experimental. It may not make it to 1.0.

## Performance?

Rendering an error might be a little expensive if you're asserting a
large data structure because we use `inspect`.

I had wanted to compile away the code completely in production but
`mix` compiles all libraries in `:prod`. Accordingly, there are some
runtime costs we pay even when disabled:

* A function call.
* A call to `Application.get_env/3`.

It isn't much, but it's annoying.

## Copyright and License

Copyright (c) 2020 Tip contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
