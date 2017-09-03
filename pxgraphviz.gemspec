Gem::Specification.new do |s|
  s.name = 'pxgraphviz'
  s.version = '0.2.3'
  s.summary = 'Generates a GraphViz Markup Language file from a Polyrex document'
  s.authors = ['James Robertson']
  s.files = Dir['lib/pxgraphviz.rb']
  s.add_runtime_dependency('polyrex', '~> 1.1', '>=1.1.12')
  s.signing_key = '../privatekeys/pxgraphviz.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/pxgraphviz'
end
