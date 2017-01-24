class Cipher

    attr_reader :key, :cube

    $RULE_1 = 1
    $RULE_2 = 2
    $RULE_3 = 3

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

        raise_exception('array size incorrect during building') if arr.length != 25

        return arr
    end

    def encrypt(message)

        delim_char = 'x'

        message = message.tr(" ", '') # remove white space

        # loop through message and insert 'x' between duplicate chars
        temp = ''
        message.each_char.with_index do |char, index|
            message.insert(index, delim_char) if char == temp
            temp = char
        end

        # a delimeter needs to be appended if the string wont divide into pairs equally
        message.insert( message.length, delim_char) if message.length % 2 != 0

        # loop through message, encrypt pairs, append to encrypt string
        index = 0
        encrypted_string = ''

        # iterate over the message string encrypting the pairs and buildings encryted message.
        while index < message.length do
            encrypted_string << encrypt_pair(message[index], message[index + 1], determine_rule(message[index], message[index+1]))
            index += 2
        end

        p 'ENCRYPTED STRING'
        p encrypted_string

        #p encrypt_pair('c', 'r', determine_rule('c', 'r'))
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

    # this function will analyse a pair to determine what rule to use to encrypt the pair
    def determine_rule(ch_1, ch_2)
        #p '---'
        #p ch_1
        #p ch_2
        #p cube.index(ch_1)
        #p cube.index(ch_2)
        #p cube
        pair = Array.new([ch_1, ch_2]) # create a sorted array with the pairs of chars
        return $RULE_1 if cube.index(ch_1) / 5 == cube.index(ch_2) / 5
        return $RULE_2 if (cube.index(pair.max) - cube.index(pair.min)) % 5 == 0
        return $RULE_3
    end

    def encrypt_pair(ch_1, ch_2, rule)
        p ' < -------'
        enc_1 = ''
        enc_2 = ''

        case rule
        when $RULE_1
            p 'R1'
            cube.index(ch_1) / 5 < (cube.index(ch_1) + 1) / 5 ? enc_1 = cube[cube.index(ch_1) - 4].dup : enc_1 = cube[cube.index(ch_1) + 1].dup
            cube.index(ch_2) / 5 < (cube.index(ch_2) + 1) / 5 ? enc_2 = cube[cube.index(ch_2) - 4].dup : enc_2 = cube[cube.index(ch_2) + 1].dup
        when $RULE_2
            p 'R2'
            (cube.index(ch_1) + 5) > 24? enc_1 = cube[cube.index(ch_1) - 20 ].dup : enc_1 = cube[cube.index(ch_1) + 5].dup
            (cube.index(ch_2) + 5) > 24? enc_2 = cube[cube.index(ch_2) - 20 ].dup : enc_2 = cube[cube.index(ch_2) + 5].dup

        when $RULE_3
            p 'R3'
            pair = Array.new([cube.index(ch_1), cube.index(ch_2)]).sort
            p 'INPUTS'
            p ch_1
            p ch_2
            ##p ((pair[1] - pair[0]).to_f / 5.to_f).round
            #p ((pair[1] - pair[0]).to_f / 5.to_f).floor
            #p pair[0] + ( 5 * ((pair[1] - pair[0]).to_f / 5.to_f).round)
            adjustment = 0

            if pair[0] % 5 > pair[1] % 5 # down -left
                adjustment = (((pair[0] + pair[1]) / 5).floor) * 5
                enc_1 = cube[pair[0] + adjustment].dup
                enc_2 = cube[pair[1] - adjustment].dup
            else # down - right
                adjustment = (((pair[1] - pair[0]) / 5).floor) * 5
                enc_1 = cube[pair[1] - adjustment].dup
                enc_2 = cube[pair[0] + adjustment].dup
            end

            p 'adjustment'
            p adjustment

            #enc_1 = cube[cube.index(ch_1) + adjustment]
            #enc_2 = cube[cube.index(ch_2) - adjustment]

            p ' RESULTS'
            p enc_1
            p enc_2
            # array was sorted to make the algo simpler. May be necessary to switch to retain original order
            if cube.index(ch_1) > cube.index(ch_2)
                temp = enc_1
                enc_1 = enc_2
                enc_2 = temp
            end


        else
            raise_error('unknown case when encrypting')
        end

        return enc_1 << enc_2

    end

    def decrypt_pair(ch_1, ch_2, rule)
        case rule
        when $RULE_1

        when $RULE_2

        when $RULE_3

        else
            raise_error('unknown case when decrypting')
        end
    end

    private :build_cube, :determine_rule, :encrypt_pair, :decrypt_pair

end
