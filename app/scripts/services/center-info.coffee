'use strict'
angular.module('kiteLineApp').service 'CenterInfoService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getAllActiveCenters = () ->   
    url = rootUrl+'api/CenterInfo/GetAllActiveCenters'
    $http(
      method: 'GET'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      toastr.error status, 'Error'
      return

  @centerSearch = (text) ->
    if text.length > 0
      url = rootUrl+'api/CenterInfo/GetCenters?searchText='+text
      return $http(
        method: 'GET'
        headers:
          'Content-Type': 'application/json'
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        url: url).success((data, status, headers, config) ->
        deferred.resolve data
        $rootScope.careCenters = data
        return
      ).error((data, status, headers, config) ->
        deferred.reject status
        $rootScope.careCenters = null
        return
      )
    return

  @getCenterDetails = (centerId) ->
    url = rootUrl+'api/CenterInfo/CenterDetail/'+centerId
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

  @getCenterFiles = (centerId) ->
    url = rootUrl+'api/CenterInfo/GetCenterFiles?centerid='+centerId
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