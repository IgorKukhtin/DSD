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
unit VKDBFIndex;

{$I VKDBF.DEF}

interface

uses
  Windows, Messages, SysUtils, Classes, db,
  {$IFDEF DELPHI6} Variants, {$ENDIF}
  VKDBFPrx, VKDBFSorters, VKDBFCrypt;

type

  TCLIPPER_VERSION = (v500, v501, v520, v530);
  TDBFIndexType = (itNotDefined, itNTX, itNDX, itMDX, itIDX, itCDX);
  TVKLimitBuffersType = (lbtAuto, lbtLimited, lbtUnlimited);

  TVKHashTypeForTreeSorters = (httsDefault,
                        htts1, htts2, htts4, htts8, htts16, htts32, htts64,
                        htts128, htts256, htts512, htts1024, htts2048, htts4096,
                        htts8192, htts16384, htts32768, htts65536, htts131072,
                        htts262144, htts524288, htts1048576, htts2097152,
                        htts4194304, htts8388608, htts16777216, htts33554432,
                        htts67108864, htts134217728, htts268435456,
                        htts536870912, htts1073741824, htts2147483648,
                        htts4294967296);
  TVKMaxBitsInHashCode =
                       (mbhc0, mbhc1, mbhc2, mbhc3, mbhc4, mbhc5, mbhc6, mbhc7,
                        mbhc8, mbhc9, mbhc10, mbhc11, mbhc12, mbhc13, mbhc14,
                        mbhc15, mbhc16, mbhc17, mbhc18, mbhc19, mbhc20, mbhc21,
                        mbhc22, mbhc23, mbhc24, mbhc25, mbhc26, mbhc27, mbhc28,
                        mbhc29, mbhc30, mbhc31, mbhc32);

  TVKCollationTypes = ( cltNone, cltCustom, cltClipper501Rus, cltGermanCollation,
                        cltFrenchCollation, cltSpanishCollation, cltItalianCollation,
                        cltSwedishCollation, cltPortugueseCollation, cltNorwegianCollation,
                        cltFinnishCollation, cltDutchCollation, cltDanishCollation,
                        cltGreek437Collation, cltGreek851Collation, cltIcelandic850Collation,
                        cltIcelandic861Collation, cltPolish852Collation,
                        cltHungarianCWICollation, cltHungarian852Collation);
  TVKCollatingSequence = array [0..255] of Byte;
  PVKCollatingSequence = ^TVKCollatingSequence;

  TIndexAttributes = packed record
    key_size: WORD;
    key_dec: WORD;
    key_expr: AnsiString;
    for_expr: AnsiString;
  end;
  pIndexAttributes = ^TIndexAttributes;

  TOnSubIndex = procedure(Sender: TObject; var ItemKey: AnsiString; RecordNum: DWORD; var ExitCode: Integer) of object;
  TOnSubNtx = procedure(Sender: TObject; var ItemKey: AnsiString; RecordNum: DWORD; var Accept: boolean) of object;
  TOnEvaluteKey = procedure(Sender: TObject; out Key: AnsiString) of object;
  TOnEvaluteFor = procedure(Sender: TObject; out ForValue: boolean) of object;
  TOnCompareKeys = procedure(Sender: TObject; CurrentKey, ItemKey: PAnsiChar; MaxLen: Cardinal; out c: Integer) of object;
  TOnCreateIndex = procedure(Sender: TObject; var IndAttr: TIndexAttributes) of object;

  TVKOuterSorterProperties = class(TPersistent)
  private
    FBufferSize: Integer;
    FSortItemPerInnerSorter: Integer;
    FTmpPath: AnsiString;
    FInnerSorterClass: TVKInnerSorterClass;
  public
    constructor Create;
  published
    property TmpPath: AnsiString read FTmpPath write FTmpPath;
    property InnerSorterClass: TVKInnerSorterClass read FInnerSorterClass write FInnerSorterClass;
    property SortItemPerInnerSorter: Integer read FSortItemPerInnerSorter write FSortItemPerInnerSorter;
    property BufferSize: Integer read FBufferSize write FBufferSize;
  end;

  TVKLimitIndexPages = class(TPersistent)
  private
    FLimitBuffers: Integer;
    FLimitPagesType: TVKLimitBuffersType;
    FPagesPerBuffer: Integer;
  public
    constructor Create;
  published
    property LimitPagesType: TVKLimitBuffersType read FLimitPagesType write FLimitPagesType;
    property LimitBuffers: Integer read FLimitBuffers write FLimitBuffers;
    property PagesPerBuffer: Integer read FPagesPerBuffer write FPagesPerBuffer;
  end;

  TVKCollation = class(TPersistent)
  private
    FCustomCollatingSequence: AnsiString;
    FCollationType: TVKCollationTypes;
  public
    constructor Create;
  published
    property CollationType: TVKCollationTypes read FCollationType write FCollationType;
    property CustomCollatingSequence: AnsiString read FCustomCollatingSequence write FCustomCollatingSequence;
  end;

  TVKDBFOrder = class;

  {TVKDBFOrders}
  TVKDBFOrders = class(TOwnedCollection)
  private

    {$IFDEF VER130}
    function GetCollectionOwner: TPersistent;
    {$ENDIF}
    function GetItem(Index: Integer): TVKDBFOrder;
    procedure SetItem(Index: Integer; const Value: TVKDBFOrder);
    function GetOwnerTable: TDataSet;

  public

    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
    procedure AssignValues(Value: TVKDBFOrders);
    function FindIndex(const Value: AnsiString): TVKDBFOrder;
    function IsEqual(Value: TVKDBFOrders): Boolean;
    {$IFDEF VER130}
    property Owner: TPersistent read GetCollectionOwner;
    {$ENDIF}
    property Items[Index: Integer]: TVKDBFOrder read GetItem write SetItem; default;

    property OwnerTable: TDataSet read GetOwnerTable;

  end;

  {TVKDBFOrder}
  TVKDBFOrder = class(TCollectionItem)
  private

    FName: AnsiString;

    FKeyTranslate: boolean;
    FDesc: boolean;
    FTemp: boolean;
    FUnique: boolean;
    FForExpresion: AnsiString;
    FKeyExpresion: AnsiString;
    FClipperVer: TCLIPPER_VERSION;

    FOnCompareKeys: TOnCompareKeys;
    FOnCreateIndex: TOnCreateIndex;
    FOnEvaluteFor: TOnEvaluteFor;
    FOnEvaluteKey: TOnEvaluteKey;
    FLimitPages: TVKLimitIndexPages;
    FOuterSorterProperties: TVKOuterSorterProperties;
    FCollation: TVKCollation;

    function GetOwnerTable: TDataSet;
    procedure SetCollation(const Value: TVKCollation);
    procedure SetLimitPages(const Value: TVKLimitIndexPages);
    procedure SetOuterSorterProperties(const Value: TVKOuterSorterProperties);

  protected

    function GetDisplayName: string; override;

  public

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function IsEqual(Value: TVKDBFOrder): Boolean;

    function CreateOrder: boolean; virtual;

    property OwnerTable: TDataSet read GetOwnerTable;

  published

    property Name: AnsiString read FName write FName;

    property KeyExpresion: AnsiString read FKeyExpresion write FKeyExpresion;
    property ForExpresion: AnsiString read FForExpresion write FForExpresion;
    property KeyTranslate: boolean read FKeyTranslate write FKeyTranslate default true;

    property Unique: boolean read FUnique write FUnique;
    property Desc: boolean read FDesc write FDesc;
    property Temp: boolean read FTemp write FTemp;
    property ClipperVer: TCLIPPER_VERSION read FClipperVer write FClipperVer default v500;
    property LimitPages: TVKLimitIndexPages read FLimitPages write SetLimitPages;
    property OuterSorterProperties: TVKOuterSorterProperties read FOuterSorterProperties write SetOuterSorterProperties;
    property Collation: TVKCollation read FCollation write SetCollation;

    property OnEvaluteKey: TOnEvaluteKey read FOnEvaluteKey write FOnEvaluteKey;
    property OnEvaluteFor: TOnEvaluteFor read FOnEvaluteFor write FOnEvaluteFor;
    property OnCompareKeys: TOnCompareKeys read FOnCompareKeys write FOnCompareKeys;
    property OnCreateIndex: TOnCreateIndex read FOnCreateIndex write FOnCreateIndex;

  end;

  TVKDBFIndexBag = class;

  {TVKDBFIndexDefs}
  TVKDBFIndexDefs = class(TOwnedCollection)
  private

    FIndexType: TDBFIndexType;

    {$IFDEF VER130}
    function GetCollectionOwner: TPersistent;
    {$ENDIF}
    function GetItem(Index: Integer): TVKDBFIndexBag;
    procedure SetItem(Index: Integer; const Value: TVKDBFIndexBag);
    function GetOwnerTable: TDataSet;

  public

    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
    procedure AssignValues(Value: TVKDBFIndexDefs);
    function FindIndex(const Value: AnsiString): TVKDBFIndexBag;
    function IsEqual(Value: TVKDBFIndexDefs): Boolean;

    {$IFDEF VER130}
    property Owner: TPersistent read GetCollectionOwner;
    {$ENDIF}
    property Items[Index: Integer]: TVKDBFIndexBag read GetItem write SetItem; default;

    property OwnerTable: TDataSet read GetOwnerTable;

  end;

  {TVKDBFIndexBag}
  TVKDBFIndexBag = class(TCollectionItem)
  private

    FName: AnsiString;
    FIndexFileName: AnsiString;
    FStorageType: TProxyStreamType;
    FOuterStream: TStream;
    FOrders: TVKDBFOrders;
    function GetInnerStream: TStream;
    procedure SetOrders(const Value: TVKDBFOrders);

    procedure ReadOrderData(Reader: TReader);
    procedure WriteOrderData(Writer: TWriter);
    procedure SetIndexFileName(const Value: AnsiString);
    function GetOwnerTable: TDataSet;

  protected

    Handler: TProxyStream;

    function GetDisplayName: string; override;

  public

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function IsEqual(Value: TVKDBFIndexBag): Boolean;

    procedure DefineProperties(Filer: TFiler); override;

    function CreateBag: boolean; virtual;
    function Open: boolean; virtual;
    function IsOpen: boolean; virtual;
    procedure Close; virtual;

    property OwnerTable: TDataSet read GetOwnerTable;

    property OuterStream: TStream read FOuterStream write FOuterStream;
    property InnerStream: TStream read GetInnerStream;

  published

    property Orders: TVKDBFOrders read FOrders write SetOrders stored false;
    property Name: AnsiString read FName write FName;
    property IndexFileName: AnsiString read FIndexFileName write SetIndexFileName;
    property StorageType: TProxyStreamType read FStorageType write FStorageType;

  end;

  TIndex = class;

  {TIndexes}
  TIndexes = class(TOwnedCollection)
  private

    FIndexType: TDBFIndexType;
    FActiveObject: TIndex;
    {$IFDEF VER130}
    function GetCollectionOwner: TPersistent;
    {$ENDIF}
    function GetItem(Index: Integer): TIndex;
    procedure SetItem(Index: Integer; const Value: TIndex);

  public

    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
    procedure AssignValues(Value: TIndexes);
    function FindIndex(const Value: AnsiString): TIndex;
    function IsEqual(Value: TIndexes): Boolean;
    function CreateIndex(IndexName: AnsiString): TIndex;
    procedure CloseAll;
    {$IFDEF VER130}
    property Owner: TPersistent read GetCollectionOwner;
    {$ENDIF}
    property Items[Index: Integer]: TIndex read GetItem write SetItem; default;
    property IndexType: TDBFIndexType read FIndexType write FIndexType;
    property ActiveObject: TIndex read FActiveObject write FActiveObject;

  end;

  {TIndex}
  TIndex = class(TCollectionItem)
  private

    b_R: boolean;
    FBagName: AnsiString;
    //FIndexBag: TVKDBFIndexBag;
    //FIndexOrder: TVKDBFOrder;

    procedure SetActive(const Value: boolean);
    procedure SetCollationType(const Value: TVKCollationTypes);
    procedure SetCollation(const Value: TVKCollation);
    procedure SetLimitPages(const Value: TVKLimitIndexPages);
    procedure SetOuterSorterProperties(const Value: TVKOuterSorterProperties);

  protected

    FAllowSetCollationType: boolean;
    FName: AnsiString;
    FIndexes: TIndexes;
    FActive: boolean;
    FLimitPages: TVKLimitIndexPages;
    FOuterSorterProperties: TVKOuterSorterProperties;

    FHashTypeForTreeSorters: TVKHashTypeForTreeSorters;
    FMaxBitsInHashCode: TVKMaxBitsInHashCode;

    FCollationType: TVKCollationTypes;
    FCustomCollatingTable: TVKCollatingSequence;
    FCollatingTable: PVKCollatingSequence;
    FCustomCollatingSequence: AnsiString;
    FCollation: TVKCollation;

    FOnSubIndex: TOnSubIndex;
    FOnEvaluteFor: TOnEvaluteFor;
    FOnEvaluteKey: TOnEvaluteKey;
    FOnCompareKeys: TOnCompareKeys;
    FOnCreateIndex: TOnCreateIndex;

    function GetIsRanged: boolean; virtual;
    procedure AssignIndex(oInd: TIndex);
    function GetDisplayName: string; override;
    function InternalFirst: TGetResult; virtual;
    function InternalNext: TGetResult; virtual;
    function InternalPrior: TGetResult; virtual;
    function InternalLast: TGetResult; virtual;
    function GetCurrentKey: AnsiString; virtual;
    function GetCurrentRec: DWORD; virtual;

    function GetOrder: AnsiString; virtual;
    procedure SetOrder(Value: AnsiString); virtual;

    procedure DefineBag; virtual;
    procedure DefineBagAndOrder; virtual;

    function GetIndexBag: TVKDBFIndexBag; virtual;
    function GetIndexOrder: TVKDBFOrder; virtual;

    procedure GetVKHashCode(Sender: TObject; Item: PSORT_ITEM; out HashCode: DWord); virtual;

  public

    FOldEditKey: AnsiString;
    FOldEditRec: Longint;

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IsEqual(Value: TIndex): Boolean; virtual;
    function Open: boolean; virtual;
    procedure Close; virtual;
    function IsOpen: boolean; virtual;
    function SetToRecord: boolean; overload; virtual;
    function SetToRecord(Key: AnsiString; Rec: Longint): boolean; overload; virtual;
    function SetToRecord(Rec: Longint): boolean; overload; virtual;
    function Seek(Key: AnsiString; SoftSeek: boolean = false): boolean; virtual;
    function SeekFirst( Key: AnsiString; SoftSeek: boolean = false;
                        PartialKey: boolean = false): boolean; virtual;
    function SeekFirstRecord( Key: AnsiString; SoftSeek: boolean = false;
                              PartialKey: boolean = false): Integer; virtual;
    function SeekFields(const KeyFields: Ansistring; const KeyValues: Variant;
                        SoftSeek: boolean = false;
                        PartialKey: boolean = false): Integer; virtual;
    function FindKey(Key: AnsiString; PartialKey: boolean = false; SoftSeek: boolean = false; Rec: DWORD = 0): Integer; virtual;
    function FindKeyFields( const KeyFields: AnsiString; const KeyValues: Variant;
                            PartialKey: boolean = false; SoftSeek: boolean = false): Integer; overload; virtual;
    function FindKeyFields( const KeyFields: AnsiString; const KeyValues: array of const;
                            PartialKey: boolean = false; SoftSeek: boolean = false): Integer; overload; virtual;
    function FindKeyFields( PartialKey: boolean = false; SoftSeek: boolean = false): Integer; overload; virtual;    function SubIndex(LowKey, HiKey: AnsiString): boolean; virtual;
    function FillFirstBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): longint; virtual;
    function FillLastBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): longint; virtual;
    function EvaluteKeyExpr: AnsiString; virtual;
    function SuiteFieldList(fl: AnsiString; out m: Integer): Integer; virtual;
    function EvaluteForExpr: boolean; virtual;
    function GetRecordByIndex(GetMode: TGetMode; var cRec: Longint): TGetResult; virtual;
    function GetFirstByIndex(var cRec: Longint): TGetResult; virtual;
    function GetLastByIndex(var cRec: Longint): TGetResult; virtual;
    procedure First; virtual;
    procedure Next; virtual;
    procedure Prior; virtual;
    procedure Last; virtual;
    function LastKey(out LastKey: AnsiString; out LastRec: LongInt): boolean; virtual;
    function NextBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint; virtual;
    function PriorBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint; virtual;

    procedure CreateIndex(Activate: boolean = true; PreSorterBlockSize: LongWord = 4096); virtual;
    procedure CreateIndexUsingSorter(SorterClass: TVKSorterClass; Activate: boolean = true); virtual;
    //procedure CreateIndexUsingSorter1(SorterClass: TVKSorterClass; Activate: boolean = true); virtual;
    procedure CreateIndexUsing8PathMergeSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsing4PathMergeSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingMergeSort(Activate: boolean = true); virtual;
    //procedure CreateIndexUsingAbsorptionSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingTrieTreeSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingAVLTreeSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingRBTreeSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingTreeSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingQuickSort(Activate: boolean = true); virtual;
    procedure CreateCompactIndex( BlockBufferSize: LongWord = 4096;
                                  Activate: boolean = true;
                                  CreateTmpFilesInCurrentDir: boolean = false); virtual;

    //
    (*
    procedure CreateIndexUsingMergeBinaryTreeAndBTree(  TreeSorterClass: TVKBinaryTreeSorterClass;
                                                        Activate: boolean = true;
                                                        PreSorterBlockSize: LongWord = 4096); virtual;
    procedure CreateIndexUsingBTreeHeapSort(Activate: boolean = true); virtual;
    procedure CreateIndexUsingFindMinsAndJoinItToBTree( TreeSorterClass: TVKBinaryTreeSorterClass;
                                                        Activate: boolean = true;
                                                        PreSorterBlockSize: LongWord = 4096); virtual;
    procedure CreateIndexUsingAbsorption( TreeSorterClass: TVKBinaryTreeSorterClass;
                                          Activate: boolean = true;
                                          PreSorterBlockSize: LongWord = 4096); virtual;
    *)
    //

    procedure Reindex(Activate: boolean = true); virtual;

    procedure VerifyIndex; virtual;

    procedure SetRangeFields(FieldList: AnsiString; FieldValues: array of const); overload; virtual;
    procedure SetRangeFields(FieldList: AnsiString; FieldValues: variant); overload; virtual;
    procedure SetRangeFields(FieldList: AnsiString; FieldValuesLow: array of const; FieldValuesHigh: array of const); overload; virtual;
    procedure SetRangeFields(FieldList: AnsiString; FieldValuesLow: variant; FieldValuesHigh: variant); overload; virtual;
    function InRange(Key: AnsiString): boolean; overload; virtual;
    function InRange: boolean; overload; virtual;

    function FLock: boolean; virtual;
    function FUnLock: boolean; virtual;

    procedure StartUpdate(UnLock: boolean = true); virtual;
    procedure Flush; virtual;

    procedure DeleteKey(sKey: AnsiString; nRec: Longint); virtual;
    procedure AddKey(sKey: AnsiString; nRec: Longint); virtual;

    procedure Truncate; virtual;

    procedure BeginCreateIndexProcess; virtual;
    procedure EvaluteAndAddKey(nRec: DWORD); virtual;
    procedure EndCreateIndexProcess; virtual;

    procedure ArrayOfConstant2Variant(const InputValue: array of const; var Value: Variant);

    function IsUniqueIndex: boolean; virtual;
    function IsForIndex: boolean; virtual;

    function ReCrypt(pNewCrypt: TVKDBFCrypt): boolean; virtual;

    property HashTypeForTreeSorters: TVKHashTypeForTreeSorters read FHashTypeForTreeSorters write FHashTypeForTreeSorters default httsDefault;
    property MaxBitsInHashCode: TVKMaxBitsInHashCode read FMaxBitsInHashCode write FMaxBitsInHashCode default mbhc32;

    //Remove property CustomCollatingTable, this type not support in Borland C++Builder :-(
    //property CustomCollatingTable: TVKCollatingSequence read FCustomCollatingTable write FCustomCollatingTable;
    property CollatingTable: PVKCollatingSequence read FCollatingTable write FCollatingTable;

    property LimitPages: TVKLimitIndexPages read FLimitPages write SetLimitPages;
    property OuterSorterProperties: TVKOuterSorterProperties read FOuterSorterProperties write SetOuterSorterProperties;

    property CollationType: TVKCollationTypes read FCollationType write SetCollationType;
    property CustomCollatingSequence: AnsiString read FCustomCollatingSequence write FCustomCollatingSequence;

    property Order: AnsiString read GetOrder write SetOrder;

    property IndexBag: TVKDBFIndexBag read GetIndexBag;
    property IndexOrder: TVKDBFOrder read GetIndexOrder;

    property IsRanged: boolean read GetIsRanged;
    property CurrentKey: AnsiString read GetCurrentKey;
    property CurrentRec: DWORD read GetCurrentRec;

    property OnSubIndex: TOnSubIndex read FOnSubIndex write FOnSubIndex;
    property OnEvaluteKey: TOnEvaluteKey read FOnEvaluteKey write FOnEvaluteKey;
    property OnEvaluteFor: TOnEvaluteFor read FOnEvaluteFor write FOnEvaluteFor;
    property OnCompareKeys: TOnCompareKeys read FOnCompareKeys write FOnCompareKeys;
    property OnCreateIndex: TOnCreateIndex read FOnCreateIndex write FOnCreateIndex;

  published

    property Name: AnsiString read FName write FName;
    property BagName: AnsiString read FBagName write FBagName;
    property Active: boolean read FActive write SetActive;
    property Collation: TVKCollation read FCollation write SetCollation;

  end;

