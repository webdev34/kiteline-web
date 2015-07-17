'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService, CreditCardService) ->
  $rootScope.pageTitle = 'Billing'
  $rootScope.startSpin()
  $rootScope.pageTitle = 'Billing'
  $rootScope.isLoginPage = false
  $scope.noResults = false
  $scope.currentTab = 'Overview'
  $scope.invoicesArray = []
  $scope.invoiceGrandTotal = 0
  $scope.bank_auto_pay = true
  $scope.credit_card_auto_pay = false
  $scope.addBankAccount = false
  $scope.addCreditCard = false
  $scope.newBankAccount = {}
  $scope.newCC = {}
  $scope.taxStatements = [ [2015,2014],[2013,2012],[2011,2010]]
  $scope.billDates = {}
  $scope.billDates.transactionStartDate = '1/01/2014'
  $scope.billDates.transactionEndDate = '7/01/2015'
  $scope.billDates.historicalStartDate = '2/01/2015'
  $scope.billDates.historicalEndDate = '7/30/2015'
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


  LogInService.isLoggedIn()

  $scope.addAccount = (type) ->
    if type == 'CC'
      $scope.addCreditCard = true
    else
      $scope.addBankAccount = true

  $scope.submitNewAccount = (type) ->
    if type == 'CC'
      $scope.newCC.ExpirationDate = $scope.exp_month+'/'+$scope.exp_year
      CreditCardService.createAccount($scope.newCC).then (response) ->
        console.log response
    else
      CreditCardService.createAccount($scope.newBankAccount).then (response) ->
        console.log response

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
    $scope.noResults = false
    if type == 'Historical'
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data
    else
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.transactionStartDate, $scope.billDates.transactionEndDate).then (response) ->
        $scope.pastTransactions  = response.data

        if $scope.pastTransactions.length == 0
          $scope.noResults = true

  $scope.goToInvoiceFromArrayItem = (obj) ->
    $scope.viewInvoice = obj
    $scope.lineItemId = obj.LineItemId

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    centerId = $rootScope.currentCenter.CenterId
    familyId = $rootScope.currentCenter.FamilyId
    customerId = $rootScope.currentCenter.CustomerId
    $scope.outstandingBalance = $rootScope.currentCenter.OutstandingBalance
    
    if $route.current.$$route.originalPath == "/invoices/outstanding-balance"
      $scope.goToViewOutstandingBalance()

    CenterInfoService.getCenterDetails(centerId).then (response) ->
      $scope.currentCenterDetails = response.data
      console.log $scope.currentCenterDetails
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
      console.log response.data
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
      console.log response.data

    CreditCardService.getCreditCardAccounts(familyId, centerId).then (response) ->
      $scope.creditCardAccounts = response.data
      console.log response.data

      $rootScope.stopSpin()
