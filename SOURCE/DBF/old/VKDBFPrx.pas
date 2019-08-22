{Copyright:      Vlad Karpov
 		 mailto:KarpovVV@protek.ru
		 http:\\vlad-karpov.narod.ru
     ICQ#136489711
 Author:         Vlad Karpov
 Remarks:        Freeware with pay for support, see license.txt
}
unit VKDBFPrx;

{$I VKDBF.DEF}
{$WARNINGS OFF}

interface

uses
  {$IFDEF VKDBF_LOGGIN}VKDBFLogger,{$ENDIF}
  Windows, SysUtils, Classes, VKDBFUtil;

const

  DBF_T_HASGOTINDEX     = $01;
  DBF_T_HASGOTMEMO      = $02;
  DBF_T_ITISDATABASE    = $04;

  DBF_CT_SYSTEM          = $01;
  DBF_CT_CANSTORENULL    = $02;
  DBF_CT_BINARYCOLUMN    = $04;
  DBF_CT_AUTOINCREMENT   = $08;

type

  TProxyStreamType = (pstFile, pstInnerStream, pstOuterStream);

  TLockEvent = procedure(Sender: TObject; ProxyStreamType: TProxyStreamType; Stream: TStream; var LockSuccess: boolean) of object;
  TUnlockEvent = procedure(Sender: TObject; ProxyStreamType: TProxyStreamType; Stream: TStream; var UnlockSuccess: boolean) of object;

  {TAccessMode}
  TAccessMode = class(TPersistent)
  private
    fOpenRead      : boolean;
    fOpenWrite     : boolean;
    fOpenReadWrite : boolean;
    fShareExclusive: boolean;
    fShareDenyWrite: boolean;
    fShareDenyNone : boolean;
    function GetAccessMode: LongWord;
    procedure SetAccessMode(const Value: LongWord);
  public
    FLast: LongWord;
    constructor Create;
    function IsExists(const Value: LongWord): boolean;
  published
    property AccessMode: LongWord read GetAccessMode write SetAccessMode;
    property OpenRead       : boolean read fOpenRead       write fOpenRead      ;
    property OpenWrite      : boolean read fOpenWrite      write fOpenWrite     ;
    property OpenReadWrite  : boolean read fOpenReadWrite  write fOpenReadWrite ;
    property ShareExclusive : boolean read fShareExclusive write fShareExclusive;
    property ShareDenyWrite : boolean read fShareDenyWrite write fShareDenyWrite;
    property ShareDenyNone  : boolean read fShareDenyNone  write fShareDenyNone ;
  end;

  {TTableFlag}
  TTableFlag = class(TPersistent)
  private
    fHasGotIndex    : boolean;
    fHasGotMemo     : boolean;
    fItIsDatabase   : boolean;
    function GetTableFlag: Byte;
    procedure SetTableFlag(const Value: Byte);
  public
    constructor Create;
    function IsExists(const Value: Byte): boolean;
  published
    property TableFlag: Byte read GetTableFlag write SetTableFlag;
    property HasGotIndex   : boolean read fHasGotIndex    write fHasGotIndex;
    property HasGotMemo    : boolean read fHasGotMemo     write fHasGotMemo;
    property ItIsDatabase  : boolean read fItIsDatabase   write fItIsDatabase;
  end;

  {TFieldFlag}
  TFieldFlag = class(TPersistent)
  private
    fSystem         : boolean;
    fCanStoreNull   : boolean;
    fBinaryColumn   : boolean;
    fAutoIncrement  : boolean;
    function GetFieldFlag: Byte;
    procedure SetFieldFlag(const Value: Byte);
  public
    constructor Create;
    function IsExists(const Value: Byte): boolean;
  published
    property FieldFlag: Byte read GetFieldFlag write SetFieldFlag;
    property System        : boolean read fSystem         write fSystem;
    property CanStoreNull  : boolean read fCanStoreNull   write fCanStoreNull;
    property BinaryColumn  : boolean read fBinaryColumn   write fBinaryColumn;
    property AutoIncrement : boolean read fAutoIncrement  write fAutoIncrement;
  end;

  {TProxyStream}
  TProxyStream = class(TPersistent)
  private

    FHandler: Integer;
    FAccessMode: TAccessMode;
    FFileName: AnsiString;
    FInnerStream: TMemoryStream;
    FIsInnerStreamOpen: boolean;
    FOuterStream: TStream;
    FIsOuterStreamOpen: boolean;
    FProxyStreamType: TProxyStreamType;
    FOnLockEvent: TLockEvent;
    FOnUnlockEvent: TUnlockEvent;

  public

    constructor Create;
    destructor Destroy; override;

    property InnerStream: TMemoryStream read FInnerStream;
    property OuterStream: TStream read FOuterStream write FOuterStream;
    property Handler: Integer read FHandler;

    procedure Open;
    procedure CreateProxyStream;
    function IsOpen: boolean;
    function Seek(Offset, Origin: Integer): Integer;
    function Read(var Buffer; Count: LongWord): Integer;
    function Write(const Buffer; Count: LongWord): Integer;
    function Lock(Offset, NumberOfBytes: DWORD): Boolean;
    function UnLock(Offset, NumberOfBytes: DWORD): Boolean;
    procedure SetEndOfFile;
    procedure LoadFromFile(FileName: AnsiString);
    procedure Close;
    function size: DWORD;

  published

    property ProxyStreamType: TProxyStreamType read FProxyStreamType write FProxyStreamType;

    property AccessMode: TAccessMode read FAccessMode write FAccessMode;
    property FileName: AnsiString read FFileName write FFileName;

    property OnLockEvent: TLockEvent read FOnLockEvent write FOnLockEvent;
    property OnUnlockEvent: TUnlockEvent read FOnUnlockEvent write FOnUnlockEvent;

  end;

