unit Winsoft.FireMonkey.ZBar;

(*------------------------------------------------------------------------
 *  Copyright 2007-2010 (c) Jeff Brown <spadix@users.sourceforge.net>
 *
 *  This file is part of the ZBar Bar Code Reader.
 *
 *  The ZBar Bar Code Reader is free software; you can redistribute it
 *  and/or modify it under the terms of the GNU Lesser Public License as
 *  published by the Free Software Foundation; either version 2.1 of
 *  the License, or (at your option) any later version.
 *
 *  The ZBar Bar Code Reader is distributed in the hope that it will be
 *  useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 *  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser Public License
 *  along with the ZBar Bar Code Reader; if not, write to the Free
 *  Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 *  Boston, MA  02110-1301  USA
 *
 *  http://sourceforge.net/projects/zbar
 *------------------------------------------------------------------------*)

interface

{$ifdef NEXTGEN}

type
  PAnsiChar = PByte;

{$endif NEXTGEN}

// ZBar Barcode Reader C API definition

(** @mainpage
 *
 * interface to the barcode reader is available at several levels.
 * most applications will want to use the high-level interfaces:
 *
 * @section high-level High-Level Interfaces
 *
 * these interfaces wrap all library functionality into an easy-to-use
 * package for a specific toolkit:
 * - the "GTK+ 2.x widget" may be used with GTK GUI applications.  a
 *   Python wrapper is included for PyGtk
 * - the @ref zbar::QZBar "Qt4 widget" may be used with Qt GUI
 *   applications
 * - the Processor interface (in @ref c-processor "C" or @ref
 *   zbar::Processor "C++") adds a scanning window to an application
 *   with no GUI.
 *
 * @section mid-level Intermediate Interfaces
 *
 * building blocks used to construct high-level interfaces:
 * - the ImageScanner (in @ref c-imagescanner "C" or @ref
 *   zbar::ImageScanner "C++") looks for barcodes in a library defined
 *   image object
 * - the Window abstraction (in @ref c-window "C" or @ref
 *   zbar::Window "C++") sinks library images, displaying them on the
 *   platform display
 * - the Video abstraction (in @ref c-video "C" or @ref zbar::Video
 *   "C++") sources library images from a video device
 *
 * @section low-level Low-Level Interfaces
 *
 * direct interaction with barcode scanning and decoding:
 * - the Scanner (in @ref c-scanner "C" or @ref zbar::Scanner "C++")
 *   looks for barcodes in a linear intensity sample stream
 * - the Decoder (in @ref c-decoder "C" or @ref zbar::Decoder "C++")
 *   extracts barcodes from a stream of bar and space widths
 *)

// Global library interfaces

// "color" of element: bar or space
type
  zbar_color_t =
  (
    ZBAR_SPACE = 0, // light area or space between bars
    ZBAR_BAR = 1    // dark area or colored bar segment
  );

// decoded symbol type
type
  zbar_symbol_type_t =
  (
    ZBAR_NONE        =     0, // no symbol decoded
    ZBAR_PARTIAL     =     1, // intermediate status
    ZBAR_EAN2        =     2, // GS1 2-digit add-on
    ZBAR_EAN5        =     5, // GS1 5-digit add-on
    ZBAR_EAN8        =     8, // EAN-8
    ZBAR_UPCE        =     9, // UPC-E
    ZBAR_ISBN10      =    10, // ISBN-10 (from EAN-13)
    ZBAR_UPCA        =    12, // UPC-A
    ZBAR_EAN13       =    13, // EAN-13
    ZBAR_ISBN13      =    14, // ISBN-13 (from EAN-13)
    ZBAR_COMPOSITE   =    15, // EAN/UPC composite
    ZBAR_I25         =    25, // Interleaved 2 of 5
    ZBAR_DATABAR     =    34, // GS1 DataBar (RSS)
    ZBAR_DATABAR_EXP =    35, // GS1 DataBar Expanded
    ZBAR_CODABAR     =    38, // Codabar
    ZBAR_CODE39      =    39, // Code 39
    ZBAR_PDF417      =    57, // PDF417
    ZBAR_QRCODE      =    64, // QR Code
    ZBAR_SQCODE      =    80, // SQ Code
    ZBAR_CODE93      =    93, // Code 93
    ZBAR_CODE128     =   128, // Code 128
    ZBAR_SYMBOL      = $00ff, // DEPRECATED: mask for base symbol type
    ZBAR_ADDON2      = $0200, // DEPRECATED: 2-digit add-on flag
    ZBAR_ADDON5      = $0500, // DEPRECATED: 5-digit add-on flag
    ZBAR_ADDON       = $0700  // DEPRECATED: add-on flag mask
  );

// decoded symbol coarse orientation
type
  zbar_orientation_t =
  (
    ZBAR_ORIENT_UNKNOWN = -1, // unable to determine orientation
    ZBAR_ORIENT_UP,           // upright, read left to right
    ZBAR_ORIENT_RIGHT,        // sideways, read top to bottom
    ZBAR_ORIENT_DOWN,         // upside-down, read right to left
    ZBAR_ORIENT_LEFT          // sideways, read bottom to top
  );

// error codes
type
  zbar_error_t =
  (
    ZBAR_OK = 0, // no error
    ZBAR_ERR_NOMEM,       // out of memory
    ZBAR_ERR_INTERNAL,    // internal library error
    ZBAR_ERR_UNSUPPORTED, // unsupported request
    ZBAR_ERR_INVALID,     // invalid request
    ZBAR_ERR_SYSTEM,      // system error
    ZBAR_ERR_LOCKING,     // locking error
    ZBAR_ERR_BUSY,        // all resources busy
    ZBAR_ERR_XDISPLAY,    // X11 display error
    ZBAR_ERR_XPROTO,      // X11 protocol error
    ZBAR_ERR_CLOSED,      // output window is closed
    ZBAR_ERR_WINAPI,      // windows system error
    ZBAR_ERR_NUM          // number of error codes
  );

