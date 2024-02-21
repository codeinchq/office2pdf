/*
 * Copyright 2024 Code Inc. <https://www.codeinc.co>
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 */

import express from 'express';
import multer from 'multer';
import uniqid from 'uniqid';
import {resolve} from "path";
import {unlinkSync} from "node:fs";
import {execSync} from "child_process";
import {existsSync} from "node:fs";

const port = +(process.env.PORT ?? 3000);
const tempDir = 'temp';

const app = express();
const upload = multer({dest: tempDir});

app.post('/convert', upload.single('file'), (req, res) => {
    if (!req.file.filename) {
        res.status(400);
        res.send({error: 'No file uploaded'});
        return;
    }

    // converting the PDF file to images
    console.log(`Converting Office file ${req.file.originalname} to PDF`);
    try {
        const outPath = `${req.file.path}.pdf`;

        execSync(
            `libreoffice `
            + `--headless `
            + `--convert-to pdf:writer_pdf_Export `
            + `--outdir ${tempDir} `
            + `${req.file.path}`,
        );

        if (!existsSync(outPath)) {
            throw 'Failed to convert the office file to PDF';
        }

        // sending the images as a response
        // await res.download(imagePath);
        res.sendFile(outPath, {root: resolve()}, (err) => {
            // cleaning up
            unlinkSync(req.file.path);
            unlinkSync(outPath);
        });
    }
    catch (e) {
        console.error(e.message);
        res.status(400);
        res.send({error: e.message});
        unlinkSync(req.file.path);
    }
});

app.listen(port, () => {
    console.log(`Now listening on port ${port}`);
});
