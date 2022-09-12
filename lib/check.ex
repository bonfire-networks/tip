if Code.ensure_loaded?(ProtocolEx) do
  import ProtocolEx

  defprotocol_ex Tip.Check do
    def check(type, data)
  end
end
