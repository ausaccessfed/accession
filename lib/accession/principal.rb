module Accession
  module Principal
    def permits?(action)
      permissions.any? { |p| p.permit?(action) }
    end
  end
end
