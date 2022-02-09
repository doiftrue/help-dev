Usage
-----

Place file to any directory and run it. It will ask Your domain name (the cert create for) and create sertificate for that domain.

### Add CA cert to UBUNTU

Additionally, for the first run base ROOT CA certificate will be created as well. This root certificate need to be added to global trust certificates repository of your system (e.g. ubuntu).

	$ sudo apt-get install -y ca-certificates
	$ sudo cp local-ca.crt /usr/local/share/ca-certificates
	$ sudo update-ca-certificates

OR using interactive variant and another ubuntu CA repository (this is not recomended):

	$ sudo cp local-ca.crt /usr/share/ca-certificates/
	$ sudo dpkg-reconfigure ca-certificates

- See: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
- See: https://askubuntu.com/questions/73287/how-do-i-install-a-root-certificate
- See: https://support.kerioconnect.gfi.com/hc/en-us/articles/360015200119-Adding-Trusted-Root-Certificates-to-the-Server


### Add a trusted CA certificate to Chrome and Firefox

- See: https://docs.vmware.com/en/VMware-Adapter-for-SAP-Landscape-Management/2.1.0/Installation-and-Administration-Guide-for-VLA-Administrators/GUID-0CED691F-79D3-43A4-B90D-CD97650C13A0.html
- See: https://support.securly.com/hc/en-us/articles/206081828-How-do-I-manually-install-the-Securly-SSL-certificate-in-Chrome-


### Notes

update-ca-certificates manual: http://manpages.ubuntu.com/manpages/trusty/man8/update-ca-certificates.8.html

Fresh updates. Remove symlinks in `/etc/ssl/certs` directory.

	sudo update-ca-certificates --fresh

View single certificate data:

	openssl x509 -in certificate.crt -text