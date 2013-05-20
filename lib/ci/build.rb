module CI
  class Build
    def initialize(options)
      @project_id = options[:project_id]
      @build_id   = options[:build_id]
      @repo       = options[:repo]
      @commit     = options[:commit]
      @command    = options[:command]
    end

    def start(&block)
      checkout
      update

      @result = command.run(@command) do |chunk|
        yield(chunk) if block_given?
      end
    end

    private

    def checkout
      unless build_path.exist?
        build_path.mkpath

        command.run! %{git clone "#{@repo}" .}
      end
    end

    def update
      command.run! %{git clean -fd}
      command.run! %{git fetch}
      command.run! %{git checkout -qf "#{@commit}"}
    end

    def build_path
      CI.root_path.join folder_name
    end

    def folder_name
      name = @repo.match(/:(.+).git/)[1]

      "#{@project_id}-#{name.gsub(/\//, '-')}"
    end

    def command
      CI::Command.new(build_path)
    end
  end
end
