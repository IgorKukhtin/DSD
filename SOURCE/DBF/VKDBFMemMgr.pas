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
unit VKDBFMemMgr;

interface

uses
  contnrs, Dialogs, syncobjs,
  {$IFDEF DELPHI6} Variants, {$ENDIF}
  {$IFDEF VKDBFMEMCONTROL} Windows, DB,{$ENDIF}
  sysutils;

type

  {TVKDBFOneAlloc}
  TVKDBFOneAlloc = class
  private

    FMemory: Pointer;
    FCaller: TObject;
    FCaption: AnsiString;
    FSize: Cardinal;
    FmemID: Int64;

  public

    constructor Create; overload;
    constructor Create(Caller: TObject; Caption: AnsiString; Size: Cardinal; memID: Int64); overload;
    constructor Create(Caller: TObject; Size: Cardinal; memID: Int64); overload;
    destructor Destroy; override;

    procedure GetMem(Size: Cardinal);
    procedure ReallocMem(NewSize: Cardinal);
    procedure FreeMem;

    property Memory: Pointer read FMemory;
    property Caller: TObject read FCaller write FCaller;
    property Caption: AnsiString read FCaption write FCaption;
    property Size: Cardinal read FSize;

  end;

  {TVKDBFMemMgr}
  TVKDBFMemMgr = class(TObjectList)
  private
    memID: Int64;
    FCS: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;

    function FindIndex(p: Pointer; out Ind: Integer): boolean;
    function FindCaption(Capt: AnsiString; out Ind: Integer): boolean;

    procedure FreeForCaption(Capt: AnsiString);

    function GetMem(Caller: TObject; size: Integer): Pointer; overload;
    function ReallocMem(p: Pointer; size: Integer): Pointer; overload;
    procedure FreeMem(p: Pointer); overload;

    function GetMem(Capt: AnsiString; size: Integer): Pointer; overload;

    function GetSize(p: Pointer): Integer;

  end;

  {$IFDEF VKDBFMEMCONTROL}
  //function getUseDbf: boolean;
  //procedure setUseDBF(newValue: boolean);
  function getUseExDbf: boolean;
  procedure setUseExDBF(newValue: boolean);
  {$ENDIF}

var
  oMem: TVKDBFMemMgr;
  {$IFDEF VKDBFMEMCONTROL}
  oCS: TCriticalSection;
  useDBF: Boolean;
  useExDBF: Boolean;
  oDBF: TDataSet;
  {$ENDIF}

implementation

uses
  VKDBFUtil
  {$IFDEF VKDBFMEMCONTROL}
  , VKDBFDataSet, VKDBFNTX, VKDBFIndex, ActiveX
  {$ENDIF};

{$IFDEF VKDBFMEMCONTROL}
function Int64toVariant(value: Int64): Variant;
begin
  {$IFDEF DELPHI6}
  Result := value;
  {$ELSE}
  TVarData(Result).VType := VT_DECIMAL;
  Decimal(Result).lo64 := value;
  {$ENDIF}
end;
function getUseDbf: boolean;
begin
  oCS.Enter;
  try
    Result := ( useDBF and useExDBF );
  finally
    oCS.Leave;
  end;
end;
procedure setUseDBF(newValue: boolean);
begin
  oCS.Enter;
  try
    useDBF := newValue;
  finally
    oCS.Leave;
  end;
end;
function getUseExDbf: boolean;
begin
  oCS.Enter;
  try
    Result := useExDBF;
  finally
    oCS.Leave;
  end;
end;
procedure setUseExDBF(newValue: boolean);
begin
  oCS.Enter;
  try
    useExDBF := newValue;
  finally
    oCS.Leave;
  end;
end;
{$ENDIF}

{ TVKDBFMemMgr }

constructor TVKDBFMemMgr.Create;
begin
  inherited Create;
  FCS := TCriticalSection.Create;
  memID := 10;
end;

destructor TVKDBFMemMgr.Destroy;
begin
  FreeAndNil(FCS);
  inherited Destroy;
end;

function TVKDBFMemMgr.FindCaption(Capt: AnsiString; out Ind: Integer): boolean;
var
  i: Integer;
begin
  Result := false;
  Ind := -1;
  for i := 0 to Count - 1 do
    if TVKDBFOneAlloc(Items[i]).Caption = Capt then begin
      Result := true;
      Ind := i;
      Exit;
    end;
end;

function TVKDBFMemMgr.FindIndex(p: Pointer; out Ind: Integer): boolean;
var
  B: TVKDBFOneAlloc;
  beg, Mid: Integer;
