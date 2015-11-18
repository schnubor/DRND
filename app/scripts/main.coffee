player = null
url = ''

newRecord = ->
    id = getRandomInt(1,999999)
    getRelease id
    $('.js-twitter, .js-link').removeClass('in').addClass('out')
    $('.js-skip').html '<i class="fa fa-refresh fa-spin"></i>'

showTwitterButton = (url) ->
    $('.js-twitter').attr 'href', 'https://twitter.com/intent/tweet?text=I+just+stumbled+into+this+tune+'+url+'+on&url=http%3A%2F%2Fdrnd.chko.org%2F&hashtags=drnd,randomtune'
    $('.js-twitter, .js-link').removeClass('out').addClass('in')
    $('.js-skip').html 'Next'

getRandomInt = (min, max) ->
    return Math.floor(Math.random() * (max - min + 1) + min)

getRelease = (id) ->
    $.ajax
        url: "http://api.discogs.com/releases/"+id
        dataType: "json"
        error: (jqXHR, textStatus, errorThrown) ->
            console.log 'Record not found -> Skip'
            newRecord()
        success: (data) ->
            # console.log data
            $('.js-title').text data.title
            $('.js-artist').text data.artists[0].name
            $('.js-link').attr 'href', data.uri

            if data.formats.length and data.year > 0
                $('.js-info').text data.formats[0].name + ', ' + data.year + ', ' + data.genres[0]
            else if data.year > 0
                $('.js-info').text data.year + ', ' + data.genres[0]
            else
                $('.js-info').text data.genres[0]

            if data.videos and data.videos.length
                player.loadVideoById(data.videos[0].uri.slice(-11), 0, 'large')
                url = data.videos[0].uri
            else
                console.log 'Record has no videos -> Skip'
                newRecord()

# Document Ready
##########################

$ ->
    # Youtube Init
    tag = document.createElement('script')
    tag.src = 'https://www.youtube.com/iframe_api'
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag
    player = undefined
    checkPlayer = undefined

# Events
##########################

$('.js-skip').click ->
    newRecord()

# Youtube
##########################

window.onYouTubeIframeAPIReady = ->
    player = new (YT.Player) 'player',
        events:
            'onReady': onPlayerReady
            'onStateChange': onPlayerStateChange
            'onError': onPlayerError
    newRecord()
    return

onPlayerStateChange = (event) ->
    if event.data is 0
        console.log 'Record played -> Next'
        newRecord()
    if event.data is 1
        console.log 'All good -> playing'
        showTwitterButton(url)

onPlayerReady = (event) ->
    console.log 'All ready -> Play'
    event.target.playVideo()

onPlayerError = (event) ->
    console.log 'Video blocked -> Skip!'
    newRecord()