// decoder configuration options
type
  zbar_config_t =
  (
    ZBAR_CFG_ENABLE = 0,        // enable symbology/feature
    ZBAR_CFG_ADD_CHECK,         // enable check digit when optional
    ZBAR_CFG_EMIT_CHECK,        // return check digit when present
    ZBAR_CFG_ASCII,             // enable full ASCII character set
    ZBAR_CFG_BINARY,            // don't convert binary data to text
    ZBAR_CFG_NUM,               // number of boolean decoder configs
    ZBAR_CFG_MIN_LEN = $20,     // minimum data length for valid decode
    ZBAR_CFG_MAX_LEN,           // maximum data length for valid decode
    ZBAR_CFG_UNCERTAINTY = $40, // required video consistency frames
    ZBAR_CFG_POSITION = $80,    // enable scanner to collect position data
    ZBAR_CFG_TEST_INVERTED,     // if fails to decode, test inverted
    ZBAR_CFG_X_DENSITY = $100,  // image scanner vertical scan density
    ZBAR_CFG_Y_DENSITY          // image scanner horizontal scan density
  );

// decoder symbology modifier flags.
type
  zbar_modifier_t =
  (
    // barcode tagged as GS1 (EAN.UCC) reserved
    // (eg, FNC1 before first data character).
    // data may be parsed as a sequence of GS1 AIs
    ZBAR_MOD_GS1 = 0,

    // barcode tagged as AIM reserved
    // (eg, FNC1 after first character or digit pair)
    ZBAR_MOD_AIM
  );

const
  ZBAR_MOD_NUM = 2; // number of modifiers

// retrieve runtime library version information
// @param major set to the running major version (unless NULL)
// @param minor set to the running minor version (unless NULL)
// @returns 0
type
  zbar_version_t = function(var major, minor, patch: LongWord): Integer; cdecl;

// set global library debug level
// @param verbosity desired debug level. higher values create more spew
  zbar_set_verbosity_t = procedure(verbosity: Integer); cdecl;

// increase global library debug level
// eg, for -vvvv
  zbar_increase_verbosity_t = procedure; cdecl;

// retrieve string name for symbol encoding
// @param sym symbol type encoding
// @returns the static string name for the specified symbol type,
// or "UNKNOWN" if the encoding is not recognized
  zbar_get_symbol_name_t = function(sym: zbar_symbol_type_t): PAnsiChar; cdecl;

// DEPRECATED
// retrieve string name for addon encoding
// @param sym symbol type encoding
// @returns static string name for any addon, or the empty string
// if no addons were decoded
  zbar_get_addon_name_t = function(sym: zbar_symbol_type_t): PAnsiChar; cdecl;

// retrieve string name for configuration setting.
// @param config setting to name
// @returns static string name for config,
// or the empty string if value is not a known config
  zbar_get_config_name_t = function(config: zbar_config_t): PAnsiChar; cdecl;

// retrieve string name for modifier.
// @param modifier flag to name
// @returns static string name for modifier,
// or the empty string if the value is not a known flag
  zbar_get_modifier_name_t = function(modifier: zbar_modifier_t): PAnsiChar; cdecl;

// retrieve string name for orientation.
// @param orientation orientation encoding
// @returns the static string name for the specified orientation,
// or "UNKNOWN" if the orientation is not recognized
  zbar_get_orientation_name_t = function(orientation: zbar_orientation_t): PAnsiChar; cdecl;

// parse a configuration string of the form "[symbology.]config[=value]"
// the config must match one of the recognized names.
// the symbology, if present, must match one of the recognized names.
// if symbology is unspecified, it will be set to 0.
// if value is unspecified it will be set to 1.
// @returns 0 if the config is parsed successfully, 1 otherwise
  zbar_parse_config_t = function(const config_string: PAnsiChar; var symbology: zbar_symbol_type_t; var config: zbar_config_t; var value: Integer): Integer; cdecl;

// consistently compute fourcc values across architectures
// (adapted from v4l2 specification)
function zbar_fourcc(a, b, c, d: LongWord): LongWord;

// parse a fourcc string into its encoded integer value.
function zbar_fourcc_parse(format: PAnsiChar): LongWord;

// @internal type unsafe error API (don't use)
type
  _zbar_error_spew_t = function(const _object: Pointer; verbosity: Integer): Integer; cdecl;

  _zbar_error_string_t = function(const _object: Pointer; verbosity: Integer): PAnsiChar; cdecl;

  _zbar_get_error_code_t = function(const _object: Pointer): zbar_error_t; cdecl;

  zbar_symbol_t = Pointer;
  zbar_symbol_set_t = Pointer;

// @name Symbol interface
// decoded barcode symbol result object.  stores type, data, and image
// location of decoded symbol.  all memory is owned by the library

// symbol reference count manipulation
// increment the reference count when you store a new reference to the
// symbol.  decrement when the reference is no longer used.  do not
// refer to the symbol once the count is decremented and the
// containing image has been recycled or destroyed.
// @note the containing image holds a reference to the symbol, so you
// only need to use this if you keep a symbol after the image has been
// destroyed or reused.
  zbar_symbol_ref_t = procedure(const symbol: zbar_symbol_t; refs: Integer); cdecl;

// retrieve type of decoded symbol
// @returns the symbol type
  zbar_symbol_get_type_t = function(const symbol: zbar_symbol_t): zbar_symbol_type_t; cdecl;

// retrieve symbology boolean config settings.
// @returns a bitmask indicating which configs were set for the detected
// symbology during decoding.
  zbar_symbol_get_configs_t = function(const symbol: zbar_symbol_t): LongWord; cdecl;

// retrieve symbology modifier flag settings.
// @returns a bitmask indicating which characteristics were detected
// during decoding.
  zbar_symbol_get_modifiers_t = function(const symbol: zbar_symbol_t): LongWord; cdecl;

// retrieve data decoded from symbol
// @returns the data string
  zbar_symbol_get_data_t = function(const symbol: zbar_symbol_t): PAnsiChar; cdecl;

// retrieve length of binary data
// @returns the length of the decoded data
  zbar_symbol_get_data_length_t = function(const symbol: zbar_symbol_t): LongWord; cdecl;

// retrieve a symbol confidence metric
// @returns an unscaled, relative quantity: larger values are better
// than smaller values, where "large" and "small" are application
// dependent
// @note expect the exact definition of this quantity to change as the
// metric is refined.  currently, only the ordered relationship
// between two values is defined and will remain stable in the future
  zbar_symbol_get_quality_t = function(const symbol: zbar_symbol_t): Integer; cdecl;

// retrieve current cache count.  when the cache is enabled for the
// image_scanner this provides inter-frame reliability and redundancy
// information for video streams
// @returns < 0 if symbol is still uncertain.
// @returns 0 if symbol is newly verified.
// @returns > 0 for duplicate symbols
  zbar_symbol_get_count_t = function(const symbol: zbar_symbol_t): Integer; cdecl;

