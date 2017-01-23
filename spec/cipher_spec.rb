require_relative './../cipher'




RSpec.describe Cipher, "#build" do

    let(:cipher) { Cipher.new("puzzle") }

    context "creating a cipher cube" do

        it "removes duplicate letters from message" do
            expect(cipher.cube[0,5]).to eq(["p", "u", "z", "l", "e"])
        end

        it "fills the remainder of array with alphabet (no duplicates)" do
            expect(cipher.cube).to eq(["p", "u", "z", "l", "e", "a", "b", "c", "d", "f", "g", "h", "i", "k", "m", "n", "o", "q", "r", "s", "t", "v", "w", "x", "y"])
        end
        it "raises error when key too large" do
            expect{Cipher.new('thiskeyistoolarge')}.to raise_error(RuntimeError)
        end

        it "should be 25 characters" do
            expect(cipher.cube.length).to eq(25)
        end

    end

    context "encrypting a message" do

        
    end
end
