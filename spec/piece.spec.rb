# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  subject(:pc) { described_class.new(:w, :P) }

  describe '#find_hor_dir' do
    context 'when given dir ends with E' do
      it 'returns :E' do
        hor_dir = pc.find_hor_dir(:E)
        expect(hor_dir).to eq(:E)
      end
    end

    context 'when given dir ends with W' do
      it 'returns :W' do
        hor_dir = pc.find_hor_dir(:W)
        expect(hor_dir).to eq(:W)
      end
    end

    context 'when given dir does not end with E or W' do
      it 'returns :W' do
        hor_dir = pc.find_hor_dir(:N)
        expect(hor_dir).to be_nil
      end
    end
  end

  describe '#find_ver_dir' do
    context 'when given dir starts with N' do
      it 'returns :N' do
        ver_dir = pc.find_ver_dir(:N)
        expect(ver_dir).to eq(:N)
      end
    end

    context 'when given dir starts with S' do
      it 'returns :S' do
        ver_dir = pc.find_ver_dir(:S)
        expect(ver_dir).to eq(:S)
      end
    end

    context 'when given dir does not start with N or S' do
      it 'returns nil' do
        ver_dir = pc.find_ver_dir(:E)
        expect(ver_dir).to be_nil
      end
    end
  end
end
