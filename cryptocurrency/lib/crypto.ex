defmodule Crypto do

  @hash_fields [:data, :timestamp, :prev_hash, :nonce]

  def hash(%{} = block) do
    new_block = Map.take(block, @hash_fields)
    #IO.inspect new_block  , label: "The map is"
    message = new_block[:timestamp] <> new_block[:prev_hash] <> inspect(new_block[:data]) <> new_block[:nonce]
    hash = :crypto.hash(:sha256, message) |> Base.encode16 |> String.downcase
  end

  def put_hash(%{} = block) do
    %{ block | hash: hash(block) }
  end

  def sha256(binary) do
    :crypto.hash(:sha256, binary) |> Base.encode16
  end

end
