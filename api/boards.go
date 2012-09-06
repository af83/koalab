package main

import (
	"fmt"
	"net/http"
	"io"
)

type Board struct {
	Id string
	Postits []Postit
	// FIXME : h|vrules
}

var Boards []Board 

func ListBoards(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("boards=%v\n", Boards)
}

func ShowBoard(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get(":Id")+"!\n")
}

func CreateBoard(w http.ResponseWriter, req *http.Request) {
	board := &Board{Id: "foo"}
	Boards = append(Boards, *board)
}
