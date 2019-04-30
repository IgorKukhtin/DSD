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
unit VKDBFSorters;

interface

uses
  Windows, SysUtils, Classes, contnrs, VKDBFMemMgr, VKDBFPrx, Dialogs;

const
  MAX_SORTER_KEY_SIZE = 1024;  //
  COLOR_BLACK = 0;
  COLOR_RED = 1;
  NULL_REF = DWord(-1);

type

  //
  //  item for sorters
  //
  SORT_ITEM = packed record
    Hash: DWORD;
    RID: DWORD;
    case Boolean of
      True: (
        key: array[0..pred(MAX_SORTER_KEY_SIZE)] of Byte;
        );
      False: (
        key_of_char: array[0..pred(MAX_SORTER_KEY_SIZE)] of AnsiChar;
        );
  end;
  pSORT_ITEM = ^SORT_ITEM;

  THashTableSizeType = (htst1, htst2, htst4, htst8, htst16, htst32, htst64,
                        htst128, htst256, htst512, htst1024, htst2048, htst4096,
                        htst8192, htst16384, htst32768, htst65536, htst131072,
                        htst262144, htst524288, htst1048576, htst2097152,
                        htst4194304, htst8388608, htst16777216, htst33554432,
                        htst67108864, htst134217728, htst268435456,
                        htst536870912, htst1073741824, htst2147483648,
                        htst4294967296);
  TMaxBitsInHashCode = (mbhc0, mbhc1, mbhc2, mbhc3, mbhc4, mbhc5, mbhc6, mbhc7,
                        mbhc8, mbhc9, mbhc10, mbhc11, mbhc12, mbhc13, mbhc14,
                        mbhc15, mbhc16, mbhc17, mbhc18, mbhc19, mbhc20, mbhc21,
                        mbhc22, mbhc23, mbhc24, mbhc25, mbhc26, mbhc27, mbhc28,
                        mbhc29, mbhc30, mbhc31, mbhc32);

  TOnCompareSortItems = procedure(Sender: TObject; CurrentItem, Item: PSORT_ITEM; MaxLen: Cardinal; out c: Integer) of object;
  TOnCompareChars = procedure(Sender: TObject; Char1, Char2: Byte; out c: Integer) of object;
  TOnCompareRIDs = procedure(Sender: TObject; CurrentRID, ItemRID: DWord; out c: Integer) of object;
  TOnGetHashCode = procedure(Sender: TObject; Item: PSORT_ITEM; out HashCode: DWord) of object;

  //Forword declarations
  TVKInnerSorter = class;
  TVKInnerSorterClass = class of TVKInnerSorter;
  TVKOuterSorter = class;
  TVKOuterSorterClass = class of TVKOuterSorter;

  {TVKSorterAbstract}
  TVKSorterAbstract = class
  protected
    FKeyPoolCount: DWord;
    FKeyPool: Pointer;
    FSortArray: PDWord;
    FKeySize: Word;
    FRecordsCount: DWord;
    FCompareMethod: TOnCompareSortItems;
    FCompareCharsMethod: TOnCompareChars;
    FCompareRIDsMethod: TOnCompareRIDs;
    FUnique: boolean;
    FHashTableSize: THashTableSizeType;
    FHashTableSizeValue: DWord;
    FMaxBitsInHashCode: TMaxBitsInHashCode;
    FHashShift: DWord;
    FNormalizeCoeff: DWord;
    FNormalizeCoeffNeg: DWord;
    FGetHashCodeMethod: TOnGetHashCode;
    FStandardHash: boolean;
    FCurrentItem: DWord;
    FDynamicSortHash: boolean;
    FTmpStream: TProxyStream;
    FInnerSorterClass: TVKInnerSorterClass;
    FBufferSize: DWord;
    FInnerSorterItemsCount: Integer;
    function GetSortArray(ndx: DWord): DWord; virtual;
    procedure SetSortArray(ndx: DWord; const Value: DWord); virtual;
    function GetSortItem(ndx: DWord): SORT_ITEM; virtual;
    procedure SetSortItem(ndx: DWord; const Value: SORT_ITEM); virtual;
    //function GetKey(ndx: DWord): PByte; virtual;
    //function GetRecNo(ndx: DWord): DWord; virtual;
    //procedure SetKey(ndx: DWord; const Value: PByte); virtual;
    //procedure SetRecNo(ndx: DWord; const Value: DWord); virtual;
    function GetPSortItem(ndx: DWord): PSORT_ITEM; virtual;
    function AddNewItem(var item: SORT_ITEM): boolean; virtual;
  protected
    procedure GetVKHashCode(Sender: TObject; Item: PSORT_ITEM; out HashCode: DWord); virtual;
    function Hash(Item: PSORT_ITEM): DWord; virtual;
    function GetCurrentSortItem: PSORT_ITEM; virtual; abstract;
    procedure AllocateSpace; virtual;
    procedure ReleaseSpace; virtual;
  public
    constructor Create( RecordsCount: DWord;
                        KeySize: Word;
                        CompareMethod: TOnCompareSortItems;
                        CompareCharsMethod: TOnCompareChars = nil;
                        CompareRIDsMethod: TOnCompareRIDs = nil;
                        UniqueFeature: boolean = false;
                        HashTableSizePar: THashTableSizeType = htst256;
                        GetHashCodeMethod: TOnGetHashCode = nil;
                        MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                        DynamicSortHash: boolean = false;
                        TmpStream: TProxyStream = nil;
                        InnerSorterClass: TVKInnerSorterClass = nil;
                        BufferSize: Integer = 4096;
                        InnerSorterItemsCount: Integer = 0); virtual;
    destructor Destroy; override;
    function CompareItems(CurrentItem, Item: PSORT_ITEM; out c: Integer): Integer;
    function AddItem(var item: SORT_ITEM): boolean; virtual;
    procedure Sort; virtual; abstract;
    procedure Clear; virtual;
    function FirstSortItem: boolean; virtual; abstract;
    function NextSortItem: boolean; virtual; abstract;
    property CountRecords: DWord read FRecordsCount;
    property CountAddedItems: DWord read FKeyPoolCount;
    property SortArray[ndx: DWord]: DWord read GetSortArray write SetSortArray;
    property SortItem[ndx: DWord]: SORT_ITEM read GetSortItem write SetSortItem;
    property PSortItem[ndx: DWord]: PSORT_ITEM read GetPSortItem;
    //property Key[ndx: DWord]: PByte read GetKey write SetKey;
    //property RecNo[ndx: DWord]: DWord read GetRecNo write SetRecNo;
    property Unique: boolean read FUnique;
    property HashTableSize: THashTableSizeType read FHashTableSize;
    property HashTableSizeValue: DWord read FHashTableSizeValue;
    property MaxBitsInHashCode: TMaxBitsInHashCode read FMaxBitsInHashCode;
    property HashShift: DWord read FHashShift;
    property CurrentSortItem: PSORT_ITEM read GetCurrentSortItem;
    property CurrentItem: DWord read FCurrentItem;
    property OnGetHashCode: TOnGetHashCode read FGetHashCodeMethod;
    property OnCompare: TOnCompareSortItems read FCompareMethod;
    property OnCompareRIDs: TOnCompareRIDs read FCompareRIDsMethod;
  end;
  TVKSorterClass = class of TVKSorterAbstract;

  {TVKInnerSorter}
  TVKInnerSorter = class(TVKSorterAbstract)
  end;

  {TVKOuterSorter}
  TVKOuterSorter = class(TVKSorterAbstract)
  end;

  {TVKQuickSorter}
  TVKQuickSorter = class(TVKInnerSorter)
  protected
    function GetCurrentSortItem: PSORT_ITEM; override;
  public
    constructor Create( RecordsCount: DWord;
                        KeySize: Word;
                        CompareMethod: TOnCompareSortItems;
                        CompareCharsMethod: TOnCompareChars = nil;
                        CompareRIDsMethod: TOnCompareRIDs = nil;
                        UniqueFeature: boolean = false;
                        HashTableSize: THashTableSizeType = htst256;
                        GetHashCodeMethod: TOnGetHashCode = nil;
                        MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                        DynamicSortHash: boolean = false;
                        TmpStream: TProxyStream = nil;
                        InnerSorterClass: TVKInnerSorterClass = nil;
                        BufferSize: Integer = 4096;
                        InnerSorterItemsCount: Integer = 0); override;
    procedure Sort; override;
    function FirstSortItem: boolean; override;
    function NextSortItem: boolean; override;
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property HashTableSize;
    property HashTableSizeValue;
    property HashShift;
    property CurrentSortItem;
    property CurrentItem;
    property OnGetHashCode;
    property OnCompare;
    property OnCompareRIDs;
  end;

  {TVKBinaryTreeSorterAbstract}
  TVKBinaryTreeSorterAbstract = class(TVKInnerSorter)
  protected
    FCurrentSrtItem: DWord;
    procedure AllocateTree(RecordsCount: DWord); virtual; abstract;
    procedure InitTree; virtual; abstract;
    procedure OnInitTree(i: Integer); virtual; abstract;
    procedure FreeTree; virtual; abstract;
    function AddItemInTree(point: DWord): boolean; virtual; abstract;
    procedure DeleteItemFromTree(point: DWord); virtual; abstract;
  public
    function GetLastSortItem(var point: DWord): boolean; virtual; abstract;
    function AddItemInTreeByEntry(point: DWord): boolean; virtual;
    procedure DeleteFromTreeByEntry(point: DWord); virtual;
    property CurrentSortItem;
    property CurrentItem;
  end;
  TVKBinaryTreeSorterClass = class of TVKBinaryTreeSorterAbstract;

  {TVKBinaryTreeSorter}
  TVKBinaryTreeSorter = class(TVKBinaryTreeSorterAbstract)
  private
    Flson: PDWord;
    Frson: PDWord;
    Fdad: PDWord;
    Flsrt: PDWord;
    Frsrt: PDWord;
    Fdsrt: PDWord;
    Fcsrt: PDWord;
    function GetDad(ndx: DWord): DWord;
    function GetLson(ndx: DWord): DWord;
    function GetRson(ndx: DWord): DWord;
    procedure SetDad(ndx: DWord; const Value: DWord);
    procedure SetLson(ndx: DWord; const Value: DWord);
    procedure SetRson(ndx: DWord; const Value: DWord);
    function GetLsrt(ndx: DWord): DWord;
    function GetRsrt(ndx: DWord): DWord;
    procedure SetLsrt(ndx: DWord; const Value: DWord);
    procedure SetRsrt(ndx: DWord; const Value: DWord);
    function GetDsrt(ndx: DWord): DWord;
    procedure SetDsrt(ndx: DWord; const Value: DWord);
    function GetCsrt(ndx: DWord): DWord;
    procedure SetCsrt(ndx: DWord; const Value: DWord);
    procedure LRsrt(point: DWord);
    procedure RRsrt(point: DWord);
    procedure AddItemInSrtTree(point: DWord);
  protected
    FNILL: DWord;
    FNULL: DWord;
    procedure DeleteItemFromSrtTree(DelNode: DWord);
    procedure DeleteNodeFromSrtTree(point: DWord);
    procedure LeftRotate(point: DWord);
    procedure RightRotate(point: DWord);
    function GetCurrentSortItem: PSORT_ITEM; override;
    procedure AllocateTree(RecordsCount: DWord); override;
    procedure InitTree; override;
    procedure OnInitTree(i: Integer); override;
    procedure FreeTree; override;
    function AddItemInTree(point: DWord): boolean; override;
    procedure DeleteItemFromTree(point: DWord); override;
    property lson[ndx: DWord]: DWord read GetLson write SetLson;
    property rson[ndx: DWord]: DWord read GetRson write SetRson;
    property dad[ndx: DWord]: DWord read GetDad write SetDad;
    property lsrt[ndx: DWord]: DWord read GetLsrt write SetLsrt;
    property rsrt[ndx: DWord]: DWord read GetRsrt write SetRsrt;
    property dsrt[ndx: DWord]: DWord read GetDsrt write SetDsrt;
    property csrt[ndx: DWord]: DWord read GetCsrt write SetCsrt;
  public
    constructor Create( RecordsCount: DWord;
                        KeySize: Word;
                        CompareMethod: TOnCompareSortItems;
                        CompareCharsMethod: TOnCompareChars = nil;
                        CompareRIDsMethod: TOnCompareRIDs = nil;
                        UniqueFeature: boolean = false;
                        HashTableSize: THashTableSizeType = htst256;
                        GetHashCodeMethod: TOnGetHashCode = nil;
                        MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                        DynamicSortHash: boolean = false;
                        TmpStream: TProxyStream = nil;
                        InnerSorterClass: TVKInnerSorterClass = nil;
                        BufferSize: Integer = 4096;
                        InnerSorterItemsCount: Integer = 0); override;
    destructor Destroy; override;
    function AddItem(var item: SORT_ITEM): boolean; override;
    function FirstSortItem: boolean; override;
    function GetLastSortItem(var point: DWord): boolean; override;
    function NextSortItem: boolean; override;
    procedure Sort; override;
    procedure Clear; override;
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property CurrentSortItem;
    property CurrentItem;
    property OnCompare;
    property OnCompareRIDs;
  end;

  {TVKRedBlackTreeSorter}
  TVKRedBlackTreeSorter = class(TVKBinaryTreeSorter)
  private
    Fcolor: PByte;
    function GetColor(ndx: DWord): Byte;
    procedure SetColor(ndx: DWord; const Value: Byte);
  protected
    procedure AllocateTree(RecordsCount: DWord); override;
    procedure InitTree; override;
    procedure OnInitTree(i: Integer); override;
    procedure FreeTree; override;
    function AddItemInTree(point: DWord): boolean; override;
    procedure DeleteItemFromTree(DelNode: DWord); override;
    property color[ndx: DWord]: Byte read GetColor write SetColor;
    property lson;
    property rson;
    property dad;
  public
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property CurrentSortItem;
    property CurrentItem;
    property OnCompare;
    property OnCompareRIDs;
  end;

  {TVKAVLTreeSorter}
  TVKAVLTreeSorter = class(TVKBinaryTreeSorter)
  private
    Fbalance: PShortInt;
    function GetBalance(ndx: DWord): ShortInt;
    procedure SetBalance(ndx: DWord; const Value: ShortInt);
    function IncBalance(ndx: DWord): ShortInt;
    function IncBalance1(ndx: DWord; Value: ShortInt): ShortInt;
    function DecBalance(ndx: DWord): ShortInt;
  protected
    procedure AllocateTree(RecordsCount: DWord); override;
    procedure InitTree; override;
    procedure OnInitTree(i: Integer); override;
    procedure FreeTree; override;
    function AddItemInTree(point: DWord): boolean; override;
    procedure DeleteItemFromTree(DelNode: DWord); override;
    property balance[ndx: DWord]: ShortInt read GetBalance write SetBalance;
    property lson;
    property rson;
    property dad;
  public
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property CurrentSortItem;
    property CurrentItem;
    property OnCompare;
    property OnCompareRIDs;
  end;

{-------------------------   ReTRIEval Tree  ----------------------------------}

  {TODO: Make retrieval tree with flexible TVKTrieNode chain }

  {TVKTrieNode record}
  PVKTrieNode = ^TVKTrieNode;
  PPVKTrieNode = ^PVKTrieNode;
  TVKTrieNode = packed record
    l: Byte;
    case Boolean of
      True: (
        lson: PVKTrieNode;
        case Boolean of
          True: (
            rson: PVKTrieNode;
            KeyChar: Byte;
          );
          False: (
            KeyChars: array[0..4] of Byte;
          );
      );
      False: (
        RID: DWORD;
      );
  end;

  TVKMemSourceItem = class
  private
    FMemory: Pointer;
    FCount: Integer;
    FCurrent: Integer;
  public
    constructor Create(memSize: DWORD);
    destructor Destroy; override;
    function GetNewTrieNode: PVKTrieNode;
  end;

  TVKMemSourceList = class(TObjectList)
  private
    FDestroy: boolean;
    FFirstBlockSize: DWORD;
    FCurrentBlockSize: DWORD;
    FMinBlockSize: DWORD;
    FCurrentBlock: TVKMemSourceItem;
    procedure Start;
  public
    constructor Create(FirstBlockSize, MinBlockSize: DWORD);
    procedure Clear; override;
    destructor Destroy; override;
    function GetNewTrieNode: PVKTrieNode;
  end;

  TVKSortItem = class
  private
    FSize: Integer;
    FPSortItem: PSORT_ITEM;
    function GetSortItem: SORT_ITEM;
    procedure SetSortItem(const Value: SORT_ITEM);
  public
    constructor Create(Size: Integer);
    destructor Destroy; override;
    procedure Clear;
    property SortItem: SORT_ITEM read GetSortItem write SetSortItem;
    property PSortItem: PSORT_ITEM read FPSortItem;
  end;

  {TVKTrieTreeSorter}
  TVKTrieTreeSorter = class(TVKInnerSorter)
  private
    FCurrentSrtItem: DWord;
    FNULL: DWord;
    Flsrt: PDWord;
    Frsrt: PDWord;
    Fdsrt: PDWord;
    Fcsrt: PDWord;
    function GetLsrt(ndx: DWord): DWord;
    procedure SetLsrt(ndx: DWord; const Value: DWord);
    function GetRsrt(ndx: DWord): DWord;
    procedure SetRsrt(ndx: DWord; const Value: DWord);
    function GetDsrt(ndx: DWord): DWord;
    procedure SetDsrt(ndx: DWord; const Value: DWord);
    function GetCsrt(ndx: DWord): DWord;
    procedure SetCsrt(ndx: DWord; const Value: DWord);
    procedure LRsrt(point: DWord);
    procedure RRsrt(point: DWord);
    procedure AddItemInSrtTree(point: DWord);
    property lsrt[ndx: DWord]: DWord read GetLsrt write SetLsrt;
    property rsrt[ndx: DWord]: DWord read GetRsrt write SetRsrt;
    property dsrt[ndx: DWord]: DWord read GetDsrt write SetDsrt;
    property csrt[ndx: DWord]: DWord read GetCsrt write SetCsrt;
  private
    FRoot: TVKTrieNode;
    FMemSrcList: TVKMemSourceList;
    FTrackCurent: Integer;
    FCharCurent: Integer;
    FTrack: array[0..pred(MAX_SORTER_KEY_SIZE)] of PVKTrieNode;
    FTrack_Sort_Item: SORT_ITEM;
    FHashTable: PPVKTrieNode;
    FHashSortItemPool: array of TVKSortItem;
    function GetHashTable(Ind: Integer): PVKTrieNode;
    procedure SetHashTable(Ind: Integer; const Value: PVKTrieNode);
    function GetHashSortItem(Ind: DWord): SORT_ITEM;
    function GetPHashSortItem(Ind: Integer): PSORT_ITEM;
    procedure SetHashSortItem(Ind: DWord; const Value: SORT_ITEM);
    procedure AllocateHashTable;
    procedure InitHashTable;
    procedure FreeHashTable;
    property HashTable[Ind: Integer]: PVKTrieNode read GetHashTable write SetHashTable;
    property HashSortItem[Ind: DWord]: SORT_ITEM read GetHashSortItem write SetHashSortItem;
    property PHashSortItem[Ind: Integer]: PSORT_ITEM read GetPHashSortItem;
  protected
    function GetSortArray(ndx: DWord): DWord; override;
    procedure SetSortArray(ndx: DWord; const Value: DWord); override;
    function GetSortItem(ndx: DWord): SORT_ITEM; override;
    procedure SetSortItem(ndx: DWord; const Value: SORT_ITEM); override;
    //function GetKey(ndx: DWord): PByte; override;
    //function GetRecNo(ndx: DWord): DWord; override;
    //procedure SetKey(ndx: DWord; const Value: PByte); override;
    //procedure SetRecNo(ndx: DWord; const Value: DWord); override;
    function GetPSortItem(ndx: DWord): PSORT_ITEM; override;
    procedure DropDownTiers(CurrentNode: PVKTrieNode);
    function AddNewItem(var item: SORT_ITEM): boolean; override;
  protected
    function GetCurrentSortItem: PSORT_ITEM; override;
    procedure AllocateSpace; override;
    procedure ReleaseSpace; override;
  public
    constructor Create( RecordsCount: DWord;
                        KeySize: Word;
                        CompareMethod: TOnCompareSortItems;
                        CompareCharsMethod: TOnCompareChars = nil;
                        CompareRIDsMethod: TOnCompareRIDs = nil;
                        UniqueFeature: boolean = false;
                        HashTableSizePar: THashTableSizeType = htst256;
                        GetHashCodeMethod: TOnGetHashCode = nil;
                        MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                        DynamicSortHash: boolean = false;
                        TmpStream: TProxyStream = nil;
                        InnerSorterClass: TVKInnerSorterClass = nil;
                        BufferSize: Integer = 4096;
                        InnerSorterItemsCount: Integer = 0); override;
    destructor Destroy; override;
    function AddItem(var item: SORT_ITEM): boolean; override;
    procedure Sort; override;
    procedure Clear; override;
    function FirstSortItem: boolean; override;
    function NextSortItem: boolean; override;
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property HashTableSize;
    property HashTableSizeValue;
    property MaxBitsInHashCode;
    property HashShift;
    property CurrentSortItem;
    property CurrentItem;
    property OnGetHashCode;
    property OnCompare;
    property OnCompareRIDs;
  end;

