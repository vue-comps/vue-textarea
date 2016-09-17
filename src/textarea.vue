// out: ..
<template lang="pug">
div(
  v-bind:style="computedStyle",
  @mousedown="onClick"
  )
  div(
    v-el:sizer,
    style="position:absolute;visibility:hidden;word-break:break-word;white-space:pre-wrap;overflow: auto",
    v-bind:style="sizerStyle") {{value}}
  textarea(
    v-model="value",
    v-el:ta,
    v-bind:style="taStyle",
    v-bind:class="taclass",
    v-bind:autofocus="autofocus",
    v-bind:disabled="disabled",
    v-bind:readonly="readonly",
    @mouseenter="mouseenter",
    @mouseleave="mouseleave",
    @focus="onFocus",
    @blur="onBlur",
    @keyup="onKeyup",
    @input="onInput",
    @scroll="onScroll",
    style="resize:none;overflow:hidden")
  slot(name="label")
  div(
    style="position:absolute;overflow:hidden",
    v-if="!isOpened && value==''",
    v-bind:style="sizerStyle",
    v-show="loaded")
    slot(name="placeholder")
  div(
    v-el:content,
    style="position:absolute;visibility:hidden",
    v-if="!loaded")
    slot
</template>

<script lang="coffee">
module.exports =

  mixins:[
    require("vue-mixins/isOpened")
    require("vue-mixins/style")
  ]

  props:
    "taclass":
      default: -> []
    "style":
      default: -> []
    "autofocus":
      type: Boolean
      default: false
    "disabled":
      type: Boolean
      default: false
    "readonly":
      type: Boolean
      default: false
    "noExtraLine":
      type: Boolean
      default: false
    "value":
      type: String
      default: ""
    "transitionIn":
      type: Function
      default: ({el,style,cb}) ->
        cb()
    "transitionOut":
      type: Function
      default: ({el,style,cb}) ->
        cb()
    "maxSize":
      type: Object
      default: -> {}
    "size":
      type: Object
      default: -> {}
    "hoverSize":
      type: Object
      default: -> {}

  data: ->
    content: {}
    current:
      width: null
      height: null
    loaded: false
    hovered: false
    tastyle: null
    elstyle: null

  computed:
    inner: ->
      return null unless @tastyle
      inner = {}
      for name in ["top","right","bottom","left"]
        padding = parseFloat @tastyle.getPropertyValue("padding-#{name}").replace("px","")
        border = parseFloat @tastyle.getPropertyValue("border-#{name}-width").replace("px","")
        inner[name] = padding+border
      return inner
    sizerStyle: ->
      return null unless @tastyle and @elstyle
      style = {
        fontSize: @tastyle.getPropertyValue("font-size")
        lineHeight: @lineHeight + "px"
        fontFamily: @tastyle.getPropertyValue("font-family")
        letterSpacing: @tastyle.getPropertyValue("letter-spacing")
        minHeight: @tastyle.getPropertyValue("min-height")
        maxWidth: if @maxWidth? then @maxWidth + "px" else null
        maxHeight: @maxHeight + "px"
        paddingTop: @inner.top + "px"
        paddingBottom: @inner.bottom + "px"
        paddingLeft: @inner.left + "px"
        paddingRight: @inner.right + "px"
        top: @elstyle.getPropertyValue("padding-top")
        left: @elstyle.getPropertyValue("padding-left")
        marginTop: @tastyle.getPropertyValue("margin-top")
        marginBottom: @tastyle.getPropertyValue("margin-bottom")
        marginLeft: @tastyle.getPropertyValue("margin-left")
        marginRight: @tastyle.getPropertyValue("margin-right")
        boxSizing: @tastyle.getPropertyValue("box-sizing")
      }
      return style
    lineHeight: ->
      return null unless @tastyle
      lh = @tastyle.getPropertyValue("line-height")
      if lh == "normal"
        return null
      else
        return parseFloat lh.replace("px","")
    lineHeightOrFontSize: ->
      if @lineHeight
        return @lineHeight
      else
        return parseFloat @sizerStyle.fontSize.replace("px","")
    maxWidth: ->
      return @maxSize.width if @maxSize.width?
      return null
    maxHeight: ->
      return @maxSize.height if @maxSize.height?
      return null
    closed: ->
      height = @size.height
      height ?= @$els.ta.offsetHeight
      height = @maxheight if @maxheight? and height > @maxheight
      width = @size.width
      width ?= @$els.ta.offsetWidth
      width = @maxWidth if @maxWidth? and width > @maxWidth
      return width:width,height:height
    taStyle: ->
      return null unless @inner
      return {
        height: @offsetHeight(@current.height) + "px"
        width: @offsetWidth(@current.width) + "px"
        visibility: if @loaded then null else "hidden"
        overflow: if @opened then null else "hidden"
      }
    mergeStyle: ->
      return null unless @tastyle
      return {
        position: "relative"
        height: @current.height + "px"
        width: if @maxWidth? then @maxWidth + "px" else null
      }
  watch:
    value: "valueChanged"
  methods:
    offsetHeight: (height = @height) -> height - @inner.top - @inner.bottom
    offsetWidth: (width = @width) -> width - @inner.left - @inner.right
    setCurrent: (style) ->
      @current.height = style.height
      @current.width = style.width
    onClick: (e) ->
      unless e.defaultPrevented
        unless @opened or @value!=''
          e.preventDefault()
          @focus()
        @open()
    onFocus: (e) ->
      @$emit "focus", e
    onBlur: (e) ->
      @close()
      @$emit "blur", e
    onScroll: (e) ->
      @$emit "scroll", e
    focus: ->
      @open()
      @$els.ta.focus()
    blur: ->
      @close()
      @$els.ta.blur()
    onKeyup: (e) ->
      @$emit "keyup", e
    onInput: (e) ->
      e.stopPropagation()
    mouseenter: ->
      unless @opened
        if @hoverSize.height > @hoverSize.height or @hoverSize.width > @closed.width
          @hovered = true
          @move(@hoverSize)
    mouseleave: ->
      if not @opened and @hovered
        @move(@closed)
    valueChanged: (value) ->
      @$emit "input", value
      @processContent(value)
    processContent: (content) ->
      @content.height = @$els.sizer.clientHeight
      unless @noExtraLine
        @content.height += @lineHeightOrFontSize
      @content.height = @closed.height if @content.height < @closed.height
      @content.height = @maxHeight if @maxHeight and @content.height > @maxHeight
      @content.width = @$els.sizer.offsetWidth
      @content.width = @closed.width if @content.width < @closed.width
      @move(@content) if content and @opened # use transition

    getOffsetStyle: (style) ->
      return {height:@offsetHeight(style.height),width:@offsetWidth(style.width)}

    move: (style,cb) ->
      area = @current.height * @current.width
      newArea = style.height * style.width
      if area == newArea
        cb?()
      else if area <= newArea
        @transitionIn el:@$els.ta,style:@getOffsetStyle(style),cb: =>
          @setCurrent(style)
          cb?()
      else
        @transitionOut el:@$els.ta,style:@getOffsetStyle(style),cb: =>
          @setCurrent(style)
          cb?()

    show: ->
      @setOpened()
      @$emit "before-enter"
      @move @content, =>
        @$emit "after-enter"

    hide: ->
      @$emit "before-leave"
      @move @closed, =>
        @setClosed()
        @$emit "after-leave"

    open: ->
      return if @opened
      @show()

    close: ->
      return unless @opened
      @hide()

    toggle: ->
      if @opened
        @close()
      else
        @open()

  ready: ->
    @value = @$els.content?.textContent unless @value
    @tastyle = window.getComputedStyle(@$els.ta)
    @elstyle = window.getComputedStyle(@$el)
    @processContent()
    @loaded = true
    if @isOpened
      @setCurrent(@content)
    else
      @setCurrent(@closed)
</script>
