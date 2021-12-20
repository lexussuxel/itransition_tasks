require 'sha3'

hashes = []
email = "bloodangelalexandra@gmail.com"

Dir["iles/*"].each do |a|
  hashes << SHA3::Digest::SHA256.file(a).hexdigest
end

answ = hashes.sort!.join
p SHA3::Digest::SHA256.new(answ << email).hexdigest
