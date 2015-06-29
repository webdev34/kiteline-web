(function() {
  'use strict';
  angular.module('kiteLineApp').service('CenterInfoService', function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getAllActiveCenters = function() {
      var url;
      url = rootUrl + 'api/CenterInfo/GetAllActiveCenters';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.centerSearch = function(text) {
      var url;
      if (text.length > 0) {
        url = rootUrl + 'api/CenterInfo/GetCenters?searchText=' + text;
        return $http({
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
          },
          url: url
        }).success(function(data, status, headers, config) {
          deferred.resolve(data);
          $rootScope.careCenters = data;
        }).error(function(data, status, headers, config) {
          deferred.reject(status);
          $rootScope.careCenters = null;
        });
      }
    };
    this.getCenterDetails = function(centerId) {
      var url;
      url = rootUrl + 'api/CenterInfo/CenterDetail/' + centerId;
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
  });

}).call(this);

//# sourceMappingURL=center-info.js.map
