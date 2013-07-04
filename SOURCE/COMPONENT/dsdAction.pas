unit dsdAction;

interface

uses VCL.ActnList, Forms, Classes, ParentForm, dsdDB, DB, DBClient, UtilConst,
     cxGrid, dsdGuides;

type
  TDataSetAcionType = (acInsert, acUpdate);

  TdsdStoredProcItem = class(TCollectionItem)
  private
    FStoredProc: TdsdStoredProc;
  published
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
  end;

  TdsdStoredProcList = class(TCollection)
  private
    function GetItem(Index: Integer): TdsdStoredProcItem;
    procedure SetItem(Index: Integer; const Value: TdsdStoredProcItem);
  public
    function Add: TdsdStoredProcItem;
    property Items[Index: Integer]: TdsdStoredProcItem read GetItem write SetItem; default;
  end;

  // Вызываем события при изменении каких параметров датасета
  IDataSetAction = interface
    procedure DataSetChanged;
    procedure UpdateData;
  end;

  // Вызываем события у формы
  IFormAction = interface
    ['{9647E6F2-B61C-46FC-83E7-F3E1C69B8699}']
    procedure OnFormClose(Params: TdsdParams);
  end;

  TDataSetDataLink = class(TDataLink)
  private
    FAction: IDataSetAction;
  protected
    procedure DataSetChanged; override;
    procedure UpdateData; override;
  public
    constructor Create(Action: IDataSetAction);
  end;

  TdsdCustomDataSetAction = class(TCustomAction, IDataSetAction)
  private
    FStoredProcList: TdsdStoredProcList;
    function GetStoredProc: TdsdStoredProc;
    procedure SetStoredProc(const Value: TdsdStoredProc);
  protected
    procedure DataSetChanged; virtual;
    procedure UpdateData;     virtual;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property StoredProc: TdsdStoredProc read GetStoredProc write SetStoredProc;
    property StoredProcList: TdsdStoredProcList read FStoredProcList write FStoredProcList;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

  TdsdDataSetRefresh = class(TdsdCustomDataSetAction)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TdsdInsertUpdateGuides = class (TdsdCustomDataSetAction)
  private
    FInsertUpdateAction: TCustomAction;
  public
    function Execute: boolean; override;
    property InsertUpdateAction: TCustomAction read FInsertUpdateAction write FInsertUpdateAction;
  end;

  TdsdExecStoredProc = class(TdsdCustomDataSetAction)

  end;

  TdsdUpdateDataSet = class(TdsdCustomDataSetAction)
  private
    FDataSetDataLink: TDataSetDataLink;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
  protected
    procedure UpdateData; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

  TdsdChangeMovementStatus = class (TdsdCustomDataSetAction)
  private
    FStatus: TdsdMovementStatus;
    FActionDataLink: TDataSetDataLink;
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
  protected
    procedure DataSetChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: boolean; override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Status: TdsdMovementStatus read FStatus write FStatus;
  end;

  TdsdUpdateErased = class;

  TdsdUpdateErased = class(TdsdCustomDataSetAction, IDataSetAction)
  private
    FActionDataLink: TDataSetDataLink;
    FisSetErased: boolean;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetisSetErased(const Value: boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure DataSetChanged; override;
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property isSetErased: boolean read FisSetErased write SetisSetErased default true;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

  TdsdOpenForm = class(TCustomAction, IFormAction)
  private
    FParams: TdsdParams;
    FFormName: string;
    FisShowModal: boolean;
  protected
    procedure BeforeExecute(Form: TParentForm); virtual;
    procedure OnFormClose(Params: TdsdParams); virtual;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property FormName: string read FFormName write FFormName;
    property GuiParams: TdsdParams read FParams write FParams;
    property isShowModal: boolean read FisShowModal write FisShowModal;
  end;

  // Данный класс дополняет поведение класса TdsdOpenForm по работе со справочниками
  // К сожалению наследование самое удобное пока
  TdsdInsertUpdateAction = class (TdsdOpenForm, IDataSetAction, IFormAction)
  private
    FActionDataLink: TDataSetDataLink;
    FdsdDataSetRefresh: TdsdDataSetRefresh;
    FForm: TParentForm;
    FActionType: TDataSetAcionType;
    FFormClose: TCloseEvent;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DataSetChanged;
    procedure UpdateData; virtual;
    procedure OnFormClose(Params: TdsdParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ActionType: TDataSetAcionType read FActionType write FActionType default acInsert;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataSetRefresh: TdsdDataSetRefresh read FdsdDataSetRefresh write FdsdDataSetRefresh;
  end;


  TdsdFormClose = class(TCustomAction)
  public
    function Execute: boolean; override;
  end;

  // Действие выбора значения из справочника
  // Заполняет параметры формы указанными параметрами. Параметры заполняются по имени
  // и закрывает форму
  TdsdChoiceGuides = class(TCustomAction)
  private
    FParams: TdsdParams;
    FGuides: TdsdGuides;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
    property Guides: TdsdGuides read FGuides write FGuides;
  published
    property Params: TdsdParams read FParams write FParams;
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
  end;

  TdsdGridToExcel = class (TCustomAction)
  private
    FGrid: TcxGrid;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property Grid: TcxGrid read FGrid write FGrid;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  // Действие печати
  TdsdPrintAction = class(TdsdCustomDataSetAction)
  private
    FReportName: String;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property ReportName: String read FReportName write FReportName;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  procedure Register;

implementation

uses Windows, Storage, SysUtils, CommonData, UtilConvert, FormStorage,
     Vcl.Controls, Menus, cxGridExportLink, ShellApi, frxClass, frxDesgn;

procedure Register;
begin
  RegisterActions('DSDLib', [TdsdChangeMovementStatus], TdsdChangeMovementStatus);
  RegisterActions('DSDLib', [TdsdChoiceGuides],   TdsdChoiceGuides);
  RegisterActions('DSDLib', [TdsdDataSetRefresh], TdsdDataSetRefresh);
  RegisterActions('DSDLib', [TdsdExecStoredProc], TdsdExecStoredProc);
  RegisterActions('DSDLib', [TdsdFormClose],      TdsdFormClose);
  RegisterActions('DSDLib', [TdsdGridToExcel],    TdsdGridToExcel);
  RegisterActions('DSDLib', [TdsdInsertUpdateAction], TdsdInsertUpdateAction);
  RegisterActions('DSDLib', [TdsdInsertUpdateGuides], TdsdInsertUpdateGuides);
  RegisterActions('DSDLib', [TdsdOpenForm],       TdsdOpenForm);
  RegisterActions('DSDLib', [TdsdPrintAction],    TdsdPrintAction);
  RegisterActions('DSDLib', [TdsdUpdateErased], TdsdUpdateErased);
  RegisterActions('DSDLib', [TdsdUpdateDataSet], TdsdUpdateDataSet);
end;

{ TdsdCustomDataSetAction }

constructor TdsdCustomDataSetAction.Create(AOwner: TComponent);
begin
  inherited;
  FStoredProcList := TdsdStoredProcList.Create(TdsdStoredProcItem);
end;

procedure TdsdCustomDataSetAction.DataSetChanged;
begin

end;

function TdsdCustomDataSetAction.Execute: boolean;
var i: integer;
begin
  result := true;
  for I := 0 to StoredProcList.Count - 1  do
      if Assigned(StoredProcList[i]) then
         StoredProcList[i].StoredProc.Execute
end;


function TdsdCustomDataSetAction.GetStoredProc: TdsdStoredProc;
begin
  if StoredProcList.Count > 0 then
     result := StoredProcList[0].StoredProc
  else
     result := nil
end;

procedure TdsdCustomDataSetAction.SetStoredProc(const Value: TdsdStoredProc);
begin
  // Если устанавливается или
  if Value <> nil then begin
     if StoredProcList.Count > 0 then
        StoredProcList[0].StoredProc := Value
     else
        StoredProcList.Add.StoredProc := Value;
  end
  else begin
    //если ставится в NIL
    if StoredProcList.Count > 0 then
       StoredProcList.Delete(0);
  end;
end;

procedure TdsdCustomDataSetAction.UpdateData;
begin

end;

{ TdsdDataSetRefresh }

constructor TdsdDataSetRefresh.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Перечитать';
  Hint:='Обновить данные';
  ShortCut:=VK_F5
end;

{ TdsdOpenForm }

procedure TdsdOpenForm.BeforeExecute;
begin

end;

constructor TdsdOpenForm.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(TdsdParam);
end;

function TdsdOpenForm.Execute: boolean;
var
  Form: TParentForm;
begin
  Form := TdsdFormStorageFactory.GetStorage.Load(FormName);
  BeforeExecute(Form);
  Form.Execute(Self, FParams);
  if isShowModal then
     Form.ShowModal
  else
     Form.Show
end;

procedure TdsdOpenForm.OnFormClose(Params: TdsdParams);
begin

end;

{ TdsdFormClose }

function TdsdFormClose.Execute: boolean;
begin
  if Owner is TForm then
     (Owner as TForm).Close;
end;

{ TdsdInsertUpdateAction }

constructor TdsdInsertUpdateAction.Create(AOwner: TComponent);
begin
  inherited;
  FActionDataLink := TDataSetDataLink.Create(Self);
end;

procedure TdsdInsertUpdateAction.DataSetChanged;
begin
  Enabled := false;
  if Assigned(DataSource) then
     if Assigned(DataSource.DataSet) then
        Enabled := (ActionType = acInsert) or (DataSource.DataSet.RecordCount <> 0)
end;

function TdsdInsertUpdateAction.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdInsertUpdateAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DataSource) then
     DataSource := nil;
end;

procedure TdsdInsertUpdateAction.OnFormClose(Params: TdsdParams);
begin
  inherited;
  // Событие вызывается в момент закрытия формы добавления изменения справочника.
  // Необходимо в таком случае перечитать запрос и отпозиционироваться в нем
  // тут перечитаем запрос и спозиционируемся на нем
  DataSetRefresh.Execute;
  if Assigned(DataSource) then
     if Assigned(DataSource.DataSet) then
        if Assigned(Params) then
           DataSource.DataSet.Locate('Id', Params.ParamByName('Id').Value, []);
end;

procedure TdsdInsertUpdateAction.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value;
end;

procedure TdsdInsertUpdateAction.UpdateData;
begin

end;

{ TActionDataLink }

constructor TDataSetDataLink.Create(Action: IDataSetAction);
begin
  inherited Create;
  FAction := Action;
end;

procedure TDataSetDataLink.DataSetChanged;
begin
  inherited;
  if Assigned(FAction) then
     FAction.DataSetChanged;
end;

procedure TDataSetDataLink.UpdateData;
begin
  inherited;
  if Assigned(FAction) then
     FAction.UpdateData;
end;

{ TdsdUpdateErased }

constructor TdsdUpdateErased.Create(AOwner: TComponent);
begin
  inherited;
  FActionDataLink := TDataSetDataLink.Create(Self);
  isSetErased := true;
end;

procedure TdsdUpdateErased.DataSetChanged;
begin
  Enabled := false;
  if Assigned(DataSource) then
     if Assigned(DataSource.DataSet) then
        if DataSource.DataSet.RecordCount = 0 then
           Enabled := false
        else
           if FisSetErased then
              Enabled := not DataSource.DataSet.FieldByName('isErased').AsBoolean
           else
              Enabled := DataSource.DataSet.FieldByName('isErased').AsBoolean
end;

function TdsdUpdateErased.Execute: boolean;
begin
  result := inherited Execute;
  if result and Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
     DataSource.DataSet.Edit;
     DataSource.DataSet.FieldByName('isErased').AsBoolean := not DataSource.DataSet.FieldByName('isErased').AsBoolean;
     DataSource.DataSet.Post;
  end;
end;

function TdsdUpdateErased.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdUpdateErased.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DataSource) then
     DataSource := nil;
