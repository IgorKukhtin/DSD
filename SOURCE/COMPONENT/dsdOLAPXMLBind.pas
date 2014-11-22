{*****************************************}
{                                         }
{            XML Data Binding             }
{                                         }
{*****************************************}

unit dsdOLAPXMLBind;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls   }

  IXMLItemsType = interface;
  IXMLItemType = interface;

{ IXMLItemsType }

  IXMLItemsType = interface(IXMLNodeCollection)
    ['{E4ED994A-F72E-4FF5-846E-34F8F2E76E5E}']
    { Property Accessors }
    function Get_Item(Index: Integer): IXMLItemType;
    function Get_isOLAPonServer: Boolean;
    function Get_isCreateDate: Boolean;
    procedure Set_isOLAPonServer(Value: Boolean);
    procedure Set_isCreateDate(Value: Boolean);
    function Get_SummaryType: Integer;
    procedure Set_SummaryType(Value: Integer);
    { Methods & Properties }
    function Add: IXMLItemType;
    function Insert(const Index: Integer): IXMLItemType;
    property Item[Index: Integer]: IXMLItemType read Get_Item; default;
    property isOLAPonServer: Boolean read Get_isOLAPonServer write Set_isOLAPonServer;
    property isCreateDate: Boolean read Get_isCreateDate write Set_isCreateDate;
    property SummaryType: Integer read Get_SummaryType write Set_SummaryType;
  end;

{ IXMLItemType }

  IXMLItemType = interface(IXMLNode)
    ['{9D48A2C6-4606-4605-9DAC-72E604473CD5}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Visible: Boolean;
    procedure Set_Name(Value: WideString);
    procedure Set_Visible(Value: Boolean);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Visible: Boolean read Get_Visible write Set_Visible;
  end;

{ Forward Decls }

  TXMLItemsType = class;
  TXMLItemType = class;

{ TXMLItemsType }

  TXMLItemsType = class(TXMLNodeCollection, IXMLItemsType)
  protected
    { IXMLItemsType }
    function Get_isOLAPonServer: Boolean;
    function Get_isCreateDate: Boolean;
    function Get_SummaryType: Integer;
    procedure Set_isOLAPonServer(Value: Boolean);
    procedure Set_isCreateDate(Value: Boolean);
    procedure Set_SummaryType(Value: Integer);
    function Get_Item(Index: Integer): IXMLItemType;
    function Add: IXMLItemType;
    function Insert(const Index: Integer): IXMLItemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLItemType }

  TXMLItemType = class(TXMLNode, IXMLItemType)
  protected
    { IXMLItemType }
    function Get_Name: WideString;
    function Get_Visible: Boolean;
    procedure Set_Name(Value: WideString);
    procedure Set_Visible(Value: Boolean);
  end;

{ Global Functions }

function Getitems(Doc: string): IXMLItemsType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Getitems(Doc: string): IXMLItemsType;
begin
  Result := LoadXMLData(Doc).GetDocBinding('items', TXMLItemsType, TargetNamespace) as IXMLItemsType;
end;

{ TXMLItemsType }

procedure TXMLItemsType.AfterConstruction;
begin
  RegisterChildNode('item', TXMLItemType);
  ItemTag := 'item';
  ItemInterface := IXMLItemType;
  inherited;
end;

function TXMLItemsType.Get_Item(Index: Integer): IXMLItemType;
begin
  Result := List[Index] as IXMLItemType;
end;

function TXMLItemsType.Add: IXMLItemType;
begin
  Result := AddItem(-1) as IXMLItemType;
end;

function TXMLItemsType.Insert(const Index: Integer): IXMLItemType;
begin
  Result := AddItem(Index) as IXMLItemType;
end;

function TXMLItemsType.Get_isCreateDate: Boolean;
begin
  try
    Result := AttributeNodes['isCreateDate'].NodeValue;
  except
    Result := false
  end
end;

function TXMLItemsType.Get_isOLAPonServer: Boolean;
begin
  try
    Result := AttributeNodes['isOLAPonServer'].NodeValue;
  except
    Result := false
  end
end;

procedure TXMLItemsType.Set_isCreateDate(Value: Boolean);
begin
  SetAttribute('isCreateDate', Value);
end;

procedure TXMLItemsType.Set_isOLAPonServer(Value: Boolean);
begin
  SetAttribute('isOLAPonServer', Value);
end;

function TXMLItemsType.Get_SummaryType: Integer;
begin
  try
    Result := AttributeNodes['SummaryType'].NodeValue;
  except
    Result := 0
  end
end;

procedure TXMLItemsType.Set_SummaryType(Value: Integer);
begin
  SetAttribute('SummaryType', Value)
end;

{ TXMLItemType }

function TXMLItemType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLItemType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLItemType.Get_Visible: Boolean;
begin
  Result := AttributeNodes['visible'].NodeValue;
end;

procedure TXMLItemType.Set_Visible(Value: Boolean);
begin
  SetAttribute('visible', Value);
end;

end. 