module Accession
  class Permission
    # A segment is a "word" in the url-safe base64 alphabet, or single '*'
    SEGMENT = /([\w-]+|\*)/.freeze
    REGEXP = /\A(#{SEGMENT}:)*#{SEGMENT}\z/.freeze
    private_constant :SEGMENT, :REGEXP

    def self.regexp
      REGEXP
    end

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
