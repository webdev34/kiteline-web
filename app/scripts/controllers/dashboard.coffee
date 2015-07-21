'use strict'
angular.module('kiteLineApp').controller 'DashboardCtrl', ($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, AnnouncementsService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService) ->
  $rootScope.pageTitle = 'Dashboard'
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
  #console.log StorageService.getItem('currentCenter')
  # StorageService.deleteLocalStorage();

  $scope.payOutstandingBalance = ->
    ngDialog.open template: '/views/modals/pay-outstanding-balance.html'

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
    CurbSideService.getAllChildren(centerId, familyId).then (response) ->
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

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    centerId = $rootScope.currentCenter.CenterId
    familyId = $rootScope.currentCenter.FamilyId
    customerId = $rootScope.currentCenter.CustomerId
    
    CenterInfoService.getCenterDetails(centerId).then (response) ->
      $scope.currentCenterDetails = response.data

      $scope.getChildrenData()
          
    AnnouncementsService.getAnnouncements(customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data

    DailyActivityFeedService.getActivityFeed(familyId).then (response) ->
      $scope.dailyFeed = response.data
      $scope.goToFeed($scope.dailyFeed[0].FeedId)
      
    GuardianService.getAllGuardians(familyId).then (response) ->
      $scope.guardians = response.data
      $scope.goToGuardian($scope.guardians[0].GuardianId)

    ContactService.getAllContacts(familyId).then (response) ->
      $scope.contacts = response.data
      $scope.goToEmergencyContact($scope.contacts[0].EmergencyContactId)

    ChildPickupService.getAllChildPickupList(familyId).then (response) ->
      $scope.pickupList = response.data
      $scope.goToPickupContact($scope.pickupList[0].ChildPickupId)
      $rootScope.stopSpin()
      