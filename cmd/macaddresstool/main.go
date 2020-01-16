package main

import (
	"fmt"
	"log"
	"os"

	"github.com/rtluckie/macaddresstool/pkg/macaddressio"
	"github.com/urfave/cli/v2"
)

var version = "unversioned"

func main() {
	app := &cli.App{
		Name:    "macaddresstool",
		Usage:   "A tool to retrieve information about MAC Addresses that uses macaddress.io",
		Version: version,
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:     "api-key",
				Usage:    "macaddress.io API Key",
				EnvVars:  []string{"MACADDRESSIO_API_KEY"},
				Required: true,
			},
			&cli.StringFlag{
				Name:     "address",
				Aliases:  []string{"a"},
				Usage:    "Search term: MAC address or OUI. You can use any octet delimiters including ':', '.', or even no delimiter. At least 6 BASE16 chars should be provided.",
				Required: true,
			},
			&cli.StringFlag{
				Name:    "output",
				Aliases: []string{"o"},
				Value:   "json",
				Usage:   "Output format (json or yaml)",
				EnvVars: []string{"MACADDRESSTOOL_OUTPUT_FORMAT"},
			},
		},
		Action: func(c *cli.Context) error {
			query := macaddressio.Query{}
			query.Address = c.String("address")
			query.ApiKey = c.String("api-key")
			query.OutputFormat = c.String("output")
			err := query.Validate()
			if err != nil {
				return err
			}
			err = query.Request()
			if err != nil {
				return err
			}
			result, err := query.GetResult()
			if err != nil {
				return err
			}
			fmt.Println(result)
			return nil
		},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatalf("ERROR: %s", err)
	}
}
