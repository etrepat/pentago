module Pentago
  module Rules
    def find_winner
      winners = players_with_5_in_a_row

      if winners.empty?
        nil
      elsif winners.size == 1
        winners.first
      else
        winners
      end
    end

    def game_over?
      !!find_winner
    end

    def tie_game?
      case find_winner
        when Array  then true
        when nil    then full?
        else false
      end
    end

    def runs
      rows + columns + diagonals
    end

    private

    def players_with_5_in_a_row
      marbles = @squares.compact.uniq
      winners = marbles.each_with_object([]) do |marble, result|
        result << runs.map do |run|
          marble if run.each_cons(5).any? { |p| p.count(marble) == 5 }
        end
      end.flatten.compact.uniq
    end

  end
end
