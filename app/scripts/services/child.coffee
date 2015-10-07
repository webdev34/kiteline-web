'use strict'
angular.module('kiteLineApp').service 'ChildService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @updateChildGenInfo = (obj) ->   
    url = rootUrl+'api/Child/UpdateChildGenInfo'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildId': obj.ChildId
        'CenterId': $rootScope.currentCenter.CenterId
        'FirstName': obj.FirstName
        'MiddleName': obj.MiddleName
        'LastName': obj.LastName
        'NickName': obj.NickName
        'Sex': obj.Sex
        'DOB': obj.DOB
        'EnrollmentStatus': obj.EnrollmentStatus
        'PhotoVideoAuthorization': obj.PhotoVideoAuthorization
        'Notes': obj.Notes
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

  @updateChildMedInfo = (obj) ->   
    url = rootUrl+'api/Child/UpdateChildMedInfo'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildId': obj.ChildId
        'CenterId': $rootScope.currentCenter.CenterId
        'DoctorName': obj.DoctorName
        'DoctorPhone': obj.DoctorPhone
        'PhysicalDate': obj.PhysicalDate
        'Immunized': obj.Immunized
        'InsuranceCompany': obj.InsuranceCompany
        'PolicyNumber': obj.PolicyNumber
        'GroupNumber': obj.GroupNumber
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

  @updateChildHistory = (obj) ->  
    url = rootUrl+'api/Child/UpdateChildHistory'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildId': obj.ChildId
        'CenterId': $rootScope.currentCenter.CenterId
        'HomeLanguage': obj.HomeLanguage
        'HowCommunicate': obj.HowCommunicate
        'FavToys': obj.FavToys
        'FavFoods': obj.FavFoods
        'AllergiesFoodRestrictions': obj.AllergiesFoodRestrictions
        'RegularMedications': obj.RegularMedications
        'EmergencyMedication': obj.EmergencyMedication
        'BlanketSpecialToy': obj.BlanketSpecialToy
        'AdditionalInformation': obj.AdditionalInformation

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

  @updateMedication = (obj, childId) ->  
    url = rootUrl+'api/Child/UpdateMedication'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildMedicationId': obj.ChildMedicationId
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'MedicationName': obj.MedicationName
        'Frequency': obj.Frequency
        'StartDate': obj.StartDate
        'EndDate': obj.EndDate
        'Expiration': obj.Expiration
        'Instructions': obj.Instructions
        'OPEN_UID': $rootScope.currentUserEmail
        'OPEN_DATE': new Date
        'EDIT_UID': $rootScope.currentUserEmail
        'EDIT_DATE': new Date

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

  @addMedication = (obj, childId) ->  
    url = rootUrl+'api/Child/AddMedication'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildMedicationId':0
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'MedicationName': obj.MedicationName
        'Frequency': obj.Frequency
        'StartDate': obj.StartDate
        'EndDate': obj.EndDate
        'Expiration': obj.Expiration
        'Instructions': obj.Instructions
        'OPEN_UID': $rootScope.currentUserEmail
        'OPEN_DATE': new Date
        'EDIT_UID': $rootScope.currentUserEmail
        'EDIT_DATE': new Date

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

  @updateAllergy = (obj, childId) ->  
    url = rootUrl+'api/Child/UpdateAllergy'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildAllergyId': obj.ChildAllergyId
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'AllergyName': obj.AllergyName
        'Severity': obj.Severity
        'Action': obj.Action
        'OPEN_UID': $rootScope.currentUserEmail
        'OPEN_DATE': new Date
        'EDIT_UID': $rootScope.currentUserEmail
        'EDIT_DATE': new Date

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

  @addAllergy = (obj, childId) ->  
    url = rootUrl+'api/Child/AddAllergy'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'ChildAllergyId': obj.ChildAllergyId
        'ChildId': childId
        'CenterId': $rootScope.currentCenter.CenterId
        'AllergyName': obj.AllergyName
        'Severity': obj.Severity
        'Action': obj.Action
        'OPEN_UID': $rootScope.currentUserEmail
        'OPEN_DATE': new Date
        'EDIT_UID': $rootScope.currentUserEmail
        'EDIT_DATE': new Date

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

  @getChildClass = (childId) ->  
    url = rootUrl+'api/Child/GetChildClass/'+childId
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

  @getChildren = (familyId) ->  
    url = rootUrl+'api/Child/GetChildren/'+familyId
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

  @getChildGenInfo = (childId) ->  
    url = rootUrl+'api/Child/GetChildGenInfo/'+childId
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

  @getChildMedInfo = (childId) ->  
    url = rootUrl+'api/Child/GetChildMedInfo/'+childId
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

  @getChildHistory = (childId) ->  
    url = rootUrl+'api/Child/GetChildHistory/'+childId
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

  @getMedications = (childId) ->  
    url = rootUrl+'api/Child/GetMedications/'+childId
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

  @deleteMedication = (childMedicationId) ->  
    url = rootUrl+'api/Child/DeleteMedication/'+childMedicationId
    $http(
      method: 'POST'
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

  @getAllergies = (childId) ->  
    url = rootUrl+'api/Child/GetAllergies/'+childId
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

  @deleteAllergy = (childAllergyId) ->  
    url = rootUrl+'api/Child/DeleteAllergy/'+childAllergyId
    $http(
      method: 'POST'
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