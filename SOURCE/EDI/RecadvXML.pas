
{**********************************************************************************}
{                                                                                  }
{                                 XML Data Binding                                 }
{                                                                                  }
{         Generated on: 05.10.2015 18:06:28                                        }
{                                                                                  }
{**********************************************************************************}

unit RecadvXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLRECADVType = interface;
  IXMLHEADType = interface;
  IXMLPACKINGSEQUENCEType = interface;
  IXMLPOSITIONType = interface;
  IXMLPOSITIONTypeList = interface;

{ IXMLRECADVType }

  IXMLRECADVType = interface(IXMLNode)
    ['{5EB5FA74-2686-446E-A935-62D2C16E18DF}']
    { Property Accessors }
    function Get_NUMBER: string;
    function Get_DATE: UnicodeString;
    function Get_RECEPTIONDATE: UnicodeString;
    function Get_ORDERNUMBER: string;
    function Get_DESADVNUMBER: string;
    function Get_CAMPAIGNNUMBER: string;
    function Get_HEAD: IXMLHEADType;
    { Methods & Properties }
    property NUMBER: string read Get_NUMBER;
    property DATE: UnicodeString read Get_DATE;
    property RECEPTIONDATE: UnicodeString read Get_RECEPTIONDATE;
    property ORDERNUMBER: string read Get_ORDERNUMBER;
    property DESADVNUMBER: string read Get_DESADVNUMBER;
    property CAMPAIGNNUMBER: string read Get_CAMPAIGNNUMBER;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{28929C6A-D2CA-4043-B3A0-9E103F158AD2}']
    { Property Accessors }
    function Get_DELIVERYPLACE: string;
    function Get_BUYER: string;
    function Get_SUPPLIER: string;
    function Get_SENDER: string;
    function Get_RECIPIENT: string;
    function Get_EDIINTERCHANGEID: string;
    function Get_EDIMESSAGE: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_EDIMESSAGE(Value: UnicodeString);
    { Methods & Properties }
    property DELIVERYPLACE: string read Get_DELIVERYPLACE;
    property BUYER: string read Get_BUYER;
    property SUPPLIER: string read Get_SUPPLIER;
    property SENDER: string read Get_SENDER;
    property RECIPIENT: string read Get_RECIPIENT;
    property EDIINTERCHANGEID: string read Get_EDIINTERCHANGEID;
    property EDIMESSAGE: UnicodeString read Get_EDIMESSAGE write Set_EDIMESSAGE;
    property PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType read Get_PACKINGSEQUENCE;
  end;

