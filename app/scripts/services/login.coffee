'use strict'
angular.module('kiteLineApp').service 'LogInService', ($http, $q, $rootScope, toastr, $location, StorageService) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  url = undefined
  deferred = undefined
  deferred = $q.defer()
  
  @Login = (email, pin, centerId) ->
    url = rootUrl+'api/Login'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      data:
        'CenterId': centerId
        'GuardianEmail': email
        'Pin': pin
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      $rootScope.currentCenter = data
      $rootScope.currentUserEmail = email
      $rootScope.currentUserToken = headers()['x-skychildcaretoken']

      StorageService.setItem 'currentCenter', data
      StorageService.setItem 'x-skychildcaretoken', $rootScope.currentUserToken
      StorageService.setItem 'userEmail', email

      $location.path 'dashboard'
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.dataLoading = false
      toastr.clear()
      toastr.error data.Message, 'Error'
      return

  @getCenterInfo = (centerId, familyId) ->
    url = rootUrl+'api/Account/GetAccounts?familyId='+familyId+'&centerId='+centerId
    $http(
      method: 'GET'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      $rootScope.currentCenterInfo = data
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.currentCenterInfo = null
      toastr.error status, 'Error'
      return

  @ForgotPin = (email, centerId) ->
    url = rootUrl+'api/ForgotPin/SendForgottenPIN'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      data:
        'emailAddress': email
        'CenterId': centerId
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      $rootScope.dataLoading = false
      toastr.clear()
      toastr.success data, 'Success'
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.dataLoading = false
      toastr.clear()
      toastr.error data.Message, 'Error'
      return

  @isLoggedIn = ->
    if StorageService.getItem('currentCenter') and $location.$$path == '/'
      $location.path 'dashboard'
    else if StorageService.getItem('currentCenter')
      $rootScope.currentCenter = StorageService.getItem('currentCenter')
    else
      $location.path '/'
      $rootScope.changePageTitle()


  return