{-------------------------   ReTRIEval Tree  ----------------------------------}

{--------------------   Outer Absorption Sorter -------------------------------}

  {TVKAbsorptionSorter}
  TVKAbsorptionSorter = class(TVKOuterSorter)
  private
    FInnerSorter: TVKInnerSorter;
    FSortItemSize: DWord;
    FSortItemsPerBuffer: DWord;
    FBuff1: Pointer;
    FBuff2: Pointer;
    FBuff3: Pointer;
    FCurrentSortItemInBlock: DWord;
    FSortItemsInBlock: DWord;
    FBlockCount: DWord;
    procedure FlushInnerSorterToTmpStream;
  protected
    function GetSortArray(ndx: DWord): DWord; override;
    procedure SetSortArray(ndx: DWord; const Value: DWord); override;
    function GetSortItem(ndx: DWord): SORT_ITEM; override;
    procedure SetSortItem(ndx: DWord; const Value: SORT_ITEM); override;
    //function GetKey(ndx: DWord): PByte; override;
    //function GetRecNo(ndx: DWord): DWord; override;
    //procedure SetKey(ndx: DWord; const Value: PByte); override;
    //procedure SetRecNo(ndx: DWord; const Value: DWord); override;
    function GetPSortItem(ndx: DWord): PSORT_ITEM; override;
  protected
    function GetCurrentSortItem: PSORT_ITEM; override;
    procedure AllocateSpace; override;
    procedure ReleaseSpace; override;
  public
    constructor Create( RecordsCount: DWord;
                        KeySize: Word;
                        CompareMethod: TOnCompareSortItems;
                        CompareCharsMethod: TOnCompareChars = nil;
                        CompareRIDsMethod: TOnCompareRIDs = nil;
                        UniqueFeature: boolean = false;
                        HashTableSizePar: THashTableSizeType = htst256;
                        GetHashCodeMethod: TOnGetHashCode = nil;
                        MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                        DynamicSortHash: boolean = false;
                        TmpStream: TProxyStream = nil;
                        InnerSorterClass: TVKInnerSorterClass = nil;
                        BufferSize: Integer = 4096;
                        InnerSorterItemsCount: Integer = 0); override;
    destructor Destroy; override;
    function AddItem(var item: SORT_ITEM): boolean; override;
    procedure Sort; override;
    procedure Clear; override;
    function FirstSortItem: boolean; override;
    function NextSortItem: boolean; override;
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property HashTableSize;
    property HashTableSizeValue;
    property MaxBitsInHashCode;
    property HashShift;
    property CurrentSortItem;
    property CurrentItem;
    property OnGetHashCode;
    property OnCompare;
    property OnCompareRIDs;
  end;

{--------------------   Outer Absorption Sorter -------------------------------}

{--------------------   Outer Merge Sorter ------------------------------------}

  PMergeBlockHeader = ^TMergeBlockHeader;
  PPMergeBlockHeader = ^PMergeBlockHeader;
  TMergeBlockHeader = packed record
    next_block: DWord;
    count: DWord;
  end;

  {TVKMergeSorterBase}
  TVKMergeSorterBase = class(TVKOuterSorter)
  protected
    procedure AddFreeList(NewFreeEntry: DWord; Buffer: Pointer); virtual; abstract;
  end;

  {TVKMergeIteratorAbstract}
  TVKMergeIteratorAbstract = class
  protected
    function GetEof: Boolean; virtual; abstract;
  public
    function GetCurrentSortItem: PSORT_ITEM; virtual; abstract;
    function First: boolean; virtual; abstract;
    function Next: boolean; virtual; abstract;
    property Eof: boolean read GetEof;
  end;

  {TVKMergeIterator}
  TVKMergeIterator = class(TVKMergeIteratorAbstract)
  private
    FEof: Boolean;
    FSortItemSize: DWord;
    FTmpStream: TProxyStream;
    FEntry: DWord;
    FBuff: Pointer;
    FBufferSize: DWord;
    FOwner: TVKMergeSorterBase;
    FCurrentSortItemInBlock: DWord;
  protected
    function GetEof: Boolean; override;
  public
    constructor Create(
        Owner: TVKMergeSorterBase;
        TmpStream: TProxyStream;
        Entry: DWord;
        Buff: Pointer;
        BufferSize: DWord;
        SortItemSize: DWord
      );
    destructor Destroy; override;
    function GetCurrentSortItem: PSORT_ITEM; override;
    function First: boolean; override;
    function Next: boolean; override;
  end;

  {TVKMerge2PathIterator}
  TVKMerge2PathIterator = class(TVKMergeIteratorAbstract)
  private
    FOwner: TVKMergeSorterBase;
    FIterator1: TVKMergeIteratorAbstract;
    FIterator2: TVKMergeIteratorAbstract;
    FCurrentIterator: TVKMergeIteratorAbstract;
    procedure FillCurrentIterator;
  protected
    function GetEof: Boolean; override;
  public
    constructor Create(
        Owner: TVKMergeSorterBase;
        Iterator1, Iterator2: TVKMergeIteratorAbstract
      );
    destructor Destroy; override;
    function GetCurrentSortItem: PSORT_ITEM; override;
    function First: boolean; override;
    function Next: boolean; override;
  end;

  {TVKMergeSorter}
  TVKMergeSorter = class(TVKMergeSorterBase)
  private
    FSortItemsPerBuffer: DWord;
    FSortItemsPerInnerSorter: DWord;
    FEntryCount: DWord;
    FFreeList: DWord;
    FBlockCount: DWord;
    FIterator: TVKMergeIteratorAbstract;
    FIt1: TVKMergeIteratorAbstract;
    FIt2: TVKMergeIteratorAbstract;
    function Merge(Entry1, Entry2: DWord): DWord;
  protected
    //
    FBuff1: Pointer;
    FBuff2: Pointer;
    FBuff3: Pointer;
    FBuff4: Pointer;
    FSortItemSize: DWord;
    FInnerSorter: TVKInnerSorter;
    FEntryPoint: DWord;
    FEntries: array of DWord;
    //
    function GetSortArray(ndx: DWord): DWord; override;
    procedure SetSortArray(ndx: DWord; const Value: DWord); override;
    function GetSortItem(ndx: DWord): SORT_ITEM; override;
    procedure SetSortItem(ndx: DWord; const Value: SORT_ITEM); override;
    //function GetKey(ndx: DWord): PByte; override;
    //function GetRecNo(ndx: DWord): DWord; override;
    //procedure SetKey(ndx: DWord; const Value: PByte); override;
    //procedure SetRecNo(ndx: DWord; const Value: DWord); override;
    function GetPSortItem(ndx: DWord): PSORT_ITEM; override;
    //
    procedure AddFreeList(NewFreeEntry: DWord; Buffer: Pointer); override;
    //
    procedure FlushInnerSorterToTmpStream;
    procedure OutSortItem(Buffer: Pointer; psi: PSORT_ITEM; var CurrentBlock, PredBlock: DWord);
    procedure FlushOut(Buffer: Pointer; Eof: boolean; var CurrentBlock, PredBlock: DWord);
    function GetFreeBuffer(Buffer: Pointer): DWord;
    function MergeInternal(Iterator: TVKMergeIteratorAbstract): DWord;
    //
  protected
    function GetCurrentSortItem: PSORT_ITEM; override;
    procedure AllocateSpace; override;
    procedure ReleaseSpace; override;
    procedure SomeMoreAllocate; virtual;
    procedure SomeMoreRelease; virtual;
    function GetIterator(n: Integer; base: Integer = 0): TVKMergeIteratorAbstract; virtual;
  public
    constructor Create( RecordsCount: DWord;
                        KeySize: Word;
                        CompareMethod: TOnCompareSortItems;
                        CompareCharsMethod: TOnCompareChars = nil;
                        CompareRIDsMethod: TOnCompareRIDs = nil;
                        UniqueFeature: boolean = false;
                        HashTableSizePar: THashTableSizeType = htst256;
                        GetHashCodeMethod: TOnGetHashCode = nil;
                        MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                        DynamicSortHash: boolean = false;
                        TmpStream: TProxyStream = nil;
                        InnerSorterClass: TVKInnerSorterClass = nil;
                        BufferSize: Integer = 4096;
                        InnerSorterItemsCount: Integer = 0); override;
    destructor Destroy; override;
    function AddItem(var item: SORT_ITEM): boolean; override;
    procedure Sort; override;
    procedure Clear; override;
    function FirstSortItem: boolean; override;
    function NextSortItem: boolean; override;
    property CountRecords;
    property CountAddedItems;
    property SortArray;
    property SortItem;
    property PSortItem;
    //property Key;
    //property RecNo;
    property Unique;
    property HashTableSize;
    property HashTableSizeValue;
    property MaxBitsInHashCode;
    property HashShift;
    property CurrentSortItem;
    property CurrentItem;
    property OnGetHashCode;
    property OnCompare;
    property OnCompareRIDs;
  end;

  {TVK4PathMergeSorter}
  TVK4PathMergeSorter = class(TVKMergeSorter)
  private
    FIt1: TVKMergeIterator;
    FIt2: TVKMergeIterator;
    FTwoPathIt1: TVKMerge2PathIterator;
    FTwoPathIt2: TVKMerge2PathIterator;
    FIt3: TVKMergeIterator;
    FIt4: TVKMergeIterator;
    function Merge(Entry1, Entry2, Entry3, Entry4: DWord): DWord; overload;
  protected
    FBuff5: Pointer;
    FBuff6: Pointer;
    procedure SomeMoreAllocate; override;
    procedure SomeMoreRelease; override;
    function GetIterator(n: Integer; base: Integer = 0): TVKMergeIteratorAbstract; override;
  public
    procedure Sort; override;
    procedure Clear; override;
  end;

  {TVK8PathMergeSorter}
  TVK8PathMergeSorter = class(TVK4PathMergeSorter)
  private
    FIt1: TVKMergeIterator;
    FIt2: TVKMergeIterator;
    FTwoPathIt1: TVKMerge2PathIterator;
    FIt3: TVKMergeIterator;
    FIt4: TVKMergeIterator;
    FTwoPathIt2: TVKMerge2PathIterator;
    FTwoPathIt1_2: TVKMerge2PathIterator;
    FIt5: TVKMergeIterator;
    FIt6: TVKMergeIterator;
    FTwoPathIt3: TVKMerge2PathIterator;
    FIt7: TVKMergeIterator;
    FIt8: TVKMergeIterator;
    FTwoPathIt4: TVKMerge2PathIterator;
    FTwoPathIt3_4: TVKMerge2PathIterator;
    function Merge(Entry1, Entry2, Entry3, Entry4, Entry5, Entry6, Entry7, Entry8: DWord): DWord; overload;
  protected
    FBuff7: Pointer;
    FBuff8: Pointer;
    FBuff9: Pointer;
    FBuff10: Pointer;
    procedure SomeMoreAllocate; override;
    procedure SomeMoreRelease; override;
    function GetIterator(n: Integer; base: Integer = 0): TVKMergeIteratorAbstract; override;
  public
    procedure Sort; override;
    procedure Clear; override;
  end;

{--------------------   Outer Merge Sorter ------------------------------------}

implementation

{ TVKQuickSorter }

constructor TVKQuickSorter.Create(
  RecordsCount: DWord;
  KeySize: Word;
  CompareMethod: TOnCompareSortItems;
  CompareCharsMethod: TOnCompareChars = nil;
  CompareRIDsMethod: TOnCompareRIDs = nil;
  UniqueFeature: boolean = false;
  HashTableSize: THashTableSizeType = htst256;
  GetHashCodeMethod: TOnGetHashCode = nil;
  MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
  DynamicSortHash: boolean = false;
  TmpStream: TProxyStream = nil;
  InnerSorterClass: TVKInnerSorterClass = nil;
  BufferSize: Integer = 4096;
  InnerSorterItemsCount: Integer = 0);
begin
  inherited Create( RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSize,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash,
                    TmpStream,
                    InnerSorterClass,
                    BufferSize,
                    InnerSorterItemsCount);
  if UniqueFeature = true then raise Exception.Create('TVKQuickSorter.Create: TVKQuickSorter not support Unique feature!');
end;

function TVKQuickSorter.FirstSortItem: boolean;
begin
  FCurrentItem := 0;
  Result := ( CountAddedItems = 0 );
end;

function TVKQuickSorter.GetCurrentSortItem: PSORT_ITEM;
begin
  Result := PSortItem[SortArray[FCurrentItem]];
end;

function TVKQuickSorter.NextSortItem: boolean;
begin
  Inc(FCurrentItem);
  Result := ( FCurrentItem >= CountAddedItems );
end;

procedure TVKQuickSorter.Sort;

  procedure QuickSort(l, r: Integer);
  var
    cmpKey: PSORT_ITEM;
    i, j, c, cmp: Integer;
    t: DWord;
  begin
    repeat
      i := l;
      j := r;
      cmpKey := PSortItem[SortArray[ ( l + r ) shr 1 ]];
      repeat
        while True do begin
          c := CompareItems(PSortItem[SortArray[i]], cmpKey, cmp);
          if c >= 0 then
            break
          else
            Inc(i);
        end;
        while True do begin
          c := CompareItems(PSortItem[SortArray[j]], cmpKey, cmp);
          if c <= 0 then
            break
          else
            Dec(j);
        end;
        if i<=j then
        begin
          t := SortArray[i];
          SortArray[i] := SortArray[j];
          SortArray[j] := t;
          Inc(i);
          Dec(j);
        end;
      until ( i > j );
      if l < j then
        QuickSort(l, j);
      l := i;
    until i >= r;
  end;

begin
  if FKeyPoolCount > 0 then
    QuickSort(0, pred(FKeyPoolCount));
end;

(*
// It's the same, but not recursive
procedure TVKQuickSorter.Sort;
var
  Fpipe: PDWord;
  FNULL: DWord;
  pipeIn, pipeOut: DWord;

  procedure pipePut(Value: DWord);
  begin
    PDWord( pAnsiChar(Fpipe) + ( ( pipeIn mod FNULL ) * SizeOf(DWord) ) )^ := Value;
    Inc(pipeIn);
  end;

  function pipeGet: DWord;
  begin
    Result := PDWord( pAnsiChar(Fpipe) + ( ( pipeOut mod FNULL ) * SizeOf(DWord) ) )^;
    Inc(pipeOut);
  end;

  procedure QuickSort;
  var
    cmpKey: PSORT_ITEM;
    l, r: DWord;
    i, j, c, cmp: Integer;
    t: DWord;

  begin
    l := pipeGet;
    r := pipeGet;
    repeat
      i := l;
      j := r;
      cmpKey := PSortItem[SortArray[ ( l + r ) shr 1 ]];
      repeat
        while True do begin
          c := CompareItems(PSortItem[SortArray[i]], cmpKey, cmp);
          if c >= 0 then
            break
          else
            Inc(i);
        end;
        while True do begin
          c := CompareItems(PSortItem[SortArray[j]], cmpKey, cmp);
          if c <= 0 then
            break
          else
            Dec(j);
        end;
        if i <= j then
        begin
          t := SortArray[i];
          SortArray[i] := SortArray[j];
          SortArray[j] := t;
          Inc(i);
          Dec(j);
        end;
      until ( i > j );
      if l < j then begin
        pipePut(l);
        pipePut(j);
      end;
        l := i;
    until i >= r;
  end;

begin
  if FKeyPoolCount > 0 then begin
    FNULL := FKeyPoolCount;
    Fpipe := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL ) );
    try
      pipeIn := 0;
      pipeOut := 0;
      pipePut(0);
      pipePut(Pred(FNULL));
      repeat
        QuickSort;
      until pipeIn < pipeOut;
    finally
      VKDBFMemMgr.oMem.FreeMem(Fpipe);
    end;
  end;
end;
*)

{ TVKSorterAbstract }

function TVKSorterAbstract.AddItem(var item: SORT_ITEM): boolean;
begin
  Result := AddNewItem(item);
end;

function TVKSorterAbstract.AddNewItem(var item: SORT_ITEM): boolean;
begin
  SortArray[FKeyPoolCount] := FKeyPoolCount;
  SortItem[FKeyPoolCount] := item;
  Inc(FKeyPoolCount);
  Result := true;
end;

procedure TVKSorterAbstract.AllocateSpace;
begin
  if FRecordsCount > 0 then begin
    FSortArray := VKDBFMemMgr.oMem.GetMem(self, SizeOf(DWord) * FRecordsCount);
    FKeyPool := VKDBFMemMgr.oMem.GetMem(self, ( ( SizeOf(DWord) shl 1 ) + FKeySize ) * FRecordsCount);
  end;
end;

procedure TVKSorterAbstract.Clear;
begin
  FKeyPoolCount := 0;
end;

