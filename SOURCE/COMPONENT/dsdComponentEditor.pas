unit dsdComponentEditor;

interface

uses Classes, DesignEditors, DesignIntf, dsdAddOn;

type
  // Выбираем только гриды
  TExcelGridProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

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

  // Редактор компонент позволяет отображать только используемые
  TdsdPropertiesСhangeComponentProperty = class(TComponentProperty)
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

  TDataTypeProperty = class(TEnumProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  procedure Register;

implementation

uses dsdDB, TypInfo, Db, dsdGuides, cxTextEdit, cxMemo, cxCurrencyEdit, cxCheckBox,
     cxCalendar, cxButtonEdit, dsdAction, ChoicePeriod, ParentForm, Document, Defaults,
     cxGrid, cxCustomPivotGrid, cxControls, VCLEditors, EDI, ExternalSave, Medoc, Vcl.ActnList,
     cxGridTableView, cxGridDBTableView, cxDropDownEdit, cxDateNavigator, cxMaskEdit,
     cxDBEdit;

procedure Register;
begin
   RegisterCustomModule(TParentForm, TCustomModule);
   RegisterPropertyEditor(TypeInfo(boolean),    TExecuteDialog,       'isShowModal',   nil);
   RegisterPropertyEditor(TypeInfo(TcxControl), TdsdGridToExcel,      'Grid',          TExcelGridProperty);
   RegisterPropertyEditor(TypeInfo(TComponent), TdsdParam,            'Component',     TdsdParamComponentProperty);
   RegisterPropertyEditor(TypeInfo(TComponent), TComponentListItem,   'Component',     TdsdParamComponentProperty);
   RegisterPropertyEditor(TypeInfo(TFieldType), TdsdParam,            'DataType',      TDataTypeProperty);
   RegisterPropertyEditor(TypeInfo(String),     TdsdParam,            'ComponentItem', TComponentItemTextProperty);

   RegisterPropertyEditor(TypeInfo(TComponent), TdsdPropertiesСhange, 'Component',     TdsdPropertiesСhangeComponentProperty);

   RegisterPropertyEditor(TypeInfo(TShortCut),  TShortCutActionItem,  'ShortCut',      TShortCutProperty);
   RegisterPropertyEditor(TypeInfo(TFieldType), TdsdPairParamsItem,   'DataType',      TDataTypeProperty);
end;


{ TdsdParamComponentProperty }

procedure TdsdParamComponentProperty.GetValues(Proc: TGetStrProc);
begin
  // Отображаем только те компоненты, с которыми умеет работать TdsdParam
  Designer.GetComponentNames(GetTypeData(TypeInfo(TBooleanStoredProcAction)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TChangeStatus)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxCheckBox)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxButtonEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxCurrencyEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxDateEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxTextEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxDBTextEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxMaskEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxMemo)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxComboBox)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TDataSet)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TDefaultKey)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TDocument)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TdsdFormParams)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TdsdGuides)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TCheckListBoxAddOn)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TEDI)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TPeriodChoice)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TADOQueryAction)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TMedocAction)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TExportGrid)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TdsdPropertiesСhange)), Proc);
  // и даже такой. Приходится использовать для кросса
  Designer.GetComponentNames(GetTypeData(TypeInfo(TCrossDBViewAddOn)), Proc);
  // и примерно такой же для Pivot
  Designer.GetComponentNames(GetTypeData(TypeInfo(TPivotAddOn)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TCustomAction)), Proc);
  // для мультиселекта
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxGridDBTableView)), Proc);
  // для мульти заполнения по
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxDateNavigator)), Proc);
end;

{ TComponentItemTextProperty }

function TComponentItemTextProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paReadOnly];
  if Assigned(GetComponent(0)) then
    with TdsdParam(GetComponent(0)) do
         if Component <> nil then
            if (Component is TDataSet) or (Component is TdsdFormParams)
               or (Component is TDocument) or (Component is TdsdGuides)
               or (Component is TDefaultKey) or (Component is TCrossDBViewAddOn)
               or (Component is TCustomAction) or (Component is TcxGridDBTableView) then
               Result := Result + [paValueList] - [paReadOnly];
end;

procedure TComponentItemTextProperty.GetValues(Proc: TGetStrProc);
var i: Integer;
begin
  inherited;
  if Assigned(GetComponent(0)) then
    with TdsdParam(GetComponent(0)) do
         if Component <> nil then begin
            if (Component is TDataSet) then;
            if (Component is TdsdFormParams) then
                with Component as TdsdFormParams do
                  for i := 0 to Params.Count - 1 do
                    Proc(Params[i].Name);
            if (Component is TCustomGuides) then
            begin
              Proc('Key');
              Proc('TextValue');
              Proc('ParentId');
            end;
            if (Component is TDocument) then
            begin
              Proc('Name');
              Proc('FileName');
              Proc('ExtractFileName');
              Proc('Data');
            end;
            if (Component is TADOQueryAction) then
            begin
              Proc('ConnectionString');
              Proc('QueryText');
            end;
            if (Component is TExportGrid) then
            begin
              Proc('ExportType');
              Proc('DefaultFileName');
            end;
            if (Component is TMedocAction) then
            begin
              Proc('Directory');
            end;
            if (Component is TEDI) then
            begin
              Proc('Directory');
            end;
            if (Component is TDefaultKey) then
            begin
              Proc('Key');
              Proc('JSONKey');
            end;
            if (Component is TShowMessageAction) then
            Begin
              Proc('MessageText');
            End;
            if (Component is TCustomAction) then
            Begin
              Proc('Enabled');
            End;
            if (Component is TCheckListBoxAddOn) then
            begin
              Proc('KeyList');
            end;
            if (Component is TcxGridDBTableView) then
            begin
              with Component as TcxGridDBTableView do
                for i := 0 to ColumnCount - 1 do
                  Proc(Columns[i].Name);
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

{ TDataTypeProperty }

procedure TDataTypeProperty.GetValues(Proc: TGetStrProc);
begin
 // inherited;
  Proc('ftBoolean');
  Proc('ftDateTime');
  Proc('ftFloat');
  Proc('ftInteger');
  Proc('ftString');
  Proc('ftWideString');
end;

{ TExcelGridProperty }

procedure TExcelGridProperty.GetValues(Proc: TGetStrProc);
begin
  // Отображаем только те компоненты, с которыми умеет работать TdsdGuides
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxGrid)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxCustomPivotGrid)), Proc);
end;

{ TdsdGuidesComponentProperty }

procedure TdsdPropertiesСhangeComponentProperty.GetValues(Proc: TGetStrProc);
begin
  // Отображаем только те компоненты, с которыми умеет работать TdsdGuides
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxCurrencyEdit)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TcxTextEdit)), Proc);
end;


end.
