'use strict'
angular.module('kiteLineApp').controller 'MainCtrl', ($filter, $scope, $rootScope, $location, StorageService, usSpinnerService, $window) ->
  $rootScope.pageTitle = ' '
  $rootScope.paymentGreaterThanAmount = false

  $rootScope.changePageTitle = () ->
    $rootScope.showLogOut = false
    if $location.$$path is '/dashboard'
      $rootScope.pageTitle = 'Kiteline Web - Dashboard'

    if $location.$$path is '/billing'
      $rootScope.pageTitle = 'Kiteline Web - Billing'

    if $location.$$path is '/'
      $rootScope.pageTitle = 'Kiteline Web'
      $rootScope.stopSpin()

    if $location.$$path is '/forms'
      $rootScope.pageTitle = 'Kiteline Web - Forms'

  $rootScope.startSpin = ->
    $rootScope.isLoading = true
    usSpinnerService.spin 'spinner-1'

  $rootScope.stopSpin = ->
    $rootScope.isLoading = false
    usSpinnerService.stop 'spinner-1'

  $rootScope.showLogOutFunc = () ->
    $rootScope.showLogOut = true

  $rootScope.logOut = () ->
    $rootScope.showLogOut = false
    StorageService.deleteLocalStorage();
    if window.location.href.indexOf('localhost') > -1
      $window.location.href = '/'
    else if window.location.href.indexOf('cloud') > -1
      $window.location.href = 'https://cloud.spinsys.com/skychildcare/kitelineweb/#/'
    else
      $window.location.href = 'https://uat.skychildcare.com/parentportal/#/'

  isNumeric = (n) ->
    !isNaN(parseFloat(n)) and isFinite(n)

  $rootScope.makeFloat = () ->
    if isNumeric(document.getElementById('payment-amount').value)
      document.getElementById('payment-amount').value = $filter('currency') document.getElementById('payment-amount').value, ''
    else
      if $rootScope.currentPaymentModal == 'Outstanding Balance'
        document.getElementById('payment-amount').value = $filter('currency') $rootScope.outstandingInvoicesDueTotal, ''
      else if $rootScope.currentPaymentModal = 'Single Invoice'
        document.getElementById('payment-amount').value = $filter('currency') $rootScope.viewInvoice.Amount, ''
      else
        document.getElementById('payment-amount').value = $filter('currency') $rootScope.viewInvoiceTotal, ''

  $rootScope.checkPaymentAmount = () ->
    $rootScope.paymentGreaterThanAmount = false
    paymentAmount = parseFloat document.getElementById('payment-amount').value 
    if $rootScope.currentPaymentModal == 'Outstanding Balance'
      outstandingBalance = parseFloat $rootScope.outstandingInvoicesDueTotal
      $rootScope.paymentAmount = parseFloat $rootScope.outstandingInvoicesDueTotal
    else if $rootScope.currentPaymentModal = 'Single Invoice'
      outstandingBalance = parseFloat $rootScope.viewInvoice.Amount
      $rootScope.paymentAmount = parseFloat $rootScope.viewInvoice.Amount
    else
      outstandingBalance = parseFloat $rootScope.viewInvoiceTotal
      $rootScope.paymentAmount = parseFloat 0.00
   
    if paymentAmount > outstandingBalance
      $rootScope.paymentGreaterThanAmount = true
      document.getElementById('payment-amount').value = $filter('currency') $rootScope.outstandingInvoicesDueTotal, '' 

  $rootScope.changePageTitle()

  if window.location.href.indexOf('localhost') > -1
    $rootScope.modalUrl = 'http://localhost:9000'
  else if window.location.href.indexOf('cloud') > -1
    $rootScope.modalUrl = 'https://cloud.spinsys.com/skychildcare/kitelineweb'
  else
    $rootScope.modalUrl = 'https://uat.skychildcare.com/parentportal'

  if window.location.href.indexOf('localhost') > -1 || window.location.href.indexOf('cloud') > -1
    $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/'
  else
    $rootScope.rootUrl = ' https://uat.skychildcare.com/services/KiteLine/V2.0/'

  $rootScope.footerYear = (new Date).getFullYear()

  $rootScope.isMobileFunc = () ->
    if sessionStorage.desktop
      return false
    else if localStorage.mobile
      return true
    # alternative
    mobile = [
      'iphone'
      'ipad'
      'android'
      'blackberry'
      'nokia'
      'opera mini'
      'windows mobile'
      'windows phone'
      'iemobile'
    ]
    for i of mobile
      if navigator.userAgent.toLowerCase().indexOf(mobile[i].toLowerCase()) > 0
        $rootScope.mobileType = mobile[i].toLowerCase()
        return true
    # nothing found.. assume desktop
    false

  $rootScope.isMobile = $rootScope.isMobileFunc()

  $rootScope.normalizeYear = (year) ->
    # Century fix
    YEARS_AHEAD = 20
    if year < 100
      nowYear = (new Date).getFullYear()
      year += Math.floor(nowYear / 100) * 100
      if year > nowYear + YEARS_AHEAD
        year -= 100
      else if year <= nowYear - 100 + YEARS_AHEAD
        year += 100
    year

  $rootScope.checkExp = (year) ->
    match = year.match(/^\s*(0?[1-9]|1[0-2])\/(\d\d|\d{4})\s*$/)
    if !match
      #alert 'Input string isn\'t match the expiration date format or date fragments are invalid.'
      return
    exp = new Date($rootScope.normalizeYear(1 * match[2]), 1 * match[1] - 1, 1).valueOf()
    now = new Date
    currMonth = new Date(now.getFullYear(), now.getMonth(), 1).valueOf()
    if exp <= currMonth
      return 'Expired'
    else
      return 'Valid'

  $rootScope.autocompleteHomeAddressCCPayment = () ->
    if $rootScope.paymentCC.autofillAddressCC is true
      $rootScope.paymentCC.BillingAddress = $rootScope.headOfHouseHold.Street
      $rootScope.paymentCC.BillingCity = $rootScope.headOfHouseHold.City
      $rootScope.paymentCC.BillingState = $rootScope.headOfHouseHold.State
      $rootScope.paymentCC.BillingZip = $rootScope.headOfHouseHold.Zip
      $rootScope.paymentCC.BusinessPhone = $rootScope.headOfHouseHold.HomePhone
    else
      $rootScope.paymentCC.BillingAddress = null
      $rootScope.paymentCC.BillingCity = null
      $rootScope.paymentCC.BillingState = null
      $rootScope.paymentCC.BillingZip = null
      $rootScope.paymentCC.BusinessPhone = null  
  

  $rootScope.bankAccountTypes = [
    {
      id: '1'
      name: 'Checking'
    }
    {
      id: '2'
      name: 'Savings'
    }
  ]

  $rootScope.creditCardAccountTypes = [
    {
      id: '3'
      name: 'CC - Visa'
    }
    {
      id: '4'
      name: 'CC - Mastercard'
    }
    {
      id: '5'
      name: 'CC - Discover'
    }
    {
      id: '6'
      name: 'CC - AMEX'
    }
  ]

  $rootScope.statesDropDown = [
    {
      name: 'Alabama'
      label: 'Alabama'
      abbreviation: 'AL'
    }
    {
      name: 'Alaska'
      label: 'Alaska'
      abbreviation: 'AK'
    }
    {
      name: 'Arizona'
      label: 'Arizona'
      abbreviation: 'AZ'
    }
    {
      name: 'Arkansas'
      label: 'Arkansas'
      abbreviation: 'AR'
    }
    {
      name: 'Armed Forces Europe'
      label: 'Armed Forces Europe'
      abbreviation: 'AE'
    }
    {
      name: 'Armed Forces Pacific'
      label: 'Armed Forces Pacific'
      abbreviation: 'AP'
    }
    {
      name: 'Armed Forces the Americas'
      label: 'Armed Forces the Americas'
      abbreviation: 'AA'
    }
    {
      name: 'California'
      label: 'California'
      abbreviation: 'CA'
    }
    {
      name: 'Colorado'
      label: 'Colorado'
      abbreviation: 'CO'
    }
    {
      name: 'Connecticut'
      label: 'Connecticut'
      abbreviation: 'CT'
    }
    {
      name: 'Delaware'
      label: 'Delaware'
      abbreviation: 'DE'
    }
    {
      name: 'District of Columbia'
      label: 'District of Columbia'
      abbreviation: 'DC'
    }
    {
      name: 'Florida'
      label: 'Florida'
      abbreviation: 'FL'
    }
    {
      name: 'Georgia'
      label: 'Georgia'
      abbreviation: 'GA'
    }
    {
      name: 'Hawaii'
      label: 'Hawaii'
      abbreviation: 'HI'
    }
    {
      name: 'Idaho'
      label: 'Idaho'
      abbreviation: 'ID'
    }
    {
      name: 'Illinois'
      label: 'Illinois'
      abbreviation: 'IL'
    }
    {
      name: 'Indiana'
      label: 'Indiana'
      abbreviation: 'IN'
    }
    {
      name: 'Iowa'
      label: 'Iowa'
      abbreviation: 'IA'
    }
    {
      name: 'Kansas'
      label: 'Kansas'
      abbreviation: 'KS'
    }
    {
      name: 'Kentucky'
      label: 'Kentucky'
      abbreviation: 'KY'
    }
    {
      name: 'Louisiana'
      label: 'Louisiana'
      abbreviation: 'LA'
    }
    {
      name: 'Maine'
      label: 'Maine'
      abbreviation: 'ME'
    }
    {
      name: 'Maryland'
      label: 'Maryland'
      abbreviation: 'MD'
    }
    {
      name: 'Massachusetts'
      label: 'Massachusetts'
      abbreviation: 'MA'
    }
    {
      name: 'Michigan'
      label: 'Michigan'
      abbreviation: 'MI'
    }
    {
      name: 'Minnesota'
      label: 'Minnesota'
      abbreviation: 'MN'
    }
    {
      name: 'Mississippi'
      label: 'Mississippi'
      abbreviation: 'MS'
    }
    {
      name: 'Missouri'
      label: 'Missouri'
      abbreviation: 'MO'
    }
    {
      name: 'Montana'
      label: 'Montana'
      abbreviation: 'MT'
    }
    {
      name: 'Nebraska'
      label: 'Nebraska'
      abbreviation: 'NE'
    }
    {
      name: 'Nevada'
      label: 'Nevada'
      abbreviation: 'NV'
    }
    {
      name: 'New Hampshire'
      label: 'New Hampshire'
      abbreviation: 'NH'
    }
    {
      name: 'New Jersey'
      label: 'New Jersey'
      abbreviation: 'NJ'
    }
    {
      name: 'New Mexico'
      label: 'New Mexico'
      abbreviation: 'NM'
    }
    {
      name: 'New York'
      label: 'New York'
      abbreviation: 'NY'
    }
    {
      name: 'North Carolina'
      label: 'North Carolina'
      abbreviation: 'NC'
    }
    {
      name: 'North Dakota'
      label: 'North Dakota'
      abbreviation: 'ND'
    }
    {
      name: 'Ohio'
      label: 'Ohio'
      abbreviation: 'OH'
    }
    {
      name: 'Oklahoma'
      label: 'Oklahoma'
      abbreviation: 'OK'
    }
    {
      name: 'Oregon'
      label: 'Oregon'
      abbreviation: 'OR'
    }
    {
      name: 'Pennsylvania'
      label: 'Pennsylvania'
      abbreviation: 'PA'
    }
    {
      name: 'Puerto Rico'
      label: 'Puerto Rico'
      abbreviation: 'PR'
    }
    {
      name: 'Rhode Island'
      label: 'Rhode Island'
      abbreviation: 'RI'
    }
    {
      name: 'South Carolina'
      label: 'South Carolina'
      abbreviation: 'SC'
    }
    {
      name: 'South Dakota'
      label: 'South Dakota'
      abbreviation: 'SD'
    }
    {
      name: 'Tennessee'
      label: 'Tennessee'
      abbreviation: 'TN'
    }
    {
      name: 'Texas'
      label: 'Texas'
      abbreviation: 'TX'
    }
    {
      name: 'Utah'
      label: 'Utah'
      abbreviation: 'UT'
    }
    {
      name: 'Vermont'
      label: 'Vermont'
      abbreviation: 'VT'
    }
    {
      name: 'Virgin Islands, U.S.'
      label: 'Virgin Islands, U.S.'
      abbreviation: 'VI'
    }
    {
      name: 'Virginia'
      label: 'Virginia'
      abbreviation: 'VA'
    }
    {
      name: 'Washington'
      label: 'Washington'
      abbreviation: 'WA'
    }
    {
      name: 'West Virginia'
      label: 'West Virginia'
      abbreviation: 'WV'
    }
    {
      name: 'Wisconsin'
      label: 'Wisconsin'
      abbreviation: 'WI'
    }
    {
      name: 'Wyoming'
      label: 'Wyoming'
      abbreviation: 'WY'
    }
  ]