
{*******************************************************************************}
{                                                                               }
{                               XML Data Binding                                }
{                                                                               }
{         Generated on: 21.11.2019 13:37:28                                     }
{       Generated from: D:\Work\Project\XML\iftmin_201911211034_546770904.xml   }
{   Settings stored in: D:\Work\Project\XML\iftmin_201911211034_546770904.xdb   }
{                                                                               }
{*******************************************************************************}

unit IftminFozzXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLIFTMINType = interface;
  IXMLDOCUMENTType = interface;
  IXMLDOCITEMType = interface;
  IXMLHEADType = interface;
  IXMLPOSITIONSType = interface;

{ IXMLIFTMINType }

  IXMLIFTMINType = interface(IXMLNode)
    ['{4627E415-2460-48D7-9F57-2C38AB7BCF5F}']
    { Property Accessors }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_DOCUMENT: IXMLDOCUMENTType;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
    { Methods & Properties }
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property DELIVERYTIME: UnicodeString read Get_DELIVERYTIME write Set_DELIVERYTIME;
    property DOCTYPE: UnicodeString read Get_DOCTYPE write Set_DOCTYPE;
    property DOCUMENT: IXMLDOCUMENTType read Get_DOCUMENT;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLDOCUMENTType }

  IXMLDOCUMENTType = interface(IXMLNode)
    ['{57DBB9AC-78BE-4E3C-9ADF-8B18479211DB}']
    { Property Accessors }
    function Get_DOCITEM: IXMLDOCITEMType;
    { Methods & Properties }
    property DOCITEM: IXMLDOCITEMType read Get_DOCITEM;
  end;

{ IXMLDOCITEMType }

  IXMLDOCITEMType = interface(IXMLNode)
    ['{8A85B4BF-D053-46E8-BE71-B9B30C56BA9E}']
    { Property Accessors }
    function Get_DOCTYPE: UnicodeString;
    function Get_DOCNUMBER: UnicodeString;
    procedure Set_DOCTYPE(Value: UnicodeString);
    procedure Set_DOCNUMBER(Value: UnicodeString);
    { Methods & Properties }
    property DOCTYPE: UnicodeString read Get_DOCTYPE write Set_DOCTYPE;
    property DOCNUMBER: UnicodeString read Get_DOCNUMBER write Set_DOCNUMBER;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{4AE6C98B-3F60-4FC4-9DC9-956DACB30EFC}']
    { Property Accessors }
    function Get_CONSIGNOR: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_POSITIONS: IXMLPOSITIONSType;
    procedure Set_CONSIGNOR(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    { Methods & Properties }
    property CONSIGNOR: UnicodeString read Get_CONSIGNOR write Set_CONSIGNOR;
    property DELIVERYPLACE: UnicodeString read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property SENDER: UnicodeString read Get_SENDER write Set_SENDER;
    property RECIPIENT: UnicodeString read Get_RECIPIENT write Set_RECIPIENT;
    property POSITIONS: IXMLPOSITIONSType read Get_POSITIONS;
  end;

{ IXMLPOSITIONSType }

  IXMLPOSITIONSType = interface(IXMLNode)
    ['{70AB4D4A-F488-4EF4-9A3C-CA02C0EC2BBD}']
    { Property Accessors }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PACKAGEQUANTITY: UnicodeString;
    function Get_PACKAGETYPE: UnicodeString;
    function Get_PACKAGEWIGHT: UnicodeString;
    function Get_MAXPACKAGEQUANTITY: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PACKAGEQUANTITY(Value: UnicodeString);
    procedure Set_PACKAGETYPE(Value: UnicodeString);
    procedure Set_PACKAGEWIGHT(Value: UnicodeString);
    procedure Set_MAXPACKAGEQUANTITY(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: UnicodeString read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PACKAGEQUANTITY: UnicodeString read Get_PACKAGEQUANTITY write Set_PACKAGEQUANTITY;
    property PACKAGETYPE: UnicodeString read Get_PACKAGETYPE write Set_PACKAGETYPE;
    property PACKAGEWIGHT: UnicodeString read Get_PACKAGEWIGHT write Set_PACKAGEWIGHT;
    property MAXPACKAGEQUANTITY: UnicodeString read Get_MAXPACKAGEQUANTITY write Set_MAXPACKAGEQUANTITY;
  end;

{ Forward Decls }

  TXMLIFTMINType = class;
  TXMLDOCUMENTType = class;
  TXMLDOCITEMType = class;
  TXMLHEADType = class;
  TXMLPOSITIONSType = class;

{ TXMLIFTMINType }

  TXMLIFTMINType = class(TXMLNode, IXMLIFTMINType)
  protected
    { IXMLIFTMINType }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_DOCUMENT: IXMLDOCUMENTType;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDOCUMENTType }

  TXMLDOCUMENTType = class(TXMLNode, IXMLDOCUMENTType)
  protected
    { IXMLDOCUMENTType }
    function Get_DOCITEM: IXMLDOCITEMType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDOCITEMType }

  TXMLDOCITEMType = class(TXMLNode, IXMLDOCITEMType)
  protected
    { IXMLDOCITEMType }
    function Get_DOCTYPE: UnicodeString;
    function Get_DOCNUMBER: UnicodeString;
    procedure Set_DOCTYPE(Value: UnicodeString);
    procedure Set_DOCNUMBER(Value: UnicodeString);
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode, IXMLHEADType)
  protected
    { IXMLHEADType }
    function Get_CONSIGNOR: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_POSITIONS: IXMLPOSITIONSType;
    procedure Set_CONSIGNOR(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONSType }

  TXMLPOSITIONSType = class(TXMLNode, IXMLPOSITIONSType)
  protected
    { IXMLPOSITIONSType }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PACKAGEQUANTITY: UnicodeString;
    function Get_PACKAGETYPE: UnicodeString;
    function Get_PACKAGEWIGHT: UnicodeString;
    function Get_MAXPACKAGEQUANTITY: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PACKAGEQUANTITY(Value: UnicodeString);
    procedure Set_PACKAGETYPE(Value: UnicodeString);
    procedure Set_PACKAGEWIGHT(Value: UnicodeString);
    procedure Set_MAXPACKAGEQUANTITY(Value: UnicodeString);
  end;

