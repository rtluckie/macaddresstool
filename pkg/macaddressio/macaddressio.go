package macaddressio

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/ghodss/yaml"
	"github.com/tidwall/gjson"
)

type Query struct {
	Address      string
	ApiKey       string
	OutputFormat string
	Result       []byte
}

func (q *Query) Validate() error {
	q.OutputFormat = strings.ToLower(q.OutputFormat)
	if q.OutputFormat == "yml" {
		q.OutputFormat = "yaml"
	}
	if q.OutputFormat != "json" && q.OutputFormat != "yaml" {
		return fmt.Errorf("Invalid format: %s", q.OutputFormat)
	}
	return nil
}

func (q *Query) Request() error {
	url := fmt.Sprintf("https://api.macaddress.io/v1?output=json&search=%s", q.Address)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return err
	}
	// set the auth header
	req.Header.Set("X-Authentication-Token", q.ApiKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	if resp.StatusCode != 200 {
		return fmt.Errorf("Response code %d!=200", resp.StatusCode)
	}
	defer resp.Body.Close()
	result, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}
	q.Result = result
	return nil
}

func (q *Query) GetResult() (string, error) {
	if q.Result == nil {
		return "", fmt.Errorf("No result returned")
	}
	result, err := yaml.YAMLToJSON(q.Result)
	if err != nil {
		return "", err
	}
	if q.OutputFormat == "json" {
		return string(result), nil
	}
	result, err = yaml.JSONToYAML(q.Result)
	if err != nil {
		return "", err
	}
	return string(result), nil
}

func (q *Query) GetSelection(selector string) (string, error) {
	data, err := yaml.YAMLToJSON(q.Result)
	if err != nil {
		return "", err
	}
	selection := gjson.Get(string(data), selector)
	return selection.String(), nil

}
