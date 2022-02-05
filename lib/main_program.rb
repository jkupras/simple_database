# frozen_string_literal: true

require_relative 'data_base'

class MainProgram
  POMOC = ['Pomoc programu  baza danych lista dostępnych komend:',
           'SET',
           'GET',
           'COUNT',
           'DELETE',
           'BEGIN',
           'ROLLBACK',
           'COMMIT'].freeze

  HELLO = ['Witaj w bazie danych wprowadź komende.',
           'Potrzebujesz pomocy wpisz komende pomoc.',
           'Chcesz zkończyć program wpisz komende koniec'].freeze
  PROMPT = '> '

  def creata_data_base
    sample_data_base = DataBase.new
    hello_message

    while (user_input = gets.chomp)
      input = user_input.split
      command = input.first
      arg1 = input[1]
      arg2 = input[2]

      case command
      when 'pomoc'
        pomoc
      when 'koniec'
        puts 'Do Widzenia'
        break
      when 'SET'
        comand_set(sample_data_base, arg1, arg2)
      when 'GET'
        comand_get(sample_data_base, arg1)
      when 'COUNT'
        comand_count(sample_data_base, arg1)
      when 'DELETE'
        comand_delete(sample_data_base, arg1)
        print PROMPT
      when 'BEGIN'
        comand_begin(sample_data_base)
      when 'ROLLBACK'
        comand_rollback(sample_data_base)
      when 'COMMIT'
        comand_commit(sample_data_base)
      else
        puts 'Nieznana komenda. Wprowadź prawidłową komende'
        print PROMPT
      end
    end
  end

  private

  def hello_message
    HELLO.each do |elem|
      puts elem
    end
    print PROMPT
  end

  def pomoc
    POMOC.each do |elem|
      puts elem
    end
    print PROMPT
  end

  def comand_delete(sample_data_base, arg1)
    puts 'DELETE'
    if sample_data_base.current_transaction
      deleted_data = { arg1 => sample_data_base.current_transaction[:data_transactions].base[arg1] || sample_data_base.base[arg1] }
      sample_data_base.current_transaction[:deletion].merge!(deleted_data)
      sample_data_base.current_transaction[:data_transactions].delete(arg1) || sample_data_base.delete(arg1)
    else
      sample_data_base.delete(arg1)
    end
  end

  def comand_set(sample_data_base, arg1, arg2)
    puts 'SET'
    if sample_data_base.current_transaction
      sample_data_base.current_transaction[:data_transactions].set(arg1, arg2)
    else
      sample_data_base.set(arg1, arg2)
    end
    print PROMPT
  end

  def comand_get(sample_data_base, arg1)
    puts 'GET'
    if sample_data_base.current_transaction
      puts sample_data_base.current_transaction[:data_transactions].get(arg1) || sample_data_base.get(arg1) || 'NULL'
    else
      puts sample_data_base.get(arg1) || 'NULL'
    end
    print PROMPT
  end

  def comand_count(sample_data_base, arg1)
    puts 'COUNT'
    if sample_data_base.current_transaction
      puts sample_data_base.current_transaction[:data_transactions].count(arg1) + sample_data_base.count(arg1)
    else
      puts sample_data_base.count(arg1)
    end
    print PROMPT
  end

  def comand_begin(sample_data_base)
    puts 'BEGIN'
    sample_data_base.begin_transaction
    print PROMPT
  end

  def comand_rollback(sample_data_base)
    puts 'ROLLBACK'
    if sample_data_base.current_transaction
      sample_data_base.base.merge!(sample_data_base.current_transaction[:deletion])
    end
    sample_data_base.rollback_transaction || (puts 'NO TRANSACTION')
    print PROMPT
  end

  def comand_commit(sample_data_base)
    puts 'COMMIT'
    sample_data_base.commit_transaction
    print PROMPT
  end
end
