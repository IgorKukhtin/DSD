unit dsdAction;

{$I ..\dsdVer.inc}

interface

uses VCL.ActnList, VCL.Forms, Classes, dsdDB, DB, DBClient, UtilConst, ComObj, Clipbrd,
  cxControls, dsdGuides, ImgList, cxPC, cxGrid, cxGridTableView, cxDBPivotGrid, Math,
  cxGridDBTableView, frxClass, frxExportPDF, frxExportXLS, cxGridCustomView, Dialogs, Controls,
  dsdDataSetDataLink, ExtCtrls, GMMap, GMMapVCL, cxDateNavigator, IdFTP, IdFTPCommon,
  System.IOUtils, IdHTTP, IdSSLOpenSSL, IdURI, IdAuthentication, {IdMultipartFormData,}
  Winapi.ActiveX, ZConnection, ZDataset, dxBar, DateUtils, dsdCommon
  {$IFDEF DELPHI103RIO}, System.JSON, Actions {$ELSE} , Data.DBXJSON {$ENDIF}, Vcl.Graphics;

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
  TMapAcionType = (acShowOne, acShowAll);

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
    FPivotGrid: TcxDBPivotGrid;
    procedure SetGridView(const Value: TcxGridTableView);
    procedure SetPivotGrid(const Value: TcxDBPivotGrid);
  protected
    procedure SetDataSet(const Value: TDataSet); override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property UserName: String read FUserName write FUserName;
    property IndexFieldNames: String read FIndexFieldNames
      write FIndexFieldNames;
    property GridView: TcxGridTableView read FGridView write SetGridView;
    property PivotGrid: TcxDBPivotGrid read FPivotGrid write SetPivotGrid;
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
    fExecPack:Boolean; //12.07.2016 - Передали параметр в StoredProc, нужен для otMultiExecute
    FOnPageChanging: TOnPageChanging;
    FTabSheet: TcxTabSheet;
    FPostDataSetBeforeExecute: Boolean;
    FInfoAfterExecute: string;
    FQuestionBeforeExecute: string;
    FMoveParams: TCollection;
    FCancelAction: TCustomAction;
    FActiveControl: TWinControl;
    FTimer: TTimer;
    FEnabledTimer: Boolean;
    FPostDataSetAfterExecute: Boolean;
    FAfterAction: TCustomAction;
    FBeforeAction: TCustomAction;
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
    property CancelAction: TCustomAction read FCancelAction write FCancelAction;
    // действие вызывается если результат вызова основного действия true
    property AfterAction: TCustomAction read FAfterAction write FAfterAction;
    // действие вызывается вызываеться перед выполнение основного действия
    property BeforeAction: TCustomAction read FBeforeAction write FBeforeAction;
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
    fExecPack:Boolean;//12.07.2016 - Передали параметр в StoredProc, нужен для otMultiExecute
    FActionList: TOwnedCollection;
    FDataSource: TDataSource;
    FDateNavigator: TcxDateNavigator;
    FQuestionBeforeExecuteList: TStringList;
    FInfoAfterExecuteList: TStringList;
    FView: TcxGridTableView;
    FWithoutNext: Boolean;
    FShowGauge: Boolean;
    procedure ListExecute;
    procedure SaveQuestionBeforeExecute;
    procedure SaveInfoAfterExecute;
    procedure RestoreQuestionBeforeExecute;
    procedure RestoreInfoAfterExecute;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetView(const Value: TcxGridTableView);
    procedure SetDateNavigator(const Value: TcxDateNavigator);
  protected
    procedure DataSourceExecute; virtual;
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
    // Ссылка на DateNavigator выполняеться для каждой отмеченной даты
    property DateNavigator: TcxDateNavigator read FDateNavigator write SetDateNavigator;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
    property WithoutNext: Boolean read FWithoutNext write FWithoutNext
      default false;
    property ShowGauge: Boolean read FShowGauge write FShowGauge
      default True;
  end;

  // Выполняет несколько Action подряд. В случае установки св-ва DataSource выполняет
  // Актионы для всех записей DataSource
  // В случае, если указаны  QuestionBeforeExecute, InfoAfterExecute то данные вопросы в Action игнорируются
  // Дополнительно можно фильтр наложить

  TMultiActionFilter = class(TMultiAction)
  private

    FFilterColumnList: TOwnedCollection;
    FFilterList: TStringList;

  protected
    procedure DataSourceExecute; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function SetFiltered(AFiltered : Boolean): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Установка (отмена) фильтра на поле по содержимому перед пробегом
    property FilterColumnList: TOwnedCollection read FFilterColumnList write FFilterColumnList;
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
    procedure OnPageChanging(Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property Timer: TTimer read FTimer;
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

  TdsdCustomOpenForm = class(TdsdCustomAction, IFormAction)
  private
    FParams: TdsdParams;
    FFormName: string;
    FisShowModal: Boolean;
    FisReturnGuiParams: Boolean;
    FisNotExecuteDialog: Boolean;
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
    property isReturnGuiParams: Boolean read FisReturnGuiParams write FisReturnGuiParams default False;
    property isNotExecuteDialog: Boolean read FisNotExecuteDialog write FisNotExecuteDialog default False;
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

  TdsdOpenForm = class(TdsdCustomOpenForm)
  private
  public
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property FormName;
    property FormNameParam;
    property GuiParams;
    property isShowModal;
    property isReturnGuiParams;
    property isNotExecuteDialog;
  end;

  // Откываем форму для выбора значения из справочника
  TOpenChoiceForm = class(TdsdCustomOpenForm, IChoiceCaller)
  private
    // Вызыввем процедуру после выбора элемента из справочника
    procedure SetOwner(Owner: TObject);
    procedure AfterChoice(Params: TdsdParams; Form: TForm);
  public
    constructor Create(AOwner: TComponent); override;
    property isReturnGuiParams;
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

  TdsdDataSetRefreshEx = class(TdsdDataSetRefresh)
  private
    FColumn: TcxGridDBColumn;
    procedure SetColumn(const Value: TcxGridDBColumn);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: Boolean; override;
  published
    property Column: TcxGridDBColumn read FColumn write SetColumn;
  end;

  // Данный класс дополняет поведение класса TdsdOpenForm по работе со справочниками
  // К сожалению наследование самое удобное пока
  TdsdInsertUpdateAction = class(TdsdOpenForm, IDataSetAction, IFormAction)
  private
    FActionDataLink: TDataSetDataLink;
    FdsdDataSetRefresh: TdsdCustomAction;
    FActionType: TDataSetAcionType;
    FFieldName: string;
    FCheckIDRecords : boolean;
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
    property CheckIDRecords : boolean  read FCheckIDRecords write FCheckIDRecords
      default False;
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
  private
    FModalResult: TModalResult;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ModalResult: TModalResult read FModalResult write FModalResult default mrCancel;
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
    cxegExportToExcel, cxegExportToXlsx, cxegExportToDbf, cxegExportToXmlUTF8,
    cxegExportToTextUTF8);

  TExportGrid = class(TdsdCustomAction)
  private
    FGrid: TcxControl;
    FExportType: TcxExport;
    FDefaultFileName: string;
    FDefaultFileExt: string;
    FColumnNameDataSet: TDataSet;
    FOpenAfterCreate: Boolean;
    FHideHeader: Boolean;
    FSeparator: String;
    FEncodingANSI: Boolean;
    FnoRecreateColumns: Boolean;
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
    property HideHeader: Boolean read FHideHeader write FHideHeader Default False;
    property Separator: String read FSeparator write FSeparator;
    property DefaultFileExt: String read FDefaultFileExt write FDefaultFileExt;
    property EncodingANSI: Boolean read FEncodingANSI write FEncodingANSI default false;
    property noRecreateColumns: Boolean read FnoRecreateColumns
      write FnoRecreateColumns default false;
  end;

  TdsdGridToExcel = class(TExportGrid)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  //Генерация / предпросмотр / дизайн распечаток
  TfrxReportExt = Class(TdsdComponent)
    FReport : TfrxReport;
  private
    procedure ClosePreview(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteReport(AReportName: String; ADataSets: TdsdDataSets;
      AParams: TdsdParams; ACopiesCount: Integer = 1; APrinter : String = ''; AWithOutPreview:Boolean = False;
      ADesignReport:Boolean = False; AModal:Boolean = False; APreviewWindowMaximized:Boolean = True);
  end;
  // Действие печати
  TdsdPrintAction = class(TdsdCustomDataSetAction)
  private
    FReportName: String;          // Название отчета - локально
    FPrinter: String;             // Название Принтера - локально
    FReportNameParam: TdsdParam;  // Название отчета - из Get
    FPrinterNameParam: TdsdParam; // Название Принтера - из Get
    FParams: TdsdParams;          // Параметры - передаются в саму форму печати
    FPictureFields: TStrings;     // Поля, в которых находятся фото
    FDataSets: TdsdDataSets;
//    FDataSetList: TList;
    FWithOutPreview: Boolean;
    FCopiesCount: Integer;
    FModalPreview: Boolean;
    FPreviewWindowMaximized: Boolean;
    function GetReportName: String;
    function GetPrinterName : String;
    procedure SetReportName(const Value: String);
    procedure SetPrinterName(const Value: String);
    procedure SetWithOutPreview(const Value: Boolean);
    procedure SetPictureFields(Value: TStrings);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
    procedure PreparePictures;
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
    // Параметры - передаются в саму форму печати
    property Params: TdsdParams read FParams write FParams;
    // Название Принтера - локально
    property Printer: String read GetPrinterName write SetPrinterName;
    // Название отчета - локально
    property ReportName: String read GetReportName write SetReportName;
    // Название отчета - из Get
    property ReportNameParam: TdsdParam read FReportNameParam
      write FReportNameParam;
    // Название Принтера - из Get
    property PrinterNameParam: TdsdParam read FPrinterNameParam
      write FPrinterNameParam;
    // Поля, в которых находятся фото
    property PictureFields: TStrings read FPictureFields write SetPictureFields;

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

  TShellExecuteAction = class(TdsdCustomAction)
  private
    FParam: TdsdParam;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Param: TdsdParam read FParam write FParam;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  TShowMessageAction = class(TdsdCustomAction)
  private
    FMessageText: String;
    procedure SetMessageText(Value: String);
    function GetMessageText: String;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property MessageText: String read GetMessageText write SetMessageText;
  end;

  // Загрузка XML Киевстара в БД
  TdsdLoadXMLKS = class(TdsdCustomAction)
  private
    FXMLFilename: String;
    FInsertProcedureName: string;
    odOpenXML: TOpenDialog;
    // обработка свойства XMLFilename
    //procedure SetXMLFilename(Value: String);
    //function GetXMLFilename: String;
    // обработка свойства InsertProcedureName
    //procedure SetInsertProcedureName(Value: String);
    //function GetInsertProcedureName: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // основная функция - Сохранение файла в БД
    function Execute: Boolean; override;
  published
    property XMLFilename: String read FXMLFilename write FXMLFilename;
    property InsertProcedureName: String read FInsertProcedureName write FInsertProcedureName;
  end;

type
  TspExportToFile = (spefExportToText, spefExportToDbf);

  // Выгрузка результата в файл
  TdsdStoredProcExportToFile = class(TdsdCustomAction)
  private
    FdsdStoredProcName: TdsdStoredProc;
    FFilePath: string;
    FFilePathParam: TdsdParam;
    FFileName: string;
    FFileNameParam: TdsdParam;
    FFileExt: string;// = '.txt';
    FFileExtParam: TdsdParam;
    FFileNamePrefix: string;
    FFileNamePrefixParam: TdsdParam;
    FShowSaveDialog : Boolean;
    sdSaveFile: TSaveDialog;
    FExportType: TspExportToFile;
    FFieldDefsCDS: TClientDataSet;
    FCreateNewFile: boolean;
    //FIncludeFieldNames: Boolean;

    procedure SetdsdStoredProcName(Value: TdsdStoredProc);
    function GetdsdStoredProcName: TdsdStoredProc;
    procedure SetFilePath(const Value: string);
    function GetFilePath: string;
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    procedure SetFileExt(const Value: string);
    function GetFileExt: string;
    procedure SetFileNamePrefix(const Value: string);
    function GetFileNamePrefix: string;
    function GetFieldDefs : TFieldDefs;
    procedure SetFieldDefs(Value: TFieldDefs);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // основная функция - Сохранение файла
    function Execute: Boolean; override;
  published
    // Настроенный компонент процедуры
    property dsdStoredProcName: TdsdStoredProc read GetdsdStoredProcName write SetdsdStoredProcName;
    // Путь к файлу файла
    property FilePath: string read GetFilePath write SetFilePath;
    property FilePathParam: TdsdParam read FFilePathParam write FFilePathParam;
    // Имя файла
    property FileName: string read GetFileName write SetFileName;
    property FileNameParam: TdsdParam read FFilenameParam write FFilenameParam;
    // Расширение файла
    property FileExt: string read GetFileExt write SetFileExt;
    property FileExtParam: TdsdParam read FFileExtParam write FFileExtParam;
    // Префикс имени файла
    property FileNamePrefix: string read GetFileNamePrefix write SetFileNamePrefix;
    property FileNamePrefixParam: TdsdParam read FFileNamePrefixParam write FFileNamePrefixParam;
    // Показывать диалог сохранения
    property ShowSaveDialog : Boolean read FShowSaveDialog write FShowSaveDialog default True;
    // Формат файла
    property ExportType: TspExportToFile read FExportType write FExportType default spefExportToText;
    // Описатель структурі DBF
    property FieldDefs: TFieldDefs read GetFieldDefs write SetFieldDefs;
    // Всегда создавать новій файл
    property CreateNewFile: boolean read FCreateNewFile write FCreateNewFile default True;
  end;

  TdsdPartnerMapAction = class(TdsdOpenForm, IFormAction)
  private
    FDataSet: TDataSet;
    FMapType: TMapAcionType;
    FGPSNField: string;
    FGPSEField: string;
    FAddressField: string;
    FInsertDateField: string;
    FGMMap: TGMMap;
    FIsShowRoute: Boolean;
    FAPIKey: String;
    FAPIKeyField: String;
    FAPIKeyStoredProc: TdsdStoredProc;
    procedure SetDataSet(const Value: TDataSet);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure BeforeExecute(Form: TForm); override;
    procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent);
  published
    property MapType: TMapAcionType read FMapType write FMapType default acShowOne;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property GPSNField: string read FGPSNField write FGPSNField;
    property GPSEField: string read FGPSEField write FGPSEField;
    property AddressField: string read FAddressField write FAddressField;
    property InsertDateField: string read FInsertDateField write FInsertDateField;
    property IsShowRoute: Boolean read FIsShowRoute write FIsShowRoute default False;

    property APIKey: string read FAPIKey write FAPIKey;
    property APIKeyField: string read FAPIKeyField write FAPIKeyField;
    property APIKeyStoredProc: TdsdStoredProc  read FAPIKeyStoredProc write FAPIKeyStoredProc;
  end;

  TPUSHMessageType = (pmtResult, pmtWarning, pmtError, pmtInformation, pmtConfirmation);

  TdsdShowPUSHMessage = class(TdsdCustomDataSetAction)
  private
    FPUSHMessageType : TPUSHMessageType;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    property PUSHMessageType : TPUSHMessageType read FPUSHMessageType write FPUSHMessageType default pmtResult;
  end;

  TdsdDuplicateSearchAction = class(TdsdCustomAction)
  private
  protected
    function LocalExecute: Boolean; override;
  public
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
  end;

  TdsdDOCReportFormAction = class(TdsdCustomAction)
  private
    FDataSet: TDataSet;
    FBlankName: string;
    FFileName: string;
    procedure SetDataSet(const Value: TDataSet);
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

    property DataSet: TDataSet read FDataSet write SetDataSet;
    property BlankName: string read FBlankName write FBlankName;
    property FileName: string read FFileName write FFileName;
  end;

  TdsdOpenStaticForm = class(TdsdCustomAction)
  private
    FParams: TdsdParams;
    FFormName: string;
    FisShowModal: Boolean;
    FisReturnGuiParams: Boolean;
    FFormNameParam: TdsdParam;
    procedure SetFormName(const Value: string);
    function GetFormName: string;
  protected
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
    property isReturnGuiParams: Boolean read FisReturnGuiParams write FisReturnGuiParams default False;
  end;


  TdsdDefaultParamsItem = class(TCollectionItem)
  private
    FParam: TdsdParam;
    FValue: Variant;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // При установке данного свойства процедура будет вызвана только если TabSheet активен
    property Param: TdsdParam read FParam write FParam;
    property Value: Variant read FValue write FValue;
  end;

  TdsdDefaultParamsList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdDefaultParamsItem;
    procedure SetItem(Index: Integer; const Value: TdsdDefaultParamsItem);
  public
    function Add: TdsdDefaultParamsItem;
    property Items[Index: Integer]: TdsdDefaultParamsItem read GetItem
      write SetItem; default;
  end;

  TdsdSetDefaultParams = class(TdsdCustomAction)
  private
    FDefaultParams: TdsdDefaultParamsList;
  protected
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
    property DefaultParams: TdsdDefaultParamsList read FDefaultParams write FDefaultParams;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
  end;

  TdsdFTPOperationType = (ftpSend, ftpDownload, ftpDownloadAndRun, ftpDelete);

  TdsdFTP = class(TdsdCustomAction)
  private
    FHostParam: TdsdParam;
    FPortParam: TdsdParam;
    FUserNameParam: TdsdParam;
    FPasswordParam: TdsdParam;
    FDirParam: TdsdParam;

    FFullFileNameParam: TdsdParam;
    FFileNameFTPParam: TdsdParam;
    FFileNameParam: TdsdParam;
    FDownloadFolderParam: TdsdParam;

    FFTPOperation : TdsdFTPOperationType;
    FIdFTP: TIdFTP;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property HostParam: TdsdParam read FHostParam write FHostParam;
    property PortParam: TdsdParam read FPortParam write FPortParam;
    property UserNameParam: TdsdParam read FUserNameParam write FUserNameParam;
    property PasswordParam: TdsdParam read FPasswordParam write FPasswordParam;
    property DirParam: TdsdParam read FDirParam write FDirParam;
    property FullFileNameParam: TdsdParam read FFullFileNameParam write FFullFileNameParam;
    property FileNameFTPParam: TdsdParam read FFileNameFTPParam write FFileNameFTPParam;
    property FileNameParam: TdsdParam read FFileNameParam write FFileNameParam;
    property DownloadFolderParam: TdsdParam read FDownloadFolderParam write FDownloadFolderParam;
    property FTPOperation : TdsdFTPOperationType read FFTPOperation write FFTPOperation default ftpSend;
    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdDblClickAction = class(TdsdCustomAction)
    procedure OnDblClick(Sender: TObject);
  private
    FComponent: TComponent;
    FAction: TCustomAction;
    FOnDblClick: TNotifyEvent;
    procedure SetComponent(const Value: TComponent);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property Action: TCustomAction read FAction write FAction;
    property Component: TComponent read FComponent write SetComponent;
  end;

  TdsdSendSMSAction = class(TdsdCustomAction)
  private
    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

    FHostParam: TdsdParam;
    FLoginParam: TdsdParam;
    FPasswordParam: TdsdParam;
    FPhonesParam: TdsdParam;
    FMessageParam: TdsdParam;
    FShowCostParam: TdsdParam;
  protected
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
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Host: TdsdParam read FHostParam write FHostParam;
    property Login: TdsdParam read FLoginParam write FLoginParam;
    property Password: TdsdParam read FPasswordParam write FPasswordParam;
    property Phones: TdsdParam read FPhonesParam write FPhonesParam;
    property Message: TdsdParam read FMessageParam write FMessageParam;
    property ShowCost: TdsdParam read FShowCostParam write FShowCostParam;
  end;

  TdsdSendSMSCPAAction = class(TdsdCustomAction)
  private
    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

    FHostParam: TdsdParam;
    FLoginParam: TdsdParam;
    FPasswordParam: TdsdParam;
    FPhonesParam: TdsdParam;
    FMessageParam: TdsdParam;
  protected
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
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Host: TdsdParam read FHostParam write FHostParam;
    property Login: TdsdParam read FLoginParam write FLoginParam;
    property Password: TdsdParam read FPasswordParam write FPasswordParam;
    property Phones: TdsdParam read FPhonesParam write FPhonesParam;
    property Message: TdsdParam read FMessageParam write FMessageParam;
  end;

  TdsdSendSMSKyivstarAction = class(TdsdCustomAction)
  private
    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    FUnauthorized: Boolean;

    FAlphaName: TdsdParam;
    FHostParam: TdsdParam;
    FEnvironmentParam: TdsdParam;
    FClientIdParam: TdsdParam;
    FClientSecretParam: TdsdParam;
    FTokenParam: TdsdParam;
    FVersionParam: TdsdParam;


    FPhonesParam: TdsdParam;
    FMessageParam: TdsdParam;
  protected
    function LocalExecute: Boolean; override;
    procedure CreateIdHTTP;
    function Authentication: Boolean;
    function SendSMS: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property AlphaName: TdsdParam read FAlphaName write FAlphaName;
    property Host: TdsdParam read FHostParam write FHostParam;
    property Environment: TdsdParam read FEnvironmentParam write FEnvironmentParam;
    property ClientId: TdsdParam read FClientIdParam write FClientIdParam;
    property ClientSecret: TdsdParam read FClientSecretParam write FClientSecretParam;
    property Token: TdsdParam read FTokenParam write FTokenParam;
    property Phones: TdsdParam read FPhonesParam write FPhonesParam;
    property Message: TdsdParam read FMessageParam write FMessageParam;
    property Version: TdsdParam read FVersionParam write FVersionParam;
  end;

  TdsdSetFocusedAction = class(TdsdCustomAction)
  private

    FControlNameParam: TdsdParam;
    FTimerFocused: TTimer;
    procedure OnTimerFocused(Sender: TObject);
  protected
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
    property ControlName: TdsdParam read FControlNameParam write FControlNameParam;
  end;

  TdsdLoadListValuesFileAction = class(TdsdCustomAction)
  private
    FFileOpenDialog: TFileOpenDialog;
    FParam: TdsdParam;
    FFileNameParam: TdsdParam;
    FStartColumns: Integer;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Param: TdsdParam read FParam write FParam;
    property FileName: TdsdParam read FFileNameParam write FFileNameParam;
    property StartColumns: Integer read FStartColumns write FStartColumns default 2;

    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  // Преобразование датасета с фотографиями
  TdsdPreparePicturesAction = class(TdsdCustomAction)
  private
    FDataSet: TDataSet;
    FPictureFields: TStrings;     // Поля, в которых находятся фото
    procedure SetPictureFields(Value: TStrings);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function LocalExecute: Boolean; override;
    procedure PreparePictures;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Lатасет
    property DataSet: TDataSet read FDataSet write FDataSet;
    // Поля, в которых находятся фото
    property PictureFields: TStrings read FPictureFields write SetPictureFields;

    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
  end;

  TdsdSetVisibleParamsItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    FParam: TdsdParam;
    procedure SetComponent(const Value: TComponent);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Component: TComponent read FComponent write SetComponent;
    property ValueParam: TdsdParam read FParam write FParam;
  end;

  TdsdSetVisibleAction = class(TdsdCustomAction)
  private

    FSetVisibleParams: TOwnedCollection;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
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
    property SetVisibleParams: TOwnedCollection read FSetVisibleParams write FSetVisibleParams;
  end;

  TdsdPairParamsItem = class(TCollectionItem)
  private
    FDataType: TFieldType;
    FFieldName : String;
    FPairName : String;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FieldName: String read FFieldName write FFieldName;
    property PairName: String read FPairName write FPairName;
    property DataType: TFieldType read FDataType write FDataType default ftString;
  end;

  TFilterParamCollectionItem = class(TCollectionItem)
    FFieldParam: TdsdParam;
    FValueParam: TdsdParam;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FieldParam: TdsdParam read FFieldParam write FFieldParam;
    property ValueParam: TdsdParam read FValueParam write FValueParam;
  end;

  TdsdDataToJsonAction = class(TdsdCustomAction)
  private
    FDataSource: TDataSource;
    FView: TcxGridTableView;

    FJsonParam: TdsdParam;
    FPairParams: TOwnedCollection;

    FFileOpenDialog: TFileOpenDialog;
    FFileNameParam: TdsdParam;
    FStartColumns: Integer;

    FFilterParam: TOwnedCollection;

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
    // Ссылка на элемент отображающий список
    property View: TcxGridTableView read FView write SetView;
    // Ссылка на список данных. Может быть установлен только один источник данных
    property DataSource: TDataSource read FDataSource write SetDataSource;
    // Получившийся Json
    property JsonParam: TdsdParam read FJsonParam write FJsonParam;
    // Содержимое массива Json
    property PairParams: TOwnedCollection read FPairParams write FPairParams;
    // Имя файла для загрузки данных
    property FileNameParam: TdsdParam read FFileNameParam write FFileNameParam;
    property StartColumns: Integer read FStartColumns write FStartColumns default 2;

    property FilterParam: TOwnedCollection read FFilterParam write FFilterParam;

    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

//  TSendTelegramBotType = (tbSendMessage, tbSendDocument, tbSendPhoto);

  TdsdSendTelegramBotAction = class(TdsdCustomAction)
  private
    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

//    FSendType : TSendTelegramBotType;

    FBaseURLParam: TdsdParam;
    FTokenParam: TdsdParam;
    FMessageParam: TdsdParam;
//    FFileNameParam: TdsdParam;
//    FCaptionFileParam: TdsdParam;
    FChatIdParam: TdsdParam;

    FisSeendParam: TdsdParam;
    FisErroeSendParam: TdsdParam;
    FErrorParam: TdsdParam;

    Fid_bot : Boolean;
    Ffirst_name : String;
    Fusername : String;
    Fcan_join_groups : Boolean;
    Fcan_read_all_group_messages : Boolean;
    Fsupports_inline_queries : Boolean;

  protected
    function LocalExecute: Boolean; override;
    procedure SetError(AError : String);
    function InitBot : Boolean;
    function SendMessage : Boolean;
//    function SendFile : Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property QuestionBeforeExecute;
    property InfoAfterExecute;

//    property SendType : TSendTelegramBotType read FSendType write FSendType default tbSendMessage;

    property BaseURLParam: TdsdParam read FBaseURLParam write FBaseURLParam;
    property Token: TdsdParam read FTokenParam write FTokenParam;
    property ChatId: TdsdParam read FChatIdParam write FChatIdParam;

    property isSeend: TdsdParam read FisSeendParam write FisSeendParam;
    property isErroeSend: TdsdParam read FisErroeSendParam write FisErroeSendParam;
    property Error: TdsdParam read FErrorParam write FErrorParam;

    property Message: TdsdParam read FMessageParam write FMessageParam;
