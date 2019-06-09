  defmodule Transaction do
  defmodule Tx do
    defstruct id: nil, inputs: [], outputs: []
  end

  defmodule TxOutput do
    defstruct address: nil, amount: 0
  end

  defmodule TxInput do
    defstruct out_id: nil, out_index: 0, signature: nil
  end

  defmodule UnspentTxOutput do
    defstruct out_id: nil, out_index: 0, address: nil, amount: 0
  end

  def get_transaction_id(%Tx{inputs: inputs, outputs: outputs}) do
    #IO.puts "Starting get_transaction_id"
    #IO.puts Integer.to_string(inputs.out_index)
    #IO.inspect inputs.out_id, label: "The input.out_id is "
    #IO.puts "After printing input params"
    txInContent =
      inputs
      |> Enum.map(fn input -> input.out_id <> Integer.to_string(input.out_index) end)
      |> Enum.reduce("", fn a, b -> a <> b end)
    #IO.puts "After Inputs"
    txOutContent =
      outputs
      |> Enum.map(fn output -> output.address <> Float.to_string(output.amount) end)
      |> Enum.reduce("", fn a, b -> a <> b end)

    :crypto.hash(:sha, txInContent <> txOutContent)
  end

  def getCoinbaseTransaction(address, blockIndex) do
    
    #IO.inspect address, label: "The address is "
    #IO.inspect blockIndex, label: "The Block Index is" 
    txIn = %TxInput{
      out_id: "dummy",
      out_index: 1234,
      signature: "dummy",
    }
    #IO.puts "TxIn assigned"

    txOut = %TxOutput{
      address: address,
      amount: 10000.0
    }
    #IO.puts "TxOut assigned"

    tx = %Tx{
      inputs: [txIn],
      outputs: [txOut]
    }
    #IO.puts "Tx created"  
    txId = get_transaction_id(tx)
    #IO.inspect txId, label: "The transaction id is"
    new_tx = %Tx{
      inputs: [txIn],
      outputs: [txOut],
      id: txId
    }
    utxo = %UnspentTxOutput{
      out_id: txId,
      out_index: blockIndex,
      address: address,
      amount: 10000
    }
    {new_tx, [utxo]}
  end

  def find_unspent_tx_output(transaction_id, index, unspent_tx_outs)
      when is_list(unspent_tx_outs) do
    unspent_tx_outs
    |> Enum.find(fn utx -> utx.out_id == transaction_id and utx.out_index == index end)
  end

  def update_unspent_tx_outputs(new_transactions, unspent_tx_outputs) do

    #IO.inspect new_transactions, label: "The value of new trnasactions is"
    #IO.inspect unspent_tx_outputs, label: "The Unspent tx_outputs in the beginning is"
    new_unspent_tx_outputs =
      new_transactions
      |> Enum.map(fn %Tx{id: tx_id, outputs: tx_outputs} ->
        tx_outputs
        |> Enum.with_index()
        |> Enum.map(fn {output, index} ->
          %UnspentTxOutput{
            out_id: tx_id,
            out_index: index,
            address: output.address,
            amount: output.amount
          }
        end)
      end)
      |> Enum.flat_map(& &1)

      #IO.inspect new_unspent_tx_outputs, label: "The new Unspent tx_outputs is"

    consumed_tx_outputs =
      new_transactions
      |> Enum.map(fn %Tx{inputs: tx_inputs} -> tx_inputs end)
      |> Enum.flat_map(& &1)
      |> Enum.map(fn %TxInput{out_id: out_id, out_index: out_index} ->
        %UnspentTxOutput{out_id: out_id, out_index: out_index}
      end)

      #IO.inspect consumed_tx_outputs, label: "The consumed tx_outputs is"

    original_unspent_tx_outputs =
      unspent_tx_outputs
      |> Enum.filter(fn %UnspentTxOutput{out_id: out_id, out_index: out_index} ->
        find_unspent_tx_output(out_id, out_index, consumed_tx_outputs) == nil
      end)

    IO.inspect original_unspent_tx_outputs, label: "The original_unspent_tx_outputs before updation is"

    original_unspent_tx_outputs ++ new_unspent_tx_outputs

    IO.inspect original_unspent_tx_outputs ++ new_unspent_tx_outputs, label: "The original_unspent_tx_outputs after updation is"
  end

  def getBalance(utxo, public_key) do
    
    balance =
    Enum.filter(utxo, fn %UnspentTxOutput{address: address} ->
        address == public_key
      end)
    |>
    Enum.map(fn %UnspentTxOutput{amount: amount} -> amount end)
    |>
    Enum.sum()

  end
end