// retrieve the number of points in the location polygon.  the
// location polygon defines the image area that the symbol was
// extracted from.
// @returns the number of points in the location polygon
// @note this is currently not a polygon, but the scan locations
// where the symbol was decoded
  zbar_symbol_get_loc_size_t = function(const symbol: zbar_symbol_t): LongWord; cdecl;

// retrieve location polygon x-coordinates
// points are specified by 0-based index
// @returns the x-coordinate for a point in the location polygon.
// @returns -1 if index is out of range
  zbar_symbol_get_loc_x_t = function(const symbol: zbar_symbol_t; index: LongWord): Integer; cdecl;

// retrieve location polygon y-coordinates
// points are specified by 0-based index
// @returns the y-coordinate for a point in the location polygon.
// @returns -1 if index is out of range
  zbar_symbol_get_loc_y_t = function(const symbol: zbar_symbol_t; index: LongWord): Integer; cdecl;

// retrieve general orientation of decoded symbol.
// @returns a coarse, axis-aligned indication of symbol orientation or
// ::ZBAR_ORIENT_UNKNOWN if unknown
  zbar_symbol_get_orientation_t = function(const symbol: zbar_symbol_t): zbar_orientation_t; cdecl;

// iterate the set to which this symbol belongs (there can be only one)
// @returns the next symbol in the set, or
// @returns NULL when no more results are available
  zbar_symbol_next_t = function(const symbol: zbar_symbol_t): zbar_symbol_t; cdecl;

// retrieve components of a composite result
// @returns the symbol set containing the components
// @returns NULL if the symbol is already a physical symbol
  zbar_symbol_get_components_t = function(const symbol: zbar_symbol_t): zbar_symbol_set_t; cdecl;

// iterate components of a composite result
// @returns the first physical component symbol of a composite result
// @returns NULL if the symbol is already a physical symbol
  zbar_symbol_first_component_t = function(const symbol: zbar_symbol_t): zbar_symbol_t; cdecl;

// print XML symbol element representation to user result buffer
// @see http://zbar.sourceforge.net/2008/barcode.xsd for the schema.
// @param symbol is the symbol to print
// @param buffer is the inout result pointer, it will be reallocated
// with a larger size if necessary.
// @param buflen is inout length of the result buffer.
// @returns the buffer pointer
  zbar_symbol_xml_t = function(const symbol: zbar_symbol_t; var buffer: PAnsiChar; var buflen: LongWord): PAnsiChar; cdecl;

// @name Symbol Set interface
// container for decoded result symbols associated with an image
// or a composite symbol

// reference count manipulation
// increment the reference count when you store a new reference.
// decrement when the reference is no longer used.  do not refer to
// the object any longer once references have been released
  zbar_symbol_set_ref_t = procedure(const symbols: zbar_symbol_set_t; refs: Integer); cdecl;

// retrieve set size
// @returns the number of symbols in the set
  zbar_symbol_set_get_size_t = function(const symbols: zbar_symbol_set_t): Integer; cdecl;

// set iterator
// @returns the first decoded symbol result in a set
// @returns NULL if the set is empty
  zbar_symbol_set_first_symbol_t = function(const symbols: zbar_symbol_set_t): zbar_symbol_t; cdecl;

// raw result iterator.
// @returns the first decoded symbol result in a set, *before* filtering
// @returns NULL if the set is empty
  zbar_symbol_set_first_unfiltered_t = function(const symbols: zbar_symbol_set_t): zbar_symbol_t; cdecl;

// @name Image interface
// stores image data samples along with associated format and size metadata

  zbar_image_t = Pointer;

// cleanup handler callback function
// called to free sample data when an image is destroyed
  zbar_image_cleanup_handler_t = procedure(image: zbar_image_t); cdecl;

// data handler callback function
// called when decoded symbol results are available for an image
  zbar_image_data_handler_t = procedure(image: zbar_image_t; const userdata: Pointer); cdecl;

// new image constructor
// @returns a new image object with uninitialized data and format
// this image should be destroyed (using zbar_image_destroy()) as
// soon as the application is finished with it
  zbar_image_create_t = function: zbar_image_t; cdecl;

// image destructor.  all images created by or returned to the
// application should be destroyed using this function.  when an image
// is destroyed, the associated data cleanup handler will be invoked
// if available
// @note make no assumptions about the image or the data buffer.
// they may not be destroyed/cleaned immediately if the library
// is still using them.  if necessary, use the cleanup handler hook
// to keep track of image data buffers
  zbar_image_destroy_t = procedure(image: zbar_image_t); cdecl;

// image reference count manipulation
// increment the reference count when you store a new reference to the
// image.  decrement when the reference is no longer used.  do not
// refer to the image any longer once the count is decremented.
// zbar_image_ref(image, -1) is the same as zbar_image_destroy(image)
  zbar_image_ref_t = procedure(image: zbar_image_t; refs: Integer); cdecl;

// image format conversion.  refer to the documentation for supported
// image formats
// @returns a @em new image with the sample data from the original image
// converted to the requested format.  the original image is
// unaffected.
// @note the converted image size may be rounded (up) due to format
// constraints
  zbar_image_convert_t = function(const image: zbar_image_t; format: LongWord): zbar_image_t; cdecl;

// image format conversion with crop/pad
// if the requested size is larger than the image, the last row/column
// are duplicated to cover the difference.  if the requested size is
// smaller than the image, the extra rows/columns are dropped from the
// right/bottom.
// @returns a @em new image with the sample data from the original
// image converted to the requested format and size.
// @note the image is @em not scaled
// @see zbar_image_convert()
  zbar_image_convert_resize_t = function(const image: zbar_image_t; format, width, height: LongWord): zbar_image_t; cdecl;

// retrieve the image format
// @returns the fourcc describing the format of the image sample data
  zbar_image_get_format_t = function(const image: zbar_image_t): LongWord; cdecl;

// retrieve a "sequence" (page/frame) number associated with this image
  zbar_image_get_sequence_t = function(const image: zbar_image_t): LongWord; cdecl;

// retrieve the width of the image
// @returns the width in sample columns
  zbar_image_get_width_t = function(const image: zbar_image_t): LongWord; cdecl;

// retrieve the height of the image
// @returns the height in sample rows
  zbar_image_get_height_t = function(const image: zbar_image_t): LongWord; cdecl;

// retrieve both dimensions of the image.
// fills in the width and height in samples
  zbar_image_get_size_t = procedure(const image: zbar_image_t; var width, height: LongWord); cdecl;

