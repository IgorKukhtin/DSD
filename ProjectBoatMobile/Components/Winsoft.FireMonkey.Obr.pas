// ---------------------------------------------------------------------
//
// Optical Barcode Recognition Component for FireMonkey
//
// Copyright (c) 2013-2021 WINSOFT
//
// ---------------------------------------------------------------------

//{$define TRIAL} // trial version, comment this line for full version

{$WARN SYMBOL_DEPRECATED OFF}

unit Winsoft.FireMonkey.Obr;

interface

{$if CompilerVersion = 23}
  {$define DXE2}
{$ifend}

{$if CompilerVersion >= 24} // Delphi XE3 or higher
  {$LEGACYIFEND ON}
{$ifend}

{$if CompilerVersion >= 26} // Delphi XE5 or higher
  {$define DXE5PLUS}
{$ifend}

{$if CompilerVersion >= 29} // Delphi XE8 or higher
  {$define DXE8PLUS}
{$ifend}

{$if CompilerVersion >= 33} // Delphi 10.3 or higher
  {$define D103PLUS}
{$ifend}

{$if CompilerVersion >= 35} // Delphi 11 or higher
  {$define D11PLUS}
{$ifend}

{$ifdef IOS}
  {$ifdef CPUARM}
    {$define IOS_DEVICE}
  {$else}
    {$define IOS_SIMULATOR}
  {$endif CPUARM}
{$endif IOS}

{$ifdef WIN32}
{$HPPEMIT '#pragma link "Winsoft.FireMonkey.ObrP.lib"'}
{$endif WIN32}

{$ifdef WIN64}
{$HPPEMIT '#pragma link "Winsoft.FireMonkey.ObrP.a"'}
{$endif WIN64}

uses
  {$ifdef MSWINDOWS} Winapi.Windows, {$endif MSWINDOWS}
  {$ifdef DXE5PLUS} FMX.Graphics {$else} FMX.Types {$endif DXE5PLUS},
  Winsoft.FireMonkey.ZBar, System.Types, System.SysUtils, System.Classes;

type
  EObrError = class(Exception);

type
  TObrSymbology =
  (
    syNone            =   0, // no symbol decoded
    syPartial         =   1, // intermediate status
    syEan2            =   2, // GS1 2-digit add-on
    syEan5            =   5, // GS1 5-digit add-on
    syEan8            =   8, // EAN-8
    syUpcE            =   9, // UPC-E
    syIsbn10          =  10, // ISBN-10 (from EAN-13)
    syUpcA            =  12, // UPC-A
    syEan13           =  13, // EAN-13
    syIsbn13          =  14, // ISBN-13 (from EAN-13)
    syComposite       =  15, // EAN/UPC composite
    syInterleaved2of5 =  25, // Interleaved 2 of 5
    syDataBar         =  34, // GS1 DataBar (RSS)
    syExpandedDataBar =  35, // GS1 DataBar Expanded
    syCodabar         =  38, // Codabar
    syCode39          =  39, // Code 39
    syPdf417          =  57, // PDF417
    syQrCode          =  64, // QR Code
    sySqCode          =  80, // SQ Code
    syCode93          =  93, // Code 93
    syCode128         = 128  // Code 128
  );

type
  TObrSymbologyAddon =
  (
    saNone,   // no add-on flag
    sa2Digit, // 2-digit add-on flag
    sa5Digit  // 5-digit add-on flag
  );

type
  TObrConfig =
  (
    coEnableSymbology = 0, // enable symbology/feature
    coEnableCheckDigit,    // enable check digit when optional
    coReturnCheckDigit,    // return check digit when present
    coFullAscii,           // enable full ASCII character set
    coBinary,              // don't convert binary data to text
    coBooleanConfigCount,  // number of boolean decoder configs
    coMinDataLength = $20, // minimum data length for valid decode
    coMaxDataLength,       // maximum data length for valid decode
    coUncertainty = $40,   // required video consistency frames
    coPositionData = $80,  // enable scanner to collect position data
    coTryInverted = $81,   // if fails to decode, test inverted
    coDensityX = $100,     // image scanner vertical scan density
    coDensityY             // image scanner horizontal scan density
  );

type
  TObrOrientation =
  (
    orUnknown = -1, // unable to determine orientation
    orUp,           // upright, read left to right
    orRight,        // sideways, read top to bottom
    orDown,         // upside-down, read right to left
    orLeft          // sideways, read bottom to top
  );

type
  TObrModifier =
  (
    moGs1Reserved, // barcode tagged as GS1 (EAN.UCC) reserved (eg, FNC1 before first data character). Data may be parsed as a sequence of GS1 AIs.
    moAimReserved // barcode tagged as AIM reserved (eg, FNC1 after first character or digit pair)
  );

  TObrModifiers = set of TObrModifier;

