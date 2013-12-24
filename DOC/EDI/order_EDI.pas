unit order_EDI;

interface

uses MSXML_TLB, classes;

type

  TXMLORDERType = class;
  TXMLHEADType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;
  TXMLCHARACTERISTICType = class;

  TXMLNode = class
    XMLNode: IXMLDOMNode;
    function NodeValue: OleVariant;
    function Text: string;
    function ChildNodes(NodeName: String): TXMLNode;
    procedure AfterConstruction; virtual;
    constructor Create(DOMNode: IXMLDOMNode);
  end;

  TXMLNodeCollection = class(TXMLNode)
    List: TList;
    function GetCount: integer;
    property Count: Integer read GetCount;
    constructor Create(DOMNode: IXMLDOMNode; Tag: string);
  end;

{ TXMLORDERType }

  TXMLORDERType = class(TXMLNode)
  private
    FDOMDocument: IXMLDOMDocument;
    FHEAD: TXMLHEADType;
  protected
    { IXMLORDERType }
    function Get_DOCUMENTNAME: String;
    function Get_NUMBER: String;
    function Get_DATE: String;
    function Get_DELIVERYDATE: String;
    function Get_DELIVERYTIME: String;
    function Get_CURRENCY: String;
    function Get_INFO: String;
    function Get_HEAD: TXMLHEADType;
  public
    property DOCUMENTNAME: String read Get_DOCUMENTNAME;
    property NUMBER: String read Get_NUMBER;
    property DATE: String read Get_DATE;
    property DELIVERYDATE: String read Get_DELIVERYDATE;
    property DELIVERYTIME: String read Get_DELIVERYTIME;
    property CURRENCY: String read Get_CURRENCY;
    property INFO: String read Get_INFO;
    property HEAD: TXMLHEADType read Get_HEAD;
    procedure AfterConstruction; override;
    constructor Create(FileName: string);
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode)
  private
    FPOSITION: TXMLPOSITIONTypeList;
  protected
    { IXMLHEADType }
    function Get_SUPPLIER: String;
    function Get_BUYER: String;
    function Get_DELIVERYPLACE: String;
    function Get_RECIPIENT: String;
    function Get_SENDER: String;
    function Get_INVOICEPARTNER: String;
    function Get_POSITION: TXMLPOSITIONTypeList;
  public
    property SUPPLIER: String read Get_SUPPLIER;
    property BUYER: String read Get_BUYER;
    property DELIVERYPLACE: String read Get_DELIVERYPLACE;
    property RECIPIENT: String read Get_RECIPIENT;
    property SENDER: String read Get_SENDER;
    property INVOICEPARTNER: String read Get_INVOICEPARTNER;
    property POSITION: TXMLPOSITIONTypeList read Get_POSITION;
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONType }

  TXMLPOSITIONType = class(TXMLNode)
  protected
    { IXMLPOSITIONType }
    function Get_POSITIONNUMBER: String;
    function Get_PRODUCT: String;
    function Get_PRODUCTIDBUYER: String;
    function Get_ORDEREDQUANTITY: String;
    function Get_ORDERUNIT: String;
    function Get_ORDERPRICE: String;
    function Get_CHARACTERISTIC: TXMLCHARACTERISTICType;
  public
    property POSITIONNUMBER: String read Get_POSITIONNUMBER;
    property PRODUCT: String read Get_PRODUCT;
    property PRODUCTIDBUYER: String read Get_PRODUCTIDBUYER;
    property ORDEREDQUANTITY: String read Get_ORDEREDQUANTITY;
    property ORDERUNIT: String read Get_ORDERUNIT;
    property ORDERPRICE: String read Get_ORDERPRICE;
    property CHARACTERISTIC: TXMLCHARACTERISTICType read Get_CHARACTERISTIC;
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONTypeList }

  TXMLPOSITIONTypeList = class(TXMLNodeCollection)
  protected
    { IXMLPOSITIONTypeList }
    function Get_Item(Index: Integer): TXMLPOSITIONType;
  public
    property Item[Index: integer]: TXMLPOSITIONType read Get_Item;
  end;

{ TXMLCHARACTERISTICType }

  TXMLCHARACTERISTICType = class(TXMLNode)
  protected
    { IXMLCHARACTERISTICType }
    function Get_DESCRIPTION: String;
  public
    property DESCRIPTION: String read Get_DESCRIPTION;
  end;
 
{ Global Functions }

function LoadORDER(const FileName: string): TXMLORDERType;

const
  TargetNamespace = '';

implementation

{ Global Functions }


function LoadORDER(const FileName: string): TXMLORDERType;
begin
  result := TXMLORDERType.Create(FileName);
end;

function TXMLNodeCollection.GetCount: integer;
begin
  result := List.Count
end;

constructor TXMLNodeCollection.Create(DOMNode: IXMLDOMNode; Tag: string);
var i: integer;
begin
  inherited Create(DOMNode);
  List := TList.Create;
  for i := 0 to DOMNode.childNodes.length - 1 do begin
      if DOMNode.childNodes.item[i].nodeName = Tag then
         List.Add(Pointer(TXMLNode.Create(DOMNode.childNodes.item[i])))
  end;
