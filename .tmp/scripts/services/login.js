(function() {
  'use strict';
  angular.module('kiteLineApp').service('LogInService', function($http, $q, $rootScope, toastr, $location, StorageService) {
    var deferred, rootUrl, self, url;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    url = void 0;
    deferred = void 0;
    deferred = $q.defer();
    this.Login = function(email, pin, centerId) {
      url = rootUrl + 'api/Login';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        data: {
          'CenterId': centerId,
          'GuardianEmail': email,
          'Pin': pin
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        $rootScope.currentCenter = data;
        $rootScope.currentUserEmail = email;
        $rootScope.currentUserToken = headers()['x-skychildcaretoken'];
        StorageService.setItem('currentCenter', data);
        StorageService.setItem('x-skychildcaretoken', $rootScope.currentUserToken);
        StorageService.setItem('userEmail', email);
        $location.path('dashboard');
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        $rootScope.dataLoading = false;
        toastr.clear();
        toastr.error(data.Message, 'Error');
      });
    };
    this.getCenterInfo = function(centerId, familyId) {
      url = rootUrl + 'api/Account/GetAccounts?familyId=' + familyId + '&centerId=' + centerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        $rootScope.currentCenterInfo = data;
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        $rootScope.currentCenterInfo = null;
        toastr.error(status, 'Error');
      });
    };
    this.ForgotPin = function(email, centerId) {
      url = rootUrl + 'api/ForgotPin/SendForgottenPIN';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        data: {
          'emailAddress': email,
          'CenterId': centerId
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        $rootScope.dataLoading = false;
        toastr.clear();
        toastr.success(data, 'Success');
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        $rootScope.dataLoading = false;
        toastr.clear();
        toastr.error(data.Message, 'Error');
      });
    };
    this.isLoggedIn = function() {
      if (StorageService.getItem('currentCenter') && $location.$$path === '/') {
        $location.path('dashboard');
      } else if (StorageService.getItem('currentCenter')) {
        $rootScope.currentCenter = StorageService.getItem('currentCenter');
      }
    };
  });

}).call(this);

//# sourceMappingURL=login.js.map
