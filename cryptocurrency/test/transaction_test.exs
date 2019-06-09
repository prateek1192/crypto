defmodule TransactionTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "generate two different keypairs and transfer money between them" do
    
    {public_key1, private_key1} = Keypair.generate()
    {public_key2, private_key2} = Keypair.generate()

    chain = Blockchain.new
    {coinbase_transaction, utxo} = Transaction.getCoinbaseTransaction(public_key1, 1)
    assert 10000 == Transaction.getBalance(utxo, public_key1)
    assert 0 == Transaction.getBalance(utxo, public_key2)
    chain = chain |> Blockchain.insert(coinbase_transaction)

    txIn = %Transaction.TxInput{
      out_id: "dummy",
      out_index: 1234,
      signature: "dummy",
    }
    txOut = %Transaction.TxOutput{
      address: public_key2,
      amount: 80.0
    }
    tx = %Transaction.Tx{
      inputs: [txIn],
      outputs: [txOut]
    }
    txId = Transaction.get_transaction_id(tx)
    new_tx = %Transaction.Tx{
      inputs: [txIn],
      outputs: [txOut],
      id: txId
    }
    utxo_new = Transaction.update_unspent_tx_outputs([new_tx], utxo)


    
    assert 80 == Transaction.getBalance(utxo_new, public_key2)
    
  end
end
