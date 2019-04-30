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
unit VKDBFNTX;

{$I VKDBF.DEF}

interface

uses
  Windows, Messages, SysUtils, Classes, contnrs, db, Math,
  {$IFDEF DELPHI6} Variants, {$ENDIF}
  VKDBFPrx, VKDBFParser, VKDBFIndex, VKDBFUtil, VKDBFMemMgr,
  VKDBFSorters, VKDBFSortedList, VKDBFCrypt, syncobjs;

const

  NTX_MAX_KEY         =       256;    // Maximum of length of key expression
  NTX_PAGE            =       1024;   // Dimension of NTX page
  MAX_LEV_BTREE       =       30;     // Maximum depth of BTREE
  MAX_NTX_STOCK       =       100000; // Stock ntx pages for count size of ntx pages buffer
  NTX_STOCK_INSURANCE =       3;      //
  MAX_ITEMS_IN_PAGE   =       510;    //
  DEFPAGESPERBUFFER   =       4;

type

  TDeleteKeyStyle = (dksClipper, dksApolloHalcyon);

  //NTX Structute
  NTX_HEADER = packed record
    sign: WORD;                                 //2        0
    version: WORD;                              //2        2
    root: DWORD;                                //4        4
    next_page: DWORD;                           //4        8
    item_size: WORD;                            //2       12
    key_size: WORD;                             //2       14
    key_dec: WORD;                              //2       16
    max_item: WORD;                             //2       18
    half_page: WORD;                            //2       20
    key_expr: array [0..NTX_MAX_KEY-1] of AnsiChar; //256     22
    unique: AnsiChar;                               //1      278
    reserv1: AnsiChar;                              //1      279
    desc: AnsiChar;                                 //1      280
    reserv3: AnsiChar;                              //1      281
    for_expr: array [0..NTX_MAX_KEY-1] of AnsiChar; //256    282
    order: array [0..7] of AnsiChar;                //8      538
    Rest: array [0..477] of AnsiChar;               //478    546
  end;                                          //1024

  //
  // Describer one ITEM
  //
  NTX_ITEM = packed record
    page: DWORD;
    rec_no: DWORD;
    key: array[0..NTX_PAGE-1] of AnsiChar;
  end;
  pNTX_ITEM = ^NTX_ITEM;

  //
  // Beginign of Index page
  //
  NTX_BUFFER = packed record
    count: WORD;
    ref: array[0..MAX_ITEMS_IN_PAGE] of WORD;
  end;
  pNTX_BUFFER = ^NTX_BUFFER;

  //
  //  Block item for compact indexing
  //
  BLOCK_ITEM = packed record
    rec_no: DWORD;
    key: array[WORD] of AnsiChar;
  end;
  pBLOCK_ITEM = ^BLOCK_ITEM;

  //
  //  Block for compact indexing
  //
  BLOCK_BUFFER = packed record
    count: WORD;
    ref: array[WORD] of WORD;
  end;
  pBLOCK_BUFFER = ^BLOCK_BUFFER;

  TBTreeLevels = array [0..MAX_LEV_BTREE] of NTX_BUFFER;
  pBTreeLevels = ^TBTreeLevels;

  //
  // Abstract class Iterator
  //
  TVKNTXIndexIterator = class(TObject)
  public
    item: NTX_ITEM;
    Eof: boolean;
    procedure Open; virtual; abstract;
    procedure Close; virtual; abstract;
    procedure Next; virtual; abstract;
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Block class Iterator
  //
  TVKNTXBlockIterator = class(TVKNTXIndexIterator)
  protected
    i: Integer;
    FBufSize: Integer;
    Fkey_size: Integer;
    FFileName: AnsiString;
    FHndl: Integer;
    p: pBLOCK_BUFFER;
  public
    procedure Open; override;
    procedure Close; override;
    procedure Next; override;
    constructor Create(FileName: AnsiString; key_size, BufSize: Integer); overload;
    destructor Destroy; override;
  end;

  //
  // NTX class Iterator
  //
  TVKNTXIterator = class(TVKNTXIndexIterator)
  protected
    FFileName: AnsiString;
    FHndl: Integer;
    SHead: NTX_HEADER;
    levels: pBTreeLevels;
    indexes: array [0..MAX_LEV_BTREE] of WORD;
    cur_lev: Integer;
  public
    procedure Open; override;
    procedure Close; override;
    procedure Next; override;
    constructor Create(FileName: AnsiString); overload;
    destructor Destroy; override;
  end;

  //
  // Compact index class for CreateCompact method TVKNTXIndex
  //
  TVKNTXCompactIndex = class(TObject)
  private
    FHndl: Integer;
    SHead: NTX_HEADER;
    levels: TBTreeLevels;
    cur_lev: Integer;
    max_lev: Integer;
    SubOffSet: DWORD;
    CryptPage: NTX_BUFFER;
    pWriteBuff: pAnsiChar;
    wbCount: Integer;
    wbAmount: Integer;
  public
    FileName: AnsiString;
    OwnerTable: TDataSet;
    Crypt: boolean;
    Handler: TProxyStream;
    CreateTmpFilesInTmpFilesDir: boolean;
    TmpFilesDir: AnsiString;
    constructor Create(pBuffCount: Integer = 0);
    destructor Destroy; override;
    procedure NewPage(lev: Integer);
    procedure CreateEmptyIndex(var FHead: NTX_HEADER);
    procedure AddItem(item: pNTX_ITEM);
    procedure Flush;
    procedure LinkRest;
    procedure NormalizeRest;
    procedure Close;
  end;

  //Forword declarations
  TVKNTXIndex = class;

  TVKNTXBuffer = class;

  {TVKNTXNodeDirect}
  TVKNTXNodeDirect = class
  private
    FNodeOffset: DWORD;
    FNode: NTX_BUFFER;
    function GetNode: NTX_BUFFER;
    function GetPNode: pNTX_BUFFER;
  public
    constructor Create(Offset: DWORD);
    property PNode: pNTX_BUFFER read GetPNode;
    property Node: NTX_BUFFER read GetNode;
    property NodeOffset: DWORD read FNodeOffset;
  end;

  {TVKNTXNode}
  TVKNTXNode = class
  private
    FNTXBuffer: TVKNTXBuffer;
    FNodeOffset: DWORD;
    FIndexInBuffer: Integer;
    FChanged: boolean;
    function GetPNode: pNTX_BUFFER;
    function GetNode: NTX_BUFFER;
  public
    constructor Create(Owner: TVKNTXBuffer; Offset: DWORD; Index: Integer);
    property PNode: pNTX_BUFFER read GetPNode;
    property Node: NTX_BUFFER read GetNode;
    property NodeOffset: DWORD read FNodeOffset;
    property Changed: boolean read FChanged write FChanged;
    property NTXBuffer: TVKNTXBuffer read FNTXBuffer;
  end;

//{$DEFINE NTXBUFFERASTREE}
//{//$UNDEF NTXBUFFERASTREE}

//{$IFNDEF NTXBUFFERASTREE}

  {TVKNTXBuffer}
  TVKNTXBuffer = class
  private
    FOffset: DWORD;
    FBusyCount: Integer;
    FUseCount: DWORD;
    FNodeCount: Word;
    FPages: pNTX_BUFFER;
    FNTXNode: array[0..Pred(MAX_ITEMS_IN_PAGE)] of TVKNTXNode;
    function GetBusy: boolean;
    procedure SetBusy(const Value: boolean);
    function GetChanged: boolean;
    function GetPPages(ndx: DWord): pNTX_BUFFER;
    function GetNTXNode(ndx: DWord): TVKNTXNode;
    procedure SetChanged(const Value: boolean);
    procedure SetOffset(const Value: DWORD);
  public
    constructor Create(pOffset: DWORD; pNodeCount: Word);
    destructor Destroy; override;
    property Changed: boolean read GetChanged write SetChanged;
    property NodeCount: Word read FNodeCount;
    property Pages: pNTX_BUFFER read FPages;
    property PPage[ndx: DWord]: pNTX_BUFFER read GetPPages;
    property NTXNode[ndx: DWord]: TVKNTXNode read GetNTXNode;
    property Busy: boolean read GetBusy write SetBusy;
    property UseCount: DWORD read FUseCount write FUseCount;
    property Offset: DWORD read FOffset write SetOffset;
  end;

  {TVKNTXBuffers}
  TVKNTXBuffers = class(TObjectList)
  private
    NXTObject: TVKNTXIndex;
    Flt: TVKLimitBuffersType;
    FMaxBuffers: Integer;
    FPagesPerBuffer: Integer;
    FUseCount: DWORD;
    function FindIndex(block_offset: DWORD; out Ind: Integer): boolean;
    function FindLeastUsed(out Ind: Integer): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function IncUseCount(b: TVKNTXBuffer): DWORD;
    function GetNTXBuffer(Handle: TProxyStream; page_offset: DWORD; out page: pNTX_BUFFER; fRead: boolean = true): TVKNTXNode;
    procedure FreeNTXBuffer(ntxb: TVKNTXBuffer);
    procedure SetPageChanged(Handle: TProxyStream; page_offset: DWORD);
    procedure Flush(Handle: TProxyStream);
    procedure Flash(ntxb: TVKNTXBuffer);
    property lt: TVKLimitBuffersType read Flt write Flt;
    property MaxBuffers: Integer read FMaxBuffers write FMaxBuffers;
    property PagesPerBuffer: Integer read FPagesPerBuffer write FPagesPerBuffer;
  end;

//{$ELSE}
(*

  {TVKNTXBuffer}
  TVKNTXBuffer = class(TVKSortedObject)
  private
    FOffset: DWORD;
    FBusyCount: Integer;
    FUseCount: DWORD;
    FNodeCount: Word;
    FPages: pNTX_BUFFER;
    FNTXNode: array[0..Pred(MAX_ITEMS_IN_PAGE)] of TVKNTXNode;
    function GetBusy: boolean;
    procedure SetBusy(const Value: boolean);
    function GetChanged: boolean;
    function GetPPages(ndx: DWord): pNTX_BUFFER;
    function GetNTXNode(ndx: DWord): TVKNTXNode;
    procedure SetChanged(const Value: boolean);
    procedure SetOffset(const Value: DWORD);
  public
    constructor Create(pOffset: DWORD; pNodeCount: Word);
    destructor Destroy; override;
    function cpm(sObj: TVKSortedObject): Integer; override;
    function IncUseCount: DWORD;
    property Changed: boolean read GetChanged write SetChanged;
    property NodeCount: Word read FNodeCount;
    property Pages: pNTX_BUFFER read FPages;
    property PPage[ndx: DWord]: pNTX_BUFFER read GetPPages;
    property NTXNode[ndx: DWord]: TVKNTXNode read GetNTXNode;
    property Busy: boolean read GetBusy write SetBusy;
    property UseCount: DWORD read FUseCount write FUseCount;
    property Offset: DWORD read FOffset write SetOffset;
  end;

  {TVKNTXBuffers}
  TVKNTXBuffers = class(TVKSortedList)
  private
    NXTObject: TVKNTXIndex;
    Flt: TVKLimitBuffersType;
    FMaxBuffers: Integer;
    FPagesPerBuffer: Integer;
    FTMPHandle: TProxyStream;
    function FindLeastUsed(out Ind: Integer): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function FindKey(dwKey: DWORD): TVKSortedObject;
    function GetNTXBuffer(Handle: TProxyStream; page_offset: DWORD; out page: pNTX_BUFFER; fRead: boolean = true): TVKNTXNode;
    procedure FreeNTXBuffer(ntxb: TVKNTXBuffer);
    procedure SetPageChanged(Handle: TProxyStream; page_offset: DWORD);
    procedure Flush(Handle: TProxyStream);
    procedure Flash(ntxb: TVKNTXBuffer);
    procedure OnFlush(Sender: TVKSortedListAbstract; SortedObject: TVKSortedObject);
    property lt: TVKLimitBuffersType read Flt write Flt;
    property MaxBuffers: Integer read FMaxBuffers write FMaxBuffers;
    property PagesPerBuffer: Integer read FPagesPerBuffer write FPagesPerBuffer;
  end;

//{$ENDIF}

*)

  {TVKNTXRange}
  TVKNTXRange = class(TPersistent)
  private

    FActive: boolean;
    FLoKey: AnsiString;
    FHiKey: AnsiString;
    FNTX: TVKNTXIndex;
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);

  protected
  public

    function InRange(S: AnsiString): boolean;

    procedure ReOpen;

    property NTX: TVKNTXIndex read FNTX write FNTX;

  published

    property Active: boolean read GetActive write SetActive;
    property HiKey: AnsiString read FHiKey write FHiKey;
    property LoKey: AnsiString read FLoKey write FLoKey;

  end;

  {TVKNTXOrder}
  TVKNTXOrder = class(TVKDBFOrder)
  public

    FHead: NTX_HEADER;

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    function CreateOrder: boolean; override;

  published

    property OnCreateIndex;
    property OnEvaluteKey;
    property OnEvaluteFor;
    property OnCompareKeys;

  end;

  {TVKNTXBag}
  TVKNTXBag = class(TVKDBFIndexBag)
  private

    //FLstOffset: DWORD;

  public

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    function CreateBag: boolean; override;
    function Open: boolean; override;
    function IsOpen: boolean; override;
    procedure Close; override;

    procedure FillHandler;

    //property FLastOffset: DWORD read FLstOffset write FLstOffset;
    property NTXHandler: TProxyStream read Handler write Handler;

  end;

  {TVKNTXIndex}
  TVKNTXIndex = class(TIndex)
  private

    FNTXBag: TVKNTXBag;
    FNTXOrder: TVKNTXOrder;

    FLastOffset: DWORD;
    FReindex: boolean;
    FCreateIndexProc: boolean;
    FNTXBuffers: TVKNTXBuffers;
    FNTXFileName: AnsiString;
    //NTXHandler: Integer;
    //FHead: NTX_HEADER;
    FKeyExpresion: AnsiString;
    FForExpresion: AnsiString;
    FKeyParser: TVKDBFExprParser;
    FForParser: TVKDBFExprParser;
    FForExists: boolean;
    FKeyTranslate: boolean;
    //FCl501Rus: boolean;
    FFileLock: boolean;
    FSeekRecord: Integer;
    FSeekKey: AnsiString;
    FSeekOk: boolean;
    FTemp: boolean;
    FNTXRange: TVKNTXRange;
    FOnSubNtx: TOnSubNtx;
    FDestructor: boolean;
    FClipperVer: TCLIPPER_VERSION;
    FUpdated: boolean;
    FFLastFUpdated: boolean;
    FDeleteKeyStyle: TDeleteKeyStyle;

    FUnique: boolean;
    FDesc: boolean;
    FOrder: AnsiString;

    FGetHashFromSortItem: boolean;

    FFLockObject: TCriticalSection;
    FFUnLockObject: TCriticalSection;

    //procedure ForwardPass;
    //procedure BackwardPass;

    procedure SetNTXFileName(const Value: AnsiString);
    procedure SetKeyExpresion(Value: AnsiString);
    procedure SetForExpresion(Value: AnsiString);
    function CompareKeys(S1, S2: PAnsiChar; MaxLen: Cardinal): Integer;
    function GetFreePage: DWORD;
    procedure SetUnique(const Value: boolean);
    function GetUnique: boolean;
    procedure SetDesc(const Value: boolean);
    function GetDesc: boolean;
    function SeekFirstInternal(Key: AnsiString; SoftSeek: boolean = false): boolean;
    function SeekLastInternal(Key: AnsiString; SoftSeek: boolean = false): boolean;
    procedure ChekExpression(var Value: AnsiString);
    function GetOwnerTable: TDataSet;
    procedure ClearIfChange;
    function GetCreateNow: Boolean;
    procedure SetCreateNow(const Value: Boolean);
    procedure SetNTXRange(const Value: TVKNTXRange);

    //procedure SortNtxNode(NtxNode: TVKNTXNode);

    procedure IndexSortProc(Sender: TObject; CurrentItem, Item: PSORT_ITEM; MaxLen: Cardinal; out c: Integer);
    procedure IndexSortCharsProc(Sender: TObject; Char1, Char2: Byte; out c: Integer);

  protected

    FCurrentKey: AnsiString;
    FCurrentRec: DWORD;
    function GetIsRanged: boolean; override;
    procedure AssignIndex(oInd: TVKNTXIndex);
    function InternalFirst: TGetResult; override;
    function InternalNext: TGetResult; override;
    function InternalPrior: TGetResult; override;
    function InternalLast: TGetResult; override;
    function GetCurrentKey: AnsiString; override;
    function GetCurrentRec: DWORD; override;
    //function FileRead(Handle: Integer; var Buffer; Count: LongWord): Integer;
    //function FileWrite(Handle: Integer; const Buffer; Count: LongWord): Integer;
    function AddItem(ntxItem: pNTX_ITEM; AddItemAtEnd: boolean = False): boolean;

    function GetOrder: AnsiString; override;
    procedure SetOrder(Value: AnsiString); override;

    procedure DefineBag; override;
    procedure DefineBagAndOrder; override;

    function GetIndexBag: TVKDBFIndexBag; override;
    function GetIndexOrder: TVKDBFOrder; override;

    procedure GetVKHashCode(Sender: TObject; Item: PSORT_ITEM; out HashCode: DWord); override;

  public

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IsEqual(Value: TIndex): Boolean; override;
    function CmpKeys(ItemKey, CurrKey: pAnsiChar; KSize: Integer = 0): Integer;
    function CmpKeys1(ItemKey, CurrKey: pAnsiChar; KSize: Integer = 0): Integer;
    function CmpKeys2(ItemKey, CurrKey: pAnsiChar; KSize: Integer = 0): Integer;
    function CmpKeys3(ItemKey, CurrKey: pAnsiChar; KSize: Integer = 0): Integer;
    procedure TransKey(Key: pAnsiChar; KSize: Integer = 0; ToOem: Boolean = true); overload;
    function TransKey(Key: AnsiString): AnsiString; overload;
    procedure TransKey(var SItem: SORT_ITEM); overload;
    function Open: boolean; override;
    procedure Close; override;
    function IsOpen: boolean; override;
    function SetToRecord: boolean; overload; override;
    function SetToRecord(Rec: Longint): boolean; overload; override;
    function SetToRecord(Key: AnsiString; Rec: Longint): boolean; overload; override;

    //
    function Seek(Key: AnsiString; SoftSeek: boolean = false): boolean; override;
    function SeekFirst( Key: AnsiString; SoftSeek: boolean = false;
                        PartialKey: boolean = false): boolean; override;
    function SeekFirstRecord( Key: AnsiString; SoftSeek: boolean = false;
                              PartialKey: boolean = false): Integer; override;
    function SeekFields(const KeyFields: AnsiString; const KeyValues: Variant;
                        SoftSeek: boolean = false;
                        PartialKey: boolean = false): Integer; override;

    // It is a new find mashine subject to SetDeleted, Filter and Range
    function FindKey(Key: AnsiString; PartialKey: boolean = false; SoftSeek: boolean = false; Rec: DWORD = 0): Integer; override;
    function FindKeyFields( const KeyFields: AnsiString; const KeyValues: Variant;
                            PartialKey: boolean = false; SoftSeek: boolean = false): Integer; overload; override;
    function FindKeyFields( const KeyFields: AnsiString; const KeyValues: array of const;
                            PartialKey: boolean = false; SoftSeek: boolean = false): Integer; overload; override;
    function FindKeyFields( PartialKey: boolean = false; SoftSeek: boolean = false): Integer; overload; override;
    //

    function SubIndex(LoKey, HiKey: AnsiString): boolean; override;
    function SubNtx(var SubNtxFile: AnsiString; LoKey, HiKey: AnsiString): boolean;
    function FillFirstBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): longint; override;
    function FillLastBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): longint; override;
    function EvaluteKeyExpr: AnsiString; override;
    function SuiteFieldList(fl: AnsiString; out m: Integer): Integer; override;
    function EvaluteForExpr: boolean; override;
    function GetRecordByIndex(GetMode: TGetMode; var cRec: Longint): TGetResult; override;
    function GetFirstByIndex(var cRec: Longint): TGetResult; override;
    function GetLastByIndex(var cRec: Longint): TGetResult; override;
    procedure First; override;
    procedure Next; override;
    procedure Prior; override;
    procedure Last; override;
    function LastKey(out LastKey: AnsiString; out LastRec: LongInt): boolean; override;
    function NextBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint; override;
    function PriorBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint; override;
    procedure SetRangeFields(FieldList: AnsiString; FieldValues: array of const); overload; override;
    procedure SetRangeFields(FieldList: AnsiString; FieldValues: variant); overload; override;
    procedure SetRangeFields(FieldList: AnsiString; FieldValuesLow: array of const; FieldValuesHigh: array of const); overload; override;
    procedure SetRangeFields(FieldList: AnsiString; FieldValuesLow: variant; FieldValuesHigh: variant); overload; override;
    function InRange(Key: AnsiString): boolean; overload; override;
    function InRange: boolean; overload; override;

    function FLock: boolean; override;
    function FUnLock: boolean; override;

    procedure StartUpdate(UnLock: boolean = true); override;
    procedure Flush; override;

    procedure DeleteKey(sKey: AnsiString; nRec: Longint); override;
    procedure AddKey(sKey: AnsiString; nRec: Longint); override;

    // Create index file adding keys one by one using classic algorithm
    // division B-tree pages. B-tree pages stores im memory according
    // LimitPages property
    procedure CreateIndex(Activate: boolean = true; PreSorterBlockSize: LongWord = 65536); override;
    // Save on disk sorted blocks, then merge blocks into BTrees. Slowly CreateIndex, but no need memory
    procedure CreateCompactIndex( BlockBufferSize: LongWord = 65536;
                                  Activate: boolean = true;
                                  CreateTmpFilesInCurrentDir: boolean = false); override;
    // Create index using RAM SORTER algorithm.
    // SorterClass must be one of the descendant of TVKSorterAbstract.
    procedure CreateIndexUsingSorter(SorterClass: TVKSorterClass; Activate: boolean = true); override;
    //procedure CreateIndexUsingSorter1(SorterClass: TVKSorterClass; Activate: boolean = true); override;
    // All keys has copied to RAM buffer and sorted using "Quick Sort" algorithm,
    // then carried to the index file. ATTANTION: All keys stores in memory!
    //procedure CreateIndexUsingQuickSort(Activate: boolean = true); override;
    //

    //Experiments with external sort of B-Tree
    //
    (*
    procedure CreateIndexUsingMergeBinaryTreeAndBTree(  TreeSorterClass: TVKBinaryTreeSorterClass;
                                                        Activate: boolean = True;
                                                        PreSorterBlockSize: LongWord = 65536); override;
    procedure CreateIndexUsingBTreeHeapSort(Activate: boolean = true); override;
    procedure CreateIndexUsingFindMinsAndJoinItToBTree( TreeSorterClass: TVKBinaryTreeSorterClass;
                                                        Activate: boolean = true;
                                                        PreSorterBlockSize: LongWord = 65536); override;
    procedure CreateIndexUsingAbsorption( TreeSorterClass: TVKBinaryTreeSorterClass;
                                          Activate: boolean = true;
                                          PreSorterBlockSize: LongWord = 65536); override;
    *)
    //
    //

    //
    procedure Reindex(Activate: boolean = true); override;

    procedure VerifyIndex; override;

    procedure Truncate; override;

    procedure BeginCreateIndexProcess; override;
    procedure EvaluteAndAddKey(nRec: DWORD); override;
    procedure EndCreateIndexProcess; override;

    function IsUniqueIndex: boolean; override;
    function IsForIndex: boolean; override;

    function ReCrypt(pNewCrypt: TVKDBFCrypt): boolean; override;

    property OwnerTable: TDataSet read GetOwnerTable;

  published

    property NTXFileName: AnsiString read FNTXFileName write SetNTXFileName;
    property KeyExpresion: AnsiString read FKeyExpresion write SetKeyExpresion stored false;
    property ForExpresion: AnsiString read FForExpresion write SetForExpresion stored false;
    property KeyTranslate: boolean read FKeyTranslate write FKeyTranslate default true;
    //property Clipper501RusOrder: boolean read FCl501Rus write FCl501Rus;
    property Unique: boolean read GetUnique write SetUnique;
    property Desc: boolean read GetDesc write SetDesc;
    property Order;
    property Temp: boolean read FTemp write FTemp;
    property NTXRange: TVKNTXRange read FNTXRange write SetNTXRange;
    property ClipperVer: TCLIPPER_VERSION read FClipperVer write FClipperVer default v500;
    property CreateNow: Boolean read GetCreateNow write SetCreateNow;
    property DeleteKeyStyle: TDeleteKeyStyle read FDeleteKeyStyle write FDeleteKeyStyle;
    property LimitPages;
    property OuterSorterProperties;
    property HashTypeForTreeSorters;
    property MaxBitsInHashCode;

    property OnCreateIndex;
    property OnSubIndex;
    property OnEvaluteKey;
    property OnEvaluteFor;
    property OnCompareKeys;
    property OnSubNtx: TOnSubNtx read FOnSubNtx write FOnSubNtx;

  end;

implementation

uses
   DBCommon, Dialogs, AnsiStrings, VKDBFDataSet;

{ TVKNTXIndex }

procedure TVKNTXIndex.Assign(Source: TPersistent);
begin
  if Source is TVKNTXIndex then
    AssignIndex(TVKNTXIndex(Source))
  else
    inherited Assign(Source);
end;

procedure TVKNTXIndex.AssignIndex(oInd: TVKNTXIndex);
begin
  if oInd <> nil then
  begin
    Name := oInd.Name;
    NTXFileName := oInd.NTXFileName;
  end;
end;

procedure TVKNTXIndex.Close;
begin
  //
  FNTXOrder.LimitPages.LimitPagesType := LimitPages.LimitPagesType;
  FNTXOrder.LimitPages.LimitBuffers := LimitPages.LimitBuffers;
  FNTXOrder.LimitPages.PagesPerBuffer := LimitPages.PagesPerBuffer;
  FNTXOrder.Collation.CollationType := Collation.CollationType;
  FNTXOrder.Collation.CustomCollatingSequence := Collation.CustomCollatingSequence;
  //
  FNTXOrder.OuterSorterProperties := OuterSorterProperties;
  //
  if not IsOpen then Exit;
  Flush;
  FNTXBuffers.Clear;
  FNTXBag.Close;
  FForExists := false;
  if FTemp then begin
    DeleteFile(FNTXFileName);
    if not FDestructor then
      Collection.Delete(Index);
  end;
end;

constructor TVKNTXIndex.Create(Collection: TCollection);
var
  FieldMap: TFieldMap;
begin
  inherited Create(Collection);

  FFLockObject := TCriticalSection.Create;
  FFUnLockObject := TCriticalSection.Create;

  FUpdated := False;

  FClipperVer := v500;

  FDeleteKeyStyle := dksClipper;

  FUnique := False;
  FDesc := False ;
  FOrder := '';

  (*
  FNTXOrder.FHead.sign := 6;
  FNTXOrder.FHead.version := 1;
  FNTXOrder.FHead.root := 0;
  FNTXOrder.FHead.next_page := 0;
  FNTXOrder.FHead.item_size := 0;
  FNTXOrder.FHead.key_size := 0;
  FNTXOrder.FHead.key_dec := 0;
  FNTXOrder.FHead.max_item := 0;
  FNTXOrder.FHead.half_page := 0;
  for i := 0 to NTX_MAX_KEY-1 do FNTXOrder.FHead.key_expr[i] := #0;
  FNTXOrder.FHead.unique := #0;
  FNTXOrder.FHead.reserv1 := #0;
  FNTXOrder.FHead.desc := #0;
  FNTXOrder.FHead.reserv3 := #0;
  for i := 0 to NTX_MAX_KEY-1 do FNTXOrder.FHead.for_expr[i] := #0;
  for i := 0 to 7 do FNTXOrder.FHead.order[i] := #0;
  for i := 0 to 477 do FNTXOrder.FHead.Rest[i] := #0;
  *)

  FKeyParser := TVKDBFExprParser.Create(TVKDBFNTX(FIndexes.Owner), '', [], [poExtSyntax], '', nil, FieldMap);
  FKeyParser.IndexKeyValue := true;
  FForParser := TVKDBFExprParser.Create(TVKDBFNTX(FIndexes.Owner), '', [], [poExtSyntax], '', nil, FieldMap);
  FForParser.IndexKeyValue := true;
  FKeyTranslate := true;
  //FCl501Rus := false;
  FFileLock := false;
  FTemp := false;
  FForExists := false;

  FNTXRange := TVKNTXRange.Create;
  FNTXRange.NTX := self;

  FNTXBuffers := TVKNTXBuffers.Create;
  FNTXBuffers.NXTObject := self;
  FCreateIndexProc:= false;
  FReindex := false;

  FOnSubNtx := nil;

  FDestructor := false;

  FGetHashFromSortItem := False;

end;

destructor TVKNTXIndex.Destroy;
begin
  FDestructor := true;
  if IsOpen then Close;
  FKeyParser.Free;
  FForParser.Free;
  FNTXRange.Free;
  FNTXBuffers.Free;
  FreeAndNil(FFLockObject);
  FreeAndNil(FFUnLockObject);
  if TIndexes(Collection).ActiveObject = self then
    TIndexes(Collection).ActiveObject := nil;
  inherited Destroy;
end;

function TVKNTXIndex.EvaluteForExpr: boolean;
begin
  if Assigned(FOnEvaluteFor) then
    FOnEvaluteFor(self, Result)
  else
    Result := FForParser.Execute;
end;

function TVKNTXIndex.EvaluteKeyExpr: AnsiString;
begin
  if Assigned(FOnEvaluteKey) then
    FOnEvaluteKey(self, Result)
  else
    Result := FKeyParser.EvaluteKey;
end;

function TVKNTXIndex.InternalFirst: TGetResult;
var
  level: Integer;
  v: WORD;

  function Pass(page_off: DWORD): TGetResult;
  var
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    Srckey: array[0..NTX_PAGE-1] of AnsiChar;
    Destkey: array[0..NTX_PAGE-1] of AnsiChar;
    ntxb: TVKNTXNode;
  begin
    Inc(level);
    try
      ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
      try
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[0]);
        if ( item.page <> 0 ) then begin
          Result := Pass(item.page);
          if Result = grOK then Exit;
        end;
        if page.count <> 0 then begin
          //
          if FKeyTranslate then begin
            Move(item.key, Srckey, FNTXOrder.FHead.key_size);
            Srckey[FNTXOrder.FHead.key_size] := #0;
            TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
            SetString(FCurrentKey, Destkey, FNTXOrder.FHead.key_size);
          end else
            SetString(FCurrentKey, item.key, FNTXOrder.FHead.key_size);
          FCurrentRec := item.rec_no;
          //
          Result := grOK;
        end else
          if level = 1 then
            Result := grEOF
          else
            Result := grError;
        Exit;
      finally
        FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
      end;
    finally
      Dec(level);
    end;
  end;

begin

  if not FUpdated then begin
    v := FNTXOrder.FHead.version;
    FNTXBag.NTXHandler.Seek(0, 0);
    FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
    if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
  end;

  level := 0;
  Result := Pass(FNTXOrder.FHead.root);

end;

procedure TVKNTXIndex.First;
begin
  if InternalFirst = grOk then
    TVKDBFNTX(FIndexes.Owner).RecNo := FCurrentRec;
end;

function TVKNTXIndex.IsEqual(Value: TIndex): Boolean;
var
  oNTX: TVKNTXIndex;
begin
  oNTX := Value as TVKNTXIndex;
  Result := ( (FName = oNTX.Name) and (FNTXFileName = oNTX.NTXFileName) );
end;

function TVKNTXIndex.IsOpen: boolean;
begin
  Result := ((FNTXBag <> nil) and (FNTXBag.IsOpen));
end;

function TVKNTXIndex.InternalLast: TGetResult;
var
  level: Integer;
  v: WORD;

  function Pass(page_off: DWORD): TGetResult;
  var
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    Srckey: array[0..NTX_PAGE-1] of AnsiChar;
    Destkey: array[0..NTX_PAGE-1] of AnsiChar;
    ntxb: TVKNTXNode;
  begin
    Inc(level);
    try
      ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
      try
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
        if ( item.page <> 0 ) then begin
          Result := Pass(item.page);
          if Result = grOK then Exit;
        end;
        if page.count <> 0 then begin
          //
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count - 1]);
          if FKeyTranslate then begin
            Move(item.key, Srckey, FNTXOrder.FHead.key_size);
            Srckey[FNTXOrder.FHead.key_size] := #0;
            TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
            SetString(FCurrentKey, Destkey, FNTXOrder.FHead.key_size);
          end else
            SetString(FCurrentKey, item.key, FNTXOrder.FHead.key_size);
          FCurrentRec := item.rec_no;
          //
          Result := grOK;
        end else
          if level = 1 then
            Result := grBOF
          else
            Result := grError;
        Exit;
      finally
        FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
      end;
    finally
      Dec(level);
    end;
  end;

begin

  if not FUpdated then begin
    v := FNTXOrder.FHead.version;
    FNTXBag.NTXHandler.Seek(0, 0);
    FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
    if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
  end;

  level := 0;
  Result := Pass(FNTXOrder.FHead.root);

end;

function TVKNTXIndex.InternalPrior: TGetResult;
var
  Found: boolean;
  gr: TGetResult;
  v: WORD;

  procedure Pass(page_off: DWORD);
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    Srckey: array[0..NTX_PAGE-1] of AnsiChar;
    Destkey: array[0..NTX_PAGE-1] of AnsiChar;
    c: Integer;
    ntxb1, ntxb2: TVKNTXNode;

    procedure SetCurrentKey;
    begin
      if FKeyTranslate then begin
        Move(item.key, Srckey, FNTXOrder.FHead.key_size);
        Srckey[FNTXOrder.FHead.key_size] := #0;
        TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
        SetString(FCurrentKey, Destkey, FNTXOrder.FHead.key_size);
      end else
        SetString(FCurrentKey, item.key, FNTXOrder.FHead.key_size);
      FCurrentRec := item.rec_no;
    end;

  begin
    ntxb1 := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          c := CmpKeys(item.key, pAnsiChar(FCurrentKey));
          if c <= 0 then begin
            if ( FCurrentRec = item.rec_no ) and ( c = 0 ) then begin
              Found := true;

              if ( item.page = 0 ) then begin
                if ( i <> 0 ) then begin
                  gr := grOK;
                  item := pNTX_ITEM(pAnsiChar(page) + page.ref[i - 1]);
                  SetCurrentKey;
                end;
              end else begin

                ntxb2 := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, item.page, page);
                try
                  if page.count > 0 then begin
                    gr := grOK;
                    item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count - 1]);
                    SetCurrentKey;
                  end else
                    gr := grError;
                finally
                  FNTXBuffers.FreeNTXBuffer(ntxb2.FNTXBuffer);
                end;
              end;

              Exit;
            end;

            if ( item.page <> 0 ) then Pass(item.page);

            if Found and (gr = grBOF) then begin
              if ( i <> 0 ) then begin
                gr := grOK;
                item := pNTX_ITEM(pAnsiChar(page) + page.ref[i - 1]);
                SetCurrentKey;
              end;
              Exit;
            end;
            if gr = grError then Exit;
            if gr = grOK then Exit;

          end;
        end;
      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);
      if Found and (gr = grBOF ) then begin
        if ( page.count <> 0 ) then begin
          gr := grOK;
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count - 1]);
          SetCurrentKey;
        end else
          gr := grError;
      end;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb1.FNTXBuffer);
    end;
  end;

begin

  if not FUpdated then begin
    v := FNTXOrder.FHead.version;
    FNTXBag.NTXHandler.Seek(0, 0);
    FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
    if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
  end;

  gr := grBOF;
  Found := false;
  Pass(FNTXOrder.FHead.root);
  Result := gr;

end;

function TVKNTXIndex.Open: boolean;
var
  oW: TVKDBFNTX;
