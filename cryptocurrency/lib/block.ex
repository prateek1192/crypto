defmodule Block do
  defstruct [:data, :timestamp, :prev_hash, :hash, :nonce]

  def new(data, prev_hash) do
    timestamp = NaiveDateTime.utc_now |> NaiveDateTime.to_string()
    {hash, nonce} = ProofOfWork.getNonce(timestamp, prev_hash, data, 9)
    %Block{
      data: data,
      prev_hash: prev_hash,
      timestamp: timestamp,
      nonce: nonce
    }
  end

  def genesis_block do
    timestamp = NaiveDateTime.utc_now |> NaiveDateTime.to_string()
    prev_hash = "ZERO_HASH"
    data = "ZERO_DATA"
    {hash, nonce} = ProofOfWork.getNonce(timestamp, prev_hash, data, 9)
    #IO.inspect hash, label: "The hash being returned is"
    %Block{
      data: data,
      prev_hash: prev_hash,
      timestamp: timestamp,
      nonce: nonce
    }
  end
end