end;

procedure TdsdUpdateErased.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value
end;

procedure TdsdUpdateErased.SetisSetErased(const Value: boolean);
begin
  FisSetErased := Value;
  if FisSetErased then
  begin
    Caption := 'Удалить';
    Hint:='Удалить данные';
    ShortCut:=VK_DELETE
  end
  else
  begin
    Caption := 'Восстановить';
    Hint:='Восстановить данные';
  end;
end;

{ TdsdStoredProcList }

function TdsdStoredProcList.Add: TdsdStoredProcItem;
begin
  result := TdsdStoredProcItem(inherited Add)
end;

function TdsdStoredProcList.GetItem(Index: Integer): TdsdStoredProcItem;
begin
  Result := TdsdStoredProcItem(inherited GetItem(Index))
end;

procedure TdsdStoredProcList.SetItem(Index: Integer;
  const Value: TdsdStoredProcItem);
begin
  inherited SetItem(Index, Value);
end;

{ TdsdChoiceGuides }

constructor TdsdChoiceGuides.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(TdsdParam);
  Caption := 'Выбор из справочника';
  Hint := 'Выбор из справочника';
  ShortCut := VK_RETURN;
end;

function TdsdChoiceGuides.Execute: boolean;
begin
  Guides.AfterChoice(FParams.ParamByName('Key').AsString, FParams.ParamByName('TextValue').AsString);
  TForm(Owner).Close;
