#!/usr/bin/env ruby

# file: pxgraphviz.rb


require 'polyrex'


class PxGraphViz


  def initialize(s)

    if s =~ /^<\?/ then
      
      @px = Polyrex.new
      @px.import s        

    else
      @px = Polyrex.new s

    end
    
  end

  def to_doc()

    #jr020917 labels = @px.xpath('//records/item/summary/label/text()').uniq
    
    summary = @px.xpath('//records/item/summary')
    labels = summary.map do |x|
      label = x.text('label')
      shape = x.element('shape')

      [label, shape.text || 'box' ]

    end

    ids = labels.length.times.map {|i| i+1}

    labels_ids = labels.zip ids

    # Create a document of the nodes

    node_records = RexleBuilder.build do |xml|

      xml.records do
        labels_ids.each do |x, i|
          label, shape = x
          attr = {id: i.to_s, shape: shape}
          xml.node(attr) do
            xml.label label
          end
        end
      end

    end

    a_nodes = labels.map(&:first).zip(node_records[3..-1])
    h_nodes = a_nodes.to_h


    a_edges = []
    @px.each_recursive do |x, parent, level|

      next if level <= 0
      a_edges << [parent.label, x.label, x.connection]

    end


    # Create a document of the nodes

    edge_records = RexleBuilder.build do |xml|

      xml.records do
        a_edges.each.with_index do |x, i|
          item1, item2, connection = x
          xml.edge id: 'e' + (i+1).to_s do
            xml.summary do
              xml.label connection
            end
            xml.records { RexleArray.new([h_nodes[item1], h_nodes[item2]])}
          end
        end
      end

    end

    
style = '
  node { 
    color: #ddaa66; 
    fillcolor: #775500;
    fontcolor: #ffeecc; 
    fontname: Trebuchet MS; 
    fontsize: 8; 
    margin: 0.0;
    penwidth: 1; 
    shape: box; 
    style: filled;
  }

  edge {
    arrowsize: 0.5;
    color: #999999; 
    fontcolor: #444444; 
    fontname: Verdana; 
    fontsize: 8; 
    dir: forward;
    weight: 1;
  }
'
    h = {
      style: style,
      nodes: {summary: '', records: node_records[3..-1]},
      edges: {summary: '', records: edge_records[3..-1]}
    }

    a = RexleBuilder.new(h).to_a
    a[0] = 'gvml'
    a[1] = {direction: @px.summary.direction} if @px.summary.direction
    
    Rexle.new(a)    

  end

end