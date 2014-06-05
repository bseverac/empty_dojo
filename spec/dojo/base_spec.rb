require 'spec_helper'

describe Dojo::Game do

  before do
    @base = subject.new
  end

  it 'initialize the score' do
    @base.score.must_equal 0
  end

  it 'should not change score on first throw when hit 1' do
    @base.record! '1'
    @base.score.must_equal 0
  end

  it 'changes score to 2 when 1 pin hit twice' do
    2.times do @base.record! '1' end
    @base.score.must_equal 2
  end

  it 'doesnt change the score on a strike' do
    @base.record! 'X'
    @base.score.must_equal 0
  end
  
  it 'doesnt change the score on a spare' do
    @base.record! '1'
    @base.record! '/'
    @base.score.must_equal 0
  end

  it 'update score on first hit and spare before' do
    @base.record! '1'
    @base.record! '/'
    @base.record! '1'
    @base.score.must_equal 11
  end

end