begin

  FFileLock := False;

  oW := TVKDBFNTX(FIndexes.Owner);

  DefineBagAndOrder;

  FNTXBuffers.Clear;
  if not ((FNTXOrder.FHead.sign = 6) or (FNTXOrder.FHead.sign = 7)) then begin
    FNTXBag.Close;
    raise Exception.Create('TVKNTXIndex.Open: File "' + FNTXFileName + '" is not NTX file');
  end;

  Result := IsOpen;

  if Result then begin

    //FKeyParser.SetExprParams1(FKeyExpresion, [], [poExtSyntax], '');
    //FForParser.SetExprParams1(FForExpresion, [], [poExtSyntax], '');

    FNTXBuffers.Flt := LimitPages.LimitPagesType;
    case FNTXBuffers.Flt of
      lbtAuto:
        begin
          FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oW.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
          FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
          LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
        end;
      lbtLimited:
        begin
          FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
          FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
        end;
      lbtUnlimited:
        begin
          FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
        end;
    end;

    FAllowSetCollationType := True;
    try
      CollationType := Collation.CollationType;
    finally
      FAllowSetCollationType := False;
    end;
    CustomCollatingSequence := Collation.CustomCollatingSequence;

    FLastOffset := FNTXBag.NTXHandler.Seek(0, 2);

    if  ( ( ( oW.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
        ( ( oW.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
        StartUpdate;
    InternalFirst;
    KeyExpresion := FNTXOrder.FHead.key_expr;
    ForExpresion := FNTXOrder.FHead.for_expr;
    if ForExpresion <> '' then
      FForExists := true;
  end;

end;

function TVKNTXIndex.InternalNext: TGetResult;
var
  Found: Boolean;
  gr: TGetResult;
  v: WORD;

  procedure Pass(page_off: DWORD);
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    Srckey: array[0..NTX_PAGE-1] of AnsiChar;
    Destkey: array[0..NTX_PAGE-1] of AnsiChar;
    c: Integer;
    level: Integer;
    ntxb: TVKNTXNode;

    procedure SetCurrentKey;
    begin
      if FKeyTranslate then begin
        Move(item.key, Srckey, FNTXOrder.FHead.key_size);
        Srckey[FNTXOrder.FHead.key_size] := #0;
        TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
        SetString(FCurrentKey, Destkey, FNTXOrder.FHead.key_size);
      end else
        SetString(FCurrentKey, item.key, FNTXOrder.FHead.key_size);
      FCurrentRec := item.rec_no;
    end;

    procedure GetFirstFromSubTree(page_off: DWORD);
    var
      ntxb: TVKNTXNode;
    begin
      Inc(level);
      try
        ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
        try
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[0]);
          if ( item.page <> 0 ) then begin
            GetFirstFromSubTree(item.page);
            if gr = grOK then Exit;
          end;
          if page.count <> 0 then begin
            SetCurrentKey;
            gr := grOK;
          end else
            if level = 1 then
              gr := grEOF
            else
              gr := grError;
          Exit;
        finally
          FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
        end;
      finally
        Dec(level);
      end;
    end;

  begin
    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          c := CmpKeys(item.key, pAnsiChar(FCurrentKey));
          if c <= 0 then begin
            if ( FCurrentRec = item.rec_no ) and ( c = 0 ) then begin
              Found := true;
              //
              SetCurrentKey;
              item := pNTX_ITEM(pAnsiChar(page) + page.ref[i + 1]);
              if item.page <> 0 then begin
                level := 0;
                GetFirstFromSubTree(item.page);
              end else begin
                if ( ( i + 1 ) = page.count ) then begin
                  gr := grEOF;
                end else begin
                  gr := grOK;
                  SetCurrentKey;
                end;
              end;
              //
              Exit;
            end;
            if ( item.page <> 0 ) then Pass(item.page);
            if (gr = grOK) then Exit;
            if Found and (gr = grEOF) then begin
              gr := grOK;
              SetCurrentKey;
              Exit;
            end;
            if gr = grError then Exit;
          end;
        end;
      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  if not FUpdated then begin
    v := FNTXOrder.FHead.version;
    FNTXBag.NTXHandler.Seek(0, 0);
    FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
    if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
  end;

  Found := false;
  gr := grEOF;
  Pass(FNTXOrder.FHead.root);
  Result := gr;

end;

function TVKNTXIndex.Seek(Key: AnsiString; SoftSeek: boolean = false): boolean;
var
  R: Integer;
begin
  R := FindKey(Key, false, SoftSeek);
  if R <> 0 then begin
    (TVKDBFNTX(FIndexes.Owner)).RecNo := R;
    Result := True;
  end else
    Result := False;
end;

function TVKNTXIndex.SeekFirstInternal( Key: AnsiString; SoftSeek: boolean = false): boolean;
var
  lResult, SoftSeekSet: boolean;

  procedure Pass(page_off: DWORD);
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    c: Integer;
    ntxb: TVKNTXNode;
  begin
    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin

        item := nil;

        for i := 0 to page.count - 1 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          c := CmpKeys(item.key, pAnsiChar(Key));

          if c < 0 then begin //Key < item.key
            if ( item.page <> 0 ) then Pass(item.page);
            if (SoftSeek) and (not lResult) and (not SoftSeekSet) then begin
              FSeekRecord := item.rec_no;
              SetString(FSeekKey, item.key, FNTXOrder.FHead.key_size);
              SoftSeekSet := true;
              FSeekOk := true;
            end;
            Exit;
          end;

          if c = 0 then begin //Key = item.key
            if ( item.page <> 0 ) then Pass(item.page);
            if not lResult then begin
              FSeekRecord := item.rec_no;
              SetString(FSeekKey, item.key, FNTXOrder.FHead.key_size);
              FSeekOk := true;
              lResult := true;
            end;
            Exit;
          end;

        end;

        FSeekRecord := item.rec_no;
        SetString(FSeekKey, item.key, FNTXOrder.FHead.key_size);
        FSeekOk := true;

      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  FSeekOk := false;

  if FLock then
    try

      ClearIfChange;

      SoftSeekSet := false;
      lResult := false;
      Pass(FNTXOrder.FHead.root);
      Result := lResult;

    finally
      FUnLock;
    end
  else
    Result := false;

end;

function TVKNTXIndex.SeekFirst( Key: AnsiString; SoftSeek: boolean = false;
                                PartialKey: boolean = false): boolean;
var
  R: Integer;
begin
  R := FindKey(Key, PartialKey, SoftSeek);
  if R <> 0 then begin
    (TVKDBFNTX(FIndexes.Owner)).RecNo := R;
    Result := True;
  end else
    Result := False;
end;

procedure TVKNTXIndex.SetKeyExpresion(Value: AnsiString);
var
  oW: TVKDBFNTX;
begin
  ChekExpression(Value);
  FKeyExpresion := Value;
  oW := TVKDBFNTX(FIndexes.Owner);
  if oW.IsCursorOpen then
    FKeyParser.SetExprParams1(FKeyExpresion, [], [poExtSyntax], '');
end;

procedure TVKNTXIndex.SetForExpresion(Value: AnsiString);
var
  oW: TVKDBFNTX;
begin
  ChekExpression(Value);
  FForExpresion := Value;
  oW := TVKDBFNTX(FIndexes.Owner);
  if oW.IsCursorOpen then
    FForParser.SetExprParams1(FForExpresion, [], [poExtSyntax], '');
end;

procedure TVKNTXIndex.SetNTXFileName(const Value: AnsiString);
var
  PointPos: Integer;
begin
  FNTXFileName := Value;
  FName := ExtractFileName(FNTXFileName);
  PointPos := Pos('.', FName);
  if PointPos <> 0 then
    FName := Copy(FName, 1, PointPos - 1);
end;

function TVKNTXIndex.SubIndex(LoKey, HiKey: AnsiString): boolean;
var
  l, m: Integer;

  function Pass(page_off: DWORD): boolean;
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    c: Integer;
    S: AnsiString;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          c := CmpKeys(item.key, pAnsiChar(LoKey), m);

          if c <= 0 then begin //LoKey <= item.key
            if ( item.page <> 0 ) then begin
              Result := Pass(item.page);
              if Result then Exit;
            end;
            c := CmpKeys(item.key, pAnsiChar(HiKey), l);
            if c < 0 then begin // HiKey < item.key
              Result := true;
              Exit;
            end;
            if Assigned(OnSubIndex) then begin
              SetString(S, item.key, FNTXOrder.FHead.key_size);
              ExitCode := 0;
              OnSubIndex(self, S, item.rec_no, ExitCode);
              if ExitCode = 1 then begin
                Result := true;
                Exit;
              end;
            end;
          end;

        end;
      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);

      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;

  end;

begin

  if FLock then
    try

      ClearIfChange;

      m := Length(LoKey);
      if FNTXOrder.FHead.key_size < m then m := FNTXOrder.FHead.key_size;
      l := Length(HiKey);
      if FNTXOrder.FHead.key_size < l then l := FNTXOrder.FHead.key_size;
      Pass(FNTXOrder.FHead.root);
      Result := true;

    finally
      FUnLock;
    end
  else
    Result := false;

end;

function TVKNTXIndex.SubNtx(var SubNtxFile: AnsiString; LoKey, HiKey: AnsiString): boolean;
var
  l, m: Integer;
  Accept: boolean;
  oSubIndex: TVKNTXCompactIndex;

  function Pass(page_off: DWORD): boolean;
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    itm: NTX_ITEM;
    c: Integer;
    S: AnsiString;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          c := CmpKeys(item.key, pAnsiChar(LoKey), m);

          if c <= 0 then begin //LoKey <= item.key
            if ( item.page <> 0 ) then begin
              Result := Pass(item.page);
              if Result then Exit;
            end;
            c := CmpKeys(item.key, pAnsiChar(HiKey), l);
            if c < 0 then begin // HiKey < item.key
              Result := true;
              Exit;
            end;
            Accept := true;
            if Assigned(OnSubNtx) then begin
              SetString(S, item.key, FNTXOrder.FHead.key_size);
              OnSubNtx(self, S, item.rec_no, Accept);
            end;
            if Accept then begin
              Move(item^, itm, FNTXOrder.FHead.item_size);
              oSubIndex.AddItem(@itm);
            end;
          end;

        end;
      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);

      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  oSubIndex := TVKNTXCompactIndex.Create(LimitPages.PagesPerBuffer);
  try

    oSubIndex.FileName := SubNtxFile;
    oSubIndex.OwnerTable := OwnerTable;
    oSubIndex.Crypt := TVKDBFNTX(OwnerTable).Crypt.Active;
    oSubIndex.CreateEmptyIndex(FNTXOrder.FHead);

    if oSubIndex.FHndl > 0 then
      try

        if FLock then
          try

            ClearIfChange;

            m := Length(LoKey);
            if FNTXOrder.FHead.key_size < m then m := FNTXOrder.FHead.key_size;
            l := Length(HiKey);
            if FNTXOrder.FHead.key_size < l then l := FNTXOrder.FHead.key_size;

            Pass(FNTXOrder.FHead.root);

            Result := true;

          finally
            FUnLock;
          end
        else
          Result := false;

      finally

        oSubIndex.Close;

        with FIndexes.Add as TVKNTXIndex do begin
          Temp := True;
          NTXFileName := SubNtxFile;
          Open;
          Active := true;
          TVKDBFNTX(FIndexes.Owner).First;
        end;

      end

    else
      Result := false;

  finally
    oSubIndex.Free;
  end;

end;

procedure TVKNTXIndex.Last;
begin
  if InternalLast = grOk then
    TVKDBFNTX(FIndexes.Owner).RecNo := FCurrentRec;
end;

procedure TVKNTXIndex.Next;
begin
  if InternalNext = grOk then
    TVKDBFNTX(FIndexes.Owner).RecNo := FCurrentRec;
end;

procedure TVKNTXIndex.Prior;
begin
  if InternalPrior = grOk then
    TVKDBFNTX(FIndexes.Owner).RecNo := FCurrentRec;
end;

function TVKNTXIndex.GetRecordByIndex(GetMode: TGetMode;
  var cRec: Integer): TGetResult;
begin
  Result := grOk;
  case GetMode of
    gmNext:
      begin
        if cRec <> - 1 then
          Result := InternalNext
        else
          Result := InternalFirst;
      end;
    gmPrior:
      begin
        if cRec <> TVKDBFNTX(FIndexes.Owner).RecordCount then
          Result := InternalPrior
        else
          Result := InternalLast;
      end;
  end;
  if Result = grOk then
    cRec := FCurrentRec;
  if Result = grBOF then
    cRec := -1;
  if Result = grEOF then
    cRec := TVKDBFNTX(FIndexes.Owner).RecordCount;
  if Result = grError then
    cRec := TVKDBFNTX(FIndexes.Owner).RecordCount;
end;

function TVKNTXIndex.GetFirstByIndex(var cRec: Integer): TGetResult;
begin
  Result := InternalFirst;
  cRec := FCurrentRec;
end;

function TVKNTXIndex.GetLastByIndex(var cRec: Integer): TGetResult;
begin
  Result := InternalLast;
  cRec := FCurrentRec;
end;

function TVKNTXIndex.SetToRecord: boolean;
var
  TmpKey: AnsiString;
begin
  Result := true;
  FCurrentKey := EvaluteKeyExpr;
  FCurrentRec := TVKDBFNTX(FIndexes.Owner).RecNo;
  if Unique or FForExists then begin
    SeekFirstInternal(FCurrentKey, true);
    if FSeekOk then begin
      TmpKey := TransKey(FSeekKey);
      if (FCurrentKey <> TmpKey) then begin
        FCurrentKey := TmpKey;
        FCurrentRec := FSeekRecord;
      end;
    end else
      Result := false;
  end;
end;

function TVKNTXIndex.NextBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint;
var
  lResult: Longint;
  Found: boolean;
  v: WORD;

  function Pass(page_off: DWORD): boolean;
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    c: Integer;
    l: Integer;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          c := CmpKeys(item.key, pAnsiChar(FCurrentKey));
          if c <= 0 then begin //FCurrentKey <= item.key
            if ( item.page <> 0 ) then begin
              Result := Pass(item.page);
              if Result then Exit;
            end;
            //
            if Found then begin
              if NTXRange.Active then begin
                l := Length(NTXRange.HiKey);
                if l > 0 then begin
                  c := CmpKeys(item.key, pAnsiChar(NTXRange.HiKey), l);
                  if c < 0 then begin //NTXRange.HiKey < item.key
                    Result := true;
                    Exit;
                  end;
                end;
              end;
              pLongint(pAnsiChar(FBufInd) + lResult * SizeOf(Longint))^ := item.rec_no;
              DBFHandler.Seek(data_offset + (item.rec_no - 1) * DWORD(FRecordSize), soFromBeginning);
              DBFHandler.Read((FBuffer + lResult * FRecordSize)^, FRecordSize);
              if TVKDBFNTX(OwnerTable).Crypt.Active then
                TVKDBFNTX(OwnerTable).Crypt.Decrypt(item.rec_no, Pointer(FBuffer + lResult * FRecordSize), FRecordSize);
              Inc(lResult);
            end;
            //
            if lResult = FRecordsPerBuf then begin
              Result := true;
              Exit;
            end;

            if ( FCurrentRec = item.rec_no ) and ( c = 0 ) then Found := true;

          end;

        end;
      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then begin
        Result := Pass(item.page);
        if Result then Exit;
      end;

      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  if not FUpdated then begin
    v := FNTXOrder.FHead.version;
    FNTXBag.NTXHandler.Seek(0, 0);
    FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
    if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
  end;

  lResult := 0;
  Found := false;
  Pass(FNTXOrder.FHead.root);
//  if not Found then
//    beep;
  Result := lResult;

end;

function TVKNTXIndex.PriorBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint;
var
  lResult: Longint;
  bResult: boolean;
  Found: boolean;
  v: WORD;

  procedure Pass(page_off: DWORD);
  var
    k, i: Integer;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    c: Integer;
    ntxb: TVKNTXNode;
  label
    a1;

  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
    k := page.count;
    if not Found then begin
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin
          k := i - 1;
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          c := CmpKeys(item.key, pAnsiChar(FCurrentKey));
          if c <= 0 then begin //FCurrentKey <= item.key
            if ( FCurrentRec = item.rec_no ) and ( c = 0 ) then Found := true;
            if ( item.page <> 0 ) then begin
              Pass(item.page);
              if bResult then Exit;
            end;
            if Found then goto a1;
          end;
        end;
      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then begin
        Pass(item.page);
        if bResult then Exit;
        k := page.count - 1;
        if Found then goto a1;
      end;
    end;
    //
    a1:
    if Found then begin
      while k >= 0 do begin
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[k]);
        if k < page.count then begin
          if NTXRange.Active then begin
            c := CmpKeys(item.key, pAnsiChar(NTXRange.LoKey));
            if c > 0 then begin //NTXRange.LoKey > item.key
              bResult := true;
              Exit;
            end;
          end;
          pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - lResult - 1) * SizeOf(Longint))^ := item.rec_no;
          DBFHandler.Seek(data_offset + (item.rec_no - 1) * DWORD(FRecordSize), soFromBeginning);
          DBFHandler.Read((FBuffer + (FRecordsPerBuf - lResult - 1) * FRecordSize)^, FRecordSize);
          if TVKDBFNTX(OwnerTable).Crypt.Active then
            TVKDBFNTX(OwnerTable).Crypt.Decrypt(item.rec_no, Pointer(FBuffer + (FRecordsPerBuf - lResult - 1) * FRecordSize), FRecordSize);
          Inc(lResult);
          if lResult = FRecordsPerBuf then begin
            bResult := true;
            Exit;
          end;
        end;
        if ( item.page <> 0 ) then begin
          Pass(item.page);
          if bResult then Exit;
        end;
        Dec(k);
      end;
    end;
    //
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  if not FUpdated then begin
    v := FNTXOrder.FHead.version;
    FNTXBag.NTXHandler.Seek(0, 0);
    FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
    if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
  end;

  lResult := 0;
  bResult := false;
  Found := false;
  Pass(FNTXOrder.FHead.root);
//  if not Found then
//    beep;
  Result := lResult;

end;

function TVKNTXIndex.SetToRecord(Key: AnsiString; Rec: Integer): boolean;
var
  TmpKey: AnsiString;
begin
  Result := true;
  FCurrentKey := Key;
  FCurrentRec := Rec;
  if Unique or FForExists then begin
    SeekFirstInternal(FCurrentKey, true);
    if FSeekOk then begin
      TmpKey := TransKey(FSeekKey);
      if (FCurrentKey <> TmpKey) then begin
        FCurrentKey := TmpKey;
        FCurrentRec := FSeekRecord;
      end;
    end else
      Result := false;
  end;
end;

function TVKNTXIndex.GetCurrentKey: AnsiString;
begin
  Result := FCurrentKey;
end;

function TVKNTXIndex.GetCurrentRec: DWORD;
begin
  Result := FCurrentRec;
end;

function TVKNTXIndex.FillFirstBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar;
  FRecordsPerBuf, FRecordSize: Integer;
  FBufInd: pLongInt; data_offset: Word): longint;
var
  lResult: longint;
  c, l: Integer;
  v: WORD;

  function Pass(page_off: DWORD): boolean;
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          if ( item.page <> 0 ) then begin
            Result := Pass(item.page);
            if Result then Exit;
          end;
          //
          pLongint(pAnsiChar(FBufInd) + lResult * SizeOf(Longint))^ := item.rec_no;
          DBFHandler.Seek(data_offset + (item.rec_no - 1) * DWORD(FRecordSize), soFromBeginning);
          DBFHandler.Read((FBuffer + lResult * FRecordSize)^, FRecordSize);
          if TVKDBFNTX(OwnerTable).Crypt.Active then
            TVKDBFNTX(OwnerTable).Crypt.Decrypt(item.rec_no, Pointer(FBuffer + lResult * FRecordSize), FRecordSize);
          Inc(lResult);
          //
          if lResult = FRecordsPerBuf then begin
            Result := true;
            Exit;
          end;

        end;
      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then
        Result := Pass(item.page)
      else
        Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  if not NTXRange.Active then begin

    if not FUpdated then begin
      v := FNTXOrder.FHead.version;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
      if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
    end;

    lResult := 0;
    Pass(FNTXOrder.FHead.root);
    Result := lResult;

  end else begin
    SeekFirstInternal(NTXRange.LoKey, true);
    if FSeekOk then begin
      l := Length(NTXRange.LoKey);
      c := CmpKeys2(pAnsiChar(NTXRange.LoKey), pAnsiChar(FSeekKey), l);
      if c >= 0 then begin
        l := Length(NTXRange.HiKey);
        c := CmpKeys2(pAnsiChar(NTXRange.HiKey), pAnsiChar(FSeekKey), l);
        if (l > 0) and (c <= 0) then begin
          FCurrentKey := TransKey(FSeekKey);
          FCurrentRec := FSeekRecord;
          pLongint(FBufInd)^ := FSeekRecord;
          DBFHandler.Seek(data_offset + (DWORD(FSeekRecord) - 1) * DWORD(FRecordSize), soFromBeginning);
          DBFHandler.Read(FBuffer^, FRecordSize);
          if TVKDBFNTX(OwnerTable).Crypt.Active then
            TVKDBFNTX(OwnerTable).Crypt.Decrypt(FSeekRecord, Pointer(FBuffer), FRecordSize);
          Result := 1 + NextBuffer(DBFHandler, FBuffer + FRecordSize, FRecordsPerBuf - 1, FRecordSize, pLongint(pAnsiChar(FBufInd) + SizeOf(Longint)), data_offset);
        end else
          Result := 0;
      end else
        Result := 0;
    end else
      Result := 0;
  end;

end;

function TVKNTXIndex.FillLastBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar;
  FRecordsPerBuf, FRecordSize: Integer; FBufInd: pLongint;
  data_offset: Word): longint;
var
  lResult: longint;
  c, l: Integer;
  v: WORD;

  function Pass(page_off: DWORD): boolean;
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then begin
        Result := Pass(item.page);
        if Result then Exit;
      end;

      if page.count > 0 then begin
        for i := page.count - 1 downto 0 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          //
          pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - lResult - 1) * SizeOf(Longint))^ := item.rec_no;
          DBFHandler.Seek(data_offset + (item.rec_no - 1) * DWORD(FRecordSize), soFromBeginning);
          DBFHandler.Read((FBuffer + (FRecordsPerBuf - lResult - 1) * FRecordSize)^, FRecordSize);
          if TVKDBFNTX(OwnerTable).Crypt.Active then
            TVKDBFNTX(OwnerTable).Crypt.Decrypt(item.rec_no, Pointer(FBuffer + (FRecordsPerBuf - lResult - 1) * FRecordSize), FRecordSize);
          Inc(lResult);
          //

          if lResult = FRecordsPerBuf then begin
            Result := true;
            Exit;
          end;

          if ( item.page <> 0 ) then begin
            Result := Pass(item.page);
            if Result then Exit;
          end;

        end;
      end;

      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  if (not NTXRange.Active) or (NTXRange.LoKey  = '') then begin

    if not FUpdated then begin
      v := FNTXOrder.FHead.version;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
      if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
    end;

    lResult := 0;
    Pass(FNTXOrder.FHead.root);
    Result := lResult;

  end else begin
    SeekLastInternal(NTXRange.HiKey, true);
    if FSeekOk then begin
      l := Length(NTXRange.LoKey);
      c := CmpKeys2(pAnsiChar(NTXRange.LoKey), pAnsiChar(FSeekKey), l);
      if c >= 0 then begin
        l := Length(NTXRange.HiKey);
        c := CmpKeys2(pAnsiChar(NTXRange.HiKey), pAnsiChar(FSeekKey), l);
        if (l > 0) and (c <= 0) then begin
          FCurrentKey := TransKey(FSeekKey);
          FCurrentRec := FSeekRecord;
          pLongint(pAnsiChar(FBufInd) + (FRecordsPerBuf - 1) * SizeOf(Longint))^ := FCurrentRec;
          DBFHandler.Seek(data_offset + (FCurrentRec - 1) * DWORD(FRecordSize), soFromBeginning);
          DBFHandler.Read((FBuffer + (FRecordsPerBuf - 1) * FRecordSize)^, FRecordSize);
          if TVKDBFNTX(OwnerTable).Crypt.Active then
            TVKDBFNTX(OwnerTable).Crypt.Decrypt(FCurrentRec, Pointer(FBuffer + (FRecordsPerBuf - 1) * FRecordSize), FRecordSize);
          Result := 1 + PriorBuffer(DBFHandler, FBuffer, FRecordsPerBuf - 1, FRecordSize, FBufInd, data_offset);
        end else
          Result := 0;
      end else
        Result := 0;
    end else
      Result := 0;
  end;

end;

function TVKNTXIndex.SetToRecord(Rec: Integer): boolean;
var
  TmpKey: AnsiString;
begin
  Result := true;
  FCurrentKey := EvaluteKeyExpr;
  FCurrentRec := Rec;
  if Unique or FForExists then begin
    SeekFirstInternal(FCurrentKey, true);
    if FSeekOk then begin
      TmpKey := TransKey(FSeekKey);
      if (FCurrentKey <> FSeekKey) then begin
        FCurrentKey := TmpKey;
        FCurrentRec := FSeekRecord;
      end;
    end else
      Result := false;
  end;
end;

(*
function TVKNTXIndex.FileWrite(Handle: Integer; const Buffer;
  Count: LongWord): Integer;
var
  i: Integer;
  l: boolean;
  Ok: boolean;
  oW: TVKDBFNTX;
begin
  i := 0;
  oW := TVKDBFNTX(FIndexes.Owner);
  l := (( (oW.AccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (oW.AccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ));
  repeat
    Result := SysUtils.FileWrite(Handle, Buffer, Count);
    Ok := (Result <> -1);
    if not Ok then begin
      if l then
        Ok := true
      else begin
        Wait(0.001, false);
        Inc(i);
        if i = oW.WaitBusyRes then Ok := true;
      end;
    end;
  until Ok;
end;
*)

(*
function TVKNTXIndex.FileRead(Handle: Integer; var Buffer;
  Count: LongWord): Integer;
var
  i: Integer;
  l: boolean;
  Ok: boolean;
  oW: TVKDBFNTX;
begin
  i := 0;
  oW := TVKDBFNTX(FIndexes.Owner);
  l := (( (oW.AccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (oW.AccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ));
  repeat
    Result := SysUtils.FileRead(Handle, Buffer, Count);
    Ok := (Result <> -1);
    if not Ok then begin
      if l then
        Ok := true
      else begin
        Wait(0.001, false);
        Inc(i);
        if i = oW.WaitBusyRes then Ok := true;
      end;
    end;
  until Ok;
end;
*)

function TVKNTXIndex.CompareKeys(S1, S2: PAnsiChar; MaxLen: Cardinal): Integer;
var
  i: Integer;
  T1: array [0..NTX_PAGE] of AnsiChar;
  T2: array [0..NTX_PAGE] of AnsiChar;
begin
  //S1 - CurrentKey
  //S2 - Item Key
  if Assigned(OnCompareKeys) then begin
    OnCompareKeys(self, S1, S2, MaxLen, Result);
  end else begin
    if CollationType <> cltNone then begin
      Result := 0;
      //DONE: make it throws TVKNTXIndex.TransKey
      //CharToOem(pChar(S1), T1);
      //CharToOem(pAnsiChar(S2), T2);
      TVKDBFNTX(FIndexes.Owner).Translate(S1, pAnsiChar(@T1[0]), True);
      TVKDBFNTX(FIndexes.Owner).Translate(S2, pAnsiChar(@T2[0]), True);
      //end TODO
      for i := 0 to MaxLen - 1 do begin
        Result := CollatingTable[Ord(T1[i])] - CollatingTable[Ord(T2[i])];
        if Result <> 0 then Exit;
      end;
    end else begin
      //Result := AnsiStrLComp(S1, S2, MaxLen);  - in Win95-98 not currect
      Result := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLComp(S1, S2, MaxLen);
    end;
  end;
end;

function TVKNTXIndex.GetFreePage: DWORD;
var
  page: pNTX_BUFFER;
  i: Integer;
  Ind: TVKNTXNode;
  item_off: WORD;
begin
  if FNTXOrder.FHead.next_page <> 0 then begin

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, FNTXOrder.FHead.next_page, page);

    page.count := 0;
    Result := FNTXOrder.FHead.next_page;
    FNTXOrder.FHead.next_page := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).page;
    pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).page := 0;

    Ind.Changed := true;
    FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);

  end else begin

    Result := FLastOffset;

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, Result, page, false);

    page.count := 0;
    item_off := ( FNTXOrder.FHead.max_item * 2 ) + 4;
    for i := 0 to FNTXOrder.FHead.max_item do begin
      page.ref[i] := item_off;
      item_off := item_off + FNTXOrder.FHead.item_size;
    end;
    pNTX_ITEM(pAnsiChar(page) + page.ref[0]).page := 0;

    Inc(FLastOffset, SizeOf(NTX_BUFFER));

    Ind.Changed := true;
    FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);

  end;
end;

function TVKNTXIndex.AddItem(ntxItem: pNTX_ITEM; AddItemAtEnd: boolean = False): boolean;
var
  NewPage: pNTX_BUFFER;
  _NewPageOff, NewPageOff: DWORD;
  ItemHasBeenAdded: boolean;
  rf: WORD;
  Ind: TVKNTXNode;

  procedure AddItemInternal(page_off: DWORD; ParentNode: TVKNTXNode = nil; ParentItem: pNTX_ITEM = nil; ParentItemNo: Word = Word(-1));
  var
    i, j, beg, Mid, k, l: Integer;
    page, SiblingNodePage: pNTX_BUFFER;
    item, SiblingItem, i1, i2: pNTX_ITEM;
    c: Integer;
    Ind, Ind1, SiblingNode: TVKNTXNode;
    BreakItem: Word;

    procedure InsItem(page: pNTX_BUFFER);
    begin
      j := page.count;
      while j >= i do begin
        rf := page.ref[j + 1];
        page.ref[j + 1] := page.ref[j];
        page.ref[j] := rf;
        Dec(j);
      end;
      page.count := page.count + 1;
      Move(ntxItem.key, pNTX_ITEM(pAnsiChar(page) + page.ref[i]).key, FNTXOrder.FHead.key_size);
      pNTX_ITEM(pAnsiChar(page) + page.ref[i]).rec_no := ntxItem.rec_no;
      pNTX_ITEM(pAnsiChar(page) + page.ref[i]).page := ntxItem.page;
      if ( ntxItem.page <> 0 ) then begin
        pNTX_ITEM(pAnsiChar(page) + page.ref[i + 1]).page := NewPageOff;
        NewPageOff := 0;
      end;
    end;

    procedure CmpRec;
    begin
      if c = 0 then begin
        if item.rec_no < ntxItem.rec_no then
          c := 1
        else
          c := -1;
      end;
    end;

  begin

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      i := page.count;
      if not AddItemAtEnd then begin
        if ( i > 0 ) then begin
          beg := 0;
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[beg]);
          c := CmpKeys1(item.key, pAnsiChar(@ntxItem^.key[0]));

          CmpRec;

          if ( c > 0 ) then begin
            repeat
              Mid := ( i + beg ) shr 1;
              item := pNTX_ITEM(pAnsiChar(page) + page.ref[Mid]);
              c := CmpKeys1(item.key, pAnsiChar(@ntxItem^.key[0]));

              CmpRec;

              if ( c > 0 ) then
                 beg := Mid
              else
                 i := Mid;
            until ( ((i-beg) div 2) = 0 );
          end else
            i := beg;
        end;
      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
      if ( item.page <> 0 ) then AddItemInternal(item.page, Ind, item, i);
      if not ItemHasBeenAdded then begin

        // If Item add at end and node is full then try carry half node to left sibling node
        if AddItemAtEnd and ( page.count = FNTXOrder.FHead.max_item ) then begin
          if ( ParentNode <> nil )
            and ( ParentItem <> nil )
            and ( ParentItemNo <> Word(-1) )
            and ( ParentItemNo > 0 ) then begin
            SiblingItem := pNTX_ITEM(pAnsiChar(ParentNode.pNode) + ParentNode.PNode.ref[Pred(ParentItemNo)]);
            SiblingNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, SiblingItem.page, SiblingNodePage);
            try
              l := 0;
              for k := SiblingNodePage.count to Pred(FNTXOrder.FHead.max_item) do begin
                i1 := pNTX_ITEM(pAnsiChar(SiblingNode.pNode) + SiblingNode.PNode.ref[k]);
                i2 := pNTX_ITEM(pAnsiChar(Ind.pNode) + Ind.PNode.ref[l]);
                i1.rec_no := SiblingItem.rec_no;
                Move(SiblingItem.key, i1.key, FNTXOrder.FHead.key_size);
                i1 := pNTX_ITEM(pAnsiChar(SiblingNode.pNode) + SiblingNode.PNode.ref[Succ(k)]);
                i1.page := i2.page;
                i2.page := 0;
                SiblingItem.rec_no := i2.rec_no;
                Move(i2.key, SiblingItem.key, FNTXOrder.FHead.key_size);
                Inc(l);
              end;
              if l > 0 then begin
                Inc(SiblingNodePage.count, l);
                //Shift cuttent page
                for k := l to page.count do begin
                  rf := page.ref[k - l];
                  page.ref[k - l] := page.ref[k];
                  page.ref[k] := rf;
                end;
                Dec(page.count, l);
                Ind.Changed := true;
                SiblingNode.Changed := true;
                ParentNode.Changed := true;
                Dec(i, l);
              end;
            finally
              FNTXBuffers.FreeNTXBuffer(SiblingNode.FNTXBuffer);
            end;
          end;
        end;

        if (page.count = FNTXOrder.FHead.max_item) then begin

          _NewPageOff := GetFreePage;

          Ind1 := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, _NewPageOff, NewPage);
          try

            BreakItem := FNTXOrder.FHead.half_page;

            Move(page^, NewPage^, SizeOf(NTX_BUFFER));
            page.count := BreakItem;
            for j := BreakItem to NewPage.count do begin
              rf := NewPage.ref[j - BreakItem];
              NewPage.ref[j - BreakItem] := NewPage.ref[j];
              NewPage.ref[j] := rf;
            end;
            NewPage.count := NewPage.count - BreakItem;
            if i < BreakItem then begin
              InsItem(page);
            end else begin
              i := i - BreakItem;
              InsItem(NewPage);
            end;
            NewPageOff := _NewPageOff;
            if page.count >= NewPage.count then begin
              page.count := page.count - 1;
              Move(pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).key, ntxItem.key, FNTXOrder.FHead.key_size);
              ntxItem.rec_no := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).rec_no;
            end else begin
              Move(pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[0]).key, ntxItem.key, FNTXOrder.FHead.key_size);
              ntxItem.rec_no := pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[0]).rec_no;
              for j := 0 to NewPage.count - 1 do begin
                rf := NewPage.ref[j];
                NewPage.ref[j] := NewPage.ref[j + 1];
                NewPage.ref[j + 1] := rf;
              end;
              NewPage.count := NewPage.count - 1;
            end;
            ntxItem.page := page_off;
            Ind.Changed := true;
            Ind1.Changed := true;
          finally
            FNTXBuffers.FreeNTXBuffer(Ind1.FNTXBuffer);
          end;

          ItemHasBeenAdded := false;
        end else begin
          InsItem(page);

          Ind.Changed := true;

          ItemHasBeenAdded := true;
        end;
      end;
    finally
      FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);
    end;
  end;

begin

  NewPageOff := 0;
  ItemHasBeenAdded := false;

  AddItemInternal(FNTXOrder.FHead.root, nil, nil, Word(-1));

  if not ItemHasBeenAdded then begin
    _NewPageOff := GetFreePage;
    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, _NewPageOff, NewPage);
    try
      NewPage.count := 1;
      Move(ntxItem.key, pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[0]).key, FNTXOrder.FHead.key_size);
      pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[0]).rec_no := ntxItem.rec_no;
      pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[0]).page := ntxItem.page;
      pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[1]).page := NewPageOff;
      FNTXOrder.FHead.root := _NewPageOff;
      Ind.Changed := True;
    finally
      FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);
    end;

    ItemHasBeenAdded := true;

  end;
  Result := ItemHasBeenAdded;

end;

procedure TVKNTXIndex.AddKey(sKey: AnsiString; nRec: Integer);
var
  item: NTX_ITEM;
  AddOk: boolean;
begin
  AddOk := true;
  if Unique then
    AddOk := AddOk and (not SeekFirstInternal(sKey));
  if FForExists then
    AddOk := AddOk and (FForParser.Execute);
  if AddOk then begin
    item.page := 0;
    item.rec_no := nRec;
    Move(pAnsiChar(sKey)^, item.key, FNTXOrder.FHead.key_size);
    TransKey(item.key);
    AddItem(@item);
  end;
end;

