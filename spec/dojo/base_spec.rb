require 'spec_helper'

describe Dojo::Base do

  it 'handle backet empty' do
    subject.price([]).must_equal 0
  end

  it 'handle price for 1 book' do
    subject.price([0]).must_equal 8
    subject.price([1]).must_equal 8
    subject.price([2]).must_equal 8
    subject.price([3]).must_equal 8
    subject.price([4]).must_equal 8
  end

  it 'handle price for identical book' do
    subject.price([0, 0]).must_equal 8*2
    subject.price([1, 1, 1]).must_equal 8*3
  end

  it 'handle 5% discount' do
    subject.price([0, 1]).must_equal 8 * 2 * 0.95
  end

  it 'handle 10% discount' do
    subject.price([0, 2, 4]).must_equal 8 * 3 * 0.9
  end

  it 'handle 20% discount' do
    subject.price([0, 1, 2, 4]).must_equal 8 * 4 * 0.8
  end

  it 'handle 25% discount' do
    subject.price([0, 1, 2, 3, 4]).must_equal 8 * 5 * 0.75
  end

  it 'handle multiple discount 1' do
    subject.price([0, 0, 1]).must_equal 8 + (8 * 2 * 0.95)
  end

  it 'handle multiple discount 2' do
    subject.price([0, 0, 1, 1]).must_equal 2 * (8 * 2 * 0.95)
  end

  it "handle multiple discount 3" do
    subject.price([0, 0, 1, 2, 2, 3]).must_equal (8 * 4 * 0.8) + (8 * 2 * 0.95)
  end

  it 'handle multiple discount 4' do
    subject.price([0, 1, 1, 2, 3, 4]).must_equal 8 + (8 * 5 * 0.75)
  end

  it 'handle tricky case 1' do
    subject.price([0, 0, 1, 1, 2, 2, 3, 4]).must_equal 2 * (8 * 4 * 0.8)
  end

  it 'handle tricky case 2' do
    subject.price([0, 0, 0, 0, 0,
                   1, 1, 1, 1, 1,
                   2, 2, 2, 2,
                   3, 3, 3, 3, 3,
                   4, 4, 4, 4]).must_equal 3 * (8 * 5 * 0.75) + 2 * (8 * 4 * 0.8)
  end

end
