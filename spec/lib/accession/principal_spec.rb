module Accession
  RSpec.describe Principal do
    let(:permission_true) { double(permit?: true) }
    let(:permission_false) { double(permit?: false) }

    matcher(:permit) { match { |a| a.permits?('dummy') } }
    RSpec::Matchers.define_negated_matcher :deny, :permit

    subject do
      klass = Class.new do
        include Principal
        attr_reader :permissions
        def initialize(permissions)
          @permissions = permissions
        end
      end

      klass.new(permissions)
    end

    context 'single permit' do
      let(:permissions) { [permission_true] }
      it { is_expected.to permit }
    end

    context 'multiple permit' do
      let(:permissions) { [permission_true, permission_true] }
      it { is_expected.to permit }
    end

    context 'single deny' do
      let(:permissions) { [permission_false] }
      it { is_expected.to deny }
    end

    context 'multiple deny' do
      let(:permissions) { [permission_false, permission_false] }
      it { is_expected.to deny }
    end

    context 'deny then permit' do
      let(:permissions) { [permission_false, permission_true] }
      it { is_expected.to permit }
    end

    context 'permit then deny' do
      let(:permissions) { [permission_true, permission_false] }
      it { is_expected.to permit }
    end
  end
end
