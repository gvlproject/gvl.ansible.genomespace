# gvl.ansible.genomespace
This is the ansible playbook to deploy the GVL version of GenomeSpace. It is located at [https://github.com/gvlproject/gvl.ansible.genomespace](https://github.com/gvlproject/gvl.ansible.genomespace)

## Requirements
To use the playbook you need to clone the gvl.ansible.genomespace script ([https://github.com/gvlproject/gvl.ansible.genomespace](https://github.com/gvlproject/gvl.ansible.genomespace)) and follow the instructions in it's readme.

You will need:
  * A URL which will allow users to access the GenomeSpace instance
  * A SSL certificate for the URL, with corresponding keystore file
  * A valid email address for sending user registration emails
  * An Amazon Web Services account, with a SimpleDB instance for the GenomeSpace database
  * Dropbox developer credentials, available at [https://www.dropbox.com/developers](https://www.dropbox.com/developers)

## Usage/Deploying GenomeSpace

To use the playbook you need to clone the gvl.ansible.genomespace script ([https://github.com/gvlproject/gvl.ansible.genomespace](https://github.com/gvlproject/gvl.ansible.genomespace)) and follow the instructions in it's readme.

To run the playbook:
  1. Start a cloud machine with an Ubuntu 14.04 image (this describes the OpenStack cloud dashboard, it will be slightly different for other cloud types):
    * On the *Details* tab, give it a sensible name, select at least a medium machine size (2vpus), use the *Ubuntu 14.04* image.
    * On the Access and Security tab: select a known key pair, create and select a security group which opens the following ports: 22, 80, 443, 8400-8500.
    * Click the *Launch* button.
    * Once it starts, record the ip address of the newly created machine.
  2. Replace the IP in the hosts file with the IP you recorded in step one. Replace the private key variable `[ansible_ssh_private_key_file]` with the location of the private key file for the key pair you chose in step one.
  3. Copy the SSL certificate and keystore file to the files directory
  4. Set the appropriate variables in defaults/main.yml:
    * `[gs_url]` is the URL for the GenomeSpace instance you are deploying.
    * `[ssl_cert_filename]` and `[ssl_keystore_name]` are the filenames for the SSL certificate and keystore files, which should be copied in the files directory
    * `[admin_username]` and `[admin_password]` are your chosen username and password for the GenomeSpace admin user. This user will need to be created after launching your GenomeSpace instance.
    * `[gs_email]` and `[gs_email_password]` is the email address and corresponding password which will be used to register new users. `[gs_email_smtp]` and `[gs_email_port]` are for the corresponding SMTP server and port used to send mail.
    * `[aws_access_id]` and `[aws_secret_key]` are the access ID and secret key for the AWS account. Instructions for obtaining these can be found [here](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).
    * `[dropbox_access_id]` and `[dropbox_secret_key]` are the access ID and secret key for the Dropbox developer account. These can be obtained by creating a new 'app' under 'My apps' at [https://www.dropbox.com/developers](https://www.dropbox.com/developers)
    * `[dropbox_encoded_key]` should be generated [here](https://dl.dropboxusercontent.com/spa/pjlfdak1tmznswp/api_keys.js/public/index.html) using the `[dropbox_secret_key]`
    * `[virgo_username]` and `[virgo_password]` are your chosen username and password for the Virgo Server Admin Console.
  5. From the gvl.ansible.genomespace directory, run the playbook
  ```
  ansible-playbook playbook.yml -i hosts
  ```
  6. After the ansible has completed, start the server:
    * SSH into the cloud machine
    * `[cd /mnt/genomespace/DEVDEPLOY/virgo/bin]`
    * `[./startup.sh]`
  7. Once the server has completed its startup (it will take approx. 5 minutes), navigate to your GenomeSpace URL and create the user you specified in `[admin_username]` and `[admin_password]` in the main.yml file using the GenomeSpace main login page.
  8. Shutdown the server, and restart the server as specified in step 6. To run the server and keep it running after you logout, use the command `[nohup ./startup.sh &]`

## Role design
The layout of the role is as follows:

* **gvl.ansible.genomespace**

  * **defaults**

    * *main.yml* - file contains the global variables for the script.

  * **files**

    * *gengssecretkey.sh* - script for generating the GenomeSpace secret key.

    * *secretkeygenerator-0.0.1-SNAPSHOT.jar* - jar file used in the *gengssecretkey.sh* script.

    * *tomcat-server.xml* - the Tomcat server config file.

  * **meta**

    * *main.yml* - contains some meta data about the role including its dependencies, license etc.

  * **tasks** - the set of yaml files that are executed by ansible during the build process for this role.

    * *main.yml* - sets the variables in defaults.yml, followed by running the ansible scripts below.

    * *install_dependencies.yml* - installs all of the dependencies for GenomeSpace

    * *install_genomespace.yml* - copies the GenomeSpace code and creates the appropriate directories.

    * *configure_genomespace.yml* - configures all aspects of GenomeSpace, copies required files and sets all variables in appropriate files.

    * *build_and_run.yml* - builds the GenomeSpace code.

  * **templates**

    * *ANDSPublisher.java.j2* - template for the ANDS java file, required for ANDS functionality.

    * *atm_server_properties.j2* - template for the Analysis and Tool Management properties file.

    * *dmjobs_server_properties.j2* - template for the Data Manager Jobs properties file.

    * *dmwebservice_server_properties.j2* - template for the Data Manager Webservice properties file.

    * *identityserver_server_properties.j2* - template for the Identity Server properties file.

    * *virgo_config.j2* - template for the Virgo Server admin user file.

    * *genomespace-aws-properties.j2* - template for the Amazon Web Service account credentials.
