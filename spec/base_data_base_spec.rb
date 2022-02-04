# frozen_string_literal: true

# spec/base_data_base.rb
require 'base_data_base'
describe BaseDataBase do
  let(:base_data_base) { BaseDataBase.new }

  it '#set add new kay value pair to database' do
    base_before = base_data_base.base.count
    base_data_base.set('a', '50')
    base_after = base_data_base.base.count
    expect(base_after - base_before).to eq(1)
  end

  it '#get return value from data base' do
    base_data_base.set('a', '50')
    expect(base_data_base.get('a')).to eq('50')
  end

  it '#delete removes kay value pair from database' do
    base_data_base.set('a', '50')
    base_data_base.set('b', '50')
    base_data_base.set('c', '50')
    base_before = base_data_base.base.count
    base_data_base.delete('a')
    base_after = base_data_base.base.count
    expect(base_before - base_after).to eq(1)
  end

  it '#count counts the number of times the argument appears as a value in the database' do
    base_data_base.set('a', '50')
    base_data_base.set('b', '50')
    base_data_base.set('c', '50')
    expect(base_data_base.count('50')).to eq(3)
  end

  it '#base return database' do
    base_data_base.set('a', '50')
    base_data_base.set('b', '50')
    base_data_base.set('c', '50')
    expect(base_data_base.base).to eq({ 'a' => '50', 'b' => '50', 'c' => '50' })
  end
end
