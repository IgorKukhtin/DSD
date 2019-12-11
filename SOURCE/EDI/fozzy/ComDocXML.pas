
{*******************************************************************************}
{                                                                               }
{                               XML Data Binding                                }
{                                                                               }
{         Generated on: 21.11.2019 13:33:04                                     }
{       Generated from: D:\Work\Project\XML\comdoc_201911211036_545329106.xml   }
{   Settings stored in: D:\Work\Project\XML\comdoc_201911211036_545329106.xdb   }
{                                                                               }
{*******************************************************************************}

unit ComDocXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXML�������������������Type = interface;
  IXML���������Type = interface;
  IXML�������Type = interface;
  IXML����������Type = interface;
  IXML���������Type = interface;
  IXML��������Type = interface;
  IXML�������Type = interface;
  IXML�����Type = interface;
  IXML��������Type = interface;

{ IXML�������������������Type }

  IXML�������������������Type = interface(IXMLNode)
    ['{7F3227B1-247B-4C01-8768-5DAAD0C14E57}']
    { Property Accessors }
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    { Methods & Properties }
    property ���������: IXML���������Type read Get_���������;
    property �������: IXML�������Type read Get_�������;
    property ���������: IXML���������Type read Get_���������;
    property �������: IXML�������Type read Get_�������;
  end;

{ IXML���������Type }

  IXML���������Type = interface(IXMLNode)
    ['{FD932D61-ACD9-42B4-BCF8-C3C8956D5305}']
    { Property Accessors }
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: Integer;
    function Get_�������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_̳������������: UnicodeString;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: Integer);
    procedure Set_�������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_̳������������(Value: UnicodeString);
    { Methods & Properties }
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ����������������: Integer read Get_���������������� write Set_����������������;
    property �������������: UnicodeString read Get_������������� write Set_�������������;
    property ���������������: UnicodeString read Get_��������������� write Set_���������������;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ̳������������: UnicodeString read Get_̳������������ write Set_̳������������;
  end;

{ IXML�������Type }

  IXML�������Type = interface(IXMLNodeCollection)
    ['{16514CB9-A1E3-4E7A-A171-15D6A4D5E7DB}']
    { Property Accessors }
    function Get_����������(Index: Integer): IXML����������Type;
    { Methods & Properties }
    function Add: IXML����������Type;
    function Insert(const Index: Integer): IXML����������Type;
    property ����������[Index: Integer]: IXML����������Type read Get_����������; default;
  end;

{ IXML����������Type }

  IXML����������Type = interface(IXMLNode)
    ['{C5C33254-CCB9-4146-A8D9-61E5517152B5}']
    { Property Accessors }
    function Get_�����������������: UnicodeString;
    function Get_��������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_��������������: Integer;
    function Get_���: Integer;
    function Get_GLN: Integer;
    procedure Set_�����������������(Value: UnicodeString);
    procedure Set_��������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_��������������(Value: Integer);
    procedure Set_���(Value: Integer);
    procedure Set_GLN(Value: Integer);
    { Methods & Properties }
    property �����������������: UnicodeString read Get_����������������� write Set_�����������������;
    property ��������: UnicodeString read Get_�������� write Set_��������;
    property ����������������: UnicodeString read Get_���������������� write Set_����������������;
    property ��������������: Integer read Get_�������������� write Set_��������������;
    property ���: Integer read Get_��� write Set_���;
    property GLN: Integer read Get_GLN write Set_GLN;
  end;

{ IXML���������Type }

  IXML���������Type = interface(IXMLNodeCollection)
    ['{795A5564-999E-49AA-94AF-454870ABD0BE}']
    { Property Accessors }
    function Get_��������(Index: Integer): IXML��������Type;
    { Methods & Properties }
    function Add: IXML��������Type;
    function Insert(const Index: Integer): IXML��������Type;
    property ��������[Index: Integer]: IXML��������Type read Get_��������; default;
  end;

{ IXML��������Type }

  IXML��������Type = interface(IXMLNode)
    ['{19AEFD74-3B85-414C-B2B0-1AEC98ECCDF9}']
    { Property Accessors }
    function Get_��: Integer;
    function Get_�����: UnicodeString;
    procedure Set_��(Value: Integer);
    procedure Set_�����(Value: UnicodeString);
    { Methods & Properties }
    property ��: Integer read Get_�� write Set_��;
    property �����: UnicodeString read Get_����� write Set_�����;
  end;

{ IXML�������Type }

  IXML�������Type = interface(IXMLNode)
    ['{BF01A3DA-1E2D-4DD6-B4B2-F1D6248D32A3}']
    { Property Accessors }
    function Get_�����: IXML�����Type;
    { Methods & Properties }
    property �����: IXML�����Type read Get_�����;
  end;

