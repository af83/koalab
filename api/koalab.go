package main

import (
	"code.google.com/p/gorilla/securecookie"
	"encoding/json"
	"flag"
	"github.com/bmizerany/pat"
	"io/ioutil"
	"labix.org/v2/mgo"
	"labix.org/v2/mgo/bson"
	"log"
	"net/http"
	"net/url"
	"time"
)

var host string
var db *mgo.Database
var scookie *securecookie.SecureCookie

type BrowserIDResponse struct {
	Status, Email, Audience, Issuer string
	Expires                         int64
}

type Board struct {
	Id    bson.ObjectId `json:"_id" bson:"_id"`
	Title string        `json:"title"`
}

type Line struct {
	Id      bson.ObjectId `json:"_id" bson:"_id"`
	BoardId bson.ObjectId `json:"board_id" bson:"board_id"`
	X1      int `json:"x1"`
	X2      int `json:"x2"`
	Y1      int `json:"y1"`
	Y2      int `json:"y2"`
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
	Angle     float64   `json:"angle"`
	Color     string    `json:"color"`
	UpdatedAt time.Time `json:"updatedAt"`
}

func (b BrowserIDResponse) Okay() bool {
	return b.Status == "okay"
}

func initSecureCookie(filename string) {
	key, err := ioutil.ReadFile(filename)
	if err != nil {
		key = securecookie.GenerateRandomKey(32)
		if key == nil {
			log.Fatal("Can't generate a secret!")
		}
		err = ioutil.WriteFile(filename, key, 0600)
		if err != nil {
			log.Fatal("Can't read or write .secret", err)
		}
	}

	scookie = securecookie.New(key, nil)
}

func SignInUser(w http.ResponseWriter, r *http.Request) {
	user := make(map[string]interface{})
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &user)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	assertion, ok := user["assertion"].(string)
	if !ok {
		http.Error(w, "Missing assertion", 500)
		return
	}
	values := url.Values{"assertion": {assertion}, "audience": {host}}
	resp, err := http.PostForm("https://verifier.login.persona.org/verify", values)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	defer resp.Body.Close()

	bytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	var response BrowserIDResponse
	err = json.Unmarshal(bytes, &response)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	if response.Email == "" {
		http.Error(w, "Invalid authentication", 403)
		return
	}

	// Store the cookie
	encoded, err := scookie.Encode("email", response.Email)
	if err == nil {
		cookie := &http.Cookie{Name: "email", Value: encoded, Path: "/"}
		http.SetCookie(w, cookie)
	}

	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
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
	id := bson.ObjectIdHex(r.URL.Query().Get(":id"))
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
	postit := Postit{}
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &postit)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	postit.Id = bson.NewObjectId()
	postit.BoardId = bson.ObjectIdHex(r.URL.Query().Get(":id"))
	postit.UpdatedAt = time.Now()
	err = db.C("postits").Insert(postit)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	bytes, _ := json.Marshal(postit)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func UpdatePostit(w http.ResponseWriter, r *http.Request) {
	postit := Postit{}
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &postit)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	postit.Id = bson.ObjectIdHex(r.URL.Query().Get(":id"))
	postit.BoardId = bson.ObjectIdHex(r.URL.Query().Get(":bid"))
	postit.UpdatedAt = time.Now()
	err = db.C("postits").UpdateId(postit.Id, postit)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	bytes, _ := json.Marshal(postit)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func ListLines(w http.ResponseWriter, r *http.Request) {
	var lines []Line
	id := bson.ObjectIdHex(r.URL.Query().Get(":id"))
	err := db.C("lines").Find(bson.M{"board_id": id}).All(&lines)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	bytes, _ := json.Marshal(lines)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func CreateLine(w http.ResponseWriter, r *http.Request) {
	line := Line{}
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &line)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	line.Id = bson.NewObjectId()
	line.BoardId = bson.ObjectIdHex(r.URL.Query().Get(":id"))
	err = db.C("lines").Insert(line)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	bytes, _ := json.Marshal(line)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func UpdateLine(w http.ResponseWriter, r *http.Request) {
	line := Line{}
	body, _ := ioutil.ReadAll(r.Body)
	err := json.Unmarshal(body, &line)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	line.Id = bson.ObjectIdHex(r.URL.Query().Get(":id"))
	line.BoardId = bson.ObjectIdHex(r.URL.Query().Get(":bid"))
	err = db.C("lines").UpdateId(line.Id, line)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	bytes, _ := json.Marshal(line)
	w.Header().Add("content-type", "application/json")
	w.Write(bytes)
}

func ApiHandlerFunc(handler http.HandlerFunc) http.HandlerFunc {
	wrapped := func(w http.ResponseWriter, r *http.Request) {
		cookie, err := r.Cookie("email")
		if err != nil {
			http.Error(w, "Authentication required", 403)
			return
		}
		email := ""
		err = scookie.Decode("email", cookie.Value, &email)
		if err != nil {
			http.Error(w, "Authentication required", 403)
			return
		}
		handler(w, r)
	}
	return http.HandlerFunc(wrapped)
}

func main() {
	// Parse the command-line
	var addr string
	var mongo string
	var dbase string
	flag.StringVar(&addr, "a", "127.0.0.1:8080", "Bind to this address:port")
	flag.StringVar(&host, "h", "http://koalab.lo", "Public URL use for Persona")
	flag.StringVar(&mongo, "m", "localhost", "MongoDB host")
	flag.StringVar(&dbase, "d", "koalab", "MongoDB database")
	flag.Parse()

	// Database connexion
	session, err := mgo.Dial(mongo)
	if err != nil {
		log.Fatal("Can't connect to MongoDB: ", err)
	}
	defer session.Close()
	db = session.DB(dbase)

	// Init secure cookie
	initSecureCookie(".secret")

	// Routing
	m := pat.New()
	m.Post("/api/user", http.HandlerFunc(SignInUser))
	m.Get("/api/boards", ApiHandlerFunc(ListBoards))
	m.Post("/api/boards", ApiHandlerFunc(CreateBoard))
	m.Get("/api/boards/:id", ApiHandlerFunc(ShowBoard))
	m.Get("/api/boards/:id/postits", ApiHandlerFunc(ListPostits))
	m.Post("/api/boards/:id/postits", ApiHandlerFunc(CreatePostit))
	m.Put("/api/boards/:bid/postits/:id", http.HandlerFunc(UpdatePostit))
	m.Get("/api/boards/:id/lines", ApiHandlerFunc(ListLines))
	m.Post("/api/boards/:id/lines", ApiHandlerFunc(CreateLine))
	m.Put("/api/boards/:bid/lines/:id", http.HandlerFunc(UpdateLine))

	// Start the HTTP server
	http.Handle("/", m)
	log.Printf("Listening on http://%s/\n", addr)
	err = http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
