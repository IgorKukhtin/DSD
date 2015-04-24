{******************************************************}
{                                                      }
{                   XML Data Binding                   }
{                                                      }
{                                                      }
{******************************************************}

unit ScriptXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLSCRIPTType = interface;
  IXMLFORMType = interface;
  IXMLCOMPONENTSType = interface;
  IXMLCOMPONENTType = interface;
  IXMLACTIONSType = interface;
  IXMLACTIONType = interface;

{ IXMLSCRIPTType }

  IXMLSCRIPTType = interface(IXMLNodeCollection)
    ['{C7F64694-D4CB-4E70-BF56-CF48BB38615A}']
    { Property Accessors }
    function Get_FORM(Index: Integer): IXMLFORMType;
    { Methods & Properties }
    function Add: IXMLFORMType;
    function Insert(const Index: Integer): IXMLFORMType;
    property FORM[Index: Integer]: IXMLFORMType read Get_FORM; default;
  end;

{ IXMLFORMType }

  IXMLFORMType = interface(IXMLNode)
    ['{EAA089A4-A86D-4DD6-807B-902AFCA50122}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_COMPONENTS: IXMLCOMPONENTSType;
    function Get_ACTIONS: IXMLACTIONSType;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property COMPONENTS: IXMLCOMPONENTSType read Get_COMPONENTS;
    property ACTIONS: IXMLACTIONSType read Get_ACTIONS;
  end;

{ IXMLCOMPONENTSType }

  IXMLCOMPONENTSType = interface(IXMLNodeCollection)
    ['{29B8E56A-4824-4FF8-81C8-9E1DF78E8968}']
    { Property Accessors }
    function Get_COMPONENT(Index: Integer): IXMLCOMPONENTType;
    { Methods & Properties }
    function Add: IXMLCOMPONENTType;
    function Insert(const Index: Integer): IXMLCOMPONENTType;
    property COMPONENT[Index: Integer]: IXMLCOMPONENTType read Get_COMPONENT; default;
  end;

{ IXMLCOMPONENTType }

  IXMLCOMPONENTType = interface(IXMLNode)
    ['{E898848F-7B64-41E5-BBF5-032CEB69A5B2}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Value: UnicodeString;
    function Get_Property: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Property(Value: UnicodeString);
    procedure Set_Value(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Value: UnicodeString read Get_Value write Set_Value;
    property PropertyName: UnicodeString read Get_Property write Set_Property;
  end;

{ IXMLACTIONSType }

  IXMLACTIONSType = interface(IXMLNodeCollection)
    ['{5B581957-6068-4ED0-9A6E-FA46F6C63BFF}']
    { Property Accessors }
    function Get_ACTION(Index: Integer): IXMLACTIONType;
    { Methods & Properties }
    function Add: IXMLACTIONType;
    function Insert(const Index: Integer): IXMLACTIONType;
    property ACTION[Index: Integer]: IXMLACTIONType read Get_ACTION; default;
  end;

{ IXMLACTIONType }

  IXMLACTIONType = interface(IXMLNode)
    ['{7F696F1E-8926-49CD-ABAD-1B639FC0AFA5}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ Forward Decls }

  TXMLSCRIPTType = class;
  TXMLFORMType = class;
  TXMLCOMPONENTSType = class;
  TXMLCOMPONENTType = class;
  TXMLACTIONSType = class;
  TXMLACTIONType = class;

{ TXMLSCRIPTType }

  TXMLSCRIPTType = class(TXMLNodeCollection, IXMLSCRIPTType)
  protected
    { IXMLSCRIPTType }
    function Get_FORM(Index: Integer): IXMLFORMType;
    function Add: IXMLFORMType;
    function Insert(const Index: Integer): IXMLFORMType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFORMType }

  TXMLFORMType = class(TXMLNode, IXMLFORMType)
  protected
    { IXMLFORMType }
    function Get_Name: UnicodeString;
    function Get_COMPONENTS: IXMLCOMPONENTSType;
    function Get_ACTIONS: IXMLACTIONSType;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCOMPONENTSType }

  TXMLCOMPONENTSType = class(TXMLNodeCollection, IXMLCOMPONENTSType)
  protected
    { IXMLCOMPONENTSType }
    function Get_COMPONENT(Index: Integer): IXMLCOMPONENTType;
    function Add: IXMLCOMPONENTType;
    function Insert(const Index: Integer): IXMLCOMPONENTType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCOMPONENTType }

  TXMLCOMPONENTType = class(TXMLNode, IXMLCOMPONENTType)
  protected
    { IXMLCOMPONENTType }
    function Get_Name: UnicodeString;
    function Get_Value: UnicodeString;
    function Get_Property: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Value(Value: UnicodeString);
    procedure Set_Property(Value: UnicodeString);
  end;

{ TXMLACTIONSType }

  TXMLACTIONSType = class(TXMLNodeCollection, IXMLACTIONSType)
  protected
    { IXMLACTIONSType }
    function Get_ACTION(Index: Integer): IXMLACTIONType;
    function Add: IXMLACTIONType;
    function Insert(const Index: Integer): IXMLACTIONType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACTIONType }

  TXMLACTIONType = class(TXMLNode, IXMLACTIONType)
  protected
    { IXMLACTIONType }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
  end;

