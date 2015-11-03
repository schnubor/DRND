getRandomInt = (min, max) ->
    return Math.floor(Math.random() * (max - min + 1) + min)

getRelease = (id) ->
    $.ajax
        url: "http://api.discogs.com/releases/"+id
        dataType: "json"
        error: (jqXHR, textStatus, errorThrown) ->
            console.log 'release not found, retrying'
            newId = getRandomInt(1,999999)
            getRelease(newId)
        success: (data) ->
            console.log data
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
                $('.js-video').html '<iframe width="100%" src="https://www.youtube.com/embed/' + data.videos[0].uri.slice(-11) + '?autoplay=1" frameborder="0" allowfullscreen></iframe>'
            else
                console.log 'no videos, retrying'
                newId = getRandomInt(1,999999)
                getRelease(newId)

# Document Ready

$ ->
    id = getRandomInt(1,999999)
    console.log id
    getRelease id

# Events

$('.js-skip').click ->
    id = getRandomInt(1,999999)
    getRelease id
    

