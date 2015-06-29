(function() {
  'use strict';
  angular.module('kiteLineApp').service('InvoiceService', function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getOutstandingInvoices = function(customerId) {
      var url;
      url = rootUrl + 'api/Customer/' + customerId + '/Invoices/OutStandingInvoices';
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
    this.getPaidInvoices = function(customerId) {
      var url;
      url = rootUrl + 'api/Customer/' + customerId + '/Invoices/PaidInvoices';
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

//# sourceMappingURL=invoice.js.map
