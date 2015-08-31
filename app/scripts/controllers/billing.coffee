'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService, CreditCardService, AccountService, GuardianService, ngDialog, Pagination) ->
  $rootScope.changePageTitle()
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  LogInService.isLoggedIn()
  $scope.noResults = false
  $scope.noResultsInvoices = false
  $scope.currentTab = 'Overview'
  $rootScope.invoicesArray = []
  $rootScope.addCreditCardFromModal = false
  $scope.invoiceGrandTotal = 0
  $rootScope.paymentAmount = 0
  $scope.addBankAccount = false
  $scope.addCreditCard = false
  $rootScope.paymentMSG = null
  $rootScope.matchingBankAccount = false
  $rootScope.matchingRoutingNum = false
  $scope.newBankAccount = {}
  $scope.newCC = {}
  $rootScope.paymentCC = {}
  $scope.expireDates = {}
  $rootScope.expireDatesPayment = {}
  $rootScope.currentPaymentModal =  null
  $rootScope.processingPayment =  null
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

  $rootScope.processPayment = (accountId, invoiceId) ->
    $rootScope.processingPayment = true
    if !invoiceId
      invoiceId = 0
    
    if $rootScope.addCreditCardFromModal
      if $rootScope.paymentCC.RecurringAccount is true
        $rootScope.submitNewAccount('CC Payment', '')
      thisYear = String($rootScope.expireDatesPayment.year)
      thisYear = thisYear[2]+thisYear[3]
      $rootScope.paymentCC.ExpirationDate = $rootScope.expireDatesPayment.month+'/'+thisYear
      
      PaymentService.makePaymentWithCC($scope.familyId, $scope.centerId, invoiceId, $scope.customerId, $rootScope.paymentCC).then (response) ->
        $rootScope.paymentMSG = response.data
        $rootScope.processingPayment = false
        $scope.getInvoiceData()
    else
      PaymentService.makePaymentWithAccountId(accountId, $scope.customerId, invoiceId).then (response) ->
        $rootScope.paymentMSG = response.data
        $rootScope.processingPayment = false
        $scope.getTransactionsByDate(null)
        $scope.getTransactionsByDate('Historical')
        $scope.getInvoiceData()
        $rootScope.stopSpin()
      
  $rootScope.processInvoicePayment = (accountId) ->
    $rootScope.processingPayment = true
    if $rootScope.viewInvoiceArray is null
      invoiceId = $rootScope.viewInvoice.InvoiceId
    else
      invoiceId = $rootScope.viewInvoiceArray[0].InvoiceId

    $rootScope.processPayment(accountId, invoiceId)

  $scope.emailInvoiceToUser = (tranId) ->
    PaymentService.emailInvoice(tranId, $scope.familyId, $scope.centerId).then (response) ->
  
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
        $scope.getPaymentAccounts()

  $scope.setDefaultBankAccount = (account) ->
    if account.RecurringAccount == false
      $scope.deleteDefaultAccount()
    else
      AccountService.setActiveAccount($scope.familyId, $scope.centerId, account.AccountId).then (response) ->
        $scope.getPaymentAccounts()

  $scope.payOutstandingBalance = ->
    $rootScope.resetAccountForm('CC Payment')
    $rootScope.currentPaymentModal = 'Outstanding Balance'
    $rootScope.paymentAmount = $rootScope.outstandingInvoicesDueTotal.toFixed 2 
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

  $rootScope.payInvoice = (invoiceId, fromModal, trueAmount) ->
    $rootScope.resetAccountForm('CC Payment')
    $rootScope.invoicesArrayed()
    $rootScope.currentPaymentModal = 'Single Invoice'
    $rootScope.viewInvoiceArray = null
    $rootScope.viewInvoiceArrayTotal = trueAmount
    $rootScope.paymentAmount = trueAmount.toFixed 2 
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
            
      $rootScope.nextAndPreviousInvoices($scope.currentInvoice)
      $rootScope.currentPaymentModal = 'Multiple Line Item Invoice'
    else
      $rootScope.nextAndPreviousInvoices($rootScope.viewInvoice)

    PaymentService.getPartialPaymentsByInvoiceId($scope.customerId, invoiceId, $scope.customerId).then (response) ->
      $rootScope.PartialPaymentsMade = response.data
     
  $rootScope.reportInvoice = (invoice) ->
    $rootScope.currentInvoiceID = invoice.InvoiceId
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-invoice.html'
      className: 'ngdialog-theme-default ngdialog-pdf'

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
      $scope.autocompleteHomeAddressCC()
      $scope.newCC.autofillAddressCC = false
      $scope.addCreditCard = true
    else
      $scope.autocompleteHomeAddressBank()
      $scope.newBankAccount.autofillAddressBank = false 
      $scope.addBankAccount = true

  $rootScope.addAccountModal = () ->
    $rootScope.autocompleteHomeAddressCCPayment()
    $rootScope.paymentCC.autofillAddressCC = false
    $rootScope.addCreditCardFromModal = true
    $rootScope.resetActiveAccount(null, true)

  $rootScope.resetAccountForm = (type, form) ->
    $rootScope.paymentMSG = null
    if type == 'CC'
      $scope.addCreditCard = false
      $scope.newCC = {}
      $scope.newCC.PayerEmail = ''
      $scope.expireDates = {}
      $scope.expireDates.month = ''

    else if type == 'CC Payment'
      $rootScope.addCreditCardFromModal = false
      $rootScope.activePaymentAccount = false
      $rootScope.paymentCC = {}
      $rootScope.paymentCC.PayerEmail = ''
      $rootScope.expireDatesPayment = {}
      $rootScope.expireDatesPayment.month = ''

    else
      $scope.addBankAccount = false
      $scope.newBankAccount = {}
      $scope.newBankAccount.PayerEmail = ''
      
    if form      
      form.$setPristine();

  $rootScope.submitNewAccount = (type, form) ->
    if type == 'CC'
      thisYear = String($scope.expireDates.year)
      thisYear = thisYear[2]+thisYear[3]
      $scope.newCC.ExpirationDate = $scope.expireDates.month+'/'+thisYear
      CreditCardService.addCreditCard($scope.newCC).then (response) ->
        $scope.getPaymentAccounts()
        $scope.resetAccountForm('CC', form)
    else if type == 'CC Payment' and $rootScope.paymentCC.saveAccount
      thisYear = String($rootScope.expireDatesPayment.year)
      thisYear = thisYear[2]+thisYear[3]
      $rootScope.paymentCC.ExpirationDate = $rootScope.expireDatesPayment.month+'/'+thisYear
      CreditCardService.addCreditCard($rootScope.paymentCC).then (response) ->
        $scope.getPaymentAccounts()
        accountId = response.data
        $scope.resetAccountForm('CC Payment', form)
        if $rootScope.currentPaymentModal isnt 'Outstanding Balance'
          $rootScope.processInvoicePayment(accountId)
        # ngDialog.closeAll(1)
    else
      AccountService.createAccount($scope.newBankAccount).then (response) ->
        if response.statusText is 'OK'
          $scope.addBankAccount = false
          $scope.getPaymentAccounts()
          $scope.resetAccountForm('Bank', form)

  $scope.deleteBankAccount = (accountId) ->
    if confirm('Are you sure you want to delete this?')
      AccountService.deleteAccount($scope.familyId, $scope.centerId, accountId).then (response) ->
        $scope.getBankAccounts()
    else
      false
    
  $scope.deleteCreditCardAccount = (accountId) ->
    if confirm('Are you sure you want to delete this?')
      CreditCardService.deleteCreditCard(accountId).then (response) ->
      setTimeout (->
        $scope.getCCAccounts()
      ), 500
    else
      false    

  $scope.goToTab = (tab) ->
    $scope.setPagination()
    $scope.currentTab = tab
    $scope.addCreditCard = false
    $scope.addBankAccount = false
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

  $scope.getInvoiceData = () ->
    InvoiceService.getOutstandingInvoices($scope.customerId).then (response) ->
      $rootScope.outstandingInvoices = response.data
      $rootScope.outstandingInvoicesDueTotal = 0
      $rootScope.outstandingInvoicesTotal = 0
      $scope.outstandingBalance = 0
      
      angular.forEach $rootScope.outstandingInvoices, (value, key) ->
        $rootScope.outstandingInvoicesDueTotal += value.DueAmount
        $rootScope.outstandingInvoicesTotal += value.TotalAmount
        InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then (response) ->
          
          if response.data.length == 1
            $rootScope.invoicesArray.push response.data[0]
            $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+response.data[0].Amount
            $scope.outstandingBalance = $scope.invoiceGrandTotal

          else
            arrayHolder = []
            angular.forEach response.data, (value, key) ->
              arrayHolder.push value
              $scope.invoiceGrandTotal = $scope.invoiceGrandTotal+value.Amount
              $scope.outstandingBalance = $scope.invoiceGrandTotal
            
            $rootScope.invoicesArray.push arrayHolder   

  $scope.getPaymentAccounts = () ->
    $scope.getCCAccounts()
    $scope.getBankAccounts()
      
  $scope.getCCAccounts = () ->
    CreditCardService.getCreditCardAccounts($rootScope.subscriberId, $scope.customerId).then (response) ->
      $rootScope.creditCardAccounts = response.data
      $scope.setPagination()
      $scope.setDefaultAccount()
      
  $scope.getBankAccounts = () ->
    AccountService.getAccounts($scope.familyId, $scope.centerId).then (response) ->
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
    if $rootScope.outstandingInvoices  
      $rootScope.outstandingInvoicesPagination = Pagination.getNew(10)
      $rootScope.outstandingInvoicesPagination.numPages = Math.ceil($rootScope.outstandingInvoices.length/$rootScope.outstandingInvoicesPagination.perPage)
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
    # $scope.outstandingBalance = $rootScope.currentCenter.OutstandingBalance
    
    CenterInfoService.getCenterDetails($scope.centerId).then (response) ->
      $scope.currentCenterDetails = response.data
      $rootScope.subscriberId = response.data.SubscriberId

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
    $scope.getInvoiceData().then (response) ->
      $scope.getPaymentAccounts().then (response) ->

        $rootScope.stopSpin()
    
    if $route.current.$$route.originalPath == '/billing/invoices'
      $scope.goToTab('Invoices')
    else if $route.current.$$route.originalPath == '/billing/payment-accounts'
      $scope.goToTab('Invoices')