function TVKSorterAbstract.CompareItems(
  CurrentItem, Item: PSORT_ITEM;
  out c: Integer): Integer;
begin
  FCompareMethod(self, CurrentItem, Item, FKeySize, c);
  if ( c = 0 ) and ( CurrentItem.RID <> Item.RID ) then begin
    if Assigned(FCompareRIDsMethod) then
      FCompareRIDsMethod(self, CurrentItem.RID, Item.RID, result)
    else begin
      if CurrentItem.RID < Item.RID then
        result := -1
      else
        result := 1;
    end;
  end else
    result := c;
end;

constructor TVKSorterAbstract.Create(  RecordsCount: DWord;
                                       KeySize: Word;
                                       CompareMethod: TOnCompareSortItems;
                                       CompareCharsMethod: TOnCompareChars = nil;
                                       CompareRIDsMethod: TOnCompareRIDs = nil;
                                       UniqueFeature: boolean = false;
                                       HashTableSizePar: THashTableSizeType = htst256;
                                       GetHashCodeMethod: TOnGetHashCode = nil;
                                       MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                                       DynamicSortHash: boolean = false;
                                       TmpStream: TProxyStream = nil;
                                       InnerSorterClass: TVKInnerSorterClass = nil;
                                       BufferSize: Integer = 4096;
                                       InnerSorterItemsCount: Integer = 0);
begin
  inherited Create;
  FKeyPoolCount := 0;
  FKeySize := KeySize;
  FRecordsCount := RecordsCount;
  FCompareMethod := CompareMethod;
  FCompareCharsMethod := CompareCharsMethod;
  FCompareRIDsMethod := CompareRIDsMethod;
  FUnique := UniqueFeature;
  FDynamicSortHash := DynamicSortHash;
  if Assigned(GetHashCodeMethod) then begin
    FStandardHash := False;
    FGetHashCodeMethod := GetHashCodeMethod;
    FHashTableSize := HashTableSizePar;
    FHashTableSizeValue := 1 shl Integer(FHashTableSize);
    FMaxBitsInHashCode := MaxBitsInHashCodePar;
    if Integer(FMaxBitsInHashCode) >= Integer(FHashTableSize) then
      FHashShift := Integer(FMaxBitsInHashCode) - Integer(FHashTableSize)
    else
      raise Exception.Create('TVKSorterAbstract.Create: MaxBitsInHashCode must be greater then number of bits used for HashTableSize!');
    FNormalizeCoeff := $FFFFFFFF shr ( 32 - Integer(FMaxBitsInHashCode) );
    FNormalizeCoeffNeg := $FFFFFFFF shr ( 32 - Integer(FMaxBitsInHashCode) + 1 );
  end else begin
    FStandardHash := True;
    FGetHashCodeMethod := GetVKHashCode;
    FHashTableSize := htst256;
    FHashTableSizeValue := 1 shl Integer(FHashTableSize);
  end;
  FTmpStream := TmpStream;
  FInnerSorterClass := InnerSorterClass;
  FBufferSize := BufferSize;
  FInnerSorterItemsCount := InnerSorterItemsCount;
  AllocateSpace;
end;

destructor TVKSorterAbstract.Destroy;
begin
  ReleaseSpace;
  inherited Destroy;
end;

procedure TVKSorterAbstract.GetVKHashCode(Sender: TObject;
  Item: PSORT_ITEM; out HashCode: DWord);
begin
  HashCode := DWord(pByte(@Item.key[0])^);
end;

(*
function TVKSorterAbstract.GetKey(ndx: DWord): PByte;
begin
  Result := PByte( pAnsiChar(FKeyPool) + ( ndx * ( ( SizeOf(DWord) shl 1 ) + FKeySize ) ) + ( SizeOf(DWord) shl 1 ) );
end;
*)

function TVKSorterAbstract.GetPSortItem(ndx: DWord): PSORT_ITEM;
begin
  Result := PSORT_ITEM(pAnsiChar(FKeyPool) + ( ndx * ( ( SizeOf(DWord) shl 1 ) + FKeySize ) ) );
end;

(*
function TVKSorterAbstract.GetRecNo(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(FKeyPool) + ( ndx * ( ( SizeOf(DWord) shl 1 ) + FKeySize ) ) + SizeOf(DWord) )^;
end;
*)

function TVKSorterAbstract.GetSortArray(ndx: DWord): DWord;
begin
  Result := PDWord(pAnsiChar(FSortArray) + ( ndx * SizeOf(DWord) ))^;
end;

function TVKSorterAbstract.GetSortItem(ndx: DWord): SORT_ITEM;
begin
  Result := PSORT_ITEM(pAnsiChar(FKeyPool) + ( ndx * ( ( SizeOf(DWord) shl 1 ) + FKeySize ) ))^;
end;

function TVKSorterAbstract.Hash(Item: PSORT_ITEM): DWord;
var
  HashCode: DWord;
  HashCodeInt: LongInt absolute HashCode;
begin
  FGetHashCodeMethod(self, Item, HashCode);
  if FStandardHash then begin
    Result := HashCode;
  end else begin
    //Check HashCode for boundaries
    if HashCodeInt < 0 then begin
      if DWord( - HashCodeInt ) > FNormalizeCoeffNeg then
        raise Exception.Create('TVKSorterAbstract.Hash: Hash value (' + IntToStr( - HashCodeInt ) + ') must be less than ' + IntToStr(FNormalizeCoeffNeg) );
    end else begin
      if DWord( HashCodeInt ) > FNormalizeCoeff then
        raise Exception.Create('TVKSorterAbstract.Hash: Hash value (' + IntToStr( HashCodeInt ) + ') must be less than ' + IntToStr(FNormalizeCoeff) );
    end;
    //
    Result := ( HashCode and FNormalizeCoeff ) shr FHashShift;
  end;
end;

procedure TVKSorterAbstract.ReleaseSpace;
begin
  if FRecordsCount > 0 then begin
    VKDBFMemMgr.oMem.FreeMem(FSortArray);
    VKDBFMemMgr.oMem.FreeMem(FKeyPool);
  end;
end;

(*
procedure TVKSorterAbstract.SetKey(ndx: DWord; const Value: PByte);
begin
  Move(Value^, PByte( pAnsiChar(FKeyPool) + ( ndx *  ( ( SizeOf(DWord) shl 1 ) + FKeySize ) ) + ( SizeOf(DWord) shl 1 ) )^, FKeySize);
end;
*)

(*
procedure TVKSorterAbstract.SetRecNo(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(FKeyPool) + ( ndx * ( ( SizeOf(DWord) shl 1 ) + FKeySize ) + SizeOf(DWord) ) )^ := Value;
end;
*)

procedure TVKSorterAbstract.SetSortArray(ndx: DWord;
  const Value: DWord);
begin
  PDWord(pAnsiChar(FSortArray) + ( ndx * SizeOf(DWord) ))^ := Value;
end;

procedure TVKSorterAbstract.SetSortItem(ndx: DWord;
  const Value: SORT_ITEM);
var
  l: Word;
begin
  l := ( SizeOf(DWord) shl 1 ) + FKeySize;
  Move(PSORT_ITEM(@Value)^, PSORT_ITEM(pAnsiChar(FKeyPool) + ( ndx *  l ))^, l);
end;

{ TVKBinaryTreeSorter }

function TVKBinaryTreeSorter.AddItem(var item: SORT_ITEM): boolean;
begin
  inherited AddItem(item);
  Result := AddItemInTree(FKeyPoolCount - 1);
end;

function TVKBinaryTreeSorter.AddItemInTree(point: DWord): boolean;
var
  q: Boolean;
  p, hsh: DWord;
  cmp, c: Integer;
begin
  Result := false;
  hsh := Hash(PSortItem[point]);
  p := FNILL + 1 + hsh;
  q := ( rson[p] = FNILL );
  cmp := 1;
  c := 1;
  rson[point] := FNILL;
  lson[point] := FNILL;
  while true do begin
    if (cmp = 0) then begin
      if FUnique then begin
        Result := false;
        break;
      end;
    end;
    if (c >= 0) then begin
      if (rson[p] <> FNILL) then begin
        p := rson[p];
      end else begin
        rson[p] := point;
        dad[point] := p;
        Result := true;
        break;
      end;
    end else begin
      if (lson[p] <> FNILL) then begin
        p := lson[p];
      end else begin
        lson[p] := point;
        dad[point] := p;
        Result := true;
        break;
      end;
    end;
    c := CompareItems(PSortItem[point], PSortItem[p], cmp);
  end;
  if FDynamicSortHash then
    if Result and q then AddItemInSrtTree(hsh);
end;

procedure TVKBinaryTreeSorter.AllocateTree(RecordsCount: DWord);
begin
  FNILL := FRecordsCount;
  Flson := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNILL + 1 ) );
  Frson := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNILL + 1 + FHashTableSizeValue ) );
  Fdad  := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNILL + 1 ) );
  FNULL := FHashTableSizeValue;
  Flsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 1 ) );
  Frsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 2 ) );
  Fdsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 1 ) );
  Fcsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 1 ) );
end;

procedure TVKBinaryTreeSorter.Clear;
begin
  inherited Clear;
  InitTree;
end;

constructor TVKBinaryTreeSorter.Create(  RecordsCount: DWord;
                                            KeySize: Word;
                                            CompareMethod: TOnCompareSortItems;
                                            CompareCharsMethod: TOnCompareChars = nil;
                                            CompareRIDsMethod: TOnCompareRIDs = nil;
                                            UniqueFeature: boolean = false;
                                            HashTableSize: THashTableSizeType = htst256;
                                            GetHashCodeMethod: TOnGetHashCode = nil;
                                            MaxBitsInHashCodePar: TMaxBitsInHashCode = mbhc32;
                                            DynamicSortHash: boolean = false;
                                            TmpStream: TProxyStream = nil;
                                            InnerSorterClass: TVKInnerSorterClass = nil;
                                            BufferSize: Integer = 4096;
                                            InnerSorterItemsCount: Integer = 0);
begin
  inherited Create( RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSize,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash,
                    TmpStream,
                    InnerSorterClass,
                    BufferSize,
                    InnerSorterItemsCount);
  AllocateTree(RecordsCount);
  InitTree;
  FCurrentSrtItem := FNULL;
  FCurrentItem := FNILL;
end;

procedure TVKBinaryTreeSorter.DeleteItemFromTree(point: DWord);
var
  q: DWord;
begin
  if (dad[point] = FNILL) then exit;
  DeleteNodeFromSrtTree(point);
  if (rson[point] = FNILL) then
    q := lson[point]
  else
    if (lson[point] = FNILL) then
      q := rson[point]
    else begin
      q := lson[point];
      if (rson[q] <> FNILL) then begin
        while true do begin
          q := rson[q];
          if (rson[q] = FNILL) then break;
        end;
        rson[dad[q]] := lson[q];  dad[lson[q]] := dad[q];
        lson[q] := lson[point];  dad[lson[point]] := q;
      end;
      rson[q] := rson[point];  dad[rson[point]] := q;
    end;
  dad[q] := dad[point];
  if (rson[dad[point]] = point) then
    rson[dad[point]] := q
  else
    lson[dad[point]] := q;
  dad[point] := FNILL;
end;

destructor TVKBinaryTreeSorter.Destroy;
begin
  FreeTree;
  inherited Destroy;
end;

procedure TVKBinaryTreeSorter.FreeTree;
begin
  VKDBFMemMgr.oMem.FreeMem(Flson);
  VKDBFMemMgr.oMem.FreeMem(Frson);
  VKDBFMemMgr.oMem.FreeMem(Fdad);
  VKDBFMemMgr.oMem.FreeMem(Flsrt);
  VKDBFMemMgr.oMem.FreeMem(Frsrt);
  VKDBFMemMgr.oMem.FreeMem(Fdsrt);
  VKDBFMemMgr.oMem.FreeMem(Fcsrt);
end;

function TVKBinaryTreeSorter.GetDad(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Fdad) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKBinaryTreeSorter.GetLson(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Flson) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKBinaryTreeSorter.GetLsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Flsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKBinaryTreeSorter.GetDsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Fdsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKBinaryTreeSorter.GetRson(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Frson) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKBinaryTreeSorter.GetRsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Frsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

procedure TVKBinaryTreeSorter.InitTree;
var
  i: Integer;
begin

  // Init trees in hash table
  for i := FNILL + 1 to FNILL + FHashTableSizeValue do begin
    rson[i] := FNILL;
  end;
  for i := 0 to FNILL do begin
    dad[i] := FNILL;
    OnInitTree(i);
  end;
  lson[FNILL] := FNILL;
  rson[FNILL] := FNILL;

  // Init tree of hash table
  rsrt[Succ(FNULL)] := FNULL;
  for i := 0 to FNULL do begin
    dsrt[i] := FNULL;
    if FDynamicSortHash then
      csrt[i] := COLOR_BLACK;
  end;
  lsrt[FNULL] := FNULL;
  rsrt[FNULL] := FNULL;

end;

procedure TVKBinaryTreeSorter.LeftRotate(point: DWord);
var
  p: DWord;
begin
  p := rson[point];
  rson[point] := lson[p];
  dad[rson[point]] := point;
  dad[p] := dad[point];
  if rson[dad[p]] = point then
    rson[dad[p]] := p
  else
    lson[dad[p]] := p;
  lson[p] := point;
  dad[point] := p;
end;

procedure TVKBinaryTreeSorter.RightRotate(point: DWord);
var
  p: DWord;
begin
  p := lson[point];
  lson[point] := rson[p];
  dad[lson[point]] := point;
  dad[p] := dad[point];
  if rson[dad[p]] = point then
    rson[dad[p]] := p
  else
    lson[dad[p]] := p;
  rson[p] := point;
  dad[point] := p;
end;

procedure TVKBinaryTreeSorter.SetDad(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Fdad) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.SetLson(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Flson) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.SetLsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Flsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.SetDsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Fdsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.SetRson(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Frson) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.SetRsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Frsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.Sort;
var
  i: DWord;
  pnt: DWord;
  pipeIn, pipeOut: DWord;

  procedure pipePut(Value: DWord);
  begin
    csrt[pipeIn and ( FNULL - 1 )] := Value;
    Inc(pipeIn);
  end;

  function pipeGet: DWord;
  begin
    Result := csrt[pipeOut and ( FNULL - 1 )];
    Inc(pipeOut);
  end;

  procedure AddElement(point: DWord);
  var
    p: DWord;
    c, cmp: Integer;
  begin
    p := Succ(FNULL);
    cmp := 1;
    c := 1;
    rsrt[point] := FNULL;
    lsrt[point] := FNULL;
    while true do begin
      if (c > 0) then begin
        if (rsrt[p] <> FNULL) then begin
          p := rsrt[p];
        end else begin
          rsrt[p] := point;
          dsrt[point] := p;
          exit;
        end;
      end else begin
        if (lsrt[p] <> FNULL) then begin
          p := lsrt[p];
        end else begin
          lsrt[p] := point;
          dsrt[point] := p;
          exit;
        end;
      end;
      c := CompareItems(PSortItem[rson[FNILL + 1 + point]], PSortItem[rson[FNILL + 1 + p]], cmp);
    end;
  end;

  procedure SortRoots;
  var
    qb, qe, qm: DWord;
  begin
    qb := pipeGet;
    qe := pipeGet;
    if ( qe - qb ) > 2 then begin
      qm := (qb + qe) shr 1;
      if rson[FNILL + 1 + qm] <> FNILL then AddElement(qm);
      pipePut(qb);
      pipePut(Pred(qm));
      pipePut(Succ(qm));
      pipePut(qe);
    end else
      for qm := qb to qe do
        if rson[FNILL + 1 + qm] <> FNILL then AddElement(qm);
  end;

  procedure Pass(RootTie: DWord);
  begin
    if lson[RootTie] <> FNILL then Pass(lson[RootTie]);
    SortArray[i] := RootTie;
    Inc(i);
    if rson[RootTie] <> FNILL then Pass(rson[RootTie]);
  end;

  procedure pss(RootTie: DWord);
  begin
    if lsrt[RootTie] <> FNULL then pss(lsrt[RootTie]);
    Pass(rson[FNILL + 1 + RootTie]);
    if rsrt[RootTie] <> FNULL then pss(rsrt[RootTie]);
  end;

begin

  if not FDynamicSortHash then begin

    rsrt[Succ(FNULL)] := FNULL;

    pipeIn := 0;
    pipeOut := 0;
    pipePut(0);
    pipePut(Pred(FNULL));
    repeat
      SortRoots;
    until pipeIn = pipeOut;

  end;

  i := 0;
  pnt := rsrt[Succ(FNULL)];
  if pnt <> FNULL then pss(pnt);
  FKeyPoolCount := i;

end;

function TVKBinaryTreeSorter.GetCsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Fcsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

procedure TVKBinaryTreeSorter.SetCsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Fcsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKBinaryTreeSorter.OnInitTree(i: Integer);
begin
  //
end;

procedure TVKBinaryTreeSorter.LRsrt(point: DWord);
var
  p: DWord;
begin
  p := rsrt[point];
  rsrt[point] := lsrt[p];
  dsrt[rsrt[point]] := point;
  dsrt[p] := dsrt[point];
  if rsrt[dsrt[p]] = point then
    rsrt[dsrt[p]] := p
  else
    lsrt[dsrt[p]] := p;
  lsrt[p] := point;
  dsrt[point] := p;
end;

procedure TVKBinaryTreeSorter.RRsrt(point: DWord);
var
  p: DWord;
begin
  p := lsrt[point];
  lsrt[point] := rsrt[p];
  dsrt[lsrt[point]] := point;
  dsrt[p] := dsrt[point];
  if rsrt[dsrt[p]] = point then
    rsrt[dsrt[p]] := p
  else
    lsrt[dsrt[p]] := p;
  rsrt[p] := point;
  dsrt[point] := p;
end;

procedure TVKBinaryTreeSorter.AddItemInSrtTree(point: DWord);
var
  p: DWord;
  c, cmp: Integer;
  uncle, daddy, grandpa: DWord;
  IsRson, IsRdaddy: boolean;
