# frozen_string_literal: true

require 'site_prism/error'
require 'site_prism/all_there'

require 'addressable/template'
require 'capybara/dsl'
require 'forwardable'

require 'site_prism/addressable_url_matcher'
require 'site_prism/dsl'
require 'site_prism/dsl_validator'
require 'site_prism/deprecator'
require 'site_prism/element_checker'
require 'site_prism/loadable'
require 'site_prism/logger'
require 'site_prism/page'
require 'site_prism/rspec_matchers'
require 'site_prism/section'
require 'site_prism/timer'
require 'site_prism/waiter'

# [SitePrism]
module SitePrism
  class << self
    def configure
      yield self
    end

    # The SitePrism logger object - This is called automatically in several
    # locations and will log messages according to the normal Ruby protocol
    # To alter (or check), the log level; call .log_level= or .log_level
    #
    # This logger object can also be used to manually log messages
    #
    # To Manually log a message
    #   SitePrism.logger.info('Information')
    #   SitePrism.logger.debug('Input debug message')
    #
    # By default the logger will output all messages to $stdout, but can be
    # altered to log to a file or another IO location by calling `.log_path=`
    def logger
      @logger ||= SitePrism::Logger.new.create
    end

    # `Logger#reopen` was added in Ruby 2.3 - Which is now the minimum version
    # for the site_prism gem
    #
    # This writer method allows you to configure where you want the output of
    # the site_prism logs to go (Default is $stdout)
    #
    # example: SitePrism.log_path = 'site_prism.log' would save all
    # log messages to `./site_prism.log`
    def log_path=(logdev)
      logger.reopen(logdev)
    end

    # To enable full logging (This uses the Ruby API, so can accept any of a
    # Symbol / String / Integer as an input
    #   SitePrism.log_level = :DEBUG
    #   SitePrism.log_level = 'DEBUG'
    #   SitePrism.log_level = 0
    #
    # To disable all logging (Done by default)
    #   SitePrism.log_level = :UNKNOWN
    def log_level=(value)
      logger.level = value
    end

    # To query what level is being logged
    #   SitePrism.log_level
    #   => :UNKNOWN # By default
    def log_level
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][logger.level]
    end
  end
end
