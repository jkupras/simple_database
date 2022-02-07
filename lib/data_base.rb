# frozen_string_literal: true

require_relative 'base_data_base'

class DataBase < BaseDataBase
  def initialize
    @transactions = []
    super
  end

  def begin_transaction
    data_transactions = BaseDataBase.new
    deletion = {}
    transaction = { data_transactions: data_transactions, deletion: deletion }
    @transactions << transaction
  end

  def rollback_transaction
    return unless current_transaction

    @base.merge!(current_transaction[:deletion])
    @transactions.pop
  end

  def commit_transaction
    @transactions.each do |transaction|
      @base.merge!(transaction[:data_transactions].base)
    end
    @transactions = []
  end

  def current_transaction
    @transactions.last
  end

  def transactions_empty?
    @transactions.empty?
  end
end