begin
  p := Succ(FNULL);
  cmp := 1;
  c := 1;
  rsrt[point] := FNULL;
  lsrt[point] := FNULL;
  while true do begin
    if (c > 0) then begin
      if (rsrt[p] <> FNULL) then begin
        p := rsrt[p];
      end else begin
        rsrt[p] := point;
        dsrt[point] := p;
        break;
      end;
    end else begin
      if (lsrt[p] <> FNULL) then begin
        p := lsrt[p];
      end else begin
        lsrt[p] := point;
        dsrt[point] := p;
        break;
      end;
    end;
    c := CompareItems(PSortItem[rson[FNILL + 1 + point]], PSortItem[rson[FNILL + 1 + p]], cmp);
  end;
  // Now making Tree balanced if Item has been added
  csrt[point] := COLOR_RED;
  while True do begin
    daddy := dsrt[point];
    if daddy > FNULL then begin // point is root
      csrt[point] := COLOR_BLACK;
      break;
    end;
    if csrt[daddy] = COLOR_RED then begin //if daddy is red
      //
      IsRson := ( rsrt[daddy] = point );
      grandpa := dsrt[daddy];
      IsRdaddy := ( rsrt[grandpa] = daddy );
      if IsRdaddy then
        uncle := lsrt[grandpa]
      else
        uncle := rsrt[grandpa];
      if csrt[uncle] = COLOR_RED then begin
        csrt[uncle] := COLOR_BLACK;
        csrt[daddy] := COLOR_BLACK;
        csrt[grandpa] := COLOR_RED;
        point := grandpa;
      end else begin
        if ( IsRson ) and ( not IsRdaddy ) then begin
          LRsrt(daddy);
          daddy := point;
        end;
        if ( not IsRson ) and ( IsRdaddy ) then begin
          RRsrt(daddy);
          daddy := point;
        end;
        csrt[daddy] := COLOR_BLACK;
        csrt[grandpa] := COLOR_RED;
        if ( IsRdaddy ) then
          LRsrt(grandpa)
        else
          RRsrt(grandpa);
        break;
      end;
      //
    end else  //if daddy is black then simple exit from loop
      break;
  end;
end;

procedure TVKBinaryTreeSorter.DeleteItemFromSrtTree(DelNode: DWord);
var
  q, x, Dadx, Brotherx, lBrotherxSon, rBrotherxSon: DWord;
  ColorDelNode: Byte;

  procedure FillNodes;
  begin
    Dadx := dsrt[x];
    if rsrt[Dadx] = x then
      Brotherx := lsrt[Dadx]
    else
      Brotherx := rsrt[Dadx];
    lBrotherxSon := lsrt[Brotherx];
    rBrotherxSon := rsrt[Brotherx];
  end;

begin
  if (dsrt[DelNode] = FNULL) then exit;  (* not in tree *)
  if (rsrt[DelNode] = FNULL) then begin
    q := lsrt[DelNode];
    x := q;
    ColorDelNode := csrt[DelNode];
  end else begin
    if (lsrt[DelNode] = FNULL) then begin
      q := rsrt[DelNode];
      x := q;
      ColorDelNode := csrt[DelNode];
    end else begin
      q := lsrt[DelNode];
      if (rsrt[q] <> FNULL) then begin
        while true do begin
          q := rsrt[q];
          if (rsrt[q] = FNULL) then break;
        end;
        x := lsrt[q];
        ColorDelNode := csrt[q];
        rsrt[dsrt[q]] := lsrt[q];
        dsrt[lsrt[q]] := dsrt[q];
        lsrt[q] := lsrt[DelNode];
        dsrt[lsrt[DelNode]] := q;
        csrt[q] := csrt[DelNode];
      end else begin
        x := lsrt[q];
        ColorDelNode := csrt[q];
        dsrt[x] := q;
        csrt[q] := csrt[DelNode];
      end;
      rsrt[q] := rsrt[DelNode];
      dsrt[rsrt[DelNode]] := q;
    end;
  end;
  dsrt[q] := dsrt[DelNode];
  if (rsrt[dsrt[DelNode]] = DelNode) then
    rsrt[dsrt[DelNode]] := q
  else
    lsrt[dsrt[DelNode]] := q;
  dsrt[DelNode] := FNULL;
  // Now making Tree balanced if deleted node was black
  // x is the child of realy deleted node
  if ColorDelNode = COLOR_BLACK then begin
    while True do begin
      Dadx := dsrt[x];
      if Dadx > FNULL then begin //if Dadx is root
        csrt[x] := COLOR_BLACK;
        exit;
      end else begin
        if csrt[x] = COLOR_RED then begin
          csrt[x] := COLOR_BLACK;
          exit;
        end else begin
          while True do begin
            FillNodes;
            if rsrt[Dadx] = x then begin  // x is right son
              if csrt[Brotherx] = COLOR_RED then begin
                csrt[Dadx] := COLOR_RED;
                csrt[Brotherx] := COLOR_BLACK;
                RRsrt(Dadx);
                dsrt[x] := Dadx;
              end else begin
                if ( csrt[lBrotherxSon] = COLOR_BLACK ) and ( csrt[rBrotherxSon] = COLOR_BLACK ) then begin
                  csrt[Brotherx] := COLOR_RED;
                  x := Dadx;
                  break;
                end;
                if ( csrt[lBrotherxSon] = COLOR_BLACK ) then begin
                  csrt[Brotherx] := COLOR_RED;
                  csrt[rBrotherxSon] := COLOR_BLACK;
                  LRsrt(Brotherx);
                  dsrt[x] := Dadx;
                  break;
                end;
                csrt[Brotherx] := csrt[Dadx];
                csrt[Dadx] := COLOR_BLACK;
                csrt[lBrotherxSon] := COLOR_BLACK;
                RRsrt(Dadx);
                dsrt[x] := Dadx;
                exit;
              end;
            end else begin                // x is left son
              if csrt[Brotherx] = COLOR_RED then begin
                csrt[Dadx] := COLOR_RED;
                csrt[Brotherx] := COLOR_BLACK;
                LRsrt(Dadx);
                dsrt[x] := Dadx;
              end else begin
                if ( csrt[lBrotherxSon] = COLOR_BLACK ) and ( csrt[rBrotherxSon] = COLOR_BLACK ) then begin
                  csrt[Brotherx] := COLOR_RED;
                  x := Dadx;
                  break;
                end;
                if ( csrt[rBrotherxSon] = COLOR_BLACK ) then begin
                  csrt[Brotherx] := COLOR_RED;
                  csrt[lBrotherxSon] := COLOR_BLACK;
                  RRsrt(Brotherx);
                  dsrt[x] := Dadx;
                  break;
                end;
                csrt[Brotherx] := csrt[Dadx];
                csrt[Dadx] := COLOR_BLACK;
                csrt[rBrotherxSon] := COLOR_BLACK;
                LRsrt(Dadx);
                dsrt[x] := Dadx;
                exit;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TVKBinaryTreeSorter.DeleteNodeFromSrtTree(point: DWord);
begin
  if FDynamicSortHash then begin
    if ( dad[point] > FNILL )
       and ( lson[point] = FNILL )
       and ( rson[point] = FNILL ) then
        DeleteItemFromSrtTree( dad[point] - ( FNILL + 1 ) );
  end;
end;

function TVKBinaryTreeSorter.FirstSortItem: boolean;
begin
  Result := False;
  FCurrentSrtItem := rsrt[Succ(FNULL)];
  if FCurrentSrtItem <> FNULL then begin
    while lsrt[FCurrentSrtItem] <> FNULL do FCurrentSrtItem := lsrt[FCurrentSrtItem];
    FCurrentItem := rson[FNILL + 1 + FCurrentSrtItem];
    if FCurrentItem <> FNILL then begin
      while lson[FCurrentItem] <> FNILL do FCurrentItem := lson[FCurrentItem];
    end else
      raise Exception.Create('TVKBinaryTreeSorter.FirstSortItem: There is a root in hash table, but there aren''t items in binary tree!');
  end else begin
    Result := True;
  end;
end;

function TVKBinaryTreeSorter.NextSortItem: boolean;
var
  cmp, c: Integer;
  p: DWord;
  point: DWord;
begin
  Result := False;
  if rson[FCurrentItem] = FNILL then begin
    point := FCurrentItem;
    while True do begin
      point := dad[point];
      if point >= FNILL then begin
        break;
      end else begin
        c := CompareItems(PSortItem[point], PSortItem[FCurrentItem], cmp);
        if c > 0 then begin // PSortItem[point] > PSortItem[FCurrentItem]
          FCurrentItem := point;
          exit;
        end;
      end;
    end;
    // if prog is there then we neen move root point in the hash table
    if rsrt[FCurrentSrtItem] = FNULL then begin
      p := FCurrentSrtItem;
      while True do begin
        p := dsrt[p];
        if p >= FNULL then begin
          // Eof
          Result := True;
          break;
        end else begin
          c := CompareItems(PSortItem[rson[FNILL + 1 + p]], PSortItem[rson[FNILL + 1 + FCurrentSrtItem]], cmp);
          if c > 0 then begin //PSortItem[rson[FNILL + 1 + p]] > PSortItem[rson[FNILL + 1 + FCurrentSrtItem]]
            FCurrentSrtItem := p;
            break;
          end;
        end;
      end;
    end else begin
      FCurrentSrtItem := rsrt[FCurrentSrtItem];
      while lsrt[FCurrentSrtItem] <> FNULL do FCurrentSrtItem := lsrt[FCurrentSrtItem];
    end;
    // Move current point to the fist tree node
    if not Result then begin
      FCurrentItem := rson[FNILL + 1 + FCurrentSrtItem];
      if FCurrentItem <> FNILL then begin
        while lson[FCurrentItem] <> FNILL do FCurrentItem := lson[FCurrentItem];
      end else
        raise Exception.Create('TVKBinaryTreeSorter.NextSortItem: There is a root in hash table, but there aren''t items in binary tree!');
    end;
    //
  end else begin
    FCurrentItem := rson[FCurrentItem];
    while lson[FCurrentItem] <> FNILL do FCurrentItem := lson[FCurrentItem];
  end;
end;

function TVKBinaryTreeSorter.GetCurrentSortItem: PSORT_ITEM;
begin
  //Result := PSortItem[FCurrentItem];
  Result := PSORT_ITEM(pAnsiChar(FKeyPool) + ( FCurrentItem * ( ( SizeOf(DWord) shl 1 ) + FKeySize ) ) );
end;

function TVKBinaryTreeSorter.GetLastSortItem(var point: DWord): boolean;
var
  FCurrentSrtItem, FCurrentItem: DWord;
begin
  Result := False;
  FCurrentSrtItem := rsrt[Succ(FNULL)];
  if FCurrentSrtItem <> FNULL then begin
    while rsrt[FCurrentSrtItem] <> FNULL do FCurrentSrtItem := rsrt[FCurrentSrtItem];
    FCurrentItem := rson[FNILL + 1 + FCurrentSrtItem];
    if FCurrentItem <> FNILL then begin
      while rson[FCurrentItem] <> FNILL do FCurrentItem := rson[FCurrentItem];
      point := FCurrentItem;
    end else
      raise Exception.Create('TVKBinaryTreeSorter.GetLastSortItem: There is a root in hash table, but there aren''t items in binary tree!');
  end else begin
    Result := True;
  end;
end;

{ TVKRedBlackTreeSorter }

function TVKRedBlackTreeSorter.AddItemInTree(point: DWord): boolean;
var
  uncle, daddy, grandpa: DWord;
  IsRson, IsRdaddy: boolean;
begin

  Result := inherited AddItemInTree(point);

  // Now making Tree balanced if Item has been added
  if Result then begin
    color[point] := COLOR_RED;
    while True do begin
      daddy := dad[point];
      if daddy > FNILL then begin // point is root
        color[point] := COLOR_BLACK;
        break;
      end;
      if color[daddy] = COLOR_RED then begin //if daddy is red
        //
        IsRson := ( rson[daddy] = point );
        grandpa := dad[daddy];
        IsRdaddy := ( rson[grandpa] = daddy );
        if IsRdaddy then
          uncle := lson[grandpa]
        else
          uncle := rson[grandpa];
        if color[uncle] = COLOR_RED then begin
          color[uncle] := COLOR_BLACK;
          color[daddy] := COLOR_BLACK;
          color[grandpa] := COLOR_RED;
          point := grandpa;
        end else begin
          if ( IsRson ) and ( not IsRdaddy ) then begin
            LeftRotate(daddy);
            daddy := point;
          end;
          if ( not IsRson ) and ( IsRdaddy ) then begin
            RightRotate(daddy);
            daddy := point;
          end;
          color[daddy] := COLOR_BLACK;
          color[grandpa] := COLOR_RED;
          if ( IsRdaddy ) then
            LeftRotate(grandpa)
          else
            RightRotate(grandpa);
          break;
        end;
        //
      end else  //if daddy is black then simple exit from loop
        break;
    end;
  end;

end;

procedure TVKRedBlackTreeSorter.AllocateTree(RecordsCount: DWord);
begin
  inherited AllocateTree(RecordsCount);
  Fcolor := VKDBFMemMgr.oMem.GetMem( self, SizeOf(Byte) * ( FRecordsCount + 1 ) );
end;

procedure TVKRedBlackTreeSorter.DeleteItemFromTree(DelNode: DWord);
var
  q, x, Dadx, Brotherx, lBrotherxSon, rBrotherxSon: DWord;
  ColorDelNode: Byte;

  procedure FillNodes;
  begin
    Dadx := dad[x];
    if rson[Dadx] = x then
      Brotherx := lson[Dadx]
    else
      Brotherx := rson[Dadx];
    lBrotherxSon := lson[Brotherx];
    rBrotherxSon := rson[Brotherx];
  end;

begin
  if (dad[DelNode] = FNILL) then exit;  (* not in tree *)
  DeleteNodeFromSrtTree(DelNode);
  if (rson[DelNode] = FNILL) then begin
    q := lson[DelNode];
    x := q;
    ColorDelNode := color[DelNode];
  end else begin
    if (lson[DelNode] = FNILL) then begin
      q := rson[DelNode];
      x := q;
      ColorDelNode := color[DelNode];
    end else begin
      q := lson[DelNode];
      if (rson[q] <> FNILL) then begin
        while true do begin
          q := rson[q];
          if (rson[q] = FNILL) then break;
        end;
        x := lson[q];
        ColorDelNode := color[q];
        rson[dad[q]] := lson[q];
        dad[lson[q]] := dad[q];
        lson[q] := lson[DelNode];
        dad[lson[DelNode]] := q;
        color[q] := color[DelNode];
      end else begin
        x := lson[q];
        ColorDelNode := color[q];
        dad[x] := q;
        color[q] := color[DelNode];
      end;
      rson[q] := rson[DelNode];
      dad[rson[DelNode]] := q;
    end;
  end;
  dad[q] := dad[DelNode];
  if (rson[dad[DelNode]] = DelNode) then
    rson[dad[DelNode]] := q
  else
    lson[dad[DelNode]] := q;
  dad[DelNode] := FNILL;
  // Now making Tree balanced if deleted node was black
  // x is the child of realy deleted node
  if ColorDelNode = COLOR_BLACK then begin
    while True do begin
      Dadx := dad[x];
      if Dadx > FNILL then begin //if Dadx is root
        color[x] := COLOR_BLACK;
        exit;
      end else begin
        if color[x] = COLOR_RED then begin
          color[x] := COLOR_BLACK;
          exit;
        end else begin
          while True do begin
            FillNodes;
            if rson[Dadx] = x then begin  // x is right son
              if color[Brotherx] = COLOR_RED then begin
                color[Dadx] := COLOR_RED;
                color[Brotherx] := COLOR_BLACK;
                RightRotate(Dadx);
                dad[x] := Dadx;
              end else begin
                if ( color[lBrotherxSon] = COLOR_BLACK ) and ( color[rBrotherxSon] = COLOR_BLACK ) then begin
                  color[Brotherx] := COLOR_RED;
                  x := Dadx;
                  break;
                end;
                if ( color[lBrotherxSon] = COLOR_BLACK ) then begin
                  color[Brotherx] := COLOR_RED;
                  color[rBrotherxSon] := COLOR_BLACK;
                  LeftRotate(Brotherx);
                  dad[x] := Dadx;
                  break;
                end;
                color[Brotherx] := color[Dadx];
                color[Dadx] := COLOR_BLACK;
                color[lBrotherxSon] := COLOR_BLACK;
                RightRotate(Dadx);
                dad[x] := Dadx;
                exit;
              end;
            end else begin                // x is left son
              if color[Brotherx] = COLOR_RED then begin
                color[Dadx] := COLOR_RED;
                color[Brotherx] := COLOR_BLACK;
                LeftRotate(Dadx);
                dad[x] := Dadx;
              end else begin
                if ( color[lBrotherxSon] = COLOR_BLACK ) and ( color[rBrotherxSon] = COLOR_BLACK ) then begin
                  color[Brotherx] := COLOR_RED;
                  x := Dadx;
                  break;
                end;
                if ( color[rBrotherxSon] = COLOR_BLACK ) then begin
                  color[Brotherx] := COLOR_RED;
                  color[lBrotherxSon] := COLOR_BLACK;
                  RightRotate(Brotherx);
                  dad[x] := Dadx;
                  break;
                end;
                color[Brotherx] := color[Dadx];
                color[Dadx] := COLOR_BLACK;
                color[rBrotherxSon] := COLOR_BLACK;
                LeftRotate(Dadx);
                dad[x] := Dadx;
                exit;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TVKRedBlackTreeSorter.FreeTree;
begin
  VKDBFMemMgr.oMem.FreeMem(Fcolor);
  inherited FreeTree;
end;

function TVKRedBlackTreeSorter.GetColor(ndx: DWord): Byte;
begin
  Result := PByte( pAnsiChar(Fcolor) + ( ndx * SizeOf(Byte) ) )^;
end;

procedure TVKRedBlackTreeSorter.InitTree;
begin
  inherited InitTree;
end;

procedure TVKRedBlackTreeSorter.OnInitTree(i: Integer);
begin
  color[i] := COLOR_BLACK;
end;

procedure TVKRedBlackTreeSorter.SetColor(ndx: DWord; const Value: Byte);
begin
  PByte( pAnsiChar(Fcolor) + ( ndx * SizeOf(Byte) ) )^ := Value;
end;

{ TVKAVLTreeSorter }

function TVKAVLTreeSorter.AddItemInTree(point: DWord): boolean;
var
  daddy, son, grandson: DWord;
  IsRightHeightChange: boolean;
  NewBalance: ShortInt;
