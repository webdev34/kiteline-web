'use strict'
angular.module('kiteLineApp').directive 'numbersOnly', ->
  {
    require: 'ngModel'
    link: (scope, element, attrs, modelCtrl) ->

      modelCtrl.$parsers.push (inputValue) ->
        if isNaN(modelCtrl.$viewValue)
          modelCtrl.$setViewValue inputValue
          modelCtrl.$render()
        inputValue
      return

  }

angular.module('kiteLineApp').directive 'numericOnly', ->
  {
    require: 'ngModel'
    link: (scope, element, attrs, modelCtrl) ->

      modelCtrl.$parsers.push (inputValue) ->
        transformedInput = modelCtrl.$viewValue.replace(/[^0-9]/g, '')
        modelCtrl.$setViewValue transformedInput
        modelCtrl.$render()
        transformedInput
      return

  }