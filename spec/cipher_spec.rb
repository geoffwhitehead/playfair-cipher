require 'cipher'


RSpec.describe Cipher, "#build" do
    context "creating a cipher cube" do
        it "removes duplicate letters from message" do
            Cipher = Cipher.new("secret message", "puzzle")
            check that string_array = ['p',]"puzle"
        end
    end
end
