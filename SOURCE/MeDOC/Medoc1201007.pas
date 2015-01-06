
{***********************************************************************************************************}
{                                                                                                           }
{                                             XML Data Binding                                              }
{                                                                                                           }
{         Generated on: 06.01.2015 16:09:07                                                                 }
{       Generated from: D:\WORK\DSD\DSD\DOC\Вспомогательные\Медок\Описание и примеры\201007\fj1201007.xml   }
{                                                                                                           }
{***********************************************************************************************************}

unit Medoc1201007;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLZVITType = interface;
  IXMLTRANSPORTType = interface;
  IXMLORGType = interface;
  IXMLFIELDSType = interface;
  IXMLCARDType = interface;
  IXMLDOCUMENTType = interface;
  IXMLROWType = interface;

{ IXMLZVITType }

  IXMLZVITType = interface(IXMLNode)
    ['{06C41BE1-960E-4DCD-BCAE-502A3E5D05B1}']
    { Property Accessors }
    function Get_TRANSPORT: IXMLTRANSPORTType;
    function Get_ORG: IXMLORGType;
    { Methods & Properties }
    property TRANSPORT: IXMLTRANSPORTType read Get_TRANSPORT;
    property ORG: IXMLORGType read Get_ORG;
  end;

{ IXMLTRANSPORTType }

  IXMLTRANSPORTType = interface(IXMLNode)
    ['{84D6919D-93B0-4756-B7A7-B1F54632716B}']
    { Property Accessors }
    function Get_CREATEDATE: UnicodeString;
    function Get_VERSION: UnicodeString;
    procedure Set_CREATEDATE(Value: UnicodeString);
    procedure Set_VERSION(Value: UnicodeString);
    { Methods & Properties }
    property CREATEDATE: UnicodeString read Get_CREATEDATE write Set_CREATEDATE;
    property VERSION: UnicodeString read Get_VERSION write Set_VERSION;
  end;

{ IXMLORGType }

  IXMLORGType = interface(IXMLNode)
    ['{89667DF7-751E-4284-B460-A6C06D475BAC}']
    { Property Accessors }
    function Get_FIELDS: IXMLFIELDSType;
    function Get_CARD: IXMLCARDType;
    { Methods & Properties }
    property FIELDS: IXMLFIELDSType read Get_FIELDS;
    property CARD: IXMLCARDType read Get_CARD;
  end;

{ IXMLFIELDSType }

  IXMLFIELDSType = interface(IXMLNode)
    ['{DC2DC7DB-20A9-4D16-8E99-94F305B7BC25}']
    { Property Accessors }
    function Get_EDRPOU: UnicodeString;
    function Get_PERTYPE: UnicodeString;
    function Get_PERDATE: UnicodeString;
    function Get_CHARCODE: UnicodeString;
    function Get_DOCID: UnicodeString;
    procedure Set_EDRPOU(Value: UnicodeString);
    procedure Set_PERTYPE(Value: UnicodeString);
    procedure Set_PERDATE(Value: UnicodeString);
    procedure Set_CHARCODE(Value: UnicodeString);
    procedure Set_DOCID(Value: UnicodeString);
    { Methods & Properties }
    property EDRPOU: UnicodeString read Get_EDRPOU write Set_EDRPOU;
    property PERTYPE: UnicodeString read Get_PERTYPE write Set_PERTYPE;
    property PERDATE: UnicodeString read Get_PERDATE write Set_PERDATE;
    property CHARCODE: UnicodeString read Get_CHARCODE write Set_CHARCODE;
    property DOCID: UnicodeString read Get_DOCID write Set_DOCID;
  end;

{ IXMLCARDType }

  IXMLCARDType = interface(IXMLNode)
    ['{1CDBE4C4-FD4D-48EF-A191-C4C209A5475D}']
    { Property Accessors }
    function Get_FIELDS: IXMLFIELDSType;
    function Get_DOCUMENT: IXMLDOCUMENTType;
    { Methods & Properties }
    property FIELDS: IXMLFIELDSType read Get_FIELDS;
    property DOCUMENT: IXMLDOCUMENTType read Get_DOCUMENT;
  end;

{ IXMLDOCUMENTType }

  IXMLDOCUMENTType = interface(IXMLNodeCollection)
    ['{58C2DD57-9C8A-48FE-947C-1006314FB323}']
    { Property Accessors }
    function Get_ROW(Index: Integer): IXMLROWType;
    { Methods & Properties }
    function Add: IXMLROWType;
    function Insert(const Index: Integer): IXMLROWType;
    property ROW[Index: Integer]: IXMLROWType read Get_ROW; default;
  end;

