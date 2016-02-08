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

    pro.instance_variable_set(:@dictionary, ["the", "12th", "Zorro", "morrow"])
    pro.create_sequence_word_pairs

    pairs_hash_with_one_duplicate = {
      "12th" => ["12th"],
      "Zorr" => ["Zorro"],
      "orro" => ["Zorro", "morrow"],
      "morr" => ["morrow"],
      "rrow" => ["morrow"]
    }

    assert_equal pairs_hash_with_one_duplicate, pro.pairs_hash

    # I'm concerned lines 47-57 might be overdoing it.
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    pro.create_sequence_word_pairs

    assert_kind_of(Hash, pro.pairs_hash)

    pro.pairs_hash.each do |sequence, word_array|
      assert_kind_of String, sequence
      assert_kind_of Array, word_array
      assert_operator word_array.length, :>=, 1
    end
  end

  def test_select_unique_sequences
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    pro.instance_variable_set(:@pairs_hash, {"orro" => ["Zorro", "morrow"], "fall" => ["fallout"]})

    assert_equal({"fall" => ["fallout"]}, pro.select_unique_sequences)

    # This as well, possibly overdoing it, lines 68-79.
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    pro.create_sequence_word_pairs
    pro.select_unique_sequences

    assert_kind_of(Hash, pro.pairs_hash)

    pro.pairs_hash.each do |sequence, word_array|
      assert_kind_of String, sequence
      assert_kind_of Array, word_array
      assert_equal 1, word_array.length
    end
  end

  def test_alphabetize_pairs_by_sequence
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    unordered_hash = {"Simo" => ["under"], "beef"=> ["made"], "12th" => ["damsel"], "'eli" => ["brute"]}
    ordered_array = [["'eli", "brute"], ["12th", "damsel"], ["beef", "made"], ["Simo", "under"]]

    pro.instance_variable_set(:@pairs_hash, unordered_hash)

    assert_equal ordered_array, pro.alphabetize_pairs_by_sequence

    # And lastly lines 93-107.
    pro = Processor.new("dictionary.txt", "sequence_list.txt")

    pro.create_sequence_word_pairs
    pro.select_unique_sequences
    pro.alphabetize_pairs_by_sequence

    assert_kind_of(Array, pro.pairs_array)

    pro.pairs_array.each do |sequence_word_pair|
      assert_kind_of Array, sequence_word_pair
      assert_equal 2, sequence_word_pair.length
      assert_kind_of String, sequence_word_pair[0]
      assert_kind_of String, sequence_word_pair[1]
    end
  end
end