begin

  Result := inherited AddItemInTree(point);

  // Now making Tree balanced if Item has been added
  if Result then begin
    balance[point] := 0;
    daddy := dad[point];
    IsRightHeightChange := ( rson[daddy] = point );
    point := daddy;
    while point < FNILL do begin
      //Count new balance
      if IsRightHeightChange then
        NewBalance := IncBalance(point)
      else
        NewBalance := DecBalance(point);
      //Check NewBalance, there are three cases
      case NewBalance of
        0: break;
        1, -1:
          begin
            daddy := dad[point];
            IsRightHeightChange := ( rson[daddy] = point );
            point := daddy;
          end;
        2, -2:
          begin
            if NewBalance > 0 then begin
              son := rson[point];
              case balance[son] of
                0:
                  begin
                    LeftRotate(point);
                    balance[point] := 1;
                    balance[son] := -1;
                    break;
                  end;
                1:
                  begin
                    LeftRotate(point);
                    balance[point] := 0;
                    balance[son] := 0;
                    break;
                  end;
                -1:
                  begin
                    grandson := lson[son];
                    RightRotate(son);
                    LeftRotate(point);
                    case balance[grandson] of
                      -1:
                        begin
                          balance[point] := 0;
                          balance[son] := 1;
                          balance[grandson] := 0;
                        end;
                      0:
                        begin
                          balance[point] := 0;
                          balance[son] := 0;
                          balance[grandson] := 0;
                        end;
                      1:
                        begin
                          balance[point] := -1;
                          balance[son] := 0;
                          balance[grandson] := 0;
                        end;
                    else
                      raise Exception.Create('TVKAVLTreeSorter.AddItemInTree: Illegal range of balance factor!');
                    end;
                    break;
                  end;
              else
                raise Exception.Create('TVKAVLTreeSorter.AddItemInTree: Illegal range of balance factor!');
              end;
            end else begin
              son := lson[point];
              case balance[son] of
                -1:
                  begin
                    RightRotate(point);
                    balance[point] := 0;
                    balance[son] := 0;
                    break;
                  end;
                0:
                  begin
                    RightRotate(point);
                    balance[point] := -1;
                    balance[son] := 1;
                    break;
                  end;
                1:
                  begin
                    grandson := rson[son];
                    LeftRotate(son);
                    RightRotate(point);
                    case balance[grandson] of
                      -1:
                        begin
                          balance[point] := 1;
                          balance[son] := 0;
                          balance[grandson] := 0;
                        end;
                      0:
                        begin
                          balance[point] := 0;
                          balance[son] := 0;
                          balance[grandson] := 0;
                        end;
                      1:
                        begin
                          balance[point] := 0;
                          balance[son] := -1;
                          balance[grandson] := 0;
                        end;
                    else
                      raise Exception.Create('TVKAVLTreeSorter.AddItemInTree: Illegal range of balance factor!');
                    end;
                    break;
                  end;
              else
                raise Exception.Create('TVKAVLTreeSorter.AddItemInTree: Illegal range of balance factor!');
              end;
            end;
            break;
          end;
      else
        raise Exception.Create('TVKAVLTreeSorter.AddItemInTree: Illegal range of balance factor!');
      end;
    end;

  end;

end;

procedure TVKAVLTreeSorter.AllocateTree(RecordsCount: DWord);
begin
  inherited AllocateTree(RecordsCount);
  Fbalance := VKDBFMemMgr.oMem.GetMem( self, SizeOf(Byte) * ( FRecordsCount + 1 ) );
end;

function TVKAVLTreeSorter.DecBalance(ndx: DWord): ShortInt;
var
  q: PShortInt;
begin
  q := PShortInt( pAnsiChar(Fbalance) + ( ndx * SizeOf(ShortInt) ) );
  Dec( q^ );
  result := q^;
end;

procedure TVKAVLTreeSorter.DeleteItemFromTree(DelNode: DWord);
var
  BalanceInc: ShortInt;
  q, x : DWord;
  NewBalance: ShortInt;
  daddy, son, grandson: DWord;
begin
  if (dad[DelNode] = FNILL) then exit;
  DeleteNodeFromSrtTree(DelNode);
  if (rson[DelNode] = FNILL) then begin
    q := lson[DelNode];
    //
    x := dad[DelNode];
    if rson[x] = DelNode then
      BalanceInc := -1
    else
      BalanceInc := 1;
    //
  end else begin
    if (lson[DelNode] = FNILL) then begin
      q := rson[DelNode];
      //
      x := dad[DelNode];
      if rson[x] = DelNode then
        BalanceInc := -1
      else
        BalanceInc := 1;
      //
    end else begin
      q := lson[DelNode];
      if (rson[q] <> FNILL) then begin
        while true do begin
          q := rson[q];
          if (rson[q] = FNILL) then break;
        end;
        //
        x := dad[q];
        if (rson[x] = q) then
          BalanceInc := -1
        else
          BalanceInc := 1;
        //
        rson[dad[q]] := lson[q];
        dad[lson[q]] := dad[q];
        lson[q] := lson[DelNode];
        dad[lson[DelNode]] := q;
        balance[q] := balance[DelNode];
      end else begin
        //
        x := q;
        BalanceInc := 1;
        //
        balance[x] := balance[DelNode];
      end;
      rson[q] := rson[DelNode];
      dad[rson[DelNode]] := q;
    end;
  end;
  dad[q] := dad[DelNode];
  if (rson[dad[DelNode]] = DelNode) then
    rson[dad[DelNode]] := q
  else
    lson[dad[DelNode]] := q;
  dad[DelNode] := FNILL;
  // Now balanced tree
  // x is dad of realy deleted node
  while x < FNILL do begin
    NewBalance := IncBalance1(x, BalanceInc);
    //Check NewBalance, there are three cases
    case NewBalance of
      0:
        begin
          daddy := dad[x];
          if ( rson[daddy] = x ) then
            BalanceInc := -1
          else
            BalanceInc := 1;
          x := daddy;
        end;
      1, -1: break;
      2, -2:
        begin
          if NewBalance > 0 then begin
            son := rson[x];
            case balance[son] of
              0:
                begin
                  LeftRotate(x);
                  balance[x] := 1;
                  balance[son] := -1;
                  break;
                end;
              1:
                begin
                  LeftRotate(x);
                  balance[x] := 0;
                  balance[son] := 0;
                  //
                  x := dad[son];
                  if ( rson[x] = son ) then
                    BalanceInc := -1
                  else
                    BalanceInc := 1;
                  //
                end;
              -1:
                begin
                  grandson := lson[son];
                  RightRotate(son);
                  LeftRotate(x);
                  case balance[grandson] of
                    -1:
                      begin
                        balance[x] := 0;
                        balance[son] := 1;
                        balance[grandson] := 0;
                      end;
                    0:
                      begin
                        balance[x] := 0;
                        balance[son] := 0;
                        balance[grandson] := 0;
                      end;
                    1:
                      begin
                        balance[x] := -1;
                        balance[son] := 0;
                        balance[grandson] := 0;
                      end;
                  else
                    raise Exception.Create('TVKAVLTreeSorter.DeleteItemFromTree: Illegal range of balance factor!');
                  end;
                  //
                  x := dad[grandson];
                  if ( rson[x] = grandson ) then
                    BalanceInc := -1
                  else
                    BalanceInc := 1;
                  //
                end;
            else
              raise Exception.Create('TVKAVLTreeSorter.DeleteItemFromTree: Illegal range of balance factor!');
            end;
          end else begin
            son := lson[x];
            case balance[son] of
              -1:
                begin
                  RightRotate(x);
                  balance[x] := 0;
                  balance[son] := 0;
                  //
                  x := dad[son];
                  if ( rson[x] = son ) then
                    BalanceInc := -1
                  else
                    BalanceInc := 1;
                  //
                end;
              0:
                begin
                  RightRotate(x);
                  balance[x] := -1;
                  balance[son] := 1;
                  break;
                end;
              1:
                begin
                  grandson := rson[son];
                  LeftRotate(son);
                  RightRotate(x);
                  case balance[grandson] of
                    -1:
                      begin
                        balance[x] := 1;
                        balance[son] := 0;
                        balance[grandson] := 0;
                      end;
                    0:
                      begin
                        balance[x] := 0;
                        balance[son] := 0;
                        balance[grandson] := 0;
                      end;
                    1:
                      begin
                        balance[x] := 0;
                        balance[son] := -1;
                        balance[grandson] := 0;
                      end;
                  else
                    raise Exception.Create('TVKAVLTreeSorter.DeleteItemFromTree: Illegal range of balance factor!');
                  end;
                  //
                  x := dad[grandson];
                  if ( rson[x] = grandson ) then
                    BalanceInc := -1
                  else
                    BalanceInc := 1;
                  //
                end;
            else
              raise Exception.Create('TVKAVLTreeSorter.DeleteItemFromTree: Illegal range of balance factor!');
            end;
          end;
        end;
    else
      raise Exception.Create('TVKAVLTreeSorter.AddItemInTree: Illegal range of balance factor!');
    end;
  end;

end;

procedure TVKAVLTreeSorter.FreeTree;
begin
  VKDBFMemMgr.oMem.FreeMem(Fbalance);
  inherited FreeTree;
end;

function TVKAVLTreeSorter.GetBalance(ndx: DWord): ShortInt;
begin
  Result := PShortInt( pAnsiChar(Fbalance) + ( ndx * SizeOf(ShortInt) ) )^;
end;

function TVKAVLTreeSorter.IncBalance(ndx: DWord): ShortInt;
var
  q: PShortInt;
begin
  q := PShortInt( pAnsiChar(Fbalance) + ( ndx * SizeOf(ShortInt) ) );
  Inc( q^ );
  result := q^;
end;

function TVKAVLTreeSorter.IncBalance1(ndx: DWord;
  Value: ShortInt): ShortInt;
begin
  Result := balance[ndx];
  Result := Result + Value;
  balance[ndx] := Result;
end;

procedure TVKAVLTreeSorter.InitTree;
begin
  inherited InitTree;
end;

procedure TVKAVLTreeSorter.OnInitTree(i: Integer);
begin
  balance[i] := 0;
end;

procedure TVKAVLTreeSorter.SetBalance(ndx: DWord; const Value: ShortInt);
begin
  PShortInt( pAnsiChar(Fbalance) + ( ndx * SizeOf(ShortInt) ) )^ := Value;
end;

{ TVKBinaryTreeSorterAbstract }

function TVKBinaryTreeSorterAbstract.AddItemInTreeByEntry(
  point: DWord): boolean;
begin
  Result := AddItemInTree(point);
end;

procedure TVKBinaryTreeSorterAbstract.DeleteFromTreeByEntry(point: DWord);
begin
  DeleteItemFromTree(point);
end;

{ TVKTrieTreeSorter }

function TVKTrieTreeSorter.AddItem(var item: SORT_ITEM): boolean;
begin
  Result := AddNewItem(item);
  if Result then Inc(FKeyPoolCount);
end;

procedure TVKTrieTreeSorter.AddItemInSrtTree(point: DWord);
var
  p: DWord;
  c, cmp: Integer;
  uncle, daddy, grandpa: DWord;
  IsRson, IsRdaddy: boolean;
begin
  p := Succ(FNULL);
  cmp := 1;
  c := 1;
  rsrt[point] := FNULL;
  lsrt[point] := FNULL;
  while true do begin
    if (c > 0) then begin
      if (rsrt[p] <> FNULL) then begin
        p := rsrt[p];
      end else begin
        rsrt[p] := point;
        dsrt[point] := p;
        break;
      end;
    end else begin
      if (lsrt[p] <> FNULL) then begin
        p := lsrt[p];
      end else begin
        lsrt[p] := point;
        dsrt[point] := p;
        break;
      end;
    end;
    //DONE: CompareItems
    c := CompareItems(PHashSortItem[point], PHashSortItem[p], cmp);
  end;
  // Now making Tree balanced if Item has been added
  csrt[point] := COLOR_RED;
  while True do begin
    daddy := dsrt[point];
    if daddy > FNULL then begin // point is root
      csrt[point] := COLOR_BLACK;
      break;
    end;
    if csrt[daddy] = COLOR_RED then begin //if daddy is red
      //
      IsRson := ( rsrt[daddy] = point );
      grandpa := dsrt[daddy];
      IsRdaddy := ( rsrt[grandpa] = daddy );
      if IsRdaddy then
        uncle := lsrt[grandpa]
      else
        uncle := rsrt[grandpa];
      if csrt[uncle] = COLOR_RED then begin
        csrt[uncle] := COLOR_BLACK;
        csrt[daddy] := COLOR_BLACK;
        csrt[grandpa] := COLOR_RED;
        point := grandpa;
      end else begin
        if ( IsRson ) and ( not IsRdaddy ) then begin
          LRsrt(daddy);
          daddy := point;
        end;
        if ( not IsRson ) and ( IsRdaddy ) then begin
          RRsrt(daddy);
          daddy := point;
        end;
        csrt[daddy] := COLOR_BLACK;
        csrt[grandpa] := COLOR_RED;
        if ( IsRdaddy ) then
          LRsrt(grandpa)
        else
          RRsrt(grandpa);
        break;
      end;
      //
    end else  //if daddy is black then simple exit from loop
      break;
  end;
end;

function TVKTrieTreeSorter.AddNewItem(var item: SORT_ITEM): boolean;
var
  i, j, c: Integer;
  l, b: Byte;
  CurrentNode, PredNode, NewNode: PVKTrieNode;
  hsh: DWord;
begin
  Result := True;
  hsh := Hash(@item);
  FRoot.lson := HashTable[hsh];
  PredNode := @FRoot;
  CurrentNode := FRoot.lson;
  i := 0;
  while i < FKeySize do begin
    if CurrentNode = nil then begin
      CurrentNode := FMemSrcList.GetNewTrieNode;
      //{
      j := 0;
      if (Succ(i) < FKeySize) then begin
        while ((j < 5) and (i + j < FKeySize)) do begin
          CurrentNode.KeyChars[j] := item.key[i + j];
          Inc(j);
        end;
        CurrentNode.l := j;
      end else begin
        CurrentNode.KeyChar := item.key[i];
        Inc(j);
      end;
      //}
      PredNode.lson := CurrentNode;
      PredNode := CurrentNode;
      CurrentNode := nil;
    end else begin
      //{
      j := 1;
      l := CurrentNode.l and $07;
      if (l > 0) then begin
        b := (CurrentNode.l and $38) shr 3;
        NewNode := FMemSrcList.GetNewTrieNode;
        NewNode.lson := CurrentNode;
        NewNode.KeyChar := CurrentNode.KeyChars[b];
        PredNode.lson := NewNode;
        Dec(l);
        Inc(b);
        if l = 1 then begin
          CurrentNode.KeyChar := CurrentNode.KeyChars[b];
          CurrentNode.rson := nil;
          CurrentNode.l := 0;
        end else begin
          CurrentNode.l := (b shl 3) or l;
        end;
        CurrentNode := NewNode;
      end;
      //}
      FCompareCharsMethod(  self,
                            item.key[i],
                            CurrentNode.KeyChar,
                            c);
      if          c < 0 then begin
        NewNode := FMemSrcList.GetNewTrieNode;
        NewNode.KeyChar := item.key[i];
        NewNode.rson := CurrentNode;
        PredNode.lson := NewNode;
        PredNode := NewNode;
        CurrentNode := nil;
      end else if c = 0 then begin
        PredNode := CurrentNode;
        CurrentNode := CurrentNode.lson;
      end else if c > 0 then begin
        while True do begin
          PredNode := CurrentNode;
          CurrentNode := CurrentNode.rson;
          if CurrentNode = nil then begin
            CurrentNode := FMemSrcList.GetNewTrieNode;
            CurrentNode.KeyChar := item.key[i];
            PredNode.rson := CurrentNode;
            PredNode := CurrentNode;
            CurrentNode := nil;
            break;
          end else begin
            FCompareCharsMethod(  self,
                                  item.key[i],
                                  CurrentNode.KeyChar,
                                  c);
            if          c < 0 then begin
              NewNode := FMemSrcList.GetNewTrieNode;
              NewNode.KeyChar := item.key[i];
              NewNode.rson := CurrentNode;
              PredNode.rson := NewNode;
              PredNode := NewNode;
              CurrentNode := nil;
              break;
            end else if c = 0 then begin
              PredNode := CurrentNode;
              CurrentNode := CurrentNode.lson;
              break;
            end;
          end;
        end;
      end;
    end;
    Inc(i, j);
  end;
  // add RID
  if CurrentNode = nil then begin
    CurrentNode := FMemSrcList.GetNewTrieNode;
    PredNode.lson := CurrentNode;
    CurrentNode.RID := item.RID;
    CurrentNode.l := $80;
  end else begin
    if FUnique then begin
      Result := False;
    end else begin
      while CurrentNode <> nil do begin
        PredNode := CurrentNode;
        CurrentNode := CurrentNode.rson;
      end;
      CurrentNode := FMemSrcList.GetNewTrieNode;
      PredNode.rson := CurrentNode;
      CurrentNode.RID := item.RID;
      CurrentNode.l := $80;
    end;
  end;
  //
  if HashTable[hsh] = nil then begin
    HashTable[hsh] := FRoot.lson;
    if FHashSortItemPool[hsh] = nil then begin
      FHashSortItemPool[hsh] := TVKSortItem.Create( SizeOf(DWord) * 2 + FKeySize );
      HashSortItem[hsh] := item;
    end else
      raise Exception.Create('TVKTrieTreeSorter.AddNewItem: Illegal use HashSortItem array!');
    if FDynamicSortHash then
      if Result then AddItemInSrtTree(hsh);
  end;
  if HashTable[hsh] <> FRoot.lson then begin
    HashTable[hsh] := FRoot.lson;
  end;
  //
end;

procedure TVKTrieTreeSorter.AllocateHashTable;
begin
  FHashTable := VKDBFMemMgr.oMem.GetMem( self, SizeOf(PVKTrieNode) * FHashTableSizeValue );
  SetLength(FHashSortItemPool, FHashTableSizeValue);
  FNULL := FHashTableSizeValue;
  FCurrentSrtItem := FNULL;
  Flsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 1 ) );
  Frsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 2 ) );
  Fdsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 1 ) );
  Fcsrt := VKDBFMemMgr.oMem.GetMem( self, SizeOf(DWord) * ( FNULL + 1 ) );
end;

procedure TVKTrieTreeSorter.AllocateSpace;
begin
  //
end;

procedure TVKTrieTreeSorter.Clear;
begin
  inherited Clear;
  FMemSrcList.Clear;
  InitHashTable;  
end;

constructor TVKTrieTreeSorter.Create(RecordsCount: DWord; KeySize: Word;
  CompareMethod: TOnCompareSortItems;
  CompareCharsMethod: TOnCompareChars;
  CompareRIDsMethod: TOnCompareRIDs;
  UniqueFeature: boolean; HashTableSizePar: THashTableSizeType;
  GetHashCodeMethod: TOnGetHashCode;
  MaxBitsInHashCodePar: TMaxBitsInHashCode; DynamicSortHash: boolean;
  TmpStream: TProxyStream;
  InnerSorterClass: TVKInnerSorterClass;
  BufferSize: Integer;
  InnerSorterItemsCount: Integer);
begin
  inherited Create( RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSizePar,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash,
                    TmpStream,
                    InnerSorterClass,
                    BufferSize,
                    InnerSorterItemsCount);
  FRoot.KeyChar := 0;
  FRoot.lson := nil;
  FRoot.rson := nil;
  FMemSrcList := TVKMemSourceList.Create(
    ( ( ( ( KeySize + SizeOf( DWORD ) ) * RecordsCount ) div 2 ) div ( SizeOf( TVKTrieNode ) ) ) * SizeOf( TVKTrieNode )
    , 4096);
  AllocateHashTable;
  InitHashTable;
end;

destructor TVKTrieTreeSorter.Destroy;
begin
  FreeHashTable;
  FreeAndNil(FMemSrcList);
  inherited Destroy;
end;

procedure TVKTrieTreeSorter.DropDownTiers(CurrentNode: PVKTrieNode);
var
  k: Integer;
  l, b: Byte;
