'use strict'
angular.module('kiteLineApp').controller 'TOSCtrl', ($scope, $rootScope) ->
  $rootScope.pageTitle = 'Kiteline Terms Of Service'
  $rootScope.isLoggedIn = false
  $rootScope.isLoginPage = true
  $rootScope.widerContainer = true