This action publishes a new Download Monitor release

# Usage
## Update the version information

Use the following inside your workflow:

    - name: Upload artifact to WordPress
	# execute SCP/FTP to overwrite existing download file
	
    - name: Write meta information
      uses: schakko/actions/upload-to-dm@master
	    env:
		  dlm_endpoint: "https://your-server/wp-json/download-monitor-release-version/v1/downloads/${YOUR_DOWNLOAD_ID}/release"
		  username: ${{ secrets.dlm_username }}
		  password: ${{ secrets.dlm_password }}
		  
With this, the DLM download artifact with ID *${YOUR_DOWNLOAD_ID}* will be updated with the version information from *.git-meta/version*.

## Update URL and meta information

If you want e.g. to store your artifact in S3 and need to update the URL inside WordPress DLM, you can use the *artifact_url_source_file* environment variable. In addition to that, *artifact_meta_source_file* can be used as environment variable to define additional meta information.

	- name: Write URL source file
	  run: "echo s3://dlm-artifacts/`cat .git-meta/version`/release.zip > ./artifact_s3_upload_url"
	- name: Write meta source file
	  run "echo "{'key': 'value'}" > ./artifact_meta_information"
	  
	- name: Release file on AWS S3
      uses: actions/aws/cli@master
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_AK_DEPLOYMENT }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SAK_DEPLOYMENT }}
      with:
        args: "s3 cp file.zip `cat ./artifact_s3_upload_url`"
		
    - name: Write meta information
      uses: schakko/actions/upload-to-dm@master
	    env:
		  dlm_endpoint: "https://your-server/wp-json/download-monitor-release-version/v1/downloads/${YOUR_DOWNLOAD_ID}/release"
		  artifact_url_source_file: "./artifact_s3_upload_url"
		  artifact_meta_source_file: "./artifact_meta_information"
		  username: ${{ secrets.dlm_username }}
		  password: ${{ secrets.dlm_password }}