
angular.module('kiteLineApp').service 'CreditCardService', ($http, $q, $rootScope, toastr, $location) ->
  deferred = undefined
  rootUrl = undefined
  self = undefined
  rootUrl = $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @creditCardValidation = (obj) ->
    url = undefined
    url = rootUrl+'api/CreditCard/CCValidation'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'invoiceId': obj
        'customerId': obj
        'amount': obj
        'ccname': obj
        'ccnum': obj
        'cctype': obj
        'expiration': obj
        'cvv': obj
        'street': obj
        'city': obj
        'state': obj
        'zip': obj
        'trackData': obj
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      toastr.error status, 'Error'
      return

  @getCreditCardType = (obj) ->
    url = undefined
    url = rootUrl+'api/CreditCard/GetCCType'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'invoiceId': obj
        'customerId': obj
        'amount': obj
        'ccname': obj
        'ccnum': obj
        'cctype': obj
        'expiration': obj
        'cvv': obj
        'street': obj
        'city': obj
        'state': obj
        'zip': obj
        'trackData': obj
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      toastr.error status, 'Error'
      return

  @processCreditCard = (obj) ->
    url = undefined
    url = rootUrl+'api/CreditCard/ProcessCC'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'familyId': obj
        'centerId': obj
        'invoiceId': obj
        'customerId': obj
        'amount': obj
        'ccname': obj
        'ccnum': obj
        'cctype': obj
        'expiration': obj
        'cvv': obj
        'street': obj
        'city': obj
        'state': obj
        'zip': obj
        'trackData': obj
        'SessionID': obj
        'OriginationIP': obj
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      toastr.error status, 'Error'
      return

  @addCreditCard = (obj) ->
    url = undefined
    url = rootUrl+'api/CreditCard/AddCCAccount'
    $http(
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        'X-SkyChildCareToken': $rootScope.currentUserToken
        'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId
        'X-SkyChildCareUserId': $rootScope.currentUserEmail
      data:
        'AppId': 3
        'SubscriberId': $rootScope.subscriberId
        'RecurringAccount': obj.RecurringAccount
        'CustomerId': $rootScope.currentCenter.CustomerId
        'userId': $rootScope.currentUserEmail
        'LegalBusinessName': obj.PayerName
        'BillingAddress': obj.BillingAddress
        'BillingCity': obj.BillingCity
        'BillingState': obj.BillingState
        'BillingZip': obj.BillingZip
        'BusinessPhone': obj.BusinessPhone
        'BusinessEmail': obj.PayEmail
        'CardHolderName': obj.PayerName
        'AccountName': ''
        'CardNumber': obj.AccountNumber
        'ExpirationDate': obj.ExpirationDate
        'BillingZip': obj.BillingZip
      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      toastr.error status, 'Error'
      return

  @getBankAccounts = (familyId, centerId) ->
    url = undefined
    url = rootUrl+'api/Account/GetBankAccounts?familyId='+familyId+'&centerId='+centerId
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

  @getCreditCardAccounts = (subscriberId, customerId) ->
    url = undefined
    url = rootUrl+'api/CreditCard/GetCCAccount/'+subscriberId+'/'+customerId
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

  @getCreditCardInfo = (subscriberId, customerId) ->
    url = undefined
    url = rootUrl+'api/CreditCard/GetCCAccount/'+subscriberId+'/'+customerId
    $http(
      method: 'GET'
      headers:
        'Access-Control-Allow-Origin': '*'
        'Access-Control-Allow-Methods': 'OPTIONS,GET,POST,PUT,DELETE'
        'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With'
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

  @deleteCreditCard = (accountId) ->
    url = undefined
    url = rootUrl+'api/CreditCard/DeleteCCAccount/'+accountId
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

  @setDefaultCreditCard = (subscriberId, customerId, accountId) ->
    url = undefined
    url = rootUrl+'api/CreditCard/SetDefaultCCAccount?SubscriberId='+subscriberId+'&CustomerId='+customerId+'&accountId='+accountId
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

  @getDefaultCreditCard = (subscriberId, customerId) ->
    url = undefined
    url = rootUrl+'api/CreditCard/GetDefaultCCAccount?SubscriberId='+subscriberId+'&CustomerId='+customerId
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