// retrieve the crop rectangle.
// fills in the image coordinates of the upper left corner and size
// of an axis-aligned rectangular area of the image that will be scanned.
// defaults to the full image
  zbar_image_get_crop_t = procedure(const image: zbar_image_t; var x, y, width, height: LongWord); cdecl;

// return the image sample data.  the returned data buffer is only
// valid until zbar_image_destroy() is called
  zbar_image_get_data_t = function(const image: zbar_image_t): Pointer; cdecl;

// return the size of image data
  zbar_image_get_data_length_t = function(const img: zbar_image_t): LongWord; cdecl;

// retrieve the decoded results
// @returns the (possibly empty) set of decoded symbols
// @returns NULL if the image has not been scanned
  zbar_image_get_symbols_t = function(const image: zbar_image_t): zbar_symbol_set_t; cdecl;

// associate the specified symbol set with the image, replacing any
// existing results.  use NULL to release the current results from the
// image.
// @see zbar_image_scanner_recycle_image()
  zbar_image_set_symbols_t = procedure(image: zbar_image_t; const symbols: zbar_symbol_set_t); cdecl;

// image_scanner decode result iterator
// @returns the first decoded symbol result for an image
// or NULL if no results are available
  zbar_image_first_symbol_t = function(const image: zbar_image_t): zbar_symbol_t; cdecl;

// specify the fourcc image format code for image sample data
// refer to the documentation for supported formats.
// @note this does not convert the data!
// (see zbar_image_convert() for that)
  zbar_image_set_format_t = procedure(image: zbar_image_t; format: LongWord); cdecl;

// associate a "sequence" (page/frame) number with this image
  zbar_image_set_sequence_t = procedure(image: zbar_image_t; sequence_num: LongWord); cdecl;

// specify the pixel size of the image
// @note this also resets the crop rectangle to the full image
// (0, 0, width, height)
// @note this does not affect the data!
  zbar_image_set_size_t = procedure(image: zbar_image_t; width, height: LongWord); cdecl;

// specify a rectangular region of the image to scan.
// the rectangle will be clipped to the image boundaries.
// defaults to the full image specified by zbar_image_set_size()
  zbar_image_set_crop_t = procedure(image: zbar_image_t; x, y, width, height: LongWord); cdecl;

// specify image sample data.  when image data is no longer needed by
// the library the specific data cleanup handler will be called
// (unless NULL)
// @note application image data will not be modified by the library
  zbar_image_set_data_t = procedure(image: zbar_image_t; const data: Pointer; data_byte_length: LongWord; cleanup_hndlr: zbar_image_cleanup_handler_t); cdecl;

// built-in cleanup handler
// passes the image data buffer to free()
  zbar_image_free_data_t = procedure(image: zbar_image_t); cdecl;

// associate user specified data value with an image
  zbar_image_set_userdata_t = procedure(image: zbar_image_t; userdata: Pointer); cdecl;

// return user specified data value associated with the image
  zbar_image_get_userdata_t = function(const image: zbar_image_t): Pointer; cdecl;

// dump raw image data to a file for debug
// the data will be prefixed with a 16 byte header consisting of:
//   - 4 bytes uint = 0x676d697a ("zimg")
//   - 4 bytes format fourcc
//   - 2 bytes width
//   - 2 bytes height
//   - 4 bytes size of following image data in bytes
// this header can be dumped w/eg:
// @verbatim
//     od -Ax -tx1z -N16 -w4 [file]
// @endverbatim
// for some formats the image can be displayed/converted using
// ImageMagick, eg:
// @verbatim
//     display -size 640x480+16 [-depth ?] [-sampling-factor ?x?] \
//         {GRAY,RGB,UYVY,YUV}:[file]
// @endverbatim
//
// @param image the image object to dump
// @param filebase base filename, appended with ".XXXX.zimg" where
// XXXX is the format fourcc
// @returns 0 on success or a system error code on failure
  zbar_image_write_t = function(const image: zbar_image_t; const filebase: PAnsiChar): Integer; cdecl;

// read back an image in the format written by zbar_image_write()
// @note TBD
  zbar_image_read_t = function(filename: PAnsiChar): zbar_image_t; cdecl;

// @name Processor interface
// @anchor c-processor
// high-level self-contained image processor.
// processes video and images for barcodes, optionally displaying
// images to a library owned output window

  zbar_processor_t = Pointer;

// constructor
// if threaded is set and threading is available the processor
// will spawn threads where appropriate to avoid blocking and
// improve responsiveness
  zbar_processor_create_t = function(threaded: Integer): zbar_processor_t; cdecl;

// destructor. cleans up all resources associated with the processor
  zbar_processor_destroy_t = procedure(processor: zbar_processor_t); cdecl;

// (re)initialization
// opens a video input device and/or prepares to display output
  zbar_processor_init_t = function(processor: zbar_processor_t; const video_device: PAnsiChar; enable_display: Integer): Integer; cdecl;

// request a preferred size for the video image from the device
// the request may be adjusted or completely ignored by the driver
// @note must be called before zbar_processor_init()
  zbar_processor_request_size_t = function(processor: zbar_processor_t; width, height: LongWord): Integer; cdecl;

// request a preferred video driver interface version for
// debug/testing
// @note must be called before zbar_processor_init()
  zbar_processor_request_interface_t = function(processor: zbar_processor_t; version: Integer): Integer; cdecl;

// request a preferred video I/O mode for debug/testing.  You will
// get errors if the driver does not support the specified mode.
// @verbatim
//  0 = auto-detect
//  1 = force I/O using read()
//  2 = force memory mapped I/O using mmap()
//  3 = force USERPTR I/O (v4l2 only)
// @endverbatim
// @note must be called before zbar_processor_init()
  zbar_processor_request_iomode_t = function(video: zbar_processor_t; iomode: Integer): Integer; cdecl;

// force specific input and output formats for debug/testing
// @note must be called before zbar_processor_init()
  zbar_processor_force_format_t = function(processor: zbar_processor_t; input_format, output_format: LongWord): Integer; cdecl;

// setup result handler callback
// the specified function will be called by the processor whenever
// new results are available from the video stream or a static image.
// pass a NULL value to disable callbacks.
// @param processor the object on which to set the handler.
// @param handler the function to call when new results are available.
// @param userdata is set as with zbar_processor_set_userdata().
// @returns the previously registered handler
  zbar_processor_set_data_handler_t = function(processor: zbar_processor_t; handler: zbar_image_data_handler_t; const userdata: Pointer): zbar_image_data_handler_t; cdecl;

