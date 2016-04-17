// out: ..
<template lang="jade">
div(
  :style="style",
  @mousedown="onClick | notPrevented",
  @mouseenter="mouseenter",
  @mouseleave="mouseleave"
  )
  div(v-el:sizer,style="position:absolute;visibility:hidden",:style="sizerStyle") {{value}}
  textarea(v-model="value",v-el:ta,:style="taStyle",:class="class",@blur="close")
  div(
    style="position:absolute;top:0;left:0;overflow:hidden",
    v-if="!isOpened && value==''",
    :style="sizerStyle",
    v-show="loaded")
    slot(name="placeholder")
  div(v-el:content,style="position:absolute;visibility:hidden",v-if="!loaded")
    slot
</template>

<script lang="coffee">
module.exports =

  mixins:[
    require("vue-mixins/isOpened")
  ]

  filters:
    notPrevented: require("vue-filters/notPrevented")

  props:
    "class":
      type: String
      default: ""
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
    inner: {}
    content: {}
    current: {}
    lineHeight: 0
    loaded: false
    hovered: false
    style:
      position: "relative"
      margin: 0
      padding: 0
      height: null
      width: null
    taStyle:
      height: null
      width: null
      overflow: "hidden"
      visibility: "hidden"
    sizerStyle:
      fontSize: null
      letterSpacing: null
      fontFamily: null
      paddingTop: null
      paddingRight: null
      paddingBottom: null
      paddingLeft: null
      maxWidth: @maxSize.width + 'px'
      maxHeight: @maxSize.height + 'px'
      wordBreak: "break-word"
      whiteSpace: "pre-wrap"
      overflow: "auto"

  watch:
    maxWidth: (val) -> @sizerStyle.maxWidth = val + @inner.top + @inner.bottom + 'px'
    maxHeight: (val) -> @sizerStyle.maxHeight = val + @inner.right + @inner.left + 'px'
    value: "processContent"
  methods:
    setHeight: (height) ->
      @current.height = height
      @style.height = height + 'px'
      @taStyle.height = @offsetHeight(height) + 'px'

    setWidth: (width) ->
      @current.width = width
      @taStyle.width = @offsetWidth(width) + 'px'

    offsetHeight: (height) ->
      return height - @inner.top - @inner.bottom

    offsetWidth: (width) ->
      return width - @inner.right - @inner.left

    onClick: (e) ->
      unless @opened or @value!=''
        e.preventDefault()
        @$els.ta.focus()
      @open()

    mouseenter: ->
      unless @opened
        if @hoverSize.height > @hoverSize.height or @hoverSize.width > @size.width
          @hovered = true
          @move(@hoverSize)
    mouseleave: ->
      unless @opened and not @hovered
        @move(@size)
    process: ->
      @value = @$els.content?.textContent
      # get default sizes
      @size.width = @$els.ta.offsetWidth unless @size.width
      @size.height = @$els.ta.offsetHeight unless @size.height
      @hoverSize.width = @size.width unless @hoverSize.width
      @hoverSize.height = @size.height unless @hoverSize.height
      if @maxSize.width
        @size.width = @maxSize.width if @size.width > @maxSize.width
      else
        @maxSize.width = @size.width
      @style.width = @maxSize.width + 'px'
      if @maxSize.height
        @size.height = @maxSize.height if @size.height > @maxSize.height
      else
        @maxSize.height = Number.MAX_VALUE
      # get style for textarea and content sizer
      style = window.getComputedStyle(@$el)
      tastyle = window.getComputedStyle(@$els.ta)
      @sizerStyle.fontSize = tastyle.getPropertyValue("font-size")
      @sizerStyle.fontFamily = tastyle.getPropertyValue("font-family")
      @sizerStyle.letterSpacing = tastyle.getPropertyValue("letter-spacing")
      lh = tastyle.getPropertyValue("line-height")
      if lh == "normal"
        @lineHeight = parseFloat(@sizerStyle.fontSize.replace("px",""))
      else
        @lineHeight = parseFloat lh.replace("px","")
      @sizerStyle.lineHeight = lh
      # get the padding+border of the textarea to convert from div size to textarea size
      for name in ["top","right","bottom","left"]
        upper = name[0].toUpperCase()+name.slice(1)
        padding = parseFloat tastyle.getPropertyValue("padding-#{name}").replace("px","")
        border = parseFloat tastyle.getPropertyValue("border-#{name}-width").replace("px","")
        @inner[name] = padding+border
        @sizerStyle["padding"+upper] = @inner[name]+'px'
      # process initial state
      @processContent()
      if @isOpened
        @setHeight(@content.height)
        @setWidth(@content.width)
      else
        @setHeight(@size.height)
        @setWidth(@size.width)
      @taStyle.visibility = null
      @loaded = true

    processContent: (content) ->
      @content.height = @$els.sizer.offsetHeight+@lineHeight
      @content.height = @size.height if @content.height < @size.height
      @content.height = @maxSize.height if @content.height > @maxSize.height
      @content.width = @$els.sizer.offsetWidth
      @content.width = @size.width if @content.width < @size.width
      @move(@content) if content and @opened # use transition

    getOffsetStyle: (style) ->
      return {height:@offsetHeight(style.height),width:@offsetWidth(style.width)}

    move: (style,cb) ->
      area = @current.height * @current.width
      if area <= style.height * style.width
        @transitionIn el:@$els.ta,style:@getOffsetStyle(style),cb: =>
          @setHeight(style.height)
          @setWidth(style.width)
          cb?()
      else
        @transitionOut el:@$els.ta,style:@getOffsetStyle(style),cb: =>
          @setHeight(style.height)
          @setWidth(style.width)
          cb?()

    show: ->
      @setOpened()
      @$emit "beforeOpen"
      @move @content, =>
        @taStyle.overflow = null
        @$emit "opened"

    hide: ->
      @$emit "beforeClose"
      @move @size, =>
        @setClosed()
        @taStyle.overflow = "hidden"
        @$emit "closed"

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

  attached: ->
    @process
</script>
