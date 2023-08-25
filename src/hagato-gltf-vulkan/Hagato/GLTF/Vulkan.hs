{-# LANGUAGE DataKinds  #-}
{-# LANGUAGE LambdaCase #-}
-----------------------------------------------------------------------------
-- |
-- Module      : Hagato.GLTF.Vulkan
-- Copyright   : (c) Michael Szvetits, 2023
-- License     : BSD-3-Clause (see the file LICENSE)
-- Maintainer  : typedbyte@qualified.name
-- Stability   : stable
-- Portability : portable
--
-- Utility functions for converting glTF objects to Vulkan objects.
-----------------------------------------------------------------------------
module Hagato.GLTF.Vulkan
  ( toIndexType
  , toSamplerInfo
  ) where

-- hagato:with-gltf
import Hagato.GLTF qualified as GLTF

-- vulkan
import Vulkan      qualified as Vk
import Vulkan.Zero qualified as Vk

-- | Converts a glTF component type to a Vulkan index type.
toIndexType :: GLTF.ComponentType -> Vk.IndexType
toIndexType = \case
  GLTF.Byte          -> Vk.INDEX_TYPE_UINT8_EXT
  GLTF.UnsignedByte  -> Vk.INDEX_TYPE_UINT8_EXT
  GLTF.Short         -> Vk.INDEX_TYPE_UINT16
  GLTF.UnsignedShort -> Vk.INDEX_TYPE_UINT16
  GLTF.UnsignedInt   -> Vk.INDEX_TYPE_UINT32
  GLTF.Float         -> Vk.INDEX_TYPE_UINT32

-- | Converts a glTF sampler to an object describing a Vulkan sampler.
toSamplerInfo :: GLTF.Sampler -> Vk.SamplerCreateInfo '[]
toSamplerInfo sampler =
  Vk.zero
    { Vk.magFilter    = toMagFilter sampler.magFilter
    , Vk.minFilter    = toMinFilter sampler.minFilter
    , Vk.addressModeU = toAddressMode sampler.wrapS
    , Vk.addressModeV = toAddressMode sampler.wrapT
    }
  where
    toMagFilter = \case
      GLTF.MagnificationNearest -> Vk.FILTER_NEAREST
      GLTF.MagnificationLinear  -> Vk.FILTER_LINEAR
      GLTF.MagnificationDefault -> Vk.FILTER_LINEAR
    toMinFilter = \case
      GLTF.MinificationNearest  -> Vk.FILTER_NEAREST
      GLTF.MinificationLinear   -> Vk.FILTER_LINEAR
      GLTF.NearestMipmapNearest -> Vk.FILTER_NEAREST
      GLTF.LinearMipmapNearest  -> Vk.FILTER_NEAREST
      GLTF.NearestMipmapLinear  -> Vk.FILTER_LINEAR
      GLTF.LinearMipmapLinear   -> Vk.FILTER_LINEAR
      GLTF.MinificationDefault  -> Vk.FILTER_LINEAR
    toAddressMode = \case
      GLTF.ClampToEdge    -> Vk.SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE
      GLTF.MirroredRepeat -> Vk.SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT
      GLTF.Repeat         -> Vk.SAMPLER_ADDRESS_MODE_REPEAT
