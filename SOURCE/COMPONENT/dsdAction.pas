unit dsdAction;

interface

uses VCL.ActnList, Forms, Classes, dsdDB, DB, DBClient, UtilConst,
     {cxGrid, }cxControls, dsdGuides, ImgList, cxPC, cxGridDBTableView;

type
  TDataSetAcionType = (acInsert, acUpdate);

  TdsdStoredProcItem = class(TCollectionItem)
  private
    FStoredProc: TdsdStoredProc;
    FTabSheet: TcxTabSheet;
    procedure SetStoredProc(const Value: TdsdStoredProc);
    procedure SetTabSheet(const Value: TcxTabSheet);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    // При установке данного свойства процедура будет вызвана только если TabSheet активен
    property TabSheet: TcxTabSheet read FTabSheet write SetTabSheet;
    property StoredProc: TdsdStoredProc read FStoredProc write SetStoredProc;
  end;

  TdsdStoredProcList = class(TOwnedCollection)
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

  TOnPageChanging = procedure (Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean) of object;

  // Общий класс нужен для некороторых общих операций. Например учитывать TabSheet
  TdsdCustomAction = class(TCustomAction)
  private
    FOnPageChanging: TOnPageChanging;
    FTabSheet: TcxTabSheet;
    FPostDataSetBeforeExecute: boolean;
    FInfoAfterExecute: string;
    FQuestionBeforeExecute: string;
    procedure SetTabSheet(const Value: TcxTabSheet); virtual;
  protected
    property QuestionBeforeExecute: string read FQuestionBeforeExecute write FQuestionBeforeExecute;
    property InfoAfterExecute: string read FInfoAfterExecute write FInfoAfterExecute;
    property PostDataSetBeforeExecute: boolean read FPostDataSetBeforeExecute write FPostDataSetBeforeExecute;
    // Делаем Post всем датасетам на форме где стоит Action
    procedure PostDataSet;
    procedure OnPageChanging(Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: boolean; override;
  published
    // При установке данного свойства Action будет активирован только если TabSheet активен
    property TabSheet: TcxTabSheet read FTabSheet write SetTabSheet;
  end;

  TDataSetDataLink = class(TDataLink)
  private
    FAction: IDataSetAction;
    // вешаем флаг, потому что UpdateData срабатывает ДВАЖДЫ!!!
    FModified: boolean;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure UpdateData; override;
  public
    constructor Create(Action: IDataSetAction);
  end;

  TdsdCustomDataSetAction = class(TdsdCustomAction, IDataSetAction)
  private
    FStoredProcList: TdsdStoredProcList;
    function GetStoredProc: TdsdStoredProc;
    procedure SetStoredProc(const Value: TdsdStoredProc);
  protected
    procedure DataSetChanged; virtual;
    procedure UpdateData;     virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property StoredProc: TdsdStoredProc read GetStoredProc write SetStoredProc;
    property StoredProcList: TdsdStoredProcList read FStoredProcList write FStoredProcList;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

  // Выполняет несколько Action подряд. В случае установки св-ва DataSource выполняет
  // Актионы для всех записей DataSource
  // В случае, если указаны  QuestionBeforeExecute, InfoAfterExecute то данные вопросы в Action игнорируются

  TMultiAction = class(TdsdCustomAction)
  private
    FActionList: TOwnedCollection;
    FDataSource: TDataSource;
    FQuestionBeforeExecuteList: TStringList;
    FInfoAfterExecuteList: TStringList;
    procedure ListExecute;
    procedure DataSourceExecute;
    procedure SaveQuestionBeforeExecute;
    procedure SaveInfoAfterExecute;
    procedure RestoreQuestionBeforeExecute;
    procedure RestoreInfoAfterExecute;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ActionList: TOwnedCollection read FActionList write FActionList;
    property DataSource: TDataSource read FDataSource write FDataSource;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

  TdsdDataSetRefresh = class(TdsdCustomDataSetAction)
  private
    FRefreshOnTabSetChanges: boolean;
  protected
    procedure OnPageChanging(Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property RefreshOnTabSetChanges: boolean read FRefreshOnTabSetChanges write FRefreshOnTabSetChanges;
  end;

  // Сохраняет или изменяет значение в справочнике и закрывает форму
  TdsdInsertUpdateGuides = class (TdsdCustomDataSetAction)
  private
    FInsertUpdateAction: TCustomAction;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property InsertUpdateAction: TCustomAction read FInsertUpdateAction write FInsertUpdateAction;
  end;

  TdsdExecStoredProc = class(TdsdCustomDataSetAction)
  published
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  // Вызывает процедуры на среднем уровне. Для этого сначала будет вызвана процедура ListProcedure.
  // которая вернет рекордсет параметров. А потом по результатам ее вызова будут вызываться процедуры из StoredProcList
  TExecServerStoredProc = class(TdsdExecStoredProc)
  private
    FMasterProcedure: TdsdStoredProc;
    function GetXML(StoredProc: TdsdStoredProc): string;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  published
    property MasterProcedure: TdsdStoredProc read FMasterProcedure write FMasterProcedure;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  TdsdUpdateDataSet = class(TdsdCustomDataSetAction)
  private
    FAlreadyRun: boolean;
    FDataSetDataLink: TDataSetDataLink;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
  protected
    procedure UpdateData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

  TCustomChangeStatus = class (TdsdCustomDataSetAction)
  private
    FStatus: TdsdMovementStatus;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Status: TdsdMovementStatus read FStatus write FStatus;
  end;

  // Изменяет статус документа
  TChangeGuidesStatus = class (TCustomChangeStatus)
  private
    FGuides: TdsdGuides;
    FOnChange: TNotifyEvent;
    procedure OnChange(Sender: TObject);
    procedure SetGuides(const Value: TdsdGuides);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  published
    property Guides: TdsdGuides read FGuides write SetGuides;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  // Изменяет статус документов в гриде
  TdsdChangeMovementStatus = class (TCustomChangeStatus)
  private
    FActionDataLink: TDataSetDataLink;
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
  protected
    procedure DataSetChanged; override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  TdsdUpdateErased = class(TdsdCustomDataSetAction, IDataSetAction)
  private
    FActionDataLink: TDataSetDataLink;
    FisSetErased: boolean;
    FErasedFieldName: string;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetisSetErased(const Value: boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    procedure DataSetChanged; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ErasedFieldName: string read FErasedFieldName write FErasedFieldName;
    property isSetErased: boolean read FisSetErased write SetisSetErased default true;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  TdsdOpenForm = class(TdsdCustomAction, IFormAction)
  private
    FParams: TdsdParams;
    FFormName: string;
    FisShowModal: boolean;
    FFormNameParam: TdsdParam;
    procedure SetFormName(const Value: string);
    function GetFormName: string;
  protected
    procedure BeforeExecute(Form: TForm); virtual;
    procedure OnFormClose(Params: TdsdParams); virtual;
    function ShowForm: TForm;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property FormName: string read GetFormName write SetFormName;
    property FormNameParam: TdsdParam read FFormNameParam write FFormNameParam;
    property GuiParams: TdsdParams read FParams write FParams;
    property isShowModal: boolean read FisShowModal write FisShowModal;
  end;

  // Откываем форму для выбора значения из справочника
  TOpenChoiceForm = class(TdsdOpenForm, IChoiceCaller)
  private
    // Вызыввем процедуру после выбора элемента из справочника
    procedure SetOwner(Owner: TObject);
    procedure AfterChoice(Params: TdsdParams; Form: TForm);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TDSAction = class(TdsdCustomAction)
  private
    FAction: TCustomAction;
    FView: TcxGridDBTableView;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ChangeDSState; virtual; abstract;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property View: TcxGridDBTableView read FView write FView;
    property Action: TCustomAction read FAction write FAction;
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
  end;

  // Добавляем запись
  TInsertRecord = class(TDSAction)
  protected
    procedure ChangeDSState; override;
  end;

  // Редактируем запись
  TUpdateRecord = class(TDSAction)
  protected
    procedure ChangeDSState; override;
  end;

  // Данный класс дополняет поведение класса TdsdOpenForm по работе со справочниками
  // К сожалению наследование самое удобное пока
  TdsdInsertUpdateAction = class (TdsdOpenForm, IDataSetAction, IFormAction)
  private
    FActionDataLink: TDataSetDataLink;
    FdsdDataSetRefresh: TdsdDataSetRefresh;
    FActionType: TDataSetAcionType;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DataSetChanged;
    procedure UpdateData; virtual;
    procedure OnFormClose(Params: TdsdParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ActionType: TDataSetAcionType read FActionType write FActionType default acInsert;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataSetRefresh: TdsdDataSetRefresh read FdsdDataSetRefresh write FdsdDataSetRefresh;
  end;


  TdsdFormClose = class(TdsdCustomAction)
  protected
    function LocalExecute: boolean; override;
  end;

  // Действие выбора значения из справочника
  // Заполняет параметры формы указанными параметрами. Параметры заполняются по имени
  // и закрывает форму
  TdsdChoiceGuides = class(TdsdCustomAction, IDataSetAction)
  private
    FActionDataLink: TDataSetDataLink;
    FParams: TdsdParams;
    FChoiceCaller: IChoiceCaller;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetChoiceCaller(const Value: IChoiceCaller);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DataSetChanged;
    procedure UpdateData;
    function LocalExecute: boolean; override;
  public
    property ChoiceCaller: IChoiceCaller read FChoiceCaller write SetChoiceCaller;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Params: TdsdParams read FParams write FParams;
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

  TdsdGridToExcel = class (TdsdCustomAction)
  private
    FGrid: TcxControl;
    procedure SetGrid(const Value: TcxControl);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Grid: TcxControl read FGrid write SetGrid;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  // Действие печати
  TdsdPrintAction = class(TdsdCustomDataSetAction)
  private
    FReportName: String;
    FParams: TdsdParams;
    FReportNameParam: TdsdParam;
    function GetReportName: String;
    procedure SetReportName(const Value: String);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Params: TdsdParams read FParams write FParams;
    property ReportName: String read GetReportName write SetReportName;
    property ReportNameParam: TdsdParam read FReportNameParam write FReportNameParam;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  TBooleanStoredProcAction = class (TdsdCustomDataSetAction)
  private
    FImageIndexFalse: TImageIndex;
    FImageIndexTrue: TImageIndex;
    FValue: Boolean;
    FHintFalse: String;
    FHintTrue: String;
    FCaptionFalse: String;
    FCaptionTrue: String;
    procedure SetImageIndexFalse(const Value: TImageIndex);
    procedure SetImageIndexTrue(const Value: TImageIndex);
    procedure SetValue(const Value: Boolean);
    procedure SetCaptionFalse(const Value: String);
    procedure SetCaptionTrue(const Value: String);
    procedure SetHintFalse(const Value: String);
    procedure SetHintTrue(const Value: String);
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Value: Boolean read FValue write SetValue;
    property HintTrue: String read FHintTrue write SetHintTrue;
    property HintFalse: String read FHintFalse write SetHintFalse;
    property CaptionTrue: String read FCaptionTrue write SetCaptionTrue;
    property CaptionFalse: String read FCaptionFalse write SetCaptionFalse;
    property ImageIndexTrue: TImageIndex read FImageIndexTrue write SetImageIndexTrue;
    property ImageIndexFalse: TImageIndex read FImageIndexFalse write SetImageIndexFalse;
  end;

  procedure Register;

implementation

uses Windows, Storage, SysUtils, CommonData, UtilConvert, FormStorage,
     Vcl.Dialogs, Vcl.Controls, Menus, cxGridExportLink, ShellApi,
     frxClass, frxDesgn, messages, ParentForm, SimpleGauge, TypInfo,
     cxExportPivotGridLink, cxGrid, cxCustomPivotGrid;

procedure Register;
begin
  RegisterActions('DSDLib', [TBooleanStoredProcAction], TBooleanStoredProcAction);
  RegisterActions('DSDLib', [TChangeGuidesStatus], TChangeGuidesStatus);
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
  RegisterActions('DSDLib', [TInsertRecord], TInsertRecord);
  RegisterActions('DSDLib', [TMultiAction], TMultiAction);
  RegisterActions('DSDLib', [TOpenChoiceForm], TOpenChoiceForm);
  RegisterActions('DSDLib', [TUpdateRecord], TUpdateRecord);
end;

{ TdsdCustomDataSetAction }

constructor TdsdCustomDataSetAction.Create(AOwner: TComponent);
begin
  inherited;
  FStoredProcList := TdsdStoredProcList.Create(Self, TdsdStoredProcItem);
end;

procedure TdsdCustomDataSetAction.DataSetChanged;
begin

end;

destructor TdsdCustomDataSetAction.Destroy;
begin
  FStoredProcList.Free;
  FStoredProcList := nil;
  inherited;
end;

function TdsdCustomDataSetAction.LocalExecute: boolean;
var i: integer;
begin
  result := true;
  for I := 0 to StoredProcList.Count - 1  do
      if Assigned(StoredProcList[i]) then
         if Assigned(StoredProcList[i].StoredProc) then begin
            // Если табшит не установлен, но если установлен, то активен
            if (not Assigned(StoredProcList[i].TabSheet))
               or (Assigned(StoredProcList[i].TabSheet) and (StoredProcList[i].TabSheet.PageControl.ActivePage = StoredProcList[i].TabSheet)) then
                  StoredProcList[i].StoredProc.Execute
         end;
end;


function TdsdCustomDataSetAction.GetStoredProc: TdsdStoredProc;
begin
  if StoredProcList.Count > 0 then begin
     if Assigned(StoredProcList[0].StoredProc) then
        result := StoredProcList[0].StoredProc
     else
        result := nil
  end
  else
     result := nil
end;

procedure TdsdCustomDataSetAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and Assigned(StoredProcList) then begin
       if AComponent is TdsdStoredProc then begin
           for i := 0 to StoredProcList.Count - 1 do
               if StoredProcList[i].StoredProc = AComponent then
                  StoredProcList[i].StoredProc := nil;
           if StoredProc = AComponent then
              StoredProc := nil
       end;
       if AComponent is TcxTabSheet then begin
           for i := 0 to StoredProcList.Count - 1 do
               if StoredProcList[i].TabSheet = AComponent then
                  StoredProcList[i].TabSheet := nil;
       end;
    end;
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

procedure TdsdDataSetRefresh.OnPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  inherited;
  if not(csDesigning in ComponentState) then
     if Enabled and RefreshOnTabSetChanges then
        Execute;
end;

{ TdsdOpenForm }

procedure TdsdOpenForm.BeforeExecute;
begin

end;

constructor TdsdOpenForm.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(Self, TdsdParam);
  FFormNameParam := TdsdParam.Create(nil);
  FFormNameParam.DataType := ftString;
  FFormNameParam.Value := '';
end;

destructor TdsdOpenForm.Destroy;
begin
  FParams.Free;
  FParams := nil;
  FFormNameParam.Free;
  inherited;
end;

function TdsdOpenForm.GetFormName: string;
begin
  result := FFormNameParam.AsString;
  if result = '' then
     result := FFormName
end;

function TdsdOpenForm.LocalExecute: boolean;
begin
  inherited;
  result := true;
  ShowForm
end;

procedure TdsdOpenForm.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and Assigned(FParams) then
       for i := 0 to GuiParams.Count - 1 do
           if GuiParams[i].Component = AComponent then
              GuiParams[i].Component := nil;
end;

procedure TdsdOpenForm.OnFormClose(Params: TdsdParams);
begin

end;

procedure TdsdOpenForm.SetFormName(const Value: string);
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
     ShowMessage('Используйте FormNameParam')
  else
     FFormName := Value;
end;

function TdsdOpenForm.ShowForm: TForm;
begin
  Result := TdsdFormStorageFactory.GetStorage.Load(FormName);
  BeforeExecute(Result);
  if TParentForm(Result).Execute(Self, FParams) then
    if isShowModal then
       Result.ShowModal
    else
       Result.Show
  else
    Result.Free
end;

{ TdsdFormClose }

function TdsdFormClose.LocalExecute: boolean;
var i: integer;
begin
  result := true;
  // Для начала делаем отмену всем ДатаСетам
  //
  for I := 0 to Owner.ComponentCount - 1 do
     if Owner.Components[i] is TDataSet then
        if TDataSet(Owner.Components[i]).State in dsEditModes then
           TDataSet(Owner.Components[i]).Cancel;

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

destructor TdsdInsertUpdateAction.Destroy;
begin
  FActionDataLink.Free;
  inherited;
end;

function TdsdInsertUpdateAction.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdInsertUpdateAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (AComponent = DataSource) then
       DataSource := nil;
end;

procedure TdsdInsertUpdateAction.OnFormClose(Params: TdsdParams);
begin
  inherited;
  // Событие вызывается в момент закрытия формы добавления изменения справочника.
  // Необходимо в таком случае перечитать запрос и отпозиционироваться в нем
  // тут перечитаем запрос и спозиционируемся на нем
  if Assigned(DataSetRefresh) then
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

procedure TDataSetDataLink.EditingChanged;
begin
  inherited;
  if Assigned(DataSource) and (DataSource.State in [dsEdit, dsInsert]) then
     FModified := true;
end;

procedure TDataSetDataLink.UpdateData;
begin
  inherited;
  if Assigned(FAction) and FModified then
     FAction.UpdateData;
  FModified := false;
end;

{ TdsdUpdateErased }

constructor TdsdUpdateErased.Create(AOwner: TComponent);
begin
  inherited;
  FErasedFieldName := gcisErased;
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
              Enabled := not DataSource.DataSet.FieldByName(ErasedFieldName).AsBoolean
           else
              Enabled := DataSource.DataSet.FieldByName(ErasedFieldName).AsBoolean
end;

destructor TdsdUpdateErased.Destroy;
begin
  FActionDataLink.Free;
  inherited;
end;

function TdsdUpdateErased.LocalExecute: boolean;
var lDataSet: TDataSet;
begin
  result := inherited LocalExecute;
  if result and Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
     lDataSet := DataSource.DataSet;
     // Что бы не вызывались события после на Post
     DataSource.DataSet := nil;
     try
       lDataSet.Edit;
       lDataSet.FieldByName(ErasedFieldName).AsBoolean := isSetErased;
       lDataSet.Post;
     finally
       DataSource.DataSet := lDataSet;
     end;
  end;
end;

function TdsdUpdateErased.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdUpdateErased.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
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
  if csDesigning in ComponentState then
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
  FActionDataLink := TDataSetDataLink.Create(Self);
  FParams := TdsdParams.Create(Self, TdsdParam);
  Caption := 'Выбор из справочника';
  Hint := 'Выбор из справочника';
end;

procedure TdsdChoiceGuides.DataSetChanged;
begin
  Enabled := false;
  // Если инициализирован выбор
  if Assigned(DataSource) and Assigned(FChoiceCaller) then
     if Assigned(DataSource.DataSet) then
        Enabled := (DataSource.DataSet.RecordCount <> 0)
end;

destructor TdsdChoiceGuides.Destroy;
begin
  FActionDataLink.Free;
  FreeAndNil(FParams);
  inherited;
end;

function TdsdChoiceGuides.LocalExecute: boolean;
begin
  result := true;
  if Assigned(FParams.ParamByName('Key')) and Assigned(FParams.ParamByName('TextValue')) then
     FChoiceCaller.AfterChoice(FParams, TForm(Owner))
  else
     raise Exception.Create('Не определены параметры возврата значений при выборе из справочника');
end;

function TdsdChoiceGuides.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdChoiceGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
       if Assigned(Params) then
         for i := 0 to Params.Count - 1 do
             if Params[i].Component = AComponent then
                Params[i].Component := nil;
       if (AComponent = DataSource) then
           DataSource := nil;
    end;
end;

procedure TdsdChoiceGuides.SetChoiceCaller(const Value: IChoiceCaller);
begin
  FChoiceCaller := Value;
end;

procedure TdsdChoiceGuides.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value;
end;

procedure TdsdChoiceGuides.UpdateData;
begin

end;

{ TdsdChangeMovementStatus }

constructor TdsdChangeMovementStatus.Create(AOwner: TComponent);
begin
  inherited;
  FActionDataLink := TDataSetDataLink.Create(Self);
end;

procedure TdsdChangeMovementStatus.DataSetChanged;
var Field: TField;
begin
  Field := DataSource.DataSet.FindField('StatusCode');
  Enabled := Assigned(Field) and (DataSource.DataSet.RecordCount > 0)
    and (Field.AsInteger <> (Integer(Status) + 1));
end;

destructor TdsdChangeMovementStatus.Destroy;
begin
  FActionDataLink.Free;
  inherited;
end;

function TdsdChangeMovementStatus.LocalExecute: boolean;
var lDataSet: TDataSet;
begin
  result := inherited LocalExecute;
  if result and Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
     lDataSet := DataSource.DataSet;
     // Что бы не вызывались события после на Post
     DataSource.DataSet := nil;
     try
       lDataSet.Edit;
       lDataSet.FieldByName('StatusCode').AsInteger := Integer(Status) + 1;
       lDataSet.Post;
     finally
       DataSource.DataSet := lDataSet;
     end;
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
  FAlreadyRun := false;
  FDataSetDataLink := TDataSetDataLink.Create(Self);
end;

destructor TdsdUpdateDataSet.Destroy;
begin
  FDataSetDataLink.Free;
  inherited;
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
var i: integer;
begin
  // Убираем цикл
  if FAlreadyRun then
     exit;
  FAlreadyRun := true;
  try
    // Ничего лучшего не нашел пока. Если ячейка грида находится в редиме редактирования
    // и выполняется Post, то вот тут данных в датасете еще нифига нет!
    // Поэтому надо дернуть грид и уговорить его поставить
    for I := 0 to Owner.ComponentCount - 1 do
        if Owner.Components[i] is TcxGridDBTableView then
           with TcxGridDBTableView(Owner.Components[i]) do
             DataController.UpdateData;
    {}
    Execute;
  finally
    FAlreadyRun := false;
  end;
end;

{ TdsdGridToExcel }

constructor TdsdGridToExcel.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Выгрузка в Excel';
  Hint := 'Выгрузка в Excel';
  ShortCut := TextToShortCut('Ctrl+X');
  PostDataSetBeforeExecute := true
end;

function TdsdGridToExcel.LocalExecute: boolean;
begin
  result := true;
  if not Assigned(FGrid) then begin
     ShowMessage('Не установлено свойство Grid');
     exit;
  end;
  if FGrid is TcxGrid then
     ExportGridToExcel('#$#$#$.xls', TcxGrid(FGrid));
  if FGrid is TcxCustomPivotGrid then
     cxExportPivotGridToExcel('#$#$#$.xls', TcxCustomPivotGrid(FGrid));
  ShellExecute(Application.Handle, 'open', PWideChar('#$#$#$.xls'), nil, nil, SW_SHOWNORMAL);
end;

procedure TdsdGridToExcel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (AComponent = FGrid) then
       FGrid := nil;
end;

procedure TdsdGridToExcel.SetGrid(const Value: TcxControl);
begin
  if not ((Value is TcxGrid) or (Value is TcxCustomPivotGrid)) then begin
     ShowMessage('Компонент может быть только типа TcxGrid или TcxPivotGrid');
     exit;
  end;
  FGrid := Value;
end;

{ TdsdPrintAction }


constructor TdsdPrintAction.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(Self, TdsdParam);
  PostDataSetBeforeExecute := true;
  FReportNameParam := TdsdParam.Create(nil);
  FReportNameParam.DataType := ftString;
  FReportNameParam.Value := '';
end;

destructor TdsdPrintAction.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FReportNameParam);
  inherited;
end;

function TdsdPrintAction.GetReportName: String;
begin
  result := FReportNameParam.AsString;
  if result = '' then
     result := FReportName
end;

function TdsdPrintAction.LocalExecute: boolean;
var i: integer;
    Stream: TStringStream;
begin
  inherited;
  result := true;
  Stream := TStringStream.Create;
  try
    with TfrxReport.Create(nil) do begin
      if ShiftDown then begin
         try
           LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(ReportName));
         except
         end;
         for i := 0 to Params.Count - 1 do
             Variables[Params[i].Name] := chr(39) + Params[i].AsString + chr(39);
         DesignReport;
         Stream.Clear;
         SaveToStream(Stream);
         Stream.Position := 0;
         TdsdFormStorageFactory.GetStorage.SaveReport(Stream, ReportName);
      end
      else begin
         LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(ReportName));
         for i := 0 to Params.Count - 1 do
             Variables[Params[i].Name] := chr(39) + Params[i].AsString + chr(39);
         PrepareReport;
         ShowReport;
      end;
    end;
  finally
    Stream.Free
  end;
end;

procedure TdsdPrintAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and Assigned(Params) then
       for i := 0 to Params.Count - 1 do
           if Params[i].Component = AComponent then
              Params[i].Component := nil;
end;

procedure TdsdPrintAction.SetReportName(const Value: String);
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
     ShowMessage('Используйте ReportNameParam')
  else
     FReportName := Value;
end;

{ TdsdInsertUpdateGuides }

constructor TdsdInsertUpdateGuides.Create(AOwner: TComponent);
begin
  inherited;
  // Обязательно так, потому как это делается в LocalExecute
  PostDataSetBeforeExecute := false
end;

function TdsdInsertUpdateGuides.LocalExecute: boolean;
begin
  // Делаем post всем
  try
    inherited;
    PostDataSet;
  except
    TParentForm(Owner).ModalResult := mrNone;
    raise;
  end;
  result := true;
  TParentForm(Owner).Close(Self);
end;

procedure TdsdInsertUpdateGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (FInsertUpdateAction = AComponent) then
       FInsertUpdateAction := nil
end;

{ TBooleanStoredProcAction }

constructor TBooleanStoredProcAction.Create(AOwner: TComponent);
begin
  inherited;
  FImageIndexTrue := -1;
  FImageIndexFalse := -1;
  FHintFalse := 'Показать все';
  FHintTrue := 'Показать товары в документе';
  FCaptionFalse := 'Показать все';
  FCaptionTrue := 'Показать товары в документе';
  FValue := false;
end;

function TBooleanStoredProcAction.LocalExecute: boolean;
begin
  Value := not Value;
  result := inherited;
end;

procedure TBooleanStoredProcAction.SetCaptionFalse(const Value: String);
begin
  FCaptionFalse := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanStoredProcAction.SetCaptionTrue(const Value: String);
begin
  FCaptionTrue := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanStoredProcAction.SetHintFalse(const Value: String);
begin
  FHintFalse := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanStoredProcAction.SetHintTrue(const Value: String);
begin
  FHintTrue := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanStoredProcAction.SetImageIndexFalse(const Value: TImageIndex);
begin
  FImageIndexFalse := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanStoredProcAction.SetImageIndexTrue(const Value: TImageIndex);
begin
  FImageIndexTrue := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanStoredProcAction.SetValue(const Value: Boolean);
begin
  FValue := Value;
  if Value then begin
     ImageIndex := ImageIndexTrue;
     Caption := CaptionTrue;
     Hint := HintTrue;
  end
  else begin
     ImageIndex := ImageIndexFalse;
     Caption := CaptionFalse;
     Hint := HintFalse;
  end;
end;

{ TdsdCustomAction }

constructor TdsdCustomAction.Create(AOwner: TComponent);
begin
  inherited;
  FPostDataSetBeforeExecute := true;
end;

function TdsdCustomAction.Execute: boolean;
begin
  result := false;
  if QuestionBeforeExecute <> '' then
     if MessageDlg(QuestionBeforeExecute, mtInformation, mbOKCancel, 0) <> mrOk  then
        exit;
  if PostDataSetBeforeExecute then
     PostDataSet;
  result := LocalExecute;
  if InfoAfterExecute <> '' then
     ShowMessage(InfoAfterExecute);
end;

procedure TdsdCustomAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (AComponent = TabSheet) then
       TabSheet := nil;
end;

procedure TdsdCustomAction.OnPageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  if Assigned(FOnPageChanging) then
     FOnPageChanging(Sender, NewPage, AllowChange);
  Enabled := TabSheet = NewPage;
  Visible := Enabled;
end;

procedure TdsdCustomAction.PostDataSet;
var i: integer;
begin
  if Assigned(Owner) then
     for i := 0 to Owner.ComponentCount - 1 do
         if Owner.Components[i] is TDataSet then
            if TDataSet(Owner.Components[i]).State in dsEditModes then
               TDataSet(Owner.Components[i]).Post;
end;

procedure TdsdCustomAction.SetTabSheet(const Value: TcxTabSheet);
begin
  FTabSheet := Value;
  if Assigned(FTabSheet) then begin
     FOnPageChanging := FTabSheet.PageControl.OnPageChanging;
     FTabSheet.PageControl.OnPageChanging := OnPageChanging;
     Enabled := TabSheet = FTabSheet.PageControl.ActivePage;
     Visible := Enabled
  end;
end;

{ TdsdStoredProcItem }

procedure TdsdStoredProcItem.Assign(Source: TPersistent);
begin
  if Source is TdsdStoredProcItem then
     with TdsdStoredProcItem(Source) do begin
          Self.TabSheet := TabSheet;
          Self.StoredProc := StoredProc;
     end
  else
    inherited Assign(Source);
end;

function TdsdStoredProcItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FStoredProc) then
     result := FStoredProc.Name + ' \ ' + FStoredProc.StoredProcName
