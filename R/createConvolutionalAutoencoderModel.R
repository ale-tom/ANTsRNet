#' Function for creating a 2-D symmetric convolutional autoencoder model.
#'
#' Builds a convolutional autoencoder based on the specified array
#' definining the number of units in the encoding branch.  Ported to
#' Keras R from the Keras python implementation here:
#'
#' \url{https://github.com/XifengGuo/DCEC}
#'
#' @param inputImageSize vector definining spatial dimensions + channels
#' @param numberOfFiltersPerLayer vector defining the number of convolutional
#' filters in the encoding branch per layer
#' @param convolutionKernelSize kernel size fo the convolutional filters
#' @param deconvolutionKernelSize kernel size fo the convolutional transpose
#' filters
#'
#' @return two models:  the convolutional encoder and convolutional auto-encoder
#'
#' @author Tustison NJ
#' @examples
#'
#' library( ANTsRNet )
#' library( keras )
#'
#' ae <- createConvolutionalAutoencoderModel2D( c( 32, 32, 1 ) )
#'
#' @export

createConvolutionalAutoencoderModel2D <- function( inputImageSize,
                                                   numberOfFiltersPerLayer = c( 32, 64, 128, 10 ),
                                                   convolutionKernelSize = c( 5, 5 ),
                                                   deconvolutionKernelSize = c( 5, 5 ) )
{
  activation <- 'relu'
  strides <- c( 2, 2 )

  numberOfEncodingLayers <- length( numberOfFiltersPerLayer ) - 1

  factor <- 2^numberOfEncodingLayers

  padding <- 'valid'
  if( inputImageSize[1] %% factor == 0 )
    {
    padding <- 'same'
    }

  inputs <- layer_input( shape = inputImageSize )

  encoder <- inputs

  for( i in seq_len( numberOfEncodingLayers ) )
    {
    localPadding <- 'same'
    kernelSize <- convolutionKernelSize
    if( i == numberOfEncodingLayers )
      {
      localPadding <- padding
      kernelSize <- convolutionKernelSize - 2
      }
    encoder <- encoder %>%
      layer_conv_2d( filters = numberOfFiltersPerLayer[i],
        kernel_size = kernelSize, strides = strides,
        activation = activation, padding = localPadding )
    }

  encoder <- encoder %>%
    layer_flatten() %>%
    layer_dense( units = tail( numberOfFiltersPerLayer, 1 ) )

  autoencoder <- encoder

  penultimateNumberOfFilters <-
    numberOfFiltersPerLayer[numberOfEncodingLayers]

  numberOfUnitsForEncoderOutput <- penultimateNumberOfFilters *
    prod( floor( inputImageSize[1:2] / factor ) )

  autoencoder <- autoencoder %>%
    layer_dense( units = numberOfUnitsForEncoderOutput, activation = activation )

  autoencoder <- autoencoder %>%
    layer_reshape( target_shape = c( floor( inputImageSize[1:2] / factor ),
      penultimateNumberOfFilters ) )

  for( i in seq( from = numberOfEncodingLayers, to = 2, by = -1 ) )
    {
    localPadding <- 'same'
    kernelSize <- deconvolutionKernelSize
    if( i == numberOfEncodingLayers )
      {
      localPadding <- padding
      kernelSize <- deconvolutionKernelSize - 2
      }
    autoencoder <- autoencoder %>%
      layer_conv_2d_transpose( filters = numberOfFiltersPerLayer[i-1],
        kernel_size = kernelSize, strides = strides,
        padding = localPadding )
    }

  autoencoder <- autoencoder %>%
    layer_conv_2d_transpose( filters = tail( inputImageSize, 1 ),
      kernel_size = deconvolutionKernelSize, strides = strides,
      padding = 'same' )

  autoencoderModel <-  keras_model( inputs = inputs, outputs = autoencoder )
  encoderModel <-  keras_model( inputs = inputs, outputs = encoder )

  return( list(
    convolutionalAutoencoderModel = autoencoderModel,
    convolutionalEncoderModel = encoderModel ) )
}

