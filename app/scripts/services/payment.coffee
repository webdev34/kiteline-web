'use strict'
angular.module('kiteLineApp').service 'PaymentService', ($http, $q, $rootScope, toastr, $location) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getPastPayments = (customerId) ->   
    url = rootUrl+'api/Payment/GetPastPayments?customerId='+customerId
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

  @getPastPaymentsByDate = (customerId, startDate, endDate) ->   
    url = rootUrl+'api/Payment/GetPastPaymentsByDate?customerId='+customerId+'&startDate='+startDate+'&endDate='+endDate
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

  @getRecentPayments = (customerId) ->  
    url = rootUrl+'api/Payment/GetRecentPayments?customerId='+customerId
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

  @getChildrenTuiton = (familyId) ->  
    url = rootUrl+'api/Payment/GetChildrenTuition?familyId='+familyId
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

  @getTaxStatment = (familyId, customerId, year) ->  
    url = rootUrl+'api/Payment/GetTaxStatement?familyid='+familyId+'&customerid='+customerId+'&year='+year
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

  @getPartialPaymentsByInvoiceId = (customerId, invoiceId, centerId) ->  
    url = rootUrl+'api/Payment/GetPartialPaymentsByInvoiceId?customerId='+customerId+'&invoiceId='+invoiceId+'&centerId='+centerId
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

  @makePaymentWithAccountId = (accountId, customerId, amount, invoiceId) ->  
    url = rootUrl+'api/Payment/MakePayment?accountId='+accountId+'&customerId='+customerId+'&amount='+amount+'&invoiceid='+invoiceId
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

  @makePaymentWithCC = (familyId, centerId, invoiceId, customerId, amount, accountObj) ->  
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
        'familyId': familyId
        'centerId': centerId
        'invoiceId': invoiceId                        
        'customerId': customerId        
        'amount': amount
        'ccname': accountObj.PayerName
        'ccnum': accountObj.AccountNumber
        'cctype': $rootScope.newCCAccountTypeId
        'expiration': accountObj.ExpirationDate
        'cvv': accountObj.CVV
        'street': accountObj.BillingAddress
        'city': accountObj.BillingCity
        'state': accountObj.BillingState
        'zip': accountObj.BillingZip
        'trackData': null          
        'SessionID': null  
        'OriginationIP': document.getElementById('user-ip').value    

      url: url).success((data, status, headers, config) ->
      deferred.resolve data
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error status, 'Error'
      return

  @emailInvoice = (tranId, familyId, centerId) ->  
    url = rootUrl+'api/Payment/SendPaymentEmail?tranId='+tranId+'&familyId='+familyId+'&centerid='+centerId
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
      toastr.success 'E-mail has been sent'
      
      return
    ).error (data, status, headers, config) ->
      deferred.reject status
      
      toastr.error status, 'Error'
      return      

  return