end;

procedure TdsdStoredProcItem.SetStoredProc(const Value: TdsdStoredProc);
begin
  if FStoredProc <> Value then begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FStoredProc := Value;
  end;
end;

procedure TdsdStoredProcItem.SetTabSheet(const Value: TcxTabSheet);
begin
  FTabSheet := Value;
end;

{ TOpenChoiceForm }

procedure TOpenChoiceForm.AfterChoice(Params: TdsdParams; Form: TForm);
begin
  // Расставляем параметры по местам
  Self.GuiParams.AssignParams(Params);
  Form.Close
end;

{ TDataSetAction }

constructor TDSAction.Create(AOwner: TComponent);
begin
  inherited;
  FPostDataSetBeforeExecute := false;
end;

function TDSAction.LocalExecute: boolean;
var i: integer;
begin
  result := true;
  if Assigned(FView.Owner)
     and (FView.Owner is TForm) then
        TForm(FView.Owner).ActiveControl := FView.Control;
  if Assigned(FView) then
     if Assigned(FView.DataController.DataSource) then
        if FView.DataController.DataSource.State in [dsInsert, dsEdit] then
           FView.DataController.DataSource.DataSet.Post;
  inherited;
  ChangeDSState;
  // Этот кусок кода написан как подарок Костянычу! :-)
  for I := 0 to FView.ColumnCount - 1 do
      if FView.Columns[i].Visible and FView.Columns[i].Editable then begin
         FView.Columns[i].Focused := true;
         break;
      end;
  // конец подарка
  if Assigned(FAction) then
     FAction.Execute;