end;


procedure TXMLNode.AfterConstruction;
begin
end;


constructor TXMLNode.Create(DOMNode: IXMLDOMNode);
begin
  XMLNode := DOMNode
end;

function TXMLNode.NodeValue: OleVariant;
begin
  result := XMLNode.nodeValue;
end;

function TXMLNode.Text: string;
begin
  result := XMLNode.text;
end;

function TXMLNode.ChildNodes(NodeName: String): TXMLNode;
var i: integer;
begin
  for i := 0 to XMLNode.childNodes.length - 1 do
    if XMLNode.childNodes.item[i].nodeName = NodeName then begin
       result := TXMLNode.Create(XMLNode.childNodes.item[i]);
       break;
    end
end;
{ TXMLORDERType }

constructor TXMLORDERType.Create(FileName: string);
begin
  FDOMDocument := CoDOMDocument.Create;
  FDOMDocument.load(FileName);
  inherited Create(FDOMDocument.documentElement);
end;

procedure TXMLORDERType.AfterConstruction;
begin
  inherited;
end;

function TXMLORDERType.Get_DOCUMENTNAME: String;
begin
  Result := ChildNodes('DOCUMENTNAME').Text;
end;

function TXMLORDERType.Get_NUMBER: String;
begin
  Result := ChildNodes('NUMBER').NodeValue;
end;


function TXMLORDERType.Get_DATE: String;
begin
  Result := ChildNodes('DATE').Text;
end;

function TXMLORDERType.Get_DELIVERYDATE: String;
begin
  Result := ChildNodes('DELIVERYDATE').Text;
end;

function TXMLORDERType.Get_DELIVERYTIME: String;
begin
  Result := ChildNodes('DELIVERYTIME').Text;
end;

function TXMLORDERType.Get_CURRENCY: String;
begin
  Result := ChildNodes('CURRENCY').Text;
end;

function TXMLORDERType.Get_INFO: String;
begin
  Result := ChildNodes('INFO').Text;
end;

function TXMLORDERType.Get_HEAD: TXMLHEADType;
begin
  IF not Assigned(FHEAD) then
     FHEAD := TXMLHEADType.Create(ChildNodes('HEAD').XMLNode);;
  Result := FHEAD;
end;

{ TXMLHEADType }

procedure TXMLHEADType.AfterConstruction;
begin
  inherited;
end;

function TXMLHEADType.Get_SUPPLIER: String;
begin
  Result := ChildNodes('SUPPLIER').Text;
end;

function TXMLHEADType.Get_BUYER: String;
begin
  Result := ChildNodes('BUYER').Text;
end;

function TXMLHEADType.Get_DELIVERYPLACE: String;
begin
  Result := ChildNodes('DELIVERYPLACE').Text;
end;

function TXMLHEADType.Get_RECIPIENT: String;
begin
  Result := ChildNodes('RECIPIENT').Text;
end;

function TXMLHEADType.Get_SENDER: String;
begin
  Result := ChildNodes('SENDER').Text;
end;

function TXMLHEADType.Get_INVOICEPARTNER: String;
begin
  Result := ChildNodes('INVOICEPARTNER').Text;
end;

function TXMLHEADType.Get_POSITION: TXMLPOSITIONTypeList;
begin
  if not Assigned(FPOSITION) THEN
     FPOSITION := TXMLPOSITIONTypeList.Create(XMLNode, 'POSITION');
  Result := FPOSITION
end;

{ TXMLPOSITIONType }

procedure TXMLPOSITIONType.AfterConstruction;
begin
  inherited;
end;

function TXMLPOSITIONType.Get_POSITIONNUMBER: String;
begin
  Result := ChildNodes('POSITIONNUMBER').Text;
end;


function TXMLPOSITIONType.Get_PRODUCT: String;
begin
  Result := ChildNodes('PRODUCT').Text;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: String;
begin
  Result := ChildNodes('PRODUCTIDBUYER').Text;
end;

function TXMLPOSITIONType.Get_ORDEREDQUANTITY: String;
begin
  Result := ChildNodes('ORDEREDQUANTITY').Text;
end;

function TXMLPOSITIONType.Get_ORDERUNIT: String;
begin
  Result := ChildNodes('ORDERUNIT').Text;
end;

function TXMLPOSITIONType.Get_ORDERPRICE: String;
begin
  Result := ChildNodes('ORDERPRICE').Text;
end;

function TXMLPOSITIONType.Get_CHARACTERISTIC: TXMLCHARACTERISTICType;
begin
  Result := TXMLCHARACTERISTICType.Create(ChildNodes('CHARACTERISTIC').XMLNode);
end;

{ TXMLPOSITIONTypeList }

function TXMLPOSITIONTypeList.Get_Item(Index: Integer): TXMLPOSITIONType;
begin
  Result := TXMLPOSITIONType(List[Index]);
end;


{ TXMLCHARACTERISTICType }

function TXMLCHARACTERISTICType.Get_DESCRIPTION: String;
begin
  Result := ChildNodes('DESCRIPTION').Text;
end;

end.