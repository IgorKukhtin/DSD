{==============================================================================*
* Copyright © 2020, Pukhkiy Igor                                               *
* All rights reserved.                                                         *
*==============================================================================*
* This Source Code Form is subject to the terms of the Mozilla                 *
* Public License, v. 2.0. If a copy of the MPL was not distributed             *
* with this file, You can obtain one at http://mozilla.org/MPL/2.0/.           *
*==============================================================================*
* The Initial Developer of the Original Code is Pukhkiy Igor (Ukraine).        *
* Contacts: nspytnik-programming@yahoo.com                                     *
*==============================================================================*
* DESCRIPTION:                                                                 *
* CrtUtils.pas - helprt console                                                *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit CrtUtils;


interface
uses
  Windows, SysUtils;
type
  TValueIndex = 0..12;
const
  idxValueErrors       = 10;
  idxValueDocumentTime = 11;
  idxValueLive         = 12;

  idxValueMasterName   = 0;
  idxValueSlaveName    = 1;

  idxValueMasterDB     = 2;
  idxValueMasterSrv    = 3;
  idxValueMasterUTime  = 4;
  idxValueMasterDTime  = 5;

  idxValueSlaveDB      = 6;
  idxValueSlaveSrv     = 7;
  idxValueSlaveUTime   = 8;
  idxValueSlaveDTime   = 9;


  //  Инициализация, финализация консоли
  procedure InitConsole(const Caption: string);
  procedure FinalizeConsole;
  //  Обновление значений на верхней панели. Каждое значение имеет индекс.
  procedure PanelUpdateValue(Index: Integer; const Value: string);
  //  Отображение прогресса.
  procedure Progress(Index, Count: Integer; const text: string; Hide: Boolean; Erase: Boolean = true);
  procedure ProgressInfinite(Count: Integer; const text: string; Hide: Boolean; Erase: Boolean = true);
  //  Вывод сообщений в консоль
  procedure WriteError(const Text: string); overload;
  procedure WriteError(const Fmt: string; const Args: array of const); overload;
  procedure WriteInfo(const Text: string); overload;
  procedure WriteInfo(const Fmt: string; const Args: array of const); overload;
  //  Гвардеец от WriteLn()
  function AlterWrite(var t: TTextRec; s: UnicodeString): Pointer;

var
  ConsoleTerminate: Boolean;
  OnConsolteTerminate: procedure;    // << Вызывается при событии завершения приложения
implementation


  procedure InitPanel; forward;
  procedure ScrollConsole(ScrHandle: THandle; Rows: Integer); forward;


type
  TStatValue = record
    Coord: TCoord;
    Len: Integer;
    Attributes: Word;
  end;

var
  Values: array [TValueIndex] of TStatValue;
  ScrHandle: THandle;
  Coord: TCoord;
  IsAllocatedConsole: Boolean;
  DefY: SmallInt;
  Errors: Integer;

//==============================================================================
function AlterWrite(var t: TTextRec; s: UnicodeString): Pointer;
begin
  raise Exception.Create('not allow. Use WriteInfo, WriteError');
end;

//==============================================================================
function ConsoleEventProc(CtrlType: DWORD): BOOL; stdcall;
begin
  if (CtrlType = CTRL_CLOSE_EVENT) then
  begin
    ConsoleTerminate := true;
    if Assigned(OnConsolteTerminate) then
      OnConsolteTerminate();
    //  доп. код
  end;
  Result := True;
end;

//==============================================================================
{ Инициализация консоли }
procedure InitConsole(const Caption: string);
const
  ENABLE_EXTENDED_FLAGS = $80;
  ENABLE_INSERT_MODE = $20;
var
  CCI: TConsoleCursorInfo;
begin
  if ScrHandle <> 0  then exit;

  ScrHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  if ScrHandle = 0 then
    begin
      AllocConsole;
      IsAllocatedConsole := true;
      writeln('i');    //< Инициализация стандартного вывода в RTL
      ScrHandle :=  TTextRec(Output).Handle;
    end;
  writeln('i');

  SetConsoleCP(GetACP);
  SetConsoleOutputCP(GetACP);
  SetConsoleTitle(PChar(Caption));
  SetConsoleCtrlHandler(@ConsoleEventProc, True);

  GetConsoleCursorInfo(ScrHandle, CCI);
  CCI.bVisible := false;
  SetConsoleCursorInfo(ScrHandle,CCI);
  AlternateWriteUnicodeStringProc := AlterWrite;
  Coord.X := 0;
  Coord.Y := 3;
  DefY := 3;
  SetConsoleCursorPosition(TTextRec(Output).Handle, Coord);
  InitPanel;
  SetConsoleCursorPosition(TTextRec(Output).Handle, Coord);
  Coord.X := 0;
  Coord.Y := DefY;
  SetConsoleCursorPosition(TTextRec(Output).Handle, Coord);
  AlternateWriteUnicodeStringProc := AlterWrite;
  Coord.Y := DefY + 1;
end;


procedure FinalizeConsole;
begin
  if IsAllocatedConsole then
    FreeConsole;
  IsAllocatedConsole := false;
  ScrHandle := 0;
end;

procedure InitPanel;
const
  MaxRowPanel = 9;
  MaxWidthPanel = 80;
  Borders: array [0..5] of char = ('═', '║', '╔', '╗', '╝', '╚');
  Corners: array [0..3] of TCoord = ((X:0; Y:0), (X:MaxWidthPanel-1; Y:0), (X:MaxWidthPanel-1; Y:MaxRowPanel-1), (X:0; Y:MaxRowPanel-1));
  Titles: array [0..8] of string = ('MASTER:', 'SLAVE: ', 'db', 'srv', 'u.time', 'd.time', '#', 'Errors: ', 'Live: ');

var
  s: string;
  PnlCoord: TCoord;
  I: Integer;
  tmpsz: Cardinal;
  J, offset: Integer;
begin
  PnlCoord.X := 0;
  PnlCoord.Y := 0;

  (*  Синий фон, серый шрифт  *)

  tmpsz := FOREGROUND_BLUE or FOREGROUND_GREEN or FOREGROUND_RED  or BACKGROUND_BLUE ;
  FillConsoleOutputAttribute(ScrHandle, tmpsz , 80*(MaxRowPanel), PnlCoord, tmpsz);


  (*  рамка  *)

  s := StringOfChar(Borders[0], MaxWidthPanel);
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
  PnlCoord.X := 0;
  PnlCoord.Y := MaxRowPanel-1;
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
  PnlCoord.X := 1;
  PnlCoord.Y := 2;
  s := StringOfChar('─', MaxWidthPanel-2);
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
  for I := 1 to MaxRowPanel-2 do
    begin
      PnlCoord.x := MaxWidthPanel-1;
      PnlCoord.Y := I;
      WriteConsoleOutputCharacter(ScrHandle, @Borders[1], 1, PnlCoord, tmpsz);
      PnlCoord.x := 0;
      WriteConsoleOutputCharacter(ScrHandle, @Borders[1], 1, PnlCoord, tmpsz)
    end;
  for I := 2 to 5 do
    begin
      PnlCoord  :=  Corners[I-2];
      WriteConsoleOutputCharacter(ScrHandle, @Borders[I], 1, PnlCoord, tmpsz);
    end;

  (*  Размещение напдисей  *)

  // -------  Center:
  s := Titles[6];
  PnlCoord.x := 31 - Length(s) div 2;
  PnlCoord.Y := 1;
  Values[idxValueDocumentTime].Coord := PnlCoord;
  Values[idxValueDocumentTime].Coord.x := Values[idxValueDocumentTime].Coord.X + Length(s);
  Values[idxValueDocumentTime].Attributes :=  FOREGROUND_GREEN or FOREGROUND_RED  or BACKGROUND_BLUE or FOREGROUND_INTENSITY;
  Values[idxValueDocumentTime].Len := 8;
  FillConsoleOutputAttribute(ScrHandle, Values[idxValueDocumentTime].Attributes, Values[idxValueDocumentTime].Len, Values[idxValueDocumentTime].Coord, tmpsz);
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
  s := TimeToStr(0);
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), Values[idxValueDocumentTime].Coord, tmpsz);

  // ------- Erros count:
  s := Titles[7];
  Values[idxValueErrors].Len := PnlCoord.X -1;
  PnlCoord.x := 2;
  PnlCoord.Y := 1;
  Values[idxValueErrors].Coord := PnlCoord;
  Values[idxValueErrors].Coord.x := Values[idxValueErrors].Coord.X + Length(s);
  Values[idxValueErrors].Len := Values[idxValueErrors].Len - Values[idxValueErrors].Coord.x;
  Values[idxValueErrors].Attributes :=FOREGROUND_INTENSITY or BACKGROUND_BLUE or FOREGROUND_RED;
  FillConsoleOutputAttribute(ScrHandle, Values[idxValueErrors].Attributes, Values[idxValueErrors].Len, Values[idxValueErrors].Coord, tmpsz);
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
  s := '0';
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), Values[idxValueErrors].Coord, tmpsz);

  // ------- Right:
  s := Titles[8];
  PnlCoord.x := Values[idxValueDocumentTime].Coord.X + Values[idxValueDocumentTime].Len + 8;
  PnlCoord.Y := 1;
  Values[idxValueLive].Coord := PnlCoord;
  Values[idxValueLive].Coord.x := Values[idxValueLive].Coord.X + Length(s);
  Values[idxValueLive].Len := 78 - Values[idxValueLive].Coord.x;
  Values[idxValueLive].Attributes := FOREGROUND_GREEN or FOREGROUND_RED  or BACKGROUND_BLUE or FOREGROUND_INTENSITY;
