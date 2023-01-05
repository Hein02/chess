# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  subject(:pc) { described_class.new(:w, :P) }

  describe '#find_fl_dir' do
    context 'when given dir ends with E' do
      it 'returns :E' do
        fl_dir = pc.find_fl_dir(:E)
        expect(fl_dir).to eq(:E)
      end
    end

    context 'when given dir ends with W' do
      it 'returns :W' do
        fl_dir = pc.find_fl_dir(:W)
        expect(fl_dir).to eq(:W)
      end
    end

    context 'when given dir does not end with E or W' do
      it 'returns :W' do
        fl_dir = pc.find_fl_dir(:N)
        expect(fl_dir).to be_nil
      end
    end
  end

  describe '#find_rk_dir' do
    context 'when given dir starts with N' do
      it 'returns :N' do
        rk_dir = pc.find_rk_dir(:N)
        expect(rk_dir).to eq(:N)
      end
    end

    context 'when given dir starts with S' do
      it 'returns :S' do
        rk_dir = pc.find_rk_dir(:S)
        expect(rk_dir).to eq(:S)
      end
    end

    context 'when given dir does not start with N or S' do
      it 'returns nil' do
        rk_dir = pc.find_rk_dir(:E)
        expect(rk_dir).to be_nil
      end
    end
  end

  describe '#find_adj_rk' do
    it 'returns the adjacent rank' do
      cur_rk = :'2'
      rk_dir = :S
      adj_rk = pc.find_adj_rk(cur_rk, rk_dir)
      expect(adj_rk).to eq(:'1')
    end

    context 'when there is no rank dir' do
      it 'returns rank of current sqr' do
        cur_rk = :'1'
        adj_rk = pc.find_adj_rk(cur_rk, nil)
        expect(adj_rk).to eq(cur_rk)
      end
    end

    context 'when cur_rk is at the edge of the board' do
      it 'returns nil' do
        cur_rk = :'1'
        rk_dir = :S
        adj_rk = pc.find_adj_rk(cur_rk, rk_dir)
        expect(adj_rk).to be_nil
      end
    end
  end

  describe '#find_adj_fl' do
    it 'returns the adjacent file' do
      cur_fl = :a
      fl_dir = :E
      adj_fl = pc.find_adj_fl(cur_fl, fl_dir)
      expect(adj_fl).to eq(:b)
    end

    context 'when there is no file dir' do
      it 'returns file of current sqr' do
        cur_fl = :a
        adj_fl = pc.find_adj_fl(cur_fl, nil)
        expect(adj_fl).to eq(cur_fl)
      end
    end

    context 'when cur_fl is at the edge of the board' do
      it 'returns nil' do
        cur_fl = :a
        ver_dir = :W
        adj_fl = pc.find_adj_fl(cur_fl, ver_dir)
        expect(adj_fl).to be_nil
      end
    end
  end

  describe '#find_adj_sq' do
    it 'returns the adjacent sqr of the current sq' do
      cur_sq = :b1
      fl_dir = :E
      rk_dir = :N
      adj_sq = pc.find_adj_sq(cur_sq, fl_dir, rk_dir)
      expect(adj_sq).to eq(:c2)
    end
  end

  describe '#traverse' do
    context 'when there is no adjacent sqr' do
      it 'stops the loop and returns the path it traversed' do
        stack = [:a1]
        fl_dir = :E
        rk_dir = nil
        path = pc.traverse(stack, fl_dir, rk_dir)
        expected = %i[b1 c1 d1 e1 f1 g1 h1]
        expect(path).to eq(expected)
      end
    end
  end
end
