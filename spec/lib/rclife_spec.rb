require 'spec_helper'

include RCLife

describe 'Grid' do
  it 'can be initialized' do
    Grid.new(20, 40)
  end

  it 'has the height and width it was initialized with' do
    # Given
    width = 40
    height = 20

    # When
    lb = Grid.new(width, height)

    # Then
    lb.width.should eq width
    lb.height.should eq height
  end

  it 'has a Cell in every valid coordinate' do
    # Given
    width = 40
    height = 20

    # When
    lb = Grid.new(width, height)

    # Then
    height.times do |i|
      width.times do |j|
        lb[i, j].class.should eq Cell
      end
    end
  end

  it 'raises an IndexError if an invalid coordinate is accessed' do
    # Given
    width = 40
    height = 20

    # When
    g = Grid.new(width, height)

    # Then
    expect { g[    -1,     0] }.to raise_error IndexError
    expect { g[height,     0] }.to raise_error IndexError
    expect { g[     0,    -1] }.to raise_error IndexError
    expect { g[     0, width] }.to raise_error IndexError
  end
end

describe 'Rules' do
  def gen_living_neighbors(count)
    living = Array.new(count) { :live } 
    dead = Array.new(8 - count) { :dead }
    (living + dead).shuffle(random: rand)
  end

  it 'resurrects a dead cell with exactly three neighbors' do
    Rules.apply(:dead, gen_living_neighbors(3)).should eq :live
  end

  it 'leaves a cell dead if it does not have three neighbors' do
    ((0..8).to_a - [3]).each do |n|
      Rules.apply(:dead, gen_living_neighbors(n)).should eq :dead
    end
  end

  it 'preserves a living cell with two or three neighbors' do
    [2, 3].each do |n|
      Rules.apply(:live, gen_living_neighbors(n)).should eq :live
    end
  end

  it 'starves a living cell with one or zero neighbors' do
    [0, 1].each do |n|
      Rules.apply(:live, gen_living_neighbors(n)).should eq :dead
    end
  end

  it 'overcrowds living cells with four or more neighbors' do
    (4..8).each do |n|
      Rules.apply(:live, gen_living_neighbors(n)).should eq :dead
    end
  end
end
