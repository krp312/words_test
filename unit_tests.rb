require 'test/unit'
require_relative 'processor'

class TestProcessor < Test::Unit::TestCase
  def test_all_sequences
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    short_sequences = pro.all_sequences("abc")

    assert_equal([], short_sequences)

    sequences = pro.all_sequences("magnet")

    assert_equal("magn", sequences.first)
    assert_equal("gnet", sequences.last)
  end

  def test_get_words_from_file
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    words = pro.get_words_from_file("dictionary.txt")

    assert_instance_of(Array, words)
    assert_equal(words, words.grep(String))
    assert_equal(25_143, words.count)
    assert_no_match(/\s/, words.join)
    assert_nil words.detect{ |w| w.length == 0 }
  end

  def test_create_sequence_word_pairs
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    pro.create_sequence_word_pairs

    assert_kind_of(Hash, pro.pairs_hash)

    pro.pairs_hash.each do |sequence, word_array|
      assert_kind_of String, sequence
      assert_kind_of Array, word_array
      assert_operator word_array.length, :>=, 1
    end
  end

  def test_alphabetize_pairs_by_sequence
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    pro.create_sequence_word_pairs
    pro.select_unique_sequences
    pro.alphabetize_pairs_by_sequence

    assert_kind_of(Array, pro.pairs_array)

    pro.pairs_array.each do |sequence_word_pair|
      assert_kind_of Array, sequence_word_pair
      assert_equal 2, sequence_word_pair.length
    end
  end
end
