unit ComDocXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXML�������������������Type = interface;
  IXML���������Type = interface;
  IXML���ϳ������Type = interface;
  IXML�������Type = interface;
  IXML����������Type = interface;
  IXML���������Type = interface;
  IXML��������Type = interface;
  IXML�������Type = interface;
  IXML�����Type = interface;
  IXML��������Type = interface;
  IXML�������������Type = interface;
  IXML������������Type = interface;
  IXML�����������������Type = interface;

{ IXML�������������������Type }

  IXML�������������������Type = interface(IXMLNode)
    ['{9DF9164B-0E86-4F6D-8CD9-619754D2EE0D}']
    { Property Accessors }
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    function Get_�����������������: IXML�����������������Type;
    { Methods & Properties }
    property ���������: IXML���������Type read Get_���������;
    property �������: IXML�������Type read Get_�������;
    property ���������: IXML���������Type read Get_���������;
    property �������: IXML�������Type read Get_�������;
    property �����������������: IXML�����������������Type read Get_�����������������;
  end;

{ IXML���������Type }

  IXML���������Type = interface(IXMLNode)
    ['{F16C56EC-DCFC-43CC-AC73-34EF74218B6F}']
    { Property Accessors }
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_�������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_̳������������: UnicodeString;
    function Get_���ϳ������: IXML���ϳ������Type;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_�������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_̳������������(Value: UnicodeString);
    { Methods & Properties }
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ����������������: UnicodeString read Get_���������������� write Set_����������������;
    property �������������: UnicodeString read Get_������������� write Set_�������������;
    property ���������������: UnicodeString read Get_��������������� write Set_���������������;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ̳������������: UnicodeString read Get_̳������������ write Set_̳������������;
    property ���ϳ������: IXML���ϳ������Type read Get_���ϳ������;
end;

{ IXML���ϳ������Type }

  IXML���ϳ������Type = interface(IXMLNode)
    ['{A0FE8FAB-308F-463F-A37D-889038B51506}']
    { Property Accessors }
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_�������������: UnicodeString;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_�������������(Value: UnicodeString);
    { Methods & Properties }
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ����������������: UnicodeString read Get_���������������� write Set_����������������;
    property �������������: UnicodeString read Get_������������� write Set_�������������;
  end;

{ IXML�������Type }

  IXML�������Type = interface(IXMLNodeCollection)
    ['{78F798DC-7528-46E5-A61F-8870C8D581DB}']
    { Property Accessors }
    function Get_����������(Index: Integer): IXML����������Type;
    { Methods & Properties }
    function Add: IXML����������Type;
    function Insert(const Index: Integer): IXML����������Type;
    property ����������[Index: Integer]: IXML����������Type read Get_����������; default;
  end;