//    property FileName: TdsdParam read FFileNameParam write FFileNameParam;
//    property CaptionFile: TdsdParam read FCaptionFileParam write FCaptionFileParam;

  end;

  TdsdSendClipboardAction = class(TdsdCustomAction)
  private
    FParam: TdsdParam;
  protected
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
    property QuestionBeforeExecute;
    property InfoAfterExecute;

    property TextParam: TdsdParam read FParam write FParam;
  end;

  TdsdSetEnabledParamsItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    FParam: TdsdParam;
    procedure SetComponent(const Value: TComponent);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Component: TComponent read FComponent write SetComponent;
    property ValueParam: TdsdParam read FParam write FParam;
  end;

  TdsdSetEnabledAction = class(TdsdCustomAction)
  private

    FSetEnabledParams: TOwnedCollection;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
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
    property SetEnabledParams: TOwnedCollection read FSetEnabledParams write FSetEnabledParams;
  end;

  TdsdRunAction = class(TdsdCustomAction)
  private
    FRunTask : TNotifyEvent;
  protected
    function LocalExecute: Boolean; override;
  public
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property OnRunTask: TNotifyEvent read FRunTask write FRunTask;
  end;

  TdsdUpdateFieldItem = class(TCollectionItem)
  private
    FFieldNameFrom : String;
    FFieldNameTo : String;
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property FieldNameFrom: String read FFieldNameFrom write FFieldNameFrom;
    property FieldNameTo: String read FFieldNameTo write FFieldNameTo;
  end;

  TTypeTransaction = (ttSelect, ttExecSQL);
  TForeignDataOperation = (fdoDataSet, fdoUpdateDataSet, fdoToJSON, fdoMultiExecuteJSON);

  TdsdFDPairParamsItem = class(TCollectionItem)
  private
    FFieldName : String;
    FPairName : String;
  protected
    constructor Create(Collection: TCollection); overload; override;
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property FieldName: String read FFieldName write FFieldName;
    property PairName: String read FPairName write FPairName;
  end;

  TdsdForeignData = class(TdsdCustomAction)
  private
    FHostParam: TdsdParam;
    FPortParam: TdsdParam;
    FDataBase: TdsdParam;
    FUserNameParam: TdsdParam;
    FPasswordParam: TdsdParam;

    FSQLParam: TdsdParam;
    FDataSet: TClientDataSet;

    FTypeTransaction : TTypeTransaction;
    FOperation : TForeignDataOperation;
    FParams: TdsdParams;
    FUpdateFields: TCollection;

    FIdFieldFrom : String;
    FIdFieldTo : String;

    FJsonParam: TdsdParam;
    FPairParams: TCollection;
    FMultiExecuteAction: TCustomAction;
    FMultiExecuteCount: Integer;

    FZConnection : TZConnection;
    FZQuery: TZQuery;
    FHideError: Boolean;
    FParamBollToInt: Boolean;
    FShowGaugeForm: Boolean;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ZConnection : TZConnection read FZConnection;
    property HostParam: TdsdParam read FHostParam write FHostParam;
    property PortParam: TdsdParam read FPortParam write FPortParam;
    property UserNameParam: TdsdParam read FUserNameParam write FUserNameParam;
    property PasswordParam: TdsdParam read FPasswordParam write FPasswordParam;
    property DataBase: TdsdParam read FDataBase write FDataBase;
    property SQLParam: TdsdParam read FSQLParam write FSQLParam;
    property TypeTransaction : TTypeTransaction read FTypeTransaction write FTypeTransaction default ttSelect;
    property DataSet: TClientDataSet read FDataSet write FDataSet;
    property Operation : TForeignDataOperation read FOperation write FOperation default fdoDataSet;
    property Params: TdsdParams read FParams write FParams;
    property UpdateFields: TCollection read FUpdateFields write FUpdateFields;
    property IdFieldFrom : String read FIdFieldFrom write FIdFieldFrom;
    property IdFieldTo : String read FIdFieldTo write FIdFieldTo;
    property JsonParam: TdsdParam read FJsonParam write FJsonParam;
    property PairParams: TCollection read FPairParams write FPairParams;
    property MultiExecuteAction: TCustomAction read FMultiExecuteAction write FMultiExecuteAction;
    property MultiExecuteCount: Integer read FMultiExecuteCount write FMultiExecuteCount default 1000;
    property HideError: Boolean read FHideError write FHideError default False;
    property ParamBollToInt: Boolean read FParamBollToInt write FParamBollToInt default False;
    property ShowGaugeForm: Boolean read FShowGaugeForm write FShowGaugeForm default True;
    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdMyIPAction = class(TdsdCustomAction)
  private

    FIP: TdsdParam;
    FContinent: TdsdParam;
    FContinent_Code: TdsdParam;
    FCountry: TdsdParam;
    FCountry_Code: TdsdParam;
    FRegion: TdsdParam;
    FRegion_Code: TdsdParam;
    FCity: TdsdParam;
    FLatitude: TdsdParam;
    FLongitude: TdsdParam;
    FPstal: TdsdParam;
    FCalling_Code: TdsdParam;
    FCapital: TdsdParam;
    FBorders: TdsdParam;
    FConnection: TdsdParam;

    FIdHTTP: TIdHTTP;

  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property IP: TdsdParam read FIP write FIP;
    property Continent: TdsdParam read FContinent write FContinent;
    property Continent_Code: TdsdParam read FContinent_Code write FContinent_Code;
    property Country: TdsdParam read FCountry write FCountry;
    property Country_Code: TdsdParam read FCountry_Code write FCountry_Code;
    property Region: TdsdParam read FRegion write FRegion;
    property Region_Code : TdsdParam read FRegion_Code write FRegion_Code;
    property City: TdsdParam read FCity write FCity;
    property Latitude : TdsdParam read FLatitude write FLatitude;
    property Longitude: TdsdParam read FLongitude write FLongitude;
    property Pstal: TdsdParam read FPstal write FPstal;
    property Calling_Code : TdsdParam read FCalling_Code write FCalling_Code;
    property Capital : TdsdParam read FCapital write FCapital;
    property Borders: TdsdParam read FBorders write FBorders;
    property Connection: TdsdParam read FConnection write FConnection;

    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdVATNumberValidation = class(TdsdCustomAction)
  private

    FAccess_Key: TdsdParam;
    FVat_Number: TdsdParam;

    FValid: TdsdParam;

    FCountry_Code: TdsdParam;
    FCompany_Name: TdsdParam;
    FCompany_Address: TdsdParam;

    FIdHTTP: TIdHTTP;

  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // API Access Key - для доступа к сервису
    property Access_Key: TdsdParam read FAccess_Key write FAccess_Key;
    // vat_number - клиента
    property Vat_Number: TdsdParam read FVat_Number write FVat_Number;
    // Результат успешности получения
    property Valid: TdsdParam read FValid write FValid;
    // Код страны
    property Country_Code: TdsdParam read FCountry_Code write FCountry_Code;
    // Название
    property Company_Name: TdsdParam read FCompany_Name write FCompany_Name;
    // Адрес
    property Company_Address: TdsdParam read FCompany_Address write FCompany_Address;

    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdLoadAgilis = class(TdsdCustomAction)
  private

    FURL: TdsdParam;
    FOrder: TdsdParam;

    FDataSet: TClientDataSet;

    FFieldCount: TdsdParam;
    FTitleName: TdsdParam;
    FValueName: TdsdParam;

    FCreateFileTitle : TdsdParam;

    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

  protected
    function GetURL : String;
    function GetOrder : String;
    function GetCreateFileTitle : Boolean;
    function GetFieldCount : Integer;
    function GetFieldTitle : String;
    function GetFieldValue : String;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // URL
    property URL: String read GetURL;
    property URLParam: TdsdParam read FURL write FURL;
    // Order - заказа
    property Order: String read GetOrder;
    property OrderParam: TdsdParam read FOrder write FOrder;
    // DataSet - для полученных данных
    property DataSet: TClientDataSet read FDataSet write FDataSet;

    // Создавать столбцы с названием обекта
    property CreateFileTitle: Boolean read GetCreateFileTitle;
    property CreateFileTitleParam : TdsdParam read FCreateFileTitle write FCreateFileTitle;

    // Количество полей без учета ключа
    property FieldCount: Integer read GetFieldCount;
    property FieldCountParam: TdsdParam read FFieldCount write FFieldCount;
    // Название ключа при его формировании
    property FieldTitle: String read GetFieldTitle;
    property FieldTitleParam: TdsdParam read FTitleName write FTitleName;
    // Значение
    property FieldValue: String read GetFieldValue;
    property FieldValueParam: TdsdParam read FValueName write FValueName;

    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdLoadFile_https = class(TdsdCustomAction)
  private

    FURL: TdsdParam;
    FData: TdsdParam;

    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

    FStream: TStringStream;

  protected
    function GetURL : String;

    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // URL
    property URL: String read GetURL;
    property URLParam: TdsdParam read FURL write FURL;
    // Order - заказа
    property DataParam: TdsdParam read FData write FData;

    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdeSputnikContactsMessages = class(TdsdCustomAction)
  private

    FDataStart: TdsdParam;
    FDataEnd: TdsdParam;
    FUserName: TdsdParam;
    FPassword: TdsdParam;
    FPhone: TdsdParam;

    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

    FDataSet: TClientDataSet;

  protected

    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published

    property DataStartParam: TdsdParam read FDataStart write FDataStart;
    property DataEndParam: TdsdParam read FDataEnd write FDataEnd;
    property UserNameParam: TdsdParam read FUserName write FUserName;
    property PasswordParam: TdsdParam read FPassword write FPassword;
    property PhoneParam: TdsdParam read FPhone write FPhone;

    property DataSet: TClientDataSet read FDataSet write FDataSet;

    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;

  TdsdeSputnikSendSMS = class(TdsdCustomAction)
  private

    FUserName: TdsdParam;
    FPassword: TdsdParam;
    FFrom: TdsdParam;
    FText: TdsdParam;
    FPhone: TdsdParam;
    FSend: TdsdParam;

    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;

  protected

    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published

    property UserNameParam: TdsdParam read FUserName write FUserName;
    property PasswordParam: TdsdParam read FPassword write FPassword;
    property FromParam: TdsdParam read FFrom write FFrom;
    property TextParam: TdsdParam read FText write FText;
    property PhoneParam: TdsdParam read FPhone write FPhone;
    property SendParam: TdsdParam read FSend write FSend;

    property Caption;
    property Hint;
    property ImageIndex;
    property QuestionBeforeExecute;
    property ShortCut;
    property SecondaryShortCuts;
    property InfoAfterExecute;
  end;


  TdsdComponentItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    procedure SetComponent(const Value: TComponent);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Component: TComponent read FComponent write SetComponent;
  end;

  TBooleanSetVisibleAction = class(TdsdCustomAction)
  private
    FImageIndexFalse: TImageIndex;
    FImageIndexTrue: TImageIndex;
    FValue: Boolean;
    FHintFalse: String;
    FHintTrue: String;
    FCaptionFalse: String;
    FCaptionTrue: String;
    FComponents: TCollection;
    procedure SetImageIndexFalse(const Value: TImageIndex);
    procedure SetImageIndexTrue(const Value: TImageIndex);
    procedure SetValue(const Value: Boolean);
    procedure SetCaptionFalse(const Value: String);
    procedure SetCaptionTrue(const Value: String);
    procedure SetHintFalse(const Value: String);
    procedure SetHintTrue(const Value: String);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetVisiableAll;
  published
    property Value: Boolean read FValue write SetValue default True;
    property Components: TCollection read FComponents write FComponents;
    property HintTrue: String read FHintTrue write SetHintTrue;
    property HintFalse: String read FHintFalse write SetHintFalse;
    property CaptionTrue: String read FCaptionTrue write SetCaptionTrue;
    property CaptionFalse: String read FCaptionFalse write SetCaptionFalse;
    property ImageIndexTrue: TImageIndex read FImageIndexTrue
      write SetImageIndexTrue;
    property ImageIndexFalse: TImageIndex read FImageIndexFalse
      write SetImageIndexFalse;
  end;

  TdsdSetPropValueParamsItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    FNameParam: TdsdParam;
    FValueParam: TdsdParam;
    procedure SetComponent(const Value: TComponent);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Component: TComponent read FComponent write SetComponent;
    property NameParam: TdsdParam read FNameParam write FNameParam;
    property ValueParam: TdsdParam read FValueParam write FValueParam;
  end;

  TdsdSetPropValueAction = class(TdsdCustomAction)
  private

    FSetPropValueParams: TOwnedCollection;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
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
    property SetPropValueParams: TOwnedCollection read FSetPropValueParams write FSetPropValueParams;
  end;

  TdsdContinueAction = class(TdsdCustomAction)
  private
    FContinueParam: TdsdParam;
  protected
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
    property Continue: TdsdParam read FContinueParam write FContinueParam;
  end;

procedure Register;

implementation

uses Windows, Storage, SysUtils, CommonData, UtilConvert, FormStorage,
  Menus, cxGridExportLink, ShellApi, cxFilter,
  frxDesgn, messages, ParentForm, SimpleGauge, TypInfo,
  cxExportPivotGridLink, cxCustomPivotGrid, StrUtils, Variants,
  frxDBSet, Printers, cxDBData, dsdAddOn, dsdException,
  cxGridAddOn, cxTextEdit, cxGridDBDataDefinitions, ExternalSave,
  dxmdaset, dxCore, cxCustomData, cxGridLevel, cxImage, UnilWin,
  dsdExportToXLSAction, dsdExportToXMLAction, PUSHMessage, Xml.XMLDoc, XMLIntf;

var XML: IXMLDocument;

procedure Register;
begin
  RegisterActions('DSDLib', [TBooleanStoredProcAction],
    TBooleanStoredProcAction);
  RegisterActions('DSDLib', [TChangeGuidesStatus], TChangeGuidesStatus);
  RegisterActions('DSDLib', [TdsdChangeMovementStatus],
    TdsdChangeMovementStatus);
  RegisterActions('DSDLib', [TdsdChoiceGuides], TdsdChoiceGuides);
  RegisterActions('DSDLib', [TdsdDataSetRefresh], TdsdDataSetRefresh);
  RegisterActions('DSDLib', [TdsdDataSetRefreshEx], TdsdDataSetRefreshEx);
  RegisterActions('DSDLib', [TdsdExecStoredProc], TdsdExecStoredProc);
  RegisterActions('DSDLib', [TdsdStoredProcExportToFile], TdsdStoredProcExportToFile);
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
  RegisterActions('DSDLib', [TMultiActionFilter], TMultiActionFilter);
  RegisterActions('DSDLib', [TOpenChoiceForm], TOpenChoiceForm);
  RegisterActions('DSDLib', [TUpdateRecord], TUpdateRecord);
  RegisterActions('DSDLib', [TShellExecuteAction], TShellExecuteAction);
  RegisterActions('DSDLib', [TShowMessageAction], TShowMessageAction);
  RegisterActions('DSDLib', [TdsdLoadXMLKS], TdsdLoadXMLKS);
  RegisterActions('DSDLib', [TdsdPartnerMapAction], TdsdPartnerMapAction);
  RegisterActions('DSDLib', [TCrossDBViewSetTypeId], TCrossDBViewSetTypeId);
  RegisterActions('DSDLib', [TCrossDBViewSetTypeId], TCrossDBViewSetTypeId);
  RegisterActions('DSDLib', [TdsdShowPUSHMessage], TdsdShowPUSHMessage);
  RegisterActions('DSDLib', [TdsdDuplicateSearchAction], TdsdDuplicateSearchAction);
  RegisterActions('DSDLib', [TdsdDOCReportFormAction], TdsdDOCReportFormAction);
  RegisterActions('DSDLib', [TdsdOpenStaticForm], TdsdOpenStaticForm);
  RegisterActions('DSDLib', [TdsdSetDefaultParams], TdsdSetDefaultParams);
  RegisterActions('DSDLib', [TdsdFTP], TdsdFTP);
  RegisterActions('DSDLib', [TdsdDblClickAction], TdsdDblClickAction);
  RegisterActions('DSDLib', [TdsdSendSMSAction], TdsdSendSMSAction);
  RegisterActions('DSDLib', [TdsdSendSMSCPAAction], TdsdSendSMSCPAAction);
  RegisterActions('DSDLib', [TdsdSendSMSKyivstarAction], TdsdSendSMSKyivstarAction);
  RegisterActions('DSDLib', [TdsdSetFocusedAction], TdsdSetFocusedAction);
  RegisterActions('DSDLib', [TdsdLoadListValuesFileAction], TdsdLoadListValuesFileAction);
  RegisterActions('DSDLib', [TdsdPreparePicturesAction], TdsdPreparePicturesAction);
  RegisterActions('DSDLib', [TdsdSetVisibleAction], TdsdSetVisibleAction);
  RegisterActions('DSDLib', [TdsdDataToJsonAction], TdsdDataToJsonAction);
  RegisterActions('DSDLib', [TdsdSendTelegramBotAction], TdsdSendTelegramBotAction);
  RegisterActions('DSDLib', [TdsdSendClipboardAction], TdsdSendClipboardAction);
  RegisterActions('DSDLib', [TdsdSetEnabledAction], TdsdSetEnabledAction);
  RegisterActions('DSDLib', [TdsdRunAction], TdsdRunAction);
  RegisterActions('DSDLib', [TdsdForeignData], TdsdRunAction);
  RegisterActions('DSDLib', [TdsdMyIPAction], TdsdMyIPAction);
  RegisterActions('DSDLib', [TdsdVATNumberValidation], TdsdVATNumberValidation);
  RegisterActions('DSDLib', [TdsdLoadAgilis], TdsdLoadAgilis);
  RegisterActions('DSDLib', [TdsdLoadFile_https], TdsdLoadFile_https);
  RegisterActions('DSDLib', [TdsdeSputnikContactsMessages], TdsdeSputnikContactsMessages);
  RegisterActions('DSDLib', [TdsdeSputnikSendSMS], TdsdeSputnikSendSMS);
  RegisterActions('DSDLib', [TBooleanSetVisibleAction], TBooleanSetVisibleAction);
  RegisterActions('DSDLib', [TdsdSetPropValueAction], TdsdSetPropValueAction);
  RegisterActions('DSDLib', [TdsdContinueAction], TdsdContinueAction);

  RegisterActions('DSDLibExport', [TdsdGridToExcel], TdsdGridToExcel);
  RegisterActions('DSDLibExport', [TdsdExportToXLS], TdsdExportToXLS);
  RegisterActions('DSDLibExport', [TdsdExportToXML], TdsdExportToXML);

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
          if StoredProcList[i].StoredProc.OutputType = otMultiExecute
          then StoredProcList[i].StoredProc.Execute(fExecPack, true)//12.07.2016 - Передали параметр в StoredProc, нужен для otMultiExecute
          else StoredProcList[i].StoredProc.Execute
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

{ TdsdCustomOpenForm }

procedure TdsdCustomOpenForm.BeforeExecute;
begin

end;

constructor TdsdCustomOpenForm.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(Self, TdsdParam);
  FFormNameParam := TdsdParam.Create(nil);
  FFormNameParam.DataType := ftString;
  FFormNameParam.Value := '';
  isReturnGuiParams := False;
  FisNotExecuteDialog := False;
end;

destructor TdsdCustomOpenForm.Destroy;
begin
  FParams.Free;
  FParams := nil;
  FFormNameParam.Free;
  inherited;
end;

function TdsdCustomOpenForm.GetFormName: string;
begin
  result := FFormNameParam.AsString;
  if result = '' then
    result := FFormName
end;

function TdsdCustomOpenForm.LocalExecute: Boolean;
var
  ModalResult: TModalResult;
begin
  inherited;
  result := true;
  ModalResult := ShowForm.ModalResult;
  if isShowModal then
    result := ModalResult = mrOk;
end;

