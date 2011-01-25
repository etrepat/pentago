module Pentago
  module UI
    class Console
      def initialize(arguments, stdin, stdout)
        @arguments  = arguments
        @options    = {}
        @input      = stdin
        @output     = stdout
      end
      
      def run
        if parsed_options? && options_valid?
          @board  = Pentago::Board.new
          @game   = Pentago::Game.new(@options[:player1], @options[:player2], @board)
          @game.add_observer(self)
          
          @game.play
        else
          output_usage
        end
      end
      
      def update(player_at_turn, board)
        marble  = player_at_turn.marble
        x, y, s, d = player_at_turn.last_move
        say "\nTurn #{board.moves}: Player #{marble} played: [#{x}, #{y}], rotated square: #{s} #{d}"
        if board.game_over?
          if board.tie?
            say "Game ends w/state: --- TIE GAME ---"
          else
            say "Game ends w/state: --- PLAYER #{board.find_winner} WINS! ---"
          end
        end
        say "-------------------"
        say board
        say "-------------------"
      end
      
      def parsed_options?
        @options_parser ||= OptionParser.new do |opts|
          opts.banner = <<BANNER
Pentago Bot/Game AI Console Lab v#{Pentago.version}

Usage:
  pentago --player1=[Engine] --player2=[Engine] ([options])
  
Example:
  pentago --player1=Human --player2=Minimax
  
Options are:
BANNER
          opts.on('--player1=PLAYER', String,
            'Player 1 Engine (required)') do |engine|
              @options[:player1] = load_player(engine, 1)
          end
          
          opts.on('--player2=PLAYER', String,
            'Player 2 Engine (required)') do |engine|
              @options[:player2] = load_player(engine, 2)
          end
          
          # TODO: option for reading a board from a text file
          # TODO: option to set level of dificulty (of course, AI should be done first)
          
          opts.separator ''

          opts.on('-h', '--help', 'Show this message') do
            puts opts
            exit
          end

          opts.separator ''
        end
        
        begin
          @options_parser.parse!(@arguments)
        rescue TypeError, OptionParser::ParseError => e
          @options_parser.warn e.message
          nil
        end
      end
      
      protected
      
      def options_valid?
        @options.keys.include?(:player1) && @options.keys.include?(:player2)
      end
      
      def output_usage
        puts @options_parser
      end
      
      def load_player(engine_name, player_marble)
        player = player_to_constant(engine_name).new(player_marble) unless player.kind_of?(Pentago::Players::Base)
      rescue Exception => e
        puts e.message
        raise TypeError, "invalid player engine (#{engine_name})"       
      end
      
      def player_to_constant(name)
        camel = name.to_s.split('_').map { |s| s.capitalize }.join
        eval("Pentago::Players::#{camel}")
      end  
      
      def gets
        @input ? @input.gets : ''
      end
      
      def say(message)
        @output.puts(message) if @output
      end
      
      def ask(question)
        say("#{question} [yn]: ")
        gets.chomp.downcase == 'y'
      end
      
      def ask_coords(question)
        say("#{question} [x,y] (ex: 3,4 - comma sep.): ")
        gets.chomp.split(',').map { |n| n.strip.to_i }
      end
    end
  end
end