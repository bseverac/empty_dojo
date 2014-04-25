require 'spec_helper'

describe Dojo::Base do

  before do
    @base = subject.new
  end

  it 'must say we starting dojo' do
    Dojo::Base.starting_dojo!.must_equal "starting dojo"
  end

end
