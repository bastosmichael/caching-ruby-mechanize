#!/usr/bin/env ruby
require 'mechanize'
require 'net/http'
require 'uri'
require 'vcr'
require 'fakeweb'
require 'digest/md5'

VCR.configure { |c|
  c.cassette_library_dir = 'tmp/'
  c.hook_into :fakeweb
  c.allow_http_connections_when_no_cassette = true
}

class Caching
	def initialize
    	@agent = Mechanize.new
	    @agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11'
	    @agent.open_timeout = 300
	    @agent.read_timeout = 300
	    @agent.html_parser = Nokogiri::HTML
	    @agent.ssl_version = 'SSLv3'
	    @agent.keep_alive = false
	    @agent.idle_timeout = 300
	    url = ["http://google.com",
	    	   	"http://yahoo.com",
	    		"http://msnbc.com"]
	    url.each do |u|
	    	run u
		end
  	end

  	def run url
	    digest = Digest::MD5.hexdigest(url)
        puts "Hash: #{digest}"
        VCR.use_cassette("#{digest}") do
          page = @agent.get(url)
          puts page.body
        end
  	end
end

Caching.new