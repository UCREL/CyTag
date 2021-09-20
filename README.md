# CyTag

### A collection of surface-level natural language processing tools for Welsh

*CyTag* is a collection of surface-level natural language processing tools for Welsh, including:

* text segmenter (*cy_textsegmenter*)
* sentence splitter (*cy_sentencesplitter*)
* tokeniser (*cy_tokeniser*)
* part-of-speech (POS) tagger (*cy_postagger*)

As well as being run individually, the `CyTag.py` script allows for all of the tools to be run in sequence as a complete pipeline (the default option) or for a customised pipeline to be specified. Please see further sections of this file for more information on running the individual tools, the full default pipeline, or customised pipelines.

*CyTag* has been developed at Cardiff University as part of the [CorCenCC](http://www.corcencc.org) project.

## Releases

A quick note on [releases](https://github.com/UCREL/CyTag/releases). You will notice that we have two release versions, this can sometimes be best seen in the [tags tab on GitHub](https://github.com/UCREL/CyTag/tags):
1. Version 1.x.x
2. Version 2.x.x

### Version 1.x.x

This relates most directly to the version that was published in the original paper, [Leveraging Lexical Resources and Constraint Grammar for Rule-Based
Part-of-Speech Tagging in Welsh](https://aclanthology.org/L18-1623.pdf). This version will not have any changes to the actual tagger, but rather some code maybe added to make it easier to evaluate and run the tagger. The branch this is being developed on is the [**v1.0 branch.**](https://github.com/UCREL/CyTag/tree/v1.0)

### Version 2.x.x

This is the most updated version that is being actively developed on. **These changes may included changes to the Part Of Speech tagset, and other changes to the taggers compared to version 1.x.x.**. The branch this is being developed on is the [**main branch.**](https://github.com/UCREL/CyTag/tree/main)

## Dependencies

*CyTag* has been developed and tested on [Ubuntu](https://www.ubuntu.com/), and so these instructions should be followed with this in mind.

*CyTag* is written in [Python](https://www.python.org/), and so a recent version of *python3* should be downloaded before using the tools. Downloads for *python* can be found at https://www.python.org/downloads/ (version 3.5.1 recommended).

The following *python* libraries will be needed to run various *CyTag* components. *CyTag* will check for them and will stop running if they are missing:
* [lxml](https://lxml.de/)
* [progress](https://github.com/verigak/progress)
* [NumPy](http://www.numpy.org/)
* [unicodedata2](https://pypi.org/project/unicodedata2/)

All of these python pip dependencies can be found in the [requirements.txt file](./requirements.txt).

*CyTag* depends on having a working version of VISL's [Constraint Grammar v3](http://visl.sdu.dk/cg3.html) (a.k.a. CG-3). For Ubuntu/Debian, a pre-built CG-3 package can be easily installed from a ready-made nightly repository:

```bash
wget https://apertium.projectjj.com/apt/install-nightly.sh -O - | sudo bash
sudo apt-get install cg3
```

See http://visl.sdu.dk/cg3/chunked/installation.html for installation instructions for other platforms.

**You can run the *CyTag* package through a docker container**, to do so see the [docker section below.](#docker)

## Usage

With *python* and *CG-3* installed, *CyTag* can then be run from the command line.

In all examples, `*PATH*` refers to the path leading from the current directory to the directory in which the *CyTag* folder is located.


## Passing input files to CyTag

In *Linux*, the following command will run the full, default pipeline over two input files, named `file1.txt` and `file2.txt`:

```bash
python3 *PATH*/CyTag/CyTag.py -i file1.txt file2.txt -n cytag_test -d cytag_test_2018-08-03 -f all
```

### Required arguments

#### -i/--input

The Welsh input file or files to be processed. 

### Optional arguments

#### -n/--name

A name to be used for the saved output text and files.

#### -d/--dir

A folder to be created in `*PATH*/CyTag/outputs/` and into which the output files from running *CyTag* will be saved.

#### -c/--component

Specify a specific part of the *CyTag* pipeline to run to. By default, the entire pipeline (text segmenter -> sentence splitter -> tokeniser -> part-of-speech tagger) is run. Currently supported components include: 'seg', 'sent', 'tok', 'pos'.

#### -f/--format

A file format to print output to. Currently supported formats include: 'tsv', 'xml', 'all'.


## Passing a string of text to CyTAG

Alternatively, a single text string (enclosed in quotation marks) can be passed as an argument to *CyTag*, which will run the full pipeline up to the POS tagger and return TSV values for each token to the standard output:

```bash
python3 *PATH*/CyTag/CyTag.py "Dw i'n hoffi coffi. Dw i eisiau bwyta'r cynio hefyd!"
```


## Taking input text from standard input

*CyTag* also accepts Welsh text passed via standard input. For example, in *Linux*:

```bash
echo "Dw i'n hoffi coffi. Dw i eisiau bwyta'r cynio hefyd!" | python3 *PATH*/CyTag/CyTag.py
```

```bash
cat example.txt | python3 *PATH*/CyTag/CyTag.py
```

```bash
python3 *PATH*/CyTag/CyTag.py < example.txt
```

## Docker

You can run the *CyTag* package through the provided docker container like so: 

**NOTE: if this is the first time you have used the docker container it will first download the container and then run it.**

``` bash
docker run --rm ghcr.io/ucrel/cytag:1.0.4 "Dw i'n hoffi coffi. Dw i eisiau bwyta'r cynio hefyd!"
```
Output from running the command above:
```txt
1       Dw      1,1     bod     B       Bpres1u
2       i       1,2     mi      Rha     Rhapers1u
3       'n      1,3     yn      U       Uberf
4       hoffi   1,4     hoffi   B       Be
5       coffi   1,5     coffi   E       Egu
6       .       1,6     .       Atd     Atdt
7       Dw      2,1     bod     B       Bpres1u
8       i       2,2     mi      Rha     Rhapers1u
9       eisiau  2,3     eisiau  E       Egu
10      bwyta   2,4     bwyta | bwyta   B | B   Be | Bgorch2u
11      'r      2,5     y       YFB     YFB
12      cynio   2,6     cynio   B       Be
13      hefyd   2,7     hefyd   Adf     Adf
14      !       2,8     !       Atd     Atdt
```

All of the arguments after `docker run --rm ghcr.io/ucrel/cytag:latest` will be passed directly to [CyTag.py](./CyTag.py).

The docker container is [hosted on GitHub as a package](https://github.com/UCREL/CyTag/pkgs/container/cytag). By default the container runs as the user `nobody`, which is a random non-root user, on a debian based operating system. For more information on how the docker container was created see the [dockerfile](./dockerfile).

### Examples

Below we list some examples on how to use the docker container:

1. **Taking input text from standard input**
``` bash
cat example.txt | docker run -i --rm ghcr.io/ucrel/cytag:latest
```
2. **Running on a text file with XML output**
```bash
# The first command runs cytag over the file called test.txt
docker run -v $(pwd)/test.txt:/tmp/test_file.txt --name cytag ghcr.io/ucrel/cytag:1.0.4 -f xml -n example -i /tmp/test_file.txt
# This command copies the outputs directory to a new directory that will be created called `docker_output`
docker cp cytag:/usr/nobody/CyTag-1.0/outputs ./docker_output
docker rm -f cytag # removes the container
``` 
Within the copied directory called `docker_output` will be another directory called `example`. Within the `example` directory will be the `xml` output in a file called `example.xml`.

## Contact

Questions about *CyTag* can be directed to: 
* Steve Neale <<steveneale3000@gmail.com>> <<NealeS2@cardiff.ac.uk>>
* Kevin Donnelly <<kevin@dotmon.com>>
* Dawn Knight <<KnightD5@cardiff.ac.uk>>


## License

*CyTag* is available under the GNU General Public License (v3), a copy of which is included with this repository.