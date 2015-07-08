'use strict'
angular.module('kiteLineApp').controller 'BillingCtrl', ($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService) ->
  $rootScope.pageTitle = 'Billing'
  $rootScope.isLoginPage = false
  $scope.currentTab = 'Overview'
  $scope.showBreakDownView = false
  $scope.showItemsMenu = false
  $scope.invoicesArray = []
  $scope.invoiceGrandTotal = 0
  $scope.amountBeingPaid = 'payTotalAmountDue'
  $scope.taxStatements = [ [2015,2014],[2013,2012],[2011,2010]]

  LogInService.isLoggedIn()

  $scope.goToTab = (tab) ->
    $scope.currentTab = tab
 
  $scope.goToOutstandingInvoicesView = () ->
    $scope.displayView = 'outstanding invoices'
    return

  $scope.goToPaymentsMadeView = () ->
    $scope.displayView = 'payments made'
    return

  $scope.goBackToInvoices = () ->
    $scope.showBreakDownView = false
    $scope.displayView = 'invoices'
    return

  $scope.goToPayment = (payId) ->
    $scope.showBreakDownView = true
    $scope.displayView = 'payments made'
    $scope.viewPayment = $filter('filter')($scope.pastPayments, (d) -> d.PayId == payId)[0]
    return

  $scope.goToInvoiceFromArrayItem = (obj) ->
    $scope.viewInvoice = obj
    $scope.lineItemId = obj.LineItemId
    return

  $scope.goToInvoice = (invoiceId) ->
    $scope.displayView = 'outstanding invoices'
    $scope.showItemsMenu = false
    $scope.showBreakDownView = true
    $scope.viewInvoice = $filter('filter')($scope.invoicesArray, (d) -> d.InvoiceId == invoiceId)[0]

    if typeof $scope.viewInvoice == 'undefined'
      $scope.showItemsMenu = true
      angular.forEach $scope.invoicesArray, (value, key) ->
        if value instanceof Array
          if value[0].InvoiceId == invoiceId
            $scope.viewInvoiceArray = $scope.invoicesArray[key]
            $scope.goToInvoiceFromArrayItem($scope.invoicesArray[key][0])
  

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
      
    PaymentService.getPastPayments(customerId).then (response) ->
      $scope.pastPayments = response.data
      if $routeParams.payId
        $scope.goToPayment(parseInt($routeParams.payId))

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

