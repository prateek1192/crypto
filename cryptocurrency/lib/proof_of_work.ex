defmodule ProofOfWork do

  def getNonce(timestamp, prev_hash, data, len \\ 9) do
    nonce   = :crypto.strong_rand_bytes(len) |> Base.url_encode64 |> binary_part(0, len) |> String.downcase
    message = timestamp <> prev_hash <> inspect(data) <> nonce
    hash    = :crypto.hash(:sha256, message) |> Base.encode16 |> String.downcase
    cond do
      String.slice(hash, 0..1) == "00" -> {hash, nonce}
      true -> getNonce(timestamp, prev_hash, data, 9)
    end
  end
end
  
