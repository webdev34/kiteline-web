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
        'AppId': obj
        'SubscriberId': obj        
        'CustomerId': obj
        'userId': obj
        'LegalBusinessName': obj
        'MailingAddress': obj
        'MailingCity': obj
        'MailingState': obj  
        'MailingZip': obj
        'BusinessPhone': obj
        'BusinessEmail': obj
        'CardHolderName': obj
        'CardNumber': obj
        'ExpirationDate': obj  
        'BillingZip': obj    

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