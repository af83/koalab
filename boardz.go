package main 

import (
	"flag"
	"github.com/bmizerany/pat"
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

type board struct {
	id string
	title string
	// FIXME : h|vrules
}

func ListBoards(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get("")+"!\n")
}

func ShowBoard(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get(":id")+"!\n")
}

func ListPostits(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get("")+"!\n")
}

func ShowPostit(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "hello world "+req.URL.Query().Get(":id")+"!\n")
}

func main() {
	var port int
	var mongoip string 

	flag.IntVar(&port, "port", 8080, "Port") 
	flag.StringVar(&mongoip, "mongoip", "127.0.0.1", "MongoDB Ip")
	flag.Parse()
	
	m := pat.New()

	m.Get("/boards/", http.HandlerFunc(ListBoards))
	m.Get("/boards/:id", http.HandlerFunc(ShowBoard))
	m.Get("/postits/", http.HandlerFunc(ListPostits))
	m.Get("/postits/:id", http.HandlerFunc(ShowPostit))



}


