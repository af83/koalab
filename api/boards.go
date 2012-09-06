package main

import (
	"fmt"
	"net/http"
	"io"
)

func ListBoards(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("boards=%v\n", boards)
}

func ShowBoard(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get(":id")+"!\n")
}

func CreateBoard(w http.ResponseWriter, req *http.Request) {
	board := &board{id: "foo"}
	boards = append(boards, *board)
}
