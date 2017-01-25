class Cipher

    attr_reader :key, :cube

    $RULE_1 = 1
    $RULE_2 = 2
    $RULE_3 = 3
    $DELIM_CHAR = 'x'

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

    def decrypt(message)

        # iterate over the message string encrypting the pairs and buildings encryted message.
        index = 0
        decrypted_string = ''
        while index < message.length do
            decrypted_string << decrypt_pair(message[index], message[index + 1])
            index += 2
        end

        # remove the delimiting chars that were added during the encryption
        decrypted_string = decrypted_string.tr($DELIM_CHAR, '')

        return decrypted_string
    end

    def encrypt(message)

        message = message.tr(" ", '').tr("j", 'i').downcase # remove white space, swap 'j' for 'i' (chars is not included in cube array), change to lowercase

        # loop through message and insert 'x' between duplicate chars
        prev_char = ''
        message.each_char.with_index do |char, index|
            message.insert(index, $DELIM_CHAR) if char == prev_char
            prev_char = char
        end

        # a delimeter needs to be appended if the string wont divide into pairs equally
        message.insert( message.length, $DELIM_CHAR) if message.length % 2 != 0

        # iterate over the message string encrypting the pairs and buildings encryted message.
        index = 0
        encrypted_string = ''
        while index < message.length do
            encrypted_string << encrypt_pair(message[index], message[index + 1])
            index += 2
        end

        return encrypted_string
    end

    # this function will analyse a pair to determine what rule to use to encrypt the pair
    def determine_rule(ch_1, ch_2)
        pair = Array.new([ch_1, ch_2]) # create a sorted array with the pairs of chars
        return $RULE_1 if cube.index(ch_1) / 5 == cube.index(ch_2) / 5
        return $RULE_2 if (cube.index(pair.max) - cube.index(pair.min)) % 5 == 0
        return $RULE_3
    end

    # takes a pair of letters and return the encrypted characters
    def encrypt_pair(ch_1, ch_2)
        enc_1 = ''
        enc_2 = ''

        p '---'
        p ch_1
        p ch_2
        case determine_rule(ch_1, ch_2)
        when $RULE_1
            cube.index(ch_1) / 5 < (cube.index(ch_1) + 1) / 5 ? enc_1 = cube[cube.index(ch_1) - 4].dup : enc_1 = cube[cube.index(ch_1) + 1].dup
            cube.index(ch_2) / 5 < (cube.index(ch_2) + 1) / 5 ? enc_2 = cube[cube.index(ch_2) - 4].dup : enc_2 = cube[cube.index(ch_2) + 1].dup
        when $RULE_2
            (cube.index(ch_1) + 5) > 24? enc_1 = cube[cube.index(ch_1) - 20 ].dup : enc_1 = cube[cube.index(ch_1) + 5].dup
            (cube.index(ch_2) + 5) > 24? enc_2 = cube[cube.index(ch_2) - 20 ].dup : enc_2 = cube[cube.index(ch_2) + 5].dup
        when $RULE_3
            arr = do_rule_3(ch_1, ch_2)
            enc_1 = arr[0]
            enc_2 = arr[1]
        else
            raise_error('unknown case when encrypting')
        end
        return enc_1 << enc_2
    end

    # takes a pair of letters and return the decrypted characters
    def decrypt_pair(ch_1, ch_2)
        dec_1 = ''
        dec_2 = ''

        case determine_rule(ch_1, ch_2)
        when $RULE_1
            cube.index(ch_1) / 5 > (cube.index(ch_1) - 1) / 5 ? dec_1 = cube[cube.index(ch_1) + 4].dup : dec_1 = cube[cube.index(ch_1) - 1].dup
            cube.index(ch_2) / 5 > (cube.index(ch_2) - 1) / 5 ? dec_2 = cube[cube.index(ch_2) + 4].dup : dec_2 = cube[cube.index(ch_2) - 1].dup
        when $RULE_2
            (cube.index(ch_1) - 5) < 0? dec_1 = cube[cube.index(ch_1) + 20 ].dup : dec_1 = cube[cube.index(ch_1) - 5].dup
            (cube.index(ch_2) - 5) < 0? dec_2 = cube[cube.index(ch_2) + 20 ].dup : dec_2 = cube[cube.index(ch_2) - 5].dup
        when $RULE_3
            arr = do_rule_3(ch_1, ch_2)
            dec_1 = arr[0]
            dec_2 = arr[1]
        else
            raise_error('unknown case when decrypting')
        end
        return dec_1 << dec_2
    end

    # encrypts or decrypts using rule 3 - the rule where you form a rectangle
    def do_rule_3(ch_1, ch_2)
        pair = Array.new([cube.index(ch_1), cube.index(ch_2)]).sort

        i = pair[0]
        j = pair[1]
        if pair[0] % 5 > pair[1] % 5 # down - left : using mod will tell us whether the other index is located down and left or down and right
            while i < pair[1] do # keep incrementing until the index passes the other index, the corner point is the last index before this happens
                i += 5
            end
            while j > pair[0] do
                j -= 5
            end
        else # down - right
            while i + 5 < pair[1] do
                i += 5
            end
            while j - 5 > pair[0] do
                j -= 5
            end
        end
        new_1 = cube[j].dup
        new_2 = cube[i].dup

        # the index were initially sorted to make the algo simpler. Switch the values to match the order in which they were received
        if cube.index(ch_1) > cube.index(ch_2)
            temp = new_1
            new_1 = new_2
            new_2 = temp
        end

        return [new_1, new_2]
    end

    private :build_cube, :determine_rule, :encrypt_pair, :decrypt_pair

end
