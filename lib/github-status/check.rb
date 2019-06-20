require 'concourse-fuselage'
require_relative 'core'
require_relative 'support/github'

module GitHubStatus
  class Check < Fuselage::Check
    include Core
    include Support::GitHub

    Contract HashOf[String, String] => String
    def sha(version)
      @sha ||= version.fetch('context@sha@date') { commit['sha'] }.split('@')[1]
    end

    Contract HashOf[String, String] => String
    def date(version)
      @date ||= version.fetch('context@sha@date') { commit['date'] }.split('@').last
    end

    Contract None => HashOf[String, String]
    def commit
      if github_ratelimit_ok?
        @branch ||= github.branch(repo, branch)
        @commit ||= { 'sha' => @branch.commit.sha, 'date' => @branch.commit.commit.author.date.to_s }
      end
    end

    Contract None => HashOf[String, String]
    def latest
      { 'context@sha@date' => "concourseci@#{commit['sha']}@#{commit['date']}" }
    end

    Contract HashOf[String, String] => ArrayOf[HashOf[String, String]]
    def since(version)
      if github_ratelimit_ok?
        github
          .commits_since(repo, date(version))
          .map { |commit| { 'context@sha@date' => "concourseci@#{commit[:sha]}@#{commit.commit.author.date.to_s}" } }
      end
    end
  end
end
