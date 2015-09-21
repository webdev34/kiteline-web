'use strict'
angular.module('kiteLineApp').controller 'LoginCtrl', [
  '$scope'
  '$rootScope'
  '$location'
  'LogInService'
  'CenterInfoService'
  'ForgotPinService'
  ($scope, $rootScope, $location, LogInService, CenterInfoService, ForgotPinService, StorageService) ->
    $rootScope.isLoggedIn = false
    $rootScope.isLoginPage = true
    $rootScope.showLogIn = true
    $scope.email = ''
    $scope.pin = ''
    $rootScope.centerId = ''
    $scope.emailForgotPin = ''
    $scope.requestSent = false
    $scope.currentActive = 0
    $rootScope.centernameSearch = null
    LogInService.isLoggedIn()
    $rootScope.changePageTitle()

    $scope.requestUpgrade = (centerId, familyId) ->
      LogInService.sendRequestEmail(centerId, familyId).then (response) ->
        $scope.requestSent = true

    $scope.login = ->
      $rootScope.dataLoading = true
      $rootScope.centerId = $scope.centernameSearch.originalObject.CenterId
      LogInService.Login($scope.email, $scope.pin, $rootScope.centerId).then (response) ->
        $rootScope.dataLoading = false

    $scope.changeView = (view) ->
      if view == 'forgotPin'
        $rootScope.showLogIn = false
      else
        $rootScope.showLogIn = true
        $scope.validationCheck()

    $scope.forgotPinFunc = ->
      $rootScope.dataLoading = true
      ForgotPinService.sendForgottenPIN $scope.email, $rootScope.centerId
  
    return
]