{ IXMLPACKINGSEQUENCEType }

  IXMLPACKINGSEQUENCEType = interface(IXMLNode)
    ['{A2707B23-25EC-4DFF-9537-4697A1BA87C1}']
    { Property Accessors }
    function Get_HIERARCHICALID: Integer;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_HIERARCHICALID(Value: Integer);
    { Methods & Properties }
    property HIERARCHICALID: Integer read Get_HIERARCHICALID write Set_HIERARCHICALID;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{644A85F2-FA7B-4546-AA6B-8CCA8F50F8CA}']
    { Property Accessors }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: Integer;
    function Get_PRODUCTIDBUYER: Integer;
    function Get_ACCEPTEDQUANTITY: UnicodeString;
    function Get_ACCEPTEDUNIT: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: Integer);
    procedure Set_PRODUCTIDBUYER(Value: Integer);
    procedure Set_ACCEPTEDQUANTITY(Value: UnicodeString);
    procedure Set_ACCEPTEDUNIT(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: Integer read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: Integer read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: Integer read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property ACCEPTEDQUANTITY: UnicodeString read Get_ACCEPTEDQUANTITY write Set_ACCEPTEDQUANTITY;
    property ACCEPTEDUNIT: UnicodeString read Get_ACCEPTEDUNIT write Set_ACCEPTEDUNIT;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{3C2CF099-5A92-4AD5-B30F-0601998CB0FE}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLRECADVType = class;
  TXMLHEADType = class;
  TXMLPACKINGSEQUENCEType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;

{ TXMLRECADVType }

  TXMLRECADVType = class(TXMLNode, IXMLRECADVType)
  protected
    { IXMLRECADVType }
    function Get_NUMBER: string;
    function Get_DATE: UnicodeString;
    function Get_RECEPTIONDATE: UnicodeString;
    function Get_ORDERNUMBER: string;
    function Get_DESADVNUMBER: string;
    function Get_CAMPAIGNNUMBER: string;
    function Get_HEAD: IXMLHEADType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode, IXMLHEADType)
  protected
    { IXMLHEADType }
    function Get_DELIVERYPLACE: string;
    function Get_BUYER: string;
    function Get_SUPPLIER: string;
    function Get_SENDER: string;
    function Get_RECIPIENT: string;
    function Get_EDIINTERCHANGEID: string;
    function Get_EDIMESSAGE: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_EDIMESSAGE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPACKINGSEQUENCEType }

  TXMLPACKINGSEQUENCEType = class(TXMLNode, IXMLPACKINGSEQUENCEType)
  private
    FPOSITION: IXMLPOSITIONTypeList;
  protected
    { IXMLPACKINGSEQUENCEType }
    function Get_HIERARCHICALID: Integer;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_HIERARCHICALID(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONType }

  TXMLPOSITIONType = class(TXMLNode, IXMLPOSITIONType)
  protected
    { IXMLPOSITIONType }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: Integer;
    function Get_PRODUCTIDBUYER: Integer;
    function Get_ACCEPTEDQUANTITY: UnicodeString;
    function Get_ACCEPTEDUNIT: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: Integer);
    procedure Set_PRODUCTIDBUYER(Value: Integer);
    procedure Set_ACCEPTEDQUANTITY(Value: UnicodeString);
    procedure Set_ACCEPTEDUNIT(Value: UnicodeString);
  end;

{ TXMLPOSITIONTypeList }

  TXMLPOSITIONTypeList = class(TXMLNodeCollection, IXMLPOSITIONTypeList)
  protected
    { IXMLPOSITIONTypeList }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
  end;

{ Global Functions }

function GetRECADV(Doc: IXMLDocument): IXMLRECADVType;
function LoadRECADV(XMLString: string): IXMLRECADVType;
function NewRECADV: IXMLRECADVType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetRECADV(Doc: IXMLDocument): IXMLRECADVType;
begin
  Result := Doc.GetDocBinding('RECADV', TXMLRECADVType, TargetNamespace) as IXMLRECADVType;
end;

function LoadRECADV(XMLString: string): IXMLRECADVType;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('RECADV', TXMLRECADVType, TargetNamespace) as IXMLRECADVType;
  end;
end;

function NewRECADV: IXMLRECADVType;
begin
  Result := NewXMLDocument.GetDocBinding('RECADV', TXMLRECADVType, TargetNamespace) as IXMLRECADVType;
end;

{ TXMLRECADVType }

procedure TXMLRECADVType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLRECADVType.Get_NUMBER: string;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

function TXMLRECADVType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

function TXMLRECADVType.Get_RECEPTIONDATE: UnicodeString;
begin
  Result := ChildNodes['RECEPTIONDATE'].Text;
end;

function TXMLRECADVType.Get_ORDERNUMBER: string;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

function TXMLRECADVType.Get_DESADVNUMBER: string;
begin
  Result := ChildNodes['DESADVNUMBER'].Text;
end;

function TXMLRECADVType.Get_CAMPAIGNNUMBER: string;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

function TXMLRECADVType.Get_HEAD: IXMLHEADType;
begin
  Result := ChildNodes['HEAD'] as IXMLHEADType;
end;

{ TXMLHEADType }

