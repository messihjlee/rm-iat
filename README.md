# RM-IAT: Implicit Bias-Like Patterns in Reasoning Models

**Authors:** Messi H.J. Lee (Washington University in St. Louis), Calvin K. Lai (Rutgers, The State University of New Jersey)

This repository contains the analysis and data-collection **code** used in our paper introducing the Reasoning Model Implicit Association Test (RM-IAT), a method for measuring implicit bias-like *processing* in reasoning models — LLMs that generate step-by-step reasoning before producing a final answer — by comparing reasoning token usage across association-compatible vs. association-incompatible task conditions.

Five reasoning models are examined: **o3-mini**, **DeepSeek-R1**, **gpt-oss-20b**, **Qwen3-8B**, and **Claude 3.7 Sonnet**.

This is the code companion to a CodeOcean reproducible capsule and a Figshare data deposit; see [Data & Code Availability](#data--code-availability) below.

## Repository Contents

```
rm-iat/
├── environment/           # Docker image specification (RStudio Server, R 4.5.1)
├── .codeocean/             # CodeOcean environment configuration
├── metadata/                # Capsule metadata + full pipeline documentation
│   ├── metadata.yml
│   └── README.md            # Detailed structure, data schema, replication steps
└── code/
    ├── run                  # Bash entry point (calls Rscript analyze/rmiat/main.R)
    ├── analyze/              # All analysis scripts (mixed models, effect sizes, STM, viz)
    ├── collect/               # Data-collection scripts (RM-IAT, per model)
    └── collect_downstream/     # Data-collection scripts (WAT & Resume Decision Task)
```

For the full repository structure, per-script descriptions, data schema, and step-by-step replication instructions, see **[metadata/README.md](metadata/README.md)**.

## Data & Code Availability

- **Code (this repository):** https://github.com/messihjlee/rm-iat — archived version: `<Zenodo/GitHub-release DOI — to be added>`
- **Reproducible capsule (CodeOcean):** `<CodeOcean capsule DOI — to be added>`
- **Data (Figshare):** `<Figshare DOI — to be added>` — contains all raw RM-IAT, WAT, and Resume Decision Task datasets (see [metadata/README.md](metadata/README.md#data) for the data schema).

To reproduce the analyses, download the data deposit from Figshare into a `data/` directory alongside `code/` (matching the layout documented in [metadata/README.md](metadata/README.md)), or use the CodeOcean capsule, which bundles code, data, and environment together for a one-click reproducible run.

## Environment

The analyses run in a Docker container built on RStudio Server (Ubuntu 22.04, R 4.5.1); see `environment/Dockerfile` and [metadata/README.md](metadata/README.md#environment--dependencies) for pinned package versions and local (non-Docker) setup instructions.

## Citation

If you use this code, please cite it — see [CITATION.cff](CITATION.cff). A citation for the associated paper will be added once published.

## License

Code is released under the **MIT License** (see [LICENSE](LICENSE)). The data deposited on Figshare is released under a separate license — see the Figshare record.
