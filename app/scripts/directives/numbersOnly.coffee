'use strict'
angular.module('kiteLineApp').directive 'numbersOnly', ->
  {
    require: 'ngModel'
    link: (scope, element, attrs, modelCtrl) ->

      modelCtrl.$parsers.push (inputValue) ->
        transformedInput = undefined
        if inputValue == undefined
          return ''
        transformedInput = inputValue.replace(/[^0-9]/g, '')
        if transformedInput != inputValue
          modelCtrl.$setViewValue transformedInput
          modelCtrl.$render()
        transformedInput
      return

  }