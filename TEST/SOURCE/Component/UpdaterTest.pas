unit UpdaterTest;

interface

uses  dbTest, dbObjectTest;

type

  TUpdaterTest = class (TdbObjectTestNew)
  private
    procedure SaveFile(FilePath: string);
  published
    procedure ProcedureLoad; override;
    procedure UpdateMainProgram;
    procedure UpdateMain64Program;
    procedure UpdateDll;
    procedure UpdateScale;
    procedure UpdateScaleCeh;
    procedure UpdateFarmacyCash;
    procedure UpdateFarmacyCashServise;
    procedure UpdateMobile;
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
      ParamByName('inProgramName').AsString := ExtractFileName(FilePath) + GetBinaryPlatfotmSuffics(FilePath, '');
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

procedure TUpdaterTest.UpdateFarmacyCash;
begin
  SaveFile(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe');
end;

procedure TUpdaterTest.UpdateFarmacyCashServise;
begin
   SaveFile(ExtractFileDir(ParamStr(0)) + '\FarmacyCashServise.exe');
end;

procedure TUpdaterTest.UpdateMainProgram;
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\midas.dll')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\midas.dll');
  if FileExists(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\Upgrader4.exe');
  SaveFile(ExtractFileDir(ParamStr(0)) + '\' + gc_ProgramName);
end;

// для отправки SMS
procedure TUpdaterTest.UpdateDll;
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\libeay32.dll')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\libeay32.dll');
  //
  if FileExists(ExtractFileDir(ParamStr(0)) + '\ssleay32.dll')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\ssleay32.dll');
  //
  if FileExists(ExtractFileDir(ParamStr(0)) + '\libeay64.dll')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\libeay64.dll');
  //
  if FileExists(ExtractFileDir(ParamStr(0)) + '\ssleay64.dll')
  then SaveFile(ExtractFileDir(ParamStr(0)) + '\ssleay64.dll');
end;

procedure TUpdaterTest.UpdateMain64Program;
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\_64\bin\' + gc_ProgramName)
  then
      SaveFile(ExtractFileDir(ParamStr(0)) + '\_64\bin\' + gc_ProgramName)
  else
      SaveFile(ExtractFileDir(ParamStr(0)) + '\' + gc_ProgramName);
end;

procedure TUpdaterTest.UpdateMobile;
begin
  SaveFile(ExtractFileDir(ParamStr(0)) + '\ProjectMobile.apk');
end;

procedure TUpdaterTest.UpdateScale;
begin
  SaveFile(ExtractFileDir(ParamStr(0)) + '\Scale.exe');
end;

procedure TUpdaterTest.UpdateScaleCeh;
begin
  SaveFile(ExtractFileDir(ParamStr(0)) + '\ScaleCeh.exe');
end;


initialization
  TestFramework.RegisterTest('Сохранение программы', TUpdaterTest.Suite);

end.
