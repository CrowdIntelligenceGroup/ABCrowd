# ABCrowd: An Auction Mechanism on Blockchain for Spatial Crowdsourcing

ABCrowd is an auction mechanism designed to run entirely on Ethereum Blockchain within a crowdsourcing platform. ABCrowd uses the Repeated-Single-Minded Bidder (R-SMB) auction mechanism, which motivates workers to bid truthfully before allocating them to tasks and calculating their payments. On the other hand, Blockchain and smart contracts guarantee trusted execution for the crowdsourcing platform by the autonomous and transparent on-Chain execution.

The current version is developed on the Ethereum network using Solidity Language. It has one smart contract constituting the auction mechanism.

# Research Team

<b>PhD Candidate</b>

Maha Kadadha (Khalifa University, UAE) 

<b>Research Supervisors</b>

Hadi Otrok (Khalifa University, UAE)

Rabeb Mizouni (Khalifa University, UAE)

Shakti Singh (Khalifa University, UAE)

Anis Ouali (EBTIC, UAE)

# Abstract
In this paper, a fully distributed auction-blockchain-based crowdsourcing framework is proposed-ABCrowd. In a typical crowdsourcing framework, independent workers compete to be allocated requesters' tasks. These workers advertise their costs to the centralized platform, which then decides the final allocation of tasks. While performing the allocation, centralized platforms face two main challenges: 1) how to ensure trusted execution for the allocation of tasks, and 2) how to motivate workers to declare their truthful costs. To address these challenges, ABCrowd proposes to run the crowdsourcing platform entirely on Ethereum Blockchain while incorporating auctions. Blockchain and smart contracts guarantee trusted execution for the allocation through autonomous and transparent on-Chain execution. ABCrowd uses the Repeated-Single-Minded Bidder (R-SMB) auction mechanism, which motivates workers to bid truthfully before allocating them and calculating their payments. R-SMB is an approximation of the optimized off-Chain Vickrey-Clarke-Groves (VCG) mechanism in terms of maximized profit. It entails repeating the Single-Minded Bidder (SMB) auction mechanism to meet the allocation requirement of crowdsourcing applications. ABCrowd is implemented and evaluated using Solidity on a private Ethereum Blockchain, where a real publicly available dataset is used. The proposed on-Chain R-SMB auction mechanism is compared to the off-Chain VCG mechanism, where the results show that R-SMB provides similar performance to VCG in terms of the average number of allocated tasks. Furthermore, R-SMB outperforms VCG in workers' travelled distance and requesters' costs, at a low execution cost.

# Citation
If you are using any part of ABCrowd, please cite our paper.

<a href="https://ieeexplore.ieee.org/document/8955886">Journal</a> |
<a href="https://www.researchgate.net/publication/338523572_ABCrowd_An_Auction_Mechanism_on_Blockchain_for_Spatial_Crowdsourcing">ResearchGate</a> | <a href="https://www.youtube.com/watch?v=dtVfuHliFgU&t=12s">Youtube</a> 

<b> Text </b>
M. Kadadha, R. Mizouni, S. Singh, H. Otrok and A. Ouali, "ABCrowd An Auction Mechanism on Blockchain for Spatial Crowdsourcing," in IEEE Access, vol. 8, pp. 12745-12757, 2020, doi: 10.1109/ACCESS.2020.2965897.

<b> BibTex </b>
@ARTICLE{8955886,  author={M. {Kadadha} and R. {Mizouni} and S. {Singh} and H. {Otrok} and A. {Ouali}},  journal={IEEE Access},   title={ABCrowd An Auction Mechanism on Blockchain for Spatial Crowdsourcing},   year={2020},  volume={8},  number={},  pages={12745-12757},  doi={10.1109/ACCESS.2020.2965897}}