end;

procedure TDSAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then begin
    if AComponent = FView then
       FView := nil;
    if AComponent = FAction then
       FAction := nil;
  end;
end;

constructor TOpenChoiceForm.Create(AOwner: TComponent);
begin
  inherited;
  FPostDataSetBeforeExecute := false;
end;

procedure TOpenChoiceForm.SetOwner(Owner: TObject);
begin

end;

{ TInsertRecord }

procedure TInsertRecord.ChangeDSState;
begin
  if Assigned(FView) then
     if Assigned(FView.DataController.DataSource) then begin
        if FView.DataController.DataSource.State = dsInactive then
           raise Exception.Create('DataSet ' + FView.DataController.DataSource.DataSet.Name + ' не открыт. Добавление не возможно');
        if FView.DataController.DataSource.State = dsBrowse then
           FView.DataController.DataSource.DataSet.Append;
     end;
end;

{ TUpdateRecord }

procedure TUpdateRecord.ChangeDSState;
begin
  if Assigned(FView) then
     if Assigned(FView.DataController.DataSource) then begin
        if FView.DataController.DataSource.State = dsInactive then
           raise Exception.Create('DataSet ' + FView.DataController.DataSource.DataSet.Name + ' не открыт. Редактирование не возможно');
        if FView.DataController.DataSource.State = dsBrowse then
           FView.DataController.DataSource.DataSet.Edit;
     end;
