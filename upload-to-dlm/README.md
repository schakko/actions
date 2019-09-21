This action publishes a new Download Monitor release

# Usage
## Update the version information

Use the following inside your workflow:

    - name: Upload artifact to WordPress
	# execute SCP/FTP to overwrite existing download file
	
    - name: Write meta information
      uses: schakko/actions/upload-to-dm@master
	    env:
		  DLM_ENDPOINT: "https://your-server/wp-json/download-monitor-release-version/v1/downloads/${YOUR_DOWNLOAD_ID}/release"
		  USERNAME: ${{ secrets.dlm_username }}
		  PASSWORD: ${{ secrets.dlm_password }}
		  
With this, the DLM download artifact with ID *${YOUR_DOWNLOAD_ID}* will be updated with the version information from *.git-meta/version*.

## Update URL and meta information

If you want e.g. to store your artifact in S3 and need to update the URL inside WordPress DLM, you can use the *ARTIFACT_URL_SOURCE_FILE* environment variable. In addition to that, *ARTIFACT_META_SOURCE_FILE* can be used as environment variable to define additional meta information.

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
		  DLM_ENDPOINT: "https://your-server/wp-json/download-monitor-release-version/v1/downloads/${YOUR_DOWNLOAD_ID}/release"
		  ARTIFACT_URL_SOURCE_FILE: "./artifact_s3_upload_url"
		  ARTIFACT_META_SOURCE_FILE: "./artifact_meta_information"
		  USERNAME: ${{ secrets.dlm_username }}
		  PASSWORD: ${{ secrets.dlm_password }}