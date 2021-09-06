unit dsdPlaySound;

interface

uses System.SysUtils, Classes, MMSystem, FormStorage;

procedure PlaySoundFile(AFileName : String);

implementation

procedure PlaySoundFile(AFileName : String);
  var Stream: TStringStream;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + AFileName) then
  begin
    Stream := TStringStream.Create;
    try
      Stream.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(AFileName));
      Stream.SaveToFile(ExtractFilePath(ParamStr(0)) + AFileName);
    finally
      Stream.Free;
    end;
  end;

  PlaySound(PChar(ExtractFilePath(ParamStr(0)) + AFileName), 0, SND_ASYNC);
end;

end.
