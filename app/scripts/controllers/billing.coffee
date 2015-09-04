'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, PaymentService, CurbSideService, CreditCardService, AccountService, ngDialog, Pagination) ->
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  LogInService.isLoggedIn()
  $scope.currentTab = 'Overview'
  $rootScope.addBankAccount = false
  $rootScope.newBankAccount = {}
  $scope.taxStatements = [ [2015,2014],[2013,2012],[2011,2010]]
  $rootScope.changePageTitle()

  $rootScope.processInvoicePayment = (accountId) ->
    $rootScope.processingPayment = true
    if $rootScope.viewInvoiceArray is null
      invoiceId = $rootScope.viewInvoice.InvoiceId
    else
      invoiceId = $rootScope.viewInvoiceArray[0].InvoiceId
      thisYear = String($rootScope.expireDatesPayment.year)
      thisYear = thisYear[2]+thisYear[3]
      $rootScope.paymentCC.ExpirationDate = $rootScope.expireDatesPayment.month+'/'+thisYear
      if $rootScope.paymentCC.ExpirationDate.length == 4
        $rootScope.paymentCC.ExpirationDate = "0"+$rootScope.paymentCC.ExpirationDate
      
    $rootScope.processPayment(accountId, invoiceId)

  $scope.emailInvoiceToUser = (transaction) ->
    transaction.sendingEmail = true
    PaymentService.emailInvoice(transaction.PayId, $rootScope.familyId, $rootScope.centerId).then (response) ->
      transaction.sendingEmail = false

  $scope.getTaxStatement = (year) ->
    $rootScope.currentFamilyID = $rootScope.familyId
    $rootScope.selectedYear = year
    $rootScope.paymentMSG = null
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-statement.html'
      className: 'ngdialog-theme-default ngdialog-pdf'
  
  $scope.reportPayment = (payment) ->
    $rootScope.currentFamilyID = $rootScope.familyId
    $rootScope.currentTransactionID = payment.PayId
    $rootScope.currentTranType = payment.PaymentType
    $rootScope.paymentMSG = null
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-transaction.html'
      className: 'ngdialog-theme-default ngdialog-pdf'

  $scope.autocompleteHomeAddressBank = () ->
    if $rootScope.newBankAccount.autofillAddressBank is true
      $rootScope.newBankAccount.BillingAddress = $rootScope.headOfHouseHold.Street
      $rootScope.newBankAccount.BillingCity = $rootScope.headOfHouseHold.City
      $rootScope.newBankAccount.BillingState = $rootScope.headOfHouseHold.State
      $rootScope.newBankAccount.BillingZip = $rootScope.headOfHouseHold.Zip
      $rootScope.newBankAccount.BusinessPhone = $rootScope.headOfHouseHold.HomePhone
    else
      $rootScope.newBankAccount.BillingAddress = null
      $rootScope.newBankAccount.BillingCity = null
      $rootScope.newBankAccount.BillingState = null
      $rootScope.newBankAccount.BillingZip = null
      $rootScope.newBankAccount.BusinessPhone = null

  $scope.autocompleteHomeAddressCC = () ->
    if $rootScope.newCC.autofillAddressCC is true
      $rootScope.newCC.BillingAddress = $rootScope.headOfHouseHold.Street
      $rootScope.newCC.BillingCity = $rootScope.headOfHouseHold.City
      $rootScope.newCC.BillingState = $rootScope.headOfHouseHold.State
      $rootScope.newCC.BillingZip = $rootScope.headOfHouseHold.Zip
      $rootScope.newCC.BusinessPhone = $rootScope.headOfHouseHold.HomePhone
    else
      $rootScope.newCC.BillingAddress = null
      $rootScope.newCC.BillingCity = null
      $rootScope.newCC.BillingState = null
      $rootScope.newCC.BillingZip = null
      $rootScope.newCC.BusinessPhone = null   

  $rootScope.nextAndPreviousInvoices = (currentInvoice) ->
    angular.forEach $rootScope.arrayOfinvoices, (value, key) ->
      if value == currentInvoice.InvoiceId
        $rootScope.nextInvoice = $rootScope.arrayOfinvoices[key+1] 
        $rootScope.previousInvoice = $rootScope.arrayOfinvoices[key-1]

  $rootScope.payInvoice = (invoiceId, fromModal, trueAmount) ->
    $rootScope.resetAccountForm('CC Payment')
    $rootScope.invoicesArrayed()
    $rootScope.paymentMSG = null
    $rootScope.viewInvoiceBreakDown = null
    $rootScope.viewInvoiceArray = null
    $rootScope.paymentAmount = 0
    $rootScope.viewInvoice = null
    $rootScope.viewInvoice = $filter('filter')($rootScope.outstandingInvoices, (d) -> d.InvoiceId == invoiceId)[0]
    $rootScope.paymentAmount = $filter('currency') $rootScope.viewInvoice.DueAmount, ''
    $rootScope.nextAndPreviousInvoices($rootScope.viewInvoice)
    if $rootScope.creditCardAccounts.length == 0
      $rootScope.addCreditCardFromModal = true
   
    if !fromModal
      ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-invoice.html'

    #Line Item Check
    $scope.hasLineItems = $filter('filter')($rootScope.invoicesArray, (d) -> d.InvoiceId == invoiceId)[0]

    if typeof $scope.hasLineItems == 'undefined'
      angular.forEach $rootScope.invoicesArray, (value, key) ->
        if value instanceof Array
          if value[0].InvoiceId == invoiceId
            $scope.currentInvoice = $rootScope.invoicesArray[key][0]
            $rootScope.viewInvoiceArray = $rootScope.invoicesArray[key]
            $scope.goToInvoiceFromArrayItem($rootScope.invoicesArray[key][0])
            
      $rootScope.nextAndPreviousInvoices($scope.currentInvoice)
      $rootScope.currentPaymentModal = 'Multiple Line Item Invoice'
      $rootScope.showMulti = true
    else
      $rootScope.currentPaymentModal = 'Single Invoice'
      $rootScope.nextAndPreviousInvoices($rootScope.viewInvoice)
      $rootScope.showMulti = false

  $rootScope.reportInvoice = (invoice) ->
    $rootScope.paymentMSG = null
    $rootScope.currentInvoiceID = invoice.InvoiceId
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-invoice.html'
      className: 'ngdialog-theme-default ngdialog-pdf'

  $scope.verifyBanking = (type) ->
    if type is 'Routing Number' 
      if $rootScope.newBankAccount.RoutingNumber == $rootScope.newBankAccount.VerifyRoutingNumber and $rootScope.newBankAccount.VerifyRoutingNumber.length == 9
        $scope.matchingRoutingNum = true
      else
        $scope.matchingRoutingNum = false
    else
      if $rootScope.newBankAccount.AccountNumber == $rootScope.newBankAccount.VerifyBankAcctNumber and $rootScope.newBankAccount.VerifyBankAcctNumber.length > 5
        $scope.matchingBankAccount = true
      else
        $scope.matchingBankAccount = false

  $scope.addAccount = (type) ->
    if type == 'CC'
      $scope.autocompleteHomeAddressCC()
      $rootScope.newCC.autofillAddressCC = false
      $rootScope.addCreditCard = true
    else
      $scope.autocompleteHomeAddressBank()
      $rootScope.newBankAccount.autofillAddressBank = false 
      $rootScope.addBankAccount = true

  $scope.deleteBankAccount = (accountId) ->
    if confirm('Are you sure you want to delete this?')
      AccountService.deleteAccount($rootScope.familyId, $rootScope.centerId, accountId).then (response) ->
        $rootScope.getBankAccounts()
    else
      false
    
  $scope.deleteCreditCardAccount = (accountId) ->
    if confirm('Are you sure you want to delete this?')
      CreditCardService.deleteCreditCard(accountId).then (response) ->
      setTimeout (->
        $rootScope.getCCAccounts()
      ), 500
    else
      false    

  $scope.goToTab = (tab) ->
    $scope.setPagination()
    $scope.currentTab = tab
    $rootScope.addCreditCard = false
    $rootScope.addBankAccount = false
    $rootScope.resetAccountForm('CC')
    $rootScope.resetAccountForm('Bank')
    document.body.scrollTop = document.documentElement.scrollTop = 0

  $rootScope.currentCardType = (type) ->
    if type == 'Visa'
      $rootScope.newCCAccountTypeId = 3
    else if type == 'Mastercard'
      $rootScope.newCCAccountTypeId = 4
    else if type == 'Discover'
      $rootScope.newCCAccountTypeId = 5
    else if type == 'American Express'
      $rootScope.newCCAccountTypeId = 6

  $scope.goToInvoiceFromArrayItem = (obj) ->
    $rootScope.viewInvoiceBreakDown = obj
    $rootScope.lineItemId = obj.LineItemId

  $rootScope.resetActiveAccount = (account, payWithNewCC) ->
    if payWithNewCC == true
      $rootScope.activePaymentAccount = null
      angular.forEach $rootScope.creditCardAccounts, (value, key) ->
        value.isActive = false
    else
      angular.forEach $rootScope.creditCardAccounts, (value, key) ->
        if account.AccountId is value.AccountId
          account.isActive = !account.isActive;
          if account.isActive == false
            $rootScope.activePaymentAccount = null
          else
            $rootScope.activePaymentAccount = account
        else
          value.isActive = false

  if StorageService.getItem('currentCenter')
    $rootScope.getUserData().then (response) ->
      $rootScope.getMessages().then (response) ->

      CurbSideService.getAllChildren($rootScope.centerId, $rootScope.familyId).then (response) ->
        $scope.userChildren = response.data

      PaymentService.getChildrenTuiton($rootScope.familyId).then (response) ->
        $scope.userChildrenTuition = response.data
      
      $rootScope.getTransactionsByDate(null)
      $rootScope.getTransactionsByDate('Historical')
      $rootScope.getPaymentAccounts()
      $rootScope.getGuardianData()
      $rootScope.getInvoiceData().then (response) ->
        $rootScope.stopSpin()
    
    if $route.current.$$route.originalPath == '/billing/invoices'
      $scope.goToTab('Invoices')
    else if $route.current.$$route.originalPath == '/billing/payment-accounts'
      $scope.goToTab('Invoices')