'use strict'
angular.module('kiteLineApp').service 'AccountService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getAccounts = (familyId, centerId) ->   
    url = rootUrl+'api/Account/GetAccounts?familyId='+familyId+'&centerId='+centerId
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

  @getAccount = (familyId, centerId, accountId) ->   
    url = rootUrl+'api/Account/GetAccount?familyId='+familyId+'&centerId='+centerId+'&accountId='+accountId
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

  @createAccount = (accountId, createdOn, verificationYN, recurringAccountYN, guardianId, payerId, payerName, payerEmail, accountName, bankName, displayNumbers, familyId, centerId, accountTypeId, accountTypeDescription, statusFlag, failedDescription, mailingAddress, mailingCity, mailingState, mailingZip, phone, userId, accountNumber, routingNumber, userHostAddress, displayFlag) ->
    url = rootUrl + 'api/Account/CreateAccount'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'AccountId': accountId
        'CreatedOn': createdOn
        'VerificationYN': verificationYN
        'RecurringAccountYN': recurringAccountYN
        'GuardianId': guardianId
        'PayerId': payerId
        'PayerName': payerName
        'PayerEmail': payerEmail
        'AccountName': accountName
        'BankName': bankName
        'DisplayNumbers': displayNumbers
        'FamilyId': familyId
        'CenterId': centerId
        'AccountTypeId': accountTypeId
        'AccountTypeDescription': accountTypeDescription
        'StatusFlag': statusFlag
        'FailedDescription': failedDescription
        'MailingAddress': mailingAddress
        'MailingCity': mailingCity
        'MailingState': mailingState
        'MailingZip': mailingZip
        'Phone': phone
        'UserId': userId
        'AccountNumber': accountNumber
        'RoutingNumber': routingNumber
        'UserHostAddress': userHostAddress
        'DisplayFlag': displayFlag
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error status, 'Error'
      return

    

  @deleteAccount = (familyId, centerId, accountId) ->  
    url = rootUrl+'api/Account/DeleteAccount?familyId='+familyId+'&centerId='+centerId+'&accountId='+accountId
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
      
      toastr.error status, 'Error'
      return

  @setActiveAccount = (familyId, centerId, accountId) ->  
    url = rootUrl+'api/Account/SetActiveAccount?familyId='+familyId+'&centerId='+centerId+'&accountId='+accountId
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
      
      toastr.error status, 'Error'
      return

  @getPayers = (customerId) ->  
    url = rootUrl+'api/Account/GetPayers?customerId='+customerId
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

  return