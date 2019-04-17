unit dsdAddOn;

interface

uses Windows, Winapi.Messages, Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView,
     cxTextEdit, DB, dsdAction, cxGridTableView,
     VCL.Graphics, cxGraphics, cxStyles, cxCalendar, Forms, Controls,
     SysUtils, dsdDB, Contnrs, cxGridCustomView, cxGridCustomTableView, dsdGuides,
     VCL.ActnList, cxCustomPivotGrid, cxDBPivotGrid, cxEdit, cxCustomData, cxPC,
     GMClasses, GMMap, GMMapVCL, GMGeoCode, GMConstants, GMMarkerVCL, SHDocVw, ExtCtrls,
     Winapi.ShellAPI, System.StrUtils, GMDirection, GMDirectionVCL;

const
  WM_SETFLAG = WM_USER + 2;
  WM_SETFLAGHeaderSaver = WM_USER + 3;

type
  // 1. ��������� �������� isErased
  TCustomDBControlAddOn = class(TComponent)
  private
    FImages: TImageList;
    FOnDblClickActionList: TActionItemList;
    FActionItemList: TActionItemList;
    FOnKeyDown: TKeyEvent;
    FErasedFieldName: string;
    FAfterInsert: TDataSetNotifyEvent;
    procedure OnAfterInsert(DataSet: TDataSet);
    procedure OnDblClick(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
  protected
    property OnDblClickActionList: TActionItemList read FOnDblClickActionList write FOnDblClickActionList;
    property ActionItemList: TActionItemList read FActionItemList write FActionItemList;
    property SortImages: TImageList read FImages write FImages;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    // ��� ���� ���������� �� ����������� �������� ������
    property ErasedFieldName: string read FErasedFieldName write FErasedFieldName;
  end;

  TdsdDBTreeAddOn = class(TCustomDBControlAddOn)
  private
    FDBTreeList: TcxDBTreeList;
    procedure SetDBTreeList(const Value: TcxDBTreeList);
    // �������� ��� ������� Ctrl, Shift ��� Alt
    procedure onColumnHeaderClick(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
    // ������ ���� ������
    procedure onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
       var ADone: Boolean);
    // ������ ���� ���� � ���������� ������
    procedure onCustomDrawDataCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
       var ADone: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure onGetNodeImageIndex(Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
              AIndexType: TcxTreeListImageIndexType; var AIndex: TImageIndex);
  published
    property OnDblClickActionList;
    property ActionItemList;
    property SortImages;
    property DBTreeList: TcxDBTreeList read FDBTreeList write SetDBTreeList;
  end;

  // ���������� �������

  // �������� �����
  TColorValue = class(TCollectionItem)
  private
    FColor: TColor;
    FValue: Variant;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write FColor;
    property Value: Variant read FValue write FValue;
  end;

  // ������� ���������� ������
  TColorRule = class(TCollectionItem)
  private
    FColorColumn: TcxGridColumn;
    FValueColumn: TcxGridColumn;
    FValueBoldColumn: TcxGridColumn;
    FColorInValueColumn: boolean;
    FColorValueList: TCollection;
    FStyle: TcxStyle;
    FBackGroundValueColumn: TcxGridColumn;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // ����� ������ ������������. ���� ColorColumn �� ������, �� ����� �������� ���� � ���� ������
    property ColorColumn: TcxGridColumn read FColorColumn write FColorColumn;
    // ������ ����� �������� ��� ����������� �����
    property ValueColumn: TcxGridColumn read FValueColumn write FValueColumn;
    // ������ ����� �������� ��� ����������� ����� BackGround
    property BackGroundValueColumn: TcxGridColumn read FBackGroundValueColumn write FBackGroundValueColumn;
    // ������ �� ���� ��������������� � ValueColumn;
    property ColorInValueColumn: boolean read FColorInValueColumn write FColorInValueColumn default true;
    // �������� ��� ������
    property ColorValueList: TCollection read FColorValueList write FColorValueList;
    // ������ ����� �������� ��� ����������� Bold
    property ValueBoldColumn: TcxGridColumn read FValueBoldColumn write FValueBoldColumn;
  end;

  // ������� ���������� ������
  TColorRulePivot = class(TCollectionItem)
  private
    FColorColumn: TcxPivotGridField;
    FValueColumn: TcxPivotGridField;
    FValueBoldColumn: TcxPivotGridField;
    FColorInValueColumn: boolean;
    FColorValueList: TCollection;
    FStyle: TcxStyle;
    FBackGroundValueColumn: TcxPivotGridField;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // ����� ������ ������������. ���� ColorColumn �� ������, �� ����� �������� ���� � ���� ������
    property ColorColumn: TcxPivotGridField read FColorColumn write FColorColumn;
    // ������ ����� �������� ��� ����������� �����
    property ValueColumn: TcxPivotGridField read FValueColumn write FValueColumn;
    // ������ ����� �������� ��� ����������� ����� BackGround
    property BackGroundValueColumn: TcxPivotGridField read FBackGroundValueColumn write FBackGroundValueColumn;
    // ������ �� ���� ��������������� � ValueColumn;
    property ColorInValueColumn: boolean read FColorInValueColumn write FColorInValueColumn default true;
    // �������� ��� ������
    property ColorValueList: TCollection read FColorValueList write FColorValueList;
    // ������ ����� �������� ��� ����������� Bold
    property ValueBoldColumn: TcxPivotGridField read FValueBoldColumn write FValueBoldColumn;
  end;

	TPivotSummartType = (psNone, psCount, psSum, psMin, psMax, psAverage,
    psStdDev, psStdDevP, psVariance, psVarianceP, psAveragePrice);

  // ������� �������� ������ �� ������� ������
  TSummaryFieldPivot = class(TCollectionItem)
  private
    FAddColumn: TcxPivotGridField;
    FSummaryColumn: TcxPivotGridField;
    FTypeColumn: TcxPivotGridField;
    FIfDifferent: TPivotSummartType;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // ��� ����� ������ ��������� ������
    property SummaryColumn: TcxPivotGridField read FSummaryColumn write FSummaryColumn;
    // ������ ����� �������� ��� ���� ������������
    property AddColumn: TcxPivotGridField read FAddColumn write FAddColumn;
    // ������ ����� �������� ��� ���� ������������
    property TypeColumn: TcxPivotGridField read FTypeColumn write FTypeColumn;
    // ���� ������ ���� ������������
    property IfDifferent: TPivotSummartType read FIfDifferent write FIfDifferent default psNone;
  end;

  TColumnActionOptions = class(TPersistent)
  private
    FAfterEmptyValue: boolean;
    FActive: boolean;
    FAction: TCustomAction;
  published
    property Active: boolean read FActive write FActive;
    //  ������ ���� ������ �������� ����
    property AfterEmptyValue: boolean read FAfterEmptyValue write FAfterEmptyValue;
    property Action: TCustomAction read FAction write FAction;
  end;

  TColumnCollectionItem = class(TCollectionItem)
    FColumn: TcxGridColumn;
  protected
    function GetDisplayName: string; override;
  published
    property Column: TcxGridColumn read FColumn write FColumn;
  end;

  TColumnAddOn = class(TColumnCollectionItem)
  private
    FAction: TCustomAction;
    FonExitColumn: TColumnActionOptions;
    FFindByFullValue: boolean;
  public
    constructor Create(Collection: TCollection); override;
    procedure Init;
  published
    property FindByFullValue: boolean read FFindByFullValue write FFindByFullValue default false;
    property Action: TCustomAction read FAction write FAction;
    property onExitColumn: TColumnActionOptions read FonExitColumn write FonExitColumn;
  end;

  TSummaryItemAddOn = class(TCollectionItem)
  private
    FDataSummaryItemIndex: Integer;
    FParam: TdsdParam;
    procedure SetDataSummaryItemIndex(const Value: Integer);
    procedure onGetText(Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean; var AText: string);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Param: TdsdParam read FParam write FParam;
    property DataSummaryItemIndex: Integer read FDataSummaryItemIndex write SetDataSummaryItemIndex;
  end;

  // ��������� ��� ����������� �� GridView
  // 1. ������� ��������� ��������
  // 2. ��������� ������ ����������
  // 3. ��������� �������� isErased
  TdsdDBViewAddOn = class(TCustomDBControlAddOn)
  private
    FDateEdit: TcxDateEdit;
    FView: TcxGridTableView;
    FBackGroundStyle: TcxStyle;
    FonExit: TNotifyEvent;
    // ������� ��� ����� ������� �������
    edFilter: TcxTextEdit;
    FOnlyEditingCellOnEnter: boolean;
    FGridEditKeyEvent: TcxGridEditKeyEvent;
    FOnGetContentStyleEvent : TcxGridGetCellStyleEvent;
    FErasedStyle: TcxStyle;
    FBeforeOpen: TDataSetNotifyEvent;
    FAfterOpen: TDataSetNotifyEvent;
    FColorRuleList: TCollection;
    FColumnAddOnList: TCollection;
    FColumnEnterList: TCollection;
    FSummaryItemList: TOwnedCollection;
    FGridFocusedItemChangedEvent: TcxGridFocusedItemChangedEvent;
    FSearchAsFilter: boolean;
    FKeepSelectColor: boolean;
    procedure TableViewFocusedItemChanged(Sender: TcxCustomGridTableView;
                        APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
    procedure OnBeforeOpen(ADataSet: TDataSet);
    procedure OnAfterOpen(ADataSet: TDataSet);
    function inColumnEnterList(Column: TcxGridColumn): boolean;
    procedure ActionOnlyEditingCellOnEnter;
    procedure GridEditKeyEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
                                AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure SetView(const Value: TcxGridTableView); virtual;
    procedure SetDateEdit(const Value: TcxDateEdit); virtual;
    procedure edFilterExit(Sender: TObject);
    procedure edFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    // ��������� ������������� ������� ��� �������� �������� ������� � ��������������� �� ��������� �������
    procedure lpSetEdFilterPos(inKey: Char);
    //��������� ������������� ������ � ������� ��������� � ��������
    procedure lpSetFilter;
    // �������� ��� ������� Ctrl, Shift ��� Alt
    procedure OnColumnHeaderClick(Sender: TcxGridTableView; AColumn: TcxGridColumn);
    // ������ ���� ������
    procedure OnCustomDrawColumnHeader(Sender: TcxGridTableView;
     ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo;
     var ADone: Boolean);
    // ������ ���� ���� � ���������� ������ � �����
    procedure OnCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    // ������ ���� ���� � ���������� ������ ��� �������� � Excel, ��������, ��� ������
    procedure OnGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    // �������� ���� ����� � ������ ��������� �������
    procedure onFilterChanged(Sender: TObject);
    // ���� ��� ������ �� ����� ������� � Edit mode, �� ������ Post
    procedure OnExit(Sender: TObject);
    procedure SetOnlyEditingCellOnEnter(const Value: boolean);
    function GetErasedColumn(Sender: TObject): TcxGridColumn;
    procedure SetSearchAsFilter(const Value: boolean);
    function GetColumnAddOn(FindColumn: TcxGridColumn): TColumnAddOn;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // ������ �� ������� � �����, ���� ���� ��� �������� �������� ������� ����/�����
    property DateEdit: TcxDateEdit read FDateEdit write SetDateEdit;
    // ������ ������ �� ������� ������������ ������
    property View: TcxGridTableView read FView write SetView;
    // ������ ������� �� DblClick
    property OnDblClickActionList;
    // ������ �������, ����������� �� ������� ������ � �����
    property ActionItemList;
    // �������� ��� ����������
    property SortImages;
    // ������������ ������ �� ������������� ������� �� Enter
    // � ������ ���������� ����� ������� � ������� ��������� ������ ������� �� ��� � c����������������� �� ������������� ������
    property OnlyEditingCellOnEnter: boolean read FOnlyEditingCellOnEnter write SetOnlyEditingCellOnEnter;
    // ������� �������������� �����
    property ColorRuleList: TCollection read FColorRuleList write FColorRuleList;
    // �������������� ��������� ��� �������
    property ColumnAddOnList: TCollection read FColumnAddOnList write FColumnAddOnList;
    // ������� �� ������ ������� �� Enter
    property ColumnEnterList: TCollection read FColumnEnterList write FColumnEnterList;
    // ����������� ��������� �� �������
    property SummaryItemList: TOwnedCollection read FSummaryItemList write FSummaryItemList;
    // ����� ��� ������
    property SearchAsFilter: boolean read FSearchAsFilter write SetSearchAsFilter default true;
    // ��� ��������� � True ����������� ���� ������ � ��� ��� ���������� �������
    property KeepSelectColor: boolean read FKeepSelectColor write FKeepSelectColor default false;

  end;

  TCrossDBViewAddOn = class(TdsdDBViewAddOn)
  private
    FHeaderDataSet: TDataSet;
    FTemplateColumn: TcxGridColumn;
    FHeaderColumnName: String;
    FBeforeOpen: TDataSetNotifyEvent;
    FAfterClose: TDataSetNotifyEvent;
    FEditing: TcxGridEditingEvent;
    FFocusedItemChanged: TcxGridFocusedItemChangedEvent;
    FDataSet: TDataSet;
    FCreateColumnList: TList;
    FCreateColorRuleList: TList;
    FNoCrossColorColumn : boolean;
    procedure onEditing(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
         var AAllow: Boolean);
    procedure onBeforeOpen(DataSet: TDataSet);
    procedure onAfterClose(DataSet: TDataSet);
    procedure SetView(const Value: TcxGridTableView); override;
    procedure FocusedItemChanged(Sender: TcxCustomGridTableView;
                                 APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property DataSet: TDataSet read FDataSet;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // ���� ��� � ��������� ������� � ������ ����������� ��� ������ �����������.
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    // ���� � HeaderDataSet � ���������� ������� �����
    property HeaderColumnName: String read FHeaderColumnName write FHeaderColumnName;
    // ������ ��� Cross �������
    property TemplateColumn: TcxGridColumn read FTemplateColumn write FTemplateColumn;
    // ������� ����� �� ���������� (���� ���� �� ��� �������)
    property NoCrossColorColumn : boolean read FNoCrossColorColumn write FNoCrossColorColumn default False;
  end;

  TPivotAddOn = class(TCustomDBControlAddOn)
  private
    FPivotGrid: TcxDBPivotGrid;
    FAfterOpen: TDataSetNotifyEvent;
    FOnGetContentStyleEvent : TcxPivotGridGetContentStyleEvent;
    FExpandRow : Integer;
    FExpandColumn : Integer;
    FColorRuleList: TCollection;
    FSummaryFieldList: TCollection;

    procedure SetPivotGrid(const Value: TcxDBPivotGrid);
    procedure OnAfterOpen(ADataSet: TDataSet);
    // ������ ���� ���� � ���������� ������ ��� �������� � Excel, ��������, ��� ������
    procedure OnGetContentStyle(Sender: TcxCustomPivotGrid;
      ACell: TcxPivotGridDataCellViewInfo; var AStyle: TcxStyle);
    // ������ ����������� �� �������
    procedure OnCalculateCustomSummary(
      Sender: TcxPivotGridField; ASummary: TcxPivotGridCrossCellSummary);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCurrentData: string;
  published
    property PivotGrid: TcxDBPivotGrid read FPivotGrid write SetPivotGrid;
    // ������ ������� �� DblClick
    property OnDblClickActionList;
    // ������ �������, ����������� �� ������� ������ � �����
    property ActionItemList;
    // ���������� �������������� �����
    property ExpandRow : Integer read FExpandRow write FExpandRow default 0;
    // ���������� �������������� ��������
    property ExpandColumn : Integer read FExpandColumn write FExpandColumn default 0;
    // ������� �������������� �����
    property ColorRuleList: TCollection read FColorRuleList write FColorRuleList;
    // ������� ����������� �� �������
    property SummaryList: TCollection read FSummaryFieldList write FSummaryFieldList;
  end;

  TCrossDBViewSetTypeId = class(TdsdCustomAction)
  private
    FCrossDBViewAddOn : TCrossDBViewAddOn;
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
    property CrossDBViewAddOn : TCrossDBViewAddOn read FCrossDBViewAddOn write FCrossDBViewAddOn;
  end;

  TdsdUserSettingsStorageAddOn = class(TComponent)
  private
    FOnDestroy: TNotifyEvent;
    FActive: boolean;
    procedure OnDestroy(Sender: TObject);
  public
    procedure SaveUserSettings;
    procedure LoadUserSettings;
    constructor Create(AOwner: TComponent); override;
  published
    property Active: boolean read FActive write FActive default true;
  end;

  TControlListItem = class(TCollectionItem)
  private
    FControl: TControl;
    procedure SetControl(const Value: TControl);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Control: TControl read FControl write SetControl;
  end;

  THeaderSaver = class;

  TControlList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TControlListItem;
    procedure SetItem(Index: Integer; const Value: TControlListItem);
  public
    function Add: TControlListItem;
    property Items[Index: Integer]: TControlListItem read GetItem write SetItem; default;
  end;

  // �������� ��������� ���������� ��� ������������ ��������� � ������ ��������� ��������
  THeaderSaver = class(TComponent)
  private
    { field to store the window handle }
    FHWnd: HWND;
    FNotSave: boolean;
    FControlList: TControlList;
    FStoredProc: TdsdStoredProc;
    FEnterValue: TStringList;
    FOnAfterShow: TNotifyEvent;
    FParam: TdsdParam;
    FGetStoredProc: TdsdStoredProc;
    FAfterExecute: TNotifyEvent;
    FAction: TCustomAction;
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    // ��������� ���������� ����� �������� ����� � ��������� FEnterValue ���������� �����������
    procedure OnAfterShow(Sender: TObject);
    procedure WndMethod(var Msg: TMessage);
    procedure SetGetStoredProc(Value: TdsdStoredProc);
    procedure AfterGetExecute(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // ��������� ����� �� ��� ��������, ����� ���������� ������� ��������
    procedure EnterAll;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
    property ControlList: TControlList read FControlList write FControlList;
    property GetStoredProc: TdsdStoredProc read FGetStoredProc write SetGetStoredProc;
    property ActionAfterExecute: TCustomAction read FAction write FAction;
  end;

  TChangerListItem = class(TCollectionItem)
  private
    FControl: TControl;
    procedure SetControl(const Value: TControl);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Control: TControl read FControl write SetControl;
  end;

  TChangerList = class(TOwnedCollection)
  private
    function GetChangerListItem(Index: Integer): TChangerListItem;
    procedure SetChangerListItem(Index: Integer; const Value: TChangerListItem);
  public
    function Add: TChangerListItem;
    property Items[Index: Integer]: TChangerListItem read GetChangerListItem write SetChangerListItem; default;
  end;

  THeaderChanger = class(TComponent)
  private
    FParam: TdsdParam;
    FChangerList: TChangerList;
    FAction: TCustomAction;
    procedure OnChange(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property ChangerList: TChangerList read FChangerList write FChangerList;
    property Action: TCustomAction read FAction write FAction;
  end;

  TRefreshAddOn = class(TComponent)
  private
    FFormName: string;
    FDataSet: string;
    FOnClose: TCloseEvent;
    FRefreshAction: string;
    FFormParams: string;
    FKeyField: string;
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FormName: string read FFormName write FFormName;
    property DataSet: string read FDataSet write FDataSet;
    property KeyField: string read FKeyField write FKeyField;
    property RefreshAction: string read FRefreshAction write FRefreshAction;
    property FormParams: string read FFormParams write FFormParams;
  end;

  TComponentListItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    FOnChange: TNotifyEvent;
    procedure SetComponent(const Value: TComponent);
    procedure OnChange(Sender: TObject);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Component: TComponent read FComponent write SetComponent;
  end;

  TExecuteDialog = class;

  TRefreshDispatcher = class(TComponent)
  private
    { field to store the window handle }
    FHWnd: HWND;
    FNotRefresh: boolean;
    FRefreshAction: TdsdDataSetRefresh;
    FComponentList: TCollection;
    FShowDialogAction: TExecuteDialog;
    FIdParam: TdsdParam;
    FCheckIdParam: boolean;
    procedure SetShowDialogAction(const Value: TExecuteDialog);
    procedure WndMethod(var Msg: TMessage);
    procedure SetFlag;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure OnComponentChange(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CheckIdParam: boolean read FCheckIdParam write FCheckIdParam default false;
    property IdParam: TdsdParam read FIdParam write FIdParam;
    property RefreshAction: TdsdDataSetRefresh read FRefreshAction write FRefreshAction;
    property ShowDialogAction: TExecuteDialog read FShowDialogAction write SetShowDialogAction;
    property ComponentList: TCollection read FComponentList write FComponentList;
  end;

  // ������� ������ � ��������� ��������� ����������
  TExecuteDialog = class (TdsdOpenForm)
  private
    FRefreshDispatcher: TRefreshDispatcher;
    FOpenBeforeShow: boolean;
    // ������ �������� ����������� - ��� ������ ��������
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    // ������ �������� ����� ������ � ������ �������� ������� �� �����. ��� �� �� ���� 2-� ������������� �������
    RefreshAllow: boolean;
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property RefreshDispatcher: TRefreshDispatcher read FRefreshDispatcher write FRefreshDispatcher;
    property OpenBeforeShow: boolean read FOpenBeforeShow write FOpenBeforeShow;
  end;

  TAddOnFormRefresh = Class(TPersistent)
  private
    FParentList: String;
    FSelfList: String;
    FDataSet: TDataSet;
    FKeyField: String;
    FKeyParam: String;
    FNeedRefresh: Boolean;
    FRefreshID: Variant;
    FGetStoredProc: TdsdStoredProc;

    function GetDataSet: TDataSet;
    procedure SetDatSet(Value: TDataSet);

    function GetGetStoredProc: TdsdStoredProc;
    procedure SetGetStoredProc(Value: TdsdStoredProc);
  public
    constructor Create;
    destructor Destroy; override;
    //��������� ���������� ������
    procedure RefreshRecord;

    property NeedRefresh: Boolean read FNeedRefresh write FNeedRefresh;
    property RefreshID: Variant read FRefreshID write FRefreshID;
  published
    // ������������� ������ ������������ �����
    property ParentList: String read FParentList write FParentList;
    // ������������� ������ ����������� �����
    property SelfList: String read FSelfList write FSelfList;
    // ������� �������
    property DataSet: TDataSet read GetDataSet write SetDatSet;
    //��� ��������� ����
    property KeyField: String read FKeyField write FKeyField;
    //��� ��������� ���������
    property KeyParam: String read FKeyParam write FKeyParam;
    //��������� ��������� �������
    property GetStoredProc: TdsdStoredProc read GetGetStoredProc write SetGetStoredProc;
  End;

  TAddOnFormData = class(TPersistent)
  private
    FChoiceAction: TdsdChoiceGuides;
    FParams: TdsdFormParams;
    FExecuteDialogAction: TExecuteDialog;
    FRefreshAction: TdsdDataSetRefresh;
    FisSingle: boolean;
    FisAlwaysRefresh: boolean;
    FisFreeAtClosing: boolean;
    FOnLoadAction: TdsdCustomAction;
    FAddOnFormRefresh: TAddOnFormRefresh;
  public
    constructor Create;
    destructor Destroy; override;
  published
    // ������ ������������ �����
    property isAlwaysRefresh: boolean read FisAlwaysRefresh write FisAlwaysRefresh default true;
    // ������� ���������� ����� �������� �����.
    property OnLoadAction: TdsdCustomAction read FOnLoadAction write FOnLoadAction;
    // ������� ���������� ��� ������������� �����
    property RefreshAction: TdsdDataSetRefresh read FRefreshAction write FRefreshAction;
    // ������ ����� ��������� � ������������ ����������. ���������, ��������, ��� ������������
    property isSingle: boolean read FisSingle write FisSingle default true;
    // ������ ����� ����� �������� �������������
    property isFreeAtClosing: boolean read FisFreeAtClosing write FisFreeAtClosing default false;
    // ������� ���������� ��� ������ ��������
    property ChoiceAction: TdsdChoiceGuides read FChoiceAction write FChoiceAction;
    // ������� �������� �������
    property ExecuteDialogAction: TExecuteDialog read FExecuteDialogAction write FExecuteDialogAction;
    // ��������� �����
    property Params: TdsdFormParams read FParams write FParams;
    // ��������� ��� ������������� �����
    property AddOnFormRefresh: TAddOnFormRefresh Read FAddOnFormRefresh Write FAddOnFormRefresh;
  end;

  TdsdGMMap = class(TGMMap)
  private
    FMapType: TMapAcionType;
    FDataSet: TDataSet;
    FMapLoad: Boolean;
    FGPSNField: string;
    FGPSEField: string;
    FAddressField: string;
    FInsertDateField: string;
    FIsShowRoute: Boolean;

    procedure LoadDefaultWebBrowser;
    procedure DoAfterPageLoaded(Sender: TObject; First: Boolean);
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetDocLoaded;

    property MapType: TMapAcionType read FMapType write FMapType default acShowOne;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property MapLoad: Boolean read FMapLoad write FMapLoad;
    property GPSNField: string read FGPSNField write FGPSNField;
    property GPSEField: string read FGPSEField write FGPSEField;
    property AddressField: string read FAddressField write FAddressField;
    property InsertDateField: string read FInsertDateField write FInsertDateField;
    property IsShowRoute: Boolean read FIsShowRoute write FIsShowRoute default False;
  end;

  TdsdWebBrowser = class(TWebBrowser)
  private
    FTimer: TTimer;
    FGeoCode: TGMGeoCode;
    FDirection: TGMDirection;

    procedure DoDownloadComplete(Sender: TObject);
    procedure OnTimerNotifyEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TWinControlListItem = class(TCollectionItem)
  private
    FControl: TWinControl;
    FStoredProc: TdsdStoredProc;
    FGotoControl: TWinControl;
    FAction: TCustomAction;
    FKeyDown : TKeyEvent;
    procedure SetControl(const Value: TWinControl);
    procedure SetGotoControl(const Value: TWinControl);
    procedure edKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Action: TCustomAction read FAction write FAction;
    property Control: TWinControl read FControl write SetControl;
    property GotoControl: TWinControl read FGotoControl write SetGotoControl;
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
  end;

  TTabSheetListItem = class(TCollectionItem)
  private
    FTabSheet: TcxTabSheet;
    FControl: TWinControl;
    FKeyDown : TKeyEvent;
    procedure SetTabSheet(const Value: TcxTabSheet);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property TabSheet: TcxTabSheet read FTabSheet write FTabSheet;
    property Control: TWinControl read FControl write FControl;
  end;

  TdsdEnterManager = class(TComponent)
  private
    FControlList: TCollection;
    FTabSheetList: TCollection;
    FPageControl: TcxPageControl;

    FOnChange: TNotifyEvent;
    procedure SetPageControl(const Value: TcxPageControl);
    procedure PageControl1Change(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ControlList: TCollection read FControlList write FControlList;
    property TabSheetList: TCollection read FTabSheetList write FTabSheetList;
    property PageControl: TcxPageControl read FPageControl write SetPageControl;
  end;

  procedure Register;

implementation

uses utilConvert, FormStorage, Xml.XMLDoc, XMLIntf,
     cxFilter, cxClasses, cxLookAndFeelPainters,
     cxGridCommon, math, cxPropertiesStore, UtilConst, cxStorage,
     cxGeometry, cxCheckBox, dxBar, cxButtonEdit, cxCurrencyEdit,
     VCL.Menus, ParentForm, ChoicePeriod, cxGrid, cxDBData, Variants,
     cxGridDBBandedTableView, cxGridDBDataDefinitions,cxGridBandedTableView,
     cxDropDownEdit, cxMemo, Dialogs, dsdException;

type

  TcxGridColumnHeaderViewInfoAccess = class(TcxGridColumnHeaderViewInfo);

procedure Register;
begin
  RegisterComponents('DSDComponent', [
    TCrossDBViewAddOn,
    THeaderSaver,
    THeaderChanger,
    TdsdDBTreeAddOn,
    TdsdDBViewAddOn,
    TdsdUserSettingsStorageAddOn,
    TRefreshAddOn,
    TRefreshDispatcher,
    TPivotAddOn,
    TdsdGMMap,
    TdsdWebBrowser,
    TdsdEnterManager
  ]);

  RegisterActions('DSDLib', [TExecuteDialog], TExecuteDialog);
end;

{ TdsdDBTreeAddOn }

procedure TdsdDBTreeAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) and (AComponent = DBTreeList) then
     DBTreeList := nil;
end;

procedure TdsdDBTreeAddOn.onColumnHeaderClick(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  // �������� ��� ������� Ctrl, Shift ��� Alt
  if not (ShiftDown or CtrlDown or AltDown) then
     raise ESortException.Create('');
end;

procedure TdsdDBTreeAddOn.onCustomDrawDataCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean);
begin
  if AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end;
end;

procedure TdsdDBTreeAddOn.onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
  var ADone: Boolean);
var
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
   with AViewInfo do begin
    Painter.DrawHeaderBorder(ACanvas,
      cxRectInflate(AViewInfo.BoundsRect, -1, -1),
      AViewInfo.Neighbors, AViewInfo.Borders);

    Painter.DrawHeaderEx(ACanvas,
      BoundsRect, TextBounds, Neighbors, Borders, State, AlignHorz, AlignVert,
      MultiLine, ShowEndEllipsis, Text, ViewParams.Font, ViewParams.TextColor,
      ViewParams.Color, nil);
   end;

   ASortingImageSize := 0;
   if Assigned(SortImages) then
      ASortingImageSize := SortImages.Width;

    R := AViewInfo.BoundsRect;
    R.Left := R.Right - ASortingImageSize - 3;
    InflateRect(R, -1, -1);
    if AViewInfo.SortOrder <> soNone then
    begin
      //ACanvas.Brush.Color := AViewInfo. Color;
      ACanvas.Brush.Style := bsClear;
      if AViewInfo.SortOrder = soAscending then
         ASortingImageIndex := min(0, 11)
      else
         ASortingImageIndex := 11 + min(0, 11);
      if Assigned(SortImages) then
         ACanvas.DrawImage(SortImages, R.Left, R.Top, ASortingImageIndex);
    end;

  ADone := true
end;

procedure TdsdDBTreeAddOn.onGetNodeImageIndex(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
  var AIndex: TImageIndex);
begin
  // ������������� ������� ��������
  if Assigned(FDBTreeList) then
    // ���� ��������, �� ������ ����������� ��������� �����!
    if ANode.Expanded then
       AIndex := 1
    else
       AIndex := 0;
end;

procedure TdsdDBTreeAddOn.SetDBTreeList(const Value: TcxDBTreeList);
begin
  FDBTreeList := Value;
  if Assigned(FDBTreeList) then begin
     FDBTreeList.OnKeyDown := OnKeyDown;
     FDBTreeList.OnDblClick := OnDblClick;
     FDBTreeList.onCustomDrawDataCell := onCustomDrawDataCell;
     FDBTreeList.OnGetNodeImageIndex := OnGetNodeImageIndex;
     FDBTreeList.OnColumnHeaderClick := OnColumnHeaderClick;
     FDBTreeList.OnCustomDrawHeaderCell := OnCustomDrawHeaderCell;
  end;
end;


procedure TdsdDBViewAddOn.ActionOnlyEditingCellOnEnter;
var i: integer;
    NextFocusIndex: integer;
begin
  if ColumnEnterList.Count <> 0 then begin
    // 1. ���� �� ������� ������� ������
    for i := View.Controller.FocusedColumnIndex + 1 to View.VisibleColumnCount - 1 do
        if inColumnEnterList(View.VisibleColumns[i]) then begin
           View.Controller.FocusedColumnIndex := View.VisibleColumns[i].VisibleIndex;
           if (not View.VisibleColumns[i].Editing) and (TcxDBDataController(FView.DataController).DataSource.State in dsEditModes) then
               TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
           if (ColumnEnterList.Count = 1) then View.VisibleColumns[i].Editing:=true;
           exit;
        end;

    for i := 0 to View.Controller.FocusedColumnIndex do
        if inColumnEnterList(View.VisibleColumns[i]) then
        begin
           View.Controller.FocusedColumnIndex := View.VisibleColumns[i].VisibleIndex;
           if  ((ColumnEnterList.Count = 1) and (TcxDBDataController(FView.DataController).DataSource.State in dsEditModes))
            or ((not View.VisibleColumns[i].Editing) and (TcxDBDataController(FView.DataController).DataSource.State in dsEditModes))
           then
               TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
           if (ColumnEnterList.Count = 1) then View.VisibleColumns[i].Editing:=true;
           exit;
        end;
  end
  else begin
    // 1. ������� ���� ����� ����
    NextFocusIndex := -1;
    for I := View.Controller.FocusedColumnIndex + 1 to View.VisibleColumnCount - 1 do
        if View.VisibleColumns[i].Editable then begin
           NextFocusIndex := i;
           break;
        end;
    // 2. ���� ���� ���� �� ���� �������, �� ���� �� ���� �������
    if NextFocusIndex > -1 then begin
       View.Controller.FocusedColumnIndex := NextFocusIndex;
       View.Controller.FocusedItem.Editing := true;
    end;
    // 3. ���� �� ���� ������� ������ � ��������� � ��������� ��������������, �� Post
    if (NextFocusIndex = -1) and (TcxDBDataController(FView.DataController).DataSource.State in [dsEdit, dsInsert]) then
       TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
    // 4. ���� ���� ���� �� ���������, �� ���� �� ���������
  end
end;

constructor TdsdDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  edFilter := TcxTextEdit.Create(Self);
  edFilter.OnKeyDown := edFilterKeyDown;
  edFilter.Visible := false;

  edFilter.OnExit := edFilterExit;
  FBackGroundStyle := TcxStyle.Create(nil);
  FBackGroundStyle.Color := $00E4E4E4;
  FErasedStyle := TcxStyle.Create(nil);
  FErasedStyle.TextColor := clRed;

  FColorRuleList := TCollection.Create(TColorRule);
  FColumnAddOnList := TCollection.Create(TColumnAddOn);
  FColumnEnterList := TCollection.Create(TColumnCollectionItem);
  FSummaryItemList := TOwnedCollection.Create(Self, TSummaryItemAddOn);

  SearchAsFilter := true;
  FKeepSelectColor := false;
end;

procedure TdsdDBViewAddOn.OnAfterOpen(ADataSet: TDataSet);
begin
  if Assigned(Self.FView) then
     if Assigned(Self.FView.Control) then
        TcxGrid(Self.FView.Control).EndUpdate;
  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);
end;

procedure TdsdDBViewAddOn.OnBeforeOpen(ADataSet: TDataSet);
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(ADataSet);
  if Assigned(Self.FView) then
     if Assigned(Self.FView.Control) then
        TcxGrid(Self.FView.Control).BeginUpdate;
end;

procedure TdsdDBViewAddOn.OnColumnHeaderClick(Sender: TcxGridTableView;
  AColumn: TcxGridColumn);
begin
  // �������� ��� ������� Ctrl, Shift ��� Alt
  if not (ShiftDown or CtrlDown or AltDown) then
     Abort;
end;

function TdsdDBViewAddOn.GetColumnAddOn(FindColumn: TcxGridColumn): TColumnAddOn;
var Item: TCollectionItem;
begin
  result := nil;
  for Item in ColumnAddOnList do
      if TColumnAddOn(Item).Column = FindColumn then
      begin
        result := TColumnAddOn(Item);
        break;
      end;
end;

function TdsdDBViewAddOn.GetErasedColumn(Sender: TObject): TcxGridColumn;
begin
  result := nil;
  if (Sender is TcxGridDBTableView) then
      result := TcxGridDBTableView(Sender).GetColumnByFieldName(FErasedFieldName);
  if (Sender is TcxGridDBBandedTableView) then
      result := TcxGridDBBandedTableView(Sender).GetColumnByFieldName(FErasedFieldName);
end;

procedure TdsdDBViewAddOn.OnCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
var Column: TcxGridColumn; i, j : integer; bManual : boolean;
begin

  bManual := False;

  if FKeepSelectColor and (AViewInfo.Selected or AViewInfo.Focused) then begin
    // �������� � ���������
    try
      for i := 0 to ColorRuleList.Count - 1 do
        with TColorRule(ColorRuleList.Items[i]) do begin
          if Assigned(ColorColumn) then
          begin
            if TcxGridDBTableView(Sender).Columns[AViewInfo.Item.Index] = ColorColumn then begin
             //������� Bold, !!!�� ��� �� ��������, ������� - ��������!!!!
             {isBold_calc:= false;
             if Assigned(ValueBoldColumn) then
                if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
                isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
             //

             if Assigned(ValueColumn) and (AViewInfo.GridRecord.ValueCount > ValueColumn.Index) then
                if not VarIsNull(AViewInfo.GridRecord.Values[ValueColumn.Index]) then begin
                   ACanvas.Font.Color := AViewInfo.GridRecord.Values[ValueColumn.Index];
                   bManual := True;
                end;
             if Assigned(BackGroundValueColumn) and (AViewInfo.GridRecord.ValueCount > BackGroundValueColumn.Index) then
                if not VarIsNull(AViewInfo.GridRecord.Values[BackGroundValueColumn.Index]) then begin
                begin
                  j := BackGroundValueColumn.Index;
                  ACanvas.Brush.Color := AViewInfo.GridRecord.Values[BackGroundValueColumn.Index];
                  bManual := True;
                end;
                end;
             end;
          end
          else begin
             //������� Bold, !!!�� ��� �� ��������, ������� - ��������!!!!
             {isBold_calc:= false;
             if Assigned(ValueBoldColumn) then
                if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
                isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
             //
             if Assigned(ValueColumn) then
                if not VarIsNull(AViewInfo.GridRecord.Values[ValueColumn.Index]) then begin
                   ACanvas.Font.Color := AViewInfo.GridRecord.Values[ValueColumn.Index];
                   bManual := True;
                end;
             if Assigned(BackGroundValueColumn) then
                if not VarIsNull(AViewInfo.GridRecord.Values[BackGroundValueColumn.Index]) then begin
                   ACanvas.Brush.Color := AViewInfo.GridRecord.Values[BackGroundValueColumn.Index];
                   ACanvas.Font.Color := clWindowText;
                   bManual := True;
                end;
          end;
        end;
    except
      on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(AViewInfo.GridRecord.ValueCount)  + ' ' +  IntToStr(J));
    end;
  end;

  if not bManual and AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     if SearchAsFilter then
        ACanvas.Font.Color := clHighlightText
     else
        ACanvas.Font.Color := clYellow;
  end;

  // �������� �� ��������� ������
  Column := GetErasedColumn(Sender);
  if Assigned(Column) then
     if not VarIsNull(AViewInfo.GridRecord.Values[Column.Index])
        and AViewInfo.GridRecord.Values[Column.Index] then
            ACanvas.Font.Color := FErasedStyle.TextColor;
end;

procedure TdsdDBViewAddOn.OnGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem;
  out AStyle: TcxStyle);
var Column: TcxGridColumn;
    i, j: integer;
    isBold_calc:Boolean;
begin
  if Assigned(FOnGetContentStyleEvent) then
     FOnGetContentStyleEvent(Sender, ARecord, AItem, AStyle);

  if ARecord = nil then exit;
  // ���� ��� ��������������� ������, �� �������
  if not ARecord.IsData then exit;

  // �������� �� ��������� ������
  Column := GetErasedColumn(Sender);
  if Assigned(Column) then
     if not VarIsNull(ARecord.Values[Column.Index])
        and ARecord.Values[Column.Index] then
            AStyle := FErasedStyle;

  // �������� � ���������
  try
    for i := 0 to ColorRuleList.Count - 1 do
      with TColorRule(ColorRuleList.Items[i]) do begin
        if Assigned(ColorColumn) then
        begin
          if AItem = ColorColumn then begin
           //������� Bold, !!!�� ��� �� ��������, ������� - ��������!!!!
           {isBold_calc:= false;
           if Assigned(ValueBoldColumn) then
              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
              isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
           //
           if Assigned(ValueColumn) and (ARecord.ValueCount > ValueColumn.Index) then
              if not VarIsNull(ARecord.Values[ValueColumn.Index]) then begin
                 FStyle.TextColor := ARecord.Values[ValueColumn.Index];
                 // if isBold_calc = true then FStyle.Font.Style:= [fsBold] else if Assigned(FStyle.Font) then FStyle.Font.Style:= [];
                 AStyle := FStyle
              end;
           if Assigned(BackGroundValueColumn) and (ARecord.ValueCount > BackGroundValueColumn.Index) then
              if not VarIsNull(ARecord.Values[BackGroundValueColumn.Index]) then begin
              begin
                j := BackGroundValueColumn.Index;
                FStyle.Color := ARecord.Values[BackGroundValueColumn.Index];
              end;
                 AStyle := FStyle
              end;
           end;
        end
        else begin
           //������� Bold, !!!�� ��� �� ��������, ������� - ��������!!!!
           {isBold_calc:= false;
           if Assigned(ValueBoldColumn) then
              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
              isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
           //
           if Assigned(ValueColumn) then
              if not VarIsNull(ARecord.Values[ValueColumn.Index]) then begin
                 FStyle.TextColor := ARecord.Values[ValueColumn.Index];
                 // if (isBold_calc = true)and Assigned(FStyle.Font) then FStyle.Font.Style:= [fsBold] else if Assigned(FStyle.Font) then FStyle.Font.Style:= [];
                 AStyle := FStyle
              end;
           if Assigned(BackGroundValueColumn) then
              if not VarIsNull(ARecord.Values[BackGroundValueColumn.Index]) then begin
                 FStyle.Color := ARecord.Values[BackGroundValueColumn.Index];
                 AStyle := FStyle
              end;
        end;
      end;
  except
    on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(ARecord.ValueCount)  + ' ' +  IntToStr(J));
  end;

end;


procedure TdsdDBViewAddOn.OnCustomDrawColumnHeader(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
  // ��� ��� ��������� "������" ������� - 10.04.2016
  if not AViewInfo.Column.HeaderGlyph.Empty then exit;

  ASortingImageSize := 0;
  if Assigned(SortImages) then
     ASortingImageSize := SortImages.Width;
  with AViewInfo do
  begin
    Sender.Painter.LookAndFeelPainter.DrawHeader(ACanvas, Bounds, TextAreaBounds, Neighbors,
      Borders, ButtonState, AlignmentHorz, AlignmentVert, MultiLinePainting, TcxGridColumnHeaderViewInfoAccess(AViewinfo).ShowEndEllipsis,
      Text, Params.Font, Params.TextColor, Params.Color,
      nil, Column.IsMostRight,
      Container.Kind = ckGroupByBox);
    R := AViewInfo.ContentBounds;
    R.Left := R.Right - ASortingImageSize - 3;
    InflateRect(R, -1, -1);
    with TcxGridColumnHeaderViewInfoAccess(AViewinfo) do
      for I := 0 to AreaViewInfoCount - 1 do
        if AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
        begin
          if AViewInfo.ButtonState = cxbsHot then
          begin
            Sender.Painter.LookAndFeelPainter.DrawFilterDropDownButton(Canvas, AreaViewInfos[I].Bounds,
              GridCellStateToButtonState(AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AreaViewInfos[I]).Active);
            R.Right := AreaViewInfos[I].Bounds.Left - 3;
            R.Left := R.Right - ASortingImageSize;
          end;
        end;
    if AViewInfo.Column.SortOrder <> soNone then
    begin
      ACanvas.Brush.Color := AViewInfo.Params.Color;
      ACanvas.Brush.Style := bsClear;
      if AViewInfo.Column.SortOrder = soAscending then
         ASortingImageIndex := min(AViewInfo.Column.SortIndex, 11)
      else
         ASortingImageIndex := 11 + min(AViewInfo.Column.SortIndex, 11);
      if Assigned(SortImages) then
         ACanvas.DrawImage(SortImages, R.Left, R.Top, ASortingImageIndex);
    end;
    ADone := True;
  end;
end;

procedure TdsdDBViewAddOn.OnExit(Sender: TObject);
begin
  if Assigned(FonExit) then
     FOnExit(Sender);
  if Assigned(FView) then
     if Assigned(TcxDBDataController(FView.DataController).DataSource) then
        if TcxDBDataController(FView.DataController).DataSource.State in dsEditModes then
           try
             TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
             // � ������ ������ ��������� �����
           except
             on E: Exception do begin
               FView.Control.SetFocus;
               raise;
             end;
           end;
end;

procedure TdsdDBViewAddOn.onFilterChanged(Sender: TObject);
begin
  if FView.DataController.Filter.Root.Count > 0 then
     FView.Styles.Background := FBackGroundStyle
  else
     FView.Styles.Background := nil
end;

destructor TdsdDBViewAddOn.Destroy;
begin
  if Assigned(FView) then begin
    FView.OnKeyDown := nil;
    FView.OnKeyPress := nil;
    FView.OnCustomDrawColumnHeader := nil;
    FView.DataController.Filter.OnChanged := nil;
    FView.OnColumnHeaderClick := nil;
    FView.OnDblClick := nil;
    FView.OnCustomDrawCell := nil;
    if Assigned(TcxDBDataController(FView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FView.DataController).DataSource.DataSet) then
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert := nil;
  end;
  FErasedStyle.Free;
  FreeAndNil(FColumnAddOnList);
  FreeAndNil(FColumnEnterList);
  inherited;
end;

procedure TdsdDBViewAddOn.edFilterExit(Sender: TObject);
begin
  edFilter.Visible:=false;
  TWinControl(FView.GetParentComponent).SetFocus;
  FView.Focused := true;
end;

procedure TdsdDBViewAddOn.edFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin lpSetFilter; Key := 0; end;
    VK_ESCAPE: edFilterExit(Sender);
  end;
end;

procedure TdsdDBViewAddOn.GridEditKeyEvent(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FGridEditKeyEvent) then
     FGridEditKeyEvent(Sender, AItem, AEdit, Key, Shift);
  // ���� ����� ������ Enter � OnlyEditingCellOnEnter
  if (Key = VK_RETURN) and (Shift = []) and OnlyEditingCellOnEnter then begin
     ActionOnlyEditingCellOnEnter;
     Key := 0;
  end;
end;

function TdsdDBViewAddOn.inColumnEnterList(Column: TcxGridColumn): boolean;
var i: integer;
begin
  result := false; //ColumnEnterList.Count = 1;
  for i := 0 to ColumnEnterList.Count - 1  do
      if Column = TColumnCollectionItem(ColumnEnterList.Items[i]).Column then begin
         result := true;
         break;
      end;
end;

procedure TdsdDBViewAddOn.Loaded;
var i: integer;
begin
  inherited;
  // ���������� ������ ColumnAddOnList
  for I := 0 to ColumnAddOnList.Count - 1 do
      TColumnAddOn(ColumnAddOnList.Items[i]).Init;
  for I := 0 to SummaryItemList.Count - 1 do
      TSummaryItemAddOn(SummaryItemList.Items[i]).DataSummaryItemIndex := TSummaryItemAddOn(SummaryItemList.Items[i]).DataSummaryItemIndex
end;

procedure TdsdDBViewAddOn.lpSetEdFilterPos(inKey: Char);
// ��������� ������������� ������� ��� �������� �������� ������� � ��������������� �� ��������� �������
var pRect:TRect;
begin
 if (not edFilter.Visible) then
   with FView.Controller do begin
     // ������������� ������� �� ����� ���������
     edFilter.Visible := true;
     edFilter.Parent := TWinControl(FView.GetParentComponent);
     pRect := TcxGridTableView(GridView).ViewInfo.HeaderViewInfo.Items[FocusedItemIndex].Bounds;
     edFilter.Left := pRect.Left;
     edFilter.Top := pRect.Top;
     edFilter.Width := pRect.Right - pRect.Left + 1;
     edFilter.Height := pRect.Bottom - pRect.Top;
     edFilter.SetFocus;
     edFilter.Text := inKey;
     edFilter.SelStart := 1;
     edFilter.SelLength := 0;
   end;
end;

procedure TdsdDBViewAddOn.lpSetFilter;
   function GetFilterItem(ItemLink: TObject): TcxFilterCriteriaItem;
   var i: integer;
   begin
     result := nil;
     with FView.DataController.Filter.Root do
       for i := 0 to Count - 1 do
           if Items[i] is TcxFilterCriteriaItem then
              if TcxFilterCriteriaItem(Items[i]).ItemLink = ItemLink then begin
                 result := TcxFilterCriteriaItem(Items[i]);
                 exit;
              end;
   end;
var
  FilterCriteriaItem: TcxFilterCriteriaItem;
  vbValue: string;
  CurrentColumn: TcxGridColumn;
  ColumnAddOn: TColumnAddOn;
begin
  CurrentColumn := View.VisibleColumns[TcxGridDBDataController(FView.DataController).Controller.FocusedItemIndex];
  ColumnAddOn := GetColumnAddOn(CurrentColumn);

  if Assigned(ColumnAddOn) and ColumnAddOn.FindByFullValue then
  begin
    if ShiftDown then
       vbValue := '%' + edFilter.Text + '%'
    else
       vbValue := edFilter.Text;
  end
  else begin
    if (length(edFilter.Text) = 1) and (not CharInSet(edFilter.Text[1], ['0'..'9'])) then
       vbValue := edFilter.Text + '%'
    else begin
       if ShiftDown then
          vbValue := edFilter.Text
       else
          vbValue := '%' + edFilter.Text + '%';
    end;
  end;
  edFilter.Visible := false;
  with TcxGridDBDataController(FView.DataController), Filter.Root do begin
    FilterCriteriaItem := GetFilterItem(GetItem(CurrentColumn.Index));
    if Assigned(FilterCriteriaItem) then begin
       FilterCriteriaItem.Value := vbValue;
       FilterCriteriaItem.DisplayValue := '"' + edFilter.Text + '"';
    end
    else
       AddItem(GetItem(CurrentColumn.Index), foLike, vbValue, '"' + edFilter.Text + '"');
  end;
  edFilter.Text := '';
  View.DataController.Filter.Active := True;
  if View.DataController.FilteredRecordCount > 0 then
     View.DataController.FocusedRecordIndex := View.DataController.FilteredRecordIndex[0];
end;

procedure TdsdDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FView) then begin
     FView := nil;
  end;
end;

procedure TdsdDBViewAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (View.DataController.Filter.Active) then begin
      View.DataController.Filter.Clear;
      View.DataController.Filter.Active := false;
  end;
  if (Key = VK_RETURN) and (Shift = []) and OnlyEditingCellOnEnter then begin
     ActionOnlyEditingCellOnEnter;
     Key := 0;
  end;
  if Key = VK_F11 then
     SearchAsFilter := not SearchAsFilter;
  inherited;
end;

procedure TdsdDBViewAddOn.OnKeyPress(Sender: TObject; var Key: Char);
var isReadOnly: boolean;
begin
  isReadOnly := false;
  if Assigned(FView.Controller.FocusedColumn) then
  begin
     if Assigned(TcxGridDBColumn(FView.Controller.FocusedColumn).Properties) then
       isReadOnly := TcxGridDBColumn(FView.Controller.FocusedColumn).Properties.ReadOnly;
    // ���� ������� �� ������������ � ������� ����� ��� BackSpace �� ������������ ��������� �������
    if SearchAsFilter and (isReadOnly or (not TcxGridDBColumn(FView.Controller.FocusedColumn).Editable)) and (Key > #31) then
    begin
       lpSetEdFilterPos(Char(Key));
       Key := #0;
    end;
  end;
end;

procedure TdsdDBViewAddOn.SetOnlyEditingCellOnEnter(const Value: boolean);
begin
  FOnlyEditingCellOnEnter := Value;
end;

procedure TdsdDBViewAddOn.SetSearchAsFilter(const Value: boolean);
begin
  FSearchAsFilter := Value;
  if Assigned(FView) then
     FView.OptionsBehavior.IncSearch := not FSearchAsFilter;
end;

procedure TdsdDBViewAddOn.SetDateEdit(const Value: TcxDateEdit);
begin
  FDateEdit := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FDateEdit) then begin
    FDateEdit.Date:=Now;
  end;
end;

procedure TdsdDBViewAddOn.SetView(const Value: TcxGridTableView);
begin
  FView := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FView) then begin
    if FView.Control is TcxGrid then begin
       FOnExit := TcxGrid(FView.Control).OnExit;
       TcxGrid(FView.Control).OnExit := OnExit;
    end;
    FGridFocusedItemChangedEvent := FView.OnFocusedItemChanged;
    FView.OnFocusedItemChanged := TableViewFocusedItemChanged;
    FOnKeyDown := FView.OnKeyDown;
    FView.OnKeyDown := OnKeyDown;
    FView.OnKeyPress := OnKeyPress;
    FView.OnCustomDrawColumnHeader := OnCustomDrawColumnHeader;
    FView.DataController.Filter.OnChanged := onFilterChanged;
    FView.OnColumnHeaderClick := OnColumnHeaderClick;
    FView.OnDblClick := OnDblClick;
    FView.OnCustomDrawCell := OnCustomDrawCell;
    FGridEditKeyEvent := FView.OnEditKeyDown;
    FView.OnEditKeyDown := GridEditKeyEvent;
    FOnGetContentStyleEvent := FView.Styles.OnGetContentStyle;
    FView.Styles.OnGetContentStyle := Nil;
    FView.Styles.OnGetContentStyle := OnGetContentStyle;

    if Assigned(TcxDBDataController(FView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FView.DataController).DataSource.DataSet) then begin
          FAfterInsert := TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert;
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert := OnAfterInsert;
          FBeforeOpen := TcxDBDataController(FView.DataController).DataSource.DataSet.BeforeOpen;
          TcxDBDataController(FView.DataController).DataSource.DataSet.BeforeOpen := OnBeforeOpen;
          FAfterOpen := TcxDBDataController(FView.DataController).DataSource.DataSet.AfterOpen;
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterOpen := OnAfterOpen;
     end;
  end;
end;

procedure TdsdDBViewAddOn.TableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
var i: integer;
begin
  if Assigned(FGridFocusedItemChangedEvent) then
     FGridFocusedItemChangedEvent(Sender, APrevFocusedItem, AFocusedItem);
  for i := 0 to ColumnAddOnList.Count - 1 do
      with TColumnAddOn(ColumnAddOnList.Items[i]) do
         if onExitColumn.Active then begin
            if Column = APrevFocusedItem then
                onExitColumn.Action.Execute;
         end;
end;

{ TdsdUserSettingsStorageAddOn }

constructor TdsdUserSettingsStorageAddOn.Create(AOwner: TComponent);
begin
  // �������� �� ���������
  FActive := true;
  inherited;
  if csDesigning in ComponentState then
     exit;
  if AOwner is TForm then begin
     FOnDestroy := TForm(AOwner).OnDestroy;
     TForm(AOwner).OnDestroy := Self.OnDestroy;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.OnDestroy(Sender: TObject);
begin
  if csDesigning in ComponentState then
     exit;
  if Active then
    SaveUserSettings;
  if Assigned(FOnDestroy) then
     FOnDestroy(Sender);
end;

procedure TdsdUserSettingsStorageAddOn.LoadUserSettings;
var
  Data: String;
  XMLDocument: IXMLDocument;
  i: integer;
  PropertiesStore: TcxPropertiesStore;
  GridView: TcxCustomGridView;
  TreeList: TcxDBTreeList;
  FormName: string;
  PropertiesStoreComponent: TcxPropertiesStoreComponent;
begin
  if gc_isSetDefault then
     exit;
  if Owner is TParentForm then
     FormName := TParentForm(Owner).FormClassName
  else
     FormName := Owner.ClassName;
  Data := TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(FormName);
  if Data <> '' then begin
    XMLDocument := TXMLDocument.Create(nil);
    XMLDocument.LoadFromXML(Data);
    with XMLDocument.DocumentElement do begin
      for I := 0 to ChildNodes.Count - 1 do begin
        if ChildNodes[i].NodeName = 'cxGridView' then begin
           GridView := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxCustomGridView;
           if Assigned(GridView) then
              GridView.RestoreFromStream(TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data'))),False);
        end;
        if ChildNodes[i].NodeName = 'cxTreeList' then begin
           TreeList := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxDBTreeList;
           if Assigned(TreeList) then
              TreeList.RestoreFromStream(TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data'))));
        end;
{        if ChildNodes[i].NodeName = 'dxBarManager' then begin
           BarManager := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TdxBarManager;
           if Assigned(BarManager) then
              BarManager.LoadFromStream(TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data'))));
        end;}
        if ChildNodes[i].NodeName = 'cxPropertiesStore' then begin
           PropertiesStore := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxPropertiesStore;
           if Assigned(PropertiesStore) then begin
              PropertiesStore.StorageType := stStream;
              PropertiesStore.StorageStream := TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data')));
              PropertiesStore.RestoreFrom;
              PropertiesStore.StorageStream.Free;
              // �������� � ��������� �������� ��� ���������� ������� � ����� �����
              if PropertiesStore.Components.FindComponentItemByComponent(Owner, PropertiesStoreComponent) then begin
                 if PropertiesStoreComponent.Properties.IndexOf('Top') = -1 then
                    PropertiesStoreComponent.Properties.Add('Top');
                 if PropertiesStoreComponent.Properties.IndexOf('Width') = -1 then
                    PropertiesStoreComponent.Properties.Add('Width');
                 if PropertiesStoreComponent.Properties.IndexOf('Left') = -1 then
                    PropertiesStoreComponent.Properties.Add('Left');
                 if PropertiesStoreComponent.Properties.IndexOf('Height') = -1 then
                    PropertiesStoreComponent.Properties.Add('Height');
              end
              else
                 with PropertiesStore.Components.Add do begin
                      Properties.Add('Top');
                      Properties.Add('Width');
                      Properties.Add('Left');
                      Properties.Add('Height');
                 end;
           end;
        end;
      end;
    end;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.SaveUserSettings;
var
  TempStream: TStringStream;
  i: integer;
  xml: string;
  FormName: string;
begin
  if gc_isSetDefault then
     exit;
  if Owner is TParentForm then
     FormName := TParentForm(Owner).FormClassName
  else
     FormName := Owner.ClassName;
  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // ��������� ��������� ������
    for i := 0 to Owner.ComponentCount - 1 do begin
{      if Owner.Components[i] is TdxBarManager then
         with TdxBarManager(Owner.Components[i]) do begin
           SaveToStream(TempStream);
           xml := xml + '<dxBarManager name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;}
      if Owner.Components[i] is TcxCustomGridView then
         with TcxCustomGridView(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxGridView name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if Owner.Components[i] is TcxDBTreeList then
         with TcxDBTreeList(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxTreeList name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      // ��������� ��������� ���������
      if Owner.Components[i] is TcxPropertiesStore then
         with Owner.Components[i] as TcxPropertiesStore do begin
            StorageType := stStream;
            StorageStream := TempStream;
            StoreTo;
            xml := xml + '<cxPropertiesStore name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '"/>';
            TempStream.Clear;
         end;
    end;
    xml := xml + '</root>';
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(FormName, gfStrToXmlStr(xml));
  finally
    TempStream.Free;
  end;
end;


{ THeaderSaver }

procedure THeaderSaver.AfterGetExecute(Sender: TObject);
begin
  if Assigned(FAfterExecute) then
     FAfterExecute(Sender);
  EnterAll;
end;

constructor THeaderSaver.Create(AOwner: TComponent);
begin
  inherited;
  FHWnd := AllocateHWnd(WndMethod);
  FNotSave := false;
  FParam := TdsdParam.Create(nil);
  FControlList := TControlList.Create(Self, TControlListItem);
  FEnterValue := TStringList.Create;
  if Self.Owner is TParentForm then begin
     FOnAfterShow := TParentForm(Owner).onAfterShow;
     TParentForm(Owner).onAfterShow := onAfterShow;
  end;
end;

destructor THeaderSaver.Destroy;
begin
  FParam.Free;
  FControlList.Free;
  FEnterValue.Free;
  DeallocateHWnd(FHWnd);
  if Self.Owner is TParentForm then
     TParentForm(Owner).onAfterShow := FOnAfterShow;
  inherited;
end;

procedure THeaderSaver.EnterAll;
var
   Item: TCollectionItem;
begin
  for Item in FControlList do
      onEnter(TControlListItem(Item).Control)
end;

procedure THeaderSaver.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent is TControl then begin
         for i := 0 to ControlList.Count - 1 do
            if ControlList[i].Control = AComponent then
               ControlList[i].Control := nil;
      end;
      if AComponent = StoredProc then
         StoredProc := nil;
      if AComponent = FGetStoredProc then
         FGetStoredProc := nil;
    end;
end;

procedure THeaderSaver.OnAfterShow(Sender: TObject);
begin
  if Assigned(FOnAfterShow) then
     FOnAfterShow(Sender);
  EnterAll;
end;

procedure THeaderSaver.OnEnter(Sender: TObject);
var
  DateTime: TDateTime;
begin
  if Sender is TcxTextEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxTextEdit).Text;
  if Sender is TcxMemo then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxMemo).Text;
  if Sender is TcxButtonEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then begin
        DateTime := (Sender as TcxDateEdit).Date;
        if DateTime = -700000 then
           DateTime := 0;
     FEnterValue.Values[TComponent(Sender).Name] := DateToStr(DateTime);
  end;
  if Sender is TcxCheckBox then
     FEnterValue.Values[TComponent(Sender).Name] := BoolToStr((Sender as TcxCheckBox).Checked);
  if Sender is TcxComboBox then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxComboBox).Text;
end;

procedure THeaderSaver.OnExit(Sender: TObject);
var isChanged: boolean;
begin
  isChanged := false;
  if FNotSave then
     exit;
  if not Assigned(IdParam) then
     raise Exception.Create('�� ����������� �������� IdParam');
  if (IdParam.Value = 0) or VarIsNull(IdParam.Value) then
      exit;
  if Sender is TcxTextEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxTextEdit).Text;
  if Sender is TcxMemo then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxMemo).Text;
  if Sender is TcxButtonEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then begin
     isChanged := ((TcxDateEdit(Sender).Text = '') AND (FEnterValue.Values[TComponent(Sender).Name] <> '')) or
                  (FEnterValue.Values[TComponent(Sender).Name] <> DateToStr((Sender as TcxDateEdit).Date));
  end;
  if Sender is TcxCheckBox then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> BoolToStr((Sender as TcxCheckBox).Checked);
  if Sender is TcxComboBox then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxComboBox).Text;

  try
    if isChanged then
       StoredProc.Execute;
    if isChanged and Assigned(FAction) then
       FAction.Execute;
  // ���� � ������ ���������� ��������� ������, �� ������ ������ �������� �� ����
  except
    if Assigned(GetStoredProc) then
       GetStoredProc.Execute;
    raise;
  end;
  FNotSave := true;
  PostMessage(FHWnd, WM_SETFLAGHeaderSaver, 0, 0);
end;

procedure THeaderSaver.SetGetStoredProc(Value: TdsdStoredProc);
begin
  //���� ������ �� ���������� - �������
  if Value = FGetStoredProc then exit;
  //���� �������� ��������� - ���������� ������ ��������� � ������������
  if FGetStoredProc <> nil then
    FGetStoredProc.AfterExecute := FAfterExecute;
  FGetStoredProc := Value;
  //���� ��������� ����������� - ������ �� ������������
  if Assigned(FGetStoredProc) then
  Begin
    FAfterExecute := FGetStoredProc.AfterExecute;
    FGetStoredProc.AfterExecute := AfterGetExecute;
  End;
end;

procedure THeaderSaver.WndMethod(var Msg: TMessage);
var
  Handled: Boolean;
begin
  // Assume we handle message
  Handled := True;
  case Msg.Msg of
    WM_SETFLAGHeaderSaver: FNotSave := false;
    else
      // We didn't handle message
      Handled := False;
  end;
  if Handled then
    // We handled message - record in message result
    Msg.Result := 0
  else
    // We didn't handle message
    // pass to DefWindowProc and record result
    Msg.Result := DefWindowProc(fHWnd, Msg.Msg,
      Msg.WParam, Msg.LParam);
end;

{ TControlList }

function TControlList.Add: TControlListItem;
begin
  result := TControlListItem(inherited Add);
end;

function TControlList.GetItem(Index: Integer): TControlListItem;
begin
  Result := TControlListItem(inherited GetItem(Index));
end;

procedure TControlList.SetItem(Index: Integer; const Value: TControlListItem);
begin
  inherited SetItem(Index, Value);
end;

{ TControlListItem }

procedure TControlListItem.Assign(Source: TPersistent);
begin
  if Source is TControlListItem then
     Self.Control := TControlListItem(Source).Control
  else
    inherited; //raises an exception
end;

function TControlListItem.GetDisplayName: string;
begin
  if Assigned(Control) then
     result := Control.Name
  else
     result := inherited;
end;

procedure TControlListItem.SetControl(const Value: TControl);
begin
  if FControl <> Value then begin
    FControl := Value;
    if Assigned(Value) and Assigned(Collection) then begin
       Value.FreeNotification(TComponent(Collection.Owner));
       if (Collection.Owner is THeaderSaver) then begin
          if FControl is TcxTextEdit then begin
             (FControl as TcxTextEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxTextEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxMemo then begin
             (FControl as TcxMemo).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxMemo).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxDateEdit then begin
             (FControl as TcxDateEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxDateEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxButtonEdit then begin
             (FControl as TcxButtonEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxButtonEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxCheckBox then begin
             (FControl as TcxCheckBox).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxCheckBox).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxCurrencyEdit then begin
             (FControl as TcxCurrencyEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxCurrencyEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxComboBox then begin
             (FControl as TcxComboBox).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxComboBox).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
       end;
    end;
  end;
end;

{ TRefreshAddOn }

constructor TRefreshAddOn.Create(AOwner: TComponent);
begin
  inherited;
  DataSet := 'ClientDataSet';
  RefreshAction := 'actRefresh';
  FormParams := 'FormParams';
  FKeyField := 'Id';
  if AOwner is TForm then begin
     FOnClose := (AOwner as TForm).OnClose;
     (AOwner as TForm).OnClose := Self.OnClose;
  end;
end;

destructor TRefreshAddOn.Destroy;
begin
  if Owner is TForm then
     TForm(Owner).OnClose := FOnClose;
  inherited;
end;

procedure TRefreshAddOn.OnClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  // ������������ � ���������������
  // ������ ������� ������� ����� ���������� ����
  for I := 0 to Screen.FormCount - 1 do
      if lowercase(Screen.Forms[i].Name) = lowercase(FormName) then
         with Screen.Forms[i] do begin
           if Assigned(FindComponent(RefreshAction)) then
              TdsdDataSetRefresh(FindComponent(RefreshAction)).Execute;
           if Assigned(FindComponent(DataSet)) and Assigned(Self.Owner.FindComponent(FormParams)) then
              if Assigned(TDataSet(FindComponent(DataSet)).FindField(KeyField)) then
                 TDataSet(FindComponent(DataSet)).Locate(KeyField, TdsdFormParams(Self.Owner.FindComponent(FormParams)).ParamByName(FKeyField).AsString, []);
         end;
  if Assigned(FOnClose) then
     FOnClose(Sender, Action);
end;

{ TCustomDBControlAddOn }

constructor TCustomDBControlAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FErasedFieldName := gcisErased;
  ActionItemList := TActionItemList.Create(Self, TShortCutActionItem);
  OnDblClickActionList := TActionItemList.Create(Self, TActionItem);
end;

procedure TCustomDBControlAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
    if (Operation = opRemove) then begin
      if AComponent is TCustomAction then begin
         for i := 0 to ActionItemList.Count - 1 do
            if ActionItemList[i].Action = AComponent then
               ActionItemList[i].Action := nil;
         for i := 0 to OnDblClickActionList.Count - 1 do
            if OnDblClickActionList[i].Action = AComponent then
               OnDblClickActionList[i].Action := nil;
      end;
      if AComponent = SortImages then
         SortImages := nil
    end;
end;

procedure TCustomDBControlAddOn.OnAfterInsert(DataSet: TDataSet);
var Field: TField;
begin
  if Assigned(FAfterInsert) then
     FAfterInsert(DataSet);
  Field := DataSet.FindField(ErasedFieldName);
  if Assigned(Field) then
     Field.AsBoolean := false;
end;

procedure TCustomDBControlAddOn.OnDblClick(Sender: TObject);
var i: integer;
begin
  // ��������� ������� �� DblClick
  for I := 0 to FOnDblClickActionList.Count - 1 do
    if Assigned(FOnDblClickActionList[i].Action) then
       if OnDblClickActionList[i].Action.Enabled then begin
          // ��������� ������ �������� � ������
          OnDblClickActionList[i].Action.Execute;
          // � ����� �����!!!
          exit;
       end;
end;

procedure TCustomDBControlAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
begin                       
  if Assigned(FOnKeyDown) then
     FOnKeyDown(Sender, Key, Shift);

  // ������� �������� ��� action
  // � ���� ��� ��� ������, �� ����� ���� ������
  for I := 0 to ActionItemList.Count - 1 do
      if ShortCut(Key, Shift) = TShortCutActionItem(ActionItemList[i]).ShortCut then begin
         if ActionItemList[i].Action.Enabled then begin
            // ��������� ������ �������� � ������
            ActionItemList[i].Action.Execute;
            Key := 0;
            Shift := [];
            // � ����� �����!!!
            exit;
         end;
      end;
end;

{ TRefreshDispatcher }

constructor TRefreshDispatcher.Create(AOwner: TComponent);
begin
  inherited;
  ComponentList := TOwnedCollection.Create(Self, TComponentListItem);
  FIdParam := TdsdParam.Create(nil);
  CheckIdParam := false;
  FNotRefresh := false;
  FHWnd := AllocateHWnd(WndMethod);
end;

destructor TRefreshDispatcher.Destroy;
begin
  DeallocateHWnd(FHWnd);
  FreeAndNil(FComponentList);
  FreeAndNil(FIdParam);
  inherited;
end;

procedure TRefreshDispatcher.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent = FRefreshAction then
         FRefreshAction := nil;
      if AComponent = FShowDialogAction then
         FShowDialogAction := nil;
      for i := 0 to ComponentList.Count - 1 do
         if TComponentListItem(ComponentList.Items[i]).Component = AComponent then
            TComponentListItem(ComponentList.Items[i]).Component := nil;
    end;
end;

procedure TRefreshDispatcher.OnComponentChange(Sender: TObject);
var fNeedRefreshOnExecute_calc: Boolean; // add 22.01.2018
begin
  // add 22.01.2018
  fNeedRefreshOnExecute_calc:= true;
  //
  if FNotRefresh then
     exit;
  if CheckIdParam then
  begin
     if (IdParam.asString = '') or (IdParam.asString = '0') or (IdParam.Value=NULL) then
        exit;
     //
     // add 22.01.2018 - �������� �������� ���������, ����� �� �� ��������� - �� ����� ������������
     if Assigned (TParentForm(Self.Owner).AddOnFormData.Params) then
        if TParentForm(Self.Owner).AddOnFormData.Params.ParamByName(IdParam.ComponentItem) <> nil
        then fNeedRefreshOnExecute_calc:= TParentForm(Self.Owner).AddOnFormData.Params.ParamByName(IdParam.ComponentItem).isValueChange;
  end;

  if Assigned(FRefreshAction) then
  // ������������ ������� ������ ���� ����� ���������
     if Assigned(Self.Owner) and (Self.Owner is TParentForm) then
        if TParentForm(Self.Owner).Visible then
           FRefreshAction.Execute
        else
           TParentForm(Self.Owner).NeedRefreshOnExecute := fNeedRefreshOnExecute_calc; // change 22.01.2018
  FNotRefresh := true;
  SetFlag;
end;

procedure TRefreshDispatcher.SetFlag;
begin
  PostMessage(FHWnd, WM_SETFLAG, 0, 0);
end;

procedure TRefreshDispatcher.SetShowDialogAction(const Value: TExecuteDialog);
begin
  if FShowDialogAction <> Value then begin
     if Assigned(Value) then
        Value.RefreshDispatcher := Self;
     if Assigned(FShowDialogAction) then
        FShowDialogAction.RefreshDispatcher := nil;
     FShowDialogAction := Value;
  end;
end;

procedure TRefreshDispatcher.WndMethod(var Msg: TMessage);
var
  Handled: Boolean;
begin
  // Assume we handle message
  Handled := True;
  case Msg.Msg of
    WM_SETFLAG: FNotRefresh := false;
    else
      // We didn't handle message
      Handled := False;
  end;
  if Handled then
    // We handled message - record in message result
    Msg.Result := 0
  else
    // We didn't handle message
    // pass to DefWindowProc and record result
    Msg.Result := DefWindowProc(fHWnd, Msg.Msg,
      Msg.WParam, Msg.LParam);
end;

{ TComponentListItem }

procedure TComponentListItem.Assign(Source: TPersistent);
begin
  if Source is TComponentListItem then
     with TComponentListItem(Source) do begin
       Self.Component := Component;
     end
  else
    inherited Assign(Source);
end;

function TComponentListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FComponent) then
     result := FComponent.Name
end;

procedure TComponentListItem.OnChange(Sender: TObject);
begin
  // �������� onChange ���� ���
  if Assigned(FOnChange) then
     FOnChange(Sender);
  // ������������ �������
  if Assigned(TRefreshDispatcher(Collection.Owner)) then
     TRefreshDispatcher(Collection.Owner).OnComponentChange(Sender);
end;

procedure TComponentListItem.SetComponent(const Value: TComponent);
begin
  FComponent := Value;
  if Assigned(FComponent) then begin
     if Assigned(Collection) then
        FComponent.FreeNotification(TComponent(Collection.Owner));
     if FComponent is TPeriodChoice then begin
        FOnChange := TPeriodChoice(FComponent).onChange;
        TPeriodChoice(FComponent).onChange := OnChange;
     end;
     if FComponent is TdsdGuides then begin
        FOnChange := TdsdGuides(FComponent).onChange;
        TdsdGuides(FComponent).onChange := OnChange;
     end;
     if FComponent is TcxDateEdit then begin
        FOnChange := TcxDateEdit(FComponent).Properties.OnChange;
        TcxDateEdit(FComponent).Properties.OnChange := OnChange;
     end;
     if FComponent is TcxCurrencyEdit then begin
        FOnChange := TcxCurrencyEdit(FComponent).Properties.OnEditValueChanged;
        TcxCurrencyEdit(FComponent).Properties.OnEditValueChanged := OnChange;
     end;
  end;
end;

{ TExecuteDialog }

constructor TExecuteDialog.Create(AOwner: TComponent);
begin
  inherited;
  isShowModal := true;
  OpenBeforeShow := true;
  RefreshAllow := true;
end;

function TExecuteDialog.Execute: boolean;
begin
  result := false;
  with TParentForm(ShowForm) do
    if ModalResult = mrOk then begin
       result := true;
       // �� ������������ RefreshDispatcher ��� ��������� ��������. ����� ��������� ��� ����
       if Assigned(RefreshDispatcher) then
          RefreshDispatcher.FNotRefresh := true;
       try
         Self.GuiParams.AssignParams(AddOnFormData.Params.Params);
         if Assigned(RefreshDispatcher) and Assigned(RefreshDispatcher.RefreshAction) and RefreshAllow then
            RefreshDispatcher.RefreshAction.Execute;// OnComponentChange(Self);
         RefreshAllow := true;
       finally
         // ����������� ������� ���� �� �����
         if Assigned(RefreshDispatcher) then
            RefreshDispatcher.FNotRefresh := false;
       end;
    end;
end;

procedure TExecuteDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
     if (Operation = opRemove) and (AComponent = FRefreshDispatcher) then
        FRefreshDispatcher := nil;
end;

{ TCrossDBViewAddOn }

constructor TCrossDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FCreateColumnList := TList.Create;
  FCreateColorRuleList := TList.Create;
end;

destructor TCrossDBViewAddOn.Destroy;
begin
  FreeAndNil(FCreateColorRuleList);
  FreeAndNil(FCreateColumnList);
  inherited;
end;

procedure TCrossDBViewAddOn.FocusedItemChanged(Sender: TcxCustomGridTableView;
  APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
begin
  if Assigned(FFocusedItemChanged) then
     FFocusedItemChanged(Sender, APrevFocusedItem, AFocusedItem);
  if TcxDBDataController(FView.DataController).DataSource.State = dsEdit then begin
     // ���� ������, �� ������ � ������� ������
     try
       TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
     except
       TcxDBDataController(FView.DataController).DataSource.DataSet.Cancel;
       FView.Controller.FocusedItem := APrevFocusedItem;
       raise;
     end;
  end;
end;

procedure TCrossDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
     if Operation = opRemove then begin
        if AComponent = HeaderDataSet then
           HeaderDataSet := nil;
        if AComponent = FTemplateColumn then
           FTemplateColumn := nil;
     end;
end;

procedure TCrossDBViewAddOn.onAfterClose(DataSet: TDataSet);
var i: integer;
begin
  if Assigned(FAfterClose) then
     FAfterClose(DataSet);

  for i := 0 to FCreateColorRuleList.Count - 1 do
    TColorRule(FCreateColorRuleList.Items[I]).Free;

  FCreateColorRuleList.Clear;

  for i := 0 to FCreateColumnList.Count - 1 do
    View.Columns[View.ColumnCount - 1].Free;

  FCreateColumnList.Clear;
end;

procedure TCrossDBViewAddOn.onBeforeOpen(DataSet: TDataSet);
var NewColumnIndex, I: integer;
    Column: TcxGridColumn;
    TemplateColorRule, ColorRule: TColorRule;
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(DataSet);
  View.BeginUpdate;
    try
      // ��������� ��������� �������
      if Assigned(HeaderDataSet) and HeaderDataSet.Active then begin
         if not Assigned(HeaderDataSet.Fields.FindField(HeaderColumnName)) then
            raise Exception.Create('HeaderDataSet �� ����� ���� ' + HeaderColumnName);
         if not Assigned(TemplateColumn) then
            raise Exception.Create('TemplateColumn �� ���������� ');
         TemplateColorRule := Nil;
         for I := 0 to ColorRuleList.Count - 1 do
           if TColorRule(ColorRuleList.Items[I]).ColorColumn = TemplateColumn then
         begin
           TemplateColorRule := TColorRule(ColorRuleList.Items[I]);
           Break;
         end;

         HeaderDataSet.First;
         NewColumnIndex := 1;
         while not HeaderDataSet.Eof do begin
           Column := View.CreateColumn;
           if TemplateColumn is TcxGridDBBandedColumn then
             Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColumn).DataBinding.FieldName + IntToStr(Column.index);
           if TemplateColumn is TcxGridDBColumn then
             Column.Name:= View.Name + TcxGridDBColumn(TemplateColumn).DataBinding.FieldName + IntToStr(Column.index);
           FCreateColumnList.Add(Column);
           with Column do begin
             Assign(TemplateColumn);
             Visible := true;
             Caption := HeaderDataSet.FieldByName(HeaderColumnName).AsString;
             Width := TemplateColumn.Width;
             if Column is TcxGridDBBandedColumn then
                TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
             if Column is TcxGridDBColumn then
                TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
             if Caption = '' then Options.Editing := False;
           end;

           if Assigned(TemplateColorRule) then
           begin
             ColorRule:= TColorRule.Create(FColorRuleList);
             ColorRule.Assign(TemplateColorRule);
             ColorRule.ColorColumn := Column;
             if not NoCrossColorColumn then
             begin
               if Assigned(TemplateColorRule.BackGroundValueColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.BackGroundValueColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.BackGroundValueColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.BackGroundValueColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.BackGroundValueColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.BackGroundValueColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.BackGroundValueColumn := Column;
               end;
               if Assigned(TemplateColorRule.ValueBoldColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.ValueBoldColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.ValueBoldColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.ValueBoldColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.ValueBoldColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.ValueBoldColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.ValueBoldColumn := Column;
               end;
               if Assigned(TemplateColorRule.ValueColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.ValueColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.ValueColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.ValueColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.ValueColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.ValueColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.ValueColumn := Column;
               end;
             end else
             begin
               ColorRule.BackGroundValueColumn := TemplateColorRule.BackGroundValueColumn;
               ColorRule.ValueBoldColumn := TemplateColorRule.ValueBoldColumn;
               ColorRule.ValueColumn := TemplateColorRule.ValueColumn;
             end;
             FCreateColorRuleList.Add(ColorRule);
           end;

           inc(NewColumnIndex);
           HeaderDataSet.Next;
         end;
      end;
    finally
      View.EndUpdate;
    end;
end;

procedure TCrossDBViewAddOn.onEditing(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; var AAllow: Boolean);
begin
  if Assigned(FEditing) then
     FEditing(Sender, AItem, AAllow);
  if Assigned(HeaderDataSet) and (FCreateColumnList.IndexOf(Aitem) >= 0) then
     HeaderDataSet.Locate(HeaderColumnName, Aitem.Caption, []);
end;

procedure TCrossDBViewAddOn.SetView(const Value: TcxGridTableView);
begin
  inherited;
  if Value <> nil then begin
     FDataSet := TcxDBDataController(Value.DataController).DataSet;
     FBeforeOpen := FDataSet.BeforeOpen;
     FDataSet.BeforeOpen := onBeforeOpen;
     FAfterClose := FDataSet.AfterClose;
     FDataSet.AfterClose := onAfterClose;
     FEditing := Value.OnEditing;
     Value.OnEditing := Nil;
     Value.OnEditing := onEditing;
     FFocusedItemChanged := Value.OnFocusedItemChanged;
     Value.OnFocusedItemChanged := FocusedItemChanged;
  end;
end;

{ TAddOnFormData }

{procedure TAddOnFormData.Assign(Source: TPersistent);
begin
  inherited;
  with TAddOnFormData(Source) do begin
    Self.ChoiceAction := ChoiceAction;
    Self.Params := Params;
    Self.ExecuteDialogAction := ExecuteDialogAction;
    Self.isSingle := isSingle;
    Self.isAlwaysRefresh := isAlwaysRefresh;
  end;
end;    }

constructor TAddOnFormData.Create;
begin
  FisAlwaysRefresh := true;
  FisSingle := true;
  FisFreeAtClosing := false;
  FAddOnFormRefresh := TAddOnFormRefresh.Create;
end;

destructor TAddOnFormData.Destroy;
begin
  FAddOnFormRefresh.Free;
  inherited;
end;

{ TColorRule }

procedure TColorRule.Assign(Source: TPersistent);
begin
  if Source is TColorRule then
    with TColorRule(Source) do
    begin
      Self.ColorColumn := ColorColumn;
      Self.ValueColumn := ValueColumn;
      Self.ValueBoldColumn := ValueBoldColumn;
      Self.ColorInValueColumn := ColorInValueColumn;
      Self.ColorValueList.Assign(ColorValueList);
    end
  else
    inherited Assign(Source);
end;

constructor TColorRule.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColorValueList := TCollection.Create(TColorValue);
  FColorInValueColumn := true;
  FStyle := TcxStyle.Create(nil);
end;

destructor TColorRule.Destroy;
begin
  FreeAndNil(FColorValueList);
  FreeAndNil(FStyle);
  inherited;
end;

{ TColorRulePivot }

procedure TColorRulePivot.Assign(Source: TPersistent);
begin
  if Source is TColorRulePivot then
    with TColorRulePivot(Source) do
    begin
      Self.ColorColumn := ColorColumn;
      Self.ValueColumn := ValueColumn;
      Self.ValueBoldColumn := ValueBoldColumn;
      Self.ColorInValueColumn := ColorInValueColumn;
      Self.ColorValueList.Assign(ColorValueList);
    end
  else
    inherited Assign(Source);
end;

constructor TColorRulePivot.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColorValueList := TCollection.Create(TColorValue);
  FColorInValueColumn := true;
  FStyle := TcxStyle.Create(nil);
end;

destructor TColorRulePivot.Destroy;
begin
  FreeAndNil(FColorValueList);
  FreeAndNil(FStyle);
  inherited;
end;

{ TSummaryFieldPivot }

procedure TSummaryFieldPivot.Assign(Source: TPersistent);
begin
  if Source is TSummaryFieldPivot then
    with TSummaryFieldPivot(Source) do
    begin
      Self.AddColumn := AddColumn;
      Self.SummaryColumn := SummaryColumn;
      Self.TypeColumn := TypeColumn;
      Self.IfDifferent := IfDifferent;
    end
  else
    inherited Assign(Source);
end;

constructor TSummaryFieldPivot.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FIfDifferent := psNone;
end;

destructor TSummaryFieldPivot.Destroy;
begin
  inherited;
end;

{ TColumnAddOn }

constructor TColumnAddOn.Create(Collection: TCollection);
begin
  inherited;
  FindByFullValue := false;
  onExitColumn := TColumnActionOptions.Create;
end;

procedure TColumnAddOn.Init;
begin
  if Assigned(Column) and Assigned(Action) then
     if Assigned(Column.Properties) then
        with Column.Properties.Buttons.Add as TcxEditButton do begin
          Default := True;
          Kind := bkEllipsis;
          Action := Self.Action;
        end;
end;

{ TPivotAddOn }

constructor TPivotAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FAfterOpen := Nil;
  FExpandRow := 0;
  FExpandColumn := 0;
  FOnGetContentStyleEvent := Nil;
  FColorRuleList := TCollection.Create(TColorRulePivot);
  FSummaryFieldList := TCollection.Create(TSummaryFieldPivot);
end;

destructor TPivotAddOn.Destroy;
begin
  FSummaryFieldList.Free;
  FColorRuleList.Free;
  inherited;
end;

function TPivotAddOn.GetCurrentData: string;
// <xml><field name="" value=""/><field name="" value=""/></xml>
var
  PivotGridViewDataItem: TcxPivotGridViewDataItem;
  i: integer;
  List: TStringList;
begin
  result := '';
  List := TStringList.Create;
  try
    with PivotGrid.ViewData do begin
      if PivotGrid.ViewData.Selection.FocusedCell.X = -1 then
         exit;

      PivotGridViewDataItem := Columns[Selection.FocusedCell.X];
      while Assigned(PivotGridViewDataItem) do begin
         if (PivotGridViewDataItem.Value <> '') and Assigned(PivotGridViewDataItem.Field) and (PivotGridViewDataItem.Field.Area <> faData) then
            List.Add(PivotGridViewDataItem.Value);
         PivotGridViewDataItem := PivotGridViewDataItem.Parent;
      end;

      for i := 0 to DataBuilder.ColumnFields.Count - 1 do
          if List.Count > i then
             result := result + TcxDBPivotGridField(DataBuilder.ColumnFields[i]).DataBinding.DBField.FieldName +
                       '=' + List[List.Count - 1 - i] + ';';

      List.Clear;
      PivotGridViewDataItem := Rows[Selection.FocusedCell.Y];
      while Assigned(PivotGridViewDataItem) do begin
         if PivotGridViewDataItem.Value <> '' then
            List.Add(PivotGridViewDataItem.Value);
         PivotGridViewDataItem := PivotGridViewDataItem.Parent;
      end;

      for i := 0 to DataBuilder.RowFields.Count - 1 do
          if List.Count > i then
             result := result + TcxDBPivotGridField(DataBuilder.RowFields[i]).DataBinding.DBField.FieldName +
                       '=' + List[List.Count - 1 - i] + ';';
    end;
  finally
    List.Free
  end;
end;

procedure TPivotAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
     if Operation = opRemove then begin
        if AComponent = PivotGrid then
           PivotGrid := nil;
     end;
end;

procedure TPivotAddOn.SetPivotGrid(const Value: TcxDBPivotGrid);
begin
  FPivotGrid := Value;
  if Assigned(FPivotGrid) then begin
    FOnKeyDown := FPivotGrid.OnKeyDown;
    FPivotGrid.OnKeyDown := OnKeyDown;
    FPivotGrid.OnDblClick := OnDblClick;
    FOnGetContentStyleEvent := FPivotGrid.Styles.OnGetContentStyle;
    FPivotGrid.Styles.OnGetContentStyle := Nil;
    FPivotGrid.Styles.OnGetContentStyle := OnGetContentStyle;

    if FPivotGrid is TcxDBPivotGrid then
    begin
      FAfterOpen := TcxDBPivotGrid(FPivotGrid).DataSource.DataSet.AfterOpen;
      TcxDBPivotGrid(FPivotGrid).DataSource.DataSet.AfterOpen := OnAfterOpen;
    end;
  end;
end;

procedure TPivotAddOn.OnAfterOpen(ADataSet: TDataSet);
  var I, J : Integer;
begin
  FPivotGrid.BeginUpdate;
  try
    for I := 0 to FPivotGrid.FieldCount - 1 do
    case FPivotGrid.Fields[I].Area of
      faRow : if FPivotGrid.Fields[I].AreaIndex < FExpandRow then FPivotGrid.Fields[I].ExpandAll;
      faColumn : if FPivotGrid.Fields[I].AreaIndex < FExpandColumn then FPivotGrid.Fields[I].ExpandAll;
    end;

    for I := 0 to FSummaryFieldList.Count - 1 do
      if Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).SummaryColumn) and
         Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).TypeColumn) then
    begin
      for J := 0 to FPivotGrid.FieldCount - 1 do
        if FPivotGrid.Fields[J] = TSummaryFieldPivot(FSummaryFieldList.Items[I]).SummaryColumn then
      begin
        FPivotGrid.Fields[J].OnCalculateCustomSummary := OnCalculateCustomSummary;
        FPivotGrid.Fields[J].SummaryType := stCustom;
      end;
    end;

  finally
    FPivotGrid.EndUpdate;
  end;

  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);
end;

procedure TPivotAddOn.OnGetContentStyle(Sender: TcxCustomPivotGrid;
      ACell: TcxPivotGridDataCellViewInfo; var AStyle: TcxStyle);
var Column: TcxGridColumn;
    i, j: integer;
    isBold_calc:Boolean;
begin
  if Assigned(FOnGetContentStyleEvent) then
     FOnGetContentStyleEvent(Sender, ACell, AStyle);

  if ACell = nil then exit;

  // ���� ��� ��������������� ������, �� �������
//  if ACell.IsGrandTotal or
//     ACell.Row.IsTotalItem or
//     ACell.Column.IsTotalItem then Exit;

  // �������� � ���������
  try
    for i := 0 to ColorRuleList.Count - 1 do
      with TColorRulePivot(ColorRuleList.Items[i]) do begin
        if Assigned(ColorColumn) then
        begin
          if ACell.DataField = ColorColumn then begin
           //������� Bold, !!!�� ��� �� ��������, ������� - ��������!!!!
           {isBold_calc:= false;
           if Assigned(ValueBoldColumn) then
              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
              isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
           //
           if Assigned(ValueColumn) and (ValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax)) then begin
                 FStyle.TextColor := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax);
                 // if isBold_calc = true then FStyle.Font.Style:= [fsBold] else if Assigned(FStyle.Font) then FStyle.Font.Style:= [];
                 AStyle := FStyle
              end;
           if Assigned(BackGroundValueColumn) and (BackGroundValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax)) then begin
              begin
                j := BackGroundValueColumn.Index;
                FStyle.Color := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax);
              end;
                 AStyle := FStyle
              end;
           end;
        end
        else begin
           //������� Bold, !!!�� ��� �� ��������, ������� - ��������!!!!
           {isBold_calc:= false;
           if Assigned(ValueBoldColumn) then
              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
              isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
           //
           if Assigned(ValueColumn) and (ValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax)) then begin
                 FStyle.TextColor := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax);
                 // if (isBold_calc = true)and Assigned(FStyle.Font) then FStyle.Font.Style:= [fsBold] else if Assigned(FStyle.Font) then FStyle.Font.Style:= [];
                 AStyle := FStyle
              end;
           if Assigned(BackGroundValueColumn) and (BackGroundValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax)) then begin
                 FStyle.Color := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax);
                 AStyle := FStyle
              end;
        end;
      end;
  except
    on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(FPivotGrid.FieldCount)  + ' ' +  IntToStr(J));
  end;

