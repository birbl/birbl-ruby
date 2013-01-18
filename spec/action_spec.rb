require 'birbl'

describe Birbl::Action do
  context 'without initialization' do
    context '.instance' do
      it 'raises an error'
    end

    context '.new' do
      it 'takes one parameter'
    end
  end

  context 'with initialization' do
    subject { Birbl::Action.new('the_key') }

    context '.instance' do
      it 'returns the instance' do
        subject # create it
        expect(Birbl::Action.instance).to be(subject)
      end
    end

    context 'attributes' do
      [
        [:use_sandbox, false],
        [:base_url,    'https://api.birbl.com'],
        [:dev_url,     'https://dev-api.birbl.com'],
        [:timeout,     10],
      ].each do |attribute, value|
        it "has accessors for #{attribute}"
        example "#{attribute} defaults to #{value}" do
          expect(subject.send(attribute)).to eq(value)
        end
      end
    end

    context '.url' do
      context 'when not sandboxed' do
        it 'returns production URL' do
          expect(subject.url).to eq('https://api.birbl.com')
        end
      end

      context 'when sandboxed' do
        it 'returns staging URL' do
          subject.use_sandbox = true

          expect(subject.url).to eq('https://dev-api.birbl.com')
        end
      end
    end

    context '.get' do
      before do
        #Foobar.stub(:get).with('https://...').and_return([a, b, c])
      end

      it 'proxies to foobar' do
        #Foobar.should_receive(:get).with('https://...').and_return([a, b, c])
        subject.get('partners')
      end

      it 'parses the JSON response'
      it 'returns the parsed data'
      it 'fails on error responses'
    end
  end
end
