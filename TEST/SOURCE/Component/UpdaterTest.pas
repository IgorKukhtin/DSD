unit UpdaterTest;

interface

uses dbTest, dbObjectTest;

type

  TUpdaterTest = class (TdbObjectTestNew)
  private
    procedure SaveFile(FilePath: string);
  published
    procedure ProcedureLoad; override;
    procedure UpdateAllProgram;
    procedure UpdateScale;
    procedure UpdateScaleCeh;
  end;

  TUpdaterScaleTest = class (TdbObjectTestNew)
  private
    procedure SaveFile(FilePath: string);
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TUpdaterScaleCehTest = class (TdbObjectTestNew)
  private
    procedure SaveFile(FilePath: string);
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

implementation

uses DB, UtilConst, Classes, TestFramework, SysUtils, FormStorage,
     ZStoredProcedure, UnilWin, ZLibEx, Dialogs, CommonData;

{ TdbUnitTest }

procedure TUpdaterTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Program\';
  inherited;
end;

procedure TUpdaterTest.SaveFile(FilePath: string);
var Stream: TStream;
begin
  Stream := TStringStream.Create(ConvertConvert(FileReadString(FilePath)));
  with TZStoredProc.Create(nil), UnilWin.GetFileVersion(FilePath) do begin
    try
      Connection := ZConnection;
      StoredProcName := 'gpInsertUpdate_Object_Program';
      Params.Clear;
      Params.CreateParam(ftString, 'inProgramName', ptInput);
      Params.CreateParam(ftFloat, 'inMajorVersion', ptInput);
      Params.CreateParam(ftFloat, 'inMinorVersion', ptInput);
      Params.CreateParam(ftBlob, 'inProgramData', ptInput);
      Params.CreateParam(ftString, 'inSession', ptInput);
      ParamByName('inProgramName').AsString := ExtractFileName(FilePath);
      ParamByName('inMajorVersion').AsFloat := VerHigh;
      ParamByName('inMinorVersion').AsFloat := VerLow;
      ParamByName('inProgramData').LoadFromStream(Stream, ftMemo);
      ParamByName('inSession').AsString := gc_User.Session;
      ExecProc;
    finally
      Free;
      Stream.Free;
    end;
  end;
end;

procedure TUpdaterTest.UpdateAllProgram;
begin
  inherited;
  SaveFile(ExtractFileDir(ParamStr(0)) + '\midas.dll');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\' + gc_ProgramName);
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Scale.exe');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\ScaleCeh.exe');
end;

procedure TUpdaterTest.UpdateScale;
begin
  inherited;

end;

procedure TUpdaterTest.UpdateScaleCeh;
begin
  inherited;

end;

{-----------------Scale--------------------------------}

procedure TUpdaterScaleTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Program\';
  inherited;
end;

procedure TUpdaterScaleTest.SaveFile(FilePath: string);
var Stream: TStream;
begin
  Stream := TStringStream.Create(ConvertConvert(FileReadString(FilePath)));
  with TZStoredProc.Create(nil), UnilWin.GetFileVersion(FilePath) do begin
    try
      Connection := ZConnection;
      StoredProcName := 'gpInsertUpdate_Object_Program';
      Params.Clear;
      Params.CreateParam(ftString, 'inProgramName', ptInput);
      Params.CreateParam(ftFloat, 'inMajorVersion', ptInput);
      Params.CreateParam(ftFloat, 'inMinorVersion', ptInput);
      Params.CreateParam(ftBlob, 'inProgramData', ptInput);
      Params.CreateParam(ftString, 'inSession', ptInput);
      ParamByName('inProgramName').AsString := ExtractFileName(FilePath);
      ParamByName('inMajorVersion').AsFloat := VerHigh;
      ParamByName('inMinorVersion').AsFloat := VerLow;
      ParamByName('inProgramData').LoadFromStream(Stream, ftMemo);
      ParamByName('inSession').AsString := gc_User.Session;
      ExecProc;
    finally
      Free;
      Stream.Free;
    end;
  end;
end;

procedure TUpdaterScaleTest.Test;
begin
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Scale.exe');
end;

{-----------------ScaleCeh--------------------------------}

procedure TUpdaterScaleCehTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Program\';
  inherited;
end;

procedure TUpdaterScaleCehTest.SaveFile(FilePath: string);
var Stream: TStream;
begin
  Stream := TStringStream.Create(ConvertConvert(FileReadString(FilePath)));
  with TZStoredProc.Create(nil), UnilWin.GetFileVersion(FilePath) do begin
    try
      Connection := ZConnection;
      StoredProcName := 'gpInsertUpdate_Object_Program';
      Params.Clear;
      Params.CreateParam(ftString, 'inProgramName', ptInput);
      Params.CreateParam(ftFloat, 'inMajorVersion', ptInput);
      Params.CreateParam(ftFloat, 'inMinorVersion', ptInput);
      Params.CreateParam(ftBlob, 'inProgramData', ptInput);
      Params.CreateParam(ftString, 'inSession', ptInput);
      ParamByName('inProgramName').AsString := ExtractFileName(FilePath);
      ParamByName('inMajorVersion').AsFloat := VerHigh;
      ParamByName('inMinorVersion').AsFloat := VerLow;
      ParamByName('inProgramData').LoadFromStream(Stream, ftMemo);
      ParamByName('inSession').AsString := gc_User.Session;
      ExecProc;
    finally
      Free;
      Stream.Free;
    end;
  end;
end;

procedure TUpdaterScaleCehTest.Test;
begin
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\ScaleCeh.exe');
end;

initialization
  TestFramework.RegisterTest('Сохранение программы', TUpdaterTest.Suite);
  TestFramework.RegisterTest('Сохранение Scale', TUpdaterScaleTest.Suite);
  TestFramework.RegisterTest('Сохранение ScaleCeh', TUpdaterScaleCehTest.Suite);

end.
