class Cipher

    attr_reader :key, :cube

    def initialize(key)
        raise_exception('key too large') if key.length > 15
        @key = key
        @cube = build_cube(key)

    end

    def raise_exception(message)
        raise 'An error has occured: ' + message
    end

    def build_cube(key)
        arr = Array.new()

        #push each unique char from key into the cube array
        key.split("").uniq.each do |char|
            arr.push(char)
        end

        # populate array with with alphabets remaining non duplicate characters or the char 'j'
        i = 'a'.ord
        while i <= 'z'.ord
            arr.push(i.chr) if (!arr.include? i.chr) && i != 'j'.ord
            i += 1
        end

        raise_exception('array size exceeded during building') if arr.length > 25

        return arr
    end

    def encrypt(message)

        delim_char = 'x'

        message = message.tr(" ", '')

        temp = ''
        message.each_char.with_index do |char, index|
            message.insert(index+1, delim_char)
            p char
            p index
        end
        # seperate duplicate letters with an 'x'
        # remove spaces
        # pair all the letters
        # # rule 1
        # same row - select letters directly to the right of the letters - if on the end, wrap on same row
        # # rule 2
        # same column - select the letters directly below the letters - in the same order - if on the bottom, wrap on same column
        # # rule 3
        # not on the same row - in the same order select the 2 letters that form a rectangle
    end


    def decrypt(message)

    end
end
