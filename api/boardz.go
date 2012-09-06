package main 

import (
	"flag"
	"fmt"
	"github.com/bmizerany/pat"
	"log"
	"net/http"
)

func main() {
	var addr string
	var port int
	var mongoip string 

	flag.StringVar(&addr, "addr", "127.0.0.1", "Address")
	flag.IntVar(&port, "port", 8080, "Port") 
	flag.StringVar(&mongoip, "mongoip", "127.0.0.1", "MongoDB Ip")
	flag.Parse()
	
	m := pat.New()

	// Boards
	m.Get("/boards/", http.HandlerFunc(ListBoards))
	m.Post("/boards/", http.HandlerFunc(CreateBoard))
	m.Get("/boards/:id", http.HandlerFunc(ShowBoard))
	m.Del("/boards/:id", http.HandlerFunc(DeleteBoard))

	// Postits
	m.Get("/postits/", http.HandlerFunc(ListPostits))
	m.Post("/postits/", http.HandlerFunc(CreatePostit))
	m.Get("/postits/:id", http.HandlerFunc(ShowPostit))
	m.Del("/postits/:id", http.HandlerFunc(DeletePostit))

	// Start the HTTP server
	log.Printf("Listening on http://%s:%d/\n", addr, port)
	foo := fmt.Sprintf("%s:%d", addr, port)	
	err := http.ListenAndServe(foo, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}	
}
