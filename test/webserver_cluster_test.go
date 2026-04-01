package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestWebserverCluster(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()
	clusterName := fmt.Sprintf("tt-%s", uniqueID)

	// Copy module to temp directory to avoid state conflicts
	terraformDir := test_structure.CopyTerraformFolderToTemp(t, "..", ".")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{}{
			"project_name":              "terratest",
			"team_name":                 "qa",
			"environment":               "test",
			"cluster_name":              clusterName,
			"instance_type":             "t3.micro",
			"min_size":                  1,
			"max_size":                  2,
			"custom_message":            "Terratest Passed Successfully",
			"enable_destroy_protection": false,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	albDNSName := terraform.Output(t, terraformOptions, "alb_dns_name")

	http_helper.HttpGetWithRetry(
		t,
		"http://"+albDNSName,
		nil,
		200,
		"Terratest Passed Successfully",
		30,
		10*time.Second,
	)
}
