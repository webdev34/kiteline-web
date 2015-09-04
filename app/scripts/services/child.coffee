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
      
      toastr.error data.Message, 'Error'
      return

  @updateMedication = (childMedicationId, childId, centerId, medicationName, frequency, startDate, endDate, expiration, instructions, openUID, openDate, editUID, editDate) ->  
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
        'ChildMedicationId': childMedicationId
        'ChildId': childId
        'CenterId': centerId
        'MedicationName': medicationName
        'Frequency': frequency
        'StartDate': startDate
        'EndDate': endDate
        'Expiration': expiration
        'Instructions': instructions
        'OPEN_UID': openUID
        'OPEN_DATE': openDate
        'EDIT_UID': editUID
        'EDIT_DATE': editDate

      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error data.Message, 'Error'
      return  

  @addMedication = (childMedicationId, childId, centerId, medicationName, frequency, startDate, endDate, expiration, instructions, openUID, openDate, editUID, editDate) ->  
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
        'ChildMedicationId': childMedicationId
        'ChildId': childId
        'CenterId': centerId
        'MedicationName': medicationName
        'Frequency': frequency
        'StartDate': startDate
        'EndDate': endDate
        'Expiration': expiration
        'Instructions': instructions
        'OPEN_UID': openUID
        'OPEN_DATE': openDate
        'EDIT_UID': editUID
        'EDIT_DATE': editDate

      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error data.Message, 'Error'
      return

  @updateAllergy = (childAllergyId, childId, centerId, allergyName, severity, action, openUID, openDate, editUID, editDate) ->  
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
        'ChildAllergyId': childAllergyId
        'ChildId': childId
        'CenterId': centerId
        'AllergyName': allergyName
        'Severity': severity
        'Action': action
        'OPEN_UID': openUID
        'OPEN_DATE': openDate
        'EDIT_UID': editUID
        'EDIT_DATE': editDate

      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error data.Message, 'Error'
      return

  @addAllergy = (childAllergyId, childId, centerId, allergyName, severity, action, openUID, openDate, editUID, editDate) ->  
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
        'ChildAllergyId': childAllergyId
        'ChildId': childId
        'CenterId': centerId
        'AllergyName': allergyName
        'Severity': severity
        'Action': action
        'OPEN_UID': openUID
        'OPEN_DATE': openDate
        'EDIT_UID': editUID
        'EDIT_DATE': editDate

      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
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
      
      toastr.error data.Message, 'Error'
      return

  @deleteMedications = (childMedicationId) ->  
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
      
      toastr.error data.Message, 'Error'
      return
      
  return