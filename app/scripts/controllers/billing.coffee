'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService, CreditCardService, AccountService, GuardianService, ngDialog, Pagination) ->
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
  d = new Date
  $scope.billDates = {}
  $scope.billDates.transactionStartDate = new Date((new Date).setDate((new Date).getDate() - 30))
  $scope.billDates.transactionStartDate = $filter('date')($scope.billDates.transactionStartDate, 'M/d/yyyy')
  $scope.billDates.historicalStartDate = $scope.billDates.transactionStartDate
  $scope.billDates.transactionEndDate = [
    d.getMonth() + 1
    d.getDate()
    d.getFullYear()
  ].join('/')
  $scope.billDates.historicalEndDate = $scope.billDates.transactionEndDate
  $scope.billDates.querying = false
  $scope.billDates.queryingHistorical = false
  $scope.autofillAddressBank = false  
  $scope.autofillAddressCC = false

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

  $scope.autocompleteHomeAddressBank = () ->
    $scope.autofillAddressBank = !$scope.autofillAddressBank

    if $scope.autofillAddressBank is true
      $scope.newBankAccount.MailingAddress = 'test'
      $scope.newBankAccount.MailingCity = 'City'
      $scope.newBankAccount.MailingState = 'FL'
      $scope.newBankAccount.MailingZip = 11434
      $scope.newBankAccount.BusinessPhone = '7185277939'
    else
      $scope.newBankAccount.MailingAddress = null
      $scope.newBankAccount.MailingCity = null
      $scope.newBankAccount.MailingState = null
      $scope.newBankAccount.MailingZip = null
      $scope.newBankAccount.BusinessPhone = null

  $scope.autocompleteHomeAddressCC = () ->
    $scope.autofillAddressCC = !$scope.autofillAddressCC

    if $scope.autofillAddressCC is true
      $scope.newCC.MailingAddress = 'test'
      $scope.newCC.MailingCity = 'City'
      $scope.newCC.MailingState = 'FL'
      $scope.newCC.MailingZip = 11434
      $scope.newCC.BusinessPhone = '7185277939'
    else
      $scope.newCC.MailingAddress = null
      $scope.newCC.MailingCity = null
      $scope.newCC.MailingState = null
      $scope.newCC.MailingZip = null
      $scope.newCC.BusinessPhone = null

  $scope.setDefaultAccount = (accountId) ->
    console.log accountId
    AccountService.setActiveAccount($scope.familyId, $scope.centerId, accountId).then (response) ->
      console.log response

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
      thisYear = String($scope.expireDates.year)
      thisYear = thisYear[2]+thisYear[3]
      $scope.newCC.ExpirationDate = $scope.expireDates.month+'/'+thisYear
      CreditCardService.addCreditCard($scope.newCC).then (response) ->
    else
      AccountService.createAccount($scope.newBankAccount).then (response) ->
        $scope.getPaymentAccounts($scope.familyId, $scope.centerId).then (response) ->
          $scope.addBankAccount = false

  $scope.deleteBankAccount = (accountId) ->
    AccountService.deleteAccount($scope.familyId, $scope.centerId, accountId).then (response) ->
      $scope.getPaymentAccounts($scope.familyId, $scope.centerId)

  $scope.deleteCreditCardAccount = (accountId) ->
    CreditCardService.deleteCreditCard(accountId).then (response) ->
      $scope.getPaymentAccounts($scope.familyId, $scope.centerId)

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
      $scope.pastTransactionsPagination = Pagination.getNew(10)
      $scope.pastTransactionsPagination.numPages = Math.ceil($scope.pastTransactions.length/$scope.pastTransactionsPagination.perPage)

  $scope.getTransactionsByDate = (type) ->
    if type == 'Historical'
      $scope.noResultsInvoices = false
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data
        $scope.historicalTransactionsPagination = Pagination.getNew(10)
        $scope.historicalTransactionsPagination.numPages = Math.ceil($scope.historicalTransactions.length/$scope.historicalTransactionsPagination.perPage)
        $scope.billDates.queryingHistorical = false
        if $scope.historicalTransactions.length == 0
          $scope.noResultsInvoices = true
    else
      $scope.noResults = false
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.transactionStartDate, $scope.billDates.transactionEndDate).then (response) ->
        $scope.pastTransactions  = response.data
        $scope.pastTransactionsPagination = Pagination.getNew(10)
        $scope.pastTransactionsPagination.numPages = Math.ceil($scope.pastTransactions.length/$scope.pastTransactionsPagination.perPage)
        $scope.billDates.querying = false

        if $scope.pastTransactions.length == 0
          $scope.noResults = true

  $scope.goToInvoiceFromArrayItem = (obj) ->
    $rootScope.viewInvoice = obj
    $rootScope.lineItemId = obj.LineItemId

  $rootScope.resetActiveAccount = (type) ->
    if type == 'bank'
      angular.forEach $rootScope.bankAccounts, (value, key) ->
        value.isActive = false
    else
      angular.forEach $rootScope.creditCardAccounts, (value, key) ->
        value.isActive = false

  $scope.getPaymentAccounts = (familyId, centerId) ->
    CreditCardService.getBankAccounts(familyId, centerId).then (response) ->
      $rootScope.bankAccounts = response.data

    CreditCardService.getCreditCardAccounts($rootScope.subscriberId, centerId).then (response) ->
      $rootScope.creditCardAccounts = response.data

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    $scope.centerId = $rootScope.currentCenter.CenterId
    $scope.familyId = $rootScope.currentCenter.FamilyId
    $scope.customerId = $rootScope.currentCenter.CustomerId
    $scope.outstandingBalance = $rootScope.currentCenter.OutstandingBalance
    
    CenterInfoService.getCenterDetails($scope.centerId).then (response) ->
      $scope.currentCenterDetails = response.data
      $scope.childrenClasses = []

    GuardianService.getAllGuardians($scope.familyId).then (response) ->
      $rootScope.guardians = response.data

    CurbSideService.getAllChildren($scope.centerId, $scope.familyId).then (response) ->
      $scope.userChildren = response.data

      angular.forEach $scope.userChildren, (value, key) ->
        ChildService.getChildClass(value.ChildId).then (response) ->
          $scope.childrenClasses.push response.data

    AnnouncementsService.getAnnouncements($scope.customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data
      
    $scope.getTransactionsByDate(null)
    $scope.getTransactionsByDate('Historical')

    InvoiceService.getOutstandingInvoices($scope.customerId).then (response) ->
      $scope.outstandingInvoices = response.data
      $scope.outstandingInvoicesPagination = Pagination.getNew(10)
      $scope.outstandingInvoicesPagination.numPages = Math.ceil($scope.outstandingInvoices.length/$scope.outstandingInvoicesPagination.perPage)

      $rootScope.subscriberId = response.data[0].SubscriberId

      angular.forEach $scope.outstandingInvoices, (value, key) ->
        InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then (response) ->
          
          if response.data.length == 1
            $scope.invoicesArray.push response.data[0]
            $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+response.data[0].Amount

          else
            arrayHolder = []
            angular.forEach response.data, (value, key) ->
              arrayHolder.push value
              $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+value.Amount
            
            $scope.invoicesArray.push arrayHolder
      
      $rootScope.stopSpin()

      $scope.getPaymentAccounts($scope.familyId, $scope.centerId)
      
      if $route.current.$$route.originalPath == '/billing/invoices'
        $scope.goToTab('Invoices')

      