implementation

uses
   VKDBFDataSet, VKDBFNTX, VKDBFCDX, VKDBFParser, VKDBFCollate, VKDBFMemMgr;

{ TIndexes }

procedure TIndexes.AssignValues(Value: TIndexes);
var
  I: Integer;
  P: TIndex;
begin
  for I := 0 to Value.Count - 1 do
  begin
    P := FindIndex(Value[I].Name);
    if P <> nil then
      P.Assign(Value[I]);
  end;
end;

procedure TIndexes.CloseAll;
var
  I: Integer;

  function FindOpened(var Ind: Integer): boolean;
  var
    i: Integer;
  begin
    Result := false;
    for i := 0 to Count - 1 do
      if Items[i].IsOpen then begin
        Ind := i;
        Result := true;
        Exit;
      end;
  end;

begin
  while FindOpened(I) do Items[I].Close;
end;

constructor TIndexes.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClass);
  if ItemClass.ClassName = 'TVKNTXIndex' then
    FIndexType := itNTX
  else if ItemClass.ClassName = 'TVKNDXIndex' then
    FIndexType := itNDX
  else if ItemClass.ClassName = 'TVKMDXIndex' then
    FIndexType := itMDX
  else if ItemClass.ClassName = 'TVKCDXIndex' then
    FIndexType := itCDX
  else
    FIndexType := itNotDefined;
  FActiveObject := nil;
