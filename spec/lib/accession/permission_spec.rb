module Accession
  RSpec.describe Permission do
    let(:permission) { |e| described_class.new(e.metadata[:permission]) }
    let(:action) { |e| e.metadata[:action] }

    shared_context result: :permit do
      it 'is permitted' do
        expect(permission.permit?(action)).to be_truthy
      end
    end

    shared_context result: :deny do
      it 'is denied' do
        expect(permission.permit?(action)).to be_falsey
      end
    end

    class <<self
      def permission(p, &bl)
        context("permission: #{p}", permission: p, &bl)
      end

      def permits(a)
        context("action: #{a}", action: a, result: :permit)
      end

      def denies(a)
        context("action: #{a}", action: a, result: :deny)
      end
    end

    permission 'a:b:c:d:e:f:g:h:i:j:k:l:m:*' do
      permits('a:b:c:d:e:f:g:h:i:j:k:l:m:n')
      denies('a:b:c:d')
    end

    permission 'a:b:c:*' do
      permits('a:b:c:d')
      permits('a:b:c:d:e')
      denies('a:b:c')
      denies('c:b:c:d')
    end

    permission '*' do
      permits('a:b:c:d')
    end

    permission 'a:b:c:d' do
      permits('a:b:c:d')
      denies('a:b:c')
      denies('a:b:c:e')
      denies('a:b:c:d:f')
    end

    permission 'a:b:*:d' do
      permits('a:b:c:d')
      denies('a:b:d')
      denies('a:b:c:e:d')
      denies('a:b:d:c')
    end
  end
end
