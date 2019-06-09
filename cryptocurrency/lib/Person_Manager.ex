defmodule PersonManager do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    #DynamicSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_node() do
    IO.puts("Person with wrong Arguments")
  end

  def add_node(private_key, public_key, num_of_coins) do
    IO.inspect public_key, label: " Module: PersonManager, Method: add_node Adding a person with public key"
    #child_spec = {Person, {private_key, public_key, num_of_coins}}
    child_spec = {Person, %{private_key: private_key,public_key: public_key,num_of_coins: num_of_coins, utxo: nil, chain: nil}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def remove_node(public_key) do
    DynamicSupervisor.terminate_child(__MODULE__, public_key)
  end

  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end

  def send_utxo(utxo) do 
    Enum.each PersonManager.children, fn {_ ,person_pid, _, _} ->  
        GenServer.call(person_pid, {:update_utxo, utxo})
    end
  end

  def send_genesis_blockchain(chain) do 
    Enum.each PersonManager.children, fn {_ ,person_pid, _, _} ->  
        GenServer.call(person_pid, {:update_genesis_blockchain, chain})
    end
  end

  def get_public_key(random_person_pid) do
    GenServer.call(random_person_pid, {:get_public_key})
  end

  def start_mining(transaction) do 
    Enum.each PersonManager.children, fn {_ ,person_pid, _, _} ->  
        GenServer.cast(person_pid, {:mine_block, transaction})
    end    
  end

  #def update_blockchain(chain, person_pid) do
  #  IO.inspect person_pid, label: "Blockchain received from "
  #  Enum.each PersonManager.children, fn {_ ,person_pid, _, _} ->  
  #      GenServer.cast(person_pid, {:update_blockchain, chain})
  #  end
  #end

  def update_blockchain(chain, person_pid) do
    IO.inspect person_pid, label: "Blockchain received from "
    Enum.each PersonManager.children, fn {_ ,person_pid, _, _} ->  
       GenServer.cast(person_pid, {:update_blockchain, chain})
    end
  end

  def allow_sleep() do
    Process.sleep(2000)
    Enum.each PersonManager.children, fn {_ ,person_pid, _, _} ->  
        GenServer.call(person_pid, {:allow_sleep})
    end    
  end
end