(function() {
  'use strict';
  angular.module('kiteLineApp').service('ChildService', function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.updateChildGenInfo = function(obj) {
      var url;
      url = rootUrl + 'api/Child/UpdateChildGenInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildId': obj.ChildId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'FirstName': obj.FirstName,
          'MiddleName': obj.MiddleName,
          'LastName': obj.LastName,
          'NickName': obj.NickName,
          'Sex': obj.Sex,
          'DOB': obj.DOB,
          'EnrollmentStatus': obj.EnrollmentStatus,
          'PhotoVideoAuthorization': obj.PhotoVideoAuthorization,
          'Notes': obj.Notes
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateChildMedInfo = function(obj) {
      var url;
      url = rootUrl + 'api/Child/UpdateChildMedInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildId': obj.ChildId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'DoctorName': obj.DoctorName,
          'DoctorPhone': obj.DoctorPhone,
          'PhysicalDate': obj.PhysicalDate,
          'Immunized': obj.Immunized,
          'InsuranceCompany': obj.InsuranceCompany,
          'PolicyNumber': obj.PolicyNumber,
          'GroupNumber': obj.GroupNumber
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateChildHistory = function(obj) {
      var url;
      url = rootUrl + 'api/Child/UpdateChildHistory';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildId': obj.ChildId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'HomeLanguage': obj.HomeLanguage,
          'HowCommunicate': obj.HowCommunicate,
          'FavToys': obj.FavToys,
          'FavFoods': obj.FavFoods,
          'AllergiesFoodRestrictions': obj.AllergiesFoodRestrictions,
          'RegularMedications': obj.RegularMedications,
          'EmergencyMedication': obj.EmergencyMedication,
          'BlanketSpecialToy': obj.BlanketSpecialToy,
          'AdditionalInformation': obj.AdditionalInformation
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateMedication = function(childMedicationId, childId, centerId, medicationName, frequency, startDate, endDate, expiration, instructions, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/UpdateMedication';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildMedicationId': childMedicationId,
          'ChildId': childId,
          'CenterId': centerId,
          'MedicationName': medicationName,
          'Frequency': frequency,
          'StartDate': startDate,
          'EndDate': endDate,
          'Expiration': expiration,
          'Instructions': instructions,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.addMedication = function(childMedicationId, childId, centerId, medicationName, frequency, startDate, endDate, expiration, instructions, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/AddMedication';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildMedicationId': childMedicationId,
          'ChildId': childId,
          'CenterId': centerId,
          'MedicationName': medicationName,
          'Frequency': frequency,
          'StartDate': startDate,
          'EndDate': endDate,
          'Expiration': expiration,
          'Instructions': instructions,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateAllergy = function(childAllergyId, childId, centerId, allergyName, severity, action, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/UpdateAllergy';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildAllergyId': childAllergyId,
          'ChildId': childId,
          'CenterId': centerId,
          'AllergyName': allergyName,
          'Severity': severity,
          'Action': action,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.addAllergy = function(childAllergyId, childId, centerId, allergyName, severity, action, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/AddAllergy';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildAllergyId': childAllergyId,
          'ChildId': childId,
          'CenterId': centerId,
          'AllergyName': allergyName,
          'Severity': severity,
          'Action': action,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildClass = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildClass/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildren = function(familyId) {
      var url;
      url = rootUrl + 'api/Child/GetChildren/' + familyId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildGenInfo = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildGenInfo/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildMedInfo = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildMedInfo/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildHistory = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildHistory/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getMedications = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetMedications/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteMedications = function(childMedicationId) {
      var url;
      url = rootUrl + 'api/Child/DeleteMedication/' + childMedicationId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAllergies = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetAllergies/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteAllergy = function(childAllergyId) {
      var url;
      url = rootUrl + 'api/Child/DeleteAllergy/' + childAllergyId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  });

}).call(this);

//# sourceMappingURL=child.js.map
