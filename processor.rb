class Processor
  attr_reader :pairs_hash
  attr_reader :pairs_array

  def initialize(input_filename, output_filename)
    @dictionary = get_words_from_file(input_filename)
    @output_filename = output_filename
    @sequences = []
    @pairs_hash = Hash.new { |pairs_hash, sequence| pairs_hash[sequence] = [] }
  end

  def create_list
    create_sequence_word_pairs
    select_unique_sequences
    alphabetize_pairs_by_sequence
    output_to_file
  end

  def create_sequence_word_pairs
    @dictionary.each do |word|
      extracted_sequences = all_sequences(word)
      extracted_sequences.each { |sequence| @pairs_hash[sequence] << word }
    end
  end

  def all_sequences(word)
    @sequences = []
    while word.length > 3
      four_letter_sequence = word[0..3]
      @sequences << four_letter_sequence
      word = word[1..-1]
    end
    @sequences
  end

  def select_unique_sequences
    @pairs_hash.select! do |sequence, duplicate_words_array|
      duplicate_words_array.length == 1
    end
  end

  def alphabetize_pairs_by_sequence
    @pairs_array = @pairs_hash.map { |sequence, word| [sequence, word.first] }
    @pairs_array.sort_by! { |sequence, word| sequence.downcase }
  end

  def output_to_file
    File.open @output_filename, "w" do |csv|
      csv.puts("'sequences'   'words'\n\n")
      @pairs_array.each do |sequence_word_pair|
        csv.puts([sequence_word_pair[0], sequence_word_pair[1]].join('           '))
      end
    end
  end

  def get_words_from_file(input_filename)
    File.read(input_filename).strip.split
  end
end
