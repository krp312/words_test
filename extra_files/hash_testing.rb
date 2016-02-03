# h = {"string1"=>["string2"], "string3"=>["string4"], "string5"=>["string6"], "string7"=>["string8"]}
#
# # print h.each { |k,v| [k,v.to_s] }.to_a
#
# h = {"string1"=>["string2"], "string3"=>["string4"], "string5"=>["string6"], "string7"=>["string8"]}.each { |k,v| [k,v] }.to_a
#
# print h


h = {"string1"=>["string2"], "string3"=>["string4"], "string5"=>["string6"], "string7"=>["string8"]}.map { |k,v| [k,v].flatten }

print h
