# Introducing the PxGraphViz gem

The PxGraphViz gem generates a GraphViz Markup Language file as can been seen in the example below.

    require 'pxgraphviz'

    s = "
    <?polyrex schema='items/item[label, connection]' delimiter =' # '?>

    hello
      world # link 1
        run # link 2
        walk # link 3
          fun # link 4
      fun # link 5
    "


    pxg = PxGraphViz.new(s)
    doc = pxg.to_doc
    File.write 'gvml.xml', doc.xml(pretty: true)

## Resources

* pxgraphviz https://rubygems.org/gems/pxgraphviz

graphviz polyrex pxgraphviz gem