//  FillConsoleOutputAttribute(ScrHandle, Values[8].Attributes, Values[8].Len, Values[8].Coord, tmpsz);
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
  s := '0/0';
  WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), Values[idxValueLive].Coord, tmpsz);

  // ------- MASTER, SLAVE:
  PnlCoord.Y := 3;
  PnlCoord.x := 2;
  for I := 0 to 1 do
    begin
      PnlCoord.Y := 3;
      WriteConsoleOutputCharacter(ScrHandle, POinter(Titles[I]), Length(Titles[I]), PnlCoord, tmpsz);
      Values[i].Coord   := PnlCoord;
      Values[i].Coord.x := Values[I].Coord.x + Length(Titles[I]) + 1;
      if i = 1 then
        Values[I].Len := 78 - Values[I].Coord.x  else
        Values[I].Len := 40 - Values[I].Coord.x - 1;
      PnlCoord.x := PnlCoord.X + Length(Titles[I])-6;
      PnlCoord.Y := 4;
      offset := Length(Titles[I])-4;


      // ------- Имя, сервер, база, uptime, downtime:
      for J := 2 to 5 do
        begin
          WriteConsoleOutputCharacter(ScrHandle, POinter(Titles[J]), Length(Titles[J]), PnlCoord, tmpsz);
          Inc(PnlCoord.Y, 1);
        end;
      // ------- аттрибуты текста значений:
      PnlCoord.Y := 4;
      PnlCoord.x := PnlCoord.X + Length(Titles[4]);
      s := ' ';
      for J := 2 to 5 do
        begin
          WriteConsoleOutputCharacter(ScrHandle, POinter(s), Length(s), PnlCoord, tmpsz);
          Values[I*4+J].Coord   := PnlCoord;
          Values[I*4+J].Coord.x := Values[I*4+J].Coord.x + Length(s);
          Values[I*4+J].Attributes := FOREGROUND_GREEN or FOREGROUND_RED  or BACKGROUND_BLUE or FOREGROUND_INTENSITY;
          if PnlCoord.x > 40 then
            Values[I*4+J].Len := 78 - Values[I*4+J].Coord.x  else
            Values[I*4+J].Len := 40 - Values[I*4+J].Coord.x ;
          //FillConsoleOutputAttribute(ScrHandle, Values[I*4+J].Attributes, Values[I*4+J].Len, Values[I*4+J].Coord, tmpsz);
          Inc(PnlCoord.Y, 1);
        end;
      PnlCoord.x := 40;
    end;
  DefY := MaxRowPanel ;
