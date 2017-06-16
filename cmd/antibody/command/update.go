package command

import (
	"fmt"

	"github.com/akatrevorjay/antibody"
	"github.com/akatrevorjay/antibody/project"
	"github.com/urfave/cli"
)

// Update all previously bundled bundles
var Update = cli.Command{
	Name:  "update",
	Usage: "updates all previously bundled commands",
	Action: func(ctx *cli.Context) error {
		fmt.Println("Updating all bundles in " + antibody.Home() + "...")
		return project.Update(antibody.Home())
	},
}
