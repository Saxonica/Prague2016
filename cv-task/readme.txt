The files in this folder are part of an assignment for LexisNexis, which requested to 

- take the original CV
- create a model in sketch
- turn it into an XSD (or RelaxNG or other schema language)
- create an XSLT 2.0 file that creates an HTML (or other format) of the same CV
- describe the process


This package contains the files that are the result of this assignment. 

## CV
The file cv-original.pdf contains the original CV

## readme.txt
This file

## Model of CV
The file cv-model-simplified-sketch.png is a sketch-like model without data-types etc. It can be seen as a view of the mental model drawn on the white board prior to starting the assignment.

The file cv.svg is a clickable view (viewable in Firefox or Chrome, but not IE) of the XSD model.

The file cv.xsd is the actual XSD model. It is necessarily a straightforward model, considering the allowed time to work on it.

The file cv.xml is the instance document.

## XSLT approach
I chose to use a two-way approach:

step 1: transform the model into a simplified tabular XML format using nested section/row/cell approach, which translates well for this particular tasks and allows for easy adoption to other formats (xslfo, wordml, html, tex)

step 2: transform the doc-model in HTML. This is now a straightforward excercise

The file cv.xslt is used for step 1 and uses XSLT 3.0 with schema-aware processing for both input and output. Use schema mode "strict" (without schema-awareness I've programmed it such that it throws an error).

## Model of cv-doc
The file cv-doc-model-simplified-sketch.png is a sketch-like model without data-types etc. It can be seen as a view of the mental model drawn on the white board prior to starting the assignment.

The file cv-doc.svg is a clickable view (viewable in Firefox or Chrome, but not in IE) of the XSD model.

The file cv-doc.xsd is the actual XSD model of the intermediate "DOC" format. Straightforward for obvious reasons.

The file cv-doc.xml is an example file of an instance of this XSD model. It is based on the XSLT 3.0 processing step 1 mentioned above and should be recreated whenever the original data file changes.

The file cv-doc.xslt is the file used for step 2 (it creates HTML 5) and uses XSLT 3.0 without schema-aware processing (I ran out of time), though a schema is available and should be used. Of mild interest may be the sorting applied to create a three-file column newspaper style from a single file input, while maintaining the original order (reading direction top to bottom, left to right).

## Auxiliary
The file cv.css is used as input for the styling of the HTML 5 output and is embedded by the processor. It can be set using the parameter $css.

The file cv-xsdview.css is used by the SVG views of the model and it must be in the same directory as the SVG files to work.

## Conclusion
All in all I did spent a little bit more time (not in the least because something went wrong with sending and I am doing this excercise now for the second time, where the first time had a RelaxNG (+XSD variant) model and XSLFO output, I chose to create XSD and HTML this time, to hopefully merge the two methods together.

Most *extra* time was spent in finetuning of the CSS styling of the output. I didn't time it exactly, but I think that CV XSD and initial two-step transform took me about 3 hours. The extra XSD I created for convenience. The SVG files were created automatically.

I used oXygen for all development. The resulting XSLT is Saxon 9.6 compatible.

I chose XSLT 3.0 over XSLT 2.0 for speed of development. Plus it illustrates the use of maps, higher order functions, partial function application, simple mapping operator, and not in the least, text value templates. If XSLT 2.0 is a strict requirement then I apologize, it is trivial though to downgrade the XSLT into 2.0 if necessary.

About the bonus points: I'm afraid I went a little bit off-track. Of the four points mentioned, three are trivial and all of them are in abundance in the XT3 test-set that I maintain for the XSLT 3.0 specification. If you like me to elaborate, I can do that of course :).

Since this project contains my personal data, I assume that it will be taken care of with the necessary precautions.

Thanks for an interesting excercise!

Abel Braaksma
abel@exselt.net