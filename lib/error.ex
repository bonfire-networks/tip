defmodule Tip.Error do
  defexception [:data, :type, :env]

  def message(%Tip.Error{data: data, type: type, env: env}) do
    # Top line short 15 characters as that's how wide the prelude of
    # this error is when printed with the current elixir compiler.
    """
    ********************
    Context: #{module(env)}#{context(env)}
    Location: #{file(env)}#{line(env)}
    Expected type: #{inspect(type)}
    Got data: #{inspect(data)}
    """
  end

  defp module(%{module: nil}), do: "(no module)"
  defp module(%{module: m}), do: inspect(m)

  defp context(%{function: nil}), do: ""
  defp context(%{function: {fun, arity}}), do: ".#{fun}/#{arity}"

  defp file(%{file: nil}), do: "(interactive)"
  defp file(%{file: name}), do: name

  defp line(%{line: nil}), do: ""
  defp line(%{line: line}), do: ":#{line}"
end