{ Global Functions }

function GetSCRIPT(Doc: IXMLDocument): IXMLSCRIPTType;
function LoadSCRIPT(const FileName: string): IXMLSCRIPTType;
function NewSCRIPT: IXMLSCRIPTType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetSCRIPT(Doc: IXMLDocument): IXMLSCRIPTType;
begin
  Result := Doc.GetDocBinding('SCRIPT', TXMLSCRIPTType, TargetNamespace) as IXMLSCRIPTType;
end;

function LoadSCRIPT(const FileName: string): IXMLSCRIPTType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SCRIPT', TXMLSCRIPTType, TargetNamespace) as IXMLSCRIPTType;
end;

function NewSCRIPT: IXMLSCRIPTType;
begin
  Result := NewXMLDocument.GetDocBinding('SCRIPT', TXMLSCRIPTType, TargetNamespace) as IXMLSCRIPTType;
end;

{ TXMLSCRIPTType }

procedure TXMLSCRIPTType.AfterConstruction;
begin
  RegisterChildNode('FORM', TXMLFORMType);
  ItemTag := 'FORM';
  ItemInterface := IXMLFORMType;
  inherited;
end;

function TXMLSCRIPTType.Get_FORM(Index: Integer): IXMLFORMType;
begin
  Result := List[Index] as IXMLFORMType;
end;

function TXMLSCRIPTType.Add: IXMLFORMType;
begin
  Result := AddItem(-1) as IXMLFORMType;
end;

function TXMLSCRIPTType.Insert(const Index: Integer): IXMLFORMType;
begin
  Result := AddItem(Index) as IXMLFORMType;
end;

{ TXMLFORMType }

procedure TXMLFORMType.AfterConstruction;
begin
  RegisterChildNode('COMPONENTS', TXMLCOMPONENTSType);
  RegisterChildNode('ACTIONS', TXMLACTIONSType);
  inherited;
end;

function TXMLFORMType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLFORMType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('Name', Value);
end;

function TXMLFORMType.Get_COMPONENTS: IXMLCOMPONENTSType;
begin
  Result := ChildNodes['COMPONENTS'] as IXMLCOMPONENTSType;
end;

function TXMLFORMType.Get_ACTIONS: IXMLACTIONSType;
begin
  Result := ChildNodes['ACTIONS'] as IXMLACTIONSType;
end;

{ TXMLCOMPONENTSType }

procedure TXMLCOMPONENTSType.AfterConstruction;
begin
  RegisterChildNode('COMPONENT', TXMLCOMPONENTType);
  ItemTag := 'COMPONENT';
  ItemInterface := IXMLCOMPONENTType;
  inherited;
end;

function TXMLCOMPONENTSType.Get_COMPONENT(Index: Integer): IXMLCOMPONENTType;
begin
  Result := List[Index] as IXMLCOMPONENTType;
end;

function TXMLCOMPONENTSType.Add: IXMLCOMPONENTType;
begin
  Result := AddItem(-1) as IXMLCOMPONENTType;
end;

function TXMLCOMPONENTSType.Insert(const Index: Integer): IXMLCOMPONENTType;
begin
  Result := AddItem(Index) as IXMLCOMPONENTType;
end;

{ TXMLCOMPONENTType }

function TXMLCOMPONENTType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLCOMPONENTType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('Name', Value);
end;

function TXMLCOMPONENTType.Get_Property: UnicodeString;
begin
  Result := AttributeNodes['Property'].Text;
end;

procedure TXMLCOMPONENTType.Set_Property(Value: UnicodeString);
begin
  SetAttribute('Property', Value);
end;

function TXMLCOMPONENTType.Get_Value: UnicodeString;
begin
  Result := AttributeNodes['Value'].Text;
end;

procedure TXMLCOMPONENTType.Set_Value(Value: UnicodeString);
begin
  SetAttribute('Value', Value);
end;

{ TXMLACTIONSType }

procedure TXMLACTIONSType.AfterConstruction;
begin
  RegisterChildNode('ACTION', TXMLACTIONType);
  ItemTag := 'ACTION';
  ItemInterface := IXMLACTIONType;
  inherited;
end;

function TXMLACTIONSType.Get_ACTION(Index: Integer): IXMLACTIONType;
begin
  Result := List[Index] as IXMLACTIONType;
end;

function TXMLACTIONSType.Add: IXMLACTIONType;
begin
  Result := AddItem(-1) as IXMLACTIONType;
end;

function TXMLACTIONSType.Insert(const Index: Integer): IXMLACTIONType;
begin
  Result := AddItem(Index) as IXMLACTIONType;
end;

{ TXMLACTIONType }

function TXMLACTIONType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLACTIONType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('Name', Value);
end;

end.