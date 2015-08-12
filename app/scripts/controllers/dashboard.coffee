'use strict'
angular.module('kiteLineApp').controller 'DashboardCtrl', ($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, AnnouncementsService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService, CreditCardService, Pagination, InvoiceService) ->
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

  $scope.payOutstandingBalance = ->
    ngDialog.open template: $rootScope.modalUrl+'/views/modals/pay-outstanding-balance.html'

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
    $scope.getBankAccounts(familyId, centerId)
      
  $scope.getCCAccounts = (familyId, centerId) ->
    CreditCardService.getCreditCardAccounts($rootScope.subscriberId, $scope.customerId).then (response) ->
      $rootScope.creditCardAccounts = response.data
      $rootScope.creditCardAccountsPagination = Pagination.getNew()
      $rootScope.creditCardAccountsPagination.numPages = Math.ceil($rootScope.creditCardAccounts.length/$scope.creditCardAccountsPagination.perPage)
  
  $scope.getBankAccounts = (familyId, centerId) ->
    CreditCardService.getBankAccounts(familyId, centerId).then (response) ->
      $rootScope.bankAccounts = response.data
      $rootScope.bankAccountsPagination = Pagination.getNew()
      $rootScope.bankAccountsPagination.numPages = Math.ceil($rootScope.bankAccounts.length/$scope.bankAccountsPagination.perPage)

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    $scope.centerId = $rootScope.currentCenter.CenterId
    $scope.familyId = $rootScope.currentCenter.FamilyId
    $scope.customerId = $rootScope.currentCenter.CustomerId
    $rootScope.showLogOut = false
   
    CenterInfoService.getCenterDetails($scope.centerId).then (response) ->
      $scope.currentCenterDetails = response.data

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

    InvoiceService.getOutstandingInvoices($scope.customerId).then (response) ->
      $scope.outstandingInvoices = response.data
      $rootScope.subscriberId = response.data[0].SubscriberId
      $scope.getPaymentAccounts($scope.familyId, $scope.centerId)

    ChildPickupService.getAllChildPickupList($scope.familyId).then (response) ->
      $scope.pickupList = response.data
      if $scope.pickupList == null
        $scope.pickupList = []
      else
        $scope.goToPickupContact($scope.pickupList[0].ChildPickupId)
        
      $scope.pickupListPagination = Pagination.getNew()
      $scope.pickupListPagination.numPages = Math.ceil($scope.pickupList.length/$scope.pickupListPagination.perPage)
      
      $rootScope.stopSpin()
      