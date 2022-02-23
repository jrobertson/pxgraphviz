Gem::Specification.new do |s|
  s.name = 'pxgraphviz'
  s.version = '0.6.0'
  s.summary = 'Generates a GraphViz Markup Language file from a ' + 
      'Polyrex document'
  s.authors = ['James Robertson']
  s.files = Dir['lib/pxgraphviz.rb']
  s.add_runtime_dependency('polyrex', '~> 1.4', '>=1.4.0')
  s.add_runtime_dependency('graphvizml', '~> 0.7', '>=0.7.1')
  s.signing_key = '../privatekeys/pxgraphviz.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/pxgraphviz'
end
