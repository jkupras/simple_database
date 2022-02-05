# frozen_string_literal: true

# spec/main.rb
require 'stringio'
require 'main_program'
describe MainProgram do
let(:main_program) { MainProgram.new }

    before do
      allow(gets).to receive(chomp).and_return('koniec')
    end
  it '#set add new kay value pair to database' do
#   #   allow(STDIN).to receive(:gets).and_return('koniec')
#   # # expect(STDOUT).to receive(:puts).with("Witaj w bazie danych wprowadź komende.")

#   # # { expect { print('foo') }.to output('foo').to_stdout }
#   # # allow(STDIN).to receive(:gets) { 'koniec' }
#   # # expect(game.ask_for_name).to eq 'Joe'
#   # main_program.creata_data_base
#   #   allow(STDIN).to receive(:gets).and_return('koniec')

# STDIN.should_receive(:read).and_return("koniec")
# STDOUT.should_receive(:puts).with("Witaj w bazie danych wprowadź komende1.")

# main_program.creata_data_base

# STDIN.should_receive(:read).and_return("koniec")
# STDOUT.should_receive(:puts).with("Witaj w bazie danych wprowadź komende2.")


      main_program.creata_data_base
  end
end
