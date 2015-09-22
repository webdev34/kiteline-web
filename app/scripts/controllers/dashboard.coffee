'use strict'
angular.module('kiteLineApp').controller 'DashboardCtrl', ($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, ChildService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService, Pagination) ->
  
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  $scope.showItemsMenu = false
  LogInService.isLoggedIn()
  $scope.userChildren = null
  $scope.viewChild = null
  $scope.editGuardian = false
  $scope.editContact = false
  $scope.editMedicalInfo = false
  $scope.editPickupList = false
  $scope.newPickupContact = false
  $scope.buttonDisable = false
  $scope.isPinValid = false
  $scope.currentLowerTab = "Updates"
  $scope.activeChild = "child-1"
  $scope.activeGuardian = "guardian-1"
  $scope.activeEmergencyContact = "contact-1"
  $scope.activePickupContact = "pickup-contact-1"
  $scope.viewPickupContactNew = {}
  $rootScope.changePageTitle()


  $scope.pinValidation = ()->
    if $scope.viewEmergencyContactEdit.Pin 
      if $scope.viewEmergencyContactEdit.Pin.length == 4
        $scope.isPinValid = true
      else
        editContactFormTop.pin.$invalid = true
        $scope.isPinValid = false

  $scope.editSection = (editMe) ->
    if editMe == 'Medical Info'
      $scope.editMedicalInfo = !$scope.editMedicalInfo
    else if editMe == 'Guardian Info'
      $scope.editGuardian = !$scope.editGuardian
    else if editMe == 'Contact Info'
      $scope.editContact = !$scope.editContact
    else if editMe == 'Picklist Info'
      $scope.editPickupList = !$scope.editPickupList
    else if editMe == 'New Picklist Info'
      $scope.newPickupContact = !$scope.newPickupContact
      $scope.viewPickupContactNew = {}

  $scope.deleteEmergencyContact = (contactId) ->
    ContactService.deleteContact(contactId, $rootScope.centerId).then (response) ->
      $scope.getContactData(false)
      $scope.activeEmergencyContact = "contact-1"

  $scope.deletePickupListContact = (contactId) -> 
    ChildPickupService.deleteChildPickupListItem(contactId, $rootScope.centerId).then (response) ->
      $scope.getPickListData()
      $scope.activePickupContact = "pickup-contact-1"

  $scope.newPickupListContact = () ->
    $scope.buttonDisable = true
    ChildPickupService.addChildPickUpRecord($scope.viewPickupContactNew, $scope.viewChild.ChildId).then (response) ->
      $scope.getPickListData(true)
      $scope.buttonDisable = false
      $scope.newPickupContact = false
      thisIndex = $scope.pickupList.length+1
      $scope.changeActivePickupContact('pickup-contact-'+thisIndex)

  $scope.editMedInfo = () ->
    $scope.buttonDisable = true
    ChildService.updateChildMedInfo($scope.viewChildMedicalInfoEdit).then (response) ->
      ChildService.getChildMedInfo($scope.viewChildMedicalInfoEdit.ChildId).then (response) ->
        $scope.childrenMedicalInfo = []
        $scope.childrenMedicalInfo.push response.data
        $scope.viewChildMedicalInfo = $filter('filter')($scope.childrenMedicalInfo, (d) -> d.ChildId == $scope.viewChildMedicalInfoEdit.ChildId)[0]
        $scope.viewChildMedicalInfoEdit = angular.copy $scope.viewChildMedicalInfo
        $scope.viewChildMedicalInfoEdit.PhysicalDate = $filter('date') $scope.viewChildMedicalInfoEdit.PhysicalDate, 'M/dd/yyyy'
        $scope.editMedicalInfo = false
        $scope.buttonDisable = false

  $scope.editPickupContactInfo = () ->
    $scope.buttonDisable = true
    ChildPickupService.updateChildPickupInfo($scope.viewChild.ChildId, $scope.viewPickupContactEdit).then (response) ->
      $scope.getPickListData().then (response) ->
      $scope.buttonDisable = false
      $scope.editPickupList = false
      angular.forEach $scope.pickupList, (value, key) ->
        if value.PickupName == $scope.viewPickupContactEdit
          $scope.goToPickupContact(value.ChildPickupId)


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
  
  $scope.getChildrenData = (refreshingData) ->
    CurbSideService.getAllChildren($rootScope.centerId, $rootScope.familyId).then (response) ->
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
                else if refreshingData
                  $scope.goToChild(value.ChildId, true)

  $scope.goToChild = (childId, refreshingData, tabToShow) ->
    $scope.viewChild = $filter('filter')($scope.userChildren, (d) -> d.ChildId == childId)[0]
    $scope.viewChildMedicalInfo = $filter('filter')($scope.childrenMedicalInfo, (d) -> d.ChildId == childId)[0]
    $scope.viewChildMedicalInfoEdit = angular.copy $scope.viewChildMedicalInfo
    $scope.viewChildMedicalInfoEdit.PhysicalDate = $filter('date') $scope.viewChildMedicalInfoEdit.PhysicalDate, 'M/dd/yyyy'
    $scope.viewChildGeneralInfo = $filter('filter')($scope.childrenGenInfo, (d) -> d.ChildId == childId)[0]
    $scope.viewChildHistoryInfo = $filter('filter')($scope.childrenHistoryInfo, (d) -> d.ChildId == childId)[0]
    if refreshingData
      $scope.changeActiveLowerTab(tabToShow)

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
      $scope.viewGuardianEdit = angular.copy $scope.viewGuardian
      $rootScope.headOfHouseHold = $scope.viewGuardian

  $scope.editGuardianInfo = () ->
    $scope.buttonDisable = true
    GuardianService.updatePersonalInfo($scope.viewGuardianEdit)
    GuardianService.updateMailingAddress($scope.viewGuardianEdit)
    GuardianService.updateContactInfo($scope.viewGuardianEdit).then (response) ->
      $rootScope.getGuardianData(true)
      $scope.goToGuardian($scope.viewGuardianEdit.GuardianId)
      $scope.editGuardian = false
      $scope.buttonDisable = false

  $scope.goToEmergencyContact = (contactId) ->
    ContactService.getContact(contactId).then (response) ->
      $scope.viewEmergencyContact = response.data
      $scope.viewEmergencyContactEdit = angular.copy $scope.viewEmergencyContact
      if $scope.viewEmergencyContactEdit.Pin == '(Not Set)' || $scope.viewEmergencyContactEdit.Pin == '(not set)' 
        $scope.viewEmergencyContactEdit.Pin = null

  $scope.editContactInfo = () ->
    $scope.buttonDisable = true
    ContactService.updatePersonalInfo($scope.viewEmergencyContactEdit)
    ContactService.updateMailingAddress($scope.viewEmergencyContactEdit)
    ContactService.updateContactInfo($scope.viewEmergencyContactEdit).then (response) ->
      $scope.getContactData(true)
      $scope.goToEmergencyContact($scope.viewEmergencyContactEdit.EmergencyContactId)
      $scope.editContact = false
      $scope.buttonDisable = false

  $scope.goToPickupContact = (contactId) ->
    $scope.viewPickupContact = $filter('filter')($scope.pickupList, (d) -> d.ChildPickupId == contactId)[0]  
    $scope.viewPickupContactEdit = angular.copy $scope.viewPickupContact

  $scope.getContactData = (isUpdated) ->
    ContactService.getAllContacts($rootScope.familyId).then (response) ->
      $scope.contacts = response.data
      $scope.contactsPagination = Pagination.getNew()
      $scope.contactsPagination.numPages = Math.ceil($scope.contacts.length/$scope.contactsPagination.perPage)
      if !isUpdated
        $scope.goToEmergencyContact($scope.contacts[0].EmergencyContactId)
      else
        $scope.goToEmergencyContact($scope.viewEmergencyContactEdit.EmergencyContactId)

  $scope.getPickListData = (refreshed, childPickupId) ->
    ChildPickupService.getAllChildPickupList($rootScope.familyId).then (response) ->
      $scope.pickupList = response.data
      if $scope.pickupList == null
        $scope.pickupList = []
      else if refreshed
        $scope.goToPickupContact($scope.pickupList[$scope.pickupList.length-1].ChildPickupId)
      else
        $scope.goToPickupContact($scope.pickupList[0].ChildPickupId)
        
      $scope.pickupListPagination = Pagination.getNew()
      $scope.pickupListPagination.numPages = Math.ceil($scope.pickupList.length/$scope.pickupListPagination.perPage)

  if StorageService.getItem('currentCenter')
    $rootScope.getUserData()
    $scope.getChildrenData()    
    $rootScope.getMessages()

    DailyActivityFeedService.getActivityFeed($rootScope.familyId).then (response) ->
      $scope.dailyFeed = response.data
      $scope.dailyFeedPagination = Pagination.getNew()
      $scope.dailyFeedPagination.numPages = Math.ceil($scope.dailyFeed.length/$scope.dailyFeedPagination.perPage)
      if $scope.dailyFeed.length > 0
        $scope.goToFeed($scope.dailyFeed[0].FeedId)
      
      $rootScope.getGuardianData(false).then (response) ->
        if $rootScope.guardians.length > 0
          $scope.goToGuardian($rootScope.guardians[0].GuardianId)

      $scope.getContactData(false).then (response) ->

      $scope.getPickListData()
      $rootScope.getInvoiceData()
      
      setTimeout (->
        $rootScope.getPaymentAccounts()
        $rootScope.stopSpin()
      ), 1000
        