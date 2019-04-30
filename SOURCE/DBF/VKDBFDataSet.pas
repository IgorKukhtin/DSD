{**********************************************************************************}
{                                                                                  }
{ Project vkDBF - dbf ntx clipper compatibility delphi component                   }
{                                                                                  }
{ This Source Code Form is subject to the terms of the Mozilla Public              }
{ License, v. 2.0. If a copy of the MPL was not distributed with this              }
{ file, You can obtain one at http://mozilla.org/MPL/2.0/.                         }
{                                                                                  }
{ The Initial Developer of the Original Code is Vlad Karpov (KarpovVV@protek.ru).  }
{                                                                                  }
{ Contributors:                                                                    }
{   Sergey Klochkov (HSerg@sklabs.ru)                                              }
{                                                                                  }
{ You may retrieve the latest version of this file at the Project vkDBF home page, }
{ located at http://sourceforge.net/projects/vkdbf/                                }
{                                                                                  }
{**********************************************************************************}
unit VKDBFDataSet;

{$I VKDBF.DEF}

interface

uses
  {$IFDEF VKDBF_LOGGIN}VKDBFLogger,{$ENDIF}
  Windows, Messages, SysUtils, Classes, Forms, Db, DbConsts,
  {$IFDEF DELPHI6} Variants, FmtBcd, {$ENDIF}
  VKDBFPrx, VKDBFParser, VKDBFIndex, VKDBFNTX, VKDBFCDX,
  VKDBFUtil, VKDBFMemMgr, VKDBFGostCrypt, VKDBFCrypt, syncobjs;

const

  DBF_HEADIII_SIZE = 32;
  DBF_HEADV_SIZE = 68;
  FIELD_RECIII_SIZE = 32;
  FIELD_RECV_SIZE = 48;

  DB4_LockMin = $40000000;
  DB4_LockMax = $EFFFFFFF;
  DB4_LockRng = $B0000000;

  CLIPPER_LockMin = 1000000000;
  CLIPPER_LockMax = 1000000000;
  CLIPPER_LockRng = 1000000000;

  FOX_LockMin = $40000000;
  FOX_LockMax = $7FFFFFFE;
  FOX_LockRng = $06BCA198;

  CLIPPER_FOR_FOX_LOB_LockMin = $00000000;
  CLIPPER_FOR_FOX_LOB_LockMax = $00000000;
  CLIPPER_FOR_FOX_LOB_LockRng = $EFFFFFFF;

type

  LockProtocolType = (lpNone, lpDB4Lock, lpClipperLock, lpFoxLock, lpClipperForFoxLob);
  xBaseVersion = (xUnknown, xClipper, xBaseIII, xBaseIV, xBaseV, xBaseVII, xFoxPro, xVisualFoxPro);

  {$A-}

  DBF_HEAD = packed record
    dbf_id:             Byte;                     //0
    last_update:        array[0..2] of Byte;      //1
    last_rec:           Longint;                  //4
    data_offset:        Word;                     //8
    rec_size:           Word;                     //10
    Dummy1:             Word;                     // 12-13
    IncTrans:           byte;                     // 14
    Encrypt:            byte;                     // 15
    Dummy2:             Integer;                  // 16-19
    Dummy3: array[20..27] of Byte;                // 20-27
    TableFlag:          Byte;                     //28
    CodePageMark:       Byte;                 //29
    Dummy4:             Word;                     //30 - 31
  end;

  num_size = packed record
    len: Byte;
    dec: Byte;
  end;

  len_info = packed record
    case Shortint of
      0: (char_len: Word);
      1: (num_len: num_size);
  end;
  plen_info = ^len_info;

  TVKDBFType = (
    dbftS1,             //Shortint              (1 byte)
    dbftS1_N,           //Shortint with NULL    (1 byte ShortInt + 1 byte null/not null)
    dbftU1,             //Byte
    dbftU1_N,           //Byte  with NULL
    dbftS2,             //Smallint
    dbftS2_N,           //Smallint with NULL
    dbftU2,             //Word
    dbftU2_N,           //Word with NULL
    dbftS4,             //Longint
    dbftS4_N,           //Longint with NULL
    dbftU4,             //Longword
    dbftU4_N,           //Longword with NULL
    dbftS8,             //Int64
    dbftS8_N,           //Int64 with NULL
    dbftR4,             //Single
    dbftR4_N,           //Single with NULL
    dbftR6,             //Real48
    dbftR6_N,           //Real48 with NULL
    dbftR8,             //Double
    dbftR8_N,           //Double with NULL
    dbftR10,            //Extended                !!!!!!!Not yet realized
    dbftR10_N,          //Extended with NULL      !!!!!!!Not yet realized
    dbftD1,             //TDateTime
    dbftD1_N,           //TDateTime with NULL
    dbftD2,             //DataSet DateTime
    dbftD2_N,           //DataSet DateTime with NULL
    //
    dbftString,         //String
    dbftString_N,       //String with NULL
    dbftFixedChar,      //FixedChar
    dbftWideString,     //WideString
    dbftCurrency,       //Currency
    dbftCurrency_N,     //Currency with NULL
    //
    dbftClob,           //Clob
    dbftBlob,           //Blob
    dbftGraphic,        //Graphic
    dbftFmtMemo,        //FmtMemo
    //
    dbftBCD,            //BCD (34 bytes VCL BCD structure TBCD)
    //
    dbftDate,            //Date  (Integer, 4 bytes)
    dbftDate_N,          //Date with NULL (Integer, 4 bytes + 1 null/not null byte)
    dbftTime,            //Time (Integer, 4 bytes)
    dbftTime_N,          //Time with NULL (Integer, 4 bytes + 1 null/not null byte)

    dbftD3,             //TDateTime as dbftR6 (6 bytes)
    dbftD3_N,           //TDateTime as dbftR6 (6 bytes) with NULL ( + 1 byte null/not null)

////////////////////////////////////////////////////////////////////////////////
/// This integer and real types with 1 null/not null bit instead of sign bit
////////////////////////////////////////////////////////////////////////////////
    dbftU1_NB,          //Byte              ( 0 - 127         )
    dbftU2_NB,          //Word              ( 0 - 32767       )
    dbftU4_NB,          //Longword          ( 0 - 2147483647  )
    dbftR4_NB,          //Single            ( Positive Single )
    dbftR6_NB,          //Real48            ( Positive Real48 )
    dbftR8_NB,          //Double            ( Positive Double )
    dbftD1_NB,          //TDateTime         ( Positive TDateTime  )  (8 bytes)
    dbftD2_NB,          //DataSet DateTime  ( Positive DataSet DateTime) (8 bytes)
    //
    dbftCurrency_NB,    //Currency
    //
    dbftDate_NB,        //Date
    dbftTime_NB,        //Time

    dbftD3_NB,          //TDateTime as dbftR6 (6 bytes) ( Positive Real48 )

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
///////////       This is Lob types with absolute pointer (dbftU4_NB) to a lob
///////////       file and not align 512 byte pages into the Lob
////////////////////////////////////////////////////////////////////////////////

    dbftClob_NB,           //Clob
    dbftBlob_NB,           //Blob
    dbftGraphic_NB,        //Graphic
    dbftFmtMemo_NB,        //FmtMemo

////////////////////////////////////////////////////////////////////////////////

    dbftUndefined,          //Special type

////////////////////////////////////////////////////////////////////////////////

    dbftDBFDataSet,         //DataSet
    dbftDBFDataSet_NB,      //DataSet with absolute pointer (dbftU4_NB) to a lob
                            //file and not align 512 byte pages into the Lob

////////////////////////////////////////////////////////////////////////////////
///////////       Not yet realized
////////////////////////////////////////////////////////////////////////////////

    dbftBytes,          //Bytes
    dbftVarBytes,       //VarBytes
    dbftTypedBinary,    //TypedBinary

    dbftADT,            //ADT
    dbftArray,          //Array
    dbftReference,      //Reference
    dbftVariant,        //Variant
    dbftInterface,      //Interface
    dbftIDispatch,      //IDispatch
    dbftGuid            //Guid

////////////////////////////////////////////////////////////////////////////////

  );

  FIELD_RECIII = packed record
    field_name:         array[0..10] of AnsiChar;
    field_type:         AnsiChar;                 //11  //C N D L M  F B G   E - Extendes types
    case Byte of
    1: ( Displacement: DWord; );
    2: (
      extend_type:        TVKDBFType;           //12  //use if field_type = 'E'
      dummy:              array[0..2] of Byte;  //13-15
      lendth:             len_info;             //16-17
      FldFlag:            Byte;                 //18
      NativeNextAutoInc:  DWord;                //19-22
      NativeStepAutoInc:  Byte;                 //23
      NextAutoInc:        DWord;                //24-27
      filler:             array [0..3] of Byte; //28-31     = 32
    );
  end;

  FIELD_RECV = packed record
    field_name:         array [0..31] of AnsiChar;
    field_type:         AnsiChar;  // 32
    lendth:             len_info; // 33 34      //C N D L M F B G + I O @    E - Extendes types
    extend_type:        TVKDBFType;   //35      //use if field_type = 'E'
    NativeStepAutoInc:  Byte;  // 36
    FldFlag:            Byte;  // 37
    NextAutoInc:        DWord; // 38-39
    NativeNextAutoInc:  DWord; // 40-43
    Reserved3:          Word;  // 44-47   =  48
  end;

  TVFPTimeStamp = packed record
    Date: Integer;
    Time: Integer;
  end;
  PVFPTimeStamp = ^TVFPTimeStamp;

  FIELD_REC = class
  private
    FFIELD_REC_STRUCT:
      packed record
        fldRecIII: FIELD_RECIII;
        fldRecV: FIELD_RECV;
      end;
    FFIELD_REC_VER: xBaseVersion;
    FFIELD_REC_SIZE: Integer;
    function Get_extend_type: TVKDBFType;
    function Get_field_type: AnsiChar;
    function Get_NextAutoInc: DWord;
    function Get_NativeNextAutoInc: DWord;
    procedure Set_extend_type(const Value: TVKDBFType);
    procedure Set_field_type(const Value: AnsiChar);
    procedure Set_NextAutoInc(const Value: DWord);
    procedure Set_NativeNextAutoInc(const Value: DWord);
    procedure SetFIELD_REC_VER(const Value: xBaseVersion);
    procedure SetFIELD_REC_SIZE(const Value: Integer);
    function Get_field_name: pAnsiChar;
    function Get_plendth: plen_info;
    function GetFeildName: AnsiString;
    procedure SetFeildName(const Value: AnsiString);
    function GetMaxFieldNameSize: Integer;
    function Get_NativeStepAutoInc: Byte;
    procedure Set_NativeStepAutoInc(const Value: Byte);
    function Get_FieldFlag: Byte;
    procedure Set_FieldFlag(const Value: Byte);
    function GetFFIELD_REC_STRUCT: Pointer;
  public
    constructor Create;
    property FIELD_REC_STRUCT: Pointer read GetFFIELD_REC_STRUCT;
    property FIELD_REC_VER: xBaseVersion read FFIELD_REC_VER write SetFIELD_REC_VER;
    property FIELD_REC_SIZE: Integer read FFIELD_REC_SIZE write SetFIELD_REC_SIZE;
    property field_name: pAnsiChar read Get_field_name;
    property FeildName: AnsiString read GetFeildName write SetFeildName;
    property field_type: AnsiChar read Get_field_type write Set_field_type;
    property extend_type: TVKDBFType read Get_extend_type write Set_extend_type;
    property lendth: plen_info read Get_plendth;
    property NextAutoInc: DWord read Get_NextAutoInc write Set_NextAutoInc;
    property NativeNextAutoInc: DWord read Get_NativeNextAutoInc write Set_NativeNextAutoInc;
    property NativeStepAutoInc: Byte read Get_NativeStepAutoInc write Set_NativeStepAutoInc;
    property MaxFieldNameSize: Integer read GetMaxFieldNameSize;
    property FieldFlag: Byte read Get_FieldFlag write Set_FieldFlag;
  end;

  AFTER_DBF_HEAD = record
    Dummy:              array[32..67] of byte;      // = 68
  end;

  TRecInfo = packed record
    RecordRowID: Longint;
    UpdateStatus: TUpdateStatus;
    BookmarkFlag: TBookmarkFlag;
  end;

  LOB_HEAD = packed record
    NextEmtyBlock:      Longint;
    Dummy:              array [0..3] of Byte;
    dbfFileName:        array [0..7] of Byte; //8..15
    bVersion:           Byte; //16
    Dummy2:             array [17..19] of Byte;
    BlockLength:        Word;
    Dummy3:             array [22..511] of Byte;
  end;
  pLOB_HEAD = ^LOB_HEAD;

  LOB_BLOCK_HEADER = packed record
    case Byte of
      0: (
        DBIV_Flag:          SmallInt;
        StartOffsetMemo:    SmallInt;
        LengthMemo:         LongInt;
        );
      1: (
        ID:                 LongInt;
        Length:             LongInt;
        );
      3: (
        NextEmtyBlock:      longint;
        BlocksEmty:         longint;
        );
      4: (
        FoxLobSignature:    longint;
        );
  end;

  VISUALFOXPRO_FOOTER = packed record
    Dummy:              array [0..262] of Byte;
  end;
  {$A+}

  TBufDirection = (bdFromTop, bdFromBottom);

  pTRecInfo = ^TRecInfo;
  ppTRecInfo = ^pTRecInfo;

  pDouble = ^Double;
  pInteger = ^Integer;
  pReal48 = ^Real48;

  TVKSmartDBF = class;
  TVKNestedDBF = class;

  TVKDBFFieldDefs = class;

  TChangeFieldsProc = procedure(dbfObj: TVKSmartDBF; fieldsObj: TVKDBFFieldDefs) of object;
  TMoveRecordProc = procedure(pRecordBuffer: pAnsiChar; dbfObj: TVKSmartDBF) of object;

  TOnDBEval = procedure(Sender: TObject; nRecNo: LongWord; var ExitCode: Integer) of object;

  TVKDBFFieldDef = class;

  {TVKDataLink}
  TVKDataLink = class(TDataLink)
  private
    FDBFDataSet: TVKSmartDBF;
  protected
    procedure DataEvent(Event: TDataEvent; Info: {$IFDEF DELPHIXE2}NativeInt{$ELSE}Integer{$ENDIF}); override;
    procedure DataSetScrolled(Distance: Integer); override;
  public
    property DBFDataSet: TVKSmartDBF read FDBFDataSet write FDBFDataSet;
  end;

  {TVKDBFFieldDefs}
  TVKDBFFieldDefs = class(TOwnedCollection)
  private

    FIsThereAutoInc: boolean;
    FdbfVersion: xBaseVersion;

    FVFPNullsOffset: Integer;
    FVFPNullsLength: Integer;

    {$IFDEF VER130}
    function GetCollectionOwner: TPersistent;
    {$ENDIF}
    function GetItem(Index: Integer): TVKDBFFieldDef;
    procedure SetItem(Index: Integer; const Value: TVKDBFFieldDef);
    procedure SetdbfVersion(const Value: xBaseVersion);

  public

    constructor Create(AOwner: TPersistent);
    procedure AssignValues(Value: TVKDBFFieldDefs);
    function FindIndex(const Value: AnsiString): TVKDBFFieldDef;
    function IsEqual(Value: TVKDBFFieldDefs): Boolean;
    {$IFDEF VER130}
    property Owner: TPersistent read GetCollectionOwner;
    {$ENDIF}
    property Items[Index: Integer]: TVKDBFFieldDef read GetItem write SetItem; default;
    property IsThereAutoInc: boolean read FIsThereAutoInc write FIsThereAutoInc;
    property dBaseVersion: xBaseVersion read FdbfVersion write SetdbfVersion;

    property VFPNullsOffset: Integer read FVFPNullsOffset;
    property VFPNullsLength: Integer read FVFPNullsLength;

  end;

  {TVKDBFFieldDef}
  TVKDBFFieldDef = class(TCollectionItem)
  private

    FMustBeDelete: boolean;

    FFieldFlag: TFieldFlag;

    FTag: Integer;

    FOff: Integer;
    FOffHD: Integer;

    FieldRec: FIELD_REC;

    Fdec: Word;
    Flen: Word;
    FDBFFieldDefs: TVKDBFFieldDefs;
    FVFPNullNumber: Word;
    FVFPNullBitMask: Byte;
    FVFPNullByteNumber: Word;
    function GetField: FIELD_REC;
    function GetDataSize: Word;
    procedure SetDBFFieldDefs(const Value: TVKDBFFieldDefs);

    procedure ReadDBFFieldDefData(Reader: TReader);
    procedure WriteDBFFieldDefData(Writer: TWriter);
    function Get_field_type: AnsiChar;
    procedure Set_field_type(const Value: AnsiChar);
    function Get_extend_type: TVKDBFType;
    procedure Set_extend_type(const Value: TVKDBFType);
    function GetDBaseVersion: xBaseVersion;
    procedure SetDBaseVersion(const Value: xBaseVersion);
    function GetVKDBFFieldDefs: TVKDBFFieldDefs;
    function Get_NativeNextAutoInc: DWord;
    function Get_NativeStepAutoInc: Byte;
    function Get_NextAutoInc: DWord;
    procedure Set_NativeNextAutoInc(const Value: DWord);
    procedure Set_NativeStepAutoInc(const Value: Byte);
    procedure Set_NextAutoInc(const Value: DWord);

  protected

    FFieldDefRef: TFieldDef;

    function GetDisplayName: String; override;
    procedure SetDisplayName(const Value: String); override;
    procedure AssignTo(Dest: TPersistent); override;

  public

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure DefineProperties(Filer: TFiler); override;

    function IsEqual(Value: TVKDBFFieldDef): Boolean; virtual;

    property OwnerVKDBFFieldDefs: TVKDBFFieldDefs read GetVKDBFFieldDefs;

    property dBaseVersion: xBaseVersion read GetDBaseVersion write SetDBaseVersion;
    property Field: FIELD_REC read GetField;
    property DataSize: Word read GetDataSize;

    property FieldDefRef: TFieldDef read FFieldDefRef;

    property VFPNullNumber: Word      read FVFPNullNumber;
    property VFPNullBitMask: Byte   read FVFPNullBitMask;
    property VFPNullByteNumber: Word  read FVFPNullByteNumber;

  published

    property DBFFieldDefs: TVKDBFFieldDefs read FDBFFieldDefs write SetDBFFieldDefs stored false;
    property FieldFlag: TFieldFlag read FFieldFlag write FFieldFlag;
    property Name: String read GetDisplayName write SetDisplayName;
    property field_type: AnsiChar read Get_field_type write Set_field_type;
    property extend_type: TVKDBFType read Get_extend_type write Set_extend_type;
    property len: Word read Flen write Flen;
    property dec: Word read Fdec write Fdec;
    property Offset: Integer read FOff;
    property OffsetHD: Integer read FOffHD;
    property NextAutoInc: DWord read Get_NextAutoInc write Set_NextAutoInc;
    property NativeNextAutoInc: DWord read Get_NativeNextAutoInc write Set_NativeNextAutoInc;
    property NativeStepAutoInc: Byte read Get_NativeStepAutoInc write Set_NativeStepAutoInc;

    property Tag: Integer read FTag write FTag;

  end;

  {TVKDBTStream}
  TVKDBTStream = class(TMemoryStream)
  protected
    FModified: boolean;
    FSmartDBF: TVKSmartDBF;
    FField: TField;
  public
    constructor Create;
    constructor CreateDBTStream(dbf: TVKSmartDBF; field: TField);
    destructor Destroy; override;
    procedure Clear;
    procedure SetSize(NewSize: Longint); override;
    procedure SaveToDBT;
    function Write(const Buffer; Count: Longint): Longint; override;
    {$IFDEF DELPHIXE3}
    function Write(const Buffer: TBytes; Offset, Count: Longint): Longint; override;
    {$ENDIF DELPHIXE3}
    property SmartDBF: TVKSmartDBF read FSmartDBF write FSmartDBF;
    property Field: TField read FField write FField;
  end;

  {TVKSmartDBF}
  TVKSmartDBF = class(TDataSet)
  private

    FDbfVersion: xBaseVersion;
    FLobVersion: xBaseVersion;
    FLobBlockSize: Integer;
    FOpenWithoutIndexes: boolean;
    FSaveOnTheSamePlace: boolean;
    FIndexName: AnsiString;
    FSaveState: TDataSetState;
    FDataLink: TVKDataLink;
    FDBFFieldDefs: TVKDBFFieldDefs;
    FDBFIndexDefs: TVKDBFIndexDefs;
    FIndRecBuf: pAnsiChar;
    FIndState: boolean;
    FLocateBuffer: pAnsiChar;
    FMasterFields: AnsiString;
    FRange: boolean;
    ListMasterFields: TVKListOfFields;
    FTableFlag: TTableFlag;

    FAlwaysSetFieldData: boolean;
    FAddBuffered: boolean;
    FAddBuffer: pAnsiChar;
    FAddBufferCrypt: pAnsiChar;
    FAddBufferCount: Integer;
    FAddBufferCurrent: Integer;
    FLookupOptions: TLocateOptions;
    FStorageType: TProxyStreamType;
    FOuterStream: TStream;
    FCreateNow: boolean;
    FOuterLobStream: TStream;
    FOnOuterStreamLock: TLockEvent;
    FOnOuterStreamUnlock: TUnlockEvent;

    FRLockObject: TCriticalSection;
    FRUnLockObject: TCriticalSection;
    FFLockObject: TCriticalSection;
    FFUnLockObject: TCriticalSection;
    FHeaderLockObject: TCriticalSection;
    FHeaderUnLockObject: TCriticalSection;
    FLobHeaderLockObject: TCriticalSection;
    FLobHeaderUnLockObject: TCriticalSection;

    procedure SetRngInt;
    function GetRecBuf: pAnsiChar;
    function GetRecNoBuf: Longint;
    procedure SetDataSource(const Value: TDataSource);
    function GetCreateNow: Boolean;
    procedure SetCreateNow(const Value: Boolean);
    procedure SetMasterFields(const Value: AnsiString);
    function GetMasterFields: Variant;
    procedure SetDBFFieldDefs(const Value: TVKDBFFieldDefs);
    procedure SetDBFIndexDefs(const Value: TVKDBFIndexDefs);
    procedure SetOnEncrypt(const Value: TOnCrypt);
    function GetOnEncrypt: TOnCrypt;
    procedure SetOnDecrypt(const Value: TOnCrypt);
    function GetOnDecrypt: TOnCrypt;
    function GetOnCryptActivate: TNotifyEvent;
    function GetOnCryptDeActivate: TNotifyEvent;
    procedure SetOnCryptActivate(const Value: TNotifyEvent);
    procedure SetOnCryptDeActivate(const Value: TNotifyEvent);
    function GetInnerStream: TStream;
    function GetInnerLobStream: TStream;
    procedure SetLobBlockSize(const Value: Integer);
    procedure SetDbfVersion(const Value: xBaseVersion);
    procedure SetLockProtocol(const Value: LockProtocolType);
    procedure SetLobLockProtocol(const Value: LockProtocolType);
    procedure HiddenInitFieldDefs(FDs: TFieldDefs; DBFFDs: TVKDBFFieldDefs; BeginOffset, BeginOffsetHD: Integer; NamePrefix: AnsiString = ''; CreateFieldDef: boolean = true);
    procedure ChangeFieldsInternal(
        fields: TVKDBFFieldDefs;
        RecInBuffer: Integer;
        ChangeFieldsProc: TChangeFieldsProc;
        MoveRecordProc: TMoveRecordProc;
        TmpInCurrentPath: boolean = false);
    procedure InternalCopyTableInnerStreams(oDbf: TVKSmartDBF);
    procedure ChangeFieldsCodeForAddFields(newDbf: TVKSmartDBF; fields: TVKDBFFieldDefs);
    procedure MoveRecordForAddFields(pRecordBuffer: pAnsiChar; newDbf: TVKSmartDBF);
    procedure ChangeFieldsCodeForDeleteFields(newDbf: TVKSmartDBF; fields: TVKDBFFieldDefs);
    procedure MoveRecordForDeleteFields(pRecordBuffer: pAnsiChar; newDbf: TVKSmartDBF);

  private
    FStreamedActive: boolean;
    FStreamedCreateNow: boolean;
    FTempRecord: pAnsiChar;
    FFilterRecord: pAnsiChar;
    FSetKeyBuffer: pAnsiChar;
    FTmpCurrentEditBuffer: pAnsiChar;
    FFilterParser: TVKDBFExprParser;
    FDBFFileName: AnsiString;

    DBFHandler: TProxyStream;
    DBFHeader: DBF_HEAD;

    FIsThereLob: boolean;

    LobHandler: TProxyStream;
    LobHeader: LOB_HEAD;

    FPackProcess: boolean;
    FPackLobHandler: TProxyStream;
    PackLobHeader: LOB_HEAD;

    FRecordSize: Integer;
    FAccessMode: TAccessMode;
    FVKDBFCrypt: TVKDBFCrypt;
    FCryptBuff: Pointer;
    FOEM: Boolean;
    FSetDeleted: Boolean;
    FIndexes: TIndexes;
    FTmpActive: boolean;
    FKeyCalk: boolean;
    FWaitBusyRes: Integer;

    FBufferSize: Integer;
    FRecordsPerBuf: Integer;
    FBuffer: pAnsiChar;
    FBufInd: pLongint;
    FBufCnt: Longint;
    FBufDir: TBufDirection;
    FCurInd: Integer;

    FBOF: boolean;
    FEOF: boolean;

    FLockProtocol: LockProtocolType;
    FLobLockProtocol: LockProtocolType;

    FLobHeaderLock: boolean;
    FFileHeaderLock: boolean;
    FFileLock: boolean;
    FLockRecords: TList;

    FLastFastPostRecord: boolean;
    FFastPostRecord: boolean;

    FOnDBEval: TOnDBEval;
    FTrimInLocate: boolean;

    FTrimCType: boolean;

    function GetRecordBufferSize: Integer;
    property RecordBufferSize: Integer read GetRecordBufferSize;
    property RecBuf: pAnsiChar read GetRecBuf;
    property RecNoBuf: Longint read GetRecNoBuf;
    function GetActiveRecBuf(var pRecBuf: PAnsiChar): Boolean;
    function GetDeleted: Boolean;
    procedure SetDeletedFlag(const Value: Boolean);
    function GetRecordByBuffer(Buffer: PAnsiChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
    function AcceptRecord: Boolean;
    procedure SetSetDeleted(const Value: Boolean);

    procedure ReadIndexData(Reader: TReader);
    procedure WriteIndexData(Writer: TWriter);

    procedure SetIndexList(const Value: TIndexes);
    function AcceptRecordInternal: boolean;
    procedure SetRecNoInternal(Value: Integer);
    procedure BindDBFFieldDef;
    procedure InternalSetCurrentIndex(i: Integer);

  protected

    procedure Loaded; override;

    procedure DoAfterOpen; override;
    procedure DoBeforeClose; override;

    procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean); override;
    {$IFDEF DELPHIXE3}
    procedure DataConvert(Field: TField; Source: TValueBuffer; {$IFDEF DELPHIXE4}var{$ENDIF} Dest: TValueBuffer; ToNative: Boolean); override;
    {$ENDIF DELPHIXE3}

    {$IFDEF DELPHI2009}
    function AllocRecordBuffer: TRecordBuffer; override;
    procedure FreeRecordBuffer(var Buffer: TRecordBuffer); override;
    procedure GetBookmarkData(Buffer: TRecordBuffer; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: TRecordBuffer): TBookmarkFlag; override;
    function GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    procedure InternalInitRecord(Buffer: TRecordBuffer); override;
    procedure InternalSetToRecord(Buffer: TRecordBuffer); override;
    procedure SetBookmarkFlag(Buffer: TRecordBuffer; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: TRecordBuffer; Data: Pointer); override;
    {$ELSE}
    function AllocRecordBuffer: PAnsiChar; override;
    procedure FreeRecordBuffer(var Buffer: PAnsiChar); override;
    procedure GetBookmarkData(Buffer: PAnsiChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PAnsiChar): TBookmarkFlag; override;
    function GetRecord(Buffer: PAnsiChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    procedure InternalInitRecord(Buffer: PAnsiChar); override;
    procedure InternalSetToRecord(Buffer: PAnsiChar); override;
    procedure SetBookmarkFlag(Buffer: PAnsiChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PAnsiChar; Data: Pointer); override;
    {$ENDIF}
    function GetRecordSize: Word; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalClose; override;
    procedure DeleteRecallRecord(Del: boolean = true); virtual;
    procedure InternalDelete; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalEdit; override;
    procedure InternalPost; override;

    procedure InternalSetFieldData(Field: TField; Buffer: Pointer);
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    {$IFDEF DELPHIXE3}
    procedure SetFieldData(Field: TField; Buffer: TValueBuffer); override;
    {$ENDIF DELPHIXE3}

    procedure SetActive(Value: Boolean); override;
    procedure InternalRefresh; override;

    function FindRecord(Restart, GoForward: Boolean): Boolean; override;

    procedure SetRange(FieldList: AnsiString; FieldValues: array of const); overload; virtual;
    procedure SetRange(FieldList: AnsiString; FieldValues: variant); overload; virtual;
    procedure SetRange(FieldList: AnsiString; FieldValuesLow: array of const; FieldValuesHigh: array of const); overload; virtual;
    procedure SetRange(FieldList: AnsiString; FieldValuesLow: variant; FieldValuesHigh: variant); overload; virtual;
    procedure ClearRange; virtual;

    procedure NextIndexBuf;
    procedure PriorIndexBuf;

    function NextBuffer: Longint;
    function PriorBuffer: Longint;
    procedure GetBufferByRec(Rec: Longint);
    procedure RefreshBufferByRec(Rec: Longint);
    procedure ReloadRecord(nRec: Integer);

    function GetRecordCount: Integer; override;
    function GetRecNo: Integer; override;
    procedure SetRecNo(Value: Integer); override;

    function GetStateFieldValue(State: TDataSetState; Field: TField): Variant; override;
    function CompareLocateField(const Fields: TVKListOfFields; const KeyValues: Variant; Options: TLocateOptions): Integer;

    procedure SetFiltered(Value: Boolean); override;

    function GetDataSource: TDataSource; override;

    function GetCurIndByRec(nRec: Longint): Integer;

    function LockHeader: boolean;
    function UnlockHeader: boolean;

    function LockLobHeader(LbHandler: TProxyStream): boolean;
    function UnlockLobHeader(LbHandler: TProxyStream): boolean;

    function UnlockAllRecords: boolean;

    procedure LobHandlerCreate; virtual;
    procedure CreateLobStream(dbf_id: Byte; IsThereLob: boolean); virtual;
    procedure OpenLobStream(dbf_id: Byte); virtual;
    procedure CloseLobStream; virtual;
    procedure LobHandlerDestroy; virtual;

    procedure FillLobHeader(dbf_id_p: Byte; LHandler: TProxyStream; var LHeader: LOB_HEAD); virtual;

    procedure PackLobHandlerCreate; virtual;
    procedure PackLobHandlerOpen(TempLobName: AnsiString); virtual;
    procedure PackLobHandlerClose(LobName, TempLobName: AnsiString); virtual;
    procedure PackLobHandlerDestroy; virtual;

    function GetPackLobHandler: TProxyStream; virtual;
    function GetLobHandler: TProxyStream; virtual;

    function SetAutoInc(const FieldNum: Integer; Value: DWORD; Dummy: Integer): boolean; overload;
    function SetStepAutoInc(const FieldNum: Integer; Value: BYTE): boolean;
    function GetCurrentAutoInc(const FieldNum: Integer; Dummy: Integer): DWORD; overload;
    function GetNextAutoInc(const FieldNum: Integer; Dummy: Integer): DWORD; overload;
    function GetStepAutoInc(const FieldNum: Integer): BYTE;

    function IsLockWithIndex: boolean; virtual;

    function GetParentCryptObject: TVKDBFCrypt; virtual;

    function ReccordLockInternal(nRec: Integer; bReload: boolean = true): Boolean;

    function InternalGetFieldData(Field: TField; Buffer: Pointer): Boolean;

  public

    FullLengthCharFieldCopy: boolean;
    Changed: boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property MainLobHandler: TProxyStream read GetLobHandler;
    property PackLobHandler: TProxyStream read GetPackLobHandler;

    function IsCursorOpen: Boolean; override;

    {$IFDEF DELPHIXE3}
    function GetFieldData(Field: TField; {$IFDEF DELPHIXE4}var{$ENDIF} Buffer: TValueBuffer): Boolean; overload; override;
    {$ENDIF DELPHIXE3}
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; override;
    function Translate(Src, Dest: PAnsiChar; ToOem: Boolean): Integer; override;
    function TranslateBuff(Src, Dest: PAnsiChar; ToOem: Boolean; Len: Integer): Integer;

    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
    function BookmarkValid(Bookmark: TBookmark): Boolean; override;

    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    procedure CreateNestedStream(NestedDataSet: TVKSmartDBF; Field: TField; NestedStream: TStream); virtual;
    procedure SaveToDBT(Source: TMemoryStream; Field: TField); overload; virtual;
    procedure SaveOnTheSamePlaceToDBT(Source: TMemoryStream; Field: TField); overload; virtual;

    procedure CreateTable;
    procedure Reindex;
    procedure ReindexWithOutActivated;
    procedure ReindexAll;

    procedure AddFields(fields: TVKDBFFieldDefs; RecInBuffer: Integer; TmpInCurrentPath: boolean = false);
    procedure DeleteFields(fields: TVKDBFFieldDefs; RecInBuffer: Integer; TmpInCurrentPath: boolean = false);

    procedure ReCrypt(pNewCrypt: TVKDBFCrypt);

    procedure DefineProperties(Filer: TFiler); override;

    property LockRecords: TList read FLockRecords;
    property LobHeaderLock: boolean read FLobHeaderLock;
    property FileHeaderLock: boolean read FFileHeaderLock;
    property FileLock: boolean read FFileLock;

    property Deleted: Boolean read GetDeleted write SetDeletedFlag;
    property Header: DBF_HEAD read DBFHeader;
    property Handle: TProxyStream read DBFHandler;
    property IndRecBuf: pAnsiChar read FIndRecBuf write FIndRecBuf;
    property IndState: boolean read FIndState write FIndState;

    function FirstByIndex(IndInd: Integer): TGetResult;
    function PriorByIndex(IndInd: Integer): TGetResult;
    function NextByIndex(IndInd: Integer): TGetResult;
    function LastByIndex(IndInd: Integer): TGetResult;

    procedure AddRecord(const Values: array of const); overload;
    procedure AddRecord(ne: TNotifyEvent); overload;
    procedure AddRecord(const Values: variant); overload;
    procedure BeginAddRecord;
    procedure EndAddRecord;
    procedure SetTmpRecord(nRec: DWORD);
    procedure CloseTmpRecord;

    procedure BeginAddBuffered(RecInBuffer: Integer);
    procedure FlushAddBuffer;
    procedure EndAddBuffered;

    function LocateRecord(  const KeyFields: AnsiString;
                            const KeyValues: Variant;
                            Options: TLocateOptions;
                            nRec: DWORD = 1;
                            FullScanOnly: boolean = false): Integer;
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;

    function GetPrec(aField: TField): Integer;
    function GetLen(aField: TField): Integer;
    function GetDataSize(aField: TField): Integer;

    function RLock: Boolean; overload;
    function RLock(nRec: Integer): Boolean; overload;
    function IsRLock: Boolean; overload;
    function IsRLock(nRec: Integer): Boolean; overload;

    function RUnLock: Boolean; overload;
    function RUnLock(nRec: Integer): Boolean; overload;

    function FLock: Boolean;
    function UnLock: Boolean;

    procedure SetOrder(nOrd: Integer); overload;
    procedure SetOrder(sOrd: AnsiString); overload;
    procedure SetOrderName(sOrd: AnsiString); overload;
    function GetOrder: AnsiString;

    property Last_Rec: Longint read DBFHeader.last_rec;

    function SetAutoInc(const FieldName: AnsiString; Value: DWORD): boolean; overload;
    function SetAutoInc(const FieldNum: Integer; Value: DWORD): boolean; overload;

    function GetCurrentAutoInc(const FieldName: AnsiString): DWORD; overload;
    function GetCurrentAutoInc(const FieldNum: Integer): DWORD; overload;

    function GetNextAutoInc(const FieldName: AnsiString): DWORD; overload;
    function GetNextAutoInc(const FieldNum: Integer): DWORD; overload;

    function SetNativeAutoInc(const FieldName: AnsiString; Value: DWORD): boolean; overload;
    function SetNativeAutoInc(const FieldNum: Integer; Value: DWORD): boolean; overload;

    function GetCurrentNativeAutoInc(const FieldName: AnsiString): DWORD; overload;
    function GetCurrentNativeAutoInc(const FieldNum: Integer): DWORD; overload;

    function GetNextNativeAutoInc(const FieldName: AnsiString): DWORD; overload;
    function GetNextNativeAutoInc(const FieldNum: Integer): DWORD; overload;

    function SetNativeStepAutoInc(const FieldName: AnsiString; Value: BYTE): boolean; overload;
    function SetNativeStepAutoInc(const FieldNum: Integer; Value: BYTE): boolean; overload;

    function GetNativeStepAutoInc(const FieldName: AnsiString): BYTE; overload;
    function GetNativeStepAutoInc(const FieldNum: Integer): BYTE; overload;

    procedure Truncate;
    procedure Zap;

    procedure DeleteRecord;
    procedure RecallRecord;

    procedure Pack(TmpInCurrentPath: boolean = false);

    procedure DBEval;

    function AcceptTmpRecord(nRec: DWORD): boolean;

    procedure SetKey;
    procedure EditKey;
    function GotoKey: boolean;
    procedure GotoNearest;
    procedure DropEditKey;
    function FindKey(const KeyValues: array of const): Boolean;
    function FindNearest(const KeyValues: array of const): Boolean;

    property OuterStream: TStream read FOuterStream write FOuterStream;
    property InnerStream: TStream read GetInnerStream;
    property OuterLobStream: TStream read FOuterLobStream write FOuterLobStream;
    property InnerLobStream: TStream read GetInnerLobStream;

    property Indexes: TIndexes read FIndexes write SetIndexList stored false;
    property IndexName: AnsiString read GetOrder write SetOrderName;

    property StorageType: TProxyStreamType read FStorageType write FStorageType;
    property DBFFieldDefs: TVKDBFFieldDefs read FDBFFieldDefs write SetDBFFieldDefs stored false;
    property DBFIndexDefs: TVKDBFIndexDefs read FDBFIndexDefs write SetDBFIndexDefs stored false;
    property DBFFileName: AnsiString read FDBFFileName write FDBFFileName;
    property AccessMode: TAccessMode read FAccessMode write FAccessMode;
    property Crypt: TVKDBFCrypt read FVKDBFCrypt write FVKDBFCrypt;
    property BufferSize: Integer read FBufferSize write FBufferSize;
    property WaitBusyRes: Integer read FWaitBusyRes write FWaitBusyRes;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property CreateNow: Boolean read GetCreateNow write SetCreateNow;
    property MasterFields: AnsiString read FMasterFields write SetMasterFields;
    property DbfVersion: xBaseVersion read FDbfVersion write SetDbfVersion;
    property LobVersion: xBaseVersion read FLobVersion write FLobVersion;
    property LobBlockSize: Integer read FLobBlockSize write SetLobBlockSize;
    property LockProtocol: LockProtocolType read FLockProtocol write SetLockProtocol;
    property LobLockProtocol: LockProtocolType read FLobLockProtocol write SetLobLockProtocol;
    property FoxTableFlag: TTableFlag read FTableFlag write FTableFlag;

  published

    property Active;
    property OEM: Boolean read FOEM write FOEM default false;
    property SetDeleted: Boolean read FSetDeleted write SetSetDeleted;
    property FastPostRecord: Boolean read FFastPostRecord write FFastPostRecord;
    property LookupOptions: TLocateOptions read FLookupOptions write FLookupOptions;

    property Filter;
    property Filtered;
    property FilterOptions;

    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;

    property OnEncrypt: TOnCrypt read GetOnEncrypt write SetOnEncrypt;
    property OnDecrypt: TOnCrypt read GetOnDecrypt write SetOnDecrypt;
    property OnCryptActivate: TNotifyEvent  read GetOnCryptActivate
                                            write SetOnCryptActivate;
    property OnCryptDeActivate: TNotifyEvent  read GetOnCryptDeActivate
                                            write SetOnCryptDeActivate;

    property OnDBEval: TOnDBEval read FOnDBEval write FOnDBEval;

    property OnOuterStreamLock: TLockEvent read FOnOuterStreamLock write FOnOuterStreamLock;
    property OnOuterStreamUnlock: TUnlockEvent read FOnOuterStreamUnlock write FOnOuterStreamUnlock;

    property TrimInLocate: boolean read FTrimInLocate write FTrimInLocate;
    property TrimCType: boolean read FTrimCType write FTrimCType;

  end;

  {TVKNestedDBF}
  TVKNestedDBF = class(TVKSmartDBF)
  private
    function GetParentDataSet: TVKSmartDBF;
  protected

    procedure LobHandlerCreate; override;
    procedure CreateLobStream(dbf_id: Byte; IsThereLob: boolean); override;
    procedure OpenLobStream(dbf_id: Byte); override;
    procedure CloseLobStream; override;
    procedure LobHandlerDestroy; override;

    procedure PackLobHandlerCreate; override;
    procedure PackLobHandlerOpen(TempLobName: AnsiString); override;
    procedure PackLobHandlerClose(LobName, TempLobName: AnsiString); override;
    procedure PackLobHandlerDestroy; override;

    function GetPackLobHandler: TProxyStream; override;

    procedure SetDataSetField(const Value: TDataSetField); override;

    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalClose; override;
    procedure DeleteRecallRecord(Del: boolean = true); override;
    procedure DataEvent(Event: TDataEvent; Info: {$IFDEF DELPHIXE2}NativeInt{$ELSE}Integer{$ENDIF}); override;

    function GetParentCryptObject: TVKDBFCrypt; override;

    procedure SaveToDBT; overload;
    procedure SaveOnTheSamePlaceToDBT; overload;

  public

    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property ParentDataSet: TVKSmartDBF read GetParentDataSet;

  published

    property DataSetField;

    property DBFFieldDefs;
    property BufferSize;

  end;

  {TDBFNTX}
  TVKDBFNTX = class(TVKSmartDBF)
  private

    procedure ReadDBFFieldDefData(Reader: TReader);
    procedure WriteDBFFieldDefData(Writer: TWriter);
    procedure ReadDBFIndexDefData(Reader: TReader);
    procedure WriteDBFIndexDefData(Writer: TWriter);
    function GetOrdersByNum(Index: Integer): TVKNTXIndex;
    function GetOrdersByName(const Index: AnsiString): TVKNTXIndex;
    function GetSuitableIndex(FieldList: AnsiString): Integer;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DefineProperties(Filer: TFiler); override;

    procedure SetRange(FieldList: AnsiString; FieldValues: array of const); overload; override;
    procedure SetRange(FieldList: AnsiString; FieldValues: variant); overload; override;
    procedure SetRange(FieldList: AnsiString; FieldValuesLow: array of const; FieldValuesHigh: array of const); overload; override;
    procedure SetRange(FieldList: AnsiString; FieldValuesLow: variant; FieldValuesHigh: variant); overload; override;
    procedure ClearRange; override;

    property Orders[Index: Integer]: TVKNTXIndex read GetOrdersByNum;
    property OrdersByName[const Index: AnsiString]: TVKNTXIndex read GetOrdersByName;

  published

    property StorageType;
    property DBFFieldDefs;
    property DBFIndexDefs;
    property Indexes;
    property IndexName;
    property DBFFileName;
    property AccessMode;
    property Crypt;
    property BufferSize;
    property WaitBusyRes;
    property DataSource;
    property CreateNow;
    property MasterFields;
    property DbfVersion;
    property LobBlockSize;
    property LockProtocol;
    property LobLockProtocol;
    property FoxTableFlag;

  end;

  {TDBFCDX}
  TVKDBFCDX = class(TVKSmartDBF)
  private

    procedure ReadDBFFieldDefData(Reader: TReader);
    procedure WriteDBFFieldDefData(Writer: TWriter);
    procedure ReadDBFIndexDefData(Reader: TReader);
    procedure WriteDBFIndexDefData(Writer: TWriter);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DefineProperties(Filer: TFiler); override;

  published

    property StorageType;
    property DBFFieldDefs;
    property DBFIndexDefs;
    property Indexes;
    property IndexName;
    property DBFFileName;
    property AccessMode;
    property Crypt;
    property BufferSize;
    property WaitBusyRes;
    property DataSource;
    property CreateNow;
    property MasterFields;
    property DbfVersion;
    property LobBlockSize;
    property LockProtocol;
    property LobLockProtocol;
    property FoxTableFlag;

  end;

procedure Wait(t: double; l: boolean = true);
function Space(iSize: Integer): AnsiString;
function Zerro(iSize: Integer): AnsiString;
function DoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
function IsBlank(Buff: pAnsiChar; BufLen: Integer): boolean;
function ExtType2Str(t: TVKDBFType): AnsiString;
function Str2ExtType(s: AnsiString): TVKDBFType;
function SwapInt(const Value): Integer;
function SwapInt64( const Value ) : Int64;

implementation

uses
  AnsiStrings, Dialogs, DBcommon;

//******************************************************************************
function SwapInt( const Value ): Integer;
var i : Integer;
begin
  PByteArray(@i)[0] := PByteArray(@Value)[3];
  PByteArray(@i)[1] := PByteArray(@Value)[2];
  PByteArray(@i)[2] := PByteArray(@Value)[1];
  PByteArray(@i)[3] := PByteArray(@Value)[0];
  result := i;
end;

//******************************************************************************
function SwapInt64( const Value ) : Int64;
var i : Int64;
begin
  PByteArray(@i)[0] := PByteArray(@Value)[7];
  PByteArray(@i)[1] := PByteArray(@Value)[6];
  PByteArray(@i)[2] := PByteArray(@Value)[5];
  PByteArray(@i)[3] := PByteArray(@Value)[4];
  PByteArray(@i)[4] := PByteArray(@Value)[3];
  PByteArray(@i)[5] := PByteArray(@Value)[2];
  PByteArray(@i)[6] := PByteArray(@Value)[1];
  PByteArray(@i)[7] := PByteArray(@Value)[0];
  result := i;
end;

//******************************************************************************
procedure Wait(t: double; l: boolean = true);
var
  t1: TDateTime;
begin
  t1 := Now;
  while (Now - t1) < (0.0000115741 * t) do     //0.0000115741 - This is 1 sec
    if l then Application.ProcessMessages;
end;

//******************************************************************************
function Space(iSize: Integer): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to iSize do
    Result := Result + ' ';
end;

//******************************************************************************
function Zerro(iSize: Integer): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to iSize do
    Result := Result + #0;
end;

//******************************************************************************
function DoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
var
  I: Integer;
  DayTable: PDayTable;
begin
  Result := False;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;

//******************************************************************************
function IsBlank(Buff: pAnsiChar; BufLen: Integer): boolean;
var
  i, j: Integer;
begin
  Result := true;
  j := BufLen - 1;
  for i := 0 to j do
  begin
    if Buff[i] <> #32 then
    begin
      Result := false;
      break;
    end;
  end;
end;

function ExtType2Str(t: TVKDBFType): AnsiString;
begin
  case t of
    DBFTS1            : Result :=    'DBFTS1           ';
    DBFTU1            : Result :=    'DBFTU1           ';
    DBFTS2            : Result :=    'DBFTS2           ';
    DBFTU2            : Result :=    'DBFTU2           ';
    DBFTS4            : Result :=    'DBFTS4           ';
    DBFTU4            : Result :=    'DBFTU4           ';
    DBFTS8            : Result :=    'DBFTS8           ';
    DBFTR4            : Result :=    'DBFTR4           ';
    DBFTR6            : Result :=    'DBFTR6           ';
    DBFTR8            : Result :=    'DBFTR8           ';
    DBFTR10           : Result :=    'DBFTR10          ';
    DBFTD1            : Result :=    'DBFTD1           ';
    DBFTD2            : Result :=    'DBFTD2           ';
    DBFTS1_N          : Result :=    'DBFTS1_N         ';
    DBFTU1_N          : Result :=    'DBFTU1_N         ';
    DBFTS2_N          : Result :=    'DBFTS2_N         ';
    DBFTU2_N          : Result :=    'DBFTU2_N         ';
    DBFTS4_N          : Result :=    'DBFTS4_N         ';
    DBFTU4_N          : Result :=    'DBFTU4_N         ';
    DBFTS8_N          : Result :=    'DBFTS8_N         ';
    DBFTR4_N          : Result :=    'DBFTR4_N         ';
    DBFTR6_N          : Result :=    'DBFTR6_N         ';
    DBFTR8_N          : Result :=    'DBFTR8_N         ';
    DBFTR10_N         : Result :=    'DBFTR10_N        ';
    DBFTD1_N          : Result :=    'DBFTD1_N         ';
    DBFTD2_N          : Result :=    'DBFTD2_N         ';
    DBFTCLOB          : Result :=    'DBFTCLOB         ';
    DBFTBLOB          : Result :=    'DBFTBLOB         ';
    DBFTGRAPHIC       : Result :=    'DBFTGRAPHIC      ';
    DBFTFMTMEMO       : Result :=    'DBFTFMTMEMO      ';
    DBFTSTRING        : Result :=    'DBFTSTRING       ';
    DBFTSTRING_N      : Result :=    'DBFTSTRING_N     ';
    DBFTFIXEDCHAR     : Result :=    'DBFTFIXEDCHAR    ';
    DBFTWIDESTRING    : Result :=    'DBFTWIDESTRING   ';
    DBFTCURRENCY      : Result :=    'DBFTCURRENCY     ';
    DBFTCURRENCY_N    : Result :=    'DBFTCURRENCY_N   ';
    DBFTCURRENCY_NB   : Result :=    'DBFTCURRENCY_NB  ';
    DBFTBCD           : Result :=    'DBFTBCD          ';
    DBFTDATE          : Result :=    'DBFTDATE         ';
    DBFTDATE_N        : Result :=    'DBFTDATE_N       ';
    DBFTTIME          : Result :=    'DBFTTIME         ';
    DBFTTIME_N        : Result :=    'DBFTTIME_N       ';
    DBFTD3            : Result :=    'DBFTD3           ';
    DBFTD3_N          : Result :=    'DBFTD3_N         ';
    DBFTU1_NB         : Result :=    'DBFTU1_NB        ';
    DBFTU2_NB         : Result :=    'DBFTU2_NB        ';
    DBFTU4_NB         : Result :=    'DBFTU4_NB        ';
    DBFTR4_NB         : Result :=    'DBFTR4_NB        ';
    DBFTR6_NB         : Result :=    'DBFTR6_NB        ';
    DBFTR8_NB         : Result :=    'DBFTR8_NB        ';
    DBFTD1_NB         : Result :=    'DBFTD1_NB        ';
    DBFTD2_NB         : Result :=    'DBFTD2_NB        ';
    DBFTD3_NB         : Result :=    'DBFTD3_NB        ';
    DBFTDATE_NB       : Result :=    'DBFTDATE_NB      ';
    DBFTTIME_NB       : Result :=    'DBFTTIME_NB      ';
    DBFTCLOB_NB       : Result :=    'DBFTCLOB_NB      ';
    DBFTBLOB_NB       : Result :=    'DBFTBLOB_NB      ';
    DBFTGRAPHIC_NB    : Result :=    'DBFTGRAPHIC_NB   ';
    DBFTFMTMEMO_NB    : Result :=    'DBFTFMTMEMO_NB   ';
    DBFTDBFDATASET    : Result :=    'DBFTDBFDATASET   ';
    DBFTDBFDATASET_NB : Result :=    'DBFTDBFDATASET_NB';
  else
    Result := '';
  end;
  Result := AnsiStrings.Trim(Result);
end;

function Str2ExtType(s: AnsiString): TVKDBFType;
var
  q: AnsiString;
begin
  Result := dbftUndefined;
  q := Uppercase(Trim(s));
  if q = 'DBFTS1'    then Result :=              DBFTS1;
  if q = 'DBFTU1'    then Result :=              DBFTU1;
  if q = 'DBFTS2'    then Result :=              DBFTS2;
  if q = 'DBFTU2'    then Result :=              DBFTU2;
  if q = 'DBFTS4'    then Result :=              DBFTS4;
  if q = 'DBFTU4'    then Result :=              DBFTU4;
  if q = 'DBFTS8'    then Result :=              DBFTS8;
  if q = 'DBFTR4'    then Result :=              DBFTR4;
  if q = 'DBFTR6'    then Result :=              DBFTR6;
  if q = 'DBFTR8'    then Result :=              DBFTR8;
  if q = 'DBFTR10'   then Result :=              DBFTR10;
  if q = 'DBFTD1'    then Result :=              DBFTD1;
  if q = 'DBFTD2'    then Result :=              DBFTD2;
  if q = 'DBFTS1_N'  then Result :=              DBFTS1_N;
  if q = 'DBFTU1_N'  then Result :=              DBFTU1_N;
  if q = 'DBFTS2_N'  then Result :=              DBFTS2_N;
  if q = 'DBFTU2_N'  then Result :=              DBFTU2_N;
  if q = 'DBFTS4_N'  then Result :=              DBFTS4_N;
  if q = 'DBFTU4_N'  then Result :=              DBFTU4_N;
  if q = 'DBFTS8_N'  then Result :=              DBFTS8_N;
  if q = 'DBFTR4_N'  then Result :=              DBFTR4_N;
  if q = 'DBFTR6_N'  then Result :=              DBFTR6_N;
  if q = 'DBFTR8_N'  then Result :=              DBFTR8_N;
  if q = 'DBFTR10_N' then Result :=              DBFTR10_N;
  if q = 'DBFTD1_N'  then Result :=              DBFTD1_N;
  if q = 'DBFTD2_N'  then Result :=              DBFTD2_N;
  if q = 'DBFTCLOB'     then Result :=           DBFTCLOB;
  if q = 'DBFTBLOB'     then Result :=           DBFTBLOB;
  if q = 'DBFTGRAPHIC'  then Result :=           DBFTGRAPHIC;
  if q = 'DBFTFMTMEMO'  then Result :=           DBFTFMTMEMO;
  if q = 'DBFTSTRING'  then Result :=            DBFTSTRING;
  if q = 'DBFTSTRING_N'  then Result :=          DBFTSTRING_N;
  if q = 'DBFTFIXEDCHAR' then Result :=          DBFTFIXEDCHAR;
  if q = 'DBFTWIDESTRING' then Result :=         DBFTWIDESTRING;
  if q = 'DBFTCURRENCY' then Result :=           DBFTCURRENCY;
  if q = 'DBFTCURRENCY_N' then Result :=         DBFTCURRENCY_N;
  if q = 'DBFTCURRENCY_NB' then Result :=        DBFTCURRENCY_NB;
  if q = 'DBFTBCD' then Result :=                DBFTBCD;
  if q = 'DBFTDATE' then Result :=               DBFTDATE;
  if q = 'DBFTDATE_N' then Result :=             DBFTDATE_N;
  if q = 'DBFTTIME' then Result :=               DBFTTIME;
  if q = 'DBFTTIME_N' then Result :=             DBFTTIME_N;
  if q = 'DBFTD3' then Result :=                 DBFTD3;
  if q = 'DBFTD3_N' then Result :=               DBFTD3_N;
  if q = 'DBFTU1_NB' then Result :=              DBFTU1_NB;
  if q = 'DBFTU2_NB' then Result :=              DBFTU2_NB;
  if q = 'DBFTU4_NB' then Result :=              DBFTU4_NB;
  if q = 'DBFTR4_NB' then Result :=              DBFTR4_NB;
  if q = 'DBFTR6_NB' then Result :=              DBFTR6_NB;
  if q = 'DBFTR8_NB' then Result :=              DBFTR8_NB;
  if q = 'DBFTD1_NB' then Result :=              DBFTD1_NB;
  if q = 'DBFTD2_NB' then Result :=              DBFTD2_NB;
  if q = 'DBFTD3_NB' then Result :=              DBFTD3_NB;
  if q = 'DBFTDATE_NB' then Result :=            DBFTDATE_NB;
  if q = 'DBFTTIME_NB' then Result :=            DBFTTIME_NB;
  if q = 'DBFTCLOB_NB' then Result :=            DBFTCLOB_NB;
  if q = 'DBFTBLOB_NB' then Result :=            DBFTBLOB_NB;
  if q = 'DBFTGRAPHIC_NB' then Result :=         DBFTGRAPHIC_NB;
  if q = 'DBFTFMTMEMO_NB' then Result :=         DBFTFMTMEMO_NB;
  if q = 'DBFTDBFDATASET' then Result :=         DBFTDBFDATASET;
  if q = 'DBFTDBFDATASET_NB' then Result :=      DBFTDBFDATASET_NB;
end;

{ TVKSmartDBF }

function TVKSmartDBF.AcceptRecord: Boolean;
begin
  Result := true;
  if Assigned(OnFilterRecord) then
    OnFilterRecord(self, Result);
  if Filter <> '' then
    Result := Result and FFilterParser.Execute;
  if FSetDeleted then
    Result := Result and ( not Deleted );
end;

{$IFDEF DELPHI2009}
function TVKSmartDBF.AllocRecordBuffer: TRecordBuffer;
{$ELSE}
function TVKSmartDBF.AllocRecordBuffer: PAnsiChar;
{$ENDIF}
begin
  Result := VKDBFMemMgr.oMem.GetMem(self, RecordBufferSize);
end;

function TVKSmartDBF.CompareLocateField(const Fields: TVKListOfFields;
  const KeyValues: Variant; Options: TLocateOptions): Integer;
var
  FieldCount: Integer;
  Field: TField;
  KeyVal: Variant;
  v1, v2: AnsiString;
  i1, i2: Integer;
  l1, l2, l3: Int64;
  w1, w2: Word;
  b1, b2: boolean;
  f1, f2: double;
  i: Integer;
  Code: Integer;
  kk: Int64;
  {$IFNDEF DELPHI6}
  Vr: Variant;
	{$ENDIF}
begin
  Result := 1;
  FieldCount := Fields.Count;
  if FieldCount = 1 then
  begin
    try
      Field := TField(Fields.First);
    except
      Field := nil;
    end;
    try
      if VarIsArray(KeyValues) then
         KeyVal := KeyValues[0]
      else
         KeyVal := KeyValues;
    except
      KeyVal := NULL;
    end;
    case Field.DataType of
      ftFixedChar, ftWideString, ftString, ftMemo:
      begin
        KeyVal := VarAsType(KeyVal, varString);
        if FTrimInLocate then
          v1 := Trim(Field.AsString)
        else
          v1 := Field.AsString;
        if not VarIsNull(KeyVal) then v2 := KeyVal else v2 := '';
        if FTrimInLocate then
          v2:= Trim(v2);
        if loPartialKey in Options then begin
          if ( loCaseInsensitive in Options ) then begin
            v1 := AnsiUpperCase(v1);
            v2 := AnsiUpperCase(v2);
          end;
          Result := Pos(v2, v1);
          if Result <> 1 then
            Result := AnsiCompareStr(v1, v2)
          else
            Result := 0;
        end else
          if loCaseInsensitive in Options then
            Result := AnsiCompareText(v1, v2)
          else
            Result := AnsiCompareStr(v1, v2);
      end;
      ftSmallint, ftInteger, ftAutoInc:
      begin
        KeyVal := VarAsType(KeyVal, varInteger);
        i1 := Field.AsInteger;
        if not VarIsNull(KeyVal) then i2 := KeyVal else i2 := 0;
        Result := i1 - i2;
      end;
      ftLargeint:
      begin
        //
        {$IFDEF DELPHI6}
				if (VarType(KeyVal) <> varInt64) then begin
        {$ELSE}
        if TVarData(KeyVal).VType <> VT_DECIMAL then begin
				{$ENDIF}
          Val(KeyVal, kk, code);
          if code <> 0 then
            KeyVal := Null
          else begin
						{$IFDEF DELPHI6}
						KeyVal := kk;
            {$ELSE}
            TVarData(Vr).VType := VT_DECIMAL;
            Decimal(Vr).lo64 := kk;
            KeyVal := Vr;
						{$ENDIF}
          end;
        end;
        //
        l1 := TLargeintField(Field).AsLargeInt;
        if not VarIsNull(KeyVal) then
  				{$IFDEF DELPHI6}
					l2 := KeyVal
          {$ELSE}
          l2 := Decimal(KeyVal).lo64
					{$ENDIF}
        else
          l2 := 0;
        l3 := l1 - l2;
        if l3 < 0 then
          Result := -1
        else if l3 = 0 then
          Result := 0
        else if l3 > 0 then
          Result := 1;
      end;
      ftWord:
      begin
        KeyVal := VarAsType(KeyVal, varInteger);
        w1 := Field.AsInteger;
        if not VarIsNull(KeyVal) then w2 := KeyVal else w2 := 0;
        Result := w1 - w2;
      end;
      ftBoolean:
      begin
        KeyVal := VarAsType(KeyVal, varBoolean);
        b1 := Field.AsBoolean;
        if not VarIsNull(KeyVal) then b2 := KeyVal else b2 := false;
        if (not b1) and b2 then
          Result := -1;
        if b1 = b2 then
          Result := 0;
        if b1 and (not b2) then
          Result := 1;
      end;
      ftFloat, ftCurrency, ftBCD:
      begin
        Result := VarAsType(Result, varDouble);
        f1 := Field.AsFloat;
        if not VarIsNull(KeyVal) then f2 := KeyVal else f2 := 0;
        if f1 < f2 then
          Result := -1;
        if f1 = f2 then
          Result := 0;
        if f1 > f2 then
          Result := 1;
      end;
      ftDate, ftTime, ftDateTime:
      begin
        Result := VarAsType(Result, varDate);
        f1 := Field.AsDateTime;
        if not VarIsNull(KeyVal) then f2 := KeyVal else f2 := 0;
        if f1 < f2 then
          Result := -1;
        if f1 = f2 then
          Result := 0;
        if f1 > f2 then
          Result := 1;
      end;
    end;
  end else begin
    for i := 0 to FieldCount - 1 do
    begin
      //
      try
        Field := TField(Fields.Items[i]);
      except
        Field := nil;
      end;
      try
        if VarIsArray(KeyValues) then
           KeyVal := KeyValues[i]
        else
           KeyVal := NULL;
      except
        KeyVal := NULL;
      end;
      case Field.DataType of
        ftFixedChar, ftWideString, ftString:
        begin
          KeyVal := VarAsType(KeyVal, varString);
          if FTrimInLocate then
            v1 := Trim(Field.AsString)
          else
            v1 := Field.AsString;
          if not VarIsNull(KeyVal) then v2 := KeyVal else v2 := '';
          if FTrimInLocate then
            v2:= Trim(v2);
          if loPartialKey in Options then begin
            if ( loCaseInsensitive in Options ) then begin
              v1 := AnsiUpperCase(v1);
              v2 := AnsiUpperCase(v2);
            end;
            Result := Pos(v2, v1);
            if Result <> 1 then
              Result := AnsiCompareStr(v1, v2)
            else
              Result := 0;
          end else
            if loCaseInsensitive in Options then
              Result := AnsiStrings.AnsiCompareText(v1, v2)
            else
              Result := AnsiStrings.AnsiCompareStr(v1, v2);
        end;
        ftSmallint, ftInteger:
        begin
          KeyVal := VarAsType(KeyVal, varInteger);
          i1 := Field.AsInteger;
          if not VarIsNull(KeyVal) then i2 := KeyVal else i2 := 0;
          Result := i1 - i2;
        end;
        ftLargeint:
        begin
          //
          {$IFDEF DELPHI6}
          if (VarType(KeyVal) <> varInt64) then begin
          {$ELSE}
          if TVarData(KeyVal).VType <> VT_DECIMAL then begin
				  {$ENDIF}
            Val(KeyVal, kk, code);
            if code <> 0 then
              KeyVal := Null
            else begin
              {$IFDEF DELPHI6}
							KeyVal := kk;
              {$ELSE}
              TVarData(Vr).VType := VT_DECIMAL;
              Decimal(Vr).lo64 := kk;
              KeyVal := Vr;
				      {$ENDIF}
            end;
          end;
          //
          l1 := TLargeintField(Field).AsLargeInt;
          if not VarIsNull(KeyVal) then
            {$IFDEF DELPHI6}
						l2 := KeyVal
            {$ELSE}
            l2 := Decimal(KeyVal).lo64
				    {$ENDIF}
          else
            l2 := 0;
          l3 := l1 - l2;
          if l3 < 0 then
            Result := -1
          else if l3 = 0 then
            Result := 0
          else if l3 > 0 then
            Result := 1;
        end;
        ftWord:
        begin
          KeyVal := VarAsType(KeyVal, varInteger);
          w1 := Field.AsInteger;
          if not VarIsNull(KeyVal) then w2 := KeyVal else w2 := 0;
          Result := w1 - w2;
        end;
        ftBoolean:
        begin
          KeyVal := VarAsType(KeyVal, varBoolean);
          b1 := Field.AsBoolean;
          if not VarIsNull(KeyVal) then b2 := KeyVal else b2 := false;
          if (not b1) and b2 then
            Result := -1;
          if b1 = b2 then
            Result := 0;
          if b1 and (not b2) then
            Result := 1;
        end;
        ftFloat, ftCurrency, ftBCD:
        begin
          KeyVal := VarAsType(KeyVal, varDouble);
          f1 := Field.AsFloat;
          if not VarIsNull(KeyVal) then f2 := KeyVal else f2 := 0;
          if f1 < f2 then
            Result := -1;
          if f1 = f2 then
            Result := 0;
          if f1 > f2 then
            Result := 1;
        end;
        ftDate, ftTime, ftDateTime:
        begin
          KeyVal := VarAsType(KeyVal, varDate);
          f1 := Field.AsDateTime;
          if not VarIsNull(KeyVal) then f2 := KeyVal else f2 := 0;
          if f1 < f2 then
            Result := -1;
          if f1 = f2 then
            Result := 0;
          if f1 > f2 then
            Result := 1;
        end;
      end;
      //
      if Result <> 0 then
        Exit;
    end;
  end;
end;

constructor TVKSmartDBF.Create(AOwner: TComponent);
var
  FieldMap: TFieldMap;
begin
  inherited Create(AOwner);
  FRLockObject := TCriticalSection.Create;
  FRUnLockObject := TCriticalSection.Create;
  FFLockObject := TCriticalSection.Create;
  FFUnLockObject := TCriticalSection.Create;
  FHeaderLockObject := TCriticalSection.Create;
  FHeaderUnLockObject := TCriticalSection.Create;
  FLobHeaderLockObject := TCriticalSection.Create;
  FLobHeaderUnLockObject := TCriticalSection.Create;
  FLockProtocol := lpNone;
  FLobLockProtocol := lpNone;
  FTableFlag := TTableFlag.Create;
  FAlwaysSetFieldData := False;
  FTmpCurrentEditBuffer := nil;
  FLobBlockSize := 512;
  FDbfVersion := xBaseIII;
  FLobVersion := xBaseIII;
  DBFHandler := TProxyStream.Create;
  LobHandlerCreate;
  FStorageType := pstFile;
  FFilterParser := TVKDBFExprParser.Create(self, '', [], [poExtSyntax], '', nil, FieldMap);
  FAccessMode := TAccessMode.Create;
  FVKDBFCrypt := TVKDBFCrypt.Create;
  FVKDBFCrypt.SmartDBF := self;
  FLockRecords := TList.Create;
  FDBFFieldDefs := TVKDBFFieldDefs.Create(self);
  FOEM := false;
  FDBFFileName := '';
  FTmpActive := false;
  FKeyCalk := false;
  FBufferSize := 4096;
  FRecordsPerBuf := 0;
  FBuffer := nil;
  FBufInd := nil;
  FBufCnt := 0;
  FCurInd := -1;
  FBufDir := bdFromTop;;
  FBOF := false;
  FEOF := false;
  FWaitBusyRes := 3000;  //3 sec. waiting for a locking resource

  FDataLink := TVKDataLink.Create;
  FDataLink.DBFDataSet := self;

  FLobHeaderLock := False;
  FFileHeaderLock := False;
  FFileLock := false;

  FIndRecBuf := nil;
  FIndState := false;

  FMasterFields := '';
  FRange := false;
  ListMasterFields := TVKListOfFields.Create;

  FFastPostRecord := false;

  FAddBuffered := false;
  FAddBuffer := nil;
  FAddBufferCrypt := nil;
  FAddBufferCount := -1;
  FAddBufferCurrent := -1;

  FLookupOptions := [];

  FPackProcess := false;
  FPackLobHandler := nil;

  FullLengthCharFieldCopy := false;

  FOnOuterStreamLock := nil;
  FOnOuterStreamUnlock := nil;

  ObjectView := true;

  Changed := False;

  NestedDataSetClass := TVKNestedDBF;

  FSaveOnTheSamePlace := False;

  FOpenWithoutIndexes := False;

  FTrimInLocate := False;

  FTrimCType := False;

end;

procedure TVKSmartDBF.CreateTable;
var
  cHeader: DBF_HEAD;
  caHeader: AFTER_DBF_HEAD;
  VFP_F: VISUALFOXPRO_FOOTER;
  i, j, k: Integer;
  Year, Month, Day: Word;
  qq: byte;
  oBag: TVKDBFIndexBag;
  oOrd: TVKDBFOrder;
  OldActiveIndexObject: TIndex;
  fldt: AnsiChar;
  NullFields: Word;
  _NULLFLAGS_Field: TVKDBFFieldDef;
  IsThereLob: boolean;

  procedure WriteFieldDef(DBFFDs: TVKDBFFieldDefs; LastWrite: boolean = false);
  var
    i: Integer;
    cField: FIELD_REC;
    q: array[0..Pred(FIELD_RECV_SIZE)] of AnsiChar;
  begin
    if DBFFDs.Count = 0 then
      raise Exception.Create('TVKSmartDBF.CreateTable: You should define one field at least to create table!');
    for i := 0 to DBFFDs.Count - 1 do
    begin
      cHeader.rec_size := cHeader.rec_size + DBFFDs[i].DataSize;
      cField := DBFFDs[i].Field;
      cField.FieldFlag := DBFFDs[i].FieldFlag.FieldFlag;
      cField.FIELD_REC_VER := FDbfVersion;
      fldt := cField.field_type;
      case fldt of
        'Y': if FDbfVersion < xFoxPro then raise Exception.Create('TVKSmartDBF.CreateTable: DBF Version must be xFoxPro or greater for field type "Y"!');
        'T': if FDbfVersion < xFoxPro then raise Exception.Create('TVKSmartDBF.CreateTable: DBF Version must be xFoxPro or greater for field type "T"!');
        'P': if FDbfVersion < xFoxPro then raise Exception.Create('TVKSmartDBF.CreateTable: DBF Version must be xFoxPro or greater for field type "P"!');
        'F': if FDbfVersion < xBaseIV then raise Exception.Create('TVKSmartDBF.CreateTable: DBF Version must be greater then xBaseIII for field type "F"!');
        'B', 'G': if FDbfVersion < xBaseV then raise Exception.Create('TVKSmartDBF.CreateTable: DBF Version must be greater then xBaseIV for field type "B" or "G"!');
        'I', '+', 'O', '@':
          begin
            if FDbfVersion < xBaseVII then raise Exception.Create('TVKSmartDBF.CreateTable: DBF Version must be greater then xBaseVII for fields "I", "+", "O", "@"!');
            DBFFDs[i].FieldFlag.BinaryColumn := True;
            cField.FieldFlag := DBFFDs[i].FieldFlag.FieldFlag;
          end;
      end;
      if  ( fldt = 'M' ) or ( ( ( fldt = 'P' ) or ( fldt = 'G' ) ) and ( FDbfVersion in [xFoxPro..xVisualFoxPro] ) ) or
          ( ( ( fldt = 'B' ) or ( fldt = 'G' ) ) and ( FDbfVersion in [xBaseV..xBaseVII] ) ) or
          ( ( fldt = 'E' ) and ( cField.extend_type in
            [dbftClob, dbftBlob, dbftGraphic, dbftFmtMemo,
            dbftClob_NB, dbftBlob_NB, dbftGraphic_NB, dbftFmtMemo_NB,
            dbftDBFDataSet, dbftDBFDataSet_NB]  ) ) then begin
        IsThereLob := True;
        case FDbfVersion of
          xUnknown, xClipper, xBaseIII: cHeader.dbf_id := $83;
          xBaseIV: cHeader.dbf_id := $8B;
          xBaseV, xBaseVII: cHeader.dbf_id := $8C;
          xFoxPro: cHeader.dbf_id := $F5;
          xVisualFoxPro:
            begin
              FTableFlag.HasGotMemo := True;
              cHeader.TableFlag := FTableFlag.TableFlag;
            end;
        else
          cHeader.dbf_id := $83;
        end;
        FLobVersion := FDbfVersion;
      end;
      TranslateBuff(cField.field_name, cField.field_name, true, cField.MaxFieldNameSize);
      DBFHandler.Write(cField.FIELD_REC_STRUCT^, cField.FFIELD_REC_SIZE);
      TranslateBuff(cField.field_name, cField.field_name, false, cField.MaxFieldNameSize);
      Inc(cHeader.data_offset, cField.FFIELD_REC_SIZE);
      if  ( cField.field_type = 'E' ) and
          ( cField.extend_type in [dbftDBFDataSet, dbftDBFDataSet_NB]) then begin
        // Recursive call
        WriteFieldDef(DBFFDs[i].DBFFieldDefs);
      end;
    end;
    q[0] := #$D;
    if LastWrite then
      DBFHandler.Write(q, 1)
    else begin
      if DbfVersion in [xBaseV..xBaseVII] then begin
        DBFHandler.Write(q, FIELD_RECV_SIZE);
        Inc(cHeader.data_offset, FIELD_RECV_SIZE);
      end else begin
        DBFHandler.Write(q, FIELD_RECIII_SIZE);
        Inc(cHeader.data_offset, FIELD_RECIII_SIZE);
      end;
    end;
  end;

begin
  if not Active then
  begin
    DBFHandler.FileName := DBFFileName;
    DBFHandler.AccessMode.AccessMode := AccessMode.AccessMode;
    DBFHandler.ProxyStreamType := FStorageType;
    DBFHandler.OuterStream := FOuterStream;
    DBFHandler.CreateProxyStream;
    if DBFHandler.IsOpen then
    begin
      DecodeDate(Now, Year, Month, Day);
      with cHeader do
      begin
        case FDbfVersion of
          xClipper, xBaseIII, xBaseIV, xFoxPro: dbf_id := $03;
          xVisualFoxPro: dbf_id := $30;
          xBaseV, xBaseVII: dbf_id := $04;
        else
          dbf_id := $03;
        end;
        last_update[0] := Byte(Year);
        last_update[1] := Byte(Month);
        last_update[2] := Byte(Day);
        last_rec := 0;
        data_offset := 1;
        rec_size := 1;
        Dummy1 := 0;
        IncTrans := 0;
        Encrypt := 0;
        Dummy2 := 0;
        for i := 20 to 27 do
          Dummy3[i] := 0;
        TableFlag := FTableFlag.TableFlag;
        CodePageMark := 0;
        Dummy4 := 0;
      end;
      DBFHandler.Seek(0, 0);
      DBFHandler.Write(cHeader, SizeOf(DBF_HEAD));
      cHeader.data_offset := cHeader.data_offset + SizeOf(DBF_HEAD);
      if FDbfVersion in [xBaseV..xBaseVII] then begin
        DBFHandler.Write(caHeader, SizeOf(AFTER_DBF_HEAD));
        cHeader.data_offset := cHeader.data_offset + SizeOf(AFTER_DBF_HEAD);
      end;

      // Define _NULLFLAGS system field for VFP
      if FDbfVersion = xVisualFoxPro then begin
        NullFields := 0;
        for k := 0 to FDBFFieldDefs.Count - 1 do begin
          if FDBFFieldDefs[k].FieldFlag.CanStoreNull then Inc(NullFields);
        end;
        if NullFields > 0 then begin
          _NULLFLAGS_Field := TVKDBFFieldDef(FDBFFieldDefs.Add);
          _NULLFLAGS_Field.Name := '_NULLFLAGS';
          _NULLFLAGS_Field.field_type := '0';
          _NULLFLAGS_Field.extend_type := dbftUndefined;
          _NULLFLAGS_Field.len := NullFields div 8 ;
          if NullFields mod 8 > 0 then _NULLFLAGS_Field.len := _NULLFLAGS_Field.len + 1;
          _NULLFLAGS_Field.FieldFlag.FieldFlag := 0;
          _NULLFLAGS_Field.FieldFlag.System := True;
          _NULLFLAGS_Field.FieldFlag.BinaryColumn := True;
        end;
      end;

      IsThereLob := False;

      WriteFieldDef(FDBFFieldDefs, true);

      FIsThereLob := IsThereLob;

      cHeader.data_offset := cHeader.data_offset + 1;
      qq := $1A;
      DBFHandler.Write(qq, 1);

      //
      if FDbfVersion = xVisualFoxPro then begin
        FillChar(VFP_F, SizeOf(VISUALFOXPRO_FOOTER), #0);
        DBFHandler.Write(VFP_F, SizeOf(VISUALFOXPRO_FOOTER));
        cHeader.data_offset := cHeader.data_offset + SizeOf(VISUALFOXPRO_FOOTER);
      end;
      //
      DBFHandler.SetEndOfFile;


      DBFHandler.Seek(0, 0);
      DBFHandler.Write(cHeader, SizeOf(DBF_HEAD));
      DBFHandler.Close;

      CreateLobStream(cHeader.dbf_id, IsThereLob);

    end else raise Exception.Create('TVKSmartDBF.CreateTable: Create error');

    if Indexes <> nil then begin
      OldActiveIndexObject := Indexes.ActiveObject;
      Indexes.ActiveObject := nil;
      FOpenWithoutIndexes := True;
      try
        Active := True;
        for i := 0 to DBFIndexDefs.Count - 1 do begin
          oBag := TVKDBFIndexBag(DBFIndexDefs[i]);
          oBag.CreateBag;
          for j := 0 to oBag.Orders.Count - 1 do begin
            oOrd := TVKDBFOrder(oBag.Orders[j]);
            oOrd.CreateOrder;
          end;
          oBag.Close;
        end;
        Active := False;
      finally
        FOpenWithoutIndexes := False;
        if Indexes <> nil then
          Indexes.ActiveObject := OldActiveIndexObject;
      end;
    end;

  end else raise Exception.Create('TVKSmartDBF.CreateTable: Can not create table while dataset is open');
end;

destructor TVKSmartDBF.Destroy;
begin
  try
    inherited Destroy;
    FreeAndNil(FLockRecords);
    FreeAndNil(FAccessMode);
    FreeAndNil(FVKDBFCrypt);
    FreeAndNil(FFilterParser);
    FreeAndNil(FDataLink);
    FreeAndNil(FDBFFieldDefs);
    FreeAndNil(ListMasterFields);
    LobHandlerDestroy;
    FreeAndNil(DBFHandler);
    FreeAndNil(FTableFlag);
    FreeAndNil(FRLockObject);
    FreeAndNil(FRUnLockObject);
    FreeAndNil(FFLockObject);
    FreeAndNil(FFUnLockObject);
    FreeAndNil(FHeaderLockObject);
    FreeAndNil(FHeaderUnLockObject);
    FreeAndNil(FLobHeaderLockObject);
    FreeAndNil(FLobHeaderUnLockObject);
  except
    if Assigned(DBFHandler) and DBFHandler.IsOpen then DBFHandler.Close;
    if Assigned(LobHandler) and LobHandler.IsOpen then LobHandler.Close;
  end;
end;

function TVKSmartDBF.FindRecord(Restart, GoForward: Boolean): Boolean;
var
  SaveState: TDataSetState;
  Accept: Boolean;
  Ret: TGetResult;
begin
  if (not Filtered) and (Filter <> '') then
      FFilterParser.SetExprParams(Filter, FilterOptions, [poExtSyntax], '');
  CheckBrowseMode;
  DoBeforeScroll;
  SetFound(False);
  UpdateCursorPos;
  CursorPosChanged;
  if GoForward then
  begin
    if Restart then InternalFirst;
    repeat
      Ret := GetRecordByBuffer(FFilterRecord, gmNext, false);
      SaveState := SetTempState(dsFilter);
      Accept := AcceptRecordInternal;
      RestoreState(SaveState);
    until Accept or (Ret <> grOK);
  end else
  begin
    if Restart then InternalLast;
    repeat
      Ret := GetRecordByBuffer(FFilterRecord, gmPrior, false);
      SaveState := SetTempState(dsFilter);
      Accept := AcceptRecordInternal;
      RestoreState(SaveState);
    until Accept or (Ret <> grOK);
  end;
  if Ret = grOK then
  begin
    Resync([rmExact, rmCenter]);
    SetFound(True);
  end else
    InternalSetToRecord(ActiveBuffer);
  Result := Found;
  if Result then DoAfterScroll;
end;

{$IFDEF DELPHI2009}
procedure TVKSmartDBF.FreeRecordBuffer(var Buffer: TRecordBuffer);
{$ELSE}
procedure TVKSmartDBF.FreeRecordBuffer(var Buffer: PAnsiChar);
{$ENDIF}
begin
  VKDBFMemMgr.oMem.FreeMem(Buffer)
end;

function TVKSmartDBF.GetActiveRecBuf(var pRecBuf: PAnsiChar): Boolean;
begin
  if FTmpCurrentEditBuffer <> nil then pRecBuf := FTmpCurrentEditBuffer;
  if FIndState then begin
    pRecBuf := FIndRecBuf;
  end else begin
    if FKeyCalk then begin
      pRecBuf := RecBuf
    end else begin
      if FTmpActive then
        pRecBuf := FTempRecord
      else begin
        case State of
          dsBrowse: if IsEmpty then pRecBuf := nil else pRecBuf := PAnsiChar(ActiveBuffer);
          dsEdit, dsInsert: pRecBuf := PAnsiChar(ActiveBuffer);
          dsFilter: pRecBuf := FFilterRecord;
          dsNewValue, dsOldValue, dsCurValue: pRecBuf := PAnsiChar(ActiveBuffer);
          dsCalcFields: pRecBuf := PAnsiChar(CalcBuffer);
          dsSetKey: pRecBuf := FSetKeyBuffer;
        else
          pRecBuf := nil;
        end;
      end;
    end;
  end;
  Result := pRecBuf <> nil;
end;

{$IFDEF DELPHI2009}
procedure TVKSmartDBF.GetBookmarkData(Buffer: TRecordBuffer; Data: Pointer);
{$ELSE}
procedure TVKSmartDBF.GetBookmarkData(Buffer: PAnsiChar; Data: Pointer);
{$ENDIF}
begin
  Longword(Data^) := pTRecInfo(Buffer + FRecordSize).RecordRowID;
end;

{$IFDEF DELPHI2009}
function TVKSmartDBF.GetBookmarkFlag(Buffer: TRecordBuffer): TBookmarkFlag;
{$ELSE}
function TVKSmartDBF.GetBookmarkFlag(Buffer: PAnsiChar): TBookmarkFlag;
{$ENDIF}
begin
  Result := pTRecInfo(Buffer + FRecordSize).BookmarkFlag;
end;

function TVKSmartDBF.GetDeleted: Boolean;
var
  ActBuff: pAnsiChar;
begin
  Result := false;
  if GetActiveRecBuf(ActBuff) then
    Result := (ActBuff[0] = #42); //'*'
end;

procedure TVKSmartDBF.SetDeletedFlag(const Value: Boolean);
var
  ActBuff: pAnsiChar;
  c: Boolean;
begin
  if GetActiveRecBuf(ActBuff) then
  begin
    c := ( ActBuff[0] = #42 );
    if Value <> c then begin
      if not (State in [dsEdit, dsInsert]) then Edit;
      if Value then
        ActBuff[0] := #42 //'*'
      else
        ActBuff[0] := #32; //' '
      SetModified(True);
    end;
  end;
end;

function TVKSmartDBF.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  Result := InternalGetFieldData(Field, Buffer);
end;

{$IFDEF DELPHIXE3}
function TVKSmartDBF.GetFieldData(Field: TField; {$IFDEF DELPHIXE4}var{$ENDIF} Buffer: TValueBuffer): Boolean;
begin
  if not Assigned(Buffer) then
    Result := InternalGetFieldData(Field, nil)
  else
    Result := InternalGetFieldData(Field, @Buffer[0]);
end;
{$ENDIF DELPHIXE3}

function TVKSmartDBF.InternalGetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  iCode, dInt: Integer;
  dInt64: Int64;
  dFloat: Double;
  ww: Extended;
  dBool: WordBool;
  dDate: TDateTime;
  sTS: TTimeStamp;
  sVFPTS: TVFPTimeStamp;
  dd: double;
  Year, Month, Day: Word;
  ss, vfpnull: pAnsiChar;
  ss1: array [0..255] of AnsiChar;
  ActiveBuf: pAnsiChar;
  qq: TVKDBFFieldDef;
  oDS: TDataSet;
  LookupResult: Variant;
  LastSetp: Char;
  SLen: WORD;
  WLen: Integer;
begin
  Result := false;
  case Field.FieldKind of
  fkData:
    begin
      qq := TVKDBFFieldDef(Pointer(Field.Tag));
      if GetActiveRecBuf(ActiveBuf) then
      begin
        if FDbfVersion = xVisualFoxPro then begin
          if qq.FieldFlag.CanStoreNull then begin
            vfpnull := ActiveBuf + qq.OwnerVKDBFFieldDefs.FVFPNullsOffset + qq.FVFPNullByteNumber;
            if ( Byte(vfpnull^) and qq.FVFPNullBitMask ) = qq.FVFPNullBitMask then begin
              Result := False;
              if not ( qq.field_type in ['M', 'P', 'G'] ) then Exit;
            end;
          end;
        end;
        ss := ActiveBuf + qq.FOff;
        if Assigned(Buffer) then
        begin
          case Field.DataType of
            ftTime:
              begin
                case qq.extend_type of
                  dbftTime:
                    begin
                      Integer(Buffer^) := pInteger(ss)^;
                      Result := true;
                    end;
                  dbftTime_N:
                    begin
                      Result := (ss[0] <> ' ');  //if ' ' then NULL
                      if Result then
                        Integer(Buffer^) := pInteger(ss + 1)^;
                    end;
                  dbftTime_NB:
                    begin
                      Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
                      if Result then
                        Longword(Buffer^) := ( pLongword(ss)^ and $7FFFFFFF );
                    end;
                end;
              end;
            ftDate:
              begin
                if qq.field_type <> 'E' then begin
                  Result := not IsBlank(ss, qq.FLen);
                  if Result then begin
                    Year := (Byte(ss[0]) - $30) * 1000 + (Byte(ss[1]) - $30) * 100 + (Byte(ss[2]) - $30) * 10 + (Byte(ss[3]) - $30);
                    Month := (Byte(ss[4]) - $30) * 10 + (Byte(ss[5]) - $30);
                    Day := (Byte(ss[6]) - $30) * 10 + (Byte(ss[7]) - $30);
                    if DoEncodeDate(Year, Month, Day, dDate) then
                    begin
                      sTS := DateTimeToTimeStamp(dDate);
                      //dd := 3600.0*24*1000*sTS.Date + sTS.Time;
                      //double(Buffer^) := dd;
                      Integer(Buffer^) := sTS.Date;
                    end else
                      Result := false;
                  end;
                end else begin
                  case qq.extend_type of
                    dbftDate:
                      begin
                        Integer(Buffer^) := pInteger(ss)^;
                        Result := true;
                      end;
                    dbftDate_NB:
                      begin
                        Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
                        if Result then
                          Longword(Buffer^) := ( pLongword(ss)^ and $7FFFFFFF );
                      end;
                    dbftDate_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          Integer(Buffer^) := pInteger(ss + 1)^;
                      end;
                  end;
                end;
              end;
            ftBCD:
              begin
                Result := (( Byte(ss[1]) and $40 ) <> $00);
                if Result  then begin
                  Tbcd(Buffer^) := Pbcd(ss)^;
                  Tbcd(Buffer^).SignSpecialPlaces := (Tbcd(Buffer^).SignSpecialPlaces or $40);
                end;
              end;
            ftCurrency:
              begin
                if qq.field_type <> 'E' then begin
                  // qq.field_type = 'Y'
                  Currency(Buffer^) := pCurrency(ss)^;
                  Result := true;
                end else begin
                  case qq.extend_type of
                    dbftCurrency:
                      begin
                        Currency(Buffer^) := pCurrency(ss)^;
                        Result := true;
                      end;
                    dbftCurrency_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          Currency(Buffer^) := pCurrency(ss + 1)^;
                      end;
                    dbftCurrency_NB:
                      begin
                        Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ and $7F );
                          Currency(Buffer^) := Currency( Pointer(ss)^ );
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ or $80 );
                        end;
                      end;
                  end;
                end;
              end;
            ftBytes:
              begin
                // 'C' and FieldFlag.BinaryColumn = True
                // or '0'
                Move(ss^, Buffer^, qq.FLen);
              end;
            ftWideString:
              begin
                Result := not IsBlank(ss, qq.FLen);
                if Result then begin
                  WLen := pInteger(ss)^;
                  Move(ss^, Buffer^, WLen + 6);
                end;
              end;
            ftString:
              begin
                if qq.field_type <> 'E' then begin
                  Move(ss^, Buffer^, qq.FLen);
                  pAnsiChar(Buffer)[qq.FLen] := #0;
                  if FTrimCType then begin
                    dInt := Pred(qq.FLen);
                    while pAnsiChar(Buffer)[dInt] = ' ' do begin
                      pAnsiChar(Buffer)[dInt] := #0;
                      Dec(dInt);
                      if dInt < 0 then break;
                    end;
                    Result := ( not ( dInt < 0 ) );
                  end else
                    Result := true;
                end else
                  case qq.extend_type of
                    dbftString:       //
                      begin
                        SLen := pWORD(ss)^;
                        if SLen < 8224 then begin
                          ss := ss + SizeOf(WORD);
                          Move(ss^, Buffer^, SLen);
                          pAnsiChar(Buffer)[SLen] := #0;
                          Result := true;
                        end else
                          Result := false;
                      end;
                    dbftString_N:     //
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then begin
                          ss := ss + 1;
                          SLen := pWORD(ss)^;
                          ss := ss + SizeOf(WORD);
                          Move(ss^, Buffer^, SLen);
                          pAnsiChar(Buffer)[SLen] := #0;
                        end;
                      end;
                    dbftFixedChar:
                      begin
                        Result := not IsBlank(ss, qq.FLen + 1);
                        if Result then
                          Move(ss^, Buffer^, qq.FLen + 1);
                      end;
                  else
                    Result := false;
                  end;
              end;
            ftSmallint:
              begin
                case qq.extend_type of
                  dbftS1:       //Shortint
                    begin
                      Smallint(Buffer^) := pShortint(ss)^;
                      Result := true;
                    end;
                  dbftS2:       //Smallint
                    begin
                      Smallint(Buffer^) := pSmallint(ss)^;
                      Result := true;
                    end;
                  dbftS1_N:     //Shortint with NULL
                    begin
                      Result := (ss[0] <> ' ');  //if ' ' then NULL
                      if Result then
                        Smallint(Buffer^) := pShortint(ss + 1)^;
                    end;
                  dbftS2_N:     //Smallint with NULL
                    begin
                      Result := (ss[0] <> ' ');  //if ' ' then NULL
                      if Result then
                        Smallint(Buffer^) := pSmallint(ss + 1)^;
                    end;
                else
                  Result := false;
                end;
              end;
            ftWord:
              begin
                case qq.extend_type of
                  dbftU1:     //Byte
                    begin
                      Word(Buffer^) := pByte(ss)^;
                      Result := true;
                    end;
                  dbftU2:     //Word
                    begin
                      Word(Buffer^) := pWord(ss)^;
                      Result := true;
                    end;
                  dbftU1_N:   //Byte with NULL
                    begin
                      Result := (ss[0] <> ' ');  //if ' ' then NULL
                      if Result then
                        Word(Buffer^) := pByte(ss + 1)^;
                    end;
                  dbftU2_N:   //Word with NULL
                    begin
                      Result := (ss[0] <> ' ');  //if ' ' then NULL
                      if Result then
                        Word(Buffer^) := pWord(ss + 1)^;
                    end;
                  dbftU1_NB:  //Positive byte with NULL bit instead of sign bit
                    begin
                      Result := ( ( Byte(ss[0]) and $80 ) = $80 );
                      if Result then
                        Word(Buffer^) := ( Byte(ss[0]) and $7F );
                    end;
                  dbftU2_NB:  //Positive word with NULL bit instead of sign bit
                    begin
                      Result := ( ( pWord(ss)^ and $8000 ) = $8000 );
                      if Result then
                        Word(Buffer^) := ( pWord(ss)^ and $7FFF );
                    end;
                else
                  Result := false;
                end;
              end;
            ftInteger:
              begin
                if qq.field_type <> 'E' then begin
                  case qq.field_type of
                    'I':
                      begin
                        if FDbfVersion > xBaseVII then begin
                          dInt := pInteger(ss)^;
                          Result := True;
                          Integer(Buffer^) := dInt;
                        end else begin
                          dInt := pInteger(ss)^;
                          Integer(Buffer^) := SwapInt(dInt);
                          Result := ( DWord(Buffer^) <> 0 );
                          if Result then
                            Integer(Buffer^) := Integer( DWord(Buffer^) - $80000000 );
                        end;
                      end;
                  else
                    Move(ss^, ss1, qq.FLen);
                    ss1[qq.FLen] := #0;
                    Val(ss1, dInt, iCode);
                    if iCode = 0 then
                    begin
                      Integer(Buffer^) := dInt;
                      Result := true;
                    end else
                      Result := false;
                  end;
                end else begin
                  case qq.extend_type of
                    dbftS4, dbftU4:       //Longint, Longword
                      begin
                        Integer(Buffer^) := pInteger(ss)^;
                        Result := true;
                      end;
                    dbftS4_N, dbftU4_N:     //Longint with NULL, Longword with NULL
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          Integer(Buffer^) := pInteger(ss + 1)^;
                      end;
                    dbftU4_NB:
                      begin
                        Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
                        if Result then
                          Longword(Buffer^) := ( pLongword(ss)^ and $7FFFFFFF );
                      end;
                  else
                    Result := false;
                  end;
                end;
              end;
            ftAutoInc:
              begin
                if FDbfVersion > xBaseVII then begin
                  dInt := pInteger(ss)^;
                  Result := True;
                  Integer(Buffer^) := dInt;
                end else begin
                  dInt := pInteger(ss)^;
                  Integer(Buffer^) := SwapInt(dInt);
                  Result := DWord(Buffer^) <> 0;
                  if Result then
                    Integer(Buffer^) := Integer( DWord(Buffer^) - $80000000 );
                end;
              end;
            ftLargeint:
              begin
                if qq.field_type <> 'E' then begin
                  Move(ss^, ss1, qq.FLen);
                  ss1[qq.FLen] := #0;
                  Val(ss1, dInt64, iCode);
                  if iCode = 0 then
                  begin
                    Int64(Buffer^) := dInt64;
                    Result := true;
                  end else
                    Result := false;
                end else begin
                  case qq.extend_type of
                    dbftS8:    //Int64
                      begin
                        Int64(Buffer^) := pInt64(ss)^;
                        Result := true;
                      end;
                    dbftS8_N:  //Int64 with NULL
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          Int64(Buffer^) := pInt64(ss + 1)^;
                      end;
                  else
                    Result := false;
                  end;
                end;
              end;
            ftFloat:
              begin
                if qq.field_type <> 'E' then begin
                  case qq.field_type of
                    'B':
                      begin
                        double(Buffer^) := pDouble(ss)^;
                        Result := true;
                      end;
                    'O':
                      begin
                        if pInt64(ss)^ <> 0 then begin
                          dInt64 := pInt64(ss)^;
                          Int64(Buffer^) := SwapInt64(dInt64);
                          if pInt64(Buffer)^ > 0 then
                            Int64(Buffer^) := not pInt64(Buffer)^
                          else
                            Double(Buffer^) := - pDouble(Buffer)^;
                          Result := True;  //not NULL
                        end else begin
                          Result := False; //NULL
                        end;
                      end;
                  else
                    Result := not IsBlank(ss, qq.FLen);
                    if Result then begin
                      Move(ss^, ss1, qq.FLen);
                      ss1[qq.FLen] := #0;
                      LastSetp := {$IFDEF DELPHIXE}FormatSettings.{$ENDIF}DecimalSeparator;
                      {$IFDEF DELPHIXE}FormatSettings.{$ENDIF}DecimalSeparator := '.';
                      if {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}TextToFloat(ss1, ww, fvExtended) then
                      begin
                        dFloat := ww;
                        double(Buffer^) := dFloat;
                      end else begin
                        {$IFDEF DELPHIXE}FormatSettings.{$ENDIF}DecimalSeparator := ',';
                        if {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}TextToFloat(ss1, ww, fvExtended) then
                        begin
                          dFloat := ww;
                          double(Buffer^) := dFloat;
                        end else
                          Result := false;
                      end;
                      {$IFDEF DELPHIXE}FormatSettings.{$ENDIF}DecimalSeparator := LastSetp;
                    end;
                  end;
                end else begin
                  case qq.extend_type of
                    dbftR4:
                      begin
                        double(Buffer^) := pSingle(ss)^;
                        Result := true;
                      end;
                    dbftR6:
                      begin
                        double(Buffer^) := pReal48(ss)^;
                        Result := true;
                      end;
                    dbftR8:
                      begin
                        double(Buffer^) := pDouble(ss)^;
                        Result := true;
                      end;
                    dbftR10:
                      begin
                        Extended(Buffer^) := pExtended(ss)^;
                        Result := true;
                      end;
                    dbftR4_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          double(Buffer^) := pSingle(ss + 1)^;
                      end;
                    dbftR4_NB:
                      begin
                        Result := ( ( pByte(ss + 3)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 3)^ := ( pByte(ss + 3)^ and $7F );
                          double(Buffer^) := Single( Pointer(ss)^ );
                          pByte(ss + 3)^ := ( pByte(ss + 3)^ or $80 );
                        end;
                      end;
                    dbftR6_NB:
                      begin
                        Result := ( ( pByte(ss + 5)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 5)^ := ( pByte(ss + 5)^ and $7F );
                          double(Buffer^) := Real48( Pointer(ss)^ );
                          pByte(ss + 5)^ := ( pByte(ss + 5)^ or $80 );
                        end;
                      end;
                    dbftR8_NB:
                      begin
                        Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ and $7F );
                          double(Buffer^) := double( Pointer(ss)^ );
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ or $80 );
                        end;
                      end;
                    dbftR6_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          double(Buffer^) := pReal48(ss + 1)^;
                      end;
                    dbftR8_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          double(Buffer^) := pDouble(ss + 1)^;
                      end;
                    dbftR10_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          Extended(Buffer^) := pExtended(ss + 1)^;
                      end;
                  else
                    Result := false;
                  end;
                end;
              end;
            ftMemo, ftBlob, ftFmtMemo, ftGraphic, ftParadoxOle, ftDBaseOle:
              begin
                if  ( qq.field_type = 'M' ) or ( qq.field_type = 'B' ) or
                    ( qq.field_type = 'G' ) or ( qq.field_type = 'P' ) or
                    ( ( qq.field_type = 'E' ) and
                      ( qq.extend_type in [ dbftClob, dbftFmtMemo,
                                            dbftBlob, dbftGraphic] )) then begin
                  if DbfVersion = xVisualFoxPro then begin
                    dInt := pInteger(ss)^;
                    Result := dInt <> 0;
                    if Result then
                      Integer(Buffer^) := dInt;
                  end else begin
                    Result := not IsBlank(ss, 10);
                    if Result then
                      Move(ss^, Buffer^, 10);
                  end;
                end else begin
                  Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
                  if Result then
                    Integer(Buffer^) := Integer(pLongWord(ss)^ and $7FFFFFFF);
                end;
              end;
            ftDateTime:
              begin
                if qq.field_type = 'E' then
                  case qq.extend_type of
                    dbftD1:
                      begin
                        sTS := DateTimeToTimeStamp(pDouble(ss)^);
                        dd := 3600.0*24*1000*sTS.Date + sTS.Time;
                        double(Buffer^) := dd;
                        Result := true;
                      end;
                    dbftD1_NB:
                      begin
                        Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ and $7F );
                          sTS := DateTimeToTimeStamp(pDouble(ss)^);
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ or $80 );
                          dd := 3600.0*24*1000*sTS.Date + sTS.Time;
                          double(Buffer^) := dd;
                        end;
                      end;
                    dbftD2:
                      begin
                        double(Buffer^) := pDouble(ss)^;
                        Result := true;
                      end;
                    dbftD2_NB:
                      begin
                        Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ and $7F );
                          double(Buffer^) := pDouble(ss)^;
                          pByte(ss + 7)^ := ( pByte(ss + 7)^ or $80 );
                        end;
                      end;
                    dbftD3:
                      begin
                        sTS := DateTimeToTimeStamp(pReal48(ss)^);
                        dd := 3600.0*24*1000*sTS.Date + sTS.Time;
                        double(Buffer^) := dd;
                        Result := true;
                      end;
                    dbftD3_NB:
                      begin
                        Result := ( ( pByte(ss + 5)^ and $80 ) = $80 );
                        if Result then begin
                          pByte(ss + 5)^ := ( pByte(ss + 5)^ and $7F );
                          double(Buffer^) := pReal48(ss)^;
                          pByte(ss + 5)^ := ( pByte(ss + 5)^ or $80 );
                        end;
                      end;
                    dbftD1_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then begin
                          sTS := DateTimeToTimeStamp(pDouble(ss + 1)^);
                          dd := 3600.0*24*1000*sTS.Date + sTS.Time;
                          double(Buffer^) := dd;
                        end;
                      end;
                    dbftD2_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then
                          double(Buffer^) := pDouble(ss + 1)^;
                      end;
                    dbftD3_N:
                      begin
                        Result := (ss[0] <> ' ');  //if ' ' then NULL
                        if Result then begin
                          sTS := DateTimeToTimeStamp(pReal48(ss + 1)^);
                          dd := 3600.0*24*1000*sTS.Date + sTS.Time;
                          double(Buffer^) := dd;
                        end;
                      end;
                  end
                else begin
                  if qq.field_type = '@' then begin
                    if pInt64(ss)^ <> 0 then begin
                      dInt64 := pInt64(ss)^;
                      Int64(Buffer^) := SwapInt64(dInt64);
                      Result := True;  //not NULL
                    end else begin
                      Result := False; //NULL
                    end;
                  end else if qq.field_type = 'T' then begin
                    Result := (ss[0] <> ' ');  //if ' ' then NULL
                    if Result then begin
                      sVFPTS := PVFPTimeStamp(ss)^;
                      dd := 3600.0 * 24 * 1000 * ( sVFPTS.Date - 1721425) + sVFPTS.Time;
                      double(Buffer^) := dd;
                    end;
                  end;
                end;
              end;
            ftBoolean:
              begin
                case ss[0] of
                  'T':
                    begin
                      dBool := true;
                      Result := true;
                    end;
                  'F':
                    begin
                      dBool := false;
                      Result := true;
                    end;
                  ' ':
                    begin
                      dBool := false;
                      Result := false;
                    end;
                else
                  dBool := false;
                  Result := false;
                end;
                WordBool(Buffer^) := dBool;
              end;
            ftDataSet:
              begin
                case qq.extend_type of
                  dbftDBFDataSet:
                    begin
                      if DbfVersion = xVisualFoxPro then begin
                        dInt := pInteger(ss)^;
                        Result := dInt <> 0;
                        if Result then
                          Integer(Buffer^) := dInt;
                      end else begin
                        Result := not IsBlank(ss, 10);
                        if Result then
                          Move(ss^, Buffer^, 10);
                      end;
                    end;
                  dbftDBFDataSet_NB:
                    begin
                      Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
                      if Result then
                        Integer(Buffer^) := Integer(Pointer(ss)^);
                    end;
                end;
              end;
          end;
        end else begin
          if qq.field_type <> 'E' then begin
            if qq.field_type <> 'C' then begin
              if qq.field_type in ['I', '+', 'O', '@'] then begin
                if qq.field_type in ['I', '+'] then begin
                  if FDbfVersion > xBaseVII then
                    Result := True
                  else begin
                    dInt := pInteger(ss)^;
                    dInt := SwapInt(dInt);
                    Result := ( dInt <> 0 );
                  end;
                end else begin// 'O', '@'
                  Result := pInt64(ss)^ <> 0;
                end;
              end else begin
                if FDbfVersion = xVisualFoxPro then begin
                  if qq.field_type in ['M', 'P'] then
                    Result := DWord(ss^) <> 0
                  else
                    Result := not IsBlank(ss, qq.FLen);
                end else
                  Result := not IsBlank(ss, qq.FLen)
              end;
            end else begin
              Result := true;
              if FTrimCType then begin
                dInt := Pred(qq.FLen);
                while ss[dInt] = ' ' do begin
                  Dec(dInt);
                  if dInt < 0 then break;
                end;
                Result := (not ( dInt < 0 ));
              end;
            end;
          end else begin
            case qq.extend_type of
              dbftS1_N,     //Shortint with NULL
              dbftU1_N,     //Byte  with NULL
              dbftS2_N,     //Smallint with NULL
              dbftU2_N,     //Word with NULL
              dbftS4_N,     //Longint with NULL
              dbftU4_N,     //Longword with NULL
              dbftS8_N,     //Int64 with NULL
              dbftR4_N,     //Single with NULL
              dbftR6_N,     //Real48 with NULL
              dbftR8_N,     //Double with NULL
              dbftR10_N,    //Extended with NULL
              dbftD1_N,
              dbftD2_N,
              dbftD3_N,
              dbftString_N, //String with NULL
              dbftCurrency_N, //Currency with NULL
              dbftDate_N,
              dbftTime_N: Result := not (ss[0] = ' ');  //if ' ' then NULL
              dbftU1_NB: Result := not ( ( Byte(ss[0]) and $80 ) = $80 );
              dbftU2_NB: Result := ( ( pWord(ss)^ and $8000 ) = $8000 );
              dbftU4_NB: Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
              dbftR4_NB: Result := ( ( pByte(ss + 3)^ and $80 ) = $80 );
              dbftR6_NB: Result := ( ( pByte(ss + 5)^ and $80 ) = $80 );
              dbftR8_NB: Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
              dbftCurrency_NB: Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
              dbftD1_NB: Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
              dbftD2_NB: Result := ( ( pByte(ss + 7)^ and $80 ) = $80 );
              dbftD3_NB: Result := ( ( pByte(ss + 5)^ and $80 ) = $80 );
              dbftDate_NB: Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
              dbftTime_NB: Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
              dbftClob, dbftFmtMemo, dbftBlob, dbftGraphic, dbftDBFDataSet:
                begin
                  if FDbfVersion = xVisualFoxPro then
                    Result := DWord(ss^) <> 0
                  else
                    Result := not IsBlank(ss, qq.FLen);
                end;
              dbftClob_NB, dbftFmtMemo_NB, dbftBlob_NB, dbftGraphic_NB, dbftDBFDataSet_NB:
                begin
                  if FDbfVersion = xVisualFoxPro then
                    Result := DWord(ss^) <> 0
                  else
                    Result := ( ( pLongword(ss)^ and $80000000 ) = $80000000 );
                end;
              dbftString: Result := not ( pWORD(ss)^ = 8224 );
              dbftFixedChar: Result := not IsBlank(ss, qq.FLen + 1);
              dbftS1,
              dbftU1,
              dbftS2,
              dbftU2,
              dbftS4,
              dbftU4,
              dbftS8,
              dbftR4,
              dbftR6,
              dbftR8,
              dbftR10,
              dbftD1,
              dbftD2,
              dbftD3,
              dbftCurrency,
              dbftDate,
              dbftTime: Result := true;
              dbftBCD: Result := not ( ( Byte(ss[1]) and $40 ) = $00 );
            else
              Result := false;
            end;
          end;
        end;
      end else
        Result := false;
    end;
  fkCalculated:
    begin
      if GetActiveRecBuf(ActiveBuf) then begin
        ss := ActiveBuf + FRecordSize + sizeof(TRecInfo) + Field.Offset;
        if Buffer <> nil then
        begin
          if not (csDesigning in ComponentState) then
          begin
            Move(ss^, Buffer^, Field.DataSize);
            if Field.DataType in [ftString, ftBytes, ftVarBytes]  then pAnsiChar(Buffer)[Field.DataSize] := AnsiChar(0);
            Result := true;
          end else begin
            FillChar(Buffer^, Field.DataSize, ' ');
            Result := false;
          end;
        end else
          Result := not IsBlank(ss, Field.DataSize);
      end;
    end;
  fkLookup:
    begin
      Result := false;
      if GetActiveRecBuf(ActiveBuf) then
      begin
        oDS := Field.LookupDataSet;
        if Buffer <> nil then
        begin
          if (oDS <> nil) and oDS.Active then
          begin
            LookupResult := oDS.Lookup(Field.LookupKeyFields, FieldValues[Field.KeyFields], Field.LookupResultField);
            if (not VarIsEmpty(LookupResult)) and (not VarIsNull(LookupResult)) then
            begin
              case Field.DataType of
                ftString:
                  begin
                    ss := TVarData(LookupResult).VPointer;
                    Move(ss^, Buffer^, Length(ss) + 1);
                  end;
                ftSmallint: Smallint(Buffer^) := TVarData(LookupResult).VSmallint;
                ftInteger: Integer(Buffer^) := TVarData(LookupResult).VInteger;
                ftWord: Word(Buffer^) := TVarData(LookupResult).VSmallint;
                ftBoolean: WordBool(Buffer^) := TVarData(LookupResult).VBoolean;
                ftFloat: double(Buffer^) := TVarData(LookupResult).VDouble;
                ftCurrency: Currency(Buffer^) := TVarData(LookupResult).VCurrency;
                ftDateTime: double(Buffer^) := TVarData(LookupResult).VDate;
                ftTime:
                  begin
                    sTS := DateTimeToTimeStamp(TVarData(LookupResult).VDate);
                    Integer(Buffer^) := sTS.Time;
                  end;
                ftDate:
                  begin
                    sTS := DateTimeToTimeStamp(TVarData(LookupResult).VDate);
                    Integer(Buffer^) := sTS.Date;
                  end;
              else
                ss := pAnsiChar(@(TVarData(LookupResult).VAny));
                Move(ss^, Buffer^, Field.DataSize);
              end;
              Result := true;
            end;
          end;
        end else begin
          if (oDS <> nil) and oDS.Active then
          begin
            LookupResult := oDS.Lookup(Field.LookupKeyFields, FieldValues[Field.KeyFields], Field.LookupResultField);
            if (not VarIsEmpty(LookupResult)) and (not VarIsNull(LookupResult)) then Result := True;
          end;
        end;
      end else begin
        FillChar(Buffer^, Field.DataSize, ' ');
        Result := false;
      end;
    end;
  end;
end;

function TVKSmartDBF.GetRecNo: Integer;
var
  ActiveBuf: pAnsiChar;
begin
  Result := -1;
  if GetActiveRecBuf(ActiveBuf) then
    Result := pTRecInfo(ActiveBuf + RecordSize).RecordRowID;
end;

{$IFDEF DELPHI2009}
function TVKSmartDBF.GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode;
{$ELSE}
function TVKSmartDBF.GetRecord(Buffer: PAnsiChar; GetMode: TGetMode;
{$ENDIF}
  DoCheck: Boolean): TGetResult;
var
  SaveState: TDataSetState;
  Accept: Boolean;
begin
  if not Filtered then
  begin
    if not FSetDeleted then
      Result := GetRecordByBuffer(PAnsiChar(Buffer), GetMode, DoCheck)
    else begin
      Accept := False;
      if GetMode <> gmCurrent then
      begin
        repeat
          Result := GetRecordByBuffer(FFilterRecord, GetMode, DoCheck);
          if Result <> grOK then Break;
          SaveState := SetTempState(dsFilter);
          Accept := not Deleted;
          RestoreState(SaveState);
        until Accept;
      end else begin
        Result := GetRecordByBuffer(FFilterRecord, GetMode, DoCheck);
        if Result = grOK then begin
          SaveState := SetTempState(dsFilter);
          Accept := not Deleted;
          RestoreState(SaveState);
          if not Accept then Result := grError;
        end;
      end;
      if Accept then
        Move(FFilterRecord^, Buffer^, RecordBufferSize)
      else
        Move(FTempRecord^, Buffer^, RecordBufferSize);
    end;
  end else begin
    Accept := False;
    if GetMode <> gmCurrent then
    begin
      repeat
        Result := GetRecordByBuffer(FFilterRecord, GetMode, DoCheck);
        if Result <> grOK then Break;
        SaveState := SetTempState(dsFilter);
        Accept := AcceptRecordInternal;
        RestoreState(SaveState);
      until Accept;
    end else begin
      Result := GetRecordByBuffer(FFilterRecord, GetMode, DoCheck);
      if Result = grOK then begin
        SaveState := SetTempState(dsFilter);
        Accept := AcceptRecordInternal;
        RestoreState(SaveState);
        if not Accept then Result := grError;
      end;
    end;
    if Accept then
      Move(FFilterRecord^, Buffer^, RecordBufferSize)
    else
      Move(FTempRecord^, Buffer^, RecordBufferSize);
  end;
end;

function TVKSmartDBF.GetRecordBufferSize: Integer;
begin
  Result := FRecordSize + sizeof(TRecInfo) + CalcFieldsSize;
end;

function TVKSmartDBF.GetRecordByBuffer(Buffer: PAnsiChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
var
  cc: PAnsiChar;
begin
  Result := grOK;
  cc := pAnsiChar(Buffer);
  case GetMode of
    gmCurrent:
      if ( not FBOF ) and ( not FEOF ) then
      begin
        {$IFDEF DELPHI2009}
        InternalInitRecord(pByte(cc));
        {$ELSE}
        InternalInitRecord(cc);
        {$ENDIF}
        pTRecInfo(cc + FRecordSize).BookmarkFlag := bfCurrent;
        pTRecInfo(cc + FRecordSize).RecordRowID := RecNoBuf;
        pTRecInfo(cc + FRecordSize).UpdateStatus := usUnmodified;
        Move(RecBuf^, cc^, FRecordSize);
      end else begin
        {$IFDEF DELPHI2009}
        InternalInitRecord(pByte(FTempRecord));
        {$ELSE}
        InternalInitRecord(FTempRecord);
        {$ENDIF}
        Move(FTempRecord^, Buffer^, RecordBufferSize);
        pTRecInfo(FTempRecord + FRecordSize).BookmarkFlag := bfEOF;
        pTRecInfo(FTempRecord + FRecordSize).RecordRowID := 0;
        pTRecInfo(FTempRecord + FRecordSize).UpdateStatus := usUnmodified;
        Result := grError;
      end;
    gmNext:
      begin
        NextIndexBuf;
        if not FEOF then
        begin
          {$IFDEF DELPHI2009}
          InternalInitRecord(pByte(cc));
          {$ELSE}
          InternalInitRecord(cc);
          {$ENDIF}
          pTRecInfo(cc + FRecordSize).BookmarkFlag := bfCurrent;
          pTRecInfo(cc + FRecordSize).RecordRowID := RecNoBuf;
          pTRecInfo(cc + FRecordSize).UpdateStatus := usUnmodified;
          Move(RecBuf^, cc^, FRecordSize);
        end else begin
          {$IFDEF DELPHI2009}
          InternalInitRecord(pByte(FTempRecord));
          {$ELSE}
          InternalInitRecord(FTempRecord);
          {$ENDIF}
          Move(FTempRecord^, Buffer^, RecordBufferSize);
          pTRecInfo(FTempRecord + FRecordSize).BookmarkFlag := bfEOF;
          pTRecInfo(FTempRecord + FRecordSize).RecordRowID := 0;
          pTRecInfo(FTempRecord + FRecordSize).UpdateStatus := usUnmodified;
          Result := grEOF;
        end;
      end;
    gmPrior:
      begin
        PriorIndexBuf;
        if not FBOF then
        begin
          {$IFDEF DELPHI2009}
          InternalInitRecord(pByte(cc));
          {$ELSE}
          InternalInitRecord(cc);
          {$ENDIF}
          pTRecInfo(cc + FRecordSize).BookmarkFlag := bfCurrent;
          pTRecInfo(cc + FRecordSize).RecordRowID := RecNoBuf;
          pTRecInfo(cc + FRecordSize).UpdateStatus := usUnmodified;
          Move(RecBuf^, cc^, FRecordSize);
        end else begin
          {$IFDEF DELPHI2009}
          InternalInitRecord(pByte(FTempRecord));
          {$ELSE}
          InternalInitRecord(FTempRecord);
          {$ENDIF}
          Move(FTempRecord^, Buffer^, RecordBufferSize);
          pTRecInfo(FTempRecord + FRecordSize).BookmarkFlag := bfBOF;
          pTRecInfo(FTempRecord + FRecordSize).RecordRowID := 0;
          pTRecInfo(FTempRecord + FRecordSize).UpdateStatus := usUnmodified;
          Result := grBOF;
        end;
      end;
  end;
  if Result = grOK then
    begin
      {$IFDEF DELPHI2009}
        {$IFDEF DELPHIXE4}
      GetCalcFields(TRecBuf(Buffer));
        {$ELSE}
      GetCalcFields(pByte(Buffer));
        {$ENDIF DELPHIXE4}
      {$ELSE}
      GetCalcFields(Buffer);
      {$ENDIF DELPHI2009}
    end;
end;

function TVKSmartDBF.GetRecordCount: Integer;
begin
  //if LockHeader then
  //  try
      DBFHeader.last_rec := ( (DBFHandler.Seek(0, 2) - DBFHeader.data_offset) div DBFHeader.rec_size );
  //  finally
  //    UnLockHeader;
  //  end;
  Result := DBFHeader.last_rec;
end;

function TVKSmartDBF.GetRecordSize: Word;
begin
  Result := FRecordSize;
end;

function TVKSmartDBF.GetStateFieldValue(State: TDataSetState;
  Field: TField): Variant;
begin
  Result := NULL;
  if State in [dsNewValue, dsCurValue, dsOldValue] then
    Result := inherited GetStateFieldValue(State, Field);
end;

procedure TVKSmartDBF.CloseTmpRecord;
begin
  FTmpActive := false;
  FFastPostRecord := FLastFastPostRecord;
end;

procedure TVKSmartDBF.SetTmpRecord(nRec: DWORD);
begin
  DBFHandler.Seek(DBFHeader.data_offset + (nRec - 1) * DWORD(FRecordSize), soFromBeginning);
  DBFHandler.Read(FTempRecord^, FRecordSize);
  if Crypt.Active then
     Crypt.Decrypt(nRec, Pointer(FTempRecord), FRecordSize);
  {$IFDEF DELPHI2009}
  SetBookmarkData(pByte(FTempRecord), @nRec);
  SetBookmarkFlag(pByte(FTempRecord), bfCurrent);
  {$ELSE}
  SetBookmarkData(FTempRecord, @nRec);
  SetBookmarkFlag(FTempRecord, bfCurrent);
  {$ENDIF}
  FTmpActive := true;
  FLastFastPostRecord := FFastPostRecord;
  FFastPostRecord := true;
end;

procedure TVKSmartDBF.AddRecord(const Values: variant);
var
  i, j: Integer;
begin
  {$IFDEF DELPHI2009}
  InternalInitRecord(pByte(FTempRecord));
  {$ELSE}
  InternalInitRecord(FTempRecord);
  {$ENDIF}
  FTmpActive := true;
  FLastFastPostRecord := FFastPostRecord;
  FFastPostRecord := true;
  try
    j := VarArrayHighBound(Values, 1);
    for i := 0 to j do
      Fields[i].AsVariant := Values[i];
    InternalAddRecord(FTempRecord, true);
  finally
    FTmpActive := false;
    FFastPostRecord := FLastFastPostRecord;
  end;
end;

procedure TVKSmartDBF.AddRecord(ne: TNotifyEvent);
begin
  {$IFDEF DELPHI2009}
  InternalInitRecord(pByte(FTempRecord));
  {$ELSE}
  InternalInitRecord(FTempRecord);
  {$ENDIF}
  FTmpActive := true;
  FLastFastPostRecord := FFastPostRecord;
  FFastPostRecord := true;
  try
    if Assigned(ne) then ne(self);
    InternalAddRecord(FTempRecord, true);
  finally
    FTmpActive := false;
    FFastPostRecord := FLastFastPostRecord;
  end;
end;

procedure TVKSmartDBF.BeginAddRecord;
begin
  {$IFDEF DELPHI2009}
  InternalInitRecord(pByte(FTempRecord));
  {$ELSE}
  InternalInitRecord(FTempRecord);
  {$ENDIF}
  FTmpActive := true;
  FLastFastPostRecord := FFastPostRecord;
  FFastPostRecord := true;
end;

procedure TVKSmartDBF.EndAddRecord;
begin
  InternalAddRecord(FTempRecord, true);
  FTmpActive := false;
  FFastPostRecord := FLastFastPostRecord;
end;

procedure TVKSmartDBF.AddRecord(const Values: array of const);
begin
  {$IFDEF DELPHI2009}
  InternalInitRecord(pByte(FTempRecord));
  {$ELSE}
  InternalInitRecord(FTempRecord);
  {$ENDIF}
  FTmpActive := true;
  FLastFastPostRecord := FFastPostRecord;
  FFastPostRecord := true;
  try
    SetFields(Values);
    InternalAddRecord(FTempRecord, true);
  finally
    FTmpActive := false;
    FFastPostRecord := FLastFastPostRecord;
  end;
end;

procedure TVKSmartDBF.InternalAddRecord(Buffer: Pointer; Append: Boolean);
var
  i, RealRead, l, r: Integer;
  lpMsgBuf: array [0..500] of AnsiChar;
  le: DWORD;
  NewR: Longint;
  NewKey: AnsiString;
  b: boolean;
  cc: pAnsiChar;
  oFld: TField;
begin

  CheckActive;
  if FAddBuffered then begin

    // Set AutoInc fields
    if FDBFFieldDefs.IsThereAutoInc then begin
      if LockHeader then begin
        try
          FTmpCurrentEditBuffer := Buffer;
          FAlwaysSetFieldData := True;
          try
            for i := 0 to pred(Fields.Count) do begin
              oFld := Fields[i];
              if oFld.DataType = ftAutoInc then begin
                oFld.AsInteger := GetNextAutoInc(oFld.FieldNo, 2);
              end;
            end;
          finally
            FAlwaysSetFieldData := False;
            FTmpCurrentEditBuffer := nil;
          end;
        finally
          UnLockHeader;
        end;
      end else
        raise Exception.Create('TVKSmartDBF.InternalAddRecord: Can not lock DBF header.');
    end;
    //

    if FAddBufferCurrent = FAddBufferCount - 1 then FlushAddBuffer;
    Inc(FAddBufferCurrent);
    cc := FAddBuffer + FAddBufferCurrent * DBFHeader.rec_size;
    Move(Buffer^, cc^, DBFHeader.rec_size);
    Changed := True;

  end else begin
    b := false;
    if LockHeader then begin
      try

        // Set AutoInc fields
        if FDBFFieldDefs.IsThereAutoInc then begin
          FTmpCurrentEditBuffer := Buffer;
          FAlwaysSetFieldData := True;
          try
            for i := 0 to pred(Fields.Count) do begin
              oFld := Fields[i];
              if oFld.DataType = ftAutoInc then begin
                oFld.AsInteger := GetNextAutoInc(oFld.FieldNo, 2);
              end;
            end;
          finally
            FAlwaysSetFieldData := False;
            FTmpCurrentEditBuffer := nil;
          end;
        end;
        //

        DBFHeader.last_rec := ( (DBFHandler.Seek(0, 2) - DBFHeader.data_offset) div DBFHeader.rec_size );
        NewR := DBFHeader.last_rec + 1;
        if ReccordLockInternal(NewR, false) then begin
          try
            pTRecInfo(pAnsiChar(Buffer) + FRecordSize).RecordRowID := NewR;
            DBFHandler.Seek(DBFHeader.data_offset + LongWord(DBFHeader.last_rec * FRecordSize), 0);
            //Crypt
            if Crypt.Active then begin
              Move(Buffer^, FCryptBuff^, DBFHeader.rec_size);
              Crypt.Encrypt(NewR, FCryptBuff, DBFHeader.rec_size);
              RealRead := DBFHandler.Write(FCryptBuff^, DBFHeader.rec_size);
            end else
              RealRead := DBFHandler.Write(Buffer^, DBFHeader.rec_size);
            if RealRead = -1 then
            begin
              le := GetLastError();
              FormatMessageA(
                  FORMAT_MESSAGE_FROM_SYSTEM,
                  nil,
                  le,
                  0, // Default language
                  lpMsgBuf,
                  500,
                  nil
              );
              raise Exception.Create('TVKSmartDBF: ' + lpMsgBuf);
            end else begin
              Inc(DBFHeader.last_rec);
              DBFHandler.Seek(0, 0); //go to the begin
              RealRead := DBFHandler.Write(DBFHeader, SizeOf(DBFHeader));
              if RealRead = -1 then
              begin
                le := GetLastError();
                FormatMessageA(
                    FORMAT_MESSAGE_FROM_SYSTEM,
                    nil,
                    le,
                    0, // Default language
                    lpMsgBuf,
                    500,
                    nil
                );
                raise Exception.Create('TVKSmartDBF: ' + lpMsgBuf);
              end else begin
                l := DBFHeader.last_rec;
                if Indexes <> nil then
                  for i := 0 to Indexes.Count - 1 do begin
                    NewKey := Indexes[i].EvaluteKeyExpr;

                    //if  (Indexes.ActiveObject <> nil) and
                    //    (Indexes.ActiveObject = Indexes[i]) and
                    //    (Indexes[i].IsRanged) and
                    //    (not Indexes[i].InRange(NewKey)) then b := true;

                    if  not (
                      ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or
                      ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) or
                      FFileLock
                        ) then begin
                      if Indexes[i].FLock then
                        try
                          Indexes[i].StartUpdate(false);
                          Indexes[i].AddKey(NewKey, DBFHeader.last_rec);
                        finally
                          Indexes[i].Flush;
                          Indexes[i].FUnLock;
                        end
                      else
                        raise Exception.Create('TVKSmartDBF.InternalAddRecord: Can not add key to index file (FLock is false).');
                    end else begin
                      if Indexes[i].FLock then
                        try
                          Indexes[i].AddKey(NewKey, DBFHeader.last_rec);
                        finally
                          Indexes[i].FUnLock;
                        end
                      else
                        raise Exception.Create('TVKSmartDBF.InternalAddRecord: Can not add key to index file (FLock is false).');
                    end;

                    if  ( Indexes.ActiveObject <> nil ) and
                        ( Indexes.ActiveObject = Indexes[i] ) and
                        ( Indexes.ActiveObject.IsUniqueIndex or Indexes.ActiveObject.IsForIndex ) and
                        ( not FFastPostRecord ) then begin
                        r := Indexes.ActiveObject.FindKey(NewKey, true);
                        if r <> 0 then begin
                          if r <> l then l := r;
                        end else begin
                          InternalFirst;
                          b := true;
                        end;
                    end;

                  end;
                if not FFastPostRecord then
                  if not b then begin
                    GetBufferByRec(l);
                    RefreshBufferByRec(l);
                  end;
              end;
              Changed := True;
            end;
          finally
            RUnLock(NewR);
          end
        end else
          raise Exception.Create('TVKSmartDBF.InternalAddRecord: Can not lock DBF record.');
      finally
        UnLockHeader;
      end
    end else
      raise Exception.Create('TVKSmartDBF.InternalAddRecord: Can not lock DBF header.');
  end;
end;

procedure TVKSmartDBF.DoBeforeClose;
begin
  EndAddBuffered;
  inherited DoBeforeClose;
end;

procedure TVKSmartDBF.InternalClose;
var
  i: Integer;
  end1a: Byte;
begin
  try
    if Indexes <> nil then
      for i := 0 to Indexes.Count - 1 do Indexes[i].Flush;
    {$IFDEF DELPHI2009}
    FreeRecordBuffer(pByte(FBuffer));
    {$ELSE}
    FreeRecordBuffer(FBuffer);
    {$ENDIF}
    FRecordsPerBuf := 0;
    FBuffer := nil;
    VKDBFMemMgr.oMem.FreeMem(FBufInd);
    VKDBFMemMgr.oMem.FreeMem(FLocateBuffer);
    FBufInd := nil;
    FBufCnt := 0;
    FBufDir := bdFromTop;
    {$IFDEF DELPHI2009}
    FreeRecordBuffer(pByte(FTempRecord));
    FreeRecordBuffer(pByte(FFilterRecord));
    FreeRecordBuffer(pByte(FSetKeyBuffer));
    FreeRecordBuffer(pByte(FCryptBuff));
    {$ELSE}
    FreeRecordBuffer(FTempRecord);
    FreeRecordBuffer(FFilterRecord);
    FreeRecordBuffer(FSetKeyBuffer);
    FreeRecordBuffer(pAnsiChar(FCryptBuff));
    {$ENDIF}
    BindFields(false);
    if DefaultFields then DestroyFields;
    if FIndexes <> nil then FIndexes.CloseAll;
  finally
    CloseLobStream;
    if DBFHandler.IsOpen then begin
      //Add 1A at end dbf file
      if AccessMode.OpenReadWrite then begin
        DBFHandler.Seek(0, 2);
        DBFHandler.Seek(-1, 1);
        end1a := 0;
        DBFHandler.Read(end1a, 1);
        if end1a <> $1A then begin
          end1a := $1A;
          DBFHandler.Seek(0, 2);
          DBFHandler.Write(end1a, 1);
        end;
      end;
      DBFHandler.Close;
    end;
  end;
end;

procedure TVKSmartDBF.DeleteRecallRecord(Del: boolean = true);
var
  l, fOffset: Integer;

  ActiveBuf: pAnsiChar;
  RealRead: Integer;

  lpMsgBuf: array [0..500] of AnsiChar;
  le: DWORD;

begin
  CheckActive;
  if GetActiveRecBuf(ActiveBuf) then begin
    if Del then
      ActiveBuf[0] := #42   //'*'
    else
      ActiveBuf[0] := #32;  //' '
    l := pTRecInfo(ActiveBuf + RecordSize).RecordRowID;
    fOffset := DBFHandler.Seek(0, 1);
    if ReccordLockInternal(l, false) then
      try
        DBFHandler.Seek(DBFHeader.data_offset + LongWord((l - 1) * FRecordSize), 0);
        //Crypt
        if Crypt.Active then begin
          Move(ActiveBuf^, FCryptBuff^, DBFHeader.rec_size);
          Crypt.Encrypt(l, FCryptBuff, DBFHeader.rec_size);
          RealRead := DBFHandler.Write(FCryptBuff^, DBFHeader.rec_size);
        end else
          RealRead := DBFHandler.Write(ActiveBuf^, DBFHeader.rec_size);
        Move(ActiveBuf^, (FBuffer + GetCurIndByRec(l) * FRecordSize)^, FRecordSize);
        if RealRead = -1 then
        begin
          le := GetLastError();
          FormatMessageA(
              FORMAT_MESSAGE_FROM_SYSTEM,
              nil,
              le,
              0, // Default language
              lpMsgBuf,
              500,
              nil
          );
          raise Exception.Create('TVKSmartDBF: ' + lpMsgBuf);
        end else begin
          if not FFastPostRecord then begin
            //GetBufferByRec(l);
            RefreshBufferByRec(l);
            SetModified(true);
            DataEvent(deRecordChange, 0);
          end;
        end;
      finally
        RUnLock(l);
        DBFHandler.Seek(fOffset, 0);
      end
    else
      raise Exception.Create('TVKSmartDBF.InternalPost: Can not lock DBF record.');
  end;
end;


procedure TVKSmartDBF.InternalDelete;
begin
  DeleteRecallRecord;
end;

procedure TVKSmartDBF.DeleteRecord;
begin
  DeleteRecallRecord;
end;

procedure TVKSmartDBF.RecallRecord;
begin
  DeleteRecallRecord(false);
end;

procedure TVKSmartDBF.Pack(TmpInCurrentPath: boolean = false);
var
  RecPareBuf, i, j, k: Integer;
  ReadSize, RealRead, RealWrite, BufCnt, BufCntPack: Integer;
  Rec, RecPack: Integer;
  Offset, OffsetPack: Integer;
  IndPackBuf: pAnsiChar;
  LobName: AnsiString;
  TempLobName: AnsiString;
  lb: TStream;
  LobFieldsNum: TList;
  DataSetFieldsNum: TList;
  NstDSet: TVKNestedDBF;
  BlobFld: TBlobField;
  DataSetFld: TDataSetField;
begin
  CheckActive;
  if State = dsEdit then Post;
  if LockHeader then begin
    PackLobHandlerCreate;
    LobFieldsNum := TList.Create;
    DataSetFieldsNum := TList.Create;
    try

      FPackProcess := true;

      if LobHandler.IsOpen then begin

        //Create new LOB
        if FLobVersion in [xFoxPro..xVisualFoxPro] then
          LobName := ChangeFileExt(DBFFileName, '.fpt')
        else
          LobName := ChangeFileExt(DBFFileName, '.dbt');
        if TmpInCurrentPath then  //if TmpInCurrentPath = True then create TmpLob in current path
          TempLobName := GetTmpFileName(ExtractFilePath(DBFFileName))
        else  // else in system temporary directory
          TempLobName := GetTmpFileName;

        PackLobHandlerOpen(TempLobName);

        for k := 0 to FieldCount - 1 do begin
          if Fields[k].IsBlob then
            LobFieldsNum.Add(Pointer(k));
          if Fields[k].DataType = ftDataSet then
            DataSetFieldsNum.Add(Pointer(k));
        end;
      end;

      if Indexes <> nil then
        for j := 0 to Indexes.Count - 1 do Indexes.Items[j].BeginCreateIndexProcess;

      IndState := true;
      try
        RecPareBuf := FBufferSize div Header.rec_size;
        if RecPareBuf >= 1 then begin
          ReadSize := RecPareBuf * Header.rec_size;

          Offset := Header.data_offset;
          OffsetPack := Header.data_offset;
          Rec := 0;
          RecPack := 0;

          repeat

            Handle.Seek(Offset, 0);
            RealRead := Handle.Read(FLocateBuffer^, ReadSize);
            Inc(Offset, RealRead);

            BufCntPack := 0;
            BufCnt := RealRead div Header.rec_size;
            for i := 0 to BufCnt - 1 do begin
              IndRecBuf := FLocateBuffer + Header.rec_size * i;
              if Crypt.Active then
                Crypt.Decrypt(Rec + 1, Pointer(IndRecBuf), FRecordSize);
              Inc(Rec);
              if IndRecBuf[0] = #32 then begin (* If not Deleted *)
                //Lob copy from old to new location
                if LobHandler.IsOpen then begin
                  for k := 0 to LobFieldsNum.Count - 1 do
                    if Fields[Integer(LobFieldsNum.Items[k])].IsBlob then begin
                      BlobFld := TBlobField(Fields[Integer(LobFieldsNum.Items[k])]);
                      lb := CreateBlobStream(BlobFld, bmRead);
                      try
                        BlobFld.LoadFromStream(lb);
                      finally
                        lb.free;
                      end;
                    end;
                  for k := 0 to DataSetFieldsNum.Count - 1 do
                    if Fields[Integer(DataSetFieldsNum.Items[k])].DataType = ftDataSet then begin
                      DataSetFld := TDataSetField(Fields[Integer(DataSetFieldsNum.Items[k])]);
                      if not DataSetFld.IsNull then begin
                        NstDSet := TVKNestedDBF(DataSetFld.NestedDataSet);
                        NstDSet.Close;
                        NstDSet.Open;
                        NstDSet.Pack;
                      end;
                    end;
                end;
                //
                IndPackBuf := FLocateBuffer + Header.rec_size * BufCntPack;
                if IndRecBuf <> IndPackBuf then
                  Move(IndRecBuf^, IndPackBuf^, Header.rec_size);
                if Indexes <> nil then
                  for j := 0 to Indexes.Count - 1 do Indexes.Items[j].EvaluteAndAddKey(RecPack + 1);
                if Crypt.Active then
                  Crypt.Encrypt(RecPack + 1, Pointer(IndPackBuf), FRecordSize);
                Inc(BufCntPack);
                Inc(RecPack);
              end;
            end;

            if BufCntPack > 0 then begin
              Handle.Seek(OffsetPack, 0);
              RealWrite := Handle.Write(FLocateBuffer^, Header.rec_size * BufCntPack);
              Inc(OffsetPack, RealWrite);
            end;

          until ( BufCnt <= 0 );

          DBFHeader.last_rec := RecPack;
          Handle.Seek(0, 0);
          Handle.Write(DBFHeader, SizeOf(DBFHeader));
          Handle.Seek(OffsetPack, 0);
          Handle.SetEndOfFile;

          if LobHandler.IsOpen then
            PackLobHandlerClose(LobName, TempLobName);

        end else raise Exception.Create('TVKSmartDBF.Pack: Record size too large');

      finally
        if Indexes <> nil then
          for j := 0 to Indexes.Count - 1 do Indexes.Items[j].EndCreateIndexProcess;
        IndState := false;
        IndRecBuf := nil;
        FPackProcess := false;
      end;

    finally
      PackLobHandlerDestroy;
      DataSetFieldsNum.Free;
      LobFieldsNum.Free;
      UnLockHeader;
      Refresh;
    end;
  end else
    raise Exception.Create('TVKSmartDBF.Pack: Can not lock DBF header.');
end;

procedure TVKSmartDBF.InternalFirst;
var
  i, RealRead: Integer;
begin
  FBOF := true;
  FEOF := false;
  FBufDir := bdFromTop;
  FCurInd := -1;
  if (FIndexes = nil) or (FIndexes.ActiveObject = nil) then begin
    DBFHandler.Seek(DBFHeader.data_offset, soFromBeginning);
    RealRead := DBFHandler.Read(FBuffer^, FRecordsPerBuf * FRecordSize);
    FBufCnt := RealRead div FRecordSize;
    for i := 0 to FBufCnt - 1 do begin
      pLongint(pAnsiChar(FBufInd) + i * SizeOf(LongInt))^ := i + 1;
      if Crypt.Active then
        Crypt.Decrypt(i + 1, Pointer(FBuffer + i * FRecordSize), FRecordSize);
    end;
    if FBufCnt = 0 then begin
      FBOF := true;
      FEOF := true;
    end;
  end else begin
    if FIndexes.ActiveObject.FLock then
      try
        FBufCnt := FIndexes.ActiveObject.FillFirstBufRecords(DBFHandler, FBuffer, FRecordsPerBuf, FRecordSize, FBufInd, DBFHeader.data_offset);
      finally
        FIndexes.ActiveObject.FUnLock;
      end
    else
      raise Exception.Create('TDBFDataSet: Can not read from index file (FLock is false).');
  end;
end;

procedure TVKSmartDBF.InternalGotoBookmark(Bookmark: Pointer);
var
  i : Longint;
begin
  i := pTRecInfo(Bookmark).RecordRowID;
  GetBufferByRec(i);
end;

procedure TVKSmartDBF.InternalHandleException;
begin
  Application.HandleException(self);
end;

procedure TVKSmartDBF.HiddenInitFieldDefs(
  FDs: TFieldDefs;
  DBFFDs: TVKDBFFieldDefs;
  BeginOffset, BeginOffsetHD: Integer;
  NamePrefix: AnsiString = '';
  CreateFieldDef: boolean = true);
var
  DBFField: FIELD_REC;
  dbOffset, dbOffsetHD: Integer;
  dbSize: Integer;
  FD, CFD: TFieldDef;
  DBFFD: TVKDBFFieldDef;
  s: AnsiString;
  VFPNullsCounter: Word;
begin
  CFD := TFieldDef.Create(nil);
  DBFField := FIELD_REC.Create;
  DBFField.FIELD_REC_VER := FDbfVersion;
  try
    dbOffset := BeginOffset;
    dbOffsetHD := BeginOffsetHD;
    VFPNullsCounter := 0;
    while true do
    begin
      DBFHandler.Read(DBFField.FIELD_REC_STRUCT^, DBFField.FFIELD_REC_SIZE);
      if DBFField.field_name[0] = #13 then break;
      dbSize := 0;
      if CreateFieldDef then
        FD := FDs.AddFieldDef
      else
        FD := CFD;
      TranslateBuff(DBFField.field_name, DBFField.field_name, false, DBFField.MaxFieldNameSize);
      s := UpperCase(Trim(DBFField.field_name));
      with FD do begin
        Name := NamePrefix + s;
        Required := false;
      end;
      DBFFD := TVKDBFFieldDef(DBFFDs.Add);
      DBFFD.dBaseVersion := FDbfVersion;
      DBFFD.FieldFlag.FieldFlag := DBFField.FieldFlag;
      with DBFFD do begin
        Name          := s;
        field_type    := DBFField.field_type;
        extend_type   := DBFField.extend_type;
        if field_type <> 'E' then
          extend_type := dbftUndefined;
        FOff          := dbOffset;
        FOffHD        := dbOffsetHD;
        if dBaseVersion = xVisualFoxPro then begin
          if FieldFlag.CanStoreNull then begin
            FVFPNullNumber     := VFPNullsCounter;
            FVFPNullByteNumber := FVFPNullNumber div 8;
            FVFPNullBitMask  := 1 shl ( FVFPNullNumber mod 8 );
            Inc(VFPNullsCounter);
          end;
        end;
        if CreateFieldDef then
          FFieldDefRef  := FD
        else
          FFieldDefRef  := nil;
      end;
      //
      case DBFField.field_type of
        '0':
          begin
            FD.DataType := ftBytes;
            FD.Size := DBFField.lendth.char_len;
            dbSize := DBFField.lendth.char_len;
            FD.Precision := 0;
            DBFFD.FLen    := dbSize;
            DBFFD.Fdec   := 0;
            if s = '_NULLFLAGS' then begin
              DBFFDs.FVFPNullsOffset := dbOffset;
              DBFFDs.FVFPNullsLength := dbSize;
            end;
          end;
        'T':
          begin
            if FDbfVersion < xVisualFoxPro then
              raise Exception.Create('TVKSmartDBF.HiddenInitFieldDefs: DBF Version must be xVisualFoxPro or greater for field type "T"!');
            FD.DataType := ftDateTime;
            dbSize := 8;
            DBFFD.FLen   := 8;
            DBFFD.Fdec   := 0;
          end;
        'Y':
          begin
            if FDbfVersion < xVisualFoxPro then
              raise Exception.Create('TVKSmartDBF.HiddenInitFieldDefs: DBF Version must be xVisualFoxPro or greater for field type "Y"!');
            FD.DataType := ftCurrency;
            dbSize := 8;
            DBFFD.FLen   := 25;
            DBFFD.Fdec   := 4;
          end;
        'C':
          begin
            if  ( DbfVersion = xVisualFoxPro ) and
                ( DBFFD.FieldFlag.BinaryColumn ) then
              FD.DataType := ftBytes
            else
              FD.DataType := ftString;
            FD.Size := DBFField.lendth.char_len;
            dbSize := DBFField.lendth.char_len;
            FD.Precision := 0;
            DBFFD.FLen    := dbSize;
            DBFFD.Fdec   := 0;
          end;
        'N', 'F':
          begin
            //if DBFField.field_type = 'F' then
            //  if FDbfVersion < xBaseIV then
            //    raise Exception.Create('TVKSmartDBF.HiddenInitFieldDefs: DBF Version must be greater then xBaseIII for field type "F"!');
            if DBFField.lendth.num_len.dec = 0 then
            begin
              if DBFField.lendth.num_len.len < 10 then begin
                FD.DataType := ftInteger;
                FD.Size := 0;
                dbSize := DBFField.lendth.num_len.len;
                FD.Precision := 0;
              end else begin
                FD.DataType := ftLargeint;
                FD.Size := 0;
                dbSize := DBFField.lendth.num_len.len;
                FD.Precision := 0;
              end;
            end else begin
              FD.DataType := ftFloat;
              FD.Size := 0;
              dbSize := DBFField.lendth.num_len.len;
              FD.Precision := DBFField.lendth.num_len.dec;
            end;
            DBFFD.FLen   := dbSize;
            DBFFD.Fdec   := FD.Precision;
          end;
        'D':
          begin
            FD.DataType := ftDate;
            FD.Size := 0;
            dbSize := 8;
            FD.Precision := 0;
            DBFFD.FLen   := 8;
            DBFFD.Fdec   := 0;
          end;
        'L':
          begin
            FD.DataType := ftBoolean;
            FD.Size := 0;
            dbSize := 1;
            FD.Precision := 0;
            DBFFD.FLen   := 1;
            DBFFD.Fdec   := 0;
          end;
        'P':
          begin
            if FDbfVersion < xFoxPro then
              raise Exception.Create('TVKSmartDBF.HiddenInitFieldDefs: DBF Version must be xFoxPro or greater for field type "P"!');
            if DbfVersion = xVisualFoxPro then begin
              FD.DataType := ftGraphic;
              FD.Size := 0;
              dbSize := 4;
              FD.Precision := 0;
              DBFFD.FLen   := 4;
              DBFFD.Fdec   := 0;
            end else begin
              FD.DataType := ftGraphic;
              FD.Size := 0;
              dbSize := 10;
              FD.Precision := 0;
              DBFFD.FLen   := 10;
              DBFFD.Fdec   := 0;
            end;
          end;
        'M':
          begin
            if DbfVersion = xVisualFoxPro then begin
              if DBFFD.FieldFlag.BinaryColumn then
                FD.DataType := ftBlob
              else
                FD.DataType := ftMemo;
              FD.Size := 0;
              dbSize := 4;
              FD.Precision := 0;
              DBFFD.FLen   := 4;
              DBFFD.Fdec   := 0;
            end else begin
              FD.DataType := ftMemo;
              FD.Size := 0;
              dbSize := 10;
              FD.Precision := 0;
              DBFFD.FLen   := 10;
              DBFFD.Fdec   := 0;
            end;
          end;
        'B', 'G':
          begin
            if FDbfVersion < xBaseIV then
              raise Exception.Create('TVKSmartDBF.HiddenInitFieldDefs: DBF Version must be greater then xBaseIII for field type "B" and "G"!');
            case DBFField.field_type of
              'B':
                begin
                  if DbfVersion = xVisualFoxPro then begin
                    FD.DataType := ftFloat;
                    dbSize := 8;
                    DBFFD.FLen   := 34;
                    DBFFD.Fdec   := 16;
                  end else begin
                    FD.DataType := ftBlob;
                    FD.Size := 0;
                    dbSize := 10;
                    FD.Precision := 0;
                    DBFFD.FLen   := 10;
                    DBFFD.Fdec   := 0;
                  end;
                end;
              'G':
                begin
                  if DbfVersion = xVisualFoxPro then begin
                    FD.DataType := ftParadoxOle;
                    FD.Size := 0;
                    dbSize := 4;
                    FD.Precision := 0;
                    DBFFD.FLen   := 4;
                    DBFFD.Fdec   := 0;
                  end else begin
                    FD.DataType := ftGraphic;
                    FD.Size := 0;
                    dbSize := 10;
                    FD.Precision := 0;
                    DBFFD.FLen   := 10;
                    DBFFD.Fdec   := 0;
                  end;
                end;
            end;
          end;
        '+', 'I', 'O', '@':
          begin
            if not ( FDbfVersion in [xBaseVII..xBaseVII, xVisualFoxPro] ) then
              raise Exception.Create('TVKSmartDBF.HiddenInitFieldDefs: DBF Version must be greater then xBaseV for field type "+", "I", "O" and "@"!');
            case DBFField.field_type of
              '+':
                begin
                  DBFFDs.IsThereAutoInc := True;
                  FD.DataType := ftAutoInc;
                  dbSize := 4;
                  DBFFD.FLen   := 11;
                  DBFFD.Fdec   := 0;
                end;
              'I':
                begin
                  if FDbfVersion = xVisualFoxPro then begin
                    if DBFFD.FieldFlag.AutoIncrement then begin
                      DBFFDs.IsThereAutoInc := True;
                      FD.DataType := ftAutoInc;
                    end else
                      FD.DataType := ftInteger;
                  end else begin
                    FD.DataType := ftInteger;
                  end;
                  dbSize := 4;
                  DBFFD.FLen   := 11;
                  DBFFD.Fdec   := 0;
                end;
              'O':
                begin
                  FD.DataType := ftFloat;
                  dbSize := 8;
                  DBFFD.FLen   := 21;
                  DBFFD.Fdec   := 0;
                end;
              '@':
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 8;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
            end;
          end;
        'E':    //Extended types
          begin
            case DBFField.extend_type of
              dbftS1:       //Shortint
                begin
                  FD.DataType := ftSmallint;
                  dbSize := 1;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;
                end;
              dbftU1:       //Byte
                begin
                  FD.DataType := ftWord;
                  dbSize := 1;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;
                end;
              dbftU1_NB:       //Byte with null bit instead of sign bit
                begin
                  FD.DataType := ftWord;
                  dbSize := 1;
                  DBFFD.FLen   := 3;
                  DBFFD.Fdec   := 0;
                end;
              dbftU2_NB:       //Byte with null bit instead of sign bit
                begin
                  FD.DataType := ftWord;
                  dbSize := 2;
                  DBFFD.FLen   := 5;
                  DBFFD.Fdec   := 0;
                end;
              dbftS2:       //Smallint
                begin
                  FD.DataType := ftSmallint;
                  dbSize := 2;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftU2:       //Word
                begin
                  FD.DataType := ftWord;
                  dbSize := 2;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftS4:       //Longint
                begin
                  FD.DataType := ftInteger;
                  dbSize := 4;
                  DBFFD.FLen   := 11;
                  DBFFD.Fdec   := 0;
                end;
              dbftU4:       //Longword
                begin
                  FD.DataType := ftInteger;
                  dbSize := 4;
                  DBFFD.FLen   := 11;
                  DBFFD.Fdec   := 0;
                end;
              dbftU4_NB:       //
                begin
                  FD.DataType := ftInteger;
                  dbSize := 4;
                  DBFFD.FLen   := 10;
                  DBFFD.Fdec   := 0;
                end;
              dbftS8:       //Int64
                begin
                  FD.DataType := ftLargeint;
                  dbSize := 8;
                  DBFFD.FLen   := 21;
                  DBFFD.Fdec   := 0;
                end;
              dbftR4:       //Single
                begin
                  FD.DataType := ftFloat;
                  dbSize := 4;
                  DBFFD.FLen   := 18;
                  DBFFD.Fdec   := 8;
                end;
              dbftR4_NB:
                begin
                  FD.DataType := ftFloat;
                  dbSize := 4;
                  DBFFD.FLen   := 18;
                  DBFFD.Fdec   := 8;
                end;
              dbftR6_NB:
                begin
                  FD.DataType := ftFloat;
                  dbSize := 6;
                  DBFFD.FLen   := 26;
                  DBFFD.Fdec   := 12;
                end;
              dbftR8_NB:
                begin
                  FD.DataType := ftFloat;
                  dbSize := 8;
                  DBFFD.FLen   := 34;
                  DBFFD.Fdec   := 16;
                end;
              dbftR6:       //Real48
                begin
                  FD.DataType := ftFloat;
                  dbSize := 6;
                  DBFFD.FLen   := 26;
                  DBFFD.Fdec   := 12;
                end;
              dbftR8:       //Double
                begin
                  FD.DataType := ftFloat;
                  dbSize := 8;
                  DBFFD.FLen   := 34;
                  DBFFD.Fdec   := 16;
                end;
              dbftR10:      //Extended
                begin
                  FD.DataType := ftFloat;
                  dbSize := 10;
                  DBFFD.FLen   := 42;
                  DBFFD.Fdec   := 20;
                end;
              dbftD1:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 8;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD1_NB:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 8;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD2:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 8;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD2_NB:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 8;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD3:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 6;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD3_NB:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 6;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftS1_N:     //Shortint with NULL
                begin
                  FD.DataType := ftSmallint;
                  dbSize := 2;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;
                end;
              dbftU1_N:     //Byte  with NULL
                begin
                  FD.DataType := ftWord;
                  dbSize := 2;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;
                end;
              dbftS2_N:     //Smallint with NULL
                begin
                  FD.DataType := ftSmallint;
                  dbSize := 3;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftU2_N:     //Word with NULL
                begin
                  FD.DataType := ftWord;
                  dbSize := 3;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftS4_N:     //Longint with NULL
                begin
                  FD.DataType := ftInteger;
                  dbSize := 5;
                  DBFFD.FLen   := 11;
                  DBFFD.Fdec   := 0;
                end;
              dbftU4_N:     //Longword with NULL
                begin
                  FD.DataType := ftInteger;
                  dbSize := 5;
                  DBFFD.FLen   := 11;
                  DBFFD.Fdec   := 0;
                end;
              dbftS8_N:     //Int64 with NULL
                begin
                  FD.DataType := ftLargeint;
                  dbSize := 9;
                  DBFFD.FLen   := 21;
                  DBFFD.Fdec   := 0;
                end;
              dbftR4_N:     //Single with NULL
                begin
                  FD.DataType := ftFloat;
                  dbSize := 5;
                  DBFFD.FLen   := 18;
                  DBFFD.Fdec   := 8;
                end;
              dbftR6_N:     //Real48 with NULL
                begin
                  FD.DataType := ftFloat;
                  dbSize := 7;
                  DBFFD.FLen   := 26;
                  DBFFD.Fdec   := 12;
                end;
              dbftR8_N:     //Double with NULL
                begin
                  FD.DataType := ftFloat;
                  dbSize := 9;
                  DBFFD.FLen   := 34;
                  DBFFD.Fdec   := 16;
                end;
              dbftR10_N:     //Extended with NULL
                begin
                  FD.DataType := ftFloat;
                  FD.Size := 11;
                  dbSize := 11;
                  DBFFD.FLen   := 42;
                  DBFFD.Fdec   := 20;
                end;
              dbftD1_N:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 9;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD2_N:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 9;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftD3_N:
                begin
                  FD.DataType := ftDateTime;
                  dbSize := 7;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftDate:
                begin
                  FD.DataType := ftDate;
                  dbSize := 4;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftDate_N:
                begin
                  FD.DataType := ftDate;
                  dbSize := 5;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftDate_NB:
                begin
                  FD.DataType := ftDate;
                  dbSize := 4;
                  DBFFD.FLen   := 8;
                  DBFFD.Fdec   := 0;
                end;
              dbftTime:
                begin
                  FD.DataType := ftTime;
                  dbSize := 4;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftTime_NB:
                begin
                  FD.DataType := ftTime;
                  dbSize := 4;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftTime_N:
                begin
                  FD.DataType := ftTime;
                  dbSize := 5;
                  DBFFD.FLen   := 6;
                  DBFFD.Fdec   := 0;
                end;
              dbftClob, dbftFmtMemo:
                begin
                  FD.DataType := ftMemo;
                  FD.Size := 0;
                  dbSize := 10;
                  FD.Precision := 0;
                  DBFFD.FLen   := 10;
                  DBFFD.Fdec   := 0;
                  if FLobVersion in [xVisualFoxPro] then begin
                    dbSize := 4;
                    DBFFD.FLen   := 4;
                  end;
                end;
              dbftBlob, dbftGraphic:
                begin
                  FD.DataType := ftBlob;
                  FD.Size := 0;
                  dbSize := 10;
                  FD.Precision := 0;
                  DBFFD.FLen   := 10;
                  DBFFD.Fdec   := 0;
                  if FLobVersion in [xVisualFoxPro] then begin
                    dbSize := 4;
                    DBFFD.FLen   := 4;
                  end;
                end;
              dbftClob_NB, dbftFmtMemo_NB:
                begin
                  FD.DataType := ftMemo;
                  FD.Size := 0;
                  dbSize := 4;
                  FD.Precision := 0;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;
                end;
              dbftBlob_NB, dbftGraphic_NB:
                begin
                  FD.DataType := ftBlob;
                  FD.Size := 0;
                  dbSize := 4;
                  FD.Precision := 0;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;
                end;
              dbftString:
                begin
                  FD.DataType := ftString;
                  FD.Size := DBFField.lendth.Char_len;
                  dbSize := DBFField.lendth.char_len + 2;
                  FD.Precision := 0;
                  DBFFD.FLen   := DBFField.lendth.char_len;
                  DBFFD.Fdec   := 0;
                end;
              dbftString_N:
                begin
                  FD.DataType := ftString;
                  FD.Size := DBFField.lendth.char_len;
                  dbSize := DBFField.lendth.char_len + 3;
                  FD.Precision := 0;
                  DBFFD.FLen   := DBFField.lendth.char_len;
                  DBFFD.Fdec   := 0;
                end;
              dbftFixedChar:
                begin
                  FD.DataType := ftFixedChar;
                  FD.Size := DBFField.lendth.char_len;
                  dbSize := DBFField.lendth.char_len + 1;
                  FD.Precision := 0;
                  DBFFD.FLen   := DBFField.lendth.char_len;
                  DBFFD.Fdec   := 0;
                end;
              dbftWideString:
                begin
                  FD.DataType := ftWideString;
                  FD.Size := DBFField.lendth.char_len;
                  dbSize := DBFField.lendth.char_len * 2 + 5;
                  FD.Precision := 0;
                  DBFFD.FLen   := DBFField.lendth.char_len;
                  DBFFD.Fdec   := 0;
                end;
              dbftCurrency:
                begin
                  FD.DataType := ftCurrency;
                  dbSize := 8;
                  DBFFD.FLen   := 25;
                  DBFFD.Fdec   := 4;
                end;
              dbftCurrency_N:
                begin
                  FD.DataType := ftCurrency;
                  dbSize := 9;
                  DBFFD.FLen   := 25;
                  DBFFD.Fdec   := 4;
                end;
              dbftCurrency_NB:
                begin
                  FD.DataType := ftCurrency;
                  dbSize := 8;
                  DBFFD.FLen   := 25;
                  DBFFD.Fdec   := 4;
                end;
              dbftBCD:
                begin
                  FD.DataType := ftBCD;
                  dbSize := DBFField.lendth.num_len.len shr 1;
                  if ( DBFField.lendth.num_len.len and $01 ) = $01 then Inc(dbSize);
                  Inc(dbSize);
                  DBFFD.FLen   := 25;
                  DBFFD.Fdec   := 4;
                end;
              dbftDBFDataSet:
                begin
                  FD.DataType := ftDataSet;
                  FD.Size := 0;
                  dbSize := 10;
                  FD.Precision := 0;
                  DBFFD.FLen   := 10;
                  DBFFD.Fdec   := 0;
                  if FLobVersion in [xVisualFoxPro] then begin
                    dbSize := 4;
                    DBFFD.FLen   := 4;
                  end;

                  // Recursive call
                  if CreateFieldDef then
                    HiddenInitFieldDefs(  FD.ChildDefs,
                                          DBFFD.DBFFieldDefs,
                                          dbOffset + dbSize,
                                          dbOffsetHD + DBFField.FIELD_REC_SIZE,
                                          NamePrefix,
                                          False)
                  else
                    HiddenInitFieldDefs(  nil,
                                          DBFFD.DBFFieldDefs,
                                          dbOffset + dbSize,
                                          dbOffsetHD + DBFField.FIELD_REC_SIZE,
                                          NamePrefix,
                                          False);

                end;
              dbftDBFDataSet_NB:
                begin
                  FD.DataType := ftDataSet;
                  FD.Size := 0;
                  dbSize := 4;
                  FD.Precision := 0;
                  DBFFD.FLen   := 4;
                  DBFFD.Fdec   := 0;

                  // Recursive call
                  if CreateFieldDef then
                    HiddenInitFieldDefs(  FD.ChildDefs,
                                          DBFFD.DBFFieldDefs,
                                          dbOffset + dbSize,
                                          dbOffsetHD + DBFField.FIELD_REC_SIZE,
                                          NamePrefix,
                                          False)
                  else
                    HiddenInitFieldDefs(  nil,
                                          DBFFD.DBFFieldDefs,
                                          dbOffset + dbSize,
                                          dbOffsetHD + DBFField.FIELD_REC_SIZE,
                                          NamePrefix,
                                          False);

                end;
            end;
          end;
      end;
      //
      Inc(dbOffset, dbSize);
      Inc(dbOffsetHD, DBFField.FIELD_REC_SIZE);
    end;
  finally
    CFD.Free;
    FreeAndNil(DBFField);
  end;
end;

procedure TVKSmartDBF.InternalInitFieldDefs;
begin

  FieldDefs.Clear;
  FDBFFieldDefs.Clear;
  FDBFFieldDefs.FdbfVersion := FDbfVersion;
  FDBFFieldDefs.FIsThereAutoInc := False;
  FDBFFieldDefs.FVFPNullsOffset := 0;
  FDBFFieldDefs.FVFPNullsLength := 0;

  if not DBFHandler.IsOpen then
    raise Exception.Create('TVKSmartDBF.InternalInitFieldDefs: Can not define fields while DataSet is closed!');

  if FDbfVersion = xBaseVII then begin
    DBFHandler.Seek(SizeOf(DBF_HEAD) + SizeOf(AFTER_DBF_HEAD), soFromBeginning);
    HiddenInitFieldDefs(FieldDefs, FDBFFieldDefs, 1, SizeOf(DBF_HEAD) + SizeOf(AFTER_DBF_HEAD));
  end else begin
    DBFHandler.Seek(SizeOf(DBFHeader), soFromBeginning);
    HiddenInitFieldDefs(FieldDefs, FDBFFieldDefs, 1, SizeOf(DBFHeader));
  end;

end;

{$IFDEF DELPHI2009}
procedure TVKSmartDBF.InternalInitRecord(Buffer: TRecordBuffer);
{$ELSE}
procedure TVKSmartDBF.InternalInitRecord(Buffer: PAnsiChar);
{$ENDIF}
var
  i: Integer;
begin
  if Buffer <> nil then begin
    FillChar(Buffer^, RecordBufferSize, #32);
    for i := 0 to pred(FDBFFieldDefs.Count) do begin
      case FDBFFieldDefs[i].field_type of
        '0': FillChar((Buffer + FDBFFieldDefs[i].Offset)^, FDBFFieldDefs[i].len, #$FF);
        'T': FillChar((Buffer + FDBFFieldDefs[i].Offset)^, FDBFFieldDefs[i].len, #0);
        'Y': pCurrency(Buffer + FDBFFieldDefs[i].Offset)^ := 0;
        'I', '+': pInteger(Buffer + FDBFFieldDefs[i].Offset)^ := 0;
        '@', 'O': pInt64(Buffer + FDBFFieldDefs[i].Offset)^ := 0;
        'M', 'P', 'G':
          begin
            if FLobVersion in [xVisualFoxPro] then begin
              pInteger(Buffer + FDBFFieldDefs[i].Offset)^ := 0;
            end;
          end;
        'B':
          begin
            if FLobVersion in [xVisualFoxPro] then begin
              pDouble(Buffer + FDBFFieldDefs[i].Offset)^ := 0;
            end;
          end;
        'E':
          begin
            if FLobVersion in [xVisualFoxPro] then begin
              if FDBFFieldDefs[i].extend_type in [
                  dbftClob,
                  dbftBlob,
                  dbftGraphic,
                  dbftFmtMemo,
                  dbftClob_NB,
                  dbftBlob_NB,
                  dbftGraphic_NB,
                  dbftFmtMemo_NB,
                  dbftDBFDataSet,
                  dbftDBFDataSet_NB] then
                pInteger(Buffer + FDBFFieldDefs[i].Offset)^ := 0;
            end;
          end;
      end;
    end;
    pTRecInfo(Buffer + RecordSize).RecordRowID := 0;
    pTRecInfo(Buffer + RecordSize).UpdateStatus := usInserted;
    pTRecInfo(Buffer + RecordSize).BookmarkFlag := bfInserted;
  end;
end;

procedure TVKSmartDBF.InternalLast;
var
  j: Longint;
  i: Integer;
  LOff: Integer;
begin
  FBOF := false;
  FEOF := true;
  FBufDir := bdFromBottom;
  FCurInd := FRecordsPerBuf;
  if (FIndexes = nil) or (FIndexes.ActiveObject = nil) then begin
    LOff := DBFHandler.Seek(0, 2);
    //if LockHeader then
    //  try
        DBFHeader.last_rec := ( (LOff - DBFHeader.data_offset) div DBFHeader.rec_size );
    //  finally
    //    UnLockHeader;
    //  end
    if DBFHeader.last_rec <> 0 then begin
      j := DBFHeader.last_rec - FRecordsPerBuf + 1;
      if j < 1 then j := 1;
      FBufCnt := DBFHeader.last_rec - j + 1;
      DBFHandler.Seek(DBFHeader.data_offset + ((j - 1) * FRecordSize), soFromBeginning);
      DBFHandler.Read((FBuffer + (FRecordsPerBuf - FBufCnt) * FRecordSize)^, FBufCnt * FRecordSize);
      for i := 0 to FBufCnt - 1 do begin
        pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - i - 1)*SizeOf(Longint))^ := DBFHeader.last_rec - i;
        if Crypt.Active then
          Crypt.Decrypt(DBFHeader.last_rec - i, Pointer(FBuffer + (FRecordsPerBuf - i - 1) * FRecordSize), FRecordSize);
      end;
    end else begin
      FBOF := true;
      FEOF := true;
    end;
  end else begin
    if FIndexes.ActiveObject.FLock then
      try
        FBufCnt := FIndexes.ActiveObject.FillLastBufRecords(DBFHandler, FBuffer, FRecordsPerBuf, FRecordSize, FBufInd, DBFHeader.data_offset);
      finally
        FIndexes.ActiveObject.FUnLock;
      end
    else
      raise Exception.Create('TDBFDataSet: Can not read from index file (FLock is false).');
  end;
end;

procedure TVKSmartDBF.InternalOpen;
var
  i: Integer;
  b: boolean;
  oI: TIndex;
  AfterDBFHeader: AFTER_DBF_HEAD;

  procedure CloseAllInInternalOpen;
  begin
    {$IFDEF DELPHI2009}
    FreeRecordBuffer(pByte(FBuffer));
    {$ELSE}
    FreeRecordBuffer(FBuffer);
    {$ENDIF}
    FRecordsPerBuf := 0;
    FBuffer := nil;
    VKDBFMemMgr.oMem.FreeMem(FBufInd);
    FBufInd := nil;
    FBufCnt := 0;
    FBufDir := bdFromTop;
    BindFields(false);
    if DefaultFields then DestroyFields;
    DBFHandler.Close;
    FIndexes.CloseAll;
  end;

begin

  FLobHeaderLock := False;
  FFileHeaderLock := False;
  FFileLock := False;
  FLockRecords.Clear;

  CloseLobStream;
  DBFHandler.FileName := DBFFileName;
  DBFHandler.AccessMode.AccessMode := AccessMode.AccessMode;
  DBFHandler.ProxyStreamType := FStorageType;
  DBFHandler.OuterStream := FOuterStream;
  DBFHandler.OnLockEvent := FOnOuterStreamLock;
  DBFHandler.OnUnlockEvent := FOnOuterStreamUnlock;
  DBFHandler.Open;
  if not DBFHandler.IsOpen then begin
      raise Exception.Create('TVKSmartDBF.InternalOpen: Open error "' + DBFFileName + '"');
  end else begin
    DBFHandler.Seek(0, 0);
    DBFHandler.Read(DBFHeader, SizeOf(DBF_HEAD));
    FTableFlag.TableFlag := DBFHeader.TableFlag;
    case DBFHeader.dbf_id of
      $03:
        begin
          FDbfVersion := xBaseIII;
          FLobVersion := xUnknown;
        end;
      $07:
        begin
          FDbfVersion := xClipper;
          FLobVersion := xUnknown;
        end;
      $83:
        begin
          FDbfVersion := xBaseIII;
          FLobVersion := xBaseIII;
        end;
      $8B,$8E,$7B:
        begin
          FDbfVersion := xBaseIV;
          FLobVersion := xBaseIV;
        end;
      $04:
        begin
          FDbfVersion := xbaseVII;
          FLobVersion := xUnknown;
        end;
      $8C:
        begin
          FDbfVersion := xbaseVII;
          FLobVersion := xbaseVII;
        end;
      $30, $31:
        begin
          FDbfVersion := xVisualFoxPro;
          if FTableFlag.HasGotMemo then
            FLobVersion := xVisualFoxPro
          else
            FLobVersion := xUnknown;
        end;
      $F5:
        begin
          FDbfVersion := xFoxPro;
          FLobVersion := xFoxPro;
        end;
    else
      FDbfVersion := xUnknown;
      FLobVersion := xUnknown;
      DBFHandler.Close;
      raise Exception.Create('TVKSmartDBF.InternalOpen: File "' + DBFFileName + '" is not DBF file');
    end;
    if FDbfVersion in [xBaseV..xbaseVII] then begin
      DBFHandler.Read(AfterDBFHeader, SizeOf(AFTER_DBF_HEAD));
    end;
    FRecordSize := DBFHeader.rec_size;
    FBuffer := VKDBFMemMgr.oMem.GetMem(self, FBufferSize + 10);
    FRecordsPerBuf := FBufferSize div FRecordSize;
    if FRecordsPerBuf = 0 then
      raise Exception.Create('TVKSmartDBF.InternalOpen: BufferSize too small!');
    FBufCnt := 0;
    FBufDir := bdFromTop;
    FBufInd := VKDBFMemMgr.oMem.GetMem(self, FRecordsPerBuf * SizeOf(LongInt));
    FLocateBuffer := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);

    // Open Lob Stream, when we exactly known FDbfVersion
    OpenLobStream(DBFHeader.dbf_id);
    //

    // Define FieldDefs after open Lob storage because LobBlockSize needed
    FieldDefs.Updated := False;
    FieldDefs.Update;
    if DefaultFields then CreateFields;
    BindFields(True);
    BindDBFFieldDef;

    if FVKDBFCrypt.Active then begin
      FVKDBFCrypt.Active := false;
      FVKDBFCrypt.Active := true;
    end;
    b := true;
    if not FOpenWithoutIndexes then begin
      if FIndexes <> nil then begin
        for i := 0 to FIndexes.Count - 1 do begin
          if not FIndexes.Items[i].Open then begin
            b := false;
            CloseAllInInternalOpen;
            break;
          end;
        end;
        if b then begin
          for i := 0 to FDBFIndexDefs.Count - 1 do begin
            if not FDBFIndexDefs.Items[i].IsOpen then begin
              oI := TIndex(FIndexes.Add);
              oI.BagName := FDBFIndexDefs.Items[i].Name;
              if not oI.Open then begin
                b := false;
                CloseAllInInternalOpen;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
    if b then begin
      Changed := False;
      SetRngInt;
      InternalFirst;
      FTempRecord := pAnsiChar(AllocRecordBuffer);
      FFilterRecord := pAnsiChar(AllocRecordBuffer);
      FSetKeyBuffer := pAnsiChar(AllocRecordBuffer);
      FCryptBuff := pAnsiChar(AllocRecordBuffer);
      if Filtered and (Filter <> '') then
        FFilterParser.SetExprParams(Filter, FilterOptions, [poExtSyntax], '');
    end;
  end;
  FBOF := true;
  ObjectView := true;
  BookmarkSize := sizeof(Longword);
end;

procedure TVKSmartDBF.InternalPost;
var

  i, l, r: Integer;
  fOffset: Integer;
  ActiveBuf: pAnsiChar;
  RealRead: Integer;

  lpMsgBuf: array [0..500] of AnsiChar;
  le: DWORD;

  NewKey: AnsiString;

  b: boolean;
begin

  b := false;
  CheckActive;
  if GetActiveRecBuf(ActiveBuf) then begin
    l := pTRecInfo(ActiveBuf + RecordSize).RecordRowID;
    if State = dsEdit then
    begin
      fOffset := DBFHandler.Seek(0, 1);
      if ReccordLockInternal(l, false) then
        try
          DBFHandler.Seek(DBFHeader.data_offset + LongWord((l - 1) * FRecordSize), 0);
          //Crypt
          if Crypt.Active then begin
            Move(ActiveBuf^, FCryptBuff^, DBFHeader.rec_size);
            Crypt.Encrypt(l, FCryptBuff, DBFHeader.rec_size);
            RealRead := DBFHandler.Write(FCryptBuff^, DBFHeader.rec_size);
          end else
            RealRead := DBFHandler.Write(ActiveBuf^, DBFHeader.rec_size);
          if RealRead = -1 then
          begin
            le := GetLastError();
            FormatMessageA(
                FORMAT_MESSAGE_FROM_SYSTEM,
                nil,
                le,
                0, // Default language
                lpMsgBuf,
                500,
                nil
            );
            raise Exception.Create('TVKSmartDBF: ' + lpMsgBuf);
          end else begin
            Move(ActiveBuf^, (FBuffer + GetCurIndByRec(l) * FRecordSize)^, FRecordSize);
            if Indexes <> nil then
              for i := 0 to Indexes.Count - 1 do begin
                NewKey := Indexes[i].EvaluteKeyExpr;
                if NewKey <> Indexes[i].FOldEditKey then begin

                  //if  (Indexes.ActiveObject <> nil) and
                  //    (Indexes.ActiveObject = Indexes[i]) and
                  //    (Indexes[i].IsRanged) and
                  //    (not Indexes[i].InRange(NewKey)) then b := true;

                  if  not (
                    ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or
                    ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) or
                    FFileLock
                      ) then begin
                    if Indexes[i].FLock then
                      try
                        Indexes[i].StartUpdate(false);
                        Indexes[i].DeleteKey(Indexes[i].FOldEditKey, Indexes[i].FOldEditRec);
                        Indexes[i].AddKey(NewKey, l);
                      finally
                        Indexes[i].Flush;
                        Indexes[i].FUnLock;
                      end
                    else
                      raise Exception.Create('TDBFDataSet.InternalPost: Can not Delete/add key to index file (FLock is false).');
                  end else begin
                    if Indexes[i].FLock then
                      try
                        Indexes[i].DeleteKey(Indexes[i].FOldEditKey, Indexes[i].FOldEditRec);
                        Indexes[i].AddKey(NewKey, l);
                      finally
                        Indexes[i].FUnLock;
                      end
                    else
                      raise Exception.Create('TDBFDataSet.InternalPost: Can not Delete/add key to index file (FLock is false).');
                  end;
                  if  ( Indexes.ActiveObject <> nil ) and
                      ( Indexes.ActiveObject = Indexes[i] ) and
                      ( Indexes.ActiveObject.IsUniqueIndex or Indexes.ActiveObject.IsForIndex ) and
                      ( not FFastPostRecord ) then begin
                      r := Indexes.ActiveObject.FindKey(NewKey, true);
                      if r <> 0 then begin
                        if r <> l then begin
                          l := r;
                          GetBufferByRec(r);
                        end;
                      end else begin
                        InternalFirst;
                        b := true;
                      end;
                  end;
                end;
              end;
            if not FFastPostRecord then
              if not b then
                RefreshBufferByRec(l);
            Changed := True;
          end;
        finally
          RUnLock(l);
          DBFHandler.Seek(fOffset, 0);
        end
      else
        raise Exception.Create('TVKSmartDBF.InternalPost: Can not lock DBF record.');
    end else begin
      InternalAddRecord(ActiveBuf, true);
    end;
  end;
end;

{$IFDEF DELPHI2009}
procedure TVKSmartDBF.InternalSetToRecord(Buffer: TRecordBuffer);
{$ELSE}
procedure TVKSmartDBF.InternalSetToRecord(Buffer: PAnsiChar);
{$ENDIF}
var
  i: Longint;
begin
  i := pTRecInfo(Buffer + RecordSize).RecordRowID;
  InternalSetCurrentIndex(i);
  GetBufferByRec(i);
end;

function TVKSmartDBF.IsCursorOpen: Boolean;
begin
  Result := DBFHandler.IsOpen;
end;

{$IFDEF DELPHI2009}
procedure TVKSmartDBF.SetBookmarkData(Buffer: TRecordBuffer; Data: Pointer);
{$ELSE}
procedure TVKSmartDBF.SetBookmarkData(Buffer: PAnsiChar; Data: Pointer);
{$ENDIF}
begin
  pTRecInfo(Buffer + RecordSize).RecordRowID := Longword(Data^);
end;

{$IFDEF DELPHI2009}
procedure TVKSmartDBF.SetBookmarkFlag(Buffer: TRecordBuffer; Value: TBookmarkFlag);
{$ELSE}
procedure TVKSmartDBF.SetBookmarkFlag(Buffer: PAnsiChar; Value: TBookmarkFlag);
{$ENDIF}
begin
  pTRecInfo(Buffer + RecordSize).BookmarkFlag := Value;
end;

procedure TVKSmartDBF.SetFieldData(Field: TField; Buffer: Pointer);
begin
  InternalSetFieldData(Field, Buffer);
end;

{$IFDEF DELPHIXE3}
procedure TVKSmartDBF.SetFieldData(Field: TField; Buffer: TValueBuffer);
begin
  InternalSetFieldData(Field, @Buffer[0]);
end;
{$ENDIF DELPHIXE3}

procedure TVKSmartDBF.InternalSetFieldData(Field: TField; Buffer: Pointer);
var
  ss, vfpnull, ActiveBuf: pAnsiChar;
  qq: TVKDBFFieldDef;
  dd: double;
  sTS: TTimeStamp;
  sVFPTS: TVFPTimeStamp;
  Year, Month, Day: Word;
  dInt: Integer;
  dInt64: Int64;
  dFloat: double;
  dBool: WordBool;
  q: AnsiString;
  p0, p1, p2, p3: byte;
  wE: boolean;
  w: AnsiChar;
  i: Integer;
  SLen: WORD;
  WLen: Integer;
begin
  if Field.ReadOnly and not (State in [dsSetKey, dsFilter]) then
    DatabaseErrorFmt(SFieldReadOnly, [Field.DisplayName]);
  Field.Validate(Buffer);
  case Field.FieldKind of
  fkData:
    begin
      qq := TVKDBFFieldDef(Pointer(Field.Tag));
      if GetActiveRecBuf(ActiveBuf) then begin
        if (Buffer <> nil) then begin
          if FDbfVersion = xVisualFoxPro then begin
            if qq.FieldFlag.CanStoreNull then begin
              vfpnull := ActiveBuf + qq.OwnerVKDBFFieldDefs.FVFPNullsOffset + qq.FVFPNullByteNumber;
              pByte(vfpnull)^ := Byte(Byte(vfpnull^) and ( not qq.FVFPNullBitMask ));
            end;
          end;
          ss := ActiveBuf + qq.FOff;
          case Field.DataType of
            ftDataSet, ftMemo, ftFmtMemo, ftBlob, ftGraphic, ftParadoxOle, ftDBaseOle:
              begin
                if  ( qq.field_type = 'M' ) or ( qq.field_type = 'B' ) or
                    ( qq.field_type = 'G' ) or ( qq.field_type = 'P' ) or
                    ( ( qq.field_type = 'E' ) and
                      ( qq.extend_type in [ dbftClob, dbftFmtMemo,
                                            dbftBlob, dbftGraphic,
                                            dbftDBFDataSet] ) ) then begin
                  if DbfVersion = xVisualFoxPro then begin
                    dInt := pLongInt(Buffer)^;
                    LongInt(Pointer(ss)^) := pLongInt(Buffer)^;
                  end else begin
                    Move(Buffer^, ss^, 10)
                  end;
                end else
                  LongWord(Pointer(ss)^) := ( pLongWord(Buffer)^ or $80000000 );
              end;
            ftDate:
              begin
                if qq.field_type <> 'E' then begin
                  sTS.Date := pInteger(Buffer)^;
                  sTS.Time := 0;
                  dd := TimeStampToDateTime(sTS);
                  DecodeDate(dd, Year, Month, Day);
                  p0 := Year div 1000;
                  ss[0] := AnsiChar( p0 + $30 );
                  p1 := (Year - p0 * 1000) div 100;
                  ss[1] := AnsiChar( p1 + $30 );
                  p2 := (Year - p0 * 1000 - p1 * 100) div 10;
                  ss[2] := AnsiChar( p2 + $30 );
                  p3 := (Year - p0 * 1000 - p1 * 100 - p2 * 10);
                  ss[3] := AnsiChar( p3 + $30 );
                  ss[4] := AnsiChar( (Month div 10) + $30 );
                  ss[5] := AnsiChar( (Month - (Month div 10) * 10 ) + $30 );
                  ss[6] := AnsiChar( (Day div 10) + $30 );
                  ss[7] := AnsiChar( (Day - (Day div 10) * 10) + $30 );
                  (*
                  dd := double(Buffer^);
                  sTS.Date := Trunc(dd/(3600.0*24*1000));
                  sTS.Time := Trunc(dd - sTS.Date*((3600.0*24*1000)));
                  dd := TimeStampToDateTime(sTS);
                  DecodeDate(dd, Year, Month, Day);
                  p0 := Year div 1000;
                  ss[0] := AnsiChar( p0 + $30 );
                  p1 := (Year - p0 * 1000) div 100;
                  ss[1] := AnsiChar( p1 + $30 );
                  p2 := (Year - p0 * 1000 - p1 * 100) div 10;
                  ss[2] := AnsiChar( p2 + $30 );
                  p3 := (Year - p0 * 1000 - p1 * 100 - p2 * 10);
                  ss[3] := AnsiChar( p3 + $30 );
                  ss[4] := AnsiChar( (Month div 10) + $30 );
                  ss[5] := AnsiChar( (Month - (Month div 10) * 10 ) + $30 );
                  ss[6] := AnsiChar( (Day div 10) + $30 );
                  ss[7] := AnsiChar( (Day - (Day div 10) * 10) + $30 );
                  *)
                end else begin
                  case qq.extend_type of
                    dbftDate: pInteger(ss)^ := pInteger(Buffer)^;
                    dbftDate_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        pInteger(ss + 1)^ := pInteger(Buffer)^;
                      end;
                    dbftDate_NB: LongWord(Pointer(ss)^) := ( pLongWord(Buffer)^ or $80000000 );
                  end;
                end;
              end;
            ftTime:
              begin
                case qq.extend_type of
                  dbftTime: pInteger(ss)^ := pInteger(Buffer)^;
                  dbftTime_N:
                    begin
                      Byte(Pointer(ss)^) := 1;
                      pInteger(ss + 1)^ := pInteger(Buffer)^;
                    end;
                  dbftTime_NB: LongWord(Pointer(ss)^) := ( pLongWord(Buffer)^ or $80000000 );
                end;
              end;
            ftBCD:
              begin
                pBcd(ss)^ := pBcd(Buffer)^;
                Byte(ss[1]) := ( Byte(ss[1]) or $40 );
              end;
            ftCurrency:
              begin
                if qq.field_type <> 'E' then begin
                  // qq.field_type = 'Y'
                  Currency(Pointer(ss)^) := pCurrency(Buffer)^;
                end else begin
                  case qq.extend_type of
                    dbftCurrency: Currency(Pointer(ss)^) := pCurrency(Buffer)^;
                    dbftCurrency_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Currency(Pointer(ss + 1)^) := pCurrency(Buffer)^;
                      end;
                    dbftCurrency_NB:
                      begin
                        Currency(Pointer(ss)^) := pCurrency(Buffer)^;
                        Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ or $80 );
                      end;
                  end;
                end;
              end;
            ftBytes:
              begin
                // 'C' and FieldFlag.BinaryColumn = True
                // or '0'
                Move(Buffer^, ss^, qq.FLen)
              end;
            ftWideString:
              begin
                WLen := pInteger(Buffer)^;
                Move(Buffer^, ss^, WLen + 6);
              end;
            ftString:
              begin
                if qq.field_type <> 'E' then begin
                  if FullLengthCharFieldCopy then
                    {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrMove(ss, Buffer, qq.FLen)
                  else begin
                    wE := false;
                    for i := 0 to qq.FLen - 1 do
                    begin
                      w := pAnsiChar(Buffer)[i];
                      if w = #0 then
                        wE := true;
                      if not wE then
                        ss[i] := w
                      else
                        ss[i] := ' ';
                    end;
                  end;
                end else begin
                  case qq.extend_type of
                    dbftString:
                      begin
                        SLen := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(Buffer));
                        WORD(Pointer(ss)^) := SLen;
                        ss := ss + SizeOf(WORD);
                        Move(Buffer^, ss^, SLen);
                      end;
                    dbftString_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        SLen := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(Buffer));
                        ss := ss + 1;
                        WORD(Pointer(ss)^) := SLen;
                        ss := ss + SizeOf(WORD);
                        Move(Buffer^, ss^, SLen);
                      end;
                    dbftFixedChar:
                      begin
                        SLen := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(Buffer));
                        Move(Buffer^, ss^, SLen);
                        ss[SLen] := #0;
                      end;
                  end;
                end;
              end;
            ftDateTime:
              begin
                if qq.field_type = 'E' then
                  case qq.extend_type of
                    dbftD1:
                      begin
                        dd := double(Buffer^);
                        sTS.Date := Trunc(dd/(3600.0*24*1000));
                        sTS.Time := Trunc(dd - sTS.Date*((3600.0*24*1000)));
                        dd := TimeStampToDateTime(sTS);
                        Double(Pointer(ss)^) := Double(dd);
                      end;
                    dbftD1_NB:
                      begin
                        dd := double(Buffer^);
                        sTS.Date := Trunc(dd/(3600.0*24*1000));
                        sTS.Time := Trunc(dd - sTS.Date*((3600.0*24*1000)));
                        dd := TimeStampToDateTime(sTS);
                        Double(Pointer(ss)^) := Double(dd);
                        Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ or $80 );
                      end;
                    dbftD2: Double(Pointer(ss)^) := pDouble(Buffer)^;
                    dbftD2_NB:
                      begin
                        Double(Pointer(ss)^) := pDouble(Buffer)^;
                        Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ or $80 );
                      end;
                    dbftD3:
                      begin
                        dd := double(Buffer^);
                        sTS.Date := Trunc(dd/(3600.0*24*1000));
                        sTS.Time := Trunc(dd - sTS.Date*((3600.0*24*1000)));
                        dd := TimeStampToDateTime(sTS);
                        Real48(Pointer(ss)^) := Double(dd);
                      end;
                    dbftD3_NB:
                      begin
                        Real48(Pointer(ss)^) := pDouble(Buffer)^;
                        Byte(Pointer(ss + 5)^) := ( pByte(ss + 5)^ or $80 );
                      end;
                    dbftD1_N:
                      begin
                        dd := double(Buffer^);
                        sTS.Date := Trunc(dd/(3600.0*24*1000));
                        sTS.Time := Trunc(dd - sTS.Date*((3600.0*24*1000)));
                        dd := TimeStampToDateTime(sTS);
                        Byte(Pointer(ss)^) := 1;
                        Double(Pointer(ss + 1)^) := Double(dd);
                      end;
                    dbftD2_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Double(Pointer(ss + 1)^) := pDouble(Buffer)^;
                      end;
                    dbftD3_N:
                      begin
                        dd := double(Buffer^);
                        sTS.Date := Trunc(dd/(3600.0*24*1000));
                        sTS.Time := Trunc(dd - sTS.Date*((3600.0*24*1000)));
                        dd := TimeStampToDateTime(sTS);
                        Byte(Pointer(ss)^) := 1;
                        Real48(Pointer(ss + 1)^) := Double(dd);
                      end;
                  end
                else begin
                  if qq.field_type = '@' then begin
                    dInt64 := pInt64(Buffer)^;
                    pInt64(ss)^ := SwapInt64(dInt64);
                  end else if qq.field_type = 'T' then begin
                    dd := double(Buffer^);
                    sVFPTS.Date := trunc( dd / ( 3600.0 * 24 * 1000 ) );
                    sVFPTS.Time := round( dd - ( sVFPTS.Date * ( 3600.0 * 24 * 1000 ) ) );
                    sVFPTS.Date := sVFPTS.Date + 1721425;
                    TVFPTimeStamp(Pointer(ss)^) := sVFPTS;
                  end;
                end;
              end;
            ftSmallint:
              begin
                case qq.extend_type of
                  dbftS1: Shortint(Pointer(ss)^) := pShortint(Buffer)^;
                  dbftS2: Smallint(Pointer(ss)^) := pSmallint(Buffer)^;
                  dbftS1_N:     //Shortint with NULL
                    begin
                      Byte(Pointer(ss)^) := 1;
                      Shortint(Pointer(ss + 1)^) := pShortint(Buffer)^;
                    end;
                  dbftS2_N:     //Smallint with NULL
                    begin
                      Byte(Pointer(ss)^) := 1;
                      Smallint(Pointer(ss + 1)^) := pSmallint(Buffer)^;
                    end;
                end;
              end;
            ftWord:
              begin
                case qq.extend_type of
                  dbftU1: Byte(Pointer(ss)^) := pByte(Buffer)^;
                  dbftU2: Word(Pointer(ss)^) := pWord(Buffer)^;
                  dbftU1_N:
                    begin
                      Byte(Pointer(ss)^) := 1;
                      Byte(Pointer(ss + 1)^) := pByte(Buffer)^;
                    end;
                  dbftU2_N:
                    begin
                      Byte(Pointer(ss)^) := 1;
                      Word(Pointer(ss + 1)^) := pWord(Buffer)^;
                    end;
                  dbftU1_NB: Byte(Pointer(ss)^) := ( pByte(Buffer)^ or $80 );
                  dbftU2_NB: Word(Pointer(ss)^) := ( pWord(Buffer)^ or $8000 );
                end;
              end;
            ftInteger:
              begin
                if qq.field_type <> 'E' then begin
                  case qq.field_type of
                    'I':
                      begin
                        if FDbfVersion > xBaseVII then
                          Integer(Pointer(ss)^) := pInteger(Buffer)^
                        else begin
                          dInt := DWord(Buffer^) + $80000000;
                          Integer(Pointer(ss)^) := SwapInt(dInt);
                        end;
                      end;
                  else
                    dInt := Integer(Buffer^);
                    Str(dInt:qq.FLen, q);
                    Move(pAnsiChar(q)^, ss^, qq.FLen);
                  end;
                end else begin
                  case qq.extend_type of
                    dbftS4, dbftU4:       //Longint, Longword
                      begin
                        Integer(Pointer(ss)^) := pInteger(Buffer)^;
                      end;
                    dbftS4_N, dbftU4_N:     //Longint with NULL, Longword with NULL
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Integer(Pointer(ss + 1)^) := pInteger(Buffer)^;
                      end;
                    dbftU4_NB: LongWord(Pointer(ss)^) := ( pLongWord(Buffer)^ or $80000000 );
                  end;
                end;
              end;
            ftLargeint:
              begin
                if qq.field_type <> 'E' then begin
                  dInt64 := Int64(Buffer^);
                  Str(dInt64:qq.FLen, q);
                  Move(pAnsiChar(q)^, ss^, qq.FLen);
                end else begin
                  case qq.extend_type of
                    dbftS8:   Int64(Pointer(ss)^) := pInt64(Buffer)^;
                    dbftS8_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Int64(Pointer(ss + 1)^) := pInt64(Buffer)^;
                      end;
                  end;
                end;
              end;
            ftAutoInc:
              begin
                if FAlwaysSetFieldData then begin
                  if FDbfVersion > xBaseVII then begin
                    Integer(Pointer(ss)^) := pInteger(Buffer)^
                  end else begin
                    dInt := Integer(DWord(Buffer^) + $80000000);
                    Integer(Pointer(ss)^) := SwapInt(dInt);
                  end;
                end;
              end;
            ftFloat:
              begin
                if qq.field_type <> 'E' then begin
                  case qq.field_type of
                    'O':
                      begin
                        if Double(Buffer^) < 0 then
                          Int64(Pointer(ss)^) := not Int64(Buffer^)
                        else
                          Double(Pointer(ss)^):= - Double(Buffer^);
                        Int64(Pointer(ss)^) := SwapInt64(ss^);
                      end;
                  else
                    dFloat := Double(Buffer^);
                    Str(dFloat:qq.Flen:qq.Fdec, q);
                    Move(pAnsiChar(q)^, ss^, qq.FLen);
                  end;
                end else begin
                  case qq.extend_type of
                    dbftR4: Single(Pointer(ss)^) := pDouble(Buffer)^;
                    dbftR4_NB:
                      begin
                        Single(Pointer(ss)^) := pDouble(Buffer)^;
                        Byte(Pointer(ss + 3)^) := ( pByte(ss + 3)^ or $80 );
                      end;
                    dbftR6_NB:
                      begin
                        Real48(Pointer(ss)^) := pDouble(Buffer)^;
                        Byte(Pointer(ss + 5)^) := ( pByte(ss + 5)^ or $80 );
                      end;
                    dbftR8_NB:
                      begin
                        Double(Pointer(ss)^) := pDouble(Buffer)^;
                        Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ or $80 );
                      end;
                    dbftR6: Real48(Pointer(ss)^) := pDouble(Buffer)^;
                    dbftR8: Double(Pointer(ss)^) := pDouble(Buffer)^;
                    dbftR10: Extended(Pointer(ss)^) := pExtended(Buffer)^;
                    dbftR4_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Single(Pointer(ss + 1)^) := pDouble(Buffer)^;
                      end;
                    dbftR6_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Real48(Pointer(ss + 1)^) := pDouble(Buffer)^;
                      end;
                    dbftR8_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Double(Pointer(ss + 1)^) := pDouble(Buffer)^;
                      end;
                    dbftR10_N:
                      begin
                        Byte(Pointer(ss)^) := 1;
                        Extended(Pointer(ss + 1)^) := pExtended(Buffer)^;
                      end;
                  end;
                end;
              end;
            ftBoolean:
              begin
                dBool := WordBool(Buffer^);
                if dBool then
                   ss[0] := 'T'
                else
                  ss[0] := 'F';
              end;
          end;
        end else begin
          ss := ActiveBuf + qq.FOff;
          if FDbfVersion = xVisualFoxPro then begin
            if qq.FieldFlag.CanStoreNull then begin
              vfpnull := ActiveBuf + qq.OwnerVKDBFFieldDefs.FVFPNullsOffset + qq.FVFPNullByteNumber;
              pByte(vfpnull)^ := Byte(Byte(vfpnull^) or qq.FVFPNullBitMask);
            end;
            if not ( qq.field_type in ['M', 'P', 'G'] ) then Exit
            else
              pInteger(ss)^ := 0;
          end;
          if qq.field_type <> 'E' then begin
            if qq.field_type in ['I', '+', 'O', '@'] then begin
              case qq.field_type of
                '+':
                  begin
                    if FAlwaysSetFieldData then pInteger(ss)^ := 0;
                  end;
                'I':      pInteger(ss)^ := 0;
                'O', '@': pInt64(ss)^ := 0;
              end;
            end else
              for i := 0 to qq.FLen - 1 do ss[i] := ' ';
          end else begin
            case qq.extend_type of
              dbftS1_N,     //Shortint with NULL
              dbftU1_N,     //Byte  with NULL
              dbftS2_N,     //Smallint with NULL
              dbftU2_N,     //Word with NULL
              dbftS4_N,     //Longint with NULL
              dbftU4_N,     //Longword with NULL
              dbftS8_N,     //Int64 with NULL
              dbftR4_N,     //Single with NULL
              dbftR6_N,     //Real48 with NULL
              dbftR8_N,     //Double with NULL
              dbftR10_N,    //Extended with NULL
              dbftD1_N,     //TDateTime
              dbftD2_N,     //DataSet DateTime
              dbftD3_N,     //Real48 DateTime
              dbftString_N, //String
              dbftString,
              dbftCurrency_N,
              dbftBCD,
              dbftDate_N,
              dbftTime_N:
                begin
                  ss[0] := ' ';
                  ss[1] := ' ';
                end;
              dbftFixedChar: for i := 0 to qq.FLen do ss[i] := ' ';
              dbftU1_NB: Byte(Pointer(ss)^) := ( pByte(ss)^ and $7F );
              dbftU2_NB: Word(Pointer(ss)^) := ( pWord(ss)^ and $7FFF );
              dbftU4_NB: Longword(Pointer(ss)^) := ( pLongword(ss)^ and $7FFFFFFF );
              dbftR4_NB: Byte(Pointer(ss + 3)^) := ( pByte(ss + 3)^ and $7F );
              dbftR6_NB: Byte(Pointer(ss + 5)^) := ( pByte(ss + 5)^ and $7F );
              dbftR8_NB: Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ and $7F );
              dbftCurrency_NB: Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ and $7F );
              dbftD1_NB: Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ and $7F );
              dbftD2_NB: Byte(Pointer(ss + 7)^) := ( pByte(ss + 7)^ and $7F );
              dbftD3_NB: Byte(Pointer(ss + 5)^) := ( pByte(ss + 5)^ and $7F );
              dbftDate_NB: Longword(Pointer(ss)^) := ( pLongword(ss)^ and $7FFFFFFF );
              dbftTime_NB: Longword(Pointer(ss)^) := ( pLongword(ss)^ and $7FFFFFFF );
              dbftClob, dbftFmtMemo, dbftBlob, dbftGraphic, dbftDBFDataSet:
                begin
                  if FDbfVersion = xVisualFoxPro then
                    pDWord(ss)^ := 0
                  else
                    for i := 0 to qq.FLen do ss[i] := ' ';
                end;
              dbftClob_NB, dbftFmtMemo_NB, dbftBlob_NB, dbftGraphic_NB, dbftDBFDataSet_NB:
                begin
                  if FDbfVersion = xVisualFoxPro then
                    pDWord(ss)^ := 0
                  else
                    LongWord(Pointer(ss)^) := ( pLongWord(ss)^ and $7FFFFFFF );
                end;
            end;
          end;
        end;
      end;
    end;
  fkCalculated:
    begin
      if GetActiveRecBuf(ActiveBuf) then begin
        ss := ActiveBuf + FRecordSize + sizeof(TRecInfo) + Field.Offset;
        if Buffer <> nil then
          Move(Buffer^, ss^, Field.DataSize)
        else
          FillChar(ss^, Field.DataSize, ' ');
      end;
    end;
  end;
  if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
    DataEvent(deFieldChange, Longint(Field));
end;

procedure TVKSmartDBF.SetFiltered(Value: Boolean);
begin
  if Active then
  begin
    CheckBrowseMode;
    if ((not Filtered) and Value) and (Filter <> '') then
      FFilterParser.SetExprParams(Filter, FilterOptions, [poExtSyntax], '');
    if Filtered <> Value then begin
      inherited SetFiltered(Value);
      Refresh;
    end;
  end else
    inherited SetFiltered(Value);
end;

procedure TVKSmartDBF.SetIndexList(const Value: TIndexes);
begin
  FIndexes.Assign(Value);
end;

procedure TVKSmartDBF.SetRecNo(Value: Integer);
begin
  CheckBrowseMode;
  if AcceptTmpRecord(Value) then SetRecNoInternal(Value);
end;

procedure TVKSmartDBF.SetSetDeleted(const Value: Boolean);
begin
  if Active then
  begin
    CheckBrowseMode;
    if FSetDeleted <> Value then FSetDeleted := Value;
    Refresh;
  end else
    FSetDeleted := Value;
end;

function TVKSmartDBF.TranslateBuff(Src, Dest: PAnsiChar; ToOem: Boolean;
  Len: Integer): Integer;
begin
  if FOEM then
  begin
    if not ToOem then begin
      if (Src <> nil) then
      begin
        if OemToCharBuffA(Src, Dest, Len) then
          Result := Len
        else
          Result := 0;
      end else
        Result := 0;
    end else begin
      if (Src <> nil) then
      begin
        if CharToOemBuffA(Src, Dest, Len) then
          Result := Len
        else
          Result := 0;
      end else
        Result := 0;
    end;
  end else begin
    if (Src <> nil) then
    begin
      if (Src <> Dest) then
        Move(Src^, Dest^, Len);
      Result := Len;
    end else
      Result := 0;
  end;
end;

function TVKSmartDBF.Translate(Src, Dest: PAnsiChar; ToOem: Boolean): Integer;
begin
  if FOEM then
  begin
    if not ToOem then begin
      if (Src <> nil) then
      begin
        if OemToCharA(Src, Dest) then
          Result := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLen(Dest)
        else
          Result := 0;
      end else
        Result := 0;
    end else begin
      if (Src <> nil) then
      begin
        if CharToOemA(Src, Dest) then
          Result := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLen(Dest)
        else
          Result := 0;
      end else
        Result := 0;
    end;
  end else
    Result := inherited Translate(Src, Dest, ToOem);
end;

procedure TVKSmartDBF.DefineProperties(Filer: TFiler);

  function WriteData: Boolean;
  begin
    if FIndexes <> nil then begin
      if Filer.Ancestor <> nil then
        Result := not FIndexes.IsEqual(TVKSmartDBF(Filer.Ancestor).FIndexes)
      else
        Result := (FIndexes.Count > 0);
    end else
      Result := false;
  end;

begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('IndexData', ReadIndexData, WriteIndexData, WriteData);
end;

procedure TVKSmartDBF.ReadIndexData(Reader: TReader);
begin
  if Indexes <> nil then begin
    Reader.ReadValue;
    Reader.ReadCollection(Indexes);
  end;
end;

procedure TVKSmartDBF.WriteIndexData(Writer: TWriter);
begin
  if Indexes <> nil then
    Writer.WriteCollection(Indexes);
end;

function TVKSmartDBF.FirstByIndex(IndInd: Integer): TGetResult;
var
  i: Integer;
begin
  CheckBrowseMode;
  CursorPosChanged;
  DoBeforeScroll;
  Result := grError;
  if FIndexes <> nil then begin
    Result := FIndexes[IndInd].GetFirstByIndex(i);
    if Result = grOK then begin
      GetBufferByRec(i);
      Resync([]);
    end;
  end;
  DoAfterScroll;
end;

function TVKSmartDBF.LastByIndex(IndInd: Integer): TGetResult;
var
  i: Integer;
begin
  CheckBrowseMode;
  CursorPosChanged;
  DoBeforeScroll;
  Result := grError;
  if FIndexes <> nil then begin
    Result := FIndexes[IndInd].GetLastByIndex(i);
    if Result = grOK then begin
      GetBufferByRec(i);
      Resync([]);
    end;
  end;
  DoAfterScroll;
end;

function TVKSmartDBF.NextByIndex(IndInd: Integer): TGetResult;
var
  i: Integer;
begin
  CheckBrowseMode;
  CursorPosChanged;
  DoBeforeScroll;
  Result := grError;
  if FIndexes <> nil then begin
    FIndexes[IndInd].SetToRecord;
    Result := FIndexes[IndInd].GetRecordByIndex(gmNext, i);
    if Result = grOK then begin
      GetBufferByRec(i);
      Resync([]);
    end;
  end;
  DoAfterScroll;
end;

function TVKSmartDBF.PriorByIndex(IndInd: Integer): TGetResult;
var
  i: Integer;
begin
  CheckBrowseMode;
  CursorPosChanged;
  DoBeforeScroll;
  Result := grError;
  if FIndexes <> nil then begin
    FIndexes[IndInd].SetToRecord;
    Result := FIndexes[IndInd].GetRecordByIndex(gmPrior, i);
    if Result = grOK then begin
      GetBufferByRec(i);
      Resync([]);
    end;
  end;
  DoAfterScroll;
end;

function TVKSmartDBF.GetPrec(aField: TField): Integer;
begin
  //Result := (DBFFieldDefs.Items[aField.FieldNo - 1]).Fdec;
  Result := TVKDBFFieldDef(Pointer(aField.Tag)).Fdec;
end;

function TVKSmartDBF.GetLen(aField: TField): Integer;
begin
  //Result := (DBFFieldDefs.Items[aField.FieldNo - 1]).Flen;
  Result := TVKDBFFieldDef(Pointer(aField.Tag)).Flen;
end;

function TVKSmartDBF.GetDataSize(aField: TField): Integer;
begin
  Result := TVKDBFFieldDef(Pointer(aField.Tag)).GetDataSize;
end;

function TVKSmartDBF.NextBuffer: Longint;
var
  i, RealRead: Integer;
  OldIndex, NextRec: Longint;
  OldKey: String;
  OldRec: Longint;
  end1a: AnsiChar;
begin
  if FBufCnt > 0 then begin
    if (FIndexes = nil) or (FIndexes.ActiveObject = nil) then begin
      if FBufDir = bdFromTop then
        NextRec := pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)*(FBufCnt - 1))^
      else
        NextRec := pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)*(FRecordsPerBuf - 1))^;
      DBFHandler.Seek(DBFHeader.data_offset + NextRec * FRecordSize, soFromBeginning);
      end1a := FBuffer[0];
      RealRead := DBFHandler.Read(FBuffer^, FRecordsPerBuf * FRecordSize);
      Result := RealRead div FRecordSize;
      if Result > 0 then begin
        FBufCnt := Result;
        FBufDir := bdFromTop;
        FCurInd := 0;
        for i := 0 to FBufCnt - 1 do begin
          pLongint(pAnsiChar(FBufInd) + SizeOf(Longint) * i)^ := NextRec + i + 1;
          if Crypt.Active then
            Crypt.Decrypt(NextRec + i + 1, Pointer(FBuffer + i * FRecordSize), FRecordSize);
        end;
      end else
        FBuffer[0] := end1a;
    end else begin
      //Next buffer by index
      OldIndex := FCurInd;
      OldKey := FIndexes.ActiveObject.CurrentKey;
      OldRec := FIndexes.ActiveObject.CurrentRec;
      if FBufDir = bdFromTop then
        FCurInd := FBufCnt - 1
      else
        FCurInd := FRecordsPerBuf - 1;
      FKeyCalk := true;
      try
        FIndexes.ActiveObject.SetToRecord(pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)*FCurInd)^);
      finally
        FKeyCalk := false;
      end;
//      Result := 0;
      if FIndexes.ActiveObject.FLock then
        try
          Result := FIndexes.ActiveObject.NextBuffer(DBFHandler, FBuffer, FRecordsPerBuf, FRecordSize, FBufInd, DBFHeader.data_offset);
        finally
          FIndexes.ActiveObject.FUnLock;
        end
      else
        raise Exception.Create('TDBFDataSet: Can not read from index file (FLock is false).');
      if Result > 0 then begin
        FBufCnt := Result;
        FBufDir := bdFromTop;
        FCurInd := 0;
      end else begin
        FCurInd := OldIndex;
        FIndexes.ActiveObject.SetToRecord(OldKey, OldRec);
      end;
    end;
  end else Result := 0;
end;

function TVKSmartDBF.PriorBuffer: Longint;
var
  j: Longint;
  i: Integer;
  OldIndex, NextRec: Longint;
  OldKey: String;
  OldRec: Longint;
begin
  if FBufCnt > 0 then begin
    if (FIndexes = nil) or (FIndexes.ActiveObject = nil) then begin
      if FBufDir = bdFromTop then
        NextRec := FBufInd^
      else
        NextRec := pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - FBufCnt) * SizeOf(Longint))^;
      j := NextRec - FRecordsPerBuf;
      if j < 1 then j := 1;
      Result := NextRec - j;
      if Result > 0 then begin
        FBufCnt := Result;
        DBFHandler.Seek(DBFHeader.data_offset + ((j - 1) * FRecordSize), soFromBeginning);
        DBFHandler.Read((FBuffer + (FRecordsPerBuf - FBufCnt) * FRecordSize)^, FBufCnt * FRecordSize);
        FBufDir := bdFromBottom;
        FCurInd := FRecordsPerBuf - 1;
        for i := 0 to FBufCnt - 1 do begin
          pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - i - 1) * SizeOf(LongInt))^ := NextRec - i - 1;
          if Crypt.Active then
            Crypt.Decrypt(NextRec - i - 1, Pointer(FBuffer + (FRecordsPerBuf - i - 1) * FRecordSize), FRecordSize);
        end;
      end;
    end else begin
      //Prior buffer by index
      OldIndex := FCurInd;
      OldKey := FIndexes.ActiveObject.CurrentKey;
      OldRec := FIndexes.ActiveObject.CurrentRec;
      if FBufDir = bdFromTop then
        FCurInd := 0
      else
        FCurInd := FRecordsPerBuf - FBufCnt;
      FKeyCalk := true;
      try
        FIndexes.ActiveObject.SetToRecord(pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)*FCurInd)^);
      finally
        FKeyCalk := false;
      end;
//      Result := 0;
      if FIndexes.ActiveObject.FLock then
        try
          Result := FIndexes.ActiveObject.PriorBuffer(DBFHandler, FBuffer, FRecordsPerBuf, FRecordSize, FBufInd, DBFHeader.data_offset);
        finally
          FIndexes.ActiveObject.FUnLock;
        end
      else
        raise Exception.Create('TDBFDataSet: Can not read from index file (FLock is false).');
      if Result > 0 then begin
        FBufCnt := Result;
        FBufDir := bdFromBottom;
        FCurInd := FRecordsPerBuf - 1;
        FIndexes.ActiveObject.SetToRecord;
      end else begin
        FCurInd := OldIndex;
        FIndexes.ActiveObject.SetToRecord(OldKey, OldRec);
      end;
    end;
  end else Result := 0;
end;

procedure TVKSmartDBF.GetBufferByRec(Rec: Integer);
var
  i, RealRead: Integer;
  NewRec: Longint;
  Result: Longint;
begin
  if (FIndexes = nil) or (FIndexes.ActiveObject = nil) then begin
    NewRec := Rec - ( FRecordsPerBuf div 2);
    if NewRec < 1 then NewRec := 1;
    DBFHandler.Seek(DBFHeader.data_offset + (NewRec - 1) * FRecordSize, soFromBeginning);
    RealRead := DBFHandler.Read(FBuffer^, FRecordsPerBuf * FRecordSize);
    FBufCnt := RealRead div FRecordSize;
    if FBufCnt = 0 then begin
      FBOF := true;
      FEOF := true;
    end else begin
      FBOF := false;
      FEOF := false;
      FCurInd := 0;
    end;
    FBufDir := bdFromTop;
    for i := 0 to FBufCnt - 1 do begin
      pLongint(pAnsiChar(FBufInd) + i * SizeOf(Longint))^ := NewRec + i;
      if pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)*i)^ = Rec then
        FCurInd := i;
      if Crypt.Active then
        Crypt.Decrypt(NewRec + i, Pointer(FBuffer + i * FRecordSize), FRecordSize);
    end;
  end else begin
    if Rec < 1 then Rec := 1;
    DBFHandler.Seek(DBFHeader.data_offset + (Rec - 1) * FRecordSize, soFromBeginning);
    RealRead := DBFHandler.Read(FBuffer^, FRecordSize);
    if Crypt.Active then
      Crypt.Decrypt(Rec, Pointer(FBuffer), FRecordSize);
    if RealRead = FRecordSize then begin
      FBufInd^ := Rec;
      FCurInd := 0;
      FBufDir := bdFromTop;
      FKeyCalk := true;
      try
        if not FIndexes.ActiveObject.SetToRecord(Rec) then begin
          FCurInd := -1;
          FBufDir := bdFromTop;
          FBufCnt := 0;
          FBOF := true;
          FEOF := true;
          Exit;
        end else begin
          FBOF := false;
          FEOF := false;
        end;
      finally
        FKeyCalk := false;
      end;
      if FIndexes.ActiveObject.CurrentRec <> DWORD(Rec) then begin
        Rec := FIndexes.ActiveObject.CurrentRec;
        DBFHandler.Seek(DBFHeader.data_offset + (Rec - 1) * FRecordSize, soFromBeginning);
        DBFHandler.Read(FBuffer^, FRecordSize);
        if Crypt.Active then
          Crypt.Decrypt(Rec, Pointer(FBuffer), FRecordSize);
        FBufInd^ := Rec;
        FCurInd := 0;
      end;
//      Result := 0;
      if FIndexes.ActiveObject.FLock then
        try
          Result := FIndexes.ActiveObject.NextBuffer(DBFHandler, FBuffer + FRecordSize, FRecordsPerBuf - 1, FRecordSize, pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)), DBFHeader.data_offset);
        finally
          FIndexes.ActiveObject.FUnLock;
        end
      else
        raise Exception.Create('TDBFDataSet: Can not read from index file (FLock is false).');
      FBufCnt := Result + 1
    end else begin
      FCurInd := -1;
      FBufDir := bdFromTop;
      FBufCnt := 0;
      FBOF := true;
      FEOF := true;
    end;
  end;
end;

function TVKSmartDBF.GetRecBuf: pAnsiChar;
begin
  if ( 0 <= FCurInd ) and ( FCurInd <= FRecordsPerBuf ) then
    Result := FBuffer + FCurInd * FRecordSize
  else
    Result := nil;
end;

procedure TVKSmartDBF.NextIndexBuf;
begin
  FBOF := false;
  Inc(FCurInd);
  if FBufDir = bdFromTop then begin
    if FCurInd >= FBufCnt then if NextBuffer = 0 then begin
      FCurInd := FBufCnt;
      FEOF := true;
    end;
  end else begin
    if FCurInd >= FRecordsPerBuf then if NextBuffer = 0 then begin
      FCurInd := FRecordsPerBuf;
      FEOF := true;
    end;
  end;
end;

procedure TVKSmartDBF.PriorIndexBuf;
begin
  FEOF := false;
  Dec(FCurInd);
  if FBufDir = bdFromTop then begin
    if FCurInd < 0 then if PriorBuffer = 0 then begin
      //FCurInd := 0;
      FBOF := true;
    end;
  end else begin
    if FCurInd < FRecordsPerBuf - FBufCnt then  if PriorBuffer = 0 then begin
      //FCurInd := FRecordsPerBuf - FBufCnt;
      FBOF := true;
    end;
  end;
end;

function TVKSmartDBF.GetRecNoBuf: Longint;
begin
  Result := pLongint(pAnsiChar(FBufInd) + (FCurInd)*SizeOf(Longint))^;
end;

function TVKSmartDBF.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TVKSmartDBF.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  SetRngInt;
end;

procedure TVKSmartDBF.SetRngInt;
begin
  if FDataLink.DataSource <> nil then begin
    if FMasterFields <> '' then begin
      if FRange then ClearRange;
      FRange := true;
      ListMasterFields.Clear;
      if FDataLink.DataSource.DataSet <> nil then begin
        if FDataLink.DataSource.DataSet.Active then begin
          FDataLink.DataSource.DataSet.GetFieldList(ListMasterFields, FMasterFields);
          SetRange(FMasterFields, GetMasterFields);
        end;
      end;
    end;
  end;
end;

function TVKSmartDBF.IsLockWithIndex: boolean;
begin
  Result := True;
end;

function TVKSmartDBF.RLock: Boolean;
var
  r: Integer;
begin
  r := RecNo;
  {$IFDEF VKDBF_LOGGIN}
  VKDBFLogger.log.Write('TVKSmartDBF.RLock: lebel 1 : ' + IntToStr(r));
  {$ENDIF}
  Result := RLock(r);
end;

function TVKSmartDBF.RLock(nRec: Integer): Boolean;
begin
  {$IFDEF VKDBF_LOGGIN}
  VKDBFLogger.log.Write('TVKSmartDBF.RLock: lebel 1 : ' + IntToStr(nRec));
  {$ENDIF}
  Result := ReccordLockInternal(nRec);
end;

function TVKSmartDBF.ReccordLockInternal(nRec: Integer; bReload: boolean = true): Boolean;
var
  i, k: Integer;
  l: boolean;
begin
  FRLockObject.Enter;
  try
    {$IFDEF VKDBF_LOGGIN}
    VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 1 : ' + IntToStr(nRec));
    {$ENDIF}
    if FFileLock then begin
      {$IFDEF VKDBF_LOGGIN}
      VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 2 : FFileLock = True');
      {$ENDIF}
      Result := true;
    end else begin
      k := FLockRecords.IndexOf(Pointer(nRec));
      {$IFDEF VKDBF_LOGGIN}
      VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 3 : k = ' + IntToStr(k));
      {$ENDIF}
      if k = -1 then begin
        l := ( ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
        {$IFDEF VKDBF_LOGGIN}
        if l then
          VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 4 : l = True')
        else
          VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 4 : l = False');
        {$ENDIF}
        if not l then begin
          i := 0;
          repeat
            Result := False;
            case FLockProtocol of
              lpNone        : Result := True;
              lpDB4Lock     : Result := DBFHandler.Lock(DB4_LockMax - DWORD(nRec) - 1, 1);
              lpClipperLock : Result := DBFHandler.Lock(CLIPPER_LockMin + DWORD(nRec), 1);
              lpFoxLock     :
                begin
                  if IsLockWithIndex then
                    Result := DBFHandler.Lock(FOX_LockMax - DWORD(nRec), 1)
                  else
                    Result := DBFHandler.Lock(FOX_LockMin + ( DBFHeader.data_offset + ( ( DWORD(nRec)- 1 ) * DWORD(FRecordSize) ) ), 1);
                end;
              lpClipperForFoxLob: Result := DBFHandler.Lock(CLIPPER_FOR_FOX_LOB_LockMin + DWORD(nRec), 1);
            end;
            if not Result then begin
              {$IFDEF VKDBF_LOGGIN}
              VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 5 : try again');
              {$ENDIF}
              Wait(0.001, false);
              Inc(i);
              if i >= FWaitBusyRes then Break;
            end else begin
              {$IFDEF VKDBF_LOGGIN}
              VKDBFLogger.log.Write('TVKSmartDBF.ReccordLockInternal(nRec: Integer): lebel 6 : add to list ' + IntToStr(nRec));
              {$ENDIF}
              FLockRecords.Add(Pointer(nRec));
            end;
          until Result;
          if ((Result) and (bReload)) then begin
            ReloadRecord(nRec);
          end;
        end else
          Result := true;
      end else
        Result := true;
    end;
  finally
    FRLockObject.Release;
  end;
end;

procedure TVKSmartDBF.ReloadRecord(nRec: Integer);
var
  ActiveBuf: pAnsiChar;
begin
  if GetActiveRecBuf(ActiveBuf) then begin
    DBFHandler.Seek(DBFHeader.data_offset + (nRec - 1) * FRecordSize, soFromBeginning);
    DBFHandler.Read(ActiveBuf^, FRecordSize);
    if Crypt.Active then
      Crypt.Decrypt(nRec, Pointer(ActiveBuf), FRecordSize);
  end;
end;

function TVKSmartDBF.RUnLock: Boolean;
begin
  Result := RUnLock(RecNo);
end;

function TVKSmartDBF.RUnLock(nRec: Integer): Boolean;
var
  l: boolean;
  k: Integer;
begin
  FRUnLockObject.Enter;
  try
    l := (  ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or
            ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite )
            (* or ( FFileLock ) *) );
    if not l then begin
      Result := False;
      case FLockProtocol of
        lpNone        : Result := True;
        lpDB4Lock     : Result := DBFHandler.UnLock(DB4_LockMax - DWORD(nRec) - 1, 1);
        lpClipperLock : Result := DBFHandler.UnLock(CLIPPER_LockMin + DWORD(nRec), 1);
        lpFoxLock     :
          begin
            if IsLockWithIndex then
              Result := DBFHandler.UnLock(FOX_LockMax - DWORD(nRec), 1)
            else
              Result := DBFHandler.UnLock(FOX_LockMin + ( DBFHeader.data_offset + ( ( DWORD( nRec )- 1 ) * DWORD( FRecordSize ) ) ), 1);
          end;
        lpClipperForFoxLob: Result := DBFHandler.UnLock(CLIPPER_FOR_FOX_LOB_LockMin + DWORD(nRec), 1);
      end;
      if Result then begin
        k := FLockRecords.IndexOf(Pointer(nRec));
        if k <> -1 then FLockRecords.Delete(k);
      end;
    end else
      Result := true;
  finally
    FRUnLockObject.Release;
  end;
end;

function TVKSmartDBF.LockHeader: boolean;
var
  i: Integer;
  l: boolean;
begin
  FHeaderLockObject.Enter;
  try
    i := 0;
    l := ( ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
    if FLockProtocol = lpFoxLock then begin
      l := (l or FFileLock);
    end;
    repeat
      if not FFileHeaderLock then begin
        if not l then begin
          Result := False;
          case FLockProtocol of
            lpNone            : Result := True;
            lpDB4Lock         : Result := DBFHandler.Lock(DB4_LockMax, 1);
            lpClipperLock     : Result := DBFHandler.Lock(CLIPPER_LockMax, 1);
            lpFoxLock         : Result := DBFHandler.Lock(FOX_LockMax, 1);
            lpClipperForFoxLob: Result := DBFHandler.Lock(CLIPPER_FOR_FOX_LOB_LockMax, 1);
          end;
          if not Result then begin
            Wait(0.001, false);
            Inc(i);
            if i >= FWaitBusyRes then begin
              FFileHeaderLock := Result;
              Exit;
            end;
          end;
        end else
          Result := True;
      end else
        Result := True;
    until Result;
    if Result then begin
      DBFHandler.Seek(0, 0);
      DBFHandler.Read(DBFHeader, SizeOf(DBF_HEAD));
    end;
    FFileHeaderLock := Result;
  finally
    FHeaderLockObject.Release;
  end;
end;

function TVKSmartDBF.UnlockHeader: boolean;
var
  l: boolean;
begin
  FHeaderUnLockObject.Enter;
  try
    l := ( ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
    if FLockProtocol = lpFoxLock then begin
      l := (l or FFileLock);
    end;
    if not l then begin
      if FFileHeaderLock then begin
        Result := False;
        case FLockProtocol of
          lpNone            : Result := True;
          lpDB4Lock         : Result := DBFHandler.UnLock(DB4_LockMax, 1);
          lpClipperLock     : Result := DBFHandler.UnLock(CLIPPER_LockMax, 1);
          lpFoxLock         : Result := DBFHandler.UnLock(FOX_LockMax, 1);
          lpClipperForFoxLob: Result := DBFHandler.UnLock(CLIPPER_FOR_FOX_LOB_LockMax, 1);
        end;
      end else
        Result := True;
    end else
      Result := True;
    if FFileHeaderLock and Result then FFileHeaderLock := False;
  finally
    FHeaderUnLockObject.Release;
  end;
end;

function TVKSmartDBF.LockLobHeader(LbHandler: TProxyStream): boolean;
var
  i: Integer;
  l: boolean;
begin
  FLobHeaderLockObject.Enter;
  try
    i := 0;
    l := ( ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
    repeat
      if not FLobHeaderLock then begin
        if not l then begin
          Result := False;
          case FLobLockProtocol of
            lpNone            : Result := True;
            lpDB4Lock         : Result := LbHandler.Lock(DB4_LockMax, 1);
            lpClipperLock     : Result := LbHandler.Lock(CLIPPER_LockMax, 1);
            lpFoxLock         : Result := LbHandler.Lock(FOX_LockMin, 1);
            lpClipperForFoxLob: Result := LbHandler.Lock(CLIPPER_FOR_FOX_LOB_LockMax, 1);
          end;
          if not Result then begin
            Wait(0.001, false);
            Inc(i);
            if i >= FWaitBusyRes then begin
              FLobHeaderLock := Result;
              Exit;
            end;
          end;
        end else
          Result := True;
      end else
        Result := True;
    until Result;
    FLobHeaderLock := Result;
  finally
    FLobHeaderLockObject.Release;
  end;
end;

function TVKSmartDBF.UnlockLobHeader(LbHandler: TProxyStream): boolean;
var
  l: boolean;
begin
  FLobHeaderUnLockObject.Enter;
  try
    l := ( ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
    if not l then begin
      if FLobHeaderLock then begin
        Result := False;
        case FLobLockProtocol of
          lpNone            : Result := True;
          lpDB4Lock         : Result := LbHandler.UnLock(DB4_LockMax, 1);
          lpClipperLock     : Result := LbHandler.UnLock(CLIPPER_LockMax, 1);
          lpFoxLock         : Result := LbHandler.UnLock(FOX_LockMin, 1);
          lpClipperForFoxLob: Result := LbHandler.UnLock(CLIPPER_FOR_FOX_LOB_LockMax, 1);
        end;
      end else
        Result := True;
    end else
      Result := True;
    if FLobHeaderLock and Result then FLobHeaderLock := False;
  finally
    FLobHeaderUnLockObject.Release;
  end;
end;

function TVKSmartDBF.UnlockAllRecords: boolean;
var
  countBefore, countAfter: Integer;
begin
  if FLockRecords.Count > 0 then begin
    result := false;
    while not result do begin
      countBefore := FLockRecords.Count;
      RUnLock(Integer(FLockRecords.Items[0]));
      countAfter := FLockRecords.Count;
      if countBefore = countAfter then break;
      result := (FLockRecords.Count < 1);
    end;
  end else
    result := true;
end;

function TVKSmartDBF.GetCurIndByRec(nRec: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  if FBufDir = bdFromTop then begin
    for i := 0 to FBufCnt - 1 do
      if pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)*i)^ = nRec then begin
        Result := i;
        Break;
      end;
  end else begin
    for i := 0 to FBufCnt - 1 do
      if pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - i - 1) * SizeOf(LongInt))^ = nRec then begin
        Result := (FRecordsPerBuf - i - 1);
        Break;
      end;
  end;
end;

function TVKSmartDBF.FLock: Boolean;
var
  i: Integer;
  l: boolean;
  ActiveBuf: pAnsiChar;
  r: Integer;
begin
  FFLockObject.Enter;
  try
    Result := false;
    if FFileLock then begin
      Result := true;
      Exit;
    end else begin
      if UnlockAllRecords then
        try
          i := 0;
          l := ( ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
          repeat
            if not l then begin
              Result := False;
              case FLockProtocol of
                lpNone            : Result := True;
                lpDB4Lock         : Result := DBFHandler.Lock(DB4_LockMin,  DB4_LockRng);
                lpClipperLock     : Result := DBFHandler.Lock(CLIPPER_LockMin + 1 , CLIPPER_LockRng);
                lpFoxLock         : Result := DBFHandler.Lock(FOX_LockMax + 1 - FOX_LockRng, FOX_LockRng);
                lpClipperForFoxLob: Result := DBFHandler.Lock(CLIPPER_FOR_FOX_LOB_LockMin + 1, CLIPPER_FOR_FOX_LOB_LockRng);
              end;
              if not Result then begin
                Wait(0.001, false);
                Inc(i);
                if i >= FWaitBusyRes then Exit;
              end;
            end else
              Result := true;
          until Result;
        finally
          FFileLock := Result;
        end;
      if FFileLock then begin
        if Indexes <> nil then
          for i := 0 to Indexes.Count - 1 do Indexes[i].StartUpdate;
        if GetActiveRecBuf(ActiveBuf) then begin
          r := pTRecInfo(ActiveBuf + RecordSize).RecordRowID;
          GetBufferByRec(r);
          RefreshBufferByRec(r);
          Resync([]);
        end;
      end;
    end;
  finally
    FFLockObject.Release;
  end;
end;

function TVKSmartDBF.UnLock: Boolean;
var
  l: boolean;
  i: Integer;
begin
  FFUnLockObject.Enter;
  try
    l := (  ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or
            ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
    if Indexes <> nil then
      for i := 0 to Indexes.Count - 1 do Indexes[i].Flush;
    if not l then begin
      Result := UnlockAllRecords;
      if result then
        case FLockProtocol of
          lpNone            : Result := result and True;
          lpDB4Lock         : Result := result and DBFHandler.UnLock(DB4_LockMin,  DB4_LockRng);
          lpClipperLock     : Result := result and DBFHandler.UnLock(CLIPPER_LockMin + 1 , CLIPPER_LockRng);
          lpFoxLock         : Result := result and DBFHandler.UnLock(FOX_LockMax + 1 - FOX_LockRng, FOX_LockRng);
          lpClipperForFoxLob: Result := result and DBFHandler.UnLock(CLIPPER_FOR_FOX_LOB_LockMin + 1, CLIPPER_FOR_FOX_LOB_LockRng);
        end;
    end else
      Result := true;
    if FFileLock and Result then FFileLock := False;
  finally
    FFUnLockObject.Release;
  end;
end;

procedure TVKSmartDBF.InternalEdit;
var
  i, l: Integer;
  ActiveBuf: pAnsiChar;
begin
  if GetActiveRecBuf(ActiveBuf) then begin
    l := pTRecInfo(ActiveBuf + RecordSize).RecordRowID;
    if Indexes <> nil then
      for i := 0 to Indexes.Count - 1 do begin
        Indexes[i].FOldEditKey := Indexes[i].EvaluteKeyExpr;
        Indexes[i].FOldEditRec := l;
      end;
  end;
end;

procedure TVKSmartDBF.InternalRefresh;
var
  ActiveBuf: pAnsiChar;
  Rec: Longint;
begin
  if GetActiveRecBuf(ActiveBuf) then begin
    Rec := pTRecInfo(ActiveBuf + RecordSize).RecordRowID;
    GetBufferByRec(Rec);
  end;
end;

procedure TVKSmartDBF.SetOrder(nOrd: Integer);
begin
  if (FIndexes <> nil) then begin
    if ( nOrd = 0 ) and ( FIndexes.ActiveObject <> nil ) then
      FIndexes.ActiveObject.Active := false;
    if (( nOrd - 1 ) >= 0 ) and ( ( nOrd - 1 ) < FIndexes.Count ) then
      FIndexes[nOrd - 1].Active := true;
  end;
end;

procedure TVKSmartDBF.SetOrder(sOrd: AnsiString);
var
  i: Integer;
begin
  if (FIndexes <> nil) then begin
    for i := 0 to FIndexes.Count - 1 do
      if UpperCase(FIndexes[i].Name) = UpperCase(sOrd) then
        FIndexes[i].Active := true;
  end;
end;

function TVKSmartDBF.GetCreateNow: Boolean;
begin
  Result := FCreateNow;
end;

procedure TVKSmartDBF.SetCreateNow(const Value: Boolean);
begin
  if (csReading in ComponentState) then
  begin
    FStreamedCreateNow := Value;
  end else begin
    if Value then begin
      CreateTable;
      if  (csDesigning in ComponentState)
          and (not (csLoading in ComponentState)) then
            ShowMessage(Format('Table %s create successfully!', [DBFFileName]));
    end;
    FCreateNow := Value;
  end;
end;

function TVKSmartDBF.LocateRecord(  const KeyFields: AnsiString;
                                    const KeyValues: Variant;
                                    Options: TLocateOptions;
                                    nRec: DWORD = 1;
                                    FullScanOnly: boolean = false): Integer;
var
  m, i, j, k, l, n, p, o: Integer;
  FFields: TVKListOfFields;

  procedure CntFld;
  var
    I: Integer;
  begin
    I := p;
    while (I <= Length(KeyFields)) and (KeyFields[I] <> ';') do Inc(I);
    Inc(o);
    if (I <= Length(KeyFields)) and (KeyFields[I] = ';') then Inc(I);
    p := I;
  end;

  function LocatePass: Integer;
  var
    RecPareBuf, i: Integer;
    ReadSize, RealRead, BufCnt: Integer;
    Ok: boolean;
    Rec: Integer;
    //
    LowV, HiV, vj: Integer;
    //
  begin
    IndState := true;
    Result := 0;
    Rec := nRec - 1;
    Ok := false;
    // Check empty KeyValues
    if VarIsEmpty(KeyValues) or VarIsNull(KeyValues) then Exit;
    if VarIsArray(KeyValues) then begin
      LowV := VarArrayLowBound(KeyValues, 1);
      HiV := VarArrayHighBound(KeyValues, 1);
      for vj := LowV to HiV do begin
        if VarIsEmpty(KeyValues[vj]) or VarIsNull(KeyValues[vj]) then Exit;
      end;
    end;
    //
    try
      RecPareBuf := FBufferSize div Header.rec_size;
      if RecPareBuf >= 1 then begin
        ReadSize := RecPareBuf * Header.rec_size;
        Handle.Seek(Header.data_offset + ((nRec - 1) * Header.rec_size), 0);
        repeat
          RealRead := Handle.Read(FLocateBuffer^, ReadSize);
          BufCnt := RealRead div Header.rec_size;
          for i := 0 to BufCnt - 1 do begin
            IndRecBuf := FLocateBuffer + Header.rec_size * i;
            if Crypt.Active then
              Crypt.Decrypt(Rec + 1, Pointer(IndRecBuf), FRecordSize);
            Inc(Rec);
            if AcceptRecordInternal then begin
              if CompareLocateField(FFields, KeyValues, Options) = 0 then begin
                Ok := true;
                Exit;
              end;
            end;
          end;
        until ( BufCnt <= 0 );
      end else raise Exception.Create('TVKSmartDBF.LocateRecord: Record size too large');
    finally
      IndState := false;
      IndRecBuf := nil;
      if Ok then
        Result := Rec
      else
        Result := 0;
    end;
  end;

  procedure FullScan;
  begin
    FFields := TVKListOfFields.Create;
    try
      GetFieldList(FFields, KeyFields);
      Result := LocatePass;
    finally
      FFields.Free;
    end;
  end;

begin

  if FullScanOnly then begin
    FullScan;
    Exit;
  end;

  m := 0;
  k := 0;
  p := 1;
  o := 0;
  if Indexes <> nil then begin
    while p <= Length(KeyFields) do CntFld;
    j := Indexes.Count - 1;
    for i := 0 to j do begin
      l := Indexes[i].SuiteFieldList(KeyFields, n);
      if l > m then begin
        m := l;
        k := i;
      end;
    end;
  end;
  if (m > 0) and (o = m) then begin
    if loPartialKey in Options then
      Result := Indexes[k].FindKeyFields(KeyFields, KeyValues, true)
    else
      Result := Indexes[k].FindKeyFields(KeyFields, KeyValues);
  end else
    FullScan;
end;

function TVKSmartDBF.Locate(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
  Rec: Integer;
begin
  Result := false;
  Rec := LocateRecord(KeyFields, KeyValues, Options);
  if Rec <> 0 then begin
    SetRecNoInternal(Rec);
    Result := true;
  end;
end;

function TVKSmartDBF.Lookup(const KeyFields: string;
  const KeyValues: Variant; const ResultFields: string): Variant;
var
  Rec: Integer;
begin
  Rec := LocateRecord(KeyFields, KeyValues, FLookupOptions);
  if Rec <> 0 then begin
    Handle.Seek(Header.data_offset + (Rec - 1) * Header.rec_size, 0);
    Handle.Read(FLocateBuffer^, Header.rec_size);
    IndRecBuf := FLocateBuffer;
    if Crypt.Active then
      Crypt.Decrypt(Rec, Pointer(IndRecBuf), FRecordSize);
    IndState := true;
    try
      {$IFDEF DELPHI2009}
        {$IFDEF DELPHIXE4}
      GetCalcFields(TRecBuf(IndRecBuf));
        {$ELSE}
      GetCalcFields(pByte(IndRecBuf));
        {$ENDIF DELPHIXE4}
      {$ELSE}
      GetCalcFields(IndRecBuf);
      {$ENDIF DELPHI2009}
      Result := FieldValues[ResultFields];
    finally
      IndState := false;
      IndRecBuf := nil;
    end;
  end else
    Result := Unassigned;
end;

function TVKSmartDBF.GetMasterFields: Variant;
var
  i: Integer;
  OldTrimCType: boolean;
  MasterDBF: TVKSmartDBF;
begin
  if ListMasterFields.Count > 0 then begin
    Result := VarArrayCreate([0, ListMasterFields.Count - 1], varVariant);
    if TField(ListMasterFields[0]).DataSet is TVKSmartDBF then
      MasterDBF := TVKSmartDBF(TField(ListMasterFields[0]).DataSet)
    else
      MasterDBF := nil;
    if MasterDBF <> nil then begin
      OldTrimCType := MasterDBF.TrimCType;
      MasterDBF.TrimCType := False;
      try
        for i := 0 to ListMasterFields.Count - 1 do
          Result[i] := TField(ListMasterFields[i]).AsVariant;
      finally
        MasterDBF.TrimCType := OldTrimCType;
      end;
    end else begin
      for i := 0 to ListMasterFields.Count - 1 do
        Result[i] := TField(ListMasterFields[i]).AsVariant;
    end;
  end else
    Result := Null;
end;

procedure TVKSmartDBF.SetMasterFields(const Value: AnsiString);
begin
  if Value = '' then begin
    FMasterFields := Value;
    if FRange then ClearRange;
    FRange := false;
  end;
  if FMasterFields <> Value then begin
    FMasterFields := Value;
    if FRange then ClearRange;
    FRange := true;
    ListMasterFields.Clear;
    if DataSource <> nil then begin
      if DataSource.DataSet <> nil then begin
        if DataSource.DataSet.Active then begin
          DataSource.DataSet.GetFieldList(ListMasterFields, FMasterFields);
          SetRange(FMasterFields, GetMasterFields);
        end;
      end;
    end;
  end;
end;

procedure TVKSmartDBF.ClearRange;
begin
  //
end;

procedure TVKSmartDBF.SetRange(FieldList: AnsiString;
  FieldValues: array of const);
begin
  //
end;

procedure TVKSmartDBF.SetRange(FieldList: AnsiString; FieldValues: variant);
begin
  //
end;

procedure TVKSmartDBF.Reindex;
var
  i, j: Integer;
begin
  if Indexes <> nil then begin
    j := Indexes.Count - 1;
    for i := 0 to j do
      Indexes[i].Reindex;
  end;
end;

procedure TVKSmartDBF.ReindexWithOutActivated;
var
  i, j: Integer;
begin
  if Indexes <> nil then begin
    j := Indexes.Count - 1;
    for i := 0 to j do
      Indexes[i].Reindex(false);
  end;
end;

procedure TVKSmartDBF.SetDBFFieldDefs(const Value: TVKDBFFieldDefs);
begin
  FDBFFieldDefs.Assign(Value);
end;

procedure TVKSmartDBF.SetDBFIndexDefs(const Value: TVKDBFIndexDefs);
begin
  FDBFIndexDefs.Assign(Value);
end;

function TVKSmartDBF.CreateBlobStream(Field: TField;
  Mode: TBlobStreamMode): TStream;
var
  qq: TVKDBFFieldDef;
  ss: array [0..10] of AnsiChar;
  iCode, dInt: LongInt;
  dbfBuf: array [0..511] of byte;
  eof: boolean;
  i: Integer;
  rr, rr1: Integer;
  LenLob: LongInt;
  bh: LOB_BLOCK_HEADER;
begin
  qq := TVKDBFFieldDef(Pointer(Field.Tag));
  if Field.GetData(Pointer(@ss[0])) then
  begin
    if Mode = bmWrite then begin
      Result := TVKDBTStream.CreateDBTStream(self, Field);
      TVKDBTStream(Result).FModified := true;
      Exit;
    end;
    if FLobVersion in [xBaseIV..xBaseVII] then begin
      if  ( qq.field_type = 'M' ) or ( qq.field_type = 'B' ) or
          ( qq.field_type = 'G' ) or
          ( ( qq.field_type = 'E' ) and
            ( qq.extend_type in [dbftClob, dbftFmtMemo,
                              dbftBlob, dbftGraphic] )) then begin
        ss[10] := #0;
        Val(ss, dInt, iCode);
      end else begin
        dInt := pLongword(@ss[0])^;
        iCode := 0;
      end;
      if (iCode = 0) and (LobHandler.IsOpen) then
      begin
        LobHandler.Seek(0, 0);
        LobHandler.Read(LobHeader, SizeOf(LOB_HEAD));
        Result := TVKDBTStream.CreateDBTStream(self, Field);
        case qq.field_type of
          'M', 'B', 'G':
            begin
              LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
              LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
              if bh.ID <> $0008ffff then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
              LenLob := bh.Length - 8;
              Result.Size := LenLob;
              LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
              Result.Position := 0;
              if GetParentCryptObject.Active then
                GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TVKDBTStream(Result).Memory, LenLob);
              if qq.field_type = 'M' then
                if TVKDBTStream(Result).Memory <> nil then
                  TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
              TVKDBTStream(Result).FModified := false;
            end;
          'E':
            begin
              case qq.extend_type of
                dbftClob, dbftFmtMemo, dbftClob_NB, dbftFmtMemo_NB:
                  begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if bh.ID <> $0008ffff then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := bh.Length - 8;
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    Result.Position := 0;
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TVKDBTStream(Result).Memory, LenLob);
                    if TVKDBTStream(Result).Memory <> nil then
                      TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
                    TVKDBTStream(Result).FModified := false;
                  end;
                dbftBlob, dbftGraphic, dbftBlob_NB, dbftGraphic_NB:
                  begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if bh.ID <> $0008ffff then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := bh.Length - 8;
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TVKDBTStream(Result).Memory, LenLob);
                    Result.Position := 0;
                    TVKDBTStream(Result).FModified := false;
                  end;
              else
                raise Exception.Create('TVKSmartDBF: Lob stream create error!');
              end;
            end;
        else
          raise Exception.Create('TVKSmartDBF: Lob stream create error!');
        end;
      end else
        Result := TVKDBTStream.CreateDBTStream(self, Field);
    end else if FLobVersion in [xFoxPro..xVisualFoxPro] then begin
      if  ( qq.field_type = 'M' ) or ( qq.field_type = 'P' ) or
          ( qq.field_type = 'G' ) or
          ( ( qq.field_type = 'E' ) and
            ( qq.extend_type in [dbftClob, dbftFmtMemo,
                              dbftBlob, dbftGraphic] )) then begin
        if FLobVersion = xVisualFoxPro then begin
          dInt := pLongInt(@ss[0])^;
          iCode := 0;
        end else begin
          ss[10] := #0;
          Val(ss, dInt, iCode);
        end;
      end else begin
        dInt := pLongword(@ss[0])^;
      end;
      if (iCode = 0) and (LobHandler.IsOpen) then
      begin
        LobHandler.Seek(0, 0);
        LobHandler.Read(LobHeader, SizeOf(LOB_BLOCK_HEADER));
        LobHeader.BlockLength := SwapInt(pLongInt(@LobHeader.Dummy[0])^) and $FFFF;
        Result := TVKDBTStream.CreateDBTStream(self, Field);
        case qq.field_type of
          'M', 'P', 'G':
            begin
              LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
              LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
              if not ( (bh.FoxLobSignature = $01000000) or (bh.FoxLobSignature = 0) ) then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
              LenLob := SwapInt(bh.Length);
              Result.Size := LenLob;
              LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
              Result.Position := 0;
              if GetParentCryptObject.Active then
                GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TVKDBTStream(Result).Memory, LenLob);
              if FLobVersion = xFoxPro then begin
                if TVKDBTStream(Result).Memory <> nil then
                  TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
              end else begin  //xVisualFoxPro
                if  ( qq.field_type = 'M' ) and
                    ( not qq.FieldFlag.BinaryColumn ) and
                    ( TVKDBTStream(Result).Memory <> nil ) then
                  TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
              end;
              TVKDBTStream(Result).FModified := false;
            end;
          'E':
            begin
              case qq.extend_type of
                dbftClob, dbftFmtMemo, dbftClob_NB, dbftFmtMemo_NB:
                  begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if not ( (bh.FoxLobSignature = $01000000) or (bh.FoxLobSignature = 0) ) then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := SwapInt(bh.Length);
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    Result.Position := 0;
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TVKDBTStream(Result).Memory, LenLob);
                    if TVKDBTStream(Result).Memory <> nil then
                      TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
                    TVKDBTStream(Result).FModified := false;
                  end;
                dbftBlob, dbftGraphic, dbftBlob_NB, dbftGraphic_NB:
                  begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if not ( (bh.FoxLobSignature = $01000000) or (bh.FoxLobSignature = 0) ) then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := SwapInt(bh.Length);
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TVKDBTStream(Result).Memory, LenLob);
                    Result.Position := 0;
                    TVKDBTStream(Result).FModified := false;
                  end;
              else
                raise Exception.Create('TVKSmartDBF: Lob stream create error!');
              end;
            end;
        else
          raise Exception.Create('TVKSmartDBF: Lob stream create error!');
        end;
      end else
        Result := TVKDBTStream.CreateDBTStream(self, Field);
    end else begin
      if  ( qq.field_type = 'M' ) or
          ( ( qq.field_type = 'E' ) and
            ( qq.extend_type in [dbftClob, dbftFmtMemo,
                              dbftBlob, dbftGraphic] )) then begin
        ss[10] := #0;
        Val(ss, dInt, iCode);
      end else begin
        dInt := pLongword(@ss[0])^;
        iCode := 0;
      end;
      if (iCode = 0) and (LobHandler.IsOpen) then
      begin
        Result := TVKDBTStream.CreateDBTStream(self, Field);
        case qq.field_type of
          'M':
            begin
              eof := false;
              LobHandler.Seek(512 * dInt, 0);
              repeat
                rr := LobHandler.Read(dbfBuf, 512);
                rr1 := rr;
                for i := 0 to rr - 1 do begin
                  if dbfBuf[i] = $1A then begin
                    eof := true;
                    rr1 := i;
                    break;
                  end;
                end;
                Result.Write(dbfBuf, rr1);
              until eof;
              Result.Position := 0;
              if TVKDBTStream(Result).Memory <> nil then
                TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, TVKDBTStream(Result).Size);
              TVKDBTStream(Result).FModified := false;
            end;
          'E':
            begin
              case qq.extend_type of
                dbftClob, dbftFmtMemo:
                  begin
                    LobHandler.Seek(512 * dInt, 0);
                    LobHandler.Read(LenLob, SizeOf(LongInt));
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    Result.Position := 0;
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(512 * dInt, TVKDBTStream(Result).Memory, LenLob);
                    if TVKDBTStream(Result).Memory <> nil then
                      TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
                    TVKDBTStream(Result).FModified := false;
                  end;
                dbftBlob, dbftGraphic:
                  begin
                    LobHandler.Seek(512 * dInt, 0);
                    LobHandler.Read(LenLob, SizeOf(LongInt));
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(512 * dInt, TVKDBTStream(Result).Memory, LenLob);
                    Result.Position := 0;
                    TVKDBTStream(Result).FModified := false;
                  end;
                dbftClob_NB, dbftFmtMemo_NB:
                  begin
                    LobHandler.Seek(dInt, 0);
                    LobHandler.Read(LenLob, SizeOf(LongInt));
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    Result.Position := 0;
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(dInt, TVKDBTStream(Result).Memory, LenLob);
                    if TVKDBTStream(Result).Memory <> nil then
                      TranslateBuff(TVKDBTStream(Result).Memory, TVKDBTStream(Result).Memory, false, LenLob);
                    TVKDBTStream(Result).FModified := false;
                  end;
                dbftBlob_NB, dbftGraphic_NB:
                  begin
                    LobHandler.Seek(dInt, 0);
                    LobHandler.Read(LenLob, SizeOf(LongInt));
                    Result.Size := LenLob;
                    LobHandler.Read(TVKDBTStream(Result).Memory^, LenLob);
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(dInt, TVKDBTStream(Result).Memory, LenLob);
                    Result.Position := 0;
                    TVKDBTStream(Result).FModified := false;
                  end;
              else
                raise Exception.Create('TVKSmartDBF: Lob stream create error!');
              end;
            end;
        else
          raise Exception.Create('TVKSmartDBF: Lob stream create error!');
        end;
      end else
        Result := TVKDBTStream.CreateDBTStream(self, Field);
    end;
  end else
    Result := TVKDBTStream.CreateDBTStream(self, Field);
end;

procedure TVKSmartDBF.CreateNestedStream(NestedDataSet: TVKSmartDBF; Field: TField; NestedStream: TStream);
var
  qq: TVKDBFFieldDef;
  ss: array [0..10] of AnsiChar;
  iCode, dInt: LongInt;
  LenLob: LongInt;
  bh: LOB_BLOCK_HEADER;

  procedure CreateNewStream;
  begin
    NestedDataSet.DBFFieldDefs.Clear;
    qq := DBFFieldDefs.FindIndex(Field.FullName);
    NestedDataSet.DBFFieldDefs.Assign(qq.DBFFieldDefs);
    NestedDataSet.DbfVersion := DbfVersion;
    NestedDataSet.LockProtocol := LockProtocol;
    NestedDataSet.LobLockProtocol := LobLockProtocol;
    NestedDataSet.FLobBlockSize := FLobBlockSize;
    NestedDataSet.CreateTable;
  end;

begin
  qq := TVKDBFFieldDef(Pointer(Field.Tag));
  if Field.GetData(@ss[0]) then
  begin
    if FLobVersion = xVisualFoxPro then begin
      dInt := pLongInt(@ss[0])^;
      iCode := 0;
    end else begin
      if  ( ( qq.field_type = 'E' ) and
            ( qq.extend_type in [dbftDBFDataSet] )) then begin
        ss[10] := #0;
        Val(ss, dInt, iCode);
      end else begin
        dInt := pLongword(@ss[0])^;
        iCode := 0;
      end;
    end;
    if (iCode = 0) and (LobHandler.IsOpen) then
    begin
      if FLobVersion in [xBaseIV..xBaseVII] then begin
        LobHandler.Seek(0, 0);
        LobHandler.Read(LobHeader, SizeOf(LOB_HEAD));
      end else if FLobVersion in [xFoxPro..xVisualFoxPro] then begin
        LobHandler.Seek(0, 0);
        LobHandler.Read(LobHeader, SizeOf(LOB_BLOCK_HEADER));
        LobHeader.BlockLength := SwapInt(pLongInt(@LobHeader.Dummy[0])^) and $FFFF;
      end;
      case qq.field_type of
        'E':
          begin
            case qq.extend_type of
              dbftDBFDataSet:
                begin
                  if FLobVersion in [xBaseIV..xBaseVII] then begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if bh.ID <> $0008ffff then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := bh.Length - 8;
                  end else if FLobVersion in [xFoxPro..xVisualFoxPro] then begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if not ( (bh.FoxLobSignature = $01000000) or (bh.FoxLobSignature = 0) ) then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := SwapInt(bh.Length);
                  end else begin
                    LobHandler.Seek(512 * dInt, 0);
                    LobHandler.Read(LenLob, SizeOf(LongInt));
                  end;
                  TMemoryStream(NestedStream).Size := LenLob;
                  LobHandler.Read(TMemoryStream(NestedStream).Memory^, LenLob);
                  TMemoryStream(NestedStream).Position := 0;
                  if FLobVersion >= xBaseIV then begin
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TMemoryStream(NestedStream).Memory, LenLob);
                  end else begin
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(512 * dInt, TMemoryStream(NestedStream).Memory, LenLob);
                  end;
                end;
              dbftDBFDataSet_NB:
                begin
                  if FLobVersion in [xBaseIV..xBaseVII] then begin
                    LobHandler.Seek(LobHeader.BlockLength * dInt, 0);
                    LobHandler.Read(bh, SizeOf(LOB_BLOCK_HEADER));
                    if bh.ID <> $0008ffff then raise Exception.Create('TVKSmartDBF: Lob stream read block error!');
                    LenLob := bh.Length - 8;
                  end else begin
                    LobHandler.Seek(dInt, 0);
                    LobHandler.Read(LenLob, SizeOf(LongInt));
                  end;
                  TMemoryStream(NestedStream).Size := LenLob;
                  LobHandler.Read(TMemoryStream(NestedStream).Memory^, LenLob);
                  if FLobVersion >= xBaseIV then begin
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(LobHeader.BlockLength * dInt, TMemoryStream(NestedStream).Memory, LenLob);
                  end else begin
                    if GetParentCryptObject.Active then
                      GetParentCryptObject.Decrypt(dInt, TMemoryStream(NestedStream).Memory, LenLob);
                  end;
                  TMemoryStream(NestedStream).Position := 0;
                end;
              else
                raise Exception.Create('TVKSmartDBF: Nested stream create error!');
              end;
          end;
      else
        raise Exception.Create('TVKSmartDBF: Nested stream create error!');
      end;
    end else
      CreateNewStream;
  end else
    CreateNewStream;
end;

procedure TVKSmartDBF.SaveOnTheSamePlaceToDBT(Source: TMemoryStream; Field: TField);
begin
  FSaveOnTheSamePlace := True;
  try
    SaveToDBT(Source, Field);
  finally
    FSaveOnTheSamePlace := False;
  end;
end;

procedure TVKSmartDBF.SaveToDBT(Source: TMemoryStream; Field: TField);
var
  qq: TVKDBFFieldDef;
  ss: array [0..10] of AnsiChar;
  lEnd, dInt: LongInt;
  LenLob: LongInt;
  CryptContext: LongWord;
  LHnd: TProxyStream;
  LHeader: LOB_HEAD;
  bh: LOB_BLOCK_HEADER;

  procedure ReleaseFoxProMemoBlocks(BlocksEnterToRelease: Integer);
  begin
    // do nothing
  end;

  function FindFoxProAvailBlock(LengthRequest: LongInt): LongInt;
  var
    BlocksRequest: LongInt;
    bhLocation: LongInt;
    bh: LOB_BLOCK_HEADER;
  begin
    BlocksRequest := ( ( LengthRequest + 8 + ( LHeader.BlockLength - 1 ) ) div LHeader.BlockLength );
    bhLocation := 0;
    LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
    LHnd.Read(bh, SizeOf(LOB_BLOCK_HEADER));
    LHeader.BlockLength := SwapInt(pLongInt(@LHeader.Dummy[0])^) and $FFFF;
    Result := SwapInt(bh.NextEmtyBlock);
    bh.NextEmtyBlock := Result + BlocksRequest;
    bh.NextEmtyBlock := SwapInt(bh.NextEmtyBlock);
    LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
    LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
  end;

  procedure ReleaseBDVMemoBlocks(BlocksEnterToRelease: Integer);
  var
    bh1, bh2: LOB_BLOCK_HEADER;
  begin
    LHnd.Seek(0, 0);
    LHnd.Read(bh1, SizeOf(LOB_BLOCK_HEADER));
    LHnd.Seek(BlocksEnterToRelease * LHeader.BlockLength, 0);
    LHnd.Read(bh2, SizeOf(LOB_BLOCK_HEADER));
    bh2.NextEmtyBlock := bh1.NextEmtyBlock;
    bh2.BlocksEmty := ( ( bh2.LengthMemo + ( LHeader.BlockLength - 1 ) ) div LHeader.BlockLength );
    LHnd.Seek(BlocksEnterToRelease * LHeader.BlockLength, 0);
    LHnd.Write(bh2, SizeOf(LOB_BLOCK_HEADER));
    bh1.NextEmtyBlock := BlocksEnterToRelease;
    LHnd.Seek(0, 0);
    LHnd.Write(bh1, SizeOf(LOB_BLOCK_HEADER));
  end;

  function FindBDVAvailBlock(LengthRequest: LongInt): LongInt;
  var
    BlocksRequest: LongInt;
    bhLocation: LongInt;
    bh, bh1: LOB_BLOCK_HEADER;

      procedure FindBDVAvailBlockInternal;
      begin
        repeat
          Result := bh.NextEmtyBlock;
          if ( ( Result * LHeader.BlockLength ) < lEnd ) then begin
            LHnd.Seek(Result * LHeader.BlockLength, 0);
            LHnd.Read(bh1, SizeOf(LOB_BLOCK_HEADER));
            if ( BlocksRequest < bh1.BlocksEmty ) then begin
              bh1.BlocksEmty := bh1.BlocksEmty - BlocksRequest;
              LHnd.Seek( ( Result + BlocksRequest ) * LHeader.BlockLength, 0);
              LHnd.Write(bh1, SizeOf(LOB_BLOCK_HEADER));
              bh.NextEmtyBlock := Result + BlocksRequest;
              LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
              LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
              Break;
            end else if ( BlocksRequest = bh1.BlocksEmty ) then begin
              bh.NextEmtyBlock := bh1.NextEmtyBlock;
              LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
              LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
              Break;
            end else begin
              bhLocation := Result;
              bh := bh1;
            end;
          end else begin
            bh.NextEmtyBlock := bh.NextEmtyBlock + BlocksRequest;
            LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
            LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
            Break;
          end;
        until ( ( Result * LHeader.BlockLength ) >= lEnd );
      end;

  begin
    BlocksRequest := ( ( LengthRequest + 8 + ( LHeader.BlockLength - 1 ) ) div LHeader.BlockLength );
    bhLocation := 0;
    LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
    LHnd.Read(bh, SizeOf(LOB_BLOCK_HEADER));
    FindBDVAvailBlockInternal;
  end;

  procedure AdjustBDVBindedList(LengthRequest: LongInt);
  var
    BlocksRequest: LongInt;
    bhLocation: LongInt;
    bh: LOB_BLOCK_HEADER;

      procedure AdjustBDVBindedListInternal;
      begin
        while ( ( bh.NextEmtyBlock * LHeader.BlockLength ) < lEnd ) do begin
          bhLocation := bh.NextEmtyBlock;
          LHnd.Seek(bh.NextEmtyBlock * LHeader.BlockLength, 0);
          LHnd.Read(bh, SizeOf(LOB_BLOCK_HEADER));
        end;
        BlocksRequest := ( ( ( lEnd -  bh.NextEmtyBlock * LHeader.BlockLength ) + LengthRequest + 4 + ( LHeader.BlockLength - 1 ) ) div LHeader.BlockLength );
        bh.NextEmtyBlock := bh.NextEmtyBlock + BlocksRequest;
        LHnd.Seek(bhLocation * LHeader.BlockLength, 0);
        LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
      end;

  begin
    bhLocation := 0;
    LHnd.Seek(0, 0);
    LHnd.Read(bh, SizeOf(LOB_BLOCK_HEADER));
    AdjustBDVBindedListInternal;
  end;

begin
  qq := TVKDBFFieldDef(Pointer(Field.Tag));
  if FPackProcess then
    LHnd := PackLobHandler
  else
    LHnd := LobHandler;
  if LHnd.IsOpen then
  begin
    if LockLobHeader(LHnd) then begin
      if FLobVersion in [xBaseIV..xBaseVII] then begin
        LHnd.Seek(0, 0);
        LHnd.Read(LHeader, SizeOf(LOB_HEAD));
      end else if FLobVersion in [xFoxPro..xVisualFoxPro] then begin
        LHnd.Seek(0, 0);
        LHnd.Read(LHeader, SizeOf(LOB_BLOCK_HEADER));
        LHeader.BlockLength := SwapInt(pLongInt(@LHeader.Dummy[0])^) and $FFFF;
      end;
      if Source.Memory <> nil then begin
        lEnd := LHnd.Seek(0, 2);
        LenLob := Source.Size;
        if FLobVersion in [xBaseIV..xBaseVII] then begin
          if  ( qq.field_type = 'M' ) or ( qq.field_type = 'B' ) or
              ( qq.field_type = 'G' ) or
              ( ( qq.field_type = 'E' ) and
                ( qq.extend_type in [ dbftClob, dbftFmtMemo,
                                      dbftBlob, dbftGraphic,
                                      dbftDBFDataSet] )) then begin
            if not FSaveOnTheSamePlace then begin
              if not FPackProcess then
                if Field.GetData(Pointer(@ss[0])) then begin // Field not empty
                  dInt := StrToInt(ss);
                  ReleaseBDVMemoBlocks(dInt);
                end;
              dInt := FindBDVAvailBlock(LenLob);
              CryptContext := dInt * LHeader.BlockLength;
              Str(dInt:10, ss);
              Field.SetData(Pointer(@ss[0]));
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end else begin
              Field.GetData(Pointer(@ss[0]));
              ss[10] := #0;
              dInt := StrToInt(ss);
              CryptContext := dInt * LHeader.BlockLength;
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end;
          end else begin
            if not FSaveOnTheSamePlace then begin
              if not FPackProcess then
                if Field.GetData(@dInt) then begin // Field not empty
                  ReleaseBDVMemoBlocks(dInt);
                end;
              dInt := FindBDVAvailBlock(LenLob);
              CryptContext := dInt * LHeader.BlockLength;
              Field.SetData(@dInt);
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end else begin
              Field.GetData(@dInt);
              CryptContext := dInt * LHeader.BlockLength;
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end;
          end;
          case qq.field_type of
            'M', 'B', 'G':
              begin
                TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                if GetParentCryptObject.Active then
                  GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                bh.DBIV_Flag := -1;
                bh.StartOffsetMemo := 8;
                bh.LengthMemo := LenLob + 8;
                LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
                LHnd.Write(Pointer(Source.Memory)^, LenLob);
              end;
            'E':
              begin
                case qq.extend_type of
                  dbftClob, dbftFmtMemo, dbftClob_NB, dbftFmtMemo_NB:
                    begin
                      TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      bh.DBIV_Flag := -1;
                      bh.StartOffsetMemo := 8;
                      bh.LengthMemo := LenLob + 8;
                      LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                  dbftBlob, dbftGraphic, dbftDBFDataSet, dbftBlob_NB, dbftGraphic_NB, dbftDBFDataSet_NB:
                    begin
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      bh.DBIV_Flag := -1;
                      bh.StartOffsetMemo := 8;
                      bh.LengthMemo := LenLob + 8;
                      LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                else
                  raise Exception.Create('TVKSmartDBF: Lob stream save error!');
                end;
              end;
          else
            raise Exception.Create('TVKSmartDBF: Lob stream save error!');
          end;
        end else if FLobVersion in [xFoxPro..xVisualFoxPro] then begin
          //DONE: make write for FPT Storage...
          if  ( qq.field_type = 'M' ) or ( qq.field_type = 'P' ) or
              ( qq.field_type = 'G' ) or
              ( ( qq.field_type = 'E' ) and
                ( qq.extend_type in [ dbftClob, dbftFmtMemo,
                                      dbftBlob, dbftGraphic,
                                      dbftDBFDataSet] )) then begin
            if not FSaveOnTheSamePlace then begin
              if not FPackProcess then
                if Field.GetData(Pointer(@ss[0])) then begin // Field not empty
                  if FLobVersion = xVisualFoxPro then
                    dInt := pLongInt(@ss[0])^
                  else
                    dInt := StrToInt(ss);
                  ReleaseFoxProMemoBlocks(dInt);
                end;
              dInt := FindFoxProAvailBlock(LenLob);
              CryptContext := dInt * LHeader.BlockLength;
              if FLobVersion = xVisualFoxPro then
                pLongInt(@ss[0])^ := dInt
              else
                Str(dInt:10, ss);
              Field.SetData(Pointer(@ss[0]));
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end else begin
              Field.GetData(Pointer(@ss[0]));
              if FLobVersion = xVisualFoxPro then
                dInt := pLongInt(@ss[0])^
              else begin
                ss[10] := #0;
                dInt := StrToInt(ss);
              end;
              CryptContext := dInt * LHeader.BlockLength;
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end;
          end else begin
            if not FSaveOnTheSamePlace then begin
              if not FPackProcess then
                if Field.GetData(@dInt) then begin // Field not empty
                  ReleaseFoxProMemoBlocks(dInt);
                end;
              dInt := FindFoxProAvailBlock(LenLob);
              CryptContext := dInt * LHeader.BlockLength;
              Field.SetData(@dInt);
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end else begin
              Field.GetData(@dInt);
              CryptContext := dInt * LHeader.BlockLength;
              LHnd.Seek(dInt * LHeader.BlockLength, 0);
            end;
          end;
          case qq.field_type of
            'M', 'P', 'G':
              begin
                if ( qq.field_type = 'M' ) then begin
                  bh.FoxLobSignature := $01000000;  //Text
                  if FLobVersion = xFoxPro then begin
                    TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                  end else begin  //xVisualFoxPro
                    if not qq.FieldFlag.BinaryColumn then begin
                      TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                      bh.FoxLobSignature := 0;  //Binary
                    end;
                  end;
                end else
                  bh.FoxLobSignature := 0;  //Binary
                if GetParentCryptObject.Active then
                  GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                bh.LengthMemo := SwapInt(LenLob);
                LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
                LHnd.Write(Pointer(Source.Memory)^, LenLob);
              end;
            'E':
              begin
                case qq.extend_type of
                  dbftClob, dbftFmtMemo, dbftClob_NB, dbftFmtMemo_NB:
                    begin
                      TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      bh.FoxLobSignature := $01000000;  //Text
                      bh.LengthMemo := SwapInt(LenLob);
                      LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                  dbftBlob, dbftGraphic, dbftDBFDataSet, dbftBlob_NB, dbftGraphic_NB, dbftDBFDataSet_NB:
                    begin
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      bh.FoxLobSignature := 0; //Binary
                      bh.LengthMemo := SwapInt(LenLob);
                      LHnd.Write(bh, SizeOf(LOB_BLOCK_HEADER));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                else
                  raise Exception.Create('TVKSmartDBF: Lob stream save error!');
                end;
              end;
          else
            raise Exception.Create('TVKSmartDBF: Lob stream save error!');
          end;
          //
        end else begin
          if  ( qq.field_type = 'M' ) or
              ( ( qq.field_type = 'E' ) and
                ( qq.extend_type in [ dbftClob, dbftFmtMemo,
                                      dbftBlob, dbftGraphic,
                                      dbftDBFDataSet] )) then begin
            if not FSaveOnTheSamePlace then begin
              dInt := lEnd div 512;
              if (lEnd mod 512) > 0 then Inc(dInt);
              CryptContext := dInt * 512;
              LHnd.Seek(dInt * 512, 0);
              Str(dInt:10, ss);
              Field.SetData(Pointer(@ss[0]));
            end else begin
              Field.GetData(Pointer(@ss[0]));
              ss[10] := #0;
              dInt := StrToInt(ss);
              CryptContext := dInt * 512;
              LHnd.Seek(dInt * 512, 0);
            end;
          end else begin
            if not FSaveOnTheSamePlace then begin
              dInt := lEnd;
              CryptContext := dInt;
              LHnd.Seek(dInt, 0);
              Field.SetData(@dInt);
            end else begin
              Field.GetData(@dInt);
              CryptContext := dInt;
              LHnd.Seek(dInt, 0);
            end;
          end;
          case qq.field_type of
            'M':
              begin
                //This Lob type you can not to Crypt !!!
                TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                LHnd.Write(Pointer(Source.Memory)^, LenLob);
                ss[0] := #$1A;
                LHnd.Write(ss, 1);
              end;
            'E':
              begin
                case qq.extend_type of
                  dbftClob, dbftFmtMemo:
                    begin
                      TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      LHnd.Write(LenLob, SizeOf(LongInt));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                  dbftBlob, dbftGraphic, dbftDBFDataSet:
                    begin
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      LHnd.Write(LenLob, SizeOf(LongInt));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                  dbftClob_NB, dbftFmtMemo_NB:
                    begin
                      TranslateBuff(Source.Memory, Source.Memory, true, LenLob);
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      LHnd.Write(LenLob, SizeOf(LongInt));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                  dbftBlob_NB, dbftGraphic_NB, dbftDBFDataSet_NB:
                    begin
                      if GetParentCryptObject.Active then
                        GetParentCryptObject.Encrypt(CryptContext, Source.Memory, LenLob);
                      LHnd.Write(LenLob, SizeOf(LongInt));
                      LHnd.Write(Pointer(Source.Memory)^, LenLob);
                    end;
                else
                  raise Exception.Create('TVKSmartDBF: Lob stream save error!');
                end;
              end;
          else
            raise Exception.Create('TVKSmartDBF: Lob stream save error!');
          end;
        end;
      end else
        Field.SetData(nil);
      UnlockLobHeader(LHnd);
    end;
  end;
end;

procedure TVKSmartDBF.BeginAddBuffered(RecInBuffer: Integer);
begin
  if not FAddBuffered then begin
    FAddBuffered := true;
    FAddBufferCount := RecInBuffer;
    FAddBuffer := VKDBFMemMgr.oMem.GetMem(self, FAddBufferCount * FRecordSize);
    FAddBufferCrypt := VKDBFMemMgr.oMem.GetMem(self, FAddBufferCount * FRecordSize);
    FAddBufferCurrent := -1; // 0 - (FAddBufferCount - 1)
  end;
end;

procedure TVKSmartDBF.EndAddBuffered;
begin
  if FAddBuffered then begin
    if FAddBufferCount > -1 then FlushAddBuffer;
    VKDBFMemMgr.oMem.FreeMem(FAddBuffer);
    VKDBFMemMgr.oMem.FreeMem(FAddBufferCrypt);
    FAddBuffered := false;
    FAddBuffer := nil;
    FAddBufferCrypt := nil;
    FAddBufferCount := -1;
    FAddBufferCurrent := -1;
  end;
end;

procedure TVKSmartDBF.FlushAddBuffer;
var
  i, j, RealRead: Integer;
  lpMsgBuf: array [0..500] of AnsiChar;
  le: DWORD;
  NewKey: String;
  NewRec: LongInt;
  LockR, b: boolean;
  b1, b2: pAnsiChar;

begin

  if FAddBuffered then begin
    if FAddBufferCurrent > -1 then begin
      CheckActive;
      if LockHeader then begin
        try
          DBFHeader.last_rec := ( (DBFHandler.Seek(0, 2) - DBFHeader.data_offset) div DBFHeader.rec_size );
          NewRec := DBFHeader.last_rec + 1;
          DBFHandler.Seek(0, 2);
          DBFHandler.Seek(DBFHeader.data_offset + LongWord(DBFHeader.last_rec * FRecordSize), 0);
          //Crypt
          if Crypt.Active then begin
            for j := 0 to FAddBufferCurrent do begin
              b1 := FAddBuffer + j * DBFHeader.rec_size;
              b2 := FAddBufferCrypt + j * DBFHeader.rec_size;
              Move(b1^, b2^, DBFHeader.rec_size);
              Crypt.Encrypt(NewRec + j, b2, DBFHeader.rec_size);
            end;
            RealRead := DBFHandler.Write(FAddBufferCrypt^, DBFHeader.rec_size * ( FAddBufferCurrent + 1 ) );
          end else
            RealRead := DBFHandler.Write(FAddBuffer^, DBFHeader.rec_size * ( FAddBufferCurrent + 1 ) );
          if RealRead = -1 then begin
            le := GetLastError();
            FormatMessageA(
              FORMAT_MESSAGE_FROM_SYSTEM,
              nil,
              le,
              0, // Default language
              lpMsgBuf,
              500,
              nil
              );
            raise Exception.Create('TVKSmartDBF: ' + lpMsgBuf);
          end else begin
            Inc(DBFHeader.last_rec, FAddBufferCurrent + 1);
            DBFHandler.Seek(0, 0); //go to the begin
            RealRead := DBFHandler.Write(DBFHeader, SizeOf(DBFHeader));
            if RealRead = -1 then begin
              le := GetLastError();
              FormatMessageA(
                FORMAT_MESSAGE_FROM_SYSTEM,
                nil,
                le,
                0, // Default language
                lpMsgBuf,
                500,
                nil
                );
              raise Exception.Create('TVKSmartDBF: ' + lpMsgBuf);
            end else begin
              FIndState := true;
              try
                if Indexes <> nil then
                  for i := 0 to Indexes.Count - 1 do begin
                    b :=  ( (FAccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or
                          ( (FAccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) or
                          FFileLock;
                    LockR := Indexes[i].FLock;
                    if not b then Indexes[i].StartUpdate(false);
                    if LockR then
                      try
                        for j := 0 to FAddBufferCurrent do begin
                          FIndRecBuf := FAddBuffer + j * DBFHeader.rec_size;
                          NewKey := Indexes[i].EvaluteKeyExpr;
                          Indexes[i].AddKey(NewKey, NewRec + j);
                        end;
                      finally
                        if not b then Indexes[i].Flush;
                        Indexes[i].FUnLock;
                      end
                    else
                      raise Exception.Create('TVKSmartDBF.FlushAddBuffer: Can not add key to index file (FLock is false).');
                  end;
              finally
                FIndRecBuf := nil;
                FIndState := false;
              end;
            end;
          end;
        finally
          UnLockHeader;
        end;
      end else
        raise Exception.Create('TVKSmartDBF.FlushAddBuffer: Can not lock DBF header.');
    end;
    FAddBufferCurrent := -1;
  end;
end;

function TVKSmartDBF.GetOnEncrypt: TOnCrypt;
begin
  Result := FVKDBFCrypt.OnEncrypt;
end;

procedure TVKSmartDBF.SetOnDecrypt(const Value: TOnCrypt);
begin
  FVKDBFCrypt.OnDecrypt := Value;
end;

procedure TVKSmartDBF.SetOnEncrypt(const Value: TOnCrypt);
begin
  FVKDBFCrypt.OnEncrypt := Value;
end;

function TVKSmartDBF.GetOnDecrypt: TOnCrypt;
begin
  Result := FVKDBFCrypt.OnDecrypt;
end;

function TVKSmartDBF.GetOnCryptActivate: TNotifyEvent;
begin
  Result := FVKDBFCrypt.OnActivateCrypt;
end;

function TVKSmartDBF.GetOnCryptDeActivate: TNotifyEvent;
begin
  Result := FVKDBFCrypt.OnDeactivateCrypt;
end;

procedure TVKSmartDBF.SetOnCryptActivate(const Value: TNotifyEvent);
begin
  FVKDBFCrypt.OnActivateCrypt := Value;
end;

procedure TVKSmartDBF.SetOnCryptDeActivate(const Value: TNotifyEvent);
begin
  FVKDBFCrypt.OnDeactivateCrypt := Value;
end;

function TVKSmartDBF.SetAutoInc(const FieldName: AnsiString;
  Value: DWORD): boolean;
var
  oFld: TField;
begin
  Result := false;
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := SetAutoInc(oFld.FieldNo, Value);
end;

function TVKSmartDBF.SetAutoInc(const FieldNum: Integer;
  Value: DWORD): boolean;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := SetAutoInc(FieldNum, Value, 1);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.SetAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.SetAutoInc(const FieldNum: Integer; Value: DWORD; Dummy: Integer): boolean;
var
  qq: TVKDBFFieldDef;
  FR: FIELD_REC;
begin
  qq := TVKDBFFieldDef(Pointer(FieldByNumber(FieldNum).Tag));
  FR := qq.Field;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Read(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  if Dummy = 1 then
    FR.NextAutoInc := Value
  else
    FR.NativeNextAutoInc := Value;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Write(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  Result := true;
end;

function TVKSmartDBF.SetStepAutoInc(const FieldNum: Integer; Value: BYTE): boolean;
var
  qq: TVKDBFFieldDef;
  FR: FIELD_REC;
begin
  qq := TVKDBFFieldDef(Pointer(FieldByNumber(FieldNum).Tag));
  FR := qq.Field;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Read(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  FR.NativeStepAutoInc := Value;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Write(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  Result := true;
end;

function TVKSmartDBF.GetCurrentAutoInc(const FieldName: AnsiString): DWORD;
var
  oFld: TField;
begin
  Result := DWORD(-1);
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := GetCurrentAutoInc(oFld.FieldNo);
end;

function TVKSmartDBF.GetCurrentAutoInc(const FieldNum: Integer): DWORD;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := GetCurrentAutoInc(FieldNum, 1);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.GetCurrentAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.GetCurrentAutoInc(const FieldNum: Integer; Dummy: Integer): DWORD;
var
  qq: TVKDBFFieldDef;
  FR: FIELD_REC;
begin
  qq := TVKDBFFieldDef(Pointer(FieldByNumber(FieldNum).Tag));
  FR := qq.Field;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Read(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  if Dummy = 1 then
    Result := FR.NextAutoInc
  else
    Result := FR.NativeNextAutoInc;
end;

function TVKSmartDBF.GetNextAutoInc(const FieldName: AnsiString): DWORD;
var
  oFld: TField;
begin
  Result := DWORD(-1);
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := GetNextAutoInc(oFld.FieldNo);
end;

function TVKSmartDBF.GetNextAutoInc(const FieldNum: Integer): DWORD;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := GetNextAutoInc(FieldNum, 1);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.GetNextAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.GetNextAutoInc(const FieldNum: Integer; Dummy: Integer): DWORD;
var
  qq: TVKDBFFieldDef;
  FR: FIELD_REC;
begin
  qq := TVKDBFFieldDef(Pointer(FieldByNumber(FieldNum).Tag));
  FR := qq.Field;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Read(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  if Dummy = 1 then
    FR.NextAutoInc := FR.NextAutoInc + 1
  else
    FR.NativeNextAutoInc := FR.NativeNextAutoInc + FR.NativeStepAutoInc;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Write(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  if Dummy = 1 then
    Result := FR.NextAutoInc
  else
    Result := FR.NativeNextAutoInc - FR.NativeStepAutoInc;
end;

function TVKSmartDBF.GetStepAutoInc(const FieldNum: Integer): BYTE;
var
  qq: TVKDBFFieldDef;
  FR: FIELD_REC;
begin
  qq := TVKDBFFieldDef(Pointer(FieldByNumber(FieldNum).Tag));
  FR := qq.Field;
  DBFHandler.Seek(qq.FOffHD, soFromBeginning);
  DBFHandler.Read(FR.FIELD_REC_STRUCT^, FR.FIELD_REC_SIZE);
  Result := FR.NativeStepAutoInc;
end;

function TVKSmartDBF.SetNativeAutoInc(const FieldName: AnsiString;
  Value: DWORD): boolean;
var
  oFld: TField;
begin
  Result := false;
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := SetNativeAutoInc(oFld.FieldNo, Value);
end;

function TVKSmartDBF.SetNativeAutoInc(const FieldNum: Integer;
  Value: DWORD): boolean;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := SetAutoInc(FieldNum, Value, 2);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.SetAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.GetCurrentNativeAutoInc(const FieldName: AnsiString): DWORD;
var
  oFld: TField;
begin
  Result := DWORD(-1);
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := GetCurrentNativeAutoInc(oFld.FieldNo);
end;

function TVKSmartDBF.GetCurrentNativeAutoInc(const FieldNum: Integer): DWORD;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := GetCurrentAutoInc(FieldNum, 2);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.GetCurrentAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.GetNextNativeAutoInc(const FieldName: AnsiString): DWORD;
var
  oFld: TField;
begin
  Result := DWORD(-1);
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := GetNextNativeAutoInc(oFld.FieldNo);
end;

function TVKSmartDBF.GetNextNativeAutoInc(const FieldNum: Integer): DWORD;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := GetNextAutoInc(FieldNum, 2);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.GetNextAutoInc: Can not lock DBF header.');
end;

procedure TVKSmartDBF.Truncate;
begin
  CheckActive;
  if LockHeader then
    try
      DBFHeader.last_rec := 0;
      DBFHandler.Seek(0, 0);
      DBFHandler.Write(DBFHeader, SizeOf(DBF_HEAD));
      DBFHandler.Seek(DBFHeader.data_offset, 0);
      DBFHandler.SetEndOfFile;
      if LobHandler.IsOpen then begin
        LobHandler.Seek(0, 0);
        LobHandler.SetEndOfFile;
        FillLobHeader(DBFHeader.dbf_id, LobHandler, LobHeader);
      end;
      ReindexWithOutActivated;
    finally
      UnLockHeader;
      First;
    end
  else
    raise Exception.Create('TVKSmartDBF.Truncate: Can not lock DBF header.');
end;

procedure TVKSmartDBF.DataConvert(Field: TField; Source, Dest: Pointer;
  ToNative: Boolean);
var
  Len: Integer;
begin
  case Field.DataType of
    ftWideString:
      begin
        if ToNative then begin
          Len := PInteger(PAnsiChar(PWideChar(Source^)) - 4)^;
          Move(Pointer(PAnsiChar(PWideChar(Source^)) - 4)^, Dest^, Len + 6);
        end else begin
          PWideString(Dest)^ := PWideChar(PAnsiChar(Source) + 4);
        end;
      end;
  else
    inherited DataConvert(Field, Source, Dest, ToNative);
  end;
end;

{$IFDEF DELPHIXE3}
procedure TVKSmartDBF.DataConvert(Field: TField; Source: TValueBuffer;
  {$IFDEF DELPHIXE4}var{$ENDIF} Dest: TValueBuffer; ToNative: Boolean);
var
  Len: Integer;
begin
  case Field.DataType of
    ftWideString:
      begin
        if ToNative then begin
          Len := PInteger(PAnsiChar(PWideChar((@Source[0])^)) - 4)^;
          Move(Pointer(PAnsiChar(PWideChar((@Source[0])^)) - 4)^, Dest[0], Len + 6);
        end else begin
          PWideString(@Dest[0])^ := PWideChar(PAnsiChar(@Source[0]) + 4);
        end;
      end;
  else
    inherited DataConvert(Field, Source, Dest, ToNative);
  end;
end;
{$ENDIF DELPHIXE3}

procedure TVKSmartDBF.Zap;
begin
  Truncate;
end;

procedure TVKSmartDBF.ReindexAll;
var
  RecPareBuf, i, j: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  Rec: Integer;
  Offset: Integer;
begin
  if Indexes <> nil then begin
    CheckActive;
    if State = dsEdit then Post;
    if LockHeader then
      try

        for j := 0 to Indexes.Count - 1 do Indexes.Items[j].BeginCreateIndexProcess;

        IndState := true;
        try
          RecPareBuf := FBufferSize div Header.rec_size;
          if RecPareBuf >= 1 then begin
            ReadSize := RecPareBuf * Header.rec_size;

            Offset := Header.data_offset;
            Rec := 0;

            repeat

              Handle.Seek(Offset, 0);
              RealRead := Handle.Read(FLocateBuffer^, ReadSize);
              Inc(Offset, RealRead);

              BufCnt := RealRead div Header.rec_size;
              for i := 0 to BufCnt - 1 do begin
                IndRecBuf := FLocateBuffer + Header.rec_size * i;
                if Crypt.Active then
                  Crypt.Decrypt(Rec + 1, Pointer(IndRecBuf), FRecordSize);
                Inc(Rec);
                for j := 0 to Indexes.Count - 1 do Indexes.Items[j].EvaluteAndAddKey(Rec);
              end;

            until ( BufCnt <= 0 );

          end else raise Exception.Create('TVKSmartDBF.ReindexAll: Record size too large');

        finally
          for j := 0 to Indexes.Count - 1 do Indexes.Items[j].EndCreateIndexProcess;
          IndState := false;
          IndRecBuf := nil;
        end;


      finally
        UnLockHeader;
        First;
      end
    else
      raise Exception.Create('TVKSmartDBF.ReindexAll: Can not lock DBF header.');
  end;
end;

procedure TVKSmartDBF.ChangeFieldsCodeForAddFields(newDbf: TVKSmartDBF; fields: TVKDBFFieldDefs);
var
  i: Integer;
begin
  newDbf.DBFFieldDefs.Assign(self.FDBFFieldDefs);
  for i := 0 to pred(fields.Count) do
    newDbf.DBFFieldDefs.add.Assign(fields.Items[i]);
end;

procedure TVKSmartDBF.MoveRecordForAddFields(pRecordBuffer: pAnsiChar; newDbf: TVKSmartDBF);
begin
  Move(pRecordBuffer^, newDbf.FTempRecord^, FRecordSize);
end;

procedure TVKSmartDBF.ChangeFieldsCodeForDeleteFields(newDbf: TVKSmartDBF; fields: TVKDBFFieldDefs);
var
  i, j: Integer;
  fldDef, fldDef1: TVKDBFFieldDef;
begin
  for i := 0 to Pred(self.FDBFFieldDefs.Count) do begin
    fldDef := TVKDBFFieldDef(self.FDBFFieldDefs.Items[i]);
    for j := 0 to Pred(fields.Count) do begin
      fldDef1 := TVKDBFFieldDef(fields.Items[j]);
      if AnsiUpperCase(fldDef.Name) = AnsiUpperCase(fldDef1.Name) then begin
        fldDef.FMustBeDelete := True;
        break;
      end;
    end;
    if not fldDef.FMustBeDelete then
      newDbf.DBFFieldDefs.add.Assign(fldDef);
  end;
end;

procedure TVKSmartDBF.MoveRecordForDeleteFields(pRecordBuffer: pAnsiChar; newDbf: TVKSmartDBF);
var
  i: Integer;
  fldDef: TVKDBFFieldDef;
  ds: Word;
  byteCopied: Integer;
begin
  byteCopied := 1;
  //Copy delete mask first
  newDbf.FTempRecord^ := pRecordBuffer^;
  for i := 0 to Pred(self.FDBFFieldDefs.Count) do begin
    fldDef := TVKDBFFieldDef(self.FDBFFieldDefs.Items[i]);
    if not fldDef.FMustBeDelete then begin
      ds := fldDef.DataSize;
      Move((pRecordBuffer + fldDef.offset)^, (newDbf.FTempRecord + byteCopied)^, ds);
      Inc(byteCopied, ds);
    end else begin
      //if field is lob then delete field from lob storage
    end;
  end;
end;

procedure TVKSmartDBF.ChangeFieldsInternal(
  fields: TVKDBFFieldDefs;
  RecInBuffer: Integer;
  ChangeFieldsProc: TChangeFieldsProc;
  MoveRecordProc: TMoveRecordProc;
  TmpInCurrentPath: boolean = false);
var
  newDbf: TVKSmartDBF;
  TempNewName, TempNewDbtName, oldLobName: String;
  i: Integer;
  LastError: DWORD;
  LastErrorMes: String;
  RecPareBuf: Integer;
  ReadSize: Integer;
  Offset: Integer;
  Rec: Integer;
  RealRead: Integer;
  BufCnt: Integer;
  pLocBuffer: pAnsiChar;
begin
  CheckActive;
  if State = dsEdit then Post;
  newDbf := TVKSmartDBF.Create(self);
  try
    newDbf.DbfVersion := DbfVersion;
    // Change fields code
    ChangeFieldsProc(newDbf, fields);
    //
    if StorageType = pstFile then begin
      if TmpInCurrentPath then  //if TmpInCurrentPath = True then create TempNewName in current path
        TempNewName := GetTmpFileName(ExtractFilePath(DBFFileName))
      else  // else in system temporary directory
        TempNewName := GetTmpFileName;
      newDbf.DBFFileName := TempNewName;
    end else begin
      newDbf.StorageType := pstInnerStream;
    end;
    newDbf.AccessMode.AccessMode := 0;
    newDbf.AccessMode.OpenReadWrite := True;
    newDbf.AccessMode.ShareExclusive := True;
    newDbf.BufferSize := FBufferSize;
    newDbf.CreateTable; //may be with lob !!!
    try
      try
        newDbf.Crypt.Assign(Crypt);
        newDbf.Open;
        newDbf.BeginAddBuffered(RecInBuffer);
        try

          RecPareBuf := FBufferSize div Header.rec_size;
          if RecPareBuf >= 1 then begin
            ReadSize := RecPareBuf * Header.rec_size;

            Offset := Header.data_offset;
            Rec := 0;

            repeat

              Handle.Seek(Offset, 0);
              RealRead := Handle.Read(FLocateBuffer^, ReadSize);
              Inc(Offset, RealRead);

              BufCnt := RealRead div Header.rec_size;
              for i := 0 to BufCnt - 1 do begin

                Inc(Rec);

                pLocBuffer := FLocateBuffer + Header.rec_size * i;
                if Crypt.Active then
                  Crypt.Decrypt(Rec, pLocBuffer, FRecordSize);

                {$IFDEF DELPHI2009}
                newDbf.InternalInitRecord(pByte(newDbf.FTempRecord));
                {$ELSE}
                newDbf.InternalInitRecord(newDbf.FTempRecord);
                {$ENDIF}


                //Create new record code
                MoveRecordProc(pLocBuffer, newDbf);
                //

                newDbf.InternalAddRecord(newDbf.FTempRecord, True);

              end;

            until ( BufCnt <= 0 );

          end else raise Exception.Create('TVKSmartDBF.AddFields: Record size too large');

        finally
          newDbf.EndAddBuffered;
        end;

      finally
        newDbf.Close;
      end;
    finally
      Close;
      try
        if not Active then begin
          if StorageType = pstFile then begin
            if not DeleteFile(DBFFileName) then begin
              LastError := GetLastError;
              LastErrorMes := SysErrorMessage(LastError);
              raise Exception.Create('TVKSmartDBF.AddFields: Can not delete file "' + DBFFileName + '" !' +
                      #13#10 + '####> OS info' + #13#10 + 'Error code: ' + IntToStr(LastError) + #13#10 +
                      'Error message: ' + LastErrorMes);
            end;
            if not RenameFile(TempNewName, DBFFileName) then begin
              LastError := GetLastError;
              LastErrorMes := SysErrorMessage(LastError);
              raise Exception.Create('TVKSmartDBF.AddFields: Can not rename file "' + TempNewName + '" to "' + DBFFileName + '" !' +
                      #13#10 + '####> OS info' + #13#10 + 'Error code: ' + IntToStr(LastError) + #13#10 +
                      'Error message: ' + LastErrorMes);
            end;
            //if tmp lob exists then delete one.
            TempNewDbtName := ChangeFileExt(TempNewName, '.dbt');
            if FileExists(TempNewDbtName) then DeleteFile(TempNewDbtName);
            TempNewDbtName := ChangeFileExt(TempNewName, '.fpt');
            if FileExists(TempNewDbtName) then DeleteFile(TempNewDbtName);
            if not newDBF.FIsThereLob then begin
              oldLobName := ChangeFileExt(DBFFileName, '.dbt');
              if FileExists(oldLobName) then DeleteFile(oldLobName);
              oldLobName := ChangeFileExt(DBFFileName, '.fpt');
              if FileExists(oldLobName) then DeleteFile(oldLobName);
            end;
          end else begin
            InternalCopyTableInnerStreams(newDbf);
          end;
        end else begin
          raise Exception.Create('TVKSmartDBF.ChangeFieldsInternal:');
        end;
      finally
        Open;
      end;
    end;
  finally
    FreeAndNil(newDbf);
  end;
end;

procedure TVKSmartDBF.InternalCopyTableInnerStreams(oDbf: TVKSmartDBF);
var
 Dest1, Dest2: TStream;
begin
  Dest1 := nil;
  Dest2 := nil;
  if StorageType = pstInnerStream then
  begin
    Dest1 := DBFHandler.InnerStream;
    Dest2 := LobHandler.InnerStream;
  end else if StorageType = pstOuterStream then begin
    Dest1 := DBFHandler.OuterStream;
    Dest2 := LobHandler.OuterStream;
  end;
  if Dest1 <> nil then begin
    Dest1.Position := 0;
    Dest1.Size := 0;
    Dest1.CopyFrom(oDbf.DBFHandler.InnerStream, 0);
  end;
  if Dest2 <> nil then begin
    Dest2.Position := 0;
    Dest2.Size := 0;
    Dest2.CopyFrom(oDbf.LobHandler.InnerStream, 0);
  end;
end;

procedure TVKSmartDBF.AddFields(fields: TVKDBFFieldDefs; RecInBuffer: Integer; TmpInCurrentPath: boolean = false);
begin
  ChangeFieldsInternal(
    fields,
    RecInBuffer,
    ChangeFieldsCodeForAddFields,
    MoveRecordForAddFields,
    TmpInCurrentPath);
end;

procedure TVKSmartDBF.DeleteFields(fields: TVKDBFFieldDefs; RecInBuffer: Integer; TmpInCurrentPath: boolean = false);
begin
  ChangeFieldsInternal(
    fields,
    RecInBuffer,
    ChangeFieldsCodeForDeleteFields,
    MoveRecordForDeleteFields,
    TmpInCurrentPath);
end;

function TVKSmartDBF.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
begin
  Result := 9;
  if Bookmark1 = nil then
  begin
    if Bookmark2 <> nil then
      Result := -1
    else
      Result := 0;
  end else
    if Bookmark2 = nil then
      Result := 1;
  if Result = 9 then
  begin
    Result := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrComp(PAnsiChar(BookMark1),PAnsiChar(Bookmark2));
    if Result < 0 then
      Result := -1
    else
      if Result > 0 then
        Result := 1;
  end;
end;

function TVKSmartDBF.BookmarkValid(Bookmark: TBookmark): Boolean;
var
  q: LongWord;
begin
  Result := false;
  if Bookmark <> nil then begin
    q := pLongWord(Bookmark)^;
    if ( q > 0 ) and ( q <= LongWord(Header.last_rec) ) then Result := true;
  end;
end;

procedure TVKSmartDBF.DBEval;
var
  RecPareBuf, i: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  Rec: Integer;
  Offset: Integer;
  FLastFastPostRecord: boolean;
  ExitCode: Integer;
begin
  CheckActive;
  if State = dsEdit then Post;
  if LockHeader then
    try

      if Flock() then
        try

          FTmpActive := true;
          FLastFastPostRecord := FFastPostRecord;
          FFastPostRecord := true;

          try

            RecPareBuf := FBufferSize div Header.rec_size;
            if RecPareBuf >= 1 then begin
              ReadSize := RecPareBuf * Header.rec_size;

              Offset := Header.data_offset;
              Rec := 0;

              repeat

                Handle.Seek(Offset, 0);
                RealRead := Handle.Read(FLocateBuffer^, ReadSize);
                Inc(Offset, RealRead);

                BufCnt := RealRead div Header.rec_size;
                for i := 0 to BufCnt - 1 do begin

                  Inc(Rec);

                  Move((FLocateBuffer + Header.rec_size * i)^, FTempRecord^, FRecordSize);
                  if Crypt.Active then
                    Crypt.Decrypt(Rec, Pointer(FTempRecord), FRecordSize);
                  {$IFDEF DELPHI2009}
                  SetBookmarkData(pByte(FTempRecord), @Rec);
                  SetBookmarkFlag(pByte(FTempRecord), bfCurrent);
                  {$ELSE}
                  SetBookmarkData(FTempRecord, @Rec);
                  SetBookmarkFlag(FTempRecord, bfCurrent);
                  {$ENDIF}

                  if Assigned(FOnDBEval) then begin
                    ExitCode := 0;
                    FOnDBEval(self, Rec, ExitCode);
                    if ExitCode = 1 then Break;
                  end;

                end;

              until ( BufCnt <= 0 );

            end else raise Exception.Create('TVKSmartDBF.DBEval: Record size too large');

          finally
            FTmpActive := false;
            FFastPostRecord := FLastFastPostRecord;
          end;

        finally
          UnLock;
        end
      else
        raise Exception.Create('TVKSmartDBF.DBEval: Can not lock DBF table.');

    finally
      UnLockHeader;
      Refresh;
    end
  else
    raise Exception.Create('TVKSmartDBF.DBEval: Can not lock DBF header.');
end;

function TVKSmartDBF.GetOrder: AnsiString;
begin
  Result := '';
  if (FIndexes <> nil) and ( FIndexes.ActiveObject <> nil ) then Result := FIndexes.ActiveObject.Name;
end;

procedure TVKSmartDBF.SetOrderName(sOrd: AnsiString);
begin
  if csReading in ComponentState then
    FIndexName := sOrd
  else
    SetOrder(sOrd);
end;

procedure TVKSmartDBF.SetKey;
begin
  FSaveState := SetTempState(dsSetKey);
  {$IFDEF DELPHI2009}
  InternalInitRecord(pByte(FSetKeyBuffer));
  {$ELSE}
  InternalInitRecord(FSetKeyBuffer);
  {$ENDIF}
end;

procedure TVKSmartDBF.EditKey;
begin
  FSaveState := SetTempState(dsSetKey);
end;

procedure TVKSmartDBF.DropEditKey;
begin
  RestoreState(FSaveState);
end;

function TVKSmartDBF.GotoKey: boolean;
var
  RecN: Integer;
begin
  RecN := 0;
  Result := false;
  try
    if ( Indexes <> nil ) and ( Indexes.ActiveObject <> nil ) then
      RecN := Indexes.ActiveObject.FindKeyFields;
  finally
    RestoreState(FSaveState);
    if RecN > 0 then begin
      SetRecNoInternal(RecN);
      Result := True;
    end;
  end;
end;

procedure TVKSmartDBF.GotoNearest;
var
  RecN: Integer;
begin
  RecN := 0;
  try
    if ( Indexes <> nil ) and ( Indexes.ActiveObject <> nil ) then
      RecN := Indexes.ActiveObject.FindKeyFields(true);
  finally
    RestoreState(FSaveState);
    if RecN > 0 then
      SetRecNoInternal(RecN);
  end;
end;

function TVKSmartDBF.FindKey(const KeyValues: array of const): Boolean;
var
  RecN: Integer;
begin
  Result := false;
  if ( Indexes <> nil ) and ( Indexes.ActiveObject <> nil ) then begin
    RecN := Indexes.ActiveObject.FindKeyFields('', KeyValues, false, false);
    if RecN > 0 then begin
      SetRecNoInternal(RecN);
      Result := true;
    end;
  end;
end;

function TVKSmartDBF.FindNearest(const KeyValues: array of const): boolean;
var
  RecN: Integer;
begin
  Result := False;
  if ( Indexes <> nil ) and ( Indexes.ActiveObject <> nil ) then begin
    RecN := Indexes.ActiveObject.FindKeyFields('', KeyValues, true, true);
    if RecN > 0 then begin
      SetRecNoInternal(RecN);
      Result := true;
    end;
  end;
end;

function TVKSmartDBF.AcceptTmpRecord(nRec: DWORD): boolean;
begin
  if (not Filtered) and (Filter <> '') then
      FFilterParser.SetExprParams(Filter, FilterOptions, [poExtSyntax], '');
  SetTmpRecord(nRec);
  try
    Result := AcceptRecordInternal;
  finally
    CloseTmpRecord;
  end;
end;

function TVKSmartDBF.AcceptRecordInternal: boolean;
begin
  if not Filtered then begin
    if not FSetDeleted then
      Result := true
    else
      Result := not Deleted;
  end else
    Result := AcceptRecord;
  if  ( Result ) and
      ( Indexes <> nil ) and
      ( Indexes.ActiveObject <> nil ) and
      ( Indexes.ActiveObject.IsRanged ) then
        Result := Indexes.ActiveObject.InRange;
end;

procedure TVKSmartDBF.SetRecNoInternal(Value: Integer);
begin
  CursorPosChanged;
  DoBeforeScroll;
  GetBufferByRec(Value);
  Resync([]);
  DoAfterScroll;
end;

procedure TVKSmartDBF.Loaded;
begin
  inherited Loaded;
  IndexName := FIndexName;
  if FStreamedCreateNow then CreateNow := True;
  if FStreamedActive then Active := True;
end;

function TVKSmartDBF.GetInnerStream: TStream;
begin
  Result := DBFHandler.InnerStream;
end;

procedure TVKSmartDBF.SetActive(Value: Boolean);
begin
  if (csReading in ComponentState) then
  begin
    FStreamedActive := Value;
  end
  else
    inherited SetActive(Value);
end;

function TVKSmartDBF.GetInnerLobStream: TStream;
begin
  Result := LobHandler.InnerStream;
end;

procedure TVKSmartDBF.SetLobBlockSize(const Value: Integer);
begin
  FLobBlockSize := ( ( Value div 128 ) * 128 );
end;

procedure TVKSmartDBF.SetDbfVersion(const Value: xBaseVersion);
begin
  FDbfVersion := Value;
  FDBFFieldDefs.dBaseVersion := FDbfVersion;
end;

procedure TVKSmartDBF.SetLockProtocol(const Value: LockProtocolType);
begin
  if Active then raise Exception.Create('TVKSmartDBF.SetLockProtocol: Can''t change lock protocol while dataset is active!');
  FLockProtocol := Value;
end;

procedure TVKSmartDBF.SetLobLockProtocol(const Value: LockProtocolType);
begin
  if Active then raise Exception.Create('TVKSmartDBF.SetLobLockProtocol: Can''t change lock protocol while dataset is active!');
  FLobLockProtocol := Value;
end;

procedure TVKSmartDBF.BindDBFFieldDef;
var
  i: Integer;
  FieldFullName: String;
  F: TField;

  function HideBindDBFFieldDef(FDS: TVKDBFFieldDefs; Prefix: String = ''): boolean;
  var
    i: Integer;
    FD: TVKDBFFieldDef;
  begin
    Result := False;
    for i := 0 to FDS.Count - 1 do begin
      FD := FDS[i];
      if FD.FFieldDefRef <> nil then begin
        if Prefix + FD.Name = FieldFullName then begin
          F.Tag := Integer(Pointer(FD));
          Result := true;
          Exit;
        end;
      end;
      if FD.DBFFieldDefs.Count > 0 then begin
        Result := HideBindDBFFieldDef(FD.DBFFieldDefs, Prefix + FD.Name + '.');
        if Result then Exit;
      end;
    end;
  end;

begin

  for i := 0 to Fields.Count - 1 do begin
    F := Fields[i];
    FieldFullName := F.FullName;
    HideBindDBFFieldDef(DBFFieldDefs);
  end;

end;

procedure TVKSmartDBF.LobHandlerCreate;
begin
  LobHandler := TProxyStream.Create;
end;

procedure TVKSmartDBF.LobHandlerDestroy;
begin
  FreeAndNil(LobHandler);
end;

procedure TVKSmartDBF.FillLobHeader(dbf_id_p: Byte; LHandler: TProxyStream; var LHeader: LOB_HEAD);
begin
  (*
  $83:  // DBase III
  $8B:  // DBase IV
  $8C:  // DBase V .. VII
  $F5:  // FoxPro
  *)
  case dbf_id_p of
    $83: // DBase III
      begin
        LHandler.Write('This is Lob!', 12);
      end;
    $8B: // DBase IV
      begin
        FillChar(LHeader, SizeOf(LHeader), #0);
        LHeader.NextEmtyBlock := 1;
        LHeader.BlockLength := FLobBlockSize;
        LHandler.Write(LHeader, SizeOf(LHeader));
      end;
    $8C:  // DBase V .. VII
      begin
        FillChar(LHeader, SizeOf(LHeader), #0);
        LHeader.NextEmtyBlock := 1;
        LHeader.BlockLength := FLobBlockSize;
        LHandler.Write(LHeader, SizeOf(LHeader));
      end;
    $F5, $30, $31:  // FoxPro, VisualFoxPro
      begin
        if ( dbf_id_p in [$F5] ) or ( ( dbf_id_p in [$30, $31] ) and ( FLobVersion = xVisualFoxPro ) ) then begin
          FillChar(LHeader, SizeOf(LHeader), #0);
          LHeader.NextEmtyBlock := 1;
          LHeader.NextEmtyBlock := SwapInt(LHeader.NextEmtyBlock);
          pLongInt(@LHeader.Dummy[0])^ := SwapInt(FLobBlockSize);
          LHandler.Write(LHeader, SizeOf(LHeader));
        end;
      end;
  end;
end;

procedure TVKSmartDBF.CreateLobStream(dbf_id: Byte; IsThereLob: boolean);
begin
  LobHandler.AccessMode.AccessMode := AccessMode.AccessMode;
  LobHandler.ProxyStreamType := FStorageType;
  LobHandler.OuterStream := FOuterLobStream;
  // ( dbf_id in [$83, $8B, $8C, $F5] ) or ( ( dbf_id in [$30, $31] ) and ( FTableFlag.HasGotMemo ) )
  if IsThereLob then begin
    case dbf_id of
      $F5, $30, $31:  // FoxPro
        begin
          if ( dbf_id in [$F5] ) or ( ( dbf_id in [$30, $31] ) and ( FLobVersion = xVisualFoxPro ) ) then begin
            LobHandler.FileName := ChangeFileExt(DBFFileName, '.fpt');
            LobHandler.CreateProxyStream;
          end;
        end;
      else begin
        LobHandler.FileName := ChangeFileExt(DBFFileName, '.dbt');
        LobHandler.CreateProxyStream;
      end;
    end;
    FillLobHeader(dbf_id, LobHandler,  LobHeader);
    LobHandler.Close;
  end;
end;

procedure TVKSmartDBF.CloseLobStream;
begin
  if LobHandler.IsOpen then begin
    LobHandler.Close;
  end;
end;

procedure TVKSmartDBF.OpenLobStream(dbf_id: Byte);
begin
  (*
  $83:  // DBase III
  $8B:  // DBase IV
  $8C:  // DBase V .. VII
  $F5:  // FoxPro
  *)
  if dbf_id in [$83, $8B, $8C] then begin
    LobHandler.FileName := ChangeFileExt(DBFFileName, '.dbt');
    LobHandler.AccessMode.AccessMode := AccessMode.AccessMode;
    LobHandler.ProxyStreamType := FStorageType;
    LobHandler.OuterStream := FOuterLobStream;
    LobHandler.Open;
    if LobHandler.IsOpen then begin
      if dbf_id = $83 then begin
        FLobBlockSize := 512;
      end;
      if dbf_id = $8B then begin
        LobHandler.Read(LobHeader, SizeOf(LobHeader));
        FLobBlockSize := LobHeader.BlockLength;
      end;
      if dbf_id = $8C then begin
        LobHandler.Read(LobHeader, SizeOf(LobHeader));
        FLobBlockSize := LobHeader.BlockLength;
      end;
    end;
  end;
  if ( dbf_id in [$F5] ) or ( ( dbf_id in [$30, $31] ) and ( FLobVersion = xVisualFoxPro ) ) then begin
    LobHandler.FileName := ChangeFileExt(DBFFileName, '.fpt');
    LobHandler.AccessMode.AccessMode := AccessMode.AccessMode;
    LobHandler.ProxyStreamType := FStorageType;
    LobHandler.OuterStream := FOuterLobStream;
    LobHandler.Open;
    if LobHandler.IsOpen then begin
      LobHandler.Read(LobHeader, SizeOf(LobHeader));
      FLobBlockSize := SwapInt(pLongInt(@LobHeader.Dummy[0])^) and $FFFF;
      LobHeader.BlockLength := FLobBlockSize;
    end;
  end;
end;

procedure TVKSmartDBF.DoAfterOpen;
var
  i: Integer;
  oNested: TVKNestedDBF;
begin
  if Assigned(NestedDataSets) then
    for i := 0 to NestedDataSets.Count - 1 do begin
      oNested := TVKNestedDBF(NestedDataSets[i]);
      oNested.Close;
      oNested.Open;
    end;
  inherited DoAfterOpen;
end;

procedure TVKSmartDBF.RefreshBufferByRec(Rec: Integer);
var
  NewRec: Integer;
  WasEof, WasBof: boolean;
begin

  InternalSetCurrentIndex(Rec);

  WasEof := False;
  WasBof := False;

  FIndState := true;
  try
    repeat
      FIndRecBuf := FBuffer + FCurInd * FRecordSize;
      NewRec := pLongint(pAnsiChar(FBufInd) + FCurInd * SizeOf(Longint))^;
      if AcceptRecordInternal then Break
      else begin
        NextIndexBuf;
        if FEOF then begin
          WasEof := True;
          Break;
        end;
      end;
    until False;
    if FEOF then begin
      GetBufferByRec(Rec);
      repeat
        FIndRecBuf := FBuffer + FCurInd * FRecordSize;
        NewRec := pLongint(pAnsiChar(FBufInd) + FCurInd * SizeOf(Longint))^;
        if AcceptRecordInternal then Break
        else begin
          PriorIndexBuf;
          if FBOF then begin
            WasBof := True;
            Break;
          end;
        end;
      until False;
    end;
  finally
    FIndRecBuf := nil;
    FIndState := false;
  end;

  if WasEof and WasBof then begin
    // Clear buffer
    FCurInd := -1;
    FBufDir := bdFromTop;
    FBufCnt := 0;
    FBOF := True;
    FEOF := True;
  end else
    GetBufferByRec(NewRec);

end;

procedure TVKSmartDBF.InternalSetCurrentIndex(i: Integer);
var
  j: Integer;
begin
  for j := 0 to FBufCnt - 1 do begin
    if FBufDir = bdFromTop then
      if pLongint(pAnsiChar(FBufInd) + j * SizeOf(Longint))^ = i then begin
        FCurInd := j;
        FBOF := false;
        FEOF := false;
        Exit;
      end;
    if FBufDir = bdFromBottom then
      if pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - j) * SizeOf(Longint))^ = i then begin
        FCurInd := FRecordsPerBuf - j;
        FBOF := false;
        FEOF := false;
        Exit;
      end;
  end;
end;

procedure TVKSmartDBF.PackLobHandlerCreate;
begin
  FPackLobHandler := TProxyStream.Create;
end;

procedure TVKSmartDBF.PackLobHandlerOpen(TempLobName: AnsiString);
begin
  FPackLobHandler.FileName := TempLobName;
  FPackLobHandler.AccessMode.AccessMode := AccessMode.AccessMode;
  FPackLobHandler.ProxyStreamType := pstFile;
  FPackLobHandler.CreateProxyStream;
  FillLobHeader(DBFHeader.dbf_id, FPackLobHandler, PackLobHeader);
end;

procedure TVKSmartDBF.PackLobHandlerClose(LobName, TempLobName: AnsiString);
var
  LastError: DWORD;
  LastErrorMes: String;
begin
  //Copy new LOB into old LOB
  FPackLobHandler.Close;
  LobHandler.Close;
  case StorageType of
    pstFile:
      begin
        if not DeleteFile(LobName) then begin
          LastError := GetLastError;
          LastErrorMes := SysErrorMessage(LastError);
          raise Exception.Create('TVKSmartDBF.PackLobHandlerClose: Can not delete file "' + LobName + '" !' +
                  #13#10 + '####> OS info' + #13#10 + 'Error code: ' + IntToStr(LastError) + #13#10 +
                  'Error message: ' + LastErrorMes);
        end;
        if not RenameFile(TempLobName, LobName) then begin
          LastError := GetLastError;
          LastErrorMes := SysErrorMessage(LastError);
          raise Exception.Create('TVKSmartDBF.PackLobHandlerClose: Can not rename file "' + TempLobName + '" to "' + LobName + '" !' +
                  #13#10 + '####> OS info' + #13#10 + 'Error code: ' + IntToStr(LastError) + #13#10 +
                  'Error message: ' + LastErrorMes);
        end;
      end;
    pstInnerStream, pstOuterStream:
      begin
        LobHandler.LoadFromFile(TempLobName);
        DeleteFile(TempLobName);
      end;
  end;
  LobHandler.Open;
end;

procedure TVKSmartDBF.PackLobHandlerDestroy;
begin
  FPackLobHandler.Free;
end;

function TVKSmartDBF.GetPackLobHandler: TProxyStream;
begin
  Result := FPackLobHandler;
end;

function TVKSmartDBF.GetLobHandler: TProxyStream;
begin
  Result := LobHandler;
end;

function TVKSmartDBF.IsRLock(nRec: Integer): Boolean;
var
  UnlockResult: boolean;
begin
  Result := False;
  try
    case FLockProtocol of
      lpNone        : Result := True;
      lpDB4Lock     : Result := DBFHandler.Lock(DB4_LockMax - DWORD(nRec) - 1, 1);
      lpClipperLock : Result := DBFHandler.Lock(CLIPPER_LockMin + DWORD(nRec), 1);
      lpFoxLock     :
        begin
          if IsLockWithIndex then
            Result := DBFHandler.Lock(FOX_LockMax - DWORD(nRec), 1)
          else
            Result := DBFHandler.Lock(FOX_LockMin + ( DBFHeader.data_offset + ( ( DWORD(nRec)- 1 ) * DWORD(FRecordSize) ) ), 1);
        end;
      lpClipperForFoxLob: Result := DBFHandler.Lock(CLIPPER_FOR_FOX_LOB_LockMin + DWORD(nRec), 1);
    end;
  finally
    if Result then begin
      UnlockResult := False;
      case FLockProtocol of
        lpNone        : UnlockResult := True;
        lpDB4Lock     : UnlockResult := DBFHandler.UnLock(DB4_LockMax - DWORD(nRec) - 1, 1);
        lpClipperLock : UnlockResult := DBFHandler.UnLock(CLIPPER_LockMin + DWORD(nRec), 1);
        lpFoxLock     :
          begin
            if IsLockWithIndex then
              UnlockResult := DBFHandler.UnLock(FOX_LockMax - DWORD(nRec), 1)
            else
              UnlockResult := DBFHandler.UnLock(FOX_LockMin + ( DBFHeader.data_offset + ( ( DWORD( nRec )- 1 ) * DWORD( FRecordSize ) ) ), 1);
          end;
        lpClipperForFoxLob: UnlockResult := DBFHandler.UnLock(CLIPPER_FOR_FOX_LOB_LockMin + DWORD(nRec), 1);
      end;
      if not UnlockResult then
        raise Exception.Create('TVKSmartDBF.IsRLock: Can not Unlock checked lock record #' + IntToStr(nRec));
    end;
    Result := not Result;
  end;
end;

function TVKSmartDBF.IsRLock: Boolean;
begin
  Result := IsRLock(RecNo);
end;

procedure TVKSmartDBF.SetRange(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: variant);
begin
  //
end;

procedure TVKSmartDBF.SetRange(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: array of const);
begin
  //
end;

procedure TVKSmartDBF.ReCrypt(pNewCrypt: TVKDBFCrypt);
var
  i, k: Integer;
  RecPareBuf: Integer;
  ReadSize: Integer;
  Offset: Integer;
  Rec: Integer;
  RealRead: Integer;
  BufCnt: Integer;
  pLocBuffer: pAnsiChar;
  BlobFld: TBlobField;
  lb: TStream;
  DataSetFld: TDataSetField;
  NstDSet: TVKNestedDBF;
begin
  CheckActive;
  if State = dsEdit then Post;
  if LockHeader then
    try
      if Flock() then
        try
          FTmpActive := true;
          try
            Crypt.ReCryptObject := pNewCrypt;
            try
              RecPareBuf := FBufferSize div Header.rec_size;
              if RecPareBuf >= 1 then begin
                ReadSize := RecPareBuf * Header.rec_size;
                Offset := Header.data_offset;
                Rec := 0;
                repeat
                  Handle.Seek(Offset, 0);
                  RealRead := Handle.Read(FLocateBuffer^, ReadSize);
                  BufCnt := RealRead div Header.rec_size;
                  for i := 0 to BufCnt - 1 do begin
                    Inc(Rec);
                    pLocBuffer := FLocateBuffer + Header.rec_size * i;
                    if Crypt.Active then
                      Crypt.Decrypt(Rec, pLocBuffer, FRecordSize);
                    Move(pLocBuffer^, FTempRecord^, FRecordSize);
                    if LobHandler.IsOpen then begin
                      for k := 0 to Pred(Fields.Count) do
                        if Fields[k].IsBlob then begin
                          BlobFld := TBlobField(Fields[k]);
                          lb := CreateBlobStream(BlobFld, bmRead);
                          try
                            FSaveOnTheSamePlace := True;
                            try
                              BlobFld.LoadFromStream(lb);
                            finally
                              FSaveOnTheSamePlace := False;
                            end;
                          finally
                            lb.free;
                          end;
                        end;
                      for k := 0 to Pred(Fields.Count) do
                        if Fields[k].DataType = ftDataSet then begin
                          DataSetFld := TDataSetField(Fields[k]);
                          if not DataSetFld.IsNull then begin
                            NstDSet := TVKNestedDBF(DataSetFld.NestedDataSet);
                            NstDSet.Close;
                            NstDSet.Open;
                            NstDSet.ReCrypt(nil);
                            NstDSet.SaveOnTheSamePlaceToDBT;
                            NstDSet.Close;
                            FreeAndNil(NstDSet);
                          end;
                        end;
                    end;
                    if ( pNewCrypt <> nil ) and pNewCrypt.Active then
                      pNewCrypt.Encrypt(Rec, pLocBuffer, FRecordSize);
                  end;
                  Handle.Seek(Offset, 0);
                  Handle.Write(FLocateBuffer^, RealRead);
                  Inc(Offset, RealRead);
                until ( BufCnt <= 0 );
              end else raise Exception.Create('TVKSmartDBF.ReCrypt: Record size too large');
              if pNewCrypt <> nil then
                if Indexes <> nil then
                  for i := 0 to Pred(Indexes.Count) do
                    if not Indexes.Items[i].ReCrypt(pNewCrypt) then
                      raise Exception.Create('TVKSmartDBF.ReCrypt: Can not recrypt index!');
            finally
              if pNewCrypt <> nil then Crypt.Assign(pNewCrypt);
            end;
          finally
            FTmpActive := false;
          end;
        finally
          UnLock;
        end
      else
        raise Exception.Create('TVKSmartDBF.ReCrypt: Can not lock DBF table.');
    finally
      UnLockHeader;
      if pNewCrypt <> nil then Refresh;
    end
  else
    raise Exception.Create('TVKSmartDBF.ReCrypt: Can not lock DBF header.');
end;

function TVKSmartDBF.GetParentCryptObject: TVKDBFCrypt;
begin
  Result := FVKDBFCrypt;
end;

function TVKSmartDBF.SetNativeStepAutoInc(const FieldNum: Integer;
  Value: BYTE): boolean;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := SetStepAutoInc(FieldNum, Value);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.SetAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.SetNativeStepAutoInc(const FieldName: AnsiString;
  Value: BYTE): boolean;
var
  oFld: TField;
begin
  Result := false;
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := SetNativeStepAutoInc(oFld.FieldNo, Value);
end;

function TVKSmartDBF.GetNativeStepAutoInc(const FieldNum: Integer): BYTE;
begin
  CheckActive;
  if LockHeader then begin
    try
      Result := GetStepAutoInc(FieldNum);
    finally
      UnLockHeader;
    end
  end else
    raise Exception.Create('TVKSmartDBF.GetNextAutoInc: Can not lock DBF header.');
end;

function TVKSmartDBF.GetNativeStepAutoInc(const FieldName: AnsiString): BYTE;
var
  oFld: TField;
begin
  Result := BYTE(-1);
  oFld := FindField(FieldName);
  if oFld <> nil then
    Result := GetNativeStepAutoInc(oFld.FieldNo);
end;

{ TVKDBFNTX }

procedure TVKDBFNTX.ClearRange;
begin
  if Indexes.ActiveObject <> nil then
    TVKNTXIndex(Indexes.ActiveObject).NTXRange.Active := false;
end;

constructor TVKDBFNTX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLockProtocol := lpClipperLock;
  FLobLockProtocol := lpClipperLock;
  FIndexes := TIndexes.Create(self, TVKNTXIndex);
  FDBFIndexDefs := TVKDBFIndexDefs.Create(self, TVKNTXBag);
end;

procedure TVKDBFNTX.DefineProperties(Filer: TFiler);

  function WriteDBFFieldDefDataB: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FDBFFieldDefs.IsEqual(TVKSmartDBF(Filer.Ancestor).FDBFFieldDefs)
    else
      Result := (FDBFFieldDefs.Count > 0);
  end;

  function WriteDBFIndexDefDataB: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FDBFIndexDefs.IsEqual(TVKSmartDBF(Filer.Ancestor).FDBFIndexDefs)
    else
      Result := (FDBFIndexDefs.Count > 0);
  end;

begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('DBFFieldDefs', ReadDBFFieldDefData, WriteDBFFieldDefData, WriteDBFFieldDefDataB);
  Filer.DefineProperty('DBFIndexDefs', ReadDBFIndexDefData, WriteDBFIndexDefData, WriteDBFIndexDefDataB);
end;

destructor TVKDBFNTX.Destroy;
begin
  Active := false;
  FIndexes.Destroy;
  FIndexes := nil;
  FDBFIndexDefs.Destroy;
  FDBFIndexDefs := nil;
  inherited Destroy;
end;

procedure TVKDBFNTX.SetRange(FieldList: AnsiString; FieldValues: array of const);
begin
  Indexes[GetSuitableIndex(FieldList)].SetRangeFields(FieldList, FieldValues);
end;

procedure TVKDBFNTX.ReadDBFFieldDefData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(DBFFieldDefs);
end;

procedure TVKDBFNTX.SetRange(FieldList: AnsiString; FieldValues: variant);
begin
  Indexes[GetSuitableIndex(FieldList)].SetRangeFields(FieldList, FieldValues);
end;

procedure TVKDBFNTX.WriteDBFFieldDefData(Writer: TWriter);
begin
  Writer.WriteCollection(DBFFieldDefs);
end;

function TVKDBFNTX.GetOrdersByNum(Index: Integer): TVKNTXIndex;
begin
  if (FIndexes <> nil) then
    Result := TVKNTXIndex(Indexes[Index])
  else
    Result := nil;
end;

function TVKDBFNTX.GetOrdersByName(const Index: AnsiString): TVKNTXIndex;
var
  i: Integer;
begin
  Result := nil;
  if (FIndexes <> nil) then begin
    for i := 0 to FIndexes.Count - 1 do
      if UpperCase(FIndexes[i].Name) = UpperCase(Index) then begin
        Result := TVKNTXIndex(Indexes[i]);
        Break;
      end;
  end;
end;

procedure TVKDBFNTX.ReadDBFIndexDefData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(DBFIndexDefs);
end;

procedure TVKDBFNTX.WriteDBFIndexDefData(Writer: TWriter);
begin
  Writer.WriteCollection(DBFIndexDefs);
end;

function TVKDBFNTX.GetSuitableIndex(FieldList: AnsiString): Integer;
var
  m, i, j, k, l, n, p, o: Integer;

  procedure CntFld;
  var
    I: Integer;
  begin
    I := p;
    while (I <= Length(FieldList)) and (FieldList[I] <> ';') do Inc(I);
    Inc(o);
    if (I <= Length(FieldList)) and (FieldList[I] = ';') then Inc(I);
    p := I;
  end;

begin
  m := 0;
  k := 0;
  o := 0;
  p := 1;
  while p <= Length(FieldList) do CntFld;
  j := Indexes.Count - 1;
  for i := 0 to j do begin
    l := Indexes[i].SuiteFieldList(FieldList, n);
    if l > m then begin
      m := l;
      k := i;
    end;
  end;
  if (m > 0) and (o = m) then
    Result := k
  else
    raise Exception.Create('TVKSmartDBF: There is no suitable index!');
end;

procedure TVKDBFNTX.SetRange(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: variant);
begin
  Indexes[GetSuitableIndex(FieldList)].SetRangeFields(FieldList, FieldValuesLow, FieldValuesHigh);
end;

procedure TVKDBFNTX.SetRange(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: array of const);
begin
  Indexes[GetSuitableIndex(FieldList)].SetRangeFields(FieldList, FieldValuesLow, FieldValuesHigh);
end;

{ TVKDBFCDX }

constructor TVKDBFCDX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLockProtocol := lpFoxLock;
  FLobLockProtocol := lpFoxLock;
  FIndexes := TIndexes.Create(self, TVKCDXIndex);
  FDBFIndexDefs := TVKDBFIndexDefs.Create(self, TVKCDXBag);
end;

procedure TVKDBFCDX.DefineProperties(Filer: TFiler);

  function WriteDBFFieldDefDataB: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FDBFFieldDefs.IsEqual(TVKSmartDBF(Filer.Ancestor).FDBFFieldDefs)
    else
      Result := (FDBFFieldDefs.Count > 0);
  end;

  function WriteDBFIndexDefDataB: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FDBFIndexDefs.IsEqual(TVKSmartDBF(Filer.Ancestor).FDBFIndexDefs)
    else
      Result := (FDBFIndexDefs.Count > 0);
  end;
  
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('DBFFieldDefs', ReadDBFFieldDefData, WriteDBFFieldDefData, WriteDBFFieldDefDataB);
  Filer.DefineProperty('DBFIndexDefs', ReadDBFIndexDefData, WriteDBFIndexDefData, WriteDBFIndexDefDataB);
end;

destructor TVKDBFCDX.Destroy;
begin
  Active := false;
  FDBFIndexDefs.Destroy;
  FDBFIndexDefs := nil;
  FIndexes.Destroy;
  FIndexes := nil;
  inherited Destroy;
end;

procedure TVKDBFCDX.ReadDBFFieldDefData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(DBFFieldDefs);
end;

procedure TVKDBFCDX.ReadDBFIndexDefData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(DBFIndexDefs);
end;

procedure TVKDBFCDX.WriteDBFFieldDefData(Writer: TWriter);
begin
  Writer.WriteCollection(DBFFieldDefs);
end;

procedure TVKDBFCDX.WriteDBFIndexDefData(Writer: TWriter);
begin
  Writer.WriteCollection(DBFIndexDefs);
end;

{ TVKDataLink }

procedure TVKDataLink.DataEvent(Event: TDataEvent; Info: {$IFDEF DELPHIXE2}NativeInt{$ELSE}Integer{$ENDIF});
begin
  inherited;
  if Event = deDataSetChange then begin
    if FDBFDataSet.FRange then begin
      if FDBFDataSet.ListMasterFields.Count = 0 then
        DataSet.GetFieldList(FDBFDataSet.ListMasterFields, FDBFDataSet.FMasterFields);
      FDBFDataSet.SetRange(FDBFDataSet.FMasterFields, FDBFDataSet.GetMasterFields);
    end else begin
      if bof then FDBFDataSet.First;
      if eof then FDBFDataSet.Last;
    end;
  end;
end;

procedure TVKDataLink.DataSetScrolled(Distance: Integer);
begin
  inherited;
  if FDBFDataSet.FRange then begin
    if FDBFDataSet.ListMasterFields.Count = 0 then
      DataSet.GetFieldList(FDBFDataSet.ListMasterFields, FDBFDataSet.FMasterFields);
    FDBFDataSet.SetRange(FDBFDataSet.FMasterFields, FDBFDataSet.GetMasterFields);
  end else
    FDBFDataSet.MoveBy(Distance);
end;

{ TVKDBFFieldDefs }

procedure TVKDBFFieldDefs.AssignValues(Value: TVKDBFFieldDefs);
var
  I: Integer;
  P: TVKDBFFieldDef;
begin
  for I := 0 to Value.Count - 1 do
  begin
    P := FindIndex(Value[I].Name);
    if P <> nil then
      P.Assign(Value[I]);
  end;
end;

constructor TVKDBFFieldDefs.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TVKDBFFieldDef);
  FIsThereAutoInc := False;
  FVFPNullsOffset := 0;
  FVFPNullsLength := 0;
end;

function TVKDBFFieldDefs.FindIndex(const Value: AnsiString): TVKDBFFieldDef;

  function HideFindIndex(FDS: TVKDBFFieldDefs; var FD: TVKDBFFieldDef): boolean;
  var
    i: Integer;
  begin
    for i := 0 to FDS.Count - 1 do
    begin
      FD := TVKDBFFieldDef(FDS.Items[i]);
      if FD <> nil then begin
        if AnsiCompareText(FD.Name, Value) = 0 then begin
          Result := true;
          Exit;
        end;
        if FD.DBFFieldDefs.Count > 0 then begin
          Result := HideFindIndex(FD.DBFFieldDefs, FD);
          if Result then Exit;
        end;
      end;
    end;
    Result := False;
  end;

begin

  Result := nil;
  HideFindIndex(self, Result);

end;

{$IFDEF VER130}
function TVKDBFFieldDefs.GetCollectionOwner: TPersistent;
begin
  Result := GetOwner;
end;
{$ENDIF}

function TVKDBFFieldDefs.GetItem(Index: Integer): TVKDBFFieldDef;
begin
  Result := TVKDBFFieldDef(inherited Items[Index]);
end;

function TVKDBFFieldDefs.IsEqual(Value: TVKDBFFieldDefs): Boolean;
var
  I: Integer;
begin
  Result := (Count = Value.Count);
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := TVKDBFFieldDef(Items[I]).IsEqual(TVKDBFFieldDef(Value.Items[I]));
      if not Result then Break;
    end
end;

procedure TVKDBFFieldDefs.SetdbfVersion(const Value: xBaseVersion);
var
  i: Integer;
begin
  FdbfVersion := Value;
  for i := 0 to pred(Count) do
    TVKDBFFieldDef(Items[i]).dBaseVersion := FdbfVersion;
end;

procedure TVKDBFFieldDefs.SetItem(Index: Integer; const Value: TVKDBFFieldDef);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

{ TVKDBFFieldDef }

procedure TVKDBFFieldDef.AssignTo(Dest: TPersistent);
begin
  with Dest as TVKDBFFieldDef do begin
    Name := self.Name;
    field_type := self.field_type;
    extend_type := self.extend_type;
    NextAutoInc := self.NextAutoInc;
    NativeNextAutoInc := self.NativeNextAutoInc;
    NativeStepAutoInc := self.NativeStepAutoInc;
    len := self.len;
    dec := self.dec;
    FOff := self.FOff;
    FOffHD := self.FOffHD;
    FDBFFieldDefs.Assign(self.FDBFFieldDefs);
  end;
end;

constructor TVKDBFFieldDef.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FMustBeDelete := False;
  FFieldFlag := TFieldFlag.Create;
  FieldRec := FIELD_REC.Create;
  FieldRec.FIELD_REC_VER := TVKDBFFieldDefs(Collection).FdbfVersion;
  FieldRec.Set_NextAutoInc(0);
  FieldRec.Set_NativeNextAutoInc(1);
  FieldRec.Set_NativeStepAutoInc(1);
  FDBFFieldDefs := TVKDBFFieldDefs.Create(self);
  FDBFFieldDefs.dBaseVersion := dBaseVersion;
  FTag := 0;
end;

procedure TVKDBFFieldDef.DefineProperties(Filer: TFiler);

  function WriteDBFFieldDefDataB: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FDBFFieldDefs.IsEqual(TVKDBFFieldDef(Filer.Ancestor).FDBFFieldDefs)
    else
      Result := (FDBFFieldDefs.Count > 0);
  end;

begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('DBFFieldDefs', ReadDBFFieldDefData, WriteDBFFieldDefData, WriteDBFFieldDefDataB);
end;

procedure TVKDBFFieldDef.ReadDBFFieldDefData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(DBFFieldDefs);
end;

procedure TVKDBFFieldDef.WriteDBFFieldDefData(Writer: TWriter);
begin
  Writer.WriteCollection(DBFFieldDefs);
end;

destructor TVKDBFFieldDef.Destroy;
begin
  FDBFFieldDefs.Destroy;
  FreeAndNil(FieldRec);
  FreeAndNil(FFieldFlag);
  inherited Destroy;
end;

function TVKDBFFieldDef.GetDataSize: Word;
begin
  //C N D L M     E
  case FieldRec.field_type of
    'Y', 'T': Result := 8;
    'I', '+': Result := 4;  //Longint
    'O', '@': Result := 8; //Int64
    'C', 'N', 'F', '0': Result := len;
    'D': Result := 8;
    'L': Result := 1;
    'M', 'P':
      begin
        if dBaseVersion = xVisualFoxPro then
          Result := 4
        else
          Result := 10;
      end;
    'B', 'G':
      begin
        if dBaseVersion = xVisualFoxPro then
          Result := 4
        else
          Result := 10;
      end;
    'E':
      case FieldRec.extend_type of
        dbftS1:     Result := 1;  //Shortint
        dbftU1:     Result := 1;  //Byte
        dbftS2:     Result := 2;  //Smallint
        dbftU2:     Result := 2;  //Word
        dbftS4:     Result := 4;  //Longint
        dbftU4:     Result := 4;  //Longword
        dbftS8:     Result := 8;  //Int64
        dbftR4:     Result := 4;  //Single
        dbftR6:     Result := 6;  //Real48
        dbftR8:     Result := 8;  //Double
        dbftR10:    Result := 10; //Extended
        dbftD1:     Result := 8;  //TDateTime
        dbftD2:     Result := 8;  //DataSet DateTime
        dbftD3:     Result := 6;  //Real48 DateTime
        dbftS1_N:   Result := 2;  //Shortint with NULL
        dbftU1_N:   Result := 2;  //Byte  with NULL
        dbftS2_N:   Result := 3;  //Smallint with NULL
        dbftU2_N:   Result := 3;  //Word with NULL
        dbftS4_N:   Result := 5;  //Longint with NULL
        dbftU4_N:   Result := 5;  //Longword with NULL
        dbftS8_N:   Result := 9;  //Int64 with NULL
        dbftR4_N:   Result := 5;  //Single with NULL
        dbftR6_N:   Result := 7;  //Real48 with NULL
        dbftR8_N:   Result := 9;  //Double with NULL
        dbftR10_N:  Result := 11; //Extended with NULL
        dbftD1_N:   Result := 9;  //TDateTime with NULL
        dbftD2_N:   Result := 9;  //DataSet DateTime with NULL
        dbftD3_N:   Result := 7;  //Real48 DateTime
        dbftClob,
        dbftBlob,
        dbftGraphic,
        dbftFmtMemo:
          begin
            if dBaseVersion = xVisualFoxPro then
              Result := 4
            else
              Result := 10;
          end;
        dbftClob_NB:   Result := 4;
        dbftBlob_NB:   Result := 4;
        dbftGraphic_NB:  Result := 4;
        dbftFmtMemo_NB:  Result := 4;

        dbftString:   Result := len + 2;
        dbftString_N: Result := len + 3;
        dbftFixedChar: Result := len + 1;
        dbftWideString: Result := len * 2 + 4;
        dbftCurrency: Result := 8;
        dbftCurrency_N: Result := 9;
        dbftCurrency_NB: Result := 8;
        dbftBCD: Result := SizeOf(TBcd);
        dbftDate:   Result := 4;  //ftDate
        dbftDate_N:   Result := 5;  //ftDate with NULL byte
        dbftTime:   Result := 4;  //ftTime
        dbftTime_N:   Result := 5;  //ftTime with NULL byte
        dbftU1_NB: Result := 1;
        dbftU2_NB: Result := 2;
        dbftU4_NB: Result := 4;
        dbftR4_NB: Result := 4;
        dbftR6_NB: Result := 6;
        dbftR8_NB: Result := 8;
        dbftD1_NB: Result := 8;
        dbftD2_NB: Result := 8;
        dbftD3_NB: Result := 6;
        dbftDate_NB: Result := 4;
        dbftTime_NB: Result := 4;

        dbftDBFDataSet,
        dbftDBFDataSet_NB:
          begin
            if dBaseVersion = xVisualFoxPro then
              Result := 4
            else
              Result := 10;
          end;

      else
        raise Exception.Create('Extend_type incarect!');
      end;
  else
    raise Exception.Create('Field_type incarect!');
  end;
end;

function TVKDBFFieldDef.GetDisplayName: String;
begin
  Result := FieldRec.field_name;
end;

function TVKDBFFieldDef.GetField: FIELD_REC;
begin
  //C N D L M     F  B G       E
  case FieldRec.field_type of
    'Y':
      begin
        FieldRec.lendth.num_len.len := Byte(len);
        FieldRec.lendth.num_len.dec := Byte(dec);
      end;
    '+', 'I', 'O', '@', 'T':
      begin
        FieldRec.lendth.num_len.len := Byte(0);
        FieldRec.lendth.num_len.dec := Byte(0);
      end;
    'C', '0':
      begin
        FieldRec.lendth.char_len := len;
      end;
    'N', 'F':
      begin
        FieldRec.lendth.num_len.len := Byte(len);
        FieldRec.lendth.num_len.dec := Byte(dec);
      end;
    'D':
      begin
        FieldRec.lendth.num_len.len := Byte(8);
        FieldRec.lendth.num_len.dec := Byte(0);
      end;
    'L':
      begin
        FieldRec.lendth.num_len.len := Byte(1);
        FieldRec.lendth.num_len.dec := Byte(0);
      end;
    'M', 'P':
      begin
        if dBaseVersion = xVisualFoxPro then begin
          FieldRec.lendth.num_len.len := Byte(0);
          FieldRec.lendth.num_len.dec := Byte(0);
        end else begin
          FieldRec.lendth.num_len.len := Byte(10);
          FieldRec.lendth.num_len.dec := Byte(0);
        end;
      end;
    'B', 'G':
      begin
        if dBaseVersion = xVisualFoxPro then begin
          FieldRec.lendth.num_len.len := Byte(0);
          FieldRec.lendth.num_len.dec := Byte(0);
        end else begin
          FieldRec.lendth.num_len.len := Byte(10);
          FieldRec.lendth.num_len.dec := Byte(0);
        end;
      end;
    'E':
      begin
        if FieldRec.extend_type in [  dbftString, dbftString_N,
                                      dbftFixedChar, dbftWideString] then begin
          //FieldRec.lendth.num_len.len := Byte(len);
          FieldRec.lendth.char_len := len;
        end else if FieldRec.extend_type in [dbftBCD, dbftCurrency_N, dbftCurrency_NB] then begin
          FieldRec.lendth.num_len.len := Byte(len);
          FieldRec.lendth.num_len.dec := Byte(dec);
        end else begin
          FieldRec.lendth.num_len.len := Byte(0);
          FieldRec.lendth.num_len.dec := Byte(0);
        end;
      end;
  else
    raise Exception.Create('Field_type incarect!');
  end;
  Result := FieldRec;
end;

function TVKDBFFieldDef.IsEqual(Value: TVKDBFFieldDef): Boolean;
begin
  Result := false;
  if Value.Name = Name then Result := true;
  if Result then begin
    if ( Value.DBFFieldDefs.Count = DBFFieldDefs.Count ) then
      Result := DBFFieldDefs.IsEqual(Value.DBFFieldDefs);
  end;
end;

procedure TVKDBFFieldDef.SetDBFFieldDefs(const Value: TVKDBFFieldDefs);
begin
  FDBFFieldDefs := Value;
end;

procedure TVKDBFFieldDef.SetDisplayName(const Value: String);
begin
  FieldRec.FeildName := AnsiString(Value);
end;

function TVKDBFFieldDef.Get_field_type: AnsiChar;
begin
  Result := FieldRec.field_type;
end;

procedure TVKDBFFieldDef.Set_field_type(const Value: AnsiChar);
begin
  FieldRec.field_type := Value;
end;

function TVKDBFFieldDef.Get_extend_type: TVKDBFType;
begin
  Result := FieldRec.extend_type;
end;

procedure TVKDBFFieldDef.Set_extend_type(const Value: TVKDBFType);
begin
  FieldRec.extend_type := Value;
end;

function TVKDBFFieldDef.GetDBaseVersion: xBaseVersion;
begin
  Result := FieldRec.FFIELD_REC_VER;
end;

procedure TVKDBFFieldDef.SetDBaseVersion(const Value: xBaseVersion);
begin
  FieldRec.FFIELD_REC_VER := Value;
  FDBFFieldDefs.dBaseVersion := Value;
end;

function TVKDBFFieldDef.GetVKDBFFieldDefs: TVKDBFFieldDefs;
begin
  Result := TVKDBFFieldDefs(Collection);
end;

function TVKDBFFieldDef.Get_NativeStepAutoInc: Byte;
begin
  Result := FieldRec.Get_NativeStepAutoInc;
end;

procedure TVKDBFFieldDef.Set_NativeStepAutoInc(const Value: Byte);
begin
  FieldRec.Set_NativeStepAutoInc(Value);
end;

function TVKDBFFieldDef.Get_NativeNextAutoInc: DWord;
begin
  Result := FieldRec.Get_NativeNextAutoInc;
end;

procedure TVKDBFFieldDef.Set_NativeNextAutoInc(const Value: DWord);
begin
  FieldRec.Set_NativeNextAutoInc(Value);
end;

function TVKDBFFieldDef.Get_NextAutoInc: DWord;
begin
  Result := FieldRec.Get_NextAutoInc;
end;

procedure TVKDBFFieldDef.Set_NextAutoInc(const Value: DWord);
begin
  FieldRec.Set_NextAutoInc(value);
end;

{ TVKDBTStream }

procedure TVKDBTStream.Clear;
begin
  inherited Clear;
  FModified := true;
end;

constructor TVKDBTStream.Create;
begin
  inherited Create;
  FModified := false;
end;

constructor TVKDBTStream.CreateDBTStream(dbf: TVKSmartDBF; field: TField);
begin
  inherited Create;
  FModified := false;
  FSmartDBF := dbf;
  FField := field;
end;

destructor TVKDBTStream.Destroy;
begin
  if FModified then
    SaveToDBT;
  inherited Destroy;
end;

procedure TVKDBTStream.SaveToDBT;
begin
  FSmartDBF.SaveToDBT(self, FField);
end;

procedure TVKDBTStream.SetSize(NewSize: Integer);
begin
  inherited SetSize(NewSize);
  FModified := true;
end;

function TVKDBTStream.Write(const Buffer; Count: Integer): Longint;
begin
  FModified := true;
  Result := inherited Write(Buffer, Count);
end;

{$IFDEF DELPHIXE3}
function TVKDBTStream.Write(const Buffer: TBytes; Offset,
  Count: Integer): Longint;
begin
  FModified := true;
  Result := inherited Write(Buffer, Offset, Count);
end;
{$ENDIF DELPHIXE3}

{ TVKNestedDBF }

procedure TVKNestedDBF.CloseLobStream;
begin
  // Nothing to do
end;

constructor TVKNestedDBF.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  StorageType := pstInnerStream;
end;

procedure TVKNestedDBF.CreateLobStream(dbf_id: Byte; IsThereLob: boolean);
begin
  LobHandler := ParentDataSet.LobHandler;
end;

procedure TVKNestedDBF.DataEvent(Event: TDataEvent; Info: {$IFDEF DELPHIXE2}NativeInt{$ELSE}Integer{$ENDIF});
var
  i: Integer;
  oNested: TVKNestedDBF;
begin
  case Event of
    deFieldChange: ParentDataSet.DataEvent(deFieldChange, Info);
    deParentScroll:
      begin
        Close;
        Open;
        for i := 0 to NestedDataSets.Count - 1 do begin
          oNested := TVKNestedDBF(NestedDataSets[i]);
          oNested.DataEvent(Event, Info);
        end;
      end;
  end;
  inherited DataEvent(Event, Info);
end;

procedure TVKNestedDBF.DeleteRecallRecord(Del: boolean = true);
begin
  inherited DeleteRecallRecord(Del);
  SaveOnTheSamePlaceToDBT(TMemoryStream(self.InnerStream), DataSetField);
end;

function TVKNestedDBF.GetPackLobHandler: TProxyStream;
begin
  Result := nil;
  if ParentDataSet <> nil then Result := ParentDataSet.PackLobHandler;
end;

function TVKNestedDBF.GetParentCryptObject: TVKDBFCrypt;
begin
  Result := ParentDataSet.GetParentCryptObject;
end;

function TVKNestedDBF.GetParentDataSet: TVKSmartDBF;
begin
  Result := nil;
  if DataSetField <> nil then
    Result := DataSetField.DataSet as TVKSmartDBF;
end;

procedure TVKNestedDBF.InternalClose;
begin
  inherited InternalClose;
end;

procedure TVKNestedDBF.InternalOpen;
begin
  ParentDataSet.CreateNestedStream(self, DataSetField, self.InnerStream);
  OEM := ParentDataSet.OEM;
  SetDeleted := ParentDataSet.SetDeleted;
  inherited InternalOpen;
end;

procedure TVKNestedDBF.InternalPost;
begin
  inherited InternalPost;
  SaveToDBT(TMemoryStream(self.InnerStream), DataSetField);
end;

procedure TVKNestedDBF.LobHandlerCreate;
begin
  // Nothing to do
end;

procedure TVKNestedDBF.LobHandlerDestroy;
begin
  // Nothing to do
end;

procedure TVKNestedDBF.OpenLobStream(dbf_id: Byte);
begin
  // Nothing to do
end;

procedure TVKNestedDBF.PackLobHandlerClose(LobName, TempLobName: AnsiString);
begin
  SaveToDBT(TMemoryStream(self.InnerStream), DataSetField);
end;

procedure TVKNestedDBF.PackLobHandlerCreate;
begin
  // Nothing to do
end;

procedure TVKNestedDBF.PackLobHandlerDestroy;
begin
  // Nothing to do
end;

procedure TVKNestedDBF.PackLobHandlerOpen(TempLobName: AnsiString);
begin
  // Nothing to do
end;

procedure TVKNestedDBF.SaveOnTheSamePlaceToDBT;
begin
  SaveOnTheSamePlaceToDBT(TMemoryStream(self.InnerStream), DataSetField);
end;

procedure TVKNestedDBF.SaveToDBT;
begin
  SaveToDBT(TMemoryStream(self.InnerStream), DataSetField);
end;

procedure TVKNestedDBF.SetDataSetField(const Value: TDataSetField);
begin
  inherited SetDataSetField(Value);
  if ParentDataSet <> nil then begin
    FDbfVersion := ParentDataSet.FDbfVersion;
    FLobVersion := ParentDataSet.FLobVersion;
    FLobBlockSize := ParentDataSet.FLobBlockSize;
    LobHandler := ParentDataSet.LobHandler;
  end;
end;

{ FIELD_REC }

function FIELD_REC.Get_extend_type: TVKDBFType;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.extend_type
  else
    Result := FFIELD_REC_STRUCT.fldRecV.extend_type;
end;

function FIELD_REC.Get_field_type: AnsiChar;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.field_type
  else
    Result := FFIELD_REC_STRUCT.fldRecV.field_type;
end;

function FIELD_REC.Get_NextAutoInc: DWord;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.NextAutoInc
  else
    Result := FFIELD_REC_STRUCT.fldRecV.NextAutoInc;
end;

function FIELD_REC.Get_NativeNextAutoInc: DWord;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.NativeNextAutoInc
  else
    Result := FFIELD_REC_STRUCT.fldRecV.NativeNextAutoInc;
end;

procedure FIELD_REC.Set_extend_type(const Value: TVKDBFType);
begin
  FFIELD_REC_STRUCT.fldRecIII.extend_type := Value;
  FFIELD_REC_STRUCT.fldRecV.extend_type := Value;
end;

procedure FIELD_REC.Set_field_type(const Value: AnsiChar);
begin
  FFIELD_REC_STRUCT.fldRecIII.field_type := Value;
  FFIELD_REC_STRUCT.fldRecV.field_type := Value;
end;

procedure FIELD_REC.Set_NextAutoInc(const Value: DWord);
begin
  FFIELD_REC_STRUCT.fldRecIII.NextAutoInc := Value;
  FFIELD_REC_STRUCT.fldRecV.NextAutoInc := Value;
end;

procedure FIELD_REC.Set_NativeNextAutoInc(const Value: DWord);
begin
  FFIELD_REC_STRUCT.fldRecIII.NativeNextAutoInc := Value;
  FFIELD_REC_STRUCT.fldRecV.NativeNextAutoInc := Value;
end;

procedure FIELD_REC.SetFIELD_REC_VER(const Value: xBaseVersion);
begin
  FFIELD_REC_VER := Value;
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    FFIELD_REC_SIZE := FIELD_RECIII_SIZE
  else
    FFIELD_REC_SIZE := FIELD_RECV_SIZE;
end;

procedure FIELD_REC.SetFIELD_REC_SIZE(const Value: Integer);
begin
  FFIELD_REC_SIZE := Value;
end;

function FIELD_REC.Get_field_name: pAnsiChar;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.field_name
  else
    Result := FFIELD_REC_STRUCT.fldRecV.field_name;
end;

function FIELD_REC.Get_plendth: plen_info;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := @FFIELD_REC_STRUCT.fldRecIII.lendth
  else
    Result := @FFIELD_REC_STRUCT.fldRecV.lendth;
end;

function FIELD_REC.GetFeildName: AnsiString;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := String(FFIELD_REC_STRUCT.fldRecIII.field_name)
  else
    Result := String(FFIELD_REC_STRUCT.fldRecV.field_name);
end;

procedure FIELD_REC.SetFeildName(const Value: AnsiString);
var
  l, m: Integer;
begin
  l := Length(Value);
  m := l;
  if l > 10 then m := 10;
  FillChar(FFIELD_REC_STRUCT.fldRecIII.field_name, 11, 0);
  Move(pAnsiChar(Value)^, FFIELD_REC_STRUCT.fldRecIII.field_name, m);
  m := l;
  if l > 31 then m := 31;
  FillChar(FFIELD_REC_STRUCT.fldRecV.field_name, 32, 0);
  Move(pAnsiChar(Value)^, FFIELD_REC_STRUCT.fldRecV.field_name, m);
end;

function FIELD_REC.GetMaxFieldNameSize: Integer;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := 11
  else
    Result := 32;
end;

function FIELD_REC.Get_NativeStepAutoInc: Byte;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.NativeStepAutoInc
  else
    Result := 1;
end;

procedure FIELD_REC.Set_NativeStepAutoInc(const Value: Byte);
begin
  FFIELD_REC_STRUCT.fldRecIII.NativeStepAutoInc := Value;
  FFIELD_REC_STRUCT.fldRecV.NativeStepAutoInc := 0;
end;

function FIELD_REC.Get_FieldFlag: Byte;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := FFIELD_REC_STRUCT.fldRecIII.FldFlag
  else
    Result := FFIELD_REC_STRUCT.fldRecV.FldFlag;
end;

procedure FIELD_REC.Set_FieldFlag(const Value: Byte);
begin
  FFIELD_REC_STRUCT.fldRecIII.FldFlag := Value;
  FFIELD_REC_STRUCT.fldRecV.FldFlag := Value;
end;

constructor FIELD_REC.Create;
begin
  inherited Create;
  FillChar(FFIELD_REC_STRUCT, SizeOf(FFIELD_REC_STRUCT), #0);
end;

function FIELD_REC.GetFFIELD_REC_STRUCT: Pointer;
begin
  if not ( FFIELD_REC_VER in [xBaseV..xBaseVII] ) then
    Result := @FFIELD_REC_STRUCT.fldRecIII
  else
    Result := @FFIELD_REC_STRUCT.fldRecV;
end;

end.



