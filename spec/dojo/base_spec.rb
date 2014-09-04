require 'spec_helper'

describe Dojo::Base do

  before do
    @base = subject.new
  end

  it 'must say we starting dojo' do
    @base.tell_me_the_truth
  end

end
