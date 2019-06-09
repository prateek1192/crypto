defmodule Person do
  use GenServer

  #def init({private_key, public_key, num_of_coins}) do
  def init(initial_state) do
    {:ok, initial_state}  
  end

  #def start_link({private_key, public_key, num_of_coins}) do
  def start_link(initial_state) do
    IO.puts "Module Person: method:start_link Starting a person"
    GenServer.start_link(
      __MODULE__,
      #{private_key, public_key, num_of_coins},
      #initial_state,
      initial_state 
      #name: {:global, "node:#{inital_state["public_key"]}"}
    )
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get_public_key},_from, initial_state) do
    {:reply, initial_state[:public_key], initial_state}
  end

  def handle_call({:update_utxo, new_utxo},_from, initial_state) do
    initial_state = %{initial_state | utxo: new_utxo}
    #IO.inspect initial_state, label: "The state is "
    {:reply, initial_state[:public_key], initial_state}
  end

  def handle_call({:update_genesis_blockchain, chain},_from, initial_state) do
    initial_state = %{initial_state | chain: chain}
    #IO.inspect initial_state, label: "The state is "
    {:reply, initial_state[:public_key], initial_state}
  end

  def handle_cast({:mine_block, chain}, initial_state) do 

    IO.inspect self(), label: "Starting mining at pid : "
    chain = Blockchain.insert(initial_state[:chain], chain)
    PersonManager.update_blockchain(chain, self())
    {:noreply, initial_state}  
  end

  def handle_cast({:update_blockchain, chain}, initial_state) do
    tx_ids = Enum.map(initial_state[:chain], fn (x) -> Map.get(x, :id) end)
    new_tx_ids = Enum.map(chain, fn (x) -> Map.get(x, :id) end)
    if Enum.sort(tx_ids) != Enum.sort(new_tx_ids) do
        initial_state = %{initial_state | chain: chain}
        IO.inspect initial_state, label: "Blockchain updated "
    end
    {:noreply, initial_state}
  end

  #def handle_call({:update_blockchain, chain},_from, initial_state) do
  #  initial_state = %{initial_state | chain: chain}
  #  IO.inspect initial_state, label: "Blockchain updated "
  #  {:noreply, initial_state}
  #end

  def handle_call({:allow_sleep},_from, initial_state) do
    IO.puts "This method is just there to allow all transactions complete and for us to see all the logs properly. "
    {:reply, initial_state[:public_key], initial_state}
  end

end
