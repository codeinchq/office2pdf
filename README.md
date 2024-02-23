# office2pdf

[![Docker Image CI](https://github.com/codeinchq/office2pdf/actions/workflows/docker-image.yml/badge.svg)](https://github.com/codeinchq/office2pdf/actions/workflows/docker-image.yml)

This repository contains a simple containerized API to convert Office documents to PDF documents
using [LibreOffice](https://www.libreoffice.org/) headless.

The image is available on [Docker Hub](https://hub.docker.com/r/codeinchq/office2pdf) under the name `codeinchq/office2pdf`.

## Configuration

By default, the container listens on port 3000. The port is configurable using the `PORT` environment variable.

## Usage

All requests must by send in POST to the `/convert` endpoint with a `multipart/form-data` content type. The request must contain an Office file with the key `file`. 

The server returns `200` if the conversion was successful and the images are available in the response body. In case of error, the server returns a `400` status code with a JSON object containing the error message (format: `{error: string}`).

### Example

#### Step 1: run the container using Docker
```bash
docker run -p "3000:3000" codeinchq/office2pdf 
```

#### Step 2: convert an Office file to PDF
```bash
curl -X POST -F "file=@/path/to/file.docx" http://localhost:3000/convert -o example.pdf
```

## Client

A PHP 8 client is available at on [GitHub](https://github.com/codeinchq/office2pdf-php-client) and [Packagist](https://packagist.org/packages/codeinc/office2pdf-client).


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
