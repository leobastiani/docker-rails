module DockerRails
  class Application
    def version
      '1.11.0'
    end

    def build_time
      @build_time ||= File.read('BUILD_TIME').lines.first.chomp.to_datetime
    rescue Errno::ENOENT
      Time.current
    end

    def alpine_release
      `cat /etc/alpine-release 2>/dev/null`.chomp
    end

    def ruby_version
      "#{RUBY_VERSION} patchlevel #{RUBY_PATCHLEVEL}"
    end

    def rubygems_version
      Gem::VERSION
    end

    def bundler_version
      Bundler::VERSION
    end

    def rails_version
      Rails::VERSION::STRING
    end

    def redis_version
      Sidekiq.redis_info['redis_version']
    end

    def postgresql_version
      ActiveRecord::Base.connection.select_value('SHOW server_version;')
    end

    def elasticsearch_version
      Searchkick.server_version
    end
  end
end