procedure TdsdCustomOpenForm.Notification(AComponent: TComponent;
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

procedure TdsdCustomOpenForm.OnFormClose(Params: TdsdParams);
begin

end;

procedure TdsdCustomOpenForm.SetFormName(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FormNameParam')
  else
    FFormName := Value;
end;

function TdsdCustomOpenForm.ShowForm: TForm;
begin
  result := TdsdFormStorageFactory.GetStorage.Load(FormName);
  BeforeExecute(result);
  if TParentForm(result).Execute(Self, FParams, FisNotExecuteDialog) then
  begin
    if result.WindowState = wsMinimized then
      result.WindowState := wsNormal;
    if isShowModal then
    begin
      if result.ShowModal = mrOk then
        if FisReturnGuiParams and (Self is TdsdOpenForm) and Assigned(TParentForm(result).AddOnFormData.Params.Params) then
          FParams.AssignParams(TParentForm(result).AddOnFormData.Params.Params);
      if (result is TParentForm) and TParentForm(result).AddOnFormData.isFreeAtClosing then result.Free;
    end
    else result.Show
  end
  else
    result.Free
end;

{ TdsdFormClose }

constructor TdsdFormClose.Create(AOwner: TComponent);
begin
  inherited;
  FPostDataSetBeforeExecute := false;
  FModalResult := mrCancel;
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
  begin
    if fsModal in TForm(Owner).FormState then
      TForm(Owner).ModalResult := FModalResult
    else
      TForm(Owner).Close;
  end;
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
      if FCheckIDRecords and Assigned(DataSource.DataSet.FindField(FFieldName)) then
        Enabled := (ActionType = acInsert) or
                      (DataSource.DataSet.RecordCount <> 0) and (DataSource.DataSet.FieldByName(FFieldName).AsInteger <> 0)
      else Enabled := (ActionType = acInsert) or
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
  HideHeader := False;
  EncodingANSI := False;
  FOpenAfterCreate := true;
  FNoRecreateColumns := False;
end;

function TExportGrid.LocalExecute: Boolean;
const
  ConstFileName = 'ExportFile';
  cFieldName = 'FieldName';
  cDisplayName = 'DisplayName';
var
  FileName: string;
  i: Integer;
  HeaderVisible: Boolean;
  Ext:String;
  sl: TStringList;
begin
  result := true;
  if not Assigned(FGrid) then
  begin
    ShowMessage('Не установлено свойство Grid');
    exit;
  end;
  if not Enabled then Exit;
  if DefaultFileName = '' then
    FileName := ConstFileName
  else
    FileName := DefaultFileName;
  if DefaultFileExt = '' then
  Begin
    case ExportType of
      cxegExportToHtml:
        FileName := FileName + '.html';
      cxegExportToXml, cxegExportToXmlUTF8:
        FileName := FileName + '.xml';
      cxegExportToText, cxegExportToTextUTF8:
        FileName := FileName + '.txt';
      cxegExportToExcel:
        FileName := FileName + '.xls';
      cxegExportToXlsx:
        FileName := FileName + '.xlsx';
      cxegExportToDbf:
        FileName := FileName + '.dbf';
    end;
  end
  else
  Begin
    if DefaultFileExt[1] <> '.' then
      ext := DefaultFileExt
    else
      ext := Copy(DefaultFileExt,2,length(DefaultFileExt));
    FileName := FileName + '.' + Ext;
  End;
  if FGrid is TcxGrid then
  begin
    // грид скрыт и нужен только для выгрузки, то добавим колонки во View
    if not FGrid.Visible and not FnoRecreateColumns then
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
    if HideHeader then
    Begin
      if TcxGrid(FGrid).ViewCount > 0 then
      begin
        if TcxGrid(FGrid).Views[0] is TcxGridDBTableView then
        begin
          HeaderVisible := (TcxGrid(FGrid).Views[0] as TcxGridDBTableView).OptionsView.Header;
          (TcxGrid(FGrid).Views[0] as TcxGridDBTableView).OptionsView.Header := False;
        end;
      end;
    end;

    // Проверяем если не влазит в Xls меняем на Xlsx
    if (TcxGrid(FGrid).ViewCount > 0) and (ExportType = cxegExportToExcel) then
    begin
      if (TcxGridDBTableView(TcxGrid(FGrid).Views[0]).ColumnCount >= 256) or
         (TcxGrid(FGrid).Views[0].DataController.RecordCount >= 65536) then
      begin
        ExportType := cxegExportToXlsx;
        FileName := StringReplace(FileName, '.xls', '.xlsx', [rfReplaceAll]);
      end;
    end;

    case ExportType of
      cxegExportToHtml:
        ExportGridToHTML(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToXml:
        ExportGridToXML(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToXmlUTF8:
        begin
          ExportGridToXML(FileName, TcxGrid(FGrid), IsCtrlPressed);
          XML.Active := False;
          XML.LoadFromFile(FileName);
          XML.Active := True;
          XML.SaveToFile(FileName);
          XML.Active := False;
        end;
      cxegExportToText:
        ExportGridToText(FileName, TcxGrid(FGrid), IsCtrlPressed,true,Separator,'','',ext);
      cxegExportToTextUTF8: if TcxGrid(FGrid).Views[0].DataController is TcxGridDBDataController then
        begin
          sl := TStringList.Create;
          try
            for I := 0 to TcxGrid(FGrid).Views[0].DataController.RecordCount - 1 do
              sl.Add(TcxGrid(FGrid).Views[0].DataController.Values[I, 0]);
            sl.SaveToFile(FileName, TEncoding.UTF8)
          finally
            sl.Free;
          end;
        end;
      cxegExportToExcel:
        {begin
          with TExportGridToLibre.Create(FileName, TcxGrid(FGrid)) do
            try
              if Connected then
                Execute
              else}
                ExportGridToExcel(FileName, TcxGrid(FGrid), IsCtrlPressed);
            {finally
              Free;
            end;
        end;}
      cxegExportToXlsx:
        ExportGridToXLSX(FileName, TcxGrid(FGrid), IsCtrlPressed);
      cxegExportToDbf:
        begin
          if FileExists(FileName) then DeleteFile(FileName);
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
    if HideHeader AND HeaderVisible then
      if TcxGrid(FGrid).ViewCount > 0 then
        if TcxGrid(FGrid).Views[0] is TcxGridDBTableView then
          (TcxGrid(FGrid).Views[0] as TcxGridDBTableView).OptionsView.Header := true;
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
      cxegExportToXmlUTF8:
        begin
          cxExportPivotGridToXML(FileName, TcxCustomPivotGrid(FGrid),
            IsCtrlPressed);
          XML.Active := False;
          XML.LoadFromFile(FileName);
          XML.Active := True;
          XML.SaveToFile(FileName);
          XML.Active := False;
        end;
      cxegExportToText:
        cxExportPivotGridToText(FileName, TcxCustomPivotGrid(FGrid),
          IsCtrlPressed {$IFDEF DELPHI103RIO}, 'txt', nil,  nil {$ENDIF});
      cxegExportToTextUTF8: if TcxCustomPivotGrid(FGrid).DataController is TcxGridDBDataController then
        begin
          sl := TStringList.Create;
          try
            for I := 0 to TcxCustomPivotGrid(FGrid).DataController.RecordCount - 1 do
              sl.Add(TcxCustomPivotGrid(FGrid).DataController.Values[I, 0]);
            sl.SaveToFile(FileName, TEncoding.UTF8)
          finally
            sl.Free;
          end;
        end;
      cxegExportToExcel, cxegExportToXlsx:
        cxExportPivotGridToExcel(FileName, TcxCustomPivotGrid(FGrid),
          IsCtrlPressed);
    end;
  end;
  if EncodingANSI then
  Begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(FileName);
      sl.SaveToFile(FileName,TEncoding.ANSI);
    finally
      sl.Free;
    end;
  End;
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
  // Название отчета - из Get
  FReportNameParam := TdsdParam.Create(nil);
  FReportNameParam.DataType := ftString;
  FReportNameParam.Value := '';
 // Название Принтера - из Get
  FPrinterNameParam := TdsdParam.Create(nil);
  FPrinterNameParam.DataType := ftString;
  FPrinterNameParam.Value := '';

  FDataSets := TdsdDataSets.Create(Self, TAddOnDataSet);
  WithOutPreview := false;
  FCopiesCount := 1;
  FPrinter := '';
  FModalPreview := false;
  FPreviewWindowMaximized := True;

  FPictureFields := TStringList.Create;
end;

destructor TdsdPrintAction.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FReportNameParam);
  FreeAndNil(FPrinterNameParam);
  FreeAndNil(FDataSets);
  FreeAndNil(FPictureFields);
  inherited;
end;

function TdsdPrintAction.GetReportName: String;
begin
  result := FReportNameParam.AsString;
  if result = '' then
    result := FReportName
end;

function TdsdPrintAction.GetPrinterName: String;
begin
  result := FPrinterNameParam.AsString;
  if result = '' then
    result := FPrinter
end;

function GetDefaultPrinter: string;
var
  ResStr: array [0 .. 255] of Char;
begin
  GetProfileString('Windows', 'device', '', ResStr, 255);
  result := StrPas(ResStr);
  if Pos(',',result) > 0 then result:=Copy(result,1,Pos(',',result)-1);

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

  PreparePictures;

  result := true;
  With TfrxReportExt.Create(Self) do
    ExecuteReport(Self.ReportName,Self.DataSets,Self.Params,Self.CopiesCount, Self.Printer, Self.WithOutPreview,
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

procedure TdsdPrintAction.PreparePictures;
var I, J, Len: integer;
    Data : AnsiString;
    FMemoryStream: TMemoryStream;
    Ext, FieldName: string;
    GraphicClass: TGraphicClass;
    CheckForImages: boolean;
    Field: TField;
begin
  if FPictureFields.Count = 0 then Exit;
  FMemoryStream := TMemoryStream.Create;
  try
    for I := 0 to Self.DataSets.Count - 1 do
    begin
      CheckForImages := false;
      for J := 0 to Self.DataSets.Items[I].DataSet.FieldCount - 1 do
        if (FPictureFields.IndexOf(Self.DataSets.Items[I].DataSet.Fields.Fields[J].FieldName) > -1)
            and
           (Self.DataSets.Items[I].DataSet.Fields.Fields[J].DataType = ftWideMemo) then
        begin
          CheckForImages := true;
          break;
        end;
      if not CheckForImages then continue;
      Self.DataSets.Items[I].DataSet.First;
      while not Self.DataSets.Items[I].DataSet.Eof do
      begin
        for J := 0 to FPictureFields.Count - 1 do
        begin
          Field := Self.DataSets.Items[I].DataSet.Fields.FieldByName(FPictureFields.Strings[0]);
          if Assigned(Field) and (Field.DataType = ftWideMemo) then
          begin
            try
              if Length(Field.AsString) <= 4 then Continue;
              
              Data := ReConvertConvert(Field.AsString);
              Ext := trim(Copy(Data, 1, 255));
              Ext := AnsiLowerCase(ExtractFileExt(Ext));
              Delete(Ext, 1, 1);

              if 'wmf' = Ext then GraphicClass := TMetafile;
              if 'emf' =  Ext then GraphicClass := TMetafile;
              if 'ico' =  Ext then GraphicClass := TIcon;
              if 'tiff' = Ext then GraphicClass := TWICImage;
              if 'tif' = Ext then GraphicClass := TWICImage;
              if 'png' = Ext then GraphicClass := TWICImage;
              if 'gif' = Ext then GraphicClass := TWICImage;
              if 'jpeg' = Ext then GraphicClass := TWICImage;
              if 'jpg' = Ext then GraphicClass := TWICImage;
              if 'bmp' = Ext then GraphicClass := Vcl.Graphics.TBitmap;
              if GraphicClass = nil then Continue;

              Data := Copy(Data, 256, maxint);
              Self.DataSets.Items[I].DataSet.Edit;

              Len := Length(Data);
              FMemoryStream.WriteBuffer(Data[1],  Len);
              FMemoryStream.Position := 0;
              
              TBlobField(Field).LoadFromStream(FMemoryStream);
              Self.DataSets.Items[I].DataSet.Post;
            finally
              FMemoryStream.Clear;
            end;
          end;
        end;
        Self.DataSets.Items[I].DataSet.Next;
      end;
      Self.DataSets.Items[I].DataSet.First;
    end;
  finally
    FMemoryStream.Free;
  end;
end;

procedure TdsdPrintAction.SetReportName(const Value: String);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте ReportNameParam')
  else
    FReportName := Value;
end;

procedure TdsdPrintAction.SetPictureFields(Value: TStrings);
begin
  FPictureFields.Assign(Value);
end;

procedure TdsdPrintAction.SetPrinterName(const Value: String);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте PrinterNameParam')
  else
    FPrinter := Value;
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
  FMoveParams.Free;
  inherited;
end;

function TdsdCustomAction.Execute : Boolean;
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
  if Assigned(BeforeAction) then
  begin
    if not BeforeAction.Execute then Exit;
  end;
  try
    result := LocalExecute;
    if PostDataSetAfterExecute then
      PostDataSet;
  finally
    if not result then
    begin
      if Assigned(CancelAction) then
        CancelAction.Execute;
    end else if Assigned(AfterAction) then
        AfterAction.Execute;
    if result and (InfoAfterExecute <> '') then
    begin
      Application.ProcessMessages;
      ShowMessage(InfoAfterExecute);
    end;
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
      if Self.Name = 'actRefreshMsg'
      then FTimer.Interval := 255007
      else FTimer.Interval := 300007;
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
  if not assigned(FView) then exit;
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
  FShowGauge := True;
end;

procedure TMultiAction.DataSourceExecute;
var
  i: Integer;
  aDate : array of TDateTime;
begin
  if Assigned(View) then
  begin
    with TGaugeFactory.GetGauge(Caption, 0,
      View.DataController.FilteredRecordCount, FShowGauge) do
    begin
      if FShowGauge then Start;
      try
        for i := 0 to View.DataController.FilteredRecordCount - 1 do
        begin
          View.DataController.FocusedRecordIndex :=
            View.DataController.FilteredRecordIndex[i];
          fExecPack:= (i = View.DataController.FilteredRecordCount - 1);//***12.07.2016 - Определили параметр для StoredProc, нужен для otMultiExecute
          ListExecute;
          if FShowGauge then IncProgress(1);
          Application.ProcessMessages;
        end;
      finally
        if FShowGauge then Finish;
      end;
    end;
  end
  else if Assigned(DataSource) then
  begin
    if Assigned(DataSource.DataSet) and DataSource.DataSet.Active and
      (DataSource.DataSet.RecordCount > 0) then
    begin
      // DataSource.DataSet.DisableControls;
      i:=DataSource.DataSet.RecordCount;//***12.07.2016
      try
        DataSource.DataSet.First;
        with TGaugeFactory.GetGauge(Caption, 0,
          DataSource.DataSet.RecordCount, FShowGauge) do
          try
            if FShowGauge then Start;
            while not DataSource.DataSet.Eof do
            begin
              fExecPack:= (i = 1);//***12.07.2016 - Определили параметр для StoredProc, нужен для otMultiExecute
              ListExecute;
              i:=i-1;//***12.07.2016
              if FShowGauge then IncProgress(1);
              Application.ProcessMessages;
              if not WithoutNext then
                DataSource.DataSet.Next
              else
                DataSource.DataSet.Delete;
            end;
          finally
            if FShowGauge then Finish;
          end;
      finally
        Application.ProcessMessages;
        // DataSource.DataSet.EnableControls;
      end;
    end;
  end else
  begin
    with TGaugeFactory.GetGauge(Caption, 0,
      DateNavigator.SelectedDays.Count, FShowGauge) do
    begin
      if FShowGauge then Start;
      SetLength(aDate, DateNavigator.SelectedDays.Count);
      try
        for i := 0 to DateNavigator.SelectedDays.Count - 1 do
          aDate[i] := DateNavigator.SelectedDays.Items[I];
        for i := 0 to High(aDate) do
        begin
          DateNavigator.Date := aDate[i];
          fExecPack:= (i = High(aDate) - 1);
          ListExecute;
          if FShowGauge then IncProgress(1);
          Application.ProcessMessages;
        end;
      finally
        if FShowGauge then Finish;
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
      //если экшин не активен - не выполняем его
      if not TActionItem(ActionList.Items[i]).Action.Enabled then continue;

      //***12.07.2016 - Передали параметр в StoredProc, нужен для otMultiExecute
      if (TActionItem(ActionList.Items[i]).Action is TdsdCustomAction)
      then TdsdCustomAction (TActionItem(ActionList.Items[i]).Action).fExecPack:=fExecPack;

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
    if Assigned(DataSource) or Assigned(View) or Assigned(DateNavigator) then
      DataSourceExecute
    else
      ListExecute;
  finally
    if QuestionBeforeExecute <> '' then
      RestoreQuestionBeforeExecute;
    if InfoAfterExecute <> '' then
      RestoreInfoAfterExecute;
  end;
  result := true;
end;

procedure TMultiAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) then
  begin
    if Assigned(ActionList) then
      if AComponent is TCustomAction then
        for i := 0 to ActionList.Count - 1 do
          if TActionItem(ActionList.Items[i]).Action = AComponent then
            TActionItem(ActionList.Items[i]).Action := nil;
  end;
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
  if (Assigned(View) or Assigned(DateNavigator)) and Assigned(Value) then
  begin
    ShowMessage('Установлен View или DateNavigator. Нельзя установить DataSource');
    exit;
  end;
  FDataSource := Value;
end;

procedure TMultiAction.SetView(const Value: TcxGridTableView);
begin
  if (Assigned(DataSource) or Assigned(DateNavigator)) and Assigned(Value) then
  begin
    ShowMessage('Установлен DataSource или DateNavigator. Нельзя установить View');
    exit;
  end;
  FView := Value;
end;

procedure TMultiAction.SetDateNavigator(const Value: TcxDateNavigator);
begin
  if (Assigned(DataSource) or Assigned(View)) and Assigned(Value) then
  begin
    ShowMessage('Установлен DataSource или View. Нельзя установить DateNavigator');
    exit;
  end;
  FDateNavigator := Value;
end;

{ TMultiActionFilter }

constructor TMultiActionFilter.Create(AOwner: TComponent);
begin
  inherited;
  FActionList := TOwnedCollection.Create(Self, TActionItem);
  FFilterColumnList := TOwnedCollection.Create(Self, TColumnCollectionItem);
  FFilterList := TStringList.Create(True);
  FWithoutNext := false;
  FShowGauge := True;
end;

function TMultiActionFilter.SetFiltered(AFiltered : Boolean): Boolean;
  var I : Integer;
begin

  if AFiltered then
  begin
    if Assigned(FView) then
    begin
      with FView.DataController.Filter do
      begin
        BeginUpdate;
        try
          root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboAnd;
          for I := 0 to FFilterColumnList.Count - 1 do
            if Assigned(TColumnCollectionItem(FFilterColumnList.Items[I]).Column) and
               Assigned(TcxDBDataController(View.DataController).DataSource.DataSet.FindField(TcxGridDBColumn(TColumnCollectionItem(FFilterColumnList.Items[I]).Column).DataBinding.FieldName)) then
          begin
            FFilterList.AddObject(IntToStr(I),
              root.AddItem(TColumnCollectionItem(FFilterColumnList.Items[I]).Column, TcxFilterOperatorKind.foEqual,
                           TcxDBDataController(View.DataController).DataSource.DataSet.FieldByName(TcxGridDBColumn(TColumnCollectionItem(FFilterColumnList.Items[I]).Column).DataBinding.FieldName).AsVariant,
                           TcxDBDataController(View.DataController).DataSource.DataSet.FindField(TcxGridDBColumn(TColumnCollectionItem(FFilterColumnList.Items[I]).Column).DataBinding.FieldName).AsString));
          end;
          Active := true;
        finally
          EndUpdate;
        end;
      end;
    end;
  end else
  begin
    if Assigned(FView) then
    begin
      with FView.DataController.Filter do
      begin
        BeginUpdate;
        try
          if FFilterList.Count > 0 then FFilterList.Clear;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TMultiActionFilter.DataSourceExecute;
begin
  if Assigned(View) then if FilterColumnList.Count > 0 then SetFiltered(True);
  try
    inherited DataSourceExecute;
  finally
    if FFilterList.Count > 0 then SetFiltered(false);
  end;
end;

destructor TMultiActionFilter.Destroy;
begin
  FreeAndNil(FActionList);
  FreeAndNil(FFilterColumnList);
  FreeAndNil(FFilterList);
  inherited;
end;

procedure TMultiActionFilter.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) then
  begin
    if AComponent is TcxGridColumn then
       for i := 0 to FilterColumnList.Count - 1 do
          if TColumnFieldFilterItem(FilterColumnList.Items[i]).Column = AComponent then
             TColumnFieldFilterItem(FilterColumnList.Items[i]).Column := nil;

  end;
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
  if (Assigned(GridView) or Assigned(PivotGrid)) and Assigned(Value) then
  begin
    ShowMessage
      ('Нельзя установить свойство DataSet так как установлено GridView или PivotGrid.');
    exit
  end;
  inherited;
end;

procedure TAddOnDataSet.SetGridView(const Value: TcxGridTableView);
begin
  if (Assigned(DataSet) or Assigned(PivotGrid)) and Assigned(Value) then
  begin
    ShowMessage
      ('Нельзя установить свойство GridView так как установлено DataSet или PivotGrid.');
    exit
  end;
  FGridView := Value;
end;

procedure TAddOnDataSet.SetPivotGrid(const Value: TcxDBPivotGrid);
begin
  if (Assigned(DataSet) or Assigned(GridView)) and Assigned(Value) then
  begin
    ShowMessage
      ('Нельзя установить свойство PivotGrid так как установлено DataSet или GridView.');
    exit
  end;
  FPivotGrid := Value;
end;

procedure TAddOnDataSet.Assign(Source: TPersistent);
begin
  if Source is TAddOnDataSet then
    with TAddOnDataSet(Source) do
    begin
      Self.DataSet := TAddOnDataSet(Source).DataSet;
      Self.UserName := TAddOnDataSet(Source).UserName;
      Self.GridView := TAddOnDataSet(Source).GridView;
      Self.PivotGrid := TAddOnDataSet(Source).PivotGrid;
    end
  else
    inherited Assign(Source);
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
  AParams: TdsdParams; ACopiesCount: Integer = 1; APrinter : String = ''; AWithOutPreview:Boolean = False;
  ADesignReport:Boolean = False; AModal:Boolean = False; APreviewWindowMaximized:Boolean = True);
var
  I,J: Integer;
  OldFieldIndexList: TStringList;
  DataSetList: TList;
  MemTableList: TList;
  ViewToMemTable: TcxViewToMemTable;
  Stream: TStringStream;
  ExpandedStr: String;
  ExpandedIdx: Integer;
  frxPDFExport1: TfrxPDFExport;
  frxXLSExport1: TfrxXLSExport;
  frxPDFExport_find, frxXLSExport_find: Boolean;
  frxPDFExport1_ShowDialog, frxXLSExport1_ShowDialog: Boolean;
  frxPDFExport1_Background,frxPDFExport1_EmbeddedFonts: Boolean;
  FileNameExport: String;
  PrefixFileNameExport: String;
  ExportDirectory: String;
  FileNameParam: TdsdParam;
begin
  DataSetList := TList.Create;
  MemTableList := TList.Create;
  ViewToMemTable := TcxViewToMemTable.Create;
  Stream := TStringStream.Create;
  OldFieldIndexList := TStringList.Create;
  ExpandedStr := '';
  try // mainTry
    FReport.PreviewOptions.Maximized := APreviewWindowMaximized;
    for i := 0 to ADataSets.Count - 1 do // залить источники данных
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
            // сохранили состояние разворотов до сортировки
            for ExpandedIdx := 0 to TAddOnDataSet(ADataSets[i]).GridView.ViewData.RowCount - 1 do
              if TAddOnDataSet(ADataSets[i]).GridView.ViewData.Rows[ExpandedIdx].Expanded then
                ExpandedStr := ExpandedStr + INtToStr(ExpandedIdx)+';';
            ExpandedStr := ExpandedStr + '|';

//            if TAddOnDataSet(ADataSets[i]).IndexFieldNames <> '' then //если есть сортировка
//            begin
//              with TAddOnDataSet(ADataSets[i]).GridView do
//              begin
//                BeginSortingUpdate;
//                OldSort := '';
//                for SortIdx := 0 to PatternGridView.SortedItemCount-1 do             //сохраняем старую сортировку
//                Begin
//                  if PatternGridView.SortedItems[SortIdx].SortOrder = soAscending then
//                    OldSort := OldSort + IntToStr(PatternGridView.SortedItems[SortIdx].Index)+';'
//                  else
//                  if PatternGridView.SortedItems[SortIdx].SortOrder = soDescending then
//                    OldSort := OldSort + IntToStr(1000+PatternGridView.SortedItems[SortIdx].Index)+';';
//                End;
//                OldFieldIndexList.Values[Name] := OldSort;
//                PatternGridView.DataController.ClearSorting(false); //очистили сортировку
//                NewSort := TAddOnDataSet(ADataSets[i]).IndexFieldNames;
//                if NewSort[Length(NewSort)] <> ';' then
//                  NewSort := NewSort + ';';
//                while NewSort <> '' do
//                Begin
//                  for SortIdx := 0 to ColumnCount - 1 do
//                    if ((Columns[SortIdx] is TcxGridDBColumn)
//                        AND
//                        (CompareText(TcxGridDBColumn(Columns[SortIdx]).DataBinding.FieldName,
//                                     Copy(NewSort,1,pos(';',NewSort)-1))=0)) then
//                    Begin
//                      PatternGridView.DataController.ChangeSorting(SortIdx,soAscending);
//                      break;
//                    End;
//                  Delete(NewSort,1,pos(';',NewSort));
//                End;
//                EndSortingUpdate;
//              end;
//            end;

            // развернули все строки, что бы ChildTableView загрузил все данные в клоны

            TAddOnDataSet(ADataSets[i]).GridView.ViewData.Expand(True);

            // перегрузили отсортированные данные в dxMemData
            // MemTableList.Add(ViewToMemTable.LoadData(TAddOnDataSet(ADataSets[i]).GridView));
            MemTableList.Add(ViewToMemTable.LoadData2(TAddOnDataSet(ADataSets[i]).GridView));
            TClientDataSet(MemTableList.Items[MemTableList.Count-1]).IndexFieldNames :=
                TAddOnDataSet(ADataSets[i]).IndexFieldNames

            // вернули сортировку наместо
//            if TAddOnDataSet(ADataSets[i]).IndexFieldNames <> '' then
//              TAddOnDataSet(ADataSets[i]).GridView.DataController.ClearSorting(false);
//            if OldSort <> '' then
//            Begin
//              TAddOnDataSet(ADataSets[i]).GridView.BeginSortingUpdate;
//              while OldSort <> '' do
//              Begin
//                SI := StrToInt(Copy(OldSort,1,pos(';',OldSort)-1));
//                Delete(OldSort,1,pos(';',OldSort));
//                if SI >= 1000 then
//                  TAddOnDataSet(ADataSets[i]).GridView.PatternGridView.DataController.ChangeSorting(
//                    SI-1000,soDescending)
//                else
//                  TAddOnDataSet(ADataSets[i]).GridView.PatternGridView.DataController.ChangeSorting(
//                    SI,soAscending);
//              End;
//              TAddOnDataSet(ADataSets[i]).GridView.EndSortingUpdate;
//            End;
          finally
            (TcxGridLevel(TAddOnDataSet(ADataSets[i]).GridView.Level).Control as TcxGrid).EndUpdate;
          end;
          DataSet := MemTableList[MemTableList.Count - 1];
        end;
        if Assigned(TAddOnDataSet(ADataSets[i]).PivotGrid) then
        begin
          TAddOnDataSet(ADataSets[i]).PivotGrid.BeginUpdate;
          try
            // сохранили состояние разворотов до сортировки
            for ExpandedIdx := 0 to TAddOnDataSet(ADataSets[i]).PivotGrid.ViewData.RowCount - 1 do
              if TAddOnDataSet(ADataSets[i]).PivotGrid.ViewData.Rows[ExpandedIdx].Expanded then
                ExpandedStr := ExpandedStr + INtToStr(ExpandedIdx)+';';
            ExpandedStr := ExpandedStr + '|';

            // развернули все строки, что бы ChildTableView загрузил все данные в клоны

            for J := 0 to TAddOnDataSet(ADataSets[i]).PivotGrid.FieldCount - 1 do
            begin
              if TAddOnDataSet(ADataSets[i]).PivotGrid.Fields[J].Area = faRow then
                TAddOnDataSet(ADataSets[i]).PivotGrid.Fields[J].ExpandAll;
              if TAddOnDataSet(ADataSets[i]).PivotGrid.Fields[J].Area = faColumn then
                TAddOnDataSet(ADataSets[i]).PivotGrid.Fields[J].ExpandAll;
            end;


            // перегрузили отсортированные данные в dxMemData
            MemTableList.Add(ViewToMemTable.LoadData3(TAddOnDataSet(ADataSets[i]).PivotGrid));
            TClientDataSet(MemTableList.Items[MemTableList.Count-1]).IndexFieldNames :=
                TAddOnDataSet(ADataSets[i]).IndexFieldNames

          finally
            TAddOnDataSet(ADataSets[i]).PivotGrid.EndUpdate;
          end;
          DataSet := MemTableList[MemTableList.Count - 1];
        end;
        if not DataSet.Active then
          raise Exception.Create('Датасет с данными ' + DataSet.Name + ' не открыт');
      end;
    end;

    //********************************************************
    for i := 0 to ADataSets.Count - 1 do //залить источники данных
    begin
      if Assigned(TAddOnDataSet(ADataSets[i]).GridView) then
      begin
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

    with FReport do
    Begin
      LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(AReportName));
      // это НЕ выгрузка в PFD + XLS
      frxPDFExport_find:=false;
      frxXLSExport_find:=false;
      // Показывать диалог при печати в DBF
      frxPDFExport1_ShowDialog:=True;
      frxXLSExport1_ShowDialog:=True;
      frxPDFExport1_Background:= False;
      frxPDFExport1_EmbeddedFonts:= False;
      FileNameExport:= '';
      PrefixFileNameExport:= '';
      ExportDirectory:= '';
      FileNameParam:= Nil;
      //
      for i := 0 to AParams.Count - 1 do
      begin
        // если есть такой параметр, тогда это выгрузка в PFD
        if AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('frxPDFExport_find')
        then frxPDFExport_find:= true
        else if AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('frxXLSExport_find')
             then frxXLSExport_find:= true;

        // если есть такой параметр, тогда без диалога
        if (AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('frxPDFExport1_ShowDialog')) and
           (AParams[i].DataType = ftBoolean)
        then frxPDFExport1_ShowDialog:= AParams[i].Value;
        // если есть такой параметр, тогда без диалога
        if (AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('frxXLSExport1_ShowDialog')) and
           (AParams[i].DataType = ftBoolean)
        then frxXLSExport1_ShowDialog:= AParams[i].Value;
        // если есть такой параметр, тогда без диалога экспорт фонв
        if (AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('frxPDFExport1_Background')) and
           (AParams[i].DataType = ftBoolean)
        then frxPDFExport1_Background:= AParams[i].Value;
        // если есть такой параметр, тогда без диалога встраивание шрифирв
        if (AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('frxPDFExport1_EmbeddedFonts')) and
           (AParams[i].DataType = ftBoolean)
        then frxPDFExport1_EmbeddedFonts:= AParams[i].Value;

        // если есть такой параметр, Префикс файла экспорта
        if AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('PrefixFileNameExport')
        then PrefixFileNameExport:= AParams[i].Value;
        // если есть такой параметр, Имя файла экспорта
        if AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('FileNameExport')
        then FileNameExport:= AParams[i].Value;
        // если есть такой параметр, Путь к сохраняемому файлу
        if AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('ExportDirectory')
        then ExportDirectory:= AParams[i].Value;
        // если есть такой параметр, Возвращает полній путь с именем к файлу
        if AnsiUpperCase(AParams[i].Name) = AnsiUpperCase('GetFileNameExport')
        then FileNameParam:= AParams[i];

        //
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
            if trim (APrinter) <> ''
            then PrintOptions.Printer := APrinter
            else PrintOptions.Printer := GetDefaultPrinter;
            PrintOptions.Copies := ACopiesCount;
            PrepareReport;
            Print;
            self.Free;
          end
          else
          begin
            if trim (APrinter) <> ''
            then PrintOptions.Printer := APrinter
            else PrintOptions.Printer := GetDefaultPrinter;
            PrepareReport;
            //
            if frxPDFExport_find = true then
            begin
               frxPDFExport1:= TfrxPDFExport.Create(Self);
               try
                 if FileNameExport <> '' then
                 begin
                   FileNameExport := FileNameExport + '.pdf';
                   if PrefixFileNameExport <> '' then
                     FileNameExport := PrefixFileNameExport + FileNameExport;
                   if UpperCase(ExportDirectory) = UpperCase('GetTempPath') then
                     FileNameExport := TPath.GetTempPath + FileNameExport
                   else if ExportDirectory <> '' then
                     FileNameExport := ExportDirectory + '\' + FileNameExport;
                   if ExpandFileName(ExtractFilePath(FileNameExport)) <> '' then
                   try
                     if not DirectoryExists(ExpandFileName(ExtractFilePath(FileNameExport))) then
                       ForceDirectories(ExpandFileName(ExtractFilePath(FileNameExport)));
                   except
                   end;
                 end;
                 frxPDFExport1.FileName := FileNameExport;
                 frxPDFExport1.ShowDialog := frxPDFExport1_ShowDialog;
                 if not frxPDFExport1_ShowDialog then
                 begin
                   frxPDFExport1.Background := frxPDFExport1_Background;
                   frxPDFExport1.EmbeddedFonts := frxPDFExport1_EmbeddedFonts;
                 end;
                 FReport.Export(frxPDFExport1);
                 if Assigned(FileNameParam) then FileNameParam.Value := FileNameExport;

               finally
                 FreeAndNil(frxPDFExport1);
               end;
            end

            else
            if frxXLSExport_find = true then
            begin
               frxXLSExport1:= TfrxXLSExport.Create(Self);
               try
                 if FileNameExport <> '' then
                 begin
                   FileNameExport := FileNameExport + '.xls';
                   if PrefixFileNameExport <> '' then
                     FileNameExport := PrefixFileNameExport + FileNameExport;
                   if ExportDirectory <> '' then
                     FileNameExport := ExportDirectory + '\' + FileNameExport
                   else FileNameExport := FileNameExport;
                   try
                     if not DirectoryExists(ExpandFileName(ExtractFilePath(FileNameExport))) then
                       ForceDirectories(ExpandFileName(ExtractFilePath(FileNameExport)));
                   except
                   end;
                 end;
                 frxXLSExport1.FileName := FileNameExport;
                 frxXLSExport1.ShowDialog := frxXLSExport1_ShowDialog;
                 FReport.Export(frxXLSExport1);
               finally
                 FreeAndNil(frxXLSExport1);
               end;
            end

            else ShowPreparedReport;
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

{ TShellExecuteAction }

constructor TShellExecuteAction.Create(AOwner: TComponent);
begin
  inherited;
  FParam := TdsdParam.Create(nil);
end;

destructor TShellExecuteAction.Destroy;
begin
  FreeAndNil(FParam);
  inherited;
end;

function TShellExecuteAction.LocalExecute: Boolean;
begin
  result := false;
  if VarToStr(Param.Value) <> '' then
  Begin
    ShellExecute(0, 'open', PChar(VarToStr(Param.Value)), '', '', 1);
    Result := True;
  End;
end;

{ TShowMessageAction }

constructor TShowMessageAction.Create(AOwner: TComponent);
begin
  inherited;
  FMessageText := '';
end;

destructor TShowMessageAction.Destroy;
begin
  //
  inherited;
end;

function TShowMessageAction.GetMessageText: String;
begin
  Result := FMessageText;
end;

function TShowMessageAction.LocalExecute: Boolean;
var lMessageText:String;
begin
  //
  if FMessageText <> '' then
  begin
      // вот так криво, т.к. после raise .... на форме ничего нельзя поделать
      lMessageText:=FMessageText;
      FMessageText:='';
      //
      if gc_ProgramName = 'Boutique.exe'
      then
           ShowMessage(lMessageText)
      else
          raise Exception.Create(lMessageText);
  end;
end;

procedure TShowMessageAction.SetMessageText(Value: String);
begin
  FMessageText := Value;
  if not (csDesigning in ComponentState) then
    LocalExecute;
end;

{ TdsdLoadXMLKS }

constructor TdsdLoadXMLKS.Create(AOwner: TComponent);
begin
  inherited;

  odOpenXML := TOpenDialog.Create(Application);
  odOpenXML.Filter := 'XML файл|*.xml|ZIP файл|*.zip';
  odOpenXML.Title := 'Укажите файл для загрузки';
  odOpenXML.Options := [ofReadOnly, ofFileMustExist];
end;

destructor TdsdLoadXMLKS.Destroy;
begin
  odOpenXML := nil;
  inherited;
end;

//function TdsdLoadXMLKS.GetInsertProcedureName: String;
//begin
//  if FInsertProcedureName = '' then
//    Result := 'gpInsertUpdate_logBillsKS'
//  else
//    Result := FInsertProcedureName;
//end;

function TdsdLoadXMLKS.Execute: Boolean;
var
  XMLFileStream: TStringStream;
  spInsertProcedure: TdsdStoredProc;
