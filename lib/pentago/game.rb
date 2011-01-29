module Pentago
  class Game
    include Observable
    include Pentago::Rules

    def initialize(player1, player2, board=Board.new)
      @player1        = player1
      @player2        = player2
      @board          = board
      @current_player = nil
      @winner         = nil
      @players        = nil
    end

    attr_reader :player1, :player2, :board, :current_player, :winner

    def play
      while !game_over?
        @current_player = players.next
        @current_player.play_turn(@board)

        changed
        notify_observers @current_player, @board
      end
      @winner = @current_player unless tie_game?
    end

    def turns_played
      @board && @board.moves
    end

    def players
      @players ||= [player1, player2].cycle
    end
  end
end