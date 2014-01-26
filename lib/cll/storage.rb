require 'set'

module CLL
  # Contract storage with Redis-like interface.
  class Storage
    def initialize
      @hash = {}
    end

    def get(key)
      @hash.fetch(key, IntegerValue.new(0))
    end

    def set(key, value)
      @hash[key] = value
    end

    def sadd(key, value)
      insure_set(key)
      @hash[key].add(value)
    end

    private
    def insure_set(key)
      @hash[key] = Set.new unless @hash[key]
    end
  end
end
