% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/croppingAndPaddingUtilities.R
\name{padOrCropImageToSize}
\alias{padOrCropImageToSize}
\title{Pad or crop image to a specified size}
\usage{
padOrCropImageToSize(image, size)
}
\arguments{
\item{image}{Input ANTs image}

\item{size}{size of the output image.}
}
\value{
a padded/cropped image
}
\description{
Pad or crop image to a specified size
}
\examples{

library( ANTsR )

image <- antsImageRead( getANTsRData( "r16" ) )
paddedImage <- padOrCropImageToSize( image, c( 333, 333 ) )

}
\author{
Tustison NJ
}
