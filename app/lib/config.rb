require 'optparse'

module HTTPServer
  class Config
    attr_reader :directory

    def initialize
      @directory = parse_options[:directory] || "tmp"
    end

    private

    def parse_options
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: server.rb [options]"
        opts.on("--directory DIRECTORY", "Specify the directory where files are stored") do |dir|
          options[:directory] = dir
        end
      end.parse!
      options
    end
  end
end