{ IXML�����Type }

  IXML�����Type = interface(IXMLNode)
    ['{2829D0E2-328A-4431-A5C2-5507075B63F0}']
    { Property Accessors }
    function Get_��: Integer;
    function Get_������: Integer;
    function Get_��������: IXML��������Type;
    function Get_��������������: Integer;
    function Get_������������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_������ֳ��: UnicodeString;
    function Get_�����: Integer;
    procedure Set_��(Value: Integer);
    procedure Set_������(Value: Integer);
    procedure Set_��������������(Value: Integer);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_������ֳ��(Value: UnicodeString);
    procedure Set_�����(Value: Integer);
    { Methods & Properties }
    property ��: Integer read Get_�� write Set_��;
    property ������: Integer read Get_������ write Set_������;
    property ��������: IXML��������Type read Get_��������;
    property ��������������: Integer read Get_�������������� write Set_��������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ��������ʳ������: UnicodeString read Get_��������ʳ������ write Set_��������ʳ������;
    property ��������ʳ������: UnicodeString read Get_��������ʳ������ write Set_��������ʳ������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ������ֳ��: UnicodeString read Get_������ֳ�� write Set_������ֳ��;
    property �����: Integer read Get_����� write Set_�����;
  end;

{ IXML��������Type }

  IXML��������Type = interface(IXMLNode)
    ['{E871A5B1-9556-4710-96BC-C925FDACBC32}']
    { Property Accessors }
    function Get_��: Integer;
    procedure Set_��(Value: Integer);
    { Methods & Properties }
    property ��: Integer read Get_�� write Set_��;
  end;

{ Forward Decls }

  TXML�������������������Type = class;
  TXML���������Type = class;
  TXML�������Type = class;
  TXML����������Type = class;
  TXML���������Type = class;
  TXML��������Type = class;
  TXML�������Type = class;
  TXML�����Type = class;
  TXML��������Type = class;

{ TXML�������������������Type }

  TXML�������������������Type = class(TXMLNode, IXML�������������������Type)
  protected
    { IXML�������������������Type }
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXML���������Type }

  TXML���������Type = class(TXMLNode, IXML���������Type)
  protected
    { IXML���������Type }
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: Integer;
    function Get_�������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_̳������������: UnicodeString;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: Integer);
    procedure Set_�������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_̳������������(Value: UnicodeString);
  end;

{ TXML�������Type }

  TXML�������Type = class(TXMLNodeCollection, IXML�������Type)
  protected
    { IXML�������Type }
    function Get_����������(Index: Integer): IXML����������Type;
    function Add: IXML����������Type;
    function Insert(const Index: Integer): IXML����������Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXML����������Type }

  TXML����������Type = class(TXMLNode, IXML����������Type)
  protected
    { IXML����������Type }
    function Get_�����������������: UnicodeString;
    function Get_��������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_��������������: Integer;
    function Get_���: Integer;
    function Get_GLN: Integer;
    procedure Set_�����������������(Value: UnicodeString);
    procedure Set_��������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_��������������(Value: Integer);
    procedure Set_���(Value: Integer);
    procedure Set_GLN(Value: Integer);
  end;

{ TXML���������Type }

  TXML���������Type = class(TXMLNodeCollection, IXML���������Type)
  protected
    { IXML���������Type }
    function Get_��������(Index: Integer): IXML��������Type;
    function Add: IXML��������Type;
    function Insert(const Index: Integer): IXML��������Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXML��������Type }

  TXML��������Type = class(TXMLNode, IXML��������Type)
  protected
    { IXML��������Type }
    function Get_��: Integer;
    function Get_�����: UnicodeString;
    procedure Set_��(Value: Integer);
    procedure Set_�����(Value: UnicodeString);
  end;

{ TXML�������Type }

  TXML�������Type = class(TXMLNode, IXML�������Type)
  protected
    { IXML�������Type }
    function Get_�����: IXML�����Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXML�����Type }

  TXML�����Type = class(TXMLNode, IXML�����Type)
  protected
    { IXML�����Type }
    function Get_��: Integer;
    function Get_������: Integer;
    function Get_��������: IXML��������Type;
    function Get_��������������: Integer;
    function Get_������������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_������ֳ��: UnicodeString;
    function Get_�����: Integer;
    procedure Set_��(Value: Integer);
    procedure Set_������(Value: Integer);
    procedure Set_��������������(Value: Integer);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_������ֳ��(Value: UnicodeString);
    procedure Set_�����(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXML��������Type }

  TXML��������Type = class(TXMLNode, IXML��������Type)
  protected
    { IXML��������Type }
    function Get_��: Integer;
    procedure Set_��(Value: Integer);
  end;

{ Global Functions }

