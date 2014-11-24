module Accession
  RSpec.describe Principal do
    let(:correct_perm) { 'a:*' }
    let(:other_perm) { 'b:*' }

    matcher(:permit) { match { |a| a.permits?('a:b:c') } }
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
      let(:permissions) { [correct_perm] }
      it { is_expected.to permit }
    end

    context 'multiple permit' do
      let(:permissions) { [correct_perm, correct_perm] }
      it { is_expected.to permit }
    end

    context 'single deny' do
      let(:permissions) { [other_perm] }
      it { is_expected.to deny }
    end

    context 'multiple deny' do
      let(:permissions) { [other_perm, other_perm] }
      it { is_expected.to deny }
    end

    context 'deny then permit' do
      let(:permissions) { [other_perm, correct_perm] }
      it { is_expected.to permit }
    end

    context 'permit then deny' do
      let(:permissions) { [correct_perm, other_perm] }
      it { is_expected.to permit }
    end
  end
end