begin
  Ind := Count;
  if ( Ind > 0 ) then begin
    beg := 0;
    B := TVKDBFOneAlloc(Items[beg]);
    if ( Integer(p) > Integer(B.FMemory) ) then begin
      repeat
        Mid := (Ind + beg) div 2;
        B := TVKDBFOneAlloc(Items[Mid]);
        if ( Integer(p) > Integer(B.FMemory) ) then
           beg := Mid
        else
           Ind := Mid;
      until ( ((Ind - beg) div 2) = 0 );
    end else
      Ind := beg;
    if Ind < Count then begin
      B := TVKDBFOneAlloc(Items[Ind]);
      Result := (Integer(p) = Integer(B.FMemory));
    end else
      Result := false;
  end else
    Result := false;
end;

procedure TVKDBFMemMgr.FreeForCaption(Capt: AnsiString);
var
  i: Integer;
begin
  FCS.Enter;
  try
    while FindCaption(Capt, i) do Delete(i);
  finally
    FCS.Leave
  end;
end;

procedure TVKDBFMemMgr.FreeMem(p: Pointer);
var
  i: Integer;
begin
  FCS.Enter;
  try
    if (p <> nil) and FindIndex(p, i) then Delete(i);
  finally
    FCS.Leave
  end;
end;

function TVKDBFMemMgr.GetMem(Caller: TObject; size: Integer): Pointer;
var
  Obj: TVKDBFOneAlloc;
  i: Integer;
begin
  FCS.Enter;
  try
    Obj := TVKDBFOneAlloc.Create(Caller, size, memID);
    Inc(memID);
    FindIndex(Obj.FMemory, i);
    Insert(i, Obj);
    Result := Obj.FMemory;
  finally
    FCS.Leave
  end;
end;

function TVKDBFMemMgr.GetMem(Capt: AnsiString; size: Integer): Pointer;
var
  Obj: TVKDBFOneAlloc;
  i: Integer;
begin
  FCS.Enter;
  try
    Obj := TVKDBFOneAlloc.Create(nil, Capt, size, memID);
    Inc(memID);
    FindIndex(Obj.FMemory, i);
    Insert(i, Obj);
    Result := Obj.FMemory;
  finally
    FCS.Leave
  end;
end;

function TVKDBFMemMgr.GetSize(p: Pointer): Integer;
var
  Obj: TVKDBFOneAlloc;
  i: Integer;
begin
  FCS.Enter;
  try
    if p <> nil then begin
      if FindIndex(p, i) then begin
        Obj := TVKDBFOneAlloc(Items[i]);
        Result := Obj.FSize;
      end else
        Result := 0;
    end else
      Result := 0;
  finally
    FCS.Leave
  end;
end;

function TVKDBFMemMgr.ReallocMem(p: Pointer; size: Integer): Pointer;
var
  Obj: TVKDBFOneAlloc;
  i: Integer;
  Old: Pointer;
begin
  FCS.Enter;
  try
    if p <> nil then begin
      if FindIndex(p, i) then begin
        Obj := TVKDBFOneAlloc(Items[i]);
        Old := Obj.FMemory;
        Obj.ReallocMem(size);
        Result := Obj.FMemory;
        if Integer(Old) <> Integer(Obj.FMemory) then begin
          OwnsObjects := false;
          try
            Delete(i);
            FindIndex(Obj.FMemory, i);
            Insert(i, Obj);
          finally
            OwnsObjects := true;
          end;
        end;
      end else
        Result := nil;
    end else
      Result := self.GetMem(self, size);
  finally
    FCS.Leave
  end;
end;

{ TVKDBFOneAlloc }

constructor TVKDBFOneAlloc.Create;
begin
  FMemory := nil;
  FCaller := nil;
  FSize := 0;
  FCaption := '';
  FmemID := 0;
end;

constructor TVKDBFOneAlloc.Create(Caller: TObject; Caption: AnsiString; Size: Cardinal; memID: Int64);
begin
  Create;
  FmemID := memID;
  self.GetMem(Size);
  FCaller := Caller;
  FCaption := Caption;
end;

constructor TVKDBFOneAlloc.Create(Caller: TObject; Size: Cardinal; memID: Int64);
begin
  if Size > 0 then begin
    Create;
    FmemID := memID;
    self.GetMem(Size);
    FCaller := Caller;
    if FCaller <> nil then
      FCaption := FCaller.ClassName;
  end else
    raise Exception.Create('TVKDBFOneAlloc: Can not allocate 0 bytes memory!');
end;

destructor TVKDBFOneAlloc.Destroy;
begin
  self.FreeMem;
  inherited Destroy;
end;

