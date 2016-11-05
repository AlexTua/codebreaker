module Codebreaker
  class Game
    ATTEMPTS_NUMBER = 7
    HINTS_NUMBER = 1

    attr_reader :attempts, :hints

    def initialize(name)
      @player_name = name
      @secret_code = generate_secret_code
      @attempts =  ATTEMPTS_NUMBER
      @hints = HINTS_NUMBER
    end

    def check_guess(guess)
      return '++++' if guess == @secret_code

      code = @secret_code.chars
      guess = guess.chars
      answer = ''

      guess.each_with_index do |num, ind|
        if code.include?(num) && code[ind] == num
          answer << '+'
          code[ind], guess[ind] = nil
        end
      end

      [code,guess].each(&:compact!)

      guess.each_with_index do |num, ind|
        if code.include?(num)
          answer << '-'
          code[code.find_index(num)], guess[ind] = nil
        end
      end

      answer
    end

    def get_hint
    end

    private

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end
  end
end