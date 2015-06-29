'use strict'
angular.module('kiteLineApp').controller 'MessagesCtrl', ($scope, $rootScope, $filter, $routeParams, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService) ->
  $rootScope.pageTitle = 'Messages'
  $rootScope.isLoginPage = false
  $scope.displayView = 'messages'
  $scope.showBreakDownView = false
  LogInService.isLoggedIn()
 
  $scope.goToMessagesView = () ->
    $scope.displayView = 'messages'

  $scope.goBackToMessages = () ->
    $scope.showBreakDownView = false
    $scope.displayView = 'messages'

  $scope.goToMessage = (messageId) ->
    $scope.showBreakDownView = true
    $scope.viewMessage = $filter('filter')($scope.announcements, (d) -> d.MessageId == messageId)[0]

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

      if $routeParams.messageId
        $scope.goToMessage(parseInt($routeParams.messageId))