end;


procedure PanelUpdateValue(Index: Integer; const Value: string);
var
  sz: Cardinal;
begin
  FillConsoleOutputCharacter(ScrHandle, #$20, Values[Index].Len, Values[Index].Coord, sz);
  sz := Length(Value);
  if sz > Values[Index].Len then
    sz := Values[Index].Len;
  WriteConsoleOutputCharacter(ScrHandle, PChar(Value), sz, Values[Index].Coord, sz);
end;


procedure WriteError(const Fmt: string; const Args: array of const);
begin
  WriteError(Format(Fmt, Args));
end;

procedure WriteError(const Text: string);
var
  sz, tmpsz: Cardinal;
  s: string;
begin
  s := Text;
  sz :=  Length(s);

  ScrollConsole(ScrHandle, sz div 80 + 2);

  // цвет,
  tmpsz := FOREGROUND_BLUE or FOREGROUND_GREEN or FOREGROUND_RED  or BACKGROUND_RED ;
  FillConsoleOutputAttribute(ScrHandle, tmpsz , sz, Coord, sz);

  // текст
  WriteConsoleOutputCharacter(ScrHandle, PChar(s), Length(s), Coord, sz);
  ScrollConsole(ScrHandle, 1);

  // счетчик ошибок
  Inc(Errors);
  PanelUpdateValue(idxValueErrors, IntToStr(Errors));
end;

procedure WriteInfo(const Text: string);
var
  sz: Cardinal;
  s: string;
begin
  s := Text;
  sz :=  Length(s);
  ScrollConsole(ScrHandle, sz div 80 +1 );
  if Length(s) < 80 then
    FillConsoleOutputCharacter(ScrHandle, #$20, 80, Coord, sz);
  WriteConsoleOutputCharacter(ScrHandle, PChar(s), Length(s), Coord, sz);
end;

procedure WriteInfo(const Fmt: string; const Args: array of const);
begin
  WriteInfo(Format(Fmt, Args));
end;

procedure ScrollConsole(ScrHandle: THandle; Rows: Integer);
var
   C_I: CHAR_INFO;
   C1: _COORD;
   R1: _SMALL_RECT;
   bi: TConsoleScreenBufferInfo;
begin
   GetConsoleScreenBufferInfo(ScrHandle,bi);
   R1.Left:=0;
   R1.Top:= bi.dwCursorPosition.Y;
   R1.Right:= bi.dwSize.X-1;
   R1.Bottom:=bi.dwSize.Y-1;
   C1.X:=0;
   C1.Y:=  Rows+R1.Top;
   FillChar(C_I, SizeOf(C_I), 0);
//   C_I.AsciiChar := #0;
//   C_I.UnicodeChar := #0;
//   C_I.Attributes := BACKGROUND_GREEN or FOREGROUND_RED;
   ScrollConsoleScreenBuffer(ScrHandle,R1, nil, C1,C_I);
end;

procedure ProgressInfinite(Count: Integer; const text: string; Hide: Boolean; Erase: Boolean = true);
var
  sz, i: Cardinal;
  s1, s2: string;
  P: PChar;
  _coord: TCoord;
begin
  _coord.Y := DefY;
  _coord.X := 0;

  if Hide or Erase then
    FillConsoleOutputCharacter(ScrHandle, #0, 80, _coord, sz);
  if Hide then exit;

  if Length(text) > 50 then
    s2 := Copy(text, 1, 47) + '...' else
    s2 := text;
  if Length(s2) > 0 then
    WriteConsoleOutputCharacter(ScrHandle, PChar(s2), Length(s2), _coord, sz);
  _coord.X := _coord.X + Length(s2) + 1;

  s2 := '    ';
  UniqueString(s2);
  P := Pointer(s2);
  for I := 1 to Count mod 4 do
    begin
      P^ := '.';
      Inc(P);
    end;
  s1 := Format('BIG TABLE [%s] %d', [s2, Count]);
  WriteConsoleOutputCharacter(ScrHandle, PChar(s1), Length(s1), _coord, sz);
end;


procedure Progress(Index, Count: Integer; const text: string; Hide: Boolean; Erase: Boolean);
var
  sz, i: Cardinal;
  percent: Double;
  buf: array [0..21] of char;
  s1, s2: string;
  _coord: TCoord;
begin
  _coord.Y := DefY;
  _coord.X := 0;

  if Hide or Erase then
    FillConsoleOutputCharacter(ScrHandle, #0, 80, _coord, sz);
  if Hide then exit;

  if (Count = 0) or (Index = 0) then
    percent := 0
  else
    percent := Index / Count;
  sz := Round(percent * 20);
  for I := 1 to 20 do
    if i > sz then
      buf[i] := '.' else
      buf[i] := '■';//'▓';
  buf[0] := '[';
  buf[21] := ']';

  s1 := Format('%d/%d %2.2f%%', [Index, Count, percent * 100]);

  if Length(text) > 50 then
    s2 := Copy(text, 1, 47) + '...' else
    s2 := text;
  if Length(s2) > 0 then
    WriteConsoleOutputCharacter(ScrHandle, PChar(s2), Length(s2), _coord, sz);
  _coord.X := _coord.X + Length(s2) + 1;
  WriteConsoleOutputCharacter(ScrHandle, buf, 22, _coord, sz);
  _coord.X := _coord.X + 23;
  WriteConsoleOutputCharacter(ScrHandle, PChar(s1), Length(s1), _coord, sz);
end;

end.
