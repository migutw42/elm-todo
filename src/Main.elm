module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (attribute, checked, class, style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias UUID =
    Int


type alias TodoItem =
    { uuid : UUID
    , title : String
    , done : Bool
    }


type alias Model =
    { todoFormText : String
    , todoItemList : List TodoItem
    }


init : Model
init =
    { todoFormText = ""
    , todoItemList =
        [ { uuid = 1
          , title = "hello"
          , done = True
          }
        , { uuid = 2
          , title = "world"
          , done = False
          }
        ]
    }



-- UPDATE


type Msg
    = ToggleTodoItem UUID
    | AddTodoItem String
    | InputTodoFormText String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleTodoItem uuid ->
            { model | todoItemList = toggleTodoItem model.todoItemList uuid }

        AddTodoItem title ->
            { model | todoFormText = "", todoItemList = addTodoItem model.todoItemList title }

        InputTodoFormText title ->
            { model | todoFormText = title }


toggleTodoItem : List TodoItem -> UUID -> List TodoItem
toggleTodoItem todoItemList uuid =
    List.map
        (\todoItem ->
            if todoItem.uuid == uuid then
                { todoItem | done = not todoItem.done }

            else
                todoItem
        )
        todoItemList


addTodoItem : List TodoItem -> String -> List TodoItem
addTodoItem todoItemList title_ =
    List.concat
        [ todoItemList
        , [ { uuid = List.length todoItemList
            , title = title_
            , done = False
            }
          ]
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "", style "width" "100%" ]
        [ node "style"
            [ type_ "text/css" ]
            [ text "@import url(https://mildrenben.github.io/surface/css/surface_styles.css)" ]
        , aside [ attribute "role" "aside", class "" ] []
        , main_ [ attribute "role" "main", class "" ]
            [ header [ class "container" ]
                [ h1 [ class "m--1 g--11" ] [ text "Todo" ]
                ]
            , div [ class "g--12" ]
                [ div [ class "g--4 m--4 card" ]
                    [ form [ onSubmit (AddTodoItem model.todoFormText), class "" ]
                        [ div [ class "g--12", style "margin" "0 0 0 0" ]
                            [ input [ type_ "text", onInput InputTodoFormText, value model.todoFormText, style "width" "100%", style "background-size" "100% 100%" ] []
                            ]
                        , div [ class "g--12", style "margin" "0 0 0 0" ]
                            [ button [ class "btn--raised" ] [ text "add" ]
                            ]
                        ]
                    ]
                , ul [ class "g--4 m--4" ]
                    (List.map
                        (\todoItem ->
                            li []
                                [ div [ class "card container" ]
                                    [ input
                                        [ type_ "checkbox"
                                        , checked todoItem.done
                                        , value (String.fromInt todoItem.uuid)
                                        , onClick (ToggleTodoItem todoItem.uuid)
                                        ]
                                        []
                                    , label [ style "margin-left" "1em" ] [ text todoItem.title ]
                                    ]
                                ]
                        )
                        model.todoItemList
                    )
                ]
            ]
        ]