end;

function TIndexes.CreateIndex(IndexName: AnsiString): TIndex;
begin
  case FIndexType of
    itNotDefined: raise Exception.Create('TIndex: IndexType not defined.');
    itNTX: Result := Add as TVKNTXIndex;
    //itNDX: Result := Add as TVKNDXIndex;
    //itMDX: Result := Add as TVKMDXIndex;
    itCDX: Result := Add as TVKCDXIndex;
  else
    Result := Add as TIndex;
  end;
  Result.Name := IndexName;
end;

function TIndexes.FindIndex(const Value: AnsiString): TIndex;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TIndex(inherited Items[I]);
    if AnsiCompareText(Result.Name, Value) = 0 then Exit;
  end;
  Result := nil;
end;

{$IFDEF VER130}
function TIndexes.GetCollectionOwner: TPersistent;
begin
  Result := GetOwner;
end;
{$ENDIF}

function TIndexes.GetItem(Index: Integer): TIndex;
begin
  Result := TIndex(inherited Items[Index]);
end;

function TIndexes.IsEqual(Value: TIndexes): Boolean;
var
  I: Integer;
begin
  Result := (Count = Value.Count);
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := TIndex(Items[I]).IsEqual(TIndex(Value.Items[I]));
      if not Result then Break;
    end