end;

  // ������ ����������� �� �������
procedure TPivotAddOn.OnCalculateCustomSummary(
  Sender: TcxPivotGridField; ASummary: TcxPivotGridCrossCellSummary);

  var ARow, AColumn: TcxPivotGridGroupItem; AddColumn, TypeColumn : TcxPivotGridField;
      PivotSummartType: TPivotSummartType; I, S : Integer;

  function VarToDouble(const AValue: Variant): Currency;
  begin
    Result := 0;
    if not VarIsNull(AValue) and (VarType(AValue) in [varSmallInt, varInteger, varSingle, varDouble, varCurrency, varShortInt,
                                                      varByte, varWord, varLongWord, varInt64, varUInt64])  then
      Result := AValue;
  end;

  function VarToInteger(const AValue: Variant): Integer;
  begin
    Result := - 2;
    if not VarIsNull(AValue) and (VarType(AValue) in [varSmallInt, varInteger, varSingle, varShortInt,
                                                      varByte, varWord, varLongWord, varInt64, varUInt64]) then
      Result := AValue;
  end;

  function Cal�AveragePrice : variant;
    var I, C : integer; nSum, nAmount : Currency;  bNext : boolean;

    function RowFits : boolean;
      var J : integer;
    begin
      Result := False;
      if ARow.DataController.Values[ARow.RecordIndex, ARow.Field.Index] = ARow.DataController.Values[I, ARow.Field.Index] then
      begin
        if ARow.Field.AreaIndex > 0 then
        begin
          for J := 0 to PivotGrid.FieldCount - 1 do
            if (PivotGrid.Fields[J].Area = ARow.Field.Area) and (PivotGrid.Fields[J].AreaIndex < ARow.Field.AreaIndex) then
              if ARow.DataController.Values[ARow.RecordIndex, PivotGrid.Fields[J].Index] <> ARow.DataController.Values[I, PivotGrid.Fields[J].Index] then Exit;
        end;
        Result := True;
      end;
    end;

    function ColumnFits : boolean;
      var J : integer;
    begin
      Result := False;
      if ARow.DataController.Values[AColumn.RecordIndex, AColumn.Field.Index] = ARow.DataController.Values[I, AColumn.Field.Index] then
      begin
        if AColumn.Field.AreaIndex > 0 then
        begin
          for J := 0 to PivotGrid.FieldCount - 1 do
            if (PivotGrid.Fields[J].Area = AColumn.Field.Area) and (PivotGrid.Fields[J].AreaIndex < AColumn.Field.AreaIndex) then
              if ARow.DataController.Values[AColumn.RecordIndex, PivotGrid.Fields[J].Index] <> ARow.DataController.Values[I, PivotGrid.Fields[J].Index] then Exit;
        end;
        Result := True;
      end;
    end;

  begin
    Result := Null; nSum := 0; nAmount := 0;
    if not Assigned(AddColumn) then Exit;

    for I := 0 to ARow.DataController.RecordCount - 1 do
    begin

      bNext := False;
      for C := 0 to PivotGrid.FieldCount - 1 do
        if (TcxDBPivotGridField(PivotGrid.Fields[c]).Filter.Values.Count > 0) then
           if not TcxDBPivotGridField(PivotGrid.Fields[c]).Filter.Contains(ARow.DataController.Values[I, PivotGrid.Fields[c].Index]) then
      begin
        bNext := True;
        Break;
      end;
      if bNext then Continue;

      if ARow.Field <> Nil then
      begin
        if RowFits then
        begin
          if AColumn.Field <> Nil then
          begin
            if ColumnFits then
            begin
              nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
                VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
              nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
            end
          end else
          begin
            nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
              VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
            nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
          end;
        end;
      end else
      begin
        if AColumn.Field <> Nil then
        begin
          if ColumnFits then
          begin
            nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
              VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
            nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
          end;
        end else
        begin
          nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
            VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
          nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
        end;
      end;
    end;

    if nAmount > 0 then Result := RoundTo(nSum / nAmount, - 2);
  end;

