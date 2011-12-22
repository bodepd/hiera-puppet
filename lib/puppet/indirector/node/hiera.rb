require 'hiera'

class Puppet::Node::Hiera < Puppet::Indirector::Code
  desc 'Return a collection of classes and parameters by querying hiera for "classes" and "parameters" data entries.'

  def find(request)
    facts = Puppet::Node::Facts.indirection.find(request.key)
    hiera = Hiera.new(:config => {:logger => 'puppet'})
    node = Puppet::Node.new(
      request.key,
      :parameters => hiera.lookup('parameters', {}, facts.values, nil, :hash ),
      :classes    => hiera.lookup('classes', {}, facts.values, nil, :hash )
    )
    node
  end
end
