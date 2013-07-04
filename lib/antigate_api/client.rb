require 'net/http'
require 'net/http/post/multipart'

module AntigateApi
  class Client
    attr_reader :key
    attr_accessor :options

    DEFAULT_CONFIGS = {
      recognition_time: 5, # First waiting time
      sleep_time: 1, # Sleep time for every check interval
      timeout: 60, # Max time out for decoding captcha
      debug: false # Verborse or not
    }

    def initialize(key, opts={})
      @key = key
      @options = DEFAULT_CONFIGS.merge(opts)
    end

    def send_captcha( captcha_file )
      uri = URI.parse( 'http://antigate.com/in.php' )
      file = File.new( captcha_file, 'rb' )
      req = Net::HTTP::Post::Multipart.new( uri.path,
                                           :method => 'post',
                                           :key => @key,
                                           :file => UploadIO.new( file, 'image/jpeg', 'image.jpg' ),
                                           :numeric => 1 )
      http = Net::HTTP.new( uri.host, uri.port )
      begin
        resp = http.request( req )
      rescue => err
        puts err
        return nil
      end

      id = resp.body
      id[ 3..id.size ]
    end

    def get_captcha_text( id )
      data = { :key => @key,
               :action => 'get',
               :id => id,
               :min_len => 5,
               :max_len => 5 }
      uri = URI.parse('http://antigate.com/res.php' )
      req = Net::HTTP::Post.new( uri.path )
      http = Net::HTTP.new( uri.host, uri.port )
      req.set_form_data( data )

      begin
        resp = http.request(req)
      rescue => err
        puts err
        return nil
      end

      text = resp.body
      if text != "CAPCHA_NOT_READY"
        return text[ 3..text.size ]
      end
      nil
    end

    def report_bad( id )
      data = { :key => @key,
               :action => 'reportbad',
               :id => id }
      uri = URI.parse('http://antigate.com/res.php' )
      req = Net::HTTP::Post.new( uri.path )
      http = Net::HTTP.new( uri.host, uri.port )
      req.set_form_data( data )

      begin
        resp = http.request(req)
      rescue => err
        puts err
      end
    end

    def decode(captcha_file)
      captcha_id = self.send_captcha(captcha_file)
      start_time = Time.now.to_i
      sleep @options[:recognition_time]

      code = nil
      while code == nil do
        code = self.get_captcha_text( captcha_id )
        duration = Time.now.to_i - start_time
        puts "Spent time: #{duration}" if @options[:debug]
        sleep @options[:sleep_time]
        raise AntigateApi::Errors::TimeoutError.new if duration > @options[:timeout]
      end

      [captcha_id, code]
    end
  end
end

