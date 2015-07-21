'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService, CreditCardService, ngDialog) ->
  $rootScope.pageTitle = 'Billing'
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  $scope.noResults = false
  $scope.noResultsInvoices = false
  $scope.currentTab = 'Overview'
  $scope.invoicesArray = []
  $scope.invoiceGrandTotal = 0
  $scope.bank_auto_pay = true
  $scope.credit_card_auto_pay = false
  $scope.addBankAccount = false
  $scope.addCreditCard = false
  $scope.matchingBankAccount = false
  $scope.matchingRoutingNum = false
  $scope.newBankAccount = {}
  $scope.newCC = {}
  $scope.expireDates = {}
  $scope.taxStatements = [ [2015,2014],[2013,2012],[2011,2010]]
  $scope.billDates = {}
  $scope.billDates.transactionStartDate = '1/01/2014'
  $scope.billDates.transactionEndDate = '7/01/2015'
  $scope.billDates.historicalStartDate = '2/01/2015'
  $scope.billDates.historicalEndDate = '7/30/2015'
  
  LogInService.isLoggedIn()

  $scope.bankAccountTypes = [
    {
      id: '1'
      name: 'Checking'
    }
    {
      id: '2'
      name: 'Savings'
    }
  ]

  $scope.creditCardAccountTypes = [
    {
      id: '3'
      name: 'CC - Visa'
    }
    {
      id: '4'
      name: 'CC - Mastercard'
    }
    {
      id: '5'
      name: 'CC - Discover'
    }
    {
      id: '6'
      name: 'CC - AMEX'
    }
  ]

  $scope.payOutstandingBalance = ->
    ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-outstanding-balance.html'

  $scope.payInvoice = (invoice) ->
    $rootScope.viewInvoice = $filter('filter')($scope.invoicesArray, (d) -> d.InvoiceId == invoice.InvoiceId)[0]
    ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-invoice.html'
    if typeof $scope.viewInvoice == 'undefined'
      angular.forEach $scope.invoicesArray, (value, key) ->
        if value instanceof Array
          if value[0].InvoiceId == invoice.InvoiceId
            $scope.viewInvoiceArray = $scope.invoicesArray[key]
            $scope.goToInvoiceFromArrayItem($scope.invoicesArray[key][0])

  $scope.payOutstandingInvoice = (invoice) ->
    ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-outstanding-invoice.html'

  $scope.verifyBanking = (type) ->
    if type is 'Routing Number' 
      if $scope.newBankAccount.RoutingNumber == $scope.newBankAccount.VerifyRoutingNumber and $scope.newBankAccount.VerifyRoutingNumber.length == 9
        $scope.matchingRoutingNum = true
      else
        $scope.matchingRoutingNum = false
    else
      if $scope.newBankAccount.AccountNumber == $scope.newBankAccount.VerifyBankAcctNumber and $scope.newBankAccount.VerifyBankAcctNumber.length > 5
        $scope.matchingBankAccount = true
      else
        $scope.matchingBankAccount = false

  $scope.addAccount = (type) ->
    if type == 'CC'
      $scope.addCreditCard = true
    else
      $scope.addBankAccount = true

  $scope.resetAccountForm = (type, form) ->
    if type == 'CC'
      $scope.addCreditCard = false
      $scope.newCC = {}
      $scope.newCC.PayerEmail = ''
      $scope.expireDates = {}
      $scope.expireDates.month = ''
      form.$setPristine();
    else
      $scope.addBankAccount = false
      $scope.newBankAccount = {}
      $scope.newBankAccount.PayerEmail = ''
      form.$setPristine();

  $scope.submitNewAccount = (type) ->
    if type == 'CC'
      $scope.newCC.ExpirationDate = $scope.expireDates.month+'/'+$scope.expireDates.year
      CreditCardService.createAccount($scope.newCC).then (response) ->
    else
      CreditCardService.createAccount($scope.newBankAccount).then (response) ->

  $scope.goToTab = (tab) ->
    $scope.currentTab = tab

  $scope.currentCardType = (type) ->
    if type == 'Visa'
      $scope.newCC.AccountTypeId = 3
    else if type == 'Mastercard'
      $scope.newCC.AccountTypeId = 4
    else if type == 'Discover'
      $scope.newCC.AccountTypeId = 5
    else if type == 'American Express'
      $scope.newCC.AccountTypeId = 6

  $scope.getPastPayments = () ->
    PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId).then (response) ->
      $scope.pastTransactions  = response

  $scope.getTransactionsByDate = (type) ->
    if type == 'Historical'
      $scope.noResultsInvoices = false
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data

        if $scope.historicalTransactions.length == 0
          $scope.noResultsInvoices = true
    else
      $scope.noResults = false
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.transactionStartDate, $scope.billDates.transactionEndDate).then (response) ->
        $scope.pastTransactions  = response.data

        if $scope.pastTransactions.length == 0
          $scope.noResults = true

  $scope.goToInvoiceFromArrayItem = (obj) ->
    $rootScope.viewInvoice = obj
    $rootScope.lineItemId = obj.LineItemId

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    centerId = $rootScope.currentCenter.CenterId
    familyId = $rootScope.currentCenter.FamilyId
    customerId = $rootScope.currentCenter.CustomerId
    $scope.outstandingBalance = $rootScope.currentCenter.OutstandingBalance
    
    CenterInfoService.getCenterDetails(centerId).then (response) ->
      $scope.currentCenterDetails = response.data
      $scope.childrenClasses = []

    CurbSideService.getAllChildren(centerId, familyId).then (response) ->
      $scope.userChildren = response.data

      angular.forEach $scope.userChildren, (value, key) ->
        ChildService.getChildClass(value.ChildId).then (response) ->
          $scope.childrenClasses.push response.data

    AnnouncementsService.getAnnouncements(customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data
      
    $scope.getTransactionsByDate(null)
    $scope.getTransactionsByDate('Historical')

    InvoiceService.getOutstandingInvoices(customerId).then (response) ->
      $scope.outstandingInvoices = response.data
      $scope.subscriberId = response.data[0].SubscriberId

      angular.forEach $scope.outstandingInvoices, (value, key) ->
        InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then (response) ->
          
          if response.data.length == 1
            $scope.invoicesArray.push response.data[0]
            $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+response.data[0].Amount
            if $routeParams.invoiceId
              $scope.goToInvoice(parseInt($routeParams.invoiceId))

          else
            arrayHolder = []
            angular.forEach response.data, (value, key) ->
              arrayHolder.push value
              $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+value.Amount
            
            $scope.invoicesArray.push arrayHolder
            
            if $routeParams.invoiceId
              $scope.goToInvoice(parseInt($routeParams.invoiceId))

    CreditCardService.getBankAccounts(familyId, centerId).then (response) ->
      $scope.bankAccounts = response.data

    CreditCardService.getCreditCardAccounts(familyId, centerId).then (response) ->
      $scope.creditCardAccounts = response.data

      $rootScope.stopSpin()
