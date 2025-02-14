# Speed HPC Facility

Speed: Gina Cody School HPC Facility: Scripts, Tools, and Refs

[Concordia University](https://concordia.ca), Montreal

[![DOI](https://zenodo.org/badge/166873072.svg)](https://zenodo.org/badge/latestdoi/166873072)

* [GCS Speed HPC Facility](https://www.concordia.ca/ginacody/aits/speed.html)
* The Speed Manual ([PDF](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf), [HTML](https://nag-devops.github.io/speed-hpc/))
* [AITS Service Desk](https://www.concordia.ca/ginacody/aits.html)
* [Job Script Generator](https://nag-devops.github.io/speed-hpc/generator.html)
## Examples

* [`src/`](src/) -- sample job scripts
* [`doc/`](doc/) -- user manual sources 

## Software List

* [EL7 and EL9 Software List](software-list.md) on Speed

## Contributing and TODO

* [Public issue tracker](https://github.com/NAG-DevOps/speed-hpc/issues)
* [Contributions (pull requests)](https://github.com/NAG-DevOps/speed-hpc/pulls) are welcome for your sample job scripts or links/references (subject to reviews)
* For Internal access and support requests, please see the GCS Speed Facility link above

### Contributors

* See the overall GitHub contributors [here](https://github.com/NAG-DevOps/speed-hpc/graphs/contributors)
* [Dr. Serguei A. Mokhov](https://github.com/smokhov) -- project lead
* Current HPC/Research support team: [Gillian A. Roper](https://github.com/yulgroper), [Carlos Alarcon Meza](https://github.com/carlos-encs), [Farah Salhany](https://github.com/salhanyf)
* [Dr. Tariq Daradkeh](https://github.com/tariqghd) helped us with continuous support of Speed and its users and working on scheduling prediction. He has also integrated the OpenISS YOLOv3 example
* [Anh H Nguyen](https://github.com/aaanh) contributed the [HTML](https://nag-devops.github.io/speed-hpc/) version of the manual and its generation off our LaTeX sources as well as the corresponding [devcontainer](https://github.com/NAG-DevOps/speed-hpc/tree/master/doc/.devcontainer) environment
* The initial Grid Engine V6 manual was written by Dr. Scott Bunnell

## References

### Conferences

* Tariq Daradkeh, Gillian Roper, Carlos Alarcon Meza, and Serguei Mokhov. **HPC jobs classification and resource prediction to minimize job failures.** In International Conference on Computer Systems and Technologies 2024 (CompSysTech ’24), New York, NY, USA, June 2024. ACM. [DOI: 10.1145/3674912.3674914](https://doi.org/10.1145/3674912.3674914)
* Serguei Mokhov, Jonathan Llewellyn, Carlos Alarcon Meza, Tariq Daradkeh, and Gillian Roper. 2023. **The use of Containers in OpenGL, ML and HPC for Teaching and Research Support.** In ACM SIGGRAPH 2023 Posters (SIGGRAPH '23). Association for Computing Machinery, New York, NY, USA, Article 49, 1–2. [DOI: 10.1145/3588028.3603676](https://doi.org/10.1145/3588028.3603676)

### Related Repositories

* [OpenISS Dockerfiles](https://github.com/NAG-DevOps/openiss-dockerfiles) -- the source of the Docker containers for the above poster as well as Singularity images based off it for Speed
* Sample complete more complex projects' repos than baby jobs based on the work of students and their theses:
    * https://github.com/NAG-DevOps/openiss-yolov3
    * https://github.com/NAG-DevOps/openiss-reid-tfk
    * https://github.com/NAG-DevOps/kg-recommendation-framework

### Educational

* [Linux and other tutorials from Software Carpentry](https://software-carpentry.org/lessons/)
* [Digital Research Alliance of Canada SLURM Examples](https://docs.alliancecan.ca/wiki/Running_jobs)
* Concordia's subscription to [Udemy resources](https://www.concordia.ca/it/services/udemy.html)

### Technical

* [Slurm Workload Manager](https://en.wikipedia.org/wiki/Slurm_Workload_Manager)
* [NVIDIA A100](https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/a100/pdf/nvidia-a100-datasheet-us-nvidia-1758950-r4-web.pdf)
* [NVIDIA V100](https://images.nvidia.com/content/technologies/volta/pdf/tesla-volta-v100-datasheet-letter-fnl-web.pdf)
* [NVIDIA Tesla P6](https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/solutions/resources/documents1/Tesla-P6-Product-Brief.pdf)
* [NVIDIA RTX 6000 Ada Generation](https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/rtx-6000/proviz-print-rtx6000-datasheet-web-2504660.pdf)
* [AMD Tonga FirePro S7100X](https://en.wikipedia.org/wiki/List_of_AMD_graphics_processing_units#FirePro_Server_Series_(S000x/Sxx_000))

### Legacy

Speed no longer runs Grid Engine; these are provided for reference only.

* [Altair Grid Engine (AGE)](https://www.altair.com/grid-engine/) (formely [Univa Grid Engine (UGE)](https://en.wikipedia.org/wiki/Univa_Grid_Engine))
* [UGE User Guide for version 8.6.3 (current version running on speed)](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/UsersGuideGE.pdf)
* [Altair product documentation](https://community.altair.com/community?id=altair_product_documentation)
