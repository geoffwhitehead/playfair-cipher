require_relative 'cipher'

cipher = Cipher.new('puzzle')

#p cipher.cube

encrypted = cipher.encrypt('We explored Indiegogo looking for cool projects that can help creatives of all kinds realize their cool ideas and we found some exciting examples to help you follow your art')

decrypted = cipher.decrypt(encrypted)

p 'ENCRYPTED: ' + encrypted
p 'DECRYPTED: ' + decrypted