begin
  ARow := ASummary.Owner.Row;
  AColumn := ASummary.Owner.Column;
  TypeColumn := Nil;

  for I := 0 to FSummaryFieldList.Count - 1 do
    if Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).SummaryColumn) and
       Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).TypeColumn) then
  begin
    if TSummaryFieldPivot(FSummaryFieldList.Items[I]).FSummaryColumn = Sender then
    begin
      AddColumn := TSummaryFieldPivot(FSummaryFieldList.Items[I]).AddColumn;
      TypeColumn := TSummaryFieldPivot(FSummaryFieldList.Items[I]).TypeColumn;
      PivotSummartType := TSummaryFieldPivot(FSummaryFieldList.Items[I]).IfDifferent;
    end;
  end;

  if Assigned(TypeColumn) then
  begin
    S := VarToInteger(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(TypeColumn, stMin));
    if (S >= 0) and (S <> VarToInteger(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(TypeColumn, stMax))) then S := -1;

    if (S >= 0) and (S <= Ord(High(TPivotSummartType))) then PivotSummartType := TPivotSummartType(S)
    else if S <> -1 then PivotSummartType := psNone;
  end else PivotSummartType := psNone;

  case PivotSummartType of
    psCount : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stCount));
    psSum : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stSum));
    psMin : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stMin));
    psMax : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stMax));
    psAverage : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stAverage));
    psStdDev : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stStdDev));
    psStdDevP : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stStdDevP));
    psVariance : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stVariance));
    psVarianceP : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stVarianceP));
    psAveragePrice : ASummary.Custom := Cal�AveragePrice;
  end;