end;

procedure TIndexes.SetItem(Index: Integer; const Value: TIndex);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

{ TIndex }

procedure TIndex.AddKey(sKey: AnsiString; nRec: Integer);
begin
  //
end;

procedure TIndex.Assign(Source: TPersistent);
begin
  if Source is TIndex then
    AssignIndex(TIndex(Source))
  else
    inherited Assign(Source);
end;

procedure TIndex.AssignIndex(oInd: TIndex);
begin
  if oInd <> nil then
  begin
    Name := oInd.Name;
  end;
end;

procedure TIndex.Close;
begin
  //
end;

constructor TIndex.Create(Collection: TCollection);
var
  i: Byte;
begin
  inherited Create(Collection);
  //Collations support
  FAllowSetCollationType := False;
  FCollation := TVKCollation.Create;
  FCollationType := cltNone;
  FCustomCollatingSequence := '';
  for i := 0 to 255 do begin
    FCustomCollatingTable[i] := i;
    FCustomCollatingSequence := FCustomCollatingSequence + IntToStr(i) + ';'
  end;
  FCollatingTable := nil;
  //
  FLimitPages := TVKLimitIndexPages.Create;
  FOuterSorterProperties := TVKOuterSorterProperties.Create;
  FIndexes := TIndexes(Collection);
  b_R := false;
  //
  FHashTypeForTreeSorters := httsDefault;
  FMaxBitsInHashCode := mbhc32;
  //