begin
  while CurrentNode.l <> $80 do begin
    FTrack[FTrackCurent] := CurrentNode;
    if CurrentNode.l = 0 then begin
      FTrack_Sort_Item.key[FCharCurent] := CurrentNode.KeyChar;
      Inc(FCharCurent);
    end else begin
      l := CurrentNode.l and $07;
      b := (CurrentNode.l and $38) shr 3;
      for k := 0 to Pred(l) do begin
        FTrack_Sort_Item.key[FCharCurent] := CurrentNode.KeyChars[b + k];
        Inc(FCharCurent);
      end;
    end;
    CurrentNode := CurrentNode.lson;
    Inc(FTrackCurent);
  end;
  FTrack[FTrackCurent] := CurrentNode;
  FTrack_Sort_Item.RID := CurrentNode.RID;
end;

function TVKTrieTreeSorter.FirstSortItem: boolean;
var
  CurrentNode: PVKTrieNode;
begin
  Result := ( FKeyPoolCount = 0 );
  //
  FCurrentSrtItem := rsrt[Succ(FNULL)];
  if FCurrentSrtItem <> FNULL then begin
    while lsrt[FCurrentSrtItem] <> FNULL do FCurrentSrtItem := lsrt[FCurrentSrtItem];
  end else begin
    Result := True;
    Exit;
  end;
  FRoot.lson := HashTable[FCurrentSrtItem];
  //
  CurrentNode := FRoot.lson;
  FTrackCurent := 0;
  FCharCurent := 0;
  DropDownTiers(CurrentNode);
end;

procedure TVKTrieTreeSorter.FreeHashTable;
begin
  VKDBFMemMgr.oMem.FreeMem(FHashTable);
  FHashSortItemPool := nil;
  VKDBFMemMgr.oMem.FreeMem(Flsrt);
  VKDBFMemMgr.oMem.FreeMem(Frsrt);
  VKDBFMemMgr.oMem.FreeMem(Fdsrt);
  VKDBFMemMgr.oMem.FreeMem(Fcsrt);
end;

function TVKTrieTreeSorter.GetCsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Fcsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKTrieTreeSorter.GetCurrentSortItem: PSORT_ITEM;
begin
  Result := @FTrack_Sort_Item;
end;

function TVKTrieTreeSorter.GetDsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Fdsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKTrieTreeSorter.GetHashSortItem(Ind: DWord): SORT_ITEM;
begin
  Result := FHashSortItemPool[Ind].SortItem;
end;

function TVKTrieTreeSorter.GetHashTable(Ind: Integer): PVKTrieNode;
begin
  Result := PPVKTrieNode( pAnsiChar(FHashTable) + SizeOf(PVKTrieNode) * Ind )^;
end;

(*
function TVKTrieTreeSorter.GetKey(ndx: DWord): PByte;
begin
  raise Exception.Create('TVKTrieTreeSorter.GetKey: Not implemented!');
end;
*)

function TVKTrieTreeSorter.GetLsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Flsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKTrieTreeSorter.GetPHashSortItem(Ind: Integer): PSORT_ITEM;
begin
  Result := FHashSortItemPool[Ind].PSortItem;
end;

function TVKTrieTreeSorter.GetPSortItem(ndx: DWord): PSORT_ITEM;
begin
  //
  Result := nil;
end;

(*
function TVKTrieTreeSorter.GetRecNo(ndx: DWord): DWord;
begin
  raise Exception.Create('TVKTrieTreeSorter.GetRecNo: Not implemented!');
end;
*)

function TVKTrieTreeSorter.GetRsrt(ndx: DWord): DWord;
begin
  Result := PDWord( pAnsiChar(Frsrt) + ( ndx * SizeOf(DWord) ) )^;
end;

function TVKTrieTreeSorter.GetSortArray(ndx: DWord): DWord;
begin
  raise Exception.Create('TVKTrieTreeSorter.GetSortArray: Not implemented!');
end;

function TVKTrieTreeSorter.GetSortItem(ndx: DWord): SORT_ITEM;
begin
  raise Exception.Create('TVKTrieTreeSorter.GetSortItem: Not implemented!');
end;

procedure TVKTrieTreeSorter.InitHashTable;
var
  i: Integer;
begin

  for i := 0 to Pred(FHashTableSizeValue) do begin
    HashTable[i] := nil;
    if FHashSortItemPool[i] <> nil then begin
      FreeAndNil(FHashSortItemPool[i]);
    end;
  end;

  // Init tree of hash table
  rsrt[Succ(FNULL)] := FNULL;
  for i := 0 to FNULL do begin
    dsrt[i] := FNULL;
    if FDynamicSortHash then
      csrt[i] := COLOR_BLACK;
  end;
  lsrt[FNULL] := FNULL;
  rsrt[FNULL] := FNULL;

end;

procedure TVKTrieTreeSorter.LRsrt(point: DWord);
var
  p: DWord;
begin
  p := rsrt[point];
  rsrt[point] := lsrt[p];
  dsrt[rsrt[point]] := point;
  dsrt[p] := dsrt[point];
  if rsrt[dsrt[p]] = point then
    rsrt[dsrt[p]] := p
  else
    lsrt[dsrt[p]] := p;
  lsrt[p] := point;
  dsrt[point] := p;
end;

function TVKTrieTreeSorter.NextSortItem: boolean;
var
  k, c, cmp: Integer;
  CurrentNode: PVKTrieNode;
  l, b: Byte;
  p: DWord;
begin
  Result := False;
  CurrentNode := FTrack[FTrackCurent];
  while ((CurrentNode.rson = nil) or (CurrentNode.l > 0)) do begin
    if FTrackCurent = 0 then begin
      //
      if rsrt[FCurrentSrtItem] = FNULL then begin
        p := FCurrentSrtItem;
        while True do begin
          p := dsrt[p];
          if p >= FNULL then begin
            // Eof
            Result := True;
            break;
          end else begin
            c := CompareItems(PHashSortItem[p], PHashSortItem[FCurrentSrtItem], cmp);
            if c > 0 then begin //PHashSortItem[p] > PHashSortItem[FCurrentSrtItem]
              FCurrentSrtItem := p;
              break;
            end;
          end;
        end;
      end else begin
        FCurrentSrtItem := rsrt[FCurrentSrtItem];
        while lsrt[FCurrentSrtItem] <> FNULL do FCurrentSrtItem := lsrt[FCurrentSrtItem];
      end;
      if Result then exit;
      FRoot.lson := HashTable[FCurrentSrtItem];
      CurrentNode := FRoot.lson;
      FTrackCurent := 0;
      FCharCurent := 0;
      DropDownTiers(CurrentNode);
      exit;
      //
    end else begin
      Dec(FTrackCurent);
      l := FTrack[FTrackCurent].l and $07;
      if FTrack[FTrackCurent].l = 0 then begin
        Dec(FCharCurent);
      end else begin
        Dec(FCharCurent, l);
      end;
    end;
    CurrentNode := FTrack[FTrackCurent];
  end;
  FTrack[FTrackCurent] := FTrack[FTrackCurent].rson;

  CurrentNode := FTrack[FTrackCurent];
  if CurrentNode.l <> $80 then begin
    l := CurrentNode.l and $07;
    if l = 0 then begin
      FTrack_Sort_Item.key[FCharCurent] := CurrentNode.KeyChar;
      Inc(FCharCurent);
    end else begin
      b := (CurrentNode.l and $38) shr 3;
      for k := 0 to Pred(l) do begin
        FTrack_Sort_Item.key[FCharCurent] := CurrentNode.KeyChars[b + k];
        Inc(FCharCurent);
      end;
    end;
  end else
    FTrack_Sort_Item.RID := CurrentNode.RID;

  CurrentNode := FTrack[FTrackCurent].lson;
  Inc(FTrackCurent);
  DropDownTiers(CurrentNode);
end;

procedure TVKTrieTreeSorter.ReleaseSpace;
begin
  //
end;

procedure TVKTrieTreeSorter.RRsrt(point: DWord);
var
  p: DWord;
begin
  p := lsrt[point];
  lsrt[point] := rsrt[p];
  dsrt[lsrt[point]] := point;
  dsrt[p] := dsrt[point];
  if rsrt[dsrt[p]] = point then
    rsrt[dsrt[p]] := p
  else
    lsrt[dsrt[p]] := p;
  rsrt[p] := point;
  dsrt[point] := p;
end;

procedure TVKTrieTreeSorter.SetCsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Fcsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKTrieTreeSorter.SetDsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Fdsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKTrieTreeSorter.SetHashSortItem(Ind: DWord;
  const Value: SORT_ITEM);
begin
  FHashSortItemPool[Ind].SortItem := Value;
end;

procedure TVKTrieTreeSorter.SetHashTable(Ind: Integer;
  const Value: PVKTrieNode);
begin
  PPVKTrieNode( pAnsiChar(FHashTable) + SizeOf(PVKTrieNode) * Ind )^ := Value;
end;

(*
procedure TVKTrieTreeSorter.SetKey(ndx: DWord; const Value: PByte);
begin
  raise Exception.Create('TVKTrieTreeSorter.SetKey: Not implemented!');
end;
*)

procedure TVKTrieTreeSorter.SetLsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Flsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

(*
procedure TVKTrieTreeSorter.SetRecNo(ndx: DWord; const Value: DWord);
begin
  raise Exception.Create('TVKTrieTreeSorter.SetRecNo: Not implemented!');
end;
*)

procedure TVKTrieTreeSorter.SetRsrt(ndx: DWord; const Value: DWord);
begin
  PDWord( pAnsiChar(Frsrt) + ( ndx * SizeOf(DWord) ) )^ := Value;
end;

procedure TVKTrieTreeSorter.SetSortArray(ndx: DWord; const Value: DWord);
begin
  raise Exception.Create('TVKTrieTreeSorter.SetSortArray: Not implemented!');
end;

procedure TVKTrieTreeSorter.SetSortItem(ndx: DWord;
  const Value: SORT_ITEM);
begin
  raise Exception.Create('TVKTrieTreeSorter.SetSortItem: Not implemented!');
end;

procedure TVKTrieTreeSorter.Sort;
var
  pipeIn, pipeOut: DWord;

  procedure pipePut(Value: DWord);
  begin
    csrt[pipeIn and ( FNULL - 1 )] := Value;
    Inc(pipeIn);
  end;

  function pipeGet: DWord;
  begin
    Result := csrt[pipeOut and ( FNULL - 1 )];
    Inc(pipeOut);
  end;

  procedure AddElement(point: DWord);
  var
    p: DWord;
    c, cmp: Integer;
  begin
    p := Succ(FNULL);
    cmp := 1;
    c := 1;
    rsrt[point] := FNULL;
    lsrt[point] := FNULL;
    while true do begin
      if (c > 0) then begin
        if (rsrt[p] <> FNULL) then begin
          p := rsrt[p];
        end else begin
          rsrt[p] := point;
          dsrt[point] := p;
          exit;
        end;
      end else begin
        if (lsrt[p] <> FNULL) then begin
          p := lsrt[p];
        end else begin
          lsrt[p] := point;
          dsrt[point] := p;
          exit;
        end;
      end;
      c := CompareItems(PHashSortItem[point], PHashSortItem[p], cmp);
    end;
  end;

  procedure SortRoots;
  var
    qb, qe, qm: DWord;
  begin
    qb := pipeGet;
    qe := pipeGet;
    if ( qe - qb ) > 2 then begin
      qm := (qb + qe) shr 1;
      if HashTable[qm] <> nil then AddElement(qm);
      pipePut(qb);
      pipePut(Pred(qm));
      pipePut(Succ(qm));
      pipePut(qe);
    end else
      for qm := qb to qe do
        if HashTable[qm] <> nil then AddElement(qm);
  end;

begin

  if not FDynamicSortHash then begin

    rsrt[Succ(FNULL)] := FNULL;

    pipeIn := 0;
    pipeOut := 0;
    pipePut(0);
    pipePut(Pred(FNULL));
    repeat
      SortRoots;
    until pipeIn = pipeOut;

  end;

end;

{ TVKMemSourceItem }

constructor TVKMemSourceItem.Create(memSize: DWORD);
begin
  inherited Create;
  FMemory := VKDBFMemMgr.oMem.GetMem(self, memSize);
  FillChar(FMemory^, memSize, 0);
  FCount := memSize div SizeOf(TVKTrieNode);
  if FCount = 0 then raise Exception.Create('TVKMemSourceItem.Create: No room!');
  FCurrent := 0
end;

destructor TVKMemSourceItem.Destroy;
begin
  VKDBFMemMgr.oMem.FreeMem(FMemory);
  inherited Destroy;
end;

function TVKMemSourceItem.GetNewTrieNode: PVKTrieNode;
begin
  if FCurrent < FCount then begin
    Result := PVKTrieNode(pAnsiChar(FMemory) + SizeOf(TVKTrieNode) * FCurrent);
    Result.l := 0;
  end else
    Result := nil;
  Inc(FCurrent);
end;

{ TVKMemSourceList }

procedure TVKMemSourceList.Clear;
begin
  inherited Clear;
  if not FDestroy then Start;
end;

constructor TVKMemSourceList.Create(FirstBlockSize, MinBlockSize: DWORD);
begin
  inherited Create;
  FDestroy := false;
  FFirstBlockSize := FirstBlockSize;
  FMinBlockSize := MinBlockSize;
  Start;
end;

destructor TVKMemSourceList.Destroy;
begin
  FDestroy := true;
  inherited Destroy;
end;

function TVKMemSourceList.GetNewTrieNode: PVKTrieNode;
begin
  Result := FCurrentBlock.GetNewTrieNode;
  if Result = nil then begin
    FCurrentBlockSize := FCurrentBlockSize - FCurrentBlockSize shr 2;
    if FCurrentBlockSize < FMinBlockSize then FCurrentBlockSize := FMinBlockSize;
    FCurrentBlock := TVKMemSourceItem.Create(FCurrentBlockSize);
    Add(FCurrentBlock);
    Result := FCurrentBlock.GetNewTrieNode;
  end;
end;

procedure TVKMemSourceList.Start;
begin
  FCurrentBlockSize := FFirstBlockSize;
  if FCurrentBlockSize < FMinBlockSize then FCurrentBlockSize := FMinBlockSize;
  FCurrentBlock := TVKMemSourceItem.Create(FCurrentBlockSize);
  Add(FCurrentBlock);
end;

{ TVKSortItem }

procedure TVKSortItem.Clear;
begin
  FillChar(FPSortItem^, FSize, 0);
end;

constructor TVKSortItem.Create(Size: Integer);
begin
  inherited Create;
  FSize := Size;
  FPSortItem := VKDBFMemMgr.oMem.GetMem( self, FSize );
  Clear;
end;

destructor TVKSortItem.Destroy;
begin
  VKDBFMemMgr.oMem.FreeMem(FPSortItem);
  inherited Destroy;
end;

function TVKSortItem.GetSortItem: SORT_ITEM;
begin
  Result := FPSortItem^;
end;

procedure TVKSortItem.SetSortItem(const Value: SORT_ITEM);
begin
  Move(Value, FPSortItem^, FSize);
end;

{ TVKAbsorptionSorter }

function TVKAbsorptionSorter.AddItem(var item: SORT_ITEM): boolean;
begin
  Result := False;
  if FInnerSorter.AddItem(item) then begin
    Inc(FKeyPoolCount);
    Result := True;
  end;
  if FInnerSorter.CountAddedItems = FSortItemsPerBuffer then
    FlushInnerSorterToTmpStream;
end;

procedure TVKAbsorptionSorter.AllocateSpace;
begin
  //
end;

procedure TVKAbsorptionSorter.Clear;
begin
  inherited Clear;
  FBlockCount := 0;
  FTmpStream.Seek(0, 0);
  FTmpStream.SetEndOfFile;
end;

constructor TVKAbsorptionSorter.Create(RecordsCount: DWord; KeySize: Word;
  CompareMethod: TOnCompareSortItems; CompareCharsMethod: TOnCompareChars;
  CompareRIDsMethod: TOnCompareRIDs; UniqueFeature: boolean;
  HashTableSizePar: THashTableSizeType; GetHashCodeMethod: TOnGetHashCode;
  MaxBitsInHashCodePar: TMaxBitsInHashCode; DynamicSortHash: boolean;
  TmpStream: TProxyStream; InnerSorterClass: TVKInnerSorterClass;
  BufferSize: Integer; InnerSorterItemsCount: Integer);
begin
  inherited Create( RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSizePar,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash,
                    TmpStream,
                    InnerSorterClass,
                    BufferSize,
                    InnerSorterItemsCount);
  FInnerSorter := FInnerSorterClass.Create(RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSizePar,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash);
  FSortItemSize := SizeOf(DWord) + FKeySize;
  FSortItemsPerBuffer := ( FBufferSize - SizeOf(DWord) ) div FSortItemSize;
  FBlockCount := 0;
  FBuff1 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff2 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff3 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
end;

destructor TVKAbsorptionSorter.Destroy;
begin
  VKDBFMemMgr.oMem.FreeMem(FBuff1);
  VKDBFMemMgr.oMem.FreeMem(FBuff2);
  VKDBFMemMgr.oMem.FreeMem(FBuff3);
  inherited Destroy;
end;

function TVKAbsorptionSorter.FirstSortItem: boolean;
var
  RealRead: DWord;
begin
  Result := False;
  FCurrentSortItemInBlock := 0;
  FTmpStream.Seek(0, 0);
  repeat
    RealRead := FTmpStream.Read(FBuff1^, FBufferSize);
    if RealRead <> FBufferSize then begin
      Result := True;
      Exit;
    end;
    FSortItemsInBlock := PDWord(FBuff1)^;
  until FSortItemsInBlock <> 0 ;
end;

procedure TVKAbsorptionSorter.FlushInnerSorterToTmpStream;
var
  SortItem, sipnt: PSORT_ITEM;
  q: DWord;
begin
  sipnt := PSORT_ITEM(pAnsiChar(FBuff1));
  FInnerSorter.Sort;
  q := 0;
  if not FInnerSorter.FirstSortItem then begin
    repeat
      SortItem := FInnerSorter.CurrentSortItem;
      Move((@SortItem.RID)^, (@sipnt.RID)^, FSortItemSize);
      sipnt := PSORT_ITEM(pAnsiChar(sipnt) + FSortItemSize);
      Inc(q);
    until FInnerSorter.NextSortItem;
  end else
    raise Exception.Create('TVKAbsorptionSorter.FlushInnerSorterToTmpStream: Error with inner sorter!');
  PDWord(FBuff1)^ := q;
  FTmpStream.Write(FBuff1^, FBufferSize);
  Inc(FBlockCount);
  FInnerSorter.Clear;
end;

function TVKAbsorptionSorter.GetCurrentSortItem: PSORT_ITEM;
begin
  Result := PSORT_ITEM(pAnsiChar(FBuff1) + FCurrentSortItemInBlock * FSortItemSize);
end;

(*
function TVKAbsorptionSorter.GetKey(ndx: DWord): PByte;
begin
  raise Exception.Create('TVKAbsorptionSorter.GetKey: Not implemented!');
end;
*)

function TVKAbsorptionSorter.GetPSortItem(ndx: DWord): PSORT_ITEM;
begin
  raise Exception.Create('TVKAbsorptionSorter.GetPSortItem: Not implemented!');
end;

(*
function TVKAbsorptionSorter.GetRecNo(ndx: DWord): DWord;
begin
  raise Exception.Create('TVKAbsorptionSorter.GetRecNo: Not implemented!');
end;
*)