end;


{ TCrossDBViewSetTypeId }

constructor TCrossDBViewSetTypeId.Create(AOwner: TComponent);
begin
  inherited;
end;

function TCrossDBViewSetTypeId.LocalExecute: Boolean;
begin
  Result := False;
  if not Assigned(FCrossDBViewAddOn) then
    raise Exception.Create('�� ��������� CrossDBViewAddOn');

  if not Assigned(FCrossDBViewAddOn.FHeaderDataSet) then
    raise Exception.Create('�� ��������� HeaderDataSet');

  if not Assigned(FCrossDBViewAddOn.FView) then
    raise Exception.Create('�� ��������� View');

  if not FCrossDBViewAddOn.FView.Focused then
    raise Exception.Create('�� ���������� ����� �� ����');

  if not Assigned(FCrossDBViewAddOn.FView.Controller.FocusedColumn) then
    raise Exception.Create('�� ���������� ����� �� ���� �����');

  if FCrossDBViewAddOn.FCreateColumnList.IndexOf(FCrossDBViewAddOn.FView.Controller.FocusedColumn) < 0 then
    raise Exception.Create('��������� ���� �� ����������� ������� ��� ����������������...');

  Result := FCrossDBViewAddOn.FHeaderDataSet.Locate(FCrossDBViewAddOn.FHeaderColumnName, FCrossDBViewAddOn.FView.Controller.FocusedColumn.Caption, []);