implementation

uses
  VKDBFMemMgr;

{ TAccessMode }

constructor TAccessMode.Create;
begin
  inherited Create;
  fOpenRead         := true;
  fOpenWrite        := false;
  fOpenReadWrite    := false;
  fShareExclusive   := true;
  fShareDenyWrite   := false;
  fShareDenyNone    := false;
end;

function TAccessMode.GetAccessMode: LongWord;
begin
  Result := 0;
  if fOpenRead       then Result := Result or fmOpenRead      ;
  if fOpenWrite      then Result := Result or fmOpenWrite     ;
  if fOpenReadWrite  then Result := Result or fmOpenReadWrite ;
  if fShareExclusive then Result := Result or fmShareExclusive;
  if fShareDenyWrite then Result := Result or fmShareDenyWrite;
  if fShareDenyNone  then Result := Result or fmShareDenyNone ;
  FLast := Result;
end;

function TAccessMode.IsExists(const Value: LongWord): boolean;
begin
  Result := ( (AccessMode and Value) = Value );
end;

procedure TAccessMode.SetAccessMode(const Value: LongWord);
begin
  fOpenRead       := false;
  fOpenWrite      := false;
  fOpenReadWrite  := false;
  fShareExclusive := false;
  fShareDenyWrite := false;
  fShareDenyNone  := false;
  if (Value and fmOpenRead       ) = fmOpenRead       then fOpenRead       := true;
  if (Value and fmOpenWrite      ) = fmOpenWrite      then fOpenWrite      := true;
  if (Value and fmOpenReadWrite  ) = fmOpenReadWrite  then fOpenReadWrite  := true;
  if (Value and fmShareExclusive ) = fmShareExclusive then fShareExclusive := true;
  if (Value and fmShareDenyWrite ) = fmShareDenyWrite then fShareDenyWrite := true;
  if (Value and fmShareDenyNone  ) = fmShareDenyNone  then fShareDenyNone  := true;
end;

{ TProxyStream }

procedure TProxyStream.Close;
begin
  if IsOpen then
    case ProxyStreamType of
      pstFile:
        begin
          SysUtils.FileClose(FHandler);
          FHandler := -1;
        end;
      pstInnerStream: FIsInnerStreamOpen := False;
      pstOuterStream: FIsOuterStreamOpen := False;
    end;
end;

constructor TProxyStream.Create;
begin
  inherited Create;
  FProxyStreamType := pstFile;
  FHandler := -1;
  FAccessMode := TAccessMode.Create;
  FFileName := '';
  FInnerStream := TMemoryStream.Create;
  FOuterStream := nil;
  FIsInnerStreamOpen := False;
  FIsOuterStreamOpen := False;
  FOnLockEvent := nil;
  FOnUnlockEvent := nil;
end;

procedure TProxyStream.CreateProxyStream;
begin
  case ProxyStreamType of
    pstFile: FHandler := SysUtils.FileCreate(FileName);
    pstInnerStream:
      begin
        FInnerStream.Size := 0;
        FInnerStream.Position := 0;
        FIsInnerStreamOpen := True;
      end;
    pstOuterStream:
      begin
        FOuterStream.Size := 0;
        FOuterStream.Position := 0;
        FIsOuterStreamOpen := True;
      end;
  end;
