# super-harsh-guide-to-reserach-data-analysis
An introduction to working with research data

## Read This

Read these two papers and make a short list of their proposed rules.

- [Data Organization in Spreadsheets](https://www.tandfonline.com/doi/full/10.1080/00031305.2017.1375989)  
- [Good enough practices in scientific computing](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005510)

## Data Commandments

- Always make your data machine-readable
- Always save data in plain-text, non-proprietary formats.
- Make a column for each specific type of information
- Make a row for each observation
- Columns must have a specific type: number, date, category, or text
  - Don't write text in number columns! A long text explaining why a value is missing is of little value in analysis. Use a 'comments' column for 
- Numerical and categorical are the easiest data to use; 
  - Categories need to have labels that match (spelling and case).
  - Numbers 
- Free text data is nearly impossible to use; extract values of interest into separate columns where possible.
- You can use excel but save the data as comma-separated values
- Always write dates as YYYY-MM-DD (every other way is wrong)  
- Use 'NA' to indicate missing values.
- Don't use random symbols to indicate things.
- Don't use non-standard characters at all; eg. things like ˚ µ ˜ ß ∂ ƒ  ∑ ® † 
- 

## How to talk about data

- Files have names. Always include the file path and name when referring to files.
- Websites have URLS. Always include the url when referring to websites.
