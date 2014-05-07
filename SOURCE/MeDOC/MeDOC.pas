unit MeDOC;

interface

uses MeDocXML, dsdAction, DB;

type

  TMedoc = class
  public
    procedure CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet);
  end;

  TMedocAction = class(TdsdCustomAction)
  private
    FHeaderDataSet: TDataSet;
    FItemsDataSet: TDataSet;
  published
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    property ItemsDataSet: TDataSet read FItemsDataSet write FItemsDataSet;
  end;

  procedure Register;

implementation

uses VCL.ActnList;

procedure Register;
begin
  RegisterActions('TaxLib', [TMedocAction], TMedocAction);
end;

{ TMedoc }

procedure TMedoc.CreateXMLFile(HeaderDataSet, ItemsDataSet: TDataSet);
begin
  NewZVIT.OwnerDocument.SaveToFile('c:\test.xml');
end;

end.
