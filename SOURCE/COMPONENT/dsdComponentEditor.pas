unit dsdComponentEditor;

interface

uses Classes, DesignEditors, DesignIntf, dsdAddOn;

type

  // Редактор компонент позволяет отображать только используемые
  TdsdParamComponentProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  // Редактор компонент позволяет отображать только используемые
  TdsdGuidesComponentProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  // Редактор ствойства компонент позволяет отображать
  // возможные значения свойств у компонент TDataSet, TdsdFormParams, TdsdGuides

  TComponentItemTextProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  procedure Register;

implementation

uses dsdDB, TypInfo, Db, dsdGuides, cxTextEdit, cxCurrencyEdit, cxCheckBox,
     cxCalendar, cxButtonEdit, dsdAction, ChoicePeriod;

procedure Register;
begin
   RegisterPropertyEditor(TypeInfo(String), TdsdParam, 'ComponentItem', TComponentItemTextProperty);
   RegisterPropertyEditor(TypeInfo(TComponent), TdsdParam, 'Component', TdsdParamComponentProperty);
   RegisterPropertyEditor(TypeInfo(TComponent), TComponentListItem, 'Component', TdsdParamComponentProperty);
end;


{ TdsdParamComponentProperty }

procedure TdsdParamComponentProperty.GetValues(Proc: TGetStrProc);
begin
  // Отображаем только те компоненты, с которыми умеет работать TdsdParam
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxTextEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxDateEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxCurrencyEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TDataSet)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TdsdFormParams)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TdsdGuides)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TPeriodChoice)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxCheckBox)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TBooleanStoredProcAction)), Proc);
end;

{ TComponentItemTextProperty }

function TComponentItemTextProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paReadOnly];
  with TdsdParam(GetComponent(0)) do
       if Component <> nil then
          if (Component is TDataSet) or (Component is TdsdFormParams)
             or (Component is TdsdGuides) then
             Result := Result + [paValueList] - [paReadOnly];
end;

procedure TComponentItemTextProperty.GetValues(Proc: TGetStrProc);
var i: Integer;
begin
  inherited;
  with TdsdParam(GetComponent(0)) do
       if Component <> nil then begin
          if (Component is TDataSet) then;
          if (Component is TdsdFormParams) then
              with Component as TdsdFormParams do
                for i := 0 to Params.Count - 1 do
                  Proc(Params[i].Name);
          if (Component is TdsdGuides) then
          begin
            Proc('Key');
            Proc('TextValue');
            Proc('ParentId');
          end;
       end
end;


{ TdsdGuidesComponentProperty }

procedure TdsdGuidesComponentProperty.GetValues(Proc: TGetStrProc);
begin
  inherited;
  // Отображаем только те компоненты, с которыми умеет работать TdsdGuides
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxButtonEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxDateEdit)), Proc);
end;

end.
