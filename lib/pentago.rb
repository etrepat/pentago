require 'observer'

require 'rubygems'
require 'bundler/setup'
Bundler.require

module Pentago; end

require_relative 'pentago/board'
require_relative 'pentago/game'
require_relative 'pentago/version'

require_relative 'pentago/players/base'
require_relative 'pentago/players/dummy'

require_relative 'pentago/ui/console'