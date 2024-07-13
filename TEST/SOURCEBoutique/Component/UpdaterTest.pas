unit UpdaterTest;

interface

uses dbTest, dbObjectTest;

type

  TUpdaterTest = class (TdbObjectTestNew)
  private
    procedure SaveFile(FilePath: string);
  published
    procedure ProcedureLoad; override;
    procedure UpdateMainProgram;
    procedure UpdateBoutique;
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

procedure TUpdaterTest.UpdateBoutique;
begin
  ShowMessage(ExtractFileDir(ParamStr(0)) + '\Boutique.exe');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Boutique.exe');
end;



procedure TUpdaterTest.UpdateMainProgram;
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\midas.dll')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\midas.dll');
  if FileExists(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe');

  ShowMessage(ExtractFileDir(ParamStr(0)) + '\' + gc_ProgramName);
  SaveFile(ExtractFileDir(ParamStr(0)) + '\' + gc_ProgramName);
end;



initialization
  TestFramework.RegisterTest('Сохранение программы', TUpdaterTest.Suite);

end.