end;

procedure TIndex.CreateIndex(Activate: boolean; PreSorterBlockSize: LongWord);
begin
  //
end;

procedure TIndex.DeleteKey(sKey: AnsiString; nRec: Integer);
begin
  //
end;

destructor TIndex.Destroy;
begin
  FreeAndNil(FCollation);
  FreeAndNil(FLimitPages);
  FreeAndNil(FOuterSorterProperties);
  inherited Destroy;
end;

function TIndex.EvaluteForExpr: boolean;
begin
  Result := false;
end;

function TIndex.EvaluteKeyExpr: AnsiString;
begin
  Result := '';
end;

function TIndex.FillFirstBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar;
  FRecordsPerBuf, FRecordSize: Integer;
  FBufInd: pLongint; data_offset: Word): longint;
begin
  Result := 0;
end;

function TIndex.FillLastBufRecords(DBFHandler: TProxyStream; FBuffer: pAnsiChar;
  FRecordsPerBuf, FRecordSize: Integer; FBufInd: pLongint;
  data_offset: Word): longint;
begin
  Result := 0;
end;

procedure TIndex.First;
begin
  //
end;

function TIndex.FLock: boolean;
begin
  Result := false;
end;

function TIndex.FUnLock: boolean;
begin
  Result := false;
end;

function TIndex.GetCurrentKey: AnsiString;
begin
  Result := '';
end;

function TIndex.GetCurrentRec: DWORD;
begin
  Result := 0;
end;

function TIndex.GetDisplayName: string;
begin
  if Name <> '' then
    Result := Name
  else
    Result := inherited GetDisplayName;
end;

function TIndex.GetFirstByIndex(var cRec: Integer): TGetResult;
begin
  Result := grError;
end;

function TIndex.GetLastByIndex(var cRec: Integer): TGetResult;
begin
  Result := grError;
end;

function TIndex.GetRecordByIndex(GetMode: TGetMode;
  var cRec: Integer): TGetResult;
begin
  Result := grError;
end;

function TIndex.InternalFirst: TGetResult;
begin
  Result := grError;
end;

function TIndex.InternalLast: TGetResult;
begin
  Result := grError;
end;

function TIndex.InternalNext: TGetResult;
begin
  Result := grError;
end;

function TIndex.InternalPrior: TGetResult;
begin
  Result := grError;
end;

function TIndex.IsEqual(Value: TIndex): Boolean;
begin
  Result := false;
end;

function TIndex.IsOpen: boolean;
begin
  Result := false;
end;

procedure TIndex.Last;
begin
  //
end;

function TIndex.LastKey(out LastKey: AnsiString; out LastRec: Integer): boolean;
begin
  LastKey := '';
  LastRec := -1;
  Result := false;
end;

procedure TIndex.Next;
begin
  //
end;

function TIndex.NextBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint;
begin
  Result := 0;
end;

function TIndex.Open: boolean;
begin
  Result := false;
end;

procedure TIndex.Prior;
begin
  //
end;

function TIndex.PriorBuffer(DBFHandler: TProxyStream; FBuffer: pAnsiChar; FRecordsPerBuf: Integer; FRecordSize: Integer; FBufInd: pLongint; data_offset: Word): Longint;
begin
  Result := 0;
end;

function TIndex.Seek(Key: AnsiString; SoftSeek: boolean): boolean;
begin
  Result := false;
end;

function TIndex.SeekFields(const KeyFields: AnsiString;
  const KeyValues: Variant; SoftSeek: boolean = false;
  PartialKey: boolean = false): Integer;
begin
  Result := 0;
end;

function TIndex.SeekFirst(Key: AnsiString; SoftSeek: boolean = false;
                          PartialKey: boolean = false): boolean;
begin
  Result := false;
end;

procedure TIndex.SetActive(const Value: boolean);
var
  i: Integer;
  oW: TVKDBFNTX;
  R: Integer;
begin
  if FActive <> Value then begin
    oW := TVKDBFNTX(FIndexes.Owner);
    if Value then begin
      try
        b_R := true;
        for i := 0 to FIndexes.Count - 1 do
          FIndexes.Items[i].Active := false;
      finally
        b_R := false;
      end;
      FIndexes.FActiveObject := self;
      FActive := true;
      if oW.Active then begin
        R := FindKey(EvaluteKeyExpr, False, True, oW.RecNo);
        if R <> 0 then begin
          oW.RecNo := R;
        end else
          oW.First;
      end;
    end else begin
      if ( FIndexes.FActiveObject <> nil ) and ( FIndexes.FActiveObject = self ) then begin
        FIndexes.FActiveObject := nil;
        if not b_R then if oW.Active then oW.RecNo := oW.RecNo;
      end;
    end;
    FActive := Value;
  end;
end;

function TIndex.SetToRecord: boolean;
begin
  Result := false;
end;

function TIndex.SetToRecord(Key: AnsiString; Rec: Integer): boolean;
begin
  Result := false;
end;

procedure TIndex.SetRangeFields(FieldList: AnsiString;
  FieldValues: array of const);
begin
  //
end;

procedure TIndex.SetRangeFields(FieldList: AnsiString; FieldValues: variant);
begin
  //
end;

function TIndex.SetToRecord(Rec: Integer): boolean;
begin
  Result := false;
end;

function TIndex.SubIndex(LowKey, HiKey: AnsiString): boolean;
begin
  Result := false;
end;

function TIndex.SuiteFieldList(fl: AnsiString; out m: Integer): Integer;
begin
  m := 0;
  Result := 0;
end;

function TIndex.GetIsRanged: boolean;
begin
  Result := false;
end;

function TIndex.InRange(Key: AnsiString): boolean;
begin
  Result := false;
end;

procedure TIndex.Flush;
begin
  //
end;

procedure TIndex.Reindex(Activate: boolean = true);
begin
  //
end;

procedure TIndex.StartUpdate(UnLock: boolean = true);
begin
//
end;

function TIndex.SeekFirstRecord(Key: AnsiString; SoftSeek: boolean = false;
                                PartialKey: boolean = false): Integer;
begin
  Result := 0;
end;

procedure TIndex.Truncate;
begin
//
end;

procedure TIndex.BeginCreateIndexProcess;
begin
  //
end;

procedure TIndex.EndCreateIndexProcess;
begin
  //
end;

procedure TIndex.EvaluteAndAddKey(nRec: DWORD);
begin
  //
end;

procedure TIndex.CreateCompactIndex(BlockBufferSize: LongWord;
  Activate: boolean;
  CreateTmpFilesInCurrentDir: boolean);
