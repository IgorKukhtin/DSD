{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}

{************************************************************************}
{                                                                        }
{                            XML Data Binding                            }
{                                                                        }
{         Generated on: 12.04.2025 18:14:58                              }
{       Generated from: D:\Project-Basis\invoice_comdoc006_convert.xml   }
{   Settings stored in: D:\Project-Basis\invoice_comdoc006_convert.xdb   }
{                                                                        }
{************************************************************************}

unit invoice_comdoc_vchasno;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXML�������������������Type = interface;
  IXML���������Type = interface;
  IXML���ϳ������Type = interface;
  IXML�������Type = interface;
  IXML����������Type = interface;
  IXML��������Type = interface;
  IXML���������Type = interface;
  IXML��������Type = interface;
  IXML�������Type = interface;
  IXML�����Type = interface;
  IXML�������������Type = interface;
  IXML�����������������Type = interface;

{ IXML�������������������Type }

  IXML�������������������Type = interface(IXMLNode)
    ['{18F1EEBC-915B-48F9-A198-4CA187C6C7A0}']
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
    ['{B044C344-C5D5-43D4-B641-4BCD62E3FE10}']
    { Property Accessors }
    function Get_��������������: UnicodeString;
    function Get_�������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_���ϳ������: IXML���ϳ������Type;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_�������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    { Methods & Properties }
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property �������������: UnicodeString read Get_������������� write Set_�������������;
    property ���������������: UnicodeString read Get_��������������� write Set_���������������;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ����������������: UnicodeString read Get_���������������� write Set_����������������;
    property ���ϳ������: IXML���ϳ������Type read Get_���ϳ������;
  end;

{ IXML���ϳ������Type }

  IXML���ϳ������Type = interface(IXMLNode)
    ['{2DCEB174-D027-4B39-8F14-AACB53327A38}']
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
    ['{C9C30B26-BB65-4535-9AC8-10DB59B32F53}']
    { Property Accessors }
    function Get_����������(Index: Integer): IXML����������Type;
    { Methods & Properties }
    function Add: IXML����������Type;
    function Insert(const Index: Integer): IXML����������Type;
    property ����������[Index: Integer]: IXML����������Type read Get_����������; default;
  end;