type
  TObrImageFormat = (foY800, foGray);

  TFObr = class;

  TObrSymbol = class
  private
    FHandle: zbar_symbol_t;
    [weak] FObr: TFObr;
    function GetData: TBytes;
    function GetDataAnsi: string;
    function GetDataUtf8: string;
    function GetDataLength: Integer;
    function GetSymbology: TObrSymbology;
    function GetSymbologyName: string;
    function GetQuality: Integer;
    function GetCacheCount: Integer;
    function GetLocationCount: Integer;
    function GetLocationX(Index: Integer): Integer;
    function GetLocationY(Index: Integer): Integer;
    function GetModifiers: TObrModifiers;
    function GetOrientation: TObrOrientation;
    function GetOrientationName: string;
    function GetSymbologyAddon: TObrSymbologyAddon;
    function GetSymbologyAddonName: string;
  public
    constructor Create(Obr: TFObr; Handle: Pointer);
    property Handle: Pointer read FHandle stored False;
    property CacheCount: Integer read GetCacheCount stored False;
    property Data: TBytes read GetData stored False;
    property DataAnsi: string read GetDataAnsi stored False;
    property DataUtf8: string read GetDataUtf8 stored False;
    property DataLength: Integer read GetDataLength stored False;
    property LocationCount: Integer read GetLocationCount stored False;
    property LocationX[Index: Integer]: Integer read GetLocationX;
    property LocationY[Index: Integer]: Integer read GetLocationY;
    property Modifiers: TObrModifiers read GetModifiers;
    property Orientation: TObrOrientation read GetOrientation;
    property OrientationName: string read GetOrientationName;
    property Quality: Integer read GetQuality stored False;
    property Symbology: TObrSymbology read GetSymbology stored False;
    property SymbologyName: string read GetSymbologyName stored False;
    property SymbologyAddon: TObrSymbologyAddon read GetSymbologyAddon stored False;
    property SymbologyAddonName: string read GetSymbologyAddonName stored False;
  end;

  TObrImage = class
  private
    FHandle: zbar_image_t;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetData: Pointer;
    function GetDataLength: Integer;
    function GetFormat: TObrImageFormat;
  public
    constructor Create(Format: TObrImageFormat; Width, Height: Integer; Data: Pointer; DataLength: Integer);
    destructor Destroy; override;
    property Data: Pointer read GetData stored False;
    property DataLength: Integer read GetDataLength stored False;
    property Format: TObrImageFormat read GetFormat stored False;
    property Handle: Pointer read FHandle stored False;
    property Height: Integer read GetHeight stored False;
    property Width: Integer read GetWidth stored False;
  end;

  TObrImageScanner = class
  private
    FHandle: zbar_image_scanner_t;
  public
    constructor Create;
    destructor Destroy; override;
    procedure EnableCache;
    procedure DisableCache;
    procedure Configure(Symbology: TObrSymbology; Addon: TObrSymbologyAddon; Config: TObrConfig; Value: Integer); overload;
    procedure Configure(const Config: string); overload;
    function Scan(Image: TObrImage): Integer;
    property Handle: Pointer read FHandle stored False;
  end;

  TObrSymbolDynArray = array of TObrSymbol;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64 {$ifdef D103PLUS} or pidAndroid32Arm or pidAndroid64Arm {$else} {$ifndef DXE2} or pidAndroid {$endif DXE2} {$endif D103PLUS} {$ifdef DXE8PLUS} or pidiOSDevice64 {$endif DXE8PLUS})]
  TFObr = class(TComponent)
  private
    FActive: Boolean;
    FBarcodes: TObrSymbolDynArray;
    FImage: TObrImage;
    FImageScanner: TObrImageScanner;
    FPicture: TBitmap;
    FPictureData: TByteDynArray;
    FScanLeft: Integer;
    FScanHeight: Integer;
    FScanTop: Integer;
    FScanWidth: Integer;
    FOnBarcodeDetected: TNotifyEvent;
    function GetAbout: string;
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    procedure SetEmpty(const Value: string);
    procedure SetPicture(Value: TBitmap);
    function GetBarcode(Index: Integer): TObrSymbol;
    function GetBarcodeCount: Integer;
    procedure FreeBarcodes;
    procedure SetScanLeft(Value: Integer);
    procedure SetScanHeight(Value: Integer);
    procedure SetScanWidth(Value: Integer);
    procedure SetScanTop(Value: Integer);
  protected
    procedure CheckActive;
    procedure Loaded; override;
    procedure PictureChanged(Sender: TObject);
    function GetPictureData(var Width, Height: Integer): TByteDynArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Configure(Symbology: TObrSymbology; Addon: TObrSymbologyAddon; Config: TObrConfig; Value: Integer);
    procedure Scan;
    property ImageScanner: TObrImageScanner read FImageScanner stored false;
    property Image: TObrImage read FImage stored false;
    property BarcodeCount: Integer read GetBarcodeCount stored false;
    property Barcode[Index: Integer]: TObrSymbol read GetBarcode;
  published
    property About: string read GetAbout write SetEmpty stored False;
    property Active: Boolean read GetActive write SetActive default False;
    property Picture: TBitmap read FPicture write SetPicture;
    property ScanLeft: Integer read FScanLeft write SetScanLeft default 0;
    property ScanHeight: Integer read FScanHeight write SetScanHeight default 0;
    property ScanTop: Integer read FScanTop write SetScanTop default 0;
    property ScanWidth: Integer read FScanWidth write SetScanWidth default 0;
    property OnBarcodeDetected: TNotifyEvent read FOnBarcodeDetected write FOnBarcodeDetected;
  end;

function ModifierName(Modifier: TObrModifier): string;
function OrientationName(Orientation: TObrOrientation): string;
function SymbologyName(Symbology: TObrSymbology): string;
function SymbologyAddonName(SymbologyAddon: TObrSymbologyAddon): string;

{$ifdef IOS_DEVICE}
{$define STATIC_LIBRARY}
{$endif IOS_DEVICE}

{$ifdef ANDROID}
{$define STATIC_LIBRARY}
{$endif ANDROID}

{$ifdef STATIC_LIBRARY}
const
  LibZBar = 'libzbar.a';

