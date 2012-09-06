package main

import (
	"io"
	"net/http"
)

func ListPostits(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get("")+"!\n")
	// FIXME : without parameters, return nothing
	// with a valid board_d, return the list
}

func ShowPostit(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get(":id")+"!\n")
	// FIXME : return postit attributes
}

