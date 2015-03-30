unit MeDocCOM;

interface

uses MEDOC_TLB, DB;

type
  TMedocCOM = class
  private
    pMedoc: IZApplication;
  public
    constructor Create;
    function GetDocumentList(StartDate, EndDate: TDateTime): OleVariant;
    function GetDocumentByCode(Code: integer): TParams;
  end;

implementation
uses ComObj;

{ TMedocCOM }

constructor TMedocCOM.Create;
begin
  pMedoc := CreateOleObject('MEDOC.ZApplication') AS IZApplication;
end;

function TMedocCOM.GetDocumentByCode(Code: integer): TParams;
var Doc: IZDocument;
    DocDataSet: IZDataset;
    i: integer;
begin
  result := TParams.Create(nil);
  Doc := pMedoc.OpenDocumentByCode(Code, false);
  DocDataSet := Doc.Card;
  if not DocDataSet.Eof then
     for I := 0 to DocDataSet.Fields.Count - 1 do
         result.CreateParam(ftVariant, DocDataSet.Fields.Item[i].Name, ptInput).Value := DocDataSet.Fields.Item[i].Value;

  DocDataSet := Doc.DataSets('', 0);
  if not DocDataSet.Eof then
     for I := 0 to DocDataSet.Fields.Count - 1 do
         result.CreateParam(ftVariant, DocDataSet.Fields.Item[i].Name, ptInput).Value := DocDataSet.Fields.Item[i].Value;
end;

function TMedocCOM.GetDocumentList(StartDate, EndDate: TDateTime): OleVariant;
var lStartDate, lEndDate: OleVariant;
begin
  lStartDate := StartDate;
  lEndDate := EndDate;
  result := pMedoc.DocumentsDataSet('CHARCODE=''F1201005''', false);
  //CRTDATE = 27.03.2015
  result := pMedoc.DocumentsDataSet('CRTDATE >= ''27.03.2015''' + ' AND PERDATE=''01.03.2015'''+' AND CHARCODE=''F1201007''', false);
end;

end.