begin
  //
end;

function TIndex.InRange: boolean;
begin
  Result := false;
end;

function TIndex.FindKey(  Key: AnsiString; PartialKey: boolean = false;
                          SoftSeek: boolean = false; Rec: DWORD = 0): Integer;
begin
  Result := 0;
end;

function TIndex.FindKeyFields(const KeyFields: Ansistring;
  const KeyValues: Variant; PartialKey: boolean;
  SoftSeek: boolean): Integer;
begin
  Result := 0;
end;

procedure TIndex.ArrayOfConstant2Variant(const InputValue: array of const;
  var Value: Variant);
var
  i: Integer;
begin
  Value := VarArrayCreate([0, High(InputValue)], varVariant);
  for i := 0 to High(InputValue) do
    begin
      case InputValue[I].VType of
        vtInteger:    Value[i] := InputValue[I].VInteger;
        vtBoolean:    Value[i] := InputValue[I].VBoolean;
        vtChar:       Value[i] := InputValue[I].VChar;
        vtExtended:   Value[i] := InputValue[I].VExtended^;
        vtString:     Value[i] := InputValue[I].VString^;
        //vtPChar:      Value[i] := VPChar;
        //vtObject:     Value[i] := VObject;
        //vtClass:      Value[i] := VClass;
        vtAnsiString: Value[i] := AnsiString(InputValue[I].VAnsiString^);
        vtCurrency:   Value[i] := InputValue[I].VCurrency^;
        vtVariant:    Value[i] := InputValue[I].VVariant^;
        //vtInt64:      Value[i] := VInt64^;
        vtWideString: Value[i] := WideString(InputValue[I].VVariant);
        vtUnicodeString: Value[i] := WideString(UnicodeString(InputValue[I].VUnicodeString));
        else
          raise Exception.Create('TIndex.ArrayOfConstant2Variant: Unsupported type ['+IntToStr(InputValue[I].VType)+'].');
      end;
    end;
end;

function TIndex.FindKeyFields(const KeyFields: AnsiString;
  const KeyValues: array of const; PartialKey: boolean;
  SoftSeek: boolean): Integer;
begin
  Result := 0;
end;

function TIndex.FindKeyFields(PartialKey: boolean = false;
SoftSeek: boolean = false): Integer;
begin
  Result := 0;
end;

function TIndex.IsForIndex: boolean;
begin
  Result := False;
end;

function TIndex.IsUniqueIndex: boolean;
begin
  Result := False;
end;

function TIndex.GetOrder: AnsiString;
begin
  Result := Name;
end;

procedure TIndex.SetOrder(Value: AnsiString);
begin
  Name := Value;
end;

procedure TIndex.DefineBagAndOrder;
begin
  //
end;

procedure TIndex.DefineBag;
begin
  //
end;

procedure TIndex.SetCollationType(const Value: TVKCollationTypes);
var
  i, j, b, e: Integer;
  s: String;
  bt, k: Byte;
begin
  if not FAllowSetCollationType then
    if IsOpen then
      raise Exception.Create('TIndex.SetCollationType: You can set collation type only when index is not open!');
  FCollationType := Value;
  case FCollationType of
    cltNone           : FCollatingTable := nil;
    cltCustom         :
      begin
        // Fill FCustomCollatingTable from FCustomCollatingSequence string
        for bt := 0 to 255 do
          FCustomCollatingTable[bt] := bt;
        i := 1;
        j := Length(FCustomCollatingSequence);
        k := 0;
        b := 1;
        while i <= j do begin
          if FCustomCollatingSequence[i] = ';' then begin
            e := i;
            s := Copy(FCustomCollatingSequence, b, e - b);
            try
              bt := Byte(StrToInt(s));
              FCustomCollatingTable[k] := bt;
            except
            end;
            Inc(k);
            b := Succ(i);
          end;
          Inc(i);
        end;
        //
        FCollatingTable := @FCustomCollatingTable[0];
      end;
    cltClipper501Rus        : FCollatingTable := @VKDBFCollate.Clipper501RusOrder[0];
    cltGermanCollation      : FCollatingTable := @VKDBFCollate.GermanCollation[0];
    cltFrenchCollation      : FCollatingTable := @VKDBFCollate.FrenchCollation[0];
    cltSpanishCollation     : FCollatingTable := @VKDBFCollate.SpanishCollation[0];
    cltItalianCollation     : FCollatingTable := @VKDBFCollate.ItalianCollation[0];
    cltSwedishCollation     : FCollatingTable := @VKDBFCollate.SwedishCollation[0];
    cltPortugueseCollation  : FCollatingTable := @VKDBFCollate.PortugueseCollation[0];
    cltNorwegianCollation   : FCollatingTable := @VKDBFCollate.NorwegianCollation[0];
    cltFinnishCollation     : FCollatingTable := @VKDBFCollate.FinnishCollation[0];
    cltDutchCollation       : FCollatingTable := @VKDBFCollate.DutchCollation[0];
    cltDanishCollation      : FCollatingTable := @VKDBFCollate.DanishCollation[0];
    cltGreek437Collation    : FCollatingTable := @VKDBFCollate.Greek437Collation[0];
    cltGreek851Collation    : FCollatingTable := @VKDBFCollate.Greek851Collation[0];
    cltIcelandic850Collation: FCollatingTable := @VKDBFCollate.Icelandic850Collation[0];
    cltIcelandic861Collation: FCollatingTable := @VKDBFCollate.Icelandic861Collation[0];
    cltPolish852Collation   : FCollatingTable := @VKDBFCollate.Polish852Collation[0];
    cltHungarianCWICollation: FCollatingTable := @VKDBFCollate.HungarianCWICollation[0];
    cltHungarian852Collation: FCollatingTable := @VKDBFCollate.Hungarian852Collation[0];
  else
    FCollationType := cltNone;
  end;
end;

procedure TIndex.SetCollation(const Value: TVKCollation);
begin
  FCollation.CollationType := Value.CollationType;
  FCollation.CustomCollatingSequence := Value.CustomCollatingSequence;
end;

procedure TIndex.SetLimitPages(const Value: TVKLimitIndexPages);
begin
  FLimitPages.LimitPagesType := Value.LimitPagesType;
  FLimitPages.LimitBuffers     := Value.LimitBuffers;
  FLimitPages.PagesPerBuffer   := Value.PagesPerBuffer;
end;

function TIndex.GetIndexBag: TVKDBFIndexBag;
begin
  Result := nil;
end;

function TIndex.GetIndexOrder: TVKDBFOrder;
begin
  Result := nil;
