defmodule Tip do
  @moduledoc """
  Tip is a basic apparatus for performing type checks during
  development and test. It does not replace the need to write type
  checks in the code, it merely provides you with a convenient
  assertive style and a framework for thinking with types.

  Tip's basic types correspond roughly to the types that are
  recognised by Elixir protocols, which are the names of struct
  modules and the following special types:

  * `Tuple`
  * `Atom`
  * `List`
  * `BitString`
  * `Integer`
  * `Float`
  * `Function`
  * `Pid`
  * `Map`
  * `Port`
  * `Reference`
  * `Any`

  You may, however, define any types arbitrarily by implementing the
  `Tip.Check` ProtocolEx. Here are a few custom types we ship:

  * `Nil` - Nil
  * `Truthy` - Not nil or false
  * `Falsy` - Nil or false
  * `{Tuple, count :: non_neg_integer}` - tuple of N items
  * `{Function, arity :: non_neg_integer}` - function of arity
  * `{List, of :: type}` - List of a given type

  ### A note on taste

  We don't advise overly strict testing of types. For example, if you
  were given a list of ints and you wanted a list of binaries, it
  might make more sense to delay the checking of the contents for
  clarity of error messaging.
  """

  @doc "The type of something as used by Protocol determination"
  def prototype(%struct{}), do: struct
  def prototype(t) when is_tuple(t), do: Tuple
  def prototype(a) when is_atom(a), do: Atom
  def prototype(l) when is_list(l), do: List
  def prototype(b) when is_bitstring(b), do: BitString
  def prototype(i) when is_integer(i), do: Integer
  def prototype(f) when is_float(f), do: Float
  def prototype(f) when is_function(f), do: Function
  def prototype(p) when is_pid(p), do: Pid
  def prototype(%{}), do: Map
  def prototype(p) when is_port(p), do: Port
  def prototype(r) when is_reference(r), do: Reference
  def prototype(_), do: Any

  if Code.ensure_loaded?(ProtocolEx) do
    @spec check(type :: term, data :: term) ::
            {:ok, data :: term} | {:error, Tip.Error.t()}
    defmacro check(type, data) do
      caller = caller_info(__CALLER__)

      quote do
        Tip.check(unquote(type), unquote(data), unquote(caller))
      end
    end

    @spec check!(type :: term, data :: term) :: term
    defmacro check!(type, data) do
      caller = caller_info(__CALLER__)

      quote do
        Tip.check!(unquote(type), unquote(data), unquote(caller))
      end
    end

    @doc false
    def check(type, data, caller) do
      if Tip.Check.check(type, data),
        do: {:ok, data},
        else: {:error, Tip.Error.exception(type: type, data: data, env: caller)}
    end

    @doc false
    def check!(type, data, caller) do
      if Tip.Check.check(type, data),
        do: data,
        else: raise(Tip.Error, type: type, data: data, env: caller)
    end

    @doc """
    A config-disable-able type assertion that matches the type and
    data, returning the data.

    The name is taken from Idris, if you were wondering
    """
    @spec the(type :: term, data :: term) :: data :: term
    defmacro the(type, data) do
      caller = caller_info(__CALLER__)

      quote do
        Tip.the(unquote(type), unquote(data), unquote(caller))
      end
    end

    @doc false
    def the(type, data, env) do
      if Application.get_env(Tip, :enabled, false),
        do: Tip.check!(type, data, env),
        else: data
    end

    defp caller_info(caller) do
      quote do
        %{
          module: unquote(caller.module),
          function: unquote(caller.function),
          file: unquote(caller.file),
          line: unquote(caller.line)
        }
      end
    end
  end
end
