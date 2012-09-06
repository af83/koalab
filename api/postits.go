package main

import (
	"io"
	"io/ioutil"
	"net/http"
	"time"
	"fmt"
	"encoding/json"
	"strconv"
)

type Postit struct {
	Id string
	Title string
	Coords [2]int
	Color string
	Board_id string
	//FIXME : corners 
}

var Postits []Postit

func ListPostits(w http.ResponseWriter, req *http.Request) {
	board_id := req.URL.Query().Get("Board_id")
	if board_id != "" {
		//FIXME: return JSON array
		io.WriteString(w, "Listing postits: "+board_id+"\n")
	}	
	fmt.Printf("Available postits=%v\n", Postits)
}

func ShowPostit(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "Showing postit # "+req.URL.Query().Get(":Id")+"!\n")
	// FIXME : return postit attributes
}

func CreatePostit(w http.ResponseWriter, req *http.Request) {
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
	postit.Coords = [2]int{1,1}
	postit.Color = "#123456"

	// FIXME : add postit to relevant board postits list
	Postits = append(Postits, *postit)

}