end;


{ TColumnCollectionItem }

function TColumnCollectionItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(Column) then
     result := Column.Name
end;

{ TSummaryItemAddOn }

procedure TSummaryItemAddOn.Assign(Source: TPersistent);
begin
  if Source is TSummaryItemAddOn then
     Self.Param.Assign(TSummaryItemAddOn(Source).Param)
  else
    inherited Assign(Source);
end;

constructor TSummaryItemAddOn.Create(ACollection: TCollection);
begin
  inherited;
  FParam := TdsdParam.Create(nil);
end;

destructor TSummaryItemAddOn.Destroy;
begin
  FreeAndNil(FParam);
  inherited;
end;

procedure TSummaryItemAddOn.onGetText(Sender: TcxDataSummaryItem;
  const AValue: Variant; AIsFooter: Boolean; var AText: string);
begin
  if Param.Value = NULL then
     AText := ''
  else
     AText := Param.Value;
end;

procedure TSummaryItemAddOn.SetDataSummaryItemIndex(const Value: Integer);
begin
  FDataSummaryItemIndex := Value;
  if Value = -1  then
     exit;
  // �������� ���������� �������� onGetText ����������
  if Collection.Owner is TdsdDBViewAddOn then
     if Assigned(TdsdDBViewAddOn(Collection.Owner).View) then begin
        if TdsdDBViewAddOn(Collection.Owner).View.DataController.Summary.FooterSummaryItems.Count > Value then
           TdsdDBViewAddOn(Collection.Owner).View.DataController.Summary.FooterSummaryItems[Value].OnGetText := onGetText;
     end;
