'use strict'
angular.module('kiteLineApp').controller 'PrivacyCtrl', ($scope, $rootScope) ->
  $rootScope.pageTitle = 'Kiteline Privacy Policy'
  $rootScope.isLoggedIn = false
  $rootScope.isLoginPage = true
  $rootScope.widerContainer = true