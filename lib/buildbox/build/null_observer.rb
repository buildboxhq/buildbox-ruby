# encoding: UTF-8

module Buildbox
  class Build::NullObserver
    def started(result)
    end

    def updated(result, partial)
    end

    def finished(result)
    end
  end
end
