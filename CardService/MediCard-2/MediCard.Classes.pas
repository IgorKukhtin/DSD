unit MediCard.Classes;

interface

uses
  Data.DB,
  MediCard.Intf;

type
  TMCData = class(TInterfacedObject, IMCData)
  private
    FParams: TParams;
    function GetParams: TParams;
  protected
    procedure CreateParams; virtual;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure LoadFromXML(AXML: string);
    procedure SaveToXML(var AXML: string);
    property Params: TParams read GetParams;
  end;

  TMCRequest = class(TMCData)
  protected
    procedure CreateParams; override;
  end;

  TMCResponse = class(TMCData)
  protected
    procedure CreateParams; override;
  end;

  TMCRequestDiscount = class(TMCRequest, IMCRequestDiscount)
  protected
    procedure CreateParams; override;
  end;

  TMCResponseDiscount = class(TMCResponse, IMCResponseDiscount)
  protected
    procedure CreateParams; override;
  end;

implementation

uses
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc;

{ TMedicardCustom }

procedure TMCData.AfterConstruction;
begin
  inherited AfterConstruction;
  FParams := TParams.Create;
  CreateParams;
end;

procedure TMCData.BeforeDestruction;
begin
  FParams.Free;
  inherited BeforeDestruction;
end;

procedure TMCData.CreateParams;
begin
  Params.CreateParam(ftInteger, 'request_type', ptInputOutput);
  Params.CreateParam(ftString,  'id_casual',    ptInputOutput);
end;

function TMCData.GetParams: TParams;
begin
  Result := FParams;
end;

procedure TMCData.LoadFromXML(AXML: string);
var
  XML: IXMLDocument;
  Data, Node: IXMLNode;
  I: Integer;
begin
  TXMLDocument.Create(nil).GetInterface(IXMLDocument, XML);

  XML.LoadFromXML(AXML);
  Data := XML.DocumentElement;

  if Data <> nil then
  begin
    for I := 0 to Pred(Params.Count) do
    begin
      Node := Data.ChildNodes.FindNode(Params[I].Name);

      if Node <> nil then
        Params[I].Value := Node.NodeValue;
    end;
  end;
end;

procedure TMCData.SaveToXML(var AXML: string);
var
  XML: IXMLDocument;
  Data: IXMLNode;
  I: Integer;
begin
  TXMLDocument.Create(nil).GetInterface(IXMLDocument, XML);

  XML.Active := True;
  XML.Version := '1.0';
  XML.Encoding := 'UTF-8';
  XML.Node.ChildNodes.Add(XML.CreateNode('data'));
  Data := XML.DocumentElement;

  if Data <> nil then
  begin
    for I := 0 to Pred(Params.Count) do
      Data.AddChild(Params[I].Name).NodeValue := Params[I].Value;

    XML.SaveToXML(AXML);
  end;
end;

{ TMCRequest }

procedure TMCRequest.CreateParams;
begin
  inherited CreateParams;
  Params.CreateParam(ftString, 'login',    ptInputOutput);
  Params.CreateParam(ftString, 'password', ptInputOutput);
end;

{ TMCResponse }

procedure TMCResponse.CreateParams;
begin
  inherited CreateParams;
  Params.CreateParam(ftString, 'message', ptInputOutput);
  Params.CreateParam(ftString, 'error',   ptInputOutput);
end;

{ TMCRequestDiscount }

procedure TMCRequestDiscount.CreateParams;
begin
  inherited CreateParams;
  Params.ParamByName('request_type').AsInteger := Integer(rtDiscount);

  Params.CreateParam(ftInteger, 'inside_code',  ptInputOutput);
  Params.CreateParam(ftString,  'card_code',    ptInputOutput);
  Params.CreateParam(ftString,  'product_code', ptInputOutput);
  Params.CreateParam(ftFloat,   'price',        ptInputOutput);
  Params.CreateParam(ftFloat,   'qty',          ptInputOutput);
end;

{ TMCResponseDiscount }

procedure TMCResponseDiscount.CreateParams;
begin
  inherited CreateParams;
  Params.CreateParam(ftString,  'card_code',        ptInputOutput);
  Params.CreateParam(ftString,  'product_code',     ptInputOutput);
  Params.CreateParam(ftFloat,   'qty',              ptInputOutput);
  Params.CreateParam(ftFloat,   'discont',          ptInputOutput);
  Params.CreateParam(ftFloat,   'discont_absolute', ptInputOutput);
end;

initialization
  MCDesigner.RegisterClasses([
    TMCRequestDiscount,
    TMCResponseDiscount
  ]);
end.
