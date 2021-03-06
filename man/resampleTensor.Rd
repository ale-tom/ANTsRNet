% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resampleTensorUtilities.R
\name{resampleTensor}
\alias{resampleTensor}
\title{Resamples a spatial tensor.}
\usage{
resampleTensor(
  inputTensor,
  shape,
  interpolationType = c("nearestNeighbor", "linear", "cubic", "bicubic", "bilinear",
    "nearest")
)
}
\arguments{
\item{inputTensor}{tensor to be resampled.}

\item{shape}{vector or list of length 2 or 3 specifying the shape of the
output tensor}

\item{interpolationType}{type of interpolation for resampling.  Can be
\code{nearestNeighbor}, \code{linear}, or \code{cubic}.}
}
\value{
a tensor
}
\description{
Resamples a spatial tensor based on the specified shape and interpolation type.
}
\examples{

library( keras )

K <- keras::backend()

# 2-D spatial tensor

inputTensor <- K$ones( c( 2L, 10L, 10L, 3L ) )

outputTensor <- resampleTensor( inputTensor, c( 12, 13 ), 'nearestNeighbor' )
outputTensor <- resampleTensor( inputTensor, c( 12, 13 ), 'linear' )
outputTensor <- resampleTensor( inputTensor, c( 12, 13 ), 'cubic' )

# 3-D spatial tensor

inputTensor <- K$ones( c( 2L, 10L, 10L, 10L, 3L ) )

outputTensor <- resampleTensor( inputTensor, c( 12, 13, 14 ), 'nearestNeighbor' )
outputTensor <- resampleTensor( inputTensor, c( 12, 13, 14 ), 'linear' )
outputTensor <- resampleTensor( inputTensor, c( 12, 13, 14 ), 'cubic' )
rm(K)
rm(outputTensor)
rm(intputTensor)
gc()
}
\author{
Tustison NJ
}
