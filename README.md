<p align="right"><img align="center" src="https://raw.githubusercontent.com/xvoland/xvoland/main/images/qr_extract.png" alt="DOTOCA Ltd." height="50" width="50" /></a>
</p>

Command/function `extract` in your console
=================================
Looking to extract a diverse range of file formats on your Mac or Linux? Look no further than the versatile `extract` command, designed to handle just about any file you throw at it! With built-in support for an extensive list of formats including .zip, .rar, .bz2, .gz, .zlib, .tar, .tbz2, .tgz, .Z, .7z, .xz, .exe, .tar.bz2, .tar.gz, .tar.xz, .arj, .cab, .chm, .deb, .dmg, .iso, .lzh, .msi, .rpm, .udf, .wim, .xar .cpio, .cbr, .cbz, .cb7, .cbt, .cba, .apk, .zpaq, .arc, .ciso, .zst, tar.zst and .vhd - you can rest assured that your extraction needs will be met with ease.

`extract` utilizes free unpackers to ensure support for even the most obscure and outdated file types. Give `extract` a try and streamline your file extraction process today!

<br />

Description
-------------------------

This is a Bash function called "extract" that is designed to extract a variety of file formats. It takes one or more arguments, each of which represents a file or path that needs to be extracted. If no arguments are provided, the function displays usage instructions.

The function uses a case statement to determine the appropriate extraction method for each file type, and then calls the corresponding command. For example, if the file is a ZIP archive, the function uses the "unzip" command to extract its contents.

If the file is not recognized as a valid archive, the function displays an error message and returns an error code of 1.

Before running the function, the value of the Internal Field Separator (IFS) is saved so that it can be restored at the end of the function. This is done to prevent unwanted word splitting and filename expansion when processing file paths.

Overall, this function provides a convenient way to extract a wide variety of archive formats using a single command, simplifying and streamlining the extraction process.


<br /><br />
How to install (macOS)
-------------------------

### macOS / OSX / Mac OS X
Add the highly convenient Copy & Paste functionality to your file management arsenal by simply including the appropriate code into your `~/.bash_profile` file. With this modification, you'll be able to breeze through your file manipulation tasks with ease and efficiency.

or

add command into file `~/.bash_profile` or `~/.zshrc` or `~/.functions`

```bash
export PATH=<path_to_file>/extract.sh:$PATH
```

```bash
source <path_to_file>/extract.sh
```

So don't delay, update your `~/.bash_profile` today and supercharge your file management capabilities!

or
```bash
curl -L -o install_extract.sh https://raw.githubusercontent.com/xvoland/Extract/master/install_extract.sh && bash install_extract.sh && rm install_extract.sh
```

<br />

### Ubuntu / *nix

Copy&Paste function into file `~/.bashrc`


<br /><br />
How to Use the Installer
-------------

Copy the above code into a file, for example, install_extract.sh.

#### Download:

```bash
git clone https://github.com/xvoland/Extract.git
cd Extract
```

#### Make the script executable:

```bash
chmod +x install_extract.sh
```

#### Run the script:

```bash
./install_extract.sh
```


<br /><br />
How it use
----------

Using command `extract`, in a terminal

```bash
$ extract <archive_filename.extention>
```

```bash
$ extract <archive_filename_1.extention> <archive_filename_2.extention> <archive_filename_3.extention> ...
```

<br />

### Donation

Regardless of whether funding is obtained or not, I will persist in refining the script's capabilities because it brings me joy to witness people using it and achieving their goals. However, I would be grateful for any support you could offer in offsetting the costs of hosting the domain and the time spent programming, which would otherwise encroach on my precious family time.

[Donate any amount for my projects][paypal]


<a href='https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9D4YBRWH8QURU'><img alt='Click here to lend your support to Extractor and make a donation!' src='https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif' border='0' /></a>

---
![GitHub stats](https://github-readme-stats.vercel.app/api?username=xvoland&show_icons=true&theme=radical&hide_border=true)

<br />


## ⚠️ Sponsors
Extract community? Help us keep it alive by donating funds to cover project expenses!

### Crypto

**BTC (ERC20):** 0x17496b75d241d377334717f8cbc16cc1a5b80396<br />
**USDT (TRC20):** TAAsGXjNoQRJ7ewxSBL2W3DUCoG7h8LCT6

### Other

[Become a sponsor][opencollective]

[<img src="https://opencollective.com/extract/backers/0/avatar">][opencollective]
<br />

## ⛔ License
&copy; 2013, [Vitalii Tereshchuk][home] via MIT license.
<br />

## Other
### ☎️  Connect with me:

<p align="left">
  <a href="https://youtube.com/xvoland" target="blank"><img align="center" src="https://raw.githubusercontent.com/xvoland/xvoland/main/images/youtube.svg" alt="Youtube channel" height="30" width="40" /></a>
  <a href="https://instagram.com/xvoland" target="blank"><img align="center" src="https://raw.githubusercontent.com/xvoland/xvoland/main/images/instagram.svg" alt="xVoLAnD" height="30" width="40" /></a>
  <a href="https://www.linkedin.com/in/vitalij-terescsuk-02b4689/" target="blank"><img align="center" src="https://raw.githubusercontent.com/xvoland/xvoland/main/images/linked-in-alt.svg" alt="xVoLAnD" height="30" width="40" /></a>
  <a href="https://dotoca.net" target="blank"><img align="center" src="https://raw.githubusercontent.com/xvoland/xvoland/main/images/logo-dotoca.svg" alt="DOTOCA Ltd." height="50" width="80" /></a>
</p>

<br />
<br />

---

📺 Latest YouTube Videos
<!-- YOUTUBE:START -->
- [UAH 10 coins 2024 Ukraine’s New Medical Forces Coin. What is the price of the coin?](https://www.youtube.com/watch?v=qdtfhG7LqXg)
- [AI Avatar Demo](https://www.youtube.com/watch?v=EJhAssYHNNI)
- [ iPhone More Protection Against Theft  iOS18 Stolen Device Protection](https://www.youtube.com/watch?v=I4pHVACAEYs)
- [NO LUT. Vintage Nikon D3100 DSLR as movie cam. Test Cinematic Look](https://www.youtube.com/watch?v=KQkXScIb0rk)
- [Test Human Lungs](https://www.youtube.com/watch?v=AVCS3tARVuI)
<!-- YOUTUBE:END -->

➡️ [more videos...][youtube]


[home]: http://dotoca.net
[paypal]: https://paypal.me/xvoland
[youtube]: https://youtube.com/xvoland
[instagram]: https://www.instagram.com/xvoland/
[opencollective]: https://opencollective.com/extract/backers/0/website