end;

{ TColorValue }

procedure TColorValue.Assign(Source: TPersistent);
begin
  if Source is TColorValue then
    with TColorValue(Source) do
    begin
      Self.Color := Color;
      Self.Value := Value;
    end
  else
    inherited Assign(Source);
end;

{ TAddOnFormRefresh }

constructor TAddOnFormRefresh.Create;
begin
  FParentList := '';
  FSelfList := '';
  FKeyField := '';
  FNeedRefresh := False;
  FRefreshID := 0;
  FGetStoredProc := nil;
  FDataSet := nil;
end;

destructor TAddOnFormRefresh.Destroy;
begin

  inherited;
end;

function TAddOnFormRefresh.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

function TAddOnFormRefresh.GetGetStoredProc: TdsdStoredProc;
begin
  Result := FGetStoredProc;
end;

procedure TAddOnFormRefresh.RefreshRecord;
var
  i: Integer;
  procedure AssignValue(AField: TField; AParam: TdsdParam);
  var
    F: TFormatSettings;
    S: String;
  Begin
    case AField.DataType of
      ftDate,ftTime,ftDateTime:
        Begin
          S:=Copy(AParam.asString,1,10)+' '+Copy(AParam.asString,12,8);
          F.TimeSeparator := ':';
          if pos('.',S)>0 then
          Begin
            F.ShortDateFormat := 'DD.MM.YYYY';
            F.DateSeparator := '.';
          End
          else if pos('-',S)>0 then
          Begin
            F.DateSeparator := '-';
            F.ShortDateFormat := 'YYYY-MM-DD';
          End;
          F.LongDateFormat := 'hh:mm:ss';
          AField.AsDateTime := StrToDateTime(S,F);
        End;
      ftFloat,ftCurrency,ftBCD,TFieldType.ftExtended:
        AField.Value := AParam.AsFloat;
    ELSE
      if VarToStr(AParam.Value) = '' then
        AField.Clear
      else
        AField.Value := AParam.Value;
