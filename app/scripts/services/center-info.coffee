
angular.module('kiteLineApp').service 'CenterInfoService', ($http, $q, $rootScope, toastr, $location) ->
  
  if window.location.href.indexOf('localhost:9000') > -1 || window.location.href.indexOf('cloud.spinsys.com') > - 1
    $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/'
  else if window.location.href.indexOf('parent.skychildcare.com') > - 1
    $rootScope.rootUrl = 'https://app.skychildcare.com/services/kiteline/v2.0/'
  else if window.location.href.indexOf('uat.skychildcare.com/parentportal') > - 1
    $rootScope.rootUrl = ' https://uat.skychildcare.com/services/KiteLine/V2.0/'

  rootUrl =  $rootScope.rootUrl
  $rootScope.rootUrlCenterSearch = $rootScope.rootUrl+'api/CenterInfo/GetCenters?searchText='
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
      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'
        
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
      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
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
      if data.Message isnt null
        toastr.error data.Message, 'Error'
      else
        toastr.error data.Message, 'Error'
        
      return

  return