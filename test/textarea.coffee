env = null

event = (el,name,cb) ->
  e = new MouseEvent(name,{
    "view": window,
    "bubbles": true,
    "cancelable": true
  })
  el.dispatchEvent(e)
  env.$nextTick -> env.$nextTick -> cb()

roundBox = (box) ->
  left: Math.round(box.left)
  right: Math.round(box.right)
  top: Math.round(box.top)
  bottom: Math.round(box.bottom)
  width: Math.round(box.width)
  height: Math.round(box.height)

getBoundingBoxes = (name,eventName,cb) ->
  ta = env.$refs[name]
  el = ta.$els.ta
  event el,eventName, ->
    box1 = el.getBoundingClientRect()
    if eventName == "mousedown"
      ta.isOpened.should.be.true
      ta.blur()
      env.$nextTick ->
        ta.isOpened.should.be.false
        box2 = el.getBoundingClientRect()
        cb(roundBox(box2),roundBox(box1))
    else
      event el,"mouseleave", ->
        box2 = el.getBoundingClientRect()
        cb(roundBox(box2),roundBox(box1))


describe "textarea", ->

  describe "basic env", ->

    before ->
      env = loadComp(require("../dev/basic.vue"))

    after ->
      #unloadComp(env)

    it "should work with max-width 200", (done) ->
      getBoundingBoxes "first","mousedown", (boxClosed, boxOpened) ->
        boxOpened.width.should.equal 200, "opened"
        boxOpened.height.should.equal 200, "opened"
        boxClosed.width.should.equal 150, "closed"
        boxClosed.height.should.equal 50, "closed"
        done()

    it "should work with container width 200", (done) ->
      getBoundingBoxes "second","mousedown", (boxClosed, boxOpened) ->
        boxOpened.width.should.equal 200, "opened"
        boxOpened.height.should.equal 200, "opened"
        boxClosed.width.should.equal 150, "closed"
        boxClosed.height.should.equal 50, "closed"
        done()

    it "should work hover", (done) ->
      getBoundingBoxes "third","mouseenter", (boxClosed, boxOpened) ->
        boxOpened.width.should.equal 180, "hovered"
        boxOpened.height.should.equal 150, "hovered"
        boxClosed.width.should.equal 150, "closed"
        boxClosed.height.should.equal 50, "closed"
        done()
