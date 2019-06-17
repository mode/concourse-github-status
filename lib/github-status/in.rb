require 'concourse-fuselage'
require 'contracts'
require_relative 'core'
require_relative 'support/github'
require_relative 'support/params'

module GitHubStatus
  class In < Fuselage::In
    include Core
    include Support::Params
    include Support::GitHub

    Contract None => String
    def sha
      @sha ||= version.fetch('context@sha') { commit }.split('@').last
    end

    Contract None => Maybe[String]
    def state
      if github_ratelimit_ok?
        github
          .statuses(repo, canonical_sha)
          .select { |status| status.context == context }
          .map(&:state)
          .first
      end
    end

    Contract None => Num
    def fetch!
      File.write "#{workdir}/#{context}.state", state
    end
  end
end
