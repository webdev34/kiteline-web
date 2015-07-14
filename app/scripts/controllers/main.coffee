'use strict'
angular.module('kiteLineApp').controller 'MainCtrl', ($scope, $rootScope, $location, StorageService, usSpinnerService) ->
  $rootScope.pageTitle = ''
  $rootScope.changePageTitle = () ->
    if $location.$$path is '/dashboard'
      $rootScope.pageTitle = 'Dashboard'

    if $location.$$path is '/billing'
      $rootScope.pageTitle = 'Billing'

    if $location.$$path is '/'
      $rootScope.pageTitle = 'Kiteline Web'

    if $location.$$path is '/my-children'
      $rootScope.pageTitle = 'My Children'

    if $location.$$path is '/messages'
      $rootScope.pageTitle = 'Messages'

  $rootScope.startSpin = ->
    usSpinnerService.spin 'spinner-1'

  $rootScope.stopSpin = ->
    usSpinnerService.stop 'spinner-1'

  $rootScope.logOut = () ->
    StorageService.deleteLocalStorage();
    $location.path '/'

  $rootScope.changePageTitle()

  $rootScope.scrollbarConfig =
    theme: 'dark'
    scrollInertia: 500

  # if window.location.href.indexOf('localhost') > -1
  #   $rootScope.rootUrl = 'https://uat.skychildcare.com/services/KiteLine/V1.0/'
  # else
  $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/'

  $rootScope.footerYear = (new Date).getFullYear()