end;

procedure TIndex.CreateIndexUsingQuickSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKQuickSorter, Activate);
end;

procedure TIndex.CreateIndexUsingSorter(SorterClass: TVKSorterClass;
  Activate: boolean);
begin
  //
end;

(*
procedure TIndex.CreateIndexUsingSorter1(SorterClass: TVKSorterClass;
  Activate: boolean);
begin
  //
end;
*)

procedure TIndex.CreateIndexUsingTreeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKBinaryTreeSorter, Activate);
end;

procedure TIndex.CreateIndexUsingRBTreeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKRedBlackTreeSorter, Activate);
end;

procedure TIndex.CreateIndexUsingAVLTreeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKAVLTreeSorter, Activate);
end;

procedure TIndex.GetVKHashCode(Sender: TObject; Item: PSORT_ITEM;
  out HashCode: DWord);
begin
  HashCode := 0;
end;

(*
procedure TIndex.CreateIndexUsingMergeBinaryTreeAndBTree(
  TreeSorterClass: TVKBinaryTreeSorterClass;
  Activate: boolean = True;
  PreSorterBlockSize: LongWord = 4096);
begin
  //
end;
*)

(*
procedure TIndex.CreateIndexUsingBTreeHeapSort(Activate: boolean);
begin
  //
end;
*)

(*
procedure TIndex.CreateIndexUsingFindMinsAndJoinItToBTree(
  TreeSorterClass: TVKBinaryTreeSorterClass; Activate: boolean;
  PreSorterBlockSize: LongWord);
begin
  //
end;
*)

(*
procedure TIndex.CreateIndexUsingAbsorption(
  TreeSorterClass: TVKBinaryTreeSorterClass; Activate: boolean;
  PreSorterBlockSize: LongWord);
begin
  //
end;
*)

procedure TIndex.CreateIndexUsingTrieTreeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKTrieTreeSorter, Activate);
end;

(*
procedure TIndex.CreateIndexUsingAbsorptionSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKAbsorptionSorter, Activate);
end;
*)

procedure TIndex.CreateIndexUsingMergeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVKMergeSorter, Activate);
end;

procedure TIndex.CreateIndexUsing4PathMergeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVK4PathMergeSorter);
end;

procedure TIndex.CreateIndexUsing8PathMergeSort(Activate: boolean);
begin
  CreateIndexUsingSorter(TVK8PathMergeSorter);
end;

procedure TIndex.SetOuterSorterProperties(
  const Value: TVKOuterSorterProperties);
begin
  FOuterSorterProperties.TmpPath                := Value.TmpPath;
  FOuterSorterProperties.InnerSorterClass       := Value.InnerSorterClass;
  FOuterSorterProperties.SortItemPerInnerSorter := Value.SortItemPerInnerSorter;
  FOuterSorterProperties.BufferSize             := Value.BufferSize;
end;

procedure TIndex.SetRangeFields(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: variant);
begin
  //
end;

procedure TIndex.SetRangeFields(FieldList: AnsiString; FieldValuesLow,
  FieldValuesHigh: array of const);
begin
  //
end;

function TIndex.ReCrypt(pNewCrypt: TVKDBFCrypt): boolean;
begin
  Result := False;
end;

procedure TIndex.VerifyIndex;
begin
  //
end;

{ TVKDBFIndexBag }

procedure TVKDBFIndexBag.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

procedure TVKDBFIndexBag.Close;
begin
  Handler.Close;
end;

constructor TVKDBFIndexBag.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FName := 'TVKDBFIndexBag' + IntToStr(Index);
  with Collection as TVKDBFIndexDefs do begin
    case FIndexType of
      itNTX: FOrders := TVKDBFOrders.Create(self, TVKNTXOrder);
      //itNDX:
      //itMDX:
      //itIDX:
      itCDX: FOrders := TVKDBFOrders.Create(self, TVKCDXOrder);
    else
      FOrders := TVKDBFOrders.Create(self, TVKDBFOrder);
    end;
  end;
  Handler := TProxyStream.Create;
  FStorageType := pstFile;
end;

function TVKDBFIndexBag.CreateBag: boolean;
begin
  Result := False;
end;

procedure TVKDBFIndexBag.DefineProperties(Filer: TFiler);

  function WriteOrderDataB: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FOrders.IsEqual(TVKDBFIndexBag(Filer.Ancestor).FOrders)
    else
      Result := (FOrders.Count > 0);
  end;

begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Orders', ReadOrderData, WriteOrderData, WriteOrderDataB);
end;

destructor TVKDBFIndexBag.Destroy;
begin
  FreeAndNil(FOrders);
  FreeAndNil(Handler);
  inherited Destroy;
end;

function TVKDBFIndexBag.GetDisplayName: string;
begin
  Result := Name;
end;

function TVKDBFIndexBag.GetInnerStream: TStream;
begin
  Result := Handler.InnerStream;
end;

function TVKDBFIndexBag.GetOwnerTable: TDataSet;
begin
  Result := (Collection as TVKDBFIndexDefs).OwnerTable;
end;

function TVKDBFIndexBag.IsEqual(Value: TVKDBFIndexBag): Boolean;
begin
  Result := false;
end;

function TVKDBFIndexBag.IsOpen: boolean;
begin
  Result := False;
end;

function TVKDBFIndexBag.Open: boolean;
begin
  Result := False;
end;

procedure TVKDBFIndexBag.ReadOrderData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(FOrders);
end;

procedure TVKDBFIndexBag.SetIndexFileName(const Value: AnsiString);
begin
  FIndexFileName := Value;
  if FName = 'TVKDBFIndexBag' + IntToStr(Index) then
    FName := ChangeFileExt(ExtractFileName(FIndexFileName), '');
  Handler.FileName := FIndexFileName;
end;

procedure TVKDBFIndexBag.SetOrders(const Value: TVKDBFOrders);
begin
  FOrders.Assign(Value);
end;

procedure TVKDBFIndexBag.WriteOrderData(Writer: TWriter);
begin
  Writer.WriteCollection(FOrders);
end;

{ TVKDBFIndexDefs }

procedure TVKDBFIndexDefs.AssignValues(Value: TVKDBFIndexDefs);
var
  I: Integer;
  P: TVKDBFIndexBag;
begin
  for I := 0 to Value.Count - 1 do
  begin
    P := FindIndex(Value[I].Name);
    if P <> nil then
      P.Assign(Value[I]);
  end;
end;


