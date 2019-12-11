
{*********************************************************************************}
{                                                                                 }
{                                XML Data Binding                                 }
{                                                                                 }
{         Generated on: 21.11.2019 13:34:44                                       }
{       Generated from: D:\Work\Project\XML\contrl_20190815010843_276888325.xml   }
{   Settings stored in: D:\Work\Project\XML\contrl_20190815010843_276888325.xdb   }
{                                                                                 }
{*********************************************************************************}

unit ContrlXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLCONTRLType = interface;

{ IXMLCONTRLType }

  IXMLCONTRLType = interface(IXMLNode)
    ['{EB1A919D-056A-4060-834E-8A9F333C9128}']
    { Property Accessors }
    function Get_NUMBER: Integer;
    function Get_DATE: UnicodeString;
    function Get_RECADVDATE: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_RECIPIENT: Integer;
    function Get_SUPPLIER: Integer;
    function Get_BUYER: Integer;
    function Get_ACTION: Integer;
    procedure Set_NUMBER(Value: Integer);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_RECADVDATE(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: Integer);
    procedure Set_SUPPLIER(Value: Integer);
    procedure Set_BUYER(Value: Integer);
    procedure Set_ACTION(Value: Integer);
    { Methods & Properties }
    property NUMBER: Integer read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property RECADVDATE: UnicodeString read Get_RECADVDATE write Set_RECADVDATE;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property RECIPIENT: Integer read Get_RECIPIENT write Set_RECIPIENT;
    property SUPPLIER: Integer read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: Integer read Get_BUYER write Set_BUYER;
    property ACTION: Integer read Get_ACTION write Set_ACTION;
  end;

{ Forward Decls }

  TXMLCONTRLType = class;

{ TXMLCONTRLType }

  TXMLCONTRLType = class(TXMLNode, IXMLCONTRLType)
  protected
    { IXMLCONTRLType }
    function Get_NUMBER: Integer;
    function Get_DATE: UnicodeString;
    function Get_RECADVDATE: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_RECIPIENT: Integer;
    function Get_SUPPLIER: Integer;
    function Get_BUYER: Integer;
    function Get_ACTION: Integer;
    procedure Set_NUMBER(Value: Integer);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_RECADVDATE(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: Integer);
    procedure Set_SUPPLIER(Value: Integer);
    procedure Set_BUYER(Value: Integer);
    procedure Set_ACTION(Value: Integer);
  end;

{ Global Functions }

function GetContrl(Doc: IXMLDocument): IXMLCONTRLType;
function LoadContrl(const FileName: string): IXMLCONTRLType;
function NewContrl: IXMLCONTRLType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetContrl(Doc: IXMLDocument): IXMLCONTRLType;
begin
  Result := Doc.GetDocBinding('Contrl', TXMLCONTRLType, TargetNamespace) as IXMLCONTRLType;
end;

function LoadContrl(const FileName: string): IXMLCONTRLType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Contrl', TXMLCONTRLType, TargetNamespace) as IXMLCONTRLType;
end;

function NewContrl: IXMLCONTRLType;
begin
  Result := NewXMLDocument.GetDocBinding('Contrl', TXMLCONTRLType, TargetNamespace) as IXMLCONTRLType;
end;

{ TXMLCONTRLType }

function TXMLCONTRLType.Get_NUMBER: Integer;
begin
  Result := ChildNodes['NUMBER'].NodeValue;
end;

procedure TXMLCONTRLType.Set_NUMBER(Value: Integer);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLCONTRLType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_RECADVDATE: UnicodeString;
begin
  Result := ChildNodes['RECADVDATE'].Text;
end;

procedure TXMLCONTRLType.Set_RECADVDATE(Value: UnicodeString);
begin
  ChildNodes['RECADVDATE'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_ORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

procedure TXMLCONTRLType.Set_ORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDERNUMBER'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_ORDERDATE: UnicodeString;
begin
  Result := ChildNodes['ORDERDATE'].Text;
end;

procedure TXMLCONTRLType.Set_ORDERDATE(Value: UnicodeString);
begin
  ChildNodes['ORDERDATE'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_RECIPIENT: Integer;
begin
  Result := ChildNodes['RECIPIENT'].NodeValue;
end;

procedure TXMLCONTRLType.Set_RECIPIENT(Value: Integer);
begin
  ChildNodes['RECIPIENT'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_SUPPLIER: Integer;
begin
  Result := ChildNodes['SUPPLIER'].NodeValue;
end;

procedure TXMLCONTRLType.Set_SUPPLIER(Value: Integer);
begin
  ChildNodes['SUPPLIER'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_BUYER: Integer;
begin
  Result := ChildNodes['BUYER'].NodeValue;
end;

procedure TXMLCONTRLType.Set_BUYER(Value: Integer);
begin
  ChildNodes['BUYER'].NodeValue := Value;
end;

function TXMLCONTRLType.Get_ACTION: Integer;
begin
  Result := ChildNodes['ACTION'].NodeValue;
end;

procedure TXMLCONTRLType.Set_ACTION(Value: Integer);
begin
  ChildNodes['ACTION'].NodeValue := Value;
end;

end.