end;

procedure TdsdChoiceGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
 // if (Operation = opRemove) and (AComponent = FormParams) then
   //  FormParams := nil;
end;

{ TdsdChangeMovementStatus }

constructor TdsdChangeMovementStatus.Create(AOwner: TComponent);
begin
  inherited;
  FActionDataLink := TDataSetDataLink.Create(Self);
  Status := mtUncomplete;
end;

procedure TdsdChangeMovementStatus.DataSetChanged;
begin
  Enabled := (DataSource.DataSet.RecordCount > 0)
    and (DataSource.DataSet.FieldByName('StatusCode').AsInteger <> (Integer(Status) + 1));
end;

function TdsdChangeMovementStatus.Execute: boolean;
begin
  result := inherited Execute;
  if result and Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
     DataSource.DataSet.Edit;
     DataSource.DataSet.FieldByName('StatusCode').AsInteger := Integer(Status) + 1;
     DataSource.DataSet.Post;
  end;
end;

function TdsdChangeMovementStatus.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource;
end;

procedure TdsdChangeMovementStatus.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value;
end;

{ TdsdUpdateDataSet }

constructor TdsdUpdateDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FDataSetDataLink := TDataSetDataLink.Create(Self);
end;

function TdsdUpdateDataSet.GetDataSource: TDataSource;
begin
  result := FDataSetDataLink.DataSource;
