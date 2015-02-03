unit dsdXMLTransform;

interface

uses
  Classes, XMLIntf, DB, DBClient, dsdDataSetDataLink;

type

  TdsdXMLTransform = class;

  TdsdXMLTransform = class(TComponent, IDataSetAction)
  private
    FActionDataLink: TDataSetDataLink;
    FXMLDocument: IXMLDocument;
    FXMLDataFieldName: string;
    FDataSet: TClientDataSet;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure Transform;
    procedure DataSetChanged;
    procedure UpdateData;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property XMLDataFieldName: string read FXMLDataFieldName write FXMLDataFieldName;
    property DataSet: TClientDataSet read FDataSet write FDataSet;
  end;

  procedure Register;

implementation

uses XMLDoc, SysUtils;


procedure Register;
begin
  RegisterComponents('DSDComponent', [TdsdXMLTransform]);
end;

{ TdsdXMLTransform }

constructor TdsdXMLTransform.Create(AOwner: TComponent);
begin
  inherited;
  FXMLDocument := TXMLDocument.Create(nil);
  FActionDataLink := TDataSetDataLink.Create(Self);
end;

procedure TdsdXMLTransform.DataSetChanged;
begin
  if Assigned(DataSource) then
     if Assigned(DataSource.DataSet) then begin
        FXMLDocument.LoadFromXML(DataSource.DataSet.FieldByName(XMLDataFieldName).AsString);
        Transform;
     end;
end;

destructor TdsdXMLTransform.Destroy;
begin
  FXMLDocument := nil;
  FreeAndNil(FActionDataLink);
  inherited;
end;

function TdsdXMLTransform.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdXMLTransform.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if (Operation = opRemove) and (AComponent = DataSource) then
      DataSource := nil;
  if (Operation = opRemove) and (AComponent = DataSet) then
      DataSet := nil;
end;

procedure TdsdXMLTransform.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value
end;

procedure TdsdXMLTransform.Transform;
var i: Integer;
begin
  if not Assigned(DataSet) then
     exit;
  if not DataSet.Active then
     TClientDataSet(DataSet).CreateDataSet
  else
     TClientDataSet(DataSet).EmptyDataSet;
  if Assigned(FXMLDocument.DocumentElement) then
    with FXMLDocument.DocumentElement do
      for I := 0 to ChildNodes.Count - 1 do begin
          DataSet.Append;
          DataSet.FieldByName('FieldName').asString := ChildNodes[i].GetAttribute('FieldName');
          DataSet.FieldByName('FieldValue').asString := ChildNodes[i].GetAttribute('FieldValue');
          DataSet.Post;
      end;
end;

procedure TdsdXMLTransform.UpdateData;
begin

end;

initialization
  RegisterClass(TdsdXMLTransform);

end.
