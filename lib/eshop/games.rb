require 'httparty'
require_relative 'games/americas'
require_relative 'games/europe'

module Eshop
  class Games
    def self.list
      Americas.list + Europe.list
    end
  end
end
