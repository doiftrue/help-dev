Required packeges
-----------------

`openssl` packege must be installed for this script works. Instalation example for ubuntu:

	sudo apt update
	sudo apt install openssl -y
	openssl version


Create self-signed certificate
------------------------------

1. Place file `create-self-signed-cert.sh` to any directory on your computer and run it. 
	```
	bash ~/path/to/create-self-signed-cert.sh
    ```
2. Enter your local site domain name (ex. mysite.loc).
3. DONE: The self-signed certificate created.

Now you need to add the ROOT CA certificate to the trust store of your system and use site related cert files in your web server configs (Apache/Nginx).


### Use cert files
Add a site related cert files (`.key`, `.crt`) in yout Apache or Nginx configs.


Add ROOT-CA Certificate to the Trust Store
------------------------------------------
To make your browser/system trust the created self-signed certificate you need to add the ROOT CA certificate to the trust store of your system.


### Add ROOT-CA to Ubuntu
Copy `.pem.crt` certificate file (the format that has ----BEGIN CERTIFICATE---- in it) into `/usr/local/share/ca-certificates`. Then run `sudo update-ca-certificates`:

	$ sudo apt-get install -y ca-certificates
	$ sudo cp ./ROOT_CA_CERT/myRootCA.pem.crt /usr/local/share/ca-certificates/myRootCA.pem.crt
	$ sudo update-ca-certificates

NOTE: `.crt` file extension is important.

OR use interactive variant (not recomended):

	$ sudo cp ./ROOT_CA_CERT/myRootCA.pem.crt /usr/share/ca-certificates/myRootCA.pem.crt
	$ sudo dpkg-reconfigure ca-certificates

- See: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
- See: https://askubuntu.com/questions/73287/how-do-i-install-a-root-certificate
- See: https://support.kerioconnect.gfi.com/hc/en-us/articles/360015200119-Adding-Trusted-Root-Certificates-to-the-Server


### Add ROOT-CA to Windows
Open PowerShell as Admin and run command:

	certutil -addstore -f "Root" C:\path\to\myRootCA.crt

Now Windows will trust this CA, and all system services, Git, curl, Node, Docker Desktop, and other tools will consider certificates issued by it as valid.

OR Add Manually:
- Press `Win + R` > `certmgr.msc`.
- In the left-tree: "Trusted Root Certification Authorities" > "Certificates."
- Right click > All Tasks > Import > Next > Browse.
- Select `myRootCA.crt` > Next.
- Select "Place all certificates in the following store" > Certificate store: "Trusted Root Certification Authorities".
- Then Next > Finish. 
- The certificate will appear in the list.



### Add into Google Chrome:
- Open `chrome://certificate-manager/localcerts/usercerts` in your browser
- Click `Import` button in `Trusted Certificates` section and add `dev/wodbydocker/nginx/certs/ROOT_CA/bacardiRootCA.crt` file.

Now any cert you create for any site will work in Google Chrome, because it signed with ROOT-CA that is in trusted repository.


### Adding ROOT-CA to Firefox

1. Goto `about:preferences#privacy` - place this string into the main Firefox search field. Or go to `Settings > Privacy and security`.
2. Scroll down to `Security` section click `View Certificates` button and select `Authorities` tab in the appeared popup window.
3. Import the ROOT CA Certificate (myRootCA.crt) to the repository.
4. Done! Now any cert you create for any site will work in Firefox.

See also: https://docs.vmware.com/en/VMware-Adapter-for-SAP-Landscape-Management/2.1.0/Installation-and-Administration-Guide-for-VLA-Administrators/GUID-0CED691F-79D3-43A4-B90D-CD97650C13A0.html



About ROOT-CA Certificate
-------------------------

For the script first run (once) the ROOT-CA-certificate is created to the `ROOT_CA_CERT` folder.

Any further created certificates for separete site are signed with that ROOT CA certificate (myRootCA.pem).

Adding the ROOT CA (myRootCA.pem) to the trust store is required to all further generated certificates works correctly.


Notes
-----

- As an alternative for all this staff you can use `mkcert` lib: https://github.com/FiloSottile/mkcert

- If you can't add cert to the trust repo ensure that file has 644 chmod:
	```
	sudo chmod 644 /usr/local/share/ca-certificates/myRootCA.crt
    ```

- `update-ca-certificates` manual: http://manpages.ubuntu.com/manpages/trusty/man8/update-ca-certificates.8.html

- FILES:
    ```
    /etc/ca-certificates.conf          - A configuration file.
    /etc/ssl/certs/ca-certificates.crt - A single-file of CA certificates. Holds all CA certificates activated in /etc/ca-certificates.conf.
    /usr/share/ca-certificates         - Directory of CA certificates.
    /usr/local/share/ca-certificates   - Directory of local CA certificates (with .crt extension).
    ```

Fresh updates. Remove symlinks in `/etc/ssl/certs` directory.

	sudo update-ca-certificates --fresh

View single certificate data:

	openssl x509 -in certificate.crt -text