{ IXML����������Type }

  IXML����������Type = interface(IXMLNode)
    ['{9BC77A2D-E415-4AF5-9615-480EAC06238A}']
    { Property Accessors }
    function Get_�����������������: UnicodeString;
    function Get_GLN: UnicodeString;
    function Get_���: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_�������: UnicodeString;
    function Get_��������: IXML��������Type;
    procedure Set_�����������������(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_�������(Value: UnicodeString);
    { Methods & Properties }
    property �����������������: UnicodeString read Get_����������������� write Set_�����������������;
    property GLN: UnicodeString read Get_GLN write Set_GLN;
    property ���: UnicodeString read Get_��� write Set_���;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ����������������: UnicodeString read Get_���������������� write Set_����������������;
    property �������: UnicodeString read Get_������� write Set_�������;
    property ��������: IXML��������Type read Get_��������;
  end;

{ IXML��������Type }

  IXML��������Type = interface(IXMLNode)
    ['{5969F388-88BE-4C5F-8CC7-68205EFFD5F6}']
    { Property Accessors }
    function Get_������: Integer;
    function Get_̳���: UnicodeString;
    function Get_������: UnicodeString;
    procedure Set_������(Value: Integer);
    procedure Set_̳���(Value: UnicodeString);
    procedure Set_������(Value: UnicodeString);
    { Methods & Properties }
    property ������: Integer read Get_������ write Set_������;
    property ̳���: UnicodeString read Get_̳��� write Set_̳���;
    property ������: UnicodeString read Get_������ write Set_������;
  end;

{ IXML���������Type }

  IXML���������Type = interface(IXMLNodeCollection)
    ['{A45AE493-4F64-40E3-BF92-2699FE1BD3B8}']
    { Property Accessors }
    function Get_��������(Index: Integer): IXML��������Type;
    { Methods & Properties }
    function Add: IXML��������Type;
    function Insert(const Index: Integer): IXML��������Type;
    property ��������[Index: Integer]: IXML��������Type read Get_��������; default;
  end;

{ IXML��������Type }

  IXML��������Type = interface(IXMLNode)
    ['{95FDA727-9636-4B75-9DC5-5E77A37271DC}']
    { Property Accessors }
    function Get_�����: UnicodeString;
    procedure Set_�����(Value: UnicodeString);
    { Methods & Properties }
    property �����: UnicodeString read Get_����� write Set_�����;
  end;

{ IXML�������Type }

  IXML�������Type = interface(IXMLNodeCollection)
    ['{D3F8755B-77C0-4B9E-9C69-144545FDB9F3}']
    { Property Accessors }
    function Get_�����(Index: Integer): IXML�����Type;
    { Methods & Properties }
    function Add: IXML�����Type;
    function Insert(const Index: Integer): IXML�����Type;
    property �����[Index: Integer]: IXML�����Type read Get_�����; default;
  end;

{ IXML�����Type }

  IXML�����Type = interface(IXMLNode)
    ['{11B8872A-7572-49A8-BC98-F22C46A9CCE3}']
    { Property Accessors }
    function Get_������: Integer;
    function Get_��������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_������ֳ��: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_ֳ��: UnicodeString;
    function Get_���������: UnicodeString;
    function Get_�������������: IXML�������������Type;
    procedure Set_������(Value: Integer);
    procedure Set_��������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_������ֳ��(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_ֳ��(Value: UnicodeString);
    procedure Set_���������(Value: UnicodeString);
    { Methods & Properties }
    property ������: Integer read Get_������ write Set_������;
    property ��������: UnicodeString read Get_�������� write Set_��������;
    property ��������������: UnicodeString read Get_�������������� write Set_��������������;
    property ���������������: UnicodeString read Get_��������������� write Set_���������������;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ��������ʳ������: UnicodeString read Get_��������ʳ������ write Set_��������ʳ������;
    property ������ֳ��: UnicodeString read Get_������ֳ�� write Set_������ֳ��;
    property ������������: UnicodeString read Get_������������ write Set_������������;
    property ���: UnicodeString read Get_��� write Set_���;
    property ֳ��: UnicodeString read Get_ֳ�� write Set_ֳ��;
    property ���������: UnicodeString read Get_��������� write Set_���������;
    property �������������: IXML�������������Type read Get_�������������;
  end;

{ IXML�������������Type }

  IXML�������������Type = interface(IXMLNode)
    ['{15859B78-4118-428C-8267-D688818DC064}']
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

{ IXML�����������������Type }

  IXML�����������������Type = interface(IXMLNode)
    ['{3D846C35-5869-4913-BF62-BFF8D42AD221}']
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
  TXML��������Type = class;
  TXML���������Type = class;
  TXML��������Type = class;
  TXML�������Type = class;
  TXML�����Type = class;
  TXML�������������Type = class;
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
    function Get_�������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_���ϳ������: IXML���ϳ������Type;
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_�������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
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
    function Get_GLN: UnicodeString;
    function Get_���: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_����������������: UnicodeString;
    function Get_�������: UnicodeString;
    function Get_��������: IXML��������Type;
    procedure Set_�����������������(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_����������������(Value: UnicodeString);
    procedure Set_�������(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXML��������Type }

  TXML��������Type = class(TXMLNode, IXML��������Type)
  protected
    { IXML��������Type }
    function Get_������: Integer;
    function Get_̳���: UnicodeString;
    function Get_������: UnicodeString;
    procedure Set_������(Value: Integer);
    procedure Set_̳���(Value: UnicodeString);
    procedure Set_������(Value: UnicodeString);
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
    function Get_�����: UnicodeString;
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
    function Get_������: Integer;
    function Get_��������: UnicodeString;
    function Get_��������������: UnicodeString;
    function Get_���������������: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_��������ʳ������: UnicodeString;
    function Get_������ֳ��: UnicodeString;
    function Get_������������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_ֳ��: UnicodeString;
    function Get_���������: UnicodeString;
    function Get_�������������: IXML�������������Type;
    procedure Set_������(Value: Integer);
    procedure Set_��������(Value: UnicodeString);
    procedure Set_��������������(Value: UnicodeString);
    procedure Set_���������������(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_��������ʳ������(Value: UnicodeString);
    procedure Set_������ֳ��(Value: UnicodeString);
    procedure Set_������������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_ֳ��(Value: UnicodeString);
    procedure Set_���������(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXML�������������Type }

  TXML�������������Type = class(TXMLNode, IXML�������������Type)
  protected
    { IXML�������������Type }
    function Get_����������: UnicodeString;
    function Get_���: UnicodeString;
    function Get_����: UnicodeString;
    procedure Set_����������(Value: UnicodeString);
    procedure Set_���(Value: UnicodeString);
    procedure Set_����(Value: UnicodeString);
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
function Load�������������������(const FileName: string): IXML�������������������Type;
function New�������������������: IXML�������������������Type;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Get�������������������(Doc: IXMLDocument): IXML�������������������Type;
begin
  Result := Doc.GetDocBinding('�������������������', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
end;

function Load�������������������(const FileName: string): IXML�������������������Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('�������������������', TXML�������������������Type, TargetNamespace) as IXML�������������������Type;
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
  Result := ChildNodes['��������������'].NodeValue;
end;

procedure TXML���������Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
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
  Result := ChildNodes['����������������'].NodeValue;
end;

procedure TXML���������Type.Set_����������������(Value: UnicodeString);
begin
  ChildNodes['����������������'].NodeValue := Value;
end;

function TXML���������Type.Get_���ϳ������: IXML���ϳ������Type;
begin
  Result := ChildNodes['���ϳ������'] as IXML���ϳ������Type;
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
  Result := ChildNodes['����������������'].NodeValue;
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

procedure TXML����������Type.AfterConstruction;
begin
  RegisterChildNode('��������', TXML��������Type);
  inherited;
end;

function TXML����������Type.Get_�����������������: UnicodeString;
begin
  Result := ChildNodes['�����������������'].Text;
end;

procedure TXML����������Type.Set_�����������������(Value: UnicodeString);
begin
  ChildNodes['�����������������'].NodeValue := Value;
end;

function TXML����������Type.Get_GLN: UnicodeString;
begin
  Result := ChildNodes['GLN'].NodeValue;
end;

procedure TXML����������Type.Set_GLN(Value: UnicodeString);
begin
  ChildNodes['GLN'].NodeValue := Value;
end;

function TXML����������Type.Get_���: UnicodeString;
begin
  Result := ChildNodes['���'].NodeValue;
end;

procedure TXML����������Type.Set_���(Value: UnicodeString);
begin
  ChildNodes['���'].NodeValue := Value;
end;

function TXML����������Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].NodeValue;
end;

procedure TXML����������Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML����������Type.Get_����������������: UnicodeString;
begin
  Result := ChildNodes['����������������'].Text;
end;

procedure TXML����������Type.Set_����������������(Value: UnicodeString);
begin
  ChildNodes['����������������'].NodeValue := Value;
end;

function TXML����������Type.Get_�������: UnicodeString;
begin
  Result := ChildNodes['�������'].Text;
end;

procedure TXML����������Type.Set_�������(Value: UnicodeString);
begin
  ChildNodes['�������'].NodeValue := Value;
end;

function TXML����������Type.Get_��������: IXML��������Type;
begin
  Result := ChildNodes['��������'] as IXML��������Type;
end;

{ TXML��������Type }

function TXML��������Type.Get_������: Integer;
begin
  Result := ChildNodes['������'].NodeValue;
end;

procedure TXML��������Type.Set_������(Value: Integer);
begin
  ChildNodes['������'].NodeValue := Value;
end;

function TXML��������Type.Get_̳���: UnicodeString;
begin
  Result := ChildNodes['̳���'].Text;
end;

procedure TXML��������Type.Set_̳���(Value: UnicodeString);
begin
  ChildNodes['̳���'].NodeValue := Value;
end;

function TXML��������Type.Get_������: UnicodeString;
begin
  Result := ChildNodes['������'].Text;
end;

procedure TXML��������Type.Set_������(Value: UnicodeString);
begin
  ChildNodes['������'].NodeValue := Value;
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
  RegisterChildNode('�������������', TXML�������������Type);
  inherited;
end;

function TXML�����Type.Get_������: Integer;
begin
  Result := ChildNodes['������'].NodeValue;
end;

procedure TXML�����Type.Set_������(Value: Integer);
begin
  ChildNodes['������'].NodeValue := Value;
end;

function TXML�����Type.Get_��������: UnicodeString;
begin
  Result := ChildNodes['��������'].NodeValue;
end;

procedure TXML�����Type.Set_��������(Value: UnicodeString);
begin
  ChildNodes['��������'].NodeValue := Value;
end;

function TXML�����Type.Get_��������������: UnicodeString;
begin
  Result := ChildNodes['��������������'].NodeValue;
end;

procedure TXML�����Type.Set_��������������(Value: UnicodeString);
begin
  ChildNodes['��������������'].NodeValue := Value;
end;

function TXML�����Type.Get_���������������: UnicodeString;
begin
  Result := ChildNodes['���������������'].NodeValue;
end;

procedure TXML�����Type.Set_���������������(Value: UnicodeString);
begin
  ChildNodes['���������������'].NodeValue := Value;
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

function TXML�����Type.Get_������ֳ��: UnicodeString;
begin
  Result := ChildNodes['������ֳ��'].Text;
end;

procedure TXML�����Type.Set_������ֳ��(Value: UnicodeString);
begin
  ChildNodes['������ֳ��'].NodeValue := Value;
end;

function TXML�����Type.Get_������������: UnicodeString;
begin
  Result := ChildNodes['������������'].Text;
end;

procedure TXML�����Type.Set_������������(Value: UnicodeString);
begin
  ChildNodes['������������'].NodeValue := Value;
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

function TXML�����Type.Get_���������: UnicodeString;
begin
  Result := ChildNodes['���������'].Text;
end;

procedure TXML�����Type.Set_���������(Value: UnicodeString);
begin
  ChildNodes['���'].NodeValue := Value;
end;

function TXML�����Type.Get_�������������: IXML�������������Type;
begin
  Result := ChildNodes['�������������'] as IXML�������������Type;
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

function TXML�������������Type.Get_���: UnicodeString;
begin
  Result := ChildNodes['���'].Text;
end;

procedure TXML�������������Type.Set_���(Value: UnicodeString);
begin
  ChildNodes['���'].NodeValue := Value;
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