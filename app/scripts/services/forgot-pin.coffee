'use strict'
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

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error data.Message, 'Error'
      return

  return