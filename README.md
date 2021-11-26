# Robotic Coffee Shop

## Artificial Intelligence for Robotics II - Assignment I 
Muhammad Ali Haider Dar, _[5046263@studenti.unige.it](mailto:5046263@studenti.unige.it)_

MSc Robotics Engineering, University of Genoa, Italy

Instructor: [Prof. Mauro Vallati](https://pure.hud.ac.uk/en/persons/mauro-vallati)

## Overview

The assignment focused on the operational usage of a PDDL-based AI planner **_ENHSP-20_** and tested the understanding of planning models. It was inspired by a few robotic coffee shops functional in Japan, which used robots as waiters and baristas. The tasks reimagined a similar scenario involving a robot waiter, a robot barista, customers, and four tables. It attempted to efficiently model the scenario in such a way that the robots plan and perform their tasks effectively as the number of customers increases.

## Planner

The planning engine used for this project was ENHSP-20. ENHSP, acronym for Expressive Numeric Heuristic Search Planner, is a PDDL automated planning system which reads domain and problem files as input and provides a time-stamped sequence of actions to achieve the goal state. This planning engine builds an incremental graph and does a heuristic search to explore only the nodes which gets the planner closer to the goal. The details for ENHSP can be accessed _[here](https://sites.google.com/view/enhsp/)_.

## Running the Project

1. The ENHSP planner has a Java dependency which can be met by Java version 16.0.1 in Ubuntu 20.04. Run the following lines successively on command terminal to download and install the required jdk:
```
sudo dpkg -i jdk-16.0.1_linux-x64_bin.deb
```
```
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-16.0.1/bin/java 1
```
```
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-16.0.1/bin/javac 1
```

2. In your workspace, clone the ‘enhsp-20’ branch of ENHSP planner:
```bash 
git clone -b enhsp-20 https://gitlab.com/enricos83/ENHSP-Public.git
```

3. Make the files executable:
```bash
chmod +x ./enhsp
```

4. Navigate to the assignment folder:
```bash
cd <assignment_folder>
```

5. Run the planner specifying the domain file airo2-domain.pddl and each of the problem files, for example airo2-problem-1.pddl file:
```bash
/root/Desktop/enhsp/ENHSP-Public/enhsp -o airo2-domain.pddl -f airo2-problem-2.pddl
```

6. The terminal output generated using the above command can also be exported in text file format by adding > <file_name>.txt after the above command, for example:
```bash
/root/Desktop/enhsp/ENHSP-Public/enhsp -o airo2-domain.pddl -f airo2-problem-2.pddl > airo2-problem-2-output.txt
```
