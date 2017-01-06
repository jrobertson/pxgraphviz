#!/usr/bin/env ruby

# file: pxgraphviz.rb


require 'polyrex'


class PxGraphViz


  def initialize(s)

    @px = Polyrex.new
    @px.import s

  end

  def to_doc()

    labels = @px.xpath('//records/item/summary/label/text()').uniq

    ids = labels.length.times.map {|i| i+1}

    labels_ids = labels.zip ids

    # Create a document of the nodes

    node_records = RexleBuilder.build do |xml|

      xml.records do
        labels_ids.each do |val, i|
          xml.node(id: i.to_s) do
            xml.label val
          end
        end
      end

    end

    a_nodes = labels.zip(node_records[3..-1])
    h_nodes = a_nodes.to_h


    a_edges = []
    @px.each_recursive do |x, parent, level|

      next if level <= 0
      a_edges << [parent.label, x.label]

    end


    # Create a document of the nodes

    edge_records = RexleBuilder.build do |xml|

      xml.records do
        a_edges.each do |item1, item2|
          xml.edge do
            xml.summary
            xml.records { RexleArray.new([h_nodes[item1], h_nodes[item2]])}
          end
        end
      end

    end

    h_doc = {

    options: {
      summary: '', 
      records: 
        [['option', {}, '', 
          ['summary',{},'', ['type',{}, 'node']],
          ['records',{}, '', 
            ['attribute', {name: 'color', value: '#ddaa66'}],
            ['attribute', {name: 'style', value: 'filled'}],
            ['attribute', {name: 'shape', value: 'box'}], 
            ['attribute', {name: 'penwidth', value: '1'}], 
            ['attribute', {name: 'fontname', value: 'Trebuchet MS'}],
            ['attribute', {name: 'fontsize', value: '8'}],
            ['attribute', {name: 'fillcolor', value: '#775500'}],
            ['attribute', {name: 'fontcolor', value: '#ffeecc'}],
            ['attribute', {name: 'margin', value: '0.0'}]
          ]
        ],
        ['option', {}, '',
          ['summary', {}, '', ['type', {}, 'edge']],
          ['records', {}, '',
            ['attribute', {name: 'color', value: '#ddaa66'}],
            ['attribute', {name: 'weight', value: '1'}],
            ['attribute', {name: 'fontsize', value: '8'}],
            ['attribute', {name: 'fontcolor', value: '#ffeecc'}],
            ['attribute', {name: 'fontname', value: 'Trebuchet MS'}],
            ['attribute', {name: 'dir', value: 'forward'}],
            ['attribute', {name: 'arrowsize', value: '0.5'}]
          ]
        ]]
      },
      nodes: {summary: '', records: node_records},
      edges: {summary: '', records: edge_records[3..-1]}
    }

    a = RexleBuilder.new(h_doc).to_a
    a[0] = 'gvml'
    Rexle.new(a)    

  end

end
