unit MediCard.Classes;

interface

uses
  Data.DB, System.SysUtils,
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

  TMCSession = class(TInterfacedObject, IMCSession)
  private
    FRequest: IMCData;
    FResponse: IMCData;
    function GetRequest: IMCData;
    function GetResponse: IMCData;
  protected
    function RequestIntf: TGUID; virtual; abstract;
    function ResponseIntf: TGUID; virtual; abstract;
  public
    function GenerateCasual: string;
    function Post: Integer;
    property Request: IMCData read GetRequest;
    property Response: IMCData read GetResponse;
  end;

  // Классы для запроса скидки на товар

  TMCRequestDiscount = class(TMCRequest, IMCRequestDiscount)
  protected
    procedure CreateParams; override;
  end;

  TMCResponseDiscount = class(TMCResponse, IMCResponseDiscount)
  protected
    procedure CreateParams; override;
  end;

  TMCSessionDiscount = class(TMCSession, IMCSessionDiscount)
  protected
    function RequestIntf: TGUID; override;
    function ResponseIntf: TGUID; override;
  end;

  // Классы для подтверждения продажи товара

  TMCRequestSale = class(TMCRequest, IMCRequestSale)
  protected
    procedure CreateParams; override;
  end;

  TMCResponseSale = class(TMCResponse, IMCResponseSale)
  protected
    procedure CreateParams; override;
  end;

  TMCSessionSale = class(TMCSession, IMCSessionSale)
  protected
    function RequestIntf: TGUID; override;
    function ResponseIntf: TGUID; override;
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
  Params.ParamByName('request_type').AsInteger := MC_DISCOUNT;

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

{ TMCSession }

function TMCSession.GenerateCasual: string;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Result := StringReplace(LowerCase(GUIDToString(GUID)), '-', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '{', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll, rfIgnoreCase]);
end;

function TMCSession.GetRequest: IMCData;
begin
  if FRequest = nil then
    MCDesigner.CreateObject(RequestIntf).GetInterface(IMCData, FRequest);

  Result := FRequest;
end;

function TMCSession.GetResponse: IMCData;
begin
  if FResponse = nil then
    MCDesigner.CreateObject(ResponseIntf).GetInterface(IMCData, FResponse);

  Result := FResponse;
end;

function TMCSession.Post: Integer;
var
  RequestXML, ResponseXML: string;
begin
  Request.SaveToXML(RequestXML);

  Result := MCDesigner.HTTPPost(RequestXML, ResponseXML);

  if Result = 200 then
  begin
    Response.LoadFromXML(ResponseXML);

    if Response.Params.ParamByName('id_casual').AsString <> Request.Params.ParamByName('id_casual').AsString then
      raise EMCException.Create('Ответ не соответствует запросу');
  end;
end;

{ TMCSessionDiscount }

{ TMCSessionDiscount }

function TMCSessionDiscount.RequestIntf: TGUID;
begin
  Result := IMCRequestDiscount;
end;

function TMCSessionDiscount.ResponseIntf: TGUID;
begin
  Result := IMCResponseDiscount;
end;

{ TMCRequestSale }

procedure TMCRequestSale.CreateParams;
begin
  inherited CreateParams;
  Params.ParamByName('request_type').AsInteger := MC_SALE;

  Params.CreateParam(ftInteger, 'inside_code',     ptInputOutput);
  Params.CreateParam(ftInteger, 'supplier',        ptInputOutput);
  Params.CreateParam(ftString,  'id_alter',        ptInputOutput);
  Params.CreateParam(ftInteger, 'sale_status',     ptInputOutput);
  Params.CreateParam(ftString,  'card_code',       ptInputOutput);
  Params.CreateParam(ftString,  'product_code',    ptInputOutput);
  Params.CreateParam(ftFloat,   'price',           ptInputOutput);
  Params.CreateParam(ftFloat,   'qty',             ptInputOutput);
  Params.CreateParam(ftFloat,   'rezerv',          ptInputOutput);
  Params.CreateParam(ftFloat,   'discont_percent', ptInputOutput);
  Params.CreateParam(ftFloat,   'discont_value',   ptInputOutput);
  Params.CreateParam(ftString,  'sale_date',       ptInputOutput);
end;

{ TMCResponseSale }

procedure TMCResponseSale.CreateParams;
begin
  inherited CreateParams;
  Params.CreateParam(ftInteger, 'request_status', ptInputOutput);
end;

{ TMCSessionSale }

function TMCSessionSale.RequestIntf: TGUID;
begin
  Result := IMCRequestSale;
end;

function TMCSessionSale.ResponseIntf: TGUID;
begin
  Result := IMCResponseSale;
end;

initialization
  MCDesigner.RegisterClasses([
    TMCRequestDiscount,
    TMCResponseDiscount,
    TMCSessionDiscount,
    TMCRequestSale,
    TMCResponseSale,
    TMCSessionSale
  ]);
end.
