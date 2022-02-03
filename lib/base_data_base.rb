# frozen_string_literal: true

# base data base
class BaseDataBase
  def initialize
    @base = {}
  end
  attr_reader :base

  def set(name, value)
    @base[name] = value
  end

  def get(value)
    @base[value] || 'NULL'
  end

  def delete(name)
    @base.delete(name)
  end

  def count(value)
    @base.count { |_k, v| v == value }
  end
end
