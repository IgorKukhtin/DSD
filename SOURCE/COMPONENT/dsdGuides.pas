unit dsdGuides;

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
    procedure SetLookupControl(const Value: TWinControl);
    procedure OpenGuides;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Key: String read GetKey write SetKey;
    property TextValue: String read GetTextValue write SetTextValue;
    property LookupControl: TWinControl read FLookupControl write SetLookupControl;
    property FormName: string read FFormName write FFormName;
  end;

  procedure Register;

implementation

uses cxDBLookupComboBox, cxButtonEdit, Variants;

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

procedure TdsdGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLookupControl) then
     FLookupControl := nil;
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

procedure TdsdGuides.SetLookupControl(const Value: TWinControl);
begin
  FLookupControl := Value;
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


