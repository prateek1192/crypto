defmodule Simulator do
	
	def main(args) do

		{:ok, super_pid} = PersonManager.start_link(args)
		IO.inspect super_pid, label: "Module: Simulator, Method: main Supervisor to supervise all miners started with pid "
		num_of_persons = 100
		start_persons(num_of_persons)
		IO.inspect PersonManager.count_children, label: "Module: Simulator, Method: main The Persons started in main method are"
		IO.puts "Module: Simulator, Method: Creating the genesis block of blockchain"
		chain = Blockchain.new
		IO.puts "Module: Simulator, Method: main Randomly selecting a user to start the coinbase transaction and give him coins"
		IO.inspect PersonManager.children(), label: "The children are "
		persons = PersonManager.children()
		random_person = persons |> Enum.shuffle |> hd
		IO.inspect random_person, label: "The randomly selected person is "
		{_, random_person_pid, _, _	} = random_person
		random_person_public_key = PersonManager.get_public_key(random_person_pid)
		IO.inspect random_person_public_key, label: "The returned public key is"
		IO.puts "Assigning 10000 coins in coinbase transaction to this public_key"
		{coinbase_transaction, utxo} = Transaction.getCoinbaseTransaction(random_person_public_key, 1)
		PersonManager.send_utxo(utxo)
		PersonManager.send_genesis_blockchain(chain)
		IO.puts "Starting mining"
		PersonManager.start_mining(coinbase_transaction)
		PersonManager.allow_sleep()

	end

	def start_persons(num_of_persons) when num_of_persons >=1 do
		IO.inspect num_of_persons, label: "Module: Simulator, Method: start_persons Args: >=1 Starting person number"
		{public_key, private_key} = Keypair.generate()
		PersonManager.add_node(private_key, public_key, 0)
		start_persons(num_of_persons-1)

	end

	def start_persons(num_of_persons) when num_of_persons == 0 do
		
		IO.inspect PersonManager.count_children, label: "Module: Simulator, Method: start_persons Args: == 0 Started all persons, returning"

	end

end