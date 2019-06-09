defmodule AddressTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "generate the genesis block of the blockchain" do
    chain = Blockchain.new
    head_chain = hd(chain)
    assert head_chain.prev_hash == Block.genesis_block.prev_hash
  end

  test "Test adding of block and checking if the prev_hash matches the current hash" do
  	chain = Blockchain.new
  	chain = Blockchain.insert(chain, "New_message")
  	chain = chain |> Blockchain.insert("My Message") |> Blockchain.insert("Final Message")

  	[head | one_less_head] = chain
  	[second_head | two_less_head ] = one_less_head

  	assert head.prev_hash == second_head.hash
  	assert String.slice(head.hash, 0..1) == "00"
  	assert String.slice(head.prev_hash, 0..1) == "00"

  end
end