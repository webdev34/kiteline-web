'use strict'
angular.module('kiteLineApp').service 'CreditCardService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @creditCardValidation = (obj) ->   
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
        'CustomerId': $rootScope.currentCenter.CustomerId
        'userId': $rootScope.currentUserEmail
        'LegalBusinessName': obj.PayerName
        'MailingAddress': obj.MailingAddress
        'MailingCity': obj.MailingCity
        'MailingState': obj.MailingState
        'MailingZip': obj.MailingZip
        'BusinessPhone': obj.BusinessPhone
        'BusinessEmail': obj.PayEmail
        'CardHolderName': obj.PayerName
        'CardNumber': obj.AccountNumber
        'ExpirationDate': obj.ExpirationDate
        'BillingZip': obj.MailingZip    

      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      toastr.error status, 'Error'
      return

  @getBankAccounts = (familyId, centerId) ->   
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

  @getCreditCardAccounts = (familyId, centerId) ->   
    url = rootUrl+'api/Account/GetCreditCardAccounts?familyId='+familyId+'&centerId='+centerId
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

  return