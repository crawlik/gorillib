require File.expand_path('../../spec_helper', File.dirname(__FILE__))
require 'gorillib/pathname/template'

describe Gorillib::Pathref do
  let(:subject){ described_class.new('a', 'b') }
  let(:pathref_subklass){ Class.new(described_class) }

  it '.path_to delegates to .new' do
    a, b, c = [mock, mock, mock] # "We mock what we don't understand"
    pathref_subklass.should_receive(:new).with(a, b, c)
    pathref_subklass.path_to(a, b, c)
  end

  context 'creation' do
    it 'expands all paths into a pathname' do
      Gorillib::Pathref.should_receive(:expand_pathseg).with(:a).and_return('/a')
      Gorillib::Pathref.should_receive(:expand_pathseg).with('b').and_return('b')
      Gorillib::Pathref.new(:a, 'b').should == Pathname.new('/a/b')
    end
    it 'must have at least one segment' do
      lambda{ Gorillib::Pathref.new() }.should raise_error(ArgumentError, /wrong number of arguments/)
    end
  end

  context '.register_path' do
    it 'comes back from its handle' do
      Gorillib::Pathref.register_path(:probe, ['skeletal', 'girth'])
      Gorillib::Pathref.expand_pathseg(:probe).should == ['skeletal', 'girth']
    end
    it 'stores an array' do
      Gorillib::Pathref.register_path(:ace, 'tomato')
      Gorillib::Pathref.expand_pathseg(:ace).should == ['tomato']
    end
    it 'is overrideable' do
      Gorillib::Pathref.register_path(:glg_20, 'boyer')
      Gorillib::Pathref.register_path(:glg_20, ['milbarge', 'fitz-hume'])
      Gorillib::Pathref.expand_pathseg(:glg_20).should == ['milbarge', 'fitz-hume']
    end
  end

  context '.path_to' do
    before do
      Gorillib::Pathref.register_path(:doctor,  ['doctor/doctor'])
      Gorillib::Pathref.register_path(:code,    ['twenty-square-digit', 'boustrophedonic'])
      Gorillib::Pathref.register_path(:hello,   [:doctor, :doctor])
      Gorillib::Pathref.register_path(:oh_crap, ['~/ninjas'])
    end
    { ['/tmp', :code]                      => '/tmp/twenty-square-digit/boustrophedonic',
      [:oh_crap]                           => ENV['HOME']+'/ninjas',
      [:hello, 'doctor', :doctor, :doctor] => File.expand_path('doctor/doctor/doctor/doctor/doctor/doctor/doctor/doctor/doctor'),
      [:oh_crap, :doctor]                  => File.join(ENV['HOME'], 'ninjas', 'doctor', 'doctor'),
      [".."]                               => File.expand_path('..'),
      ["..", 'bob']                        => File.expand_path(File.join('..', 'bob')),
    }.each do |input, expected|
      it 'expands symbols' do
        Gorillib::Pathref.path_to(*input).should == Pathname.new(expected)
      end
    end
  end

  context '#/' do
    it 'aliases #join' do
      pathseg = mock ; result = mock
      subject.should_receive(:join).with(pathseg).and_return(result)
      (subject / pathseg).should be(result)
    end
  end

end
