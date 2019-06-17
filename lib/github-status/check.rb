require 'concourse-fuselage'
require_relative 'core'
require_relative 'support/github'

module GitHubStatus
  class Check < Fuselage::Check
    include Core
    include Support::GitHub

    Contract HashOf[String, String] => String
    def sha(version)
      @sha ||= version.fetch('context@sha') { commit }.split('@').last
    end

    Contract String => Time
    def date(sha)
      if github_ratelimit_ok?
        @date ||= github.commit(repo, sha).commit.author.date
      end
    end

    Contract None => String
    def commit
      if github_ratelimit_ok?
        @commit ||= github.branch(repo, branch).commit.sha
      end
    end

    Contract None => HashOf[String, String]
    def latest
      { 'context@sha' => "concourseci@#{commit}" }
    end

    Contract HashOf[String, String] => ArrayOf[HashOf[String, String]]
    def since(version)
      if github_ratelimit_ok?
        github
          .commits_since(repo, date(sha(version)))
          .map { |commit| { 'context@sha' => "concourseci@#{commit[:sha]}" } }
      end
    end
  end
end
