unit CTmscorlib;

interface

uses
  CTClient, CTObject, Windows;

type
  ByteArray = class;


  ByteArray = class(TCTObject)
  private
    function IsFixedSizeRead: Boolean;
    function IsReadOnlyRead: Boolean;
    function IsSynchronizedRead: Boolean;
    function LengthRead: Integer;
    function LongLengthRead: Int64;
    function RankRead: Integer;
    function SyncRootRead: TCTObject;
  protected
    class function CTFullTypeName: string; override;
  public
    //Address:Byte:Integer
    function Clone: TCTObject; overload;
    //CopyTo:TCTObject:TCTObject:Int64
    //CopyTo:TCTObject:TCTObject:Integer
    constructor Create(
      const a0: Integer); overload;
    function Equals(
      const aObj: TCTObject): Boolean; reintroduce; overload;
    function Get(
      const a0: Integer): Byte; overload;
    function GetEnumerator: TCTObject {Interface: System.Collections.IEnumerator}; overload;
    function GetHashCode: Integer; reintroduce; overload;
    function GetLength(
      const aDimension: Integer): Integer; overload;
    function GetLongLength(
      const aDimension: Integer): Int64; overload;
    function GetLowerBound(
      const aDimension: Integer): Integer; overload;
    //GetType:Type2
    function GetUpperBound(
      const aDimension: Integer): Integer; overload;
    //GetValue:TCTObject:Int32Array
    function GetValue(
      const aIndex: Int64): TCTObject; overload;
    function GetValue(
      const aIndex1: Int64; 
      const aIndex2: Int64): TCTObject; overload;
    function GetValue(
      const aIndex1: Int64; 
      const aIndex2: Int64; 
      const aIndex3: Int64): TCTObject; overload;
    //GetValue:TCTObject:Int64Array
    function GetValue(
      const aIndex: Integer): TCTObject; overload;
    function GetValue(
      const aIndex1: Integer; 
      const aIndex2: Integer): TCTObject; overload;
    function GetValue(
      const aIndex1: Integer; 
      const aIndex2: Integer; 
      const aIndex3: Integer): TCTObject; overload;
    procedure Initialize; overload;
    procedure SetMethod(
      const a0: Integer; 
      const a1: Byte); overload;
    //SetValue:TCTObject:TCTObject:Int32Array
    procedure SetValue(
      const aValue: TCTObject; 
      const aIndex: Int64); overload;
    procedure SetValue(
      const aValue: TCTObject; 
      const aIndex1: Int64; 
      const aIndex2: Int64); overload;
    procedure SetValue(
      const aValue: TCTObject; 
      const aIndex1: Int64; 
      const aIndex2: Int64; 
      const aIndex3: Int64); overload;
    //SetValue:TCTObject:TCTObject:Int64Array
    procedure SetValue(
      const aValue: TCTObject; 
      const aIndex: Integer); overload;
    procedure SetValue(
      const aValue: TCTObject; 
      const aIndex1: Integer; 
      const aIndex2: Integer); overload;
    procedure SetValue(
      const aValue: TCTObject; 
      const aIndex1: Integer; 
      const aIndex2: Integer; 
      const aIndex3: Integer); overload;
    function ToString: string; reintroduce; overload;

    procedure CopyTo(aDest: array of byte);
    procedure CopyFrom(aSrc: array of byte);

    property Items[const aindex: Integer]: Byte read Get write SetMethod; default;
    property IsFixedSize: Boolean read IsFixedSizeRead;
    property IsReadOnly: Boolean read IsReadOnlyRead;
    property IsSynchronized: Boolean read IsSynchronizedRead;
    property Length: Integer read LengthRead;
    property LongLength: Int64 read LongLengthRead;
    property Rank: Integer read RankRead;
    property SyncRoot: TCTObject read SyncRootRead;
  end;

implementation

uses
  SysUtils, CTException;

{ System.Byte[] }

class function ByteArray.CTFullTypeName: string;
begin
  Result := 'System.Byte[]'