end;

{ TCustomChangeStatus }

constructor TCustomChangeStatus.Create(AOwner: TComponent);
begin
  inherited;
  Status := mtUncomplete;
  PostDataSetBeforeExecute := true;
end;

{ TChangeGuidesStatus }

function TChangeGuidesStatus.LocalExecute: boolean;
var OldKey: string;
begin
  if Assigned(FGuides) then begin
     OldKey := FGuides.Key;
     FGuides.Key := IntToStr(Integer(Status) + 1);
  end;
  try
    result := inherited LocalExecute;
    if Assigned(FGuides) then begin
       FGuides.Key := IntToStr(Integer(Status) + 1);
       FGuides.TextValue := MovementStatus[Status];
    end;
  except
    FGuides.Key := OldKey;
    raise;
  end;
end;

procedure TChangeGuidesStatus.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (AComponent = FGuides) then
       FGuides := nil;
end;

procedure TChangeGuidesStatus.OnChange(Sender: TObject);
begin
  Enabled := StrToInt(TdsdGuides(Sender).Key) <> (Integer(Status) + 1);
  if Assigned(FOnChange) then
     FOnChange(Sender)
end;

procedure TChangeGuidesStatus.SetGuides(const Value: TdsdGuides);
begin
  FGuides := Value;
  if Assigned(FGuides) then begin
     FOnChange := FGuides.OnChange;
     FGuides.OnChange := OnChange;
  end;
