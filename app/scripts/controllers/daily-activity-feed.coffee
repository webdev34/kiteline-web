'use strict'
angular.module('kiteLineApp').controller 'DailyActivityFeedCtrl', ($scope, $rootScope, $filter, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService, DailyActivityFeedService) ->
  $rootScope.pageTitle = 'Daily Activity Feed'
  $rootScope.isLoginPage = false
  $scope.displayView = 'daily activity feed'
  $scope.showBreakDownView = false
  LogInService.isLoggedIn()
 
  $scope.goToFeedView = () ->
    $scope.displayView = 'daily activity feed'
    return

  $scope.goBackToFeeds = () ->
    $scope.showBreakDownView = false
    $scope.displayView = 'daily activity feed'
    return

  $scope.goToFeed = (feedId) ->
    $scope.showBreakDownView = true
    $scope.viewFeed = $filter('filter')($scope.dailyFeed, (d) -> d.FeedId == feedId)[0]
    return
  
  if StorageService.getItem('currentCenter')
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    
    centerId = $rootScope.currentCenter.CenterId
    familyId = $rootScope.currentCenter.FamilyId
    customerId = $rootScope.currentCenter.CustomerId
    
    CenterInfoService.getCenterDetails(centerId).then (response) ->
      $scope.currentCenterDetails = response.data
    
    CurbSideService.getAllChildren(centerId, familyId).then (response) ->
      $scope.userChildren = response.data
      $scope.childrenClasses = []

      angular.forEach $scope.userChildren, (value, key) ->
        ChildService.getChildClass(value.ChildId).then (response) ->
          $scope.childrenClasses.push response.data

    AnnouncementsService.getAnnouncements(customerId).then (response) ->
      $scope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $scope.announcements = response.data

    DailyActivityFeedService.getActivityFeed(familyId).then (response) ->
      $scope.dailyFeed = response.data

     
  return