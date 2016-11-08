module Codebreaker
  class Console
    def initialize
      @game = Game.new  
    end

    def play_game
      puts 'Welcome to Codebreaker!'
      puts "Type 'hint' to get hint, 'exit' to leave. " +
           'Make a guess of 4 numbers from 1 to 6.'
      
      begin
        guess = gets.chomp
        
        case guess
          when 'hint'
            puts @game.get_hint
          when 'exit'
            return 
          when /^[1-6]{4}$/
            answer = @game.check_guess(guess)
            puts answer
          else
            puts 'You should type a guess of four numbers from 1 to 6.'
        end

        game_over(:win) if answer == '++++'
      end until @game.game_over?

      game_over(:lose)
    end

    def game_over(game_status)
      message = { :win => "Congratulations, you broke the code! #{@game.to_s}",
                  :lose => "Unfortunately there are no more attempts. #{@game.to_s}" }
      puts message[game_status]
      play_again
    end

    def play_again
      puts "Would you like to play again? (y/n)"
      return unless gets.chomp == 'y' 
      @game = Game.new 
      play_game
    end
  end
end