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
  $rootScope.PartialPaymentsMade = null
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

  $scope.emailInvoiceToUser = (tranId) ->
    PaymentService.emailInvoice(tranId, $scope.familyId, $scope.centerId).then (response) ->
  
  $scope.getTaxStatement = (year) ->
    $rootScope.currentFamilyID = $scope.familyId
    $rootScope.selectedYear = year
    $rootScope.paymentMSG = null
    ngDialog.open
      template: $rootScope.modalUrl+'/views/modals/report-statement.html'
      className: 'ngdialog-theme-default ngdialog-pdf'
  
  $scope.reportPayment = (payment) ->
    $rootScope.currentFamilyID = $scope.familyId
    $rootScope.currentTransactionID = payment.PayId
    $rootScope.currentTranType = payment.PaymentType
    $rootScope.paymentMSG = null
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

  $scope.viewInvoiceHistoryCheck = (invoice) ->
    PaymentService.getPartialPaymentsByInvoiceId($scope.customerId, invoice.InvoiceId, $scope.centerId).then (response) ->
      if response.data.length == 0
        invoice.hasHistory = false
      else
        invoice.hasHistory = true

  $scope.viewInvoiceHistory = (invoiceId) ->  
    $rootScope.paymentMSG = null
    PaymentService.getPartialPaymentsByInvoiceId($scope.customerId, invoiceId, $scope.centerId).then (response) ->
      $rootScope.PartialPaymentsMade = response.data
      ngDialog.open template: $rootScope.modalUrl+'/views/modals/invoice-history.html'
      

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
  
  $rootScope.getTransactionsByDate = (type) ->
    if type == 'Historical'
      $scope.noResultsInvoices = false
      InvoiceService.getPaidInvoicesByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data
        $scope.historicalTransactionsTotal = 0
        $scope.billDates.queryingHistorical = false
    
        angular.forEach $scope.historicalTransactions, (value, key) ->
          $scope.historicalTransactionsTotal += value.TotalAmount

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

  $rootScope.getInvoiceData = () ->
    InvoiceService.getOutstandingInvoices($scope.customerId).then (response) ->
      $rootScope.outstandingInvoices = response.data
      $rootScope.outstandingInvoicesDueTotal = 0
      $rootScope.outstandingInvoicesTotal = 0
      $scope.outstandingBalance = 0
      
      angular.forEach $rootScope.outstandingInvoices, (value, key) ->
        $rootScope.outstandingInvoicesDueTotal += value.DueAmount
        $rootScope.outstandingInvoicesTotal += value.TotalAmount
        $scope.viewInvoiceHistoryCheck(value)
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
      
    $rootScope.getTransactionsByDate(null)
    $rootScope.getTransactionsByDate('Historical')
    $rootScope.getInvoiceData().then (response) ->
      $scope.getPaymentAccounts().then (response) ->

        $rootScope.stopSpin()
    
    if $route.current.$$route.originalPath == '/billing/invoices'
      $scope.goToTab('Invoices')
    else if $route.current.$$route.originalPath == '/billing/payment-accounts'
      $scope.goToTab('Invoices')