begin
  Result := False;

  if (XMLFilename = '') or (not FileExists(FXMLFilename)) then // если не указан файл или не существует
    if odOpenXML.Execute then // тогда спрашиваем
      XMLFilename := odOpenXML.FileName // запоминаем
    else                                // а если нет
      Exit;                             // то выходим

  // через поток заливаем в БД
  XMLFileStream := TStringStream.Create;
  XMLFileStream.LoadFromFile(XMLFilename);
  spInsertProcedure := TdsdStoredProc.Create(Application);
  spInsertProcedure.OutputType := otResult;
  spInsertProcedure.StoredProcName := FInsertProcedureName; ///'gpInsertUpdate_logBillsKS'; // FInsertProcedureName;
  spInsertProcedure.Params.AddParam('inXMLFile', ftBlob, ptInput, null);
  spInsertProcedure.ParamByName('inXMLFile').Value :=  EncodeBase64(BytesOf(XMLFileStream.DataString));

  try
    spInsertProcedure.Execute();
    Result := True;
  finally
    spInsertProcedure.Free;
    XMLFileStream.Free;
    XMLFilename := ''; // т.к. данный экшн автоматом создается и переменная запоминается - нужно обнулять
  end;

{  try
    try
      spInsertProcedure.Execute();
    except
      on E:Exception do
      begin
         raise Exception.Create(e.Message);
        //ShowMessage(e.Message);
      end;
    end;
  finally
    spInsertProcedure.Free;
    XMLFileStream.Free;
  end;
  XMLFilename := ''; // т.к. данный экшн автоматом создается и переменная запоминается - нужно обнулять
 }

  //inherited;
end;


{ TdsdStoredProcToFile }

constructor TdsdStoredProcExportToFile.Create(AOwner: TComponent);
begin
  inherited;

  sdSaveFile := TSaveDialog.Create(Application);
  sdSaveFile.Options := [ofFileMustExist, ofOverwritePrompt];

  FFilePathParam := TdsdParam.Create(Nil);
  FFilePathParam.DataType := ftString;
  FFilePathParam.Value := '';
  FFileNameParam := TdsdParam.Create(Nil);
  FFileNameParam.DataType := ftString;
  FFileNameParam.Value := '';
  FFileExt := '.txt';
  FFileExtParam := TdsdParam.Create(Nil);
  FFileExtParam.DataType := ftString;
  FFileExtParam.Value := '';
  FFileNamePrefixParam := TdsdParam.Create(Nil);
  FFileNamePrefixParam.DataType := ftString;
  FFileNamePrefixParam.Value := '';

  FFieldDefsCDS := TClientDataSet.Create(Nil);

  FShowSaveDialog := True;
  FCreateNewFile := True;
  FExportType := spefExportToText;
end;

destructor TdsdStoredProcExportToFile.Destroy;
begin
  sdSaveFile := Nil;
  FFilePathParam.Free;
  FFileNameParam.Free;
  FFileExtParam.Free;
  FFileNamePrefixParam.Free;
  FFieldDefsCDS.Free;

  inherited;
end;

function TdsdStoredProcExportToFile.Execute: Boolean;
var
  F: TextFile;
  FilePaths: string;
  FileNames: string;
  FieldNames: string;
