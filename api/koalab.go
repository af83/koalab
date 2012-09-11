package main

import (
	"encoding/json"
	"flag"
	"github.com/bmizerany/pat"
	"io/ioutil"
	"labix.org/v2/mgo"
	"labix.org/v2/mgo/bson"
	"log"
	"net/http"
)

var db *mgo.Database

type Board struct {
	Id    bson.ObjectId `json:"_id" bson:"_id"`
	Title string        `json:"title"`
}

type Line struct {
	Id      bson.ObjectId `json:"_id" bson:"_id"`
	BoardId bson.ObjectId
	X1      int
	X2      int
	Y1      int
	Y2      int
}

type Postit struct {
	Id      bson.ObjectId `json:"_id" bson:"_id"`
	BoardId bson.ObjectId `json:"board_id" bson:"board_id"`
	Title   string        `json:"title"`
	Coords  struct {
		X int `json:"x"`
		Y int `json:"y"`
	} `json:"coords"`
	Size struct {
		W int `json:"w"`
		H int `json:"h"`
	} `json:"size"`
	angle int    `json:"angle"`
	Color string `json:"color"`
}

func ListBoards(w http.ResponseWriter, r *http.Request) {
	var boards []Board
	err := db.C("boards").Find(nil).All(&boards)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	bytes, _ := json.Marshal(boards)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func CreateBoard(w http.ResponseWriter, r *http.Request) {
	id := bson.NewObjectId()
	board := Board{Id: id}
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &board)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	err = db.C("boards").Insert(board)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	bytes, _ := json.Marshal(board)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func ShowBoard(w http.ResponseWriter, r *http.Request) {
	var board Board
	id := r.URL.Query().Get(":id")
	err := db.C("boards").FindId(id).One(&board)
	if err != nil {
		http.NotFound(w, r)
		return
	}
	bytes, err := json.Marshal(board)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func ListPostits(w http.ResponseWriter, r *http.Request) {
	var postits []Postit
	id := r.URL.Query().Get(":id")
	err := db.C("postits").Find(bson.M{"board_id": id}).All(&postits)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	bytes, _ := json.Marshal(postits)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func CreatePostit(w http.ResponseWriter, r *http.Request) {
	id := bson.NewObjectId()
	bid := bson.ObjectId(r.URL.Query().Get(":id"))
	postit := Postit{Id: id, BoardId: bid}
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &postit)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	err = db.C("postits").Insert(postit)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	bytes, _ := json.Marshal(postit)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func main() {
	// Parse the command-line
	var addr string
	var host string
	var data string
	flag.StringVar(&addr, "a", "127.0.0.1:8080", "Bind to this address:port")
	flag.StringVar(&host, "h", "localhost", "MongoDB host")
	flag.StringVar(&data, "d", "koalab", "MongoDB database")
	flag.Parse()

	// Database connexion
	session, err := mgo.Dial(host)
	if err != nil {
		log.Fatal("Can't connect to MongoDB: ", err)
	}
	defer session.Close()
	db = session.DB(data)

	// Routing
	m := pat.New()
	m.Get("/boards", http.HandlerFunc(ListBoards))
	m.Post("/boards", http.HandlerFunc(CreateBoard))
	m.Get("/boards/:id", http.HandlerFunc(ShowBoard))
	m.Get("/boards/:id/postits", http.HandlerFunc(ListPostits))
	m.Post("/boards/:id/postits", http.HandlerFunc(CreatePostit))
	//m.Put("/boards/:bid/postits/:id", http.HandlerFunc(UpdatePostit))

	// Start the HTTP server
	http.Handle("/", m)
	log.Printf("Listening on http://%s/\n", addr)
	err = http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
