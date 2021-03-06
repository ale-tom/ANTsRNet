% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/croppingAndPaddingUtilities.R
\name{cropImageCenter}
\alias{cropImageCenter}
\title{Crop the center of an image.}
\usage{
cropImageCenter(image, cropSize)
}
\arguments{
\item{image}{Input ANTs image}

\item{cropSize}{width, height, depth (if 3-D), and time (if 4-D) of
the cropped image.}
}
\value{
a cropped image
}
\description{
Crop the center of an image.
}
\examples{

library( ANTsR )

image <- antsImageRead( getANTsRData( "r16" ) )
croppedImage <- cropImageCenter( image, c( 64, 64 ) )

}
\author{
Tustison NJ
}