procedure TVKDBFOneAlloc.FreeMem;
begin
  if FMemory <> nil then begin
    System.FreeMem(FMemory);
    //SysFreeMem(FMemory);
    FMemory := nil;
    FSize := 0;
    {$IFDEF VKDBFMEMCONTROL}
    if getUseDBF then begin
      setUseDbf(False);
      try
        if oDBF <> nil then
          if oDBF.Active then
            if oDBF.Locate('ID', Int64toVariant(FmemID), []) then
              oDBF.Delete;
      finally
        setUseDbf(True);
      end;
    end;
    {$ENDIF}
  end;
end;

procedure TVKDBFOneAlloc.GetMem(Size: Cardinal);
begin
  if FMemory = nil then begin
    System.GetMem(FMemory, Size);
    //FMemory := SysGetMem(Size);
    FSize := Size;
    {$IFDEF VKDBFMEMCONTROL}
    if getUseDBF then begin
      setUseDbf(False);
      try
        if oDBF <> nil then begin
          if oDBF.Active then begin
            oDBF.Append;
            TLargeintField(oDBF.FieldByName('ID')).AsLargeInt := FmemID;
            TLargeintField(oDBF.FieldByName('POINTER')).AsLargeInt := DWORD(FMemory);
            oDBF.FieldByName('SIZE').AsInteger := Size;
            oDBF.Post;
          end;
        end;
      finally
        setUseDbf(True);
      end;
    end;
    {$ENDIF}
  end else
    ReallocMem(Size);
end;

procedure TVKDBFOneAlloc.ReallocMem(NewSize: Cardinal);
begin
  {$IFDEF VKDBFMEMCONTROL}
  if getUseDBF then begin
    setUseDbf(False);
    try
      if oDBF <> nil then
        if oDBF.Active then
          if oDBF.Locate('ID', Int64toVariant(FmemID), []) then
            oDBF.Delete;
    finally
      setUseDbf(True);
    end;
  end;
  {$ENDIF}
  System.ReallocMem(FMemory, Size);
  //FMemory := SysReallocMem(FMemory, Size);
  FSize := Size;
  {$IFDEF VKDBFMEMCONTROL}
  if getUseDBF then begin
    setUseDbf(False);
    try
      if oDBF <> nil then begin
        if oDBF.Active then begin
          oDBF.Append;
          TLargeintField(oDBF.FieldByName('ID')).AsLargeInt := FmemID;
          TLargeintField(oDBF.FieldByName('POINTER')).AsLargeInt := DWORD(FMemory);
          oDBF.FieldByName('SIZE').AsInteger := Size;
          oDBF.Post;
        end;
      end;
    finally
      setUseDbf(True);
    end;
  end;
  {$ENDIF}
end;

initialization

    {$IFDEF VKDBFMEMCONTROL}
    oDBF := nil;
    {$ENDIF}

    oMem := TVKDBFMemMgr.Create;

    {$IFDEF VKDBFMEMCONTROL}
    oCS := TCriticalSection.Create;
    setUseDbf(False);
    setUseExDbf(False);
    oDBF := TVKDBFNTX.Create(nil);
    TVKDBFNTX(oDBF).AccessMode.AccessMode := 66;
    TVKDBFNTX(oDBF).DBFFileName := 'vkdbfmemmgr.dbf';
    TVKDBFNTX(oDBF).SetDeleted := True;
    with TVKDBFNTX(oDBF).DBFFieldDefs.add as TVKDBFFieldDef do begin
      Name := 'ID';
      field_type := 'E';
      extend_type := dbftS8_N;
    end;
    with TVKDBFNTX(oDBF).DBFFieldDefs.add as TVKDBFFieldDef do begin
      Name := 'POINTER';
      field_type := 'E';
      extend_type := dbftS8_N;
    end;
    with TVKDBFNTX(oDBF).DBFFieldDefs.add as TVKDBFFieldDef do begin
      Name := 'SIZE';
      field_type := 'N';
      len := 10;
      dec := 0;
    end;
    with TVKDBFNTX(oDBF).DBFIndexDefs.add as TVKDBFIndexBag do begin
      IndexFileName := 'vkdbfmemmgr.ntx';
      with Orders.add as TVKDBFOrder do begin
        KeyExpresion := 'ID';
      end;
    end;
    TVKDBFNTX(oDBF).CreateTable;
    TVKDBFNTX(oDBF).Active := true;
    setUseExDbf(True);
    setUseDbf(True);
    {$ENDIF}

finalization

    {$IFDEF VKDBFMEMCONTROL}
    setUseDbf(False);
    setUseExDbf(False);
    FreeAndNil(oDBF);
    FreeAndNil(oCS);
    {$ENDIF}

    FreeAndNil(oMem);

end.
