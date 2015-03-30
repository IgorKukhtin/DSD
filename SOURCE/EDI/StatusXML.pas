
{****************************************************************************************}
{                                                                                        }
{                                    XML Data Binding                                    }
{                                                                                        }
{         Generated on: 27.03.2015 16:42:01                                              }
{       Generated from: D:\WORK\DSD\DSD\SOURCE\EDI\status_20150316121019_138395551.xml   }
{   Settings stored in: D:\WORK\DSD\DSD\SOURCE\EDI\status_20150316121019_138395551.xdb   }
{                                                                                        }
{****************************************************************************************}

unit StatusXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLStatusType = interface;

{ IXMLStatusType }

  IXMLStatusType = interface(IXMLNode)
    ['{FECD7351-6D75-4BDA-99A8-B3EDAC38B77A}']
    { Property Accessors }
    function Get_CustomerICID: UnicodeString;
    function Get_From: UnicodeString;
    function Get_To_: UnicodeString;
    function Get_Date: UnicodeString;
    function Get_Status: UnicodeString;
    function Get_DocNumber: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_DateIn: UnicodeString;
    function Get_SizeInBytes: UnicodeString;
    function Get_MessageClass: UnicodeString;
    procedure Set_CustomerICID(Value: UnicodeString);
    procedure Set_From(Value: UnicodeString);
    procedure Set_To_(Value: UnicodeString);
    procedure Set_Date(Value: UnicodeString);
    procedure Set_Status(Value: UnicodeString);
    procedure Set_DocNumber(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_DateIn(Value: UnicodeString);
    procedure Set_SizeInBytes(Value: UnicodeString);
    procedure Set_MessageClass(Value: UnicodeString);
    { Methods & Properties }
    property CustomerICID: UnicodeString read Get_CustomerICID write Set_CustomerICID;
    property From: UnicodeString read Get_From write Set_From;
    property To_: UnicodeString read Get_To_ write Set_To_;
    property Date: UnicodeString read Get_Date write Set_Date;
    property Status: UnicodeString read Get_Status write Set_Status;
    property DocNumber: UnicodeString read Get_DocNumber write Set_DocNumber;
    property Description: UnicodeString read Get_Description write Set_Description;
    property DateIn: UnicodeString read Get_DateIn write Set_DateIn;
    property SizeInBytes: UnicodeString read Get_SizeInBytes write Set_SizeInBytes;
    property MessageClass: UnicodeString read Get_MessageClass write Set_MessageClass;
  end;

{ Forward Decls }

  TXMLStatusType = class;

{ TXMLStatusType }

  TXMLStatusType = class(TXMLNode, IXMLStatusType)
  protected
    { IXMLStatusType }
    function Get_CustomerICID: UnicodeString;
    function Get_From: UnicodeString;
    function Get_To_: UnicodeString;
    function Get_Date: UnicodeString;
    function Get_Status: UnicodeString;
    function Get_DocNumber: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_DateIn: UnicodeString;
    function Get_SizeInBytes: UnicodeString;
    function Get_MessageClass: UnicodeString;
    procedure Set_CustomerICID(Value: UnicodeString);
    procedure Set_From(Value: UnicodeString);
    procedure Set_To_(Value: UnicodeString);
    procedure Set_Date(Value: UnicodeString);
    procedure Set_Status(Value: UnicodeString);
    procedure Set_DocNumber(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_DateIn(Value: UnicodeString);
    procedure Set_SizeInBytes(Value: UnicodeString);
    procedure Set_MessageClass(Value: UnicodeString);
  end;

{ Global Functions }

function GetStatus(Doc: IXMLDocument): IXMLStatusType;
function LoadStatus(const XMLString: string): IXMLStatusType;
function NewStatus: IXMLStatusType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetStatus(Doc: IXMLDocument): IXMLStatusType;
begin
  Result := Doc.GetDocBinding('Status', TXMLStatusType, TargetNamespace) as IXMLStatusType;
end;

function LoadStatus(const XMLString: string): IXMLStatusType;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('Status', TXMLStatusType, TargetNamespace) as IXMLStatusType;
  end;
end;

function NewStatus: IXMLStatusType;
begin
  Result := NewXMLDocument.GetDocBinding('Status', TXMLStatusType, TargetNamespace) as IXMLStatusType;
end;

{ TXMLStatusType }

function TXMLStatusType.Get_CustomerICID: UnicodeString;
begin
  Result := ChildNodes['CustomerICID'].Text;
end;

procedure TXMLStatusType.Set_CustomerICID(Value: UnicodeString);
begin
  ChildNodes['CustomerICID'].NodeValue := Value;
end;

function TXMLStatusType.Get_From: UnicodeString;
begin
  Result := ChildNodes['From'].Text;
end;

procedure TXMLStatusType.Set_From(Value: UnicodeString);
begin
  ChildNodes['From'].NodeValue := Value;
end;

function TXMLStatusType.Get_To_: UnicodeString;
begin
  Result := ChildNodes['To'].Text;
end;

procedure TXMLStatusType.Set_To_(Value: UnicodeString);
begin
  ChildNodes['To'].NodeValue := Value;
end;

function TXMLStatusType.Get_Date: UnicodeString;
begin
  Result := ChildNodes['Date'].Text;
end;

procedure TXMLStatusType.Set_Date(Value: UnicodeString);
begin
  ChildNodes['Date'].NodeValue := Value;
end;

function TXMLStatusType.Get_Status: UnicodeString;
begin
  Result := ChildNodes['Status'].Text;
end;

procedure TXMLStatusType.Set_Status(Value: UnicodeString);
begin
  ChildNodes['Status'].NodeValue := Value;
end;

function TXMLStatusType.Get_DocNumber: UnicodeString;
begin
  Result := ChildNodes['DocNumber'].Text;
end;

procedure TXMLStatusType.Set_DocNumber(Value: UnicodeString);
begin
  ChildNodes['DocNumber'].NodeValue := Value;
end;

function TXMLStatusType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLStatusType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

function TXMLStatusType.Get_DateIn: UnicodeString;
begin
  Result := ChildNodes['DateIn'].Text;
end;

procedure TXMLStatusType.Set_DateIn(Value: UnicodeString);
begin
  ChildNodes['DateIn'].NodeValue := Value;
end;

function TXMLStatusType.Get_SizeInBytes: UnicodeString;
begin
  Result := ChildNodes['SizeInBytes'].Text;
end;

procedure TXMLStatusType.Set_SizeInBytes(Value: UnicodeString);
begin
  ChildNodes['SizeInBytes'].NodeValue := Value;
end;

function TXMLStatusType.Get_MessageClass: UnicodeString;
begin
  Result := ChildNodes['MessageClass'].Text;
end;

procedure TXMLStatusType.Set_MessageClass(Value: UnicodeString);
begin
  ChildNodes['MessageClass'].NodeValue := Value;
end;

end.