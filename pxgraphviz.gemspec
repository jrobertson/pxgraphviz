Gem::Specification.new do |s|
  s.name = 'pxgraphviz'
  s.version = '0.3.4'
  s.summary = 'Generates a GraphViz Markup Language file from a Polyrex document'
  s.authors = ['James Robertson']
  s.files = Dir['lib/pxgraphviz.rb']
  s.add_runtime_dependency('polyrex', '~> 1.1', '>=1.1.12')
  s.add_runtime_dependency('graphvizml', '~> 0.5', '>=0.5.2')
  s.signing_key = '../privatekeys/pxgraphviz.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/pxgraphviz'
end