function TVKAbsorptionSorter.GetSortArray(ndx: DWord): DWord;
begin
  raise Exception.Create('TVKAbsorptionSorter.GetSortArray: Not implemented!');
end;

function TVKAbsorptionSorter.GetSortItem(ndx: DWord): SORT_ITEM;
begin
  raise Exception.Create('TVKAbsorptionSorter.GetSortItem: Not implemented!');
end;

function TVKAbsorptionSorter.NextSortItem: boolean;
var
  RealRead: DWord;
begin
  Result := False;
  Inc(FCurrentSortItemInBlock);
  if FCurrentSortItemInBlock >= FSortItemsInBlock then begin
    FCurrentSortItemInBlock := 0;
    repeat
      RealRead := FTmpStream.Read(FBuff1^, FBufferSize);
      if RealRead <> FBufferSize then begin
        Result := True;
        Exit;
      end;
      FSortItemsInBlock := PDWord(FBuff1)^;
    until FSortItemsInBlock <> 0 ;
  end;
end;

procedure TVKAbsorptionSorter.ReleaseSpace;
begin
  //
end;

(*
procedure TVKAbsorptionSorter.SetKey(ndx: DWord; const Value: PByte);
begin
  raise Exception.Create('TVKAbsorptionSorter.SetKey: Not implemented!');
end;
*)

(*
procedure TVKAbsorptionSorter.SetRecNo(ndx: DWord; const Value: DWord);
begin
  raise Exception.Create('TVKAbsorptionSorter.SetRecNo: Not implemented!');
end;
*)

procedure TVKAbsorptionSorter.SetSortArray(ndx: DWord; const Value: DWord);
begin
  raise Exception.Create('TVKAbsorptionSorter.SetSortArray: Not implemented!');
end;

procedure TVKAbsorptionSorter.SetSortItem(ndx: DWord;
  const Value: SORT_ITEM);
begin
  raise Exception.Create('TVKAbsorptionSorter.SetSortItem: Not implemented!');
end;

procedure TVKAbsorptionSorter.Sort;
var
  JoinBlock, CurrentBlock, WriteBlock: DWord;
  cnt1, cnt2: DWord;
  psi1, psi2, psi, sipnt: PSORT_ITEM;
  c, cmp: Integer;
begin
  if FInnerSorter.CountAddedItems > 0 then FlushInnerSorterToTmpStream;

  //
  PDWord(FBuff1)^ := 0;
  PDWord(FBuff2)^ := 0;
  PDWord(FBuff3)^ := 0;

  for JoinBlock := 1 to Pred(FBlockCount) do begin

    FTmpStream.Seek(JoinBlock * FBufferSize, 0);
    FTmpStream.Read(FBuff2^, FBufferSize);
    cnt2 := 0;

    WriteBlock := 0;
    for CurrentBlock := 0 to Pred(JoinBlock) do begin
      FTmpStream.Seek(CurrentBlock * FBufferSize, 0);
      FTmpStream.Read(FBuff1^, FBufferSize);
      cnt1 := 0;

      while cnt1 < PDWord(FBuff1)^ do begin

        if PDWord(FBuff3)^ = FSortItemsPerBuffer then begin
          FTmpStream.Seek(WriteBlock * FBufferSize, 0);
          FTmpStream.Write(FBuff3^, FBufferSize);
          Inc(WriteBlock);
          PDWord(FBuff3)^ := 0;
        end;

        psi1 := PSORT_ITEM( pAnsiChar(FBuff1) + cnt1 * FSortItemSize );
        if cnt2 < PDWord(FBuff2)^ then begin
          psi2 := PSORT_ITEM( pAnsiChar(FBuff2) + cnt2 * FSortItemSize );
          c := CompareItems(psi1, psi2, cmp);
          if cmp = 0 then begin
            psi := psi1;
            if Unique then begin
              Inc(cnt2);
              Dec(FKeyPoolCount);
            end;
            Inc(cnt1);
          end else
            if c < 0 then begin
              psi := psi1;
              Inc(cnt1);
            end else begin
              psi := psi2;
              Inc(cnt2);
            end;
        end else begin
          psi := psi1;
          Inc(cnt1);
        end;

        sipnt := PSORT_ITEM( pAnsiChar(FBuff3) + PDWord(FBuff3)^ * FSortItemSize );
        Move((@psi.RID)^, (@sipnt.RID)^, FSortItemSize);
        Inc(PDWord(FBuff3)^);

      end;

    end;

    while cnt2 < PDWord(FBuff2)^ do begin
      psi := PSORT_ITEM( pAnsiChar(FBuff2) + cnt2 * FSortItemSize );
      Inc(cnt2);
      sipnt := PSORT_ITEM( pAnsiChar(FBuff3) + PDWord(FBuff3)^ * FSortItemSize );
      Move((@psi.RID)^, (@sipnt.RID)^, FSortItemSize);
      Inc(PDWord(FBuff3)^);
      if PDWord(FBuff3)^ = FSortItemsPerBuffer then begin
        FTmpStream.Seek(WriteBlock * FBufferSize, 0);
        FTmpStream.Write(FBuff3^, FBufferSize);
        Inc(WriteBlock);
        PDWord(FBuff3)^ := 0;
      end;
    end;
    if PDWord(FBuff3)^ > 0 then begin
      FTmpStream.Seek(WriteBlock * FBufferSize, 0);
      FTmpStream.Write(FBuff3^, FBufferSize);
      Inc(WriteBlock);
      PDWord(FBuff3)^ := 0;
    end;
    if WriteBlock <= JoinBlock then begin
      PDWord(FBuff3)^ := 0;
      while WriteBlock <= JoinBlock do begin
        FTmpStream.Seek(WriteBlock * FBufferSize, 0);
        FTmpStream.Write(FBuff3^, FBufferSize);
        Inc(WriteBlock);
      end;
    end;

  end;
  //

  FTmpStream.SetEndOfFile;
end;

{ TVKMergeSorter }

procedure TVKMergeSorter.AddFreeList(NewFreeEntry: DWord; Buffer: Pointer);
begin
  PMergeBlockHeader(Buffer).next_block := FFreeList;
  PMergeBlockHeader(Buffer).count := 0;
  FTmpStream.Seek( NewFreeEntry * FBufferSize, 0 );
  FTmpStream.Write( Buffer^, SizeOf(TMergeBlockHeader) );
  FFreeList := NewFreeEntry;
end;

function TVKMergeSorter.AddItem(var item: SORT_ITEM): boolean;
begin
  Result := False;
  if FInnerSorter.AddItem(item) then begin
    Inc(FKeyPoolCount);
    Result := True;
  end;
  if FInnerSorter.CountAddedItems = FSortItemsPerInnerSorter then
    FlushInnerSorterToTmpStream;
end;

procedure TVKMergeSorter.AllocateSpace;
begin
  //
end;

procedure TVKMergeSorter.Clear;
var
  i: Integer;
begin
  inherited Clear;
  FBlockCount := 0;
  for i := 0 to Pred(FEntryCount) do FEntries[i] := NULL_REF;
  FEntryPoint := 0;
  FFreeList := NULL_REF;
  FTmpStream.Seek(0, 0);
  FTmpStream.SetEndOfFile;
  if Assigned(FIterator) then FreeAndNil(FIterator);
  if Assigned(FIt1) then FreeAndNil(FIt1);
  if Assigned(FIt2) then FreeAndNil(FIt2);
end;

constructor TVKMergeSorter.Create(RecordsCount: DWord; KeySize: Word;
  CompareMethod: TOnCompareSortItems; CompareCharsMethod: TOnCompareChars;
  CompareRIDsMethod: TOnCompareRIDs; UniqueFeature: boolean;
  HashTableSizePar: THashTableSizeType; GetHashCodeMethod: TOnGetHashCode;
  MaxBitsInHashCodePar: TMaxBitsInHashCode; DynamicSortHash: boolean;
  TmpStream: TProxyStream; InnerSorterClass: TVKInnerSorterClass;
  BufferSize: Integer; InnerSorterItemsCount: Integer);
var
  i: Integer;
begin
  inherited Create( RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSizePar,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash,
                    TmpStream,
                    InnerSorterClass,
                    BufferSize,
                    InnerSorterItemsCount);
  FInnerSorter := FInnerSorterClass.Create(RecordsCount,
                    KeySize,
                    CompareMethod,
                    CompareCharsMethod,
                    CompareRIDsMethod,
                    UniqueFeature,
                    HashTableSizePar,
                    GetHashCodeMethod,
                    MaxBitsInHashCodePar,
                    DynamicSortHash);
  FSortItemSize := SizeOf(DWord) + FKeySize;
  FSortItemsPerBuffer := ( FBufferSize - SizeOf(DWord) * 2 ) div FSortItemSize;
  if      FInnerSorterItemsCount > 0 then
    FSortItemsPerInnerSorter := FInnerSorterItemsCount
  else if FInnerSorterItemsCount = 0 then
    FSortItemsPerInnerSorter := FSortItemsPerBuffer
  else if FInnerSorterItemsCount < 0 then
    FSortItemsPerInnerSorter := FSortItemsPerBuffer * DWord( - FInnerSorterItemsCount );
  FBlockCount := 0;
  FBuff1 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff2 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff3 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff4 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FEntryCount := ( RecordsCount div FSortItemsPerInnerSorter ) + 1;
  SetLength(FEntries, FEntryCount);
  for i := 0 to Pred(FEntryCount) do FEntries[i] := NULL_REF;
  FEntryPoint := 0;
  FFreeList := NULL_REF;
  FIterator := nil;
  FIt1 := nil;
  FIt2 := nil;
  SomeMoreAllocate;
end;

destructor TVKMergeSorter.Destroy;
begin
  VKDBFMemMgr.oMem.FreeMem(FBuff1);
  VKDBFMemMgr.oMem.FreeMem(FBuff2);
  VKDBFMemMgr.oMem.FreeMem(FBuff3);
  VKDBFMemMgr.oMem.FreeMem(FBuff4);
  FEntries := nil;
  SomeMoreRelease;
  inherited Destroy;
end;

function TVKMergeSorter.FirstSortItem: boolean;
begin
  case FEntryPoint of
    0: Result := True;
    else
      begin
        FIterator := GetIterator(FEntryPoint);
        Result := FIterator.First;
      end;
  end;
end;

procedure TVKMergeSorter.FlushInnerSorterToTmpStream;
var
  psi: PSORT_ITEM;
  k, l, m: DWord;
begin
  FInnerSorter.Sort;
  if not FInnerSorter.FirstSortItem then begin
    m := NULL_REF;
    k := GetFreeBuffer(FBuff3);
    l := k;
    repeat
      psi := FInnerSorter.CurrentSortItem;
      if psi <> nil then OutSortItem(FBuff3, psi, l, m);
    until FInnerSorter.NextSortItem;
    FlushOut(FBuff3, True, l, m);
    FEntries[FEntryPoint] := k;
    Inc(FEntryPoint);
  end;
  FInnerSorter.Clear;
end;

procedure TVKMergeSorter.FlushOut(Buffer: Pointer; Eof: boolean; var CurrentBlock, PredBlock: DWord);
begin
  if PredBlock <> NULL_REF then begin
    PMergeBlockHeader(FBuff4).next_block := CurrentBlock;
    FTmpStream.Seek( PredBlock * FBufferSize, 0 );
    FTmpStream.Write( FBuff4^, FBufferSize );
  end;
  if CurrentBlock <> NULL_REF then begin
    if Eof then begin
      FTmpStream.Seek( CurrentBlock * FBufferSize, 0 );
      FTmpStream.Write( Buffer^, FBufferSize );
    end else
      Move(Buffer^, FBuff4^, FBufferSize);
  end;
end;

function TVKMergeSorter.GetCurrentSortItem: PSORT_ITEM;
begin
  Result := FIterator.GetCurrentSortItem;
end;

function TVKMergeSorter.GetFreeBuffer(Buffer: Pointer): DWord;
begin
  Result := FFreeList;
  if Result <> NULL_REF then begin
    FTmpStream.Seek( Result * FBufferSize, 0 );
    FTmpStream.Read( Buffer^, SizeOf(TMergeBlockHeader) );
    FFreeList := PMergeBlockHeader(Buffer).next_block;
  end else begin
    Result := FBlockCount;
    Inc(FBlockCount);
  end;
  PMergeBlockHeader(Buffer).count := 0;
  PMergeBlockHeader(Buffer).next_block := NULL_REF;
end;

function TVKMergeSorter.GetPSortItem(ndx: DWord): PSORT_ITEM;
begin
  raise Exception.Create('TVKMergeSorter.GetPSortItem: Not implemented!');
end;

function TVKMergeSorter.GetSortArray(ndx: DWord): DWord;
begin
  raise Exception.Create('TVKMergeSorter.GetSortArray: Not implemented!');
end;

function TVKMergeSorter.GetSortItem(ndx: DWord): SORT_ITEM;
begin
  raise Exception.Create('TVKMergeSorter.GetSortItem: Not implemented!');
end;

function TVKMergeSorter.NextSortItem: boolean;
begin
  Result := FIterator.Next;
end;

procedure TVKMergeSorter.OutSortItem(Buffer: Pointer; psi: PSORT_ITEM; var CurrentBlock, PredBlock: DWord);
var
  sipnt: PSORT_ITEM;
begin
  sipnt := PSORT_ITEM( pAnsiChar(Buffer) + SizeOf(DWord) + FSortItemSize * PMergeBlockHeader(Buffer).count );
  Move((@psi.RID)^, (@sipnt.RID)^, FSortItemSize);
  Inc(PMergeBlockHeader(Buffer).count);
  if PMergeBlockHeader(Buffer).count = FSortItemsPerBuffer then begin
    FlushOut(Buffer, False, CurrentBlock, PredBlock);
    PredBlock := CurrentBlock;
    CurrentBlock := GetFreeBuffer(Buffer);
  end;
end;

procedure TVKMergeSorter.ReleaseSpace;
begin
  //
end;

procedure TVKMergeSorter.SetSortArray(ndx: DWord; const Value: DWord);
begin
  raise Exception.Create('TVKMergeSorter.SetSortArray: Not implemented!');
end;

procedure TVKMergeSorter.SetSortItem(ndx: DWord; const Value: SORT_ITEM);
begin
  raise Exception.Create('TVKMergeSorter.SetSortItem: Not implemented!');
end;

function TVKMergeSorter.Merge(Entry1, Entry2: DWord): DWord;
var
  it1: TVKMergeIterator;
  it2: TVKMergeIterator;
  itMerge: TVKMerge2PathIterator;
begin
  it1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry1], FBuff1, FBufferSize, FSortItemSize);
  it2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry2], FBuff2, FBufferSize, FSortItemSize);
  itMerge := TVKMerge2PathIterator.Create(self, it1, it2);
  try
    Result := MergeInternal(itMerge);
  finally
    FreeAndNil(it1);
    FreeAndNil(it2);
    FreeAndNil(itMerge);
  end;
end;

procedure TVKMergeSorter.Sort;
var
  i, j: DWord;
begin
  if FInnerSorter.CountAddedItems > 0 then FlushInnerSorterToTmpStream;
  while FEntryPoint > 2 do begin
    i := 0;
    j := 0;
    while Succ(i) < FEntryPoint do begin
      FEntries[j] := Merge(i, i + 1);
      Inc(j);
      Inc(i, 2);
    end;
    if Succ(i) = FEntryPoint then begin
      FEntries[j] := FEntries[i];
      Inc(j);
    end;
    FEntryPoint := j;
  end;
end;

procedure TVKMergeSorter.SomeMoreAllocate;
begin
  //
end;

procedure TVKMergeSorter.SomeMoreRelease;
begin
  if Assigned(FIterator) then FreeAndNil(FIterator);
  if Assigned(FIt1) then FreeAndNil(FIt1);
  if Assigned(FIt2) then FreeAndNil(FIt2);
end;

function TVKMergeSorter.GetIterator(n: Integer; base: Integer = 0): TVKMergeIteratorAbstract;
begin
  Result := nil;
  if Assigned(FIterator) then FreeAndNil(FIterator);
  if Assigned(FIt1) then FreeAndNil(FIt1);
  if Assigned(FIt2) then FreeAndNil(FIt2);
  case n of
    1: Result := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
    2:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        Result := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
      end;
  end;
end;

function TVKMergeSorter.MergeInternal(
  Iterator: TVKMergeIteratorAbstract): DWord;
var
  l, m: DWord;
  psi: PSORT_ITEM;
begin
  Iterator.First;
  m := NULL_REF;
  Result := GetFreeBuffer(FBuff3);
  l := Result;
  while not Iterator.Eof do begin
    psi := Iterator.GetCurrentSortItem;
    if psi <> nil then OutSortItem(FBuff3, psi, l, m);
    Iterator.Next;
  end;
  FlushOut(FBuff3, True, l, m);
end;

{ TVKMergeIterator }

constructor TVKMergeIterator.Create(
    Owner: TVKMergeSorterBase;
    TmpStream: TProxyStream;
    Entry: DWord;
    Buff: Pointer;
    BufferSize: DWord;
    SortItemSize: DWord
  );
begin
  inherited Create;
  FTmpStream := TmpStream;
  FEntry := Entry;
  FBufferSize := BufferSize;
  FBuff := Buff;
  FOwner := Owner;
  FSortItemSize := SortItemSize;
  FEof := False;
end;

destructor TVKMergeIterator.Destroy;
begin
  inherited Destroy;
end;

function TVKMergeIterator.First: boolean;
var
  bh: TMergeBlockHeader;
begin
  FEof := False;
  FTmpStream.Seek( FEntry * FBufferSize, 0 );
  FTmpStream.Read( FBuff^, FBufferSize );
  bh := PMergeBlockHeader(FBuff)^;
  FOwner.AddFreeList(FEntry, @bh);
  if PMergeBlockHeader(FBuff).count > 0  then begin
    FCurrentSortItemInBlock := 0;
  end else
    FEof := True;
  Result := FEof;
end;

function TVKMergeIterator.GetCurrentSortItem: PSORT_ITEM;
begin
  if FEof then
    Result := nil
  else
    Result := PSORT_ITEM(pAnsiChar(FBuff) + SizeOf(DWord) + FCurrentSortItemInBlock * FSortItemSize);
end;

function TVKMergeIterator.GetEof: Boolean;
begin
  Result := FEof;
end;

function TVKMergeIterator.Next: boolean;
var
  bh: TMergeBlockHeader;
begin
  if not FEof then begin
    FEof := False;
    Inc(FCurrentSortItemInBlock);
    if FCurrentSortItemInBlock >= PMergeBlockHeader(FBuff).count then begin
      FEntry := PMergeBlockHeader(FBuff).next_block;
      if FEntry <> NULL_REF then begin
        FTmpStream.Seek( FEntry * FBufferSize, 0 );
        FTmpStream.Read( FBuff^, FBufferSize );
        bh := PMergeBlockHeader(FBuff)^;
        FOwner.AddFreeList(FEntry, @bh);
        if PMergeBlockHeader(FBuff).count > 0  then begin
          FCurrentSortItemInBlock := 0;
        end else
          FEof := True;
      end else
        FEof := True;
    end;
  end;
  Result := FEof;
