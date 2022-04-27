module DcidevUtility
    class << self
        def is_numeric?(number)
            number = number.to_s
            data = number.delete("+")
            result = data =~ /^-?[0-9]+$/
            result == 0
        end

        def phone_converter(number)
            return if number.nil?
            phone = number.to_s.scan(/\d+/).join
            return phone.sub('0', '62') if number[0] == '0'
            return phone.sub('+', '') if number[0] == '+'

            phone
        end

        def download_to_file(url)
            begin
                uri = URI::parse(url)
                extension = File.extname(uri.path)
                stream = URI::open(url, "rb")
                Tempfile.new([File.basename(uri.path), extension]).tap do |file|
                    file.binmode
                    IO.copy_stream(stream, file)
                    stream.close
                    file.rewind
                end
            rescue => e
                return nil
            end
        end

        def is_phone_number?(phone)
            chars = ('a'..'z').to_a + ('A'..'Z').to_a
            phone.chars.detect { |ch| !chars.include?(ch) }.nil?
        end

        def original_phone(phone)
            unless phone.nil?
                phone = phone.to_s.scan(/\d+/).join
                return phone.sub('62', '0') if phone[0] == '6' && phone[1] == '2'
                if phone[0] == '+' && phone[1] == '6' && phone[2] == '2'
                    return phone.sub('+62', '0')
                end

                phone
            end
        end

        def file_url_to_base64(url)
            return [nil, nil, nil] if url.nil?
            file = self.download_to_file(url)
            return self.file_to_base64(file)
        end

        def file_to_base64(file)
            encoded = Base64.strict_encode64(file.read)
            extension = MimeMagic.by_magic(file).type.to_s
            [extension, encoded, "data:#{extension};base64,#{encoded}"]
        end

        def is_base64?(value)
            value.is_a?(String) && Base64.strict_encode64(Base64.decode64(value)) == value
        end

        def base64_to_file(string)
            Base64.strict_decode64(string)
        end

        def valid_json?(json)
            JSON.parse(json)
            true
        rescue JSON::ParserError => e
            return false
        end

        def body_simplifier(body)
            if body.class == String && (valid_json? body)
                JSON.parse(body)
            else
                body
            end
        end

        def check_integer(integer)
            if integer.is_a? String
                chars = ('a'..'z').to_a + ('A'..'Z').to_a
                integer.chars.detect { |ch| chars.include?(ch) }.nil?
            else
                return true
            end
        end

        def check_string(string)
            string = string.delete(" ")
            chars = ('a'..'z').to_a + ('A'..'Z').to_a
            string.chars.detect { |ch| !chars.include?(ch) }.nil?
        end

        def url_exist?(url)
            success = true
            begin
                success = false unless Net::HTTP.get_response(URI.parse(url)).is_a?(Net::HTTPSuccess)
            rescue
                success = false
            end
            success
        end

        def dob_from_nik(nik)
            now = Time.now.utc.to_date
            tanggal_lahir = nik[6..7].to_i
            if tanggal_lahir > 40
                tanggal_lahir = tanggal_lahir - 40
            end
            bulan_lahir = nik[8..9].to_i
            if bulan_lahir < 10
                bulan_lahir = "0" + bulan_lahir.to_s
            end
            tahun_lahir = nik[10..11].to_i
            if (tahun_lahir + 2000) > now.year
                tahun_lahir = "19" + nik[10..11].to_s
            else
                tahun_lahir = "20" + nik[10..11].to_s
            end

            if tanggal_lahir.to_s.length == 1
                tanggal_lahir = '0' + tanggal_lahir.to_s
            end

            dob = tahun_lahir.to_s + "-" + bulan_lahir.to_s + "-" + tanggal_lahir.to_s
            if tahun_lahir.to_i > now.year or bulan_lahir.to_i > 12 or tanggal_lahir.to_i > 31 or tahun_lahir.to_i == 0 or bulan_lahir.to_i == 0 or tanggal_lahir.to_i == 0
                dob = '1945-08-17'
            else
                dob = dob
            end
            dob
        end

        def gender_from_nik(nik)
            nik[6..7].to_i < 40 ? "L" : "P"
        end

        def currency_formatter(amount, unit: "Rp. ", separator: ".", delimiter: ".", precision: 0)
            begin
                amount = amount.to_i
            rescue
                amount = 0
            end
            ActionController::Base.helpers.number_to_currency(amount, unit: unit, separator: separator, delimiter: delimiter, precision: precision)
        end

        def name_validator(string)
            string = string.to_s.delete(" ")
            chars = ('a'..'z').to_a + ('A'..'Z').to_a
            string.chars.detect { |ch| !chars.include?(ch) }.nil?
        end

        def base64_encoded_string(base64)
            base64.split(",").last.strip
        end

        def base64_extension(base64)
            base64.split(";").first.split(":").last
        end

        def string_masking(string, length = 9)
            return "" if string.nil?
            return string.sub(string[0...length], 'x' * length)
        end

        def response_simplifier(response)
            if response.class == String
                return JSON.parse response
            end
            return response if response.class == Hash
            return response if response.nil?

            if response.class == Net::HTTPInternalServerError || response.class == Net::HTTPCreated || response.class == Net::HTTPBadGateway || response.class == Net::HTTPUnprocessableEntity
                return response.to_json
            end

            if valid_json? response
                simple_response = JSON.parse(response)
            else
                simple_response = response
            end

            if simple_response.class == RestClient::Response
                simple_response = {
                    :error => response.bytes.pack("c*").force_encoding("UTF-8")
                }.to_json
            end

            simple_response
        end

        def email_valid?(email)
          email.to_s.match(/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/).present?
        end
    end
end