end;

destructor TProxyStream.Destroy;
begin
  Close;
  FInnerStream.Destroy;
  FAccessMode.Destroy;
  inherited Destroy;
end;

function TProxyStream.IsOpen: boolean;
begin
  Result := False;
  case ProxyStreamType of
    pstFile: Result := (FHandler > 0);
    pstInnerStream: Result := FIsInnerStreamOpen;
    pstOuterStream: Result := FIsOuterStreamOpen;
  end;
end;

procedure TProxyStream.LoadFromFile(FileName: AnsiString);
var
  Stream: TFileStream;

  procedure CopyFile;
  const
    MaxBufSize = $F000;
  var
    Buffer: PByte;
    r: Integer;
  begin
    SysUtils.FileSeek(FHandler, 0, 0);
    Windows.SetEndOfFile(FHandler);
    Buffer := VKDBFMemMgr.oMem.GetMem('TProxyStream.LoadFromFile', MaxBufSize);
    try
      repeat
        r := Stream.Read(Buffer^, MaxBufSize);
        SysUtils.FileWrite(FHandler, Buffer^, r);
      until r <= 0;
    finally
      VKDBFMemMgr.oMem.FreeMem(Buffer);
    end;
    SysUtils.FileSeek(FHandler, 0, 0);
  end;

begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    case ProxyStreamType of
      pstFile: CopyFile;
      pstInnerStream: FInnerStream.LoadFromFile(FileName);
      pstOuterStream:
        begin
          FOuterStream.Size := 0;
          FOuterStream.CopyFrom(Stream, Stream.Size);
          FOuterStream.Position := 0;
        end;
    end;
  finally
    Stream.Free;
  end;
end;

function TProxyStream.Lock(Offset, NumberOfBytes: DWORD): Boolean;
begin
  {$IFDEF VKDBF_LOGGIN}
  VKDBFLogger.log.Write(Format('TProxyStream.Lock(Offset, NumberOfBytes: DWORD) : lebel 1 : try to lock %d %d', [Offset, NumberOfBytes]));
  {$ENDIF}
  Result := False;
  case ProxyStreamType of
    pstFile: Result := VKDBFUtil.FileLock(FHandler, Offset, NumberOfBytes);
    pstInnerStream: Result := True;
    pstOuterStream:
      begin
        if Assigned(OnLockEvent) then
          OnLockEvent(self, ProxyStreamType, FOuterStream, Result)
        else
          Result := True;
      end;
  end;
end;

procedure TProxyStream.Open;
begin
  case ProxyStreamType of
    pstFile: FHandler := SysUtils.FileOpen(FileName, AccessMode.AccessMode);
    pstInnerStream:
      begin
        FInnerStream.Position := 0;
        FIsInnerStreamOpen := True;
      end;
    pstOuterStream:
      begin
        FOuterStream.Position := 0;
        FIsOuterStreamOpen := True;
      end;
  end;
end;

function TProxyStream.Read(var Buffer; Count: LongWord): Integer;
begin
  Result := -1;
  case ProxyStreamType of
    pstFile: Result := SysUtils.FileRead(FHandler, Buffer, Count);
    pstInnerStream: Result := FInnerStream.Read(Buffer, Count);
    pstOuterStream: Result := FOuterStream.Read(Buffer, Count);
  end;
end;

function TProxyStream.Seek(Offset, Origin: Integer): Integer;
//var
//  OldPos: Integer;
begin
  Result := -1;
  case ProxyStreamType of
    pstFile: Result := SysUtils.FileSeek(FHandler, Offset, Origin);
    pstInnerStream:
      begin
        //OldPos := FInnerStream.Position;
        Result := FInnerStream.Seek(Offset, Origin);
        //if (Result < 0) or (Result > FInnerStream.Size) then begin
        //  FInnerStream.Position := OldPos;
        //  Result := -1;
        //end;
      end;
    pstOuterStream:
      begin
        //OldPos := FOuterStream.Position;
        Result := FOuterStream.Seek(Offset, Origin);
        //if (Result < 0) or (Result > FOuterStream.Size) then begin
        //  FOuterStream.Position := OldPos;
        //  Result := -1;
        //end;
      end;
  end;
end;

