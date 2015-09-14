'use strict'
angular.module('kiteLineApp').service 'LogInService', ($http, $q, $rootScope, toastr, $location, StorageService, CustomStatisticsService) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  url = undefined
  deferred = undefined
  deferred = $q.defer()
  $rootScope.invalidCenter = null
  
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
        'InitialLogin': true
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      if data.SubscriptionTypeName is 'bronze'
        $rootScope.invalidCenter = data
        $location.path 'invalid-subscription'
      else
        $rootScope.currentCenter = data
        $rootScope.currentUserEmail = email
        $rootScope.currentUserToken = headers()['x-skychildcaretoken']

        StorageService.setItem 'currentCenter', data
        StorageService.setItem 'x-skychildcaretoken', $rootScope.currentUserToken
        StorageService.setItem 'userEmail', email
        StorageService.setItem 'userPin', pin
        StorageService.setItem 'LastLoginInfo', data.LastLoginInfo
        
        self.setTimeStamp()
        $location.path 'dashboard'
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.dataLoading = false

      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'

      return

   @updateStaleData = (email, pin, centerId) ->
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
        'InitialLogin': false
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      $rootScope.currentCenter = data
      $rootScope.currentUserEmail = email
      $rootScope.currentUserToken = headers()['x-skychildcaretoken']
      self.checkTimeStamp()
      StorageService.setItem 'currentCenter', data
      StorageService.setItem 'x-skychildcaretoken', $rootScope.currentUserToken
      StorageService.setItem 'userEmail', email
      StorageService.setItem 'userPin', pin

      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.dataLoading = false

      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
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
      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'
        
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
      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'
        
      return

  @isLoggedIn = ->
    self.checkTimeStamp()
    if StorageService.getItem('currentCenter') and $location.$$path == '/'
      $location.path 'dashboard'
    else if StorageService.getItem('currentCenter')
      this.updateStaleData(StorageService.getItem('userEmail'), StorageService.getItem('userPin'), StorageService.getItem('currentCenter').CenterId)
    else
      $rootScope.stopSpin()

      $location.path '/'
      $rootScope.changePageTitle()

  @setTimeStamp = ->
    timeNow = new Date
    StorageService.setItem 'time-stamp', timeNow

  @checkTimeStamp = ->
    millennium = new Date(StorageService.getItem('time-stamp'))
    today = new Date
    miliseconds = today - millennium
    seconds = miliseconds / 1000
    minutes = seconds / 60
    hours = minutes / 60
    if hours > 7
      StorageService.deleteLocalStorage()
      $location.path '/'

  @sendRequestEmail = (centerId, familyId) ->
    url = rootUrl+'api/Login/SendRequestEmail?centerid='+centerId+'&familyid='+familyId
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      toastr.success 'E-mail has been sent'
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.currentCenterInfo = null
      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'
        
      return

  return