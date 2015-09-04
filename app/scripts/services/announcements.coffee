'use strict'
angular.module('kiteLineApp').service 'AnnouncementsService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getAnnouncements = (customerId) ->   
    url = rootUrl+'api/Announcement/Get?customerId='+customerId
    $http(
      method: 'GET'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error data.Message, 'Error'
      return

  @getAnnouncementsCount = (customerId) ->   
    url = rootUrl+'api/Announcement/GetTotal?customerId='+customerId
    $http(
      method: 'GET'
    headers:
      'Content-Type': 'application/json'
      'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      'X-SkyChildCareToken': $rootScope.currentUserToken
      'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
      'X-SkyChildCareUserId': $rootScope.currentUserEmail
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error data.Message, 'Error'
      return

  return