// associate user specified data value with the processor
  zbar_processor_set_userdata_t = procedure(processor: zbar_processor_t; userdata: Pointer); cdecl;

// return user specified data value associated with the processor.
  zbar_processor_get_userdata_t = function(const processor: zbar_processor_t): Pointer; cdecl;

// set config for indicated symbology (0 for all) to specified value.
// @returns 0 for success, non-0 for failure (config does not apply to
// specified symbology, or value out of range)
// @see zbar_decoder_set_config()
  zbar_processor_set_config_t = function(processor: zbar_processor_t; symbology: zbar_symbol_type_t; config: zbar_config_t; value: Integer): Integer; cdecl;

// set video control value
// @returns 0 for success, non-0 for failure
// @see zbar_video_set_control()
  zbar_processor_set_control_t = function(processor: zbar_processor_t; control_name: PAnsiChar; value: Integer): Integer; cdecl;

// get video control value
// @returns 0 for success, non-0 for failure
// @see zbar_video_get_control()

  zbar_processor_get_control_t = function(processor: zbar_processor_t; control_name: PAnsiChar; out value: Integer): Integer; cdecl;

// parse configuration string using zbar_parse_config()
// and apply to processor using zbar_processor_set_config().
// @returns 0 for success, non-0 for failure
// @see zbar_parse_config()
// @see zbar_processor_set_config()
function zbar_processor_parse_config(processor: zbar_processor_t; config_string: PAnsiChar): Integer; cdecl;

// retrieve the current state of the output window
// @returns 1 if the output window is currently displayed, 0 if not.
// @returns -1 if an error occurs
type
  zbar_processor_is_visible_t = function(processor: zbar_processor_t): Integer; cdecl;

// show or hide the display window owned by the library
// the size will be adjusted to the input size
  zbar_processor_set_visible_t = function(processor: zbar_processor_t; visible: Integer): Integer; cdecl;

// control the processor in free running video mode
// only works if video input is initialized. if threading is in use,
// scanning will occur in the background, otherwise this is only
// useful wrapping calls to zbar_processor_user_wait(). if the
// library output window is visible, video display will be enabled.
  zbar_processor_set_active_t = function(processor: zbar_processor_t; active: Integer): Integer; cdecl;

// retrieve decode results for last scanned image/frame.
// @returns the symbol set result container or NULL if no results are
// available
// @note the returned symbol set has its reference count incremented;
// ensure that the count is decremented after use
  zbar_processor_get_results_t = function(const processor: zbar_processor_t): zbar_symbol_set_t; cdecl;

// wait for input to the display window from the user
// (via mouse or keyboard).
// @returns >0 when input is received, 0 if timeout ms expired
// with no input or -1 in case of an error
  zbar_processor_user_wait_t = function(processor: zbar_processor_t; timeout: Integer): Integer; cdecl;

// process from the video stream until a result is available,
// or the timeout (in milliseconds) expires
// specify a timeout of -1 to scan indefinitely
// (zbar_processor_set_active() may still be used to abort the scan
// from another thread).
// if the library window is visible, video display will be enabled.
// @note that multiple results may still be returned (despite the
// name).
// @returns >0 if symbols were successfully decoded,
// 0 if no symbols were found (ie, the timeout expired)
// or -1 if an error occurs
  zbar_process_one_t = function(processor: zbar_processor_t; timeout: Integer): Integer; cdecl;

// process the provided image for barcodes
// if the library window is visible, the image will be displayed.
// @returns >0 if symbols were successfully decoded,
// 0 if no symbols were found or -1 if an error occurs
  zbar_process_image_t = function(processor: zbar_processor_t; image: zbar_image_t): Integer; cdecl;

// enable dbus IPC API.
// @returns 0 successful
  zbar_processor_request_dbus_t = function(proc: zbar_processor_t; req_dbus_enabled: Integer): Integer; cdecl;

// display detail for last processor error to stderr
// @returns a non-zero value suitable for passing to exit()
function zbar_processor_error_spew(const processor: zbar_processor_t; verbosity: Integer): Integer; cdecl;

// retrieve the detail string for the last processor error
function zbar_processor_error_string(const processor: zbar_processor_t; verbosity: Integer): PAnsiChar; cdecl;

// retrieve the type code for the last processor error
function zbar_processor_get_error_code(const processor: zbar_processor_t): zbar_error_t; cdecl;

// @name Video interface
// @anchor c-video
// mid-level video source abstraction.
// captures images from a video device

type
  zbar_video_t = Pointer;

// constructor
  zbar_video_create_t = function: zbar_video_t; cdecl;

// destructor
  zbar_video_destroy_t = procedure(video: zbar_video_t); cdecl;

// open and probe a video device
// the device specified by platform specific unique name
// (v4l device node path in *nix eg "/dev/video",
//  DirectShow DevicePath property in windows).
// @returns 0 if successful or -1 if an error occurs
  zbar_video_open_t = function(video: zbar_video_t; const device: PAnsiChar): Integer; cdecl;

// retrieve file descriptor associated with open *nix video device
// useful for using select()/poll() to tell when new images are
// available (NB v4l2 only!!).
// @returns the file descriptor or -1 if the video device is not open
// or the driver only supports v4l1
  zbar_video_get_fd_t = function(const video: zbar_video_t): Integer; cdecl;

// request a preferred size for the video image from the device
// the request may be adjusted or completely ignored by the driver.
// @returns 0 if successful or -1 if the video device is already
// initialized
  zbar_video_request_size_t = function(video: zbar_video_t; width, height: LongWord): Integer; cdecl;

// request a preferred driver interface version for debug/testing.
// @note must be called before zbar_video_open()
  zbar_video_request_interface_t = function(video: zbar_video_t; version: Integer): Integer; cdecl;

// request a preferred I/O mode for debug/testing.  You will get
// errors if the driver does not support the specified mode.
// @verbatim
//  0 = auto-detect
//  1 = force I/O using read()
//  2 = force memory mapped I/O using mmap()
//  3 = force USERPTR I/O (v4l2 only)
// @endverbatim
// @note must be called before zbar_video_open()
  zbar_video_request_iomode_t = function(video: zbar_video_t; iomode: Integer): Integer; cdecl;