function zbar_version(var major, minor, patch: LongWord): Integer; cdecl; external LibZBar;
procedure zbar_set_verbosity(verbosity: Integer); cdecl; external LibZBar;
procedure zbar_increase_verbosity; cdecl; external LibZBar;
function zbar_get_symbol_name(sym: zbar_symbol_type_t): PAnsiChar; cdecl; external LibZBar;
function zbar_get_addon_name(sym: zbar_symbol_type_t): PAnsiChar; cdecl; external LibZBar;
function zbar_get_config_name(config: zbar_config_t): PAnsiChar; cdecl; external LibZBar;
function zbar_get_modifier_name(modifier: zbar_modifier_t): PAnsiChar; cdecl; external LibZBar;
function zbar_get_orientation_name(orientation: zbar_orientation_t): PAnsiChar; cdecl; external LibZBar;
function zbar_parse_config(const config_string: PAnsiChar; var symbology: zbar_symbol_type_t; var config: zbar_config_t; var value: Integer): Integer; cdecl; external LibZBar;
function _zbar_error_spew(const _object: Pointer; verbosity: Integer): Integer; cdecl; external LibZBar;
function _zbar_error_string(const _object: Pointer; verbosity: Integer): PAnsiChar; cdecl; external LibZBar;
function _zbar_get_error_code(const _object: Pointer): zbar_error_t; cdecl; external LibZBar;
procedure zbar_symbol_ref(const symbol: zbar_symbol_t; refs: Integer); cdecl; external LibZBar;
function zbar_symbol_get_type(const symbol: zbar_symbol_t): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_symbol_get_configs(const symbol: zbar_symbol_t): LongWord; cdecl; external LibZBar;
function zbar_symbol_get_modifiers(const symbol: zbar_symbol_t): LongWord; cdecl; external LibZBar;
function zbar_symbol_get_data(const symbol: zbar_symbol_t): PAnsiChar; cdecl; external LibZBar;
function zbar_symbol_get_data_length(const symbol: zbar_symbol_t): LongWord; cdecl; external LibZBar;
function zbar_symbol_get_quality(const symbol: zbar_symbol_t): Integer; cdecl; external LibZBar;
function zbar_symbol_get_count(const symbol: zbar_symbol_t): Integer; cdecl; external LibZBar;
function zbar_symbol_get_loc_size(const symbol: zbar_symbol_t): LongWord; cdecl; external LibZBar;
function zbar_symbol_get_loc_x(const symbol: zbar_symbol_t; index: LongWord): Integer; cdecl; external LibZBar;
function zbar_symbol_get_loc_y(const symbol: zbar_symbol_t; index: LongWord): Integer; cdecl; external LibZBar;
function zbar_symbol_get_orientation(const symbol: zbar_symbol_t): zbar_orientation_t; cdecl; external LibZBar;
function zbar_symbol_next(const symbol: zbar_symbol_t): zbar_symbol_t; cdecl; external LibZBar;
function zbar_symbol_get_components(const symbol: zbar_symbol_t): zbar_symbol_set_t; cdecl; external LibZBar;
function zbar_symbol_first_component(const symbol: zbar_symbol_t): zbar_symbol_t; cdecl; external LibZBar;
function zbar_symbol_xml(const symbol: zbar_symbol_t; var buffer: PAnsiChar; var buflen: LongWord): PAnsiChar; cdecl; external LibZBar;
procedure zbar_symbol_set_ref(const symbols: zbar_symbol_set_t; refs: Integer); cdecl; external LibZBar;
function zbar_symbol_set_get_size(const symbols: zbar_symbol_set_t): Integer; cdecl; external LibZBar;
function zbar_symbol_set_first_symbol(const symbols: zbar_symbol_set_t): zbar_symbol_t; cdecl; external LibZBar;
function zbar_symbol_set_first_unfiltered(const symbols: zbar_symbol_set_t): zbar_symbol_t; cdecl; external LibZBar;
function zbar_image_create: zbar_image_t; cdecl; external LibZBar;
procedure zbar_image_destroy(image: zbar_image_t); cdecl; external LibZBar;
procedure zbar_image_ref(image: zbar_image_t; refs: Integer); cdecl; external LibZBar;
//  zbar_image_convert: zbar_image_convert_t;
//  zbar_image_convert_resize: zbar_image_convert_resize_t;
function zbar_image_get_format(const image: zbar_image_t): LongWord; cdecl; external LibZBar;
function zbar_image_get_sequence(const image: zbar_image_t): LongWord; cdecl; external LibZBar;
function zbar_image_get_width(const image: zbar_image_t): LongWord; cdecl; external LibZBar;
function zbar_image_get_height(const image: zbar_image_t): LongWord; cdecl; external LibZBar;
procedure zbar_image_get_size(const image: zbar_image_t; var width, height: LongWord); cdecl; external LibZBar;
procedure zbar_image_get_crop(const image: zbar_image_t; var x, y, width, height: LongWord); cdecl; external LibZBar;
function zbar_image_get_data(const image: zbar_image_t): Pointer; cdecl; external LibZBar;
function zbar_image_get_data_length(const img: zbar_image_t): LongWord; cdecl; external LibZBar;
function zbar_image_get_symbols(const image: zbar_image_t): zbar_symbol_set_t; cdecl; external LibZBar;
procedure zbar_image_set_symbols(image: zbar_image_t; const symbols: zbar_symbol_set_t); cdecl; external LibZBar;
function zbar_image_first_symbol(const image: zbar_image_t): zbar_symbol_t; cdecl; external LibZBar;
procedure zbar_image_set_format(image: zbar_image_t; format: LongWord); cdecl; external LibZBar;
procedure zbar_image_set_sequence(image: zbar_image_t; sequence_num: LongWord); cdecl; external LibZBar;
procedure zbar_image_set_size(image: zbar_image_t; width, height: LongWord); cdecl; external LibZBar;
procedure zbar_image_set_crop(image: zbar_image_t; x, y, width, height: LongWord); cdecl; external LibZBar;
procedure zbar_image_set_data(image: zbar_image_t; const data: Pointer; data_byte_length: LongWord; cleanup_hndlr: zbar_image_cleanup_handler_t); cdecl; external LibZBar;
procedure zbar_image_free_data(image: zbar_image_t); cdecl; external LibZBar;
procedure zbar_image_set_userdata(image: zbar_image_t; userdata: Pointer); cdecl; external LibZBar;
function zbar_image_get_userdata(const image: zbar_image_t): Pointer; cdecl; external LibZBar;
function zbar_image_write(const image: zbar_image_t; const filebase: PAnsiChar): Integer; cdecl; external LibZBar;
function zbar_image_scanner_create: zbar_image_scanner_t; cdecl; external LibZBar;
procedure zbar_image_scanner_destroy(scanner: zbar_image_scanner_t); cdecl; external LibZBar;
function zbar_image_scanner_set_data_handler(scanner: zbar_image_scanner_t; handler: zbar_image_data_handler_t; const userdata: Pointer): zbar_image_data_handler_t; cdecl; external LibZBar;
function zbar_image_scanner_set_config(scanner: zbar_image_scanner_t; symbology: zbar_symbol_type_t; config: zbar_config_t; value: Integer): Integer; cdecl; external LibZBar;
procedure zbar_image_scanner_enable_cache(scanner: zbar_image_scanner_t; enable: Integer); cdecl; external LibZBar;
procedure zbar_image_scanner_recycle_image(scanner: zbar_image_scanner_t; image: zbar_image_t); cdecl; external LibZBar;
function zbar_image_scanner_get_results(const scanner: zbar_image_scanner_t): zbar_symbol_set_t; cdecl; external LibZBar;
function zbar_scan_image(scanner: zbar_image_scanner_t; image: zbar_image_t): Integer; cdecl; external LibZBar;
function zbar_decoder_create: zbar_decoder_t; cdecl; external LibZBar;
procedure zbar_decoder_destroy(decoder: zbar_decoder_t); cdecl; external LibZBar;
function zbar_decoder_set_config(decoder: zbar_decoder_t; symbology: zbar_symbol_type_t; config: zbar_config_t; value: Integer): Integer; cdecl; external LibZBar;
function zbar_decoder_get_configs(const decoder: zbar_decoder_t; symbology: zbar_symbol_type_t): LongWord; cdecl; external LibZBar;
procedure zbar_decoder_reset(decoder: zbar_decoder_t); cdecl; external LibZBar;
procedure zbar_decoder_new_scan(decoder: zbar_decoder_t); cdecl; external LibZBar;
function zbar_decode_width(decoder: zbar_decoder_t; width: LongWord): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_decoder_get_color(const decoder: zbar_decoder_t): zbar_color_t; cdecl; external LibZBar;
function zbar_decoder_get_data(const decoder: zbar_decoder_t): PAnsiChar; cdecl; external LibZBar;
function zbar_decoder_get_data_length(const decoder: zbar_decoder_t): LongWord; cdecl; external LibZBar;
function zbar_decoder_get_type(const decoder: zbar_decoder_t): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_decoder_get_modifiers(const decoder: zbar_decoder_t): LongWord; cdecl; external LibZBar;
function zbar_decoder_get_direction(const decoder: zbar_decoder_t): Integer; cdecl; external LibZBar;
function zbar_decoder_set_handler(decoder: zbar_decoder_t; handler: zbar_decoder_handler_t): zbar_decoder_handler_t; cdecl; external LibZBar;
procedure zbar_decoder_set_userdata(decoder: zbar_decoder_t; userdata: Pointer); cdecl; external LibZBar;
function zbar_decoder_get_userdata(const decoder: zbar_decoder_t): Pointer; cdecl; external LibZBar;
function zbar_scanner_create(decoder: zbar_decoder_t): zbar_scanner_t; cdecl; external LibZBar;
procedure zbar_scanner_destroy(scanner: zbar_scanner_t); cdecl; external LibZBar;
function zbar_scanner_reset(scanner: zbar_scanner_t): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_scanner_new_scan(scanner: zbar_scanner_t): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_scanner_flush(scanner: zbar_scanner_t): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_scan_y(scanner: zbar_scanner_t; y: Integer): zbar_symbol_type_t; cdecl; external LibZBar;
function zbar_scanner_get_width(const scanner: zbar_scanner_t): LongWord; cdecl; external LibZBar;
function zbar_scanner_get_edge(const scanner: zbar_scanner_t; offset: LongWord; prec: Integer): LongWord; cdecl; external LibZBar;
function zbar_scanner_get_color(const scanner: zbar_scanner_t): zbar_color_t; cdecl; external LibZBar;
{$else}
var
  ZBarLibraryName: string = '';
  ZBarLibrary: HMODULE;