{ Global Functions }

function GetIftmin(Doc: IXMLDocument): IXMLIFTMINType;
function LoadIftmin(const FileName: string): IXMLIFTMINType;
function NewIftmin: IXMLIFTMINType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetIftmin(Doc: IXMLDocument): IXMLIFTMINType;
begin
  Result := Doc.GetDocBinding('IFTMIN', TXMLIFTMINType, TargetNamespace) as IXMLIFTMINType;
end;

function LoadIftmin(const FileName: string): IXMLIFTMINType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('IFTMIN', TXMLIFTMINType, TargetNamespace) as IXMLIFTMINType;
end;

function NewIftmin: IXMLIFTMINType;
begin
  Result := NewXMLDocument.GetDocBinding('IFTMIN', TXMLIFTMINType, TargetNamespace) as IXMLIFTMINType;
end;

{ TXMLIFTMINType }

procedure TXMLIFTMINType.AfterConstruction;
begin
  RegisterChildNode('DOCUMENT', TXMLDOCUMENTType);
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLIFTMINType.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLIFTMINType.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLIFTMINType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLIFTMINType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLIFTMINType.Get_DELIVERYDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYDATE'].Text;
end;

procedure TXMLIFTMINType.Set_DELIVERYDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYDATE'].NodeValue := Value;
end;

function TXMLIFTMINType.Get_DELIVERYTIME: UnicodeString;
begin
  Result := ChildNodes['DELIVERYTIME'].Text;
end;

procedure TXMLIFTMINType.Set_DELIVERYTIME(Value: UnicodeString);
begin
  ChildNodes['DELIVERYTIME'].NodeValue := Value;
end;

function TXMLIFTMINType.Get_DOCTYPE: UnicodeString;
begin
  Result := ChildNodes['DOCTYPE'].Text;
end;

procedure TXMLIFTMINType.Set_DOCTYPE(Value: UnicodeString);
begin
  ChildNodes['DOCTYPE'].NodeValue := Value;
end;

function TXMLIFTMINType.Get_DOCUMENT: IXMLDOCUMENTType;
begin
  Result := ChildNodes['DOCUMENT'] as IXMLDOCUMENTType;
end;

function TXMLIFTMINType.Get_HEAD: IXMLHEADType;
begin
  Result := ChildNodes['HEAD'] as IXMLHEADType;
end;

{ TXMLDOCUMENTType }

procedure TXMLDOCUMENTType.AfterConstruction;
begin
  RegisterChildNode('DOCITEM', TXMLDOCITEMType);
  inherited;
