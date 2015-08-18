'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, $document, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService, CreditCardService, AccountService, GuardianService, ngDialog, Pagination) ->
  $rootScope.changePageTitle()
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  LogInService.isLoggedIn()
  $scope.noResults = false
  $scope.noResultsInvoices = false
  $scope.currentTab = 'Overview'
  $rootScope.invoicesArray = []
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
  $scope.defaultCC = null
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

  $rootScope.processPayment = (type) ->
    console.log $rootScope.activePaymentAccount
    if type == 'outstanding balance'

    else

  $rootScope.processInvoicePayment = () ->
    console.log $rootScope.activePaymentAccount
    if $rootScope.viewInvoiceArray is null
      console.log $rootScope.viewInvoice
    else
      console.log $rootScope.viewInvoiceArray

  $scope.getTaxStatement = (year) ->
    $rootScope.currentFamilyID = $scope.familyId
    $rootScope.selectedYear = year
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-statement.html'
      className: 'ngdialog-theme-default ngdialog-pdf'
  
  $scope.reportPayment = (payment) ->
    $rootScope.currentFamilyID = $scope.familyId
    $rootScope.currentTransactionID = payment.PayId
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-transaction.html'
      className: 'ngdialog-theme-default ngdialog-pdf'

  $scope.autocompleteHomeAddressBank = () ->
    if $scope.newBankAccount.autofillAddressBank is true
      $scope.newBankAccount.BillingAddress = $rootScope.headOfHouseHold.Street
      $scope.newBankAccount.BillingCity = $rootScope.headOfHouseHold.City
      $scope.newBankAccount.BillingState = $rootScope.headOfHouseHold.State
      $scope.newBankAccount.BillingZip = $rootScope.headOfHouseHold.Zip
      $scope.newBankAccount.BusinessPhone = $rootScope.headOfHouseHold.HomePhone
    else
      $scope.newBankAccount.BillingAddress = null
      $scope.newBankAccount.BillingCity = null
      $scope.newBankAccount.BillingState = null
      $scope.newBankAccount.BillingZip = null
      $scope.newBankAccount.BusinessPhone = null

  $scope.autocompleteHomeAddressCC = () ->
    if $scope.newCC.autofillAddressCC is true
      $scope.newCC.BillingAddress = $rootScope.headOfHouseHold.Street
      $scope.newCC.BillingCity = $rootScope.headOfHouseHold.City
      $scope.newCC.BillingState = $rootScope.headOfHouseHold.State
      $scope.newCC.BillingZip = $rootScope.headOfHouseHold.Zip
      $scope.newCC.BusinessPhone = $rootScope.headOfHouseHold.HomePhone
    else
      $scope.newCC.BillingAddress = null
      $scope.newCC.BillingCity = null
      $scope.newCC.BillingState = null
      $scope.newCC.BillingZip = null
      $scope.newCC.BusinessPhone = null

  $scope.setDefaultAccount = () ->
    $scope.defaultAccount = null
    angular.forEach $rootScope.bankAccounts, (value, key) ->
      if value.RecurringAccount == true
        $scope.defaultAccount = value

    angular.forEach $rootScope.creditCardAccounts, (value, key) ->
      if value.RecurringAccount == true
        $scope.defaultAccount = value

  $scope.deleteDefaultAccount = () ->
    AccountService.deleteActiveAccount($rootScope.subscriberId, $scope.customerId).then (response) ->
      $scope.defaultAccount = null

  $scope.setDefaultCCAccount = (account) ->
    if account.RecurringAccount == false
      $scope.deleteDefaultAccount()
    else
      CreditCardService.setDefaultCreditCard($rootScope.subscriberId, $scope.customerId, account.AccountId).then (response) ->
        $scope.getPaymentAccounts($scope.familyId, $scope.centerId)

  $scope.setDefaultBankAccount = (account) ->
    if account.RecurringAccount == false
      $scope.deleteDefaultAccount()
    else
      AccountService.setActiveAccount($scope.familyId, $scope.centerId, account.AccountId).then (response) ->
        $scope.getPaymentAccounts($scope.familyId, $scope.centerId)

  $scope.payOutstandingBalance = ->
    ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-outstanding-balance.html'

  $rootScope.nextAndPreviousInvoices = (currentInvoice) ->
    angular.forEach $rootScope.arrayOfinvoices, (value, key) ->
      if value == currentInvoice.InvoiceId
        $rootScope.nextInvoice = $rootScope.arrayOfinvoices[key+1] 
        $rootScope.previousInvoice = $rootScope.arrayOfinvoices[key-1]

  $rootScope.invoicesArrayed = () ->
    $rootScope.arrayOfinvoicesHolder = []
    $rootScope.arrayOfinvoices = []

    angular.forEach $rootScope.invoicesArray, (value, key) ->
      if value instanceof Array
        $rootScope.arrayOfinvoicesHolder.push value[0]
      else
        $rootScope.arrayOfinvoicesHolder.push value

    $rootScope.arrayOfinvoicesHolder = $filter('orderBy')($rootScope.arrayOfinvoicesHolder, 'CreatedOn', true)

    angular.forEach $rootScope.arrayOfinvoicesHolder, (value, key) ->
      $rootScope.arrayOfinvoices.push value.InvoiceId

  $rootScope.payInvoice = (invoiceId, fromModal) ->
    $rootScope.invoicesArrayed()
    $rootScope.viewInvoiceArray = null
    $rootScope.viewInvoiceArrayTotal = 0
    $rootScope.viewInvoice = null
    $rootScope.viewInvoice = $filter('filter')($rootScope.invoicesArray, (d) -> d.InvoiceId == invoiceId)[0]
    
    if !fromModal
      ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-invoice.html'


    if typeof $scope.viewInvoice == 'undefined'
      angular.forEach $rootScope.invoicesArray, (value, key) ->
        if value instanceof Array
          if value[0].InvoiceId == invoiceId
            $scope.currentInvoice = $rootScope.invoicesArray[key][0]
            $rootScope.viewInvoiceArray = $rootScope.invoicesArray[key]
            $scope.goToInvoiceFromArrayItem($rootScope.invoicesArray[key][0])
            
            angular.forEach $rootScope.viewInvoiceArray , (value, key) ->
              $rootScope.viewInvoiceArrayTotal += value.Amount
      $rootScope.nextAndPreviousInvoices($scope.currentInvoice)
    else
      $rootScope.nextAndPreviousInvoices($rootScope.viewInvoice)

  $rootScope.reportInvoice = (invoice) ->
    $rootScope.currentInvoiceID = invoice.InvoiceId
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-invoice.html'
      className: 'ngdialog-theme-default ngdialog-pdf'

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
      $scope.newCC.autofillAddressCC = false
      $scope.addCreditCard = true
    else
      $scope.newBankAccount.autofillAddressBank = false 
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

  $scope.submitNewAccount = (type, form) ->
    if type == 'CC'
      thisYear = String($scope.expireDates.year)
      thisYear = thisYear[2]+thisYear[3]
      $scope.newCC.ExpirationDate = $scope.expireDates.month+'/'+thisYear
      console.log 'submit'
      console.log $scope.newCC
      CreditCardService.addCreditCard($scope.newCC).then (response) ->
        $scope.getPaymentAccounts($scope.familyId, $scope.centerId)
        $scope.resetAccountForm('CC', form)
    else
      console.log $scope.newBankAccount
      AccountService.createAccount($scope.newBankAccount).then (response) ->
        if response.statusText is 'OK'
          $scope.addBankAccount = false
          $scope.getPaymentAccounts($scope.familyId, $scope.centerId)
          $scope.resetAccountForm('Bank', form)

  $scope.deleteBankAccount = (accountId) ->
    if confirm('Are you sure you want to delete this?')
      AccountService.deleteAccount($scope.familyId, $scope.centerId, accountId).then (response) ->
        $scope.getBankAccounts($scope.familyId, $scope.centerId)
    else
      false
    
  $scope.deleteCreditCardAccount = (accountId) ->
    if confirm('Are you sure you want to delete this?')
      CreditCardService.deleteCreditCard(accountId).then (response) ->
      setTimeout (->
        $scope.getCCAccounts($scope.familyId, $scope.centerId)
      ), 500
    else
      false    

  $scope.goToTab = (tab) ->
    $scope.setPagination()
    $scope.currentTab = tab
    top = 0
    duration = 2000
    $document.scrollTop(top, duration).then ->

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
      $scope.setPagination()
  
  $scope.getTransactionsByDate = (type) ->
    if type == 'Historical'
      $scope.noResultsInvoices = false
      InvoiceService.getPaidInvoicesByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data
        $scope.historicalTransactionsTotal = 0
        $scope.billDates.queryingHistorical = false
    
        angular.forEach $scope.historicalTransactions, (value, key) ->
          $scope.historicalTransactionsTotal += value.Amount

        if $scope.historicalTransactions.length == 0
          $scope.noResultsInvoices = true
        else
          $scope.setPagination()

    else
      $scope.noResults = false
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.transactionStartDate, $scope.billDates.transactionEndDate).then (response) ->
        $scope.pastTransactions  = response.data
        $scope.billDates.querying = false

        if $scope.pastTransactions.length == 0
          $scope.noResults = true
        else
          $scope.setPagination()

  $scope.goToInvoiceFromArrayItem = (obj) ->
    $rootScope.viewInvoice = obj
    $rootScope.lineItemId = obj.LineItemId

  $rootScope.resetActiveAccount = (type, account) ->
    if type == 'bank'
      angular.forEach $rootScope.bankAccounts, (value, key) ->
        if account.AccountId is value.AccountId
          account.isActive = !account.isActive;
          if account.isActive == false
            $rootScope.activePaymentAccount = null
          else
            $rootScope.activePaymentAccount = account
        else
          value.isActive = false
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
      angular.forEach $rootScope.bankAccounts, (value, key) ->
        value.isActive = false

  $scope.getPaymentAccounts = (familyId, centerId) ->
    $scope.getCCAccounts(familyId, centerId)
    $scope.getBankAccounts(familyId, centerId)
      
  $scope.getCCAccounts = (familyId, centerId) ->
    CreditCardService.getCreditCardAccounts($rootScope.subscriberId, $scope.customerId).then (response) ->
      $rootScope.creditCardAccounts = response.data
      $scope.setPagination()
      $scope.setDefaultAccount()
      
  $scope.getBankAccounts = (familyId, centerId) ->
    AccountService.getAccounts(familyId, centerId).then (response) ->
      $rootScope.bankAccounts = response.data
      $scope.setPagination()
      $scope.setDefaultAccount()

  $scope.setPagination = () ->
    if $scope.pastTransactions
      $scope.pastTransactionsPagination = Pagination.getNew(10)
      $scope.pastTransactionsPagination.numPages = Math.ceil($scope.pastTransactions.length/$scope.pastTransactionsPagination.perPage)
    if $scope.historicalTransactions
      $scope.historicalTransactionsPagination = Pagination.getNew(10)
      $scope.historicalTransactionsPagination.numPages = Math.ceil($scope.historicalTransactions.length/$scope.historicalTransactionsPagination.perPage)
    if $scope.outstandingInvoices  
      $scope.outstandingInvoicesPagination = Pagination.getNew(10)
      $scope.outstandingInvoicesPagination.numPages = Math.ceil($scope.outstandingInvoices.length/$scope.outstandingInvoicesPagination.perPage)
    if $rootScope.bankAccounts 
      $rootScope.bankAccountsPagination = Pagination.getNew()
      $rootScope.bankAccountsPagination.numPages = Math.ceil($rootScope.bankAccounts.length/$scope.bankAccountsPagination.perPage)
    if $rootScope.creditCardAccounts  
      $rootScope.creditCardAccountsPagination = Pagination.getNew()
      $rootScope.creditCardAccountsPagination.numPages = Math.ceil($rootScope.creditCardAccounts.length/$scope.creditCardAccountsPagination.perPage)

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

    GuardianService.getAllGuardians($scope.familyId).then (response) ->
      $rootScope.guardians = response.data

      GuardianService.getGuardian($rootScope.guardians[0].GuardianId).then (response) ->
        $rootScope.headOfHouseHold = response.data

    CurbSideService.getAllChildren($scope.centerId, $scope.familyId).then (response) ->
      $scope.userChildren = response.data

    PaymentService.getChildrenTuiton($scope.familyId).then (response) ->
      $scope.userChildrenTuition = response.data

    AnnouncementsService.getAnnouncements($scope.customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data
      
    $scope.getTransactionsByDate(null)
    $scope.getTransactionsByDate('Historical')

    InvoiceService.getOutstandingInvoices($scope.customerId).then (response) ->
      $scope.outstandingInvoices = response.data
      $rootScope.outstandingInvoicesTotal = 0
      $rootScope.subscriberId = response.data[0].SubscriberId

      angular.forEach $scope.outstandingInvoices, (value, key) ->
        $rootScope.outstandingInvoicesTotal += value.DueAmount
        InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then (response) ->
          
          if response.data.length == 1
            $rootScope.invoicesArray.push response.data[0]
            $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+response.data[0].Amount

          else
            arrayHolder = []
            angular.forEach response.data, (value, key) ->
              arrayHolder.push value
              $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+value.Amount
            
            $rootScope.invoicesArray.push arrayHolder
      
      $scope.getPaymentAccounts($scope.familyId, $scope.centerId)
      $rootScope.stopSpin()
      
      if $route.current.$$route.originalPath == '/billing/invoices'
        $scope.goToTab('Invoices')
      else if $route.current.$$route.originalPath == '/billing/payment-accounts'
        $scope.goToTab('Invoices')