#' Function for creating a 3-D symmetric convolutional autoencoder model.
#'
#' Builds a convolutional autoencoder based on the specified array
#' definining the number of units in the encoding branch.  Ported to
#' Keras R from the Keras python implementation here:
#'
#' \url{https://github.com/XifengGuo/DCEC}
#'
#' @param inputImageSize vector definining spatial dimensions + channels
#' @param numberOfFiltersPerLayer vector defining the number of convolutional
#' filters in the encoding branch per layer
#' @param convolutionKernelSize kernel size fo the convolutional filters
#' @param deconvolutionKernelSize kernel size fo the convolutional transpose
#' filters
#'
#' @return two models:  the convolutional encoder and convolutional auto-encoder
#'
#' @author Tustison NJ
#' @examples
#'
#' library( ANTsRNet )
#' library( keras )
#'
#' ae <- createConvolutionalAutoencoderModel2D( c( 32, 32, 1 ) )
#'
#' @export

createConvolutionalAutoencoderModel3D <- function( inputImageSize,
                                                   numberOfFiltersPerLayer = c( 32, 64, 128, 10 ),
                                                   convolutionKernelSize = c( 5, 5, 5 ),
                                                   deconvolutionKernelSize = c( 5, 5, 5 ) )
{
  activation <- 'relu'
  strides <- c( 2, 2, 2 )

  numberOfEncodingLayers <- length( numberOfFiltersPerLayer ) - 1

  factor <- numberOfEncodingLayers^2

  padding <- 'valid'
  if( inputImageSize[1] %% factor == 0 )
    {
    padding <- 'same'
    }

  inputs <- layer_input( shape = inputImageSize )

  encoder <- inputs

  for( i in seq_len( numberOfEncodingLayers ) )
    {
    localPadding <- 'same'
    kernelSize <- convolutionKernelSize
    if( i == numberOfEncodingLayers )
      {
      localPadding <- padding
      kernelSize <- convolutionKernelSize - 2
      }
    encoder <- encoder %>%
      layer_conv_3d( filters = numberOfFiltersPerLayer[i],
        kernel_size = convolutionKernelSize, strides = strides,
        activation = activation, padding = localPadding )
    }

  encoder <- encoder %>%
    layer_flatten() %>%
    layer_dense( units = tail( numberOfFiltersPerLayer, 1 ) )

  autoencoder <- encoder

  penultimateNumberOfFilters <-
    numberOfFiltersPerLayer[numberOfEncodingLayers]

  numberOfUnitsForEncoderOutput <- penultimateNumberOfFilters *
    prod( floor( inputImageSize[1:3] / factor ) )

  autoencoder <- autoencoder %>%
    layer_dense( units = numberOfUnitsForEncoderOutput, activation = activation )

  autoencoder <- autoencoder %>%
    layer_reshape( target_shape = c( floor( inputImageSize[1:3] / factor ),
      penultimateNumberOfFilters ) )

  for( i in seq( from = numberOfEncodingLayers, to = 2, by = -1 ) )
    {
    localPadding <- 'same'
    kernelSize <- deconvolutionKernelSize
    if( i == numberOfEncodingLayers )
      {
      localPadding <- padding
      kernelSize <- deconvolutionKernelSize - 2
      }
    autoencoder <- autoencoder %>%
      layer_conv_3d_transpose( filters = numberOfFiltersPerLayer[i-1],
        kernel_size = kernelSize, strides = strides,
        padding = localPadding )
    }

  autoencoder <- autoencoder %>%
    layer_conv_3d_transpose( filters = tail( inputImageSize, 1 ),
      kernel_size = deconvolutionKernelSize, strides = strides,
      padding = 'same' )

  autoencoderModel <-  keras_model( inputs = inputs, outputs = autoencoder )
  encoderModel <-  keras_model( inputs = inputs, outputs = encoder )

  return( list(
    convolutionalAutoencoderModel = autoencoderModel,
    convolutionalEncoderModel = encoderModel ) )
}