begin

  Result := False;
  if not Assigned(dsdStoredProcName) then
  begin
    Exit;
  end;

  FilePaths := '';
  if FilePath <> '' then
  begin
    try
      if not DirectoryExists(FilePath) then ForceDirectories(FilePath);
      if DirectoryExists(FilePath) then FilePaths := FilePath;
    except
      FilePaths := '';
    end;
  end;

  if (ShowSaveDialog = True) or (FilePaths = '') or (FileName = '') then
  begin
    //теперь будем всегда очищать
    if FExportType = spefExportToDbf then
    begin
      if FileExt <> '' then
        sdSaveFile.Filter := 'Файл DBF|*' + FileExt + '|Все файлы|*.*'
      else sdSaveFile.Filter := 'Файл DBF|*.dbf|Все файлы|*.*';
    end else
    begin
      if FileExt <> '' then
        sdSaveFile.Filter := 'Текстовый файл|*' + FileExt + '|Все файлы|*.*'
      else sdSaveFile.Filter := 'Текстовый файл|*.txt|Все файлы|*.*';
    end;
    sdSaveFile.Title := 'Укажите файл для сохранения';
    if FilePaths <> '' then sdSaveFile.InitialDir  := FilePaths;
    sdSaveFile.FileName := FileName;
    if FileExt[1] = '.' then
      sdSaveFile.DefaultExt := copy(FileExt, 2, length(FileExt) - 1)
    else sdSaveFile.DefaultExt := FileExt;

    if sdSaveFile.Execute then
    begin
      FilePaths := ExtractFilePath(sdSaveFile.FileName);
      FileNames := ExtractFileName(sdSaveFile.FileName);
    end else Exit;

  end else FileNames := FileName;

  if (ExtractFileExt(FileNames) = '') and (FileExt <> '') then
  begin
    if FileExt[1] <> '.' then FileNames := FileNames + '.';
    FileNames := FileNames + FileExt;
  end;

  FdsdStoredProcName.Execute();

  if FCreateNewFile and FileExists(FilePaths + '\' + FilenamePrefix + FileNames) then
    DeleteFile(FilePaths + '\' + FilenamePrefix + FileNames);

  if FExportType = spefExportToDbf then
  begin

     with TFileExternalSave.Create(FieldDefs,
                                   TdsdStoredProc(FdsdStoredProcName).DataSet,
                                   FilePaths + '\' + FilenamePrefix + FileNames, true) do
     try
       Execute(FileNames);
     finally
       Free
     end;
  end else
  begin

      TdsdStoredProc(FdsdStoredProcName).DataSet.First;

      //
      try
        AssignFile(F, FilePaths + '\' + FilenamePrefix + FileNames);
        Rewrite(F); // переписываем файл


        while not TdsdStoredProc(FdsdStoredProcName).DataSet.Eof do
        begin
          FieldNames := FieldNames + TdsdStoredProc(FdsdStoredProcName).DataSet.Fields[0].AsString +#13+#10;
          TdsdStoredProc(FdsdStoredProcName).DataSet.Next;
        end;
        Writeln(F, FieldNames);

      finally
        CloseFile(F);
      end;
  end;
end;

function TdsdStoredProcExportToFile.GetFieldDefs : TFieldDefs;
begin
  Result := FFieldDefsCDS.FieldDefs;
end;

procedure TdsdStoredProcExportToFile.SetFieldDefs(Value: TFieldDefs);
begin
  FFieldDefsCDS.FieldDefs.Assign(Value);
end;

function TdsdStoredProcExportToFile.GetdsdStoredProcName: TdsdStoredProc;
begin
  Result := FdsdStoredProcName;
end;

procedure TdsdStoredProcExportToFile.SetdsdStoredProcName(
  Value: TdsdStoredProc);
begin
  FdsdStoredProcName := Value;
end;

procedure TdsdStoredProcExportToFile.SetFilePath(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FilePathParam')
  else
    FFilePath := Value;
end;

function TdsdStoredProcExportToFile.GetFilePath: string;
begin
  result := FFilePathParam.AsString;
  if result = '' then
    result := FFilePath
end;

procedure TdsdStoredProcExportToFile.SetFileName(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FileFileName')
  else
    FFileName := Value;
end;

function TdsdStoredProcExportToFile.GetFileName: string;
begin
  result := FFileNameParam.AsString;
  if result = '' then
    result := FFileName
end;

procedure TdsdStoredProcExportToFile.SetFileExt(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FileExtParam')
  else
    FFileExt := Value;
end;

function TdsdStoredProcExportToFile.GetFileExt: string;
begin
  result := FFileExtParam.AsString;
  if result = '' then
    result := FFileExt;
  if result = '' then
    result := 'txt';
end;

procedure TdsdStoredProcExportToFile.SetFileNamePrefix(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FileNamePrefixParam')
  else
    FFileNamePrefix := Value;
end;

function TdsdStoredProcExportToFile.GetFileNamePrefix: string;
begin
  result := FFileNamePrefixParam.AsString;
  if result = '' then
    result := FFileNamePrefix
end;


{ TdsdPartnerMapAction }

constructor TdsdPartnerMapAction.Create(AOwner: TComponent);
begin
  inherited;
  FMapType := acShowOne;
  FIsShowRoute := False;
  FAPIKey := '';
  FAPIKeyField := '';
end;

procedure TdsdPartnerMapAction.BeforeExecute(Form: TForm);
var
  I: Integer;
begin
  if Assigned(FDataSet) then
  begin
    Form.OnClose := OnFormClose;

    for I := 0 to Form.ComponentCount - 1 do
      if Form.Components[I].ClassType = TdsdGMMap then
      begin
        FGMMap := TGMMap(Form.Components[I]);

        if FAPIKey <> '' then TdsdGMMap(Form.Components[I]).APIKey := FAPIKey
        else if Assigned(FAPIKeyStoredProc) then
        begin
          try
            FAPIKeyStoredProc.Execute;
            if FAPIKeyField <> '' then
              TdsdGMMap(Form.Components[I]).APIKey := FAPIKeyStoredProc.ParamByName(FAPIKeyField).AsString
            else if Assigned(FAPIKeyStoredProc.ParamByName('outAPIKey')) then
              TdsdGMMap(Form.Components[I]).APIKey := FAPIKeyStoredProc.ParamByName('outAPIKey').AsString
            else if FAPIKeyStoredProc.Params.Count > 0 then
              TdsdGMMap(Form.Components[I]).APIKey := FAPIKeyStoredProc.Params.Items[0].AsString
          except
          end;
        end;

        TdsdGMMap(Form.Components[I]).MapType := FMapType;
        TdsdGMMap(Form.Components[I]).DataSet := FDataSet;
        TdsdGMMap(Form.Components[I]).GPSNField := FGPSNField;
        TdsdGMMap(Form.Components[I]).GPSEField := FGPSEField;
        TdsdGMMap(Form.Components[I]).AddressField := FAddressField;
        TdsdGMMap(Form.Components[I]).InsertDateField := FInsertDateField;
        TdsdGMMap(Form.Components[I]).IsShowRoute := FIsShowRoute;
        FGMMap.Active := True;
        Break;
      end;
  end;
end;

procedure TdsdPartnerMapAction.OnFormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FGMMap) then
    FGMMap.Active := False;
end;

procedure TdsdPartnerMapAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and (AComponent = DataSet) then
    DataSet := nil;
end;

procedure TdsdPartnerMapAction.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

{ TdsdDataSetRefreshEx }

function TdsdDataSetRefreshEx.Execute: Boolean;
var
  DestBlob: AnsiString;
  NoPhotoName: string;
begin
  if Assigned(FDataSet) then
    DataSet.DisableControls;

  if Assigned(FColumn) then
    Column.PropertiesClassName := '';

  Result := inherited Execute;

  try
    if Result and Assigned(FColumn) and Assigned(FDataSet) then
      if DataSet.FindField(Column.DataBinding.FieldName) <> nil then
      begin
        DataSet.First;
        while not DataSet.Eof do
        begin
          try
            DestBlob := ReConvertConvert(DataSet.FieldByName(Column.DataBinding.FieldName).AsString);
          except
            NoPhotoName := ExtractFilePath(ParamStr(0)) + 'NoPhoto.jpg';
            if FileExists(NoPhotoName) then
              DestBlob := FileReadString(NoPhotoName)
            else
              DestBlob := '';
          end;
          DataSet.Edit;
          DataSet.FieldByName(Column.DataBinding.FieldName).AsString := DestBlob;
          DataSet.Post;
          DataSet.Next;
        end;
        DataSet.First;
        Column.PropertiesClassName := 'TcxImageProperties';
        if Column.PropertiesClass <> nil then
        begin
          (Column.Properties as TcxCustomImageProperties).GraphicClassName := 'TJPEGImage';
          (Column.Properties as TcxCustomImageProperties).Stretch := True;
        end;
      end;
  finally
    if Assigned(FDataSet) then
    begin
      DataSet.AfterScroll := nil;
      DataSet.EnableControls;
    end;
  end;

  if Timer.Enabled then
    Timer.Enabled := False;
end;

procedure TdsdDataSetRefreshEx.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if csDestroying in ComponentState then
    Exit;
  if (Operation = opRemove) and Assigned(FColumn) then
    if (AComponent is TcxGridDBColumn) and (AComponent = FColumn) then
      Column := nil;
end;

procedure TdsdDataSetRefreshEx.SetColumn(const Value: TcxGridDBColumn);
begin
  FColumn := Value;
end;

  { TdsdShowPUSHMessage }

constructor TdsdShowPUSHMessage.Create(AOwner: TComponent);
begin
  inherited;

  FPUSHMessageType := pmtResult;
end;

function TdsdShowPUSHMessage.LocalExecute: Boolean;
var
  i,j: Integer; MessageType : TPUSHMessageType; DataSet : TDataSet;
  ASpecialLighting, ABold : Boolean; ATextColor, AColor : Integer;
begin
  result := true;
  for i := 0 to StoredProcList.Count - 1 do
    if Assigned(StoredProcList[i]) then
      if Assigned(StoredProcList[i].StoredProc) then
      begin
        // Если табшит не установлен, но если установлен, то активен
        if (not Assigned(StoredProcList[i].TabSheet)) or
          (Assigned(StoredProcList[i].TabSheet) and
          (StoredProcList[i].TabSheet.PageControl.ActivePage = StoredProcList[i].TabSheet)) then
        begin
          if StoredProcList[i].StoredProc.OutputType = otDataSet then
          begin
              if StoredProcList[i].StoredProc.DataSets.Count < 1 then
              begin
                raise Exception.Create('Не указан <DataSet> в StoredProc ' + StoredProcList[i].StoredProc.Name);
                Exit;
              end;
              try
                StoredProcList[i].StoredProc.Execute;

                for J := 0 to StoredProcList[i].StoredProc.DataSets.Count - 1 do
                begin
                  DataSet := StoredProcList[i].StoredProc.DataSets.Items[j].DataSet;

                  if DataSet.IsEmpty then Continue;

                  DataSet.First;
                  while not DataSet.Eof do
                  begin

                    ASpecialLighting := False; ATextColor := clWindowText; AColor := clCream; ABold := False;

                    if not Assigned(DataSet.Fields.FindField('ShowMessage')) then
                    begin
                      raise Exception.Create('Не найден возвращаемый параметр <ShowMessage> в функции ' + StoredProcList[i].StoredProc.StoredProcName);
                      Exit;
                    end;
                    if not DataSet.FieldByName('ShowMessage').Value then Continue;

                    if Assigned(DataSet.Fields.FindField('SpecialLighting')) then
                    begin
                      ASpecialLighting := DataSet.FieldByName('SpecialLighting').Value;

                      if ASpecialLighting and Assigned(DataSet.Fields.FindField('TextColor')) then
                        ATextColor := DataSet.FieldByName('TextColor').AsInteger;

                      if ASpecialLighting and Assigned(DataSet.Fields.FindField('Color')) then
                        AColor := DataSet.FieldByName('Color').AsInteger;

                      if ASpecialLighting and Assigned(DataSet.Fields.FindField('isBold')) then
                        ABold := DataSet.FieldByName('isBold').AsBoolean;
                    end;

                    if FPUSHMessageType = pmtResult then
                    begin
                      if not Assigned(DataSet.Fields.FindField('PUSHType')) then
                      begin
                        raise Exception.Create('Не найден возвращаемый параметр <PUSHType> в функции ' + StoredProcList[i].StoredProc.StoredProcName);
                        Exit;
                      end;

                      case DataSet.FieldByName('PUSHType').AsInteger of
                        1 : MessageType := pmtWarning;
                        2 : MessageType := pmtError;
                        3 : MessageType := pmtInformation;
                        4 : MessageType := pmtConfirmation;
                        else
                        begin
                          raise Exception.Create('Неверный тип PUSH сообщения из функции ' + StoredProcList[i].StoredProc.StoredProcName);
                          Exit;
                        end;
                      end;

                    end else MessageType := FPUSHMessageType;

                    case MessageType of
                      pmtWarning : ShowPUSHMessage(DataSet.FieldByName('Text').Value, mtWarning, ASpecialLighting, ATextColor, AColor, ABold);
                      pmtError : begin
                                   ShowPUSHMessage(DataSet.FieldByName('Text').Value, mtError, ASpecialLighting, ATextColor, AColor, ABold);
                                   raise Exception.Create('Выполнение операции прервано...');
                                   Result := False;
                                   Exit;
                                 end;
                      pmtInformation : ShowPUSHMessage(DataSet.FieldByName('Text').Value, mtInformation, ASpecialLighting, ATextColor, AColor, ABold);
                      pmtConfirmation : if not ShowPUSHMessage(DataSet.FieldByName('Text').Value +
                                          IfThen(Pos('?', DataSet.FieldByName('Text').Value) = 0, #13#10#13#10'Продолжить изменение ?...', ''),
                                          mtConfirmation, ASpecialLighting, ATextColor, AColor, ABold) then
                                        begin
                                          raise Exception.Create('Выполнение операции прервано...');
                                          Result := False;
                                          exit;
                                        end;
                    end;

                    DataSet.Next;
                  end;
                end;
              except
                on E:Exception do raise Exception.Create('Ошибка вывода ПУШ ' + Self.Name + ': ' + e.Message);
              end;
          end else
          begin
            try
              StoredProcList[i].StoredProc.Execute;
              ASpecialLighting := False; ATextColor := clWindowText; AColor := clCream; ABold := False;


              if not Assigned(StoredProcList[i].StoredProc.Params.ParamByName('outShowMessage')) then
              begin
                raise Exception.Create('Не найден возвращаемый параметр <outShowMessage> в функции ' + StoredProcList[i].StoredProc.StoredProcName);
                Exit;
              end;
              if not StoredProcList[i].StoredProc.Params.ParamByName('outShowMessage').Value then Continue;

              if Assigned(StoredProcList[i].StoredProc.Params.ParamByName('outSpecialLighting')) then
              begin
                ASpecialLighting := StoredProcList[i].StoredProc.Params.ParamByName('outSpecialLighting').Value;

                if ASpecialLighting and Assigned(StoredProcList[i].StoredProc.Params.ParamByName('outTextColor')) then
                  ATextColor := StoredProcList[i].StoredProc.Params.ParamByName('outTextColor').Value;

                if ASpecialLighting and Assigned(StoredProcList[i].StoredProc.Params.ParamByName('outColor')) then
                  AColor := StoredProcList[i].StoredProc.Params.ParamByName('outColor').Value;

                if ASpecialLighting and Assigned(StoredProcList[i].StoredProc.Params.ParamByName('outBold')) then
                  ABold := StoredProcList[i].StoredProc.Params.ParamByName('outBold').Value;
              end;

              if FPUSHMessageType = pmtResult then
              begin
                if not Assigned(StoredProcList[i].StoredProc.Params.ParamByName('outPUSHType')) then
                begin
                  raise Exception.Create('Не найден возвращаемый параметр <outPUSHType> в функции ' + StoredProcList[i].StoredProc.StoredProcName);
                  Exit;
                end;

                case StoredProcList[i].StoredProc.Params.ParamByName('outPUSHType').Value of
                  1 : MessageType := pmtWarning;
                  2 : MessageType := pmtError;
                  3 : MessageType := pmtInformation;
                  4 : MessageType := pmtConfirmation;
                  else
                  begin
                    raise Exception.Create('Неверный тип PUSH сообщения из функции ' + StoredProcList[i].StoredProc.StoredProcName);
                    Exit;
                  end;
                end;

              end else MessageType := FPUSHMessageType;
            except
              on E:Exception do raise Exception.Create('Ошибка вывода ПУШ ' + Self.Name + ': ' + e.Message);
            end;

            case MessageType of
              pmtWarning : ShowPUSHMessage(StoredProcList[i].StoredProc.Params.ParamByName('outText').Value, mtWarning, ASpecialLighting, ATextColor, AColor, ABold);
              pmtError : begin
                           ShowPUSHMessage(StoredProcList[i].StoredProc.Params.ParamByName('outText').Value, mtError, ASpecialLighting, ATextColor, AColor, ABold);
                           raise Exception.Create('Выполнение операции прервано...');
                           Result := False;
                           Exit;
                         end;
              pmtInformation : ShowPUSHMessage(StoredProcList[i].StoredProc.Params.ParamByName('outText').Value, mtInformation, ASpecialLighting, ATextColor, AColor, ABold);
              pmtConfirmation : if not ShowPUSHMessage(StoredProcList[i].StoredProc.Params.ParamByName('outText').Value +
                                  IfThen(Pos('?', StoredProcList[i].StoredProc.Params.ParamByName('outText').Value) = 0, #13#10#13#10'Продолжить изменение ?...', ''),
                                  mtConfirmation, ASpecialLighting, ATextColor, AColor, ABold) then
                                begin
                                  raise Exception.Create('Выполнение операции прервано...');
                                  Result := False;
                                  exit;
                                end;
            end;
          end;
        end;
      end;
end;

{ TdsdDuplicateSearchAction }

function TdsdDuplicateSearchAction.LocalExecute: Boolean;
begin
  Result := False;

//  if Screen.ActiveControl is   then

//  ActionDuplicateSearch;

end;


{ TdsdDOCReportForm }

constructor TdsdDOCReportFormAction.Create(AOwner: TComponent);
begin
  inherited;
  FFileName := '';
  FBlankName := '';
end;

function TdsdDOCReportFormAction.LocalExecute: Boolean;
  var Stream: TStringStream; woApp, ooApp, Doc,
      StarDesktop, VariantArr, ReplaceDescriptor, SaveParams : olevariant;

  function MakePropertyValue(PropName, PropValue:string):variant;
    var Struct: variant;
  begin
    Struct := ooApp.Bridge_GetStruct('com.sun.star.beans.PropertyValue');
    Struct.Name := PropName;
    Struct.Value := PropValue;
    Result := Struct;
  end;

  function ConvertToURL(FileName:string):string;
  var
    i:integer;
    ch:char;
  begin
    Result:='';
    for i:=1 to Length(FileName) do
      begin
        ch:=FileName[i];
        case ch of
          ' ':Result:=Result+'%20';
          '\':Result:=Result+'/';
        else
          Result:=Result+ch;
        end;
      end;
    Result:='file:///'+Result;
  end;

begin
  Result := False;

  if FFileName = '' then
  begin
    ShowMessage('Не определено имя файла.');
    Exit;
  end;

//  if not Assigned(FDataSet) then
//  begin
//    ShowMessage('Не определен источник данных.');
//    Exit;
//  end;

//  if not FDataSet.Active then
//  begin
//    ShowMessage('Источник данных не открыт.');
//    Exit;
//  end;

  Stream := TStringStream.Create;

  try
    if FBlankName <> '' then
    begin
      Stream.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(FBlankName));
      Stream.SaveToFile(ExtractFilePath(ParamStr(0)) + FFileName);
    end;

    if not FileExists(ExtractFilePath(ParamStr(0)) + FFileName) then
    begin
      ShowMessage('Файл "' + ExtractFilePath(ParamStr(0)) + FFileName + '" не найден.');
      Exit;
    end;

    // Пытаемся подключиться к MS офису
    try
      woApp := GetActiveOleObject('Word.Application');
    except
      woApp := Null;
    end;

    // Создаем новый экземпляр MS офиса
    if VarIsEmpty(woApp) or VarIsNull(woApp) then
    try
      woApp := CreateOleObject('Word.Application');
    except
      woApp := Null;
    end;

    // Создаем новый экземпляр MS офиса
    if VarIsEmpty(woApp) or VarIsNull(woApp) then
    try
      woApp := CreateOleObject('Word.Application');
    except
      woApp := Null;
    end;

    // Подключаемся к OpenOffice
    if VarIsEmpty(woApp) or VarIsNull(woApp) then
    try
      ooApp := CreateOleObject('com.sun.star.ServiceManager');
    except
      ooApp := Unassigned;
    end;

    if not (VarIsEmpty(ooApp) or VarIsNull(ooApp)) then
    begin
      try
        StarDesktop := ooApp.CreateInstance('com.sun.star.frame.Desktop');
        VariantArr := VarArrayCreate([0, 0], varVariant);
        VariantArr[0] := MakePropertyValue('FilterName', 'MS Word 97');
        Doc := StarDesktop.LoadComponentFromURL(
                      ConvertToURL(ExtractFilePath(ParamStr(0)) + FFileName), '_blank', 0,
                      VariantArr);

        if Assigned(FDataSet) then if FDataSet.Active then
        begin
          if not (VarIsEmpty(Doc) or VarIsNull(Doc)) then
          begin

            FDataSet.First;
            while not FDataSet.Eof do
            begin
              if Trim(FDataSet.Fields.Fields[0].AsString) <> '' then
              begin
                ReplaceDescriptor:=Doc.createReplaceDescriptor;
                ReplaceDescriptor.setSearchString('%' + FDataSet.Fields.Fields[0].AsString + '%');
                ReplaceDescriptor.setReplaceString(FDataSet.Fields.Fields[1].AsString);
                Doc.replaceAll(ReplaceDescriptor);
              end;
              FDataSet.Next;
            end;
          end;

          SaveParams := VarArrayCreate([0, -1], varVariant);
          Doc.StoreAsUrl(ConvertToURL(ExtractFilePath(ParamStr(0)) + FFileName),SaveParams);
        end;

      finally
        ooApp := Unassigned;
      end;
    end else
    begin

      Doc := woApp.Documents.Open(ExtractFilePath(ParamStr(0)) + FFileName);

      if Assigned(FDataSet) then if FDataSet.Active then
      begin
        woApp.Selection.HomeKey($00000006);

        FDataSet.First;
        while not FDataSet.Eof do
        begin
          if Trim(FDataSet.Fields.Fields[0].AsString) <> '' then
          begin
            woApp.Selection.HomeKey($00000006);
            while woApp.Selection.Find.Execute('%' + FDataSet.Fields.Fields[0].AsString + '%')
              do woApp.Selection.TypeText(FDataSet.Fields.Fields[1].AsString);
          end;
          FDataSet.Next;
        end;
      end;

      Doc.Save;
      woApp.WindowState := 2;
      woApp.Visible:=True;
      woApp.WindowState := 1;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TdsdDOCReportFormAction.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

{ TdsdOpenStaticForm }

constructor TdsdOpenStaticForm.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(Self, TdsdParam);
  FFormNameParam := TdsdParam.Create(nil);
  FFormNameParam.DataType := ftString;
  FFormNameParam.Value := '';
  FisReturnGuiParams := False;
end;

destructor TdsdOpenStaticForm.Destroy;
begin
  FParams.Free;
  FParams := nil;
  FFormNameParam.Free;
  inherited;
end;

procedure TdsdOpenStaticForm.SetFormName(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FormNameParam')
  else
    FFormName := Value;
end;

function TdsdOpenStaticForm.GetFormName: string;
begin
  result := FFormNameParam.AsString;
  if result = '' then
    result := FFormName
end;

function TdsdOpenStaticForm.LocalExecute: Boolean;
var FormClass: TFormClass; Form: TForm;
begin
  Result := False;

  if FormName = '' then
  begin
    raise Exception.Create('Не задано имя формы.')
  end;

  FormClass := TFormClass(GetClass(FormName));

  if not Assigned(FormClass) then
  begin
    raise Exception.Create('Класс ' + FormName + ' не найден.')
  end;

  Form := FormClass.Create(Application);

  if Form is TParentForm then
    if not TParentForm(Form).Execute(Self, FParams) then
  begin
    Form.Free;
    Exit;
  end;

  if Form is TParentForm then
    if Assigned(TParentForm(Form).AddOnFormData.Params) then
      if Assigned(TParentForm(Form).AddOnFormData.Params.ParamByName('isShow')) then
        if not TParentForm(Form).AddOnFormData.Params.ParamByName('isShow').Value then
  begin
    Form.Free;
    Exit;
  end;

  begin
    if isShowModal then
    begin
      try
        if Form.ShowModal = mrOk then
          if FisReturnGuiParams and (Form is TParentForm) then
            if Assigned(TParentForm(Form).AddOnFormData.Params.Params) then
              FParams.AssignParams(TParentForm(Form).AddOnFormData.Params.Params);
      finally
        Form.Free;
      end;
    end
    else Form.Show;
  end;

  Result := True;
end;

{ TdsdDefaultParamsItem }

constructor TdsdDefaultParamsItem.Create(Collection: TCollection);
begin
  inherited;
  FValue := Null;
  FParam := TdsdParam.Create(Nil);
end;

destructor TdsdDefaultParamsItem.Destroy;
begin
  FParam.Free;
  inherited Destroy;
end;

function TdsdDefaultParamsItem.GetDisplayName: string;
begin
  result := inherited;
  if FParam.Name <> '' then result := FParam.Name
  else if Assigned(FParam.Component) then
    result := FParam.Component.Name + ' ' + FParam.ComponentItem
  else Result := inherited;;
end;

procedure TdsdDefaultParamsItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdDefaultParamsItem then
  begin
     FParam.Assign(TdsdDefaultParamsItem(Source).Param);
     FValue := TdsdDefaultParamsItem(Source).Value;
  end
  else
    inherited Assign(Source);
end;


{ TdsdDefaultParamsList }

function TdsdDefaultParamsList.Add: TdsdDefaultParamsItem;
begin
  result := TdsdDefaultParamsItem(inherited Add)
end;

function TdsdDefaultParamsList.GetItem(Index: Integer): TdsdDefaultParamsItem;
begin
  result := TdsdDefaultParamsItem(inherited GetItem(Index))
end;

procedure TdsdDefaultParamsList.SetItem(Index: Integer;
  const Value: TdsdDefaultParamsItem);
begin
  inherited SetItem(Index, Value);
end;


{ TdsdSetDefaultParams }

constructor TdsdSetDefaultParams.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultParams := TdsdDefaultParamsList.Create(Self, TdsdDefaultParamsItem);
end;

destructor TdsdSetDefaultParams.Destroy;
begin
  FDefaultParams.Free;
  FDefaultParams := nil;
  inherited;
end;

function TdsdSetDefaultParams.LocalExecute: Boolean;
 var I: Integer;
begin
  for I := 0 to FDefaultParams.Count - 1 do
    FDefaultParams.Items[I].Param.Value := FDefaultParams.Items[I].Value;

  Result := True;
end;

  {TdsdFTP}

constructor TdsdFTP.Create(AOwner: TComponent);
begin
  inherited;

  FIdFTP := TIdFTP.Create(Nil);
  FIdFTP.Passive := True;
  FIdFTP.TransferType := ftBinary;
  FIdFTP.UseExtensionDataPort := True;

  FHostParam := TdsdParam.Create(nil);
  FHostParam.DataType := ftString;
  FHostParam.Value := '';

  FPortParam := TdsdParam.Create(nil);
  FPortParam.DataType := ftInteger;
  FPortParam.Value := FIdFTP.Port;

  FUserNameParam := TdsdParam.Create(nil);
  FUserNameParam.DataType := ftString;
  FUserNameParam.Value := '';

  FPasswordParam := TdsdParam.Create(nil);
  FPasswordParam.DataType := ftString;
  FPasswordParam.Value := '';

  FDirParam := TdsdParam.Create(nil);
  FDirParam.DataType := ftString;
  FDirParam.Value := '';

  FFullFileNameParam := TdsdParam.Create(nil);
  FFullFileNameParam.DataType := ftString;
  FFullFileNameParam.Value := '';

  FFileNameFTPParam := TdsdParam.Create(nil);
  FFileNameFTPParam.DataType := ftString;
  FFileNameFTPParam.Value := '';

  FFileNameParam := TdsdParam.Create(nil);
  FFileNameParam.DataType := ftString;
  FFileNameParam.Value := '';

  FDownloadFolderParam := TdsdParam.Create(nil);
  FDownloadFolderParam.DataType := ftString;
  FDownloadFolderParam.Value := '';


end;

destructor TdsdFTP.Destroy;
begin
  FreeAndNil(FHostParam);
  FreeAndNil(FPortParam);
  FreeAndNil(FUserNameParam);
  FreeAndNil(FPasswordParam);
  FreeAndNil(FDirParam);
  FreeAndNil(FFullFileNameParam);
  FreeAndNil(FFileNameFTPParam);
  FreeAndNil(FFileNameParam);

  FreeAndNil(FIdFTP);
  inherited;
end;

function TdsdFTP.LocalExecute: Boolean;
  var FullFileName,  FileNameFTP, FileName : String;
begin
  inherited;
  Result := False;

  if (FHostParam.Value = '') or
     (FUserNameParam.Value = '') or
     (FPasswordParam.Value = '') then
  begin
    ShowMessage('Не заполнены Host, Username или Password.');
    Exit;
  end;

  if FTPOperation = ftpSend then
  begin
    if FFullFileNameParam.Value = '' then
    begin
      ShowMessage('Не определен параметр <FullFileNameParam> в котором должен быть полный путь к сохраняемому файлу на FTP.');
      Exit;
    end;

    FullFileName :=  FFullFileNameParam.Value;
    if not TFile.Exists(FullFileName) then
    begin
      ShowMessage('Файл ' + FullFileName + ' не найден.');
      Exit;
    end;

    FileName := TPath.GetFileName(FullFileName);

    if FFileNameFTPParam.Value <> '' then
    begin
      FileNameFTP := FFileNameFTPParam.Value;
      if TPath.GetExtension(FileNameFTP) = '' then
        FileNameFTP := FileNameFTP +  TPath.GetExtension(FileName);
    end else FileNameFTP := FileName;

  end else if FTPOperation = ftpDelete then
  begin

    if FFileNameParam.Value = '' then
    begin
      ShowMessage('Файл не загружался на FTP.');
      Exit;
    end;

    if FFileNameFTPParam.Value = '' then
      FileNameFTP :=  FFileNameParam.Value
    else FileNameFTP :=  FFileNameFTPParam.Value +  TPath.GetExtension(FFileNameParam.Value);

  end else
  begin
    FFullFileNameParam.Value := '';

    if FFileNameParam.Value = '' then
    begin
      ShowMessage('Файл не загружался на FTP.');
      Exit;
    end;

    if FFileNameFTPParam.Value <> '' then
    begin
      FileNameFTP :=  FFileNameFTPParam.Value;
      if TPath.GetExtension(FileNameFTP) = '' then
        FileNameFTP := FileNameFTP +  TPath.GetExtension(FFileNameParam.Value);
    end else FileNameFTP :=  FFileNameParam.Value;

    if FDownloadFolderParam.Value <> '' then
    begin
      if Pos(':', FDownloadFolderParam.Value) > 0 then  FullFileName :=  FDownloadFolderParam.Value
      else FullFileName := ExtractFilePath(Application.ExeName) + FDownloadFolderParam.Value;
    end else FullFileName := ExtractFilePath(Application.ExeName);

    if FullFileName[Length(FullFileName)] <> '\' then FullFileName := FullFileName + '\' ;
    FullFileName := FullFileName + FFileNameParam.Value;

    if not ForceDirectories(ExtractFilePath(FullFileName)) then
    begin
      ShowMessage('Ошибка создания директории для сохранения файлов. Покажите это окно системному администратору...');
      Exit;
    end;
  end;

  try
    FIdFTP.Disconnect;
    FIdFTP.Host := FHostParam.Value;
    FIdFTP.Port := FPortParam.Value;
    FIdFTP.Username := FUserNameParam.Value;
    FIdFTP.Password := FPasswordParam.Value;

    try
      FIdFTP.Connect;
    Except ON E: Exception DO
      Begin
        ShowMessage(E.Message);
        exit;
      End;
    end;

    // Изменяем директорий если надо
    try
      if FDirParam.Value <> '' then
      begin
        try
          FIdFTP.MakeDir(FDirParam.Value);
        except
        end;
        FIdFTP.ChangeDir(FDirParam.Value)
      end else FIdFTP.ChangeDir('/');
    except ON E: Exception DO
      begin
        ShowMessage(E.Message);
        exit;
      end;
    end;

    try

      case FTPOperation of
        ftpSend : begin
                    FIdFTP.Put(FullFileName,  FileNameFTP);
                    FFileNameParam.Value := FileName;
                  end;
        ftpDelete : begin
                      FIdFTP.List (nil, '-la ' + FileNameFTP, False);
                      if FIdFTP.DirectoryListing.Count > 0 then FIdFTP.Delete(FileNameFTP);
                      FFileNameParam.Value := '';
                    end;
        else begin
               FIdFTP.Get(FileNameFTP, FullFileName, True);
               FFullFileNameParam.Value := FullFileName;
             end;
      end;

    except ON E: Exception DO
      Begin
        ShowMessage(E.Message);
        exit;
      End;
    end;

    if FTPOperation = ftpDownloadAndRun then  ShellExecute(0, 'open', PChar(FullFileName), '', '', 1);
    Result := True;
  finally
    FIdFTP.Disconnect;
  end;

end;

  {TdsdDblClickAction}

procedure TdsdDblClickAction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if AComponent = FComponent then
    FComponent := nil;
  if AComponent = FAction then
    FAction := nil;
end;

procedure TdsdDblClickAction.OnDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then FOnDblClick(Sender);

  if Assigned(FAction) then
     if FAction.Enabled then
        FAction.Execute;
end;

procedure TdsdDblClickAction.SetComponent(const Value: TComponent);
 var
    CommonMethod: TMethod;
    PropInfo: PPropInfo;
begin

  if Assigned(FComponent) then
  begin
    PropInfo := GetPropInfo(FComponent.ClassInfo, 'OnDblClick');
    CommonMethod.Data := FComponent;
    if Assigned(FOnDblClick) then
    begin
      CommonMethod.Code := Pointer(@FOnDblClick);
    end else CommonMethod.Code := Nil;
    SetMethodProp(FComponent, PropInfo, CommonMethod);
    FComponent := Value;
  end;

  if Assigned(Value) then
  begin

    PropInfo := GetPropInfo(Value.ClassInfo, 'OnDblClick');
    if PropInfo <> nil then
    begin
      FComponent := Value;

      FOnDblClick := TNotifyEvent(GetMethodProp(FComponent, PropInfo));
      CommonMethod.Data := Pointer(Self);
      CommonMethod.Code := MethodAddress('OnDblClick');
      SetMethodProp(FComponent, PropInfo, CommonMethod);
    end else
    begin
      ShowMessage('Класс ' + Value.ClassName + ' не имеет метода с именем OnDblClick.')
    end;
  end;
end;


  {TdsdSendSMSAction}

constructor TdsdSendSMSAction.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FHostParam := TdsdParam.Create(nil);
  FHostParam.DataType := ftString;
  FHostParam.Value := '';

  FLoginParam := TdsdParam.Create(nil);
  FLoginParam.DataType := ftString;
  FLoginParam.Value := '';

  FPasswordParam := TdsdParam.Create(nil);
  FPasswordParam.DataType := ftString;
  FPasswordParam.Value := '';

  FPhonesParam := TdsdParam.Create(nil);
  FPhonesParam.DataType := ftString;
  FPhonesParam.Value := '';

  FMessageParam := TdsdParam.Create(nil);
  FMessageParam.DataType := ftString;
  FMessageParam.Value := '';

  FShowCostParam := TdsdParam.Create(nil);
  FShowCostParam.DataType := ftBoolean;
  FShowCostParam.Value := False;
end;

destructor TdsdSendSMSAction.Destroy;
begin
  FreeAndNil(FHostParam);
  FreeAndNil(FLoginParam);
  FreeAndNil(FPasswordParam);
  FreeAndNil(FPhonesParam);
  FreeAndNil(FMessageParam);
  FreeAndNil(FShowCostParam);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;

function TdsdSendSMSAction.LocalExecute: Boolean;
  var S : String;
begin
  inherited;
  Result := False;

  if (FHostParam.Value = '') or
     (FLoginParam.Value = '') or
     (FPasswordParam.Value = '') then
  begin
    ShowMessage('Не заполнены Host, Login или Password.');
    Exit;
  end;

  if FPhonesParam.Value = '' then
  begin
    ShowMessage('Не заполнен номер телефона.');
    Exit;
  end;

  if FMessageParam.Value = '' then
  begin
    ShowMessage('Не заполнен текст SMS.');
    Exit;
  end;

  // Узнаем стоимость сообщения
  if FShowCostParam.Value = True then
  begin
    FIdHTTP.Request.ContentType := 'application/json';
    FIdHTTP.Request.ContentEncoding := 'utf-8';
    FIdHTTP.Request.CustomHeaders.FoldLines := False;

    try
      S := FIdHTTP.Get(TIdURI.URLEncode(FHostParam.Value + '?login=' + FLoginParam.Value +
                                                           '&psw=' + FPasswordParam.Value +
                                                           '&phones=' + FPhonesParam.Value +
                                                           '&mes=' + FMessageParam.Value +
                                                           '&cost=1'));
    except
    end;

    case FIdHTTP.ResponseCode of
      200 : if Pos('error', LowerCase(S)) > 0 then
            begin
              ShowMessage(S);
              Exit
            end  else
            begin
              if MessageDlg('Стоимость отправки: ' + S + #13#10#13#10'Отправлять SMS ?...', mtInformation, mbOKCancel, 0) <> mrOk then Exit;
            end;
      else begin
             ShowMessage(S);
             Exit;
           end;
    end;
  end;

  // Непосредственно отправка

  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.CustomHeaders.FoldLines := False;

  try
    S := FIdHTTP.Get(TIdURI.URLEncode(FHostParam.Value + '?login=' + FLoginParam.Value +
                                                         '&psw=' + FPasswordParam.Value +
                                                         '&phones=' + FPhonesParam.Value +
                                                         '&mes=' + FMessageParam.Value));
  except
  end;

  case FIdHTTP.ResponseCode of
    200 : if Pos('error', LowerCase(S)) > 0 then
          begin
            ShowMessage(S);
          end else Result := True;
    else begin
           ShowMessage(S);
         end;
  end;
end;

  {TdsdSendSMSCPAAction}

constructor TdsdSendSMSCPAAction.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FHostParam := TdsdParam.Create;
  FHostParam.DataType := ftString;
  FHostParam.Value := '';

  FLoginParam := TdsdParam.Create(nil);
  FLoginParam.DataType := ftString;
  FLoginParam.Value := '';

  FPasswordParam := TdsdParam.Create(nil);
  FPasswordParam.DataType := ftString;
  FPasswordParam.Value := '';

  FPhonesParam := TdsdParam.Create(nil);
  FPhonesParam.DataType := ftString;
  FPhonesParam.Value := '';

  FMessageParam := TdsdParam.Create(nil);
  FMessageParam.DataType := ftString;
  FMessageParam.Value := '';
end;

destructor TdsdSendSMSCPAAction.Destroy;
begin
  FreeAndNil(FHostParam);
  FreeAndNil(FLoginParam);
  FreeAndNil(FPasswordParam);
  FreeAndNil(FPhonesParam);
  FreeAndNil(FMessageParam);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;

function TdsdSendSMSCPAAction.LocalExecute: Boolean;
  var S, Json : String;
  JsonToSend: TStringStream;
begin
  inherited;
  Result := False;

  if (FHostParam.Value = '') or
     (FLoginParam.Value = '') or
     (FPasswordParam.Value = '') then
  begin
    ShowMessage('Св-во.Не заполнены Host, Login или Password.');
    Exit;
  end;

  if FPhonesParam.Value = '' then
  begin
    ShowMessage('Св-во.Не заполнен номер телефона.');
    Exit;
  end;

  if FMessageParam.Value = '' then
  begin
    ShowMessage('Св-во.Не заполнен текст SMS.');
    Exit;
  end;

  // Непосредственно отправка

  S :=  FLoginParam.Value + ':' + FPasswordParam.Value;
  FIdHTTP.Request.Clear;
  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.CustomHeaders.FoldLines := False;
  FIdHTTP.Request.CustomHeaders.AddValue('Authorization', 'Basic ' + EncodeBase64(BytesOf(S)));
  FIdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

  Json := '{"source":"CC Support","destination":"' + FPhonesParam.Value +
          '","serviceType":"104","bearerType":"sms","contentType":"text/plain","content":"' +
          StringReplace(StringReplace(FMessageParam.Value, '\', '\\', [rfReplaceAll, rfIgnoreCase]), '"', '\"', [rfReplaceAll, rfIgnoreCase]) + '"}';

  JsonToSend := TStringStream.Create(Json, TEncoding.UTF8);
  try
    try
      S := FIdHTTP.Post(FHostParam.Value, JsonToSend);
    except
    end;
  finally
    JsonToSend.Free;
  end;

  case FIdHTTP.ResponseCode of
    202 : if Pos('mid', LowerCase(S)) = 0 then
          begin
            ShowMessage(S);
          end else Result := True;
    else begin
           ShowMessage(FIdHTTP.ResponseText);
         end;
  end;
end;

  {TdsdSendSMSKyivstarAction}

constructor TdsdSendSMSKyivstarAction.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := Nil;
  FIdSSLIOHandlerSocketOpenSSL := Nil;
  FUnauthorized := False;

  FAlphaName := TdsdParam.Create(nil);
  FAlphaName.DataType := ftString;
  FAlphaName.Value := '';

  FHostParam := TdsdParam.Create(nil);
  FHostParam.DataType := ftString;
  FHostParam.Value := 'https://api-gateway.kyivstar.ua';

  FEnvironmentParam := TdsdParam.Create(nil);
  FEnvironmentParam.DataType := ftString;
  FEnvironmentParam.Value := '';

  FClientIdParam := TdsdParam.Create(nil);
  FClientIdParam.DataType := ftString;
  FClientIdParam.Value := '';

  FClientSecretParam := TdsdParam.Create(nil);
  FClientSecretParam.DataType := ftString;
  FClientSecretParam.Value := '';

  FTokenParam := TdsdParam.Create(nil);
  FTokenParam.DataType := ftString;
  FTokenParam.Value := '';

  FPhonesParam := TdsdParam.Create(nil);
  FPhonesParam.DataType := ftString;
  FPhonesParam.Value := '';

  FMessageParam := TdsdParam.Create(nil);
  FMessageParam.DataType := ftString;
  FMessageParam.Value := '';

  FVersionParam := TdsdParam.Create(nil);
  FVersionParam.DataType := ftString;
  FVersionParam.Value := 'v1beta';
end;

destructor TdsdSendSMSKyivstarAction.Destroy;
begin
  FreeAndNil(FAlphaName);
  FreeAndNil(FHostParam);
  FreeAndNil(FEnvironmentParam);
  FreeAndNil(FPhonesParam);
  FreeAndNil(FMessageParam);
  FreeAndNil(FClientIdParam);
  FreeAndNil(FClientSecretParam);
  FreeAndNil(FTokenParam);
  FreeAndNil(FVersionParam);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;

procedure TdsdSendSMSKyivstarAction.CreateIdHTTP;
begin
  if Assigned(FIdSSLIOHandlerSocketOpenSSL) then FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  if Assigned(FIdHTTP) then FreeAndNil(FIdHTTP);

  FIdHTTP := TIdHTTP.Create(Nil);
  FIdHTTP.HTTPOptions := [hoKeepOrigProtocol]; // при выполнении POST Indy попытается применить протокол HTTP 1.0
  FIdHTTP.ProtocolVersion := pv1_1;            // эти настройки сохранят использование HTTP 1.1
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;
end;

function TdsdSendSMSKyivstarAction.Authentication: Boolean;
  var S : String; tmpStream: TStringStream;
      jsonObj: TJSONObject;
      jsonPair: TJSONPair;
begin

  // Authentication

  CreateIdHTTP;
  FIdHTTP.Request.Clear;
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  FIdHTTP.Request.Accept := '*/*';
  FIdHTTP.Request.AcceptEncoding := 'gzip, deflate';
  FIdHTTP.Request.Connection := 'keep-alive';
  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.BasicAuthentication := True;
  FIdHTTP.Request.Username := FClientIdParam.Value;
  FIdHTTP.Request.Password := FClientSecretParam.Value;
  FIdHTTP.Request.UserAgent:='';

  tmpStream := TStringStream.Create('grant_type=client_credentials');
  try
    try
      S := FIdHTTP.Post(FHostParam.Value + '/idp/oauth2/token', tmpStream);
    except
    end;
  finally
    tmpStream.Free;
  end;

  if FIdHTTP.ResponseCode = 200 then
  begin
    jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
    try
      jsonPair := jsonObj.Get('access_token');
      if jsonPair <> nil then
      begin
        FTokenParam.Value := jsonPair.JsonValue.Value;
        Result := True;
      end;
    finally
      FreeAndNil(jsonObj);
    end;
  end else ShowMessage(FIdHTTP.ResponseText);

end;

function TdsdSendSMSKyivstarAction.SendSMS: Boolean;
  var S, url,  Json : String; tmpStream: TStringStream;
begin
  //   Непосредственно отправка

  CreateIdHTTP;
  FIdHTTP.Request.Clear;
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.FoldLines := False;
  FIdHTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + FTokenParam.Value);
  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.Accept := '*/*';
  FIdHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
  FIdHTTP.Request.Connection := 'keep-alive';
  FIdHTTP.Request.CharSet := 'utf-8';
  FIdHTTP.Request.UserAgent:='';

  Json := '{"from":"' + FAlphaName.Value + '","to":"' + FPhonesParam.Value +
          '","text":"' + StringReplace(StringReplace(FMessageParam.Value, '\', '\\', [rfReplaceAll, rfIgnoreCase]), '"', '\"', [rfReplaceAll, rfIgnoreCase]) + '"}';

  tmpStream := TStringStream.Create(Json, TEncoding.UTF8);
  try
    try
      url := FHostParam.Value;
      if FEnvironmentParam.Value <> '' then url := url + '/' + FEnvironmentParam.Value;
      url := url + '/rest/';
      if FVersionParam.Value <> '' then url := url + '/' + FVersionParam.Value;
      url := url + '/sms';

      S := FIdHTTP.Post(url, tmpStream);
    except
    end;
  finally
    tmpStream.Free;
  end;

  case FIdHTTP.ResponseCode of
    200 : Result := True;
    401 : FUnauthorized := True;
    else ShowMessage(FIdHTTP.ResponseText);
  end;
end;

function TdsdSendSMSKyivstarAction.LocalExecute: Boolean;
  var S, Json : String;
  JsonToSend: TStringStream;
begin
  Result := False;
  FUnauthorized := False;

  if (FHostParam.Value = '') then
  begin
    ShowMessage('Св-во.Не заполнены Host.');
    Exit;
  end;

  if FPhonesParam.Value = '' then
  begin
    ShowMessage('Св-во.Не заполнен номер телефона.');
    Exit;
  end;

  if FMessageParam.Value = '' then
  begin
    ShowMessage('Св-во.Не заполнен текст SMS.');
    Exit;
  end;

  // Получаем токен если пусто
  if Trim(FTokenParam.Value) = '' then
    if not Authentication then Exit;

  if not SendSMS and FUnauthorized then
  begin
    if not Authentication then Exit;
    Result:= SendSMS;
  end
  else Result:= true;

end;

  {TdsdSetFocusedAction}

constructor TdsdSetFocusedAction.Create(AOwner: TComponent);
begin
  inherited;

  FControlNameParam := TdsdParam.Create(nil);
  FTimerFocused := TTimer.Create(Nil);
  FTimerFocused.Enabled := False;
  FTimerFocused.Interval := 300;
  FTimerFocused.OnTimer := OnTimerFocused;
  FControlNameParam.DataType := ftString;
  FControlNameParam.Value := '';
end;

destructor TdsdSetFocusedAction.Destroy;
begin
  FreeAndNil(FTimerFocused);
  FreeAndNil(FControlNameParam);

  inherited;
end;

procedure TdsdSetFocusedAction.OnTimerFocused(Sender: TObject);
  var I : integer; Item : TCollectionItem;  Control: TWinControl;

  function SetFocused(Control: TWinControl; Form : TForm): Boolean;
  begin
    if (Control.Parent <> Nil) and (Control.Parent <> Form) then SetFocused(Control.Parent, Form);
    if Control.Parent is TcxPageControl then
    begin
      TcxPageControl(Control.Parent).ActivePage := TcxTabSheet(Control);
    end else if (Control.TabStop or (Control is TcxGrid)) and not (Control is TcxPageControl) then Control.SetFocus;
    Result := ActiveControl = Control;
  end;

  function SetFocusedColumn(Column: TcxGridColumn; Form : TForm): Boolean;
  begin
    Column.Focused := True;
    if Column.GridView.Control is TWinControl then
      Result := SetFocused(TWinControl(Column.GridView.Control), Form)
    else Result := False;
  end;

begin
  if csDesigning in Self.ComponentState then
    exit;

  if Owner is TForm then if not TForm(Owner).Visible then Exit;

  FTimerFocused.Enabled := false;

  if Owner is TForm then
  begin
    for I := 0 to TForm(Owner).ComponentCount - 1 do
      if (LowerCase(TForm(Owner).Components[I].Name) = LowerCase(FControlNameParam.Value)) then
    begin
      if TForm(Owner).Components[I] is TdsdFieldFilter  then
      begin
        Control := TdsdFieldFilter(TForm(Owner).Components[I]).TextEdit;
        if Assigned(TdsdFieldFilter(TForm(Owner).Components[I]).TextEdit) and (Trim(TdsdFieldFilter(TForm(Owner).Components[I]).TextEdit.Text) <> '') then
        begin
          SetFocused(TWinControl(TdsdFieldFilter(TForm(Owner).Components[I]).TextEdit), TForm(Owner));
          Exit;
        end else
        begin
          if not Assigned(Control) then Control := TColumnFieldFilterItem(Item).TextEdit;
          for Item in TdsdFieldFilter(TForm(Owner).Components[I]).ColumnList do
            if Assigned(TColumnFieldFilterItem(Item).TextEdit) and (Trim(TColumnFieldFilterItem(Item).TextEdit.Text) <> '') then
          begin
            SetFocused(TWinControl(TColumnFieldFilterItem(Item).TextEdit), TForm(Owner));
            Exit;
          end;
        end;
        if Assigned(Control) then SetFocused(TWinControl(Control), TForm(Owner));
      end else if (TForm(Owner).Components[I] is TWinControl) then SetFocused(TWinControl(TForm(Owner).Components[I]), TForm(Owner))
      else if (TForm(Owner).Components[I] is TcxGridColumn) then SetFocusedColumn(TcxGridColumn(TForm(Owner).Components[I]), TForm(Owner));
      Break;
    end;
  end;
end;

function TdsdSetFocusedAction.LocalExecute: Boolean;
begin
  inherited;
  Result := True;

  if FControlNameParam.Value = '' then
  begin
    Result := True;
    Exit;
  end;

  FTimerFocused.Enabled := True;
end;

{ TdsdLoadListValuesFileAction }

constructor TdsdLoadListValuesFileAction.Create(AOwner: TComponent);
begin
  inherited;
  FFileOpenDialog := TFileOpenDialog.Create(Self);
  FFileOpenDialog.SetSubComponent(true);
  FFileOpenDialog.FreeNotification(Self);
  FFileOpenDialog.OkButtonLabel := 'Загрузить список товаров';
  with FFileOpenDialog.FileTypes.Add do
  begin
    DisplayName := 'Файл со списком товаров';
    FileMask := '*.xls;*.xlsx';
  end;
  FParam := TdsdParam.Create(nil);
  FParam.DataType := ftWideString;
  FParam.Value := '';
  FFileNameParam := TdsdParam.Create(nil);
  FFileNameParam.DataType := ftString;
  FFileNameParam.Value := '';
  FStartColumns := 1;
end;

destructor TdsdLoadListValuesFileAction.Destroy;
begin
  FreeAndNil(FFileOpenDialog);
  FreeAndNil(FFileNameParam);
  FreeAndNil(FParam);
  inherited;
end;

function TdsdLoadListValuesFileAction.LocalExecute: Boolean;
const
  ExcelAppName = 'Excel.Application';
var
  CLSID: TCLSID;
  Excel, Sheet: Variant;
  Row, Code : Integer;
  S, FileName : string;
begin
  result := false;
  S := '';

  if FFileNameParam.Value = '' then
  begin
    if not FFileOpenDialog.Execute then Exit;
    FileName :=  FFileOpenDialog.FileName;
  end else
  begin
    FileName:=  ExtractFilePath(ParamStr(0)) + FFileNameParam.Value;
  end;

  if not FileExists(FileName) then
  begin
    ShowMessage('Файл <' + FileName + '> не найден.');
    Exit;
  end;

  if CLSIDFromProgID(PChar(ExcelAppName), CLSID) = S_OK then
  begin
    Excel := CreateOLEObject(ExcelAppName);

    try
      Excel.Visible := False;
      Excel.Application.EnableEvents := False;
      Excel.DisplayAlerts := False;
      Excel.WorkBooks.Open(FileName);
      Sheet := Excel.WorkBooks[1].WorkSheets[1];

      for Row := FStartColumns to Sheet.UsedRange.Rows.Count do
      begin
        if TryStrToInt(Sheet.Cells[Row, 1], Code) then
        begin
          if S = '' then S := IntToStr(Code)
          else S := S + ',' + IntToStr(Code);
        end;
      end;

      Param.Value := S;

    finally
      if not VarIsEmpty(Excel) then
        Excel.Quit;

      Excel := Unassigned;
    end;
  end;
  result := true
end;

{ TdsdPreparePicturesAction }

constructor TdsdPreparePicturesAction.Create(AOwner: TComponent);
begin
  inherited;
  FPictureFields := TStringList.Create;
end;

destructor TdsdPreparePicturesAction.Destroy;
begin
  FreeAndNil(FPictureFields);
  inherited;
end;

function TdsdPreparePicturesAction.LocalExecute: Boolean;
begin
  PreparePictures;
end;

procedure TdsdPreparePicturesAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) and (FDataSet = AComponent) then FDataSet := Nil;
end;

procedure TdsdPreparePicturesAction.PreparePictures;
var I, Len: integer;
    Data : AnsiString;
    FMemoryStream: TMemoryStream;
    Ext, FieldName: string;
    GraphicClass: TGraphicClass;
    Field: TField; Graphic: TGraphic;
    DS : TDataSource;
begin
  if FPictureFields.Count = 0 then Exit;
  if not Assigned(FDataSet) then Exit;

  FMemoryStream := TMemoryStream.Create;
  try
    FDataSet.DisableControls;
    if FDataSet is TClientDataSet then
    begin
      DS := TClientDataSet(FDataSet).MasterSource;
      TClientDataSet(FDataSet).MasterSource := Nil;
    end;
    FDataSet.First;
    while not FDataSet.Eof do
    begin
      for I := 0 to FPictureFields.Count - 1 do
      begin
        Field := FDataSet.Fields.FieldByName(FPictureFields.Strings[0]);
        if Assigned(Field) and ((Field.DataType = ftMemo) OR (Field.DataType = ftWideMemo)) then
        begin
          try
            if Length(Field.AsString) > 4 then

            try
              Data := ReConvertConvert(Field.AsString);
              Ext := trim(Copy(Data, 1, 255));
              Ext := AnsiLowerCase(ExtractFileExt(Ext));
              Delete(Ext, 1, 1);

              if 'wmf' = Ext then GraphicClass := TMetafile;
              if 'emf' =  Ext then GraphicClass := TMetafile;
              if 'ico' =  Ext then GraphicClass := TIcon;
              if 'tiff' = Ext then GraphicClass := TWICImage;
              if 'tif' = Ext then GraphicClass := TWICImage;
              if 'png' = Ext then GraphicClass := TWICImage;
              if 'gif' = Ext then GraphicClass := TWICImage;
              if 'jpeg' = Ext then GraphicClass := TWICImage;
              if 'jpg' = Ext then GraphicClass := TWICImage;
              if 'bmp' = Ext then GraphicClass := Vcl.Graphics.TBitmap;
              if GraphicClass <> nil then
              begin
                Data := Copy(Data, 256, maxint);
                FDataSet.Edit;

                Len := Length(Data);
                FMemoryStream.WriteBuffer(Data[1],  Len);
                FMemoryStream.Position := 0;

    //            Graphic := TGraphicClass(GraphicClass).Create;
    //            try
    //              Graphic.LoadFromStream(FMemoryStream);
    //              FMemoryStream.Clear;
    //              Graphic.SaveToStream(FMemoryStream);
    //            finally
    //              Graphic.Free;
    //            end;

                TBlobField(Field).LoadFromStream(FMemoryStream);
                FDataSet.Post;
              end;
            except
            end;
          finally
            FMemoryStream.Clear;
          end;
        end;
      end;
      FDataSet.Next;
    end;
    FDataSet.First;
  finally
    if Assigned(DS) then TClientDataSet(FDataSet).MasterSource := DS;
    FDataSet.EnableControls;
    FMemoryStream.Free;
  end;
end;

procedure TdsdPreparePicturesAction.SetPictureFields(Value: TStrings);
begin
  FPictureFields.Assign(Value);
end;

{  TdsdSetVisibleParamsItem  }

constructor TdsdSetVisibleParamsItem.Create(Collection: TCollection);
begin
  inherited;
  FParam := TdsdParam.Create(Nil);
  FParam.DataType := ftBoolean;
end;

destructor TdsdSetVisibleParamsItem.Destroy;
begin
  FParam.Free;
  inherited Destroy;
end;

function TdsdSetVisibleParamsItem.GetDisplayName: string;
begin
  result := '';
  if Assigned(FComponent) then result := FComponent.Name;
  if Assigned(FParam.Component) then
  begin
    if Result <> '' then Result := Result + '; ';
    result := Result + FParam.Component.Name + ' ' + FParam.ComponentItem;
  end;
  if Result = '' then Result := inherited;
end;

procedure TdsdSetVisibleParamsItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdSetVisibleParamsItem then
  begin
     FParam.Assign(TdsdSetVisibleParamsItem(Source).ValueParam);
     FComponent := TdsdSetVisibleParamsItem(Source).FComponent;
  end
  else
    inherited Assign(Source);
end;

procedure TdsdSetVisibleParamsItem.SetComponent(const Value: TComponent);
begin
  if Value <> FComponent then
  begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FComponent := Value;
  end
end;

{  TdsdSetVisibleAction  }

constructor TdsdSetVisibleAction.Create(AOwner: TComponent);
begin
  inherited;
  FSetVisibleParams := TOwnedCollection.Create(Self, TdsdSetVisibleParamsItem);
end;

destructor TdsdSetVisibleAction.Destroy;
begin
  FreeAndNil(FSetVisibleParams);

  inherited;
end;

procedure TdsdSetVisibleAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) then
  begin
    for i := 0 to FSetVisibleParams.Count - 1 do
    begin
       if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component = AComponent then
            TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component := nil;
       if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Component = AComponent then
           TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Component := nil;
    end;
  end;
end;

function TdsdSetVisibleAction.LocalExecute: Boolean;
var i: integer;
begin
  inherited;
  Result := True;

  for i := 0 to FSetVisibleParams.Count - 1 do  if Assigned(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component) then
  begin
     if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component is TcxGridColumn then
     begin
       TcxGridColumn(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component).Visible := TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Value;
       TcxGridColumn(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component).VisibleForCustomization := TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Value;
     end else if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component is TdxBarButton then
     begin
        if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.DataType = ftBoolean then
          if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Value then
            TdxBarButton(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component).Visible := ivAlways
          else TdxBarButton(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component).Visible := ivNever;
     end else if IsPublishedProp(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component, 'TabVisible') then
     begin
        if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.DataType = ftBoolean
         then
         begin
          SetPropValue(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component, 'TabVisible', TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Value);
          if not TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Value and (TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component is TcxTabSheet) and
             not Assigned(TcxTabSheet(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component).PageControl.ActivePage) then
             TcxTabSheet(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component).PageControl.ActivePageIndex := 0;
         end;
     end else if IsPublishedProp(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component, 'Visible') then
     begin
        if TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.DataType = ftBoolean
         then
          SetPropValue(TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).Component, 'Visible', TdsdSetVisibleParamsItem(FSetVisibleParams.Items[i]).FParam.Value)
     end;
  end;

end;

{  TdsdPairParamsItem  }

constructor TdsdPairParamsItem.Create(Collection: TCollection);
begin
  inherited;
  FFieldName := '';
  FPairName := '';
  FDataType := ftString;
end;

function TdsdPairParamsItem.GetDisplayName: string;
begin
  result := inherited;
  if FPairName <> '' then result := FPairName
  else Result := inherited;;
end;

procedure TdsdPairParamsItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdPairParamsItem then
  begin
     FFieldName := TdsdPairParamsItem(Source).FieldName;
     FPairName := TdsdPairParamsItem(Source).PairName;
     FDataType := TdsdPairParamsItem(Source).DataType;
  end
  else
    inherited Assign(Source);
end;


{ TFilterParamCollectionItem }

constructor TFilterParamCollectionItem.Create(Collection: TCollection);
begin
  inherited;
  FFieldParam := TdsdParam.Create(Nil);
  FFieldParam.DataType := ftString;
  FValueParam := TdsdParam.Create(Nil);
end;

destructor TFilterParamCollectionItem.Destroy;
begin
  FValueParam.Free;
  FFieldParam.Free;
  inherited Destroy;
end;

function TFilterParamCollectionItem.GetDisplayName: string;
begin
  result := inherited;
  if FFieldParam.Value <> '' then
    result := FFieldParam.Value + ' = '  + FValueParam.AsString
  else if Assigned(FFieldParam.Component) then
    result := FFieldParam.Component.Name + ' ' + FFieldParam.ComponentItem
  else Result := inherited;
end;

procedure TFilterParamCollectionItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TFilterParamCollectionItem then
  begin
     FValueParam.Assign(TFilterParamCollectionItem(Source).ValueParam);
     FFieldParam.Assign(TFilterParamCollectionItem(Source).FieldParam);
  end
  else
    inherited Assign(Source);
end;

{  TdsdDataToJsonAction  }

constructor TdsdDataToJsonAction.Create(AOwner: TComponent);
begin
  inherited;
  FPairParams := TOwnedCollection.Create(Self, TdsdPairParamsItem);
  FFilterParam := TOwnedCollection.Create(Self, TFilterParamCollectionItem);;
  FJsonParam := TdsdParam.Create(Nil);
  FJsonParam.DataType := ftWideString;

  FFileOpenDialog := TFileOpenDialog.Create(Self);
  FFileOpenDialog.SetSubComponent(true);
  FFileOpenDialog.FreeNotification(Self);
  FFileOpenDialog.OkButtonLabel := 'Загрузить данные из файла';
  with FFileOpenDialog.FileTypes.Add do
  begin
    DisplayName := 'Файл с данными';
    FileMask := '*.xls;*.xlsx';
  end;
  FFileNameParam := TdsdParam.Create(nil);
  FFileNameParam.DataType := ftString;
  FFileNameParam.Value := '';
  FStartColumns := 2;

  FDataSource := Nil;
  FView := Nil;
end;

destructor TdsdDataToJsonAction.Destroy;
begin
  FreeAndNil(FFileOpenDialog);
  FreeAndNil(FFileNameParam);
  FreeAndNil(FJsonParam);
  FreeAndNil(FPairParams);
  FreeAndNil(FFilterParam);
  inherited;
end;

function TdsdDataToJsonAction.LocalExecute: Boolean;
  var JsonArray: TJSONArray;
      JSONObject: TJSONObject;

  procedure AddParamToJSON(AName: string; AValue: Variant; ADataType: TFieldType);
    var intValue: integer; n : Double;
  begin
    try
      if AValue = NULL then
        JSONObject.AddPair(LowerCase(AName), TJSONNull.Create)
      else if ADataType = ftDateTime then
        JSONObject.AddPair(LowerCase(AName), FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', AValue))
      else if ADataType = ftFloat then
      begin
        if TryStrToFloat(AValue, n) then
          JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(n))
        else
          JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
      end else if ADataType = ftInteger then
      begin
        if TryStrToInt(AValue, intValue) then
          JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(intValue))
        else
          JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
      end
      else
        JSONObject.AddPair(LowerCase(AName), TJSONString.Create(AValue));
    except
      on E:Exception do raise Exception.Create('Ошибка добавления <' + AName + '> в Json: ' + e.Message);
    end;
  end;

  procedure DataSourceExecute;
  var
    i, j : Integer;

    function isViewFilterOk : Boolean;
    var l : Integer;
    begin
      Result := FFilterParam.Count = 0;
      for l := 0 to FFilterParam.Count - 1 do
      begin
        if (TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value <> '') then
          if Assigned(TcxDBDataController(View.DataController).DataSource.DataSet.FindField(TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value)) then
            if TcxDBDataController(View.DataController).DataSource.DataSet.FieldByName(TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value).Value <> TFilterParamCollectionItem(FFilterParam.Items[l]).ValueParam.Value then Exit;
      end;
      Result := True;
    end;

    function isDataSourceFilterOk : Boolean;
    var l : Integer;
    begin
      Result := FFilterParam.Count = 0;
      for l := 0 to FFilterParam.Count - 1 do
      begin
        if (TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value <> '') then
          if Assigned(DataSource.DataSet.FindField(TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value)) then
            if DataSource.DataSet.FieldByName(TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value).Value <> TFilterParamCollectionItem(FFilterParam.Items[l]).ValueParam.Value then Exit;
      end;
      Result := True;
    end;

  begin
    if Assigned(View) then
    begin
      with TGaugeFactory.GetGauge(Caption, 0,
        View.DataController.FilteredRecordCount) do
      begin
        Start;
        View.BeginUpdate;
        try
          for i := 0 to View.DataController.FilteredRecordCount - 1 do
          begin
            View.DataController.FocusedRecordIndex :=
              View.DataController.FilteredRecordIndex[i];
            if isViewFilterOk then
            begin
              JSONObject := TJSONObject.Create;
              if FPairParams.Count > 0 then
              begin
                for j := 0 to FPairParams.Count - 1 do
                  if (TdsdPairParamsItem(FPairParams.Items[j]).PairName <> '') and (TdsdPairParamsItem(FPairParams.Items[j]).FieldName <> '') then
                  begin
                    if Assigned(TcxDBDataController(View.DataController).DataSource.DataSet.FindField(TdsdPairParamsItem(FPairParams.Items[j]).FieldName)) then
                      AddParamToJSON(TdsdPairParamsItem(FPairParams.Items[j]).PairName,
                                     TcxDBDataController(View.DataController).DataSource.DataSet.FieldByName(TdsdPairParamsItem(FPairParams.Items[j]).FieldName).Value,
                                     TcxDBDataController(View.DataController).DataSource.DataSet.FieldByName(TdsdPairParamsItem(FPairParams.Items[j]).FieldName).DataType)
                    else AddParamToJSON(TdsdPairParamsItem(FPairParams.Items[j]).PairName, Null, ftString);
                  end;
              end else
              begin
                for j := 0 to TcxDBDataController(View.DataController).DataSource.DataSet.FieldCount - 1 do
                  AddParamToJSON(TcxDBDataController(View.DataController).DataSource.DataSet.Fields.Fields[J].DisplayText,
                                 TcxDBDataController(View.DataController).DataSource.DataSet.Fields.Fields[J].Value,
                                 TcxDBDataController(View.DataController).DataSource.DataSet.Fields.Fields[J].DataType);
              end;
              JsonArray.AddElement(JSONObject);
            end;
            IncProgress(1);
          end;
        finally
          View.EndUpdate;
          Finish;
        end;
      end;
    end
    else if Assigned(DataSource) then
    begin
      if Assigned(DataSource.DataSet) and DataSource.DataSet.Active and
        (DataSource.DataSet.RecordCount > 0) then
      begin
        DataSource.DataSet.First;
        with TGaugeFactory.GetGauge(Caption, 0,
          DataSource.DataSet.RecordCount) do
        begin
          Start;
          DataSource.DataSet.DisableControls;
          try
            while not DataSource.DataSet.Eof do
            begin
              if isDataSourceFilterOk then
              begin
                JSONObject := TJSONObject.Create;
                if FPairParams.Count > 0 then
                begin
                  for j := 0 to FPairParams.Count - 1 do
                    if (TdsdPairParamsItem(FPairParams.Items[j]).PairName <> '') and (TdsdPairParamsItem(FPairParams.Items[j]).FieldName <> '') then
                    begin
                      if Assigned(DataSource.DataSet.FindField(TdsdPairParamsItem(FPairParams.Items[j]).FieldName)) then
                        AddParamToJSON(TdsdPairParamsItem(FPairParams.Items[j]).PairName,
                                       DataSource.DataSet.FieldByName(TdsdPairParamsItem(FPairParams.Items[j]).FieldName).Value,
                                       DataSource.DataSet.FieldByName(TdsdPairParamsItem(FPairParams.Items[j]).FieldName).DataType)
                      else AddParamToJSON(TdsdPairParamsItem(FPairParams.Items[j]).PairName, Null, ftString);
                    end;
                end else
                begin
                  for j := 0 to DataSource.DataSet.FieldCount - 1 do
                    AddParamToJSON(DataSource.DataSet.Fields.Fields[J].FieldName,
                                   DataSource.DataSet.Fields.Fields[J].Value,
                                   DataSource.DataSet.Fields.Fields[J].DataType);
                end;
                JsonArray.AddElement(JSONObject);
              end;
              IncProgress(1);
              DataSource.DataSet.Next
            end;
          finally
            DataSource.DataSet.EnableControls;
            Finish;
          end;
        end;
      end;
    end;
  end;

  function ConvertToValue(AValue: String; ADataType: TFieldType) : Variant;
    var intValue: integer; n : Double; d : TDateTime;
  begin
    try
      if ADataType = ftDateTime then
      begin
        if TryStrToDateTime(AValue, d) then
          Result := d
        else
          Result := Null;
      end else if ADataType = ftFloat then
      begin
        if TryStrToFloat(AValue, n) then
          Result := n
        else
          Result := Null;
      end else if ADataType = ftInteger then
      begin
        if TryStrToInt(AValue, intValue) then
          Result := intValue
        else
          Result := Null;
      end
      else Result := AValue;
    except
      on E:Exception do raise Exception.Create('Ошибка преобразования <' + AValue + '>. ' + e.Message);
    end;
  end;

  procedure XLSExecute;
  const
    ExcelAppName = 'Excel.Application';
  var
    CLSID: TCLSID;
    Excel, Sheet: Variant;
    Row, Code, j : Integer;
    S, FileName : string;

    function ConvertLaterToNum(ALater : String) : Integer;
      var I, J, n : Integer;
    begin
      ALater := UpperCase(ALater);
      Result := 0;
      n := 0;
      if ALater = '' then Exit;

      for I := 1 to Length(ALater) do
      begin
        J := ORD(ALater[I]) - 64;

        if (J <= 0) or (J > 26) then
          raise Exception.Create('Ошибка получения данных колонки <' + ALater + '>');

        n := n + J * Round(Power (26, Length(ALater) - I));
      end;

      Result := n;
    end;

    function isXLSFilterOk : Boolean;
    var l : Integer;
    begin
      Result := FFilterParam.Count = 0;
      for l := 0 to FFilterParam.Count - 1 do
      begin
        if (TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value <> '') then
          if Sheet.Cells[Row, ConvertLaterToNum(TFilterParamCollectionItem(FFilterParam.Items[l]).FieldParam.Value)].Value <> TFilterParamCollectionItem(FFilterParam.Items[l]).ValueParam.Value then Exit;
      end;
      Result := True;
    end;

  begin

    if FFileNameParam.Value = '' then
    begin
      if not FFileOpenDialog.Execute then Exit;
      FileName :=  FFileOpenDialog.FileName;
    end else
    begin
      FileName:=  ExtractFilePath(ParamStr(0)) + FFileNameParam.Value;
    end;

    if not FileExists(FileName) then
    begin
      ShowMessage('Файл <' + FileName + '> не найден.');
      Exit;
    end;

    if CLSIDFromProgID(PChar(ExcelAppName), CLSID) = S_OK then
    begin
      Excel := CreateOLEObject(ExcelAppName);

      try
        Excel.Visible := False;
        Excel.Application.EnableEvents := False;
        Excel.DisplayAlerts := False;
        Excel.WorkBooks.Open(FileName);
        Sheet := Excel.WorkBooks[1].WorkSheets[1];

        with TGaugeFactory.GetGauge(Caption, 0,
          Sheet.UsedRange.Rows.Count) do
        begin
          Start;
          try
            for Row := FStartColumns to Sheet.UsedRange.Rows.Count do
            begin

              if FPairParams.Count > 0 then
              begin
                if isXLSFilterOk then
                begin
                  JSONObject := TJSONObject.Create;
                  for j := 0 to FPairParams.Count - 1 do
                    if (TdsdPairParamsItem(FPairParams.Items[j]).PairName <> '') and (TdsdPairParamsItem(FPairParams.Items[j]).FieldName <> '') then
                    begin
                      AddParamToJSON(TdsdPairParamsItem(FPairParams.Items[j]).PairName,
                        ConvertToValue(Sheet.Cells[Row, ConvertLaterToNum(TdsdPairParamsItem(FPairParams.Items[j]).FieldName)].Value, TdsdPairParamsItem(FPairParams.Items[j]).DataType),
                        TdsdPairParamsItem(FPairParams.Items[j]).DataType);
                    end;
                  JsonArray.AddElement(JSONObject);
                end;
                IncProgress(1);
              end

            end;
          finally
            Finish;
          end;
        end;

      finally
        if not VarIsEmpty(Excel) then
          Excel.Quit;

        Excel := Unassigned;
      end;
    end;
  end;


begin

  result := False;
  if Assigned(DataSource) or Assigned(View) or (FPairParams.Count > 0)  then
  begin
    JSONArray := TJSONArray.Create();
    try
      try
         if Assigned(DataSource) or Assigned(View) then DataSourceExecute
         else XLSExecute;
      except
        on E:Exception do raise Exception.Create('Ошибка формирования Json: ' + e.Message);
      end;
      FJsonParam.Value := JSONArray.ToString;
      result := FJsonParam.Value <> '';
    finally
      JSONArray.Free;
    end;
  end;
end;

procedure TdsdDataToJsonAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove)  then
  begin
    if FJsonParam.Component = AComponent then
      FJsonParam.Component := nil;

    for i := 0 to FFilterParam.Count - 1 do
    begin
       if TFilterParamCollectionItem(FFilterParam.Items[i]).FieldParam.Component = AComponent then
            TFilterParamCollectionItem(FFilterParam.Items[i]).FieldParam.Component := nil;
       if TdsdSetVisibleParamsItem(FFilterParam.Items[i]).ValueParam.Component = AComponent then
           TFilterParamCollectionItem(FFilterParam.Items[i]).ValueParam.Component := nil;
    end;
  end;
end;

procedure TdsdDataToJsonAction.SetDataSource(const Value: TDataSource);
begin
  if Assigned(View) and Assigned(Value) then
  begin
    ShowMessage('Установлен View. Нельзя установить DataSource');
    exit;
  end;
  FDataSource := Value;
end;

procedure TdsdDataToJsonAction.SetView(const Value: TcxGridTableView);
begin
  if Assigned(DataSource) and Assigned(Value) then
  begin
    ShowMessage('Установлен DataSource. Нельзя установить View');
    exit;
  end;
  FView := Value;
end;

  {TdsdSendSMSKyivstarAction}

constructor TdsdSendTelegramBotAction.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

//  FSendType := tbSendMessage;

  FBaseURLParam := TdsdParam.Create(nil);
  FBaseURLParam.DataType := ftString;
  FBaseURLParam.Value := 'https://api.telegram.org';

  FTokenParam := TdsdParam.Create(nil);
  FTokenParam.DataType := ftString;
  FTokenParam.Value := '';

  FChatIdParam := TdsdParam.Create(nil);
  FChatIdParam.DataType := ftString;
  FChatIdParam.Value := '';

  FMessageParam := TdsdParam.Create(nil);
  FMessageParam.DataType := ftString;
  FMessageParam.Value := '';

  FisSeendParam := TdsdParam.Create(nil);
  FisSeendParam.DataType := ftBoolean;
  FisSeendParam.Value := True;

  FisErroeSendParam := TdsdParam.Create(nil);
  FisErroeSendParam.DataType := ftBoolean;
  FisErroeSendParam.Value := False;

  FErrorParam := TdsdParam.Create(nil);
  FErrorParam.DataType := ftString;
  FErrorParam.Value := '';

//  FFileNameParam := TdsdParam.Create(nil);
//  FFileNameParam.DataType := ftString;
//  FFileNameParam.Value := '';
//  FCaptionFileParam := TdsdParam.Create(nil);
//  FCaptionFileParam.DataType := ftString;
//  FCaptionFileParam.Value := '';

end;

destructor TdsdSendTelegramBotAction.Destroy;
begin
  FreeAndNil(FBaseURLParam);
  FreeAndNil(FTokenParam);
  FreeAndNil(FMessageParam);

  FreeAndNil(FChatIdParam);
//  FreeAndNil(FFileNameParam);
//  FreeAndNil(FCaptionFileParam);

  FreeAndNil(FisSeendParam);
  FreeAndNil(FisErroeSendParam);
  FreeAndNil(FErrorParam);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;

procedure TdsdSendTelegramBotAction.SetError(AError : String);
begin
  FisErroeSendParam.Value := True;
  FErrorParam.Value := AError;
end;

function TdsdSendTelegramBotAction.LocalExecute: Boolean;
  var S, Json : String;
  JsonToSend: TStringStream;
begin
  Result := False;
  FisErroeSendParam.Value := False;
  FErrorParam.Value := '';
  try

    if FisSeendParam.Value = False then
    begin
      Result := True;
      Exit;
    end;


    if (FBaseURLParam.Value = '') then
    begin
      SetError('Св-во.Не заполнены Host.');
      Exit;
    end;

    if FTokenParam.Value = '' then
    begin
      SetError('Св-во.Не заполнен токен бота.');
      Exit;
    end;

    if FChatIdParam.Value = '' then
    begin
      SetError('Св-во.Не заполнен чат ID пользователя.');
      Exit;
    end;

//    if FSendType = tbSendMessage then
//    begin

      if FMessageParam.Value = '' then
      begin
        SetError('Св-во.Не заполнен текст сообщения.');
        Exit;
      end;

//    end else
//    begin
//      if FFileNameParam.Value = '' then
//      begin
//        ShowMessage('Св-во.Не заполнено имя файла.');
//        Exit;
//      end;
//
//      if not FileExists(FFileNameParam.Value) then
//      begin
//        ShowMessage('Св-во.Файл <' + FFileNameParam.Value + '> не найден.');
//        Exit;
//      end;
//    end;
//

    Result := SendMessage;

//    case FSendType of
//      tbSendMessage : SendMessage;
//      else SendFile;
//    end;

  finally
    if FisErroeSendParam.Value = true then
      ShowMessage(FErrorParam.Value);
  end;
end;

function TdsdSendTelegramBotAction.InitBot : Boolean;
  var jsonObj: TJSONObject; jsonPair: TJSONPair; S : String;
begin

  Result := False;

  FIdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  FIdHTTP.Request.ContentEncoding := 'utf-8';

  try
    S := FIdHTTP.Get(TIdURI.URLEncode(FBaseURLParam.Value + '/bot' + FTokenParam.Value + '/GetMe'));
  except
  end;


  if FIdHTTP.ResponseCode = 200 then
  begin
    jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
    try
      jsonPair := jsonObj.Get('ok');
      if jsonPair <> nil then
      begin
        Result := jsonPair.JsonValue.ToString = 'true';
      end;
      if not Result then
      begin
        jsonPair := jsonObj.Get('description');
        if jsonPair <> nil then
        begin
          SetError(jsonPair.JsonValue.ToString);
        end else SetError(jsonObj.ToString);
      end;
    finally
      FreeAndNil(jsonObj);
    end;
  end else SetError(FIdHTTP.ResponseText);
end;

function TdsdSendTelegramBotAction.SendMessage : Boolean;
  var jsonObj: TJSONObject; jsonPair: TJSONPair; S, str : String;
begin

  Result := False;

  FIdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  FIdHTTP.Request.ContentEncoding := 'utf-8';

  str := StringReplace(FMessageParam.Value, '&', '??',[rfReplaceAll, rfIgnoreCase]);

  try
    S := FIdHTTP.Get(TIdURI.URLEncode(FBaseURLParam.Value + '/bot' + FTokenParam.Value + '/sendMessage' +
      '?chat_id=' + FChatIdParam.Value + '&text=' + str));
  except
  end;

  if FIdHTTP.ResponseCode = 200 then
  begin
    jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
    try
      jsonPair := jsonObj.Get('ok');
      if jsonPair <> nil then
      begin
        Result := jsonPair.JsonValue.ToString = 'true';
      end;
      if not Result then
      begin
        jsonPair := jsonObj.Get('description');
        if jsonPair <> nil then
        begin
          SetError(jsonPair.JsonValue.ToString);
        end else SetError(jsonObj.ToString);
      end;
    finally
      FreeAndNil(jsonObj);
    end;
  end else SetError(FIdHTTP.ResponseText);
end;

//function TdsdSendTelegramBotAction.SendFile : Boolean;
//  var jsonObj: TJSONObject; jsonPair: TJSONPair; S : String;
//      FormData: TIdMultiPartFormDataStream;
//      Source: TFileStream;
//begin
//
//  Result := False;
//
//  FIdHTTP.Request.ContentType := 'multipart/form-data';
//  FIdHTTP.Request.ContentEncoding := 'utf-8';
//  FIdHTTP.Request.CharSet:='utf8';
//  FIdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';
//  FIdHTTP.Request.AcceptLanguage:='ru-RU,ru;q=0.9,en;q=0.8';
//  FIdHTTP.Request.AcceptEncoding:='gzip, deflate';
//  FIdHTTP.Request.Connection:='Keep-Alive';
//
// FIdHTTP.Request.UserAgent:='Opera/9.80 (Windows NT 6.1; WOW64; MRA 8.1 (build 6347)) Presto/2.12.388 Version/12.15';
//            FIdHTTP.Request.Accept:='text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/webp, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1';
//            FIdHTTP.Request.AcceptLanguage:='ru-RU,ru;q=0.9,en;q=0.8';
//            FIdHTTP.Request.AcceptEncoding:='gzip, deflate';
//            FIdHTTP.Request.Referer:='http://rghost.ru/';
//            FIdHTTP.Request.Connection:='Keep-Alive';
//  FormData := TIdMultiPartFormDataStream.Create;
////  FormData.AddFormField('utf8', '&#x2713;');
//  case FSendType of
//    tbSendDocument : FormData.AddFile ('document', FFileNameParam.Value, 'multipart/form-data');
//    tbSendPhoto : FormData.AddFile ('photo', FFileNameParam.Value, 'multipart/form-data');
//  end;
//  FormData.AddFormField ('chat_id', FChatId.Value, 'utf-8');
//  FormData.AddFormField ('caption', FCaptionFileParam.Value, 'utf-8');
//
////    FIdHTTP.Request.Accept := '*/*';
////  FIdHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
////  FIdHTTP.Request.Connection := 'keep-alive';
////  FIdHTTP.Request.CharSet := 'utf-8';
////  FIdHTTP.Request.UserAgent:='';
////FIdHTTP.HTTPOptions := FIdHTTP.HTTPOptions + [hoKeepOrigProtocol];
////
//
//
////  Source := TFileStream.Create(FFileNameParam.Value, fmOpenRead);
////   SetString(Result, PAnsiChar(Source.Memory), Source.Size);       // StreamToString
//
//  try
//    try
//      case FSendType of
//        tbSendDocument : S := FIdHTTP.POST(TIdURI.URLEncode(FBaseURLParam.Value + '/bot' + FTokenParam.Value + '/sendDocument'), FormData);
//        tbSendPhoto : S := FIdHTTP.POST(TIdURI.URLEncode(FBaseURLParam.Value + '/bot' + FTokenParam.Value + '/sendPhoto'), FormData);
////        tbSendDocument : S := FIdHTTP.POST(TIdURI.URLEncode(FBaseURLParam.Value + '/bot' + FTokenParam.Value + '/sendDocument' +
////          '?chat_id=' + FChatId.Value + '&caption=' + FCaptionFileParam.Value)+ '&document=', + FFileNameParam.Value);
////        tbSendPhoto : S := FIdHTTP.POST(TIdURI.URLEncode(FBaseURLParam.Value + '/bot' + FTokenParam.Value + '/sendPhoto' +
////          '?chat_id=' + FChatId.Value + '&caption=' + FCaptionFileParam.Value)+ '&photo=', + FFileNameParam.Value);
//      end;
//    except
//    end;
//  finally
//    FormData.Free;
////    Source.Free;
//  end;
//
//  if FIdHTTP.ResponseCode = 200 then
//  begin
//    jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
//    try
//      jsonPair := jsonObj.Get('ok');
//      if jsonPair <> nil then
//      begin
//        Result := jsonPair.JsonValue.ToString = 'true';
//      end;
//      if not Result then
//      begin
//        jsonPair := jsonObj.Get('description');
//        if jsonPair <> nil then
//        begin
//          ShowMessage(jsonPair.JsonValue.ToString);
//        end else ShowMessage(jsonObj.ToString);
//      end;
//    finally
//      FreeAndNil(jsonObj);
//    end;
//  end else ShowMessage(FIdHTTP.ResponseText);
//end;

  {TdsdSendClipboardAction}

constructor TdsdSendClipboardAction.Create(AOwner: TComponent);
begin
  inherited;

  FParam := TdsdParam.Create(nil);
  FParam.DataType := ftString;
  FParam.Value := '';
end;

destructor TdsdSendClipboardAction.Destroy;
begin
  FreeAndNil(FParam);

  inherited;
end;

function TdsdSendClipboardAction.LocalExecute: Boolean;
  var S, Json : String;
  JsonToSend: TStringStream;
begin
  Result := True;

  if FParam.Value <> '' then Clipboard.AsText := FParam.Value;

end;

{ TdsdSetEnabledParamsItem }

constructor TdsdSetEnabledParamsItem.Create(Collection: TCollection);
begin
  inherited;
  FParam := TdsdParam.Create(Nil);
  FParam.DataType := ftBoolean;
end;

destructor TdsdSetEnabledParamsItem.Destroy;
begin
  FParam.Free;
  inherited Destroy;
end;

function TdsdSetEnabledParamsItem.GetDisplayName: string;
begin
  if Assigned(FComponent) then result := FComponent.Name
  else Result := inherited;

  if Assigned(FParam.Component) then
    result := Result + ' ' + FParam.Component.Name + ' ' + FParam.ComponentItem
  else if Assigned(FParam.Component) and (FParam.Value <> '') then result := Result + ' ' + FParam.Value;
end;

procedure TdsdSetEnabledParamsItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdSetEnabledParamsItem then
  begin
     FParam.Assign(TdsdSetEnabledParamsItem(Source).ValueParam);
     FComponent := TdsdSetEnabledParamsItem(Source).FComponent;
  end
  else
    inherited Assign(Source);
end;

procedure TdsdSetEnabledParamsItem.SetComponent(const Value: TComponent);
begin
  if Value <> FComponent then
  begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FComponent := Value;
  end
end;

{  TdsdSetEnabledAction  }

constructor TdsdSetEnabledAction.Create(AOwner: TComponent);
begin
  inherited;
  FSetEnabledParams := TOwnedCollection.Create(Self, TdsdSetEnabledParamsItem);
end;

destructor TdsdSetEnabledAction.Destroy;
begin
  FreeAndNil(FSetEnabledParams);

  inherited;
end;

procedure TdsdSetEnabledAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) then
  begin
    for i := 0 to FSetEnabledParams.Count - 1 do
    begin
       if TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component = AComponent then
            TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component := nil;
       if TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).FParam.Component = AComponent then
           TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).FParam.Component := nil;
    end;
  end;
end;

function TdsdSetEnabledAction.LocalExecute: Boolean;
var i: integer;
begin
  inherited;
  Result := True;

  for i := 0 to FSetEnabledParams.Count - 1 do  if Assigned(TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component) then
  begin
     if TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component is TcxGridColumn then
     begin
       TcxGridColumn(TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component).Options.Editing := TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).FParam.Value;
     end else if IsPublishedProp(TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component, 'Enabled') then
     begin
        if TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).FParam.DataType = ftBoolean then
          SetPropValue(TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).Component, 'Enabled', TdsdSetEnabledParamsItem(FSetEnabledParams.Items[i]).FParam.Value)
     end;
  end;

