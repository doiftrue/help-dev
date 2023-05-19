Usage
-----

1. Place file `create-self-signed-cert.sh` to any directory on your computer and run it. 
2. You will be asked: the domain name (the cert creates for) and the sertificate will be created. Additionally, for the first run the base-ROOT-CA-certificates will be created to the `ROOT_CA_CERT` folder.
This root certificate need to be added to the global trust certificates repository of your system (ubuntu), browser, etc.

### About ROOT-CA-certificate

Any created certificates are signed with ROOT CA certificate (myRootCA.pem). So, to any created certificate works correctly you need to add the ROOT CA to the trust certificates repository of Ubuntu, Browser etc.

#### Adding ROOT-CA to Ubuntu

	$ sudo apt-get install -y ca-certificates
	$ sudo cp ./ROOT_CA_CERT/myRootCA.crt /usr/local/share/ca-certificates/
	$ sudo update-ca-certificates

OR using interactive variant and another ubuntu CA repository (this is not recomended):

	$ sudo cp ./ROOT_CA_CERT/myRootCA.crt /usr/share/ca-certificates/
	$ sudo dpkg-reconfigure ca-certificates

- See: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
- See: https://askubuntu.com/questions/73287/how-do-i-install-a-root-certificate
- See: https://support.kerioconnect.gfi.com/hc/en-us/articles/360015200119-Adding-Trusted-Root-Certificates-to-the-Server


#### Adding ROOT-CA to Google Chrome

1. Goto `chrome://settings/certificates` - place this string into the main Google Chrome search field. Or go to `Settings > Privacy and security > Security > Manage sertificates`.
2. Now you need to go to `Authorities` tab and import the ROOT CA Certificate (myRootCA.crt) to the repository.
3. Done! Now any cert you create for any site will work in Google Chrome, because it signed with ROOT-CA that is in trusted repository.

See also: https://support.securly.com/hc/en-us/articles/206081828-How-do-I-manually-install-the-Securly-SSL-certificate-in-Chrome-


#### Adding ROOT-CA to Firefox

1. Goto `about:preferences#privacy` - place this string into the main Firefox search field. Or go to `Settings > Privacy and security`.
2. Scroll down to `Security` section click `View Certificates` button and select `Authorities` tab in the appeared popup window.
3. Import the ROOT CA Certificate (myRootCA.crt) to the repository.
4. Done! Now any cert you create for any site will work in Firefox.

See also: https://docs.vmware.com/en/VMware-Adapter-for-SAP-Landscape-Management/2.1.0/Installation-and-Administration-Guide-for-VLA-Administrators/GUID-0CED691F-79D3-43A4-B90D-CD97650C13A0.html



### Notes

If you can't add cert to the trust repo ensure tha file has 644 chmod:

	sudo chmod 644 /usr/local/share/ca-certificates/myRootCA.crt

`update-ca-certificates` manual: 
	http://manpages.ubuntu.com/manpages/trusty/man8/update-ca-certificates.8.html

Fresh updates. Remove symlinks in `/etc/ssl/certs` directory.

	sudo update-ca-certificates --fresh

View single certificate data:

	openssl x509 -in certificate.crt -text
