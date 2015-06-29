'use strict'
angular.module('kiteLineApp').controller 'MyAccountsCtrl', ($scope, $rootScope, $filter, StorageService, LogInService, CenterInfoService, ChildService, GuardianService, AnnouncementsService, CurbSideService, ContactService, ChildPickupService) ->
  $rootScope.pageTitle = 'My Accounts'
  $rootScope.isLoginPage = false
  $scope.displayView = 'my accounts'
  $scope.displaySubView = null
  $scope.showBreakDownView = false
  $scope.isEdit = false
  $scope.new_pickup_canPickup = 0
  $scope.edit_pickup_canPickup = 0
  LogInService.isLoggedIn()

  $scope.goToView = (view) ->
    $scope.showBreakDownView = false
    $scope.displayView = view
    if view == 'pickup list'
      $scope.showBreakDownView = true
      $scope.displaySubView = 'pickup list breakdown'

  $scope.goToSubView = (subView) ->
    $scope.showBreakDownView = true
    $scope.displaySubView = subView

  $scope.goBackToMyAccounts = () ->
    $scope.showBreakDownView = false
    $scope.displayView = 'my accounts'

  $scope.goToGuardian = (guardianId) ->
    GuardianService.getGuardian(guardianId).then (response) ->
      $scope.showBreakDownView = true
      $scope.displayView = 'guardians'
      $scope.viewGuardian = response.data

  $scope.goToAltContact = (contactId) ->
    $scope.viewAltContact = null
    $scope.viewAltContactEdit = null
    $scope.showBreakDownView = true
    $scope.displaySubView = 'alt contact personal information breakdown'
    ContactService.getContact(contactId).then (response) ->
      $scope.viewAltContact = response.data
      $scope.viewAltContactEdit = angular.copy(response.data)

  $scope.editAltContactSubmit = () ->
    $scope.refreshAltContactList()
    ContactService.updatePersonalInfo($scope.viewAltContactEdit)
    ContactService.updateMailingAddress($scope.viewAltContactEdit)
    ContactService.updateContactInfo($scope.viewAltContactEdit).then (response) ->

#PICK UP LIST FUNCTIONALITY
  $scope.goToPickupContact = (contactId) ->
    $scope.showBreakDownView = true
    $scope.displaySubView = 'alt contact personal information breakdown'
    $scope.viewAltContact = $filter('filter')($scope.contacts, (d) -> d.EmergencyContactId == contactId)[0]

  $scope.addNewPickupContactSubmit = () ->
    canPickup = 0
    if $scope.new_canPickup == true
      canPickup = 1

    $scope.newPickupObj = 
      canPickup: canPickup
      name: $scope.new_pickup_name
      additionalInfo: $scope.new_pickup_additionalInfo
      childId: $scope.pickupList[0].ChildId
    
    ChildPickupService.addChildPickUpRecord($scope.newPickupObj).then (response) ->
      $scope.refreshPickupList()
      $scope.new_pickup_name = ''
      $scope.new_pickup_additionalInfo = ''
      $scope.new_canPickup = false

  $scope.editPickupContact = (contact) ->
    $scope.edit_canPickup = false
    if contact.CanPickup == 1 or contact.CanPickup == '1'
      $scope.edit_canPickup = true
      
    $scope.edit_pickup_name = contact.PickupName
    $scope.edit_additionalInfo = contact.AdditionalInfo
    $scope.edit_pickup_id = contact.ChildPickupId
    $scope.goToSubView('edit pickup')

  $scope.editPickupContactSubmit = () ->
    canPickup = '0'
    if $scope.edit_canPickup == true
      canPickup = '1'
      
    $scope.editPickupObj = 
      canPickup: canPickup
      name: $scope.edit_pickup_name
      additionalInfo: $scope.edit_additionalInfo
      childId: $scope.pickupList[0].ChildId
      childPickupId: $scope.edit_pickup_id

    ChildPickupService.updateChildPickupInfo($scope.editPickupObj).then (response) ->
      $scope.refreshPickupList()

  $scope.deletePickupContact = (contactId) ->
    ChildPickupService.deleteChildPickupListItem($rootScope.currentCenter.CenterId, contactId).then (response) ->
      $scope.refreshPickupList()

  $scope.refreshPickupList = () ->
    $scope.pickupList = null
    ChildPickupService.getAllChildPickupList($rootScope.currentCenter.FamilyId).then (response) ->
      $scope.pickupList = response.data
      $scope.goToSubView('pickup list breakdown')

  $scope.refreshAltContactList = () ->
    $scope.contacts = null
    $scope.isEdit = false
    $scope.goToSubView('alt contact personal information breakdown')
    ContactService.getAllContacts($rootScope.currentCenter.FamilyId).then (response) ->
      $scope.contacts = response.data
      
  $scope.isEditFunc = (isEdit) ->
    $scope.isEdit = isEdit

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    centerId = $rootScope.currentCenter.CenterId
    familyId = $rootScope.currentCenter.FamilyId
    customerId = $rootScope.currentCenter.CustomerId
   
    CenterInfoService.getCenterDetails(centerId).then (response) ->
      $scope.currentCenterDetails = response.data
      $scope.childrenClasses = []

      angular.forEach $scope.userChildren, (value, key) ->
        ChildService.getChildClass(value.ChildId).then (response) ->
          $scope.childrenClasses.push response.data

    AnnouncementsService.getAnnouncements(customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data

    GuardianService.getAllGuardians(familyId).then (response) ->
      $scope.guardians = response.data

    ContactService.getAllContacts(familyId).then (response) ->
      $scope.contacts = response.data

    ChildPickupService.getAllChildPickupList(familyId).then (response) ->
      $scope.pickupList = response.data
    