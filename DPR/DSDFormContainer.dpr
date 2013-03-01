program DSDFormContainer;

uses
  Vcl.Forms,
  Classes,
  DB,
  MeasureUnit in '..\Forms\MeasureUnit.pas' {MeasureForm},
  dsdDataSetWrapperUnit in '..\SOURCE\COMPONENT\dsdDataSetWrapperUnit.pas',
  StorageUnit in '..\SOURCE\StorageUnit.pas',
  UtilType in '..\SOURCE\UtilType.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonDataUnit in '..\SOURCE\CommonDataUnit.pas',
  AuthenticationUnit in '..\SOURCE\AuthenticationUnit.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  dsdActionUnit in '..\SOURCE\COMPONENT\dsdActionUnit.pas';

{$R *.res}
var
  Stream: TStringStream;
  MemoryStream: TMemoryStream;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMeasureForm, MeasureForm);
  Stream := TStringStream.Create;
  MemoryStream := TMemoryStream.Create;
  with TdsdDataSetWrapper.Create(nil) do
    try
      OutputType := otResult;
      StoredProcName := 'gpInsertUpdate_Object_Form';
      with Params.Add do begin
         Name := 'FormName';
         ParamType := ptInput;
         Value := 'MeasureForm';
         UserDataType := ftString;
      end;
      MemoryStream.WriteComponent(MeasureForm);
      MemoryStream.Position := 0;
      ObjectBinaryToText(MemoryStream, Stream);
      with Params.Add do begin
         Name := 'FormData';
         ParamType := ptInput;
         Value := Stream.DataString;
         UserDataType := ftBlob;
      end;
      Execute;
    finally
      Free;
      Stream.Free;
      MemoryStream.Free;
    end;
  Application.Run;
end.
