
angular.module('kiteLineApp').service 'GuardianService', ($http, $q, $rootScope, toastr, $location, StorageService, LogInService, ngDialog) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  
  @updatePin = (currentPin, newPin) ->   
    url = rootUrl+'api/Guardian/updatepin'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'GuardianId': $rootScope.currentCenter.GuardianId
        'CurrentPin': document.getElementById('oldPin').value
        'NewPin': document.getElementById('newPin').value
        'CenterId': $rootScope.currentCenter.CenterId

      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      if data is 'Current Pin is incorrect. Enter correct Pin to change it.' or data is 'Desired Pin is not available, please enter different Pin.'
        toastr.error data, 'Error'
      else if data is 'Success'
        toastr.success 'PIN successfully updated.', 'Success'
        StorageService.setItem 'userPin', document.getElementById('newPin').value
        ngDialog.closeAll()

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error status, 'Success'
      return

  @getAllGuardians = (familyId) ->  
    url = rootUrl+'api/Guardians/GetAllGuardians/'+familyId
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

  @getGuardian = (guardianId) ->  
    url = rootUrl+'api/Guardians/GetGuardian/'+guardianId
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

  @updatePersonalInfo = (obj) ->
    url = rootUrl+'api/Guardian/UpdatePersonalInfo'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'GuardianId': obj.GuardianId
        'FirstName': obj.FirstName
        'LastName': obj.LastName
        'RelationShip': obj.RelationShip
        'LegalCustody': obj.LegalCustody
        'Employer': obj.Employer

      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error status, 'Error'
      return

  @updateMailingAddress = (obj) ->   
    url = rootUrl+'api/Guardian/UpdateMailingAddress'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'GuardianId': obj.GuardianId
        'Street': obj.Street
        'City': obj.City
        'State': obj.State
        'Zip': obj.Zip

      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error status, 'Error'
      return

  @updateContactInfo = (obj) ->  
    url = rootUrl+'api/Guardian/UpdateContactInfo'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'GuardianId': obj.GuardianId
        'HomePhone': obj.HomePhone
        'CellPhone': obj.CellPhone
        'WorkPhone': obj.WorkPhone
        'EmailAddress': obj.EmailAddress
        'PrefMethodOfContact': obj.PrefMethodOfContact

      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      if $rootScope.loggedInGuardianId == obj.GuardianId
        StorageService.setItem('userEmail', $rootScope.currentUserEmail) 
        $rootScope.currentUserEmail = $rootScope.currentUserEmail
        LogInService.Login(obj.EmailAddress, StorageService.getItem('userPin'), StorageService.getItem('currentCenter').CenterId, true)
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error status, 'Error'
      return

  return