'use strict'
angular.module('kiteLineApp').controller 'LoginCtrl', [
  '$scope'
  '$rootScope'
  '$location'
  'LogInService'
  'CenterInfoService'
  'ForgotPinService'
  ($scope, $rootScope, $location, LogInService, CenterInfoService, ForgotPinService) ->
    LogInService.isLoggedIn()
    $rootScope.isLoggedIn = false
    $rootScope.isLoginPage = true
    $scope.isValid = false
    $scope.isValidForgotPin = false
    $scope.showLogIn = true
    $scope.email = ''
    $scope.pin = ''
    $scope.centerId = ''
    $scope.emailForgotPin = ''

    $scope.login = ->
      $rootScope.dataLoading = true
      LogInService.Login($scope.email, $scope.pin, $scope.centerId).then (response) ->
        $rootScope.dataLoading = false
        $rootScope.showLogOut = false
      return

    $scope.changeView = (view) ->
      if view == 'forgotPin'
        $scope.showLogIn = false
        $scope.validationCheckForgotPin()
      else
        $scope.showLogIn = true
        $scope.validationCheck()
      return

    $scope.centerSearchFunc = ->
      CenterInfoService.centerSearch $scope.centernameSearch
      return

    $scope.forgotPinFunc = ->
      $rootScope.dataLoading = true
      ForgotPinService.sendForgottenPIN $scope.email, $scope.centerId
      return

    $scope.selectCenter = (centerId, centerName) ->
      $scope.centernameSearch = centerName
      $scope.centerId = centerId
      $rootScope.careCenters = null
      if $scope.showLogIn == true
        $scope.validationCheck()
      else
        $scope.validationCheckForgotPin()
      return

    $scope.validationCheck = ->
      if $scope.email.length != 0 and $scope.pin.length != 0 and $scope.centerId.length != 0
        $scope.isValid = true
      else
        $scope.isValid = false
      return

    $scope.validationCheckForgotPin = ->
      if $scope.email.length != 0 and $scope.centerId.length != 0
        $scope.isValidForgotPin = true
      else
        $scope.isValidForgotPin = false
      return

    return
]