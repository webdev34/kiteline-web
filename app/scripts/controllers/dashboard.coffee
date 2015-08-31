'use strict'
angular.module('kiteLineApp').controller 'DashboardCtrl', ($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, AnnouncementsService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService, CreditCardService, Pagination, InvoiceService, InvoiceDetailService, PaymentService) ->
  $rootScope.changePageTitle()
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  $scope.showItemsMenu = false
  LogInService.isLoggedIn()
  $scope.userChildren = null
  $scope.viewChild = null
  $scope.currentLowerTab = "Updates"
  $scope.activeChild = "child-1"
  $scope.activeGuardian = "guardian-1"
  $scope.activeEmergencyContact = "contact-1"
  $scope.activePickupContact = "pickup-contact-1"
  $rootScope.paymentCC = {}
  $rootScope.expireDatesPayment = {}
  $rootScope.matchingBankAccount = false
  $rootScope.matchingRoutingNum = false
  $rootScope.addCreditCardFromModal = false
  $rootScope.invoicesArray = []
  $scope.invoiceGrandTotal = 0
  $rootScope.paymentAmount = 0
  $scope.addBankAccount = false
  $scope.addCreditCard = false
  $rootScope.paymentMSG = null
  $rootScope.matchingBankAccount = false
  $rootScope.matchingRoutingNum = false
  $rootScope.currentPaymentModal =  null

  $rootScope.processPayment = (accountId, invoiceId) ->
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
        $scope.getInvoiceData()
    else
      PaymentService.makePaymentWithAccountId(accountId, $scope.customerId, invoiceId).then (response) ->
        $rootScope.paymentMSG = response.data
        $scope.getInvoiceData()

  $scope.setDefaultAccount = () ->
    $scope.defaultAccount = null
    angular.forEach $rootScope.bankAccounts, (value, key) ->
      if value.RecurringAccount == true
        $scope.defaultAccount = value

    angular.forEach $rootScope.creditCardAccounts, (value, key) ->
      if value.RecurringAccount == true
        $scope.defaultAccount = value

  $scope.payOutstandingBalance = ->
    $rootScope.resetAccountForm('CC Payment')
    $rootScope.currentPaymentModal = 'Outstanding Balance'
    $rootScope.paymentAmount = $rootScope.outstandingInvoicesDueTotal.toFixed 2 
    ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-outstanding-balance.html'

  $rootScope.addAccountModal = () ->
    $rootScope.autocompleteHomeAddressCCPayment()
    $rootScope.paymentCC.autofillAddressCC = false
    $rootScope.addCreditCardFromModal = true; 
    $rootScope.activePaymentAccount = true;

  $rootScope.resetAccountForm = (type, form) ->
    $rootScope.addCreditCardFromModal = false
    $rootScope.activePaymentAccount = false
    $rootScope.paymentCC = {}
    $rootScope.paymentCC.PayerEmail = ''
    $rootScope.expireDatesPayment = {}
    $rootScope.expireDatesPayment.month = ''
    if form      
      form.$setPristine();

  $rootScope.submitNewAccount = (type, form) ->
    thisYear = String($rootScope.expireDatesPayment.year)
    thisYear = thisYear[2]+thisYear[3]
    $rootScope.paymentCC.ExpirationDate = $rootScope.expireDatesPayment.month+'/'+thisYear
    CreditCardService.addCreditCard($rootScope.paymentCC).then (response) ->
      $scope.getPaymentAccounts($scope.familyId, $scope.centerId)
      $scope.resetAccountForm('CC Payment', form)
      ngDialog.closeAll(1)
  
  $scope.changeActivePickupContact = (activePickupContact) ->
    $scope.activePickupContact = activePickupContact

  $scope.changeActiveEmergencyContact = (activeEmergencyContact) ->
    $scope.activeEmergencyContact = activeEmergencyContact

  $scope.changeActiveGuardian = (activeGuardian) ->
    $scope.activeGuardian = activeGuardian

  $scope.changeActiveChild = (activeChild) ->
    $scope.activeChild = activeChild

  $scope.changeActiveLowerTab = (activeTab) ->
    $scope.currentLowerTab = activeTab
  
  $scope.getChildrenData = () ->
    CurbSideService.getAllChildren($scope.centerId, $scope.familyId).then (response) ->
      $scope.userChildren = response.data
      $scope.childrenClasses = []
      $scope.childrenGenInfo = []
      $scope.childrenMedicalInfo = []
      $scope.childrenHistoryInfo = []

      angular.forEach $scope.userChildren, (value, key) ->
        ChildService.getChildClass(value.ChildId).then (response) ->
          $scope.childrenClasses.push response.data

          ChildService.getChildGenInfo(value.ChildId).then (response) ->
            $scope.childrenGenInfo.push response.data

            ChildService.getChildMedInfo(value.ChildId).then (response) ->
              $scope.childrenMedicalInfo.push response.data

              ChildService.getChildHistory(value.ChildId).then (response) ->
                $scope.childrenHistoryInfo.push response.data

                if key == 0 && $scope.viewChild == null
                  $scope.goToChild(value.ChildId)

  $scope.goToChild = (childId) ->
    $scope.viewChild = $filter('filter')($scope.userChildren, (d) -> d.ChildId == childId)[0]
    $scope.viewChildMedicalInfo = $filter('filter')($scope.childrenMedicalInfo, (d) -> d.ChildId == childId)[0]
    $scope.viewChildGeneralInfo = $filter('filter')($scope.childrenGenInfo, (d) -> d.ChildId == childId)[0]
    $scope.viewChildHistoryInfo = $filter('filter')($scope.childrenHistoryInfo, (d) -> d.ChildId == childId)[0]

  $scope.goToFeed = (feedId) ->
    $scope.viewFeedAttachments = null
    $scope.viewFeedNotes = null
    $scope.viewFeed = null

    $scope.viewFeed = $filter('filter')($scope.dailyFeed, (d) -> d.FeedId == feedId)[0]
    DailyActivityFeedService.getFeedDetail(feedId, $scope.viewFeed.FeedType).then (response) ->
      $scope.viewFeedNotes = response.data.Notes

    DailyActivityFeedService.getFeedFiles(feedId, $scope.viewFeed.FeedType).then (response) ->
      $scope.viewFeedAttachments = response.data

  $scope.goToGuardian = (guardianId) ->
    GuardianService.getGuardian(guardianId).then (response) ->
      $scope.viewGuardian = response.data

  $scope.goToEmergencyContact = (contactId) ->
    ContactService.getContact(contactId).then (response) ->
      $scope.viewEmergencyContact = response.data

  $scope.goToPickupContact = (contactId) ->
    $scope.viewPickupContact = $filter('filter')($scope.pickupList, (d) -> d.ChildPickupId == contactId)[0]

  $scope.getPaymentAccounts = (familyId, centerId) ->
    $scope.getCCAccounts(familyId, centerId)
    $scope.setDefaultAccount()
      
  $scope.getCCAccounts = (familyId, centerId) ->
    CreditCardService.getCreditCardAccounts($rootScope.subscriberId, $scope.customerId).then (response) ->
      $rootScope.creditCardAccounts = response.data
      $rootScope.creditCardAccountsPagination = Pagination.getNew()
      $rootScope.creditCardAccountsPagination.numPages = Math.ceil($rootScope.creditCardAccounts.length/$scope.creditCardAccountsPagination.perPage)
 
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


  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    $rootScope.LastLoginInfo = StorageService.getItem('LastLoginInfo')
    
    $scope.centerId = $rootScope.currentCenter.CenterId
    $scope.familyId = $rootScope.currentCenter.FamilyId
    $scope.customerId = $rootScope.currentCenter.CustomerId
    $rootScope.showLogOut = false
   
    CenterInfoService.getCenterDetails($scope.centerId).then (response) ->
      $rootScope.currentCenterDetails = response.data
      $rootScope.subscriberId = response.data.SubscriberId
    
      $scope.getChildrenData()
          
    AnnouncementsService.getAnnouncements($scope.customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data

    DailyActivityFeedService.getActivityFeed($scope.familyId).then (response) ->
      $scope.dailyFeed = response.data
      $scope.dailyFeedPagination = Pagination.getNew()
      $scope.dailyFeedPagination.numPages = Math.ceil($scope.dailyFeed.length/$scope.dailyFeedPagination.perPage)
      if $scope.dailyFeed.length > 0
        $scope.goToFeed($scope.dailyFeed[0].FeedId)
      
    GuardianService.getAllGuardians($scope.familyId).then (response) ->
      $scope.guardians = response.data
      $scope.guardiansPagination = Pagination.getNew()
      $scope.guardiansPagination.numPages = Math.ceil($scope.guardians.length/$scope.guardiansPagination.perPage)
      $scope.goToGuardian($scope.guardians[0].GuardianId)

    ContactService.getAllContacts($scope.familyId).then (response) ->
      $scope.contacts = response.data
      $scope.contactsPagination = Pagination.getNew()
      $scope.contactsPagination.numPages = Math.ceil($scope.contacts.length/$scope.contactsPagination.perPage)
      $scope.goToEmergencyContact($scope.contacts[0].EmergencyContactId)

    $scope.getInvoiceData()

    ChildPickupService.getAllChildPickupList($scope.familyId).then (response) ->
      $scope.pickupList = response.data
      if $scope.pickupList == null
        $scope.pickupList = []
      else
        $scope.goToPickupContact($scope.pickupList[0].ChildPickupId)
        
      $scope.pickupListPagination = Pagination.getNew()
      $scope.pickupListPagination.numPages = Math.ceil($scope.pickupList.length/$scope.pickupListPagination.perPage)
      
      setTimeout (->
        $scope.getPaymentAccounts()
      ), 250
      $rootScope.stopSpin()