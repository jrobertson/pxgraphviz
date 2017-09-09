#!/usr/bin/env ruby

# file: pxgraphviz.rb


require 'polyrex'
require 'graphvizml'


class PxGraphViz

  attr_reader :doc

  def initialize(s, style: default_stylesheet())

    px = s =~ /^<\?/ ? Polyrex.new.import(s) : Polyrex.new(s)
    @doc = build(px, style)
    
  end
  
  # this method will be deprecated in the near future. Use #doc instead
  #
  def to_doc()
    @doc
  end
    
  def to_dot()
    GraphVizML.new(@doc).to_dot
  end

  # returns a PNG blob
  #
  def to_png()    
    GraphVizML.new(@doc).to_png
  end
  
  # returns an SVG blob
  #
  def to_svg()
    GraphVizML.new(@doc).to_svg
  end    
  
  def write(filename)
    GraphVizML.new(@doc).write filename
  end
  
  private

  def build(px, style)

    # The issue with 2 nodes having the same name has yet to be rectified
    #jr020917 labels = @px.xpath('//records/item/summary/label/text()').uniq
    
    summary = px.xpath('//records/item/summary')
    
    labels = summary.map do |x|

      a = [x.text('label'), x.text('shape') || 'box', x.text('url')]

    end

    ids = labels.length.times.map {|i| i+1}

    labels_ids = labels.zip ids

    # Create a document of the nodes

    node_records = RexleBuilder.build do |xml|

      xml.records do
        
        labels_ids.each do |x, i|
          
          label, shape, url = x
          attr = {gid: i.to_s, shape: shape}
          
          if url then
            xml.a({href: url}) do
              xml.node(attr) { xml.label label }
            end
          else
            xml.node(attr) { xml.label label }
          end
          
        end
      end

    end

    a_nodes = labels.map(&:first).zip(node_records[3..-1])
    h_nodes = a_nodes.to_h


    a_edges = []
    px.each_recursive do |x, parent, level|

      next if level <= 0
      a_edges << [
        parent.label,
        x.label, 
        x.respond_to?(:connection) ? x.connection : ''
      ]

    end

    # Create a document of the nodes

    edge_records = RexleBuilder.build do |xml|

      xml.records do
        
        a_edges.each.with_index do |x, i|
          
          item1, item2, connection = x
          
          xml.edge gid: 'e' + (i+1).to_s do
            
            xml.summary { xml.label connection }           
            elements = [h_nodes[item1], h_nodes[item2]]            
            nodes = elements.map {|node| node[0] == 'a' ? node[3] : node }
            
            xml.records { RexleArray.new(nodes)}
          end
          
        end
      end

    end    


    h = {
      style: style,
      nodes: {summary: '', records: node_records[3..-1]},
      edges: {summary: '', records: edge_records[3..-1]}
    }

    a = RexleBuilder.new(h).to_a
    a[0] = 'gvml'

    summary = px.summary.to_h
    %i(recordx_type format_mask schema).each do |x| 
      summary.delete x; summary.delete x.to_s
    end

    a[1] = summary

    Domle.new(a)    

  end
  
  def default_stylesheet()

<<STYLE
  node { 
    color: #ddaa66; 
    fillcolor: #775533;
    fontcolor: #ffeecc; 
    fontname: Trebuchet MS; 
    fontsize: 8; 
    margin: 0.0;
    penwidth: 1; 
    style: filled;
  }
  
  a node {
    color: #0011ee;   
  }

  edge {
    arrowsize: 0.5;
    color: #999999; 
    fontcolor: #444444; 
    fontname: Verdana; 
    fontsize: 8; 
    #{@type == :digraph ? 'dir: forward;' : 'dir: none;'}
    weight: 1;
  }
STYLE

  end

end