constructor TVKDBFIndexDefs.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClass);
  if ItemClass.ClassName = 'TVKNTXBag' then
    FIndexType := itNTX
  else if ItemClass.ClassName = 'TVKNDXBag' then
    FIndexType := itNDX
  else if ItemClass.ClassName = 'TVKMDXBag' then
    FIndexType := itMDX
  else if ItemClass.ClassName = 'TVKCDXBag' then
    FIndexType := itCDX
  else
    FIndexType := itNotDefined;
end;

function TVKDBFIndexDefs.FindIndex(const Value: AnsiString): TVKDBFIndexBag;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TVKDBFIndexBag(inherited Items[I]);
    if AnsiCompareText(Result.Name, Value) = 0 then Exit;
  end;
  Result := nil;
end;

{$IFDEF VER130}
function TVKDBFIndexDefs.GetCollectionOwner: TPersistent;
begin
  Result := GetOwner;
end;
{$ENDIF}

function TVKDBFIndexDefs.GetItem(Index: Integer): TVKDBFIndexBag;
begin
  Result := TVKDBFIndexBag(inherited Items[Index]);
end;

function TVKDBFIndexDefs.GetOwnerTable: TDataSet;
begin
  Result := Owner as TDataSet;
end;

function TVKDBFIndexDefs.IsEqual(Value: TVKDBFIndexDefs): Boolean;
var
  I: Integer;
begin
  Result := (Count = Value.Count);
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := TVKDBFIndexBag(Items[I]).IsEqual(TVKDBFIndexBag(Value.Items[I]));
      if not Result then Break;
    end
end;

procedure TVKDBFIndexDefs.SetItem(Index: Integer;
  const Value: TVKDBFIndexBag);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

{ TVKDBFOrders }

procedure TVKDBFOrders.AssignValues(Value: TVKDBFOrders);
var
  I: Integer;
  P: TVKDBFOrder;
begin
  for I := 0 to Value.Count - 1 do
  begin
    P := FindIndex(Value[I].Name);
    if P <> nil then
      P.Assign(Value[I]);
  end;
end;

constructor TVKDBFOrders.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClass);
end;

function TVKDBFOrders.FindIndex(const Value: AnsiString): TVKDBFOrder;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TVKDBFOrder(inherited Items[I]);
    if AnsiCompareText(Result.Name, Value) = 0 then Exit;
  end;
  Result := nil;
end;

{$IFDEF VER130}
function TVKDBFOrders.GetCollectionOwner: TPersistent;
begin
  Result := GetOwner;
end;
{$ENDIF}

function TVKDBFOrders.GetItem(Index: Integer): TVKDBFOrder;
begin
  Result := TVKDBFOrder(inherited Items[Index]);
end;

function TVKDBFOrders.GetOwnerTable: TDataSet;
begin
  Result := (Owner as TVKDBFIndexBag).OwnerTable;
end;

function TVKDBFOrders.IsEqual(Value: TVKDBFOrders): Boolean;
var
  I: Integer;
begin
  Result := (Count = Value.Count);
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := TVKDBFOrder(Items[I]).IsEqual(TVKDBFOrder(Value.Items[I]));
      if not Result then Break;
    end
end;

procedure TVKDBFOrders.SetItem(Index: Integer; const Value: TVKDBFOrder);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

{ TVKDBFOrder }

procedure TVKDBFOrder.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

constructor TVKDBFOrder.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCollation := TVKCollation.Create;
  FLimitPages := TVKLimitIndexPages.Create;
  FOuterSorterProperties := TVKOuterSorterProperties.Create;
  FName := 'TVKDBFOrder' + IntToStr(Index);
end;

function TVKDBFOrder.CreateOrder: boolean;
begin
  Result := False;
end;

destructor TVKDBFOrder.Destroy;
var
  ds: TVKSmartDBF;
  Indexes: TIndexes;
  i: Integer;
begin
  // Find the Index object according to this Order object and destroy it
  ds := TVKSmartDBF(OwnerTable);
  if ds <> nil then begin
    Indexes := ds.Indexes;
    if Indexes <> nil then begin
      for i := 0 to pred(Indexes.Count) do begin
        if Indexes[i].IndexOrder = self then begin
          Indexes[i].Close;
          Indexes.Delete(i);
          break;
        end;
      end;
    end;
  end;
  FreeAndNil(FCollation);
  FreeAndNil(FLimitPages);
  FreeAndNil(FOuterSorterProperties);
  inherited Destroy;
end;

function TVKDBFOrder.GetDisplayName: string;
begin
  Result := Name;
end;

function TVKDBFOrder.GetOwnerTable: TDataSet;
begin
  Result := (Collection as TVKDBFOrders).OwnerTable;
end;

function TVKDBFOrder.IsEqual(Value: TVKDBFOrder): Boolean;
begin
  Result := false;
end;

procedure TVKDBFOrder.SetCollation(const Value: TVKCollation);
begin
  FCollation.CollationType := Value.CollationType;
  FCollation.CustomCollatingSequence := Value.CustomCollatingSequence;
end;

procedure TVKDBFOrder.SetLimitPages(const Value: TVKLimitIndexPages);
begin
  FLimitPages.LimitPagesType := Value.LimitPagesType;
  FLimitPages.LimitBuffers   := Value.LimitBuffers;
  FLimitPages.PagesPerBuffer := Value.PagesPerBuffer;
end;

procedure TVKDBFOrder.SetOuterSorterProperties(
  const Value: TVKOuterSorterProperties);
begin
  FOuterSorterProperties.TmpPath                := Value.TmpPath;
  FOuterSorterProperties.InnerSorterClass       := Value.InnerSorterClass;
  FOuterSorterProperties.SortItemPerInnerSorter := Value.SortItemPerInnerSorter;
  FOuterSorterProperties.BufferSize             := Value.BufferSize;
end;

{ TVKLimitIndexPages }

constructor TVKLimitIndexPages.Create;
begin
  inherited Create;
  FLimitBuffers := 0;
  FPagesPerBuffer := 4;
  FLimitPagesType := lbtAuto;
end;

{ TVKCollation }

constructor TVKCollation.Create;
var
  i: Byte;
begin
  inherited Create;
  FCollationType := cltNone;
  FCustomCollatingSequence := '';
  for i := 0 to 255 do begin
    FCustomCollatingSequence := FCustomCollatingSequence + IntToStr(i) + ';'
  end;
end;

{ TVKOuterSorterProperties }

constructor TVKOuterSorterProperties.Create;
begin
  inherited Create;
  FBufferSize := 65536;
  FSortItemPerInnerSorter := -32;
  FTmpPath := '';
  FInnerSorterClass := TVKAVLTreeSorter;
end;

end.