end;

{ TMultiAction }

constructor TMultiAction.Create(AOwner: TComponent);
begin
  inherited;
  FActionList := TOwnedCollection.Create(Self, TActionItem);
end;

procedure TMultiAction.DataSourceExecute;
var B: TBookmark;
begin
  if Assigned(DataSource.DataSet) and DataSource.DataSet.Active and (DataSource.DataSet.RecordCount > 0) then begin
     B := DataSource.DataSet.Bookmark;
     DataSource.DataSet.DisableControls;
     try
       DataSource.DataSet.First;
       with TGaugeFactory.GetGauge(Caption, 0, DataSource.DataSet.RecordCount) do
         try
           while not DataSource.DataSet.Eof do begin
             ListExecute;
             IncProgress(1);
             Application.ProcessMessages;
             DataSource.DataSet.Next;
           end;
         finally
           Free;
         end;
     finally
       DataSource.DataSet.GotoBookmark(B);
       DataSource.DataSet.FreeBookmark(B);
       DataSource.DataSet.EnableControls;
     end;
  end;
end;

procedure TMultiAction.ListExecute;
var i: integer;
begin
  for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) then
         TActionItem(ActionList.Items[i]).Action.Execute;
end;

function TMultiAction.LocalExecute: boolean;
begin
  if QuestionBeforeExecute <> '' then
     SaveQuestionBeforeExecute;
  if InfoAfterExecute <> '' then
     SaveInfoAfterExecute;
  try
    if Assigned(DataSource) then
       DataSourceExecute
    else
       ListExecute;
  finally
    if QuestionBeforeExecute <> '' then
       RestoreQuestionBeforeExecute;
    if InfoAfterExecute <> '' then
       RestoreInfoAfterExecute;
  end;
