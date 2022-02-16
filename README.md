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
- Spaces suck: use snake_case for naming things: files, objects, variables, etc.

## How to talk about data

- Files have names. Always include the file path and name when referring to files.
- Websites have URLS. Always include the url when referring to websites.
- Use quotes or fonts to differentiate code and data names from regular english.

## How to solve coding errors and other issues

- Restart and try again
- Check your code for obvious issues - typos, symbols in the wrong place, etc.
- Google it! Include keywords: the language, library, and function you are using, as well as the error message.  
- Read the documentation for the software you are using. 
- Try to reproduce and isolation the issue with a minimal dataset and with as little code as possible.
  - Create a [reprex](https://reprex.tidyverse.org/) of your problem.  
- If you can't solve your issue and it seems rather basic, try posting on social media like reddit or twitter.   
- If it is a more complex issue and the question isn't already solved by what's on StackOverflow, post it there.   
- Include as much information as possible!
- Discuss what you've tried already and what the output was.

## Your toolbox

- Use R.
- Use Rstudio as your IDE. 
- Use `tidyverse` for data munging.    
- Use `tidymodels` for machine learning.  
- Use `ggplot2` for basic plotting.
- Use `patchwork` to combine basic plots.
- Use `ggiraph` to make your ggplots interactive
- Use `rmarkdown` to create static report files in html
- Use `shiny` to create interactive apps 

## Why not python

- R was designed for data analysis and statistics
- R's package management is better than python's
- ggplot2 is better than python offerings
- Rmarkdown is better than Jupyter
- Shiny is better than Dash
- Rstudio is a better editor than VScode

