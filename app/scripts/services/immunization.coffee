'use strict'
angular.module('kiteLineApp').service 'ImmunizationService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getImmunizations = (childId, centerId) ->   
    url = rootUrl+'api/Immunization/GetImmunizations?childId='+childId+'&centerId='+centerId
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

  @createImmunization = (childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) ->   
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
      'ChildImmunizationId': childImmunizationId
      'ChildId': childId
      'CenterId': centerId
      'ImmunizationName': immunizationName
      'Description': description
      'Doses': doses
      'DateReceived': dateReceived
      'ExpiryDate': expiryDate
      'UserId': userId
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error status, 'Error'
      return

  @updateImmunization = (childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) ->   
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
      'ChildImmunizationId': childImmunizationId
      'ChildId': childId
      'CenterId': centerId
      'ImmunizationName': immunizationName
      'Description': description
      'Doses': doses
      'DateReceived': dateReceived
      'ExpiryDate': expiryDate
      'UserId': userId
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error status, 'Error'
      return

  @deleteImmunization = (childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) ->   
    url = rootUrl+'api/Immunization/DeleteImmunization'
    $http(
      method: 'GET'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildImmunizationId': childImmunizationId
        'ChildId': childId
        'CenterId': centerId
        'ImmunizationName': immunizationName
        'Description': description
        'Doses': doses
        'DateReceived': dateReceived
        'ExpiryDate': expiryDate
        'UserId': userId
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error status, 'Error'
      return

  return