//      ftUnknown: ;
//      ftString: ;
//      ftSmallint: ;
//      ftInteger: ;
//      ftWord: ;
//      ftBoolean: ;
//      ftFloat: ;
//      ftCurrency: ;
//      ftBCD: ;
//      ftBytes: ;
//      ftVarBytes: ;
//      ftAutoInc: ;
//      ftBlob: ;
//      ftMemo: ;
//      ftGraphic: ;
//      ftFmtMemo: ;
//      ftParadoxOle: ;
//      ftDBaseOle: ;
//      ftTypedBinary: ;
//      ftCursor: ;
//      ftFixedChar: ;
//      ftWideString: ;
//      ftLargeint: ;
//      ftADT: ;
//      ftArray: ;
//      ftReference: ;
//      ftDataSet: ;
//      ftOraBlob: ;
//      ftOraClob: ;
//      ftVariant: ;
//      ftInterface: ;
//      ftIDispatch: ;
//      ftGuid: ;
//      ftTimeStamp: ;
//      ftFMTBcd: ;
//      ftFixedWideChar: ;
//      ftWideMemo: ;
//      ftOraTimeStamp: ;
//      ftOraInterval: ;
//      ftLongWord: ;
//      ftShortint: ;
//      ftByte: ;
//      ftExtended: ;
//      ftConnection: ;
//      ftParams: ;
//      ftStream: ;
//      ftTimeStampOffset: ;
//      ftObject: ;
//      ftSingle: ;
    end;

  end;
begin
  //���� �� ���������� ��������� �������  �� �������
  if not Assigned(FGetStoredProc) then exit;
  //���� �� ������� ������� ������� �� �������
  if not Assigned(FDataSet) then exit;
  //���� ������� �� ����� ����� - �������
  if FDataSet.FieldCount = 0 then exit;
  //���� ����� �� �������� �������� ����, �� ������� ��� 1-� ������� � �������� ��������
  if (FKeyField = '') then
    FKeyField := FDataSet.Fields[0].FieldName;
  //���� ������� �� ����� ���� FKeyField - �������
  if FDataSet.FindField(FKeyField) = nil then exit;
  //�������� ����� ��������
  if not Assigned(FGetStoredProc.Params.ParamByName(FKeyParam)) then exit;

  try
    //�����������, ��� �� �� �������� �������� gpInsertUpdate...
    FDataSet.DisableControls;

    //����������� ��� �������� ���������� ��
    FGetStoredProc.Params.ParamByName(FKeyParam).Value := FRefreshID;
    //������� ��������� ���������
    FGetStoredProc.Execute;

    //���� � �������� ������� ������ �� ��������� ���� - ��������� ������� � ����� ��������������
    if FDataSet.Locate(FKeyField,FRefreshID,[]) then
      FDataSet.Edit
    else
    //���� ������ �� ������� - ��������� � � �������
    Begin
      FDataSet.Append;
      FDataSet.FieldByName(FKeyField).Value := FRefreshID;
    End;
    //��������� ��� ���� � ��������� �� ���������� ���������� � ������ �� �������
    for I := 0 to FDataSet.FieldCount-1 do
    Begin
      //���� ��� �������� ���� - �� ���������� ��� �� �����
      if CompareText(FDataSet.Fields[i].FieldName, FKeyField) = 0 then Continue;
      //������� ��������� �������� ���� �� ���������� � ����� �� ������
      if Assigned(FGetStoredProc.Params.ParamByName(FDataSet.Fields[i].FieldName)) then
        AssignValue(FDataSet.Fields[i],FGetStoredProc.Params.ParamByName(FDataSet.Fields[i].FieldName))
      else
      //���� ������� ���������� ��� - �� ������� �� ����������� ���������� out
      if Assigned(FGetStoredProc.Params.ParamByName('out'+FDataSet.Fields[i].FieldName)) then
        AssignValue(FDataSet.Fields[i],FGetStoredProc.Params.ParamByName('out'+FDataSet.Fields[i].FieldName));
    End;
    FDataSet.Post;
  finally
    if FDataSet.State in [dsInsert,dsEdit] then
      FDataSet.Cancel;
    //��������� ������������ ������������ ������ ��� ��������� �����������
    FNeedRefresh := False;
    //������� �� �����, ��� �� �������� �������� gpInsertUpdate...
    FDataSet.EnableControls;
  end;
end;

procedure TAddOnFormRefresh.SetDatSet(Value: TDataSet);
begin
  if Value = FDataSet then exit;
  FDataSet := Value;
end;

procedure TAddOnFormRefresh.SetGetStoredProc(Value: TdsdStoredProc);
begin
  if Value = FGetStoredProc then exit;
  FGetStoredProc := Value;
end;

{  TdsdGMMap  }

constructor TdsdGMMap.Create(AOwner: TComponent);
begin
  inherited;
  AfterPageLoaded := DoAfterPageLoaded;
  FMapLoad := False;
end;

procedure TdsdGMMap.DoAfterPageLoaded(Sender: TObject; First: Boolean);
begin
  try
    if First then
    begin
      DoMap;
      FMapLoad := True;
    end;
  except
    FMapLoad := False;

    LoadDefaultWebBrowser;

    if Owner is TForm then
      (Owner as TForm).Close;
  end;
end;

procedure TdsdGMMap.LoadDefaultWebBrowser;
var
  Field: TField;
  GPSNValue, GPSEValue: Real;
  OldDecimalSeparator: Char;
  AddressValue, MapURL: string;
begin
  if Assigned(DataSet) then
  begin
    if Trim(GPSNField) = '' then
      GPSNField := 'GPSN';

    if Trim(GPSEField) = '' then
      GPSEField := 'GPSE';

    GPSNValue := 0.0;
    GPSEValue := 0.0;

    Field := DataSet.FindField(GPSNField);
    if Assigned(Field) then
      GPSNValue := Field.AsFloat;

    Field := DataSet.FindField(GPSEField);
    if Assigned(Field) then
      GPSEValue := Field.AsFloat;

    Field := DataSet.FindField('AddressByGPS');
    if Assigned(Field) then
      AddressValue := Field.AsString;

    if (GPSNValue <> 0.0) and (GPSEValue <> 0.0) then
    begin
      AddressValue := ReplaceStr(AddressValue, ' ', '+');

      OldDecimalSeparator := FormatSettings.DecimalSeparator;
      if OldDecimalSeparator = ',' then
        FormatSettings.DecimalSeparator := '.';

      MapURL := Format('https://www.google.com.ua/maps/place/%s/@%g,%g,%uz?hl=uk', [AddressValue, GPSNValue, GPSEValue, 17]);
      FormatSettings.DecimalSeparator := OldDecimalSeparator;
      ShellExecute(0, 'open', PChar(MapURL), nil, nil, SW_SHOWNORMAL);
    end;
  end;
end;

procedure TdsdGMMap.SetDocLoaded;
begin
  FDocLoaded := True;
end;

{  TGeoMarker  }

type
  TGeoMarkerData = record
    Lat: Real;
    Lng: Real;
    Title: string;
    InsertDate: TDateTime;
  end;

  TGeoMarker = class
  private
    FData: TGeoMarkerData;
    function GetData: TGeoMarkerData;
  public
    constructor Create(ALat, ALng: Real; ATitle: string; AInsertDate: TDateTime);
    property Data: TGeoMarkerData read GetData;
  end;

  TGeoMarkerList = class(TObjectList)
  private
    function GetGeoMarker(Index: Integer): TGeoMarker;
    procedure SetGeoMarker(Index: Integer; const Value: TGeoMarker);
  public
    property Items[Index: Integer]: TGeoMarker read GetGeoMarker write SetGeoMarker; default;
  end;

function CompareGeoMarkerData(Item1, Item2: Pointer): Integer;
var
  Data1, Data2: TGeoMarkerData;
begin
  Data1 := TGeoMarker(Item1).Data;
  Data2 := TGeoMarker(Item2).Data;

  if Data1.InsertDate > Data2.InsertDate then
    Result := 1
  else if Data1.InsertDate < Data2.InsertDate then
    Result := -1
  else
    Result := 0;
end;

{  TdsdWebBrowser  }

constructor TdsdWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  OnDownloadComplete := DoDownloadComplete;

  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimerNotifyEvent;
end;

destructor TdsdWebBrowser.Destroy;
begin
  FTimer.Free;
  inherited;
end;

procedure TdsdWebBrowser.OnTimerNotifyEvent(Sender: TObject);
var
  i,j: integer;
  GMList: TGeoMarkerList;
  FDataSet: TDataSet;
  GPSNField, GPSEField, AddressField, InsertDateField, Adr: string;
  InsertDateValue: TDateTime;

  function IsDelta : boolean;
  begin
    Result := Sqrt(Sqr(GMList[j].Data.Lat - GMList[i].Data.Lat) + Sqr(GMList[j].Data.Lng - GMList[i].Data.Lng)) > 0.002;
  end;