procedure TVKNTXIndex.DeleteKey(sKey: AnsiString; nRec: Integer);
var
  TempItem: NTX_ITEM;
  LastItem: NTX_ITEM;
  FLastKey: AnsiString;
  FLastRec: DWORD;
  rf: WORD;

  procedure AddInEndItem(page_off: DWORD; itemKey: pAnsiChar; itemRec: DWORD);
  var
    page: pNTX_BUFFER;
    NewPage: pNTX_BUFFER;
    item: pNTX_ITEM;
    NewPageOff: DWORD;
    i: DWORD;
    Ind, Ind1: TVKNTXNode;
  begin

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then
        AddInEndItem(item.page, itemKey, itemRec)
      else begin
        if page.count < FNTXOrder.FHead.max_item then begin
          Move(itemKey^, pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).key, FNTXOrder.FHead.key_size);
          pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).rec_no := itemRec;
          pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).page := 0;
          page.count := page.count + 1;
          pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]).page := 0;

          Ind.Changed := true;

        end else begin
          NewPageOff := GetFreePage;

          Ind1 := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, NewPageOff, NewPage);
          try

            Move(page^, NewPage^, SizeOf(NTX_BUFFER));
            page.count := FNTXOrder.FHead.half_page;
            pNTX_ITEM(pAnsiChar(page) + page.ref[FNTXOrder.FHead.half_page]).page := NewPageOff;

            Ind.Changed := true;

            for i := FNTXOrder.FHead.half_page to NewPage.count do begin
              rf := NewPage.ref[i - FNTXOrder.FHead.half_page];
              NewPage.ref[i - FNTXOrder.FHead.half_page] := NewPage.ref[i];
              NewPage.ref[i] := rf;
            end;
            NewPage.count := NewPage.count - FNTXOrder.FHead.half_page;
            Move(itemKey^, pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[NewPage.count]).key, FNTXOrder.FHead.key_size);
            pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[NewPage.count]).rec_no := itemRec;
            pNTX_ITEM(pAnsiChar(NewPage) + NewPage.ref[NewPage.count]).page := 0;
            NewPage.count := NewPage.count + 1;

            Ind1.Changed := true;
          finally
            FNTXBuffers.FreeNTXBuffer(Ind1.FNTXBuffer);
          end;

        end;
      end;
    finally
      FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);
    end;
  end;

  procedure DeletePage(page_off: DWORD);
  var
    page: pNTX_BUFFER;
    Ind: TVKNTXNode;
  begin

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);

    page.count := 0;
    pNTX_ITEM(pAnsiChar(page) + page.ref[0]).page := FNTXOrder.FHead.next_page;

    Ind.Changed := true;
    FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);

    FNTXOrder.FHead.next_page := page_off;

  end;

  procedure GetLastItemOld(page_off: DWORD; PrePage: pNTX_BUFFER; PrePageOffset: DWORD; PreItemRef: WORD);
  var
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    Srckey: array[0..NTX_PAGE-1] of AnsiChar;
    Destkey: array[0..NTX_PAGE-1] of AnsiChar;
    Ind: TVKNTXNode;
  begin

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then
        GetLastItemOld(item.page, page, page_off, page.count)
      else begin
        //
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count - 1]);
        if FKeyTranslate then begin
          Move(item.key, Srckey, FNTXOrder.FHead.key_size);
          Srckey[FNTXOrder.FHead.key_size] := #0;
          TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
          SetString(FLastKey, Destkey, FNTXOrder.FHead.key_size);
        end else
          SetString(FLastKey, item.key, FNTXOrder.FHead.key_size);
        FLastRec := item.rec_no;
        //
        page.count := page.count - 1;

        Ind.Changed := true;

      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( page.count = 0 ) and ( item.page = 0 ) then begin
        DeletePage(page_off);
        pNTX_ITEM(pAnsiChar(PrePage) + NTX_BUFFER(PrePage^).ref[PreItemRef])^.page := 0;

        FNTXBuffers.SetPageChanged(FNTXBag.NTXHandler, PrePageOffset);

      end;
    finally
      FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);
    end;
  end;

  function Pass(page_off: DWORD; LastItemRef: WORD; LastPage: pNTX_BUFFER; LastPageOffset: DWORD): boolean;
  var
    i, j: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    item1: pNTX_ITEM;
    c: Integer;
    Ind: TVKNTXNode;

    function DelPage: boolean;
    begin
      Result := false;
      if page.count = 0 then begin
        item1 := pNTX_ITEM(pAnsiChar(page) + page.ref[0]);
        if ( item1.page = 0 ) then begin
          if LastPage <> nil then begin
            pNTX_ITEM(pAnsiChar(LastPage) + NTX_BUFFER(LastPage^).ref[LastItemRef])^.page := 0;
            DeletePage(page_off);

            FNTXBuffers.SetPageChanged(FNTXBag.NTXHandler, LastPageOffset);

            Result := true;
          end;
        end;
      end;
    end;

  begin

    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          c := CmpKeys(item.key, pAnsiChar(sKey));
          if c <= 0 then begin //sKey <= item.key

            if ( item.page <> 0 ) then begin
              Result := Pass(item.page, i, page, page_off);
              DelPage;
              if Result then Exit;
            end;

            if ( DWORD(nRec) = item.rec_no ) and ( c = 0 ) then begin
              if ( item.page = 0 ) then begin
                j := i;
                while j < page.count do begin
                  rf := page.ref[j];
                  page.ref[j] := page.ref[j + 1];
                  page.ref[j + 1] := rf;
                  Inc(j);
                end;
                if page.count > 0 then begin
                  page.count := page.count - 1;

                  Ind.Changed := true;

                end;
                DelPage;
                Result := true;
              end else begin
                GetLastItemOld(item.page, page, page_off, i);
                Move(pAnsiChar(FLastKey)^, pNTX_ITEM(pAnsiChar(page) + page.ref[i]).key, FNTXOrder.FHead.key_size);
                pNTX_ITEM(pAnsiChar(page) + page.ref[i]).rec_no := FLastRec;

                Ind.Changed := true;

                Result := true;
              end;
              Exit;
            end;

          end;
        end;
      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then begin
        Result := Pass(item.page, page.count, page, page_off);
        DelPage;
        if Result then Exit;
      end;

      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);
    end;
  end;

  procedure GetLastItem(page_off: DWORD);
  var
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    ntxb: TVKNTXNode;
  begin
    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then
        GetLastItem(item.page)
      else begin
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count - 1]);
        Move(item^, LastItem, FNTXOrder.FHead.item_size);
      end;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

  function PassForDel(page_off: DWORD; ItemForDelete: pNTX_ITEM; Parent: TVKNTXNode; ParentItemRef: WORD): boolean;
  var
    i, j: DWORD;
    item: pNTX_ITEM;
    page: pNTX_BUFFER;
    Ind: TVKNTXNode;
    c: Integer;

    procedure DelItemi;
    var
      rf: WORD;
    begin
      j := i;
      while j < page.count do begin
        rf := page.ref[j];
        page.ref[j] := page.ref[j + 1];
        page.ref[j + 1] := rf;
        Inc(j);
      end;
      page.count := page.count - 1;
    end;

    procedure NormalizePage(CurrPage, Parent: TVKNTXNode; ParentItemRef: WORD);
    var
      LeftSibling, RightSibling: TVKNTXNode;
      LeftPage, RightPage: pNTX_BUFFER;
      TryRight: boolean;
      SLItem, LItem, CItem, RItem, Item, SRItem: pNTX_ITEM;
      Shift, j: Integer;
      rf: WORD;
      LstPage: DWORD;
    begin
      if Parent <> nil then begin
        if CurrPage.PNode.count < FNTXOrder.FHead.half_page then begin

          TryRight := false;
          if ParentItemRef > 0 then begin
            LItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[ParentItemRef - 1]);
            if LItem.page <> 0 then begin
              LeftSibling := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, LItem.page, LeftPage);
              if LeftPage.count > FNTXOrder.FHead.half_page then begin

                SLItem := pNTX_ITEM( pAnsiChar(LeftPage) + LeftPage.ref[LeftPage.count]);

                rf := LeftPage.count - FNTXOrder.FHead.half_page;
                Shift := (rf div 2) + (rf mod 2);

                LeftPage.count := LeftPage.count - Shift;

                j := CurrPage.PNode.count;
                while j >= 0 do begin
                  rf := CurrPage.PNode.ref[j + Shift];
                  CurrPage.PNode.ref[j + Shift] := CurrPage.PNode.ref[j];
                  CurrPage.PNode.ref[j] := rf;
                  Dec(j);
                end;
                Inc(CurrPage.PNode.count, Shift);

                CItem := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[Shift - 1]);
                Move(LItem.key, CItem.key, FNTXOrder.FHead.key_size);
                CItem.rec_no := LItem.rec_no;
                CItem.page := SLItem.page;

                Dec(Shift);

                while Shift > 0 do begin

                  SLItem := pNTX_ITEM( pAnsiChar(LeftPage) + LeftPage.ref[LeftPage.count + Shift]);

                  CItem := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[Shift - 1]);
                  Move(SLItem.key, CItem.key, FNTXOrder.FHead.key_size);
                  CItem.rec_no := SLItem.rec_no;
                  CItem.page := SLItem.page;

                  Dec(Shift);
                end;

                SLItem := pNTX_ITEM( pAnsiChar(LeftPage) + LeftPage.ref[LeftPage.count]);
                Move(SLItem.key, LItem.key, FNTXOrder.FHead.key_size);
                LItem.rec_no := SLItem.rec_no;

              end else begin

                  CItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[ParentItemRef]);
                  Item := pNTX_ITEM( pAnsiChar(LeftPage) + LeftPage.ref[LeftPage.count]);
                  Move(LItem.key, Item.key, FNTXOrder.FHead.key_size);
                  Item.rec_no := LItem.rec_no;

                  Inc(LeftPage.count);

                  CItem.page := LItem.page;

                  for j := ParentItemRef - 1 to Parent.PNode.count - 1 do begin
                    rf := Parent.PNode.ref[j];
                    Parent.PNode.ref[j] := Parent.PNode.ref[j + 1];
                    Parent.PNode.ref[j + 1] := rf;
                  end;

                  Dec(Parent.PNode.count);

                  for j := 0 to CurrPage.PNode.count do begin
                    CItem := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[j]);
                    Item := pNTX_ITEM( pAnsiChar(LeftPage) + LeftPage.ref[LeftPage.count]);
                    Move(CItem^, Item^, FNTXOrder.FHead.item_size);
                    Inc(LeftPage.count);
                  end;

                  Dec(LeftPage.count);

                  //Delete page
                  CurrPage.PNode.count := 0;
                  CItem := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[0]);
                  CItem.page := FNTXOrder.FHead.next_page;
                  FNTXOrder.FHead.next_page := CurrPage.NodeOffset;

                  if Parent.PNode.count = 0 then begin
                    //Delete Parent
                    CItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[0]);
                    FNTXOrder.FHead.root := CItem.page;
                    CItem.page := FNTXOrder.FHead.next_page;
                    FNTXOrder.FHead.next_page := Parent.NodeOffset;
                  end;

              end;

              LeftSibling.Changed := true;
              FNTXBuffers.FreeNTXBuffer(LeftSibling.FNTXBuffer);
              CurrPage.Changed := true;
              Parent.Changed := true;

            end else
              TryRight := true;
          end else
            TryRight := true;

          if TryRight then begin
            if ParentItemRef < Parent.PNode.count then begin
              RItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[ParentItemRef + 1]);
              if RItem.page <> 0 then begin
                RightSibling := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, RItem.page, RightPage);
                if RightPage.count > FNTXOrder.FHead.half_page then begin

                  rf := RightPage.count - FNTXOrder.FHead.half_page;
                  Shift := (rf div 2) + (rf mod 2);

                  CItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[ParentItemRef]);
                  Item := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[CurrPage.PNode.count]);
                  Move(CItem.key, Item.key, FNTXOrder.FHead.key_size);
                  Item.rec_no := CItem.rec_no;

                  Inc(CurrPage.PNode.count);

                  Item := pNTX_ITEM( pAnsiChar(RightSibling.PNode) + RightSibling.PNode.ref[Shift - 1]);
                  Move(Item.key, CItem.key, FNTXOrder.FHead.key_size);
                  CItem.rec_no := Item.rec_no;
                  LstPage := Item.page;

                  for j := 0 to Shift - 2 do begin
                    SRItem := pNTX_ITEM( pAnsiChar(RightSibling.PNode) + RightSibling.PNode.ref[j]);
                    Item := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[CurrPage.PNode.count]);
                    Move(SRItem^, Item^, FNTXOrder.FHead.item_size);
                    Inc(CurrPage.PNode.count);
                  end;
                  Item := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[CurrPage.PNode.count]);
                  Item.page := LstPage;

                  Dec(RightSibling.PNode.count, Shift);
                  for j := 0 to RightSibling.PNode.count do begin
                    rf := RightSibling.PNode.ref[j];
                    RightSibling.PNode.ref[j] := RightSibling.PNode.ref[j + Shift];
                    RightSibling.PNode.ref[j + Shift] := rf;
                  end;

                end else begin

                  CItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[ParentItemRef]);
                  Item := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[CurrPage.PNode.count]);
                  Move(CItem.key, Item.key, FNTXOrder.FHead.key_size);
                  Item.rec_no := CItem.rec_no;

                  Inc(CurrPage.PNode.count);

                  RItem.page := CItem.page;

                  for j := ParentItemRef to Parent.PNode.count - 1 do begin
                    rf := Parent.PNode.ref[j];
                    Parent.PNode.ref[j] := Parent.PNode.ref[j + 1];
                    Parent.PNode.ref[j + 1] := rf;
                  end;

                  Dec(Parent.PNode.count);

                  for j := 0 to RightSibling.PNode.count do begin
                    SRItem := pNTX_ITEM( pAnsiChar(RightSibling.PNode) + RightSibling.PNode.ref[j]);
                    Item := pNTX_ITEM( pAnsiChar(CurrPage.PNode) + CurrPage.PNode.ref[CurrPage.PNode.count]);
                    Move(SRItem^, Item^, FNTXOrder.FHead.item_size);
                    Inc(CurrPage.PNode.count);
                  end;

                  Dec(CurrPage.PNode.count);

                  //Delete page
                  RightSibling.PNode.count := 0;
                  CItem := pNTX_ITEM( pAnsiChar(RightSibling.PNode) + RightSibling.PNode.ref[0]);
                  CItem.page := FNTXOrder.FHead.next_page;
                  FNTXOrder.FHead.next_page := RightSibling.NodeOffset;

                  if Parent.PNode.count = 0 then begin
                    //Delete Parent
                    CItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[0]);
                    FNTXOrder.FHead.root := CItem.page;
                    CItem.page := FNTXOrder.FHead.next_page;
                    FNTXOrder.FHead.next_page := Parent.NodeOffset;
                  end;

                end;
                RightSibling.Changed := true;
                FNTXBuffers.FreeNTXBuffer(RightSibling.FNTXBuffer);
                CurrPage.Changed := true;
                Parent.Changed := true;
              end;
            end;
          end;

        end;
      end;
    end;

  begin
    Ind := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      for i := 0 to page.count - 1 do begin
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
        c := CmpKeys1(item.key, ItemForDelete.key);
        if c <= 0 then begin //ItemForDelete.key <= item.key
          if ( item.page <> 0 ) then begin
            Result := PassForDel(item.page, ItemForDelete, Ind, i);
            NormalizePage(Ind, Parent, ParentItemRef);
            if Result then Exit;
          end;
          if ( ItemForDelete.rec_no = item.rec_no ) and ( c = 0 ) then begin
            if ( item.page = 0 ) then begin
              DelItemi;
              Ind.Changed := true;
            end else begin
              GetLastItem(item.page);
              Move(LastItem.key, item.key, FNTXOrder.FHead.key_size);
              item.rec_no := LastItem.rec_no;
              Ind.Changed := true;
              PassForDel(item.page, @LastItem, Ind, i);
            end;
            NormalizePage(Ind, Parent, ParentItemRef);
            Result := true;
            Exit;
          end;
        end;
      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then begin
        Result := PassForDel(item.page, ItemForDelete, Ind, page.count);
        NormalizePage(Ind, Parent, ParentItemRef);
        if Result then Exit;
      end;
      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(Ind.FNTXBuffer);
    end;
  end;

begin

  if FDeleteKeyStyle = dksClipper then begin

    TempItem.page := 0;
    TempItem.rec_no := nRec;
    Move(pAnsiChar(sKey)^, TempItem.key, FNTXOrder.FHead.key_size);
    TransKey(TempItem.key);

    PassForDel(FNTXOrder.FHead.root, @TempItem, nil, 0);

  end else

    Pass(FNTXOrder.FHead.root, 0, nil, 0);

end;

function TVKNTXIndex.LastKey(out LastKey: AnsiString; out LastRec: Integer): boolean;
var
  level: Integer;

  function Pass(page_off: DWORD): TGetResult;
  var
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    Srckey: array[0..NTX_PAGE-1] of AnsiChar;
    Destkey: array[0..NTX_PAGE-1] of AnsiChar;
    ntxb: TVKNTXNode;
  begin
    Inc(level);
    try

      ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
      try
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
        if ( item.page <> 0 ) then begin
          Result := Pass(item.page);
          if Result = grOK then Exit;
        end;
        if page.count <> 0 then begin
          //
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count - 1]);
          if FKeyTranslate then begin
            Move(item.key, Srckey, FNTXOrder.FHead.key_size);
            Srckey[FNTXOrder.FHead.key_size] := #0;
            TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
            SetString(LastKey, Destkey, FNTXOrder.FHead.key_size);
          end else
            SetString(LastKey, item.key, FNTXOrder.FHead.key_size);
          LastRec := item.rec_no;
          //
          Result := grOK;
        end else
          if level = 1 then
            Result := grBOF
          else
            Result := grError;
        Exit;
      finally
        FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
      end;
    finally
      Dec(level);
    end;
  end;

begin

  if FLock then
    try

      ClearIfChange;

      level := 0;
      Result := (Pass(FNTXOrder.FHead.root) = grOK);
    finally
      FUnLock;
    end
  else
    Result := false;

end;

function TVKNTXIndex.FLock: boolean;
var
  i: Integer;
  l: boolean;
  oW: TVKDBFNTX;
begin
  FFLockObject.Enter;
  try
    if not FFileLock then begin
      i := 0;
      oW := TVKDBFNTX(FIndexes.Owner);
      l := ( ( (oW.AccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (oW.AccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) or FFileLock );
      repeat
        if not l then begin
          Result := False;
          case oW.LockProtocol of
            lpNone            : Result := True;
            lpDB4Lock         : Result := FNTXBag.NTXHandler.Lock(DB4_LockMax, 1);
            lpClipperLock     : Result := FNTXBag.NTXHandler.Lock(CLIPPER_LockMax, 1);
            lpFoxLock         : Result := FNTXBag.NTXHandler.Lock(FOX_LockMax, 1);
            lpClipperForFoxLob: Result := FNTXBag.NTXHandler.Lock(CLIPPER_FOR_FOX_LOB_LockMax, 1);
          end;
          if not Result then begin
            Wait(0.001, false);
            Inc(i);
            if i >= oW.WaitBusyRes then begin
              FFileLock := Result;
              Exit;
            end;
          end;
        end else
          Result := true;
      until Result;
      FFileLock := Result;
    end else
      Result := true;
  finally
    FFLockObject.Release;
  end;
end;

function TVKNTXIndex.FUnLock: boolean;
var
  l: boolean;
  oW: TVKDBFNTX;
begin
  FFUnLockObject.Enter;
  try
    oW := TVKDBFNTX(FIndexes.Owner);
    l := ( ( (oW.AccessMode.FLast and fmShareExclusive) = fmShareExclusive ) or ( (oW.AccessMode.FLast and fmShareDenyWrite) = fmShareDenyWrite ) );
    if not l then begin
      Result := False;
      case oW.LockProtocol of
        lpNone            : Result := True;
        lpDB4Lock         : Result := FNTXBag.NTXHandler.UnLock(DB4_LockMax, 1);
        lpClipperLock     : Result := FNTXBag.NTXHandler.UnLock(CLIPPER_LockMax, 1);
        lpFoxLock         : Result := FNTXBag.NTXHandler.UnLock(FOX_LockMax, 1);
        lpClipperForFoxLob: Result := FNTXBag.NTXHandler.UnLock(CLIPPER_FOR_FOX_LOB_LockMax, 1);
      end;
    end else
      Result := true;
    FFileLock := not Result;
  finally
    FFUnLockObject.Release;
  end;
end;

procedure TVKNTXIndex.SetUnique(const Value: boolean);
begin
  if IsOpen then begin
    if Value then
      FNTXOrder.FHead.unique := #1
    else
      FNTXOrder.FHead.unique := #0;
  end else
    FUnique := Value;
end;

function TVKNTXIndex.GetUnique: boolean;
begin
  if IsOpen then
    Result := (FNTXOrder.FHead.unique <> #0)
  else
    Result := FUnique;
end;

procedure TVKNTXIndex.SetDesc(const Value: boolean);
begin
  if IsOpen then begin
    if Value then
      FNTXOrder.FHead.Desc := #1
    else
      FNTXOrder.FHead.Desc := #0;
  end else
    FDesc := Value;
end;

function TVKNTXIndex.GetDesc: boolean;
begin
  if IsOpen then
    Result := (FNTXOrder.FHead.Desc <> #0)
  else
    Result := FDesc;
end;

function TVKNTXIndex.GetOrder: AnsiString;
var
  i: Integer;
  p: pAnsiChar;
begin
  if IsOpen then begin
    for i := 0 to 7 do
      if FNTXOrder.FHead.order[i] = #0 then break;
    p := pAnsiChar(@FNTXOrder.FHead.order[0]);
    SetString(Result, p, i);
    ChekExpression(Result);
    if Result = '' then Result := Name;
  end else
    Result := FOrder;
end;

procedure TVKNTXIndex.SetOrder(Value: AnsiString);
var
  i, j: Integer;
begin
  if IsOpen then begin
    ChekExpression(Value);
    j := Length(Value);
    if j > 8 then j := 8;
    for i := 0 to j - 1 do
      FNTXOrder.FHead.order[i] := Value[i + 1];
    FNTXOrder.FHead.order[j] := #0;
    Name := FNTXOrder.FHead.order;
  end else
    FOrder := Value;
end;

procedure TVKNTXIndex.ChekExpression(var Value: AnsiString);
var
  i, j: Integer;
begin
  j := Length(Value);
  for i := 1 to j do
    if Value[i] < #32 then begin
      Value := '';
      Exit;
    end;
end;

function TVKNTXIndex.CmpKeys1(ItemKey, CurrKey: pAnsiChar; KSize: Integer): Integer;
var
  Srckey: array[0..NTX_PAGE-1] of AnsiChar;
  Destkey1, Destkey2: array[0..NTX_PAGE-1] of AnsiChar;
begin
  if KSize = 0 then KSize := FNTXOrder.FHead.key_size;
  if FKeyTranslate then begin
    Move(ItemKey^, Srckey, KSize);
    Srckey[KSize] := #0;
    TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey1, false);
    Move(CurrKey^, Srckey, KSize);
    Srckey[KSize] := #0;
    TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey2, false);
    Result := CompareKeys(Destkey2, Destkey1, KSize);
  end else
    Result := CompareKeys(CurrKey, ItemKey, KSize);
  if Desc then Result := - Result;
end;

function TVKNTXIndex.CmpKeys2(ItemKey, CurrKey: pAnsiChar; KSize: Integer): Integer;
var
  Srckey: array[0..NTX_PAGE-1] of AnsiChar;
  Destkey1, Destkey2: array[0..NTX_PAGE-1] of AnsiChar;
begin
  if KSize = 0 then KSize := FNTXOrder.FHead.key_size;
  if FKeyTranslate then begin
    Move(ItemKey^, Destkey1, KSize);
    //Move(ItemKey^, Srckey, KSize);
    //Srckey[KSize] := #0;
    //TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey1, false);
    Move(CurrKey^, Srckey, KSize);
    Srckey[KSize] := #0;
    TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey2, false);
    Result := CompareKeys(Destkey2, Destkey1, KSize);
  end else
    Result := CompareKeys(CurrKey, ItemKey, KSize);
  if Desc then Result := - Result;
end;

function TVKNTXIndex.CmpKeys(ItemKey, CurrKey: pAnsiChar; KSize: Integer = 0): Integer;
var
  Srckey: array[0..NTX_PAGE-1] of AnsiChar;
  Destkey: array[0..NTX_PAGE-1] of AnsiChar;
begin
  if KSize = 0 then KSize := FNTXOrder.FHead.key_size;
  if FKeyTranslate then begin
    Move(ItemKey^, Srckey, KSize);
    Srckey[KSize] := #0;
    TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Destkey, false);
    Result := CompareKeys(CurrKey, Destkey, KSize);
  end else
    Result := CompareKeys(CurrKey, ItemKey, KSize);
  if Desc then Result := - Result;
end;

function TVKNTXIndex.CmpKeys3(ItemKey, CurrKey: pAnsiChar; KSize: Integer): Integer;
begin
  if KSize = 0 then KSize := FNTXOrder.FHead.key_size;
  Result := CompareKeys(CurrKey, ItemKey, KSize);
  if Desc then Result := - Result;
end;

procedure TVKNTXIndex.TransKey(Key: pAnsiChar; KSize: Integer = 0; ToOem: Boolean = true);
var
  Srckey: array[0..NTX_PAGE-1] of AnsiChar;
begin
  if KSize = 0 then KSize := FNTXOrder.FHead.key_size;
  if FKeyTranslate then begin
    Move(Key^, Srckey, KSize);
    Srckey[KSize] := #0;
    TVKDBFNTX(FIndexes.Owner).Translate(Srckey, Key, ToOem);
  end;
end;

procedure TVKNTXIndex.TransKey(var SItem: SORT_ITEM);
begin
  if TVKDBFNTX(FIndexes.Owner).OEM and ( CollationType <> cltNone ) then begin
    TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(@SItem.key[0]), pAnsiChar(@SItem.key[0]), True, FNTXOrder.FHead.key_size);
  end;
end;

procedure TVKNTXIndex.CreateIndex(Activate: boolean = true; PreSorterBlockSize: LongWord = 65536);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  Key: AnsiString;
  Rec: DWORD;
  LastFUpdated: boolean;
  Sorter: TVKSorterAbstract;
  SorterRecCount: DWord;
  sitem: SORT_ITEM;
  ntxitem: NTX_ITEM;
  AddOk: boolean;
  HashTableSize: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  SortItem: PSORT_ITEM;

  procedure AddKeyInSorter(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      sitem.RID := Rec;
      sitem.Hash := FKeyParser.Hash;
      if TVKDBFNTX(FIndexes.Owner).OEM and ( CollationType <> cltNone ) then
        TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(Key), pAnsiChar(@sitem.key[0]), True, FNTXOrder.FHead.key_size)
      else
        Move(pAnsiChar(Key)^, sitem.key, FNTXOrder.FHead.key_size);
      Sorter.AddItem(sitem);
    end;
  end;

  procedure CreateEmptyIndex;
  var
    IndAttr: TIndexAttributes;
  begin
    if not FReindex then begin
      DefineBag;
      FNTXBag.NTXHandler.CreateProxyStream;
      if not FNTXBag.NTXHandler.IsOpen then begin
        raise Exception.Create('TVKNTXIndex.CreateIndex: Create error "' + Name + '"');
      end else begin
        FNTXBuffers.Clear;
        if FClipperVer in [v500, v501] then
          FNTXOrder.FHead.sign := 6
        else
          FNTXOrder.FHead.sign := 7;
        FNTXOrder.FHead.version := 1;
        FNTXOrder.FHead.root := NTX_PAGE;
        FNTXOrder.FHead.next_page := 0;

        if Assigned(OnCreateIndex) then begin
          OnCreateIndex(self, IndAttr);
          FNTXOrder.FHead.key_size := IndAttr.key_size;
          FNTXOrder.FHead.key_dec := IndAttr.key_dec;
          System.Move(pAnsiChar(IndAttr.key_expr)^, FNTXOrder.FHead.key_expr, Length(IndAttr.key_expr));
          FNTXOrder.FHead.key_expr[Length(IndAttr.key_expr)] := #0;
          System.Move(pAnsiChar(IndAttr.for_expr)^, FNTXOrder.FHead.for_expr, Length(IndAttr.for_expr));
          FNTXOrder.FHead.for_expr[Length(IndAttr.for_expr)] := #0;
        end else begin
          FNTXOrder.FHead.key_size := Length(FKeyParser.Key);
          FNTXOrder.FHead.key_dec := FKeyParser.Prec;
          System.Move(pAnsiChar(FKeyExpresion)^, FNTXOrder.FHead.key_expr, Length(FKeyExpresion));
          FNTXOrder.FHead.key_expr[Length(FKeyExpresion)] := #0;
          System.Move(pAnsiChar(FForExpresion)^, FNTXOrder.FHead.for_expr, Length(FForExpresion));
          FNTXOrder.FHead.for_expr[Length(FForExpresion)] := #0;
        end;

        FNTXOrder.FHead.item_size := FNTXOrder.FHead.key_size + 8;
        FNTXOrder.FHead.max_item := (NTX_PAGE - FNTXOrder.FHead.item_size - 4) div (FNTXOrder.FHead.item_size + 2);
        FNTXOrder.FHead.half_page := FNTXOrder.FHead.max_item div 2;
        FNTXOrder.FHead.max_item := FNTXOrder.FHead.half_page * 2;

        FNTXOrder.FHead.reserv1 := #0;
        FNTXOrder.FHead.reserv3 := #0;

        Order := FOrder;
        Desc := FDesc;
        Unique := FUnique;

        FNTXBuffers.Flt := LimitPages.LimitPagesType;
        case FNTXBuffers.Flt of
          lbtAuto:
            begin
              FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
              LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
              LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
            end;
          lbtLimited:
            begin
              FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
          lbtUnlimited:
            begin
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
        end;
        FAllowSetCollationType := True;
        try
          CollationType := Collation.CollationType;
        finally
          FAllowSetCollationType := False;
        end;
        CustomCollatingSequence := Collation.CustomCollatingSequence;

        FNTXBag.NTXHandler.Seek(0, 0);
        FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
        FLastOffset := SizeOf(NTX_HEADER);
        GetFreePage;
      end;
    end else begin
      //Truncate ntx file
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.SetEndOfFile;
      FNTXBuffers.Clear;
      if FClipperVer in [v500, v501] then
        FNTXOrder.FHead.sign := 6
      else
        FNTXOrder.FHead.sign := 7;
      FNTXOrder.FHead.version := 1;
      FNTXOrder.FHead.root := NTX_PAGE;
      FNTXOrder.FHead.next_page := 0;
      FNTXOrder.FHead.reserv1 := #0;
      FNTXOrder.FHead.reserv3 := #0;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Flt := LimitPages.LimitPagesType;
      case FNTXBuffers.Flt of
        lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
      end;
      FAllowSetCollationType := True;
      try
        CollationType := Collation.CollationType;
      finally
        FAllowSetCollationType := False;
      end;
      CustomCollatingSequence := Collation.CustomCollatingSequence;
      FLastOffset := SizeOf(NTX_HEADER);
      GetFreePage;
    end;
  end;

