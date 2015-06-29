'use strict'
angular.module('kiteLineApp').service 'CurbSideService', ($http, $q, $rootScope, toastr) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @checkInChild = (centerId, childId, punchType, guardianId, openDate) ->   
    url = rootUrl+'api/CurbSide/CheckInChild'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'CenterId': centerId
        'ChildId': childId
        'PunchType': punchType
        'GuardianId': guardianId
        'OPEN_DATE': openDate
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
     
      toastr.error status, 'Error'
      return

  @getAllChildren = (centerId, familyId) ->
    url = rootUrl+'api/'+centerId+'/'+familyId+'/Child/All'
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
      
      toastr.error status, 'Error'
      return

  return