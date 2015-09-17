'use strict'
angular.module('kiteLineApp').controller 'LoginCtrl', [
  '$scope'
  '$rootScope'
  '$location'
  'LogInService'
  'CenterInfoService'
  'ForgotPinService'
  ($scope, $rootScope, $location, LogInService, CenterInfoService, ForgotPinService, StorageService) ->
    # LogInService.isLoggedIn()
    $rootScope.isLoggedIn = false
    $rootScope.isLoginPage = true
    $scope.isValid = false
    $scope.isValidForgotPin = false
    $scope.showLogIn = true
    $scope.email = ''
    $scope.pin = ''
    $rootScope.centerId = ''
    $scope.emailForgotPin = ''
    $scope.requestSent = false
    $scope.currentActive = 0
    LogInService.isLoggedIn()
    $rootScope.changePageTitle()

    if $location.$$path == '/invalid-subscription'
      if $rootScope.invalidCenter is null
        $location.path '/'

    $scope.requestUpgrade = (centerId, familyId) ->
      LogInService.sendRequestEmail(centerId, familyId).then (response) ->
        $scope.requestSent = true

    $scope.login = ->
      $rootScope.dataLoading = true
      LogInService.Login($scope.email, $scope.pin, $rootScope.centerId).then (response) ->
        $rootScope.dataLoading = false

    $scope.changeView = (view) ->
      if view == 'forgotPin'
        $scope.showLogIn = false
        $scope.validationCheckForgotPin()
      else
        $scope.showLogIn = true
        $scope.validationCheck()

    $scope.centerSearchFunc = ($event)->
      if $scope.centernameSearch && $event.keyCode != 38 && $event.keyCode != 40
        CenterInfoService.centerSearch $scope.centernameSearch

    $scope.forgotPinFunc = ->
      $rootScope.dataLoading = true
      ForgotPinService.sendForgottenPIN $scope.email, $rootScope.centerId

    $scope.selectCenter = (centerId, centerName) ->
      $scope.centernameSearch = centerName
      $rootScope.centerId = centerId
      $rootScope.careCenters = null
      $scope.currentActive = 0
      document.getElementById('centernameSearch').blur()
      
      if $scope.showLogIn == true
        $scope.validationCheck()
      else
        $scope.validationCheckForgotPin()

    $scope.key = ($event) ->
      $scope.hideList = false
      if $scope.centernameSearch && $event.keyCode == 13
        angular.forEach $rootScope.careCenters, (value, key) ->
          if $rootScope.careCenters isnt null
            if $rootScope.careCenters[key].isActive == true
              $('#email').focus()
              $scope.hideList = true
              $scope.selectCenter($rootScope.careCenters[key].CenterId, $rootScope.careCenters[key].CenterName)

      else if $scope.centernameSearch && $event.keyCode == 38 || $event.keyCode == 40 
        angular.forEach $rootScope.careCenters, (value, key) ->
          $rootScope.careCenters[key].isActive = false

        if $event.keyCode == 38 && $scope.currentActive != 0
          $scope.currentActive--
          $rootScope.careCenters[$scope.currentActive].isActive = true  
        else if $event.keyCode == 40 && $scope.currentActive <= 3 && $scope.currentActive != 0
          $rootScope.careCenters[$scope.currentActive].isActive = true
          $scope.currentActive++ 
        else if $event.keyCode == 40 && $scope.currentActive <= 3 && $scope.currentActive == 0
          $scope.currentActive++
          $rootScope.careCenters[0].isActive = true
        else
          $rootScope.careCenters[$scope.currentActive].isActive = true

    $scope.validationCheck = ->
      if $scope.email
        if $scope.email.length != 0 and $scope.pin.length != 0 and $rootScope.centerId.length != 0
          $scope.isValid = true
        else
          $scope.isValid = false

    $scope.validationCheckForgotPin = ->
      if $scope.email.length != 0 and $rootScope.centerId.length != 0
        $scope.isValidForgotPin = true
      else
        $scope.isValidForgotPin = false

    return
]


angular.module('kiteLineApp').controller 'InvalidCtrl', ($scope, $rootScope, $location) ->
  $rootScope.widerContainer = true