{$ifdef IOS_SIMULATOR}
  IConvLibraryName: string = '';
  IConvLibrary: HMODULE;
{$endif IOS_SIMULATOR}

  zbar_version: zbar_version_t;
  zbar_set_verbosity: zbar_set_verbosity_t;
  zbar_increase_verbosity: zbar_increase_verbosity_t;
  zbar_get_symbol_name: zbar_get_symbol_name_t;
  zbar_get_addon_name: zbar_get_addon_name_t;
  zbar_get_config_name: zbar_get_config_name_t;
  zbar_get_modifier_name: zbar_get_modifier_name_t;
  zbar_get_orientation_name: zbar_get_orientation_name_t;
  zbar_parse_config: zbar_parse_config_t;
  _zbar_error_spew: _zbar_error_spew_t;
  _zbar_error_string: _zbar_error_string_t;
  _zbar_get_error_code: _zbar_get_error_code_t;
  zbar_symbol_ref: zbar_symbol_ref_t;
  zbar_symbol_get_type: zbar_symbol_get_type_t;
  zbar_symbol_get_configs: zbar_symbol_get_configs_t;
  zbar_symbol_get_modifiers: zbar_symbol_get_modifiers_t;
  zbar_symbol_get_data: zbar_symbol_get_data_t;
  zbar_symbol_get_data_length: zbar_symbol_get_data_length_t;
  zbar_symbol_get_quality: zbar_symbol_get_quality_t;
  zbar_symbol_get_count: zbar_symbol_get_count_t;
  zbar_symbol_get_loc_size: zbar_symbol_get_loc_size_t;
  zbar_symbol_get_loc_x: zbar_symbol_get_loc_x_t;
  zbar_symbol_get_loc_y: zbar_symbol_get_loc_y_t;
  zbar_symbol_get_orientation: zbar_symbol_get_orientation_t;
  zbar_symbol_next: zbar_symbol_next_t;
  zbar_symbol_get_components: zbar_symbol_get_components_t;
  zbar_symbol_first_component: zbar_symbol_first_component_t;
  zbar_symbol_xml: zbar_symbol_xml_t;
  zbar_symbol_set_ref: zbar_symbol_set_ref_t;
  zbar_symbol_set_get_size: zbar_symbol_set_get_size_t;
  zbar_symbol_set_first_symbol: zbar_symbol_set_first_symbol_t;
  zbar_symbol_set_first_unfiltered: zbar_symbol_set_first_unfiltered_t;
  zbar_image_create: zbar_image_create_t;
  zbar_image_destroy: zbar_image_destroy_t;
  zbar_image_ref: zbar_image_ref_t;
  zbar_image_get_format: zbar_image_get_format_t;
  zbar_image_get_sequence: zbar_image_get_sequence_t;
  zbar_image_get_width: zbar_image_get_width_t;
  zbar_image_get_height: zbar_image_get_height_t;
  zbar_image_get_size: zbar_image_get_size_t;
  zbar_image_get_crop: zbar_image_get_crop_t;
  zbar_image_get_data: zbar_image_get_data_t;
  zbar_image_get_data_length: zbar_image_get_data_length_t;
  zbar_image_get_symbols: zbar_image_get_symbols_t;
  zbar_image_set_symbols: zbar_image_set_symbols_t;
  zbar_image_first_symbol: zbar_image_first_symbol_t;
  zbar_image_set_format: zbar_image_set_format_t;
  zbar_image_set_sequence: zbar_image_set_sequence_t;
  zbar_image_set_size: zbar_image_set_size_t;
  zbar_image_set_crop: zbar_image_set_crop_t;
  zbar_image_set_data: zbar_image_set_data_t;
  zbar_image_free_data: zbar_image_free_data_t;
  zbar_image_set_userdata: zbar_image_set_userdata_t;
  zbar_image_get_userdata: zbar_image_get_userdata_t;
  zbar_image_write: zbar_image_write_t;
  zbar_image_scanner_create: zbar_image_scanner_create_t;
  zbar_image_scanner_destroy: zbar_image_scanner_destroy_t;
  zbar_image_scanner_set_data_handler: zbar_image_scanner_set_data_handler_t;
  zbar_image_scanner_set_config: zbar_image_scanner_set_config_t;
  zbar_image_scanner_enable_cache: zbar_image_scanner_enable_cache_t;
  zbar_image_scanner_recycle_image: zbar_image_scanner_recycle_image_t;
  zbar_image_scanner_get_results: zbar_image_scanner_get_results_t;
  zbar_scan_image: zbar_scan_image_t;
  zbar_decoder_create: zbar_decoder_create_t;
  zbar_decoder_destroy: zbar_decoder_destroy_t;
  zbar_decoder_set_config: zbar_decoder_set_config_t;
  zbar_decoder_get_configs: zbar_decoder_get_configs_t;
  zbar_decoder_reset: zbar_decoder_reset_t;
  zbar_decoder_new_scan: zbar_decoder_new_scan_t;
  zbar_decode_width: zbar_decode_width_t;
  zbar_decoder_get_color: zbar_decoder_get_color_t;
  zbar_decoder_get_data: zbar_decoder_get_data_t;
  zbar_decoder_get_data_length: zbar_decoder_get_data_length_t;
  zbar_decoder_get_type: zbar_decoder_get_type_t;
  zbar_decoder_get_modifiers: zbar_decoder_get_modifiers_t;
  zbar_decoder_get_direction: zbar_decoder_get_direction_t;
  zbar_decoder_set_handler: zbar_decoder_set_handler_t;
  zbar_decoder_set_userdata: zbar_decoder_set_userdata_t;
  zbar_decoder_get_userdata: zbar_decoder_get_userdata_t;
  zbar_scanner_create: zbar_scanner_create_t;
  zbar_scanner_destroy: zbar_scanner_destroy_t;
  zbar_scanner_reset: zbar_scanner_reset_t;
  zbar_scanner_new_scan: zbar_scanner_new_scan_t;
  zbar_scanner_flush: zbar_scanner_flush_t;
  zbar_scan_y: zbar_scan_y_t;
  zbar_scanner_get_width: zbar_scanner_get_width_t;
  zbar_scanner_get_edge: zbar_scanner_get_edge_t;
  zbar_scanner_get_color: zbar_scanner_get_color_t;
{$endif STATIC_LIBRARY}