end;

{ TdsdRunAction }


function TdsdRunAction.LocalExecute: Boolean;
var i: integer;
begin
  inherited;
  Result := False;

  if Assigned(FRunTask) then
  begin
    FRunTask(Self);
    Result := True;
  end else raise Exception.Create('Не определена функция для выполнения.');

end;

{  TdsdUpdateFieldItem  }


function TdsdUpdateFieldItem.GetDisplayName: string;
begin
  if (FFieldNameFrom <> '') or (FFieldNameTo <> '') then result := FFieldNameFrom + ' -> ' + FFieldNameTo
  else Result := inherited;
end;

procedure TdsdUpdateFieldItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdUpdateFieldItem then
  begin
     FFieldNameFrom := TdsdUpdateFieldItem(Source).FieldNameFrom;
     FFieldNameTo := TdsdUpdateFieldItem(Source). FieldNameTo;
  end
  else
    inherited Assign(Source);
end;

{  TdsdFDPairParamsItem  }

constructor TdsdFDPairParamsItem.Create(Collection: TCollection);
begin
  inherited;
  FFieldName := '';
  FPairName := '';
end;

function TdsdFDPairParamsItem.GetDisplayName: string;
begin
  result := inherited;
  if FPairName <> '' then result := FPairName
  else Result := inherited;;
