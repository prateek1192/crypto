defmodule Blockchain do
  def new do
    [ Crypto.put_hash(Block.genesis_block) ]
  end

  def insert(blockchain, data) when is_list(blockchain) do
    %Block{hash: prev} = hd(blockchain)

    block =
      data
      |> Block.new(prev)
      |> Crypto.put_hash
    [ block | blockchain ]
  end
end