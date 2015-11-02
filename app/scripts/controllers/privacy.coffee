
angular.module('kiteLineApp').controller 'PrivacyCtrl', ($scope, $rootScope) ->
  $rootScope.pageTitle = 'Kiteline Privacy Policy'
  $rootScope.isLoggedIn = false
  $rootScope.isLoginPage = true
  $rootScope.isPrivacy = true
  $rootScope.widerContainer = true