function LoadedLibrary: Boolean;
procedure LoadLibrary;
procedure UnloadLibrary;

implementation

uses {$ifdef ANDROID} System.IOUtils, {$endif ANDROID} System.UITypes {$IFDEF TRIAL}, FMX.Dialogs {$ENDIF TRIAL};

resourcestring
  SZBarSymbolIsNull = 'ZBar Symbol is null';
  SCantCreateZBarImageScanner = 'Can''t create ZBar ImageScanner';
  SCantCreateZBarImage = 'Can''t create ZBar Image';
  SConfigurationError = 'Configuration error';
  SScanError = 'Scan error';
  SIncorrectIndex = 'Incorrect index';

function ToUtf8(const Text: string): TBytes;
begin
  Result := TEncoding.UTF8.GetBytes(Text);
end;

function FromUtf8(const Data: TBytes): string;
begin
  Result := TEncoding.UTF8.GetString(Data);
end;

function FromAnsi(const Data: TBytes): string;
begin
  Result := TEncoding.ANSI.GetString(Data);
end;

function PtrToBytes(Data: PAnsiChar): TBytes;
var
  Count: Integer;
  Ptr: PByte;
begin
  if Data = nil then
  begin
    Result := nil;
    Exit;
  end;

  // compute length
  Count := 0;
  Ptr := PByte(Data);
  while Ptr^ <> 0 do
  begin
    Inc(Count);
    Inc(Ptr);
  end;

  // copy data
  SetLength(Result, Count);
  Move(Data^, Result[0], Length(Result));
end;

procedure Check(Value: Boolean; ErrorMessage: string);
begin
  if not Value then
    raise EObrError.Create(ErrorMessage);
end;

const
  ImageFormatY800 = Ord('Y') + Ord('8') shl 8 + Ord('0') shl 16 + Ord('0') shl 24;
  ImageFormatGray = Ord('G') + Ord('R') shl 8 + Ord('A') shl 16 + Ord('Y') shl 24;

function EncodeImageFormat(Format: TObrImageFormat): LongWord;
begin
  if Format = foY800 then
    Result := ImageFormatY800
  else
    Result := ImageFormatGray;
end;

function DecodeImageFormat(Value: LongWord): TObrImageFormat;
begin
  if Value = ImageFormatY800 then
    Result := foY800
  else
    Result := foGray;
end;

function EncodeSymbology(Symbology: TObrSymbology; Addon: TObrSymbologyAddon): zbar_symbol_type_t;
begin
  Result := zbar_symbol_type_t(Symbology);
  case Addon of
    sa2Digit: Result := zbar_symbol_type_t(Ord(Result) or Integer(ZBAR_ADDON2));
    sa5Digit: Result := zbar_symbol_type_t(Ord(Result) or Integer(ZBAR_ADDON5));
  end;
end;

function DecodeSymbology(Value: zbar_symbol_type_t): TObrSymbology;
begin
  Result := TObrSymbology(Integer(Value) and Integer(ZBAR_SYMBOL));
end;

function DecodeSymbologyAddon(Value: zbar_symbol_type_t): TObrSymbologyAddon;
begin
  case Ord(Value) and Ord(ZBAR_ADDON) of
    Ord(ZBAR_ADDON2): Result := sa2Digit;
    Ord(ZBAR_ADDON5): Result := sa5Digit;
    else Result := saNone;
  end;
end;

function DecodeModifiers(Value: LongWord): TObrModifiers;
begin
  Result := [];
  if (Value and (1 shl Ord(ZBAR_MOD_GS1))) <> 0 then
    Result := Result + [moGs1Reserved];
  if (Value and (1 shl Ord(ZBAR_MOD_AIM))) <> 0 then
    Result := Result + [moAimReserved];
end;

function ModifierName(Modifier: TObrModifier): string;
begin
  Result := FromAnsi(PtrToBytes(zbar_get_modifier_name(ZBar_Modifier_t(Modifier))));
end;

function OrientationName(Orientation: TObrOrientation): string;
begin
  Result := FromAnsi(PtrToBytes(zbar_get_orientation_name(ZBar_Orientation_t(Orientation))));
end;

function SymbologyName(Symbology: TObrSymbology): string;
begin
  Result := FromAnsi(PtrToBytes(zbar_get_symbol_name(EncodeSymbology(Symbology, saNone))));
end;

function SymbologyAddonName(SymbologyAddon: TObrSymbologyAddon): string;
begin
  Result := FromAnsi(PtrToBytes(zbar_get_addon_name(EncodeSymbology(syNone, SymbologyAddon))));
end;

// TObrSymbol

constructor TObrSymbol.Create(Obr: TFObr; Handle: Pointer);
begin
  FObr := Obr;
  FHandle := Handle;
  Check(FHandle <> nil, SZBarSymbolIsNull);
end;

function TObrSymbol.GetCacheCount: Integer;
begin
  Result := zbar_symbol_get_count(FHandle);
end;

function TObrSymbol.GetData: TBytes;
begin
  SetLength(Result, DataLength);
  if Result <> nil then
    Move(zbar_symbol_get_data(FHandle)^, Result[0], Length(Result));
end;

function TObrSymbol.GetDataAnsi: string;
begin
  Result := FromAnsi(Data);
end;

function TObrSymbol.GetDataUtf8: string;
begin
  Result := FromUtf8(Data);
end;

function TObrSymbol.GetDataLength: Integer;
begin
  Result := zbar_symbol_get_data_length(FHandle);
end;

function TObrSymbol.GetLocationCount: Integer;
begin
  Result := zbar_symbol_get_loc_size(FHandle);
end;

function TObrSymbol.GetLocationX(Index: Integer): Integer;
begin
  Result := zbar_symbol_get_loc_x(FHandle, Index) + FObr.FScanLeft;
end;

function TObrSymbol.GetLocationY(Index: Integer): Integer;
begin
  Result := zbar_symbol_get_loc_y(FHandle, Index) + FObr.FScanTop;
end;

function TObrSymbol.GetModifiers: TObrModifiers;
begin
  Result := DecodeModifiers(zbar_symbol_get_modifiers(FHandle));
end;

function TObrSymbol.GetOrientation: TObrOrientation;
begin
  Result := TObrOrientation(zbar_symbol_get_orientation(FHandle));
end;

function TObrSymbol.GetOrientationName: string;
begin
  Result := Winsoft.FireMonkey.Obr.OrientationName(Orientation);
end;

function TObrSymbol.GetQuality: Integer;
begin
  Result := zbar_symbol_get_quality(FHandle);
end;

function TObrSymbol.GetSymbology: TObrSymbology;
begin
  Result := DecodeSymbology(zbar_symbol_get_type(FHandle));
end;

function TObrSymbol.GetSymbologyName: string;
begin
  Result := Winsoft.FireMonkey.Obr.SymbologyName(Symbology);
end;

