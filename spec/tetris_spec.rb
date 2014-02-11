require 'spec_helper'

describe TetrisEngine::Tetris do
  let(:tetris) { TetrisEngine::Tetris.new 10, 22}

  describe '#new' do
    it 'initializes the playing field with correct height' do
       expect(tetris.rows.length).to equal(22)
    end
    it 'initializes the playing field with correct width' do
       expect(tetris.rows.first.length).to equal(10)
    end
  end

  describe '#add_row' do
    it 'adds a row to the playing field' do
      start_height = tetris.rows.length
      tetris.add_row
      expect(tetris.rows.length).to equal(start_height+1)
    end
  end

  describe '#game_over?' do
    it 'terminates the game when tetrominoes reach the top' do
      11.times { tetris.play TetrisEngine::Tetromino.new }
      expect(tetris.game_over?).to equal true
    end
  end

  describe '#play' do
    let(:tetromino) { TetrisEngine::Tetromino.new }
    it 'correctly places tetromino on the empty board' do
      tetris.play tetromino
      expected_cells = tetris.rows.first[tetromino.location..tetromino.location+1] +
                        tetris.rows[1][tetromino.location..tetromino.location+1]
      expect(expected_cells.uniq).to eq [tetromino.color]
    end
    it 'places tetromino on top of a previously played tetromino' do
      tetris.play tetromino
      tetris.play tetromino
      expected_cells = tetris.rows[2][tetromino.location..tetromino.location+1] +
                        tetris.rows[3][tetromino.location..tetromino.location+1]
      expect(expected_cells.uniq).to eq [tetromino.color]
    end
  end

  describe '#clear_lines' do
    it 'clears a single line of the same color' do
      tetris.rows.first.fill TetrisEngine::Tetromino::COLORS.first
      expect(tetris.clear_lines).to equal 1
      expect(tetris.rows.first.uniq).to eq [' ']
    end
    it 'clears multiple lines of the same color' do
      tetris.rows.first.fill TetrisEngine::Tetromino::COLORS.first
      tetris.rows[1].fill TetrisEngine::Tetromino::COLORS.first.next
      expect(tetris.clear_lines).to equal 2
      expect(tetris.rows.first.uniq).to eq [' ']
      expect(tetris.rows[1].uniq).to eq [' ']
    end
    it "does not clear a line that's not filled with the same color" do
      tetris.rows.first[3] = TetrisEngine::Tetromino::COLORS.first
      expected_line = tetris.rows.first
      expect(tetris.clear_lines).to equal 0
      expect(tetris.rows.first).to eq expected_line
    end
  end

  describe '#decrement_tops' do
    it "decrements each top's index by 1" do
      tetris.instance_variable_set(:@tops, Array.new(10, 1))
      tetris.decrement_tops
      expect(tetris.instance_variable_get(:@tops).uniq).to eq [0]
    end
  end
end

describe TetrisEngine::Tetromino do
  let(:tetromino) { TetrisEngine::Tetromino.new}

  describe '#new' do
    it 'initializes tetromino with correct color' do
      expect(TetrisEngine::Tetromino::COLORS).to include (tetromino.color)
    end
  end

  describe '#move' do
    it "changes tetromino's location to the given coordinate" do
      expect(tetromino.move 0).to equal 0
    end
  end
end