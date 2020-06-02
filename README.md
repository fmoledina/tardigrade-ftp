# INCOMPLETE - NOT FUNCTIONAL
Initial commit. Doesn't work yet.
# Tardigrade-backed FTP Server
An FTP server using s3fs and the [Storj](https//storj.io/) S3 gateway to mount a [Tardigrade](https://tardigrade.io/) bucket as FTP storage. This project is based on previous work in the [Factual/open-dockerfiles](https://github.com/Factual/open-dockerfiles/blob/master/s3-backed-ftp/README.md) project and [the fork by janek26](https://github.com/janek26/open-dockerfiles/tree/master/s3-backed-ftp). 

Instructions below are adapted from the above projects.

## Prerequisites
Create and fund a [Tardigrade.io](https://tardigrade.io/) account. Create a [project](https://documentation.tardigrade.io/getting-started/uploading-your-first-object/create-a-project) and an [API Key](https://documentation.tardigrade.io/getting-started/uploading-your-first-object/create-an-api-key) as shown on the Tardigrade documentation site.

## Usage
Set up the environment variables using `env.example` as a basis and save as `.env` file.
| Variable | Description |
| :----: | --- |
| `STORJ_ACCESS` |  The `Access:` string in the output of `uplink share` if the [Tardigrade Uplink CLI](https://documentation.tardigrade.io/getting-started/uploading-your-first-object/set-up-uplink-cli) was used to connect to the backend bucket. With this setting, the satellite address and API key values are not required. |
| `STORJ_SAT_ADDRESS` | The satellite address in the form of `<nodeid>@<address>:<port>`. |
| `STORJ_API_KEY` | The API key created in the above section. |
| `STORJ_PASSPHRASE` | (Optional) Encryption passphrase for the bucket contents. |
| `FTP_USER` | Username and password in the form of `username:passwordhash`. |
| `FTP_BUCKET` | Backend Tardigrade bucket that will be used for the FTP root. |
| `FTP_PASV_ADDRESS` | Passive address for the FTP server. |

Build the container using:
```bash
docker-compose build
```
Then run using:
```bash
docker-compose up -d
```
## Credits
* [Factual/open-dockerfiles](https://github.com/Factual/open-dockerfiles/blob/master/s3-backed-ftp/README.md) 
* [janek26/open-dockerfiles](https://github.com/janek26/open-dockerfiles/tree/master/s3-backed-ftp)