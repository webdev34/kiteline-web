(function() {
  'use strict';
  angular.module('kiteLineApp').service('ImmunizationService', function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getImmunizations = function(childId, centerId) {
      var url;
      url = rootUrl + 'api/Immunization/GetImmunizations?childId=' + childId + '&centerId=' + centerId;
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
    this.createImmunization = function(childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) {
      var url;
      url = rootUrl + 'api/Immunization/CreateImmunization';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        }
      }, {
        data: {
          'ChildImmunizationId': childImmunizationId,
          'ChildId': childId,
          'CenterId': centerId,
          'ImmunizationName': immunizationName,
          'Description': description,
          'Doses': doses,
          'DateReceived': dateReceived,
          'ExpiryDate': expiryDate,
          'UserId': userId,
          url: url
        }
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateImmunization = function(childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) {
      var url;
      url = rootUrl + 'api/Immunization/UpdateImmunization';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        }
      }, {
        data: {
          'ChildImmunizationId': childImmunizationId,
          'ChildId': childId,
          'CenterId': centerId,
          'ImmunizationName': immunizationName,
          'Description': description,
          'Doses': doses,
          'DateReceived': dateReceived,
          'ExpiryDate': expiryDate,
          'UserId': userId,
          url: url
        }
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteImmunization = function(childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) {
      var url;
      url = rootUrl + 'api/Immunization/DeleteImmunization';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildImmunizationId': childImmunizationId,
          'ChildId': childId,
          'CenterId': centerId,
          'ImmunizationName': immunizationName,
          'Description': description,
          'Doses': doses,
          'DateReceived': dateReceived,
          'ExpiryDate': expiryDate,
          'UserId': userId
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

//# sourceMappingURL=immunization.js.map
