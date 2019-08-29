This action publishes a new Download Monitor release

# Usage
Use the following inside your workflow:

    - name: Write meta information
      uses: schakko/actions/upload-to-dm@master
	    env:
		  dlm_endpoint: "https://your-server/wp-json/download-monitor-release-version/v1/downloads/"
		  username: ${{ secrets.dlm_username }}
		  password: ${{ secrets.dlm_password }}
		  
