package testing

import (
  "fmt"
  "net/http"
  "io"
  "io/ioutil"
  "strings"
  "testing"
)

var u = "http://127.0.0.1:8080"

func TestShowBoards(t *testing.T) {
  bytes := Get("/boards/123", t)
  fmt.Printf("%s\n", bytes)
}

func TestCreateBoard(t *testing.T) {
  model := `{
    "Id": "123"
  }`
  bytes := Post("/boards/", "text/json", strings.NewReader(model), t)
  fmt.Printf("%s\n", bytes)
}

func HttpMarsh(response *http.Response, err error, t *testing.T) []byte {
  if err != nil {
    t.Error("%s", err)
  } else {
    defer response.Body.Close()
    bytes, err := ioutil.ReadAll(response.Body)
    if err != nil {
      t.Error("%s", err)
    }
    return bytes
  }
  return nil
}

func Get(res string, t *testing.T) []byte {
  response, err := http.Get(u + res)
  return HttpMarsh(response, err, t)
}

func Post(res string, bodyType string, body io.Reader, t *testing.T) []byte {
  response, err := http.Post(u + res, bodyType, body)
  return HttpMarsh(response, err, t)
}
