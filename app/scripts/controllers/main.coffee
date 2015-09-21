'use strict'
angular.module('kiteLineApp').controller 'MainCtrl', ($filter, $scope, $rootScope, $location, StorageService, CenterInfoService, PaymentService, AnnouncementsService, CreditCardService, InvoiceDetailService, InvoiceService, GuardianService, AccountService, usSpinnerService, $window, ngDialog, Pagination) ->
  
  if window.location.href.indexOf('localhost') > -1 || window.location.href.indexOf('cloud') > - 1
    $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/'
  else if window.location.href.indexOf('parent') > - 1
    $rootScope.rootUrl = 'https://app.skychildcare.com/services/kiteline/v2.0/'
  else
    $rootScope.rootUrl = ' https://uat.skychildcare.com/services/KiteLine/V2.0/'

  if window.location.href.indexOf('localhost') > - 1
    $rootScope.modalUrl = 'http://localhost:9000'
  else if window.location.href.indexOf('cloud') > - 1
    $rootScope.modalUrl = 'https://cloud.spinsys.com/skychildcare/kitelineweb'
  else if window.location.href.indexOf('parent') > - 1
    $rootScope.modalUrl = 'https://parent.skychildcare.com'
  else
    $rootScope.modalUrl = 'https://uat.skychildcare.com/parentportal'

  $rootScope.isTablet = false
  $rootScope.pageTitle = ' '
  $rootScope.paymentGreaterThanAmount = false
  $rootScope.processingPayment = false
  $rootScope.paymentAmount = 0
  $rootScope.paymentMSG = null
  $rootScope.newCC = {}
  $rootScope.newCC.AccountName = null
  $rootScope.paymentCC = {}
  $rootScope.paymentCC.AccountName = null
  $rootScope.expireDates = {}
  $rootScope.expireDatesPayment = {}
  $rootScope.currentPaymentModal = null
  $rootScope.processingPayment = null
  $rootScope.matchingBankAccount = false
  $rootScope.PartialPaymentsMade = null
  $rootScope.matchingRoutingNum = false
  $rootScope.addCreditCardFromModal = false
  $rootScope.addCreditCard = false
  $rootScope.reverse = false
  $rootScope.sortOrderBy = 'PaymentDate'
  $rootScope.invoiceGrandTotal = 0
  $rootScope.invoicesArray = []

  d = new Date
  $scope.billDates = {}
  $scope.billDates.transactionStartDate = new Date((new Date).setDate((new Date).getDate() - 30))
  $scope.billDates.transactionStartDate = $filter('date')($scope.billDates.transactionStartDate, 'M/d/yyyy')
  $scope.billDates.historicalStartDate = $scope.billDates.transactionStartDate
  $scope.billDates.transactionEndDate = [
    d.getMonth() + 1
    d.getDate()
    d.getFullYear()
  ].join('/')
  $scope.billDates.historicalEndDate = $scope.billDates.transactionEndDate
  $scope.billDates.querying = false
  $scope.billDates.queryingHistorical = false
  $scope.noResults = false
  $scope.noResultsInvoices = false
  $scope.invoiceGrandTotal = 0
  $scope.defaultCC = null

  $rootScope.changePageTitle = () ->
    if $location.$$path is '/dashboard'
      $rootScope.pageTitle = 'Dashboard'
      document.title = 'Kiteline Web - Dashboard'

    if $location.$$path is '/billing' || $location.$$path is '/billing/invoices' || $location.$$path is '/billing/payment-accounts'
      $rootScope.pageTitle = 'Billing'
      document.title = 'Kiteline Web - Billing'

    if $location.$$path is '/'
      $rootScope.pageTitle = 'Kiteline Web'
      document.title = 'Kiteline Web - Log In'
      $rootScope.stopSpin()

    if $location.$$path is '/forms'
      $rootScope.pageTitle = 'Forms'
      document.title = 'Kiteline Web - Forms'

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
    StorageService.deleteLocalStorage() ;
    if window.location.href.indexOf('localhost') > - 1
      $window.location.href = '/'
    else if window.location.href.indexOf('cloud') > - 1
      $window.location.href = 'https://cloud.spinsys.com/skychildcare/kitelineweb/#/'
    else if window.location.href.indexOf('parent') > - 1
      $window.location.href = 'https://parent.skychildcare.com/#/'
    else
      $window.location.href = 'https://uat.skychildcare.com/parentportal/#/'

  $rootScope.sortByFunc = (sortBy, reverse) ->
    $rootScope.sortOrderBy = sortBy
    $rootScope.reverse = reverse

  isNumeric = (n) ->
    !isNaN(parseFloat(n) ) and isFinite(n)

  $rootScope.makeFloat = () ->
    if isNumeric(document.getElementById('payment-amount').value)
      document.getElementById('payment-amount').value = $filter('currency') document.getElementById('payment-amount').value, ''
    else
      if $rootScope.currentPaymentModal == 'Outstanding Balance'
        document.getElementById('payment-amount').value = $filter('currency') $rootScope.outstandingInvoicesDueTotal, ''
      else
        document.getElementById('payment-amount').value = $filter('currency') $rootScope.viewInvoice.DueAmount, ''

  $rootScope.checkPaymentAmount = (fromModal) ->
    $rootScope.paymentGreaterThanAmount = false
    paymentAmount = parseFloat document.getElementById('payment-amount').value
    if $rootScope.currentPaymentModal == 'Outstanding Balance'
      outstandingBalance = parseFloat $rootScope.outstandingInvoicesDueTotal
      $rootScope.paymentAmount = parseFloat $rootScope.outstandingInvoicesDueTotal
      trueTotal = outstandingBalance
    else
      outstandingBalance = parseFloat $rootScope.viewInvoice.DueAmount
      $rootScope.paymentAmount = parseFloat $rootScope.viewInvoice.DueAmount
      trueTotal = outstandingBalance

    if paymentAmount > outstandingBalance
      document.getElementById('payment-amount').blur()
      # document.getElementById('payment-amount').value = $filter('currency') trueTotal, ''
      $rootScope.paymentGreaterThanAmount = true

  $rootScope.paymentCleared = () ->
    $rootScope.processingPayment = false
    $rootScope.getTransactionsByDate(null)
    $rootScope.getTransactionsByDate('Historical')
    $rootScope.getInvoiceData()
    $rootScope.stopSpin()
    $rootScope.resetAccountForm('CC Payment')

  $rootScope.paymentClearedDashboard = () ->
    $rootScope.processingPayment = false
    $rootScope.getInvoiceData()
    $rootScope.resetAccountForm('CC Payment')

  $rootScope.processPayment = (accountId, invoiceId) ->
    $rootScope.processingPayment = true
    if !invoiceId
      invoiceId = 0
    if $rootScope.addCreditCardFromModal

      thisYear = String($rootScope.expireDatesPayment.year)
      thisYear = thisYear[2] + thisYear[3]
      $rootScope.paymentCC.ExpirationDate = $rootScope.expireDatesPayment.month + '/' + thisYear
      if $rootScope.paymentCC.ExpirationDate.length == 4
        $rootScope.paymentCC.ExpirationDate = "0" + $rootScope.paymentCC.ExpirationDate

      if $rootScope.paymentCC.RecurringAccount is true
        $rootScope.submitNewAccount('CC Payment', '')
      else
        PaymentService.makePaymentWithCC($rootScope.currentCenter.FamilyId, $rootScope.currentCenter.CenterId, invoiceId, $rootScope.currentCenter.CustomerId, $rootScope.paymentCC).then (response) ->
          $rootScope.paymentMSG = response.data
          if $rootScope.currentPaymentModal == 'Outstanding Balance'
            $rootScope.paymentClearedDashboard()
          else
            $rootScope.paymentCleared()
    else
      PaymentService.makePaymentWithAccountId(accountId, $rootScope.currentCenter.CustomerId, invoiceId).then (response) ->
        $rootScope.paymentMSG = response.data
        if $rootScope.currentPaymentModal == 'Outstanding Balance'
          
          $rootScope.paymentClearedDashboard()
        else
          $rootScope.paymentCleared()

  $rootScope.payOutstandingBalance = ->
    $rootScope.resetAccountForm('CC Payment')
    $rootScope.currentPaymentModal = 'Outstanding Balance'
    $rootScope.paymentAmount = $rootScope.outstandingInvoicesDueTotal.toFixed 2
    $rootScope.paymentMSG = null
    ngDialog.open template: $rootScope.modalUrl + '/views/modals/pay-outstanding-balance.html'

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
      form.$setPristine() ;

  $rootScope.submitNewAccount = (type, form) ->
    if type == 'CC'
      thisYear = String($rootScope.expireDates.year)
      thisYear = thisYear[2] + thisYear[3]
      $rootScope.newCC.ExpirationDate = $rootScope.expireDates.month + '/' + thisYear
      if $rootScope.newCC.ExpirationDate.length == 4
        $rootScope.newCC.ExpirationDate = "0" + $rootScope.newCC.ExpirationDate
      CreditCardService.addCreditCard($rootScope.newCC).then (response) ->
        $rootScope.getPaymentAccounts()
        $scope.resetAccountForm('CC', form)
    else if type == 'CC Payment' and $rootScope.paymentCC.saveAccount
      thisYear = String($rootScope.expireDatesPayment.year)
      thisYear = thisYear[2] + thisYear[3]
      $rootScope.paymentCC.ExpirationDate = $rootScope.expireDatesPayment.month + '/' + thisYear
      if $rootScope.paymentCC.ExpirationDate.length == 4
        $rootScope.paymentCC.ExpirationDate = "0" + $rootScope.paymentCC.ExpirationDate

      CreditCardService.addCreditCard($rootScope.paymentCC).then (response) ->
        $rootScope.getPaymentAccounts()
        accountId = response.data
        $scope.resetAccountForm('CC Payment', form)
    else
      AccountService.createAccount($rootScope.newBankAccount).then (response) ->
        if response.statusText is 'OK'
          $rootScope.addBankAccount = false
          $rootScope.getPaymentAccounts()
          $scope.resetAccountForm('Bank', form)

  $rootScope.resetAccountForm = (type, form) ->
      $rootScope.paymentGreaterThanAmount = false
      if type == 'CC'
        $rootScope.addCreditCard = false
        $rootScope.newCC = {}
        $rootScope.newCC.PayerEmail = ''
        $rootScope.expireDates = {}
        $rootScope.expireDates.month = ''
        $rootScope.expireDates.year = ''

      else if type == 'CC Payment'
        $rootScope.addCreditCardFromModal = false
        $rootScope.activePaymentAccount = false
        $rootScope.paymentCC = {}
        $rootScope.paymentCC.PayerEmail = ''
        $rootScope.expireDatesPayment = {}
        $rootScope.expireDatesPayment.month = ''
        $rootScope.expireDatesPayment.year = ''

      else
        $rootScope.addBankAccount = false
        $rootScope.newBankAccount = {}
        $rootScope.newBankAccount.PayerEmail = ''

      if form
        form.$setPristine() ;

  $rootScope.getPaymentAccounts = (familyId, centerId) ->
    $rootScope.getCCAccounts(familyId, centerId)
    $rootScope.getBankAccounts()
    $rootScope.setDefaultAccount()

  $rootScope.getCCAccounts = (familyId, centerId) ->
    CreditCardService.getCreditCardAccounts($rootScope.subscriberId, $rootScope.customerId).then (response) ->
      $rootScope.creditCardAccounts = response.data
      $rootScope.creditCardAccountsPagination = Pagination.getNew()
      $rootScope.creditCardAccountsPagination.numPages = Math.ceil($rootScope.creditCardAccounts.length / $scope.creditCardAccountsPagination.perPage)
      $rootScope.setDefaultAccount()

  $rootScope.getBankAccounts = () ->
    AccountService.getAccounts($rootScope.familyId, $rootScope.centerId).then (response) ->
      $rootScope.bankAccounts = response.data
      $scope.setPagination()
      $rootScope.setDefaultAccount()

  $rootScope.setDefaultAccount = () ->
    $rootScope.defaultAccount = null
    angular.forEach $rootScope.bankAccounts, (value, key) ->
      if value.RecurringAccount == true
        $rootScope.defaultAccount = value

    angular.forEach $rootScope.creditCardAccounts, (value, key) ->
      if value.RecurringAccount == true
        $rootScope.defaultAccount = value

  $scope.deleteDefaultAccount = () ->
    AccountService.deleteActiveAccount($rootScope.subscriberId, $rootScope.customerId).then (response) ->
      $rootScope.defaultAccount = null

  $rootScope.setDefaultCCAccount = (account) ->
    if account.RecurringAccount == false
      $scope.deleteDefaultAccount()
    else
      CreditCardService.setDefaultCreditCard($rootScope.subscriberId, $rootScope.customerId, account.AccountId).then (response) ->
        $rootScope.getPaymentAccounts()

  $scope.setDefaultBankAccount = (account) ->
    if account.RecurringAccount == false
      $scope.deleteDefaultAccount()
    else
      AccountService.setActiveAccount($rootScope.familyId, $rootScope.centerId, account.AccountId).then (response) ->
        $rootScope.getPaymentAccounts()

  $scope.viewInvoiceHistoryCheck = (invoice) ->
    PaymentService.getPartialPaymentsByInvoiceId($rootScope.customerId, invoice.InvoiceId, $rootScope.centerId).then (response) ->
      if response.data.length == 0
        invoice.hasHistory = false
      else
        invoice.hasHistory = true

  $scope.viewInvoiceHistory = (invoice) ->  
    $rootScope.paymentMSG = null
    $rootScope.viewInvoiceHistoryDueAmount  = invoice.DueAmount
    $rootScope.viewInvoiceHistoryAmountBilled = invoice.TotalAmount
    $rootScope.viewInvoiceHistoryDate = invoice.CreatedOn
    PaymentService.getPartialPaymentsByInvoiceId($rootScope.customerId, invoice.InvoiceId, $rootScope.centerId).then (response) ->
      $rootScope.PartialPaymentsMade = response.data
      ngDialog.open template: $rootScope.modalUrl+'/views/modals/invoice-history.html' 

  $rootScope.getInvoiceData = () ->
    InvoiceService.getOutstandingInvoices($rootScope.customerId).then (response) ->
      $rootScope.outstandingInvoices = response.data
      $rootScope.outstandingInvoicesDueTotal = 0
      $rootScope.outstandingInvoicesTotal = 0
      $scope.outstandingBalance = 0

      angular.forEach $rootScope.outstandingInvoices, (value, key) ->
        $scope.viewInvoiceHistoryCheck(value)
        $rootScope.outstandingInvoicesDueTotal += value.DueAmount
        $rootScope.outstandingInvoicesTotal += value.TotalAmount
        InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then (response) ->

          if response.data.length == 1
            $rootScope.invoicesArray.push response.data[0]
            $scope.invoiceGrandTotal = $scope.invoiceGrandTotal + response.data[0].Amount
            $scope.outstandingBalance = $scope.invoiceGrandTotal

          else
            arrayHolder = []
            angular.forEach response.data, (value, key) ->
              arrayHolder.push value
              $scope.invoiceGrandTotal = $scope.invoiceGrandTotal + value.Amount
              $scope.outstandingBalance = $scope.invoiceGrandTotal

            $rootScope.invoicesArray.push arrayHolder

  $rootScope.invoicesArrayed = () ->
    $rootScope.arrayOfinvoicesHolder = []
    $rootScope.arrayOfinvoices = []

    angular.forEach $rootScope.invoicesArray, (value, key) ->
      if value instanceof Array
        $rootScope.arrayOfinvoicesHolder.push value[0]
      else
        $rootScope.arrayOfinvoicesHolder.push value

    $rootScope.arrayOfinvoicesHolder = $filter('orderBy')($rootScope.arrayOfinvoicesHolder, 'CreatedOn', true)

    angular.forEach $rootScope.arrayOfinvoicesHolder, (value, key) ->
      $rootScope.arrayOfinvoices.push value.InvoiceId

  $rootScope.getUserData = () ->
    $rootScope.currentCenter = StorageService.getItem('currentCenter')
    console.log $rootScope.currentCenter
    $rootScope.currentUserEmail = StorageService.getItem('userEmail')
    $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken')
    $rootScope.LastLoginInfo = StorageService.getItem('LastLoginInfo')
    $rootScope.centerId = $rootScope.currentCenter.CenterId
    $rootScope.familyId = $rootScope.currentCenter.FamilyId
    $rootScope.customerId = $rootScope.currentCenter.CustomerId
    $rootScope.showLogOut = false

    CenterInfoService.getCenterDetails($rootScope.centerId).then (response) ->
      console.log response.data
      $rootScope.currentCenterDetails = response.data
      $rootScope.subscriberId = response.data.SubscriberId

  $rootScope.getMessages = () ->
    AnnouncementsService.getAnnouncements($rootScope.customerId).then (response) ->
      $rootScope.announcements = null
      $rootScope.announcementCount = response.data.length

      if $rootScope.announcementCount > 0
        $rootScope.announcements = response.data

  $rootScope.getGuardianData = () ->
    GuardianService.getAllGuardians($rootScope.familyId).then (response) ->
      $rootScope.guardians = response.data
      $rootScope.guardiansPagination = Pagination.getNew()
      $rootScope.guardiansPagination.numPages = Math.ceil($rootScope.guardians.length / $rootScope.guardiansPagination.perPage)

      GuardianService.getGuardian($rootScope.guardians[0].GuardianId).then (response) ->
        $rootScope.headOfHouseHold = response.data

  $scope.getPastPayments = () ->
    PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId).then (response) ->
      $scope.pastTransactions  = response
      $scope.setPagination()


  $rootScope.getTransactionsByDate = (type) ->
    if type == 'Historical'
      $scope.noResultsInvoices = false
      InvoiceService.getPaidInvoicesByDate($rootScope.currentCenter.CustomerId, $scope.billDates.historicalStartDate, $scope.billDates.historicalEndDate).then (response) ->
        $scope.historicalTransactions  = response.data
        $scope.historicalTransactionsTotal = 0
        $scope.billDates.queryingHistorical = false
    
        angular.forEach $scope.historicalTransactions, (value, key) ->
          $scope.historicalTransactionsTotal += value.TotalAmount

        if $scope.historicalTransactions.length == 0
          $scope.noResultsInvoices = true
        else
          $scope.setPagination()

    else
      $scope.noResults = false
      PaymentService.getPastPaymentsByDate($rootScope.currentCenter.CustomerId, $scope.billDates.transactionStartDate, $scope.billDates.transactionEndDate).then (response) ->
        $scope.pastTransactions  = response.data
        $scope.billDates.querying = false

        if $scope.pastTransactions.length == 0
          $scope.noResults = true
        else
          $scope.setPagination()

  $scope.setPagination = () ->
    if $scope.pastTransactions
      $scope.pastTransactionsPagination = Pagination.getNew(10)
      $scope.pastTransactionsPagination.numPages = Math.ceil($scope.pastTransactions.length / $scope.pastTransactionsPagination.perPage)
    if $scope.historicalTransactions
      $scope.historicalTransactionsPagination = Pagination.getNew(10)
      $scope.historicalTransactionsPagination.numPages = Math.ceil($scope.historicalTransactions.length / $scope.historicalTransactionsPagination.perPage)
    if $rootScope.outstandingInvoices
      $rootScope.outstandingInvoicesPagination = Pagination.getNew(10)
      $rootScope.outstandingInvoicesPagination.numPages = Math.ceil($rootScope.outstandingInvoices.length / $rootScope.outstandingInvoicesPagination.perPage)
    if $rootScope.bankAccounts
      $rootScope.bankAccountsPagination = Pagination.getNew()
      $rootScope.bankAccountsPagination.numPages = Math.ceil($rootScope.bankAccounts.length / $scope.bankAccountsPagination.perPage)
    if $rootScope.creditCardAccounts
      $rootScope.creditCardAccountsPagination = Pagination.getNew()
      $rootScope.creditCardAccountsPagination.numPages = Math.ceil($rootScope.creditCardAccounts.length / $scope.creditCardAccountsPagination.perPage)


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
      if navigator.userAgent.toLowerCase().indexOf(mobile[i].toLowerCase() ) > 0
        if mobile[i] != 'ipad'
          $rootScope.mobileType = mobile[i].toLowerCase()
          return true
        else
          $rootScope.isTablet = true

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
    if typeof year == 'undefined'
      return 'Bank'
    else
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

  $rootScope.footerYear = (new Date).getFullYear()

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