end;


function ByteArray.IsFixedSizeRead: Boolean;
begin
  Result := Boolean(CTPropGet('IsFixedSize'));
end;

function ByteArray.IsReadOnlyRead: Boolean;
begin
  Result := Boolean(CTPropGet('IsReadOnly'));
end;

function ByteArray.IsSynchronizedRead: Boolean;
begin
  Result := Boolean(CTPropGet('IsSynchronized'));
end;

function ByteArray.LengthRead: Integer;
begin
  Result := Integer(CTPropGet('Length'));
end;

function ByteArray.LongLengthRead: Int64;
begin
  Result := Int64(CTPropGet('LongLength'));
end;

function ByteArray.RankRead: Integer;
begin
  Result := Integer(CTPropGet('Rank'));
end;

function ByteArray.SyncRootRead: TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTPropGet('SyncRoot')));
end;

function ByteArray.Clone: TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('Clone', 0, [], [])));
  CTClearResults;
end;

constructor ByteArray.Create(
  const a0: Integer);
begin
  CTCreateObject('System.Byte[]', -114835243, [a0], [CTptInt]);
end;

function ByteArray.Equals(
  const aObj: TCTObject): Boolean;
begin
  Result := Boolean(CTMethodCall('Equals', 1226748890, [aObj], [CTptObj]));
  CTClearResults;
end;

function ByteArray.Get(
  const a0: Integer): Byte;
begin
  Result := Byte(CTMethodCall('Get', -114835243, [a0], [CTptInt]));
  CTClearResults;
end;

function ByteArray.GetEnumerator: TCTObject {Interface: System.Collections.IEnumerator};
begin
  Result := TCTObject {Interface: System.Collections.IEnumerator}(CTFindRef(TCTObject {Interface: System.Collections.IEnumerator}, CTMethodCall('GetEnumerator', 0, [], [])));
  CTClearResults;
end;

function ByteArray.GetHashCode: Integer;
begin
  Result := Integer(CTMethodCall('GetHashCode', 0, [], []));
  CTClearResults;
end;

function ByteArray.GetLength(
  const aDimension: Integer): Integer;
begin
  Result := Integer(CTMethodCall('GetLength', -114835243, [aDimension], [CTptInt]));
  CTClearResults;
end;

function ByteArray.GetLongLength(
  const aDimension: Integer): Int64;
begin
  Result := Int64(CTMethodCall('GetLongLength', -114835243, [aDimension], [CTptInt]));
  CTClearResults;
end;

function ByteArray.GetLowerBound(
  const aDimension: Integer): Integer;
begin
  Result := Integer(CTMethodCall('GetLowerBound', -114835243, [aDimension], [CTptInt]));
  CTClearResults;
end;

function ByteArray.GetUpperBound(
  const aDimension: Integer): Integer;
begin
  Result := Integer(CTMethodCall('GetUpperBound', -114835243, [aDimension], [CTptInt]));
  CTClearResults;
end;

function ByteArray.GetValue(
  const aIndex: Int64): TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('GetValue', 1459142863, [aIndex], [CTptInt64])));
  CTClearResults;
end;

function ByteArray.GetValue(
  const aIndex1: Int64; 
  const aIndex2: Int64): TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('GetValue', 360299681, [aIndex1, 
aIndex2], [CTptInt64, CTptInt64])));
  CTClearResults;
end;

function ByteArray.GetValue(
  const aIndex1: Int64; 
  const aIndex2: Int64; 
  const aIndex3: Int64): TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('GetValue', 1646024638, [aIndex1, 
aIndex2, 
aIndex3], [CTptInt64, CTptInt64, CTptInt64])));
  CTClearResults;
end;

function ByteArray.GetValue(
  const aIndex: Integer): TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('GetValue', -114835243, [aIndex], [CTptInt])));
  CTClearResults;
end;