end;

{ TVKMerge2PathIterator }

constructor TVKMerge2PathIterator.Create(Owner: TVKMergeSorterBase;
  Iterator1, Iterator2: TVKMergeIteratorAbstract);
begin
  inherited Create;
  FOwner := Owner;
  FIterator1 := Iterator1;
  FIterator2 := Iterator2;
end;

destructor TVKMerge2PathIterator.Destroy;
begin
  inherited Destroy;
end;

procedure TVKMerge2PathIterator.FillCurrentIterator;
var
  psi1, psi2: PSORT_ITEM;
  c, cmp: Integer;
begin
  psi1 := FIterator1.GetCurrentSortItem;
  psi2 := FIterator2.GetCurrentSortItem;
  if psi1 <> nil then begin
    if psi2 <> nil then begin
      c := FOwner.CompareItems(psi1, psi2, cmp);
      if cmp = 0 then begin
        FCurrentIterator := FIterator1;
        if FOwner.Unique then FIterator2.Next;
      end else
        if c < 0 then
          FCurrentIterator := FIterator1
        else
          FCurrentIterator := FIterator2;
    end else
      FCurrentIterator := FIterator1;
  end else
    if psi2 <> nil then FCurrentIterator := FIterator2;
end;

function TVKMerge2PathIterator.First: boolean;
begin
  FIterator2.First;
  FIterator1.First;
  FillCurrentIterator;
  Result := Eof;
end;

function TVKMerge2PathIterator.GetCurrentSortItem: PSORT_ITEM;
begin
  Result := FCurrentIterator.GetCurrentSortItem;
end;

function TVKMerge2PathIterator.GetEof: Boolean;
begin
  Result := FIterator1.Eof and FIterator2.Eof;
end;

function TVKMerge2PathIterator.Next: boolean;
begin
  FCurrentIterator.Next;
  FillCurrentIterator;
  Result := Eof;
end;

{ TVK4PathMergeSorter }

procedure TVK4PathMergeSorter.Clear;
begin
  inherited Clear;
  if Assigned(FIt1)         then FreeAndNil(FIt1);
  if Assigned(FIt2)         then FreeAndNil(FIt2);
  if Assigned(FTwoPathIt1)  then FreeAndNil(FTwoPathIt1);
  if Assigned(FTwoPathIt2)  then FreeAndNil(FTwoPathIt2);
  if Assigned(FIt3)         then FreeAndNil(FIt3);
  if Assigned(FIt4)         then FreeAndNil(FIt4);
end;

function TVK4PathMergeSorter.GetIterator(
  n: Integer; base: Integer = 0): TVKMergeIteratorAbstract;
begin
  if Assigned(FIt1)         then FreeAndNil(FIt1);
  if Assigned(FIt2)         then FreeAndNil(FIt2);
  if Assigned(FTwoPathIt1)  then FreeAndNil(FTwoPathIt1);
  if Assigned(FIt3)         then FreeAndNil(FIt3);
  if Assigned(FIt4)         then FreeAndNil(FIt4);
  if Assigned(FTwoPathIt2)  then FreeAndNil(FTwoPathIt2);
  case n of
    3:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        FTwoPathIt1 := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
        FIt3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 2], FBuff5, FBufferSize, FSortItemSize);
        Result := TVKMerge2PathIterator.Create(self, FTwoPathIt1, FIt3);
      end;
    4:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        FTwoPathIt1 := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
        FIt3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 2], FBuff5, FBufferSize, FSortItemSize);
        FIt4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 3], FBuff6, FBufferSize, FSortItemSize);
        FTwoPathIt2 := TVKMerge2PathIterator.Create(self, FIt3, FIt4);
        Result := TVKMerge2PathIterator.Create(self, FTwoPathIt1, FTwoPathIt2);
      end;
    else
      Result := inherited GetIterator(n, base);
  end;
end;

function TVK4PathMergeSorter.Merge(Entry1, Entry2, Entry3, Entry4: DWord): DWord;
var
  it1: TVKMergeIterator;
  it2: TVKMergeIterator;
  itMerge1: TVKMerge2PathIterator;
  it3: TVKMergeIterator;
  it4: TVKMergeIterator;
  itMerge2: TVKMerge2PathIterator;
  itMerge: TVKMerge2PathIterator;
begin
  it1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry1], FBuff1, FBufferSize, FSortItemSize);
  it2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry2], FBuff2, FBufferSize, FSortItemSize);
  itMerge1 := TVKMerge2PathIterator.Create(self, it1, it2);
  it3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry3], FBuff5, FBufferSize, FSortItemSize);
  it4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry4], FBuff6, FBufferSize, FSortItemSize);
  itMerge2 := TVKMerge2PathIterator.Create(self, it3, it4);
  itMerge := TVKMerge2PathIterator.Create(self, itMerge1, itMerge2);
  try
    Result := MergeInternal(itMerge);
  finally
    FreeAndNil(it1);
    FreeAndNil(it2);
    FreeAndNil(itMerge1);
    FreeAndNil(it3);
    FreeAndNil(it4);
    FreeAndNil(itMerge2);
    FreeAndNil(itMerge);
  end;
end;

procedure TVK4PathMergeSorter.SomeMoreAllocate;
begin
  inherited SomeMoreAllocate;
  FBuff5 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff6 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
end;

procedure TVK4PathMergeSorter.SomeMoreRelease;
begin
  if Assigned(FIt1)         then FreeAndNil(FIt1);
  if Assigned(FIt2)         then FreeAndNil(FIt2);
  if Assigned(FTwoPathIt1)  then FreeAndNil(FTwoPathIt1);
  if Assigned(FTwoPathIt2)  then FreeAndNil(FTwoPathIt2);
  if Assigned(FIt3)         then FreeAndNil(FIt3);
  if Assigned(FIt4)         then FreeAndNil(FIt4);
  VKDBFMemMgr.oMem.FreeMem(FBuff5);
  VKDBFMemMgr.oMem.FreeMem(FBuff6);
  inherited SomeMoreRelease;
end;

procedure TVK4PathMergeSorter.Sort;
var
  Iterator: TVKMergeIteratorAbstract;
  i, j, k: DWord;
begin
  if FInnerSorter.CountAddedItems > 0 then FlushInnerSorterToTmpStream;
  while FEntryPoint > 4 do begin
    j := 0;
    i := 0;
    while ( i + 3 ) < FEntryPoint do begin
      FEntries[j] := Merge(i, i + 1, i + 2, i + 3);
      Inc(j);
      Inc(i, 4);
    end;
    k := FEntryPoint - i;
    if k = 0 then begin
    end else if k = 1 then begin
      FEntries[j] := FEntries[i];
      Inc(j);
    end else if k > 1 then begin
      Iterator := GetIterator(k, i);
      try
        FEntries[j] := MergeInternal(Iterator);
        Inc(j);
      finally
        FreeAndNil(Iterator);
      end;
    end;
    FEntryPoint := j;
  end;
end;

{ TVK8PathMergeSorter }

procedure TVK8PathMergeSorter.Clear;
begin
  inherited Clear;
  if Assigned(FIt1)           then FreeAndNil(FIt1);
  if Assigned(FIt2)           then FreeAndNil(FIt2);
  if Assigned(FTwoPathIt1)    then FreeAndNil(FTwoPathIt1);
  if Assigned(FIt3)           then FreeAndNil(FIt3);
  if Assigned(FIt4)           then FreeAndNil(FIt4);
  if Assigned(FTwoPathIt2)    then FreeAndNil(FTwoPathIt2);
  if Assigned(FTwoPathIt1_2)  then FreeAndNil(FTwoPathIt1_2);
  if Assigned(FIt5)           then FreeAndNil(FIt5);
  if Assigned(FIt6)           then FreeAndNil(FIt6);
  if Assigned(FTwoPathIt3)    then FreeAndNil(FTwoPathIt3);
  if Assigned(FIt7)           then FreeAndNil(FIt7);
  if Assigned(FIt8)           then FreeAndNil(FIt8);
  if Assigned(FTwoPathIt4)    then FreeAndNil(FTwoPathIt4);
  if Assigned(FTwoPathIt3_4)  then FreeAndNil(FTwoPathIt3_4);
end;

function TVK8PathMergeSorter.GetIterator(n,
  base: Integer): TVKMergeIteratorAbstract;
begin
  if Assigned(FIt1)           then FreeAndNil(FIt1);
  if Assigned(FIt2)           then FreeAndNil(FIt2);
  if Assigned(FTwoPathIt1)    then FreeAndNil(FTwoPathIt1);
  if Assigned(FIt3)           then FreeAndNil(FIt3);
  if Assigned(FIt4)           then FreeAndNil(FIt4);
  if Assigned(FTwoPathIt2)    then FreeAndNil(FTwoPathIt2);
  if Assigned(FTwoPathIt1_2)  then FreeAndNil(FTwoPathIt1_2);
  if Assigned(FIt5)           then FreeAndNil(FIt5);
  if Assigned(FIt6)           then FreeAndNil(FIt6);
  if Assigned(FTwoPathIt3)    then FreeAndNil(FTwoPathIt3);
  if Assigned(FIt7)           then FreeAndNil(FIt7);
  if Assigned(FIt8)           then FreeAndNil(FIt8);
  if Assigned(FTwoPathIt4)    then FreeAndNil(FTwoPathIt4);
  if Assigned(FTwoPathIt3_4)  then FreeAndNil(FTwoPathIt3_4);
  case n of
    5:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        FTwoPathIt1 := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
        FIt3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 2], FBuff5, FBufferSize, FSortItemSize);
        FIt4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 3], FBuff6, FBufferSize, FSortItemSize);
        FTwoPathIt2 := TVKMerge2PathIterator.Create(self, FIt3, FIt4);
        FTwoPathIt1_2 := TVKMerge2PathIterator.Create(self, FTwoPathIt1, FTwoPathIt2);
        FIt5 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 4], FBuff7, FBufferSize, FSortItemSize);
        Result := TVKMerge2PathIterator.Create(self, FTwoPathIt1_2, FIt5);
      end;
    6:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        FTwoPathIt1 := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
        FIt3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 2], FBuff5, FBufferSize, FSortItemSize);
        FIt4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 3], FBuff6, FBufferSize, FSortItemSize);
        FTwoPathIt2 := TVKMerge2PathIterator.Create(self, FIt3, FIt4);
        FTwoPathIt1_2 := TVKMerge2PathIterator.Create(self, FTwoPathIt1, FTwoPathIt2);
        FIt5 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 4], FBuff7, FBufferSize, FSortItemSize);
        FIt6 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 5], FBuff8, FBufferSize, FSortItemSize);
        FTwoPathIt3 := TVKMerge2PathIterator.Create(self, FIt5, FIt6);
        Result := TVKMerge2PathIterator.Create(self, FTwoPathIt1_2, FTwoPathIt3);
      end;
    7:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        FTwoPathIt1 := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
        FIt3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 2], FBuff5, FBufferSize, FSortItemSize);
        FIt4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 3], FBuff6, FBufferSize, FSortItemSize);
        FTwoPathIt2 := TVKMerge2PathIterator.Create(self, FIt3, FIt4);
        FTwoPathIt1_2 := TVKMerge2PathIterator.Create(self, FTwoPathIt1, FTwoPathIt2);
        FIt5 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 4], FBuff7, FBufferSize, FSortItemSize);
        FIt6 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 5], FBuff8, FBufferSize, FSortItemSize);
        FTwoPathIt3 := TVKMerge2PathIterator.Create(self, FIt5, FIt6);
        FIt7 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 6], FBuff9, FBufferSize, FSortItemSize);
        FTwoPathIt4 := TVKMerge2PathIterator.Create(self, FTwoPathIt3, FIt7);
        Result := TVKMerge2PathIterator.Create(self, FTwoPathIt1_2, FTwoPathIt4);
      end;
    8:
      begin
        FIt1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 0], FBuff1, FBufferSize, FSortItemSize);
        FIt2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 1], FBuff2, FBufferSize, FSortItemSize);
        FTwoPathIt1 := TVKMerge2PathIterator.Create(self, FIt1, FIt2);
        FIt3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 2], FBuff5, FBufferSize, FSortItemSize);
        FIt4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 3], FBuff6, FBufferSize, FSortItemSize);
        FTwoPathIt2 := TVKMerge2PathIterator.Create(self, FIt3, FIt4);
        FTwoPathIt1_2 := TVKMerge2PathIterator.Create(self, FTwoPathIt1, FTwoPathIt2);
        FIt5 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 4], FBuff7, FBufferSize, FSortItemSize);
        FIt6 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 5], FBuff8, FBufferSize, FSortItemSize);
        FTwoPathIt3 := TVKMerge2PathIterator.Create(self, FIt5, FIt6);
        FIt7 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 6], FBuff9, FBufferSize, FSortItemSize);
        FIt8 := TVKMergeIterator.Create(self, FTmpStream, FEntries[base + 7], FBuff10, FBufferSize, FSortItemSize);
        FTwoPathIt4 := TVKMerge2PathIterator.Create(self, FIt7, FIt8);
        FTwoPathIt3_4 := TVKMerge2PathIterator.Create(self, FTwoPathIt3, FTwoPathIt4);
        Result := TVKMerge2PathIterator.Create(self, FTwoPathIt1_2, FTwoPathIt3_4);
      end;
    else
      Result := inherited GetIterator(n, base);
  end;
end;

function TVK8PathMergeSorter.Merge(Entry1, Entry2, Entry3, Entry4, Entry5,
  Entry6, Entry7, Entry8: DWord): DWord;
var
  it1: TVKMergeIterator;
  it2: TVKMergeIterator;
  itMerge1: TVKMerge2PathIterator;
  it3: TVKMergeIterator;
  it4: TVKMergeIterator;
  itMerge2: TVKMerge2PathIterator;
  itMerge1_2: TVKMerge2PathIterator;
  it5: TVKMergeIterator;
  it6: TVKMergeIterator;
  itMerge3: TVKMerge2PathIterator;
  it7: TVKMergeIterator;
  it8: TVKMergeIterator;
  itMerge4: TVKMerge2PathIterator;
  itMerge3_4: TVKMerge2PathIterator;
  itMerge: TVKMerge2PathIterator;
begin
  it1 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry1], FBuff1, FBufferSize, FSortItemSize);
  it2 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry2], FBuff2, FBufferSize, FSortItemSize);
  itMerge1 := TVKMerge2PathIterator.Create(self, it1, it2);
  it3 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry3], FBuff5, FBufferSize, FSortItemSize);
  it4 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry4], FBuff6, FBufferSize, FSortItemSize);
  itMerge2 := TVKMerge2PathIterator.Create(self, it3, it4);
  itMerge1_2 := TVKMerge2PathIterator.Create(self, itMerge1, itMerge2);
  it5 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry5], FBuff7, FBufferSize, FSortItemSize);
  it6 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry6], FBuff8, FBufferSize, FSortItemSize);
  itMerge3 := TVKMerge2PathIterator.Create(self, it5, it6);
  it7 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry7], FBuff9, FBufferSize, FSortItemSize);
  it8 := TVKMergeIterator.Create(self, FTmpStream, FEntries[Entry8], FBuff10, FBufferSize, FSortItemSize);
  itMerge4 := TVKMerge2PathIterator.Create(self, it7, it8);
  itMerge3_4 := TVKMerge2PathIterator.Create(self, itMerge3, itMerge4);
  itMerge := TVKMerge2PathIterator.Create(self, itMerge1_2, itMerge3_4);
  try
    Result := MergeInternal(itMerge);
  finally
    FreeAndNil(it1);
    FreeAndNil(it2);
    FreeAndNil(itMerge1);
    FreeAndNil(it3);
    FreeAndNil(it4);
    FreeAndNil(itMerge2);
    FreeAndNil(itMerge1_2);
    FreeAndNil(it5);
    FreeAndNil(it6);
    FreeAndNil(itMerge3);
    FreeAndNil(it7);
    FreeAndNil(it8);
    FreeAndNil(itMerge4);
    FreeAndNil(itMerge3_4);
    FreeAndNil(itMerge);
  end;
end;

procedure TVK8PathMergeSorter.SomeMoreAllocate;
begin
  inherited SomeMoreAllocate;
  FBuff7 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff8 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff9 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
  FBuff10 := VKDBFMemMgr.oMem.GetMem(self, FBufferSize);
end;

procedure TVK8PathMergeSorter.SomeMoreRelease;
begin
  if Assigned(FIt1)           then FreeAndNil(FIt1);
  if Assigned(FIt2)           then FreeAndNil(FIt2);
  if Assigned(FTwoPathIt1)    then FreeAndNil(FTwoPathIt1);
  if Assigned(FIt3)           then FreeAndNil(FIt3);
  if Assigned(FIt4)           then FreeAndNil(FIt4);
  if Assigned(FTwoPathIt2)    then FreeAndNil(FTwoPathIt2);
  if Assigned(FTwoPathIt1_2)  then FreeAndNil(FTwoPathIt1_2);
  if Assigned(FIt5)           then FreeAndNil(FIt5);
  if Assigned(FIt6)           then FreeAndNil(FIt6);
  if Assigned(FTwoPathIt3)    then FreeAndNil(FTwoPathIt3);
  if Assigned(FIt7)           then FreeAndNil(FIt7);
  if Assigned(FIt8)           then FreeAndNil(FIt8);
  if Assigned(FTwoPathIt4)    then FreeAndNil(FTwoPathIt4);
  if Assigned(FTwoPathIt3_4)  then FreeAndNil(FTwoPathIt3_4);
  VKDBFMemMgr.oMem.FreeMem(FBuff7);
  VKDBFMemMgr.oMem.FreeMem(FBuff8);
  VKDBFMemMgr.oMem.FreeMem(FBuff9);
  VKDBFMemMgr.oMem.FreeMem(FBuff10);
  inherited SomeMoreRelease;
end;

procedure TVK8PathMergeSorter.Sort;
var
  Iterator: TVKMergeIteratorAbstract;
  i, j , k: DWord;
begin
  if FInnerSorter.CountAddedItems > 0 then FlushInnerSorterToTmpStream;
  while FEntryPoint > 8 do begin
    j := 0;
    i := 0;
    while ( i + 7 ) < FEntryPoint do begin
      FEntries[j] := Merge(i, i + 1, i + 2, i + 3, i + 4, i + 5, i + 6, i + 7);
      Inc(j);
      Inc(i, 8);
    end;
    k := FEntryPoint - i;
    if k = 0 then begin
    end else if k = 1 then begin
      FEntries[j] := FEntries[i];
      Inc(j);
    end else if k > 1 then begin
      Iterator := GetIterator(k, i);
      try
        FEntries[j] := MergeInternal(Iterator);
        Inc(j);
      finally
        FreeAndNil(Iterator);
      end;
    end;
    FEntryPoint := j;
  end;
end;

end.
