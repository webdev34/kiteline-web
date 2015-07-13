'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService) ->
  $rootScope.pageTitle = 'Billing'
  $rootScope.isLoginPage = false
  $scope.noResults = false
  $scope.currentTab = 'Overview'
  $scope.invoicesArray = []
  $scope.invoiceGrandTotal = 0
  $scope.bank_auto_pay = true
  $scope.credit_card_auto_pay = false
  $scope.taxStatements = [ [2015,2014],[2013,2012],[2011,2010]]
  $scope.billDates = {}
  $scope.billDates.transactionStartDate = '1/01/2014'
  $scope.billDates.transactionEndDate = '7/01/2015'
  $scope.billDates.historicalStartDate = '2/01/2015'
  $scope.billDates.historicalEndDate = '7/30/2015'

  LogInService.isLoggedIn()

  $scope.goToTab = (tab) ->
    $scope.currentTab = tab

  $scope.getPastPayments = () ->
    PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId).then (response) ->
      $scope.pastTransactions  = response

  $scope.getTransactionsByDate = (type) ->
    $scope.noResults = false
    if type == 'Historical'
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data
        console.log $scope.historicalTransactions
    else
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.transactionStartDate, $scope.billDates.transactionEndDate).then (response) ->
        $scope.pastTransactions  = response.data
        console.log $scope.pastTransactions
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