function TObrSymbol.GetSymbologyAddon: TObrSymbologyAddon;
begin
  Result := DecodeSymbologyAddon(zbar_symbol_get_type(FHandle));
end;

function TObrSymbol.GetSymbologyAddonName: string;
begin
  Result := Winsoft.FireMonkey.Obr.SymbologyAddonName(SymbologyAddon);
end;

// TObrImage

constructor TObrImage.Create(Format: TObrImageFormat; Width, Height: Integer; Data: Pointer; DataLength: Integer);
begin
  FHandle := zbar_image_create;
  Check(FHandle <> nil, SCantCreateZBarImage);
  zbar_image_set_format(FHandle, EncodeImageFormat(Format));
  zbar_image_set_size(FHandle, Width, Height);
  zbar_image_set_data(FHandle, Data, DataLength, nil);
end;

destructor TObrImage.Destroy;
begin
  if FHandle <> nil then
    zbar_image_destroy(FHandle);
  inherited;
end;

function TObrImage.GetData: Pointer;
begin
  Result := zbar_image_get_data(FHandle);
end;

function TObrImage.GetDataLength: Integer;
begin
  Result := zbar_image_get_data_length(FHandle);
end;

function TObrImage.GetFormat: TObrImageFormat;
begin
  Result := DecodeImageFormat(zbar_image_get_format(FHandle));
end;

function TObrImage.GetWidth: Integer;
begin
  Result := zbar_image_get_width(FHandle);
end;

function TObrImage.GetHeight: Integer;
begin
  Result := zbar_image_get_height(FHandle);
end;

// TObrImageScanner

constructor TObrImageScanner.Create;
begin
  FHandle := zbar_image_scanner_create;
  Check(FHandle <> nil, SCantCreateZBarImageScanner);
end;

destructor TObrImageScanner.Destroy;
begin
  if FHandle <> nil then
    zbar_image_scanner_destroy(FHandle);
  inherited;
end;

procedure TObrImageScanner.EnableCache;
begin
  zbar_image_scanner_enable_cache(FHandle, 1);
end;

procedure TObrImageScanner.DisableCache;
begin
  zbar_image_scanner_enable_cache(FHandle, 0);
end;

procedure TObrImageScanner.Configure(Symbology: TObrSymbology; Addon: TObrSymbologyAddon; Config: TObrConfig; Value: Integer);
begin
  Check(zbar_image_scanner_set_config(FHandle, EncodeSymbology(Symbology, Addon), zbar_config_t(Config), Value) = 0, SConfigurationError);
end;

procedure TObrImageScanner.Configure(const Config: string);
var
{$ifdef NEXTGEN}
  ConfigValue: TBytes;
{$else}
  ConfigValue: AnsiString;
{$endif NEXTGEN}
  ConfigPtr: PAnsiChar;
begin
{$ifdef NEXTGEN}
  ConfigValue := ToUtf8(Config);
  ConfigPtr := @ConfigValue[0];
{$else}
  ConfigValue := AnsiString(Config);
  ConfigPtr := PAnsiChar(ConfigValue);
{$endif NEXTGEN}

  Check(zbar_image_scanner_parse_config(FHandle, ConfigPtr) = 0, SConfigurationError);
end;

function TObrImageScanner.Scan(Image: TObrImage): Integer;
begin
  Result := zbar_scan_image(FHandle, Image.FHandle);
  Check(Result >= 0, SScanError);
end;

// TFObr

constructor TFObr.Create(AOwner: TComponent);
begin
  inherited;
  FPicture := TBitmap.Create(0, 0);
  FPicture.OnChange := PictureChanged;
end;

destructor TFObr.Destroy;
begin
  Active := False;
  FreeAndNil(FPicture);
  inherited Destroy;
end;

procedure TFObr.FreeBarcodes;
var i: Integer;
begin
  for i := Length(FBarcodes) - 1 downto 0 do
    FreeAndNil(FBarcodes[i]);
  FBarcodes := nil;
end;

function TFObr.GetAbout: string;
begin
  Result := 'Version 3.6, Copyright (c) 2013-2021 WINSOFT, https://www.winsoft.sk';
end;

procedure TFObr.SetEmpty(const Value: string);
begin
end;

procedure TFObr.SetPicture(Value: TBitmap);
begin
  FPicture.Assign(Value);
end;

procedure TFObr.CheckActive;
begin
  Check(Active, 'Cannot perform this operation on an inactive ' + Name + ' component');
end;

function TFObr.GetActive: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := FImageScanner <> nil
  else
    Result := FActive;
end;

procedure TFObr.SetActive(Value: Boolean);
begin
  if Active <> Value then
    if not (csDesigning in ComponentState) then
      if not (csLoading in ComponentState) then
        if Value then
        begin
          LoadLibrary;
          FImageScanner := TObrImageScanner.Create
        end
        else
        begin
          FreeAndNil(FImage);
          FreeAndNil(FImageScanner);
          FPictureData := nil;
          FreeBarcodes;
        end;

  FActive := Value;
end;

procedure TFObr.Loaded;
begin
  inherited;
  SetActive(FActive);
end;

