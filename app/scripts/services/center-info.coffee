'use strict'
angular.module('kiteLineApp').service 'CenterInfoService', ($http, $q, $rootScope, toastr, $location) ->
  
  if window.location.href.indexOf('localhost') > -1 || window.location.href.indexOf('cloud') > - 1
    $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/'
  else if window.location.href.indexOf('parent') > - 1
    $rootScope.rootUrl = 'https://app.skychildcare.com/services/kiteline/v2.0/'
  else
    $rootScope.rootUrl = ' https://uat.skychildcare.com/services/KiteLine/V2.0/'

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
      toastr.error data.Message, 'Error'
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
      toastr.error data.Message, 'Error'
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
      toastr.error data.Message, 'Error'
      return

  return