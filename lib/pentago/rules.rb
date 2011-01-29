module Pentago
  module Rules
    def find_winner
      # check horizontal lines
      Board::ROWS.times do |y|
        player = board[1,y]
        return player if (player && player == board[2,y] && player == board[3,y] && \
          player == board[4,y] && (player == board[0,y] || player == board[5,y]))
      end

      # check vertical lines
      Board::COLS.times do |x|
        player = board[x,1]
        return player if (player && player == board[x,2] && player == board[x,3] && \
          player == board[x,4] && (player == board[x,0] || player == board[x,5]))
      end

      # check center diagonal lines
      player = board[1,1]
      return player if (player && player == board[2,2] && player == board[3,3] && \
        player == board[4,4] && (player == board[0,0] || player == board[5,5]))

      player = board[4,1]
      return player if (player && player == board[3,2] && player == board[2,3] && \
        player == board[1,4] && (player == board[5,0] || player == board[0,5]))

      # check off-center diagonal lines
      player = board[0,1]
      return player if (player && player == board[1,2] && player == board[2,3] && \
        player == board[3,4] && player == board[4,5])

      player = board[1,0]
      return player if (player && player == board[2,1] && player == board[3,2] && \
        player == board[4,3] && player == board[5,4])

      player = board[0,4]
      return player if (player && player == board[1,3] && player == board[2,2] && \
        player == board[3,1] && player == board[4,0])

      player = board[1,5]
      return player if (player && player == board[2,4] && player == board[3,3] && \
        player == board[4,2] && player == board[5,1])

      nil
    end

    def game_over?
      board.full? || find_winner
    end

    def tie_game?
      board.full? && !find_winner
    end
  end
end