procedure TProxyStream.SetEndOfFile;
begin
  case ProxyStreamType of
    pstFile: Windows.SetEndOfFile(FHandler);
    pstInnerStream: FInnerStream.Size := FInnerStream.Position;
    pstOuterStream: FOuterStream.Size := FOuterStream.Position;
  end;
end;

function TProxyStream.size: DWORD;
var
  lastPos: Int64;
begin
  Result := MAXDWORD;
  case ProxyStreamType of
    pstFile:
      begin
        lastPos := SysUtils.FileSeek(FHandler, 0, 1);
        Result := SysUtils.FileSeek(FHandler, 0, 2);
        SysUtils.FileSeek(FHandler, lastPos, 0);
      end;
    pstInnerStream: Result := FInnerStream.Size;
    pstOuterStream: Result := FOuterStream.Size;
  end;
end;

function TProxyStream.UnLock(Offset, NumberOfBytes: DWORD): Boolean;
begin
  Result := False;
  case ProxyStreamType of
    pstFile: Result := VKDBFUtil.FileUnLock(FHandler, Offset, NumberOfBytes);
    pstInnerStream: Result := True;
    pstOuterStream:
      begin
        if Assigned(OnUnlockEvent) then
          OnUnlockEvent(self, ProxyStreamType, FOuterStream, Result)
        else
          Result := True;
      end;
  end;
end;

function TProxyStream.Write(const Buffer; Count: LongWord): Integer;
begin
  Result := -1;
  case ProxyStreamType of
    pstFile: Result := SysUtils.FileWrite(FHandler, Buffer, Count);
    pstInnerStream: Result := FInnerStream.Write(Buffer, Count);
    pstOuterStream: Result := FOuterStream.Write(Buffer, Count);
  end;
end;

{ TFieldFlag }

constructor TFieldFlag.Create;
begin
  inherited Create;
  fSystem          := False;
  fCanStoreNull    := False;
  fBinaryColumn    := False;
  fAutoIncrement   := False;
end;

function TFieldFlag.GetFieldFlag: Byte;
begin
  Result := 0;
  if fSystem        then Result := Result or DBF_CT_SYSTEM        ;
  if fCanStoreNull  then Result := Result or DBF_CT_CANSTORENULL  ;
  if fBinaryColumn  then Result := Result or DBF_CT_BINARYCOLUMN  ;
  if fAutoIncrement then Result := Result or DBF_CT_AUTOINCREMENT ;
end;

function TFieldFlag.IsExists(const Value: Byte): boolean;
begin
  Result := ( (FieldFlag and Value) = Value );
end;

procedure TFieldFlag.SetFieldFlag(const Value: Byte);
begin
  fSystem        := false;
  fCanStoreNull  := false;
  fBinaryColumn  := false;
  fAutoIncrement := false;
  if (Value and DBF_CT_SYSTEM        ) = DBF_CT_SYSTEM        then fSystem        := true;
  if (Value and DBF_CT_CANSTORENULL  ) = DBF_CT_CANSTORENULL  then fCanStoreNull  := true;
  if (Value and DBF_CT_BINARYCOLUMN  ) = DBF_CT_BINARYCOLUMN  then fBinaryColumn  := true;
  if (Value and DBF_CT_AUTOINCREMENT ) = DBF_CT_AUTOINCREMENT then fAutoIncrement := true;
end;

{ TTableFlag }

constructor TTableFlag.Create;
begin
  inherited Create;
  fHasGotIndex   := False;
  fHasGotMemo    := False;
  fItIsDatabase  := False;
end;

function TTableFlag.GetTableFlag: Byte;
begin
  Result := 0;
  if fHasGotIndex  then Result := Result or DBF_T_HASGOTINDEX ;
  if fHasGotMemo   then Result := Result or DBF_T_HASGOTMEMO  ;
  if fItIsDatabase then Result := Result or DBF_T_ITISDATABASE;
end;

function TTableFlag.IsExists(const Value: Byte): boolean;
begin
  Result := ( (TableFlag and Value) = Value );
end;

procedure TTableFlag.SetTableFlag(const Value: Byte);
begin
  fHasGotIndex    := false;
  fHasGotMemo     := false;
  fItIsDatabase   := false;
  if (Value and DBF_T_HASGOTINDEX  ) = DBF_T_HASGOTINDEX  then fHasGotIndex  := true;
  if (Value and DBF_T_HASGOTMEMO   ) = DBF_T_HASGOTMEMO   then fHasGotMemo   := true;
  if (Value and DBF_T_ITISDATABASE ) = DBF_T_ITISDATABASE then fItIsDatabase := true;
end;

end.
