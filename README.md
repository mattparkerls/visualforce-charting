Released in Winter ’12 – Visualforce Charting drew quite a bit of excitement from the Developer community…but very little since.  Sparse documentation for the new product and insufficient answers in the DeveloperForce forums has led me create this quick example of the capabilities of VF Charting

I’ve created an Inline Visualforce page on the Account object using all standard fields.  A total of 3 chart types are rendered on the page (bar with line graph, stacked bar, and gauge) that display Aggregate Result info of Opportunities for the current Account record. 

Please keep a JavaScript debugger on (or just check the Chrome JS console) while developing –  as the charts are rendered with JavaScript and will send error messages to the console rather than anywhere remotely useful in Salesforce.  Seriously - you will be pulling your hair out when nothing is rendering and you are receiving zero apex errors. 

More documentation: http://www.salesforce.com/us/developer/docs/pages/Content/pages_charting_overview.htm 