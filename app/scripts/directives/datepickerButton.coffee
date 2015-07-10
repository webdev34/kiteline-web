angular.module('kiteLineApp').directive 'datepickerButton', ->
  { link: (scope, el, attr) ->
    
    el.bind 'click', ->
      $('.'+attr.datepickerParent).focus()
    return
 }
