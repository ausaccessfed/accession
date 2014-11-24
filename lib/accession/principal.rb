module Accession
  module Principal
    def permits?(action)
      permissions.map { |p| Permission.new(p) }
        .any? { |p| p.permit?(action) }
    end
  end
end