end;

procedure TdsdFDPairParamsItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdPairParamsItem then
  begin
     FFieldName := TdsdPairParamsItem(Source).FieldName;
     FPairName := TdsdPairParamsItem(Source).PairName;
  end
  else
    inherited Assign(Source);
end;

  {TdsdForeignData}

constructor TdsdForeignData.Create(AOwner: TComponent);
begin
  inherited;

  FZConnection := TZConnection.Create(Self);
  FZConnection.SetSubComponent(true);
  FZConnection.FreeNotification(Self);
  FZQuery := TZQuery.Create(Self);
  FZQuery.Connection := FZConnection;

  FHostParam := TdsdParam.Create(nil);
  FHostParam.DataType := ftString;
  FHostParam.Value := '';

  FPortParam := TdsdParam.Create(nil);
  FPortParam.DataType := ftInteger;
  FPortParam.Value := 3306;

  FDataBase := TdsdParam.Create(nil);
  FDataBase.DataType := ftString;
  FDataBase.Value := '';

  FUserNameParam := TdsdParam.Create(nil);
  FUserNameParam.DataType := ftString;
  FUserNameParam.Value := '';

  FPasswordParam := TdsdParam.Create(nil);
  FPasswordParam.DataType := ftString;
  FPasswordParam.Value := '';

  FSQLParam := TdsdParam.Create(nil);
  FSQLParam.DataType := ftString;
  FSQLParam.Value := '';

  FJsonParam := TdsdParam.Create(nil);
  FJsonParam.DataType := ftWideString;
  FJsonParam.Value := '';

  FParams := TdsdParams.Create(Self, TdsdParam);
  FUpdateFields := TCollection.Create(TdsdUpdateFieldItem);

  FPairParams := TCollection.Create(TdsdFDPairParamsItem);

  FTypeTransaction := ttSelect;
  FOperation := fdoDataSet;
  FIdFieldFrom := '';
  FIdFieldTo := '';
  FMultiExecuteCount := 1000;
  FHideError := False;
  FParamBollToInt := False;
  FShowGaugeForm := True;
end;

destructor TdsdForeignData.Destroy;
begin
  FreeAndNil(FHostParam);
  FreeAndNil(FPortParam);
  FreeAndNil(FDataBase);
  FreeAndNil(FUserNameParam);
  FreeAndNil(FPasswordParam);
  FreeAndNil(FSQLParam);
  FreeAndNil(FJsonParam);

  FreeAndNil(FUpdateFields);
  FreeAndNil(FParams);
  FreeAndNil(FZQuery);
  FreeAndNil(FZConnection);
  inherited;
end;

