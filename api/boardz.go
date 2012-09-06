package main 

import (
	"database/sql"
	"fmt"
	_ "github.com/mattn/go-sqlite3"
	"github.com/bmizerany/pat"
	"flag"
	"log"
	"net/http"
)

func main() {
	var addr string
	var port int
	var dbpath string 


	flag.StringVar(&addr, "addr", "127.0.0.1", "Address")
	flag.IntVar(&port, "port", 8080, "Port") 
	flag.StringVar(&dbpath, "dbpath", "/tmp/boardz.sqlite3", "SQLite3 DB file")
	flag.Parse()

	db, err := sql.Open("sqlite3", dbpath)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()

	sqls := []string{
		"create table if not exists Boards (Id integer not null primary key);",
		"create table if not exists Postits (Id integer not null primary key, Title text, Color text, X int, Y int, BoardId int, foreign key(BoardId) references Boards(Id) );",
	}

	for _, sql := range sqls {
		_, err = db.Exec(sql)
		if err != nil {
			fmt.Printf("%q: %s\n", err, sql)
			return
		}
	}

	m := pat.New()

	// Boards
	m.Get("/boards", http.HandlerFunc(ListBoards))
	m.Post("/boards", http.HandlerFunc(CreateBoard))
	m.Get("/boards/:Id", http.HandlerFunc(ShowBoard))
	m.Post("/boards/:Id/postits", http.HandlerFunc(CreatePostit))
	m.Del("/boards/:Id", http.HandlerFunc(DeleteBoard))

	// Postits
	m.Put("/postits/:Id", http.HandlerFunc(UpdatePostit))

	http.Handle("/", m)

	// Start the HTTP server
	log.Printf("Listening on http://%s:%d/\n", addr, port)
	foo := fmt.Sprintf("%s:%d", addr, port)  
	err = http.ListenAndServe(foo, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
