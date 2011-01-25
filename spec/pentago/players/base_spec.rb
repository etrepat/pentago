module Pentago
  module Players
    describe Base do
      describe '#initialize' do
        it 'should create a base player with marble' do
          base_1 = Base.new(1)
          base_1.marble.should == 1
          
          base_x = Base.new('x')
          base_x.marble.should == 'x'
        end
      end
      
      describe '#play_turn' do
        it 'should raise RuntimeError when this method is called' do
          base  = Base.new(1)
          board = Board.new 
          expect {
            base.play_turn(board)
          }.to raise_error(RuntimeError)
        end
      end
    end
  end
end