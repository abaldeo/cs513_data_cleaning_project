# CS 513: Theory and Practice of Data Cleaning - Final Project 
This group project focuses on conducting an end-to-end data cleaning project using various tools and techniques covered in the UIUC CS513 course. The goal is to enhance the data quality of a selected dataset and prepare it for data analysis. The project consists of two phases, each with specific deliverables.

## Phase-I

In this phase, we will perform the following tasks:

1. **Dataset Selection:** Choose a dataset of interest from the provided options (CD database, NYPL historic menus, PPP loan applications, etc.).

2. **Dataset Description:** Provide a comprehensive description of the dataset, including a conceptual model (ER diagram), ontology, or database schema. Additionally, include a narrative that explains the data's origin and relevant metadata, such as temporal or spatial extent.

3. **Use Case Development:**

   - **Target (Main) Use Case (U1):** Define a use case that requires data cleaning to support a specific data analysis objective. After performing data cleaning, the resulting cleaned dataset (D') should be fit-for-purpose for this use case.

   - **"Zero Data Cleaning" Use Case (U0):** Identify a use case that does not require any data cleaning, as the dataset (D) is already suitable for this analysis.

   - **"Never Enough" Use Case (U2):** Create a use case where no amount of data cleaning or wrangling can make the dataset (D) suitable for the analysis (U2).

4. **Identifying Obvious Data Quality Problems:** Document the data quality problems that are easily noticeable during Phase-I. These problems should support the claim that data cleaning is necessary and sufficient for the main use case (U1).

5. **Initial Data Cleaning Plan:** Develop an initial plan outlining the steps to clean the dataset in Phase-II. The plan should include the following:

   - S1: Describe the dataset (D) and its matching use case (U1).
   - S2: Profile the dataset (D) to identify quality problems (P) that need to be addressed to support U1.
   - S3: Specify the data cleaning process and tools to be used (e.g., OpenRefine, Python).
   - S4: Outline how to validate the cleaned dataset (D') and demonstrate improvements for U1.
   - S5: Document the types and amount of changes made to D to obtain D'.


### Phase II

In Phase II, we will perform the actual data cleaning process according to the plan developed in Phase I. The cleaned dataset will be validated and evaluated for improvements in addressing the defined use case.


## Project Phases and Deliverables

- Phase 1
    - Regular Deadline July 2nd 
    - Hard deadline July 9th

## Additional Information

- Use cases can be described in short paragraphs or formulated as specific questions or database queries.
- To document data quality problems, include snippets or screenshots of the "dirty data" along with narrative descriptions.
- Provide a clear and concise plan for the data cleaning process, including assigned tasks for each team member.

## Tools and Resources

During the project, the following tools and resources may be utilized:

- Regular expressions (RegEx)
- OpenRefine
- Datalog
- SQL
- Python, Pandas, Numpy 
- Data visualization libraries (e.g., Matplotlib, Seaborn)
- Workflow Provenance tools (e.g., YesWorkflow, or2yw)
- Commercial tools (e.g., Trifacta Wrangler, Tableau)

In the project report, we will document how and when these tools were used.

## Team Members
- @abaldeo: Responsible for Task 2 (ER Diagram, DB Schema, Write description of dataset origin  )
- @geoashley: Responsible for Task 3, 5 (Use cases, Phase 1 Plan)
- @ctheara: Responsible for Task 4 (EDA to find DQ Issues)


Feel free to add more information and sections to this README file as necessary. 