# frozen_string_literal: true

require 'main_program'

describe MainProgram do
  let(:main_program) { MainProgram.new }
  let(:sample_data_base) { DataBase.new }
  let(:hello) do
    "Witaj w bazie danych wprowadź komende.\nPotrzebujesz pomocy wpisz komende pomoc.\nChcesz zkończyć program wpisz komende koniec\n"
  end
  let(:prompt) { '> ' }
  let(:pomoc) { "Pomoc programu  baza danych lista dostępnych komend:\nSET\nGET\nCOUNT\nDELETE\nBEGIN\nROLLBACK\nCOMMIT\n" }
  let(:arg1) { 'a' }
  let(:arg2) { '10' }

  it '#hello_message puts message to user' do
    expect { main_program.send(:hello_message) }.to output(hello + prompt).to_stdout
  end

  it '#pomoc puts message to user' do
    expect { main_program.send(:pomoc) }.to output(pomoc + prompt).to_stdout
  end

  it '#comand_set set data to database' do
    base_before = sample_data_base.base.count
    main_program.send(:comand_set, sample_data_base, arg1, arg2)
    base_after = sample_data_base.base.count
    expect(base_after - base_before).to eq(1)
  end

  it '#comand_get for existing key return value from database' do
    main_program.send(:comand_set, sample_data_base, arg1, arg2)
    expect { main_program.send(:comand_get, sample_data_base, arg1) }.to output("10\n" + prompt).to_stdout
  end

  it '#comand_get for not existing key return NULL from database' do
    main_program.send(:comand_set, sample_data_base, arg1, arg2)
    expect { main_program.send(:comand_get, sample_data_base, 'notexistent') }.to output("NULL\n" + prompt).to_stdout
  end

  it '#comand_count for existing value count instance of a value in database' do
    main_program.send(:comand_set, sample_data_base, arg1, arg2)
    main_program.send(:comand_set, sample_data_base, 'b', arg2)
    main_program.send(:comand_set, sample_data_base, 'c', arg2)
    expect { main_program.send(:comand_count, sample_data_base, arg2) }.to output("3\n" + prompt).to_stdout
  end

  it '#comand_count for not existing value return 0' do
    main_program.send(:comand_set, sample_data_base, arg1, arg2)
    main_program.send(:comand_set, sample_data_base, 'b', arg2)
    main_program.send(:comand_set, sample_data_base, 'c', arg2)
    expect { main_program.send(:comand_count, sample_data_base, 'notexistent') }.to output("0\n" + prompt).to_stdout
  end

  it '#comand_delete delete key value pair from database' do
    main_program.send(:comand_set, sample_data_base, arg1, arg2)
    main_program.send(:comand_set, sample_data_base, 'b', arg2)
    main_program.send(:comand_set, sample_data_base, 'c', arg2)
    expect { main_program.send(:comand_count, sample_data_base, arg2) }.to output("3\n" + prompt).to_stdout
    main_program.send(:comand_delete, sample_data_base, arg1)
    expect { main_program.send(:comand_count, sample_data_base, arg2) }.to output("2\n" + prompt).to_stdout
  end

  it 'scenario 0 work as expected' do
    # > SET a 10
    main_program.send(:comand_set, sample_data_base, 'a', '10')
    # > GET a
    # > 10
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("10\n" + prompt).to_stdout
    # > DELETE a
    main_program.send(:comand_delete, sample_data_base, 'a')
    # > GET a
    # NULL
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("NULL\n" + prompt).to_stdout
    # > SET a 10
    # > SET b 10
    # > COUNT 10
    # 2
    main_program.send(:comand_set, sample_data_base, 'a', '10')
    main_program.send(:comand_set, sample_data_base, 'b', '10')
    expect { main_program.send(:comand_count, sample_data_base, '10') }.to output("2\n" + prompt).to_stdout
    # > COUNT 20
    # 0
    expect { main_program.send(:comand_count, sample_data_base, '20') }.to output("0\n" + prompt).to_stdout
    # > DELETE a
    # > COUNT 10
    # 1
    main_program.send(:comand_delete, sample_data_base, 'a')
    expect { main_program.send(:comand_count, sample_data_base, '10') }.to output("1\n" + prompt).to_stdout
    # > SET b 30
    # > COUNT 10
    # 0
    main_program.send(:comand_set, sample_data_base, 'b', '30')
    expect { main_program.send(:comand_count, sample_data_base, '10') }.to output("0\n" + prompt).to_stdout
  end

  it 'scenario 1 work as expected' do
    # > BEGIN
    # > SET a 10
    # > GET a
    # 10
    main_program.send(:comand_begin, sample_data_base)
    main_program.send(:comand_set, sample_data_base, 'a', '10')
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("10\n" + prompt).to_stdout
    # > BEGIN
    # > SET a 20
    # > GET a
    # 20
    main_program.send(:comand_begin, sample_data_base)
    main_program.send(:comand_set, sample_data_base, 'a', '20')
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("20\n" + prompt).to_stdout
    # > ROLLBACK
    # > GET a
    # 10
    main_program.send(:comand_rollback, sample_data_base)
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("10\n" + prompt).to_stdout
    # > ROLLBACK
    # > GET a
    # NULL
    main_program.send(:comand_rollback, sample_data_base)
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("NULL\n" + prompt).to_stdout
  end

  it 'scenario 2 work as expected' do
    # > BEGIN
    # > SET a 30
    # > BEGIN
    # > SET a 40
    # > COMMIT
    # > GET a
    # 40
    main_program.send(:comand_begin, sample_data_base)
    main_program.send(:comand_set, sample_data_base, 'a', '30')
    main_program.send(:comand_begin, sample_data_base)
    main_program.send(:comand_set, sample_data_base, 'a', '40')
    main_program.send(:comand_commit, sample_data_base)
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("40\n" + prompt).to_stdout
    # > ROLLBACK
    # NO TRANSACTION
    expect { main_program.send(:comand_rollback, sample_data_base) }.to output("NO TRANSACTION\n" + prompt).to_stdout
  end

  it 'scenario 3 work as expected' do
    # > SET a 50
    # > BEGIN
    # > GET a
    # 50
    main_program.send(:comand_set, sample_data_base, 'a', '50')
    main_program.send(:comand_begin, sample_data_base)
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("50\n" + prompt).to_stdout
    # > SET a 60
    # > BEGIN
    # > DELETE a
    # > GET a
    # NULL
    main_program.send(:comand_set, sample_data_base, 'a', '60')
    main_program.send(:comand_begin, sample_data_base)
    main_program.send(:comand_delete, sample_data_base, 'a')
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("NULL\n" + prompt).to_stdout
    # > ROLLBACK
    # > GET a
    # 60
    main_program.send(:comand_rollback, sample_data_base)
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("60\n" + prompt).to_stdout
    # > COMMIT
    # > GET a
    # 60
    main_program.send(:comand_commit, sample_data_base)
    expect { main_program.send(:comand_get, sample_data_base, 'a') }.to output("60\n" + prompt).to_stdout
  end

  it 'scenario 4 work as expected' do
    # > SET a 10
    # > BEGIN
    # > COUNT 10
    # 1
    main_program.send(:comand_set, sample_data_base, 'a', '10')
    main_program.send(:comand_begin, sample_data_base)
    expect { main_program.send(:comand_count, sample_data_base, '10') }.to output("1\n" + prompt).to_stdout
    # > BEGIN
    # > DELETE a
    # > COUNT 10
    # 0
    main_program.send(:comand_begin, sample_data_base)
    main_program.send(:comand_delete, sample_data_base, 'a')
    expect { main_program.send(:comand_count, sample_data_base, '10') }.to output("0\n" + prompt).to_stdout
    # > ROLLBACK
    # > COUNT 10
    # 1
    main_program.send(:comand_rollback, sample_data_base)
    expect { main_program.send(:comand_count, sample_data_base, '10') }.to output("1\n" + prompt).to_stdout
  end
end
