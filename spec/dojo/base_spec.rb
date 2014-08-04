require 'spec_helper'

describe Dojo::Rover do

  let :rover do
    donut = Dojo::Donut.new(x: 100, y: 100)
    subject.new(x: 10,y: 12,direction: :north, donut: donut)
  end

  it 'must initialize rover' do
    rover.position.must_equal({x:10, y:12})
    rover.direction.must_equal :north
  end

  it 'moves forward when receiving f' do
    rover.do!('f')
    rover.position.must_equal({x:10, y:13})
  end

  it 'draws a small square' do
    rover.do!('f', 'r', 'f', 'r', 'f', 'r', 'f')
    rover.position.must_equal({x:10, y:12})
    rover.direction.must_equal :west
  end

  it 'draws a small square backwards' do
    rover.do!('b', 'r', 'b', 'r', 'b', 'r', 'b')
    rover.position.must_equal({x:10, y:12})
    rover.direction.must_equal :west
  end

  it 'goes back to its starting point when receiving fb' do
    rover.do!('f','b')
    rover.position.must_equal({x:10, y:12})
  end

  it 'make a full clockwise turn' do
    rover.do!('r')
    rover.direction.must_equal :east
    rover.do!('r')
    rover.direction.must_equal :south
    rover.do!('r')
    rover.direction.must_equal :west
    rover.do!('r')
    rover.direction.must_equal :north
  end

  it 'make a full counter-clockwise turn' do
    rover.do!('l')
    rover.direction.must_equal :west
    rover.do!('l')
    rover.direction.must_equal :south
    rover.do!('l')
    rover.direction.must_equal :east
    rover.do!('l')
    rover.direction.must_equal :north
  end

  it 'cross the grid edge from the top and go back' do
    donut = Dojo::Donut.new(x: 100, y: 100)
    rover = Dojo::Rover.new(x: 99, y: 99,direction: :north, donut: donut)
    rover.do!('f')
    rover.position.must_equal({x: 99, y: 0})
    rover.do!('b')
    rover.position.must_equal({x: 99, y: 99})
    rover.do!('r', 'f')
    rover.position.must_equal({x: 0, y: 99})
    rover.do!('b')
    rover.position.must_equal({x: 99, y: 99})
  end

  it 'stop in front of a obstacle' do
    donut = Dojo::Donut.new(x: 100, y: 100, obstacles: [{x: 1, y:1}])
    rover = Dojo::Rover.new(x: 0, y: 0,direction: :north, donut: donut)
    error = ->{ rover.do!('f','r','f') }.must_raise Dojo::CollisionError
    rover.position.must_equal({x: 0, y: 1})
    error.obstacle_position.must_equal({x: 1, y: 1})
  end
end