end;

procedure TMultiAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and Assigned(ActionList) then
       if AComponent is TCustomAction then
           for i := 0 to ActionList.Count - 1 do
               if TActionItem(ActionList.Items[i]).Action = AComponent then
                  TActionItem(ActionList.Items[i]).Action := nil;
end;

procedure TMultiAction.RestoreInfoAfterExecute;
var i: integer;
begin
  try
    for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) then
         TdsdCustomAction(TActionItem(ActionList.Items[i]).Action).InfoAfterExecute := FInfoAfterExecuteList.Strings[i];
  finally
    FInfoAfterExecuteList.Free;
  end;
end;

procedure TMultiAction.RestoreQuestionBeforeExecute;
var i: integer;
begin
  try
    for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) then
         TdsdCustomAction(TActionItem(ActionList.Items[i]).Action).QuestionBeforeExecute := FQuestionBeforeExecuteList.Strings[i];
  finally
    FQuestionBeforeExecuteList.Free;
  end;
end;

procedure TMultiAction.SaveInfoAfterExecute;
var i: integer;
begin
  FInfoAfterExecuteList := TStringList.Create;
  for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) then begin
         FInfoAfterExecuteList.Add(TdsdCustomAction(TActionItem(ActionList.Items[i]).Action).InfoAfterExecute);
         TdsdCustomAction(TActionItem(ActionList.Items[i]).Action).InfoAfterExecute := '';
      end
      else
         FInfoAfterExecuteList.Add('');