// retrieve current output image width
// @returns the width or 0 if the video device is not open
  zbar_video_get_width_t = function(const video: zbar_video_t): Integer; cdecl;

// retrieve current output image height
// @returns the height or 0 if the video device is not open
  zbar_video_get_height_t = function(const video: zbar_video_t): Integer; cdecl;

// initialize video using a specific format for debug
// use zbar_negotiate_format() to automatically select and initialize
// the best available format
  zbar_video_init_t = function(video: zbar_video_t; format: LongWord): Integer; cdecl;

// start/stop video capture
// all buffered images are retired when capture is disabled.
// @returns 0 if successful or -1 if an error occurs
  zbar_video_enable_t = function(video: zbar_video_t; enable: Integer): Integer; cdecl;

// retrieve next captured image.  blocks until an image is available.
// @returns NULL if video is not enabled or an error occurs
  zbar_video_next_image_t = function(video: zbar_video_t): zbar_image_t; cdecl;

// set video control value (integer).
// @returns 0 for success, non-0 for failure
// @see zbar_processor_set_control()
  zbar_video_set_control_t = function(video: zbar_video_t; control_name: PAnsiChar; value: Integer): Integer; cdecl;

// get video control value (integer).
// @returns 0 for success, non-0 for failure
// @see zbar_processor_get_control()
  zbar_video_get_control_t = function(video: zbar_video_t; control_name: PAnsiChar; out value: Integer): Integer; cdecl;

// get available controls from video source
// @returns 0 for success, non-0 for failure
  zbar_video_get_controls_t = function(video: zbar_video_t; index: Integer): Pointer {video_controls_s}; cdecl;

//* get available video resolutions from video source
// @returns 0 for success, non-0 for failure
  
  zbar_video_get_resolutions = function(vdo: zbar_video_t; index: Integer): Pointer {video_resolution_s}; cdecl;

// display detail for last video error to stderr
// @returns a non-zero value suitable for passing to exit()
function zbar_video_error_spew(const video: zbar_video_t; verbosity: Integer): Integer; cdecl;

// retrieve the detail string for the last video error
function zbar_video_error_string(const video: zbar_video_t; verbosity: Integer): PAnsiChar; cdecl;

// retrieve the type code for the last video error
function zbar_video_get_error_code(const video: zbar_video_t): zbar_error_t; cdecl;

// @name Window interface
// @anchor c-window
// mid-level output window abstraction.
// displays images to user-specified platform specific output window

type
  zbar_window_t = Pointer;

// constructor
  zbar_window_create_t = function: zbar_window_t; cdecl;

// destructor
  zbar_window_destroy_t = procedure(window: zbar_window_t); cdecl;

// associate reader with an existing platform window
// This can be any "Drawable" for X Windows or a "HWND" for windows.
// input images will be scaled into the output window.
// pass NULL to detach from the resource, further input will be
// ignored
  zbar_window_attach_t = function(window: zbar_window_t; x11_display_w32_hwnd: Pointer; x11_drawable: LongWord): Integer; cdecl;

// control content level of the reader overlay
// the overlay displays graphical data for informational or debug
// purposes.  higher values increase the level of annotation (possibly
// decreasing performance). @verbatim
//  0 = disable overlay
//  1 = outline decoded symbols (default)
//  2 = also track and display input frame rate
// @endverbatim
  zbar_window_set_overlay_t = procedure(window: zbar_window_t; level: Integer); cdecl;

// retrieve current content level of reader overlay
// @see zbar_window_set_overlay()
  zbar_window_get_overlay_t = function(const window: zbar_window_t): Integer; cdecl;

// draw a new image into the output window
  zbar_window_draw_t = function(window: zbar_window_t; image: zbar_image_t): Integer; cdecl;

// redraw the last image (exposure handler)
  zbar_window_redraw_t = function(window: zbar_window_t): Integer; cdecl;

// resize the image window (reconfigure handler)
// this does @em not update the contents of the window
// @since 0.3, changed in 0.4 to not redraw window
  zbar_window_resize_t = function(window: zbar_window_t; width, height: LongWord): Integer; cdecl;

// display detail for last window error to stderr
// @returns a non-zero value suitable for passing to exit()
function zbar_window_error_spew(const window: zbar_window_t; verbosity: Integer): Integer; cdecl;

// retrieve the detail string for the last window error
function zbar_window_error_string(const window: zbar_window_t; verbosity: Integer): PAnsiChar; cdecl;

// retrieve the type code for the last window error
function zbar_window_get_error_code(const window: zbar_window_t): zbar_error_t; cdecl;

// select a compatible format between video input and output window
// the selection algorithm attempts to use a format shared by
// video input and window output which is also most useful for
// barcode scanning.  if a format conversion is necessary, it will
// heuristically attempt to minimize the cost of the conversion
type
  zbar_negotiate_format_t = function(video: zbar_video_t; window: zbar_window_t): Integer; cdecl;

// @name Image Scanner interface
// @anchor c-imagescanner
// mid-level image scanner interface.
// reads barcodes from 2-D images

  zbar_image_scanner_t = Pointer;

// constructor
  zbar_image_scanner_create_t = function: zbar_image_scanner_t; cdecl;

// destructor
  zbar_image_scanner_destroy_t = procedure(scanner: zbar_image_scanner_t); cdecl;

// setup result handler callback.
// the specified function will be called by the scanner whenever
// new results are available from a decoded image.
// pass a NULL value to disable callbacks.
// @returns the previously registered handler
  zbar_image_scanner_set_data_handler_t = function(scanner: zbar_image_scanner_t; handler: zbar_image_data_handler_t; const userdata: Pointer): zbar_image_data_handler_t; cdecl;

// request sending decoded codes via D-Bus
// @see zbar_processor_parse_config()
  zbar_image_scanner_request_dbus_t = function(scanner: zbar_image_scanner_t; req_dbus_enabled: Integer): Integer; cdecl;

// set config for indicated symbology (0 for all) to specified value.
// @returns 0 for success, non-0 for failure (config does not apply to
// specified symbology, or value out of range)
// @see zbar_decoder_set_config()
  zbar_image_scanner_set_config_t = function(scanner: zbar_image_scanner_t; symbology: zbar_symbol_type_t; config: zbar_config_t; value: Integer): Integer; cdecl;

// get config for indicated symbology
// @returns 0 for success, non-0 for failure (config does not apply to
// specified symbology, or value out of range). On success, *value is filled.
  zbar_image_scanner_get_config_t = function(scanner: zbar_image_scanner_t; symbology: zbar_symbol_type_t; config: zbar_config_t; out value: Integer): Integer; cdecl;

