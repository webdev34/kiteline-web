
angular.module('kiteLineApp').controller 'TOSCtrl', ($scope, $rootScope) ->
  $rootScope.pageTitle = 'Kiteline Terms Of Service'
  $rootScope.isLoggedIn = false
  $rootScope.isLoginPage = true
  $rootScope.isTOS = true
  $rootScope.widerContainer = true