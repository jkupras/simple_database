# frozen_string_literal: true

require 'data_base'
describe DataBase do
  let(:data_base) { DataBase.new }

  it '#set inherited from the class BaseDataBase add new kay value pair to database' do
    base_before = data_base.base.count
    data_base.set('a', '50')
    base_after = data_base.base.count
    expect(base_after - base_before).to eq(1)
  end

  it '#begin_transaction add new transaction to @transactions' do
    expect(data_base.current_transaction).to eq(nil)
    data_base.begin_transaction
    expect(data_base.current_transaction).to be_an_instance_of(Hash)
  end

  it '#rollback_transaction remove transaction from @transactions' do
    data_base.begin_transaction
    expect(data_base.current_transaction).to be_an_instance_of(Hash)
    data_base.rollback_transaction
    expect(data_base.current_transaction).to eq(nil)
  end

  it '#commit_transaction mergr @transactions with @base' do
    data_base.set('a', '50')
    data_base.begin_transaction
    data_base.current_transaction[:data_transactions].set('b', '30')
    data_base.begin_transaction
    data_base.current_transaction[:data_transactions].set('c', '50')
    data_base.commit_transaction
    expect(data_base.base).to eq({ 'a' => '50', 'b' => '30', 'c' => '50' })
  end

  it '#current_transaction return last transaction from @transactions' do
    expect(data_base.current_transaction).to eq(nil)
    data_base.begin_transaction
    expect(data_base.current_transaction).to be_an_instance_of(Hash)
  end
end