// parse configuration string using zbar_parse_config()
// and apply to image scanner using zbar_image_scanner_set_config().
// @returns 0 for success, non-0 for failure
// @see zbar_parse_config()
// @see zbar_image_scanner_set_config()
function zbar_image_scanner_parse_config(scanner: zbar_image_scanner_t; const config_string: PAnsiChar): Integer; cdecl;

// enable or disable the inter-image result cache (default disabled).
// mostly useful for scanning video frames, the cache filters
// duplicate results from consecutive images, while adding some
// consistency checking and hysteresis to the results.
// this interface also clears the cache
type
  zbar_image_scanner_enable_cache_t = procedure(scanner: zbar_image_scanner_t; enable: Integer); cdecl;

// remove any previously decoded results from the image scanner and the
// specified image.  somewhat more efficient version of
// zbar_image_set_symbols(image, NULL) which may retain memory for
// subsequent decodes
  zbar_image_scanner_recycle_image_t = procedure(scanner: zbar_image_scanner_t; image: zbar_image_t); cdecl;

// retrieve decode results for last scanned image.
// @returns the symbol set result container or NULL if no results are
// available
// @note the symbol set does not have its reference count adjusted;
// ensure that the count is incremented if the results may be kept
// after the next image is scanned
  zbar_image_scanner_get_results_t = function(const scanner: zbar_image_scanner_t): zbar_symbol_set_t; cdecl;

// scan for symbols in provided image.  The image format must be
// "Y800" or "GRAY".
// @returns >0 if symbols were successfully decoded from the image,
// 0 if no symbols were found or -1 if an error occurs
// @see zbar_image_convert()
// @since 0.9 - changed to only accept grayscale images
  zbar_scan_image_t = function(scanner: zbar_image_scanner_t; image: zbar_image_t): Integer; cdecl;

// @name Decoder interface
// @anchor c-decoder
// low-level bar width stream decoder interface.
// identifies symbols and extracts encoded data

  zbar_decoder_t = Pointer;

// decoder data handler callback function.
// called by decoder when new data has just been decoded
  zbar_decoder_handler_t = procedure(decoder: zbar_decoder_t); cdecl;

// constructor
  zbar_decoder_create_t = function: zbar_decoder_t; cdecl;

// destructor
  zbar_decoder_destroy_t = procedure(decoder: zbar_decoder_t); cdecl;

// set config for indicated symbology (0 for all) to specified value
// @returns 0 for success, non-0 for failure (config does not apply to
// specified symbology, or value out of range)
  zbar_decoder_set_config_t = function(decoder: zbar_decoder_t; symbology: zbar_symbol_type_t; config: zbar_config_t; value: Integer): Integer; cdecl;

// get config for indicated symbology
// @returns 0 for success, non-0 for failure (config does not apply to
// specified symbology, or value out of range). On success, *value is filled.
  zbar_decoder_get_config_t = function(decoder: zbar_decoder_t; symbology: zbar_symbol_type_t; config: zbar_config_t; out value: Integer): Integer; cdecl;

// parse configuration string using zbar_parse_config()
// and apply to decoder using zbar_decoder_set_config()
// @returns 0 for success, non-0 for failure
// @see zbar_parse_config()
// @see zbar_decoder_set_config()
function zbar_decoder_parse_config(decoder: zbar_decoder_t; const config_string: PAnsiChar): Integer;

// retrieve symbology boolean config settings.
// @returns a bitmask indicating which configs are currently set for the
// specified symbology.
type
  zbar_decoder_get_configs_t = function(const decoder: zbar_decoder_t; symbology: zbar_symbol_type_t): LongWord; cdecl;

// clear all decoder state
// any partial symbols are flushed
type
  zbar_decoder_reset_t = procedure(decoder: zbar_decoder_t); cdecl;

// mark start of a new scan pass
// clears any intra-symbol state and resets color to ::ZBAR_SPACE.
// any partially decoded symbol state is retained
  zbar_decoder_new_scan_t = procedure(decoder: zbar_decoder_t); cdecl;

// process next bar/space width from input stream
// the width is in arbitrary relative units.  first value of a scan
// is ::ZBAR_SPACE width, alternating from there.
// @returns appropriate symbol type if width completes
// decode of a symbol (data is available for retrieval)
// @returns ::ZBAR_PARTIAL as a hint if part of a symbol was decoded
// @returns ::ZBAR_NONE (0) if no new symbol data is available
  zbar_decode_width_t = function(decoder: zbar_decoder_t; width: LongWord): zbar_symbol_type_t; cdecl;

// retrieve color of @em next element passed to
// zbar_decode_width()
  zbar_decoder_get_color_t = function(const decoder: zbar_decoder_t): zbar_color_t; cdecl;

// retrieve last decoded data
// @returns the data string or NULL if no new data available
// the returned data buffer is owned by library, contents are only
// valid between non-0 return from zbar_decode_width and next library
// call
  zbar_decoder_get_data_t = function(const decoder: zbar_decoder_t): PAnsiChar; cdecl;

// retrieve length of binary data
// @returns the length of the decoded data or 0 if no new data
// available
  zbar_decoder_get_data_length_t = function(const decoder: zbar_decoder_t): LongWord; cdecl;

// retrieve last decoded symbol type
// @returns the type or ::ZBAR_NONE if no new data available
  zbar_decoder_get_type_t = function(const decoder: zbar_decoder_t): zbar_symbol_type_t; cdecl;

// retrieve modifier flags for the last decoded symbol.
// @returns a bitmask indicating which characteristics were detected
// during decoding.
  zbar_decoder_get_modifiers_t = function(const decoder: zbar_decoder_t): LongWord; cdecl;

// retrieve last decode direction.
// @returns 1 for forward and -1 for reverse
// @returns 0 if the decode direction is unknown or does not apply
  zbar_decoder_get_direction_t = function(const decoder: zbar_decoder_t): Integer; cdecl;

// setup data handler callback
// the registered function will be called by the decoder
// just before zbar_decode_width() returns a non-zero value.
// pass a NULL value to disable callbacks.
// @returns the previously registered handler
  zbar_decoder_set_handler_t = function(decoder: zbar_decoder_t; handler: zbar_decoder_handler_t): zbar_decoder_handler_t; cdecl;

// associate user specified data value with the decoder
  zbar_decoder_set_userdata_t = procedure(decoder: zbar_decoder_t; userdata: Pointer); cdecl;