function GetComDoc(Doc: IXMLDocument): IXML�������������������Type;
function LoadComDoc(const FileName: string): IXML�������������������Type;
function NewComDoc: IXML�������������������Type;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetComDoc(Doc: IXMLDocument): IXML�������������������Type;
begin
  Result := Doc.GetDocBinding('ComDoc', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
end;

function LoadComDoc(const FileName: string): IXML�������������������Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ComDoc', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
end;

function NewComDoc: IXML�������������������Type;
begin
  Result := NewXMLDocument.GetDocBinding('ComDoc', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
end;

{ TXML�������������������Type }

procedure TXML�������������������Type.AfterConstruction;
begin
  RegisterChildNode('���������', TXML���������Type);
  RegisterChildNode('�������', TXML�������Type);
  RegisterChildNode('���������', TXML���������Type);
  RegisterChildNode('�������', TXML�������Type);
  inherited;
end;

function TXML�������������������Type.Get_���������: IXML���������Type;
begin
  Result := ChildNodes['���������'] as IXML���������Type;
end;

function TXML�������������������Type.Get_�������: IXML�������Type;
begin
  Result := ChildNodes['�������'] as IXML�������Type;
end;

function TXML�������������������Type.Get_���������: IXML���������Type;
begin
  Result := ChildNodes['���������'] as IXML���������Type;
end;

function TXML�������������������Type.Get_�������: IXML�������Type;
begin
  Result := ChildNodes['�������'] as IXML�������Type;
end;

{ TXML���������Type }

function TXML���������Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].Text;
end;

procedure TXML���������Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML���������Type.Get_������������: UnicodeString;
begin
  Result := ChildNodes['������������'].Text;
end;

procedure TXML���������Type.Set_������������(Value: UnicodeString);
begin
  ChildNodes['������������'].NodeValue := Value;
end;

function TXML���������Type.Get_����������������: Integer;
begin
  Result := ChildNodes['����������������'].NodeValue;
end;

procedure TXML���������Type.Set_����������������(Value: Integer);
begin
  ChildNodes['����������������'].NodeValue := Value;
end;

function TXML���������Type.Get_�������������: UnicodeString;
begin
  Result := ChildNodes['�������������'].Text;
end;

procedure TXML���������Type.Set_�������������(Value: UnicodeString);
begin
  ChildNodes['�������������'].NodeValue := Value;
end;

function TXML���������Type.Get_���������������: UnicodeString;
begin
  Result := ChildNodes['���������������'].Text;
end;

procedure TXML���������Type.Set_���������������(Value: UnicodeString);
begin
  ChildNodes['���������������'].NodeValue := Value;
end;

function TXML���������Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].Text;
end;

procedure TXML���������Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML���������Type.Get_̳������������: UnicodeString;
begin
  Result := ChildNodes['̳������������'].Text;
end;

procedure TXML���������Type.Set_̳������������(Value: UnicodeString);
begin
  ChildNodes['̳������������'].NodeValue := Value;
end;

{ TXML�������Type }

procedure TXML�������Type.AfterConstruction;
begin
  RegisterChildNode('����������', TXML����������Type);
  ItemTag := '����������';
  ItemInterface := IXML����������Type;
  inherited;
end;

function TXML�������Type.Get_����������(Index: Integer): IXML����������Type;
begin
  Result := List[Index] as IXML����������Type;
end;

function TXML�������Type.Add: IXML����������Type;
begin
  Result := AddItem(-1) as IXML����������Type;
end;

function TXML�������Type.Insert(const Index: Integer): IXML����������Type;
begin
  Result := AddItem(Index) as IXML����������Type;
end;

{ TXML����������Type }

function TXML����������Type.Get_�����������������: UnicodeString;
begin
  Result := ChildNodes['�����������������'].Text;
end;

procedure TXML����������Type.Set_�����������������(Value: UnicodeString);
begin
  ChildNodes['�����������������'].NodeValue := Value;
end;

function TXML����������Type.Get_��������: UnicodeString;
begin
  Result := ChildNodes['��������'].Text;
end;

procedure TXML����������Type.Set_��������(Value: UnicodeString);
begin
  ChildNodes['��������'].NodeValue := Value;
end;

function TXML����������Type.Get_����������������: UnicodeString;
begin
  Result := ChildNodes['����������������'].Text;
end;

procedure TXML����������Type.Set_����������������(Value: UnicodeString);
begin
  ChildNodes['����������������'].NodeValue := Value;
end;

function TXML����������Type.Get_��������������: Integer;
begin
  Result := ChildNodes['��������������'].NodeValue;
end;

procedure TXML����������Type.Set_��������������(Value: Integer);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML����������Type.Get_���: Integer;
begin
  Result := ChildNodes['���'].NodeValue;
end;

