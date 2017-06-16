package bundle

import "github.com/akatrevorjay/antibody/project"

type dummyBundle struct {
	Project project.Project
}

func (bundle dummyBundle) Get() (result string, err error) {
	err = bundle.Project.Download()
	return result, err
}