procedure TFObr.PictureChanged(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
  begin
    FreeAndNil(FImage);
    FPictureData := nil;
    FreeBarcodes;
  end;
end;

procedure TFObr.Configure(Symbology: TObrSymbology; Addon: TObrSymbologyAddon; Config: TObrConfig; Value: Integer);
begin
  CheckActive;
  FImageScanner.Configure(Symbology, Addon, Config, Value)
end;

procedure TFObr.Scan;
var
  Width, Height, BarcodeCount, I: Integer;
  Symbol: Pointer;
begin
  CheckActive;
  FreeAndNil(FImage);
  FPictureData := nil;
  FreeBarcodes;
  if FImageScanner <> nil then
  begin
    if FPicture.IsEmpty then
      Exit;

    FPictureData := GetPictureData(Width, Height);
    if FPictureData = nil then
      Exit;

    FImage := TObrImage.Create(foY800, Width, Height, FPictureData, Width * Height);

    BarcodeCount := FImageScanner.Scan(FImage);
    if BarcodeCount > 0 then
    begin
      SetLength(FBarcodes, BarcodeCount);

      Symbol := zbar_image_first_symbol(FImage.Handle);
      for I := 0 to BarcodeCount - 1 do
      begin
        FBarcodes[I] := TObrSymbol.Create(Self, Symbol);
        Symbol := zbar_symbol_next(Symbol);
      end;

      if Assigned(OnBarcodeDetected) then
        OnBarcodeDetected(Self);
    end;
  end
end;

function TFObr.GetBarcodeCount: Integer;
begin
  Result := Length(FBarcodes);
end;

function TFObr.GetBarcode(Index: Integer): TObrSymbol;
begin
  Check((Index >= 0) and (Index < Length(FBarcodes)), SIncorrectIndex);
  Result := FBarcodes[Index];
end;

function TFObr.GetPictureData(var Width, Height: Integer): TByteDynArray;
var
{$ifndef DXE2}
  Data: TBitmapData;
{$endif DXE2}
  FromX, ToX, FromY, ToY: Integer;
  I, X, Y: Integer;
  Color: TAlphaColor;
begin
  Result := nil;
{$ifndef DXE2}
  {$ifdef D11PLUS}
  if FPicture.Map(TMapAccess.Read, Data) then
  {$else}
  if FPicture.Map(TMapAccess.maRead, Data) then
  {$endif D11PLUS}
  try
{$endif DXE2}
    Width := FPicture.Width;
    Height := FPicture.Height;

    FromX := ScanLeft;
    if FromX >= Width then
      Exit;

    FromY := ScanTop;
    if FromY >= Height then
      Exit;

    if ScanWidth = 0 then
      ToX := Width - 1
    else
    begin
      ToX := FromX + ScanWidth - 1;
      if ToX >= Width then
        ToX := Width - 1;
    end;

    if ScanHeight = 0 then
      ToY := Height - 1
    else
    begin
      ToY := FromY + ScanHeight - 1;
      if ToY >= Height then
        ToY := Height - 1;
    end;

    Width := ToX - FromX + 1;
    Height := ToY - FromY + 1;
    SetLength(Result, Width * Height);

    I := 0;
    for Y := FromY to ToY do
      for X := FromX to ToX do
      begin
{$ifndef DXE2}
        Color := Data.GetPixel(X, Y);
{$else}
        Color := FPicture.Pixels[X, Y];
{$endif DXE2}
        Result[I] := Byte(Round(0.299 * (Color and $ff) + 0.587 * ((Color shr 8) and $ff) + 0.114 * ((Color shr 16) and $ff)));
        Inc(I);
      end;
{$ifndef DXE2}
  finally
    FPicture.Unmap(Data);
  end;
{$endif DXE2}
end;

procedure TFObr.SetScanLeft(Value: Integer);
begin
  if Value <> FScanLeft then
  begin
    FScanLeft := Value;
    if FScanLeft < 0 then
      FScanLeft := 0;
    PictureChanged(Self);
  end;
end;

procedure TFObr.SetScanHeight(Value: Integer);
begin
  if Value <> FScanHeight then
  begin
    FScanHeight := Value;
    if FScanHeight < 0 then
      FScanHeight := 0;
    PictureChanged(Self);
  end;
end;

procedure TFObr.SetScanTop(Value: Integer);
begin
  if Value <> FScanTop then
  begin
    FScanTop := Value;
    if FScanTop < 0 then
      FScanTop := 0;
    PictureChanged(Self);
  end;
end;

procedure TFObr.SetScanWidth(Value: Integer);
begin
  if Value <> FScanWidth then
  begin
    FScanWidth := Value;
    if FScanWidth < 0 then
      FScanWidth := 0;
    PictureChanged(Self);
  end;
end;

// ZBar library

function LoadedLibrary: Boolean;
begin
{$ifdef STATIC_LIBRARY}
  Result := True;
{$else}
  Result := ZBarLibrary <> 0;
{$endif STATIC_LIBRARY}
end;

procedure UnloadLibrary;
begin
{$ifndef STATIC_LIBRARY}
  if LoadedLibrary then
  begin
    FreeLibrary(ZBarLibrary);
    ZBarLibrary := 0;
  end;
{$endif STATIC_LIBRARY}
end;

{$ifndef STATIC_LIBRARY}
procedure CheckLoadLibrary(const Name: string; var Handle: HMODULE);
begin
  Handle := SafeLoadLibrary(PChar(Name));
  if Handle = 0 then
    raise EObrError.Create(SysErrorMessage(GetLastError) + ': ' + Name);
end;

function CheckGetProcAddress(const Name: string): Pointer;
var ErrorMessage: string;
begin
  Result := GetProcAddress(ZBarLibrary, PChar(Name));
  if Result = nil then
  begin
    ErrorMessage := SysErrorMessage(GetLastError) + ': ' + Name;
    UnloadLibrary;
    raise EObrError.Create(ErrorMessage);
  end;
end;

function GetLibraryExtension: string;
begin
{$ifdef MSWINDOWS}
   Result := 'dll';
{$endif MSWINDOWS}

{$ifdef MACOS} // including IOS
   Result := 'dylib';
{$endif MACOS}
end;

function GetLibraryPath(const Name: string): string;
begin
  Result := Name + '.' + GetLibraryExtension;
end;
{$endif STATIC_LIBRARY}

{$IFDEF TRIAL}
var WasTrial: Boolean;
{$ENDIF TRIAL}

procedure LoadLibrary;
begin
  {$IFDEF TRIAL}
  if not WasTrial then
  begin
    WasTrial := True;
    ShowMessage(
      'OBR for FireMonkey, Copyright (c) 2013-2021 WINSOFT' + #13#10#13#10 +
      'A trial version of OBR component started.' + #13#10#13#10 +
      'Please note that trial version is supposed to be used for evaluation only. ' +
      'If you wish to distribute OBR component as part of your application, ' +
      'you must register from website at https://www.winsoft.sk.' + #13#10#13#10 +
      'Thank you for trialing OBR component.');
  end;
  {$ENDIF TRIAL}

{$ifndef STATIC_LIBRARY}
  if not LoadedLibrary then
  begin

  {$ifdef IOS_SIMULATOR}
    if IConvLibrary <> 0 then
    begin
      FreeLibrary(IConvLibrary);
      IConvLibrary := 0;
    end;

    if IConvLibraryName = '' then
      IConvLibraryName := GetLibraryPath('libiconv');
    CheckLoadLibrary(IConvLibraryName, IConvLibrary);
  {$endif IOS_SIMULATOR}

    if ZBarLibraryName = '' then
      ZBarLibraryName := GetLibraryPath('libzbar');
    CheckLoadLibrary(ZBarLibraryName, ZBarLibrary);

    zbar_version := CheckGetProcAddress('zbar_version');
    zbar_set_verbosity := CheckGetProcAddress('zbar_set_verbosity');
    zbar_increase_verbosity := CheckGetProcAddress('zbar_increase_verbosity');
    zbar_get_symbol_name := CheckGetProcAddress('zbar_get_symbol_name');
    zbar_get_addon_name := CheckGetProcAddress('zbar_get_addon_name');
    zbar_get_config_name := CheckGetProcAddress('zbar_get_config_name');
    zbar_get_modifier_name := CheckGetProcAddress('zbar_get_modifier_name');
    zbar_get_orientation_name := CheckGetProcAddress('zbar_get_orientation_name');
    zbar_parse_config := CheckGetProcAddress('zbar_parse_config');
    _zbar_error_spew := CheckGetProcAddress('_zbar_error_spew');
    _zbar_error_string := CheckGetProcAddress('_zbar_error_string');
    _zbar_get_error_code := CheckGetProcAddress('_zbar_get_error_code');
    zbar_symbol_ref := CheckGetProcAddress('zbar_symbol_ref');
    zbar_symbol_get_type := CheckGetProcAddress('zbar_symbol_get_type');
    zbar_symbol_get_configs := CheckGetProcAddress('zbar_symbol_get_configs');
    zbar_symbol_get_modifiers := CheckGetProcAddress('zbar_symbol_get_modifiers');
    zbar_symbol_get_data := CheckGetProcAddress('zbar_symbol_get_data');
    zbar_symbol_get_data_length := CheckGetProcAddress('zbar_symbol_get_data_length');
    zbar_symbol_get_quality := CheckGetProcAddress('zbar_symbol_get_quality');
    zbar_symbol_get_count := CheckGetProcAddress('zbar_symbol_get_count');
    zbar_symbol_get_loc_size := CheckGetProcAddress('zbar_symbol_get_loc_size');
    zbar_symbol_get_loc_x := CheckGetProcAddress('zbar_symbol_get_loc_x');
    zbar_symbol_get_loc_y := CheckGetProcAddress('zbar_symbol_get_loc_y');
    zbar_symbol_get_orientation := CheckGetProcAddress('zbar_symbol_get_orientation');
    zbar_symbol_next := CheckGetProcAddress('zbar_symbol_next');
    zbar_symbol_get_components := CheckGetProcAddress('zbar_symbol_get_components');
    zbar_symbol_first_component := CheckGetProcAddress('zbar_symbol_first_component');
    zbar_symbol_xml := CheckGetProcAddress('zbar_symbol_xml');
    zbar_symbol_set_ref := CheckGetProcAddress('zbar_symbol_set_ref');
    zbar_symbol_set_get_size := CheckGetProcAddress('zbar_symbol_set_get_size');
    zbar_symbol_set_first_symbol := CheckGetProcAddress('zbar_symbol_set_first_symbol');
    zbar_symbol_set_first_unfiltered := CheckGetProcAddress('zbar_symbol_set_first_unfiltered');
    zbar_image_create := CheckGetProcAddress('zbar_image_create');
    zbar_image_destroy := CheckGetProcAddress('zbar_image_destroy');
    zbar_image_ref := CheckGetProcAddress('zbar_image_ref');
    zbar_image_get_format := CheckGetProcAddress('zbar_image_get_format');
    zbar_image_get_sequence := CheckGetProcAddress('zbar_image_get_sequence');
    zbar_image_get_width := CheckGetProcAddress('zbar_image_get_width');
    zbar_image_get_height := CheckGetProcAddress('zbar_image_get_height');
    zbar_image_get_size := CheckGetProcAddress('zbar_image_get_size');
    zbar_image_get_crop := CheckGetProcAddress('zbar_image_get_crop');
    zbar_image_get_data := CheckGetProcAddress('zbar_image_get_data');
    zbar_image_get_data_length := CheckGetProcAddress('zbar_image_get_data_length');
    zbar_image_get_symbols := CheckGetProcAddress('zbar_image_get_symbols');
    zbar_image_set_symbols := CheckGetProcAddress('zbar_image_set_symbols');
    zbar_image_first_symbol := CheckGetProcAddress('zbar_image_first_symbol');
    zbar_image_set_format := CheckGetProcAddress('zbar_image_set_format');
    zbar_image_set_sequence := CheckGetProcAddress('zbar_image_set_sequence');
    zbar_image_set_size := CheckGetProcAddress('zbar_image_set_size');
    zbar_image_set_crop := CheckGetProcAddress('zbar_image_set_crop');
    zbar_image_set_data := CheckGetProcAddress('zbar_image_set_data');
    zbar_image_free_data := CheckGetProcAddress('zbar_image_free_data');
    zbar_image_set_userdata := CheckGetProcAddress('zbar_image_set_userdata');
    zbar_image_get_userdata := CheckGetProcAddress('zbar_image_get_userdata');
    zbar_image_write := CheckGetProcAddress('zbar_image_write');
    zbar_image_scanner_create := CheckGetProcAddress('zbar_image_scanner_create');
    zbar_image_scanner_destroy := CheckGetProcAddress('zbar_image_scanner_destroy');
    zbar_image_scanner_set_data_handler := CheckGetProcAddress('zbar_image_scanner_set_data_handler');
    zbar_image_scanner_set_config := CheckGetProcAddress('zbar_image_scanner_set_config');
    zbar_image_scanner_enable_cache := CheckGetProcAddress('zbar_image_scanner_enable_cache');
    zbar_image_scanner_recycle_image := CheckGetProcAddress('zbar_image_scanner_recycle_image');
    zbar_image_scanner_get_results := CheckGetProcAddress('zbar_image_scanner_get_results');
    zbar_scan_image := CheckGetProcAddress('zbar_scan_image');
    zbar_decoder_create := CheckGetProcAddress('zbar_decoder_create');
    zbar_decoder_destroy := CheckGetProcAddress('zbar_decoder_destroy');
    zbar_decoder_set_config := CheckGetProcAddress('zbar_decoder_set_config');
    zbar_decoder_get_configs := CheckGetProcAddress('zbar_decoder_get_configs');
    zbar_decoder_reset := CheckGetProcAddress('zbar_decoder_reset');
    zbar_decoder_new_scan := CheckGetProcAddress('zbar_decoder_new_scan');
    zbar_decode_width := CheckGetProcAddress('zbar_decode_width');
    zbar_decoder_get_color := CheckGetProcAddress('zbar_decoder_get_color');
    zbar_decoder_get_data := CheckGetProcAddress('zbar_decoder_get_data');
    zbar_decoder_get_data_length := CheckGetProcAddress('zbar_decoder_get_data_length');
    zbar_decoder_get_type := CheckGetProcAddress('zbar_decoder_get_type');
    zbar_decoder_get_modifiers := CheckGetProcAddress('zbar_decoder_get_modifiers');
    zbar_decoder_get_direction := CheckGetProcAddress('zbar_decoder_get_direction');
    zbar_decoder_set_handler := CheckGetProcAddress('zbar_decoder_set_handler');
    zbar_decoder_set_userdata := CheckGetProcAddress('zbar_decoder_set_userdata');
    zbar_decoder_get_userdata := CheckGetProcAddress('zbar_decoder_get_userdata');
    zbar_scanner_create := CheckGetProcAddress('zbar_scanner_create');
    zbar_scanner_destroy := CheckGetProcAddress('zbar_scanner_destroy');
    zbar_scanner_reset := CheckGetProcAddress('zbar_scanner_reset');
    zbar_scanner_new_scan := CheckGetProcAddress('zbar_scanner_new_scan');
    zbar_scanner_flush := CheckGetProcAddress('zbar_scanner_flush');
    zbar_scan_y := CheckGetProcAddress('zbar_scan_y');
    zbar_scanner_get_width := CheckGetProcAddress('zbar_scanner_get_width');
    zbar_scanner_get_edge := CheckGetProcAddress('zbar_scanner_get_edge');
    zbar_scanner_get_color := CheckGetProcAddress('zbar_scanner_get_color');
  end;
{$endif STATIC_LIBRARY}
end;

end.