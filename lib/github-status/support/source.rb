require 'contracts'

module GitHubStatus
  module Support
    module Source
      include ::Contracts::Core
      include ::Contracts::Builtin

      Contract None => String
      def access_token
        @access_token ||= source.fetch 'access_token'
      rescue KeyError
        STDERR.puts 'Source is missing access_token'
        abort
      end

      Contract None => String
      def repo
        @repo ||= source.fetch 'repo'
      rescue KeyError
        STDERR.puts 'Source is missing repo'
        abort
      end

      Contract None => String
      def branch
        @branch ||= source.fetch('branch') { 'master' }
      end

      Contract None => Int
      def api_wait_limit
        @api_wait_limit ||= source.fetch 'api_wait_limit', 900 # 15min
      end

      Contract None => Int
      def api_wait_buffer
        @api_wait_buffer ||= source.fetch 'api_wait_buffer', 60
      end
    end
  end
end
