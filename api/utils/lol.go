package main

import (
	"flag"
	"net/http"
	"io/ioutil"
	"fmt"
	"time"
)


// HTTP GET URL
func get(url string) int {
	response, err := http.Get(url)
	if err != nil {
		fmt.Printf("%s", err)
	} else {
		defer response.Body.Close()
		_, err := ioutil.ReadAll(response.Body)
		if err != nil {
			fmt.Printf("%s", err)
		}
	}
	return 0
}

func main() {
	var url string
	flag.StringVar(&url, "url", "http://af83.com", "URL to ping")
	flag.Parse()
	start := time.Now().UnixNano()
	get(url)
	stop := time.Now().UnixNano()
	fmt.Printf("%dms\n", (stop - start) / 1000000)
}

