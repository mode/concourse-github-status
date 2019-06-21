require 'contracts'
require 'octokit'

module GitHubStatus
  module Support
    module GitHub
      include ::Contracts::Core
      include ::Contracts::Builtin
      include Source

      Contract None => Octokit::Client
      def github
        @github ||= Octokit::Client.new access_token: access_token
      end

      Contract None => Bool
      def github_ratelimit_ok?
        rate_limit_remaining = github.rate_limit.remaining()
        rate_limit_resets_in = github.rate_limit.resets_in()
        
        if rate_limit_remaining < api_wait_buffer
          if rate_limit_resets_in < api_wait_limit
            STDERR.puts("Github API tries remaining (#{rate_limit_remaining}) is less than buffer (#{api_wait_buffer}). Sleeping for #{rate_limit_resets_in}s...")
            sleep (rate_limit_resets_in + 5)
            return true
          else
            raise "Github API rate exceeded: time to reset (#{rate_limit_resets_in}s) exceeds wait limit (#{api_wait_limit}s)"
          end
        else
          # continue if we're not reaching ratelimit
          return true
        end
      end

      Contract None => String
      def canonical_sha
        @canonical_sha ||= (sha.match(/^.{40}$/) || github.commit(repo, sha).sha).to_s
      end
    end
  end
end
