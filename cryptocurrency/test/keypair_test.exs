defmodule KeypairTest do
  use ExUnit.Case


  describe "generate" do
    test "generates a private public Keypair with " do
      assert {public_key, private_key} = Keypair.generate()
      assert is_binary(public_key)
      assert is_binary(private_key)
    end
  end

  describe "to_public_key" do
    test "Reversing of public to private keys not possible, negative test case" do
      {public_key, _private_key} = Keypair.generate()
      {_public_key, private_key} = Keypair.generate()
      refute public_key == Keypair.to_public_key(private_key)
    end

    test "positive test case, conversion of public to private key" do
      {public_key, private_key} = Keypair.generate()
      assert public_key == Keypair.to_public_key(private_key)
    end
  end
end
