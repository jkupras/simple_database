# frozen_string_literal: true

# spec/main.rb
require 'main_program'
describe MainProgram do
  let(:main_program) { MainProgram.new }
  let(:sample_data_base) { DataBase.new }
  let(:hello) do
    "Witaj w bazie danych wprowadź komende.\nPotrzebujesz pomocy wpisz komende pomoc.\nChcesz zkończyć program wpisz komende koniec\n"
  end
  let(:prompt) { '> ' }
  let(:pomoc) { "Pomoc programu  baza danych lista dostępnych komend:\nSET\nGET\nCOUNT\nDELETE\nBEGIN\nROLLBACK\nCOMMIT\n" }
  it '#hello_message puts message to user' do
    expect { main_program.send(:hello_message) }.to output(hello + prompt).to_stdout
  end

  it '#pomoc puts message to user' do
    expect { main_program.send(:pomoc) }.to output(pomoc + prompt).to_stdout
  end
end
