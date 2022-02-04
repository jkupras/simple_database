# frozen_string_literal: true

require_relative 'base_data_base'

# simple data base
class DataBase < BaseDataBase
  def initialize
    @transactions = []
    super
  end

  def begin_transaction
    transaction = BaseDataBase.new
    @transactions << transaction
  end

  def rollback_transaction
    @transactions.pop
  end

  def commit_transaction
    @transactions.each do |transaction|
      @base.merge!(transaction.base)
      @transactions = []
    end
  end

  def current_transaction
    @transactions.last
  end
end

# sample_data_base = DataBase.new

# prompt = '> '
# puts 'Witaj w bazie danych wprowadź komende.'
# puts 'Potrzebujesz pomocy wpisz komende pomoc.'
# puts 'Chcesz zkończyć program wpisz komende koniec'
# print prompt

# while user_input = gets.chomp
#   input = user_input.split
#   command = input.first
#   arg1 = input[1]
#   arg2 = input[2]

#   case command
#   when 'pomoc'
#     puts 'Pomoc programu  baza danych lista dostępnych komend:'
#     puts 'SET'
#     puts 'GET'
#     puts 'COUNT'
#     puts 'DELETE'
#     puts 'BEGIN'
#     puts 'ROLLBACK'
#     puts 'COMMIT'
#     print prompt
#   when 'koniec'
#     puts 'Do Widzenia'
#     break
#   when 'SET'
#     puts 'SET'
#     sample_data_base.current_transaction ? sample_data_base.current_transaction.set(arg1, arg2) : sample_data_base.set(arg1, arg2)
#     print prompt
#   when 'GET'
#     puts 'GET'
#     puts sample_data_base.current_transaction ? sample_data_base.current_transaction.get(arg1) : sample_data_base.get(arg1)
#     print prompt
#   when 'COUNT'
#     puts 'COUNT'
#     puts sample_data_base.current_transaction ? sample_data_base.current_transaction.count(arg1) : sample_data_base.count(arg1)
#     print prompt
#   when 'DELETE'
#     puts 'DELETE'
#     sample_data_base.current_transaction ? (sample_data_base.current_transaction.delete(arg1) && sample_data_base.delete(arg1)) : sample_data_base.delete(arg1)
#     print prompt
#   when 'BEGIN'
#     puts 'BEGIN'
#     sample_data_base.begin_transaction
#     print prompt
#   when 'ROLLBACK'
#     puts 'ROLLBACK'
#     sample_data_base.rollback_transaction
#     print prompt
#   when 'COMMIT'
#     puts 'COMMIT'
#     sample_data_base.commit_transaction
#     print prompt
#   else
#     puts 'Nieznana komenda. Wprowadź prawidłową komende'
#     print prompt
#   end
# end



