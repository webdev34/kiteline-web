
angular.module('kiteLineApp').service 'ForgotPinService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @sendPin = (email) ->   
    url = rootUrl+'api/ForgotPin/SendPin'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      data:
        'emailAddress': email

      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.dataLoading = false

      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'
        
      return

  @sendForgottenPIN = (email, centerId) ->   
    url = rootUrl+'api/ForgotPin/SendForgottenPIN'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      data:
        'EmailAddress': email
        'CenterId': centerId

      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      $rootScope.dataLoading = false
      toastr.success 'Your pin has been sent!', 'Success'

      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      $rootScope.dataLoading = false

      if data.status == 200
        toastr.sucess '', data.data
      else
        toastr.error data.Message, 'Error'
        
      return

  return