begin
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FGetHashFromSortItem := True;
    FCreateIndexProc:= true;
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    LastFUpdated := FUpdated;
    FUpdated := true;
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      CreateEmptyIndex;

      if FHashTypeForTreeSorters = httsDefault then begin
        HashTableSize := htst256;
        GetHashCodeMethod := nil;
      end else begin
        HashTableSize := THashTableSizeType(Integer(FHashTypeForTreeSorters) - 1);
        GetHashCodeMethod := GetVKHashCode;
      end;
      SorterRecCount :=( PreSorterBlockSize ) div ( FNTXOrder.FHead.key_size + ( 2 * SizeOf(DWord) ) );
      Sorter := TVKRedBlackTreeSorter.Create(  SorterRecCount,
                                               FNTXOrder.FHead.key_size,
                                               IndexSortProc,
                                               IndexSortCharsProc,
                                               nil,
                                               Unique,
                                               HashTableSize,
                                               GetHashCodeMethod,
                                               TMaxBitsInHashCode(MaxBitsInHashCode));
      try
        RecPareBuf := oB.BufferSize div oB.Header.rec_size;
        if RecPareBuf >= 1 then begin
          ReadSize := RecPareBuf * oB.Header.rec_size;
          oB.Handle.Seek(oB.Header.data_offset, 0);
          Rec := 0;
          repeat
            RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
            BufCnt := RealRead div oB.Header.rec_size;
            for i := 0 to BufCnt - 1 do begin
              oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
              if oB.Crypt.Active then
                oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
              Inc(Rec);
              Key := EvaluteKeyExpr;
              //
              AddKeyInSorter(Key, Rec);
              //
              if  Sorter.CountAddedItems = Sorter.CountRecords then begin
                Sorter.Sort;

                ///////////
                if not Sorter.FirstSortItem then begin
                  repeat
                    SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
                    ntxitem.page := 0;
                    ntxitem.rec_no := SortItem.RID;
                    if oB.OEM and ( CollationType <> cltNone ) then
                      Move(SortItem.key, ntxitem.key, FNTXOrder.FHead.key_size)
                    else
                      TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(@SortItem.key[0]), pAnsiChar(@ntxitem.key[0]), True, FNTXOrder.FHead.key_size);
                    ntxitem.key[FNTXOrder.FHead.key_size] := #0;

                    SetString(Key, pAnsiChar(@ntxitem.key[0]), FNTXOrder.FHead.key_size);
                    TransKey(pAnsiChar(Key), FNTXOrder.FHead.key_size, False);
                    AddOk := true;
                    if Unique then
                      AddOk := AddOk and (not SeekFirstInternal(Key));
                    if AddOk then
                      AddItem(@ntxitem);

                  until Sorter.NextSortItem;
                end;
                ///////////

                Sorter.Clear;
              end;
              //
            end;
          until ( BufCnt <= 0 );
          //
          if Sorter.CountAddedItems > 0 then begin
            Sorter.Sort;

            ///////////
            if not Sorter.FirstSortItem then begin
              repeat
                SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
                ntxitem.page := 0;
                ntxitem.rec_no := SortItem.RID;
                if oB.OEM and ( CollationType <> cltNone ) then
                  Move(SortItem.key, ntxitem.key, FNTXOrder.FHead.key_size)
                else
                  TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(@SortItem.key[0]), pAnsiChar(@ntxitem.key[0]), True, FNTXOrder.FHead.key_size);
                ntxitem.key[FNTXOrder.FHead.key_size] := #0;

                SetString(Key, pAnsiChar(@ntxitem.key[0]), FNTXOrder.FHead.key_size);
                TransKey(pAnsiChar(Key), FNTXOrder.FHead.key_size, False);
                AddOk := true;
                if Unique then
                  AddOk := AddOk and (not SeekFirstInternal(Key));
                if AddOk then
                  AddItem(@ntxitem);

              until Sorter.NextSortItem;
            end;
            ///////////

            Sorter.Clear;
          end;
          //
        end else Exception.Create('TVKNTXIndex.CreateIndex: Record size too lage');
      finally
        FreeAndNil(Sorter);
      end;
    finally
      Flush;
      FUpdated := LastFUpdated;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Clear;
      FCreateIndexProc:= false;
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
    end;
    if IsOpen then begin
      if  ( ( ( oB.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
          ( ( oB.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
          StartUpdate;
      InternalFirst;
      KeyExpresion := FNTXOrder.FHead.key_expr;
      ForExpresion := FNTXOrder.FHead.for_expr;
      if ForExpresion <> '' then
        FForExists := true;
      if Activate then Active := true;
    end;
  end else raise Exception.Create('TVKNTXIndex.CreateIndex: Create index only on active DataSet');
end;

procedure TVKNTXIndex.CreateCompactIndex( BlockBufferSize: LongWord = 65536;
                                          Activate: boolean = true;
                                          CreateTmpFilesInCurrentDir: boolean = false);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  Key: AnsiString;
  Rec: DWORD;
  BlockBuffer: pAnsiChar;
  FNtxHead: NTX_HEADER;
  max_item: WORD;
  Objects: TObjectList;
  Iter1, Iter2: TVKNTXIndexIterator;
  cIndex: TVKNTXCompactIndex;

  procedure LoadBlock(BlockFile: AnsiString; pBlock: pAnsiChar);
  var
    h: Integer;
  begin
    h := FileOpen(BlockFile, fmOpenRead or fmShareExclusive);
    if h > 0 then begin
      SysUtils.FileRead(h, pBlock^, BlockBufferSize);
      SysUtils.FileClose(h);
    end;
  end;

  procedure SaveBlock;
  var
    TmpFileName: AnsiString;
    h: Integer;
  begin
    if pBLOCK_BUFFER(BlockBuffer).count > 0 then begin
      if CreateTmpFilesInCurrentDir then  //if CreateTmpFilesInCurrentDir = True then create TmpFileName in current path
        TmpFileName := GetTmpFileName(ExtractFilePath(NTXFileName))
      else  // else in system temporary directory
        TmpFileName := GetTmpFileName;
      h := FileOpen(TmpFileName, fmOpenWrite or fmShareExclusive);
      if h > 0 then begin
        SysUtils.FileWrite(h, BlockBuffer^, BlockBufferSize);
        SysUtils.FileClose(h);
        Objects.Add(TVKNTXBlockIterator.Create(TmpFileName, FNtxHead.key_size, BlockBufferSize));
      end;
    end;
  end;

  procedure FillNtxHeader;
  var
    i: Integer;
    IndAttr: TIndexAttributes;
  begin
    DefineBag;
    if FClipperVer in [v500, v501] then
      FNtxHead.sign := 6
    else
      FNtxHead.sign := 7;
    FNtxHead.version := 0;
    FNtxHead.root := NTX_PAGE;
    FNtxHead.next_page := 0;

    if Assigned(OnCreateIndex) then begin
      OnCreateIndex(self, IndAttr);
      FNtxHead.key_size := IndAttr.key_size;
      FNtxHead.key_dec := IndAttr.key_dec;
      System.Move(pAnsiChar(IndAttr.key_expr)^, FNtxHead.key_expr, Length(IndAttr.key_expr));
      FNtxHead.key_expr[Length(IndAttr.key_expr)] := #0;
      System.Move(pAnsiChar(IndAttr.for_expr)^, FNtxHead.for_expr, Length(IndAttr.for_expr));
      FNtxHead.for_expr[Length(IndAttr.for_expr)] := #0;
    end else begin
      FNtxHead.key_size := Length(FKeyParser.Key);
      FNtxHead.key_dec := FKeyParser.Prec;
      System.Move(pAnsiChar(FKeyExpresion)^, FNtxHead.key_expr, Length(FKeyExpresion));
      FNtxHead.key_expr[Length(FKeyExpresion)] := #0;
      System.Move(pAnsiChar(FForExpresion)^, FNtxHead.for_expr, Length(FForExpresion));
      FNtxHead.for_expr[Length(FForExpresion)] := #0;
    end;

    FNtxHead.item_size := FNtxHead.key_size + 8;
    FNtxHead.max_item := (NTX_PAGE - FNtxHead.item_size - 4) div (FNtxHead.item_size + 2);
    FNtxHead.half_page := FNtxHead.max_item div 2;
    FNtxHead.max_item := FNtxHead.half_page * 2;
    if Unique then
      FNtxHead.unique := #1
    else
      FNtxHead.unique := #0;
    FNtxHead.reserv1 := #0;
    if Desc then
      FNtxHead.desc := #1
    else
      FNtxHead.desc := #0;
    FNtxHead.reserv3 := #0;
    for i := 0 to 7 do FNtxHead.order[i] := FNTXOrder.FHead.Order[i];
    //
    FNTXOrder.FHead := FNtxHead;
    //
    //
    FAllowSetCollationType := True;
    try
      CollationType := Collation.CollationType;
    finally
      FAllowSetCollationType := False;
    end;
    CustomCollatingSequence := Collation.CustomCollatingSequence;
    //
  end;

  procedure InitBlock(Block: pAnsiChar);
  var
    page: pBLOCK_BUFFER;
    half_page, item_size, item_off: WORD;
    i: Integer;
    q: LongWord;
  begin

    item_size := FNtxHead.key_size + 4;
    q := (BlockBufferSize - item_size - 4) div (item_size + 2);
    if q > MAXWORD then raise Exception.Create('TVKNTXIndex.CreateCompactIndex: BlockBufferSize too large!');
    max_item := WORD(q);
    half_page := max_item div 2;
    max_item := half_page * 2;

    page := pBLOCK_BUFFER(Block);
    page.count := 0;
    item_off := ( max_item * 2 ) + 4;
    for i := 0 to max_item do begin
      page.ref[i] := item_off;
      item_off := item_off + item_size;
    end;
  end;

  procedure AddKeyInBlock(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
    i, j, beg, Mid: Integer;
    page: pBLOCK_BUFFER;
    item: pBLOCK_ITEM;
    c: Integer;
    rf: WORD;

    procedure InsItem;
    begin
      j := page.count;
      while j >= i do begin
        rf := page.ref[j + 1];
        page.ref[j + 1] := page.ref[j];
        page.ref[j] := rf;
        Dec(j);
      end;
      page.count := page.count + 1;
      Move(pAnsiChar(Key)^, pBLOCK_ITEM(pAnsiChar(page) + page.ref[i]).key, FNTXOrder.FHead.key_size);
      pBLOCK_ITEM(pAnsiChar(page) + page.ref[i]).rec_no := Rec;
    end;

    procedure CmpRec;
    begin
      if c = 0 then begin
        if item.rec_no < Rec then
          c := 1
        else
          c := -1;
      end;
    end;

  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      page := pBLOCK_BUFFER(BlockBuffer);
      if page.count = max_item then begin
        //Save block on disc
        SaveBlock;
        //Truncate block
        page.count := 0;
      end;
      TransKey(pAnsiChar(Key));
      i := page.count;
      if ( i > 0 ) then begin
        beg := 0;
        item := pBLOCK_ITEM(pAnsiChar(page) + page.ref[beg]);
        c := CmpKeys1(item.key, pAnsiChar(Key));
        if ( c = 0 ) and Unique then Exit;

        CmpRec;

        if ( c > 0 ) then begin
          repeat
            Mid := (i+beg) div 2;
            item := pBLOCK_ITEM(pAnsiChar(page) + page.ref[Mid]);
            c := CmpKeys1(item.key, pAnsiChar(Key));
            if ( c = 0 ) and Unique then Exit;

            CmpRec;

            if ( c > 0 ) then
               beg := Mid
            else
               i := Mid;
          until ( ((i-beg) div 2) = 0 );
        end else
          i := beg;
      end;
      if AddOk then InsItem;
    end;
  end;

  procedure MergeList(Iter1, Iter2: TVKNTXIndexIterator; cIndex: TVKNTXCompactIndex);
  var
    c: Integer;

    procedure CmpRec;
    begin
      if c = 0 then begin
        if Iter1.item.rec_no < Iter2.item.rec_no then
          c := 1
        else
          c := -1;
      end;
    end;

  begin
    if Iter2 = nil then begin
      Iter1.Open;
      try
        while not Iter1.Eof do begin
          cIndex.AddItem(@Iter1.item);
          Iter1.Next;
        end;
      finally
        Iter1.Close;
      end;
    end else begin
      Iter1.Open;
      Iter2.Open;
      try
        repeat
          if not ( Iter1.Eof or Iter2.Eof ) then begin
            c := CmpKeys1(Iter1.Item.key, Iter2.Item.key);
            if ( c = 0 ) and Unique then begin
              cIndex.AddItem(@Iter1.Item);
              Iter1.Next;
              Iter2.Next;
              Continue;
            end;
            CmpRec;
            if c > 0 then begin
              if not Iter1.Eof then begin
                cIndex.AddItem(@Iter1.Item);
                Iter1.Next;
              end;
            end else
              if not Iter2.Eof then begin
                cIndex.AddItem(@Iter2.Item);
                Iter2.Next;
              end;
          end else begin
            if not Iter1.Eof then begin
              cIndex.AddItem(@Iter1.Item);
              Iter1.Next;
            end;
            if not Iter2.Eof then begin
              cIndex.AddItem(@Iter2.Item);
              Iter2.Next;
            end;
          end;
        until ( Iter1.Eof and Iter2.Eof );
      finally
        Iter1.Close;
        Iter2.Close;
      end;
    end;
  end;

begin
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    Objects := TObjectList.Create;
    cIndex := TVKNTXCompactIndex.Create(LimitPages.PagesPerBuffer);
    cIndex.CreateTmpFilesInTmpFilesDir := CreateTmpFilesInCurrentDir;
    cIndex.TmpFilesDir := ExtractFilePath(NTXFileName);
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    BlockBuffer := VKDBFMemMgr.oMem.GetMem(self, BlockBufferSize);
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      FillNtxHeader;

      InitBlock(BlockBuffer);

      RecPareBuf := oB.BufferSize div oB.Header.rec_size;
      if RecPareBuf >= 1 then begin
        ReadSize := RecPareBuf * oB.Header.rec_size;
        oB.Handle.Seek(oB.Header.data_offset, 0);
        Rec := 0;
        repeat
          RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
          BufCnt := RealRead div oB.Header.rec_size;
          for i := 0 to BufCnt - 1 do begin
            oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
            if oB.Crypt.Active then
              oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
            Inc(Rec);
            Key := EvaluteKeyExpr;
            //
            AddKeyInBlock(Key, Rec);
            //
          end;
        until ( BufCnt <= 0 );
        //Save the rest block
        SaveBlock;
        if Objects.Count > 0 then begin
          // Merge lists
          i := 0;
          while  i < Objects.Count do begin
            Iter1 := TVKNTXIndexIterator(Objects[i]);
            if ( i + 1 ) < Objects.Count then
              Iter2 := TVKNTXIndexIterator(Objects[i + 1])
            else
              Iter2 := nil;
            if ( Objects.Count - i ) > 2 then
              cIndex.FileName := ''
            else begin
              cIndex.FileName := FNTXFileName;
              cIndex.Crypt := oB.Crypt.Active;
              cIndex.OwnerTable := oB;
              if FNTXBag.NTXHandler.ProxyStreamType <> pstFile then
                cIndex.Handler := FNTXBag.NTXHandler;
            end;
            cIndex.CreateEmptyIndex(FNtxHead);
            try
              MergeList(Iter1, Iter2, cIndex);
            finally
              cIndex.Close;
              if ( Objects.Count - i ) > 2 then
                Objects.Add(TVKNTXIterator.Create(cIndex.FileName));
            end;
            Inc(i, 2);
          end;
        end else begin
          cIndex.FileName := FNTXFileName;
          cIndex.Crypt := oB.Crypt.Active;
          cIndex.OwnerTable := oB;
          if FNTXBag.NTXHandler.ProxyStreamType <> pstFile then
            cIndex.Handler := FNTXBag.NTXHandler;
          cIndex.CreateEmptyIndex(FNtxHead);
          cIndex.Close;
        end;
        //
      end else Exception.Create('TVKNTXIndex.CreateCompactIndex: Record size too lage');
    finally
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
      VKDBFMemMgr.oMem.FreeMem(BlockBuffer);
      Objects.Free;
      cIndex.Free;
    end;
    Open;
    if IsOpen and Activate then Active := true;
  end else raise Exception.Create('TVKNTXIndex.CreateCompactIndex: Create index only on active DataSet');
end;

function TVKNTXIndex.SuiteFieldList(fl: AnsiString; out m: Integer): Integer;
begin
  if Temp then begin
    m := 0;
    Result := 0
  end else
    Result := FKeyParser.SuiteFieldList(fl, m);
end;

function TVKNTXIndex.SeekFields(const KeyFields: AnsiString;
  const KeyValues: Variant; SoftSeek: boolean = false;
  PartialKey: boolean = false): Integer;
var
  m, n: Integer;
  Key: AnsiString;
begin
  Result := 0;
  m := FKeyParser.SuiteFieldList(KeyFields, n);
  if m > 0 then begin
    if PartialKey then FKeyParser.PartualKeyValue := True;
    try
      Key := FKeyParser.EvaluteKey(KeyFields, KeyValues);
    finally
      FKeyParser.PartualKeyValue := False;
    end;
    Result := SeekFirstRecord(Key, SoftSeek, PartialKey);
  end;
end;

function TVKNTXIndex.GetOwnerTable: TDataSet;
begin
  Result := TDataSet(FIndexes.Owner);
end;

function TVKNTXIndex.SeekLastInternal(Key: AnsiString;
  SoftSeek: boolean): boolean;
var
  lResult, SoftSeekSet: boolean;

  procedure Pass(page_off: DWORD);
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    c: Integer;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          c := CmpKeys(item.key, pAnsiChar(Key), Length(Key));

          if c < 0 then begin //Key < item.key
            if ( item.page <> 0 ) then Pass(item.page);
            if (SoftSeek) and (not lResult) and ( not SoftSeekSet ) then begin
              FSeekRecord := item.rec_no;
              SoftSeekSet := true;
              SetString(FSeekKey, item.key, FNTXOrder.FHead.key_size);
              FSeekOk := true;
            end;
            Exit;
          end;

          if c = 0 then begin //Key = item.key
            FSeekRecord := item.rec_no;
            SetString(FSeekKey, item.key, FNTXOrder.FHead.key_size);
            FSeekOk := true;
            lResult := true;
          end;

        end;

      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  FSeekOk := false;

  SoftSeekSet := false;

  if FLock then
    try

      ClearIfChange;

      lResult := false;
      Pass(FNTXOrder.FHead.root);
      Result := lResult;

    finally
      FUnLock;
    end
  else
    Result := false;

end;

procedure TVKNTXIndex.SetRangeFields(FieldList: AnsiString;
  FieldValues: array of const);
var
  FieldVal: Variant;
begin
  ArrayOfConstant2Variant(FieldValues, FieldVal);
  SetRangeFields(FieldList, FieldVal);
end;

procedure TVKNTXIndex.SetRangeFields(FieldList: AnsiString;
  FieldValues: Variant);
var
  Key: AnsiString;
begin
  FKeyParser.PartualKeyValue := True;
  try
    Key := FKeyParser.EvaluteKey(FieldList, FieldValues);
  finally
    FKeyParser.PartualKeyValue := False;
  end;
  NTXRange.LoKey := Key;
  NTXRange.HiKey := Key;
  NTXRange.ReOpen;
end;

function TVKNTXIndex.GetIsRanged: boolean;
begin
  Result := NTXRange.Active;
end;

function TVKNTXIndex.InRange(Key: AnsiString): boolean;
begin
  Result := NTXRange.InRange(Key);
end;

procedure TVKNTXIndex.ClearIfChange;
var
  v: WORD;
begin
  if not FCreateIndexProc then begin
    if not FUpdated then begin
      v := FNTXOrder.FHead.version;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Read(FNTXOrder.FHead, 12);
      if v <> FNTXOrder.FHead.version then FNTXBuffers.Clear;
    end;
  end;
end;

procedure TVKNTXIndex.StartUpdate(UnLock: boolean = true);
begin
  if not FUpdated then
    if FLock then
      try
        FLastOffset := FNTXBag.NTXHandler.Seek(0, 2);
        ClearIfChange;
        FUpdated := true;
      finally
        if UnLock then FUnLock;
      end;
end;

procedure TVKNTXIndex.Flush;
begin
  if FUpdated then begin
    FNTXBuffers.Flush(FNTXBag.NTXHandler);
    if not FCreateIndexProc then begin
      if FNTXOrder.FHead.version > 65530 then
        FNTXOrder.FHead.version := 0
      else
        FNTXOrder.FHead.version := FNTXOrder.FHead.version + 1;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, 12);
    end;
    FUpdated := false;
  end;
end;

procedure TVKNTXIndex.Reindex(Activate: boolean = true);
begin
  FReindex := true;
  try
    CreateIndex(Activate);
  finally
    FReindex := false;
  end;
end;

function TVKNTXIndex.GetCreateNow: Boolean;
begin
  Result := false;
end;

procedure TVKNTXIndex.SetCreateNow(const Value: Boolean);
begin
  if Value then begin
    CreateIndex;
    if csDesigning in OwnerTable.ComponentState then ShowMessage(Format('Index %s create successfully!', [NTXFileName]));
  end;
end;

function TVKNTXIndex.SeekFirstRecord(Key: AnsiString;
  SoftSeek: boolean = false; PartialKey: boolean = false): Integer;
begin
  Result := FindKey(Key, PartialKey, SoftSeek);
end;

procedure TVKNTXIndex.Truncate;
begin
  //Truncate ntx file
  FNTXBag.NTXHandler.Seek(0, 0);
  FNTXBag.NTXHandler.SetEndOfFile;
  //Create new header
  FNTXBuffers.Clear;
  FNTXOrder.FHead.version := 1;
  FNTXOrder.FHead.root := NTX_PAGE;
  FNTXOrder.FHead.next_page := 0;
  FNTXOrder.FHead.reserv1 := #0;
  FNTXOrder.FHead.reserv3 := #0;
  FNTXBag.NTXHandler.Seek(0, 0);
  FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
  FLastOffset := SizeOf(NTX_HEADER);
  GetFreePage;
end;

procedure TVKNTXIndex.BeginCreateIndexProcess;
begin
  Truncate;
  FCreateIndexProc:= true;
  FFLastFUpdated := FUpdated;
  FUpdated := true;
end;

procedure TVKNTXIndex.EndCreateIndexProcess;
begin
  Flush;
  FUpdated := FFLastFUpdated;
  FNTXBag.NTXHandler.Seek(0, 0);
  FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
  FNTXBuffers.Clear;
  FCreateIndexProc:= false;
end;

procedure TVKNTXIndex.EvaluteAndAddKey(nRec: DWORD);
var
  Key: AnsiString;
begin
  Key := EvaluteKeyExpr;
  AddKey(Key, nRec);
end;

function TVKNTXIndex.InRange: boolean;
var
  Key: AnsiString;
begin
  FKeyParser.PartualKeyValue := True;
  try
    Key := EvaluteKeyExpr;
  finally
    FKeyParser.PartualKeyValue := False;
  end;
  Result := NTXRange.InRange(Key);
end;

function TVKNTXIndex.FindKey( Key: AnsiString; PartialKey: boolean = false;
                              SoftSeek: boolean = false; Rec: DWORD = 0): Integer;
var
  oB: TVKDBFNTX;
  m: Integer;
  iResult: Integer;

  function Pass(page_off: DWORD): boolean;
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    c, c1: Integer;
    ntxb: TVKNTXNode;
  begin

    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin

          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);

          c := CmpKeys(item.key, pAnsiChar(Key), m);

          c1 := c;
          if Rec > 0 then
            if c = 0 then begin
              if item.rec_no < Rec then
                c1 := 1
              else if item.rec_no = Rec then
                c1 := 0
              else
                c1 := -1;
            end;

          if c1 <= 0 then begin //Key + RecNo <= item.key + RecNo
            if ( item.page <> 0 ) then begin
              Result := Pass(item.page);
              if Result then Exit;
            end;
            if c = 0 then begin // Key = item.key
              if oB.AcceptTmpRecord(item.rec_no) then begin
                iResult := item.rec_no;
                Result := true;
                Exit;
              end;
            end else begin
              if SoftSeek then begin
                if oB.AcceptTmpRecord(item.rec_no) then begin
                  iResult := item.rec_no;
                  Result := true;
                  Exit;
                end;
              end else begin
                Result := false;
                Exit;
              end;
            end;
          end;

        end;
      end;

      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then begin
        Result := Pass(item.page);
        if Result then Exit;
      end;

      Result := false;
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
    end;
  end;

begin

  Result := 0;
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then
    if FLock then
      try

        ClearIfChange;

        m := Length(Key);
        if m > FNTXOrder.FHead.key_size then m := FNTXOrder.FHead.key_size;
        if ( not ( PartialKey or SoftSeek ) ) and (m < FNTXOrder.FHead.key_size) then Exit;
        iResult := 0;
        Pass(FNTXOrder.FHead.root);
        Result := iResult;

      finally
        FUnLock;
      end;

end;

function TVKNTXIndex.FindKeyFields(const KeyFields: AnsiString;
  const KeyValues: Variant; PartialKey: boolean = false;
  SoftSeek: boolean = false): Integer;
var
  m, l: Integer;
  Key: AnsiString;
  KeyFields_: AnsiString;
  PartialKeyInternal: boolean;
begin
  Result := 0;
  KeyFields_ := KeyFields;
  if KeyFields_ = '' then KeyFields_ := FKeyParser.GetFieldList;
  m := FKeyParser.SuiteFieldList(KeyFields_, l);
  if m > 0 then begin
    PartialKeyInternal := PartialKey;
    if not PartialKeyInternal then begin
      if m > VarArrayDimCount(KeyValues) then PartialKeyInternal := True;
    end;
    if PartialKeyInternal then FKeyParser.PartualKeyValue := True;
    try
      Key := FKeyParser.EvaluteKey(KeyFields_, KeyValues);
    finally
      FKeyParser.PartualKeyValue := False;
    end;
    Result := FindKey(Key, PartialKeyInternal, SoftSeek);
  end;
end;

function TVKNTXIndex.FindKeyFields(const KeyFields: AnsiString;
  const KeyValues: array of const; PartialKey: boolean = false;
  SoftSeek: boolean = false): Integer;
var
  FieldVal: Variant;
begin
  ArrayOfConstant2Variant(KeyValues, FieldVal);
  Result := FindKeyFields(KeyFields, FieldVal, PartialKey, SoftSeek);
end;

function TVKNTXIndex.FindKeyFields(PartialKey: boolean = false;
  SoftSeek: boolean = false): Integer;
var
  Key: AnsiString;
begin
  if PartialKey then FKeyParser.PartualKeyValue := True;
  try
    Key := FKeyParser.EvaluteKey;
  finally
    FKeyParser.PartualKeyValue := False;
  end;
  Result := FindKey(Key, PartialKey, SoftSeek);
end;

function TVKNTXIndex.TransKey(Key: AnsiString): AnsiString;
begin
  Result := Key;
  TransKey(pAnsiChar(Result), Length(Result), false);
end;

function TVKNTXIndex.IsForIndex: boolean;
begin
  Result := FForExists;
end;

function TVKNTXIndex.IsUniqueIndex: boolean;
begin
  Result := Unique;
end;

procedure TVKNTXIndex.DefineBagAndOrder;
var
  oO: TVKNTXOrder;
  i: Integer;
  IndexName: AnsiString;
begin
  IndexName := ChangeFileExt(ExtractFileName(NTXFileName), '');
  if IndexName = '' then IndexName := Order;
  if IndexName = '' then IndexName := Name;
  DefineBag;
  if not FNTXBag.IsOpen then FNTXBag.Open;
  for i := 0 to FNTXBag.Orders.Count - 1 do begin
    oO := TVKNTXOrder(FNTXBag.Orders.Items[i]);
    if AnsiUpperCase(oO.Name) = AnsiUpperCase(IndexName) then begin
      FNTXOrder := oO;

      LimitPages.LimitPagesType := oO.LimitPages.LimitPagesType;
      LimitPages.LimitBuffers := oO.LimitPages.LimitBuffers;
      LimitPages.PagesPerBuffer := oO.LimitPages.PagesPerBuffer;
      Collation.CollationType := oO.Collation.CollationType;
      Collation.CustomCollatingSequence := oO.Collation.CustomCollatingSequence;
      OuterSorterProperties := oO.OuterSorterProperties;

    end;
  end;
  if FNTXOrder = nil then
    raise Exception.Create('TVKNTXIndex.DefineBagAndOrder: FNTXOrder not defined!');
end;

procedure TVKNTXIndex.DefineBag;
var
  oW: TVKDBFNTX;
  oB: TVKNTXBag;
  oO: TVKNTXOrder;
  i: Integer;
  BgNm, IndexName: AnsiString;
  NewOrder: boolean;
begin
  oW := TVKDBFNTX(FIndexes.Owner);
  IndexName := ChangeFileExt(ExtractFileName(NTXFileName), '');
  if IndexName = '' then IndexName := Order;
  if IndexName = '' then IndexName := Name;
  FNTXOrder := nil;
  FNTXBag := nil;
  for i := 0 to oW.DBFIndexDefs.Count - 1 do begin
    oB := TVKNTXBag(oW.DBFIndexDefs.Items[i]);
    BgNm := oB.Name;
    if BgNm = '' then BgNm := ChangeFileExt(ExtractFileName(oB.IndexFileName), '');
    if BagName <> '' then begin
      if AnsiUpperCase(BgNm) = AnsiUpperCase(BagName) then begin
        FNTXBag := oB;
        break;
      end;
    end else begin
      if AnsiUpperCase(BgNm) = AnsiUpperCase(IndexName) then begin
        FNTXBag := oB;
        break;
      end;
    end;
  end;
  if FNTXBag = nil then begin
    oB := TVKNTXBag(oW.DBFIndexDefs.Add);
    oB.Name := ChangeFileExt(ExtractFileName(NTXFileName), '');
    oB.IndexFileName := NTXFileName;
    oB.StorageType := oW.StorageType;
    FNTXBag := oB;
  end;
  FNTXBag.FillHandler;
  NewOrder := False;
  if FNTXBag.Orders.Count = 0 then begin
    FNTXBag.Orders.Add;
    NewOrder := True;
  end;
  oO := TVKNTXOrder(FNTXBag.Orders.Items[0]);
  FillChar(oO.FHead, SizeOf(NTX_HEADER), #0);
  oO.Name := ChangeFileExt(ExtractFileName(FNTXBag.IndexFileName), '');
  if oO.Name = '' then oO.Name := FNTXBag.Name;
  FNTXOrder := oO;
  if NewOrder then begin
    oO.LimitPages.LimitPagesType := LimitPages.LimitPagesType;
    oO.LimitPages.LimitBuffers := LimitPages.LimitBuffers;
    oO.LimitPages.PagesPerBuffer := LimitPages.PagesPerBuffer;
    oO.Collation.CollationType := Collation.CollationType;
    oO.Collation.CustomCollatingSequence := Collation.CustomCollatingSequence;
    oO.OuterSorterProperties := OuterSorterProperties;
  end else begin
    LimitPages.LimitPagesType := oO.LimitPages.LimitPagesType;
    LimitPages.LimitBuffers := oO.LimitPages.LimitBuffers;
    LimitPages.PagesPerBuffer := oO.LimitPages.PagesPerBuffer;
    Collation.CollationType := oO.Collation.CollationType;
    Collation.CustomCollatingSequence := oO.Collation.CustomCollatingSequence;
    OuterSorterProperties := oO.OuterSorterProperties;
  end;
end;

(*
procedure TVKNTXIndex.BackwardPass;
begin

end;

procedure TVKNTXIndex.ForwardPass;

  procedure Pass(page_off: DWORD);
  var
    i: DWORD;
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    ntxb: TVKNTXBuffer;
  begin
    ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
    try
      if page.count > 0 then begin
        for i := 0 to page.count - 1 do begin
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          if ( item.page <> 0 ) then Pass(item.page);
          //
        end;
      end;
      item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
      if ( item.page <> 0 ) then Pass(item.page);
    finally
      FNTXBuffers.FreeNTXBuffer(ntxb);
    end;
  end;

begin
  Pass(FNTXOrder.FHead.root);
end;
*)

procedure TVKNTXIndex.SetNTXRange(const Value: TVKNTXRange);
begin
  FNTXRange.HiKey := Value.HiKey;
  FNTXRange.LoKey := Value.LoKey;
  FNTXRange.Active := Value.Active;
end;

function TVKNTXIndex.GetIndexBag: TVKDBFIndexBag;
begin
  Result := FNTXBag;
end;

function TVKNTXIndex.GetIndexOrder: TVKDBFOrder;
begin
  Result := FNTXOrder;
end;

procedure TVKNTXIndex.IndexSortProc(Sender: TObject; CurrentItem, Item: PSORT_ITEM; MaxLen: Cardinal; out c: Integer);
var
  i: integer;
  c1, c2: pAnsiChar;
begin
  c1 := @CurrentItem.key[0];
  c2 := @Item.key[0];
  if CollationType <> cltNone then begin
    for i := 0 to MaxLen - 1 do begin
      c := CollatingTable[Ord(c1[i])] - CollatingTable[Ord(c2[i])];
      if c <> 0 then Break;
    end;
  end else begin
    c := {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLComp(c1, c2, MaxLen);
  end;
  if Desc then c := - c;
end;

procedure TVKNTXIndex.IndexSortCharsProc(Sender: TObject; Char1, Char2: Byte; out c: Integer);
begin
  (*
  if TVKDBFNTX(FIndexes.Owner).OEM and ( CollationType <> cltNone ) then begin
    c1 := AnsiChar3;
    c2 := AnsiChar4;
  end else begin
    c1 := AnsiChar1;
    c2 := AnsiChar2;
  end;
  *)
  if CollationType <> cltNone then begin
    c := CollatingTable[Char1] - CollatingTable[Char2];
  end else begin
    c := Char1 - Char2;
  end;
  if Desc then c := - c;
end;

(*
procedure TVKNTXIndex.CreateIndexUsingSorter1(
  SorterClass: TVKSorterClass; Activate: boolean);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i {, j}: Integer;
  Key: AnsiString;
  Rec: DWORD;
  LastFUpdated: boolean;
  Sorter: TVKSorterAbstract;
  sitem: SORT_ITEM;
  ntxitem: NTX_ITEM;
  HashTableSize: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  SortItem: PSORT_ITEM;

  procedure AddKeyInSorter(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      sitem.RID := Rec;
      sitem.Hash := FKeyParser.Hash;
      if TVKDBFNTX(FIndexes.Owner).OEM and ( CollationType <> cltNone ) then
        TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(Key), pAnsiChar(@sitem.key[0]), True, FNTXOrder.FHead.key_size)
      else
        Move(pAnsiChar(Key)^, sitem.key, FNTXOrder.FHead.key_size);
      Sorter.AddItem(sitem);
    end;
  end;

  procedure CreateEmptyIndex;
  var
    IndAttr: TIndexAttributes;
  begin
    if not FReindex then begin
      DefineBag;
      FNTXBag.NTXHandler.CreateProxyStream;
      if not FNTXBag.NTXHandler.IsOpen then begin
        raise Exception.Create('TVKNTXIndex.CreateIndexUsingSorter1: Create error "' + Name + '"');
      end else begin
        FNTXBuffers.Clear;
        if FClipperVer in [v500, v501] then
          FNTXOrder.FHead.sign := 6
        else
          FNTXOrder.FHead.sign := 7;
        FNTXOrder.FHead.version := 1;
        FNTXOrder.FHead.root := NTX_PAGE;
        FNTXOrder.FHead.next_page := 0;

        if Assigned(OnCreateIndex) then begin
          OnCreateIndex(self, IndAttr);
          FNTXOrder.FHead.key_size := IndAttr.key_size;
          FNTXOrder.FHead.key_dec := IndAttr.key_dec;
          System.Move(pAnsiChar(IndAttr.key_expr)^, FNTXOrder.FHead.key_expr, Length(IndAttr.key_expr));
          FNTXOrder.FHead.key_expr[Length(IndAttr.key_expr)] := #0;
          System.Move(pAnsiChar(IndAttr.for_expr)^, FNTXOrder.FHead.for_expr, Length(IndAttr.for_expr));
          FNTXOrder.FHead.for_expr[Length(IndAttr.for_expr)] := #0;
        end else begin
          FNTXOrder.FHead.key_size := Length(FKeyParser.Key);
          FNTXOrder.FHead.key_dec := FKeyParser.Prec;
          System.Move(pAnsiChar(FKeyExpresion)^, FNTXOrder.FHead.key_expr, Length(FKeyExpresion));
          FNTXOrder.FHead.key_expr[Length(FKeyExpresion)] := #0;
          System.Move(pAnsiChar(FForExpresion)^, FNTXOrder.FHead.for_expr, Length(FForExpresion));
          FNTXOrder.FHead.for_expr[Length(FForExpresion)] := #0;
        end;

        FNTXOrder.FHead.item_size := FNTXOrder.FHead.key_size + 8;
        FNTXOrder.FHead.max_item := (NTX_PAGE - FNTXOrder.FHead.item_size - 4) div (FNTXOrder.FHead.item_size + 2);
        FNTXOrder.FHead.half_page := FNTXOrder.FHead.max_item div 2;
        FNTXOrder.FHead.max_item := FNTXOrder.FHead.half_page * 2;

        FNTXOrder.FHead.reserv1 := #0;
        FNTXOrder.FHead.reserv3 := #0;

        Order := FOrder;
        Desc := FDesc;
        Unique := FUnique;

        FNTXBuffers.Flt := LimitPages.LimitPagesType;
        case FNTXBuffers.Flt of
          lbtAuto:
            begin
              FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
              LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
              LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
            end;
          lbtLimited:
            begin
              FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
          lbtUnlimited:
            begin
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
        end;
        FAllowSetCollationType := True;
        try
          CollationType := Collation.CollationType;
        finally
          FAllowSetCollationType := False;
        end;
        CustomCollatingSequence := Collation.CustomCollatingSequence;

        FNTXBag.NTXHandler.Seek(0, 0);
        FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
        FLastOffset := SizeOf(NTX_HEADER);
        GetFreePage;
      end;
    end else begin
      //Truncate ntx file
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.SetEndOfFile;
      FNTXBuffers.Clear;
      if FClipperVer in [v500, v501] then
        FNTXOrder.FHead.sign := 6
      else
        FNTXOrder.FHead.sign := 7;
      FNTXOrder.FHead.version := 1;
      FNTXOrder.FHead.root := NTX_PAGE;
      FNTXOrder.FHead.next_page := 0;
      FNTXOrder.FHead.reserv1 := #0;
      FNTXOrder.FHead.reserv3 := #0;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Flt := LimitPages.LimitPagesType;
      case FNTXBuffers.Flt of
        lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
      end;
      FAllowSetCollationType := True;
      try
        CollationType := Collation.CollationType;
      finally
        FAllowSetCollationType := False;
      end;
      CustomCollatingSequence := Collation.CustomCollatingSequence;
      FLastOffset := SizeOf(NTX_HEADER);
      GetFreePage;
    end;
  end;

begin
  Sorter := nil;
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FGetHashFromSortItem := True;
    FCreateIndexProc:= true;
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    LastFUpdated := FUpdated;
    FUpdated := true;
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      CreateEmptyIndex;
      if FHashTypeForTreeSorters = httsDefault then begin
        HashTableSize := htst256;
        GetHashCodeMethod := nil;
      end else begin
        HashTableSize := THashTableSizeType(Integer(FHashTypeForTreeSorters) - 1);
        GetHashCodeMethod := GetVKHashCode;
      end;
      Sorter := SorterClass.Create( oB.Header.last_rec,
                                    FNTXOrder.FHead.key_size,
                                    IndexSortProc,
                                    IndexSortAnsiCharsProc,
                                    nil,
                                    Unique,
                                    HashTableSize,
                                    GetHashCodeMethod,
                                    TMaxBitsInHashCode(MaxBitsInHashCode),
                                    False);
      if Sorter = nil then Exception.Create('TVKNTXIndex.CreateIndexUsingSorter1: Sorter object is null!');
      try
        RecPareBuf := oB.BufferSize div oB.Header.rec_size;
        if RecPareBuf >= 1 then begin
          ReadSize := RecPareBuf * oB.Header.rec_size;
          oB.Handle.Seek(oB.Header.data_offset, 0);
          Rec := 0;
          repeat
            RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
            BufCnt := RealRead div oB.Header.rec_size;
            for i := 0 to BufCnt - 1 do begin
              oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
              if oB.Crypt.Active then
                oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
              Inc(Rec);
              Key := EvaluteKeyExpr;
              //
              AddKeyInSorter(Key, Rec);
              //
            end;
          until ( BufCnt <= 0 );
          //
          Sorter.Sort;
          //

          ///////////
          if not Sorter.FirstSortItem then begin
            repeat
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              ntxitem.page := 0;
              ntxitem.rec_no := SortItem.RID;
              if oB.OEM and ( CollationType <> cltNone ) then
                Move(SortItem.key, ntxitem.key, FNTXOrder.FHead.key_size)
              else
                TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(@SortItem.key[0]), pAnsiChar(@ntxitem.key[0]), True, FNTXOrder.FHead.key_size);
              ntxitem.key[FNTXOrder.FHead.key_size] := #0;
              AddItem(@ntxitem, True);
            until Sorter.NextSortItem;
          end;
          ///////////

          //
          Sorter.Clear;
          //
        end else Exception.Create('TVKNTXIndex.CreateIndexUsingSorter1: Record size too lage');
      finally
        FreeAndNil(Sorter);
      end;
    finally
      Flush;
      FUpdated := LastFUpdated;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Clear;
      FCreateIndexProc:= false;
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
    end;
    if IsOpen then begin
      if  ( ( ( oB.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
          ( ( oB.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
          StartUpdate;
      InternalFirst;
      KeyExpresion := FNTXOrder.FHead.key_expr;
      ForExpresion := FNTXOrder.FHead.for_expr;
      if ForExpresion <> '' then
        FForExists := true;
      if Activate then Active := true;
    end;
  end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingSorter1: Create index only on active DataSet');
end;
*)

procedure TVKNTXIndex.CreateIndexUsingSorter(
  SorterClass: TVKSorterClass; Activate: boolean);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  Key: AnsiString;
  Rec: DWORD;
  FNtxHead: NTX_HEADER;
  cIndex: TVKNTXCompactIndex;
  Sorter: TVKSorterAbstract;
  TmpHandler: TProxyStream;
  sitem: SORT_ITEM;
  ntxitem: NTX_ITEM;
  HashTableSize: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  SortItem: PSORT_ITEM;

  procedure AddKeyInSorter(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      sitem.RID := Rec;
      sitem.Hash := FKeyParser.Hash;
      if TVKDBFNTX(FIndexes.Owner).OEM and ( CollationType <> cltNone ) then
        TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(Key), pAnsiChar(@sitem.key[0]), True, FNtxHead.key_size)
      else
        Move(pAnsiChar(Key)^, sitem.key, FNtxHead.key_size);
      Sorter.AddItem(sitem);
    end;
  end;

  procedure FillNtxHeader;
  var
    i: Integer;
    IndAttr: TIndexAttributes;
  begin
    DefineBag;
    if FClipperVer in [v500, v501] then
      FNtxHead.sign := 6
    else
      FNtxHead.sign := 7;
    FNtxHead.version := 0;
    FNtxHead.root := NTX_PAGE;
    FNtxHead.next_page := 0;

    if Assigned(OnCreateIndex) then begin
      OnCreateIndex(self, IndAttr);
      FNtxHead.key_size := IndAttr.key_size;
      FNtxHead.key_dec := IndAttr.key_dec;
      System.Move(pAnsiChar(IndAttr.key_expr)^, FNtxHead.key_expr, Length(IndAttr.key_expr));
      FNtxHead.key_expr[Length(IndAttr.key_expr)] := #0;
      System.Move(pAnsiChar(IndAttr.for_expr)^, FNtxHead.for_expr, Length(IndAttr.for_expr));
      FNtxHead.for_expr[Length(IndAttr.for_expr)] := #0;
    end else begin
      FNtxHead.key_size := Length(FKeyParser.Key);
      FNtxHead.key_dec := FKeyParser.Prec;
      System.Move(pAnsiChar(FKeyExpresion)^, FNtxHead.key_expr, Length(FKeyExpresion));
      FNtxHead.key_expr[Length(FKeyExpresion)] := #0;
      System.Move(pAnsiChar(FForExpresion)^, FNtxHead.for_expr, Length(FForExpresion));
      FNtxHead.for_expr[Length(FForExpresion)] := #0;
    end;

    FNtxHead.item_size := FNtxHead.key_size + 8;
    FNtxHead.max_item := (NTX_PAGE - FNtxHead.item_size - 4) div (FNtxHead.item_size + 2);
    FNtxHead.half_page := FNtxHead.max_item div 2;
    FNtxHead.max_item := FNtxHead.half_page * 2;
    if Unique then
      FNtxHead.unique := #1
    else
      FNtxHead.unique := #0;
    FNtxHead.reserv1 := #0;
    if Desc then
      FNtxHead.desc := #1
    else
      FNtxHead.desc := #0;
    FNtxHead.reserv3 := #0;
    for i := 0 to 7 do FNtxHead.order[i] := FNTXOrder.FHead.Order[i];
    //
    FNTXOrder.FHead := FNtxHead;
    //
    FAllowSetCollationType := True;
    try
      CollationType := Collation.CollationType;
    finally
      FAllowSetCollationType := False;
    end;
    CustomCollatingSequence := Collation.CustomCollatingSequence;
    //
  end;

begin
  Sorter := nil;
  TmpHandler := nil;
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FGetHashFromSortItem := True;
    cIndex := TVKNTXCompactIndex.Create(LimitPages.PagesPerBuffer);
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      FillNtxHeader;
      if FHashTypeForTreeSorters = httsDefault then begin
        HashTableSize := htst256;
        GetHashCodeMethod := nil;
      end else begin
        HashTableSize := THashTableSizeType(Integer(FHashTypeForTreeSorters) - 1);
        GetHashCodeMethod := GetVKHashCode;
      end;
      if SorterClass.InheritsFrom(TVKOuterSorter) then begin
        TmpHandler := TProxyStream.Create;
        if OuterSorterProperties.TmpPath = '' then
          TmpHandler.FileName := GetTmpFileName
        else
          TmpHandler.FileName := GetTmpFileName(OuterSorterProperties.TmpPath);
        TmpHandler.AccessMode.AccessMode := 66;
        TmpHandler.ProxyStreamType := pstFile;
        TmpHandler.CreateProxyStream;
      end;
      Sorter := SorterClass.Create( oB.Header.last_rec,
                                    FNtxHead.key_size,
                                    IndexSortProc,
                                    IndexSortCharsProc,
                                    nil,
                                    Unique,
                                    HashTableSize,
                                    GetHashCodeMethod,
                                    TMaxBitsInHashCode(MaxBitsInHashCode),
                                    False,
                                    TmpHandler,
                                    OuterSorterProperties.InnerSorterClass,
                                    OuterSorterProperties.BufferSize,
                                    OuterSorterProperties.SortItemPerInnerSorter);
      if Sorter = nil then Exception.Create('TVKNTXIndex.CreateIndexUsingSorter: Sorter object is null!');
      try
        RecPareBuf := oB.BufferSize div oB.Header.rec_size;
        if RecPareBuf >= 1 then begin
          ReadSize := RecPareBuf * oB.Header.rec_size;
          oB.Handle.Seek(oB.Header.data_offset, 0);
          Rec := 0;
          repeat
            RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
            BufCnt := RealRead div oB.Header.rec_size;
            for i := 0 to pred(BufCnt) do begin
              oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
              if oB.Crypt.Active then
                oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
              Inc(Rec);
              Key := EvaluteKeyExpr;
              //
              AddKeyInSorter(Key, Rec);
              //
            end;
          until ( BufCnt <= 0 );

          // Sort sorter object
          Sorter.Sort;
          //

          //
          cIndex.FileName := FNTXFileName;
          cIndex.Crypt := oB.Crypt.Active;
          cIndex.OwnerTable := oB;
          if FNTXBag.NTXHandler.ProxyStreamType <> pstFile then
            cIndex.Handler := FNTXBag.NTXHandler;
          cIndex.CreateEmptyIndex(FNtxHead);

          ///////////
          if not Sorter.FirstSortItem then begin
            repeat
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              ntxitem.page := 0;
              ntxitem.rec_no := SortItem.RID;
              if oB.OEM and ( CollationType <> cltNone ) then
                Move(SortItem.key, ntxitem.key, FNTXOrder.FHead.key_size)
              else
                TVKDBFNTX(FIndexes.Owner).TranslateBuff(pAnsiChar(@SortItem.key[0]), pAnsiChar(@ntxitem.key[0]), True, FNtxHead.key_size);
              ntxitem.key[FNTXOrder.FHead.key_size] := #0;
              cIndex.AddItem(@ntxitem);
            until Sorter.NextSortItem;
          end;
          ///////////

          //
          cIndex.Close;
          //

          //
        end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingSorter: Record size too lage');
        if TmpHandler <> nil then begin
          TmpHandler.Close;
          DeleteFile(TmpHandler.FileName);
        end;
      finally
        FreeAndNil(Sorter);
        FreeAndNil(TmpHandler);
      end;
    finally
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
      cIndex.Free;
    end;
    Open;
    if IsOpen and Activate then Active := true;
  end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingSorter: Create index only on active DataSet');
end;

(*
procedure TVKNTXIndex.CreateIndexUsingMergeBinaryTreeAndBTree(
  TreeSorterClass: TVKBinaryTreeSorterClass;
  Activate: boolean = True;
  PreSorterBlockSize: LongWord = 65536);
type
  TJoinTreesResult = (jtrUndefined, jtrMergeCompleted, jtrAddItemNeeded, jtrReturnToPreviosLevel);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  pKey: pAnsiChar;
  Key: AnsiString;
  Rec: DWORD;
  LastFUpdated: boolean;
  Sorter: TVKBinaryTreeSorterAbstract;
  SorterRecCount: DWord;
  sitem: SORT_ITEM;
  ntxitem: NTX_ITEM;
  AddOk: boolean;
  HashTableSize: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  NextSortItemPoint{, SortItemPoint}: DWord;
  SortItem: PSORT_ITEM;

  function MergeTreesInternal(CurrentPageOffset: DWord; ParentNode: TVKNTXNode; PreviousItem: pNTX_ITEM = nil; PreviousItemNo: Word = Word(-1)): TJoinTreesResult;
  var
    CurrentNodePage: pNTX_BUFFER;
    CurrentNode: TVKNTXNode;
    SiblingNodePage: pNTX_BUFFER;
    SiblingNode: TVKNTXNode;
    c, i, j: Integer;
    Item, Item1, SiblingItem: pNTX_ITEM;
    Item2: NTX_ITEM;
    IsLeaf , IsRoot, IsAddInSibling: boolean;
    swap_value: Word;

    function TrySiblings: TJoinTreesResult;
    var
      j: Integer;
    begin
      Result := jtrUndefined;
      //Check right and left sibling node for ability to add items into them
      //The right node is the first
      IsAddInSibling := False;
      if    ( ParentNode <> nil )
        and ( PreviousItem <> nil )
        and ( PreviousItemNo <> Word(-1) )
        and ( PreviousItemNo < ParentNode.PNode.count { note: item parent.ref[count] always exist } ) then begin
        SiblingItem := pNTX_ITEM(pAnsiChar(ParentNode.PNode) + ParentNode.PNode.ref[Succ(PreviousItemNo)]);
        SiblingNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, SiblingItem.page, SiblingNodePage);
        try
          //
          if SiblingNodePage.count < FNTXOrder.FHead.max_item then begin

            Item1 := pNTX_ITEM(pAnsiChar(CurrentNode.PNode) + CurrentNode.PNode.ref[Pred(CurrentNode.PNode.count)]);

            //Save infomation from Previouse (parent) Item in Item2
            Move(PreviousItem.key, Item2.key, FNTXOrder.FHead.key_size);
            Item2.rec_no := PreviousItem.rec_no;

            //Copy Item1 to Previouse (parent) Item
            Move(Item1.key, PreviousItem.key, FNTXOrder.FHead.key_size);
            PreviousItem.rec_no := Item1.rec_no;

            ParentNode.Changed := True;

            //Add Item2 in SiblingNode in first position

            // shift ref array
            for j := SiblingNodePage.count downto 0 do begin
              swap_value := SiblingNodePage.ref[succ(j)];
              SiblingNodePage.ref[succ(j)] := SiblingNodePage.ref[j];
              SiblingNodePage.ref[j] := swap_value;
            end;

            Item := pNTX_ITEM(pAnsiChar(SiblingNodePage) + SiblingNodePage.ref[0]);

            // Save Item2 to Item
            Move(Item2.key, Item.key, FNTXOrder.FHead.key_size);
            Item.rec_no := Item2.rec_no;
            Item.page := 0;

            Inc(SiblingNodePage.count);
            SiblingNode.Changed := True;

            Dec(CurrentNodePage.count);
            CurrentNode.Changed := True;

            //Insert SortItem to the current page

            // shift ref array
            for j := CurrentNodePage.count downto i do begin
              swap_value := CurrentNodePage.ref[succ(j)];
              CurrentNodePage.ref[succ(j)] := CurrentNodePage.ref[j];
              CurrentNodePage.ref[j] := swap_value;
            end;

            Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);

            // Save SortItem to Item
            Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
            Item.rec_no := SortItem.RID;
            Item.page := 0;

            Inc(CurrentNodePage.count);
            CurrentNode.Changed := True;

            //Get next SORT_ITEM
            //Save SortItemPoint as NextSortItemPoint
            NextSortItemPoint := Sorter.CurrentItem; // SortItemPoint;
            if Sorter.NextSortItem then // is there more SortItems?
              Result := jtrMergeCompleted;
            //Delete previous item from binary tree
            Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
            //
            if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

            //SortItem := Sorter.PSortItem[Sorter.SortArray[SortItemPoint]];
            SortItem := Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];

            IsAddInSibling := True;

          end;
          //
        finally
          FNTXBuffers.FreeNTXBuffer(SiblingNode.FNTXBuffer);
        end;
      end;
      //The left node is the second
      if    ( not IsAddInSibling )
        and ( ParentNode <> nil )
        and ( PreviousItem <> nil )
        and ( PreviousItemNo <> Word(-1) )
        and ( PreviousItemNo > 0 ) then begin
        SiblingItem := pNTX_ITEM(pAnsiChar(ParentNode.pNode) + ParentNode.PNode.ref[Pred(PreviousItemNo)]);
        SiblingNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, SiblingItem.page, SiblingNodePage);
        try
          //
          if SiblingNodePage.count < FNTXOrder.FHead.max_item then begin
            if i > 0 then begin

              Item1 := pNTX_ITEM(pAnsiChar(CurrentNode.PNode) + CurrentNode.PNode.ref[0]);

              //Save infomation from SiblingItem (parent) Item in Item2
              Move(SiblingItem.key, Item2.key, FNTXOrder.FHead.key_size);
              Item2.rec_no := SiblingItem.rec_no;

              //Copy Item1 to Previouse (parent) Item
              Move(Item1.key, SiblingItem.key, FNTXOrder.FHead.key_size);
              SiblingItem.rec_no := Item1.rec_no;

              ParentNode.Changed := True;

              //Add Item2 in SiblingNode in end position

              // shift ref array for Sibling
              for j := SiblingNodePage.count downto SiblingNodePage.count do begin
                swap_value := SiblingNodePage.ref[succ(j)];
                SiblingNodePage.ref[succ(j)] := SiblingNodePage.ref[j];
                SiblingNodePage.ref[j] := swap_value;
              end;

              Item := pNTX_ITEM(pAnsiChar(SiblingNodePage) + SiblingNodePage.ref[SiblingNodePage.count]);

              // Save Item2 to Item
              Move(Item2.key, Item.key, FNTXOrder.FHead.key_size);
              Item.rec_no := Item2.rec_no;
              Item.page := 0;

              Inc(SiblingNodePage.count);
              SiblingNode.Changed := True;

              // shift ref array for Current
              for j := 0 to Pred(CurrentNodePage.count) do begin
                swap_value := CurrentNodePage.ref[j];
                CurrentNodePage.ref[j] := CurrentNodePage.ref[succ(j)];
                CurrentNodePage.ref[succ(j)] := swap_value;
              end;
              Dec(CurrentNodePage.count);
              CurrentNode.Changed := True;

              Dec(i);

              //Insert SortItem to the current page

              // shift ref array
              for j := CurrentNodePage.count downto i do begin
                swap_value := CurrentNodePage.ref[succ(j)];
                CurrentNodePage.ref[succ(j)] := CurrentNodePage.ref[j];
                CurrentNodePage.ref[j] := swap_value;
              end;

              Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);

              // Save SortItem to Item
              Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
              Item.rec_no := SortItem.RID;
              Item.page := 0;

              Inc(CurrentNodePage.count);
              CurrentNode.Changed := True;

              //Get next SORT_ITEM
              //Save SortItemPoint as NextSortItemPoint
              NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
              if Sorter.NextSortItem then // is there more SortItems?
                Result := jtrMergeCompleted;
              //Delete previous item from binary tree
              Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
              //
              if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

              //SortItem := Sorter.PSortItem[Sorter.SortArray[SortItemPoint]];
              SortItem := Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];

              IsAddInSibling := True;

            end else begin
              IsAddInSibling := False;
            end;
          end;
          //
        finally
          FNTXBuffers.FreeNTXBuffer(SiblingNode.FNTXBuffer);
        end;
      end;
      if    ( not IsAddInSibling ) then begin
        Result := jtrAddItemNeeded;
        Exit;
      end;

    end;

    function TrySiblingsForEnd: TJoinTreesResult;
    var
      j: Integer;
    begin
      Result := jtrUndefined;
      //Check right and left sibling node for ability to add items into them
      //The right node is the first
      IsAddInSibling := False;
      if    ( ParentNode <> nil )
        and ( PreviousItem <> nil )
        and ( PreviousItemNo <> Word(-1) )
        and ( PreviousItemNo < ParentNode.PNode.count { note: item parent.ref[count] always exist } ) then begin
        SiblingItem := pNTX_ITEM(pAnsiChar(ParentNode.PNode) + ParentNode.PNode.ref[Succ(PreviousItemNo)]);
        SiblingNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, SiblingItem.page, SiblingNodePage);
        try
          //
          if SiblingNodePage.count < FNTXOrder.FHead.max_item then begin

            //Save infomation from Previouse (parent) Item in Item2
            Move(PreviousItem.key, Item2.key, FNTXOrder.FHead.key_size);
            Item2.rec_no := PreviousItem.rec_no;

            //Copy SortItem to Previouse (parent) Item
            Move(SortItem.key, PreviousItem.key, FNTXOrder.FHead.key_size);
            PreviousItem.rec_no := SortItem.RID;

            ParentNode.Changed := True;

            //Add Item2 in SiblingNode in first position

            // shift ref array
            for j := SiblingNodePage.count downto 0 do begin
              swap_value := SiblingNodePage.ref[succ(j)];
              SiblingNodePage.ref[succ(j)] := SiblingNodePage.ref[j];
              SiblingNodePage.ref[j] := swap_value;
            end;

            Item := pNTX_ITEM(pAnsiChar(SiblingNodePage) + SiblingNodePage.ref[0]);

            // Save Item2 to Item
            Move(Item2.key, Item.key, FNTXOrder.FHead.key_size);
            Item.rec_no := Item2.rec_no;
            Item.page := 0;

            Inc(SiblingNodePage.count);
            SiblingNode.Changed := True;

            //Get next SORT_ITEM
            //Save SortItemPoint as NextSortItemPoint
            NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
            if Sorter.NextSortItem then // is there more SortItems?
              Result := jtrMergeCompleted;
            //Delete previous item from binary tree
            Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
            //
            if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

            //SortItem := Sorter.PSortItem[Sorter.SortArray[SortItemPoint]];
            SortItem := Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];

            IsAddInSibling := True;

          end;
          //
        finally
          FNTXBuffers.FreeNTXBuffer(SiblingNode.FNTXBuffer);
        end;
      end;
      //The left node is the second
      if    ( not IsAddInSibling )
        and ( ParentNode <> nil )
        and ( PreviousItem <> nil )
        and ( PreviousItemNo <> Word(-1) )
        and ( PreviousItemNo > 0 ) then begin
        SiblingItem := pNTX_ITEM(pAnsiChar(ParentNode.pNode) + ParentNode.PNode.ref[Pred(PreviousItemNo)]);
        SiblingNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, SiblingItem.page, SiblingNodePage);
        try
          //
          if SiblingNodePage.count < FNTXOrder.FHead.max_item then begin

              Item1 := pNTX_ITEM(pAnsiChar(CurrentNode.PNode) + CurrentNode.PNode.ref[0]);

              //Save infomation from SiblingItem (parent) Item in Item2
              Move(SiblingItem.key, Item2.key, FNTXOrder.FHead.key_size);
              Item2.rec_no := SiblingItem.rec_no;

              //Copy Item1 to Previouse (parent) Item
              Move(Item1.key, SiblingItem.key, FNTXOrder.FHead.key_size);
              SiblingItem.rec_no := Item1.rec_no;

              ParentNode.Changed := True;

              //Add Item2 in SiblingNode in end position

              // shift ref array for Sibling
              for j := SiblingNodePage.count downto SiblingNodePage.count do begin
                swap_value := SiblingNodePage.ref[succ(j)];
                SiblingNodePage.ref[succ(j)] := SiblingNodePage.ref[j];
                SiblingNodePage.ref[j] := swap_value;
              end;

              Item := pNTX_ITEM(pAnsiChar(SiblingNodePage) + SiblingNodePage.ref[SiblingNodePage.count]);

              // Save Item2 to Item
              Move(Item2.key, Item.key, FNTXOrder.FHead.key_size);
              Item.rec_no := Item2.rec_no;
              Item.page := 0;

              Inc(SiblingNodePage.count);
              SiblingNode.Changed := True;

              // shift ref array for Current
              for j := 0 to Pred(CurrentNodePage.count) do begin
                swap_value := CurrentNodePage.ref[j];
                CurrentNodePage.ref[j] := CurrentNodePage.ref[succ(j)];
                CurrentNodePage.ref[succ(j)] := swap_value;
              end;
              Dec(CurrentNodePage.count);
              CurrentNode.Changed := True;

              Dec(i);

              //Insert SortItem to the current page at end position

              // shift ref array
              for j := CurrentNodePage.count downto CurrentNodePage.count do begin
                swap_value := CurrentNodePage.ref[succ(j)];
                CurrentNodePage.ref[succ(j)] := CurrentNodePage.ref[j];
                CurrentNodePage.ref[j] := swap_value;
              end;

              Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);

              // Save SortItem to Item
              Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
              Item.rec_no := SortItem.RID;
              Item.page := 0;

              Inc(CurrentNodePage.count);
              CurrentNode.Changed := True;

              //Get next SORT_ITEM
              //Save SortItemPoint as NextSortItemPoint
              NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
              if Sorter.NextSortItem then // is there more SortItems?
                Result := jtrMergeCompleted;
              //Delete previous item from binary tree
              Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
              //
              if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

              //SortItem := Sorter.PSortItem[Sorter.SortArray[SortItemPoint]];
              SortItem := Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];

              IsAddInSibling := True;

          end;
          //
        finally
          FNTXBuffers.FreeNTXBuffer(SiblingNode.FNTXBuffer);
        end;
      end;

      if    ( not IsAddInSibling ) then begin
        Result := jtrAddItemNeeded;
        Exit;
      end;

    end;

  begin
    Result := jtrUndefined;
    IsRoot := ( ParentNode = nil );
    IsLeaf := False;
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, CurrentPageOffset, CurrentNodePage);
    try
      //
      if CurrentNodePage.count > 0 then begin

        i := 0;
        while i < CurrentNodePage.count do begin

          Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);

          c := CmpKeys1(pAnsiChar(@SortItem.key[0]), Item.key, FNTXOrder.FHead.key_size);

          if c > 0 then begin //Item.key > SortItem

            if ( Item.page <> 0 ) then begin
              Result := MergeTreesInternal(Item.page, CurrentNode, Item, i);
              if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;
              c := CmpKeys1(pAnsiChar(@SortItem.key[0]), Item.key, FNTXOrder.FHead.key_size);
              IsLeaf := False;
            end else
              IsLeaf := True;

            if c > 0 then begin

              if IsLeaf then begin

                if ( CurrentNodePage.count < FNTXOrder.FHead.max_item ) then begin

                  // shift ref array
                  for j := CurrentNodePage.count downto i do begin
                    swap_value := CurrentNodePage.ref[succ(j)];
                    CurrentNodePage.ref[succ(j)] := CurrentNodePage.ref[j];
                    CurrentNodePage.ref[j] := swap_value;
                  end;

                  Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);

                  // Save SortItem to Item
                  Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
                  Item.rec_no := SortItem.RID;
                  Item.page := 0;

                  Inc(CurrentNodePage.count);

                  CurrentNode.Changed := True;

                  //Get next SORT_ITEM
                  //Save SortItemPoint as NextSortItemPoint
                  NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
                  if Sorter.NextSortItem then // is there more SortItems?
                    Result := jtrMergeCompleted;
                  //Delete previous item from binary tree
                  Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
                  //
                  if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

                  //SortItem := Sorter.PSortItem[Sorter.SortArray[SortItemPoint]];
                  SortItem := Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];

                end else begin

                  Result := TrySiblings;
                  if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

                end;

              end else begin

                Result := jtrAddItemNeeded;
                Exit;

                // This is code is real work, but not efficient.
                {
                //
                //Prepare sitem for add to binary tree (culculate hash)
                sitem.RID := Item.rec_no;
                Move(Item.key, sitem.key, FNTXOrder.FHead.key_size);
                TransKey(pAnsiChar(@sitem.key[0]), FNTXOrder.FHead.key_size, false);
                try
                  FGetHashFromSortItem := False;
                  GetVKHashCode(self, @sitem, sitem.Hash);
                finally
                  FGetHashFromSortItem := True;
                end;
                TransKey(pAnsiChar(@sitem.key[0]), FNTXOrder.FHead.key_size, true);
                sitem.key[FNTXOrder.FHead.key_size] := 0;

                // Save SortItem to Item
                Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
                Item.rec_no := SortItem.RID;

                CurrentNode.Changed := True;

                //Add in binary tree new item (sitem)
                Sorter.SortItem[NextSortItemPoint] := sitem;
                Sorter.AddItemInTreeByEntry(NextSortItemPoint);
                //Save SortItemPoint as NextSortItemPoint
                NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
                //Get next SORT_ITEM (it may be recently added item)
                if Sorter.NextSortItem then // is there eof
                  Result := jtrMergeCompleted;
                //Delete previous item from binary tree
                Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
                //
                if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;
                Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];
                Inc(i);
                }

              end;

            end else
              Inc(i);

          end else
            Inc(i);

        end;

        //
        c := 0;
        if IsLeaf then begin
          while True do begin
            if IsRoot then
              c := 1
            else begin
              if PreviousItem <> nil then
                c := CmpKeys1(pAnsiChar(@SortItem.key[0]), PreviousItem.key, FNTXOrder.FHead.key_size)
              else
                Break;
            end;
            if ( CurrentNodePage.count < FNTXOrder.FHead.max_item ) then begin
              if c > 0 then begin //PreviousItem.key > SortItem

                // shift ref array
                i := CurrentNodePage.count;
                for j := CurrentNodePage.count downto i do begin
                  swap_value := CurrentNodePage.ref[succ(j)];
                  CurrentNodePage.ref[succ(j)] := CurrentNodePage.ref[j];
                  CurrentNodePage.ref[j] := swap_value;
                end;

                Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);

                // Save SortItem to Item
                Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
                Item.rec_no := SortItem.RID;
                Item.page := 0;

                Inc(CurrentNodePage.count);

                CurrentNode.Changed := True;

                //Save SortItemPoint as NextSortItemPoint
                NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
                //Get next SORT_ITEM (it may be recently added item)
                if Sorter.NextSortItem then // is there more SortItems?
                  Result := jtrMergeCompleted;
                //Delete previous item from binary tree
                Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
                //
                if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

                //SortItem := Sorter.PSortItem[Sorter.SortArray[SortItemPoint]];
                SortItem := Sorter.CurrentSortItem; //Sorter.PSortItem[SortItemPoint];

              end else
                Break;
            end else begin
              if c > 0 then begin //PreviousItem.key > SortItem

                Result := TrySiblingsForEnd;
                if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

              end else
                Break;
            end;
          end;
        end;
        //

      end;

      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if ( Item.page <> 0 ) then
        Result := MergeTreesInternal(Item.page, CurrentNode, nil, CurrentNodePage.count);

      if Result in [jtrMergeCompleted, jtrAddItemNeeded] then Exit;

      Result := jtrReturnToPreviosLevel;

      //
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  function JoinTreesInternal: boolean;
  var
    jtr: TJoinTreesResult;
  begin
    repeat
      jtr := MergeTreesInternal(FNTXOrder.FHead.root, nil, nil, Word(-1));
      case jtr of
        jtrMergeCompleted, jtrReturnToPreviosLevel:
          begin
            Result := True;
            Exit;
          end;
        jtrAddItemNeeded:
          begin
            ntxitem.page := 0;
            ntxitem.rec_no := SortItem.RID;
            pKey := pAnsiChar(@SortItem.key[0]);
            Move(pKey^, ntxitem.key, FNTXOrder.FHead.key_size);
            AddItem(@ntxitem);

            //Save SortItemPoint as NextSortItemPoint
            NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
            //Get next SORT_ITEM (it may be recently added item)
            if not Sorter.NextSortItem then // is there eof
            begin
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              //Delete previous item from binary tree
              Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
            end else begin
              Result := True;
              //In anyway delete previous item from binary tree
              Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
              Exit;
            end;
            //
          end;
      end;
    until False;
  end;

  procedure AddKeyInSorter(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      sitem.RID := Rec;
      sitem.Hash := FKeyParser.Hash;
      Move(pAnsiChar(Key)^, sitem.key, FNTXOrder.FHead.key_size);
      sitem.key[FNTXOrder.FHead.key_size] := 0;
      TransKey(pAnsiChar(@sitem.key[0]));
      Sorter.AddItem(sitem);
    end;
  end;

  procedure CreateEmptyIndex;
  var
    IndAttr: TIndexAttributes;
  begin
    if not FReindex then begin
      DefineBag;
      FNTXBag.NTXHandler.CreateProxyStream;
      if not FNTXBag.NTXHandler.IsOpen then begin
        raise Exception.Create('TVKNTXIndex.CreateIndexUsingMergeBinaryTreeAndBTree: Create error "' + Name + '"');
      end else begin
        FNTXBuffers.Clear;
        if FClipperVer in [v500, v501] then
          FNTXOrder.FHead.sign := 6
        else
          FNTXOrder.FHead.sign := 7;
        FNTXOrder.FHead.version := 1;
        FNTXOrder.FHead.root := NTX_PAGE;
        FNTXOrder.FHead.next_page := 0;

        if Assigned(OnCreateIndex) then begin
          OnCreateIndex(self, IndAttr);
          FNTXOrder.FHead.key_size := IndAttr.key_size;
          FNTXOrder.FHead.key_dec := IndAttr.key_dec;
          System.Move(pAnsiChar(IndAttr.key_expr)^, FNTXOrder.FHead.key_expr, Length(IndAttr.key_expr));
          FNTXOrder.FHead.key_expr[Length(IndAttr.key_expr)] := #0;
          System.Move(pAnsiChar(IndAttr.for_expr)^, FNTXOrder.FHead.for_expr, Length(IndAttr.for_expr));
          FNTXOrder.FHead.for_expr[Length(IndAttr.for_expr)] := #0;
        end else begin
          FNTXOrder.FHead.key_size := Length(FKeyParser.Key);
          FNTXOrder.FHead.key_dec := FKeyParser.Prec;
          System.Move(pAnsiChar(FKeyExpresion)^, FNTXOrder.FHead.key_expr, Length(FKeyExpresion));
          FNTXOrder.FHead.key_expr[Length(FKeyExpresion)] := #0;
          System.Move(pAnsiChar(FForExpresion)^, FNTXOrder.FHead.for_expr, Length(FForExpresion));
          FNTXOrder.FHead.for_expr[Length(FForExpresion)] := #0;
        end;

        FNTXOrder.FHead.item_size := FNTXOrder.FHead.key_size + 8;
        FNTXOrder.FHead.max_item := (NTX_PAGE - FNTXOrder.FHead.item_size - 4) div (FNTXOrder.FHead.item_size + 2);
        FNTXOrder.FHead.half_page := FNTXOrder.FHead.max_item div 2;
        FNTXOrder.FHead.max_item := FNTXOrder.FHead.half_page * 2;

        FNTXOrder.FHead.reserv1 := #0;
        FNTXOrder.FHead.reserv3 := #0;

        Order := FOrder;
        Desc := FDesc;
        Unique := FUnique;

        FNTXBuffers.Flt := LimitPages.LimitPagesType;
        case FNTXBuffers.Flt of
          lbtAuto:
            begin
              FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
              LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
              LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
            end;
          lbtLimited:
            begin
              FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
          lbtUnlimited:
            begin
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
        end;
        FAllowSetCollationType := True;
        try
          CollationType := Collation.CollationType;
        finally
          FAllowSetCollationType := False;
        end;
        CustomCollatingSequence := Collation.CustomCollatingSequence;

        FNTXBag.NTXHandler.Seek(0, 0);
        FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
        FLastOffset := SizeOf(NTX_HEADER);
        GetFreePage;
      end;
    end else begin
      //Truncate ntx file
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.SetEndOfFile;
      FNTXBuffers.Clear;
      if FClipperVer in [v500, v501] then
        FNTXOrder.FHead.sign := 6
      else
        FNTXOrder.FHead.sign := 7;
      FNTXOrder.FHead.version := 1;
      FNTXOrder.FHead.root := NTX_PAGE;
      FNTXOrder.FHead.next_page := 0;
      FNTXOrder.FHead.reserv1 := #0;
      FNTXOrder.FHead.reserv3 := #0;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Flt := LimitPages.LimitPagesType;
      case FNTXBuffers.Flt of
        lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
      end;
      FAllowSetCollationType := True;
      try
        CollationType := Collation.CollationType;
      finally
        FAllowSetCollationType := False;
      end;
      CustomCollatingSequence := Collation.CustomCollatingSequence;
      FLastOffset := SizeOf(NTX_HEADER);
      GetFreePage;
    end;
  end;

begin
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FGetHashFromSortItem := True;
    FCreateIndexProc:= true;
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    LastFUpdated := FUpdated;
    FUpdated := true;
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      CreateEmptyIndex;

      if FHashTypeForTreeSorters = httsDefault then begin
        HashTableSize := htst256;
        GetHashCodeMethod := nil;
      end else begin
        HashTableSize := THashTableSizeType(Integer(FHashTypeForTreeSorters) - 1);
        GetHashCodeMethod := GetVKHashCode;
      end;

      //
      SorterRecCount := ( PreSorterBlockSize ) div ( FNTXOrder.FHead.key_size + ( 2 * SizeOf(DWord) ) );
      //

      if TreeSorterClass = TVKBinaryTreeSorter then
        Sorter := TVKBinaryTreeSorter.Create(  SorterRecCount,
                                                  FNTXOrder.FHead.key_size,
                                                  IndexSortProc,
                                                  nil, nil,
                                                  Unique,
                                                  HashTableSize,
                                                  GetHashCodeMethod,
                                                  TMaxBitsInHashCode(MaxBitsInHashCode),
                                                  True);
      if TreeSorterClass = TVKRedBlackTreeSorter then
        Sorter := TVKRedBlackTreeSorter.Create(  SorterRecCount,
                                                    FNTXOrder.FHead.key_size,
                                                    IndexSortProc,
                                                    nil, nil,
                                                    Unique,
                                                    HashTableSize,
                                                    GetHashCodeMethod,
                                                    TMaxBitsInHashCode(MaxBitsInHashCode),
                                                    True);
      if TreeSorterClass = TVKAVLTreeSorter then
        Sorter := TVKAVLTreeSorter.Create(  SorterRecCount,
                                               FNTXOrder.FHead.key_size,
                                               IndexSortProc,
                                               nil, nil,
                                               Unique,
                                               HashTableSize,
                                               GetHashCodeMethod,
                                               TMaxBitsInHashCode(MaxBitsInHashCode),
                                               True);
      if Sorter = nil then raise Exception.Create('TVKNTXIndex.CreateIndexUsingMergeBinaryTreeAndBTree: Sorter object is null!');
      try
        RecPareBuf := oB.BufferSize div oB.Header.rec_size;
        if RecPareBuf >= 1 then begin
          ReadSize := RecPareBuf * oB.Header.rec_size;
          oB.Handle.Seek(oB.Header.data_offset, 0);
          Rec := 0;
          repeat
            RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
            BufCnt := RealRead div oB.Header.rec_size;
            for i := 0 to BufCnt - 1 do begin
              oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
              if oB.Crypt.Active then
                oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
              Inc(Rec);
              Key := EvaluteKeyExpr;
              //
              AddKeyInSorter(Key, Rec);
              //
              if  Sorter.CountAddedItems = Pred(Sorter.CountRecords) then begin
                //
                //DONE: Join trees!
                //
                //
                NextSortItemPoint := Sorter.CountAddedItems;
                if not Sorter.FirstSortItem then begin
                  SortItem := Sorter.CurrentSortItem; // PSortItem[SortItemPoint];
                  JoinTreesInternal;
                end;

                if not Sorter.FirstSortItem then begin
                  repeat
                    SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
                    //
                    ntxitem.page := 0;
                    ntxitem.rec_no := SortItem.RID;
                    pKey := pAnsiChar(@SortItem.key[0]);
                    Move(pKey^, ntxitem.key, FNTXOrder.FHead.key_size);
                    ntxitem.key[FNTXOrder.FHead.key_size] := #0;
                    SetString(Key, pAnsiChar(@ntxitem.key[0]), FNTXOrder.FHead.key_size);
                    TransKey(pAnsiChar(Key), FNTXOrder.FHead.key_size, False);
                    AddOk := true;
                    if Unique then
                      AddOk := AddOk and (not SeekFirstInternal(Key));
                    if AddOk then
                      AddItem(@ntxitem, True);
                    //
                  until Sorter.NextSortItem;
                end;

                //
                Sorter.Clear;
              end;
              //
            end;
          until ( BufCnt <= 0 );
          //
          if Sorter.CountAddedItems > 0 then begin
            //
            //DONE: Join trees!
            //
            //
            NextSortItemPoint := Sorter.CountAddedItems;
            if not Sorter.FirstSortItem then begin
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              JoinTreesInternal;
            end;
            //
            if not Sorter.FirstSortItem then begin
              repeat
                SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
                //
                ntxitem.page := 0;
                ntxitem.rec_no := SortItem.RID;
                pKey := pAnsiChar(@SortItem.key[0]);
                Move(pKey^, ntxitem.key, FNTXOrder.FHead.key_size);
                ntxitem.key[FNTXOrder.FHead.key_size] := #0;
                SetString(Key, pAnsiChar(@ntxitem.key[0]), FNTXOrder.FHead.key_size);
                TransKey(pAnsiChar(Key), FNTXOrder.FHead.key_size, False);
                AddOk := true;
                if Unique then
                  AddOk := AddOk and (not SeekFirstInternal(Key));
                if AddOk then
                  AddItem(@ntxitem, True);
                //
              until Sorter.NextSortItem;
            end;
            //
            Sorter.Clear;
          end;
          //
        end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingMergeBinaryTreeAndBTree: Record size too lage');
      finally
        FreeAndNil(Sorter);
      end;
    finally
      Flush;
      FUpdated := LastFUpdated;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Clear;
      FCreateIndexProc:= false;
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
    end;
    if IsOpen then begin
      if  ( ( ( oB.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
          ( ( oB.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
          StartUpdate;
      InternalFirst;
      KeyExpresion := FNTXOrder.FHead.key_expr;
      ForExpresion := FNTXOrder.FHead.for_expr;
      if ForExpresion <> '' then
        FForExists := true;
      if Activate then Active := true;
    end;
  end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingMergeBinaryTreeAndBTree: Create index only on active DataSet');
end;
*)

(*
procedure TVKNTXIndex.CreateIndexUsingabsorption( TreeSorterClass: TVKBinaryTreeSorterClass;
                                                  Activate: boolean = true;
                                                  PreSorterBlockSize: LongWord = 65536);
type
  TMergeTreesResult = (mtrUndefined, mtrMergeCompleted, mtrAddItemNeeded, mtrReturnToPreviosLevel);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  Key: AnsiString;
  Rec: DWORD;
  LastFUpdated: boolean;
  ntxitem: NTX_ITEM;
  Sorter: TVKBinaryTreeSorterAbstract;
  SorterRecCount: DWord;
  HashTableSize: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  NextSortItemPoint {, SortItemPoint}: DWord;
  SortItem: PSORT_ITEM;
  sitem: SORT_ITEM;
  fb: boolean;
  c: Integer;

  procedure AddKeyInSorter(Key: pAnsiChar; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      sitem.RID := Rec;
      sitem.Hash := FKeyParser.Hash;
      Move(Key^, sitem.key, FNTXOrder.FHead.key_size);
      sitem.key[FNTXOrder.FHead.key_size] := 0;
      Sorter.AddItem(sitem);
    end;
  end;

  function WorkTraversal(CurrentPageOffset: DWord): boolean;
  var
    i, j: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    Item, LItem: pNTX_ITEM;
  begin
    Result := False;
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, CurrentPageOffset, CurrentNodePage);
    try
      LItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if LItem.rec_no = DWord(-1) then
        j := 0
      else
        j := Succ(LItem.rec_no);
      for i := 0 to Pred(CurrentNodePage.count) do begin
        Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
        if i < j then begin
          c := CmpKeys1(pAnsiChar(@SortItem.key[0]), Item.key, FNTXOrder.FHead.key_size);
          if c >= 0 then begin //Item.key >= SortItem
            if ( Item.page <> 0 ) then begin
              Result := WorkTraversal(Item.page);
              if Result then exit;
              c := CmpKeys1(pAnsiChar(@SortItem.key[0]), Item.key, FNTXOrder.FHead.key_size);
            end;
            if ( c = 0 ) and ( not Unique ) then c := 1;
            if c > 0 then begin
              //
              sitem.RID := Item.rec_no;
              Move(Item.key, sitem.key, FNTXOrder.FHead.key_size);
              TransKey(pAnsiChar(@sitem.key[0]), FNTXOrder.FHead.key_size, false);
              try
                FGetHashFromSortItem := False;
                GetVKHashCode(self, @sitem, sitem.Hash);
              finally
                FGetHashFromSortItem := True;
              end;
              TransKey(pAnsiChar(@sitem.key[0]), FNTXOrder.FHead.key_size, true);
              sitem.key[FNTXOrder.FHead.key_size] := 0;
              // Save SortItem to Item
              Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
              Item.rec_no := SortItem.RID;
              CurrentNode.Changed := True;
              //Add in binary tree new item (sitem)
              Sorter.SortItem[NextSortItemPoint] := sitem;
              Sorter.AddItemInTreeByEntry(NextSortItemPoint);
              //Save SortItemPoint as NextSortItemPoint
              NextSortItemPoint := Sorter.CurrentItem; //SortItemPoint;
              //Get next SORT_ITEM (it may be recently added item)
              Sorter.NextSortItem;
              //Delete previous item from binary tree
              Sorter.DeleteFromTreeByEntry(NextSortItemPoint);
              //
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              //
            end;
          end;
        end else begin
          if ( Item.page <> 0 ) then begin
            Result := WorkTraversal(Item.page);
            if Result then exit;
          end;
          if not fb then begin
            // Save SortItem to Item
            Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
            Item.rec_no := SortItem.RID;
            CurrentNode.Changed := True;
            //Get next SORT_ITEM
            if not Sorter.NextSortItem then begin
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
            end else begin
              Sorter.Clear;
              fb := True;
            end;
            //
            LItem.rec_no := i;
            CurrentNode.Changed := true;
            //
          end else begin
            if Sorter.CountAddedItems < Pred(Sorter.CountRecords) then
              AddKeyInSorter(Item.Key, Item.rec_no)
            else begin
              Result := True;
              Exit;
            end;
          end;
          //
        end;
      end;
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if ( Item.page <> 0 ) then begin
        Result := WorkTraversal(Item.page);
        if Result then exit;
      end;
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure MarkAllPagesAsNotHandled(CurrentPageOffset: DWord);
  var
    i: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    Item: pNTX_ITEM;
  begin
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, CurrentPageOffset, CurrentNodePage);
    try
      for i := 0 to Pred(CurrentNodePage.count) do begin
        Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
        if ( Item.page <> 0 ) then MarkAllPagesAsNotHandled(Item.page);
        if Sorter.CountAddedItems < Pred(Sorter.CountRecords) then AddKeyInSorter(Item.Key, Item.rec_no);
      end;
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if ( Item.page <> 0 ) then MarkAllPagesAsNotHandled(Item.page);
      //Save in last item (page.ref[count]) in rec_no field node def value ( -1 ) for use it field to store current position
      Item.rec_no := DWord(-1);
      CurrentNode.Changed := true;
      //
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure AddKeyInBTreeAtEnd(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      ntxitem.page := 0;
      ntxitem.rec_no := Rec;
      Move(pAnsiChar(Key)^, ntxitem.key, FNTXOrder.FHead.key_size);
      ntxitem.key[FNTXOrder.FHead.key_size] := #0;
      TransKey(pAnsiChar(@ntxitem.key[0]));
      if Unique then
        AddOk := AddOk and (not SeekFirstInternal(Key));
      if AddOk then
        AddItem(@ntxitem, True);
    end;
  end;

  procedure CreateEmptyIndex;
  var
    IndAttr: TIndexAttributes;
  begin
    if not FReindex then begin
      DefineBag;
      FNTXBag.NTXHandler.CreateProxyStream;
      if not FNTXBag.NTXHandler.IsOpen then begin
        raise Exception.Create('TVKNTXIndex.CreateIndexUsingMerge: Create error "' + Name + '"');
      end else begin
        FNTXBuffers.Clear;
        if FClipperVer in [v500, v501] then
          FNTXOrder.FHead.sign := 6
        else
          FNTXOrder.FHead.sign := 7;
        FNTXOrder.FHead.version := 1;
        FNTXOrder.FHead.root := NTX_PAGE;
        FNTXOrder.FHead.next_page := 0;

        if Assigned(OnCreateIndex) then begin
          OnCreateIndex(self, IndAttr);
          FNTXOrder.FHead.key_size := IndAttr.key_size;
          FNTXOrder.FHead.key_dec := IndAttr.key_dec;
          System.Move(pAnsiChar(IndAttr.key_expr)^, FNTXOrder.FHead.key_expr, Length(IndAttr.key_expr));
          FNTXOrder.FHead.key_expr[Length(IndAttr.key_expr)] := #0;
          System.Move(pAnsiChar(IndAttr.for_expr)^, FNTXOrder.FHead.for_expr, Length(IndAttr.for_expr));
          FNTXOrder.FHead.for_expr[Length(IndAttr.for_expr)] := #0;
        end else begin
          FNTXOrder.FHead.key_size := Length(FKeyParser.Key);
          FNTXOrder.FHead.key_dec := FKeyParser.Prec;
          System.Move(pAnsiChar(FKeyExpresion)^, FNTXOrder.FHead.key_expr, Length(FKeyExpresion));
          FNTXOrder.FHead.key_expr[Length(FKeyExpresion)] := #0;
          System.Move(pAnsiChar(FForExpresion)^, FNTXOrder.FHead.for_expr, Length(FForExpresion));
          FNTXOrder.FHead.for_expr[Length(FForExpresion)] := #0;
        end;

        FNTXOrder.FHead.item_size := FNTXOrder.FHead.key_size + 8;
        FNTXOrder.FHead.max_item := (NTX_PAGE - FNTXOrder.FHead.item_size - 4) div (FNTXOrder.FHead.item_size + 2);
        FNTXOrder.FHead.half_page := FNTXOrder.FHead.max_item div 2;
        FNTXOrder.FHead.max_item := FNTXOrder.FHead.half_page * 2;

        FNTXOrder.FHead.reserv1 := #0;
        FNTXOrder.FHead.reserv3 := #0;

        Order := FOrder;
        Desc := FDesc;
        Unique := FUnique;

        FNTXBuffers.Flt := LimitPages.LimitPagesType;
        case FNTXBuffers.Flt of
          lbtAuto:
            begin
              FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
              LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
              LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
            end;
          lbtLimited:
            begin
              FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
          lbtUnlimited:
            begin
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
        end;
        FAllowSetCollationType := True;
        try
          CollationType := Collation.CollationType;
        finally
          FAllowSetCollationType := False;
        end;
        CustomCollatingSequence := Collation.CustomCollatingSequence;

        FNTXBag.NTXHandler.Seek(0, 0);
        FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
        FLastOffset := SizeOf(NTX_HEADER);
        GetFreePage;
      end;
    end else begin
      //Truncate ntx file
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.SetEndOfFile;
      FNTXBuffers.Clear;
      if FClipperVer in [v500, v501] then
        FNTXOrder.FHead.sign := 6
      else
        FNTXOrder.FHead.sign := 7;
      FNTXOrder.FHead.version := 1;
      FNTXOrder.FHead.root := NTX_PAGE;
      FNTXOrder.FHead.next_page := 0;
      FNTXOrder.FHead.reserv1 := #0;
      FNTXOrder.FHead.reserv3 := #0;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Flt := LimitPages.LimitPagesType;
      case FNTXBuffers.Flt of
        lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
      end;
      FAllowSetCollationType := True;
      try
        CollationType := Collation.CollationType;
      finally
        FAllowSetCollationType := False;
      end;
      CustomCollatingSequence := Collation.CustomCollatingSequence;
      FLastOffset := SizeOf(NTX_HEADER);
      GetFreePage;
    end;
  end;

begin
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FCreateIndexProc:= true;
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    LastFUpdated := FUpdated;
    FUpdated := true;
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      CreateEmptyIndex;

      if FHashTypeForTreeSorters = httsDefault then begin
        HashTableSize := htst256;
        GetHashCodeMethod := nil;
      end else begin
        HashTableSize := THashTableSizeType(Integer(FHashTypeForTreeSorters) - 1);
        GetHashCodeMethod := GetVKHashCode;
      end;

      //
      SorterRecCount := ( PreSorterBlockSize ) div ( FNTXOrder.FHead.key_size + ( 2 * SizeOf(DWord) ) );
      //

      if TreeSorterClass = TVKBinaryTreeSorter then
        Sorter := TVKBinaryTreeSorter.Create(  SorterRecCount,
                                                  FNTXOrder.FHead.key_size,
                                                  IndexSortProc,
                                                  nil, nil,
                                                  Unique,
                                                  HashTableSize,
                                                  GetHashCodeMethod,
                                                  TMaxBitsInHashCode(MaxBitsInHashCode),
                                                  True);
      if TreeSorterClass = TVKRedBlackTreeSorter then
        Sorter := TVKRedBlackTreeSorter.Create(  SorterRecCount,
                                                    FNTXOrder.FHead.key_size,
                                                    IndexSortProc,
                                                    nil, nil,
                                                    Unique,
                                                    HashTableSize,
                                                    GetHashCodeMethod,
                                                    TMaxBitsInHashCode(MaxBitsInHashCode),
                                                    True);
      if TreeSorterClass = TVKAVLTreeSorter then
        Sorter := TVKAVLTreeSorter.Create(  SorterRecCount,
                                               FNTXOrder.FHead.key_size,
                                               IndexSortProc,
                                               nil, nil,
                                               Unique,
                                               HashTableSize,
                                               GetHashCodeMethod,
                                               TMaxBitsInHashCode(MaxBitsInHashCode),
                                               True);
      if Sorter = nil then raise Exception.Create('TVKNTXIndex.CreateIndexUsingMerge: Sorter object is null!');
      try
        RecPareBuf := oB.BufferSize div oB.Header.rec_size;
        if RecPareBuf >= 1 then begin
          // First of all create a not sorted B-Tree structure
          ReadSize := RecPareBuf * oB.Header.rec_size;
          oB.Handle.Seek(oB.Header.data_offset, 0);
          Rec := 0;
          repeat
            RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
            BufCnt := RealRead div oB.Header.rec_size;
            for i := 0 to BufCnt - 1 do begin
              oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
              if oB.Crypt.Active then
                oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
              Inc(Rec);
              Key := EvaluteKeyExpr;
              //
              AddKeyInBTreeAtEnd(Key, Rec);
              //
            end;
          until ( BufCnt <= 0 );
          //
          //Than mark all pages as not handled
          MarkAllPagesAsNotHandled(FNTXOrder.FHead.root);
          //
          //
          while True do begin
            NextSortItemPoint := Sorter.CountAddedItems;
            if not Sorter.FirstSortItem then begin
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              fb := False;
              WorkTraversal(FNTXOrder.FHead.root);
            end else
              Break;
          end;

          //
        end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingMerge: Record size too lage');
      finally
        FreeAndNil(Sorter);
      end;
    finally
      Flush;
      FUpdated := LastFUpdated;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Clear;
      FCreateIndexProc:= false;
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
    end;
    if IsOpen then begin
      if  ( ( ( oB.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
          ( ( oB.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
          StartUpdate;
      InternalFirst;
      KeyExpresion := FNTXOrder.FHead.key_expr;
      ForExpresion := FNTXOrder.FHead.for_expr;
      if ForExpresion <> '' then
        FForExists := true;
      if Activate then Active := true;
    end;
  end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingMerge: Create index only on active DataSet');
end;
*)

(*
procedure TVKNTXIndex.SortNtxNode(NtxNode: TVKNTXNode);
const
  TNILL = MAX_ITEMS_IN_PAGE;
var
  lson: array[0..TNILL] of WORD;
  rson: array[0..TNILL + 1] of WORD;
  ref: array[0..MAX_ITEMS_IN_PAGE] of WORD;
  root: Word;
  NtxPage: pNTX_BUFFER;
  i, j: Integer;

  function CompareItems(point, p: Word): Integer;
  var
    Ipoint, Ip: pNTX_ITEM;
  begin
    Ipoint := pNTX_ITEM(pAnsiChar(NtxPage) + NtxPage.ref[point]);
    Ip := pNTX_ITEM(pAnsiChar(NtxPage) + NtxPage.ref[p]);
    Result := CmpKeys1(Ipoint.key, Ip.key, FNTXOrder.FHead.key_size);
    if Result = 0 then begin
      if Ip.rec_no < Ipoint.rec_no then
        Result := -1
      else
        Result := 1;
    end;
  end;

  procedure InitTree;
  begin
    rson[Succ(TNILL)] := TNILL;
    lson[TNILL] := TNILL;
    rson[TNILL] := TNILL;
  end;

  procedure AddItemInTree(point: Word);
  var
    p: DWord;
    c: Integer;
  begin
    p := Succ(TNILL);
    c := 1;
    rson[point] := TNILL;
    lson[point] := TNILL;
    while true do begin
      if (c >= 0) then begin
        if (rson[p] <> TNILL) then begin
          p := rson[p];
        end else begin
          rson[p] := point;
          break;
        end;
      end else begin
        if (lson[p] <> TNILL) then begin
          p := lson[p];
        end else begin
          lson[p] := point;
          break;
        end;
      end;
      c := CompareItems(point, p);
    end;
  end;

  procedure TreeTraversal(root: Word);
  begin
    if lson[Root] <> TNILL then TreeTraversal(lson[Root]);
    ref[j] := NtxPage.ref[Root];
    Inc(j);
    if rson[Root] <> TNILL then TreeTraversal(rson[Root]);
  end;

begin
  NtxPage := NtxNode.PNode;
  InitTree;
  for i := 0 to Pred(NtxPage.count) do AddItemInTree(i);
  j := 0;
  root := rson[Succ(TNILL)];
  if root <> TNILL then TreeTraversal(root);
  if j <> 0 then begin
    for i := 0 to Pred(NtxPage.count) do NtxPage.ref[i] := ref[i];
    NtxNode.Changed := True;
  end;
end;
*)

(*
procedure TVKNTXIndex.CreateIndexUsingBTreeHeapSort(Activate: boolean = true);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  Key: AnsiString;
  Rec: DWORD;
  LastFUpdated: boolean;
  ntxitem, change_item: NTX_ITEM;
  HeapRootNode: TVKNTXNode;
  HeapRootNodePage: pNTX_BUFFER;
  LastItemInHeap: pNTX_ITEM;

  {
  function RestoreOrder(CurrentNode: TVKNTXBuffer): integer;
  var
    CurrentNodePage: pNTX_BUFFER;
    b, e, m, c, i, l: Integer;
    Item, MoveItem, LastItem: pNTX_ITEM;
    swap: Word;
  begin
    CurrentNodePage := CurrentNode.GetPage;
    LastItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
    //Result := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[Pred(CurrentNodePage.count)]);
    Result := -1;
    if ( LastItem.rec_no = DWord(-1) ) then
      b := 0
    else
      b := Succ(LastItem.rec_no);
    l := b;
    e := CurrentNodePage.count - 2;
    MoveItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[Pred(CurrentNodePage.count)]);
    repeat
      m := ( b + e ) shr 1;
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[m]);
      c := CmpKeys1(MoveItem.key, Item.key, FNTXOrder.FHead.key_size);
      if c = 0 then begin
        if Item.rec_no < MoveItem.rec_no then
          c := -1
        else
          c := 1;
      end;
      if c < 0 then begin //Item < MoveItem
        if e = m then
          break
        else
          e := m;
      end else begin
        if b = m then
          Inc(b)
        else
          b := m;
      end;
    until b > e;
    if c < 0 then
      e := e + 1
    else
      e := e + 2;
    for i := Pred(CurrentNodePage.count) downto e do begin
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
      MoveItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[Pred(i)]);
      //Result := MoveItem;
      if i <> l then begin
        swap := CurrentNodePage.ref[Pred(i)];
        CurrentNodePage.ref[Pred(i)] := CurrentNodePage.ref[i];
        CurrentNodePage.ref[i] := swap;
      end else begin
        change_item.rec_no := Item.rec_no;
        Move(Item.key, change_item.key, FNTXOrder.FHead.key_size);
        Item.rec_no := MoveItem.rec_no;
        Move(MoveItem.key, Item.key, FNTXOrder.FHead.key_size);
        MoveItem.rec_no := change_item.rec_no;
        Move(change_item.key, MoveItem.key, FNTXOrder.FHead.key_size);
        Result := l;
      end;
      CurrentNode.Changed := True;
    end;
  end;
  }

  procedure GetMinItem(CurrentNode: TVKNTXNode; var MinItem: pNTX_ITEM; var MinItemNo: Word; b: Integer);
  var
    CurrentNodePage: pNTX_BUFFER;
    e, c, i, j: Integer;
    Item1, Item2 {, LastItem } : pNTX_ITEM;
    q: array[0..MAX_ITEMS_IN_PAGE] of Word;
    q_Count: Integer;
  begin
    CurrentNodePage := CurrentNode.PNode;
    //LastItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
    //if ( LastItem.rec_no = DWord(-1) ) then
    //  b := 0
    //else
    //  b := Succ(LastItem.rec_no);
    e := Pred(CurrentNodePage.count);
    i := b;
    j := 0;
    while True do begin
      if i <= e then begin
        if (i + 1) <= e then begin
          Item1 := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
          Item2 := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[Succ(i)]);
          c := CmpKeys1(Item1.key, Item2.key, FNTXOrder.FHead.key_size);
          if c = 0 then begin
            if Item2.rec_no < Item1.rec_no then
              c := -1
            else
              c := 1;
          end;
          if c < 0 then begin //Item2 > Item1
            q[j] := Succ(i);
            Inc(j);
          end else begin
            q[j] := i;
            Inc(j);
          end;
        end else begin
          q[j] := i;
          Inc(j);
        end;
      end else
        break;
      Inc(i, 2);
    end;
    q_Count := j;

    while q_Count > 1 do begin
      i := 0;
      j := 0;
      while True do begin
        if i < q_Count then begin
          if (i + 1) < q_Count then begin
            Item1 := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[q[i]]);
            Item2 := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[q[Succ(i)]]);
            c := CmpKeys1(Item1.key, Item2.key, FNTXOrder.FHead.key_size);
            if c = 0 then begin
              if Item2.rec_no < Item1.rec_no then
                c := -1
              else
                c := 1;
            end;
            if c < 0 then begin //Item2 > Item1
              q[j] := q[Succ(i)];
              Inc(j);
            end else begin
              q[j] := q[i];
              Inc(j);
            end;
          end else begin
            q[j] := q[i];
            Inc(j);
          end;
        end else
          break;
        Inc(i, 2);
      end;
      q_Count := j;
    end;
    MinItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[q[0]]);
    MinItemNo := q[0];

  end;

  procedure siftItem( pageOffset: DWord;
                      itemForSift: pNTX_ITEM;
                      ParentNode: TVKNTXNode);
  var
    i: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    {Item,} LastItem, MinItem: pNTX_ITEM;
    c: Integer;
    MinItemNo: Word;
  begin
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, pageOffset, CurrentNodePage);
    try
      if CurrentNodePage.count > 0 then begin
        LastItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
        if ( LastItem.rec_no = DWord(-1) ) or ( LastItem.rec_no < CurrentNodePage.count ) then begin
          //
          if LastItem.rec_no = DWord(-1) then
            i := 0
          else begin
            if LastItem.rec_no < DWord(Pred(CurrentNodePage.count)) then
              i := Succ(LastItem.rec_no)
            else
              i := -1;
          end;
          if i >= 0 then begin
            GetMinItem(CurrentNode, MinItem, MinItemNo, i);
            //MinItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[Pred(CurrentNodePage.count)]);
            c := CmpKeys1(MinItem.key, itemForSift.key, FNTXOrder.FHead.key_size);
            if c = 0 then begin
              if itemForSift.rec_no < MinItem.rec_no then
                c := -1
              else
                c := 1;
            end;
            if c > 0 then begin //itemForSift > MinItem
              change_item.rec_no := itemForSift.rec_no;
              Move(itemForSift.key, change_item.key, FNTXOrder.FHead.key_size);
              itemForSift.rec_no := MinItem.rec_no;
              Move(MinItem.key, itemForSift.key, FNTXOrder.FHead.key_size);
              MinItem.rec_no := change_item.rec_no;
              Move(change_item.key, MinItem.key, FNTXOrder.FHead.key_size);
              CurrentNode.Changed := true;
              ParentNode.Changed := true;
              // and make a sift
              if ( MinItem.page <> 0 ) then siftItem(MinItem.page, MinItem, CurrentNode);
              if ( LastItem.page <> 0 ) then siftItem(LastItem.page, MinItem, CurrentNode);
              //
            end;
          end;
        end;
      end;
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure CreateHeapInternal(CurrentPageOffset: DWord; ParentNode: TVKNTXNode = nil; PreviousItem: pNTX_ITEM = nil);
  var
    i: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    Item, MinItem: pNTX_ITEM;
    c: Integer;
  begin
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, CurrentPageOffset, CurrentNodePage);
    try
      if CurrentNodePage.count > 0 then begin
        for i := 0 to Pred(CurrentNodePage.count) do begin
          Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
          if ( Item.page <> 0 ) then CreateHeapInternal(Item.page, CurrentNode, Item);
        end;
      end;
      SortNtxNode(CurrentNode);
      MinItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[Pred(CurrentNodePage.count)]);
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if ( Item.page <> 0 ) then
        CreateHeapInternal(Item.page, CurrentNode, MinItem);
      //Save in last item (page.ref[count]) in rec_no field node def value ( -1 ) for use it field to store current position
      Item.rec_no := DWord(-1);
      CurrentNode.Changed := true;
      //Change MinItem and PreviousItem (if need it)
      if PreviousItem <> nil then begin
        c := CmpKeys1(MinItem.key, PreviousItem.key, FNTXOrder.FHead.key_size);
        if c = 0 then begin
          if PreviousItem.rec_no < MinItem.rec_no then
            c := -1
          else
            c := 1;
        end;
        if c > 0 then begin //if PreviousItem > MinItem then make change
          change_item.rec_no := PreviousItem.rec_no;
          Move(PreviousItem.key, change_item.key, FNTXOrder.FHead.key_size);
          PreviousItem.rec_no := MinItem.rec_no;
          Move(MinItem.key, PreviousItem.key, FNTXOrder.FHead.key_size);
          MinItem.rec_no := change_item.rec_no;
          Move(change_item.key, MinItem.key, FNTXOrder.FHead.key_size);
          CurrentNode.Changed := true;
          ParentNode.Changed := true;
          // and make a sift
          if ( MinItem.page <> 0 ) then siftItem(MinItem.page, MinItem, CurrentNode);
          if ( Item.page <> 0 ) then siftItem(Item.page, MinItem, CurrentNode);
          //
        end;
      end;
      //

    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure SiftTraversalInternal(pageOffset: DWord);
  var
    i, j: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    Item, LastItem, MinItem {, ItemInHeap}: pNTX_ITEM;
    MinItemNo: Word;
    {c: Integer;}
  begin
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, pageOffset, CurrentNodePage);
    try
      LastItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      for i := 0 to Pred(CurrentNodePage.count) do begin
        Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
        if ( Item.page <> 0 ) then SiftTraversalInternal(Item.page);

        //
        //Write at last item curent position
        LastItem.rec_no := i;
        CurrentNode.Changed := true;
        //
        // Find minimum item in root of heap
        // First of all define j (j is begin of loop minimum finding)
        if ( HeapRootNode.NodeOffset = CurrentNode.NodeOffset ) then begin
          if LastItemInHeap.rec_no <> DWord(-1) then begin
            if LastItemInHeap.rec_no < HeapRootNodePage.count then begin
              j := LastItemInHeap.rec_no;
            end else begin
              j := -1;
            end;
          end else begin
           j := 0;
          end;
        end else begin
          if LastItemInHeap.rec_no <> DWord(-1) then begin
            if LastItemInHeap.rec_no < DWord(Pred(HeapRootNodePage.count)) then begin
              j := Succ(LastItemInHeap.rec_no);
            end else begin
              j := -1;
            end;
          end else begin
            j := 0;
          end;
        end;

        //
        if j >= 0 then begin
          //MinItem := pNTX_ITEM(pAnsiChar(HeapRootNodePage) + HeapRootNodePage.ref[Pred(HeapRootNodePage.count)]);
          //MinItemNo := Pred(HeapRootNodePage.count);
          GetMinItem(HeapRootNode, MinItem, MinItemNo, j
          );
          //
          //Change MinItem and current Item
          if  ( HeapRootNode.NodeOffset <> CurrentNode.NodeOffset )
              or ( ( HeapRootNode.NodeOffset = CurrentNode.NodeOffset )
                    and ( MinItemNo > i ) ) then begin
            change_item.rec_no := Item.rec_no;
            Move(Item.key, change_item.key, FNTXOrder.FHead.key_size);
            Item.rec_no := MinItem.rec_no;
            Move(MinItem.key, Item.key, FNTXOrder.FHead.key_size);
            MinItem.rec_no := change_item.rec_no;
            Move(change_item.key, MinItem.key, FNTXOrder.FHead.key_size);
            CurrentNode.Changed := true;
            HeapRootNode.Changed := true;
            // and make a sift
            if ( MinItem.page <> 0 ) then siftItem(MinItem.page, MinItem, HeapRootNode);
            if ( LastItemInHeap.page <> 0 ) then siftItem(LastItemInHeap.page, MinItem, HeapRootNode);
            //
          end;
        end;
        //
      end;
      //
      // Redefine HeapRootNode
      if ( HeapRootNode.NodeOffset = CurrentNode.NodeOffset ) then begin
        FNTXBuffers.FreeNTXBuffer(HeapRootNode.FNTXBuffer);
        HeapRootNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, LastItemInHeap.page, HeapRootNodePage);
        LastItemInHeap := pNTX_ITEM(pAnsiChar(HeapRootNodePage) + HeapRootNodePage.ref[HeapRootNodePage.count]);
      end;
      //
      LastItem.rec_no := CurrentNodePage.count;
      CurrentNode.Changed := true;
      //
      if ( LastItem.page <> 0 ) then SiftTraversalInternal(LastItem.page);
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure AddKeyInBTreeAtEnd(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      ntxitem.page := 0;
      ntxitem.rec_no := Rec;
      Move(pAnsiChar(Key)^, ntxitem.key, FNTXOrder.FHead.key_size);
      ntxitem.key[FNTXOrder.FHead.key_size] := #0;
      TransKey(pAnsiChar(@ntxitem.key[0]));
      if Unique then
        AddOk := AddOk and (not SeekFirstInternal(Key));
      if AddOk then
        AddItem(@ntxitem, True);
    end;
  end;

  procedure CreateEmptyIndex;
  var
    IndAttr: TIndexAttributes;
  begin
    if not FReindex then begin
      DefineBag;
      FNTXBag.NTXHandler.CreateProxyStream;
      if not FNTXBag.NTXHandler.IsOpen then begin
        raise Exception.Create('TVKNTXIndex.CreateIndexUsingBTreeHeapSort: Create error "' + Name + '"');
      end else begin
        FNTXBuffers.Clear;
        if FClipperVer in [v500, v501] then
          FNTXOrder.FHead.sign := 6
        else
          FNTXOrder.FHead.sign := 7;
        FNTXOrder.FHead.version := 1;
        FNTXOrder.FHead.root := NTX_PAGE;
        FNTXOrder.FHead.next_page := 0;

        if Assigned(OnCreateIndex) then begin
          OnCreateIndex(self, IndAttr);
          FNTXOrder.FHead.key_size := IndAttr.key_size;
          FNTXOrder.FHead.key_dec := IndAttr.key_dec;
          System.Move(pAnsiChar(IndAttr.key_expr)^, FNTXOrder.FHead.key_expr, Length(IndAttr.key_expr));
          FNTXOrder.FHead.key_expr[Length(IndAttr.key_expr)] := #0;
          System.Move(pAnsiChar(IndAttr.for_expr)^, FNTXOrder.FHead.for_expr, Length(IndAttr.for_expr));
          FNTXOrder.FHead.for_expr[Length(IndAttr.for_expr)] := #0;
        end else begin
          FNTXOrder.FHead.key_size := Length(FKeyParser.Key);
          FNTXOrder.FHead.key_dec := FKeyParser.Prec;
          System.Move(pAnsiChar(FKeyExpresion)^, FNTXOrder.FHead.key_expr, Length(FKeyExpresion));
          FNTXOrder.FHead.key_expr[Length(FKeyExpresion)] := #0;
          System.Move(pAnsiChar(FForExpresion)^, FNTXOrder.FHead.for_expr, Length(FForExpresion));
          FNTXOrder.FHead.for_expr[Length(FForExpresion)] := #0;
        end;

        FNTXOrder.FHead.item_size := FNTXOrder.FHead.key_size + 8;
        FNTXOrder.FHead.max_item := (NTX_PAGE - FNTXOrder.FHead.item_size - 4) div (FNTXOrder.FHead.item_size + 2);
        FNTXOrder.FHead.half_page := FNTXOrder.FHead.max_item div 2;
        FNTXOrder.FHead.max_item := FNTXOrder.FHead.half_page * 2;

        FNTXOrder.FHead.reserv1 := #0;
        FNTXOrder.FHead.reserv3 := #0;

        Order := FOrder;
        Desc := FDesc;
        Unique := FUnique;

        FNTXBuffers.Flt := LimitPages.LimitPagesType;
        case FNTXBuffers.Flt of
          lbtAuto:
            begin
              FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
              LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            end;
          lbtLimited:
            begin
              FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
          lbtUnlimited:
            begin
              FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            end;
        end;
        FAllowSetCollationType := True;
        try
          CollationType := Collation.CollationType;
        finally
          FAllowSetCollationType := False;
        end;
        CustomCollatingSequence := Collation.CustomCollatingSequence;

        FNTXBag.NTXHandler.Seek(0, 0);
        FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
        FLastOffset := SizeOf(NTX_HEADER);
        GetFreePage;
      end;
    end else begin
      //Truncate ntx file
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.SetEndOfFile;
      FNTXBuffers.Clear;
      if FClipperVer in [v500, v501] then
        FNTXOrder.FHead.sign := 6
      else
        FNTXOrder.FHead.sign := 7;
      FNTXOrder.FHead.version := 1;
      FNTXOrder.FHead.root := NTX_PAGE;
      FNTXOrder.FHead.next_page := 0;
      FNTXOrder.FHead.reserv1 := #0;
      FNTXOrder.FHead.reserv3 := #0;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Flt := LimitPages.LimitPagesType;
      case FNTXBuffers.Flt of
        lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
      end;
      FAllowSetCollationType := True;
      try
        CollationType := Collation.CollationType;
      finally
        FAllowSetCollationType := False;
      end;
      CustomCollatingSequence := Collation.CustomCollatingSequence;
      FLastOffset := SizeOf(NTX_HEADER);
      GetFreePage;
    end;
  end;

begin
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FCreateIndexProc:= true;
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    LastFUpdated := FUpdated;
    FUpdated := true;
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      CreateEmptyIndex;

      RecPareBuf := oB.BufferSize div oB.Header.rec_size;
      if RecPareBuf >= 1 then begin
        // First of all create a not sorted B-Tree structure
        ReadSize := RecPareBuf * oB.Header.rec_size;
        oB.Handle.Seek(oB.Header.data_offset, 0);
        Rec := 0;
        repeat
          RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
          BufCnt := RealRead div oB.Header.rec_size;
          for i := 0 to BufCnt - 1 do begin
            oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
            if oB.Crypt.Active then
              oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
            Inc(Rec);
            Key := EvaluteKeyExpr;
            //
            AddKeyInBTreeAtEnd(Key, Rec);
            //
          end;
        until ( BufCnt <= 0 );
        //
        //Than create a heap
        CreateHeapInternal(FNTXOrder.FHead.root, nil, nil);
        //
        //And at the end sift all items throw heap and create sorted B-Tree
        HeapRootNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, FNTXOrder.FHead.root, HeapRootNodePage);
        try
          LastItemInHeap := pNTX_ITEM(pAnsiChar(HeapRootNodePage) + HeapRootNodePage.ref[HeapRootNodePage.count]);
          SiftTraversalInternal(FNTXOrder.FHead.root);
        finally
          FNTXBuffers.FreeNTXBuffer(HeapRootNode.FNTXBuffer);
        end;

      end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingBTreeHeapSort: Record size too lage');
    finally
      Flush;
      FUpdated := LastFUpdated;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Clear;
      FCreateIndexProc:= false;
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
    end;
    if IsOpen then begin
      if  ( ( ( oB.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
          ( ( oB.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
          StartUpdate;
      InternalFirst;
      KeyExpresion := FNTXOrder.FHead.key_expr;
      ForExpresion := FNTXOrder.FHead.for_expr;
      if ForExpresion <> '' then
        FForExists := true;
      if Activate then Active := true;
    end;
  end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingBTreeHeapSort: Create index only on active DataSet');
end;
*)

(*
procedure TVKNTXIndex.CreateIndexUsingFindMinsAndJoinItToBTree( TreeSorterClass: TVKBinaryTreeSorterClass;
                                                                Activate: boolean = true;
                                                                PreSorterBlockSize: LongWord = 65536);
var
  oB: TVKDBFNTX;
  DBFBuffer: pAnsiChar;
  RecPareBuf: Integer;
  ReadSize, RealRead, BufCnt: Integer;
  i: Integer;
  Key: AnsiString;
  Rec: DWORD;
  LastFUpdated: boolean;
  ntxitem: NTX_ITEM;
  Sorter: TVKBinaryTreeSorterAbstract;
  SorterRecCount: DWord;
  HashTableSize: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  //SortItemPoint: DWord;
  SortItem: PSORT_ITEM;
  sitem: SORT_ITEM;
  r: boolean;
  fb: boolean;
  LastItemP: DWord;
  LastItem: PSORT_ITEM;
  c: Integer;

  procedure AddKeyInSorter(Key: pAnsiChar; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      sitem.RID := Rec;
      sitem.Hash := FKeyParser.Hash;
      Move(Key^, sitem.key, FNTXOrder.FHead.key_size);
      sitem.key[FNTXOrder.FHead.key_size] := 0;
      Sorter.AddItem(sitem);
    end;
  end;

  procedure AddOrReplaceSortItemInSorter(CurrentNode: TVKNTXNode; Item: pNTX_ITEM);
  begin
    if Sorter.CountAddedItems < Sorter.CountRecords then begin
      AddKeyInSorter(Item.Key, Item.rec_no);
    end else begin
      if Sorter.GetLastSortItem(LastItemP) then begin //if eof
        AddKeyInSorter(Item.Key, Item.rec_no);
      end else begin
        LastItem := Sorter.PSortItem[LastItemP];
        //Prepare sitem for add to binary tree (culculate hash)
        sitem.RID := Item.rec_no;
        Move(Item.key, sitem.key, FNTXOrder.FHead.key_size);
        TransKey(pAnsiChar(@sitem.key[0]), FNTXOrder.FHead.key_size, false);
        try
          FGetHashFromSortItem := False;
          GetVKHashCode(self, @sitem, sitem.Hash);
        finally
          FGetHashFromSortItem := True;
        end;
        TransKey(pAnsiChar(@sitem.key[0]), FNTXOrder.FHead.key_size, true);
        sitem.key[FNTXOrder.FHead.key_size] := 0;
        //
        Sorter.CompareItems(LastItem, @sitem, c);
        if c > 0 then begin //LastItem > sitem
          // Save LastItem to Item
          Move(LastItem.key, Item.key, FNTXOrder.FHead.key_size);
          Item.rec_no := LastItem.RID;
          CurrentNode.Changed := True;
          //
          Sorter.DeleteFromTreeByEntry(LastItemP);
          Sorter.SortItem[LastItemP] := sitem;
          Sorter.AddItemInTreeByEntry(LastItemP);
        end;
      end;
    end;
  end;

  procedure WorkTraversal(CurrentPageOffset: DWord);
  var
    i, j: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    Item, LItem: pNTX_ITEM;
  begin
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, CurrentPageOffset, CurrentNodePage);
    try
      LItem := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if LItem.rec_no = DWord(-1) then
        j := 0
      else
        j := Succ(LItem.rec_no);
      for i := j to Pred(CurrentNodePage.count) do begin
        Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
        if ( Item.page <> 0 ) then WorkTraversal(Item.page);
        //
        if not fb then begin
          //
          // Save SortItem to Item
          Move(SortItem.key, Item.key, FNTXOrder.FHead.key_size);
          Item.rec_no := SortItem.RID;
          LItem.rec_no := i;
          CurrentNode.Changed := True;
          //
          if not Sorter.NextSortItem then begin
            SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
          end else begin
            fb := True;
            Sorter.Clear;
          end;
        end else begin
          AddOrReplaceSortItemInSorter(CurrentNode, Item);
          r := False;
        end;
      end;
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if ( Item.page <> 0 ) then WorkTraversal(Item.page);
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure MarkAllPagesAsNotHandled(CurrentPageOffset: DWord);
  var
    i: Integer;
    CurrentNode: TVKNTXNode;
    CurrentNodePage: pNTX_BUFFER;
    Item: pNTX_ITEM;
  begin
    CurrentNode := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, CurrentPageOffset, CurrentNodePage);
    try
      for i := 0 to Pred(CurrentNodePage.count) do begin
        Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[i]);
        if ( Item.page <> 0 ) then MarkAllPagesAsNotHandled(Item.page);
        //
        AddOrReplaceSortItemInSorter(CurrentNode, Item);
        //
      end;
      Item := pNTX_ITEM(pAnsiChar(CurrentNodePage) + CurrentNodePage.ref[CurrentNodePage.count]);
      if ( Item.page <> 0 ) then
        MarkAllPagesAsNotHandled(Item.page);
      //Save in last item (page.ref[count]) in rec_no field node def value ( -1 ) for use it field to store current position
      Item.rec_no := DWord(-1);
      CurrentNode.Changed := true;
      //
    finally
      FNTXBuffers.FreeNTXBuffer(CurrentNode.FNTXBuffer);
    end;
  end;

  procedure AddKeyInBTreeAtEnd(Key: AnsiString; Rec: DWORD);
  var
    AddOk: boolean;
  begin
    AddOk := true;
    if FForExists then
      AddOk := AddOk and (FForParser.Execute);
    if AddOk then begin
      ntxitem.page := 0;
      ntxitem.rec_no := Rec;
      Move(pAnsiChar(Key)^, ntxitem.key, FNTXOrder.FHead.key_size);
      ntxitem.key[FNTXOrder.FHead.key_size] := #0;
      TransKey(pAnsiChar(@ntxitem.key[0]));
      if Unique then
        AddOk := AddOk and (not SeekFirstInternal(Key));
      if AddOk then
        AddItem(@ntxitem, True);
    end;
  end;

  procedure CreateEmptyIndex;
  var
    IndAttr: TIndexAttributes;
  begin
    if not FReindex then begin
      DefineBag;
      FNTXBag.NTXHandler.CreateProxyStream;
      if not FNTXBag.NTXHandler.IsOpen then begin
        raise Exception.Create('TVKNTXIndex.CreateIndexUsingFindMinsAndJoinItToBTree: Create error "' + Name + '"');
      end else begin
        FNTXBuffers.Clear;
        if FClipperVer in [v500, v501] then
          FNTXOrder.FHead.sign := 6
        else
          FNTXOrder.FHead.sign := 7;
        FNTXOrder.FHead.version := 1;
        FNTXOrder.FHead.root := NTX_PAGE;
        FNTXOrder.FHead.next_page := 0;

        if Assigned(OnCreateIndex) then begin
          OnCreateIndex(self, IndAttr);
          FNTXOrder.FHead.key_size := IndAttr.key_size;
          FNTXOrder.FHead.key_dec := IndAttr.key_dec;
          System.Move(pAnsiChar(IndAttr.key_expr)^, FNTXOrder.FHead.key_expr, Length(IndAttr.key_expr));
          FNTXOrder.FHead.key_expr[Length(IndAttr.key_expr)] := #0;
          System.Move(pAnsiChar(IndAttr.for_expr)^, FNTXOrder.FHead.for_expr, Length(IndAttr.for_expr));
          FNTXOrder.FHead.for_expr[Length(IndAttr.for_expr)] := #0;
        end else begin
          FNTXOrder.FHead.key_size := Length(FKeyParser.Key);
          FNTXOrder.FHead.key_dec := FKeyParser.Prec;
          System.Move(pAnsiChar(FKeyExpresion)^, FNTXOrder.FHead.key_expr, Length(FKeyExpresion));
          FNTXOrder.FHead.key_expr[Length(FKeyExpresion)] := #0;
          System.Move(pAnsiChar(FForExpresion)^, FNTXOrder.FHead.for_expr, Length(FForExpresion));
          FNTXOrder.FHead.for_expr[Length(FForExpresion)] := #0;
        end;

        FNTXOrder.FHead.item_size := FNTXOrder.FHead.key_size + 8;
        FNTXOrder.FHead.max_item := (NTX_PAGE - FNTXOrder.FHead.item_size - 4) div (FNTXOrder.FHead.item_size + 2);
        FNTXOrder.FHead.half_page := FNTXOrder.FHead.max_item div 2;
        FNTXOrder.FHead.max_item := FNTXOrder.FHead.half_page * 2;

        FNTXOrder.FHead.reserv1 := #0;
        FNTXOrder.FHead.reserv3 := #0;

        Order := FOrder;
        Desc := FDesc;
        Unique := FUnique;

        FNTXBuffers.Flt := LimitPages.LimitPagesType;
        case FNTXBuffers.Flt of
          lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        end;
        FAllowSetCollationType := True;
        try
          CollationType := Collation.CollationType;
        finally
          FAllowSetCollationType := False;
        end;
        CustomCollatingSequence := Collation.CustomCollatingSequence;

        FNTXBag.NTXHandler.Seek(0, 0);
        FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
        FLastOffset := SizeOf(NTX_HEADER);
        GetFreePage;
      end;
    end else begin
      //Truncate ntx file
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.SetEndOfFile;
      FNTXBuffers.Clear;
      if FClipperVer in [v500, v501] then
        FNTXOrder.FHead.sign := 6
      else
        FNTXOrder.FHead.sign := 7;
      FNTXOrder.FHead.version := 1;
      FNTXOrder.FHead.root := NTX_PAGE;
      FNTXOrder.FHead.next_page := 0;
      FNTXOrder.FHead.reserv1 := #0;
      FNTXOrder.FHead.reserv3 := #0;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Flt := LimitPages.LimitPagesType;
      case FNTXBuffers.Flt of
        lbtAuto:
          begin
            FNTXBuffers.MaxBuffers := Round( LogN(FNTXOrder.FHead.half_page + 1, oB.RecordCount + MAX_NTX_STOCK) ) * NTX_STOCK_INSURANCE;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
            LimitPages.LimitBuffers := FNTXBuffers.MaxBuffers;
            LimitPages.PagesPerBuffer := FNTXBuffers.PagesPerBuffer;
          end;
        lbtLimited:
          begin
            FNTXBuffers.MaxBuffers := LimitPages.LimitBuffers;
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
        lbtUnlimited:
          begin
            FNTXBuffers.PagesPerBuffer := LimitPages.PagesPerBuffer;
          end;
      end;
      FAllowSetCollationType := True;
      try
        CollationType := Collation.CollationType;
      finally
        FAllowSetCollationType := False;
      end;
      CustomCollatingSequence := Collation.CustomCollatingSequence;
      FLastOffset := SizeOf(NTX_HEADER);
      GetFreePage;
    end;
  end;

begin
  oB := TVKDBFNTX(FIndexes.Owner);
  if oB.Active then begin
    oB.IndState := true;
    FCreateIndexProc:= true;
    DBFBuffer := VKDBFMemMgr.oMem.GetMem(self, oB.BufferSize);
    LastFUpdated := FUpdated;
    FUpdated := true;
    try

      FillChar(DBFBuffer^, oB.BufferSize, ' ');
      oB.IndRecBuf := DBFBuffer;
      if FForExpresion <> '' then
        FForExists := true;
      EvaluteKeyExpr;
      CreateEmptyIndex;

      if FHashTypeForTreeSorters = httsDefault then begin
        HashTableSize := htst256;
        GetHashCodeMethod := nil;
      end else begin
        HashTableSize := THashTableSizeType(Integer(FHashTypeForTreeSorters) - 1);
        GetHashCodeMethod := GetVKHashCode;
      end;

      //
      SorterRecCount := ( PreSorterBlockSize ) div ( FNTXOrder.FHead.key_size + ( 2 * SizeOf(DWord) ) );
      //

      if TreeSorterClass = TVKBinaryTreeSorter then
        Sorter := TVKBinaryTreeSorter.Create(  SorterRecCount,
                                                  FNTXOrder.FHead.key_size,
                                                  IndexSortProc,
                                                  nil, nil,
                                                  Unique,
                                                  HashTableSize,
                                                  GetHashCodeMethod,
                                                  TMaxBitsInHashCode(MaxBitsInHashCode),
                                                  True);
      if TreeSorterClass = TVKRedBlackTreeSorter then
        Sorter := TVKRedBlackTreeSorter.Create(  SorterRecCount,
                                                    FNTXOrder.FHead.key_size,
                                                    IndexSortProc,
                                                    nil, nil,
                                                    Unique,
                                                    HashTableSize,
                                                    GetHashCodeMethod,
                                                    TMaxBitsInHashCode(MaxBitsInHashCode),
                                                    True);
      if TreeSorterClass = TVKAVLTreeSorter then
        Sorter := TVKAVLTreeSorter.Create(  SorterRecCount,
                                               FNTXOrder.FHead.key_size,
                                               IndexSortProc,
                                               nil, nil,
                                               Unique,
                                               HashTableSize,
                                               GetHashCodeMethod,
                                               TMaxBitsInHashCode(MaxBitsInHashCode),
                                               True);
      if Sorter = nil then Exception.Create('TVKNTXIndex.CreateIndexUsingFindMinsAndJoinItToBTree: Sorter object is null!');
      try
        RecPareBuf := oB.BufferSize div oB.Header.rec_size;
        if RecPareBuf >= 1 then begin
          // First of all create a not sorted B-Tree structure
          ReadSize := RecPareBuf * oB.Header.rec_size;
          oB.Handle.Seek(oB.Header.data_offset, 0);
          Rec := 0;
          repeat
            RealRead := oB.Handle.Read(DBFBuffer^, ReadSize);
            BufCnt := RealRead div oB.Header.rec_size;
            for i := 0 to BufCnt - 1 do begin
              oB.IndRecBuf := DBFBuffer + oB.Header.rec_size * i;
              if oB.Crypt.Active then
                oB.Crypt.Decrypt(Rec + 1, Pointer(oB.IndRecBuf), oB.Header.rec_size);
              Inc(Rec);
              Key := EvaluteKeyExpr;
              //
              AddKeyInBTreeAtEnd(Key, Rec);
              //
            end;
          until ( BufCnt <= 0 );
          //
          //Than mark all pages as not handled and in the same time accumulate in
          //Sorter all smallest items
          MarkAllPagesAsNotHandled(FNTXOrder.FHead.root);
          //
          //
          repeat
            if not Sorter.FirstSortItem then begin
              SortItem := Sorter.CurrentSortItem; //PSortItem[SortItemPoint];
              r := True;
              fb := False;
              WorkTraversal(FNTXOrder.FHead.root);
            end else
              r := False;
          until r;

          //
        end else Exception.Create('TVKNTXIndex.CreateIndexUsingFindMinsAndJoinItToBTree: Record size too lage');
      finally
        FreeAndNil(Sorter);
      end;
    finally
      Flush;
      FUpdated := LastFUpdated;
      FNTXBag.NTXHandler.Seek(0, 0);
      FNTXBag.NTXHandler.Write(FNTXOrder.FHead, SizeOf(NTX_HEADER));
      FNTXBuffers.Clear;
      FCreateIndexProc:= false;
      FGetHashFromSortItem := False;
      oB.IndState := false;
      oB.IndRecBuf := nil;
      VKDBFMemMgr.oMem.FreeMem(DBFBuffer);
    end;
    if IsOpen then begin
      if  ( ( ( oB.AccessMode.FLast and fmShareExclusive ) = fmShareExclusive ) or
          ( ( oB.AccessMode.FLast and fmShareDenyWrite ) = fmShareDenyWrite ) ) then
          StartUpdate;
      InternalFirst;
      KeyExpresion := FNTXOrder.FHead.key_expr;
      ForExpresion := FNTXOrder.FHead.for_expr;
      if ForExpresion <> '' then
        FForExists := true;
      if Activate then Active := true;
    end;
  end else raise Exception.Create('TVKNTXIndex.CreateIndexUsingFindMinsAndJoinItToBTree: Create index only on active DataSet');
end;
*)

procedure TVKNTXIndex.GetVKHashCode(Sender: TObject; Item: PSORT_ITEM;
  out HashCode: DWord);
var
  HashCodeArr: array[0..3] of Byte absolute HashCode;
  S: AnsiString;
  i64: Int64;
  key: array[0..pred(MAX_SORTER_KEY_SIZE)] of Byte;
  sign: boolean;
  Curr: Currency absolute i64;
  y, m, d: Word;
  q: DWord;

  procedure convert;
  var
    i: Integer;
  begin
    sign := False;
    if AnsiChar(Item.key[0]) in [',', '#', '$', '%', '&', '''', '(', ')', '*', '+'] then begin
      sign := True;
      for i := 0 to Pred(FNTXOrder.FHead.key_size) do
        key[i] := Byte(Ord(#92) - Ord(Item.key[i]));
    end else begin
      Move(Item.key, key, FNTXOrder.FHead.key_size);
    end;
    if FKeyParser.Prec <> 0 then
      key[FKeyParser.Len - FKeyParser.Prec] := Byte({$IFDEF DELPHIXE}FormatSettings.{$ENDIF}DecimalSeparator);
    SetString(S, pAnsiChar(@key[0]), FNTXOrder.FHead.key_size);
  end;

  procedure HashFromInt64(j64: Int64);
  var
    j64Rec: Int64Rec absolute j64;
  begin
    if j64 < 0 then begin
      j64 := - j64;
      if j64Rec.Hi <> 0 then begin
        j64Rec.Hi := 0;
        j64Rec.Lo := $80000000;
      end else begin
        j64 := - j64;
      end;
    end else begin
      if j64Rec.Hi <> 0 then begin
        j64Rec.Hi := 0;
        j64Rec.Lo := $7FFFFFFF;
      end;
    end;
    HashCode := j64Rec.Lo;
  end;

begin
  if FGetHashFromSortItem then
    HashCode := Item.Hash
  else begin
    case FKeyParser.ValueType of
      varCurrency:
        begin
          convert;
          Curr := StrToCurr(S);
          if sign then Curr := - Curr;
          HashFromInt64(i64);
        end;
      varDouble, varSingle:
        begin
          convert;
          i64 := Trunc(StrToFloat(S));
          if sign then i64 := - i64;
          HashFromInt64(i64);
        end;
      {$IFDEF DELPHI6}
      varShortInt,
      varByte,
      {$ENDIF}
      -1:
        begin
          convert;
          i64 := Word(StrToInt(S));
          if sign then i64 := - i64;
          HashFromInt64(i64);
        end;
      {$IFDEF DELPHI6}
      varWord,
      {$ENDIF}
      varSmallint:
        begin
          convert;
          i64 := Word(StrToInt(S));
          if sign then i64 := - i64;
          HashFromInt64(i64);
        end;
      {$IFDEF DELPHI6}
      varLongWord,
      {$ENDIF}
      varInteger:
        begin
          convert;
          i64 := DWord(StrToInt(S));
          if sign then i64 := - i64;
          HashFromInt64(i64);
        end;
      varBoolean:
        begin
          if AnsiChar(Item.key[0]) = 'T' then
            HashCode := $FFFFFFFF
          else
            HashCode := 0;
        end;
      varDate:
        begin
          SetString(S, pAnsiChar(@key[0]), 4);
          y := StrToInt(S);
          SetString(S, pAnsiChar(@key[4]), 2);
          m := StrToInt(S);
          SetString(S, pAnsiChar(@key[6]), 2);
          d := StrToInt(S);
          i64 := Trunc(EncodeDate(y, m, d));
          HashFromInt64(i64);
        end;
    else

      {$IFDEF DELPHI6}
      if (FKeyParser.ValueType = varInt64) then begin
      {$ELSE}
      if (FKeyParser.ValueType = 14) then begin
  		{$ENDIF}

        convert;
        i64 := StrToInt64(S);
        if sign then i64 := -i64;
        HashFromInt64(i64);
      end else begin

        q := Pred(FNTXOrder.FHead.key_size);
        if q > 3 then q := 3;

        //HashCode := ( Item.key[( q     ) and 3] shl 24 ) or
        //            ( Item.key[( q + 1 ) and 3] shl 16 ) or
        //            ( Item.key[( q + 2 ) and 3] shl 8  ) or
        //            ( Item.key[( q + 3 ) and 3]        );

        HashCodeArr[0] := Item.key[q and 3];
        Dec(q);
        HashCodeArr[1] := Item.key[q and 3];
        Dec(q);
        HashCodeArr[2] := Item.key[q and 3];
        Dec(q);
        HashCodeArr[3] := Item.key[q and 3];

      end;

    end;
  end;
end;

procedure TVKNTXIndex.SetRangeFields(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: variant);
var
  KeyLow, KeyHigh: AnsiString;
begin
  FKeyParser.PartualKeyValue := True;
  try
    KeyLow := FKeyParser.EvaluteKey(FieldList, FieldValuesLow);
    KeyHigh := FKeyParser.EvaluteKey(FieldList, FieldValuesHigh);
  finally
    FKeyParser.PartualKeyValue := False;
  end;
  NTXRange.LoKey := KeyLow;
  NTXRange.HiKey := KeyHigh;
  NTXRange.ReOpen;
end;

procedure TVKNTXIndex.SetRangeFields(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: array of const);
var
  FieldValLow, FieldValHigh: Variant;
begin
  ArrayOfConstant2Variant(FieldValuesLow, FieldValLow);
  ArrayOfConstant2Variant(FieldValuesHigh, FieldValHigh);
  SetRangeFields(FieldList, FieldValLow, FieldValHigh);
end;

function TVKNTXIndex.ReCrypt(pNewCrypt: TVKDBFCrypt): boolean;
var
  oW: TVKDBFNTX;
  buff: array [0..pred(NTX_PAGE)] of AnsiChar;
  r: Integer;
  offset: LongWord;
begin
  oW := TVKDBFNTX(FIndexes.Owner);
  if FLock then
    try
      Flush;
      FNTXBuffers.Clear;
      offset := NTX_PAGE;
      repeat
        FNTXBag.NTXHandler.Seek(offset, 0);
        r := FNTXBag.NTXHandler.Read(buff, NTX_PAGE);
        if r <> NTX_PAGE then begin
          Result := True;
          break;
        end;
        if oW.Crypt.Active then begin
          oW.Crypt.Decrypt(offset, @buff[0], NTX_PAGE);
          pNewCrypt.Encrypt(offset, @buff[0], NTX_PAGE);
        end;
        FNTXBag.NTXHandler.Seek(offset, 0);
        FNTXBag.NTXHandler.Write(buff, NTX_PAGE);
        Inc(offset, NTX_PAGE);
      until False;
      Result := True;
    finally
      FUnLock;
    end
  else
    Result := false;
end;

procedure TVKNTXIndex.VerifyIndex;
var
  level: Integer;
  predItem: pNTX_ITEM;
  ItemCount: DWORD;
  PageCount: DWORD;
  PageCountBySize: DWORD;
  key: AnsiString;

  function cmp(item1, item2: pNTX_ITEM): Integer;
  begin
    Result := CmpKeys1(item1.key, item2.key);
    if Result = 0 then begin
      if item1.rec_no < item2.rec_no then
        Result := 1
      else
        Result := -1;
    end;
  end;

  function keyToStr(item: pNTX_ITEM): AnsiString;
  var
    keyArr: array[0..NTX_PAGE-1] of AnsiChar;
    destKeyArr: array[0..NTX_PAGE-1] of AnsiChar;
    kSize: WORD;
  begin
    kSize := FNTXOrder.FHead.key_size;
    if FKeyTranslate then begin
      Move(item.key, keyArr, kSize);
      keyArr[kSize] := #0;
      TVKDBFNTX(FIndexes.Owner).Translate(keyArr, destKeyArr, false);
      Result := AnsiString(destKeyArr);
    end else begin
      Move(item.key, keyArr, kSize);
      keyArr[kSize] := #0;
      Result := AnsiString(keyArr);
    end;
  end;

  procedure VerifyPageRef(item: pNTX_ITEM; isLeaf: Boolean);
  begin
    if isLeaf then begin
      if item.page <> 0 then
        raise Exception.Create('TVKNTXIndex.VerifyIndex: item.page must be null on the leaf node item!');
    end else begin
      if item.page = 0 then
        raise Exception.Create('TVKNTXIndex.VerifyIndex: item.page must be not null on the not leaf node item!');
    end;
  end;

  procedure PassFreeList(page_off: DWORD);
  var
    ntxb: TVKNTXNode;
    page: pNTX_BUFFER;
    nextFree: DWORD;
  begin
    if page_off <> 0 then begin
      nextFree := 0;
      ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
      try
        if page.count <> 0 then
          raise Exception.Create('TVKNTXIndex.VerifyIndex: page count for free page must be 0!');
        Inc(PageCount);
        nextFree := pNTX_ITEM(pAnsiChar(page) + page.ref[0]).page;
      finally
        FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
      end;
      PassFreeList(nextFree);
    end;
  end;

  procedure Pass(page_off: DWORD);
  var
    page: pNTX_BUFFER;
    item: pNTX_ITEM;
    ntxb: TVKNTXNode;
    i: Integer;
    isLeaf: Boolean;
  begin
    Inc(level);
    try
      ntxb := FNTXBuffers.GetNTXBuffer(FNTXBag.NTXHandler, page_off, page);
      Inc(PageCount);
      try
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[0]);
        isLeaf := (item.page = 0);
        for i := 0 to Pred(page.count) do begin
          item := pNTX_ITEM(pAnsiChar(page) + page.ref[i]);
          if ( item.page <> 0 ) then begin
            Pass(item.page);
          end;
          //check page ref
          VerifyPageRef(item, isLeaf);
          //check item order
          if predItem <> nil then begin
            if cmp(predItem, item) <= 0 then
              raise Exception.Create('TVKNTXIndex.VerifyIndex: Key ' + keyToStr(item) + ' must be lager then ' + keyToStr(predItem));
          end;
          Inc(ItemCount);
          predItem := item;
          //check item key
          TVKDBFNTX(FIndexes.Owner).SetTmpRecord(item.rec_no);
          try
            key := EvaluteKeyExpr;
          finally
            TVKDBFNTX(FIndexes.Owner).CloseTmpRecord;
          end;
          if CmpKeys2(pAnsiChar(key), item.key, FNTXOrder.FHead.key_size) <> 0 then
            raise Exception.Create('TVKNTXIndex.VerifyIndex: For recNo = ' + IntToStr(item.rec_no) + ' key must be ' + key + ' , but was ' + keyToStr(item));
          //
        end;
        item := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
        if ( item.page <> 0 ) then begin
          Pass(item.page);
        end;
        //check page ref
        VerifyPageRef(item, isLeaf);
        //check item count per page
        if ((level > 1) and (page.count < FNTXOrder.FHead.half_page)) then
            raise Exception.Create('TVKNTXIndex.VerifyIndex: For page = ' + IntToStr(page_off) + ' item count (' + IntToStr(page.count) + ') less then half_page count (' + IntToStr(FNTXOrder.FHead.half_page) + ')');
      finally
        FNTXBuffers.FreeNTXBuffer(ntxb.FNTXBuffer);
      end;
    finally
      Dec(level);
    end;
  end;

begin

  if FLock then begin
    try
      Flush;
      FNTXBuffers.Clear;
      level := 0;
      ItemCount := 0;
      PageCount := 0;
      predItem := nil;
      Pass(FNTXOrder.FHead.root);
      if not FForExists and not Unique then begin
        if DWORD(TVKDBFNTX(FIndexes.Owner).RecordCount) <> ItemCount then
          raise Exception.Create('TVKNTXIndex.VerifyIndex: ItemCount in index ' + IntToStr(ItemCount) + ', but record count in dbf ' + IntToStr(TVKDBFNTX(FIndexes.Owner).RecordCount));
      end;
      PassFreeList(FNTXOrder.FHead.next_page);
      Inc(PageCount); //plus header
      PageCountBySize := FNTXBag.NTXHandler.size() div NTX_PAGE;
      if PageCountBySize <> PageCount then begin
        raise Exception.Create('TVKNTXIndex.VerifyIndex: Page count in index ' + IntToStr(PageCount) + ', but need ' + IntToStr(PageCountBySize));
      end;
    finally
      FUnLock;
    end;
  end;

end;

{ TVKNTXRange }

function TVKNTXRange.GetActive: boolean;
begin
  Result := FActive;
end;

function TVKNTXRange.InRange(S: AnsiString): boolean;
var
  l, c: Integer;

  function min(a, b: Integer): Integer;
  begin
    if a < b then
      result := a
    else
      result := b;
  end;

begin
  l := min(Length(HiKey), NTX.FNTXOrder.FHead.key_size);
  if l > 0 then begin
    c := NTX.CompareKeys(pAnsiChar(HiKey), pAnsiChar(S), l);
    Result := (c >= 0); //HiKey >= S
    if Result then begin
      l := min(Length(LoKey), NTX.FNTXOrder.FHead.key_size);
      if l > 0 then begin
        c := NTX.CompareKeys(pAnsiChar(LoKey), pAnsiChar(S), l);
        Result := (c <= 0); //LoKey <= S
      end;
    end;
  end else
    Result := false;
end;

procedure TVKNTXRange.ReOpen;
var
  oDB: TVKDBFNTX;
begin
  if not Active then begin
    Active := true;
  end else begin
    NTX.Active := true;
    oDB := TVKDBFNTX(NTX.OwnerTable);
    if oDB.Active then oDB.First;
  end;
end;

procedure TVKNTXRange.SetActive(const Value: boolean);
var
  oDB: TVKDBFNTX;
  l: boolean;
begin
  l := FActive;
  FActive := Value;
  oDB := TVKDBFNTX(NTX.OwnerTable);
  NTX.Active := true;
  if (l <> Value) and oDB.Active then begin
    oDB.First;
  end;
end;

//{$IFNDEF NTXBUFFERASTREE}

{ TVKNTXBuffer }

constructor TVKNTXBuffer.Create(pOffset: DWORD; pNodeCount: Word);
var
  i: Integer;
begin
  inherited Create;
  FOffset := pOffset;
  FNodeCount := pNodeCount;
  FBusyCount := 0;
  FUseCount := 0;
  FPages := VKDBFMemMgr.oMem.GetMem(self, NTX_PAGE * FNodeCount);
  for i := 0 to Pred(MAX_ITEMS_IN_PAGE) do FNTXNode[i] := nil;
  for i := 0 to Pred(FNodeCount) do begin
    FNTXNode[i] := TVKNTXNode.Create(self, FOffset + DWord(i) * NTX_PAGE,  i);
  end;
end;

destructor TVKNTXBuffer.Destroy;
var
  i: Integer;
begin
  VKDBFMemMgr.oMem.FreeMem(FPages);
  for i := 0 to Pred(FNodeCount) do FreeAndNil(FNTXNode[i]);
  inherited Destroy;
end;

function TVKNTXBuffer.GetBusy: boolean;
begin
  Result := ( FBusyCount > 0 );
end;

function TVKNTXBuffer.GetChanged: boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Pred(NodeCount) do begin
    Result := Result or FNTXNode[i].Changed;
    if Result then Break;
  end;
end;

function TVKNTXBuffer.GetNTXNode(ndx: DWord): TVKNTXNode;
begin
  Result := FNTXNode[ndx];
end;

function TVKNTXBuffer.GetPPages(ndx: DWord): pNTX_BUFFER;
begin
  result := pNTX_BUFFER( pAnsiChar( FPages ) + ( NTX_PAGE * ndx) );
end;

procedure TVKNTXBuffer.SetBusy(const Value: boolean);
begin
  if Value then
    Inc( FBusyCount )
  else begin
    if ( FBusyCount > 0 ) then Dec(FBusyCount);
  end;
end;

procedure TVKNTXBuffer.SetChanged(const Value: boolean);
var
  i: Integer;
begin
  for i := 0 to Pred(NodeCount) do FNTXNode[i].Changed := Value;
end;

procedure TVKNTXBuffer.SetOffset(const Value: DWORD);
var
  i: Integer;
  ntxNode: TVKNTXNode;
begin
  FOffset := Value;
  for i := 0 to Pred(NodeCount) do begin
    ntxNode := FNTXNode[i];
    ntxNode.FNodeOffset := FOffset + DWord(i) * NTX_PAGE;
    ntxNode.FIndexInBuffer := i;
  end;
end;

{ TVKNTXBuffers }

function TVKNTXBuffers.FindIndex(block_offset: DWORD;
  out Ind: Integer): boolean;
var
  B: TVKNTXBuffer;
  beg, Mid: Integer;
begin
  Ind := Count;
  if ( Ind > 0 ) then begin
    beg := 0;
    B := TVKNTXBuffer(Items[beg]);
    if ( block_offset > B.Offset ) then begin
      repeat
        Mid := (Ind + beg) div 2;
        B := TVKNTXBuffer(Items[Mid]);
        if ( block_offset > B.Offset ) then
           beg := Mid
        else
           Ind := Mid;
      until ( ((Ind - beg) div 2) = 0 );
    end else
      Ind := beg;
    if Ind < Count then begin
      B := TVKNTXBuffer(Items[Ind]);
      Result := (block_offset = B.Offset);
    end else
      Result := false;
  end else
    Result := false;
end;

procedure TVKNTXBuffers.Flush(Handle: TProxyStream);
var
  i, j, k: Integer;
  ntxb: TVKNTXBuffer;
  WriteOffsetStart: DWord;
  WriteBufferStart: pNTX_BUFFER;
  WriteLength: LongWord;
begin
  for i := 0 to Pred(Count) do begin
    ntxb := TVKNTXBuffer(Items[i]);
    if ntxb.Changed then begin

      WriteOffsetStart := ntxb.Offset;
      WriteBufferStart := ntxb.Pages;
      WriteLength := NTX_PAGE * PagesPerBuffer;
      k := 0;

      for j := 0 to Pred(PagesPerBuffer) do begin
        if ntxb.NTXNode[j].Changed then begin
          WriteOffsetStart := ntxb.NTXNode[j].NodeOffset;
          WriteBufferStart := pNTX_BUFFER(pAnsiChar(ntxb.Pages) + (NTX_PAGE * j)); //ntxb.NTXNode[j].PNode;
          k := j;
          Break;
        end;
      end;
      for j := Pred(PagesPerBuffer) downto 0 do begin
        if ntxb.NTXNode[j].Changed then begin
          WriteLength := NTX_PAGE * (j - k + 1);
          Break;
        end;
      end;

      Handle.Seek(WriteOffsetStart, 0);

      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then begin
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Encrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
        Handle.Write( WriteBufferStart^, WriteLength );
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
      end else
        Handle.Write( WriteBufferStart^, WriteLength );

      ntxb.Changed := False;
    end;
  end;
end;

function TVKNTXBuffers.GetNTXBuffer(Handle: TProxyStream; page_offset: DWORD;
  out page: pNTX_BUFFER; fRead: boolean): TVKNTXNode;
var
  NTXBuffer: TVKNTXBuffer;
  i, j, k, PageIndex: Integer;
  block_offset, block_size: DWORD;

  procedure FillBuffer;
  var
    i, lng: Integer;
  begin
    NTXBuffer.Busy := True;
    IncUseCount(NTXBuffer);
    NTXBuffer.Offset := block_offset;
    if fRead then begin
      Handle.Seek( NTXBuffer.Offset, 0 );
      Handle.Read( NTXBuffer.FPages^, NTX_PAGE * PagesPerBuffer );
      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
        for i := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(i), Pointer(NTXBuffer.PPage[i]), NTX_PAGE );
    end else begin
      lng := NTX_PAGE * Pred(PagesPerBuffer);
      if lng > 0 then begin
        Handle.Seek( NTXBuffer.Offset, 0 );
        Handle.Read( NTXBuffer.FPages^, lng );
        if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
          for i := 0 to Pred(Pred(PagesPerBuffer)) do
            TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(i), Pointer(NTXBuffer.PPage[i]), NTX_PAGE );
      end;
    end;
    Result := NTXBuffer.NTXNode[PageIndex];
    page := Result.PNode;
  end;

  procedure CreateNewBuffer(i: Integer);
  var
    j, lng: Integer;
  begin
    NTXBuffer := TVKNTXBuffer.Create(block_offset, PagesPerBuffer);
    NTXBuffer.Busy := True;
    IncUseCount(NTXBuffer);
    Insert(i, NTXBuffer);
    if fRead then begin
      Handle.Seek( NTXBuffer.Offset, 0 );
      Handle.Read( NTXBuffer.FPages^, NTX_PAGE * PagesPerBuffer );
      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(j), Pointer(NTXBuffer.PPage[j]), NTX_PAGE );
    end else begin
      lng := NTX_PAGE * Pred(PagesPerBuffer);
      if lng > 0 then begin
        Handle.Seek( NTXBuffer.Offset, 0 );
        Handle.Read( NTXBuffer.FPages^, lng );
        if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
          for j := 0 to Pred(Pred(PagesPerBuffer)) do
            TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(j), Pointer(NTXBuffer.PPage[j]), NTX_PAGE );
      end;
    end;
    Result := NTXBuffer.NTXNode[PageIndex];
    page := Result.PNode;
  end;

begin
  block_size := PagesPerBuffer * NTX_PAGE ;
  block_offset := ( page_offset div block_size ) * block_size;
  PageIndex := ( page_offset - block_offset ) div NTX_PAGE;
  if FindIndex(block_offset, i) then begin
    NTXBuffer := TVKNTXBuffer(Items[i]);
    NTXBuffer.Busy := True;
    IncUseCount(NTXBuffer);
    Result := NTXBuffer.NTXNode[PageIndex];
    page := Result.PNode;
  end else
    case Flt of
      lbtUnlimited: CreateNewBuffer(i);
      lbtAuto, lbtLimited:
        begin
          if Count < FMaxBuffers then
            CreateNewBuffer(i)
          else begin
            if FindLeastUsed(j) then begin
              NTXBuffer := TVKNTXBuffer(Items[j]);
              Flash(NTXBuffer);
              FillBuffer;
              k := j;
              while k < Pred(Count) do begin
                if TVKNTXBuffer(Items[k]).Offset > TVKNTXBuffer(Items[k + 1]).Offset then begin
                  Exchange(k, k + 1);
                  Inc(k);
                end else Break;
              end;
              k := j;
              while k > 0 do begin
                if TVKNTXBuffer(Items[k]).Offset < TVKNTXBuffer(Items[k - 1]).Offset then begin
                  Exchange(k, k - 1);
                  Dec(k);
                end else Break;
              end;
            end else
              raise Exception.Create('TVKNTXBuffers.GetNTXBuffer: There is no enough free NTX page buffers! Increase LimitPages property.');
          end;
        end;
    end;
end;

procedure TVKNTXBuffers.SetPageChanged(Handle: TProxyStream; page_offset: DWORD);
var
  NTXBuffer: TVKNTXBuffer;
  i, PageIndex: Integer;
  block_offset, block_size: DWORD;
begin
  block_size := PagesPerBuffer * NTX_PAGE ;
  block_offset := ( page_offset div block_size ) * block_size;
  PageIndex := ( page_offset - block_offset ) div NTX_PAGE;
  if FindIndex(block_offset, i) then begin
    NTXBuffer := TVKNTXBuffer(Items[i]);
    NTXBuffer.NTXNode[PageIndex].Changed := true;
  end;
end;

procedure TVKNTXBuffers.FreeNTXBuffer(ntxb: TVKNTXBuffer);
begin
  ntxb.Busy := False;
end;

procedure TVKNTXBuffers.Flash(ntxb: TVKNTXBuffer);
var
  j, k: Integer;
  WriteOffsetStart: DWord;
  WriteBufferStart: pNTX_BUFFER;
  WriteLength: LongWord;
begin
  if ntxb.Changed then begin

    WriteOffsetStart := ntxb.Offset;
    WriteBufferStart := ntxb.Pages;
    WriteLength := 0;
    k := 0;

    for j := 0 to Pred(PagesPerBuffer) do begin
      if ntxb.NTXNode[j].Changed then begin
        WriteOffsetStart := ntxb.NTXNode[j].NodeOffset;
        WriteBufferStart := pNTX_BUFFER(pAnsiChar(ntxb.Pages) + (NTX_PAGE * j));
        k := j;
        Break;
      end;
    end;
    for j := Pred(PagesPerBuffer) downto 0 do begin
      if ntxb.NTXNode[j].Changed then begin
        WriteLength := NTX_PAGE * (j - k + 1);
        Break;
      end;
    end;

    if WriteLength <> 0 then begin

      NXTObject.FNTXBag.Handler.Seek(WriteOffsetStart, 0);

      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then begin
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Encrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
        NXTObject.FNTXBag.Handler.Write( WriteBufferStart^, WriteLength );
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
      end else
        NXTObject.FNTXBag.Handler.Write( WriteBufferStart^, WriteLength );

    end else
      raise Exception.Create('TVKNTXBuffers.Flash: Internal Error!');

    ntxb.Changed := False;
  end;
end;

constructor TVKNTXBuffers.Create;
begin
  inherited Create;
  Flt := lbtUnlimited;
  FMaxBuffers := 0;
  FPagesPerBuffer := DEFPAGESPERBUFFER;
  FUseCount := 0;
end;

destructor TVKNTXBuffers.Destroy;
begin
  inherited Destroy;
end;

function TVKNTXBuffers.FindLeastUsed(out Ind: Integer): boolean;
var
  i: Integer;
  mn: DWORD;
  B: TVKNTXBuffer;
begin
  mn := MAXDWORD;
  Ind := -1;
  for i := 0 to Pred(Count) do begin
    B := TVKNTXBuffer(Items[i]);
    if not B.Busy then begin
      if B.UseCount <= mn then begin
        mn := B.UseCount;
        Ind := i;
      end;
    end;
  end;
  Result := (Ind <> -1);
end;

function TVKNTXBuffers.IncUseCount(b: TVKNTXBuffer): DWORD;
var
  i: Integer;
  uc: DWORD;
  buf: TVKNTXBuffer;
begin
  Inc(FUseCount);
  if FUseCount = MAXDWORD then begin
    FUseCount := 6;
    for i := 0 to Pred(Count) do begin
      buf := TVKNTXBuffer(Items[i]);
      uc := buf.UseCount;
      buf.UseCount := 0;
      if uc = MAXDWORD - 1 then buf.UseCount := 5;
      if uc = MAXDWORD - 2 then buf.UseCount := 4;
      if uc = MAXDWORD - 3 then buf.UseCount := 3;
      if uc = MAXDWORD - 4 then buf.UseCount := 2;
      if uc = MAXDWORD - 5 then buf.UseCount := 1;
    end;
  end;
  b.UseCount := FUseCount;
  Result := FUseCount;
end;

//{$ELSE}
(*

{TVKNTXBuffer}

constructor TVKNTXBuffer.Create(pOffset: DWORD; pNodeCount: Word);
var
  i: Integer;
begin
  inherited Create;
  FOffset := pOffset;
  FNodeCount := pNodeCount;
  FBusyCount := 0;
  FUseCount := 0;
  FPages := VKDBFMemMgr.oMem.GetMem(self, NTX_PAGE * FNodeCount);
  for i := 0 to Pred(MAX_ITEMS_IN_PAGE) do FNTXNode[i] := nil;
  for i := 0 to Pred(FNodeCount) do begin
    FNTXNode[i] := TVKNTXNode.Create(self, FOffset + DWord(i) * NTX_PAGE,  i);
  end;
end;

destructor TVKNTXBuffer.Destroy;
var
  i: Integer;
begin
  VKDBFMemMgr.oMem.FreeMem(FPages);
  for i := 0 to Pred(FNodeCount) do FreeAndNil(FNTXNode[i]);
  inherited Destroy;
end;

function TVKNTXBuffer.GetBusy: boolean;
begin
  Result := ( FBusyCount > 0 );
end;

function TVKNTXBuffer.GetChanged: boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Pred(NodeCount) do begin
    Result := Result or FNTXNode[i].Changed;
    if Result then Break;
  end;
end;

function TVKNTXBuffer.GetNTXNode(ndx: DWord): TVKNTXNode;
begin
  Result := FNTXNode[ndx];
end;

function TVKNTXBuffer.GetPPages(ndx: DWord): pNTX_BUFFER;
begin
  result := pNTX_BUFFER( pAnsiChar( FPages ) + ( NTX_PAGE * ndx) );
end;

function TVKNTXBuffer.IncUseCount: DWORD;
begin
  Inc(FUseCount);
  Result := FUseCount;
end;

procedure TVKNTXBuffer.SetBusy(const Value: boolean);
begin
  if Value then
    Inc( FBusyCount )
  else begin
    if ( FBusyCount > 0 ) then Dec(FBusyCount);
  end;
end;

procedure TVKNTXBuffer.SetChanged(const Value: boolean);
var
  i: Integer;
begin
  for i := 0 to Pred(NodeCount) do FNTXNode[i].Changed := Value;
end;

procedure TVKNTXBuffer.SetOffset(const Value: DWORD);
var
  i: Integer;
  ntxNode: TVKNTXNode;
begin
  FOffset := Value;
  for i := 0 to Pred(NodeCount) do begin
    ntxNode := FNTXNode[i];
    ntxNode.FNodeOffset := FOffset + DWord(i) * NTX_PAGE;
    ntxNode.FIndexInBuffer := i;
  end;
end;

{ TVKNTXBuffers }

procedure TVKNTXBuffers.Flush(Handle: TProxyStream);
begin
  OnTraversal := OnFlush;
  FTMPHandle := Handle;
  Traversal;
end;

function TVKNTXBuffers.GetNTXBuffer(Handle: TProxyStream; page_offset: DWORD;
  out page: pNTX_BUFFER; fRead: boolean): TVKNTXNode;
var
  NTXBuffer: TVKNTXBuffer;
  j, PageIndex: Integer;
  block_offset, block_size: DWORD;

  procedure FillBuffer;
  var
    i, lng: Integer;
  begin
    NTXBuffer.Busy := True;
    NTXBuffer.IncUseCount;
    NTXBuffer.Offset := block_offset;
    if fRead then begin
      Handle.Seek( NTXBuffer.Offset, 0 );
      Handle.Read( NTXBuffer.FPages^, NTX_PAGE * PagesPerBuffer );
      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
        for i := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(i), Pointer(NTXBuffer.PPage[i]), NTX_PAGE );
    end else begin
      lng := NTX_PAGE * Pred(PagesPerBuffer);
      if lng > 0 then begin
        Handle.Seek( NTXBuffer.Offset, 0 );
        Handle.Read( NTXBuffer.FPages^, lng );
        if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
          for i := 0 to Pred(Pred(PagesPerBuffer)) do
            TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(i), Pointer(NTXBuffer.PPage[i]), NTX_PAGE );
      end;
    end;
    Result := NTXBuffer.NTXNode[PageIndex];
    page := Result.PNode;
  end;

  procedure CreateNewBuffer;
  var
    j, lng: Integer;
  begin
    NTXBuffer := TVKNTXBuffer.Create(block_offset, PagesPerBuffer);
    NTXBuffer.Busy := True;
    NTXBuffer.IncUseCount;
    Add(NTXBuffer);
    if fRead then begin
      Handle.Seek( NTXBuffer.Offset, 0 );
      Handle.Read( NTXBuffer.FPages^, NTX_PAGE * PagesPerBuffer );
      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(j), Pointer(NTXBuffer.PPage[j]), NTX_PAGE );
    end else begin
      lng := NTX_PAGE * Pred(PagesPerBuffer);
      if lng > 0 then begin
        Handle.Seek( NTXBuffer.Offset, 0 );
        Handle.Read( NTXBuffer.FPages^, lng );
        if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then
          for j := 0 to Pred(Pred(PagesPerBuffer)) do
            TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( NTXBuffer.Offset + NTX_PAGE * DWord(j), Pointer(NTXBuffer.PPage[j]), NTX_PAGE );
      end;
    end;
    Result := NTXBuffer.NTXNode[PageIndex];
    page := Result.PNode;
  end;

begin
  block_size := PagesPerBuffer * NTX_PAGE ;
  block_offset := ( page_offset div block_size ) * block_size;
  PageIndex := ( page_offset - block_offset ) div NTX_PAGE;
  NTXBuffer := TVKNTXBuffer(FindKey(block_offset));
  if NTXBuffer <> nil then begin
    NTXBuffer.Busy := True;
    NTXBuffer.IncUseCount;
    Result := NTXBuffer.NTXNode[PageIndex];
    page := Result.PNode;
  end else
    case Flt of
      lbtUnlimited: CreateNewBuffer;
      lbtAuto, lbtLimited:
        begin
          if Count < FMaxBuffers then
            CreateNewBuffer
          else begin
            if FindLeastUsed(j) then begin
              NTXBuffer := TVKNTXBuffer(Items[j]);
              Flash(NTXBuffer);
              FillBuffer;
              UpdateObjectInTree(NTXBuffer);
            end else
              raise Exception.Create('TVKNTXBuffers.GetNTXBuffer: There is no enough free NTX page buffers! Increase LimitPages property.');
          end;
        end;
    end;
end;

procedure TVKNTXBuffers.SetPageChanged(Handle: TProxyStream; page_offset: DWORD);
var
  NTXBuffer: TVKNTXBuffer;
  PageIndex: Integer;
  block_offset, block_size: DWORD;
begin
  block_size := PagesPerBuffer * NTX_PAGE ;
  block_offset := ( page_offset div block_size ) * block_size;
  PageIndex := ( page_offset - block_offset ) div NTX_PAGE;
  NTXBuffer := TVKNTXBuffer(FindKey(block_offset));
  if NTXBuffer <> nil then
    NTXBuffer.NTXNode[PageIndex].Changed := true;
end;

procedure TVKNTXBuffers.FreeNTXBuffer(ntxb: TVKNTXBuffer);
begin
  ntxb.Busy := False;
end;

procedure TVKNTXBuffers.Flash(ntxb: TVKNTXBuffer);
var
  j, k: Integer;
  WriteOffsetStart: DWord;
  WriteBufferStart: pNTX_BUFFER;
  WriteLength: LongWord;
begin
  if ntxb.Changed then begin

    WriteOffsetStart := ntxb.Offset;
    WriteBufferStart := ntxb.Pages;
    WriteLength := 0;
    k := 0;

    for j := 0 to Pred(PagesPerBuffer) do begin
      if ntxb.NTXNode[j].Changed then begin
        WriteOffsetStart := ntxb.NTXNode[j].NodeOffset;
        WriteBufferStart := pNTX_BUFFER(pAnsiChar(ntxb.Pages) + (NTX_PAGE * j));
        k := j;
        Break;
      end;
    end;
    for j := Pred(PagesPerBuffer) downto 0 do begin
      if ntxb.NTXNode[j].Changed then begin
        WriteLength := NTX_PAGE * (j - k + 1);
        Break;
      end;
    end;

    if WriteLength <> 0 then begin

      NXTObject.FNTXBag.Handler.Seek(WriteOffsetStart, 0);

      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then begin
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Encrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
        NXTObject.FNTXBag.Handler.Write( WriteBufferStart^, WriteLength );
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
      end else
        NXTObject.FNTXBag.Handler.Write( WriteBufferStart^, WriteLength );

    end else
      raise Exception.Create('TVKNTXBuffers.Flash: Internal Error!');

    ntxb.Changed := False;
  end;
end;

constructor TVKNTXBuffers.Create;
begin
  inherited Create;
  Flt := lbtUnlimited;
  FMaxBuffers := 0;
  FPagesPerBuffer := DEFPAGESPERBUFFER;
end;

destructor TVKNTXBuffers.Destroy;
begin
  inherited Destroy;
end;

function TVKNTXBuffers.FindLeastUsed(out Ind: Integer): boolean;
var
  i: Integer;
  mn: DWORD;
  B: TVKNTXBuffer;
begin
  mn := MAXDWORD;
  Ind := -1;
  for i := 0 to Pred(Count) do begin
    B := TVKNTXBuffer(Items[i]);
    if not B.Busy then begin
      if B.UseCount < mn then begin
        mn := B.UseCount;
        Ind := i;
      end;
    end;
  end;
  Result := (Ind <> -1);
end;

function TVKNTXBuffer.cpm(sObj: TVKSortedObject): Integer;
begin
  Result := TVKNTXBuffer(sObj).Offset - Offset;
end;

procedure TVKNTXBuffers.OnFlush(Sender: TVKSortedListAbstract;
  SortedObject: TVKSortedObject);
var
  j, k: Integer;
  ntxb: TVKNTXBuffer;
  WriteOffsetStart: DWord;
  WriteBufferStart: pNTX_BUFFER;
  WriteLength: LongWord;
begin

    ntxb := TVKNTXBuffer(SortedObject);
    if ntxb.Changed then begin

      WriteOffsetStart := ntxb.Offset;
      WriteBufferStart := ntxb.Pages;
      WriteLength := NTX_PAGE * PagesPerBuffer;
      k := 0;

      for j := 0 to Pred(PagesPerBuffer) do begin
        if ntxb.NTXNode[j].Changed then begin
          WriteOffsetStart := ntxb.NTXNode[j].NodeOffset;
          WriteBufferStart := pNTX_BUFFER(pAnsiChar(ntxb.Pages) + (NTX_PAGE * j)); //ntxb.NTXNode[j].PNode;
          k := j;
          Break;
        end;
      end;
      for j := Pred(PagesPerBuffer) downto 0 do begin
        if ntxb.NTXNode[j].Changed then begin
          WriteLength := NTX_PAGE * (j - k + 1);
          Break;
        end;
      end;

      FTMPHandle.Seek(WriteOffsetStart, 0);

      if TVKDBFNTX(NXTObject.OwnerTable).Crypt.Active then begin
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Encrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
        FTMPHandle.Write( WriteBufferStart^, WriteLength );
        for j := 0 to Pred(PagesPerBuffer) do
          TVKDBFNTX(NXTObject.OwnerTable).Crypt.Decrypt( ntxb.Offset + NTX_PAGE * DWord(j), Pointer(ntxb.PPage[j]), NTX_PAGE );
      end else
        FTMPHandle.Write( WriteBufferStart^, WriteLength );

      ntxb.Changed := False;
    end;

end;

function TVKNTXBuffers.FindKey(dwKey: DWORD): TVKSortedObject;

  function FindKeyInternal(RootNodeObject: TVKSortedObject): TVKSortedObject;
  var
    c: Integer;
    CurrentObject: TVKSortedObject;
  begin
    if RootNodeObject.dad <> nil then
      c := dwKey - TVKNTXBuffer(RootNodeObject).FOffset
    else
      c := 1; //for root object alwase get 1
    if c > 0 then begin //dwKey > RootNodeObject
      CurrentObject := RootNodeObject.rson;
      if CurrentObject <> nil then
        Result := FindKeyInternal(CurrentObject)
      else begin
        Result := nil;
      end;
    end else if c = 0 then begin
      Result := RootNodeObject;
    end else begin
      CurrentObject := RootNodeObject.lson;
      if CurrentObject <> nil then
        Result := FindKeyInternal(CurrentObject)
      else begin
        Result := nil;
      end;
    end;
  end;

begin
  Result := FindKeyInternal(Root);
end;

{$ENDIF}
*)

{ TVKNTXCompactIndex }

procedure TVKNTXCompactIndex.Close;
begin
  Flush;
  SubOffSet := 0;
  LinkRest;
  SHead.root := SubOffSet;
  SHead.next_page := 0;
  if Handler = nil then begin
    SysUtils.FileSeek(FHndl, 0, 0);
    SysUtils.FileWrite(FHndl, SHead, SizeOf(NTX_HEADER));
  end else begin
    Handler.Seek(0, 0);
    Handler.Write(SHead, SizeOf(NTX_HEADER));
  end;
  NormalizeRest;
  if Handler = nil then
    FileClose(FHndl)
  else
    Handler.Close;
end;

procedure TVKNTXCompactIndex.CreateEmptyIndex(var FHead: NTX_HEADER);
begin
  if Handler = nil then begin
    if FileName = '' then begin
      if CreateTmpFilesInTmpFilesDir then
        FileName := GetTmpFileName(TmpFilesDir)
      else
        FileName := GetTmpFileName;
    end;
    FHndl := FileCreate(FileName);
    if FHndl <= 0 then
      raise Exception.Create('TVKNTXCompactIndex.CreateEmptyIndex: Index create error');
  end else
    Handler.CreateProxyStream;
  SHead := FHead;
  SHead.version := 0;
  SHead.root := NTX_PAGE;
  SHead.next_page := 0;
  if Handler = nil then begin
    SysUtils.FileSeek(FHndl, 0, 0);
    SysUtils.FileWrite(FHndl, SHead, SizeOf(NTX_HEADER));
  end else begin
    Handler.Seek(0, 0);
    Handler.Write(SHead, SizeOf(NTX_HEADER));
  end;
  NewPage(0);
  cur_lev := -1;
  SubOffSet := NTX_PAGE;
end;

procedure TVKNTXCompactIndex.NewPage(lev: Integer);
var
  item_off: WORD;
  i: Integer;
begin
  levels[lev].count := 0;
  item_off := ( SHead.max_item * 2 ) + 4;
  for i := 0 to SHead.max_item do begin
    levels[lev].ref[i] := item_off;
    item_off := item_off + SHead.item_size;
  end;
  pNTX_ITEM(pAnsiChar(@levels[lev]) + levels[lev].ref[0]).page := 0;
  max_lev := lev;
end;

procedure TVKNTXCompactIndex.NormalizeRest;
var
  LeftPage: TVKNTXNodeDirect;

  procedure SavePage(page: TVKNTXNodeDirect);
  begin
    if Handler = nil then
      FileSeek(FHndl, page.NodeOffset, 0)
    else
      Handler.Seek(page.NodeOffset, 0);
    if Crypt then begin
      CryptPage := page.Node;
      TVKDBFNTX(OwnerTable).Crypt.Encrypt(SubOffSet, @CryptPage, SizeOf(NTX_BUFFER));
      if Handler = nil then
        SysUtils.FileWrite(FHndl, CryptPage, SizeOf(NTX_BUFFER))
      else
        Handler.Write(CryptPage, SizeOf(NTX_BUFFER));
    end else begin
      if Handler = nil then
        SysUtils.FileWrite(FHndl, page.PNode^, SizeOf(NTX_BUFFER))
      else
        Handler.Write(page.PNode^, SizeOf(NTX_BUFFER));
    end;
  end;

  procedure GetPage(root: DWORD; page: TVKNTXNodeDirect);
  begin
    if Handler = nil then begin
      SysUtils.FileSeek(FHndl, root, 0);
      SysUtils.FileRead(FHndl, page.PNode^, SizeOf(NTX_BUFFER));
    end else begin
      Handler.Seek(root, 0);
      Handler.Read(page.PNode^, SizeOf(NTX_BUFFER));
    end;
    if Crypt then
      TVKDBFNTX(OwnerTable).Crypt.Decrypt(root, page.PNode, SizeOf(NTX_BUFFER));
    page.FNodeOffset := root;
  end;

  procedure Normalize(root: DWORD; Parent: TVKNTXNodeDirect);
  var
    item, LItem, SLItem, CItem: pNTX_ITEM;
    rf: DWORD;
    Shift, j: Integer;
    CurrentPage: TVKNTXNodeDirect;
  begin
    CurrentPage := TVKNTXNodeDirect.Create(root);
    GetPage(root, CurrentPage);
    if Parent <> nil then begin
      if CurrentPage.PNode.count < SHead.half_page then begin
        LItem := pNTX_ITEM( pAnsiChar(Parent.PNode) + Parent.PNode.ref[Parent.PNode.count - 1]);
        GetPage(LItem.page, LeftPage);

        SLItem := pNTX_ITEM( pAnsiChar(LeftPage.PNode) + LeftPage.PNode.ref[LeftPage.PNode.count]);

        Shift := SHead.half_page;

        LeftPage.PNode.count := LeftPage.PNode.count - Shift;

        j := CurrentPage.PNode.count;
        while j >= 0 do begin
          rf := CurrentPage.PNode.ref[j + Shift];
          CurrentPage.PNode.ref[j + Shift] := CurrentPage.PNode.ref[j];
          CurrentPage.PNode.ref[j] := rf;
          Dec(j);
        end;
        Inc(CurrentPage.PNode.count, Shift);

        CItem := pNTX_ITEM( pAnsiChar(CurrentPage.PNode) + CurrentPage.PNode.ref[Shift - 1]);
        Move(LItem.key, CItem.key, SHead.key_size);
        CItem.rec_no := LItem.rec_no;
        CItem.page := SLItem.page;

        Dec(Shift);

        while Shift > 0 do begin

          SLItem := pNTX_ITEM( pAnsiChar(LeftPage.PNode) + LeftPage.PNode.ref[LeftPage.PNode.count + Shift]);

          CItem := pNTX_ITEM( pAnsiChar(CurrentPage.PNode) + CurrentPage.PNode.ref[Shift - 1]);
          Move(SLItem.key, CItem.key, SHead.key_size);
          CItem.rec_no := SLItem.rec_no;
          CItem.page := SLItem.page;

          Dec(Shift);
        end;

        SLItem := pNTX_ITEM( pAnsiChar(LeftPage.PNode) + LeftPage.PNode.ref[LeftPage.PNode.count]);
        Move(SLItem.key, LItem.key, SHead.key_size);
        LItem.rec_no := SLItem.rec_no;

        SavePage(Parent);
        SavePage(CurrentPage);
        SavePage(LeftPage);

      end;
    end;
    Item := pNTX_ITEM( pAnsiChar(CurrentPage.PNode) + CurrentPage.PNode.ref[CurrentPage.PNode.count]);
    if Item.page <> 0 then
      Normalize(Item.page, CurrentPage);
    CurrentPage.Free;
  end;

begin
  LeftPage := TVKNTXNodeDirect.Create(0);
  try
    Normalize(SHead.root, nil);
  finally
    FreeAndNil(LeftPage);
  end;
end;

procedure TVKNTXCompactIndex.LinkRest;
var
  page: pNTX_BUFFER;
  i: pNTX_ITEM;
begin
  Inc(cur_lev);
  if (cur_lev <= max_lev) then begin
    page := pNTX_BUFFER(@levels[cur_lev]);
    i := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
    i.page := SubOffSet;
    if Handler = nil then
      SubOffSet := FileSeek(FHndl, 0, 2)
    else
      SubOffSet := Handler.Seek(0, 2);
    if Crypt then begin
      CryptPage := page^;
      TVKDBFNTX(OwnerTable).Crypt.Encrypt(SubOffSet, @CryptPage, SizeOf(NTX_BUFFER));
      if Handler = nil then
        SysUtils.FileWrite(FHndl, CryptPage, SizeOf(NTX_BUFFER))
      else
        Handler.Write(CryptPage, SizeOf(NTX_BUFFER));
    end else begin
      if Handler = nil then
        SysUtils.FileWrite(FHndl, page^, SizeOf(NTX_BUFFER))
      else
        Handler.Write(page^, SizeOf(NTX_BUFFER));
    end;
    LinkRest;
  end;
  Dec(cur_lev);
end;

procedure TVKNTXCompactIndex.AddItem(item: pNTX_ITEM);
var
  page: pNTX_BUFFER;
  i: pNTX_ITEM;
begin
  Inc(cur_lev);
  if (cur_lev > max_lev) then NewPage(cur_lev);
  page := pNTX_BUFFER(@levels[cur_lev]);
  if page.count = SHead.max_item then begin
    i := pNTX_ITEM(pAnsiChar(page) + page.ref[page.count]);
    if cur_lev <> 0  then
      i.page := item.page
    else
      i.page := 0;

    if Crypt then begin
      CryptPage := page^;
      TVKDBFNTX(OwnerTable).Crypt.Encrypt(SubOffSet, @CryptPage, SizeOf(NTX_BUFFER));
      if wbAmount > 1 then begin
        if wbCount = wbAmount then begin
          if Handler = nil then
            SysUtils.FileWrite(FHndl, pWriteBuff^, NTX_PAGE * wbCount)
          else
            Handler.Write(pWriteBuff^, NTX_PAGE * wbCount);
          wbCount := 0;
        end;
        Move(CryptPage, pAnsiChar(pWriteBuff + NTX_PAGE * wbCount)^, NTX_PAGE);
        Inc(wbCount);
      end else begin
        if Handler = nil then
          SysUtils.FileWrite(FHndl, CryptPage, SizeOf(NTX_BUFFER))
        else
          Handler.Write(CryptPage, SizeOf(NTX_BUFFER));
      end;
    end else begin
      if wbAmount > 1 then begin
        if wbCount = wbAmount then begin
          if Handler = nil then
            SysUtils.FileWrite(FHndl, pWriteBuff^, NTX_PAGE * wbCount)
          else
            Handler.Write(pWriteBuff^, NTX_PAGE * wbCount);
          wbCount := 0;
        end;
        Move(page^, pAnsiChar(pWriteBuff + NTX_PAGE * wbCount)^, NTX_PAGE);
        Inc(wbCount);
      end else begin
        if Handler = nil then
          SysUtils.FileWrite(FHndl, page^, SizeOf(NTX_BUFFER))
        else
          Handler.Write(page^, SizeOf(NTX_BUFFER));
      end;
    end;

    item.page := SubOffSet;
    Inc(SubOffSet, NTX_PAGE);
    AddItem(item);
    page.count := 0;
  end else begin
    if ( cur_lev = 0 ) then item.page := 0;
    Move(item^, (pAnsiChar(page) + page.ref[page.count])^, SHead.item_size);
    page.count := page.count + 1;
  end;
  Dec(cur_lev);
end;

constructor TVKNTXCompactIndex.Create(pBuffCount: Integer = 0);
begin
  Handler := nil;
  FHndl := -1;
  cur_lev := -1;
  max_lev := -1;
  SubOffSet := 0;
  FileName := '';
  OwnerTable := nil;
  Crypt := false;
  CreateTmpFilesInTmpFilesDir := false;
  TmpFilesDir := '';
  wbAmount := pBuffCount;
  if wbAmount > 1 then begin
    pWriteBuff :=
      VKDBFMemMgr.oMem.GetMem(self, NTX_PAGE * wbAmount);
  end;
  wbCount := 0;
end;

destructor TVKNTXCompactIndex.Destroy;
begin
  if wbAmount > 1 then
    VKDBFMemMgr.oMem.FreeMem(pWriteBuff);
  inherited Destroy;
end;

procedure TVKNTXCompactIndex.Flush;
begin
  if wbAmount > 1 then begin
    if wbCount > 0 then begin
      if Handler = nil then
        SysUtils.FileWrite(FHndl, pWriteBuff^, NTX_PAGE * wbCount)
      else
        Handler.Write(pWriteBuff^, NTX_PAGE * wbCount);
      wbCount := 0;
    end;
  end;
end;

{ TVKNTXIndexIterator }

constructor TVKNTXIndexIterator.Create;
begin
  Eof := false;
end;

destructor TVKNTXIndexIterator.Destroy;
begin
  inherited Destroy;
end;

{ TVKNTXBlockIterator }

procedure TVKNTXBlockIterator.Close;
begin
  VKDBFMemMgr.oMem.FreeMem(p);
  DeleteFile(FFileName);
end;

constructor TVKNTXBlockIterator.Create(FileName: AnsiString; key_size, BufSize: Integer);
begin
  inherited Create;
  FFileName := FileName;
  Fkey_size := key_size;
  FBufSize := BufSize;
end;

destructor TVKNTXBlockIterator.Destroy;
begin
  DeleteFile(FFileName);
  inherited Destroy;
end;

procedure TVKNTXBlockIterator.Next;
var
  BlockItem: pBLOCK_ITEM;
begin
  Inc(i);
  if i >= p.count then Eof := true else begin
    item.page := 0;
    BlockItem := pBLOCK_ITEM(pAnsiChar(p) + p.ref[i]);
    item.rec_no := BlockItem.rec_no;
    Move(BlockItem.key, item.key, Fkey_size);
  end;
end;

procedure TVKNTXBlockIterator.Open;
var
  BlockItem: pBLOCK_ITEM;
begin
  p := VKDBFMemMgr.oMem.GetMem(self, FBufSize);
  FHndl := FileOpen(FFileName, fmOpenRead or fmShareExclusive);
  if FHndl > 0 then begin
    SysUtils.FileRead(FHndl, p^, FBufSize);
    SysUtils.FileClose(FHndl);
    i := 0;
    if p.count = 0 then Eof := true;
    item.page := 0;
    BlockItem := pBLOCK_ITEM(pAnsiChar(p) + p.ref[i]);
    item.rec_no := BlockItem.rec_no;
    Move(BlockItem.key, item.key, Fkey_size);
  end else
    raise Exception.Create('TVKNTXBlockIterator.Open: Open Error "' + FFileName + '"');
end;

{ TVKNTXIterator }

procedure TVKNTXIterator.Close;
begin
  FileClose(FHndl);
  VKDBFMemMgr.oMem.FreeMem(levels);
  DeleteFile(FFileName);
end;

constructor TVKNTXIterator.Create(FileName: AnsiString);
begin
  inherited Create;
  FFileName := FileName;
end;

destructor TVKNTXIterator.Destroy;
begin
  DeleteFile(FFileName);
  inherited Destroy;
end;

procedure TVKNTXIterator.Next;
var
  page: pNTX_BUFFER;
  i: pNTX_ITEM;
begin
  Inc(indexes[cur_lev]);
  repeat
    page := pNTX_BUFFER(@levels^[cur_lev]);
    i := pNTX_ITEM(pAnsiChar(page) + page.ref[indexes[cur_lev]]);
    if i.page <> 0 then begin
      Inc(cur_lev);
      indexes[cur_lev] := 0;
      SysUtils.FileSeek(FHndl, i.page, 0);
      SysUtils.FileRead(FHndl, levels^[cur_lev], SizeOf(NTX_BUFFER));
    end;
  until i.page = 0;
  repeat
    if indexes[cur_lev] = page.count then begin
      Dec(cur_lev);
      if cur_lev = -1 then begin
        Eof := true;
        Break;
      end else begin
        page := pNTX_BUFFER(@levels^[cur_lev]);
        i := pNTX_ITEM(pAnsiChar(page) + page.ref[indexes[cur_lev]]);
        item.page := 0;
        item.rec_no := i.rec_no;
        Move(i.key, item.key, SHead.key_size);
      end;
    end else begin
      item.page := 0;
      item.rec_no := i.rec_no;
      Move(i.key, item.key, SHead.key_size);
    end;
  until indexes[cur_lev] < page.count;
end;

procedure TVKNTXIterator.Open;
var
  page: pNTX_BUFFER;
  i: pNTX_ITEM;
begin
  levels := VKDBFMemMgr.oMem.GetMem(self, MAX_LEV_BTREE * SizeOf(NTX_BUFFER));
  FHndl := FileOpen(FFileName, fmOpenRead or fmShareExclusive);
  if FHndl > 0 then begin
    SysUtils.FileRead(FHndl, SHead, SizeOf(NTX_HEADER));
    cur_lev := 0;
    SysUtils.FileSeek(FHndl, SHead.root, 0);
    SysUtils.FileRead(FHndl, levels^[cur_lev], SizeOf(NTX_BUFFER));
    Eof := false;
    indexes[cur_lev] := 0;
    if levels^[cur_lev].count = 0 then Eof := true;
    if not Eof then begin
      repeat
        page := pNTX_BUFFER(@levels^[cur_lev]);
        i := pNTX_ITEM(pAnsiChar(page) + page.ref[indexes[cur_lev]]);
        if i.page <> 0 then begin
          Inc(cur_lev);
          indexes[cur_lev] := 0;
          SysUtils.FileSeek(FHndl, i.page, 0);
          SysUtils.FileRead(FHndl, levels^[cur_lev], SizeOf(NTX_BUFFER));
        end;
      until i.page = 0;
      item.page := 0;
      item.rec_no := i.rec_no;
      Move(i.key, item.key, SHead.key_size);
    end;
  end else
    raise Exception.Create('TVKNTXIterator.Open: Open Error "' + FFileName + '"');
end;

{ TVKNTXBag }

procedure TVKNTXBag.Close;
begin
  Handler.Close;
end;

constructor TVKNTXBag.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

function TVKNTXBag.CreateBag: boolean;
begin
  if ( StorageType = pstOuterStream ) and ( OuterStream = nil ) then
    raise Exception.Create('TVKNTXBag.CreateBag: StorageType = pstOuterStream but OuterStream = nil!');
  Handler.FileName := IndexFileName;
  Handler.AccessMode.AccessMode := TVKDBFNTX(OwnerTable).AccessMode.AccessMode;
  Handler.ProxyStreamType := StorageType;
  Handler.OuterStream := OuterStream;
  Handler.OnLockEvent := TVKDBFNTX(OwnerTable).OnOuterStreamLock;
  Handler.OnUnlockEvent := TVKDBFNTX(OwnerTable).OnOuterStreamUnlock;
  Handler.CreateProxyStream;
  Result := Handler.IsOpen;
end;

destructor TVKNTXBag.Destroy;
begin
  inherited Destroy;
end;

procedure TVKNTXBag.FillHandler;
begin
  Handler.FileName := IndexFileName;
  Handler.AccessMode.AccessMode := TVKDBFNTX(OwnerTable).AccessMode.AccessMode;
  Handler.ProxyStreamType := StorageType;
  Handler.OuterStream := OuterStream;
  Handler.OnLockEvent := TVKDBFNTX(OwnerTable).OnOuterStreamLock;
  Handler.OnUnlockEvent := TVKDBFNTX(OwnerTable).OnOuterStreamUnlock;
end;

function TVKNTXBag.IsOpen: boolean;
begin
  Result := Handler.IsOpen;
end;

function TVKNTXBag.Open: boolean;
begin
  if ( StorageType = pstOuterStream ) and ( OuterStream = nil ) then
    raise Exception.Create('TVKNTXBag.Open: StorageType = pstOuterStream but OuterStream = nil!');
  Handler.FileName := IndexFileName;
  Handler.AccessMode.AccessMode := TVKDBFNTX(OwnerTable).AccessMode.AccessMode;
  Handler.ProxyStreamType := StorageType;
  Handler.OuterStream := OuterStream;
  Handler.OnLockEvent := TVKDBFNTX(OwnerTable).OnOuterStreamLock;
  Handler.OnUnlockEvent := TVKDBFNTX(OwnerTable).OnOuterStreamUnlock;
  Handler.Open;
  if not Handler.IsOpen then
    raise Exception.Create('TVKNTXBag.Open: Open error "' + IndexFileName + '"')
  else begin
    if Orders.Count = 0 then Orders.Add;
    with Orders.Items[0] as TVKNTXOrder do begin
      Handler.Seek(0, 0);
      Handler.Read(FHead, SizeOf(NTX_HEADER));
      //FLastOffset := Handler.Seek(0, 2);

      if FHead.order <> '' then
        TVKNTXOrder(Orders.Items[0]).Name := FHead.Order
      else
        TVKNTXOrder(Orders.Items[0]).Name := ChangeFileExt(ExtractFileName(IndexFileName), '');

      KeyExpresion := FHead.key_expr;
      ForExpresion := FHead.for_expr;
      Unique := (FHead.unique <> #0);
      Desc := (FHead.Desc <> #0);

    end;
  end;
  Result := Handler.IsOpen;
end;

{ TVKNTXOrder }

constructor TVKNTXOrder.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  if Index > 0 then
    raise Exception.Create('TVKNTXOrder.Create: NTX bag can not content more then one order!');
end;

function TVKNTXOrder.CreateOrder: boolean;
var
  oBag: TVKNTXBag;
  FKeyParser: TVKDBFExprParser;
  FieldMap: TFieldMap;
  IndAttr: TIndexAttributes;
  CryptPage, page: NTX_BUFFER;
  item_off: WORD;
  i: Integer;

  function EvaluteKeyExpr: AnsiString;
  begin
    if Assigned(OnEvaluteKey) then
      OnEvaluteKey(self, Result)
    else
      Result := FKeyParser.EvaluteKey;
  end;

begin

  oBag := TVKNTXBag(TVKDBFOrders(Collection).Owner);

  FKeyParser := TVKDBFExprParser.Create(TVKDBFNTX(oBag.OwnerTable), '', [], [poExtSyntax], '', nil, FieldMap);
  FKeyParser.IndexKeyValue := true;

  if ClipperVer in [v500, v501] then
    FHead.sign := 6
  else
    FHead.sign := 7;
  FHead.version := 1;
  FHead.root := NTX_PAGE;
  FHead.next_page := 0;

  if Assigned(OnCreateIndex) then begin
    OnCreateIndex(self, IndAttr);
    FHead.key_size := IndAttr.key_size;
    FHead.key_dec := IndAttr.key_dec;
    System.Move(pAnsiChar(IndAttr.key_expr)^, FHead.key_expr, Length(IndAttr.key_expr));
    FHead.key_expr[Length(IndAttr.key_expr)] := #0;
    System.Move(pAnsiChar(IndAttr.for_expr)^, FHead.for_expr, Length(IndAttr.for_expr));
    FHead.for_expr[Length(IndAttr.for_expr)] := #0;
  end else begin
    FKeyParser.SetExprParams1(KeyExpresion, [], [poExtSyntax], '');
    EvaluteKeyExpr;
    FHead.key_size := Length(FKeyParser.Key);
    FHead.key_dec := FKeyParser.Prec;
    System.Move(pAnsiChar(KeyExpresion)^, FHead.key_expr, Length(KeyExpresion));
    FHead.key_expr[Length(KeyExpresion)] := #0;
    System.Move(pAnsiChar(ForExpresion)^, FHead.for_expr, Length(ForExpresion));
    FHead.for_expr[Length(ForExpresion)] := #0;
  end;

  FHead.item_size := FHead.key_size + 8;
  FHead.max_item := (NTX_PAGE - FHead.item_size - 4) div (FHead.item_size + 2);
  FHead.half_page := FHead.max_item div 2;
  FHead.max_item := FHead.half_page * 2;

  FHead.reserv1 := #0;
  FHead.reserv3 := #0;

  System.Move(pAnsiChar(Name)^, FHead.order, Length(Name));
  if Desc then FHead.Desc := #1;
  if Unique then FHead.Unique := #1;

  oBag.NTXHandler.Seek(0, 0);
  oBag.NTXHandler.Write(FHead, SizeOf(NTX_HEADER));

  page.count := 0;
  item_off := ( FHead.max_item * 2 ) + 4;
  for i := 0 to FHead.max_item do begin
    page.ref[i] := item_off;
    item_off := item_off + FHead.item_size;
  end;
  pNTX_ITEM(pAnsiChar(@page) + page.ref[0]).page := 0;

  if TVKDBFNTX(oBag.OwnerTable).Crypt.Active then begin
     CryptPage := page;
     TVKDBFNTX(oBag.OwnerTable).Crypt.Encrypt(SizeOf(NTX_BUFFER), @CryptPage, SizeOf(NTX_BUFFER));
     oBag.NTXHandler.Write(CryptPage, SizeOf(NTX_BUFFER));
  end else
     oBag.NTXHandler.Write(page, SizeOf(NTX_BUFFER));

  oBag.NTXHandler.SetEndOfFile;

  FKeyParser.Free;

  Result := True;

end;

destructor TVKNTXOrder.Destroy;
begin
  inherited Destroy;
end;

{ TVKNTXNode }

constructor TVKNTXNode.Create(Owner: TVKNTXBuffer; Offset: DWORD;
  Index: Integer);
begin
  inherited Create;
  FChanged := false;
  FNTXBuffer := Owner;
  FNodeOffset := Offset;
  FIndexInBuffer := Index;
end;

function TVKNTXNode.GetNode: NTX_BUFFER;
begin
  Result := FNTXBuffer.PPage[FIndexInBuffer]^;
end;

function TVKNTXNode.GetPNode: pNTX_BUFFER;
begin
  Result := FNTXBuffer.PPage[FIndexInBuffer];
end;

{ TVKNTXNodeDirect }

constructor TVKNTXNodeDirect.Create(Offset: DWORD);
begin
  inherited Create;
  FNodeOffset := Offset;
end;

function TVKNTXNodeDirect.GetNode: NTX_BUFFER;
begin
  Result := FNode;
end;

function TVKNTXNodeDirect.GetPNode: pNTX_BUFFER;
begin
  Result := @FNode;
end;

end.
