require 'irb/completion' 
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

module Readline
  module History
    LOG = "#{ENV['HOME']}/.irb-history"

    def self.write_log(line)
      File.open(LOG, 'ab') {|f| f << "#{line}\n"} unless line == "quit"
    end

    def self.start_session_log
    end
  end

  alias :old_readline :readline
  def readline(*args)
    ln = old_readline(*args)
    begin
      History.write_log(ln)
    rescue
    end
    ln
  end
end

Readline::History.start_session_log

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 10
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"


# auto-indent
IRB.conf[:AUTO_INDENT]=true
#puts "Auto-indent on."
 
# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end
 
# try to load rubygems
begin
  require "rubygems"
  #puts "Rubygems loaded."
rescue LoadError => e
  puts "Seems you don't have Rubygems installed: #{e}"
end
 
# let there be colors
# just use Wirble for colors, since some enviroments dont have
# rubygems and wirble installed
begin
  require "wirble"
  Wirble.init(:skip_prompt=>true,:skip_history=>true)
  Wirble.colorize
  #puts "Wirble loaded. Now you have colors."
rescue LoadError => e
  puts "Seems you don't have Wirble installed: #{e}"
end
 
# method for load factory_girl
def load_factory
  begin
    require "faker"
    require "factory_girl"
    Dir.glob('test/factories/*_factory.rb').each { |file| require file }
    #puts "Factory_girl loaded."
  rescue LoadError => e
    puts "Seems you don't have factory_girl installed: #{e}"
  end
end