// return user specified data value associated with the decoder
  zbar_decoder_get_userdata_t = function(const decoder: zbar_decoder_t): Pointer; cdecl;

// @name Scanner interface
// @anchor c-scanner
// low-level linear intensity sample stream scanner interface.
// identifies "bar" edges and measures width between them.
// optionally passes to bar width decoder

  zbar_scanner_t = Pointer;

// constructor
// if decoder is non-NULL it will be attached to scanner
// and called automatically at each new edge
// current color is initialized to ::ZBAR_SPACE
// (so an initial BAR->SPACE transition may be discarded)
  zbar_scanner_create_t = function(decoder: zbar_decoder_t): zbar_scanner_t; cdecl;

// destructor
  zbar_scanner_destroy_t = procedure(scanner: zbar_scanner_t); cdecl;

// clear all scanner state
// also resets an associated decoder
  zbar_scanner_reset_t = function(scanner: zbar_scanner_t): zbar_symbol_type_t; cdecl;

// mark start of a new scan pass. resets color to ::ZBAR_SPACE
// also updates an associated decoder.
// @returns any decode results flushed from the pipeline
// @note when not using callback handlers, the return value should
// be checked the same as zbar_scan_y()
// @note call zbar_scanner_flush() at least twice before calling this
// method to ensure no decode results are lost
  zbar_scanner_new_scan_t = function(scanner: zbar_scanner_t): zbar_symbol_type_t; cdecl;

// flush scanner processing pipeline
// forces current scanner position to be a scan boundary.
// call multiple times (max 3) to completely flush decoder.
// @returns any decode/scan results flushed from the pipeline
// @note when not using callback handlers, the return value should
// be checked the same as zbar_scan_y()
  zbar_scanner_flush_t = function(scanner: zbar_scanner_t): zbar_symbol_type_t; cdecl;

// process next sample intensity value
// intensity (y) is in arbitrary relative units.
// @returns result of zbar_decode_width() if a decoder is attached,
// otherwise @returns (::ZBAR_PARTIAL) when new edge is detected
// or 0 (::ZBAR_NONE) if no new edge is detected
  zbar_scan_y_t = function(scanner: zbar_scanner_t; y: Integer): zbar_symbol_type_t; cdecl;

// process next sample from RGB (or BGR) triple
function zbar_scan_rgb24(scanner: zbar_scanner_t; rgb: PByte): zbar_symbol_type_t; cdecl;

// retrieve last scanned width
type
  zbar_scanner_get_width_t = function(const scanner: zbar_scanner_t): LongWord; cdecl;

// retrieve sample position of last edge
  zbar_scanner_get_edge_t = function(const scanner: zbar_scanner_t; offset: LongWord; prec: Integer): LongWord; cdecl;

// retrieve last scanned color
  zbar_scanner_get_color_t = function(const scanner: zbar_scanner_t): zbar_color_t; cdecl;

implementation

uses Winsoft.FireMonkey.Obr;

function zbar_processor_parse_config(processor: zbar_processor_t; config_string: PAnsiChar): Integer;
var
  sym: zbar_symbol_type_t;
  cfg: zbar_config_t;
  val: Integer;
begin
  Result := zbar_parse_config(config_string, sym, cfg, val) // or zbar_processor_set_config(processor, sym, cfg, val);
end;

function zbar_processor_error_spew(const processor: zbar_processor_t; verbosity: Integer): Integer;
begin
  Result := _zbar_error_spew(processor, verbosity);
end;

function zbar_processor_error_string(const processor: zbar_processor_t; verbosity: Integer): PAnsiChar;
begin
  Result := _zbar_error_string(processor, verbosity);
end;

function zbar_processor_get_error_code(const processor: zbar_processor_t): zbar_error_t;
begin
  Result := _zbar_get_error_code(processor);
end;

function zbar_video_error_spew(const video: zbar_video_t; verbosity: Integer): Integer;
begin
  Result := _zbar_error_spew(video, verbosity);
end;

function zbar_video_error_string(const video: zbar_video_t; verbosity: Integer): PAnsiChar;
begin
  Result := _zbar_error_string(video, verbosity);
end;

function zbar_video_get_error_code(const video: zbar_video_t): zbar_error_t;
begin
  Result := _zbar_get_error_code(video);
end;

function zbar_window_error_spew(const window: zbar_window_t; verbosity: Integer): Integer;
begin
  Result := _zbar_error_spew(window, verbosity);
end;

function zbar_window_error_string(const window: zbar_window_t; verbosity: Integer): PAnsiChar;
begin
  Result := _zbar_error_string(window, verbosity);
end;

function zbar_window_get_error_code(const window: zbar_window_t): zbar_error_t;
begin
  Result := _zbar_get_error_code(window);
end;

function zbar_image_scanner_parse_config(scanner: zbar_image_scanner_t; const config_string: PAnsiChar): Integer;
var
  sym: zbar_symbol_type_t;
  cfg: zbar_config_t;
  val: Integer;
begin
  Result := zbar_parse_config(config_string, sym, cfg, val) or zbar_image_scanner_set_config(scanner, sym, cfg, val);
end;

function zbar_decoder_parse_config(decoder: zbar_decoder_t; const config_string: PAnsiChar): Integer;
var
  sym: zbar_symbol_type_t;
  cfg: zbar_config_t;
  val: Integer;
begin
  Result := zbar_parse_config(config_string, sym, cfg, val) or zbar_decoder_set_config(decoder, sym, cfg, val);
end;

function zbar_scan_rgb24(scanner: zbar_scanner_t; rgb: PByte): zbar_symbol_type_t;
begin
  Result := zbar_scan_y(scanner, Ord(PAnsiChar(rgb)[0]) + Ord(PAnsiChar(rgb)[1]) + Ord(PAnsiChar(rgb)[2]));
end;

function zbar_fourcc(a, b, c, d: LongWord): LongWord;
begin
  Result := a or (b shl 8) or (c shl 16) or (d shl 24);
end;

function zbar_fourcc_parse(format: PAnsiChar): LongWord;
var i: Integer;
begin
  Result := 0;
  if format <> nil then
    for i := 0 to 3 do
{$ifdef NEXTGEN}
      if format[i] = 0 then
{$else}
      if format[i] = #0 then
{$endif NEXTGEN}
        Break
      else
        Result := Result or (LongWord(Ord(format[i])) shl (i * 8));
end;

end.