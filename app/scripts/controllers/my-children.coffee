'use strict'
angular.module('kiteLineApp').controller 'MyChildrenCtrl', ($scope, $rootScope, $routeParams, $filter, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService) ->
  $rootScope.pageTitle = 'My Children'
  $rootScope.isLoginPage = false
  $scope.displayView = 'my children'
  $scope.showBreakDownView = false
  $scope.showItemsMenu = false
  $scope.showDetailedMenu = false
  $scope.isEdit = false
  $scope.displaySubView = ''

  LogInService.isLoggedIn()
 
  $scope.goToMyChildrenView = () ->
    $scope.displayView = 'my children'

  $scope.goBackToSubView = (subView) ->
    $scope.displaySubView = subView

  $scope.goBackToMyChildren = () ->
    $scope.showBreakDownView = false
    $scope.showDetailedMenu = false
    $scope.displayView = 'my children'
    $scope.displaySubView = ''

  $scope.goToChild = (childId) ->
    $scope.showBreakDownView = false
    $scope.showDetailedMenu = true
    $scope.displayView = 'child selected'
    $scope.displaySubView = ''
    $scope.viewChild = $filter('filter')($scope.userChildren, (d) -> d.ChildId == childId)[0]
    $scope.viewChildMedicalInfo = $filter('filter')($scope.childrenMedicalInfo, (d) -> d.ChildId == childId)[0]
    $scope.viewChildGeneralInfo = $filter('filter')($scope.childrenGenInfo, (d) -> d.ChildId == childId)[0]
    $scope.viewChildHistoryInfo = $filter('filter')($scope.childrenHistoryInfo, (d) -> d.ChildId == childId)[0]

  $scope.goToChildOnLoad = (childId) ->
    $scope.showBreakDownView = false
    $scope.showDetailedMenu = true
    $scope.displayView = 'child selected'
    $scope.displaySubView = ''
    $scope.viewChild = $filter('filter')($scope.userChildren, (d) -> d.ChildId == childId)[0]

    ChildService.getChildGenInfo(childId).then (response) ->
      $scope.viewChildGeneralInfo = response.data

      ChildService.getChildMedInfo(childId).then (response) ->
        $rootScope.viewChildMedicalInfo = response.data

        ChildService.getChildHistory(childId).then (response) ->
          $scope.viewChildHistoryInfo = response.data

  $scope.goToMedicine = (medicineObj) ->
    $scope.showBreakDownView = true
    $scope.showItemsMenu = true
    $scope.displaySubView = 'medication breakdown'
    $scope.viewMedicine = medicineObj

    currentDate = new Date();
    currentDate = $filter('date')(currentDate,"M/d/yyyy")
    expirationDate = $filter('date')(medicineObj.Expiration,"M/d/yyyy")
    diffDate = $filter('amDifference')(expirationDate, currentDate)
    $scope.expirationDate = diffDate / (1000*60*60*24)

  $scope.goToAllergy = (allergyObj) ->
    $scope.showBreakDownView = true
    $scope.showItemsMenu = true
    $scope.displaySubView = 'allergy breakdown'
    $scope.viewAllergy = allergyObj

# SUB MENUS
  $scope.goToSubMenu = (displaySubViewTitle) ->
    $scope.showBreakDownView = true
    $scope.showItemsMenu = true
    $scope.displaySubView = displaySubViewTitle

# MAIN MENUS
  $scope.goToMainMenu = (displayView, displaySubView) ->
    $scope.showBreakDownView = true
    $scope.showItemsMenu = true
    $scope.displayView = displayView
    $scope.displaySubView = displaySubView

  $scope.goToMedicalInfoView = () ->
    $scope.showBreakDownView = true
    $scope.showItemsMenu = true
    $scope.displayView = 'medical info'
    $scope.displaySubView = 'medical info breakdown'

    ChildService.getMedications($scope.viewChild.ChildId).then (response) ->
      $scope.viewChildMedicineInfo = response.data

    ChildService.getAllergies($scope.viewChild.ChildId).then (response) ->
      $scope.viewChildAllergiesInfo = response.data

  $scope.addNewMedication = () ->
    $scope.displaySubView = 'add new medication'
  
  $scope.addNewAllergy = () ->
    $scope.displaySubView = 'add new allergy'

  $scope.editGenInfoContact = (contact) ->
    $scope.viewChildGeneralInfoEdit = angular.copy($scope.viewChildGeneralInfo)
    $scope.edit_enroll_status = false
    if $scope.viewChildGeneralInfoEdit.EnrollmentStatus == 'E'
      $scope.edit_enroll_status = true

    $scope.edit_photo_video_auth = false
    if $scope.viewChildGeneralInfoEdit.PhotoVideoAuthorization == 'Y'
      $scope.edit_photo_video_auth = true
    $scope.viewChildGeneralInfoEdit.DOB = $filter('date')($scope.viewChildGeneralInfoEdit.DOB)

  $scope.editGenInfoContactSubmit = () ->
    $scope.viewChildGeneralInfoEdit.EnrollmentStatus = "E"
    if $scope.edit_enroll_status != true
      $scope.viewChildGeneralInfoEdit.EnrollmentStatus = 'I'
      
    $scope.viewChildGeneralInfoEdit.PhotoVideoAuthorization = 'N'
    if $scope.edit_photo_video_auth == true
      $scope.viewChildGeneralInfoEdit.PhotoVideoAuthorization = 'Y'

    ChildService.updateChildGenInfo($scope.viewChildGeneralInfoEdit).then (response) ->
      $scope.getChildrenData().then (response) ->
        $scope.goToChildOnLoad($scope.viewChild.ChildId)
        $scope.isEditFunc(false) 

  $scope.editChildHistory = () ->
    $scope.viewChildHistoryInfoEdit = angular.copy($scope.viewChildHistoryInfo)

  $scope.editChildHistorySubmit = () ->
    ChildService.updateChildHistory($scope.viewChildHistoryInfoEdit).then (response) ->
      $scope.getChildrenData().then (response) ->
        $scope.goToChildOnLoad($scope.viewChild.ChildId)
        $scope.isEditFunc(false) 

  $scope.isEditFunc = (isEdit) ->
    $scope.isEdit = isEdit

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
      $rootScope.announcementCount = response.data.length

      if $routeParams.childId
        $scope.goToChildOnLoad(parseInt($routeParams.childId))
     
