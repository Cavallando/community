// Package githubbadge provides details for the Github Badge applet.
package githubbadge

import (
	_ "embed"

	"tidbyt.dev/community/apps/manifest"
)

//go:embed github_badge.star
var source []byte

// New creates a new instance of the Github Badge applet.
func New() manifest.Manifest {
	return manifest.Manifest{
		ID:          "github-badge",
		Name:        "Github Badge",
		Author:      "Cavallando",
		Summary:     "Github action status",
		Desc:        "Displays a Github badge for the status of the configured Action.",
		FileName:    "github_badge.star",
		PackageName: "githubbadge",
		Source:  source,
	}
}