end;

function TXMLDOCUMENTType.Get_DOCITEM: IXMLDOCITEMType;
begin
  Result := ChildNodes['DOCITEM'] as IXMLDOCITEMType;
end;

{ TXMLDOCITEMType }

function TXMLDOCITEMType.Get_DOCTYPE: UnicodeString;
begin
  Result := ChildNodes['DOCTYPE'].Text;
end;

procedure TXMLDOCITEMType.Set_DOCTYPE(Value: UnicodeString);
begin
  ChildNodes['DOCTYPE'].NodeValue := Value;
end;

function TXMLDOCITEMType.Get_DOCNUMBER: UnicodeString;
begin
  Result := ChildNodes['DOCNUMBER'].Text;
end;

procedure TXMLDOCITEMType.Set_DOCNUMBER(Value: UnicodeString);
begin
  ChildNodes['DOCNUMBER'].NodeValue := Value;
end;

{ TXMLHEADType }

procedure TXMLHEADType.AfterConstruction;
begin
  RegisterChildNode('POSITIONS', TXMLPOSITIONSType);
  inherited;
end;

function TXMLHEADType.Get_CONSIGNOR: UnicodeString;
begin
  Result := ChildNodes['CONSIGNOR'].NodeValue;
end;

procedure TXMLHEADType.Set_CONSIGNOR(Value: UnicodeString);
begin
  ChildNodes['CONSIGNOR'].NodeValue := Value;
end;

function TXMLHEADType.Get_DELIVERYPLACE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYPLACE'].NodeValue;
end;

procedure TXMLHEADType.Set_DELIVERYPLACE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYPLACE'].NodeValue := Value;
end;

function TXMLHEADType.Get_SENDER: UnicodeString;
begin
  Result := ChildNodes['SENDER'].NodeValue;
end;

procedure TXMLHEADType.Set_SENDER(Value: UnicodeString);
begin
  ChildNodes['SENDER'].NodeValue := Value;
end;

function TXMLHEADType.Get_RECIPIENT: UnicodeString;
begin
  Result := ChildNodes['RECIPIENT'].NodeValue;
end;

procedure TXMLHEADType.Set_RECIPIENT(Value: UnicodeString);
begin
  ChildNodes['RECIPIENT'].NodeValue := Value;
end;

function TXMLHEADType.Get_POSITIONS: IXMLPOSITIONSType;
begin
  Result := ChildNodes['POSITIONS'] as IXMLPOSITIONSType;
end;

{ TXMLPOSITIONSType }

function TXMLPOSITIONSType.Get_POSITIONNUMBER: UnicodeString;
begin
  Result := ChildNodes['POSITIONNUMBER'].NodeValue;
end;

procedure TXMLPOSITIONSType.Set_POSITIONNUMBER(Value: UnicodeString);
begin
  ChildNodes['POSITIONNUMBER'].NodeValue := Value;
end;

function TXMLPOSITIONSType.Get_PACKAGEQUANTITY: UnicodeString;
begin
  Result := ChildNodes['PACKAGEQUANTITY'].NodeValue;
end;

procedure TXMLPOSITIONSType.Set_PACKAGEQUANTITY(Value: UnicodeString);
begin
  ChildNodes['PACKAGEQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONSType.Get_PACKAGETYPE: UnicodeString;
begin
  Result := ChildNodes['PACKAGETYPE'].NodeValue;
end;

procedure TXMLPOSITIONSType.Set_PACKAGETYPE(Value: UnicodeString);
begin
  ChildNodes['PACKAGETYPE'].NodeValue := Value;
end;

function TXMLPOSITIONSType.Get_PACKAGEWIGHT: UnicodeString;
begin
  Result := ChildNodes['PACKAGEWIGHT'].NodeValue;
end;

procedure TXMLPOSITIONSType.Set_PACKAGEWIGHT(Value: UnicodeString);
begin
  ChildNodes['PACKAGEWIGHT'].NodeValue := Value;
end;

function TXMLPOSITIONSType.Get_MAXPACKAGEQUANTITY: UnicodeString;
begin
  Result := ChildNodes['MAXPACKAGEQUANTITY'].NodeValue;
end;

procedure TXMLPOSITIONSType.Set_MAXPACKAGEQUANTITY(Value: UnicodeString);
begin
  ChildNodes['MAXPACKAGEQUANTITY'].NodeValue := Value;
end;

end.