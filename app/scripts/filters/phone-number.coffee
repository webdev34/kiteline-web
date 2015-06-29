angular.module('kiteLineApp').filter('phonenumber', ->
  (number) ->
    if !number
      return ''
    number = String(number)
    # Will return formattedNumber. 
    # If phonenumber isn't longer than an area code, just show number
    formattedNumber = number
    # if the first character is '1', strip it out and add it back
    c = if number[0] == '1' then '1 ' else ''
    number = if number[0] == '1' then number.slice(1) else number
    # # (###) ###-#### as c (area) front-end
    area = number.substring(0, 3)
    front = number.substring(3, 6)
    end = number.substring(6, 10)
    if front
      formattedNumber = c + '(' + area + ') ' + front
    if end
      formattedNumber += '-' + end
    formattedNumber
).filter 'tel', ->
  (tel) ->
    if !tel
      return ''
    value = tel.toString().trim().replace(/^\+/, '')
    if value.match(/[^0-9]/)
      return tel
    country = undefined
    city = undefined
    number = undefined
    switch value.length
      when 10
        # +1PPP####### -> C (PPP) ###-####
        country = 1
        city = value.slice(0, 3)
        number = value.slice(3)
      when 11
        # +CPPP####### -> CCC (PP) ###-####
        country = value[0]
        city = value.slice(1, 4)
        number = value.slice(4)
      when 12
        # +CCCPP####### -> CCC (PP) ###-####
        country = value.slice(0, 3)
        city = value.slice(3, 5)
        number = value.slice(5)
      else
        return tel
    if country == 1
      country = ''
    number = number.slice(0, 3) + '-' + number.slice(3)
    (country + ' (' + city + ') ' + number).trim()