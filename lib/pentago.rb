require 'observer'

require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'highline'

module Pentago; end

require_relative 'pentago/board'
require_relative 'pentago/rules'
require_relative 'pentago/game'
require_relative 'pentago/version'

require_relative 'pentago/player'
require_relative 'pentago/dummy_player'
require_relative 'pentago/human_player'

require_relative 'pentago/ui/console'