procedure TXML����������Type.Set_���(Value: Integer);
begin
  ChildNodes['���'].NodeValue := Value;
end;

function TXML����������Type.Get_GLN: Integer;
begin
  Result := ChildNodes['GLN'].NodeValue;
end;

procedure TXML����������Type.Set_GLN(Value: Integer);
begin
  ChildNodes['GLN'].NodeValue := Value;
end;

{ TXML���������Type }

procedure TXML���������Type.AfterConstruction;
begin
  RegisterChildNode('��������', TXML��������Type);
  ItemTag := '��������';
  ItemInterface := IXML��������Type;
  inherited;
end;

function TXML���������Type.Get_��������(Index: Integer): IXML��������Type;
begin
  Result := List[Index] as IXML��������Type;
end;

function TXML���������Type.Add: IXML��������Type;
begin
  Result := AddItem(-1) as IXML��������Type;
end;

function TXML���������Type.Insert(const Index: Integer): IXML��������Type;
begin
  Result := AddItem(Index) as IXML��������Type;
end;

{ TXML��������Type }

function TXML��������Type.Get_��: Integer;
begin
  Result := AttributeNodes['��'].NodeValue;
end;

procedure TXML��������Type.Set_��(Value: Integer);
begin
  SetAttribute('��', Value);
end;

function TXML��������Type.Get_�����: UnicodeString;
begin
  Result := AttributeNodes['�����'].Text;
end;

procedure TXML��������Type.Set_�����(Value: UnicodeString);
begin
  SetAttribute('�����', Value);
end;

{ TXML�������Type }

procedure TXML�������Type.AfterConstruction;
begin
  RegisterChildNode('�����', TXML�����Type);
  inherited;
end;

function TXML�������Type.Get_�����: IXML�����Type;
begin
  Result := ChildNodes['�����'] as IXML�����Type;
end;

{ TXML�����Type }

procedure TXML�����Type.AfterConstruction;
begin
  RegisterChildNode('��������', TXML��������Type);
  inherited;
end;

function TXML�����Type.Get_��: Integer;
begin
  Result := AttributeNodes['��'].NodeValue;
end;

procedure TXML�����Type.Set_��(Value: Integer);
begin
  SetAttribute('��', Value);
end;

function TXML�����Type.Get_������: Integer;
begin
  Result := ChildNodes['������'].NodeValue;
end;

procedure TXML�����Type.Set_������(Value: Integer);
begin
  ChildNodes['������'].NodeValue := Value;
end;

function TXML�����Type.Get_��������: IXML��������Type;
begin
  Result := ChildNodes['��������'] as IXML��������Type;
end;

function TXML�����Type.Get_��������������: Integer;
begin
  Result := ChildNodes['��������������'].NodeValue;
end;

procedure TXML�����Type.Set_��������������(Value: Integer);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML�����Type.Get_������������: UnicodeString;
begin
  Result := ChildNodes['������������'].Text;
end;

procedure TXML�����Type.Set_������������(Value: UnicodeString);
begin
  ChildNodes['������������'].NodeValue := Value;
end;

function TXML�����Type.Get_��������ʳ������: UnicodeString;
begin
  Result := ChildNodes['��������ʳ������'].Text;
end;

procedure TXML�����Type.Set_��������ʳ������(Value: UnicodeString);
begin
  ChildNodes['��������ʳ������'].NodeValue := Value;
end;

function TXML�����Type.Get_��������ʳ������: UnicodeString;
begin
  Result := ChildNodes['��������ʳ������'].Text;
end;

procedure TXML�����Type.Set_��������ʳ������(Value: UnicodeString);
begin
  ChildNodes['��������ʳ������'].NodeValue := Value;
end;

function TXML�����Type.Get_������������: UnicodeString;
begin
  Result := ChildNodes['������������'].Text;
end;

procedure TXML�����Type.Set_������������(Value: UnicodeString);
begin
  ChildNodes['������������'].NodeValue := Value;
end;

function TXML�����Type.Get_������ֳ��: UnicodeString;
begin
  Result := ChildNodes['������ֳ��'].Text;
end;

procedure TXML�����Type.Set_������ֳ��(Value: UnicodeString);
begin
  ChildNodes['������ֳ��'].NodeValue := Value;
end;

function TXML�����Type.Get_�����: Integer;
begin
  Result := ChildNodes['�����'].NodeValue;
end;

procedure TXML�����Type.Set_�����(Value: Integer);
begin
  ChildNodes['�����'].NodeValue := Value;
end;

{ TXML��������Type }

function TXML��������Type.Get_��: Integer;
begin
  Result := AttributeNodes['��'].NodeValue;
end;

procedure TXML��������Type.Set_��(Value: Integer);
begin
  SetAttribute('��', Value);
end;

end.