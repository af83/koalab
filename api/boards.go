package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

// == Models

type Board struct {
	Id      string
	Title	string
	Postits []*Postit
	Rules []*Rule
	// FIXME : h|vrules
}

type Rule struct {
	Id  string
	Coords [4]int // X1, Y1, X2, Y2
}

func (b *Board) addPostit(postit *Postit) {
	b.Postits = append(b.Postits, postit)
}

func (b *Board) Unmarshal(bytes []byte) error {
	return json.Unmarshal(bytes, &b)
}

func (b *Board) toJSON() ([]byte, error) {
	return json.Marshal(&b)
}

type BoardCollection struct {
	Boards []*Board
}

func (bc *BoardCollection) addBoard(board *Board) {
	bc.Boards = append(boards.Boards, board)
}

func (bc *BoardCollection) toJSON() ([]byte, error) {
	return json.Marshal(bc.Boards)
}

func (bc *BoardCollection) findById(id string) *Board {
	for _, b := range bc.Boards {
		if (*b).Id == id {
			return b
		}
	}
	return nil
}

// == Controller

var boards = new(BoardCollection)

func ListBoards(w http.ResponseWriter, req *http.Request) {
	bytes, _ := boards.toJSON()
	fmt.Fprintf(w, "%s", bytes)
}

func ShowBoard(w http.ResponseWriter, req *http.Request) {
	id := req.URL.Query().Get(":Id")
	board := boards.findById(id)
	if board != nil {
		bytes, _ := (*board).toJSON()
		fmt.Fprintf(w, "%s", bytes)
	} else {
		w.WriteHeader(404)
	}
}

/* JSON example
 * { "Title" : "exemple", "rules": [[1,1,2,2], [3,3,4,4]]}
 * 
 */

func CreateBoard(w http.ResponseWriter, req *http.Request) {
	board := new(Board)
	bytes, _ := ioutil.ReadAll(req.Body)
	err := board.Unmarshal(bytes)
	if err == nil {
		boards.addBoard(board)
	} else {
		fmt.Println("%s", err)
	}
	// Board
	//sql := "insert into Boards (Title) values ('"+board.Title+"')";
	sql := "select * from Boards;";
	results, err := Db.Exec(sql)
	if err != nil {
		fmt.Printf("%q: %s\n", err, sql)
		return
	}
	fmt.Printf("sql return from board createBoard : %v", results )
	// Rule
	// No rules at creation time	
	
}

func DeleteBoard(w http.ResponseWriter, req *http.Request) {
}