{ IXMLROWType }

  IXMLROWType = interface(IXMLNode)
    ['{0F751457-D48F-4880-99CE-539B24D5F2AB}']
    { Property Accessors }
    function Get_TAB: UnicodeString;
    function Get_LINE: UnicodeString;
    function Get_NAME: UnicodeString;
    function Get_VALUE: UnicodeString;
    procedure Set_TAB(Value: UnicodeString);
    procedure Set_LINE(Value: UnicodeString);
    procedure Set_NAME(Value: UnicodeString);
    procedure Set_VALUE(Value: UnicodeString);
    { Methods & Properties }
    property TAB: UnicodeString read Get_TAB write Set_TAB;
    property LINE: UnicodeString read Get_LINE write Set_LINE;
    property NAME: UnicodeString read Get_NAME write Set_NAME;
    property VALUE: UnicodeString read Get_VALUE write Set_VALUE;
  end;

{ Forward Decls }

  TXMLZVITType = class;
  TXMLTRANSPORTType = class;
  TXMLORGType = class;
  TXMLFIELDSType = class;
  TXMLCARDType = class;
  TXMLDOCUMENTType = class;
  TXMLROWType = class;

{ TXMLZVITType }

  TXMLZVITType = class(TXMLNode, IXMLZVITType)
  protected
    { IXMLZVITType }
    function Get_TRANSPORT: IXMLTRANSPORTType;
    function Get_ORG: IXMLORGType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTRANSPORTType }

  TXMLTRANSPORTType = class(TXMLNode, IXMLTRANSPORTType)
  protected
    { IXMLTRANSPORTType }
    function Get_CREATEDATE: UnicodeString;
    function Get_VERSION: UnicodeString;
    procedure Set_CREATEDATE(Value: UnicodeString);
    procedure Set_VERSION(Value: UnicodeString);
  end;

{ TXMLORGType }

  TXMLORGType = class(TXMLNode, IXMLORGType)
  protected
    { IXMLORGType }
    function Get_FIELDS: IXMLFIELDSType;
    function Get_CARD: IXMLCARDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFIELDSType }

  TXMLFIELDSType = class(TXMLNode, IXMLFIELDSType)
  protected
    { IXMLFIELDSType }
    function Get_EDRPOU: UnicodeString;
    function Get_PERTYPE: UnicodeString;
    function Get_PERDATE: UnicodeString;
    function Get_CHARCODE: UnicodeString;
    function Get_DOCID: UnicodeString;
    procedure Set_EDRPOU(Value: UnicodeString);
    procedure Set_PERTYPE(Value: UnicodeString);
    procedure Set_PERDATE(Value: UnicodeString);
    procedure Set_CHARCODE(Value: UnicodeString);
    procedure Set_DOCID(Value: UnicodeString);
  end;

{ TXMLCARDType }

  TXMLCARDType = class(TXMLNode, IXMLCARDType)
  protected
    { IXMLCARDType }
    function Get_FIELDS: IXMLFIELDSType;
    function Get_DOCUMENT: IXMLDOCUMENTType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDOCUMENTType }

  TXMLDOCUMENTType = class(TXMLNodeCollection, IXMLDOCUMENTType)
  protected
    { IXMLDOCUMENTType }
    function Get_ROW(Index: Integer): IXMLROWType;
    function Add: IXMLROWType;
    function Insert(const Index: Integer): IXMLROWType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLROWType }

  TXMLROWType = class(TXMLNode, IXMLROWType)
  protected
    { IXMLROWType }
    function Get_TAB: UnicodeString;
    function Get_LINE: UnicodeString;
    function Get_NAME: UnicodeString;
    function Get_VALUE: UnicodeString;
    procedure Set_TAB(Value: UnicodeString);
    procedure Set_LINE(Value: UnicodeString);
    procedure Set_NAME(Value: UnicodeString);
    procedure Set_VALUE(Value: UnicodeString);
  end;

{ Global Functions }

function GetZVIT(Doc: IXMLDocument): IXMLZVITType;
function LoadZVIT(const FileName: string): IXMLZVITType;
function NewZVIT: IXMLZVITType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetZVIT(Doc: IXMLDocument): IXMLZVITType;
begin
  Result := Doc.GetDocBinding('ZVIT', TXMLZVITType, TargetNamespace) as IXMLZVITType;
end;

function LoadZVIT(const FileName: string): IXMLZVITType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ZVIT', TXMLZVITType, TargetNamespace) as IXMLZVITType;
end;

function NewZVIT: IXMLZVITType;
begin
  Result := NewXMLDocument.GetDocBinding('ZVIT', TXMLZVITType, TargetNamespace) as IXMLZVITType;
end;

{ TXMLZVITType }

procedure TXMLZVITType.AfterConstruction;
begin
  RegisterChildNode('TRANSPORT', TXMLTRANSPORTType);
  RegisterChildNode('ORG', TXMLORGType);
  inherited;
end;

function TXMLZVITType.Get_TRANSPORT: IXMLTRANSPORTType;
begin
  Result := ChildNodes['TRANSPORT'] as IXMLTRANSPORTType;
end;

function TXMLZVITType.Get_ORG: IXMLORGType;
begin
  Result := ChildNodes['ORG'] as IXMLORGType;
end;

{ TXMLTRANSPORTType }

function TXMLTRANSPORTType.Get_CREATEDATE: UnicodeString;
begin
  Result := ChildNodes['CREATEDATE'].Text;
end;

