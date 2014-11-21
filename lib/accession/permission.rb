module Accession
  class Permission
    def initialize(value)
      @parts = value.split(':')
    end

    def permit?(action)
      action_parts = action.split(':', @parts.length)
      return false if action_parts.length != @parts.length

      @parts.zip(action_parts).each do |(l, r)|
        next if l == '*'
        return false if l != r
      end
    end
  end
end
