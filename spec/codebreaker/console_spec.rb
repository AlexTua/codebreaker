require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    context '#play_game' do
      before do
        allow(subject).to receive(:game_over) 
        allow(subject.instance_variable_get(:@game)).to receive(:any_attempts?).and_return(false)
      end

      describe 'should print messages' do
        it 'greet message' do
          allow(subject).to receive(:gets).and_return('exit')
          expect { subject.play_game }.to output(/Welcome to Codebreaker!/).to_stdout
        end

        it "message with hint when player typed 'hint'" do
          allow(subject).to receive(:gets).and_return('hint')
          allow(subject.instance_variable_get(:@game)).to receive(:hint).and_return('HINT')
          expect { subject.play_game }.to output(/HINT/).to_stdout
        end

        it 'print mark answer' do
          allow(subject).to receive(:gets).and_return('1234')
          allow(subject.instance_variable_get(:@game)).to receive(:check_guess).and_return('----')
          expect { subject.play_game }.to output(/----/).to_stdout
        end

        it 'should print warning massege if wrong input' do
          allow(subject).to receive(:gets).and_return('11111')
          expect { subject.play_game }.to output(/You should type a guess of four numbers from 1 to 6./).to_stdout
        end
      end

      describe 'should call methods' do
        before do
          allow(subject).to receive(:puts)
          allow(subject).to receive(:gets).and_return('1234')
        end

        it 'call #check_guess method' do
          expect(subject.instance_variable_get(:@game)).to receive(:check_guess)
          subject.play_game
        end

        it "call #game_over(:win) method when answer '++++'" do
          allow(subject.instance_variable_get(:@game)).to receive(:check_guess).and_return('++++')
          expect(subject).to receive(:game_over).with(:win)
          subject.play_game
        end

        it 'call #game_over(:lose) method when no attempts' do
          allow(subject.instance_variable_get(:@game)).to receive(:any_attempts?).and_return(false)
          expect(subject).to receive(:game_over).with(:lose)
          subject.play_game
        end
      end
    end
  
    context '#game_over' do
      before do 
        allow(subject).to receive(:play_again) 
        allow(subject).to receive(:ask_for_save)
      end

      it 'print congratulations message' do
        expect { subject.send(:game_over, :win)  }.to output(/Congratulations, you broke the code!/).to_stdout
      end

      it 'print message about loss' do 
        expect { subject.send(:game_over, :lose)  }.to output(/Unfortunately there are no more attempts./).to_stdout
      end

      it 'call #play_again method' do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:play_again)
        subject.send(:game_over, :win) 
      end

      it 'call #ask_for_save method' do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:ask_for_save)
        subject.send(:game_over, :win) 
      end
    end

    context '#play_again' do
      before do
        allow(subject).to receive(:play_game) 
        allow(subject).to receive(:gets).and_return('y')
      end

      it 'ask about play again' do
        expect { subject.send(:play_again) }.to output(/Would you like to play again?/).to_stdout
      end

      it "create new game" do
        allow(subject).to receive(:puts)
        expect(Game).to receive(:new)
        subject.send(:play_again) 
      end

      it "call #play_game method" do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:play_game)
        subject.send(:play_again)
      end
    end

    context '#ask_for_save' do
      before do
        allow(subject).to receive(:save_data) 
        allow(subject).to receive(:gets).and_return('y')
      end

      it 'ask about play again' do
        expect { subject.send(:ask_for_save) }.to output(/Would you like to save game result?/).to_stdout
      end

      it "call #save_dara method" do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:save_data)
        subject.send(:ask_for_save)
      end
    end

    context '#save_data' do
      after do
          File.delete('statistics.yaml')
      end

      it 'statistics.yaml should exist' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return('Alex')
        subject.send(:save_data)
        expect(File.exist?('statistics.yaml')).to eq true
      end
    end
  end
end