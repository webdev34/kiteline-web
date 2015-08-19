'use strict'
angular.module('kiteLineApp').controller 'FormsCtrl', ($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, AnnouncementsService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService, CreditCardService, Pagination) ->
  $rootScope.changePageTitle()
  $rootScope.startSpin()
  $rootScope.isLoginPage = false
  LogInService.isLoggedIn()

  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    centerId = $rootScope.currentCenter.CenterId
    familyId = $rootScope.currentCenter.FamilyId
    customerId = $rootScope.currentCenter.CustomerId
    
    CenterInfoService.getCenterDetails(centerId).then (response) ->
      $scope.currentCenterDetails = response.data

    CenterInfoService.getCenterFiles(centerId).then (response) ->
      $scope.currentCenterFiles = response.data
      $scope.currentCenterFilesPagination = Pagination.getNew(10)
      $scope.currentCenterFilesPagination.numPages = Math.ceil($scope.currentCenterFiles.length/$scope.currentCenterFilesPagination.perPage)
      $rootScope.stopSpin()
      