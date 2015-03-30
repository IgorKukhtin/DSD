unit MeDocCOM;

interface

type
  TMedocCOM = class
  private
    pMedoc: OleVariant;
  public
    constructor Create;
    function GetDocumentList(StartDate, EndDate: TDateTime): OleVariant;
  end;

implementation
uses ComObj;

{ TMedocCOM }

constructor TMedocCOM.Create;
begin
  pMedoc := CreateOleObject('MEDOC.ZApplication');
end;

function TMedocCOM.GetDocumentList(StartDate, EndDate: TDateTime): OleVariant;
var lStartDate, lEndDate: OleVariant;
begin
  lStartDate := StartDate;
  lEndDate := EndDate;
  result := pMedoc.DocumentsDataSet('', false)
end;

end.
