player = null

getRandomInt = (min, max) ->
    return Math.floor(Math.random() * (max - min + 1) + min)

getRelease = (id) ->
    $.ajax
        url: "http://api.discogs.com/releases/"+id
        dataType: "json"
        error: (jqXHR, textStatus, errorThrown) ->
            console.log 'Record not found -> Skip!'
            newId = getRandomInt(1,999999)
            getRelease(newId)
        success: (data) ->
            # console.log data
            $('.js-title').text data.title
            $('.js-artist').text data.artists[0].name
            if data.formats.length and data.year > 0
                $('.js-info').text data.formats[0].name + ', ' + data.year + ', ' + data.genres[0]
            else if data.year > 0
                $('.js-info').text data.year + ', ' + data.genres[0]
            else
                $('.js-info').text data.genres[0]
            $('.js-link').attr 'href', data.uri
            if data.videos and data.videos.length
                player.loadVideoById(data.videos[0].uri.slice(-11), 0, 'large')
            else
                console.log 'Record has no videos -> Skip!'
                newId = getRandomInt(1,999999)
                getRelease(newId)

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
    id = getRandomInt(1,999999)
    getRelease id

# Youtube
##########################

window.onYouTubeIframeAPIReady = ->
    player = new (YT.Player) 'player',
        events:
            'onReady': onPlayerReady
            'onStateChange': onPlayerStateChange
            'onError': onPlayerError
    id = getRandomInt(1,999999)
    getRelease id
    return

onPlayerStateChange = (event) ->
    if event.data is 0
        console.log 'Record played -> Next!'
        id = getRandomInt(1,999999)
        getRelease id

onPlayerReady = (event) ->
    console.log 'All ready -> Play!'
    event.target.playVideo()

onPlayerError = (event) ->
    console.log 'Video blocked -> Skip!'
    id = getRandomInt(1,999999)
    getRelease id
