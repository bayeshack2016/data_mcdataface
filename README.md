# data_mcdataface
**

How can data help us heal communities at high risk for suicide?
---------------------------------------------------------------------

**

**Introduction**
Suicide is a major public health concern. Over 41,000 people die by suicide each year in the United States; it is the 10th leading cause of death  overall. Suicide is tragic. But it is often preventable. Knowing the risk factors for suicide and who is at risk can help reduce the suicide rate. There are approximately 300 deaths per year on railroads, usually a result of traffic accidents or suicides. 
We have focused our efforts to study the various data sets available to derive insights that can help the authorities plan and implement policies to aid the high risk communities.

**Methodology**

 - Identify the prompt data, create data dictionary
 - Research railway suicides (trends, causes, history) - see additional references
 - Identify additional sources of data
 - Retrieve data at the county level; merge with the prompt data
 - Build base models - use R to find coefficients

**Data Processing**

 - The prompt data has railway incidents dating back 1975. However, the Federal Railway Authority (FRA) did not require records of suicides until 2011. Therefore, we concentrated all analysis on data from 2011 forward.
 - We considered at the advice of the Judge that he would like to see data at the city/metropolitan level. All the data we had collected up to this point was county, but we thought to change paths anyway. In the end, we reverted back to county level analysis. There is very minimal data available to us on railway suicides; with only one or two suicides in any one city over 5 years of data, the results would not be significant or insightful.

**References**

 http://transweb.sjsu.edu/PDFs/research/1129-2-preventing-suicide-on-US-rail-systems.pdf
 http://railwaysuicideprevention.com/railway-fatalities/overview.html#suicide
 https://drive.google.com/file/d/0B-velHZJGPpOVF9ueHJsNWI0ZUk/view
 http://safetydata.fra.dot.gov/OfficeofSafety/default.aspx
 http://oli.org/about-us/news/statistics
 http://safetydata.fra.dot.gov/OfficeofSafety/Default.aspx
https://slack-files.com/files-pri-safe/T03V9PS2W-F0ZGP3WHX/fraguideforpreparingaccincreportspubmay2011__1_.pdf?c=1460357663-0a36f0ea3c2c6fd1b674cf33076f9b29681047ab
http://www.lse.ac.uk/geographyAndEnvironment/whosWho/profiles/neumayer/pdf/Article%20in%20Cross-Cultural%20Research.pdf
http://bjp.rcpsych.org/content/187/1/49
http://www.stat.columbia.edu/~madigan/DM08/descriptive.ppt.pdf https://safetydata.fra.dot.gov/officeofsafety/Documents/Railroad%20Safety%20Data%20Frequently%20Asked%20Questions.pdf?V=9
http://www.ntsb.gov/news/events/Documents/2015_trespassing_FRM_Pres10GabreeVolpe1(2).pdf
http://faculty.wcas.northwestern.edu/~ipsavage/211.pdf
https://www.nimh.nih.gov/health/topics/suicide-prevention/index.sh

**Our data team**

 1. Angela Gunn 
2. Hetal Chandaria
3. Karthik Chepudira
4. Prabhakar Gundugola
5. Deepesh Chaudri

**Future research topics**

 Proximity Analysis of the incidents to the following HIFLD geospatial datasets.

1. Railroad Bridges
2. Road and Railroad Tunnels
3. Railroads
4. Intermodal Terminal Facilities
5. Weigh in Motion Stations
6. Fixed Guideway Transit Links
7. Automatic Traffic Recorder (ATR) Stations
8. Fixed Guideway Transit Stations
9. Amtrak Stations
10. Rail Junctions
11. National Bridge Inventory (NBI) Bridges
