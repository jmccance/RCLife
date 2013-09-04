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

  it 'every cell is alive or dead' do
    # Given
    width = 40
    height = 20

    # When
    lb = Grid.new(width, height)

    # Then
    height.times do |i|
      width.times do |j|
        [:dead, :live].should include lb[i, j]
      end
    end
  end

  it 'return nil for invalid coordinates' do
    # Given
    width = 40
    height = 20

    # When
    g = Grid.new(width, height)

    # Then
    g[    -1,     0].should be_nil
    g[height,     0].should be_nil
    g[     0,    -1].should be_nil
    g[     0, width].should be_nil
  end

  it 'should step an empty grid without error' do
    # Given
    g = Grid.new(3, 3)

    # Then
    g.step
  end

  it 'should correctly simulate a spinner' do
    # Given
    init_state = [[:dead, :live, :dead]] * 3
    g = Grid.new(3, 3)
    init_state.length.times do |i|
      init_state[i].length.times do |j|
        g[i, j] = init_state[i][j]
      end
    end

    # When
    g.step

    # Then
    g.height.times do |i|
      g.width.times do |j|
        g[i, j].should eq init_state[j][i]
      end
    end
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