end;

procedure TMultiAction.SaveQuestionBeforeExecute;
var i: integer;
begin
  FQuestionBeforeExecuteList := TStringList.Create;
  for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) then begin
         FQuestionBeforeExecuteList.Add(TdsdCustomAction(TActionItem(ActionList.Items[i]).Action).QuestionBeforeExecute);
         TdsdCustomAction(TActionItem(ActionList.Items[i]).Action).QuestionBeforeExecute := '';
      end
      else
         FQuestionBeforeExecuteList.Add('');
end;

{ TExecServerStoredProc }

function TExecServerStoredProc.GetXML(StoredProc: TdsdStoredProc): string;
var
  i: integer;
begin
  Result := '';
  with StoredProc do begin
    for I := 0 to Params.Count - 1 do
        with Params[i] do
          if ParamType in [ptInput, ptInputOutput] then
             Result := Result + '<' + Name +
                   '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                   '  Value="' + ComponentItem + '" />';
    Result :=
             '<xml Session = "" >' +
                  '<' + StoredProcName + ' OutputType = "' + GetEnumName(TypeInfo(TOutputType), ord(OutputType)) + '">' +
                     Result +
                  '</' + StoredProcName + '>' +
             '</xml>';
  end;

end;

function TExecServerStoredProc.LocalExecute: boolean;
var XML: String;
    i: integer;
begin
  // Формируем XML для запуска на сервере
  XML := '<xml>';
    XML := XML + '<master>' + MasterProcedure.GetXML + '</master>';
    XML := XML + '<list>';
      for i := 0 to StoredProcList.Count - 1 do
        if Assigned(StoredProcList[i].StoredProc) then
           XML := XML + GetXML(StoredProcList[i].StoredProc);
    XML := XML + '</list>';
  XML := XML + '</xml>';
  TStorageFactory.GetStorage.ExecuteProc(XML, true);
end;

procedure TExecServerStoredProc.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (MasterProcedure = AComponent) then
       MasterProcedure := nil
end;

end.