function ByteArray.GetValue(
  const aIndex1: Integer; 
  const aIndex2: Integer): TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('GetValue', -2140566382, [aIndex1, 
aIndex2], [CTptInt, CTptInt])));
  CTClearResults;
end;

function ByteArray.GetValue(
  const aIndex1: Integer; 
  const aIndex2: Integer; 
  const aIndex3: Integer): TCTObject;
begin
  Result := TCTObject(CTFindRef(TCTObject, CTMethodCall('GetValue', -1865022468, [aIndex1, 
aIndex2, 
aIndex3], [CTptInt, CTptInt, CTptInt])));
  CTClearResults;
end;

procedure ByteArray.Initialize;
begin
  CTMethodCall('Initialize', 0, [], []);
  CTClearResults;
end;

procedure ByteArray.SetMethod(
  const a0: Integer; 
  const a1: Byte);
begin
  CTMethodCall('Set', 340346433, [a0, 
a1], [CTptInt, CTptByte]);
  CTClearResults;
end;

procedure ByteArray.SetValue(
  const aValue: TCTObject; 
  const aIndex: Int64);
begin
  CTMethodCall('SetValue', 963600931, [aValue, 
aIndex], [CTptObj, CTptInt64]);
  CTClearResults;
end;

procedure ByteArray.SetValue(
  const aValue: TCTObject; 
  const aIndex1: Int64; 
  const aIndex2: Int64);
begin
  CTMethodCall('SetValue', -57541273, [aValue, 
aIndex1, 
aIndex2], [CTptObj, CTptInt64, CTptInt64]);
  CTClearResults;
end;

procedure ByteArray.SetValue(
  const aValue: TCTObject; 
  const aIndex1: Int64; 
  const aIndex2: Int64; 
  const aIndex3: Int64);
begin
  CTMethodCall('SetValue', 1064737788, [aValue, 
aIndex1, 
aIndex2, 
aIndex3], [CTptObj, CTptInt64, CTptInt64, CTptInt64]);
  CTClearResults;
end;

procedure ByteArray.SetValue(
  const aValue: TCTObject; 
  const aIndex: Integer);
begin
  CTMethodCall('SetValue', 586423068, [aValue, 
aIndex], [CTptObj, CTptInt]);
  CTClearResults;
end;

procedure ByteArray.SetValue(
  const aValue: TCTObject; 
  const aIndex1: Integer; 
  const aIndex2: Integer);
begin
  CTMethodCall('SetValue', -1944711835, [aValue, 
aIndex1, 
aIndex2], [CTptObj, CTptInt, CTptInt]);
  CTClearResults;
end;

procedure ByteArray.SetValue(
  const aValue: TCTObject; 
  const aIndex1: Integer; 
  const aIndex2: Integer; 
  const aIndex3: Integer);
begin
  CTMethodCall('SetValue', -1315852342, [aValue, 
aIndex1, 
aIndex2, 
aIndex3], [CTptObj, CTptInt, CTptInt, CTptInt]);
  CTClearResults;
end;

function ByteArray.ToString: string;
begin
  Result := CTMethodCallStringResult('ToString', 0, [], []);
  CTClearResults;
end;

procedure ByteArray.CopyTo(aDest: array of byte);
var
  xThreadID: DWORD;
  xResult: Integer;
begin
  if (System.Length(aDest) < Length) then begin
    raise Exception.Create('Destination array is not large enough.');
  end;
  xThreadID := GetCurrentThreadID;
  xResult := CTArrayCopy(GetCurrentThreadID, Self, aDest, true);
  CTCheckResult(xThreadID, xResult);
end;

procedure ByteArray.CopyFrom(aSrc: array of byte);
var
  xThreadID: DWORD;
  xResult: Integer;
begin
  if (Length < System.Length(aSrc)) then begin
    raise Exception.Create('Destination array is not large enough.');
  end;
  xThreadID := GetCurrentThreadID;
  xResult := CTArrayCopy(GetCurrentThreadID, Self, aSrc, false);
  CTCheckResult(xThreadID, xResult);
end;

end.