{ IXML����������Type }

  IXML����������Type = interface(IXMLNode)
    ['{81D5009D-3F3C-4B99-83A7-3FFDD7D94B22}']
    { Property Accessors }
    function Get_�����������������: UnicodeString;
    function Get_��������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_�����������: UnicodeString;
    function Get_GLN: UnicodeString;
    procedure Set_�����������������(Value: UnicodeString);
    procedure Set_��������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_�����������(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
    { Methods & Properties }
    property �����������������: UnicodeString read Get_����������������� write Set_�����������������;
    property ��������: UnicodeString read Get_�������� write Set_��������;
    property ����������������: UnicodeString read Get_���������������� write Set_����������������;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ���: UnicodeString read Get_��� write Set_���;
    property �����������: UnicodeString read Get_����������� write Set_�����������;
    property GLN: UnicodeString read Get_GLN write Set_GLN;
  end;

{ IXML���������Type }

  IXML���������Type = interface(IXMLNodeCollection)
    ['{CAB95EA0-C902-4858-A1C1-E79BFEA3C4AC}']
    { Property Accessors }
    function Get_��������(Index: Integer): IXML��������Type;
    { Methods & Properties }
    function Add: IXML��������Type;
    function Insert(const Index: Integer): IXML��������Type;
    function ParamByName(const Name: string): IXML��������Type;
    property ��������[Index: Integer]: IXML��������Type read Get_��������; default;
  end;

{ IXML��������Type }

  IXML��������Type = interface(IXMLNode)
    ['{723FAA54-9338-4FBF-9322-B33B970FB1B5}']
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

  IXML�������Type = interface(IXMLNodeCollection)
    ['{A0D86ABA-62BC-45A2-BCAF-678C7E2CD5F7}']
    { Property Accessors }
    function Get_�����(Index: Integer): IXML�����Type;
    { Methods & Properties }
    function Add: IXML�����Type;
    function Insert(const Index: Integer): IXML�����Type;
    property �����[Index: Integer]: IXML�����Type read Get_�����; default;
  end;

{ IXML�����Type }

  IXML�����Type = interface(IXMLNode)
    ['{3D10A9C3-3154-4E4C-90A4-2EE03B21F874}']
    { Property Accessors }
    function Get_��: Integer;
    function Get_������: Integer;
    function Get_��������: IXML��������Type;
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_������ֳ��: UnicodeString;
    function Get_���: UnicodeString;
    function Get_ֳ��: UnicodeString;
    function Get_�������������: IXML�������������Type;
    function Get_������������: IXML������������Type;
    procedure Set_��(Value: Integer);
    procedure Set_������(Value: Integer);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_������ֳ��(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_ֳ��(Value: UnicodeString);
    { Methods & Properties }
    property ��: Integer read Get_�� write Set_��;
    property ������: Integer read Get_������ write Set_������;
    property ��������: IXML��������Type read Get_��������;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ��������ʳ������: UnicodeString read Get_��������ʳ������ write Set_��������ʳ������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ������ֳ��: UnicodeString read Get_������ֳ�� write Set_������ֳ��;
    property ���: UnicodeString read Get_��� write Set_���;
    property ֳ��: UnicodeString read Get_ֳ�� write Set_ֳ��;
    property �������������: IXML�������������Type read Get_�������������;
    property ������������: IXML������������Type read Get_������������;
  end;

{ IXML��������Type }

  IXML��������Type = interface(IXMLNode)
    ['{6DFC1F15-000E-457C-A077-7691E96CB61B}']
    { Property Accessors }
    function Get_��: Integer;
    procedure Set_��(Value: Integer);
    { Methods & Properties }
    property ��: Integer read Get_�� write Set_��;
  end;

{ IXML������������Type }

  IXML������������Type = interface(IXMLNode)
    ['{6C154905-794B-4E10-AFCB-C903BAA9B3F2}']
    { Property Accessors }
    function Get_ʳ������: UnicodeString;
    procedure Set_ʳ������(Value: UnicodeString);
    { Methods & Properties }
    property ʳ������: UnicodeString read Get_ʳ������ write Set_ʳ������;
  end;

{ IXML�������������Type }

  IXML�������������Type = interface(IXMLNode)
    ['{AC5D2A22-9C35-42EF-B828-299499F3AD9B}']
    { Property Accessors }
    function Get_����������: UnicodeString;
    function Get_�������: UnicodeString;
    function Get_����: UnicodeString;
    procedure Set_����������(Value: UnicodeString);
    procedure Set_�������(Value: UnicodeString);
    procedure Set_����(Value: UnicodeString);
    { Methods & Properties }
    property ����������: UnicodeString read Get_���������� write Set_����������;
    property �������: UnicodeString read Get_������� write Set_�������;
    property ����: UnicodeString read Get_���� write Set_����;
  end;

{ IXML�����������������Type }

  IXML�����������������Type = interface(IXMLNode)
    ['{40706B07-08C3-4D78-826F-3C8785E06FF6}']
    { Property Accessors }
    function Get_����������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_����: UnicodeString;
    procedure Set_����������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_����(Value: UnicodeString);
    { Methods & Properties }
    property ����������: UnicodeString read Get_���������� write Set_����������;
    property ���: UnicodeString read Get_��� write Set_���;
    property ����: UnicodeString read Get_���� write Set_����;
  end;

{ Forward Decls }

  TXML�������������������Type = class;
  TXML���������Type = class;
  TXML���ϳ������Type = class;
  TXML�������Type = class;
  TXML����������Type = class;
  TXML���������Type = class;
  TXML��������Type = class;
  TXML�������Type = class;
  TXML�����Type = class;
  TXML��������Type = class;
  TXML�������������Type = class;
  TXML������������Type = class;
  TXML�����������������Type = class;

{ TXML�������������������Type }

  TXML�������������������Type = class(TXMLNode, IXML�������������������Type)
  protected
    { IXML�������������������Type }
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    function Get_���������: IXML���������Type;
    function Get_�������: IXML�������Type;
    function Get_�����������������: IXML�����������������Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXML���������Type }

  TXML���������Type = class(TXMLNode, IXML���������Type)
  protected
    { IXML���������Type }
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_�������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_̳������������: UnicodeString;
    function Get_���ϳ������: IXML���ϳ������Type;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_�������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_̳������������(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXML���ϳ������Type }

  TXML���ϳ������Type = class(TXMLNode, IXML���ϳ������Type)
  protected
    { IXML���ϳ������Type }
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_�������������: UnicodeString;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_�������������(Value: UnicodeString);
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
    function Get_��������������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_�����������: UnicodeString;
    function Get_GLN: UnicodeString;
    procedure Set_�����������������(Value: UnicodeString);
    procedure Set_��������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_�����������(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
  end;

{ TXML���������Type }

  TXML���������Type = class(TXMLNodeCollection, IXML���������Type)
  protected
    { IXML���������Type }
    function Get_��������(Index: Integer): IXML��������Type;
    function Add: IXML��������Type;
    function Insert(const Index: Integer): IXML��������Type;
    function ParamByName(const Name: string): IXML��������Type;
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

  TXML�������Type = class(TXMLNodeCollection, IXML�������Type)
  protected
    { IXML�������Type }
    function Get_�����(Index: Integer): IXML�����Type;
    function Add: IXML�����Type;
    function Insert(const Index: Integer): IXML�����Type;
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
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_������ֳ��: UnicodeString;
    function Get_���: UnicodeString;
    function Get_ֳ��: UnicodeString;
    function Get_�������������: IXML�������������Type;
    function Get_������������: IXML������������Type;
    procedure Set_��(Value: Integer);
    procedure Set_������(Value: Integer);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_������ֳ��(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_ֳ��(Value: UnicodeString);
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

{ TXML�������������Type }

  TXML�������������Type = class(TXMLNode, IXML�������������Type)
  protected
    { IXML�������������Type }
    function Get_����������: UnicodeString;
    function Get_�������: UnicodeString;
    function Get_����: UnicodeString;
    procedure Set_����������(Value: UnicodeString);
    procedure Set_�������(Value: UnicodeString);
    procedure Set_����(Value: UnicodeString);
  end;

{ TXML������������Type }

  TXML������������Type = class(TXMLNode, IXML������������Type)
  protected
    { IXML������������Type }
    function Get_ʳ������: UnicodeString;
    procedure Set_ʳ������(Value: UnicodeString);
  end;

{ TXML�����������������Type }

  TXML�����������������Type = class(TXMLNode, IXML�����������������Type)
  protected
    { IXML�����������������Type }
    function Get_����������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_����: UnicodeString;
    procedure Set_����������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_����(Value: UnicodeString);
  end;

{ Global Functions }

function Get�������������������(Doc: IXMLDocument): IXML�������������������Type;
function Load�������������������(const XMLString: string): IXML�������������������Type;
function New�������������������: IXML�������������������Type;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Get�������������������(Doc: IXMLDocument): IXML�������������������Type;
begin
  Result := Doc.GetDocBinding('�������������������', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
end;

function Load�������������������(const XMLString: string): IXML�������������������Type;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('�������������������', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
  end;
end;

function New�������������������: IXML�������������������Type;
begin
  Result := NewXMLDocument.GetDocBinding('�������������������', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
end;

{ TXML�������������������Type }

procedure TXML�������������������Type.AfterConstruction;
begin
  RegisterChildNode('���������', TXML���������Type);
  RegisterChildNode('�������', TXML�������Type);
  RegisterChildNode('���������', TXML���������Type);
  RegisterChildNode('�������', TXML�������Type);
  RegisterChildNode('�����������������', TXML�����������������Type);
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

function TXML�������������������Type.Get_�����������������: IXML�����������������Type;
begin
  Result := ChildNodes['�����������������'] as IXML�����������������Type;
end;

{ TXML���������Type }

procedure TXML���������Type.AfterConstruction;
begin
  RegisterChildNode('���ϳ������', TXML���ϳ������Type);
  inherited;
end;

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

function TXML���������Type.Get_����������������: UnicodeString;
begin
  Result := ChildNodes['����������������'].Text;
end;

procedure TXML���������Type.Set_����������������(Value: UnicodeString);
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

function TXML���������Type.Get_���ϳ������: IXML���ϳ������Type;
begin
  Result := ChildNodes['���ϳ������'] as IXML���ϳ������Type;
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

{ TXML���ϳ������Type }

function TXML���ϳ������Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].Text;
end;

procedure TXML���ϳ������Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML���ϳ������Type.Get_������������: UnicodeString;
begin
  Result := ChildNodes['������������'].Text;
end;

procedure TXML���ϳ������Type.Set_������������(Value: UnicodeString);
begin
  ChildNodes['������������'].NodeValue := Value;
end;

function TXML���ϳ������Type.Get_����������������: UnicodeString;
begin
  Result := ChildNodes['����������������'].Text;
end;

procedure TXML���ϳ������Type.Set_����������������(Value: UnicodeString);
begin
  ChildNodes['����������������'].NodeValue := Value;
end;

function TXML���ϳ������Type.Get_�������������: UnicodeString;
begin
  Result := ChildNodes['�������������'].Text;
end;

procedure TXML���ϳ������Type.Set_�������������(Value: UnicodeString);
begin
  ChildNodes['�������������'].NodeValue := Value;
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

function TXML����������Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].Text;
end;

procedure TXML����������Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML����������Type.Get_���: UnicodeString;
begin
  Result := ChildNodes['���'].Text;
end;

procedure TXML����������Type.Set_���(Value: UnicodeString);
begin
  ChildNodes['���'].NodeValue := Value;
end;

function TXML����������Type.Get_�����������: UnicodeString;
begin
  Result := ChildNodes['�����������'].Text;
end;

procedure TXML����������Type.Set_�����������(Value: UnicodeString);
begin
  ChildNodes['�����������'].NodeValue := Value;
end;

function TXML����������Type.Get_GLN: UnicodeString;
begin
  Result := ChildNodes['GLN'].Text;
end;

procedure TXML����������Type.Set_GLN(Value: UnicodeString);
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

function TXML���������Type.ParamByName(
  const Name: string): IXML��������Type;
var i: integer;
begin
  result := nil;
  for i := 0 to GetCount - 1 do
      if Get_��������(i).����� = Name then begin
         result := Get_��������(i);
         break
      end;
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
  ItemTag := '�����';
  ItemInterface := IXML�����Type;
  inherited;
end;

function TXML�������Type.Get_�����(Index: Integer): IXML�����Type;
begin
  Result := List[Index] as IXML�����Type;
end;

function TXML�������Type.Add: IXML�����Type;
begin
  Result := AddItem(-1) as IXML�����Type;
end;

function TXML�������Type.Insert(const Index: Integer): IXML�����Type;
begin
  Result := AddItem(Index) as IXML�����Type;
end;

{ TXML�����Type }

procedure TXML�����Type.AfterConstruction;
begin
  RegisterChildNode('��������', TXML��������Type);
  RegisterChildNode('�������������', TXML�������������Type);
  RegisterChildNode('������������', TXML������������Type);
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

function TXML�����Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].Text;
end;

procedure TXML�����Type.Set_��������������(Value: UnicodeString);
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

function TXML�����Type.Get_���: UnicodeString;
begin
  Result := ChildNodes['���'].Text;
end;

procedure TXML�����Type.Set_���(Value: UnicodeString);
begin
  ChildNodes['���'].NodeValue := Value;
end;

function TXML�����Type.Get_ֳ��: UnicodeString;
begin
  Result := ChildNodes['ֳ��'].Text;
end;

procedure TXML�����Type.Set_ֳ��(Value: UnicodeString);
begin
  ChildNodes['ֳ��'].NodeValue := Value;
end;

function TXML�����Type.Get_�������������: IXML�������������Type;
begin
  Result := ChildNodes['�������������'] as IXML�������������Type;
end;

function TXML�����Type.Get_������������: IXML������������Type;
begin
  Result := ChildNodes['������������'] as IXML������������Type;
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

{ TXML������������Type }

function TXML������������Type.Get_ʳ������: UnicodeString;
begin
  Result := ChildNodes['ʳ������'].Text;
end;

procedure TXML������������Type.Set_ʳ������(Value: UnicodeString);
begin
  ChildNodes['ʳ������'].NodeValue := Value;
end;

{ TXML�������������Type }

function TXML�������������Type.Get_����������: UnicodeString;
begin
  Result := ChildNodes['����������'].Text;
end;

procedure TXML�������������Type.Set_����������(Value: UnicodeString);
begin
  ChildNodes['����������'].NodeValue := Value;
end;

function TXML�������������Type.Get_�������: UnicodeString;
begin
  Result := ChildNodes['�������'].Text;
end;

procedure TXML�������������Type.Set_�������(Value: UnicodeString);
begin
  ChildNodes['�������'].NodeValue := Value;
end;

function TXML�������������Type.Get_����: UnicodeString;
begin
  Result := ChildNodes['����'].Text;
end;

procedure TXML�������������Type.Set_����(Value: UnicodeString);
begin
  ChildNodes['����'].NodeValue := Value;
end;

{ TXML�����������������Type }

function TXML�����������������Type.Get_����������: UnicodeString;
begin
  Result := ChildNodes['����������'].Text;
end;

procedure TXML�����������������Type.Set_����������(Value: UnicodeString);
begin
  ChildNodes['����������'].NodeValue := Value;
end;

function TXML�����������������Type.Get_���: UnicodeString;
begin
  Result := ChildNodes['���'].Text;
end;

procedure TXML�����������������Type.Set_���(Value: UnicodeString);
begin
  ChildNodes['���'].NodeValue := Value;
end;

function TXML�����������������Type.Get_����: UnicodeString;
begin
  Result := ChildNodes['����'].Text;
end;

procedure TXML�����������������Type.Set_����(Value: UnicodeString);
begin
  ChildNodes['����'].NodeValue := Value;
end;

end.
