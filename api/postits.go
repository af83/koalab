package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"time"
)

type Postit struct {
	Id     string
	Title  string
	X	   int
	Y      int
	Color  string
	Angle  int 
	H      int
	W	   int

	//FIXME : corners 
}

func CreatePostit(w http.ResponseWriter, req *http.Request) {
	board_id := req.URL.Query().Get(":Id")
	board := boards.findById(board_id)
	if board == nil {
		fmt.Println("Board doesn't exist")
		w.WriteHeader(404)
		return
	}

	postit := &Postit{}
	defer req.Body.Close()
	body, err := ioutil.ReadAll(req.Body)
	if err != nil {
		fmt.Printf("%s", err)
	}

	erru := json.Unmarshal(body, &postit)
	if erru != nil {
		fmt.Println("Cannot unmarshal to postit: %s", err)
	}

	// FIXME : move that somewhere else, with a decent UID
	postit.Id = strconv.FormatInt(time.Now().UnixNano(), 10)
	postit.X = 1
	postit.Y = 1
	postit.Color = "#123456"

	fmt.Printf("%v", *board)
	fmt.Printf("%v", postit)

	(*board).addPostit(postit)
}

func UpdatePostit(w http.ResponseWriter, req *http.Request) {
	// FIXME : update a postit
}

func DeletePostit(w http.ResponseWriter, req *http.Request) {
	// FIXME : delete a postit
}
