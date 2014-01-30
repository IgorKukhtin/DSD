unit ExternalDocumentLoad;

interface

uses ExternalLoad, dsdDB;

type

  TSale1CLoadAction = class(TExternalLoadAction)
  protected
    function GetStoredProc: TdsdStoredProc; override;
    function GetExternalLoad: TExternalLoad; override;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); override;
  end;

  TSale1CLoad = class(TFileExternalLoad)
  private
  public
    function GetData(FieldName: String): Variant;
  end;

implementation

{ TSale1CLoadAction }

function TSale1CLoadAction.GetExternalLoad: TExternalLoad;
begin
  result := TSale1CLoad.Create
end;

function TSale1CLoadAction.GetStoredProc: TdsdStoredProc;
begin

end;

procedure TSale1CLoadAction.ProcessingOneRow(AExternalLoad: TExternalLoad;
  AStoredProc: TdsdStoredProc);
begin
  inherited;

end;

{ TSale1CLoad }

function TSale1CLoad.GetData(FieldName: String): Variant;
begin

end;

end.
