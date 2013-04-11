unit dsdGuidesUtilUnit;

interface

uses Classes, Controls;

type

  // Компонент работает со справочниками. Выбирает значение из эжлементов управления или форм
  TdsdGuides = class(TComponent)
  private
    FFormName: string;
    FLookupControl: TWinControl;
    FKey: String;
    function GetKey: String;
    function GetTextValue: String;
    procedure SetKey(const Value: String);
    procedure SetTextValue(const Value: String);
  public
    property Key: String read GetKey write SetKey;
    property TextValue: String read GetTextValue write SetTextValue;
  published
    property LookupControl: TWinControl read FLookupControl write FLookupControl;
    property FormName: string read FFormName write FFormName;
  end;

  procedure Register;

implementation

uses cxDBLookupComboBox, Variants;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdGuides]);
end;

{ TdsdGuides }

function TdsdGuides.GetKey: String;
begin
  FKey := '';
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then
        // Проверим выбран ли элемент
        if VarisNull((LookupControl as TcxLookupComboBox).EditValue) then
           Result := '0'
        else
           Result := (LookupControl as TcxLookupComboBox).EditValue;
  end;
end;

function TdsdGuides.GetTextValue: String;
begin

end;

procedure TdsdGuides.SetKey(const Value: String);
begin
  if Value = '' then
     FKey := '0'
  else
     FKey := Value;
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then
        (LookupControl as TcxLookupComboBox).EditValue := FKey
  end;
end;

procedure TdsdGuides.SetTextValue(const Value: String);
begin
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then
        (LookupControl as TcxLookupComboBox).Text := Value
  end;
end;

initialization
  RegisterClass(TdsdGuides);

end.


