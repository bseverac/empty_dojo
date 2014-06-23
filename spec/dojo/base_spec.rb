require 'spec_helper'

describe Dojo::Base do

  it 'makes an empty basket free (as a beer)' do
    subject.price([]).must_equal 0
  end

  it 'uses the default price for a single book' do
    subject.price([0]).must_equal 8
    subject.price([1]).must_equal 8
    subject.price([2]).must_equal 8
    subject.price([3]).must_equal 8
    subject.price([4]).must_equal 8
  end

  it 'does not apply any discount for identical books' do
    subject.price([0, 0]).must_equal 8*2
    subject.price([1, 1, 1]).must_equal 8*3
  end

  it 'applies a 5% discount for 2 different books' do
    subject.price([0, 1]).must_equal 8 * 2 * 0.95
  end

  it 'applies a 10% discount for 3 different books' do
    subject.price([0, 2, 4]).must_equal 8 * 3 * 0.9
  end

  it 'applies a 20% discount for 4 different books' do
    subject.price([0, 1, 2, 4]).must_equal 8 * 4 * 0.8
  end

  it 'applies a 25% discount for 5 different books' do
    subject.price([0, 1, 2, 3, 4]).must_equal 8 * 5 * 0.75
  end

  it 'applies the discount only once' do
    subject.price([0, 0, 1]).must_equal 8 + (8 * 2 * 0.95)
  end

  it 'applies the discount twice' do
    subject.price([0, 0, 1, 1]).must_equal 2 * (8 * 2 * 0.95)
  end

  it "applies the discount twice" do
    subject.price([0, 0, 1, 2, 2, 3]).must_equal (8 * 4 * 0.8) + (8 * 2 * 0.95)
  end

  it 'applies the maximal discount on a book sequence but not on the single book' do
    subject.price([0, 1, 1, 2, 3, 4]).must_equal 8 + (8 * 5 * 0.75)
  end

  it 'chooses the max discount on a tricky case' do
    subject.price([0, 0, 1, 1, 2, 2, 3, 4]).must_equal 2 * (8 * 4 * 0.8)
  end

  it 'builds a cluster of books' do
    subject.cluster_books([0,0,1,1]).must_equal([0,2,0,0,0])
    subject.cluster_books([1,2,3,4,1]).must_equal([1,0,0,1,0])
    subject.cluster_books([0,1,2,3,4]).must_equal([0,0,0,0,1])
  end

  it 'builds the cheapest cluster of books' do
    subject.optimize_cluster([5, 6, 2, 7, 1]).must_equal([5, 6, 1, 9, 0])
  end

  it 'chooses the max discount on a trickier case' do
    subject.price([0, 0, 0, 0, 0,
                   1, 1, 1, 1, 1,
                   2, 2, 2, 2,
                   3, 3, 3, 3, 3,
                   4, 4, 4, 4]).
      must_equal 3 * (8 * 5 * 0.75) + 2 * (8 * 4 * 0.8)
  end

end