begin
  FTimer.Enabled := False;
  GMList := TGeoMarkerList.Create;

  GPSNField := TdsdGMMap(FGeoCode.Map).GPSNField;
  if Trim(GPSNField) = '' then
    GPSNField := 'GPSN';

  GPSEField := TdsdGMMap(FGeoCode.Map).GPSEField;
  if Trim(GPSEField) = '' then
    GPSEField := 'GPSE';

  AddressField := TdsdGMMap(FGeoCode.Map).AddressField;
  if Trim(AddressField) = '' then
    AddressField := 'Address';

  InsertDateField := TdsdGMMap(FGeoCode.Map).InsertDateField;
  if Trim(InsertDateField) = '' then
    InsertDateField := 'InsertMobileDate';

  FDataSet := TdsdGMMap(FGeoCode.Map).DataSet;

  try
    if Assigned(FDataSet) then
    begin
      FDataSet.DisableControls;
      try
        if (FDataSet.FindField(GPSNField) <> nil) and (FDataSet.FindField(GPSEField) <> nil) then
        begin
          if TdsdGMMap(FGeoCode.Map).MapType = acShowOne then
          begin
            FGeoCode.Map.RequiredProp.Zoom := 18;

            if (FDataSet.FindField(GPSNField).AsFloat <> 0.0) and
               (FDataSet.FindField(GPSEField).AsFloat <> 0.0)
            then
              FGeoCode.Geocode(FDataSet.FindField(GPSNField).AsFloat, FDataSet.FindField(GPSEField).AsFloat)
            else
            if FDataSet.FindField(AddressField) <> nil then
              FGeoCode.Geocode(FDataSet.FindField(AddressField).AsString);

            InsertDateValue := StrToDateTime('01.01.1900');
            if FDataSet.FindField(InsertDateField) <> nil then
              InsertDateValue := FDataSet.FieldByName(InsertDateField).AsDateTime;

            if (FGeoCode.GeoStatus = gsOK) and (FGeoCode.Count > 0) then
              GMList.Add(TGeoMarker.Create(
                FGeoCode.GeoResult[0].Geometry.Location.Lat,
                FGeoCode.GeoResult[0].Geometry.Location.Lng,
                FGeoCode.GeoResult[0].FormatedAddr,
                InsertDateValue));
          end
          else
          begin
            FGeoCode.Map.RequiredProp.Zoom := 13;

            FDataSet.First;
            while not FDataSet.Eof do
            begin
              InsertDateValue := StrToDateTime('01.01.1900');
              if FDataSet.FindField(InsertDateField) <> nil then
                InsertDateValue := FDataSet.FieldByName(InsertDateField).AsDateTime;

              if (FDataSet.FindField(GPSNField).AsFloat <> 0) and
                 (FDataSet.FindField(GPSEField).AsFloat <> 0) then
              begin
                if FDataSet.FindField(AddressField) <> nil then
                  Adr := FDataSet.FindField(AddressField).AsString
                else Adr := '';

                GMList.Add(TGeoMarker.Create(
                   FDataSet.FindField(GPSNField).AsFloat,
                   FDataSet.FindField(GPSEField).AsFloat,
                   Adr,
                   InsertDateValue));

              end else if FDataSet.FindField(AddressField) <> nil then
              begin
                FGeoCode.Geocode(FDataSet.FindField(AddressField).AsString);

                if (FGeoCode.GeoStatus = gsOK) and (FGeoCode.Count > 0) then
                 GMList.Add(TGeoMarker.Create(
                   FGeoCode.GeoResult[0].Geometry.Location.Lat,
                   FGeoCode.GeoResult[0].Geometry.Location.Lng,
                   FGeoCode.GeoResult[0].FormatedAddr,
                   InsertDateValue));
              end;

              FDataSet.Next;
            end;

            FDataSet.First;
          end;

          GMList.Sort(CompareGeoMarkerData);

          j := 0;
          for i := 0 to Pred(GMList.Count) do if (i = 0) or IsDelta then
          begin
            j := I;
            FGeoCode.Marker.Add(GMList[i].Data.Lat, GMList[i].Data.Lng, FormatDateTime('hh:mm', GMList[i].Data.InsertDate));
            FGeoCode.Marker.Items[FGeoCode.Marker.Count - 1].MarkerType := mtStyledMarker;
            TGMMarker(FGeoCode.Marker).Items[FGeoCode.Marker.Count - 1].StyledMarker.StyledIcon := siBubble;
          end;

          if FGeoCode.Marker.Count > 1 then
          begin
            FDirection.DirectionsRequest.Origin.LatLng.Lat := FGeoCode.Marker.Items[0].Position.Lat;
            FDirection.DirectionsRequest.Origin.LatLng.Lng := FGeoCode.Marker.Items[0].Position.Lng;
            FDirection.DirectionsRequest.Destination.LatLng.Lat := FGeoCode.Marker.Items[Pred(FGeoCode.Marker.Count)].Position.Lat;
            FDirection.DirectionsRequest.Destination.LatLng.Lng := FGeoCode.Marker.Items[Pred(FGeoCode.Marker.Count)].Position.Lng;

            if FGeoCode.Marker.Count > 2 then
            begin
              for i := 1 to FGeoCode.Marker.Count - 2 do
                with FDirection.AddWaypoint.Location.LatLng do
                begin
                  Lat := FGeoCode.Marker.Items[i].Position.Lat;
                  Lng := FGeoCode.Marker.Items[i].Position.Lng;
                end;

              FDirection.Execute;
            end;
          end;

          if FGeoCode.Marker.Count > 0 then
            FGeoCode.Marker.Items[0].CenterMapTo;
        end;
      finally
        FDataSet.EnableControls;
      end;
    end;
  finally
    GMList.Free;
  end;
end;

procedure TdsdWebBrowser.DoDownloadComplete(Sender: TObject);
var
  I: integer;
  Form: TForm;
  Comp: TComponent;
begin
  Form := Owner as TForm;

  if Assigned(Form) then
  begin
    FGeoCode := nil;
    FDirection := nil;

    for I := 0 to Form.ComponentCount - 1 do
    begin
      Comp := Form.Components[I];

      if (Comp.ClassType = TGMGeoCode) and (FGeoCode = nil) then
        FGeoCode := Comp as TGMGeoCode;

      if (Comp.ClassType = TGMDirection) and (FDirection = nil) then
        FDirection := Comp as TGMDirection;

      if (FGeoCode <> nil) and (FDirection <> nil) then
        Break;
    end;

    if Assigned(FGeoCode) and Assigned(FGeoCode.Map) and (FGeoCode.Map.ClassType = TdsdGMMap) and
       Assigned(FGeoCode.Marker) and TdsdGMMap(FGeoCode.Map).MapLoad and
       Assigned(FDirection) and Assigned(FDirection.Map) and (FDirection.Map.ClassType = TdsdGMMap) then
    begin
      FDirection.ClearWaypoint;
      FGeoCode.Marker.Clear;
      TdsdGMMap(FGeoCode.Map).MapLoad := False;
      TdsdGMMap(FGeoCode.Map).SetDocLoaded;

      FTimer.Enabled := true;
    end;
  end;
end;

{ TChangerListItem }

procedure TChangerListItem.Assign(Source: TPersistent);
begin
  if Source is TChangerListItem then
    Self.Control := (Source as TChangerListItem).Control
  else
    inherited Assign(Source);
end;

function TChangerListItem.GetDisplayName: string;
begin
  if Control <> nil then
    Result := Control.Name
  else
    Result := inherited GetDisplayName;
end;

procedure TChangerListItem.SetControl(const Value: TControl);
begin
  if Value <> FControl then
  begin
    FControl := Value;
    if Assigned(FControl) and Assigned(Collection) then
    begin
      FControl.FreeNotification(TComponent(Collection.Owner));
      if (Collection.Owner is THeaderChanger) then
      begin
        if FControl is TcxTextEdit then
          (FControl as TcxTextEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxMemo then
          (FControl as TcxMemo).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxDateEdit then
          (FControl as TcxDateEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxButtonEdit then
          (FControl as TcxButtonEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxCheckBox then
          (FControl as TcxCheckBox).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxCurrencyEdit then
          (FControl as TcxCurrencyEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxComboBox then
          (FControl as TcxComboBox).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
      end;
    end;
  end;
end;

{ TChangerList }

function TChangerList.Add: TChangerListItem;
begin
  Result := inherited Add as TChangerListItem;
end;

function TChangerList.GetChangerListItem(Index: Integer): TChangerListItem;
begin
  Result := inherited GetItem(Index) as TChangerListItem
end;

procedure TChangerList.SetChangerListItem(Index: Integer; const Value: TChangerListItem);
begin
  inherited SetItem(Index, Value);
end;

{ THeaderChanger }

constructor THeaderChanger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParam := TdsdParam.Create(nil);
  FChangerList := TChangerList.Create(Self, TChangerListItem);
end;

destructor THeaderChanger.Destroy;
begin
  FParam.Free;
  FChangerList.Free;
  inherited;
end;

procedure THeaderChanger.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);

  if csDesigning in ComponentState then
    if Operation = opRemove then
    begin
      if AComponent is TControl then
      begin
        for I := 0 to Pred(ChangerList.Count) do
          if ChangerList[I].Control = AComponent then
            ChangerList[I].Control := nil;
      end;

      if AComponent = Action then
        Action := nil;
    end;
end;

procedure THeaderChanger.OnChange(Sender: TObject);
begin
  if Assigned(Action) then
    if (Sender is TcxTextEdit) or
      (Sender is TcxMemo) or
      (Sender is TcxButtonEdit) or
      (Sender is TcxCurrencyEdit) or
      (Sender is TcxDateEdit) or
      (Sender is TcxCheckBox) or
      (Sender is TcxComboBox) then
      Action.Execute;
end;

{ TGeoMarker }

constructor TGeoMarker.Create(ALat, ALng: Real; ATitle: string; AInsertDate: TDateTime);
begin
  inherited Create;
  FData.Lat := ALat;
  FData.Lng := ALng;
  FData.Title := ATitle;
  FData.InsertDate := AInsertDate;
end;

function TGeoMarker.GetData: TGeoMarkerData;
begin
  Result := FData;
end;

{ TGeoMarkerList }

function TGeoMarkerList.GetGeoMarker(Index: Integer): TGeoMarker;
begin
  Result := inherited GetItem(Index) as TGeoMarker;
end;

procedure TGeoMarkerList.SetGeoMarker(Index: Integer; const Value: TGeoMarker);
begin
  inherited SetItem(Index, Value);
end;

{ TWinControlListItem }

procedure TWinControlListItem.Assign(Source: TPersistent);
begin
  if Source is TWinControlListItem then
     with TWinControlListItem(Source) do begin
       Self.Control := Control;
       Self.GotoControl := GotoControl;
       Self.StoredProc := StoredProc;
       Self.Action := Action;
     end
  else
    inherited Assign(Source);
end;

function TWinControlListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FControl) then
     result := FControl.Name
end;

procedure TWinControlListItem.SetControl(const Value: TWinControl);
begin
  if FControl = Value then Exit;

  if Assigned(Value) then
  begin
    if not (Value is TcxTextEdit) and
       not (Value is TcxButtonEdit) and
       not (Value is TcxCurrencyEdit) and
       not (Value is TcxDateEdit) then
       raise Exception.Create(Value.ClassName + ' �� ���������������');
  end;

  if Assigned(FControl) and Assigned(FKeyDown) then
  begin
    if FControl is TcxTextEdit then
       (FControl as TcxTextEdit).OnKeyDown := FKeyDown
    else if FControl is TcxButtonEdit then
       (FControl as TcxButtonEdit).OnKeyDown := FKeyDown
    else if FControl is TcxCurrencyEdit then
       (FControl as TcxCurrencyEdit).OnKeyDown := FKeyDown
    else if FControl is TcxDateEdit then
       (FControl as TcxDateEdit).OnKeyDown := FKeyDown;
  end;

  if Assigned(Value) then
  begin
    if Value is TcxTextEdit then
    begin
      FKeyDown := (Value as TcxTextEdit).OnKeyDown;
      (Value as TcxTextEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxButtonEdit then
    begin
      FKeyDown := (Value as TcxButtonEdit).OnKeyDown;
      (Value as TcxButtonEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxCurrencyEdit then
    begin
      FKeyDown := (Value as TcxCurrencyEdit).OnKeyDown;
      (Value as TcxCurrencyEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxDateEdit then
    begin
      FKeyDown := (Value as TcxDateEdit).OnKeyDown;
      (Value as TcxDateEdit).OnKeyDown := edKeyDown
    end;
  end;

  FControl := Value;
end;

procedure TWinControlListItem.SetGotoControl(const Value: TWinControl);
begin
  FGotoControl := Value;
end;

procedure TWinControlListItem.edKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_RETURN) then
  begin
    Key := 0;
    try
      if Assigned(FStoredProc) then FStoredProc.Execute;
      if Assigned(FAction) then FAction.Execute;
    finally
      if Assigned(FGotoControl) then FGotoControl.SetFocus;
    end;
  end else if Assigned(FKeyDown) then FKeyDown(Sender, Key, Shift);
end;

{ TTabSheetListItem }

procedure TTabSheetListItem.Assign(Source: TPersistent);
begin
  if Source is TTabSheetListItem then
     with TTabSheetListItem(Source) do begin
       Self.Control := Control;
       Self.TabSheet := TabSheet;
     end
  else
    inherited Assign(Source);
end;

function TTabSheetListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FTabSheet) then
     result := FTabSheet.Name
end;

procedure TTabSheetListItem.SetTabSheet(const Value: TcxTabSheet);
begin

end;

{ TEnterManager }

constructor TdsdEnterManager.Create(AOwner: TComponent);
begin
  inherited;
  ControlList := TOwnedCollection.Create(Self, TWinControlListItem);
  TabSheetList := TOwnedCollection.Create(Self, TTabSheetListItem);
end;

destructor TdsdEnterManager.Destroy;
begin
  FreeAndNil(FTabSheetList);
  FreeAndNil(FControlList);
  inherited;
end;

procedure TdsdEnterManager.SetPageControl(const Value: TcxPageControl);
begin
  if FPageControl = Value then Exit;

  if Assigned(FPageControl) and Assigned(FOnChange) then
  begin
    FPageControl.OnChange := FOnChange;
  end;

  if Assigned(Value) then
  begin
    FOnChange := Value.OnChange;
    Value.OnChange := PageControl1Change;
  end;

  FPageControl := Value;
end;

procedure TdsdEnterManager.PageControl1Change(Sender: TObject);
var i: integer;
begin
  if Assigned(FPageControl) then
    for i := 0 to TabSheetList.Count - 1 do
      if TTabSheetListItem(TabSheetList.Items[i]).TabSheet = FPageControl.ActivePage then
        if Assigned(TTabSheetListItem(TabSheetList.Items[i]).FControl) then
          TTabSheetListItem(TabSheetList.Items[i]).FControl.SetFocus;
end;

procedure TdsdEnterManager.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent = FPageControl then PageControl := nil;
      for i := 0 to ControlList.Count - 1 do
      begin
         if TWinControlListItem(ControlList.Items[i]).Control = AComponent then
            TWinControlListItem(ControlList.Items[i]).Control := nil;
         if TWinControlListItem(ControlList.Items[i]).GotoControl = AComponent then
            TWinControlListItem(ControlList.Items[i]).GotoControl := nil;
         if TWinControlListItem(ControlList.Items[i]).Action = AComponent then
            TWinControlListItem(ControlList.Items[i]).Action := nil;
      end;
      for i := 0 to TabSheetList.Count - 1 do
      begin
         if TTabSheetListItem(TabSheetList.Items[i]).Control = AComponent then
            TTabSheetListItem(TabSheetList.Items[i]).Control := nil;
         if TTabSheetListItem(TabSheetList.Items[i]).TabSheet = AComponent then
            TTabSheetListItem(TabSheetList.Items[i]).TabSheet := nil;
      end;
    end;
end;

end.
