 angular.module('kiteLineApp').directive 'selectButton', ->
  { link: (scope, el, attr) ->
    event = undefined
    el.bind 'click', ->
      dropdown = undefined
      dropdown = document.getElementById(attr.selectId)
      event = undefined
      event = document.createEvent('MouseEvents')
      event.initMouseEvent 'mousedown', true, true, window
      dropdown.dispatchEvent event
    return
 }