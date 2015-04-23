'use strict'

# handling all keyboard actions
define ["jquery", "underscore", 'modules/utils', 'modules/controllers/base_controller', 'modules/dom_manipulation', 'modules/models/list', 'modules/models/movie'], ($, _, Utils, BaseController, DomManipulation, List, Movie) ->

    # Manages navigation on grid-like pages
    class GridController extends BaseController

        constructor: (HTMLSelectors) ->
            super
            @HTML = HTMLSelectors

            @lists = $ @HTML.lists

            # setting first list and movie
            @_updateList 0
            @_updateMovie 0

            # register resize to row measurement
            $(window).resize @_getRowSize
            # bind mouse hover to movie navigation
            $(@HTML.movies).mouseover @mouseMove

        doAction: (action) =>
            switch action
                when @ACTIONS.LEFT   then @left()
                when @ACTIONS.RIGHT  then @right()
                when @ACTIONS.UP     then @up()
                when @ACTIONS.DOWN   then @down()
                when @ACTIONS.OK     then @confirm()
                when @ACTIONS.CANCEL then @cancel()
                else null

        # measuring how many movies in a row, and how much is in last row
        _getRowSize: (event) =>
            @RowSize = 0
            for movie in @movies
                if $(movie).prev().length > 0 and
                $(movie).position().top isnt $(movie).prev().position().top
                    break
                @RowSize++

            @LastRowSize = if @movies.length % @RowSize is 0 then @RowSize else @movies.length % @RowSize

        left  : => @gridMove -1,  0
        up    : => @gridMove  0, -1
        down  : => @gridMove  0,  1
        right : => @gridMove  1,  0

        # navigate to hoverd list and movie, running over previous list/movie
        mouseMove: (e) =>
            setTimeout =>
                newMovie = e.delegateTarget
                # if hovering already active movie
                return false if not $(newMovie).hasClass @HTML.movieClass.substr 1

                # get the index of the selected movie
                newListIndex  = if $(newMovie).parents(@HTML.lists) then Utils.getObjectKeyInArray @lists, $(newMovie).parents(@HTML.lists)[0]  else @listIndex
                @_updateList newListIndex

                # get the index of the selected movie
                newMovieIndex = Utils.getObjectKeyInArray @movies, newMovie
                @_updateMovie newMovieIndex

                true
            , 0
            true

        # navigating on lists/movies grid, one movie at-the-time
        # calculating if next movie is in a current/previous/next list
        gridMove: (x, y) =>

            # if user movement was vertical or horizontal
            if y is 0
                axis = 'horizontal'
                newMovieIndex = @movieIndex+x
            else if x is 0
                axis = 'vertical'
                newMovieIndex = @movieIndex+(@RowSize*y)

            # if new selected movie is with list boundries:
            if @movies[newMovieIndex] then @_updateMovie newMovieIndex
            else

                # when user moved right/down (next)
                if @movies.length-1 < newMovieIndex and @lists[@listIndex+1]? # if no more movies and there's a next list
                    newMovieIndex = @_nextList axis

                # when user moved left/up (previous)
                else if newMovieIndex < 0 and @lists[@listIndex-1]? # if new movie is negative and there's a prev list
                    newMovieIndex = @_prevList axis

                # when user went to next list but there's no next list OR vice versa
                else return false

                @_updateMovie newMovieIndex
                true

        # updating to next list if needed
        # calculating the new movie index and returning it
        _nextList: (axis) =>
            if axis is 'horizontal'
                newMovieIndex = 0 # first movie
                @_updateList @listIndex+1
            else if axis is 'vertical'
                if @movieIndex in [0..@movies.length-1][-@LastRowSize..] # if movie is part of last row
                    newMovieIndex = @movieIndex % @RowSize # get movie location in last row
                    @_updateList @listIndex+1
                else
                    newMovieIndex = @movies.length-1 # go to last movie in the current list
            newMovieIndex

        # updating to prev list
        # calculating the new movie index and returning it
        _prevList: (axis) =>
            @_updateList @listIndex-1
            if axis is 'horizontal'
                newMovieIndex = @movies.length-1 # last movie
            else if axis is 'vertical'
                if @LastRowSize-1 >= @movieIndex
                    newMovieIndex = [0..@movies.length-1][-@LastRowSize..][@movieIndex] # prev row in the same movie-in-a-row position as the current movie
                else
                    newMovieIndex = @movies.length-1 # last movie
            newMovieIndex

        # updating list object, index and the movies array
        _updateList : (newIndex) =>
            return if newIndex is @listIndex or _.isEmpty @lists then false

            oldList = if @List? then @List.Object else null
            # move marker to the new list
            @listIndex = newIndex
            # create the new list object
            @List = new List @HTML, @lists, @listIndex

            # fetch the movies of the new list
            @movies = @List.Object.find @HTML.movies
            # measure row size in new list
            @_getRowSize()

            # init related DOM manipulation
            DomManipulation.toggleElement 'list', @List.Object, oldList

        # updating movie object, index
        _updateMovie : (newIndex) =>
            return if newIndex is @movieIndex or _.isEmpty @movies then false

            oldMovie = if @Movie? then @Movie.Object else null
            # move marker to the new movie
            @movieIndex = newIndex
            # create the new movie object
            @Movie = new Movie @HTML, @movies, @movieIndex

            # init related DOM manipulation
            DomManipulation.toggleElement 'movie', @Movie.Object, oldMovie
