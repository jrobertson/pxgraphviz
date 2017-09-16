#!/usr/bin/env ruby

# file: pxgraphviz.rb


require 'polyrex'
require 'graphvizml'


class PxGraphViz

  attr_reader :doc, :px

  def initialize(s, style: default_stylesheet())

    @px = s =~ /^<\?/ ? Polyrex.new.import(s) : Polyrex.new(s)

    doc = Rexslt.new(xslt_stylesheet(), @px.to_xml)\
        .to_doc.root.element('nodes')

    doc.root.elements.first.insert_before Rexle::Element.new('style')\
        .add_text style
    @doc = doc
    
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
  
  def default_stylesheet()

<<STYLE
  node { 
    color: #ddaa66; 
    fillcolor: #775533;
    fontcolor: #ffeecc; 
    fontname: 'Trebuchet MS';
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

  
  def xslt_stylesheet()
    
<<XSLT    
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes" />

  <xsl:template match='items'>
    <xsl:element name="nodes">
      <xsl:if test="summary/type">
        <xsl:attribute name="type">
          <xsl:value-of select="summary/type"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="summary/direction">
        <xsl:attribute name="direction">
          <xsl:value-of select="summary/direction"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="summary/layout">
        <xsl:attribute name="layout">
          <xsl:value-of select="summary/layout"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select='records'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match='records/item'>

    <xsl:choose>
      <xsl:when test="summary/url and summary/url != ''">

        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="summary/url"/>
          </xsl:attribute>   
          <xsl:call-template name='node'/>
        </xsl:element>

      </xsl:when>
      <xsl:otherwise> 

        <xsl:call-template name='node'/>

      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <xsl:template match='item/summary'>

      <label><xsl:value-of select='label'/></label>

  </xsl:template>

  <xsl:template name='node'>
     <xsl:element name="node">
    
      <xsl:attribute name="shape">
        <xsl:value-of select="summary/shape"/>
      </xsl:attribute>
      
      <xsl:if test="summary/id">
        <xsl:attribute name="id">
          <xsl:value-of select="summary/id"/>
        </xsl:attribute>
      </xsl:if>
    
      <xsl:if test="summary/class">
        <xsl:attribute name="class">
          <xsl:value-of select="summary/class"/>
        </xsl:attribute>
      </xsl:if>
      
      <xsl:if test="summary/connection">
        <xsl:attribute name="connection">
          <xsl:value-of select="summary/connection"/>
        </xsl:attribute>
      </xsl:if>    
    
      <xsl:apply-templates select='summary'/>
      <xsl:apply-templates select='records'/>

    </xsl:element>  
  </xsl:template>

</xsl:stylesheet>
XSLT
  end

end