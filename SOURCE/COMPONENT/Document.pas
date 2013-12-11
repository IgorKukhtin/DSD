unit Document;

interface

uses Classes;

type
  TDocument = class(TComponent)
  private
    FFileName: string;
    FisOpen: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    function GetData: string;
    function GetName: string;
  end;

  procedure Register;

implementation

uses Dialogs, UnilWin, ZLibEx, FormStorage, SysUtils;


procedure Register;
begin
   RegisterComponents('DSDComponent', [TDocument]);
end;

{ TDocument }

constructor TDocument.Create(AOwner: TComponent);
begin
  inherited;
  FisOpen := false;
end;

function TDocument.GetData: string;
begin
  result := ConvertConvert(ZCompressStr(FileReadString(FFileName)));
  FisOpen := false;
end;

function TDocument.GetName: string;
begin
  with TFileOpenDialog.Create(nil) do
  try
    if Execute then begin
       result := ExtractFileName(FileName);
       FisOpen := true;
    end
    else
       abort;
  finally
    Free;
  end;
end;

end.
