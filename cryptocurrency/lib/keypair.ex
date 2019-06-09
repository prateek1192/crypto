defmodule Keypair do
  
  def generate() do
    :crypto.generate_key(:ecdh, :secp256k1)
  end

  def to_public_key(private_key) do
    private_key
    |> String.valid?()
    |> is_encoded(private_key)
    |> generate_key()
  end

  defp is_encoded(true, private_key), do: Base.decode16!(private_key)
  defp is_encoded(false, private_key), do: private_key

  defp generate_key(private_key) do
    with {public_key, _private_key} <-
           :crypto.generate_key(:ecdh, :secp256k1, private_key),
         do: public_key
  end
end
