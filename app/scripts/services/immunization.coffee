'use strict'
angular.module('kiteLineApp').service 'ImmunizationService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getImmunizations = (childId) ->   
    url = rootUrl+'api/Immunization/GetImmunizations?childId='+childId+'&centerId='+$rootScope.currentCenter.CenterId
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

  @createImmunization = (obj, childId) ->   
    url = rootUrl+'api/Immunization/CreateImmunization'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildImmunizationId': 0
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'ImmunizationName': obj.ImmunizationName
        'Description': obj.Description
        'Doses': obj.Doses
        'DateReceived': obj.DateReceived
        'ExpiryDate': obj.ExpiryDate
        'UserId': $rootScope.currentUserEmail
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

  @updateImmunization = (obj, childId) ->   
    url = rootUrl+'api/Immunization/UpdateImmunization'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildImmunizationId': obj.ChildImmunizationId
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'ImmunizationName': obj.ImmunizationName
        'Description': obj.Description
        'Doses': obj.Doses
        'DateReceived': obj.DateReceived
        'ExpiryDate': obj.ExpiryDate
        'UserId': $rootScope.currentUserEmail
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

  @deleteImmunization = (obj, childId) ->   
    url = rootUrl+'api/Immunization/DeleteImmunization'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildImmunizationId': obj.ChildImmunizationId
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'ImmunizationName': obj.immunizationName
        'Description': obj.Description
        'Doses': obj.Doses
        'DateReceived': obj.DateReceived
        'ExpiryDate': obj.ExpiryDate
        'UserId': $rootScope.currentUserEmail
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