function TdsdForeignData.LocalExecute: Boolean;
  var I, nCount : Integer; isUpdate : Boolean;
      JsonArray: TJSONArray;
      JSONObject: TJSONObject;

  function AdaptStr(S: string): string;
  var
    C: Char;
    Code: SmallInt;
  begin
    Result := '';

    for C in S do
    begin
      Code := Ord(C);

      if Code = 188 then
        Result := Result + '1/4'
      else if Code = 189 then
        Result := Result + '1/2'
      else if Code = 190 then
        Result := Result + '3/4'
      else if ((Code = 822) or (Code = -4051)) and (dsdProject = prFarmacy) then
        Result := Result + '-'
      else if ((Code = 945) or (Code = 593) or (Code = -3999)) and (dsdProject = prFarmacy) then
        Result := Result + 'a'
      else if (Code = 946) and (dsdProject = prFarmacy) then
        Result := Result + 'b'
      else if (Code = 947) and (dsdProject = prFarmacy) then
        Result := Result + 'y'
      else if ((Code = 180) or (Code = 8125) or (Code = 700)) and (dsdProject = prFarmacy) then
        Result := Result + ''''
//      else if ((Code <= 0) or (Code >= 822) and (Code < 1000)) and (dsdProject = prFarmacy) then
//        Result := Result  + C
      else
        Result := Result + C;
    end;
  end;

  procedure AddParamToJSON(AName: string; AValue: Variant; ADataType: TFieldType);
    var intValue: integer; n : Double;
  begin
    try
      if AValue = NULL then
        JSONObject.AddPair(LowerCase(AName), TJSONNull.Create)
      else if ADataType = ftDateTime then
        JSONObject.AddPair(LowerCase(AName), FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', AValue))
      else if ADataType = ftFloat then
      begin
        if TryStrToFloat(AValue, n) then
          JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(n))
        else
          JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
      end else if ADataType in [ftInteger, ftSmallint] then
      begin
        if TryStrToInt(AValue, intValue) then
          JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(intValue))
        else
          JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
      end
      else
      begin
        JSONObject.AddPair(LowerCase(AName), TJSONString.Create(AdaptStr(AValue)));
      end;
    except
      on E:Exception do raise Exception.Create('Ошибка добавления <' + AName + '> в Json: ' + e.Message);
    end;
  end;

begin
  inherited;

  Result := FHideError;

  FZQuery.Close;
  FZConnection.Disconnect;

  if not Assigned(FDataSet) and (FTypeTransaction = ttSelect) and not (FOperation in [fdoToJSON, fdoMultiExecuteJSON]) then
  begin
    ShowMessage('Ошибка. Не определен DataSet.');
    Exit;
  end;

  if (FOperation = fdoUpdateDataSet) and ((FIdFieldFrom = '') or (FIdFieldTo = '')) then
  begin
    ShowMessage('Ошибка. Не определены Id источника или получателя.');
    Exit;
  end;

  if (FOperation = fdoUpdateDataSet) and (FUpdateFields.Count = 0) then
  begin
    ShowMessage('Ошибка. Не определены поля для обновления.');
    Exit;
  end;

  if (FOperation = fdoMultiExecuteJSON) and not Assigned(FMultiExecuteAction) then
  begin
    ShowMessage('Ошибка. Не определены акшин обновления.');
    Exit;
  end;

  if FHostParam.Value <> '' then FZConnection.HostName := FHostParam.Value;
  if FPortParam.Value <> 0 then FZConnection.Port := FPortParam.Value;
  if FDataBase.Value <> '' then FZConnection.Database := FDataBase.Value;
  if FUserNameParam.Value <> '' then FZConnection.User := FUserNameParam.Value;
  if FPasswordParam.Value <> '' then FZConnection.Password := FPasswordParam.Value;

  try
    FZConnection.Connect;
  Except ON E: Exception DO
    Begin
      if not FHideError then ShowMessage(E.Message);
      exit;
    End;
  end;

  try
    if FSQLParam.Value <> '' then FZQuery.SQL.Text := FSQLParam.Value;

    for I := 0 to FParams.Count - 1 do
      if FParamBollToInt and (FParams.Items[I].DataType = ftBoolean) then
        FZQuery.ParamByName(FParams.Items[I].Name).Value := IfThen(FParams.Items[I].Value, 1, 0)
      else FZQuery.ParamByName(FParams.Items[I].Name).Value := FParams.Items[I].Value;

    if FTypeTransaction = ttSelect then
    begin

      try
        FZQuery.Open;
        if FZQuery.Fields.Count = 0 then Exit;
      Except ON E: Exception DO
        Begin
          if not FHideError then ShowMessage(E.Message);
          exit;
        End;
      end;

      if FOperation = fdoDataSet then
      begin
        FDataSet.DisableControls;
        try
          if FDataSet.Active then FDataSet.Close;
          FDataSet.FieldDefs.Clear;

          FDataSet.FieldDefs.Assign(FZQuery.FieldDefs);
          for I := 0 to FDataSet.FieldDefs.Count - 1 do FDataSet.FieldDefs.Items[I].Attributes := [];
          FDataSet.CreateDataSet;

          with TGaugeFactory.GetGauge(Caption, 0, FZQuery.RecordCount) do
          begin
            if FShowGaugeForm then Start;
            try
              FZQuery.First;
              while not FZQuery.Eof do
              begin

                if FShowGaugeForm then IncProgress(1);

                FDataSet.Append;
                for I := 0 to FZQuery.FieldCount - 1 do
                  FDataSet.Fields.Fields[I].AsVariant := FZQuery.Fields.Fields[I].AsVariant;
                FDataSet.Post;

                FZQuery.Next;
              end;
            finally
              Finish;
            end;
          end;
        finally
          FDataSet.EnableControls;
        end;
        Result := True;
      end else if FOperation = fdoUpdateDataSet then
      begin
        FDataSet.DisableControls;
        try
          with TGaugeFactory.GetGauge(Caption, 0, FDataSet.RecordCount) do
          begin
            if FShowGaugeForm then Start;
            try
              FDataSet.First;
              while not FDataSet.Eof do
              begin

                if FShowGaugeForm then IncProgress(1);

                if FZQuery.Locate(IdFieldFrom, FDataSet.FieldByName(IdFieldTo).Value, []) then
                begin
                  isUpdate := False;
                  for I := 0 to FUpdateFields.Count - 1 do
                    if FDataSet.FieldByName(TdsdUpdateFieldItem(FUpdateFields.Items[I]).FieldNameTo).AsVariant <>
                       FZQuery.FieldByName(TdsdUpdateFieldItem(FUpdateFields.Items[I]).FieldNameFrom).AsVariant then
                    begin
                      isUpdate := True;
                    end;

                  if isUpdate then
                  begin
                    FDataSet.Edit;
                    for I := 0 to FUpdateFields.Count - 1 do
                      FDataSet.FieldByName(TdsdUpdateFieldItem(FUpdateFields.Items[I]).FieldNameTo).AsVariant :=
                         FZQuery.FieldByName(TdsdUpdateFieldItem(FUpdateFields.Items[I]).FieldNameFrom).AsVariant;
                    FDataSet.Post;
                  end;
                end else
                begin
                  FDataSet.Edit;
                  for I := 0 to FUpdateFields.Count - 1 do
                    FDataSet.FieldByName(TdsdUpdateFieldItem(FUpdateFields.Items[I]).FieldNameTo).AsVariant := Null;
                  FDataSet.Post;
                end;

                FDataSet.Next;
              end;
            finally
              Finish;
            end;
          end;
        finally
          FDataSet.EnableControls;
        end;
        Result := True;
      end else if FOperation = fdoToJSON then
      begin

        JSONArray := TJSONArray.Create();
        try
          with TGaugeFactory.GetGauge(Caption, 0, FZQuery.RecordCount) do
          begin
            if FShowGaugeForm then Start;
            try
              FZQuery.First;
              while not FZQuery.Eof do
              begin
                if FShowGaugeForm then IncProgress(1);

                JSONObject := TJSONObject.Create;
                if FPairParams.Count > 0 then
                begin
                  for I := 0 to FPairParams.Count - 1 do
                    if (TdsdFDPairParamsItem(FPairParams.Items[I]).PairName <> '') and (TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName <> '') then
                    begin
                      if Assigned(FZQuery.FindField(TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName)) then
                        AddParamToJSON(TdsdFDPairParamsItem(FPairParams.Items[I]).PairName,
                                       FZQuery.FieldByName(TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName).Value,
                                       FZQuery.FieldByName(TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName).DataType)
                      else AddParamToJSON(TdsdFDPairParamsItem(FPairParams.Items[I]).PairName, Null, ftString);
                    end;
                end else
                begin
                  for I := 0 to FZQuery.FieldCount - 1 do
                    AddParamToJSON(FZQuery.Fields.Fields[I].FieldName,
                                   FZQuery.Fields.Fields[I].Value,
                                   FZQuery.Fields.Fields[I].DataType);
                end;
                JsonArray.AddElement(JSONObject);

                FZQuery.Next;
              end;
            finally
              Finish;
            end;
          end;

          FJsonParam.Value := JSONArray.ToString;
          Result := FJsonParam.Value <> '';
        finally
          JSONArray.Free;
        end;
      end else if FOperation = fdoMultiExecuteJSON then
      begin

        JSONArray := TJSONArray.Create();
        try
          with TGaugeFactory.GetGauge(Caption, 0, FZQuery.RecordCount) do
          begin
            if FShowGaugeForm then Start;
            try
              nCount := 0;
              FZQuery.First;
              while not FZQuery.Eof do
              begin
                if FShowGaugeForm then IncProgress(1);
                Inc(nCount);

                JSONObject := TJSONObject.Create;
                if FPairParams.Count > 0 then
                begin
                  for I := 0 to FPairParams.Count - 1 do
                    if (TdsdFDPairParamsItem(FPairParams.Items[I]).PairName <> '') and (TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName <> '') then
                    begin
                      if Assigned(FZQuery.FindField(TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName)) then
                        AddParamToJSON(TdsdFDPairParamsItem(FPairParams.Items[I]).PairName,
                                       FZQuery.FieldByName(TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName).Value,
                                       FZQuery.FieldByName(TdsdFDPairParamsItem(FPairParams.Items[I]).FieldName).DataType)
                      else AddParamToJSON(TdsdFDPairParamsItem(FPairParams.Items[I]).PairName, Null, ftString);
                    end;
                end else
                begin
                  for I := 0 to FZQuery.FieldCount - 1 do
                    AddParamToJSON(FZQuery.Fields.Fields[I].FieldName,
                                   FZQuery.Fields.Fields[I].Value,
                                   FZQuery.Fields.Fields[I].DataType);
                end;
                JsonArray.AddElement(JSONObject);

                if FMultiExecuteCount <= nCount then
                begin
                  FJsonParam.Value := JSONArray.ToString;
                  FMultiExecuteAction.Execute;
                  JSONArray.Free;
                  JSONArray := TJSONArray.Create();
                  nCount := 0;
                end;

                FZQuery.Next;
              end;

              if nCount > 0 then
              begin
                FJsonParam.Value := JSONArray.ToString;
                FMultiExecuteAction.Execute;
              end;

            finally
              Finish;
            end;
          end;

          Result := True;
        finally
          JSONArray.Free;
        end;
      end;
    end else
    begin
      try
        FZQuery.ExecSQL;
      Except ON E: Exception DO
        Begin
          if not FHideError then ShowMessage(E.Message);
          exit;
        End;
      end;
      Result := True;
    end;
  finally
    FZQuery.Close;
    FZConnection.Disconnect;
  end;
end;

  {TdsdMyIPAction}

constructor TdsdMyIPAction.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;

  FIP := TdsdParam.Create(nil);
  FIP.DataType := ftString;
  FIP.Value := '';

  FContinent := TdsdParam.Create(nil);
  FContinent.DataType := ftString;
  FContinent.Value := '';

  FContinent_Code := TdsdParam.Create(nil);
  FContinent_Code.DataType := ftString;
  FContinent_Code.Value := '';

  FCountry := TdsdParam.Create(nil);
  FCountry.DataType := ftString;
  FCountry.Value := '';

  FCountry_Code := TdsdParam.Create(nil);
  FCountry_Code.DataType := ftString;
  FCountry_Code.Value := '';

  FRegion := TdsdParam.Create(nil);
  FRegion.DataType := ftString;
  FRegion.Value := '';

  FRegion_Code := TdsdParam.Create(nil);
  FRegion_Code.DataType := ftString;
  FRegion_Code.Value := '';

  FCity := TdsdParam.Create(nil);
  FCity.DataType := ftString;
  FCity.Value := '';

  FLatitude := TdsdParam.Create(nil);
  FLatitude.DataType := ftString;
  FLatitude.Value := '';

  FLongitude := TdsdParam.Create(nil);
  FLongitude.DataType := ftString;
  FLongitude.Value := '';

  FPstal := TdsdParam.Create(nil);
  FPstal.DataType := ftString;
  FPstal.Value := '';

  FCalling_Code := TdsdParam.Create(nil);
  FCalling_Code.DataType := ftString;
  FCalling_Code.Value := '';

  FCapital := TdsdParam.Create(nil);
  FCapital.DataType := ftString;
  FCapital.Value := '';

  FBorders := TdsdParam.Create(nil);
  FBorders.DataType := ftString;
  FBorders.Value := '';

  FConnection := TdsdParam.Create(nil);
  FConnection.DataType := ftString;
  FConnection.Value := '';
end;

destructor TdsdMyIPAction.Destroy;
begin
  FreeAndNil(FIP);
  FreeAndNil(FContinent);
  FreeAndNil(FContinent_Code);
  FreeAndNil(FCountry);
  FreeAndNil(FCountry_Code);
  FreeAndNil(FRegion);
  FreeAndNil(FRegion_Code);
  FreeAndNil(FCity);
  FreeAndNil(FLatitude);
  FreeAndNil(FLongitude);
  FreeAndNil(FPstal);
  FreeAndNil(FCalling_Code);
  FreeAndNil(FCapital);
  FreeAndNil(FBorders);
  FreeAndNil(FConnection);

  FreeAndNil(FIdHTTP);
  inherited;
end;

function TdsdMyIPAction.LocalExecute: Boolean;
var jsonObject: TJSONObject;
    S : String;
begin
  Result := False;
  FIP.Value := '';
  FContinent.Value := '';
  FContinent_Code.Value := '';
  FCountry.Value := '';
  FCountry_Code.Value := '';
  FRegion.Value := '';
  FRegion_Code.Value := '';
  FCity.Value := '';
  FLatitude.Value := '';
  FLongitude.Value := '';
  FPstal.Value := '';
  FCalling_Code.Value := '';
  FCapital.Value := '';
  FBorders.Value := '';
  FConnection.Value := '';

  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.FoldLines := False;

  try
    S := FIdHTTP.Get('http://ipwho.is/');

    if FIdHTTP.ResponseCode = 200 then
    begin
      jsonObject := TJSONObject.ParseJSONValue(s) as TJSONObject;
      try
        FIP.Value := jsonObject.Get('ip').JsonValue.Value;
        FContinent.Value := jsonObject.Get('continent').JsonValue.Value;
        FContinent_Code.Value := jsonObject.Get('continent_code').JsonValue.Value;
        FCountry.Value := jsonObject.Get('country').JsonValue.Value;
        FCountry_Code.Value := jsonObject.Get('country_code').JsonValue.Value;
        FRegion.Value := jsonObject.Get('region').JsonValue.Value;
        FRegion_Code.Value := jsonObject.Get('region_code').JsonValue.Value;
        FCity.Value := jsonObject.Get('city').JsonValue.Value;
        FLatitude.Value := jsonObject.Get('latitude').JsonValue.Value;
        FLongitude.Value := jsonObject.Get('longitude').JsonValue.Value;
        FPstal.Value := jsonObject.Get('postal').JsonValue.Value;
        FCalling_Code.Value := jsonObject.Get('calling_code').JsonValue.Value;
        FCapital.Value := jsonObject.Get('capital').JsonValue.Value;
        FBorders.Value := jsonObject.Get('borders').JsonValue.Value;
        FConnection.Value := TJSONObject(jsonObject.Get('connection').JsonValue).Get('org').JsonValue.Value;
        Result := True;
      finally
        jsonObject.Free;
      end;
    end;
  except  on E: Exception do
     ShowMessage('Ошибка получения IP: ' + E.Message);
  end;

end;

  {TdsdVATNumberValidation}

constructor TdsdVATNumberValidation.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;

  FAccess_Key := TdsdParam.Create(nil);
  FAccess_Key.DataType := ftString;
  FAccess_Key.Value := '';

  FVat_Number := TdsdParam.Create(nil);
  FVat_Number.DataType := ftString;
  FVat_Number.Value := '';

  FValid := TdsdParam.Create(nil);
  FValid.DataType := ftBoolean;
  FValid.Value := False;

  FCountry_Code := TdsdParam.Create(nil);
  FCountry_Code.DataType := ftString;
  FCountry_Code.Value := '';

  FCompany_Name := TdsdParam.Create(nil);
  FCompany_Name.DataType := ftString;
  FCompany_Name.Value := '';

  FCompany_Address := TdsdParam.Create(nil);
  FCompany_Address.DataType := ftString;
  FCompany_Address.Value := '';

end;

destructor TdsdVATNumberValidation.Destroy;
begin
  FreeAndNil(FAccess_Key);
  FreeAndNil(FVat_Number);
  FreeAndNil(FValid);
  FreeAndNil(FCountry_Code);
  FreeAndNil(FCompany_Name);
  FreeAndNil(FCompany_Address);

  FreeAndNil(FIdHTTP);
  inherited;
end;

function TdsdVATNumberValidation.LocalExecute: Boolean;
var jsonObject: TJSONObject;
    S : String;
begin
  Result := False;
  FValid.Value := False;
  FCountry_Code.Value := '';
  FCompany_Name.Value := '';
  FCompany_Address.Value := '';

  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.FoldLines := False;

  try
    S := FIdHTTP.Get(TIdURI.URLEncode('http://apilayer.net/api/validate?access_key=' + FAccess_Key.Value +
                                                                      '&vat_number=' + FVat_Number.Value));
    if FIdHTTP.ResponseCode = 200 then
    begin
      jsonObject := TJSONObject.ParseJSONValue(s) as TJSONObject;
      try

        if jsonObject.Get('valid') <> Nil then
        begin
          FValid.Value := jsonObject.Get('valid').JsonValue.ClassNameIs('TJSONTrue');
          FCountry_Code.Value := jsonObject.Get('country_code').JsonValue.Value;
          FCompany_Name.Value := jsonObject.Get('company_name').JsonValue.Value;
          FCompany_Address.Value := jsonObject.Get('company_address').JsonValue.Value;
        end else if jsonObject.Get('success') <> Nil then
        begin
          ShowMessage('Ошибка получения информации о клиенте: ' + TJSONObject(jsonObject.Get('error').JsonValue).Get('info').JsonValue.Value);
          Exit;
        end else
        begin
          ShowMessage('Ошибка получения информации о клиенте: ' + S);
          Exit;
        end;

        if not Assigned (FValid.Component) then
        begin
          Result := FValid.Value;
          if not FValid.Value then ShowMessage('Клиент с Vat_Number ' + FVat_Number.Value + ' не найден.' );
        end else Result := True;
      finally
        jsonObject.Free;
      end;
    end;
  except  on E: Exception do
     ShowMessage('Ошибка получения информации о клиенте: ' + E.Message);
  end;

end;

{TdsdLoadAgilis}

constructor TdsdLoadAgilis.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FURL := TdsdParam.Create(nil);
  FURL.DataType := ftString;
  FURL.Value := '';

  FOrder := TdsdParam.Create(nil);
  FOrder.DataType := ftString;
  FOrder.Value := '';

  FFieldCount := TdsdParam.Create(nil);
  FFieldCount.DataType := ftInteger;
  FFieldCount.Value := 0;

  FTitleName := TdsdParam.Create(nil);
  FTitleName.DataType := ftString;
  FTitleName.Value := 'Title';

  FValueName := TdsdParam.Create(nil);
  FValueName.DataType := ftString;
  FValueName.Value := 'Value';

  FCreateFileTitle := TdsdParam.Create(nil);
  FCreateFileTitle.DataType := ftBoolean;
  FCreateFileTitle.Value := False;

end;

destructor TdsdLoadAgilis.Destroy;
begin
  FreeAndNil(FCreateFileTitle);
  FreeAndNil(FValueName);
  FreeAndNil(FTitleName);
  FreeAndNil(FFieldCount);
  FreeAndNil(FOrder);
  FreeAndNil(FURL);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;

procedure TdsdLoadAgilis.Notification(AComponent: TComponent;
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

function TdsdLoadAgilis.GetURL : String;
begin
  Result := FURL.Value;
end;

function TdsdLoadAgilis.GetOrder : String;
begin
  Result := FOrder.Value;
end;

function TdsdLoadAgilis.GetCreateFileTitle : Boolean;
var Val : Boolean;
begin
  if not TryStrToBool(FCreateFileTitle.Value, Val) then Val := False;
  Result := Val;
end;

function TdsdLoadAgilis.GetFieldCount : Integer;
var Val : Integer;
begin
  if not TryStrToInt(FFieldCount.Value, Val) then Val := 0;
  Result := Val;
end;

function TdsdLoadAgilis.GetFieldTitle : String;
begin
  Result := FTitleName.Value;
end;

function TdsdLoadAgilis.GetFieldValue : String;
begin
  Result := FValueName.Value;
end;


function TdsdLoadAgilis.LocalExecute: Boolean;
var jsonObject, jsonItem : TJSONObject; jsonArray : TJSONArray;
    S, KeyName : String;
    nCount : Integer; I, J, L : Integer;
begin
  Result := False;

  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.FoldLines := False;

  //FIdHTTP.Request.Connection := 'keep-alive';
  //FIdHTTP.Request.BasicAuthentication := True;

  try
    S := FIdHTTP.Get(TIdURI.URLEncode(FURL.Value + FOrder.Value));
    //S := FIdHTTP.Get(FURL.Value + FOrder.Value);
    if FIdHTTP.ResponseCode = 200 then
    begin

      FDataSet.Close;
      FDataSet.FieldDefs.Clear;

      nCount := FieldCount;

      jsonObject := TJSONObject.ParseJSONValue(s) as TJSONObject;
      try

        if nCount <= 0 then
        begin
           nCount := 1;
           for I := 0 to jsonObject.Size - 1 do
           begin
             if jsonObject.Get(I).JsonValue.ClassNameIs('TJSONArray') then
             begin
               if TJSONArray(jsonObject.Get(I).JsonValue).Size > 0 then
                 if nCount < TJSONObject(TJSONArray(jsonObject.Get(I).JsonValue).Get(0)).Size then
                   nCount := TJSONObject(TJSONArray(jsonObject.Get(I).JsonValue).Get(0)).Size;
             end else if jsonObject.Get(I).JsonValue.ClassNameIs('TJSONObject') then
             begin
               if nCount < TJSONObject(jsonObject.Get(I).JsonValue).Size then
                 nCount := TJSONObject(jsonObject.Get(I).JsonValue).Size;
             end;
           end;
        end;

        FDataSet.FieldDefs.Add(FTitleName.Value, ftString, 255);

        for I := 1 to nCount do
        begin
          if CreateFileTitle then
            FDataSet.FieldDefs.Add(FTitleName.Value + IntToStr(I), ftString, 255);
          FDataSet.FieldDefs.Add(FValueName.Value + IntToStr(I), ftString, 255);
        end;

        FDataSet.CreateDataSet;

        for I := 0 to jsonObject.Size - 1 do
        begin
          KeyName := jsonObject.Get(I).JsonString.Value;
          FDataSet.Last;
          FDataSet.Append;
          FDataSet.FieldByName(FTitleName.Value).AsString := KeyName;

          if jsonObject.Get(I).JsonValue.ClassNameIs('TJSONArray') then
          begin
            jsonArray := TJSONArray(jsonObject.Get(I).JsonValue);
            for L := 0 to jsonArray.Size - 1 do
            begin
              jsonItem := TJSONObject(jsonArray.Get(L));
              for J := 0 to Min(jsonItem.Size, nCount) - 1 do
              begin
                if CreateFileTitle then
                  FDataSet.FieldByName(FTitleName.Value + IntToStr(J + 1)).AsString := jsonItem.Get(J).JsonString.Value;
                FDataSet.FieldByName(FValueName.Value + IntToStr(J + 1)).AsString := jsonItem.Get(J).JsonValue.Value;
              end;

              if L < (jsonArray.Size - 1) then
              begin
                FDataSet.Post;
                FDataSet.Last;
                FDataSet.Append;
                FDataSet.FieldByName(FTitleName.Value).AsString := KeyName;
              end;
            end;
          end else if jsonObject.Get(I).JsonValue.ClassNameIs('TJSONObject') then
          begin
            jsonItem := TJSONObject(jsonObject.Get(I).JsonValue);
            for J := 0 to Min(jsonItem.Size, nCount) - 1 do
            begin
              if CreateFileTitle then
                FDataSet.FieldByName(FTitleName.Value + IntToStr(J + 1)).AsString := jsonItem.Get(J).JsonString.Value;
              FDataSet.FieldByName(FValueName.Value + IntToStr(J + 1)).AsString := jsonItem.Get(J).JsonValue.Value;
            end;
          end else FDataSet.FieldByName(FValueName.Value + '1').AsString := jsonObject.Get(I).JsonValue.Value;

          FDataSet.Post;
        end;
        Result := True;
      finally
        jsonObject.Free;
      end;
    end;
  except  on E: Exception do
     ShowMessage('Ошибка получения информации о заказе: ' + E.Message);
  end;

end;

{ TdsdLoadFile_https }

constructor TdsdLoadFile_https.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FStream := TStringStream.Create;

  FURL := TdsdParam.Create(nil);
  FURL.DataType := ftString;
  FURL.Value := '';

  FData := TdsdParam.Create(nil);
  FData.DataType := ftWideString;
  FData.Value := '';

end;

destructor TdsdLoadFile_https.Destroy;
begin
  FreeAndNil(FData);
  FreeAndNil(FURL);

  FreeAndNil(FStream);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;

function TdsdLoadFile_https.GetURL : String;
begin
  Result := FURL.Value;
end;

function PADR(Src: string; Lg: Integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := Result + ' ';
end;

function GETS(Src: string): string;
var i, ii: integer;
begin
  Result := '';
  ii:=0;
  // нашли последний символ /
  i:=1;
  while i <= Length(Src) do begin
    if Src[i] = '/' then ii:= i;
    i := i + 1;
  end;
  // если нашли
  if (ii > 0) and (ii < Length(Src))
  then
     // переносим
     for i:= ii+1 to Length(Src) do Result:= Result + Src[i]
  else begin
    Result := src;
    ShowMessage ('Сохранится с таким названием <'+Result+'>. А потом откроется?');
  end;

  //ShowMessage ('Сохранится с таким названием <'+Result+'>. ок?');

end;

function TdsdLoadFile_https.LocalExecute: Boolean;
var jsonObject, jsonItem : TJSONObject; jsonArray : TJSONArray;
    S, KeyName : String;
    nCount : Integer; I, J, L : Integer;
begin
  Result := False;
  FData.Value := '';

//  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.FoldLines := False;

  try
    FStream.Clear;
    FIdHTTP.Get(TIdURI.URLEncode(FURL.Value), FStream);
    if FIdHTTP.ResponseCode = 200 then
    begin
      if FStream.Size > 0 then
      begin
        FStream.Position := 0;
        FData.Value := ConvertConvert(PADR(GETS(FURL.Value), 255) + FStream.DataString);

        //FData.Value := FStream.DataString;
        Result := True;

        //FStream.Position := 0;
        //if Pos('.png', FURL.Value) > 0
        //then FStream.SaveToFile('test.png')
        //else FStream.SaveToFile('test.pdf');

      end;
    end;
  except  on E: Exception do
     ShowMessage('Ошибка получения файла: ' + E.Message);
  end;

end;

{ TdsdeSputnikContactsMessages }

constructor TdsdeSputnikContactsMessages.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FDataStart := TdsdParam.Create(nil);
  FDataStart.DataType := ftDateTime;

  FDataEnd := TdsdParam.Create(nil);
  FDataEnd.DataType := ftDateTime;

  FUserName := TdsdParam.Create(nil);
  FUserName.DataType := ftString;
  FUserName.Value := '';

  FPassword := TdsdParam.Create(nil);
  FPassword.DataType := ftString;
  FPassword.Value := '';

  FPhone := TdsdParam.Create(nil);
  FPhone.DataType := ftString;
  FPhone.Value := '';

end;

destructor TdsdeSputnikContactsMessages.Destroy;
begin
  FreeAndNil(FDataStart);
  FreeAndNil(FDataEnd);
  FreeAndNil(FUserName);
  FreeAndNil(FPassword);
  FreeAndNil(FPhone);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;


function TdsdeSputnikContactsMessages.LocalExecute: Boolean;
var jsonItem : TJSONObject; jsonArray : TJSONArray;  jsonPair: TJSONPair;
    S : String; I, nOffset, nMaxRows : Integer;
    DataStart, DataEnd : TDateTime;
begin
  Result := False;

  if not Assigned(FDataSet) then
  begin
    ShowMessage('Не определен источник данных.');
    Exit;
  end;

  if FPhone.Value = '' then
  begin
    ShowMessage('Не заполнен номер телефона.');
    Exit;
  end;

  nOffset := 0;
  nMaxRows := 50;
  S := '';
  try
    DataStart := FDataStart.Value;
  except
    DataStart := IncMonth(Date, - 1);
  end;

  try
    DataEnd := FDataEnd.Value;
  except
    DataEnd := Date;
  end;

  FDataSet.DisableControls;
  try

    if FDataSet.Active then FDataSet.Close;
    FDataSet.FieldDefs.Clear;
    FDataSet.FieldDefs.Add('sentDateTime', ftDateTime);
    FDataSet.FieldDefs.Add('activityStatus', ftString, 255);
    FDataSet.FieldDefs.Add('text', ftString, 1100);
    FDataSet.CreateDataSet;

    FIdHTTP.Request.Clear;
    FIdHTTP.Request.CustomHeaders.Clear;
    FIdHTTP.Request.ContentType := 'application/json';
    FIdHTTP.Request.Accept := 'application/json';
    FIdHTTP.Request.AcceptEncoding := 'gzip, deflate';
    FIdHTTP.Request.Connection := 'keep-alive';
    FIdHTTP.Request.ContentEncoding := 'utf-8';
    FIdHTTP.Request.BasicAuthentication := True;
    FIdHTTP.Request.Username := FUserName.Value;
    FIdHTTP.Request.Password := FPassword.Value;
    FIdHTTP.Request.UserAgent:='';

    while (Length(S) > 10) or (nOffset = 0) do
    begin
      try
        S := FIdHTTP.Get(TIdURI.URLEncode('https://esputnik.com/api/v2/contacts/messages' + '?dateFrom=' + FormatDateTime('YYYY-MM-DD', DataStart) +
                                                                                            '&dateTo=' + FormatDateTime('YYYY-MM-DD', DataEnd) +
                                                                                            '&phone=' + FPhone.Value +
                                                                                            '&offset=' + IntToStr(nOffset) +
                                                                                            '&maxrows=' + IntToStr(nMaxRows)));

        if FIdHTTP.ResponseCode = 200 then
        begin
          jsonArray := TJSONObject.ParseJSONValue(S) as TJSONArray;
          try
            for I := 0 to jsonArray.Size - 1 do
            begin
              jsonItem := jsonArray.Get(I) as TJSONObject;
              FDataSet.Last;
              FDataSet.Append;
              try
                FDataSet.FieldByName('sentDateTime').AsDateTime := gfXSStrToDate(jsonItem.Get('sentDateTime').JsonValue.Value);
              except
              end;
              if jsonItem.Get('activityStatus').JsonValue.Value = 'DELIVERED' then
                FDataSet.FieldByName('activityStatus').AsString := 'Доставлено'
              else FDataSet.FieldByName('activityStatus').AsString := 'Не доставлено';
              FDataSet.FieldByName('text').AsString := jsonItem.Get('text').JsonValue.Value;
              FDataSet.Post;
            end;
          finally
            FreeAndNil(jsonArray);
          end;
        end else ShowMessage(FIdHTTP.ResponseText);

      except  on E: Exception do
         ShowMessage('Ошибка получения истории сообщений для контакта: ' + E.Message);
      end;

      nOffset := nOffset + nMaxRows;
    end;

    Result := True;
  finally
    FDataSet.EnableControls;
  end;

end;

{  TdsdeSputnikSendSMS  }

constructor TdsdeSputnikSendSMS.Create(AOwner: TComponent);
begin
  inherited;

  FIdHTTP := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FUserName := TdsdParam.Create(nil);
  FUserName.DataType := ftString;
  FUserName.Value := '';

  FPassword := TdsdParam.Create(nil);
  FPassword.DataType := ftString;
  FPassword.Value := '';

  FFrom := TdsdParam.Create(nil);
  FFrom.DataType := ftString;
  FFrom.Value := '';

  FText := TdsdParam.Create(nil);
  FText.DataType := ftString;
  FText.Value := '';

  FPhone := TdsdParam.Create(nil);
  FPhone.DataType := ftString;
  FPhone.Value := '';

  FSend := TdsdParam.Create(nil);
  FSend.DataType := ftBoolean;
  FSend.Value := True;

end;

destructor TdsdeSputnikSendSMS.Destroy;
begin
  FreeAndNil(FUserName);
  FreeAndNil(FPassword);
  FreeAndNil(FFrom);
  FreeAndNil(FText);
  FreeAndNil(FPhone);
  FreeAndNil(FSend);

  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  FreeAndNil(FIdHTTP);
  inherited;
end;


function TdsdeSputnikSendSMS.LocalExecute: Boolean;
var jsonItem : TJSONObject;
    S, Json : String; JsonToSend: TStringStream;
begin
  Result := False;

  if not FSend.Value then
  begin
    Result := True;
    Exit;
  end;

  if FFrom.Value = '' then
  begin
    ShowMessage('Не заполнен отправитель.');
    Exit;
  end;

  if FText.Value = '' then
  begin
    ShowMessage('Не заполнен текст сообщения.');
    Exit;
  end;

  if FPhone.Value = '' then
  begin
    ShowMessage('Не заполнен номер телефона.');
    Exit;
  end;

  FIdHTTP.Request.Clear;
  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.Accept := 'application/json';
  FIdHTTP.Request.AcceptEncoding := 'gzip, deflate';
  FIdHTTP.Request.Connection := 'keep-alive';
  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.BasicAuthentication := True;
  FIdHTTP.Request.Username := FUserName.Value;
  FIdHTTP.Request.Password := FPassword.Value;
  FIdHTTP.Request.UserAgent:='';

  Json := '{"from":"' + FFrom.Value +
          '","text":"' +
          StringReplace(StringReplace(FText.Value, '\', '\\', [rfReplaceAll, rfIgnoreCase]), '"', '\"', [rfReplaceAll, rfIgnoreCase]) +
          '","phoneNumbers":["' + FPhone.Value + '"]}';

  JsonToSend := TStringStream.Create(Json, TEncoding.UTF8);
  try
    try
      S := FIdHTTP.Post(TIdURI.URLEncode('https://esputnik.com/api/v1/message/sms'), JsonToSend);
    except
    end;
  finally
    JsonToSend.Free;
  end;

  if FIdHTTP.ResponseCode = 200 then
  begin
    jsonItem := TJSONObject.ParseJSONValue(S) as TJSONObject;
    if jsonItem.Get('results').JsonValue <> Nil then
    begin
      jsonItem := TJSONObject(jsonItem.Get('results').JsonValue);
      Result := jsonItem.Get('status').JsonValue.Value = 'OK';
    end;
    if not Result then ShowMessage('Ошибка отправки СМС сообщений для контакта: ' + jsonItem.ToString);
  end else ShowMessage('Ошибка отправки СМС сообщений для контакта: ' + FIdHTTP.ResponseText);

end;

{ TdsdComponentItem }

function TdsdComponentItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FComponent) then
    Result := FComponent.Name
  else Result := inherited;
end;

procedure TdsdComponentItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdSetVisibleParamsItem then
  begin
     FComponent := TdsdSetVisibleParamsItem(Source).FComponent;
  end
  else
    inherited Assign(Source);
end;

procedure TdsdComponentItem.SetComponent(const Value: TComponent);
begin
  if Value <> FComponent then
  begin
     FComponent := Value;
  end
end;

{ TBooleanSetVisibleAction }

constructor TBooleanSetVisibleAction.Create(AOwner: TComponent);
begin
  inherited;
  FImageIndexTrue := -1;
  FImageIndexFalse := -1;
  FHintFalse := 'Показать колонки';
  FHintTrue := 'Скрыть колонки';
  FCaptionFalse := 'Показать колонки';
  FCaptionTrue := 'Скрыть колонки';
  FValue := True;
  FComponents := TCollection.Create(TdsdComponentItem);
end;

destructor TBooleanSetVisibleAction.Destroy;
begin
  FreeAndNil(FComponents);
  inherited;
end;

procedure TBooleanSetVisibleAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if csDestroying in ComponentState then
    exit;
  if (Operation = opRemove) then
  begin
    for i := 0 to FComponents.Count - 1 do
      if TdsdComponentItem(FComponents.Items[i]).Component = AComponent then
        TdsdComponentItem(FComponents.Items[i]).Component := nil;
  end;
end;

procedure TBooleanSetVisibleAction.SetVisiableAll;
  var I: Integer;
begin
  for i := 0 to FComponents.Count - 1 do  if Assigned(TdsdComponentItem(FComponents.Items[i]).Component) then
  begin
     if TdsdComponentItem(FComponents.Items[i]).Component is TcxGridColumn then
     begin
       TcxGridColumn(TdsdComponentItem(FComponents.Items[i]).Component).Visible := Value;
       TcxGridColumn(TdsdComponentItem(FComponents.Items[i]).Component).VisibleForCustomization := Value;
     end else if TdsdComponentItem(FComponents.Items[i]).Component is TdxBarButton then
     begin
        if Value then
          TdxBarButton(TdsdComponentItem(FComponents.Items[i]).Component).Visible := ivAlways
        else TdxBarButton(TdsdComponentItem(FComponents.Items[i]).Component).Visible := ivNever;
     end else if IsPublishedProp(TdsdComponentItem(FComponents.Items[i]).Component, 'TabVisible') then
     begin
       SetPropValue(TdsdComponentItem(FComponents.Items[i]).Component, 'TabVisible', Value);
       if not Value and (TdsdComponentItem(FComponents.Items[i]).Component is TcxTabSheet) and
          not Assigned(TcxTabSheet(TdsdComponentItem(FComponents.Items[i]).Component).PageControl.ActivePage) then
          TcxTabSheet(TdsdComponentItem(FComponents.Items[i]).Component).PageControl.ActivePageIndex := 0;
     end else if IsPublishedProp(TdsdComponentItem(FComponents.Items[i]).Component, 'Visible') then
     begin
       SetPropValue(TdsdComponentItem(FComponents.Items[i]).Component, 'Visible', Value)
     end;
  end;
end;

function TBooleanSetVisibleAction.LocalExecute: Boolean;
begin
  Value := not Value;

  SetVisiableAll;
end;

procedure TBooleanSetVisibleAction.SetCaptionFalse(const Value: String);
begin
  FCaptionFalse := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanSetVisibleAction.SetCaptionTrue(const Value: String);
begin
  FCaptionTrue := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanSetVisibleAction.SetHintFalse(const Value: String);
begin
  FHintFalse := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanSetVisibleAction.SetHintTrue(const Value: String);
begin
  FHintTrue := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanSetVisibleAction.SetImageIndexFalse(const Value: TImageIndex);
begin
  FImageIndexFalse := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanSetVisibleAction.SetImageIndexTrue(const Value: TImageIndex);
begin
  FImageIndexTrue := Value;
  Self.Value := Self.Value;
end;

procedure TBooleanSetVisibleAction.SetValue(const Value: Boolean);
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

{ TdsdSetPropValueParamsItem }

constructor TdsdSetPropValueParamsItem.Create(Collection: TCollection);
begin
  inherited;
  FNameParam := TdsdParam.Create(Nil);
  FNameParam.DataType := ftString;
  FNameParam.Value := '';
  FValueParam := TdsdParam.Create(Nil);
  FValueParam.DataType := ftString;
  FValueParam.Value := '';
end;

destructor TdsdSetPropValueParamsItem.Destroy;
begin
  FNameParam.Free;
  FValueParam.Free;
  inherited Destroy;
end;

function TdsdSetPropValueParamsItem.GetDisplayName: string;
begin
  if Assigned(FComponent) then result := FComponent.Name
  else Result := inherited;

  if Assigned(FNameParam.Component) then
    result := Result + ' ' + FNameParam.Component.Name + ' ' + FNameParam.ComponentItem;
  if FNameParam.Value <> '' then result := Result + ' ' + FNameParam.Value;

  if Assigned(FValueParam.Component) then
    result := Result + ' ' + FValueParam.Component.Name + ' ' + FValueParam.ComponentItem
  else if Assigned(FValueParam.Component) and (FValueParam.Value <> '') then result := Result + ' ' + FValueParam.Value;
end;

procedure TdsdSetPropValueParamsItem.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdSetEnabledParamsItem then
  begin
     FNameParam.Assign(TdsdSetPropValueParamsItem(Source).NameParam);
     FValueParam.Assign(TdsdSetPropValueParamsItem(Source).ValueParam);
     FComponent := TdsdSetEnabledParamsItem(Source).FComponent;
  end
  else
    inherited Assign(Source);
end;

procedure TdsdSetPropValueParamsItem.SetComponent(const Value: TComponent);
begin
  if Value <> FComponent then
  begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FComponent := Value;
  end
end;

{  TdsdSetPropValueAction  }

constructor TdsdSetPropValueAction.Create(AOwner: TComponent);
begin
  inherited;
  FSetPropValueParams := TOwnedCollection.Create(Self, TdsdSetPropValueParamsItem);
end;

destructor TdsdSetPropValueAction.Destroy;
begin
  FreeAndNil(FSetPropValueParams);

  inherited;
end;

procedure TdsdSetPropValueAction.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) then
  begin
    for i := 0 to FSetPropValueParams.Count - 1 do
    begin
       if TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component = AComponent then
            TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component := nil;
       if TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Component = AComponent then
           TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Component := nil;
       if TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FValueParam.Component = AComponent then
           TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FValueParam.Component := nil;
    end;
  end;
end;

function TdsdSetPropValueAction.LocalExecute: Boolean;
var i, j: integer; PropInfo: PPropInfo; Value: TObject;
begin
  inherited;
  Result := True;

  for i := 0 to FSetPropValueParams.Count - 1 do  if Assigned(TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component) and (TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Value <> '') then
  begin
    if IsPublishedProp(TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component, TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Value) then
    begin
      PropInfo := GetPropInfo(TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component, TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Value);
      if Assigned(PropInfo) then
      begin

        case PropInfo^.PropType^.Kind of
          tkClass : begin
                      Value := Nil;
                      if TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FValueParam.Value <> '' then
                      begin
                        for j := 0 to TForm(Owner).ComponentCount - 1 do if TForm(Owner).Components[j].Name = TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FValueParam.Value then
                        begin
                          Value := TForm(Owner).Components[j];
                          Break;
                        end;
                      end;

                      SetObjectProp(TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component, TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Value, Value);
                    end
          else SetPropValue(TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).Component, TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FNameParam.Value, TdsdSetPropValueParamsItem(FSetPropValueParams.Items[i]).FValueParam.Value)
        end;

      end;
    end;
  end;

end;

  { TdsdContinueAction }

constructor TdsdContinueAction.Create(AOwner: TComponent);
begin
  inherited;
  FContinueParam := TdsdParam.Create(Nil);
  FContinueParam.DataType := ftBoolean;
  FContinueParam.Value := False;
end;

destructor TdsdContinueAction.Destroy;
begin
  FContinueParam.Free;
  inherited Destroy;
end;

function TdsdContinueAction.LocalExecute: Boolean;
var i, j: integer; PropInfo: PPropInfo; Value: TObject;
begin
  inherited;
  Result := FContinueParam.Value;
end;

initialization

  XML := TXMLDocument.Create(nil);


end.

