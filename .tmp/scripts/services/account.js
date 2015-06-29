(function() {
  'use strict';
  angular.module('kiteLineApp').service('AccountService', function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getAccounts = function(familyId, centerId) {
      var url;
      url = rootUrl + 'api/Account/GetAccounts?familyId=' + familyId + '&centerId=' + centerId;
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
    this.getAccount = function(familyId, centerId, accountId) {
      var url;
      url = rootUrl + 'api/Account/GetAccount?familyId=' + familyId + '&centerId=' + centerId + '&accountId=' + accountId;
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
    this.createAccount = function(accountId, createdOn, verificationYN, recurringAccountYN, guardianId, payerId, payerName, payerEmail, accountName, bankName, displayNumbers, familyId, centerId, accountTypeId, accountTypeDescription, statusFlag, failedDescription, mailingAddress, mailingCity, mailingState, mailingZip, phone, userId, accountNumber, routingNumber, userHostAddress, displayFlag) {
      var url;
      url = rootUrl + 'api/Account/CreateAccount';
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
          'AccountId': accountId,
          'CreatedOn': createdOn,
          'VerificationYN': verificationYN,
          'RecurringAccountYN': recurringAccountYN,
          'GuardianId': guardianId,
          'PayerId': payerId,
          'PayerName': payerName,
          'PayerEmail': payerEmail,
          'AccountName': accountName,
          'BankName': bankName,
          'DisplayNumbers': displayNumbers,
          'FamilyId': familyId,
          'CenterId': centerId,
          'AccountTypeId': accountTypeId,
          'AccountTypeDescription': accountTypeDescription,
          'StatusFlag': statusFlag,
          'FailedDescription': failedDescription,
          'MailingAddress': mailingAddress,
          'MailingCity': mailingCity,
          'MailingState': mailingState,
          'MailingZip': mailingZip,
          'Phone': phone,
          'UserId': userId,
          'AccountNumber': accountNumber,
          'RoutingNumber': routingNumber,
          'UserHostAddress': userHostAddress,
          'DisplayFlag': displayFlag
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteAccount = function(familyId, centerId, accountId) {
      var url;
      url = rootUrl + 'api/Account/DeleteAccount?familyId=' + familyId + '&centerId=' + centerId + '&accountId=' + accountId;
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
    this.setActiveAccount = function(familyId, centerId, accountId) {
      var url;
      url = rootUrl + 'api/Account/SetActiveAccount?familyId=' + familyId + '&centerId=' + centerId + '&accountId=' + accountId;
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
    this.getPayers = function(customerId) {
      var url;
      url = rootUrl + 'api/Account/GetPayers?customerId=' + customerId;
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

//# sourceMappingURL=account.js.map
