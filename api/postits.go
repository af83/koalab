package main

import (
	"io"
	"net/http"
)


type postit struct {
	id string
	title string
	coords [2]int
	board_id string
	//FIXME : corners 
}

func ListPostits(w http.ResponseWriter, req *http.Request) {
	board_id := req.URL.Query().Get("board_id")
	io.WriteString(w, "Listing postits "+board_id+"\n")
	// FIXME : without parameters, return nothing
	// with a valid board_d, return the list
}

func ShowPostit(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "Showing postit # "+req.URL.Query().Get(":id")+"!\n")
	// FIXME : return postit attributes
}

func CreatePostit(w http.ResponseWriter, req *http.Request) {
	//FIXME : refuse without a valid board id
	io.WriteString(w, "Creating postit for board #"+req.URL.Query().Get("board_id")+"!\n")
}

