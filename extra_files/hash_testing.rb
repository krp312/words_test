# h = {"string1"=>["string2"], "string3"=>["string4"], "string5"=>["string6"], "string7"=>["string8"]}
#
# # print h.each { |k,v| [k,v.to_s] }.to_a
#
# h = {"string1"=>["string2"], "string3"=>["string4"], "string5"=>["string6"], "string7"=>["string8"]}.each { |k,v| [k,v] }.to_a
#
# print h

#
# h = {"string1"=>["string2"], "string3"=>["string4"], "string5"=>["string6"], "string7"=>["string8"]}.map { |k,v| [k,v].flatten }
#
# print h


@test_hash = {"arro"=>["arrows", "carrots"], "rrow"=>["arrows"], "rows"=>["arrows"], "carr"=>["carrots"], "rrot"=>["carrots"], "rots"=>["carrots"], "give"=>["give"]}

def select_unique_sequences
  @test_hash.select do |sequence, duplicate_words_array|
    duplicate_words_array.length == 1
  end
end



select_unique_sequences
