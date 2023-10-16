# Speed HPC Facility

Speed: Gina Cody School HPC Facility: Scripts, Tools, and Refs

[Concordia University](https://concordia.ca), Montreal

[![DOI](https://zenodo.org/badge/166873072.svg)](https://zenodo.org/badge/latestdoi/166873072)

* [GCS Speed HPC Facility](https://www.concordia.ca/ginacody/aits/speed.html)
* The Speed Manual ([PDF](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf), [HTML](https://nag-devops.github.io/speed-hpc/))
* [Overview Slides](https://docs.google.com/presentation/d/1zu4OQBU7mbj0e34Wr3ILXLPWomkhBgqGZ8j8xYrLf44/edit?usp=sharing)
* [AITS Service Desk](https://www.concordia.ca/ginacody/aits.html)

## Examples ##

* [`src/`](src/) -- sample job scripts
* [`doc/`](doc/) -- user manual sources 

## Contributing and TODO ##

* [Public issue tracker](https://github.com/NAG-DevOps/speed-hpc/issues)
* [Contributions (pull requests)](https://github.com/NAG-DevOps/speed-hpc/pulls) are welcome for your sample job scripts or links/references (subject to reviews)
* For Internal access and support requests, please see the GCS Speed Facility link above

### Contributors ###

* See the overall contributors [here](https://github.com/NAG-DevOps/speed-hpc/graphs/contributors)
* [Serguei A. Mokhov](https://github.com/smokhov) -- project lead
* HPC/Research support team: [Gillian A. Roper](https://github.com/yulgroper), [Carlos Alarcon Meza](https://github.com/carlos-encs), [Tariq Daradkeh](https://github.com/tariqghd)
* [Anh H Nguyen](https://github.com/aaanh) contributed the [HTML](https://nag-devops.github.io/speed-hpc/) version of the manual and its generation off our LaTeX sources as well as the corresponding [devcontainer](https://github.com/NAG-DevOps/speed-hpc/tree/master/doc/.devcontainer) environment
* The initial Grid Engine V6 manual was written by Dr. Scott Bunnell

## References ##

### Conferences ###

* Serguei Mokhov, Jonathan Llewellyn, Carlos Alarcon Meza, Tariq Daradkeh, and Gillian Roper. 2023. **The use of Containers in OpenGL, ML and HPC for Teaching and Research Support.** In ACM SIGGRAPH 2023 Posters (SIGGRAPH '23). Association for Computing Machinery, New York, NY, USA, Article 49, 1–2. [DOI: 10.1145/3588028.3603676](https://doi.org/10.1145/3588028.3603676)

### Related Repositories ###

* [OpenISS Dockerfiles](https://github.com/NAG-DevOps/openiss-dockerfiles) -- the source of the Docker containers for the above poster as well as Singularity images based off it for Speed
* Sample complete more complex projects' repos than baby jobs based on the work of students and their theses:
    * https://github.com/NAG-DevOps/openiss-yolov3
    * https://github.com/NAG-DevOps/openiss-reid-tfk
    * https://github.com/NAG-DevOps/kg-recommendation-framework

### Technical ###

* [Altair Grid Engine (AGE)](https://www.altair.com/grid-engine/) (formely [Univa Grid Engine (UGE)](https://en.wikipedia.org/wiki/Univa_Grid_Engine))
* [UGE User Guide for version 8.6.3 (current version running on speed)](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/UsersGuideGE.pdf)
* [Altair product documentation](https://community.altair.com/community?id=altair_product_documentation)
* [NVIDIA Tesla P6](https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/solutions/resources/documents1/Tesla-P6-Product-Brief.pdf)
* [AMD Tonga FirePro S7100X](https://en.wikipedia.org/wiki/List_of_AMD_graphics_processing_units#FirePro_Server_Series_(S000x/Sxx_000))