procedure TXMLHEADType.AfterConstruction;
begin
  RegisterChildNode('PACKINGSEQUENCE', TXMLPACKINGSEQUENCEType);
  inherited;
end;

function TXMLHEADType.Get_DELIVERYPLACE: string;
begin
  Result := ChildNodes['DELIVERYPLACE'].Text;
end;

function TXMLHEADType.Get_BUYER: string;
begin
  Result := ChildNodes['BUYER'].Text;
end;

function TXMLHEADType.Get_SUPPLIER: string;
begin
  Result := ChildNodes['SUPPLIER'].Text;
end;

function TXMLHEADType.Get_SENDER: string;
begin
  Result := ChildNodes['SENDER'].Text;
end;

function TXMLHEADType.Get_RECIPIENT: string;
begin
  Result := ChildNodes['RECIPIENT'].Text;
end;

function TXMLHEADType.Get_EDIINTERCHANGEID: string;
begin
  Result := ChildNodes['EDIINTERCHANGEID'].Text;
end;

function TXMLHEADType.Get_EDIMESSAGE: UnicodeString;
begin
  Result := ChildNodes['EDIMESSAGE'].Text;
end;

procedure TXMLHEADType.Set_EDIMESSAGE(Value: UnicodeString);
begin
  ChildNodes['EDIMESSAGE'].NodeValue := Value;
end;

function TXMLHEADType.Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
begin
  Result := ChildNodes['PACKINGSEQUENCE'] as IXMLPACKINGSEQUENCEType;
end;

{ TXMLPACKINGSEQUENCEType }

procedure TXMLPACKINGSEQUENCEType.AfterConstruction;
begin
  RegisterChildNode('POSITION', TXMLPOSITIONType);
  FPOSITION := CreateCollection(TXMLPOSITIONTypeList, IXMLPOSITIONType, 'POSITION') as IXMLPOSITIONTypeList;
  inherited;
end;

function TXMLPACKINGSEQUENCEType.Get_HIERARCHICALID: Integer;
begin
  Result := ChildNodes['HIERARCHICALID'].NodeValue;
end;

procedure TXMLPACKINGSEQUENCEType.Set_HIERARCHICALID(Value: Integer);
begin
  ChildNodes['HIERARCHICALID'].NodeValue := Value;
end;

function TXMLPACKINGSEQUENCEType.Get_POSITION: IXMLPOSITIONTypeList;
begin
  Result := FPOSITION;
end;

{ TXMLPOSITIONType }

function TXMLPOSITIONType.Get_POSITIONNUMBER: Integer;
begin
  Result := ChildNodes['POSITIONNUMBER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_POSITIONNUMBER(Value: Integer);
begin
  ChildNodes['POSITIONNUMBER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCT: Integer;
begin
  Result := ChildNodes['PRODUCT'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCT(Value: Integer);
begin
  ChildNodes['PRODUCT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: Integer;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDBUYER(Value: Integer);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ACCEPTEDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ACCEPTEDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ACCEPTEDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ACCEPTEDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ACCEPTEDUNIT: UnicodeString;
begin
  Result := ChildNodes['ACCEPTEDUNIT'].Text;
end;

procedure TXMLPOSITIONType.Set_ACCEPTEDUNIT(Value: UnicodeString);
begin
  ChildNodes['ACCEPTEDUNIT'].NodeValue := Value;
end;

{ TXMLPOSITIONTypeList }

function TXMLPOSITIONTypeList.Add: IXMLPOSITIONType;
begin
  Result := AddItem(-1) as IXMLPOSITIONType;
end;

function TXMLPOSITIONTypeList.Insert(const Index: Integer): IXMLPOSITIONType;
begin
  Result := AddItem(Index) as IXMLPOSITIONType;
end;

function TXMLPOSITIONTypeList.Get_Item(Index: Integer): IXMLPOSITIONType;
begin
  Result := List[Index] as IXMLPOSITIONType;
end;

end.
