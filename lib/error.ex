defmodule Tip.Error do
  defexception [:data, :type]

  def exception(opts) do
    data = Keyword.get(opts, :data)
    type = Keyword.get(opts, :type)
    %Tip.Error{data: data, type: type}
  end
  
  def message(%{data: d, type: t}), do: "#{inspect(d)} is not of type #{inspect(t)}"
  
end