end;

procedure TdsdUpdateDataSet.SetDataSource(const Value: TDataSource);
begin
  FDataSetDataLink.DataSource := Value;
end;

procedure TdsdUpdateDataSet.UpdateData;
begin
  Execute;
end;

{ TdsdGridToExcel }

constructor TdsdGridToExcel.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Выгрузка в Excel';
  Hint := 'Выгрузка в Excel';
  ShortCut := TextToShortCut('Ctrl+X');
end;

function TdsdGridToExcel.Execute: boolean;
begin
  ExportGridToExcel('#$#$#$.xls', FGrid);
  ShellExecute(Application.Handle, 'open', PWideChar('#$#$#$.xls'), nil, nil, SW_SHOWNORMAL);
end;

procedure TdsdGridToExcel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FGrid) then
     FGrid := nil;
end;

{ TdsdPrintAction }


constructor TdsdPrintAction.Create(AOwner: TComponent);
begin
  inherited;

end;

function TdsdPrintAction.Execute: boolean;
begin
  inherited;
  with TfrxReport.Create(nil) do begin
    LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('Приходная накладная'));
    if ShiftDown then
       DesignReport
    else begin
       PrepareReport;
       ShowReport;
    end;
  end;
end;

{ TdsdInsertUpdateGuides }

function TdsdInsertUpdateGuides.Execute: boolean;
begin
  inherited;
  TForm(Owner).Close;
end;

end.
