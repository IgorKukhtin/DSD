unit UpdaterTest;

interface

uses dbTest, dbObjectTest;

type

  TUpdaterTest = class (TdbObjectTestNew)
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
  Stream := TStringStream.Create(ConvertConvert(ZCompressStr(FileReadString(FilePath))));
  with TZStoredProc.Create(nil), UnilWin.GetFileVersion(FilePath) do begin
    try
      Connection := ZConnection;
      StoredProcName := 'gpInsertUpdate_Object_Program';
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

procedure TUpdaterTest.Test;
begin
  SaveFile(ExtractFileDir(ParamStr(0))+'\midas.dll');
  SaveFile(ExtractFileDir(ParamStr(0))+'\Upgrader4.exe');
  SaveFile(ExtractFileDir(ParamStr(0))+'\Project.exe');
end;

initialization
  TestFramework.RegisterTest('Сохранение программы', TUpdaterTest.Suite);

end.
