unit dsdAction;

interface

uses VCL.ActnList, Forms, Classes, dsdDB, DB, DBClient, UtilConst,
  cxControls, dsdGuides, ImgList, cxPC, cxGridTableView,
  cxGridDBTableView, frxClass, cxGridCustomView, Dialogs, Controls,
  dsdDataSetDataLink, ExtCtrls;

type

  TParamMoveItem = class(TCollectionItem)
  private
    FToParam: TdsdParam;
    FFromParam: TdsdParam;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;
  published
    property FromParam: TdsdParam read FFromParam write FFromParam;
    property ToParam: TdsdParam read FToParam write FToParam;
  end;

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
    property Items[Index: Integer]: TdsdStoredProcItem read GetItem
      write SetItem; default;
  end;

  TAddOnDataSet = class(TdsdDataSetLink)
  private
    FIndexFieldNames: String;
    FUserName: String;
    FGridView: TcxGridTableView;
    procedure SetGridView(const Value: TcxGridTableView);
  protected
    procedure SetDataSet(const Value: TDataSet); override;
  published
    property UserName: String read FUserName write FUserName;
    property IndexFieldNames: String read FIndexFieldNames
      write FIndexFieldNames;
    property GridView: TcxGridTableView read FGridView write SetGridView;
  end;

  // Вызываем события у формы
  IFormAction = interface
    ['{9647E6F2-B61C-46FC-83E7-F3E1C69B8699}']
    procedure OnFormClose(Params: TdsdParams);
  end;

  TOnPageChanging = procedure(Sender: TObject; NewPage: TcxTabSheet;
    var AllowChange: Boolean) of object;

  // Общий класс нужен для некороторых общих операций. Например учитывать TabSheet
  TdsdCustomAction = class(TCustomAction)
  private
    FOnPageChanging: TOnPageChanging;
    FTabSheet: TcxTabSheet;
    FPostDataSetBeforeExecute: Boolean;
    FInfoAfterExecute: string;
    FQuestionBeforeExecute: string;
    FMoveParams: TCollection;
    FCancelAction: TAction;
    FActiveControl: TWinControl;
    FTimer: TTimer;
    FEnabledTimer: Boolean;
    FTimerInterval: Integer;
    FPostDataSetAfterExecute: Boolean;
    procedure SetTabSheet(const Value: TcxTabSheet); virtual;
    procedure SetEnabledTimer(const Value: Boolean);
    procedure OnTimer(Sender: TObject);
  protected
    property QuestionBeforeExecute: string read FQuestionBeforeExecute
      write FQuestionBeforeExecute;
    property InfoAfterExecute: string read FInfoAfterExecute
      write FInfoAfterExecute;
    // Делаем Post всем датасетам на форме где стоит Action
    procedure PostDataSet;
    procedure OnPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean); virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  published
    // Если свойство установлено, то действие вызывается ТОЛЬКО если фокус на этом контроле
    property ActiveControl: TWinControl read FActiveControl
      write FActiveControl;
    // При установке данного свойства Action будет активирован только если TabSheet активен
    // Установка данного свойства не работает в RunTime. Только в момент дизайна и загрузки
    property TabSheet: TcxTabSheet read FTabSheet write SetTabSheet;
    // задание списка параметров, которые изменяются перед выполнением действия
    property MoveParams: TCollection read FMoveParams write FMoveParams;
    // действие вызывается если результат вызова основного действия false
    property CancelAction: TAction read FCancelAction write FCancelAction;
    property Enabled;
    property PostDataSetBeforeExecute: Boolean read FPostDataSetBeforeExecute
      write FPostDataSetBeforeExecute default true;
    property PostDataSetAfterExecute: Boolean read FPostDataSetAfterExecute
      write FPostDataSetAfterExecute default false;
    property EnabledTimer: Boolean read FEnabledTimer write SetEnabledTimer
      default false;
    property Timer: TTimer read FTimer write FTimer;
  end;

  TdsdCustomDataSetAction = class(TdsdCustomAction, IDataSetAction)
  private
    FStoredProcList: TdsdStoredProcList;
    function GetStoredProc: TdsdStoredProc;
    procedure SetStoredProc(const Value: TdsdStoredProc);
  protected
    procedure DataSetChanged; virtual;
    procedure UpdateData; virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property StoredProc: TdsdStoredProc read GetStoredProc write SetStoredProc;
    property StoredProcList: TdsdStoredProcList read FStoredProcList
      write FStoredProcList;
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
    FView: TcxGridTableView;
    FWithoutNext: Boolean;
    procedure ListExecute;
    procedure DataSourceExecute;
    procedure SaveQuestionBeforeExecute;
    procedure SaveInfoAfterExecute;
    procedure RestoreQuestionBeforeExecute;
    procedure RestoreInfoAfterExecute;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetView(const Value: TcxGridTableView);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ActionList: TOwnedCollection read FActionList write FActionList;
    // Ссылка на элемент отображающий список
    property View: TcxGridTableView read FView write SetView;
    // Ссылка на список данных. Может быть установлен только один источник данных
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
    property WithoutNext: Boolean read FWithoutNext write FWithoutNext
      default false;
  end;

  TdsdDataSetRefresh = class(TdsdCustomDataSetAction)
  private
    FRefreshOnTabSetChanges: Boolean;
    FAfterScrollTimerInterval: Cardinal;
    FDataSet: TDataSet;
    FOriginalAfterScrol: TDataSetNotifyEvent;
    FTimer: TTimer;
    procedure SetAfterScrollTimerInterval(AValue: Cardinal);
    procedure SetDataSet(AValue: TDataSet);
    procedure OnTimerNotifyEvent(Sender: TObject);
    procedure AfterScrollNotifyEvent(DataSet: TDataSet);
  protected
    procedure OnPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RefreshOnTabSetChanges: Boolean read FRefreshOnTabSetChanges
      write FRefreshOnTabSetChanges;
    property AfterScrollTimerInterval: Cardinal Read FAfterScrollTimerInterval
      write SetAfterScrollTimerInterval default 500;
    property DataSet: TDataSet read FDataSet write SetDataSet;
  end;

  // Сохраняет или изменяет значение в справочнике и закрывает форму
  TdsdInsertUpdateGuides = class(TdsdCustomDataSetAction)
  private
    FInsertUpdateAction: TCustomAction;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property InsertUpdateAction: TCustomAction read FInsertUpdateAction
      write FInsertUpdateAction;
  end;

  TdsdExecStoredProc = class(TdsdCustomDataSetAction)
  public
    constructor Create(AOwner: TComponent); override;
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
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  published
    property MasterProcedure: TdsdStoredProc read FMasterProcedure
      write FMasterProcedure;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  TdsdUpdateDataSet = class(TdsdCustomDataSetAction)
  private
    FAlreadyRun: Boolean;
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

  TCustomChangeStatus = class(TdsdCustomDataSetAction)
  private
    FStatus: TdsdMovementStatus;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Status: TdsdMovementStatus read FStatus write FStatus;
  end;

  // Изменяет статус документа
  TChangeGuidesStatus = class(TCustomChangeStatus)
  private
    FGuides: TdsdGuides;
    FOnChange: TNotifyEvent;
    procedure OnChange(Sender: TObject);
    procedure SetGuides(const Value: TdsdGuides);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  published
    property Guides: TdsdGuides read FGuides write SetGuides;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  // Изменяет статус документов в гриде
  TdsdChangeMovementStatus = class(TCustomChangeStatus)
  private
    FActionDataLink: TDataSetDataLink;
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
  protected
    procedure DataSetChanged; override;
    function LocalExecute: Boolean; override;
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
    FisSetErased: Boolean;
    FErasedFieldName: string;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetisSetErased(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    procedure DataSetChanged; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ErasedFieldName: string read FErasedFieldName
      write FErasedFieldName;
    property isSetErased: Boolean read FisSetErased write SetisSetErased
      default true;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  TdsdOpenForm = class(TdsdCustomAction, IFormAction)
  private
    FParams: TdsdParams;
    FFormName: string;
    FisShowModal: Boolean;
    FFormNameParam: TdsdParam;
    procedure SetFormName(const Value: string);
    function GetFormName: string;
  protected
    procedure BeforeExecute(Form: TForm); virtual;
    procedure OnFormClose(Params: TdsdParams); virtual;
    function ShowForm: TForm;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
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
    property isShowModal: Boolean read FisShowModal write FisShowModal;
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
    FParams: TdsdParams;
    FBuferParams: TParams;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure ChangeDSState; virtual; abstract;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property View: TcxGridDBTableView read FView write FView;
    property Action: TCustomAction read FAction write FAction;
    // Если определены, то заполняем оттуда значениями
    property Params: TdsdParams read FParams write FParams;
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
  TdsdInsertUpdateAction = class(TdsdOpenForm, IDataSetAction, IFormAction)
  private
    FActionDataLink: TDataSetDataLink;
    FdsdDataSetRefresh: TdsdCustomAction;
    FActionType: TDataSetAcionType;
    FFieldName: string;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    function GetFieldName: string;
    procedure SetFieldName(const Value: string);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DataSetChanged;
    procedure UpdateData; virtual;
    procedure OnFormClose(Params: TdsdParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ActionType: TDataSetAcionType read FActionType write FActionType
      default acInsert;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataSetRefresh: TdsdCustomAction read FdsdDataSetRefresh
      write FdsdDataSetRefresh;
    property IdFieldName: string read GetFieldName write SetFieldName;
    property PostDataSetBeforeExecute default true;
  end;

  TInsertUpdateChoiceAction = class(TdsdInsertUpdateAction)
  protected
    procedure OnFormClose(Params: TdsdParams); override;
  end;

  TdsdFormClose = class(TdsdCustomAction)
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
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
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DataSetChanged;
    procedure UpdateData;
    function LocalExecute: Boolean; override;
  public
    property ChoiceCaller: IChoiceCaller read FChoiceCaller
      write SetChoiceCaller;
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

type
  TcxExport = (cxegExportToHtml, cxegExportToXml, cxegExportToText,
    cxegExportToExcel, cxegExportToXlsx, cxegExportToDbf);

  TExportGrid = class(TdsdCustomAction)
  private
    FGrid: TcxControl;
    FExportType: TcxExport;
    FDefaultFileName: string;
    FColumnNameDataSet: TDataSet;
    FOpenAfterCreate: Boolean;
    procedure SetGrid(const Value: TcxControl);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ColumnNameDataSet: TDataSet read FColumnNameDataSet
      write FColumnNameDataSet;
    property ExportType: TcxExport read FExportType write FExportType
      default cxegExportToExcel;
    property Grid: TcxControl read FGrid write SetGrid;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property OpenAfterCreate: Boolean read FOpenAfterCreate
      write FOpenAfterCreate default true;
    property DefaultFileName: string read FDefaultFileName
      write FDefaultFileName;
  end;

  TdsdGridToExcel = class(TExportGrid)
  public
    constructor Create(AOwner: TComponent); override;
  end;
  //Генерация / предпросмотр / дизайн распечаток
  TfrxReportExt = Class(TComponent)
    FReport : TfrxReport;
  private
    procedure ClosePreview(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteReport(AReportName: String; ADataSets: TdsdDataSets;
      AParams: TdsdParams; ACopiesCount: Integer = 1; AWithOutPreview:Boolean = False;
      ADesignReport:Boolean = False; AModal:Boolean = False; APreviewWindowMaximized:Boolean = True);
  end;
  // Действие печати
  TdsdPrintAction = class(TdsdCustomDataSetAction)
  private
    FReportName: String;
    FParams: TdsdParams;
    FReportNameParam: TdsdParam;
    FDataSets: TdsdDataSets;
//    FDataSetList: TList;
    FWithOutPreview: Boolean;
    FCopiesCount: Integer;
    FModalPreview: Boolean;
    FPreviewWindowMaximized: Boolean;
    function GetReportName: String;
    procedure SetReportName(const Value: String);
    procedure SetWithOutPreview(const Value: Boolean);

  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Печать без Preview
    property WithOutPreview: Boolean read FWithOutPreview
      write SetWithOutPreview default false;
    // Список датасетов
    property DataSets: TdsdDataSets read FDataSets write FDataSets;
    // Количество копий
    property CopiesCount: Integer read FCopiesCount write FCopiesCount Default 1;
    property Params: TdsdParams read FParams write FParams;
    property ReportName: String read GetReportName write SetReportName;
    // Название отчета
    property ReportNameParam: TdsdParam read FReportNameParam
      write FReportNameParam;
    Property ModalPreview: Boolean read FModalPreview write FModalPreview Default False;
    Property PreviewWindowMaximized: Boolean read FPreviewWindowMaximized write FPreviewWindowMaximized Default True;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  TBooleanStoredProcAction = class(TdsdCustomDataSetAction)
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
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Value: Boolean read FValue write SetValue;
    property HintTrue: String read FHintTrue write SetHintTrue;
    property HintFalse: String read FHintFalse write SetHintFalse;
    property CaptionTrue: String read FCaptionTrue write SetCaptionTrue;
    property CaptionFalse: String read FCaptionFalse write SetCaptionFalse;
    property ImageIndexTrue: TImageIndex read FImageIndexTrue
      write SetImageIndexTrue;
    property ImageIndexFalse: TImageIndex read FImageIndexFalse
      write SetImageIndexFalse;
  end;

  TFileDialogAction = class(TdsdCustomAction)
  private
    FFileOpenDialog: TFileOpenDialog;
    FParam: TdsdParam;
  protected
    function LocalExecute: Boolean; override;
    procedure SetupDialog;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FileOpenDialog: TFileOpenDialog read FFileOpenDialog
      write FFileOpenDialog;
    property Param: TdsdParam read FParam write FParam;
  end;

procedure Register;

implementation

uses Windows, Storage, SysUtils, CommonData, UtilConvert, FormStorage,
  Menus, cxGridExportLink, ShellApi,
  frxDesgn, messages, ParentForm, SimpleGauge, TypInfo,
  cxExportPivotGridLink, cxGrid, cxCustomPivotGrid, StrUtils, Variants,
  frxDBSet, Printers,
  cxGridAddOn, cxTextEdit, cxGridDBDataDefinitions, ExternalSave,
  dxmdaset, dxCore, cxCustomData, cxGridLevel;

procedure Register;
begin
  RegisterActions('DSDLib', [TBooleanStoredProcAction],
    TBooleanStoredProcAction);
  RegisterActions('DSDLib', [TChangeGuidesStatus], TChangeGuidesStatus);
  RegisterActions('DSDLib', [TdsdChangeMovementStatus],
    TdsdChangeMovementStatus);
  RegisterActions('DSDLib', [TdsdChoiceGuides], TdsdChoiceGuides);
  RegisterActions('DSDLib', [TdsdDataSetRefresh], TdsdDataSetRefresh);
  RegisterActions('DSDLib', [TdsdExecStoredProc], TdsdExecStoredProc);
  RegisterActions('DSDLib', [TdsdFormClose], TdsdFormClose);
  RegisterActions('DSDLib', [TdsdGridToExcel], TdsdGridToExcel);
  RegisterActions('DSDLib', [TdsdInsertUpdateAction], TdsdInsertUpdateAction);
  RegisterActions('DSDLib', [TdsdInsertUpdateGuides], TdsdInsertUpdateGuides);
  RegisterActions('DSDLib', [TdsdOpenForm], TdsdOpenForm);
  RegisterActions('DSDLib', [TdsdPrintAction], TdsdPrintAction);
  RegisterActions('DSDLib', [TdsdUpdateErased], TdsdUpdateErased);
  RegisterActions('DSDLib', [TdsdUpdateDataSet], TdsdUpdateDataSet);
  RegisterActions('DSDLib', [TFileDialogAction], TFileDialogAction);
  RegisterActions('DSDLib', [TExportGrid], TExportGrid);
  RegisterActions('DSDLib', [TInsertUpdateChoiceAction],
    TInsertUpdateChoiceAction);
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

function TdsdCustomDataSetAction.LocalExecute: Boolean;
var
  i: Integer;
begin
  result := true;
  for i := 0 to StoredProcList.Count - 1 do
    if Assigned(StoredProcList[i]) then
      if Assigned(StoredProcList[i].StoredProc) then
      begin
        // Если табшит не установлен, но если установлен, то активен
        if (not Assigned(StoredProcList[i].TabSheet)) or
          (Assigned(StoredProcList[i].TabSheet) and
          (StoredProcList[i].TabSheet.PageControl.ActivePage = StoredProcList[i]
          .TabSheet)) then
          StoredProcList[i].StoredProc.Execute
      end;
end;

function TdsdCustomDataSetAction.GetStoredProc: TdsdStoredProc;
begin
  if StoredProcList.Count > 0 then
  begin
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
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and Assigned(StoredProcList) then
  begin
    if AComponent is TdsdStoredProc then
    begin
      for i := 0 to StoredProcList.Count - 1 do
        if StoredProcList[i].StoredProc = AComponent then
          StoredProcList[i].StoredProc := nil;
      if StoredProc = AComponent then
        StoredProc := nil
    end;
    if AComponent is TcxTabSheet then
    begin
      for i := 0 to StoredProcList.Count - 1 do
        if StoredProcList[i].TabSheet = AComponent then
          StoredProcList[i].TabSheet := nil;
    end;
  end;
end;

procedure TdsdCustomDataSetAction.SetStoredProc(const Value: TdsdStoredProc);
begin
  // Если устанавливается или
  if Value <> nil then
  begin
    if StoredProcList.Count > 0 then
      StoredProcList[0].StoredProc := Value
    else
      StoredProcList.Add.StoredProc := Value;
  end
  else
  begin
    // если ставится в NIL
    if StoredProcList.Count > 0 then
      StoredProcList.Delete(0);
  end;
end;

procedure TdsdCustomDataSetAction.UpdateData;
begin

end;

{ TdsdDataSetRefresh }

procedure TdsdDataSetRefresh.AfterScrollNotifyEvent(DataSet: TDataSet);
begin
  if Assigned(FOriginalAfterScrol) then
    FOriginalAfterScrol(DataSet);
  if Assigned(FTimer) then
  Begin
    FTimer.Enabled := False;
    FTimer.Enabled := True;
  End;
end;

constructor TdsdDataSetRefresh.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Перечитать';
  Hint := 'Обновить данные';
  ShortCut := VK_F5;
  AfterScrollTimerInterval := 500;
end;

destructor TdsdDataSetRefresh.Destroy;
begin
  if assigned(FTimer) then
  Begin
    FTimer.Free;
    FTimer:=nil;
  End;
  if Assigned(FDataSet) then
  Begin
    FDataset.AfterScroll := FOriginalAfterScrol;
    FOriginalAfterScrol := Nil;
    FDataset := nil;
  End;
  inherited;
end;

procedure TdsdDataSetRefresh.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and Assigned(FDataSet) then
  begin
    if AComponent is TDataSet then
      if AComponent = FDataSet then
        DataSet := Nil;
  end;
end;

procedure TdsdDataSetRefresh.OnPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  inherited;
  if not(csDesigning in ComponentState) then
    if Enabled and RefreshOnTabSetChanges then
      Execute;
end;

procedure TdsdDataSetRefresh.OnTimerNotifyEvent(Sender: TObject);
begin
//запуск процедур и отключение таймера
  if not Assigned(FTimer) then exit;
  FTimer.Enabled := False;
  if Enabled then
    Execute;
end;

procedure TdsdDataSetRefresh.SetAfterScrollTimerInterval(AValue: Cardinal);
begin
  if AValue < 1 then
    raise Exception.Create('Значение не может быть меньше 1')
  else
  Begin
    FAfterScrollTimerInterval := AValue;
    if Assigned(FTimer) then
      FTimer.Interval := AValue;
  End;
end;

procedure TdsdDataSetRefresh.SetDataSet(AValue: TDataSet);
begin
  if FDataSet = AValue then exit;
  if (AValue <> nil) AND (FTimer = nil) then
  Begin
    FTimer := TTimer.Create(Self);
    FTimer.Enabled := False;
    FTimer.Interval := FAfterScrollTimerInterval;
    FTimer.OnTimer := OnTimerNotifyEvent;
  End;
  if (AValue = nil) AND (FTimer <> nil) then
  Begin
    FTimer.Free;
    FTimer := nil;
  End;
  if AValue <> Nil then
  Begin
    FOriginalAfterScrol := AValue.AfterScroll;
    AValue.AfterScroll := AfterScrollNotifyEvent;
  end
  else
  if (AValue = Nil) AND (FDataSet <> Nil) then
  Begin
    FDataSet.AfterScroll := FOriginalAfterScrol;
    FOriginalAfterScrol := nil;
  End;
  FDataSet := AValue;
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

function TdsdOpenForm.LocalExecute: Boolean;
var
  ModalResult: TModalResult;
begin
  inherited;
  result := true;
  ModalResult := ShowForm.ModalResult;
  if isShowModal then
    result := ModalResult = mrOk;
end;

procedure TdsdOpenForm.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
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
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FormNameParam')
  else
    FFormName := Value;
end;

function TdsdOpenForm.ShowForm: TForm;
begin
  result := TdsdFormStorageFactory.GetStorage.Load(FormName);
  BeforeExecute(result);
  if TParentForm(result).Execute(Self, FParams) then
  begin
    if result.WindowState = wsMinimized then
      result.WindowState := wsNormal;
    if isShowModal then
      result.ShowModal
    else
      result.Show
  end
  else
    result.Free
end;

{ TdsdFormClose }

constructor TdsdFormClose.Create(AOwner: TComponent);
begin
  inherited;
  FPostDataSetBeforeExecute := false;
end;

function TdsdFormClose.LocalExecute: Boolean;
var
  i: Integer;
begin
  result := true;
  // Для начала делаем отмену всем ДатаСетам
  //
  for i := 0 to Owner.ComponentCount - 1 do
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
      Enabled := (ActionType = acInsert) or
        (DataSource.DataSet.RecordCount <> 0)
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

function TdsdInsertUpdateAction.GetFieldName: string;
begin
  if FFieldName = '' then
    result := 'Id'
  else
    result := FFieldName
end;

procedure TdsdInsertUpdateAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
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
        DataSource.DataSet.Locate(IdFieldName, Params.ParamByName('Id')
          .Value, []);
end;

procedure TdsdInsertUpdateAction.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value;
end;

procedure TdsdInsertUpdateAction.SetFieldName(const Value: string);
begin
  FFieldName := Value
end;

procedure TdsdInsertUpdateAction.UpdateData;
begin

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
      else if Assigned(DataSource.DataSet.FindField(ErasedFieldName)) then
        if FisSetErased then
          Enabled := not DataSource.DataSet.FieldByName(ErasedFieldName)
            .AsBoolean
        else
          Enabled := DataSource.DataSet.FieldByName(ErasedFieldName).AsBoolean
end;

destructor TdsdUpdateErased.Destroy;
begin
  FActionDataLink.Free;
  inherited;
end;

function TdsdUpdateErased.LocalExecute: Boolean;
var
  lDataSet: TDataSet;
begin
  result := inherited LocalExecute;
  if result and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
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
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and (AComponent = DataSource) then
    DataSource := nil;
end;

procedure TdsdUpdateErased.SetDataSource(const Value: TDataSource);
begin
  FActionDataLink.DataSource := Value
end;

procedure TdsdUpdateErased.SetisSetErased(const Value: Boolean);
begin
  FisSetErased := Value;
  if csDesigning in ComponentState then
    if FisSetErased then
    begin
      Caption := 'Удалить';
      Hint := 'Удалить данные';
      ShortCut := VK_DELETE
    end
    else
    begin
      Caption := 'Восстановить';
      Hint := 'Восстановить данные';
    end;
end;

{ TdsdStoredProcList }

function TdsdStoredProcList.Add: TdsdStoredProcItem;
begin
  result := TdsdStoredProcItem(inherited Add)
end;

function TdsdStoredProcList.GetItem(Index: Integer): TdsdStoredProcItem;
begin
  result := TdsdStoredProcItem(inherited GetItem(Index))
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

function TdsdChoiceGuides.LocalExecute: Boolean;
begin
  result := true;
  if Assigned(FParams.ParamByName('Key')) and
    Assigned(FParams.ParamByName('TextValue')) then
    FChoiceCaller.AfterChoice(FParams, TForm(Owner))
  else
    raise Exception.Create
      ('Не определены параметры возврата значений при выборе из справочника');
end;

function TdsdChoiceGuides.GetDataSource: TDataSource;
begin
  result := FActionDataLink.DataSource
end;

procedure TdsdChoiceGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) then
  begin
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
var
  Field: TField;
begin
  Field := DataSource.DataSet.FindField('StatusCode');
  Enabled := Assigned(Field) and (DataSource.DataSet.RecordCount > 0) and
    (Field.AsInteger <> (Integer(Status) + 1));
end;

destructor TdsdChangeMovementStatus.Destroy;
begin
  FActionDataLink.Free;
  inherited;
end;

function TdsdChangeMovementStatus.LocalExecute: Boolean;
var
  lDataSet: TDataSet;
  ID: Integer;
  IdField: TField;
begin
  IdField := nil;
  if Assigned(DataSource.DataSet.FindField('Id')) then
    IdField := DataSource.DataSet.FieldByName('Id');
  if Assigned(DataSource.DataSet.FindField('MovementId')) then
    IdField := DataSource.DataSet.FieldByName('MovementId');

  if Assigned(IdField) then
    ID := IdField.AsInteger
  else
    ID := 0;

  result := inherited LocalExecute;

  if result and Assigned(DataSource) and Assigned(DataSource.DataSet) then
    if Assigned(IdField) AND DataSource.DataSet.Locate(IdField.FieldName, ID, [])
    then
    begin
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
  FPostDataSetBeforeExecute := false;
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
var
  i: Integer;
begin
  // Убираем цикл
  if FAlreadyRun then
    exit;
  FAlreadyRun := true;
  try
    // Ничего лучшего не нашел пока. Если ячейка грида находится в редиме редактирования
    // и выполняется Post, то вот тут данных в датасете еще нифига нет!
    // Поэтому надо дернуть грид и уговорить его поставить
    for i := 0 to Owner.ComponentCount - 1 do
      if Owner.Components[i] is TcxGridDBTableView then
        with TcxGridDBTableView(Owner.Components[i]) do
          DataController.UpdateData;
    { }
    Execute;
  finally
    FAlreadyRun := false;
  end;
end;

{ TExportGrid }

constructor TExportGrid.Create(AOwner: TComponent);
begin
  inherited;
  PostDataSetBeforeExecute := true;
  ExportType := cxegExportToExcel;
  FOpenAfterCreate := true
end;

function TExportGrid.LocalExecute: Boolean;
const
  ConstFileName = '#$#$#$';
  cFieldName = 'FieldName';
  cDisplayName = 'DisplayName';
var
  FileName: string;
  i: Integer;
begin
  result := true;
  if not Assigned(FGrid) then
  begin
    ShowMessage('Не установлено свойство Grid');
    exit;
  end;
  if DefaultFileName = '' then
    FileName := ConstFileName
  else
    FileName := DefaultFileName;
  case ExportType of
    cxegExportToHtml:
      FileName := FileName + '.html';
    cxegExportToXml:
      FileName := FileName + '.xml';
    cxegExportToText:
      FileName := FileName + '.txt';
    cxegExportToExcel:
      FileName := FileName + '.xls';
    cxegExportToXlsx:
      FileName := FileName + '.xlsx';
    cxegExportToDbf:
      FileName := FileName + '.dbf';
  end;
  if FGrid is TcxGrid then
  begin
    // грид скрыт и нужен только для выгрузки, то добавим колонки во View
    if not FGrid.Visible then
    begin
      if TcxGrid(FGrid).ViewCount > 0 then
      begin
        if TcxGrid(FGrid).Views[0].DataController is TcxGridDBDataController
        then
        begin
          while TcxGridDBTableView(TcxGrid(FGrid).Views[0]).ColumnCount > 0 do
            TcxGridDBTableView(TcxGrid(FGrid).Views[0]).Columns[0].Free;
          TcxGridDBDataController(TcxGrid(FGrid).Views[0].DataController)
            .CreateAllItems;
          // Вот тут устанавливаем имена колонок и ширину!
          if Assigned(ColumnNameDataSet) then
          begin
            with TcxGridDBTableView(TcxGrid(FGrid).Views[0]) do
              for i := 0 to ColumnCount - 1 do
              begin
                if ColumnNameDataSet.Locate(cFieldName,
                  Columns[i].DataBinding.FieldName, [loCaseInsensitive]) then
                begin
                  Columns[i].Caption := ColumnNameDataSet.FieldByName
                    (cDisplayName).AsString;
                  TcxGridDBColumn(Columns[i]).Width :=
                    ColumnNameDataSet.FieldByName('Width').AsInteger;
                end;
              end;
          end;
        end;
      end;
    end;
    case ExportType of
      cxegExportToHtml:
        ExportGridToHTML(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToXml:
        ExportGridToXML(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToText:
        ExportGridToText(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToExcel:
        ExportGridToExcel(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToXlsx:
        ExportGridToXLSX(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToDbf:
        with TcxGridDBTableView(TcxGrid(FGrid).Views[0])
          .DataController.DataSource do
          with TFileExternalSave.Create(DataSet.FieldDefs, DataSet,
            FileName, true) do
            try
              Execute(FileName);
            finally
              Free
            end;
    end;
  end;
  if FGrid is TcxCustomPivotGrid then
  begin
    case ExportType of
      cxegExportToHtml:
        cxExportPivotGridToHTML(FileName, TcxCustomPivotGrid(FGrid),
          IsCtrlPressed);
      cxegExportToXml:
        cxExportPivotGridToXML(FileName, TcxCustomPivotGrid(FGrid),
          IsCtrlPressed);
      cxegExportToText:
        cxExportPivotGridToText(FileName, TcxCustomPivotGrid(FGrid),
          IsCtrlPressed);
      cxegExportToExcel, cxegExportToXlsx:
        cxExportPivotGridToExcel(FileName, TcxCustomPivotGrid(FGrid),
          IsCtrlPressed);
    end;
  end;
  if OpenAfterCreate then
    ShellExecute(Application.Handle, 'open', PWideChar(FileName), nil, nil,
      SW_SHOWNORMAL);
end;

procedure TExportGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and (AComponent = FGrid) then
    FGrid := nil;
  if (Operation = opRemove) and (AComponent = FColumnNameDataSet) then
    FColumnNameDataSet := nil;
end;

procedure TExportGrid.SetGrid(const Value: TcxControl);
begin
  if not((Value is TcxGrid) or (Value is TcxCustomPivotGrid)) then
  begin
    ShowMessage('Компонент может быть только типа TcxGrid или TcxPivotGrid');
    exit;
  end;
  FGrid := Value;
end;

{ TdsdGridToExcel }

constructor TdsdGridToExcel.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Выгрузка в Excel';
  Hint := 'Выгрузка в Excel';
  ShortCut := TextToShortCut('Ctrl+X');
  ExportType := cxegExportToExcel;
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
  FDataSets := TdsdDataSets.Create(Self, TAddOnDataSet);
  WithOutPreview := false;
  FCopiesCount := 1;
  FModalPreview := false;
  FPreviewWindowMaximized := True;
end;

destructor TdsdPrintAction.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FReportNameParam);
  FreeAndNil(FDataSets);
  inherited;
end;

function TdsdPrintAction.GetReportName: String;
begin
  result := FReportNameParam.AsString;
  if result = '' then
    result := FReportName
end;

function GetDefaultPrinter: string;
var
  ResStr: array [0 .. 255] of Char;
begin
  GetProfileString('Windows', 'device', '', ResStr, 255);
  result := StrPas(ResStr);
end;

function TdsdPrintAction.LocalExecute: Boolean;
var
  lActiveControl: TWinControl;
begin
  // Перед вызовом печати попробуем у формы поменять фокус, что бы вызвалась процеура сохранения
  if Assigned(Owner) then
    if Owner is TForm then
    begin
      lActiveControl := TForm(Owner).ActiveControl;
      TForm(Owner).ActiveControl := nil;
      if (lActiveControl <> Nil) and
        (not(lActiveControl.ClassType = TcxCustomInnerTextEdit)) then
        TForm(Owner).ActiveControl := lActiveControl;
    end;

  inherited;

  result := true;
  With TfrxReportExt.Create(Self) do
    ExecuteReport(Self.ReportName,Self.DataSets,Self.Params,Self.CopiesCount, Self.WithOutPreview,
      ShiftDown, Self.ModalPreview, Self.PreviewWindowMaximized);
end;

procedure TdsdPrintAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and Assigned(Params) then
    for i := 0 to Params.Count - 1 do
      if Params[i].Component = AComponent then
        Params[i].Component := nil;
end;

procedure TdsdPrintAction.SetReportName(const Value: String);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте ReportNameParam')
  else
    FReportName := Value;
end;

procedure TdsdPrintAction.SetWithOutPreview(const Value: Boolean);
begin
  FWithOutPreview := Value;
end;

{ TdsdInsertUpdateGuides }

constructor TdsdInsertUpdateGuides.Create(AOwner: TComponent);
begin
  inherited;
  // Обязательно так, потому как это делается в LocalExecute
  PostDataSetBeforeExecute := false
end;

function TdsdInsertUpdateGuides.LocalExecute: Boolean;
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
  if fsModal in TForm(Owner).FormState then
    TForm(Owner).ModalResult := mrOk
  else
    TForm(Owner).Close;
  TParentForm(Owner).CloseAction(Self);
end;

procedure TdsdInsertUpdateGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
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

function TBooleanStoredProcAction.LocalExecute: Boolean;
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
  if Value then
  begin
    ImageIndex := ImageIndexTrue;
    Caption := CaptionTrue;
    Hint := HintTrue;
  end
  else
  begin
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
  FPostDataSetAfterExecute := false;
  FMoveParams := TCollection.Create(TParamMoveItem);
  FEnabledTimer := false;
end;

destructor TdsdCustomAction.Destroy;
begin
  EnabledTimer := false;
  inherited;
end;

function TdsdCustomAction.Execute: Boolean;
var
  i: Integer;
begin
  result := false;
  if Assigned(ActiveControl) then
    if not ActiveControl.Focused then
      exit;
  if QuestionBeforeExecute <> '' then
    if MessageDlg(QuestionBeforeExecute, mtInformation, mbOKCancel, 0) <> mrOk
    then
      exit;
  if PostDataSetBeforeExecute then
    PostDataSet;
  if Assigned(MoveParams) then
    for i := 0 to MoveParams.Count - 1 do
      TParamMoveItem(MoveParams.Items[i]).ToParam.Value :=
        TParamMoveItem(MoveParams.Items[i]).FromParam.Value;
  result := LocalExecute;
  if PostDataSetAfterExecute then
    PostDataSet;
  if not result then
    if Assigned(CancelAction) then
      CancelAction.Execute;
  if result and (InfoAfterExecute <> '') then
  begin
    Application.ProcessMessages;
    ShowMessage(InfoAfterExecute);
  end;
end;

procedure TdsdCustomAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and (AComponent = TabSheet) then
    TabSheet := nil;
  if (Operation = opRemove) and (AComponent = ActiveControl) then
    ActiveControl := nil;
end;

procedure TdsdCustomAction.OnPageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  if Assigned(FOnPageChanging) then
    FOnPageChanging(Sender, NewPage, AllowChange);
  Enabled := TabSheet = NewPage;
  Visible := Enabled;
end;

procedure TdsdCustomAction.OnTimer(Sender: TObject);
begin
  if csDesigning in Self.ComponentState then
    exit;
  Timer.Enabled := false;
  try
    LocalExecute;
  finally
    Timer.Enabled := true;
  end;
end;

procedure TdsdCustomAction.PostDataSet;
var
  i: Integer;
begin
  if Assigned(Owner) then
    for i := 0 to Owner.ComponentCount - 1 do
      if Owner.Components[i] is TDataSet then
        if TDataSet(Owner.Components[i]).State in dsEditModes then
          TDataSet(Owner.Components[i]).Post;
end;

procedure TdsdCustomAction.SetEnabledTimer(const Value: Boolean);
begin
  if FEnabledTimer <> Value then
  begin
    FEnabledTimer := Value;
    if FEnabledTimer then
    begin
      FTimer := TTimer.Create(Self);
      FTimer.Name := 'Timer';
      FTimer.Interval := 300000;
      FTimer.OnTimer := Self.OnTimer;
      FTimer.OnTimer(Self);
    end
    else
      FreeAndNil(FTimer)
  end;
end;

procedure TdsdCustomAction.SetTabSheet(const Value: TcxTabSheet);
begin
  // Установка данного свойства не работает в RunTime. Только в момент дизайна и загрузки
  if Self.ComponentState = [csFreeNotification] then
    exit;
  FTabSheet := Value;
  if Assigned(FTabSheet) then
  begin
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
    with TdsdStoredProcItem(Source) do
    begin
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
  if FStoredProc <> Value then
  begin
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
  Form.Close;
  if isShowModal then
    Form.ModalResult := mrOk;
end;

{ TDataSetAction }

constructor TDSAction.Create(AOwner: TComponent);
begin
  inherited;
  FPostDataSetBeforeExecute := false;
  FParams := TdsdParams.Create(Self, TdsdParam);
  FBuferParams := TParams.Create(nil);
end;

destructor TDSAction.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FBuferParams);
  inherited;
end;

function TDSAction.LocalExecute: Boolean;
var
  i: Integer;
begin
  result := true;
  if Assigned(FView.Owner) and (FView.Owner is TForm) then
    TForm(FView.Owner).ActiveControl := FView.Control;
  if Assigned(FView) then
    if Assigned(FView.DataController.DataSource) then
      if FView.DataController.DataSource.State in [dsInsert, dsEdit] then
        FView.DataController.DataSource.DataSet.Post;
  FBuferParams.Clear;
  for i := 0 to Params.Count - 1 do
    FBuferParams.CreateParam(Params[i].DataType, Params[i].Name,
      Params[i].ParamType).Value := Params[i].Value;
  inherited;
  ChangeDSState;
  // расставляем значения по датасету
  for i := 0 to FBuferParams.Count - 1 do
    FView.DataController.DataSource.DataSet.FieldByName(FBuferParams[i].Name)
      .Value := FBuferParams[i].Value;

  // Этот кусок кода написан как подарок Костянычу! :-)
  for i := 0 to FView.ColumnCount - 1 do
    if FView.Columns[i].Visible and FView.Columns[i].Editable then
    begin
      FView.Columns[i].Focused := true;
      break;
    end;
  // конец подарка
  if Assigned(FAction) then
    FAction.Execute;
end;

procedure TDSAction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if AComponent = FView then
    FView := nil;
  if AComponent = FAction then
    FAction := nil;
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
    if Assigned(FView.DataController.DataSource) then
    begin
      if FView.DataController.DataSource.State = dsInactive then
        raise Exception.Create('DataSet ' + FView.DataController.DataSource.
          DataSet.Name + ' не открыт. Добавление не возможно');
      if FView.DataController.DataSource.State = dsBrowse then
        FView.DataController.DataSource.DataSet.Insert;
    end;
end;

{ TUpdateRecord }

procedure TUpdateRecord.ChangeDSState;
begin
  if Assigned(FView) then
    if Assigned(FView.DataController.DataSource) then
    begin
      if FView.DataController.DataSource.State = dsInactive then
        raise Exception.Create('DataSet ' + FView.DataController.DataSource.
          DataSet.Name + ' не открыт. Редактирование не возможно');
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

function TChangeGuidesStatus.LocalExecute: Boolean;
var
  OldKey: string;
begin
  if Assigned(FGuides) then
  begin
    OldKey := FGuides.Key;
    FGuides.Key := IntToStr(Integer(Status) + 1);
  end;
  try
    result := inherited LocalExecute;
    if Assigned(FGuides) then
    begin
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
  if csDestroying in ComponentState then
    exit;
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
  if Assigned(FGuides) then
  begin
    FOnChange := FGuides.OnChange;
    FGuides.OnChange := OnChange;
  end;
end;

{ TMultiAction }

constructor TMultiAction.Create(AOwner: TComponent);
begin
  inherited;
  FActionList := TOwnedCollection.Create(Self, TActionItem);
  FWithoutNext := false;
end;

procedure TMultiAction.DataSourceExecute;
var
  i: Integer;
begin
  if Assigned(View) then
  begin
    with TGaugeFactory.GetGauge(Caption, 0,
      View.DataController.FilteredRecordCount) do
    begin
      Start;
      try
        for i := 0 to View.DataController.FilteredRecordCount - 1 do
        begin
          View.DataController.FocusedRecordIndex :=
            View.DataController.FilteredRecordIndex[i];
          ListExecute;
          IncProgress(1);
          Application.ProcessMessages;
        end;
      finally
        Finish;
      end;
    end;
  end
  else
  begin

    if Assigned(DataSource.DataSet) and DataSource.DataSet.Active and
      (DataSource.DataSet.RecordCount > 0) then
    begin
      // DataSource.DataSet.DisableControls;
      try
        DataSource.DataSet.First;
        with TGaugeFactory.GetGauge(Caption, 0,
          DataSource.DataSet.RecordCount) do
          try
            Start;
            while not DataSource.DataSet.Eof do
            begin
              ListExecute;
              IncProgress(1);
              Application.ProcessMessages;
              if not WithoutNext then
                DataSource.DataSet.Next
              else
                DataSource.DataSet.Delete;
            end;
          finally
            Finish;
          end;
      finally
        Application.ProcessMessages;
        // DataSource.DataSet.EnableControls;
      end;
    end;
  end;
end;

destructor TMultiAction.Destroy;
begin
  FreeAndNil(FActionList);
  inherited;
end;

procedure TMultiAction.ListExecute;
var
  i: Integer;
  State: Boolean;
begin
  // Выполняем события друг за другом. Если какое-то не выполнено, то отменяются и остальные
  for i := 0 to ActionList.Count - 1 do
    if Assigned(TActionItem(ActionList.Items[i]).Action) then
    begin
      State := TActionItem(ActionList.Items[i]).Action.Execute;
      if (TActionItem(ActionList.Items[i]).Action is TdsdCustomAction) and
        (not State) then
        exit;
    end;
end;

function TMultiAction.LocalExecute: Boolean;
begin
  if QuestionBeforeExecute <> '' then
    SaveQuestionBeforeExecute;
  if InfoAfterExecute <> '' then
    SaveInfoAfterExecute;
  try
    if Assigned(DataSource) or Assigned(View) then
      DataSourceExecute
    else
      ListExecute;
  finally
    if QuestionBeforeExecute <> '' then
      RestoreQuestionBeforeExecute;
    if InfoAfterExecute <> '' then
      RestoreInfoAfterExecute;
  end;
  result := true
end;

procedure TMultiAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and Assigned(ActionList) then
    if AComponent is TCustomAction then
      for i := 0 to ActionList.Count - 1 do
        if TActionItem(ActionList.Items[i]).Action = AComponent then
          TActionItem(ActionList.Items[i]).Action := nil;
end;

procedure TMultiAction.RestoreInfoAfterExecute;
var
  i: Integer;
begin
  try
    for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) and
        (TActionItem(ActionList.Items[i]).Action is TdsdCustomAction) then
        TdsdCustomAction(TActionItem(ActionList.Items[i]).Action)
          .InfoAfterExecute := FInfoAfterExecuteList.Strings[i];
  finally
    FInfoAfterExecuteList.Free;
  end;
end;

procedure TMultiAction.RestoreQuestionBeforeExecute;
var
  i: Integer;
begin
  try
    for i := 0 to ActionList.Count - 1 do
      if Assigned(TActionItem(ActionList.Items[i]).Action) and
        (TActionItem(ActionList.Items[i]).Action is TdsdCustomAction) then
        TdsdCustomAction(TActionItem(ActionList.Items[i]).Action)
          .QuestionBeforeExecute := FQuestionBeforeExecuteList.Strings[i];
  finally
    FQuestionBeforeExecuteList.Free;
  end;
end;

procedure TMultiAction.SaveInfoAfterExecute;
var
  i: Integer;
begin
  FInfoAfterExecuteList := TStringList.Create;
  for i := 0 to ActionList.Count - 1 do
    if Assigned(TActionItem(ActionList.Items[i]).Action) and
      (TActionItem(ActionList.Items[i]).Action is TdsdCustomAction) then
    begin
      FInfoAfterExecuteList.Add(TdsdCustomAction(TActionItem(ActionList.Items[i]
        ).Action).InfoAfterExecute);
      TdsdCustomAction(TActionItem(ActionList.Items[i]).Action)
        .InfoAfterExecute := '';
    end
    else
      FInfoAfterExecuteList.Add('');
end;

procedure TMultiAction.SaveQuestionBeforeExecute;
var
  i: Integer;
begin
  FQuestionBeforeExecuteList := TStringList.Create;
  for i := 0 to ActionList.Count - 1 do
    if Assigned(TActionItem(ActionList.Items[i]).Action) and
      (TActionItem(ActionList.Items[i]).Action is TdsdCustomAction) then
    begin
      FQuestionBeforeExecuteList.Add
        (TdsdCustomAction(TActionItem(ActionList.Items[i]).Action)
        .QuestionBeforeExecute);
      TdsdCustomAction(TActionItem(ActionList.Items[i]).Action)
        .QuestionBeforeExecute := '';
    end
    else
      FQuestionBeforeExecuteList.Add('');
end;

procedure TMultiAction.SetDataSource(const Value: TDataSource);
begin
  if Assigned(View) and Assigned(Value) then
  begin
    ShowMessage('Установлен View. Нельзя установить DataSource');
    exit;
  end;
  FDataSource := Value;
end;

procedure TMultiAction.SetView(const Value: TcxGridTableView);
begin
  if Assigned(DataSource) and Assigned(Value) then
  begin
    ShowMessage('Установлен DataSource. Нельзя установить View');
    exit;
  end;
  FView := Value;
end;

{ TExecServerStoredProc }

function TExecServerStoredProc.GetXML(StoredProc: TdsdStoredProc): string;
var
  i: Integer;
begin
  result := '';
  with StoredProc do
  begin
    for i := 0 to Params.Count - 1 do
      with Params[i] do
        if ParamType in [ptInput, ptInputOutput] then
          result := result + '<' + Name + '  DataType="' +
            GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" ' +
            '  Value="' + ComponentItem + '" />';
    result := '<xml Session = "" >' + '<' + StoredProcName + ' OutputType = "' +
      GetEnumName(TypeInfo(TOutputType), ord(OutputType)) + '">' + result + '</'
      + StoredProcName + '>' + '</xml>';
  end;

end;

function TExecServerStoredProc.LocalExecute: Boolean;
var
  XML: String;
  i: Integer;
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
  result := true;
end;

procedure TExecServerStoredProc.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and (MasterProcedure = AComponent) then
    MasterProcedure := nil
end;

{ TParamMoveItem }

procedure TParamMoveItem.Assign(Source: TPersistent);
begin

end;

constructor TParamMoveItem.Create(Collection: TCollection);
begin
  inherited;
  FFromParam := TdsdParam.Create(nil);
  FToParam := TdsdParam.Create(nil);
end;

{ TfrxAccessComponent }

{ TdsdExecStoredProc }

constructor TdsdExecStoredProc.Create(AOwner: TComponent);
begin
  inherited;
  PostDataSetBeforeExecute := false
end;

{ TInsertUpdateChoiceAction }

procedure TInsertUpdateChoiceAction.OnFormClose(Params: TdsdParams);
begin
  // Передаем параметры
  Self.GuiParams.AssignParams(Params);
  // потом перечитываем и позиционируемся
  inherited;
end;

{ TAddOnDataSet }

procedure TAddOnDataSet.SetDataSet(const Value: TDataSet);
begin
  if Assigned(GridView) and Assigned(Value) then
  begin
    ShowMessage
      ('Нельзя установить свойство DataSet так как установлено GridView.');
    exit
  end;
  inherited;
end;

procedure TAddOnDataSet.SetGridView(const Value: TcxGridTableView);
begin
  if Assigned(DataSet) and Assigned(Value) then
  begin
    ShowMessage
      ('Нельзя установить свойство GridView так как установлено DataSet.');
    exit
  end;
  FGridView := Value;
end;

{ TFileDialogAction }

constructor TFileDialogAction.Create(AOwner: TComponent);
begin
  inherited;
  SetupDialog;
  FParam := TdsdParam.Create(nil);
end;

destructor TFileDialogAction.Destroy;
begin
  FreeAndNil(FFileOpenDialog);
  FreeAndNil(FParam);
  inherited;
end;

function TFileDialogAction.LocalExecute: Boolean;
begin
  result := false;
  if FFileOpenDialog.Execute then
  begin
    Param.Value := FFileOpenDialog.FileName;
    result := true
  end;
end;

procedure TFileDialogAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if not(csDestroying in ComponentState) and (Operation = opRemove) and
    (AComponent = FFileOpenDialog) then
    SetupDialog;
end;

procedure TFileDialogAction.SetupDialog;
begin
  FFileOpenDialog := TFileOpenDialog.Create(Self);
  FFileOpenDialog.SetSubComponent(true);
  FFileOpenDialog.FreeNotification(Self);
end;

{ TfrxReportExt }

constructor TfrxReportExt.Create(AOwner: TComponent);
begin
  FReport := TFrxReport.Create(nil);
  FReport.OnClosePreview := ClosePreview;
end;

destructor TfrxReportExt.Destroy;
begin
  if Assigned(FReport) then
    FreeAndNil(FReport);
  inherited;
end;

procedure TfrxReportExt.ExecuteReport(AReportName: String; ADataSets: TdsdDataSets;
  AParams: TdsdParams; ACopiesCount: Integer = 1; AWithOutPreview:Boolean = False;
  ADesignReport:Boolean = False; AModal:Boolean = False; APreviewWindowMaximized:Boolean = True);
var
  I: Integer;
  OldFieldIndexList: TStringList;
  DataSetList: TList;
  MemTableList: TList;
  ViewToMemTable: TcxViewToMemTable;
  Stream: TStringStream;
  SortIdx,SI: Integer;
  OldSort, NewSort: String;
  ExpandedStr: String;
  ExpandedIdx: Integer;
begin
  DataSetList := TList.Create;
  MemTableList := TList.Create;
  ViewToMemTable := TcxViewToMemTable.Create;
  Stream := TStringStream.Create;
  OldFieldIndexList := TStringList.Create;
  ExpandedStr := '';
  try //mainTry
    FReport.PreviewOptions.Maximized := APreviewWindowMaximized;
    for i := 0 to ADataSets.Count - 1 do //залить источники данных
    begin
      DataSetList.Add(TfrxDBDataset.Create(nil));
      with TfrxDBDataset(DataSetList[DataSetList.Count - 1]) do
      begin
        UserName := TAddOnDataSet(ADataSets[i]).UserName;
        if Assigned(ADataSets[i].DataSet) then
        begin
          if ADataSets[i].DataSet is TClientDataSet then
          begin
            OldFieldIndexList.Values[ADataSets[i].DataSet.Name] :=
              TClientDataSet(ADataSets[i].DataSet).IndexFieldNames;
            if TAddOnDataSet(ADataSets[i]).IndexFieldNames <> '' then
            begin
              TClientDataSet(ADataSets[i].DataSet).IndexFieldNames :=
                TAddOnDataSet(ADataSets[i]).IndexFieldNames;
            end;
          end;
          DataSet := ADataSets[i].DataSet;
        end;
        if Assigned(TAddOnDataSet(ADataSets[i]).GridView) then
        begin
          TcxGrid(TcxGridLevel(TAddOnDataSet(ADataSets[i]).GridView.Level).Control).BeginUpdate;
          try
            //сохранили состояние разворотов до сортировки
            for ExpandedIdx := 0 to TAddOnDataSet(ADataSets[i]).GridView.ViewData.RowCount - 1 do
              if TAddOnDataSet(ADataSets[i]).GridView.ViewData.Rows[ExpandedIdx].Expanded then
                ExpandedStr := ExpandedStr + INtToStr(ExpandedIdx)+';';
            ExpandedStr := ExpandedStr + '|';

            if TAddOnDataSet(ADataSets[i]).IndexFieldNames <> '' then //если есть сортировка
            begin
              with TAddOnDataSet(ADataSets[i]).GridView do
              begin
                OldSort := '';
                for SortIdx := 0 to PatternGridView.SortedItemCount-1 do             //сохраняем старую сортировку
                Begin
                  if PatternGridView.SortedItems[SortIdx].SortOrder = soAscending then
                    OldSort := OldSort + IntToStr(PatternGridView.SortedItems[SortIdx].Index)+';'
                  else
                  if PatternGridView.SortedItems[SortIdx].SortOrder = soDescending then
                    OldSort := OldSort + IntToStr(1000+PatternGridView.SortedItems[SortIdx].Index)+';';
                End;
                OldFieldIndexList.Values[Name] := OldSort;
                PatternGridView.DataController.ClearSorting(false); //очистили сортировку
                NewSort := TAddOnDataSet(ADataSets[i]).IndexFieldNames;
                if NewSort[Length(NewSort)] <> ';' then
                  NewSort := NewSort + ';';
                while NewSort <> '' do
                Begin
                  for SortIdx := 0 to ColumnCount - 1 do
                    if ((Columns[SortIdx] is TcxGridDBColumn)
                        AND
                        (CompareText(TcxGridDBColumn(Columns[SortIdx]).DataBinding.FieldName,
                                     Copy(NewSort,1,pos(';',NewSort)-1))=0)) then
                    Begin
                      PatternGridView.DataController.ChangeSorting(SortIdx,soAscending);
                      break;
                    End;
                  Delete(NewSort,1,pos(';',NewSort));
                End;
              end;
            end;
            //развернули все строки, что бы ChildTableView загрузил все данные в клоны

            TAddOnDataSet(ADataSets[i]).GridView.ViewData.Expand(True);

            //перегрузили отсортированные данные в dxMemData
            MemTableList.Add(ViewToMemTable.LoadData(TAddOnDataSet(ADataSets[i]).GridView));

            //вернули сортировку наместо
            if TAddOnDataSet(ADataSets[i]).IndexFieldNames <> '' then
              TAddOnDataSet(ADataSets[i]).GridView.DataController.ClearSorting(false);
            if OldSort <> '' then
            Begin
              while OldSort <> '' do
              Begin
                SI := StrToInt(Copy(OldSort,1,pos(';',OldSort)-1));
                Delete(OldSort,1,pos(';',OldSort));
                if SI >= 1000 then
                  TAddOnDataSet(ADataSets[i]).GridView.PatternGridView.DataController.ChangeSorting(
                    SI-1000,soDescending)
                else
                  TAddOnDataSet(ADataSets[i]).GridView.PatternGridView.DataController.ChangeSorting(
                    SI,soAscending);
              End;
            End;
          finally
            //(TcxGridLevel(TAddOnDataSet(ADataSets[i]).GridView.Level).Control as TcxGrid).EndUpdate;
          end;
          DataSet := MemTableList[MemTableList.Count - 1];
        end;
        if not DataSet.Active then
          raise Exception.Create('Датасет с данными ' + DataSet.Name + ' не открыт');
      end;
    end;

    with FReport do
    Begin
      LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(AReportName));
      for i := 0 to AParams.Count - 1 do
      begin
        case AParams[i].DataType of
          ftString, ftDate, ftDateTime:
            Variables[AParams[i].Name] := chr(39) + AParams[i].AsString + chr(39);
          ftFloat, ftCurrency:
            case VarType(AParams[i].Value) of
              varDouble:
                Variables[AParams[i].Name] := ReplaceStr(FloatToStr(AParams[i].Value), ',', '.');
            else
              Variables[AParams[i].Name] := AParams[i].Value;
            end;
        else
          Variables[AParams[i].Name] := AParams[i].Value
        end;
      end;
      if ADesignReport then  //если режим дизайнера
      begin
        PreviewOptions.modal := AModal;
        DesignReport;
        Stream.Clear;
        FReport.SaveToStream(Stream);
        Stream.Position := 0;
        TdsdFormStorageFactory.GetStorage.SaveReport(Stream, AReportName);
        self.Free;
      end
      else
      begin
        for i := 0 to ADataSets.Count - 1 do
          if Assigned(TAddOnDataSet(ADataSets[i]).GridView) then
            Variables[TAddOnDataSet(ADataSets[i]).UserName +'_Filter'] :=
              TAddOnDataSet(ADataSets[i]).GridView.DataController.Filter.FilterCaption;
        try //Previre
          // Вдруг что!
          PreviewOptions.modal := AModal;
          for I := 0 to DataSetList.Count - 1 do
            TfrxDBDataset(DataSetList[I]).DataSet.DisableControls;
          if AWithOutPreview then
          begin
            PrintOptions.ShowDialog := false;
            PrintOptions.Printer := GetDefaultPrinter;
            PrintOptions.Copies := ACopiesCount;
            PrepareReport;
            Print;
            self.Free;
          end
          else
          begin
            PrepareReport;
            ShowPreparedReport;
          end;
        finally //Previre
          for I := 0 to DataSetList.Count - 1 do
            TfrxDBDataset(DataSetList[I]).DataSet.EnableControls;
        end;
      end;
    end;
  finally //main
    for i := 0 to ADataSets.Count - 1 do
      with TfrxDBDataset(DataSetList[DataSetList.Count - 1]) do
      begin
        if Assigned(ADataSets[i].DataSet) then
        begin
          if ADataSets[i].DataSet is TClientDataSet then
            TClientDataSet(ADataSets[i].DataSet).IndexFieldNames :=
              OldFieldIndexList.Values[ADataSets[i].DataSet.Name];
        end;
      end;
    //********************************************************
    for i := 0 to ADataSets.Count - 1 do //залить источники данных
    begin
      if Assigned(TAddOnDataSet(ADataSets[i]).GridView) then
      begin
        //TcxGrid(TcxGridLevel(TAddOnDataSet(ADataSets[i]).GridView.Level).Control).BeginUpdate;
        //развернули все строки, что бы ChildTableView загрузил все данные в клоны
        TAddOnDataSet(ADataSets[i]).GridView.ViewData.Collapse(True);
        While Copy(ExpandedStr,1,pos('|',ExpandedStr)-1) <> '' do
        Begin
          ExpandedIdx := StrToInt(Copy(ExpandedStr,1,pos(';',ExpandedStr)-1));
          TAddOnDataSet(ADataSets[i]).GridView.ViewData.Rows[ExpandedIdx].Expand(false);
          Delete(ExpandedStr,1,pos(';',ExpandedStr));
        End;
        Delete(ExpandedStr,1,pos('|',ExpandedStr));

        TcxGrid(TcxGridLevel(TAddOnDataSet(ADataSets[i]).GridView.Level).Control).EndUpdate;
      end;
    end;
    //*******************************************************
    for i := 0 to DataSetList.Count - 1 do
      TObject(DataSetList.Items[i]).Free;
    for i := 0 to MemTableList.Count - 1 do
      TObject(MemTableList.Items[i]).Free;

    FreeAndNil(DataSetList);
    FreeAndNil(MemTableList);
    FreeAndNil(ViewToMemTable);
    FreeAndNil(Stream);
    FreeAndNil(OldFieldIndexList);
  end;
end;

procedure TfrxReportExt.ClosePreview(Sender: TObject);
begin
  if Assigned(FReport) AND //ClosePreview повторно вызывается при удалении frxReport
     not Assigned(FReport.Designer) then //Не нужно самоубиваться, если в режиме дизайна
    Self.Destroy;
end;

end.

