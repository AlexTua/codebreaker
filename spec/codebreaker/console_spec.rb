require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    let(:console) { Console.new }

    context '#play_game' do
      before do
        allow(console).to receive(:game_over) 
        allow(console.instance_variable_get(:@game)).to receive(:game_over?).and_return('true')
      end

      describe 'should print messages' do
        it 'should greet a player' do
          allow(console).to receive(:gets).and_return('exit')
          expect{ console.play_game }.to output(/Welcome to Codebreaker!/).to_stdout
        end

        it 'should give a hint' do
          allow(console).to receive(:gets).and_return('hint')
          allow(console.instance_variable_get(:@game)).to receive(:get_hint).and_return('HINT')
          expect{ console.play_game }.to output(/HINT/).to_stdout
        end

        it 'print mark answer' do
          allow(console).to receive(:gets).and_return('1234')
          allow(console.instance_variable_get(:@game)).to receive(:check_guess).and_return('----')
          expect{ console.play_game }.to output(/----/).to_stdout
        end

        it 'should print warning massege if wrong input' do
          allow(console).to receive(:gets).and_return('11111')
          expect{ console.play_game }.to output(/You should type a guess of four numbers from 1 to 6./).to_stdout
        end
      end

      describe 'should call methods' do
        before do
          allow(console).to receive(:puts)
          allow(console).to receive(:gets).and_return('1234')
        end

        it 'call #check_guess method' do
          allow(console.instance_variable_get(:@game)).to receive(:check_guess)
          expect(console.instance_variable_get(:@game)).to receive(:check_guess)
          console.play_game
        end

        it "call #game_over(:win) method when answer '++++'" do
          allow(console.instance_variable_get(:@game)).to receive(:check_guess).and_return('++++')
          expect(console).to receive(:game_over).with(:win)
          console.play_game
        end

        it 'call #game_over(:lose) method when no attempts' do
          allow(console.instance_variable_get(:@game)).to receive(:game_over?).and_return('false')
          expect(console).to receive(:game_over).with(:lose)
          console.play_game
        end
      end
    end
  
    context '#game_over' do
      before { allow(console).to receive(:play_again) }

      it 'print congratulations message' do
        expect { console.game_over(:win) }.to output(/Congratulations, you broke the code!/).to_stdout
      end

      it 'print message about loss' do 
        expect { console.game_over(:lose) }.to output(/Unfortunately there are no more attempts./).to_stdout
      end

      it 'call #play_again method' do
        allow(console).to receive(:puts)
        expect(console).to receive(:play_again)
        console.game_over(:win) 
      end
    end

    context '#play_again' do
      before do
        allow(console).to receive(:play_game) 
        allow(console).to receive(:gets).and_return('y')
      end

      it 'ask about play again' do
        expect { console.play_again  }.to output(/Would you like to play again?/).to_stdout
      end

      it "create new game" do
        allow(console).to receive(:puts)
        expect(Game).to receive(:new)
        console.play_again 
      end

      it "call #play_game method" do
        allow(console).to receive(:puts)
        expect(console).to receive(:play_game)
        console.play_again 
      end
    end
  end
end