procedure TXMLTRANSPORTType.Set_CREATEDATE(Value: UnicodeString);
begin
  ChildNodes['CREATEDATE'].NodeValue := Value;
end;

function TXMLTRANSPORTType.Get_VERSION: UnicodeString;
begin
  Result := ChildNodes['VERSION'].Text;
end;

procedure TXMLTRANSPORTType.Set_VERSION(Value: UnicodeString);
begin
  ChildNodes['VERSION'].NodeValue := Value;
end;

{ TXMLORGType }

procedure TXMLORGType.AfterConstruction;
begin
  RegisterChildNode('FIELDS', TXMLFIELDSType);
  RegisterChildNode('CARD', TXMLCARDType);
  inherited;
end;

function TXMLORGType.Get_FIELDS: IXMLFIELDSType;
begin
  Result := ChildNodes['FIELDS'] as IXMLFIELDSType;
end;

function TXMLORGType.Get_CARD: IXMLCARDType;
begin
  Result := ChildNodes['CARD'] as IXMLCARDType;
end;

{ TXMLFIELDSType }

function TXMLFIELDSType.Get_EDRPOU: UnicodeString;
begin
  Result := ChildNodes['EDRPOU'].Text;
end;

procedure TXMLFIELDSType.Set_EDRPOU(Value: UnicodeString);
begin
  ChildNodes['EDRPOU'].NodeValue := Value;
end;

function TXMLFIELDSType.Get_PERTYPE: UnicodeString;
begin
  Result := ChildNodes['PERTYPE'].Text;
end;

procedure TXMLFIELDSType.Set_PERTYPE(Value: UnicodeString);
begin
  ChildNodes['PERTYPE'].NodeValue := Value;
end;

function TXMLFIELDSType.Get_PERDATE: UnicodeString;
begin
  Result := ChildNodes['PERDATE'].Text;
end;

procedure TXMLFIELDSType.Set_PERDATE(Value: UnicodeString);
begin
  ChildNodes['PERDATE'].NodeValue := Value;
end;

function TXMLFIELDSType.Get_CHARCODE: UnicodeString;
begin
  Result := ChildNodes['CHARCODE'].Text;
end;

procedure TXMLFIELDSType.Set_CHARCODE(Value: UnicodeString);
begin
  ChildNodes['CHARCODE'].NodeValue := Value;
end;

function TXMLFIELDSType.Get_DOCID: UnicodeString;
begin
  Result := ChildNodes['DOCID'].Text;
end;

procedure TXMLFIELDSType.Set_DOCID(Value: UnicodeString);
begin
  ChildNodes['DOCID'].NodeValue := Value;
end;

{ TXMLCARDType }

procedure TXMLCARDType.AfterConstruction;
begin
  RegisterChildNode('FIELDS', TXMLFIELDSType);
  RegisterChildNode('DOCUMENT', TXMLDOCUMENTType);
  inherited;
end;

function TXMLCARDType.Get_FIELDS: IXMLFIELDSType;
begin
  Result := ChildNodes['FIELDS'] as IXMLFIELDSType;
end;

function TXMLCARDType.Get_DOCUMENT: IXMLDOCUMENTType;
begin
  Result := ChildNodes['DOCUMENT'] as IXMLDOCUMENTType;
end;

{ TXMLDOCUMENTType }

procedure TXMLDOCUMENTType.AfterConstruction;
begin
  RegisterChildNode('ROW', TXMLROWType);
  ItemTag := 'ROW';
  ItemInterface := IXMLROWType;
  inherited;
end;

function TXMLDOCUMENTType.Get_ROW(Index: Integer): IXMLROWType;
begin
  Result := List[Index] as IXMLROWType;
end;

function TXMLDOCUMENTType.Add: IXMLROWType;
begin
  Result := AddItem(-1) as IXMLROWType;
end;

function TXMLDOCUMENTType.Insert(const Index: Integer): IXMLROWType;
begin
  Result := AddItem(Index) as IXMLROWType;
end;

{ TXMLROWType }

function TXMLROWType.Get_TAB: UnicodeString;
begin
  Result := AttributeNodes['TAB'].Text;
end;

procedure TXMLROWType.Set_TAB(Value: UnicodeString);
begin
  SetAttribute('TAB', Value);
end;

function TXMLROWType.Get_LINE: UnicodeString;
begin
  Result := AttributeNodes['LINE'].Text;
end;

procedure TXMLROWType.Set_LINE(Value: UnicodeString);
begin
  SetAttribute('LINE', Value);
end;

function TXMLROWType.Get_NAME: UnicodeString;
begin
  Result := AttributeNodes['NAME'].Text;
end;

procedure TXMLROWType.Set_NAME(Value: UnicodeString);
begin
  SetAttribute('NAME', Value);
end;

function TXMLROWType.Get_VALUE: UnicodeString;
begin
  Result := ChildNodes['VALUE'].Text;
end;

procedure TXMLROWType.Set_VALUE(Value: UnicodeString);
begin
  ChildNodes['VALUE'].NodeValue := Value;
end;

end.