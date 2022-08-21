
{******************************************}
{                                          }
{             FastReport v4.0              }
{             Report classes               }
{                                          }
{         Copyright (c) 1998-2008          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxClass;

interface

{$I frx.inc}

uses
  SysUtils, {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, ExtCtrls, Printers, frxVariables, frxXML, frxProgress,
  fs_iinterpreter, frxUnicodeUtils
{$IFDEF FPC}
  ,LResources, LMessages, LCLType, LCLIntf, LazarusPackageIntf,
  LCLProc, FileUtil, LazHelper
{$ENDIF}

{$IFDEF Delphi6}
, Variants
{$ENDIF}
{$IFNDEF NO_CRITICAL_SECTION}
,  SyncObjs
{$ENDIF}
{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
{$IFDEF FR_COM}
, ComServ
, ActiveX, AxCtrls
, VCLCom, ComObj
, ClrStream
, frxFont
, FastReport_TLB
, DispatchablePersistent
{$IFDEF ACTIVATION}
  , aspr_api
{$ENDIF}
{$ENDIF};

const
  fr01cm: Extended = 3.77953;
  fr1cm: Extended = 37.7953;
  fr01in: Extended = 9.6;
  fr1in: Integer = 96;
  fr1CharX: Extended = 9.6;
  fr1CharY: Integer = 17;
  clTransparent: TColor = clNone;
  crHand: Integer = 150;
  crZoom: Integer = 151;
  crFormat: Integer = 152;
  DEF_REG_CONNECTIONS: String = '\Software\Fast Reports\Connections';
  WM_CREATEHANDLE = WM_USER + 1;
  WM_DESTROYHANDLE = WM_USER + 2;

type
  TfrxReport = class;
  TfrxPage = class;
  TfrxReportPage = class;
  TfrxDialogPage = class;
  TfrxCustomEngine = class;
  TfrxCustomDesigner = class;
  TfrxCustomPreview = class;
  TfrxCustomPreviewPages = class;
  TfrxComponent = class;
  TfrxReportComponent = class;
  TfrxView = class;
  TfrxStyleItem = class;
  TfrxCustomExportFilter = class;
  TfrxCustomCompressor = class;
  TfrxCustomDatabase = class;
  TfrxFrame = class;
  TfrxDataSet = class;

  TfrxNotifyEvent = type String;
  TfrxCloseQueryEvent = type String;
  TfrxKeyEvent = type String;
  TfrxKeyPressEvent = type String;
  TfrxMouseEvent = type String;
  TfrxMouseMoveEvent = type String;
  TfrxPreviewClickEvent = type String;
  TfrxRunDialogsEvent = type String;

  EDuplicateName = class(Exception);
  EExportTerminated = class(TObject);

  SYSINT = Integer;

  TfrxComponentStyle = set of (csContainer, csPreviewVisible, csDefaultDiff);
  TfrxStretchMode = (smDontStretch, smActualHeight, smMaxHeight);
  TfrxShiftMode = (smDontShift, smAlways, smWhenOverlapped);
  TfrxDuplexMode = (dmNone, dmVertical, dmHorizontal, dmSimplex);

  TfrxAlign = (baNone, baLeft, baRight, baCenter, baWidth, baBottom, baClient);

  TfrxFrameStyle = (fsSolid, fsDash, fsDot, fsDashDot, fsDashDotDot, fsDouble, fsAltDot, fsSquare);

  TfrxFrameType = (ftLeft, ftRight, ftTop, ftBottom);
  TfrxFrameTypes = set of TfrxFrameType;

  TfrxFormatKind = (fkText, fkNumeric, fkDateTime, fkBoolean);

  TfrxHAlign = (haLeft, haRight, haCenter, haBlock);
  TfrxVAlign = (vaTop, vaBottom, vaCenter);

  TfrxSilentMode = (simMessageBoxes, simSilent, simReThrow);
  TfrxRestriction = (rfDontModify, rfDontSize, rfDontMove, rfDontDelete, rfDontEdit);
  TfrxRestrictions = set of TfrxRestriction;

  TfrxShapeKind = (skRectangle, skRoundRectangle, skEllipse, skTriangle,
    skDiamond, skDiagonal1, skDiagonal2);

  TfrxPreviewButton = (pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind,
    pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick,
    pbNoClose, pbNoFullScreen, pbNoEmail);
  TfrxPreviewButtons = set of TfrxPreviewButton;
  TfrxZoomMode = (zmDefault, zmWholePage, zmPageWidth, zmManyPages);
  TfrxPrintPages = (ppAll, ppOdd, ppEven);
  TfrxAddPageAction = (apWriteOver, apAdd);
  TfrxRangeBegin = (rbFirst, rbCurrent);
  TfrxRangeEnd = (reLast, reCurrent, reCount);
  TfrxFieldType = (fftNumeric, fftString, fftBoolean);
  TfrxProgressType = (ptRunning, ptExporting, ptPrinting);
  TfrxPrintMode = (pmDefault, pmSplit, pmJoin, pmScale);
  TfrxInheriteMode = (imDefault, imDelete, imRename);

{$IFDEF DELPHI16}
  frxInteger = NativeInt;
{$ELSE}
  frxInteger = {$IFDEF FPC}PtrInt{$ELSE}Integer{$ENDIF};
{$ENDIF}

  TfrxRect = packed record
    Left, Top, Right, Bottom: Extended;
  end;

  TfrxPoint = packed record
    X, Y: Extended;
  end;

  TfrxProgressEvent = procedure(Sender: TfrxReport;
    ProgressType: TfrxProgressType; Progress: Integer) of object;
  TfrxBeforePrintEvent = procedure(Sender: TfrxReportComponent) of object;
  TfrxGetValueEvent = procedure(const VarName: String; var Value: Variant) of object;
  TfrxNewGetValueEvent = procedure(Sender: TObject; const VarName: String; var Value: Variant) of object;
  TfrxUserFunctionEvent = function(const MethodName: String;
    var Params: Variant): Variant of object;
  TfrxManualBuildEvent = procedure(Page: TfrxPage) of object;
  TfrxClickObjectEvent = procedure(Sender: TfrxView;
    Button: TMouseButton; Shift: TShiftState; var Modified: Boolean) of object;
  TfrxMouseOverObjectEvent = procedure(Sender: TfrxView) of object;
  TfrxCheckEOFEvent = procedure(Sender: TObject; var Eof: Boolean) of object;
  TfrxRunDialogEvent = procedure(Page: TfrxDialogPage) of object;
  TfrxEditConnectionEvent = function(const ConnString: String): String of object;
  TfrxSetConnectionEvent = procedure(const ConnString: String) of object;
  TfrxBeforeConnectEvent = procedure(Sender: TfrxCustomDatabase; var Connected: Boolean) of object;
  TfrxAfterDisconnectEvent = procedure(Sender: TfrxCustomDatabase) of object;
  TfrxPrintPageEvent = procedure(Page: TfrxReportPage; CopyNo: Integer) of object;
  TfrxLoadTemplateEvent = procedure(Report: TfrxReport; const TemplateName: String) of object;

{ Root classes }

{$IFDEF FR_COM}
  TfrxComponent = class(TComponent, IfrxComponent )
  private
    FFont: TfrxFont;
{$ELSE}
  TfrxComponent = class(TComponent)
  private
    FFont: TFont;
{$ENDIF}
    FObjects: TList;
    FAllObjects: TList;
    FParent: TfrxComponent;
    FLeft: Extended;
    FTop: Extended;
    FWidth: Extended;
    FHeight: Extended;
    FParentFont: Boolean;
    FGroupIndex: Integer;
    FIsDesigning: Boolean;
    FIsLoading: Boolean;
    FIsPrinting: Boolean;
    FIsWriting: Boolean;
    FRestrictions: TfrxRestrictions;
    FVisible: Boolean;
    FDescription: String;
    FAncestor: Boolean;
    FComponentStyle: TfrxComponentStyle;
    function GetAbsTop: Extended;
    function GetPage: TfrxPage;
    function GetReport: TfrxReport;
    function IsFontStored: Boolean;
    function GetAllObjects: TList;
    function GetAbsLeft: Extended;
    function GetIsLoading: Boolean;
    function GetIsAncestor: Boolean;
  protected
    FAliasName: String;
    FBaseName: String;
    FOriginalComponent: TfrxComponent;
    FOriginalRect: TfrxRect;
    FOriginalBand: TfrxComponent;
    procedure SetParent(AParent: TfrxComponent); virtual;
    procedure SetLeft(Value: Extended); virtual;
    procedure SetTop(Value: Extended); virtual;
    procedure SetWidth(Value: Extended); virtual;
    procedure SetHeight(Value: Extended); virtual;
    procedure SetName(const AName: TComponentName); override;
    procedure SetFont(Value: TFont); virtual;
    procedure SetParentFont(const Value: Boolean); virtual;
    procedure SetVisible(Value: Boolean); virtual;
    procedure FontChanged(Sender: TObject); virtual;
    function DiffFont(f1, f2: TFont; const Add: String): String;
    function InternalDiff(AComponent: TfrxComponent): String;
    function GetContainerObjects: TList; virtual;

    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetChildOwner: TComponent; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); virtual;
    destructor Destroy; override;
    class function GetDescription: String; virtual;
    procedure AlignChildren; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure AssignAll(Source: TfrxComponent; Streaming: Boolean = False);
    procedure AddSourceObjects; virtual;
    procedure BeforeStartReport; virtual;
    procedure Clear; virtual;
    procedure CreateUniqueName;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
      SaveDefaultValues: Boolean = False; Streaming: Boolean = False); virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Extended);
    procedure OnNotify(Sender: TObject); virtual;
    procedure OnPaste; virtual;
    function AllDiff(AComponent: TfrxComponent): String;
    function Diff(AComponent: TfrxComponent): String; virtual;
    function FindObject(const AName: String): TfrxComponent;
    function ContainerAdd(Obj: TfrxComponent): Boolean; virtual;
    function ContainerMouseDown(Sender: TObject; X, Y: Integer): Boolean; virtual;
    procedure ContainerMouseMove(Sender: TObject; X, Y: Integer); virtual;
    procedure ContainerMouseUp(Sender: TObject; X, Y: Integer); virtual;
    function FindDataSet(DataSet: TfrxDataSet; const DSName: String): TfrxDataSet;

    property Objects: TList read FObjects;
    property AllObjects: TList read GetAllObjects;
    property ContainerObjects: TList read GetContainerObjects;
    property Parent: TfrxComponent read FParent write SetParent;
    property Page: TfrxPage read GetPage;
    property Report: TfrxReport read GetReport;
    property IsAncestor: Boolean read GetIsAncestor;
    property IsDesigning: Boolean read FIsDesigning write FIsDesigning;
    property IsLoading: Boolean read GetIsLoading write FIsLoading;
    property IsPrinting: Boolean read FIsPrinting write FIsPrinting;
    property IsWriting: Boolean read FIsWriting write FIsWriting;
    property BaseName: String read FBaseName;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex default 0;
    property frComponentStyle: TfrxComponentStyle read FComponentStyle write FComponentStyle;

    property Left: Extended read FLeft write SetLeft;
    property Top: Extended read FTop write SetTop;
    property Width: Extended read FWidth write SetWidth;
    property Height: Extended read FHeight write SetHeight;
    property AbsLeft: Extended read GetAbsLeft;
    property AbsTop: Extended read GetAbsTop;

    property Description: String read FDescription write FDescription;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property Restrictions: TfrxRestrictions read FRestrictions write FRestrictions default [];
    property Visible: Boolean read FVisible write SetVisible default True;
{$IFNDEF FR_COM}
    property Font: TFont read FFont write SetFont stored IsFontStored;
{$ELSE}
    function GetFont: TFont;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
    { IfrxComponent }
    function IfrxComponent.GetObject = IfrxComponent_GetObject;
    function IfrxComponent.Get_Description = IfrxComponent_Get_Description;
    function IfrxComponent.Get_BaseName = IfrxComponent_Get_BaseName;
    function IfrxComponent.Get_ObjectsCount = IfrxComponent_Get_ObjectsCount;
    function IfrxComponent.Get_Left = IfrxComponent_Get_Left;
    procedure IfrxComponent.Set_Left = IfrxComponent_Set_Left;
    function IfrxComponent.Get_Top = IfrxComponent_Get_Top;
    procedure IfrxComponent.Set_Top = IfrxComponent_Set_Top;
    function IfrxComponent.Get_Width = IfrxComponent_Get_Width;
    procedure IfrxComponent.Set_Width = IfrxComponent_Set_Width;
    function IfrxComponent.Get_Height = IfrxComponent_Get_Height;
    procedure IfrxComponent.Set_Height = IfrxComponent_Set_Height;
    function IfrxComponent.FindObject = IfrxComponent_FindObject;
    function IfrxComponent.Get_AliasName = IfrxComponent_Get_AliasName;
    function IfrxComponent.Get_Name = IfrxComponent_Get_Name;

    function IfrxComponent_GetObject(Index: Integer): IfrxComponent; safecall;
    function IfrxComponent_Get_Description: WideString; safecall;
    function IfrxComponent_Get_BaseName: WideString; safecall;
    function IfrxComponent_Get_ObjectsCount: SYSINT; safecall;
    function IfrxComponent_Get_Left: Double; safecall;
    procedure IfrxComponent_Set_Left(Value: Double); safecall;
    function IfrxComponent_Get_Top: Double; safecall;
    procedure IfrxComponent_Set_Top(Value: Double); safecall;
    function IfrxComponent_Get_Width: Double; safecall;
    procedure IfrxComponent_Set_Width(Value: Double); safecall;
    function IfrxComponent_Get_Height: Double; safecall;
    procedure IfrxComponent_Set_Height(Value: Double); safecall;
    function IfrxComponent_FindObject(const ObjectName: WideString): IfrxComponent; safecall;
    function IfrxComponent_Get_AliasName: WideString; safecall;
    function IfrxComponent_Get_Name: WideString; safecall;
    function Get_Restrictions: frxRestrictions; safecall;
    procedure Set_Restrictions(Value: frxRestrictions); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
{$ENDIF}
  end;

  TfrxReportComponent = class(TfrxComponent)
  private
    FOnAfterData: TfrxNotifyEvent;
    FOnAfterPrint: TfrxNotifyEvent;
    FOnBeforePrint: TfrxNotifyEvent;
    FOnPreviewClick: TfrxPreviewClickEvent;
    FOnPreviewDblClick: TfrxPreviewClickEvent;
  public
    FShiftAmount: Extended;
    FShiftChildren: TList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
      virtual; abstract;
    procedure BeforePrint; virtual;
    procedure GetData; virtual;
    procedure AfterPrint; virtual;
    function GetComponentText: String; virtual;
    function GetRealBounds: TfrxRect; virtual;
    property OnAfterData: TfrxNotifyEvent read FOnAfterData write FOnAfterData;
    property OnAfterPrint: TfrxNotifyEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeforePrint: TfrxNotifyEvent read FOnBeforePrint write FOnBeforePrint;
    property OnPreviewClick: TfrxPreviewClickEvent read FOnPreviewClick write FOnPreviewClick;
    property OnPreviewDblClick: TfrxPreviewClickEvent read FOnPreviewDblClick write FOnPreviewDblClick;
  published
    property Description;
  end;

  TfrxDialogComponent = class(TfrxReportComponent)
  private
    FComponent: TComponent;
    procedure ReadLeft(Reader: TReader);
    procedure ReadTop(Reader: TReader);
    procedure WriteLeft(Writer: TWriter);
    procedure WriteTop(Writer: TWriter);
  protected
    FImageIndex: Integer;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    property Component: TComponent read FComponent write FComponent;
  end;

  TfrxDialogControl = class(TfrxReportComponent)
  private
    FControl: TControl;
    FOnClick: TfrxNotifyEvent;
    FOnDblClick: TfrxNotifyEvent;
    FOnEnter: TfrxNotifyEvent;
    FOnExit: TfrxNotifyEvent;
    FOnKeyDown: TfrxKeyEvent;
    FOnKeyPress: TfrxKeyPressEvent;
    FOnKeyUp: TfrxKeyEvent;
    FOnMouseDown: TfrxMouseEvent;
    FOnMouseMove: TfrxMouseMoveEvent;
    FOnMouseUp: TfrxMouseEvent;
    FOnActivate: TNotifyEvent;
    function GetColor: TColor;
    function GetEnabled: Boolean;
    procedure DoOnClick(Sender: TObject);
    procedure DoOnDblClick(Sender: TObject);
    procedure DoOnEnter(Sender: TObject);
    procedure DoOnExit(Sender: TObject);
    procedure DoOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnKeyPress(Sender: TObject; var Key: Char);
    procedure DoOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DoOnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetEnabled(const Value: Boolean);
    function GetCaption: String;
    procedure SetCaption(const Value: String);
    function GetHint: String;
    procedure SetHint(const Value: String);
    function GetShowHint: Boolean;
    procedure SetShowHint(const Value: Boolean);
    function GetTabStop: Boolean;
    procedure SetTabStop(const Value: Boolean);
  protected
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure SetParentFont(const Value: Boolean); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetParent(AParent: TfrxComponent); override;
    procedure FontChanged(Sender: TObject); override;
    procedure InitControl(AControl: TControl);
    procedure SetName(const AName: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;

    property Caption: String read GetCaption write SetCaption;
    property Color: TColor read GetColor write SetColor;
    property Control: TControl read FControl write FControl;
    property TabStop: Boolean read GetTabStop write SetTabStop default True;
    property OnClick: TfrxNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TfrxNotifyEvent read FOnDblClick write FOnDblClick;
    property OnEnter: TfrxNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TfrxNotifyEvent read FOnExit write FOnExit;
    property OnKeyDown: TfrxKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TfrxKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TfrxKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnMouseDown: TfrxMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TfrxMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TfrxMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
  published
    property Left;
    property Top;
    property Width;
    property Height;
    property Font;
    property GroupIndex;
    property ParentFont;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property Hint: String read GetHint write SetHint;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
    property Visible;
  end;

{$IFDEF FR_COM}
  TfrxDataSet = class(TfrxDialogComponent, IfrxDataSet)
{$ELSE}
  TfrxDataSet = class(TfrxDialogComponent)
{$ENDIF}
  private
    FCloseDataSource: Boolean;
    FEnabled: Boolean;
    FEof: Boolean;
    FOpenDataSource: Boolean;
    FRangeBegin: TfrxRangeBegin;
    FRangeEnd: TfrxRangeEnd;
    FRangeEndCount: Integer;
    FReportRef: TfrxReport;
    FUserName: String;
    FOnCheckEOF: TfrxCheckEOFEvent;
    FOnFirst: TNotifyEvent;
    FOnNext: TNotifyEvent;
    FOnPrior: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
  protected
    FInitialized: Boolean;
    FRecNo: Integer;
    function GetDisplayText(Index: String): WideString; virtual;
    function GetDisplayWidth(Index: String): Integer; virtual;
    function GetFieldType(Index: String): TfrxFieldType; virtual;
    function GetValue(Index: String): Variant; virtual;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetUserName(const Value: String); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Navigation methods }
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Open; virtual;
    procedure Close; virtual;
    procedure First; virtual;
    procedure Next; virtual;
    procedure Prior; virtual;
    function Eof: Boolean; virtual;

    { Data access }
    function FieldsCount: Integer; virtual;
    function HasField(const fName: String): Boolean;
    function IsBlobField(const fName: String): Boolean; virtual;
    function RecordCount: Integer; virtual;
    procedure AssignBlobTo(const fName: String; Obj: TObject); virtual;
    procedure GetFieldList(List: TStrings); virtual;
    property DisplayText[Index: String]: WideString read GetDisplayText;
    property DisplayWidth[Index: String]: Integer read GetDisplayWidth;
    property FieldType[Index: String]: TfrxFieldType read GetFieldType;
    property Value[Index: String]: Variant read GetValue;

    property CloseDataSource: Boolean read FCloseDataSource write FCloseDataSource;
    { OpenDataSource is kept for backward compatibility only }
    property OpenDataSource: Boolean read FOpenDataSource write FOpenDataSource default True;
    property RecNo: Integer read FRecNo;
    property ReportRef: TfrxReport read FReportRef write FReportRef;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
  published
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property RangeBegin: TfrxRangeBegin read FRangeBegin write FRangeBegin default rbFirst;
    property RangeEnd: TfrxRangeEnd read FRangeEnd write FRangeEnd default reLast;
    property RangeEndCount: Integer read FRangeEndCount write FRangeEndCount default 0;
    property UserName: String read FUserName write SetUserName;
    property OnCheckEOF: TfrxCheckEOFEvent read FOnCheckEOF write FOnCheckEOF;
    property OnFirst: TNotifyEvent read FOnFirst write FOnFirst;
    property OnNext: TNotifyEvent read FOnNext write FOnNext;
    property OnPrior: TNotifyEvent read FOnPrior write FOnPrior;
{$IFDEF FR_COM}
  private { Interface section }
    function Get_UserName(out Value: WideString): HResult; stdcall;
    function Set_UserName(const Value: WideString): HResult; stdcall;
    function Get_RangeBegin(out Value: frxRangeBegin): HResult; stdcall;
    function Set_RangeBegin(Value: frxRangeBegin): HResult; stdcall;
    function Get_RangeEndCount(out Value: Integer): HResult; stdcall;
    function Set_RangeEndCount(Value: Integer): HResult; stdcall;
    function Get_RangeEnd(out Value: frxRangeEnd): HResult; stdcall;
    function Set_RangeEnd(Value: frxRangeEnd): HResult; stdcall;
    function Get_FieldsCount(out Value: Integer): HResult; stdcall;
    function Get_RecordsCount(out Value: Integer): HResult; stdcall;
    function ValueOfField(const FieldName: WideString; out Value: OleVariant): HResult; stdcall;
    function Get_CurrentRecordNo(out Value: Integer): HResult; stdcall;
    function GoFirst: HResult; stdcall;
    function GoNext: HResult; stdcall;
    function GoPrior: HResult; stdcall;
{$ENDIF}
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
{$IFDEF FR_COM}
  TfrxUserDataSet = class(TfrxDataset, IfrxUserDataSet, IConnectionPointContainer)
  private
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint:  TConnectionPoint;
    FEvent:            IfrxUserDataSetEvents;
{$ELSE}
  TfrxUserDataSet = class(TfrxDataset)
  private
{$ENDIF}
    FFields: TStrings;
    FOnGetValue: TfrxGetValueEvent;
    FOnNewGetValue: TfrxNewGetValueEvent;
    procedure SetFields(const Value: TStrings);
  protected
    function GetDisplayText(Index: String): WideString; override;
    function GetValue(Index: String): Variant; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FieldsCount: Integer; override;
    procedure GetFieldList(List: TStrings); override;
  published
    property Fields: TStrings read FFields write SetFields;
    property OnGetValue: TfrxGetValueEvent read FOnGetValue write FOnGetValue;
    property OnNewGetValue: TfrxNewGetValueEvent read FOnNewGetValue write FOnNewGetValue;
{$IFDEF FR_COM}
  private
    function IfrxUserDataSet.Get_Fields = IfrxUserDataSet_Get_Fields;
    function IfrxUserDataSet.Set_Fields = IfrxUserDataSet_Set_Fields;
    function IfrxUserDataSet.Get_Name = IfrxUserDataSet_Get_Name;
    function IfrxUserDataSet.Set_Name = IfrxUserDataSet_Set_Name;

    function IfrxUserDataSet_Get_Fields(out Value: WideString): HResult; stdcall;
    function IfrxUserDataSet_Set_Fields(const Value: WideString): HResult; stdcall;
    function IfrxUserDataSet_Get_Name(out Value: WideString): HResult; stdcall;
    function IfrxUserDataSet_Set_Name(const Value: WideString): HResult; stdcall;

    procedure EventSinkChanged(const Sink: IUnknown; Connecting: Boolean);
    { COM proxy event functions }
    procedure COM_OnGetValueHandler(const VarName: String; var Value: Variant);
    procedure COM_OnCheckEOFHandler(Sender: TObject; var EOF : Boolean);
    procedure COM_OnFirstHandler(Sender: TObject);
    procedure COM_OnNextHandler(Sender: TObject);
    procedure COM_OnPrevHandler(Sender: TObject);
public
    property ConnectionPoints: TConnectionPoints read FConnectionPoints implements IConnectionPointContainer;

{$ENDIF}
  end;

  TfrxCustomDBDataSet = class(TfrxDataSet)
  private
    FAliases: TStrings;
    FFields: TStringList;
    procedure SetFieldAliases(const Value: TStrings);
  protected
    property Fields: TStringList read FFields;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ConvertAlias(const fName: String): String;
    function GetAlias(const fName: String): String;
    function FieldsCount: Integer; override;
  published
    property CloseDataSource;
    property FieldAliases: TStrings read FAliases write SetFieldAliases;
    property OpenDataSource;
    property OnClose;
    property OnOpen;
  end;

  TfrxDBComponents = class(TComponent)
  public
    function GetDescription: String; virtual;
  end;

  TfrxCustomDatabase = class(TfrxDialogComponent)
  protected
    procedure BeforeConnect(var Value: Boolean);
    procedure AfterDisconnect;
    procedure SetConnected(Value: Boolean); virtual;
    procedure SetDatabaseName(const Value: String); virtual;
    procedure SetLoginPrompt(Value: Boolean); virtual;
    procedure SetParams(Value: TStrings); virtual;
    function GetConnected: Boolean; virtual;
    function GetDatabaseName: String; virtual;
    function GetLoginPrompt: Boolean; virtual;
    function GetParams: TStrings; virtual;
  public
    function ToString: WideString{$IFDEF Delphi12}; reintroduce{$ENDIF}; virtual;
    procedure FromString(const Connection: WideString); virtual;
    procedure SetLogin(const Login, Password: String); virtual;
    property Connected: Boolean read GetConnected write SetConnected default False;
    property DatabaseName: String read GetDatabaseName write SetDatabaseName;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt default True;
    property Params: TStrings read GetParams write SetParams;
  end;


  TfrxComponentClass = class of TfrxComponent;

{ Report Objects }

  TfrxFrameLine = class(TPersistent)
  private
    FFrame: TfrxFrame;
    FColor: TColor;
    FStyle: TfrxFrameStyle;
    FWidth: Extended;
    function IsColorStored: Boolean;
    function IsStyleStored: Boolean;
    function IsWidthStored: Boolean;
  public
    constructor Create(AFrame: TfrxFrame);
    procedure Assign(Source: TPersistent); override;
    function Diff(ALine: TfrxFrameLine; const LineName: String;
      ColorChanged, StyleChanged, WidthChanged: Boolean): String;
  published
    property Color: TColor read FColor write FColor stored IsColorStored;
    property Style: TfrxFrameStyle read FStyle write FStyle stored IsStyleStored;
    property Width: Extended read FWidth write FWidth stored IsWidthStored;
  end;

{$IFDEF FR_COM}
  TfrxFrame = class(TDispatchablePersistent, IfrxFrame)
{$ELSE}
  TfrxFrame = class(TPersistent)
{$ENDIF}
  private
    FLeftLine: TfrxFrameLine;
    FTopLine: TfrxFrameLine;
    FRightLine: TfrxFrameLine;
    FBottomLine: TfrxFrameLine;
    FColor: TColor;
    FDropShadow: Boolean;
    FShadowWidth: Extended;
    FShadowColor: TColor;
    FStyle: TfrxFrameStyle;
    FTyp: TfrxFrameTypes;
    FWidth: Extended;
    function IsShadowWidthStored: Boolean;
    function IsTypStored: Boolean;
    function IsWidthStored: Boolean;
    procedure SetBottomLine(const Value: TfrxFrameLine);
    procedure SetLeftLine(const Value: TfrxFrameLine);
    procedure SetRightLine(const Value: TfrxFrameLine);
    procedure SetTopLine(const Value: TfrxFrameLine);
    procedure SetColor(const Value: TColor);
    procedure SetStyle(const Value: TfrxFrameStyle);
    procedure SetWidth(const Value: Extended);
{$IFDEF FR_COM}
    { IfrxFrame }
    function Get_Color(out Value: Integer): HResult; stdcall;
    function Set_Color(Value: Integer): HResult; stdcall;
    function Get_DropShadow(out Value: WordBool): HResult; stdcall;
    function Set_DropShadow(Value: WordBool): HResult; stdcall;
    function Get_ShadowColor(out Value: Integer): HResult; stdcall;
    function Set_ShadowColor(Value: Integer): HResult; stdcall;
    function Get_ShadowWidth(out Value: Double): HResult; stdcall;
    function Set_ShadowWidth(Value: Double): HResult; stdcall;
    function Get_Style(out Value: frxFrameStyle): HResult; stdcall;
    function Set_Style(Value: frxFrameStyle): HResult; stdcall;
    function Get_FrameType(out Value: Integer): HResult; stdcall;
    function Set_FrameType(Value: Integer): HResult; stdcall;
    function Get_Width(out Value: Double): HResult; stdcall;
    function Set_Width(Value: Double): HResult; stdcall;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Diff(AFrame: TfrxFrame): String;
  published
    property Color: TColor read FColor write SetColor default clBlack;
    property DropShadow: Boolean read FDropShadow write FDropShadow default False;
    property ShadowColor: TColor read FShadowColor write FShadowColor default clBlack;
    property ShadowWidth: Extended read FShadowWidth write FShadowWidth stored IsShadowWidthStored;
    property Style: TfrxFrameStyle read FStyle write SetStyle default fsSolid;
    property Typ: TfrxFrameTypes read FTyp write FTyp stored IsTypStored;
    property Width: Extended read FWidth write SetWidth stored IsWidthStored;
    property LeftLine: TfrxFrameLine read FLeftLine write SetLeftLine;
    property TopLine: TfrxFrameLine read FTopLine write SetTopLine;
    property RightLine: TfrxFrameLine read FRightLine write SetRightLine;
    property BottomLine: TfrxFrameLine read FBottomLine write SetBottomLine;
  end;

{$IFDEF FR_COM}
 TfrxView = class(TfrxReportComponent, IfrxView)
{$ELSE}
 TfrxView = class(TfrxReportComponent)
{$ENDIF}
  private
    FAlign: TfrxAlign;
    FBrushStyle: TBrushStyle;
    FColor: TColor;
    FCursor: TCursor;
    FDataField: String;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FFrame: TfrxFrame;
    FPrintable: Boolean;
    FShiftMode: TfrxShiftMode;
    FTagStr: String;
    FTempTag: String;
    FTempURL: String;
    FHint: String;
    FShowHint: Boolean;
    FURL: String;
    FPlainText: Boolean;
    procedure SetFrame(const Value: TfrxFrame);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  protected
    FX: Integer;
    FY: Integer;
    FX1: Integer;
    FY1: Integer;
    FDX: Integer;
    FDY: Integer;
    FFrameWidth: Integer;
    FScaleX: Extended;
    FScaleY: Extended;
    FOffsetX: Extended;
    FOffsetY: Extended;
    FCanvas: TCanvas;
    procedure BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); virtual;
    procedure DrawBackground; virtual;
    procedure DrawFrame; virtual;
    procedure DrawLine(x, y, x1, y1, w: Integer);
    procedure ExpandVariables(var Expr: String);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
{$IFDEF FR_COM}
    function Get_DataField(out Value: WideString): HResult; stdcall;
    function Set_DataField(const Value: WideString): HResult; stdcall;
    function Get_TagStr(out Value: WideString): HResult; stdcall;
    function Set_TagStr(const Value: WideString): HResult; stdcall;
    function Get_URL(out Value: WideString): HResult; stdcall;
    function Set_URL(const Value: WideString): HResult; stdcall;
    function Get_DataSetName(out Value: WideString): HResult; stdcall;
    function Set_DataSetName(const Value: WideString): HResult; stdcall;
    function Get_Name(out Value: WideString): HResult; stdcall;
    function Get_Frame(out Value: IfrxFrame): HResult; stdcall;
    function Get_ShiftMode(out Value: frxShiftMode): HResult; stdcall;
    function Set_ShiftMode(Value: frxShiftMode): HResult; stdcall;
    function Get_Align(out Value: frxAlign): HResult; stdcall;
    function Set_Align(Value: frxAlign): HResult; stdcall;
    function Get_Visible(out Value: WordBool): HResult; stdcall;
    function Set_Visible(Value: WordBool): HResult; stdcall;
    function Get_Printable(out Value: WordBool): HResult; stdcall;
    function Set_Printable(Value: WordBool): HResult; stdcall;
    function Get_Color(out Value: Integer): HResult; stdcall;
    function Set_Color(Value: Integer): HResult; stdcall;
    function Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
    function Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Diff(AComponent: TfrxComponent): String; override;
    function IsDataField: Boolean;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure BeforePrint; override;
    procedure GetData; override;
    procedure AfterPrint; override;
    property BrushStyle: TBrushStyle read FBrushStyle write FBrushStyle default bsSolid;
    property Color: TColor read FColor write FColor default clNone;
    property DataField: String read FDataField write FDataField;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property Frame: TfrxFrame read FFrame write SetFrame;
    property PlainText: Boolean read FPlainText write FPlainText;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property TagStr: String read FTagStr write FTagStr;
    property URL: String read FURL write FURL;
  published
    property Align: TfrxAlign read FAlign write FAlign default baNone;
    property Printable: Boolean read FPrintable write FPrintable default True;
    property ShiftMode: TfrxShiftMode read FShiftMode write FShiftMode default smAlways;
    property Left;
    property Top;
    property Width;
    property Height;
    property GroupIndex;
    property Restrictions;
    property Visible;
    property OnAfterData;
    property OnAfterPrint;
    property OnBeforePrint;
    property OnPreviewClick;
    property OnPreviewDblClick;
    property Hint: String read FHint write FHint;
    property ShowHint: Boolean read FShowHint write FShowHint; 
  end;

{$IFDEF FR_COM}
  TfrxStretcheable = class(TfrxView, IfrxStretcheable)
{$ELSE}
  TfrxStretcheable = class(TfrxView)
{$ENDIF}
  private
    FStretchMode: TfrxStretchMode;
{$IFDEF FR_COM}
    function Get_StretchMode(out Value: frxStretchMode): HResult; stdcall;
    function Set_StretchMode(Value: frxStretchMode): HResult; stdcall;
{$ENDIF}
  public
    FSaveHeight: Extended;
    FSavedTop: Extended;
    constructor Create(AOwner: TComponent); override;
    function CalcHeight: Extended; virtual;
    function DrawPart: Extended; virtual;
    procedure InitPart; virtual;
    function HasNextDataPart: Boolean; virtual;
  published
    property StretchMode: TfrxStretchMode read FStretchMode write FStretchMode
      default smDontStretch;
  end;

{$IFDEF FR_COM}
  TfrxHighlight = class(TDispatchablePersistent, IfrxHighlight)
{$ELSE}
  TfrxHighlight = class(TPersistent)
{$ENDIF}
  private
    FActive: Boolean;
    FColor: TColor;
    FCondition: String;
{$IFNDEF FR_COM}
    FFont: TFont;
{$ELSE}
    FFont: TfrxFont;
    function GetFont: TFont;
{$ENDIF}
    procedure SetFont(const Value: TFont);
{$IFDEF FR_COM}
    { IfrxHighlight }
    function Get_Active(out Value: WordBool): HResult; stdcall;
    function Set_Active(Value: WordBool): HResult; stdcall;
    function Get_Color(out Value: Integer): HResult; stdcall;
    function Set_Color(Value: Integer): HResult; stdcall;
    function Get_Font(out Value: IfrxFont): HResult; stdcall;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Active: Boolean read FActive write FActive default False;
{$IFNDEF FR_COM}
    property Font: TFont read FFont write SetFont;
{$ELSE}
    property Font: TFont read GetFont write SetFont;
{$ENDIF}
    property Color: TColor read FColor write FColor default clNone;
    property Condition: String read FCondition write FCondition;
  end;

{$IFDEF FR_COM}
  TfrxFormat = class(TDispatchablePersistent, IfrxDisplayFormat)
{$ELSE}
  TfrxFormat = class(TPersistent)
{$ENDIF}
  private
    FDecimalSeparator: String;
    FThousandSeparator: String;
    FFormatStr: String;
    FKind: TfrxFormatKind;
{$IFDEF FR_COM}
    { IfrxDisplayFormat }
    function Get_DecimalSeparator(out Value: WideString): HResult; stdcall;
    function Set_DecimalSeparator(const Value: WideString): HResult; stdcall;
    function Get_FormatStr(out Value: WideString): HResult; stdcall;
    function Set_FormatStr(const Value: WideString): HResult; stdcall;
    function Get_Kind(out Value: frxFormatKind): HResult; stdcall;
    function Set_Kind(Value: frxFormatKind): HResult; stdcall;
{$ENDIF}
  public
{$IFDEF FR_COM}
    constructor Create;
{$ENDIF}
    procedure Assign(Source: TPersistent); override;
  published
    property DecimalSeparator: String read FDecimalSeparator write FDecimalSeparator;
    property ThousandSeparator: String read FThousandSeparator write FThousandSeparator;
    property FormatStr: String read FFormatStr write FFormatStr;
    property Kind: TfrxFormatKind read FKind write FKind default fkText;
  end;

{$IFDEF FR_COM}
  TfrxCustomMemoView = class(TfrxStretcheable, IfrxCustomMemoView)
{$ELSE}
  TfrxCustomMemoView = class(TfrxStretcheable)
{$ENDIF}
  private
    FAllowExpressions: Boolean;
    FAllowHTMLTags: Boolean;
    FAutoWidth: Boolean;
    FCharSpacing: Extended;
    FClipped: Boolean;
    FDisplayFormat: TfrxFormat;
    FExpressionDelimiters: String;
    FFlowTo: TfrxCustomMemoView;
    FFirstParaBreak: Boolean;
    FGapX: Extended;
    FGapY: Extended;
    FHAlign: TfrxHAlign;
    FHideZeros: Boolean;
    FHighlight: TfrxHighlight;
    FLastParaBreak: Boolean;
    FLineSpacing: Extended;
    FMemo: TWideStrings;
    FParagraphGap: Extended;
    FPartMemo: WideString;
    FRotation: Integer;
    FRTLReading: Boolean;
    FStyle: String;
    FSuppressRepeated: Boolean;
    FTempMemo: WideString;
    FUnderlines: Boolean;
    FVAlign: TfrxVAlign;
    FValue: Variant;
    FWordBreak: Boolean;
    FWordWrap: Boolean;
    FWysiwyg: Boolean;
    FUseDefaultCharset: Boolean;
    procedure SetMemo(const Value: TWideStrings);
    procedure SetRotation(Value: Integer);
    procedure SetText(const Value: WideString);
    procedure SetAnsiText(const Value: AnsiString);
    function AdjustCalcHeight: Extended;
    function AdjustCalcWidth: Extended;
    function GetText: WideString;
    function GetAnsiText: AnsiString;
    function IsExprDelimitersStored: Boolean;
    function IsLineSpacingStored: Boolean;
    function IsGapXStored: Boolean;
    function IsGapYStored: Boolean;
    function IsHighlightStored: Boolean;
    function IsParagraphGapStored: Boolean;
    procedure SetHighlight(const Value: TfrxHighlight);
    procedure SetDisplayFormat(const Value: TfrxFormat);
    procedure SetStyle(const Value: String);
    function IsCharSpacingStored: Boolean;
  protected
    FLastValue: Variant;
    FTotalPages: Integer;
    FCopyNo: Integer;
    FTextRect: TRect;
    FPrintScale: Extended;
    function CalcAndFormat(const Expr: WideString): WideString;
    procedure BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure SetDrawParams(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function Diff(AComponent: TfrxComponent): String; override;
    function CalcHeight: Extended; override;
    function CalcWidth: Extended; virtual;
    function DrawPart: Extended; override;
    function GetComponentText: String; override;
    function FormatData(const Value: Variant; AFormat: TfrxFormat = nil): WideString;
    function WrapText(WrapWords: Boolean): WideString;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure BeforePrint; override;
    procedure GetData; override;
    procedure AfterPrint; override;
    procedure InitPart; override;
    procedure ApplyStyle(Style: TfrxStyleItem);
    procedure ExtractMacros;
    procedure ResetSuppress;
    property Text: WideString read GetText write SetText;
    property AnsiText: AnsiString read GetAnsiText write SetAnsiText;
    property Value: Variant read FValue write FValue;
    // analogue of Memo property
    property Lines: TWideStrings read FMemo write SetMemo;

    property AllowExpressions: Boolean read FAllowExpressions write FAllowExpressions default True;
    property AllowHTMLTags: Boolean read FAllowHTMLTags write FAllowHTMLTags default False;
    property AutoWidth: Boolean read FAutoWidth write FAutoWidth default False;
    property CharSpacing: Extended read FCharSpacing write FCharSpacing stored IsCharSpacingStored;
    property Clipped: Boolean read FClipped write FClipped default True;
    property DisplayFormat: TfrxFormat read FDisplayFormat write SetDisplayFormat;
    property ExpressionDelimiters: String read FExpressionDelimiters
      write FExpressionDelimiters stored IsExprDelimitersStored;
    property FlowTo: TfrxCustomMemoView read FFlowTo write FFlowTo;
    property GapX: Extended read FGapX write FGapX stored IsGapXStored;
    property GapY: Extended read FGapY write FGapY stored IsGapYStored;
    property HAlign: TfrxHAlign read FHAlign write FHAlign default haLeft;
    property HideZeros: Boolean read FHideZeros write FHideZeros default False;
    property Highlight: TfrxHighlight read FHighlight write SetHighlight
      stored IsHighlightStored;
    property LineSpacing: Extended read FLineSpacing write FLineSpacing stored IsLineSpacingStored;
    property Memo: TWideStrings read FMemo write SetMemo;
    property ParagraphGap: Extended read FParagraphGap write FParagraphGap stored IsParagraphGapStored;
    property Rotation: Integer read FRotation write SetRotation default 0;
    property RTLReading: Boolean read FRTLReading write FRTLReading default False;
    property Style: String read FStyle write SetStyle;
    property SuppressRepeated: Boolean read FSuppressRepeated write FSuppressRepeated default False;
    property Underlines: Boolean read FUnderlines write FUnderlines default False;
    property WordBreak: Boolean read FWordBreak write FWordBreak default False;
    property WordWrap: Boolean read FWordWrap write FWordWrap default True;
    property Wysiwyg: Boolean read FWysiwyg write FWysiwyg default True;
    property VAlign: TfrxVAlign read FVAlign write FVAlign default vaTop;
    property UseDefaultCharset: Boolean read FUseDefaultCharset write FUseDefaultCharset default False;
{$IFDEF FR_COM}
    { IfrxCustomMemoView }
    function IfrxCustomMemoView.Get_Text = IfrxCustomMemoView_Get_Text;
    function IfrxCustomMemoView.Set_Text = IfrxCustomMemoView_Set_Text;

    function IfrxCustomMemoView_Get_Text(out Value: WideString): HResult; stdcall;
    function IfrxCustomMemoView_Set_Text(const Value: WideString): HResult; stdcall;
{$ENDIF}
  published
    property FirstParaBreak: Boolean read FFirstParaBreak write FFirstParaBreak default False;
    property LastParaBreak: Boolean read FLastParaBreak write FLastParaBreak default False;
    property Cursor;
    property TagStr;
    property URL;
  end;

{$IFDEF FR_COM}
  TfrxMemoView = class(TfrxCustomMemoView, IfrxMemoView)
  protected
    function Get_AutoWidth(out Value: WordBool): HResult; stdcall;
    function Set_AutoWidth(Value: WordBool): HResult; stdcall;
    function Get_AllowExpressions(out Value: WordBool): HResult; stdcall;
    function Set_AllowExpressions(Value: WordBool): HResult; stdcall;
    function Get_AllowHTMLTags(out Value: WordBool): HResult; stdcall;
    function Set_AllowHTMLTags(Value: WordBool): HResult; stdcall;
    function Get_BrushStyle(out Value: frxBrushStyle): HResult; stdcall;
    function Set_BrushStyle(Value: frxBrushStyle): HResult; stdcall;
    function Get_CharSpacing(out Value: Double): HResult; stdcall;
    function Set_CharSpacing(Value: Double): HResult; stdcall;
    function Get_Clipped(out Value: WordBool): HResult; stdcall;
    function Set_Clipped(Value: WordBool): HResult; stdcall;
    function Get_Color(out Value: Integer): HResult; stdcall;
    function Set_Color(Value: Integer): HResult; stdcall;
    function Get_DataField(out Value: WideString): HResult; stdcall;
    function Set_DataField(const Value: WideString): HResult; stdcall;
    function Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
    function Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
    function Get_DataSetName(out Value: WideString): HResult; stdcall;
    function Set_DataSetName(const Value: WideString): HResult; stdcall;
    function Get_DisplayFormat(out Value: IfrxDisplayFormat): HResult; stdcall;
    function Get_ExpressionDelimiters(out Value: WideString): HResult; stdcall;
    function Set_ExpressionDelimiters(const Value: WideString): HResult; stdcall;
    function Get_FlowTo(out Value: IfrxCustomMemoView): HResult; stdcall;
    function Set_FlowTo(const Value: IfrxCustomMemoView): HResult; stdcall;
    function Get_Font(out Value: IfrxFont): HResult; stdcall;
    function Get_Frame(out Value: IfrxFrame): HResult; stdcall;
    function Get_GapX(out Value: Double): HResult; stdcall;
    function Set_GapX(Value: Double): HResult; stdcall;
    function Get_GapY(out Value: Double): HResult; stdcall;
    function Set_GapY(Value: Double): HResult; stdcall;
    function Get_HAlign(out Value: frxHAlign): HResult; stdcall;
    function Set_HAlign(Value: frxHAlign): HResult; stdcall;
    function Get_HideZeros(out Value: WordBool): HResult; stdcall;
    function Set_HideZeros(Value: WordBool): HResult; stdcall;
    function Get_Highlight(out Value: IfrxHighlight): HResult; stdcall;
    function Get_LineSpacing(out Value: Double): HResult; stdcall;
    function Set_LineSpacing(Value: Double): HResult; stdcall;
    function Get_Memo(out Value: WideString): HResult; stdcall;
    function Set_Memo(const Value: WideString): HResult; stdcall;
    function Get_ParagraphGap(out Value: Double): HResult; stdcall;
    function Set_ParagraphGap(Value: Double): HResult; stdcall;
    function Get_ParentFont(out Value: WordBool): HResult; stdcall;
    function Set_ParentFont(Value: WordBool): HResult; stdcall;
    function Get_Rotation(out Value: Integer): HResult; stdcall;
    function Set_Rotation(Value: Integer): HResult; stdcall;
    function Get_RTLReading(out Value: WordBool): HResult; stdcall;
    function Set_RTLReading(Value: WordBool): HResult; stdcall;
    function Get_Style(out Value: WideString): HResult; stdcall;
    function Set_Style(const Value: WideString): HResult; stdcall;
    function Get_SuppressRepeated(out Value: WordBool): HResult; stdcall;
    function Set_SuppressRepeated(Value: WordBool): HResult; stdcall;
    function Get_Underlines(out Value: WordBool): HResult; stdcall;
    function Set_Underlines(Value: WordBool): HResult; stdcall;
    function Get_WordBreak(out Value: WordBool): HResult; stdcall;
    function Set_WordBreak(Value: WordBool): HResult; stdcall;
    function Get_WordWrap(out Value: WordBool): HResult; stdcall;
    function Set_WordWrap(Value: WordBool): HResult; stdcall;
    function Get_VAlign(out Value: frxVAlign): HResult; stdcall;
    function Set_VAlign(Value: frxVAlign): HResult; stdcall;
{$ELSE}
  TfrxMemoView = class(TfrxCustomMemoView)
{$ENDIF}
  published
    property AutoWidth;
    property AllowExpressions;
    property AllowHTMLTags;
    property BrushStyle;
    property CharSpacing;
    property Clipped;
    property Color;
    property DataField;
    property DataSet;
    property DataSetName;
    property DisplayFormat;
    property ExpressionDelimiters;
    property FlowTo;
    property Font;
    property Frame;
    property GapX;
    property GapY;
    property HAlign;
    property HideZeros;
    property Highlight;
    property LineSpacing;
    property Memo;
    property ParagraphGap;
    property ParentFont;
    property Rotation;
    property RTLReading;
    property Style;
    property SuppressRepeated;
    property Underlines;
    property UseDefaultCharset;
    property WordBreak;
    property WordWrap;
    property Wysiwyg;
    property VAlign;
  end;

  TfrxSysMemoView = class(TfrxCustomMemoView)
  public
    class function GetDescription: String; override;
  published
    property AutoWidth;
    property BrushStyle;
    property CharSpacing;
    property Color;
    property DisplayFormat;
    property Font;
    property Frame;
    property GapX;
    property GapY;
    property HAlign;
    property HideZeros;
    property Highlight;
    property Memo;
    property ParentFont;
    property Rotation;
    property RTLReading;
    property Style;
    property SuppressRepeated;
    property VAlign;
    property WordWrap;
  end;

  TfrxCustomLineView = class(TfrxStretcheable)
  private
    FDiagonal: Boolean;
    FArrowEnd: Boolean;
    FArrowLength: Integer;
    FArrowSolid: Boolean;
    FArrowStart: Boolean;
    FArrowWidth: Integer;
    procedure DrawArrow(x1, y1, x2, y2: Extended);
    procedure DrawDiagonalLine;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    property ArrowEnd: Boolean read FArrowEnd write FArrowEnd default False;
    property ArrowLength: Integer read FArrowLength write FArrowLength default 20;
    property ArrowSolid: Boolean read FArrowSolid write FArrowSolid default False;
    property ArrowStart: Boolean read FArrowStart write FArrowStart default False;
    property ArrowWidth: Integer read FArrowWidth write FArrowWidth default 5;
    property Diagonal: Boolean read FDiagonal write FDiagonal default False;
  published
    property TagStr;
  end;

{$IFDEF FR_COM}
  TfrxLineView = class(TfrxCustomLineView, IfrxLineView)
{$ELSE}
  TfrxLineView = class(TfrxCustomLineView)
{$ENDIF}
  public
    class function GetDescription: String; override;
{$IFDEF FR_COM}
  private
    function Get_ArrowEnd(out Value: WordBool): HResult; stdcall;
    function Set_ArrowEnd(Value: WordBool): HResult; stdcall;
    function Get_ArrowLength(out Value: Integer): HResult; stdcall;
    function Set_ArrowLength(Value: Integer): HResult; stdcall;
    function Get_ArrowSolid(out Value: WordBool): HResult; stdcall;
    function Set_ArrowSolid(Value: WordBool): HResult; stdcall;
    function Get_ArrowStart(out Value: WordBool): HResult; stdcall;
    function Set_ArrowStart(Value: WordBool): HResult; stdcall;
    function Get_ArrowWidth(out Value: Integer): HResult; stdcall;
    function Set_ArrowWidth(Value: Integer): HResult; stdcall;
    function Get_Frame(out Value: IfrxFrame): HResult; stdcall;
    function Get_Diagonal(out Value: WordBool): HResult; stdcall;
    function Set_Diagonal(Value: WordBool): HResult; stdcall;
{$ENDIF}

  published
    property ArrowEnd;
    property ArrowLength;
    property ArrowSolid;
    property ArrowStart;
    property ArrowWidth;
    property Frame;
    property Diagonal;
  end;

{$IFDEF FR_COM}
  TfrxPictureView = class(TfrxView, IfrxPictureView)
{$ELSE}
  TfrxPictureView = class(TfrxView)
{$ENDIF}
  private
    FAutoSize: Boolean;
    FCenter: Boolean;
    FFileLink: String;
    FImageIndex: Integer;
    FIsImageIndexStored: Boolean;
    FIsPictureStored: Boolean;
    FKeepAspectRatio: Boolean;
    FPicture: TPicture;
    FPictureChanged: Boolean;
    FStretched: Boolean;
    FHightQuality: Boolean;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    procedure SetPicture(const Value: TPicture);
    procedure PictureChanged(Sender: TObject);
    procedure SetAutoSize(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
{$IFDEF FR_COM}
  protected
    function Get_Picture(out Value: OLE_HANDLE): HResult; stdcall;
    function Set_Picture(Value: OLE_HANDLE): HResult; stdcall;
    function Get_Metafile(out Value: OLE_HANDLE): HResult; stdcall;
    function Set_Metafile(Value: OLE_HANDLE): HResult; stdcall;
    function LoadViewFromStream(const Stream: IUnknown): HResult; stdcall;
    function SaveViewToStream(const Stream: IUnknown): HResult; stdcall;
    function Get_FileLink(out Value: WideString): HResult; stdcall;
    function Set_FileLink(const Value: WideString): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function Diff(AComponent: TfrxComponent):String; override;
    function LoadPictureFromStream(s: TStream; ResetStreamPos: Boolean = True): HResult;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure GetData; override;
    property IsImageIndexStored: Boolean read FIsImageIndexStored write FIsImageIndexStored;
    property IsPictureStored: Boolean read FIsPictureStored write FIsPictureStored;
  published
    property Cursor;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Center: Boolean read FCenter write FCenter default False;
    property DataField;
    property DataSet;
    property DataSetName;
    property Frame;
    property FileLink: String read FFileLink write FFileLink;
    property ImageIndex: Integer read FImageIndex write FImageIndex stored FIsImageIndexStored;
    property KeepAspectRatio: Boolean read FKeepAspectRatio write FKeepAspectRatio default True;
    property Picture: TPicture read FPicture write SetPicture stored FIsPictureStored;
    property Stretched: Boolean read FStretched write FStretched default True;
    property TagStr;
    property URL;
    property HightQuality: Boolean read FHightQuality write FHightQuality;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property TransparentColor: TColor read FTransparentColor write FTransparentColor;
  end;

{$IFDEF FR_COM}
  TfrxShapeView = class(TfrxView, IfrxShapeView)
{$ELSE}
  TfrxShapeView = class(TfrxView)
{$ENDIF}
  private
    FCurve: Integer;
    FShape: TfrxShapeKind;
{$IFDEF FR_COM}
    function Get_Curve(out Value: Integer): HResult; stdcall;
    function Set_Curve(Value: Integer): HResult; stdcall;
    function Get_ShapeType(out Value: frxShapeType): HResult; stdcall;
    function Set_ShapeType(Value: frxShapeType): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    function Diff(AComponent: TfrxComponent): String; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    class function GetDescription: String; override;
  published
    property BrushStyle;
    property Color;
    property Cursor;
    property Curve: Integer read FCurve write FCurve default 0;
    property Frame;
    property Shape: TfrxShapeKind read FShape write FShape default skRectangle;
    property TagStr;
    property URL;
  end;

{$IFDEF FR_COM}
  TfrxSubreport = class(TfrxView, IfrxSubreport)
{$ELSE}
  TfrxSubreport = class(TfrxView)
{$ENDIF}
  private
    FPage: TfrxReportPage;
    FPrintOnParent: Boolean;
    procedure SetPage(const Value: TfrxReportPage);
{$IFDEF FR_COM}
    function Get_Page(out Value: IfrxReportPage): HResult; stdcall;
    function Set_Page(const Value: IfrxReportPage): HResult; stdcall;
    function Get_PrintOnparent(out Value: WordBool): HResult; stdcall;
    function Set_PrintOnparent(Value: WordBool): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    class function GetDescription: String; override;
  published
    property Page: TfrxReportPage read FPage write SetPage;
    property PrintOnParent: Boolean read FPrintOnParent write FPrintOnParent
      default False;
  end;


{ Bands }
  TfrxChild = class;

{$IFDEF FR_COM}
  TfrxBand = class(TfrxReportComponent, IfrxBand)
{$ELSE}
  TfrxBand = class(TfrxReportComponent)
{$ENDIF}
  private
    FAllowSplit: Boolean;
    FChild: TfrxChild;
    FKeepChild: Boolean;
    FOnAfterCalcHeight: TfrxNotifyEvent;
    FOutlineText: String;
    FOverflow: Boolean;
    FStartNewPage: Boolean;
    FStretched: Boolean;
    FPrintChildIfInvisible: Boolean;
    FVertical: Boolean;
    function GetBandName: String;
    procedure SetChild(Value: TfrxChild);
    procedure SetVertical(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
{$IFDEF FR_COM}
  { IfrxBand }
    function IfrxBand.Get_AllowSplit = IfrxBand_Get_AllowSplit;
    function IfrxBand.Set_AllowSplit = IfrxBand_Set_AllowSplit;
    function IfrxBand.Get_KeepChild = IfrxBand_Get_KeepChild;
    function IfrxBand.Set_KeepChild = IfrxBand_Set_KeepChild;
    function IfrxBand.Get_OutlineText = IfrxBand_Get_OutlineText;
    function IfrxBand.Set_OutlineText = IfrxBand_Set_OutlineText;
    function IfrxBand.Get_Overflow = IfrxBand_Get_Overflow;
    function IfrxBand.Set_Overflow = IfrxBand_Set_Overflow;
    function IfrxBand.Get_StartNewPage = IfrxBand_Get_StartNewPage;
    function IfrxBand.Set_StartNewPage = IfrxBand_Set_StartNewPage;
    function IfrxBand.Get_Stretched = IfrxBand_Get_Stretched;
    function IfrxBand.Set_Stretched = IfrxBand_Set_Stretched;
    function IfrxBand.Get_PrintChildIfInvisible = IfrxBand_Get_PrintChildIfInvisible;
    function IfrxBand.Set_PrintChildIfInvisible = IfrxBand_Set_PrintChildIfInvisible;
    function IfrxBand.Get_Vertical = IfrxBand_Get_Vertical;
    function IfrxBand.Set_Vertical = IfrxBand_Set_Vertical;
    function IfrxBand.Get_BandName = IfrxBand_Get_BandName;

    function IfrxBand_Get_AllowSplit(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_AllowSplit(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_KeepChild(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_KeepChild(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_OutlineText(out Value: WideString): HResult; stdcall;
    function IfrxBand_Set_OutlineText(const Value: WideString): HResult; stdcall;
    function IfrxBand_Get_Overflow(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_Overflow(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_StartNewPage(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_StartNewPage(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_Stretched(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_Stretched(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_PrintChildIfInvisible(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_PrintChildIfInvisible(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_Vertical(out Value: WordBool): HResult; stdcall;
    function IfrxBand_Set_Vertical(Value: WordBool): HResult; stdcall;
    function IfrxBand_Get_BandName(out Value: WideString): HResult; stdcall;
    function Get_Child(out Value: IfrxChild): HResult; stdcall;
    function Set_Child(const Value: IfrxChild): HResult; stdcall;
{$ENDIF}
  public
    FSubBands: TList;                    { list of subbands }
    FHeader, FFooter, FGroup: TfrxBand;  { h./f./g. bands   }
    FLineN: Integer;                     { used for Line#   }
    FLineThrough: Integer;               { used for LineThrough#   }
    FOriginalObjectsCount: Integer;      { used for TfrxSubReport.PrintOnParent }
    FHasVBands: Boolean;                 { whether the band should show vbands }
    FStretchedHeight: Extended;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BandNumber: Integer;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    class function GetDescription: String; override;
    property AllowSplit: Boolean read FAllowSplit write FAllowSplit default False;
    property BandName: String read GetBandName;
    property Child: TfrxChild read FChild write SetChild;
    property KeepChild: Boolean read FKeepChild write FKeepChild default False;
    property OutlineText: String read FOutlineText write FOutlineText;
    property Overflow: Boolean read FOverflow write FOverflow;
    property PrintChildIfInvisible: Boolean read FPrintChildIfInvisible
      write FPrintChildIfInvisible default False;
    property StartNewPage: Boolean read FStartNewPage write FStartNewPage default False;
    property Stretched: Boolean read FStretched write FStretched default False;
  published
    property Font;
    property Height;
    property Left;
    property ParentFont;
    property Restrictions;
    property Top;
    property Vertical: Boolean read FVertical write SetVertical default False;
    property Visible;
    property Width;
    property OnAfterCalcHeight: TfrxNotifyEvent read FOnAfterCalcHeight
      write FOnAfterCalcHeight;
    property OnAfterPrint;
    property OnBeforePrint;
  end;

  TfrxBandClass = class of TfrxBand;

{$IFDEF FR_COM}
  TfrxDataBand = class(TfrxBand, IfrxDataBand)
{$ELSE}
  TfrxDataBand = class(TfrxBand)
{$ENDIF}
  private
    FColumnGap: Extended;
    FColumnWidth: Extended;
    FColumns: Integer;
    FCurColumn: Integer;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FFooterAfterEach: Boolean;
    FKeepFooter: Boolean;
    FKeepHeader: Boolean;
    FKeepTogether: Boolean;
    FPrintIfDetailEmpty: Boolean;
    FRowCount: Integer;
    FOnMasterDetail: TfrxNotifyEvent;
    FVirtualDataSet: TfrxUserDataSet;
    procedure SetCurColumn(Value: Integer);
    procedure SetRowCount(const Value: Integer);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
{$IFDEF FR_COM}
  {IfrxDataBand}
    function Get_ColumnGap(out Value: Double): HResult; stdcall;
    function Set_ColumnGap(Value: Double): HResult; stdcall;
    function Get_ColumnWidth(out Value: Double): HResult; stdcall;
    function Set_ColumnWidth(Value: Double): HResult; stdcall;
    function Get_ColumnsCount(out Value: Integer): HResult; stdcall;
    function Set_ColumnsCount(Value: Integer): HResult; stdcall;
    function Get_CurrentColumn(out Value: Integer): HResult; stdcall;
    function Set_CurrentColumn(Value: Integer): HResult; stdcall;
    function Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
    function Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
    function Get_FooterAfterEach(out Value: WordBool): HResult; stdcall;
    function Set_FooterAfterEach(Value: WordBool): HResult; stdcall;
    function Get_KeepFooter(out Value: WordBool): HResult; stdcall;
    function Set_KeepFooter(Value: WordBool): HResult; stdcall;
    function Get_KeepHeader(out Value: WordBool): HResult; stdcall;
    function Set_KeepHeader(Value: WordBool): HResult; stdcall;
    function Get_KeepTogether(out Value: WordBool): HResult; stdcall;
    function Set_KeepTogether(Value: WordBool): HResult; stdcall;
    function Get_PrintIfDetailEmpty(out Value: WordBool): HResult; stdcall;
    function Set_PrintIfDetailEmpty(Value: WordBool): HResult; stdcall;
    function Get_RowCount(out Value: Integer): HResult; stdcall;
    function Set_RowCount(Value: Integer): HResult; stdcall;
    function ResetDataSet: HResult; stdcall;
{$ENDIF}
  public
    FMaxY: Extended;                             { used for columns }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    property CurColumn: Integer read FCurColumn write SetCurColumn;
    property VirtualDataSet: TfrxUserDataSet read FVirtualDataSet;
  published
    property AllowSplit;
    property Child;
    property Columns: Integer read FColumns write FColumns default 0;
    property ColumnWidth: Extended read FColumnWidth write FColumnWidth;
    property ColumnGap: Extended read FColumnGap write FColumnGap;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property FooterAfterEach: Boolean read FFooterAfterEach write FFooterAfterEach default False;
    property KeepChild;
    property KeepFooter: Boolean read FKeepFooter write FKeepFooter default False;
    property KeepHeader: Boolean read FKeepHeader write FKeepHeader default False;
    property KeepTogether: Boolean read FKeepTogether write FKeepTogether default False;
    property OutlineText;
    property PrintChildIfInvisible;
    property PrintIfDetailEmpty: Boolean read FPrintIfDetailEmpty
      write FPrintIfDetailEmpty default False;
    property RowCount: Integer read FRowCount write SetRowCount;
    property StartNewPage;
    property Stretched;
    property OnMasterDetail: TfrxNotifyEvent read FOnMasterDetail write FOnMasterDetail;
  end;

{$IFDEF FR_COM}
  TfrxHeader = class(TfrxBand, IfrxHeader)
{$ELSE}
  TfrxHeader = class(TfrxBand)
{$ENDIF}
  private
    FReprintOnNewPage: Boolean;
{$IFDEF FR_COM}
    function Get_ReprintOnNewPage(out Value: WordBool): HResult; stdcall;
    function Set_ReprintOnNewPage(Value: WordBool): HResult; stdcall;
{$ENDIF}
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property ReprintOnNewPage: Boolean read FReprintOnNewPage write FReprintOnNewPage default False;
    property StartNewPage;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxFooter = class(TfrxBand, IfrxFooter)
{$ELSE}
  TfrxFooter = class(TfrxBand)
{$ENDIF}
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxMasterData = class(TfrxDataBand, IfrxMasterData)
{$ELSE}
  TfrxMasterData = class(TfrxDataBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxDetailData = class(TfrxDataBand, IfrxDetailData)
{$ELSE}
  TfrxDetailData = class(TfrxDataBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxSubdetailData = class(TfrxDataBand, IfrxSubdetailData)
{$ELSE}
  TfrxSubdetailData = class(TfrxDataBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxDataBand4 = class(TfrxDataBand, IfrxDataBand4)
{$ELSE}
  TfrxDataBand4 = class(TfrxDataBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxDataBand5 = class(TfrxDataBand, IfrxDataBand6)
{$ELSE}
  TfrxDataBand5 = class(TfrxDataBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxDataBand6 = class(TfrxDataBand, IfrxDataBand6)
{$ELSE}
  TfrxDataBand6 = class(TfrxDataBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxPageHeader = class(TfrxBand, IfrxPageHeader)
{$ELSE}
  TfrxPageHeader = class(TfrxBand)
{$ENDIF}
  private
    FPrintOnFirstPage: Boolean;
{$IFDEF FR_COM}
    function Get_PrintOnFirstPage(out Value: WordBool): HResult; stdcall;
    function Set_PrintOnFirstPage(Value: WordBool): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Child;
    property PrintChildIfInvisible;
    property PrintOnFirstPage: Boolean read FPrintOnFirstPage write FPrintOnFirstPage default True;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxPageFooter = class(TfrxBand, IfrxPageFooter)
{$ELSE}
  TfrxPageFooter = class(TfrxBand)
{$ENDIF}
  private
    FPrintOnFirstPage: Boolean;
    FPrintOnLastPage: Boolean;
{$IFDEF FR_COM}
    function Get_PrintOnFirstPage(out Value: WordBool): HResult; stdcall;
    function Set_PrintOnFirstPage(Value: WordBool): HResult; stdcall;
    function Get_PrintOnLastPage(out Value: WordBool): HResult; stdcall;
    function Set_PrintOnLastPage(Value: WordBool): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PrintOnFirstPage: Boolean read FPrintOnFirstPage write FPrintOnFirstPage default True;
    property PrintOnLastPage: Boolean read FPrintOnLastPage write FPrintOnLastPage default True;
  end;

{$IFDEF FR_COM}
  TfrxColumnHeader = class(TfrxBand, IfrxColumnHeader)
{$ELSE}
  TfrxColumnHeader = class(TfrxBand)
{$ENDIF}
  private
  public
  published
    property Child;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxColumnFooter = class(TfrxBand, IfrxColumnFooter)
{$ELSE}
  TfrxColumnFooter = class(TfrxBand)
{$ENDIF}
  private
  public
  published
  end;

{$IFDEF FR_COM}
  TfrxGroupHeader = class(TfrxBand, IfrxGroupHeader)
{$ELSE}
  TfrxGroupHeader = class(TfrxBand)
{$ENDIF}
  private
    FCondition: String;
    FDrillName: String;               { used instead Tag property in drill down }
    FDrillDown: Boolean;
    FExpandDrillDown: Boolean;
    FShowFooterIfDrillDown: Boolean;
    FShowChildIfDrillDown: Boolean;
    FKeepTogether: Boolean;
    FReprintOnNewPage: Boolean;
    FResetPageNumbers: Boolean;
{$IFDEF FR_COM}
    function Get_Condition: WideString; safecall;
    procedure Set_Condition(const Value: WideString); safecall;
    function Get_KeepTogether: WordBool; safecall;
    procedure Set_KeepTogether(Value: WordBool); safecall;
    function Get_ReprintOnNewPage: WordBool; safecall;
    procedure Set_ReprintOnNewPage(Value: WordBool); safecall;
    function Get_LastValue: OleVariant; safecall;
{$ENDIF}
  public
    FLastValue: Variant;
    function Diff(AComponent: TfrxComponent): String; override;
  published
    property AllowSplit;
    property Child;
    property Condition: String read FCondition write FCondition;
    property DrillDown: Boolean read FDrillDown write FDrillDown default False;
    property ExpandDrillDown: Boolean read FExpandDrillDown write FExpandDrillDown default False;
    property KeepChild;
    property KeepTogether: Boolean read FKeepTogether write FKeepTogether default False;
    property ReprintOnNewPage: Boolean read FReprintOnNewPage write FReprintOnNewPage default False;
    property OutlineText;
    property PrintChildIfInvisible;
    property ResetPageNumbers: Boolean read FResetPageNumbers write FResetPageNumbers default False;
    property ShowFooterIfDrillDown: Boolean read FShowFooterIfDrillDown
      write FShowFooterIfDrillDown default False;
    property ShowChildIfDrillDown: Boolean read FShowChildIfDrillDown
      write FShowChildIfDrillDown default False;
    property StartNewPage;
    property Stretched;
    property DrillName: String read FDrillName write FDrillName;
  end;

{$IFDEF FR_COM}
  TfrxGroupFooter = class(TfrxBand, IfrxGroupFooter)
{$ELSE}
  TfrxGroupFooter = class(TfrxBand)
{$ENDIF}
  private
    FHideIfSingleDataRecord: Boolean;
{$IFDEF FR_COM}
    function Get_HideIfSingledatarecord(out Value: WordBool): HResult; stdcall;
    function Set_HideIfSingledatarecord(Value: WordBool): HResult; stdcall;
{$ENDIF}
  public
  published
    property AllowSplit;
    property Child;
    property HideIfSingleDataRecord: Boolean read FHideIfSingleDataRecord
      write FHideIfSingleDataRecord default False;
    property KeepChild;
    property PrintChildIfInvisible;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxReportTitle = class(TfrxBand, IfrxReportTitle)
{$ELSE}
  TfrxReportTitle = class(TfrxBand)
{$ENDIF}
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property StartNewPage;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxReportSummary = class(TfrxBand, IfrxReportSummary)
{$ELSE}
  TfrxReportSummary = class(TfrxBand)
{$ENDIF}
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property StartNewPage;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxChild = class(TfrxBand, IfrxChild)
{$ELSE}
  TfrxChild = class(TfrxBand)
{$ENDIF}
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property StartNewPage;
    property Stretched;
  end;

{$IFDEF FR_COM}
  TfrxOverlay = class(TfrxBand, IfrxOverlay)
{$ELSE}
  TfrxOverlay = class(TfrxBand)
{$ENDIF}
  private
    FPrintOnTop: Boolean;
{$IFDEF FR_COM}
    function Get_PrintOnTop(out Value: WordBool): HResult; stdcall;
    function Set_PrintOnTop(Value: WordBool): HResult; stdcall;
{$ENDIF}

  public
  published
    property PrintOnTop: Boolean read FPrintOnTop write FPrintOnTop default False;
  end;

  TfrxNullBand = class(TfrxBand);


{ Pages }

{$IFDEF FR_COM}
  TfrxPage = class(TfrxComponent, IfrxPage)
{$ELSE}
  TfrxPage = class(TfrxComponent)
{$ENDIF}
  private
  protected
{$IFDEF FR_COM}
    function Get_Visible(out Value: WordBool): HResult; stdcall;
    function Set_Visible(Value: WordBool): HResult; stdcall;
{$ENDIF}
  public
  published
    property Font;
    property Visible;
  end;

{$IFDEF FR_COM}
  TfrxReportPage = class(TfrxPage, IfrxReportPage)
{$ELSE}
  TfrxReportPage = class(TfrxPage)
{$ENDIF}
  private
    FBackPicture: TfrxPictureView;
    FBin: Integer;
    FBinOtherPages: Integer;
    FBottomMargin: Extended;
    FColumns: Integer;
    FColumnWidth: Extended;
    FColumnPositions: TStrings;
    FDataSet: TfrxDataSet;
    FDuplex: TfrxDuplexMode;
    FEndlessHeight: Boolean;
    FEndlessWidth: Boolean;
    FHGuides: TStrings;
    FLargeDesignHeight: Boolean;
    FLeftMargin: Extended;
    FMirrorMargins: Boolean;
    FOrientation: TPrinterOrientation;
    FOutlineText: String;
    FPrintIfEmpty: Boolean;
    FPrintOnPreviousPage: Boolean;
    FResetPageNumbers: Boolean;
    FRightMargin: Extended;
    FSubReport: TfrxSubreport;
    FTitleBeforeHeader: Boolean;
    FTopMargin: Extended;
    FVGuides: TStrings;
    FOnAfterPrint: TfrxNotifyEvent;
    FOnBeforePrint: TfrxNotifyEvent;
    FOnManualBuild: TfrxNotifyEvent;
    FDataSetName: String;
    FBackPictureVisible: Boolean;
    FBackPicturePrintable: Boolean;
    FPageCount: Integer;
    procedure SetPageCount(const Value: Integer);
    procedure SetColumns(const Value: Integer);
    procedure SetOrientation(Value: TPrinterOrientation);
    procedure SetHGuides(const Value: TStrings);
    procedure SetVGuides(const Value: TStrings);
    procedure SetColumnPositions(const Value: TStrings);
    procedure SetFrame(const Value: TfrxFrame);
    function GetFrame: TfrxFrame;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    function GetBackPicture: TPicture;
    procedure SetBackPicture(const Value: TPicture);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  protected
    FPaperHeight: Extended;
    FPaperSize: Integer;
    FPaperWidth: Extended;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetPaperHeight(const Value: Extended); virtual;
    procedure SetPaperWidth(const Value: Extended); virtual;
    procedure SetPaperSize(const Value: Integer); virtual;
    procedure UpdateDimensions;
  public
    FSubBands: TList;   { list of master bands }
    FVSubBands: TList;  { list of vertical master bands }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function FindBand(Band: TfrxBandClass): TfrxBand;
    function IsSubReport: Boolean;
    procedure AlignChildren; override;
    procedure ClearGuides;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
    procedure SetDefaults; virtual;
    procedure SetSizeAndDimensions(ASize: Integer; AWidth, AHeight: Extended);
    property SubReport: TfrxSubreport read FSubReport;
  published
    { paper }
    property Orientation: TPrinterOrientation read FOrientation
      write SetOrientation default poPortrait;
    property PaperWidth: Extended read FPaperWidth write SetPaperWidth;
    property PaperHeight: Extended read FPaperHeight write SetPaperHeight;
    property PaperSize: Integer read FPaperSize write SetPaperSize;
    { margins }
    property LeftMargin: Extended read FLeftMargin write FLeftMargin;
    property RightMargin: Extended read FRightMargin write FRightMargin;
    property TopMargin: Extended read FTopMargin write FTopMargin;
    property BottomMargin: Extended read FBottomMargin write FBottomMargin;
    property MirrorMargins: Boolean read FMirrorMargins write FMirrorMargins
      default False;
    { columns }
    property Columns: Integer read FColumns write SetColumns default 0;
    property ColumnWidth: Extended read FColumnWidth write FColumnWidth;
    property ColumnPositions: TStrings read FColumnPositions write SetColumnPositions;
    { bins }
    property Bin: Integer read FBin write FBin default DMBIN_AUTO;
    property BinOtherPages: Integer read FBinOtherPages write FBinOtherPages
      default DMBIN_AUTO;
    { other }
    property BackPicture: TPicture read GetBackPicture write SetBackPicture;
    property BackPictureVisible: Boolean read FBackPictureVisible write FBackPictureVisible default True;
    property BackPicturePrintable: Boolean read FBackPicturePrintable write FBackPicturePrintable default True;
    property PageCount: Integer read FPageCount write SetPageCount default 1;
    property Color: TColor read GetColor write SetColor default clNone;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property Duplex: TfrxDuplexMode read FDuplex write FDuplex default dmNone;
    property Frame: TfrxFrame read GetFrame write SetFrame;
    property EndlessHeight: Boolean read FEndlessHeight write FEndlessHeight default False;
    property EndlessWidth: Boolean read FEndlessWidth write FEndlessWidth default False;
    property LargeDesignHeight: Boolean read FLargeDesignHeight
      write FLargeDesignHeight default False;
    property OutlineText: String read FOutlineText write FOutlineText;
    property PrintIfEmpty: Boolean read FPrintIfEmpty write FPrintIfEmpty default True;
    property PrintOnPreviousPage: Boolean read FPrintOnPreviousPage
      write FPrintOnPreviousPage default False;
    property ResetPageNumbers: Boolean read FResetPageNumbers
      write FResetPageNumbers default False;
    property TitleBeforeHeader: Boolean read FTitleBeforeHeader
      write FTitleBeforeHeader default True;
    property HGuides: TStrings read FHGuides write SetHGuides;
    property VGuides: TStrings read FVGuides write SetVGuides;
    property OnAfterPrint: TfrxNotifyEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeforePrint: TfrxNotifyEvent read FOnBeforePrint write FOnBeforePrint;
    property OnManualBuild: TfrxNotifyEvent read FOnManualBuild write FOnManualBuild;
{$IFDEF FR_COM}
    { IfrxReportPage }
    function IfrxReportPage.SetDefaults = IfrxReportPage_SetDefaults;
    function IfrxReportPage.Get_Bin = IfrxReportPage_Get_Bin;
    function IfrxReportPage.Set_Bin = IfrxReportPage_Set_Bin;
    function IfrxReportPage.Get_BinOtherPages = IfrxReportPage_Get_BinOtherPages;
    function IfrxReportPage.Set_BinOtherPages = IfrxReportPage_Set_BinOtherPages;
    function IfrxReportPage.Get_BottomMargin = IfrxReportPage_Get_BottomMargin;
    function IfrxReportPage.Set_BottomMargin = IfrxReportPage_Set_BottomMargin;
    function IfrxReportPage.Get_Columns = IfrxReportPage_Get_Columns;
    function IfrxReportPage.Set_Columns = IfrxReportPage_Set_Columns;
    function IfrxReportPage.Get_ColumnWidth = IfrxReportPage_Get_ColumnWidth;
    function IfrxReportPage.Set_ColumnWidth = IfrxReportPage_Set_ColumnWidth;
    function IfrxReportPage.Get_ColumnPositions = IfrxReportPage_Get_ColumnPosition;
    function IfrxReportPage.Set_ColumnPositions = IfrxReportPage_Set_ColumnPosition;
    function IfrxReportPage.Get_DataSet = IfrxReportPage_Get_DataSet;
    function IfrxReportPage.Set_DataSet = IfrxReportPage_Set_DataSet;
    function IfrxReportPage.Get_Duplex = IfrxReportPage_Get_Duplex;
    function IfrxReportPage.Set_Duplex = IfrxReportPage_Set_Duplex;
    function IfrxReportPage.Get_HGuides = IfrxReportPage_Get_HGuides;
    function IfrxReportPage.Set_HGuides = IfrxReportPage_Set_HGuides;
    function IfrxReportPage.Get_LargeDesignHeight = IfrxReportPage_Get_LargeDesignHeight;
    function IfrxReportPage.Set_LargeDesignHeight = IfrxReportPage_Set_LargeDesignHeight;
    function IfrxReportPage.Get_LeftMargin = IfrxReportPage_Get_LeftMargin;
    function IfrxReportPage.Set_LeftMargin = IfrxReportPage_Set_LeftMargin;
    function IfrxReportPage.Get_MirrorMargins = IfrxReportPage_Get_MirrorMargins;
    function IfrxReportPage.Set_MirrorMargins = IfrxReportPage_Set_MirrorMargins;
    function IfrxReportPage.Get_Orientation = IfrxReportPage_Get_Orientation;
    function IfrxReportPage.Set_Orientation = IfrxReportPage_Set_Orientation;
    function IfrxReportPage.Get_OutlineText = IfrxReportPage_Get_OutlineText;
    function IfrxReportPage.Set_OutlineText = IfrxReportPage_Set_OutlineText;
    function IfrxReportPage.Get_PrintIfEmpty = IfrxReportPage_Get_PrintIfEmpty;
    function IfrxReportPage.Set_PrintIfEmpty = IfrxReportPage_Set_PrintIfEmpty;
    function IfrxReportPage.Get_PrintOnPreviousPage = IfrxReportPage_Get_PrintOnPreviousPage;
    function IfrxReportPage.Set_PrintOnPreviousPage = IfrxReportPage_Set_PrintOnPreviousPage;
    function IfrxReportPage.Get_RightMargin = IfrxReportPage_Get_RightMargin;
    function IfrxReportPage.Set_RightMargin = IfrxReportPage_Set_RightMargin;
    function IfrxReportPage.Get_SubReport = IfrxReportPage_Get_SubReport;
    function IfrxReportPage.Set_SubReport = IfrxReportPage_Set_SubReport;
    function IfrxReportPage.Get_TitleBeforeHeader = IfrxReportPage_Get_TitleBeforeHeader;
    function IfrxReportPage.Set_TitleBeforeHeader = IfrxReportPage_Set_TitleBeforeHeader;
    function IfrxReportPage.Get_TopMargin = IfrxReportPage_Get_TopMargin;
    function IfrxReportPage.Set_TopMargin = IfrxReportPage_Set_TopMargin;
    function IfrxReportPage.Get_VGuides = IfrxReportPage_Get_VGuides;
    function IfrxReportPage.Set_VGuides = IfrxReportPage_Set_VGuides;
    function IfrxReportPage.Get_BackPicture = IfrxReportPage_Get_BackPickture;
    function IfrxReportPage.Set_BackPicture = IfrxReportPage_Set_BackPickture;

    function IfrxReportPage_SetDefaults: HResult; stdcall;
    function IfrxReportPage_Get_Bin(out Value: SYSINT): HResult; stdcall;
    function IfrxReportPage_Set_Bin(Value: SYSINT): HResult; stdcall;
    function IfrxReportPage_Get_BinOtherPages(out Value: SYSINT): HResult; stdcall;
    function IfrxReportPage_Set_BinOtherPages(Value: SYSINT): HResult; stdcall;
    function IfrxReportPage_Get_BottomMargin(out Value: Double): HResult; stdcall;
    function IfrxReportPage_Set_BottomMargin(Value: Double): HResult; stdcall;
    function IfrxReportPage_Get_Columns(out Value: SYSINT): HResult; stdcall;
    function IfrxReportPage_Set_Columns(Value: SYSINT): HResult; stdcall;
    function IfrxReportPage_Get_ColumnWidth(out Value: Double): HResult; stdcall;
    function IfrxReportPage_Set_ColumnWidth(Value: Double): HResult; stdcall;
    function IfrxReportPage_Get_ColumnPosition(out Value: WideString): HResult; stdcall;
    function IfrxReportPage_Set_ColumnPosition(const Value: WideString): HResult; stdcall;
    function IfrxReportPage_Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
    function IfrxReportPage_Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
    function IfrxReportPage_Get_Duplex(out Value: frxDuplexMode): HResult; stdcall;
    function IfrxReportPage_Set_Duplex(Value: frxDuplexMode): HResult; stdcall;
    function IfrxReportPage_Get_HGuides(out Value: WideString): HResult; stdcall;
    function IfrxReportPage_Set_HGuides(const Value: WideString): HResult; stdcall;
    function IfrxReportPage_Get_LargeDesignHeight(out Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Set_LargeDesignHeight(Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Get_LeftMargin(out Value: Double): HResult; stdcall;
    function IfrxReportPage_Set_LeftMargin(Value: Double): HResult; stdcall;
    function IfrxReportPage_Get_MirrorMargins(out Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Set_MirrorMargins(Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Get_Orientation(out Value: frxPrinterOrientation): HResult; stdcall;
    function IfrxReportPage_Set_Orientation(Value: frxPrinterOrientation): HResult; stdcall;
    function IfrxReportPage_Get_OutlineText(out Value: WideString): HResult; stdcall;
    function IfrxReportPage_Set_OutlineText(const Value: WideString): HResult; stdcall;
    function IfrxReportPage_Get_PrintIfEmpty(out Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Set_PrintIfEmpty(Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Get_PrintOnPreviousPage(out Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Set_PrintOnPreviousPage(Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Get_RightMargin(out Value: Double): HResult; stdcall;
    function IfrxReportPage_Set_RightMargin(Value: Double): HResult; stdcall;
    function IfrxReportPage_Get_SubReport(out Value: IfrxSubreport): HResult; stdcall;
    function IfrxReportPage_Set_SubReport(const Value: IfrxSubreport): HResult; stdcall;
    function IfrxReportPage_Get_TitleBeforeHeader(out Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Set_TitleBeforeHeader(Value: WordBool): HResult; stdcall;
    function IfrxReportPage_Get_TopMargin(out Value: Double): HResult; stdcall;
    function IfrxReportPage_Set_TopMargin(Value: Double): HResult; stdcall;
    function IfrxReportPage_Get_VGuides(out Value: WideString): HResult; stdcall;
    function IfrxReportPage_Set_VGuides(const Value: WideString): HResult; stdcall;
    function IfrxReportPage_Get_BackPickture(out Value: OLE_HANDLE): HResult; stdcall;
    function IfrxReportPage_Set_BackPickture(Value: OLE_HANDLE): HResult; stdcall;

    function Get_PaperWidth(out Value: Double): HResult; stdcall;
    function Set_PaperWidth(Value: Double): HResult; stdcall;
    function Get_PaperHeight(out Value: Double): HResult; stdcall;
    function Set_PaperHeight(Value: Double): HResult; stdcall;
{$ENDIF}
  end;

  TfrxDialogPage = class(TfrxPage)
  private
    FBorderStyle: TFormBorderStyle;
    FCaption: String;
    FColor: TColor;
    FForm: TForm;
    FOnActivate: TfrxNotifyEvent;
    FOnClick: TfrxNotifyEvent;
    FOnDeactivate: TfrxNotifyEvent;
    FOnHide: TfrxNotifyEvent;
    FOnKeyDown: TfrxKeyEvent;
    FOnKeyPress: TfrxKeyPressEvent;
    FOnKeyUp: TfrxKeyEvent;
    FOnResize: TfrxNotifyEvent;
    FOnShow: TfrxNotifyEvent;
    FOnCloseQuery: TfrxCloseQueryEvent;
    FPosition: TPosition;
    FWindowState: TWindowState;
    FClientWidth: Extended;
    FClientHeight: Extended;
    procedure DoInitialize;
    procedure DoOnActivate(Sender: TObject);
    procedure DoOnClick(Sender: TObject);
    procedure DoOnCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DoOnDeactivate(Sender: TObject);
    procedure DoOnHide(Sender: TObject);
    procedure DoOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnKeyPress(Sender: TObject; var Key: Char);
    procedure DoOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnShow(Sender: TObject);
    procedure DoOnResize(Sender: TObject);
    procedure DoModify(Sender: TObject);
    procedure DoOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SetBorderStyle(const Value: TFormBorderStyle);
    procedure SetCaption(const Value: String);
    procedure SetColor(const Value: TColor);
    function GetModalResult: TModalResult;
    procedure SetModalResult(const Value: TModalResult);
  protected
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure SetClientWidth(Value: Extended);
    procedure SetClientHeight(Value: Extended);
    function GetClientWidth: Extended;
    function GetClientHeight: Extended;
    procedure FontChanged(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    procedure Initialize;
    function ShowModal: TModalResult;
    property DialogForm: TForm read FForm;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
  published
    property BorderStyle: TFormBorderStyle read FBorderStyle write SetBorderStyle default bsSizeable;
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Height;
    property ClientHeight: Extended read GetClientHeight write SetClientHeight;
    property Left;
    property Position: TPosition read FPosition write FPosition default poScreenCenter;
    property Top;
    property Width;
    property ClientWidth: Extended read GetClientWidth write SetClientWidth;
    property WindowState: TWindowState read FWindowState write FWindowState default wsNormal;
    property OnActivate: TfrxNotifyEvent read FOnActivate write FOnActivate;
    property OnClick: TfrxNotifyEvent read FOnClick write FOnClick;
    property OnCloseQuery: TfrxCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property OnDeactivate: TfrxNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnHide: TfrxNotifyEvent read FOnHide write FOnHide;
    property OnKeyDown: TfrxKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TfrxKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TfrxKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnShow: TfrxNotifyEvent read FOnShow write FOnShow;
    property OnResize: TfrxNotifyEvent read FOnResize write FOnResize;
  end;

  TfrxDataPage = class(TfrxPage)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property Height;
    property Left;
    property Top;
    property Width;
  end;


{ Report }

{$IFDEF FR_COM}
  TfrxEngineOptions = class(TDispatchablePersistent, IfrxEngineOptions)
{$ELSE}
  TfrxEngineOptions = class(TPersistent)
{$ENDIF}
  private
    FConvertNulls: Boolean;
    FDestroyForms: Boolean;
    FDoublePass: Boolean;
    FMaxMemSize: Integer;
    FPrintIfEmpty: Boolean;
{$IFNDEF FR_COM}
    FReportThread: TThread;
{$ENDIF}
    FEnableThreadSafe: Boolean;
    FSilentMode: TfrxSilentMode;
    FTempDir: String;
    FUseFileCache: Boolean;
    FUseGlobalDataSetList: Boolean;
    FIgnoreDevByZero: Boolean;

    procedure SetSilentMode(Mode: Boolean);
    function GetSilentMode: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
{$IFNDEF FR_COM}
    property ReportThread: TThread read FReportThread write FReportThread;
{$ENDIF}
    property DestroyForms: Boolean read FDestroyForms write FDestroyForms;
    property EnableThreadSafe: Boolean read FEnableThreadSafe write FEnableThreadSafe;
    property UseGlobalDataSetList: Boolean read FUseGlobalDataSetList write FUseGlobalDataSetList;
  published
    property ConvertNulls: Boolean read FConvertNulls write FConvertNulls default True;
    property DoublePass: Boolean read FDoublePass write FDoublePass default False;
    property MaxMemSize: Integer read FMaxMemSize write FMaxMemSize default 10;
    property PrintIfEmpty: Boolean read FPrintIfEmpty write FPrintIfEmpty default True;
    property SilentMode: Boolean read GetSilentMode write SetSilentMode default False;
    property NewSilentMode: TfrxSilentMode read FSilentMode write FSilentMode default simMessageBoxes;
    property TempDir: String read FTempDir write FTempDir;
    property UseFileCache: Boolean read FUseFileCache write FUseFileCache default False;
    property IgnoreDevByZero: Boolean read FIgnoreDevByZero write FIgnoreDevByZero default False;
{$IFDEF FR_COM}
    { IfrxEngineOptions }
    function IfrxEngineOptions.Get_ConvertNulls = IfrxEngineOptions_Get_ConvertNulls;
    function IfrxEngineOptions.Set_ConvertNulls = IfrxEngineOptions_Set_ConvertNulls;
    function IfrxEngineOptions.Get_DestroyForms = IfrxEngineOptions_Get_DestroyForms;
    function IfrxEngineOptions.Set_DestroyForms = IfrxEngineOptions_Set_DestroyForms;
    function IfrxEngineOptions.Get_DoublePass = IfrxEngineOptions_Get_DoublePass;
    function IfrxEngineOptions.Set_DoublePass = IfrxEngineOptions_Set_DoublePass;
    function IfrxEngineOptions.Get_MaxMemSize = IfrxEngineOptions_Get_MaxMemSize;
    function IfrxEngineOptions.Set_MaxMemSize = IfrxEngineOptions_Set_MaxMemSize;
    function IfrxEngineOptions.Get_PrintIfEmpty = IfrxEngineOptions_Get_PrintIfEmpty;
    function IfrxEngineOptions.Set_PrintIfEmpty = IfrxEngineOptions_Set_PrintIfEmpty;
    function IfrxEngineOptions.Get_SilentMode = IfrxEngineOptions_Get_SilentMode;
    function IfrxEngineOptions.Set_SilentMode = IfrxEngineOptions_Set_SilentMode;
    function IfrxEngineOptions.Get_TempDir = IfrxEngineOptions_Get_TempDir;
    function IfrxEngineOptions.Set_TempDir = IfrxEngineOptions_Set_TempDir;
    function IfrxEngineOptions.Get_UseFilecache = IfrxEngineOptions_Get_UseFilecache;
    function IfrxEngineOptions.Set_UseFilecache = IfrxEngineOptions_Set_UseFilecache;

    function IfrxEngineOptions_Get_ConvertNulls(out Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Set_ConvertNulls(Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Get_DestroyForms(out Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Set_DestroyForms(Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Get_DoublePass(out Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Set_DoublePass(Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Get_MaxMemSize(out Value: SYSINT): HResult; stdcall;
    function IfrxEngineOptions_Set_MaxMemSize(Value: SYSINT): HResult; stdcall;
    function IfrxEngineOptions_Get_PrintIfEmpty(out Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Set_PrintIfEmpty(Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Get_SilentMode(out Value: frxSilentMode): HResult; stdcall;
    function IfrxEngineOptions_Set_SilentMode(Value: frxSilentMode): HResult; stdcall;
    function IfrxEngineOptions_Get_TempDir(out Value: WideString): HResult; stdcall;
    function IfrxEngineOptions_Set_TempDir(const Value: WideString): HResult; stdcall;
    function IfrxEngineOptions_Get_UseFilecache(out Value: WordBool): HResult; stdcall;
    function IfrxEngineOptions_Set_UseFilecache(Value: WordBool): HResult; stdcall;
    function Get_UseGlobalDatasetList(out Value: WordBool): HResult; stdcall;
    function Set_UseGlobalDatasetList(Value: WordBool): HResult; stdcall;
{$ENDIF}
  end;

{$IFDEF FR_COM}
  TfrxPrintOptions = class(TDispatchablePersistent, IfrxPrintOptions)
{$ELSE}
  TfrxPrintOptions = class(TPersistent)
{$ENDIF}
  private
    FCopies: Integer;
    FCollate: Boolean;
    FPageNumbers: String;
    FPagesOnSheet: Integer;
    FPrinter: String;
    FPrintMode: TfrxPrintMode;
    FPrintOnSheet: Integer;
    FPrintPages: TfrxPrintPages;
    FReverse: Boolean;
    FShowDialog: Boolean;
    FSwapPageSize: Boolean;
    FPrnOutFileName: String;
    FDuplex: TfrxDuplexMode;
    FSplicingLine: Integer;
{$IFDEF FR_COM}
  protected
    { IfrxPrintOptions }
    function Get_Copies(out Value: SYSINT): HResult; stdcall;
    function Set_Copies(Value: SYSINT): HResult; stdcall;
    function Get_Collate(out Value: WordBool): HResult; stdcall;
    function Set_Collate(Value: WordBool): HResult; stdcall;
    function Get_PageNumbers(out Value: WideString): HResult; stdcall;
    function Set_PageNumbers(const Value: WideString): HResult; stdcall;
    function Get_Printer(out Value: WideString): HResult; stdcall;
    function Set_Printer(const Value: WideString): HResult; stdcall;
    function Get_PrintPages(out Value: frxPrintPages): HResult; stdcall;
    function Set_PrintPages(Value: frxPrintPages): HResult; stdcall;
    function Get_Reverse(out Value: WordBool): HResult; stdcall;
    function Set_Reverse(Value: WordBool): HResult; stdcall;
    function Get_ShowDialog(out Value: WordBool): HResult; stdcall;
    function Set_ShowDialog(Value: WordBool): HResult; stdcall;
    function Get_PrintMode(out Value: frxPrintMode): HResult; stdcall;
    function Set_PrintMode(Value: frxPrintMode): HResult; stdcall;
    function Get_PrintOnSheet(out Value: Integer): HResult; stdcall;
    function Set_PrintOnSheet(Value: Integer): HResult; stdcall;
    function Get_PrnOutFilename(out Value: WideString): HResult; stdcall;
    function Set_PrnOutFilename(const Value: WideString): HResult; stdcall;
{$ENDIF}
  public
    constructor Create;
{$IFDEF FR_COM}
    destructor Destroy; override;
{$ENDIF}
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property PrnOutFileName: String read FPrnOutFileName write FPrnOutFileName;
    property Duplex: TfrxDuplexMode read FDuplex write FDuplex;// set only after prepare report, need to store global duplex
    property SplicingLine: Integer read FSplicingLine write FSplicingLine default 3;
  published
    property Copies: Integer read FCopies write FCopies default 1;
    property Collate: Boolean read FCollate write FCollate default True;
    property PageNumbers: String read FPageNumbers write FPageNumbers;
    property Printer: String read FPrinter write FPrinter;
    property PrintMode: TfrxPrintMode read FPrintMode write FPrintMode default pmDefault;
    property PrintOnSheet: Integer read FPrintOnSheet write FPrintOnSheet;
    property PrintPages: TfrxPrintPages read FPrintPages write FPrintPages default ppAll;
    property Reverse: Boolean read FReverse write FReverse default False;
    property ShowDialog: Boolean read FShowDialog write FShowDialog default True;
    property SwapPageSize: Boolean read FSwapPageSize write FSwapPageSize stored False;// remove it
  end;

{$IFDEF FR_COM}
  TfrxPreviewOptions = class(TDispatchablePersistent, IfrxPreviewOptions)
{$ELSE}
  TfrxPreviewOptions = class(TPersistent)
{$ENDIF}
  private
    FAllowEdit: Boolean;
    FButtons: TfrxPreviewButtons;
    FDoubleBuffered: Boolean;
    FMaximized: Boolean;
    FMDIChild: Boolean;
    FModal: Boolean;
    FOutlineExpand: Boolean;
    FOutlineVisible: Boolean;
    FOutlineWidth: Integer;
    FPagesInCache: Integer;
    FShowCaptions: Boolean;
    FThumbnailVisible: Boolean;
    FZoom: Extended;
    FZoomMode: TfrxZoomMode;
    FPictureCacheInFile: Boolean;
    FRTLPreview: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property RTLPreview: Boolean read FRTLPreview write FRTLPreview;
  published
    property AllowEdit: Boolean read FAllowEdit write FAllowEdit default True;
    property Buttons: TfrxPreviewButtons read FButtons write FButtons;
    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered default True;
    property Maximized: Boolean read FMaximized write FMaximized default True;
    property MDIChild: Boolean read FMDIChild write FMDIChild default False;
    property Modal: Boolean read FModal write FModal default True;
    property OutlineExpand: Boolean read FOutlineExpand write FOutlineExpand default True;
    property OutlineVisible: Boolean read FOutlineVisible write FOutlineVisible default False;
    property OutlineWidth: Integer read FOutlineWidth write FOutlineWidth default 120;
    property PagesInCache: Integer read FPagesInCache write FPagesInCache default 50;
    property ThumbnailVisible: Boolean read FThumbnailVisible write FThumbnailVisible default False;
    property ShowCaptions: Boolean read FShowCaptions write FShowCaptions default False;
    property Zoom: Extended read FZoom write FZoom;
    property ZoomMode: TfrxZoomMode read FZoomMode write FZoomMode default zmDefault;
    property PictureCacheInFile: Boolean read FPictureCacheInFile write FPictureCacheInFile default False;
{$IFDEF FR_COM}
    { IfrxPreviewOptions }
    function Get_AllowEdit(out Value: WordBool): HResult; stdcall;
    function Set_AllowEdit(Value: WordBool): HResult; stdcall;
    function Get_Buttons(out Value: frxPreviewButtons): HResult; stdcall;
    function Set_Buttons(Value: frxPreviewButtons): HResult; stdcall;
    function Get_DoubleBuffered(out Value: WordBool): HResult; stdcall;
    function Set_DoubleBuffered(Value: WordBool): HResult; stdcall;
    function Get_Maximized(out Value: WordBool): HResult; stdcall;
    function Set_Maximized(Value: WordBool): HResult; stdcall;
    function Get_MDIChild(out Value: WordBool): HResult; stdcall;
    function Set_MDIChild(Value: WordBool): HResult; stdcall;
    function Get_Modal(out Value: WordBool): HResult; stdcall;
    function Set_Modal(Value: WordBool): HResult; stdcall;
    function Get_OutlineExpand(out Value: WordBool): HResult; stdcall;
    function Set_OutlineExpand(Value: WordBool): HResult; stdcall;
    function Get_OutlineVisible(out Value: WordBool): HResult; stdcall;
    function Set_OutlineVisible(Value: WordBool): HResult; stdcall;
    function Get_OutlineWidth(out Value: SYSINT): HResult; stdcall;
    function Set_OutlineWidth(Value: SYSINT): HResult; stdcall;
    function Get_ShowCaptions(out Value: WordBool): HResult; stdcall;
    function Set_ShowCaptions(Value: WordBool): HResult; stdcall;
    function Get_Zoom(out Value: Double): HResult; stdcall;
    function Set_Zoom(Value: Double): HResult; stdcall;
    function Get_ZoomMode(out Value: frxZoomMode): HResult; stdcall;
    function Set_ZoomMode(Value: frxZoomMode): HResult; stdcall;
    function Get_PictureCacheInFile(out Value: WordBool): HResult; stdcall;
    function Set_PictureCacheInFile(Value: WordBool): HResult; stdcall;
    function Get_RTLPreview(out Value: WordBool): HResult; stdcall;
    function Set_RTLPreview(Value: WordBool): HResult; stdcall;
{$ENDIF}
  end;

{$IFDEF FR_COM}
  TfrxReportOptions = class(TDispatchablePersistent, IfrxReportOptions)
{$ELSE}
  TfrxReportOptions = class(TPersistent)
{$ENDIF}
  private
    FAuthor: String;
    FCompressed: Boolean;
    FConnectionName: String;
    FCreateDate: TDateTime;
    FDescription: TStrings;
    FInitString: String;
    FName: String;
    FLastChange: TDateTime;
    FPassword: String;
    FPicture: TPicture;
    FReport: TfrxReport;
    FVersionBuild: String;
    FVersionMajor: String;
    FVersionMinor: String;
    FVersionRelease: String;
    FPrevPassword: String;
    FHiddenPassword: String;
    FInfo: Boolean;
    procedure SetDescription(const Value: TStrings);
    procedure SetPicture(const Value: TPicture);
    procedure SetConnectionName(const Value: String);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    function CheckPassword: Boolean;
    property PrevPassword: String write FPrevPassword;
    property Info: Boolean read FInfo write FInfo;
    property HiddenPassword: String read FHiddenPassword write FHiddenPassword;
  published
    property Author: String read FAuthor write FAuthor;
    property Compressed: Boolean read FCompressed write FCompressed default False;
    property ConnectionName: String read FConnectionName write SetConnectionName;
    property CreateDate: TDateTime read FCreateDate write FCreateDate;
    property Description: TStrings read FDescription write SetDescription;
    property InitString: String read FInitString write FInitString;
    property Name: String read FName write FName;
    property LastChange: TDateTime read FLastChange write FLastChange;
    property Password: String read FPassword write FPassword;
    property Picture: TPicture read FPicture write SetPicture;
    property VersionBuild: String read FVersionBuild write FVersionBuild;
    property VersionMajor: String read FVersionMajor write FVersionMajor;
    property VersionMinor: String read FVersionMinor write FVersionMinor;
    property VersionRelease: String read FVersionRelease write FVersionRelease;
{$IFDEF FR_COM}
    {IfrxReportOptions}
    function IfrxReportOptions.Get_Author = IfrxReportOptions_Get_Author;
    function IfrxReportOptions.Set_Author = IfrxReportOptions_Set_Author;
    function IfrxReportOptions.Get_Compressed = IfrxReportOptions_Get_Compressed;
    function IfrxReportOptions.Set_Compressed = IfrxReportOptions_Set_Compressed;
    function IfrxReportOptions.Get_ConnectionName = IfrxReportOptions_Get_ConnectionName;
    function IfrxReportOptions.Set_ConnectionName = IfrxReportOptions_Set_ConnectionName;
    function IfrxReportOptions.Get_CreationDate = IfrxReportOptions_Get_CreationDate;
    function IfrxReportOptions.Set_CreationDate = IfrxReportOptions_Set_CreationDate;
    function IfrxReportOptions.Get_Description = IfrxReportOptions_Get_Description;
    function IfrxReportOptions.Set_Description = IfrxReportOptions_Set_Description;
    function IfrxReportOptions.Get_InitString = IfrxReportOptions_Get_InitString;
    function IfrxReportOptions.Set_InitString = IfrxReportOptions_Set_InitString;
    function IfrxReportOptions.Get_Name = IfrxReportOptions_Get_Name;
    function IfrxReportOptions.Set_Name = IfrxReportOptions_Set_Name;
    function IfrxReportOptions.Get_LastChange = IfrxReportOptions_Get_LastChange;
    function IfrxReportOptions.Set_LastChange = IfrxReportOptions_Set_LastChange;
    function IfrxReportOptions.Get_Password = IfrxReportOptions_Get_Password;
    function IfrxReportOptions.Set_Password = IfrxReportOptions_Set_Password;
    function IfrxReportOptions.Get_Picture = IfrxReportOptions_Get_Picture;
    function IfrxReportOptions.Set_Picture = IfrxReportOptions_Set_Picture;
    function IfrxReportOptions.Get_VersionBuild = IfrxReportOptions_Get_VersionBuild;
    function IfrxReportOptions.Set_VersionBuild = IfrxReportOptions_Set_VersionBuild;
    function IfrxReportOptions.Get_VersionMajor = IfrxReportOptions_Get_VersionMajor;
    function IfrxReportOptions.Set_VersionMajor = IfrxReportOptions_Set_VersionMajor;
    function IfrxReportOptions.Get_VersionMinor = IfrxReportOptions_Get_VersionMinor;
    function IfrxReportOptions.Set_VersionMinor = IfrxReportOptions_Set_VersionMinor;
    function IfrxReportOptions.Get_VersionRelease = IfrxReportOptions_Get_VersionRelease;
    function IfrxReportOptions.Set_VersionRelease = IfrxReportOptions_Set_VersionRelease;
    function IfrxReportOptions.Get_HiddenPassword = IfrxReportOptions_Get_HiddenPassword;
    function IfrxReportOptions.Set_HiddenPassword = IfrxReportOptions_Set_HiddenPassword;

    function IfrxReportOptions_Get_Author(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_Author(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_Compressed(out Value: WordBool): HResult; stdcall;
    function IfrxReportOptions_Set_Compressed(Value: WordBool): HResult; stdcall;
    function IfrxReportOptions_Get_ConnectionName(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_ConnectionName(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_CreationDate(out Value: TDateTime): HResult; stdcall;
    function IfrxReportOptions_Set_CreationDate(Value: TDateTime): HResult; stdcall;
    function IfrxReportOptions_Get_Description(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_Description(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_InitString(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_InitString(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_Name(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_Name(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_LastChange(out Value: TDateTime): HResult; stdcall;
    function IfrxReportOptions_Set_LastChange(Value: TDateTime): HResult; stdcall;
    function IfrxReportOptions_Get_Password(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_Password(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_Picture(out Value: IUnknown): HResult; stdcall;
    function IfrxReportOptions_Set_Picture(const Value: IUnknown): HResult; stdcall;
    function IfrxReportOptions_Get_VersionBuild(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_VersionBuild(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_VersionMajor(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_VersionMajor(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_VersionMinor(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_VersionMinor(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_VersionRelease(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_VersionRelease(const Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Get_HiddenPassword(out Value: WideString): HResult; stdcall;
    function IfrxReportOptions_Set_HiddenPassword(const Value: WideString): HResult; stdcall;
{$ENDIF}
  end;


  TfrxExpressionCache = class(TObject)
  private
    FExpressions: TStringList;
    FMainScript: TfsScript;
    FScript: TfsScript;
    FScriptLanguage: String;
    procedure SetCaseSensitive(const Value: Boolean);
    function GetCaseSensitive: Boolean;
  public
    constructor Create(AScript: TfsScript);
    destructor Destroy; override;
    procedure Clear;
    function Calc(const Expression: String; var ErrorMsg: String;
      AScript: TfsScript): Variant;
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
  end;

  TfrxDataSetItem = class(TCollectionItem)
  private
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  published
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
  end;

  TfrxReportDataSets = class(TCollection)
  private
    FReport: TfrxReport;
    function GetItem(Index: Integer): TfrxDataSetItem;
  public
    constructor Create(AReport: TfrxReport);
    procedure Initialize;
    procedure Finalize;
    procedure Add(ds: TfrxDataSet);
    function Find(ds: TfrxDataSet): TfrxDataSetItem; overload;
    function Find(const Name: String): TfrxDataSetItem; overload;
    procedure Delete(const Name: String); overload;
    property Items[Index: Integer]: TfrxDataSetItem read GetItem; default;
  end;

  TfrxStyleItem = class(TCollectionItem)
  private
    FName: String;
    FColor: TColor;
    FFont: TFont;
    FFrame: TfrxFrame;
    procedure SetFont(const Value: TFont);
    procedure SetFrame(const Value: TfrxFrame);
    procedure SetName(const Value: String);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure CreateUniqueName;
  published
    property Name: String read FName write SetName;
    property Color: TColor read FColor write FColor;
    property Font: TFont read FFont write SetFont;
    property Frame: TfrxFrame read FFrame write SetFrame;
  end;

  TfrxStyles = class(TCollection)
  private
    FName: String;
    FReport: TfrxReport;
    function GetItem(Index: Integer): TfrxStyleItem;
  public
    constructor Create(AReport: TfrxReport);
    function Add: TfrxStyleItem;
    function Find(const Name: String): TfrxStyleItem;
    procedure Apply;
    procedure GetList(List: TStrings);
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXMLItem(Item: TfrxXMLItem; OldXMLFormat: Boolean = True);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToXMLItem(Item: TfrxXMLItem);
    property Items[Index: Integer]: TfrxStyleItem read GetItem; default;
    property Name: String read FName write FName;
  end;

  TfrxStyleSheet = class(TObject)
  private
    FItems: TList;
    function GetItems(Index: Integer): TfrxStyles;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure GetList(List: TStrings);
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);
    function Add: TfrxStyles;
    function Count: Integer;
    function Find(const Name: String): TfrxStyles;
    function IndexOf(const Name: String): Integer;
    property Items[Index: Integer]: TfrxStyles read GetItems; default;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
{$IFDEF FR_COM}
  TfrxReport = class(TfrxComponent, IfrxReport, IfrxBuiltinExports, IfrxBuiltinExportsEx, IConnectionPointContainer)
    FConnectionPoints:      TConnectionPoints;
    FConnectionPoint:       TConnectionPoint;
    FEvent:                 IfrxReportEvents;
  private
    FUseDispatchableEvents: Boolean;
{$ELSE}
  TfrxReport = class(TfrxComponent)
  private
{$ENDIF}
    FCurObject: String;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FDataSets: TfrxReportDatasets;
    FDesigner: TfrxCustomDesigner;
    FDotMatrixReport: Boolean;
    FDrawText: Pointer;
    FDrillState: TStrings;
    FEnabledDataSets: TfrxReportDataSets;
    FEngine: TfrxCustomEngine;
    FEngineOptions: TfrxEngineOptions;
    FErrors: TStrings;
    FExpressionCache: TfrxExpressionCache;
    FFileName: String;
    FIniFile: String;
    FLoadStream: TStream;
    FLocalValue: TfsCustomVariable;
    FSelfValue: TfsCustomVariable;
    FModified: Boolean;
    FOldStyleProgress: Boolean;
    FParentForm: TForm;
    FParentReport: String;
    FParentReportObject: TfrxReport;
    FPreviewPages: TfrxCustomPreviewPages;
    FPreview: TfrxCustomPreview;
    FPreviewForm: TForm;
    FPreviewOptions: TfrxPreviewOptions;
    FPrintOptions: TfrxPrintOptions;
    FProgress: TfrxProgress;
    FReloading: Boolean;
    FReportOptions: TfrxReportOptions;
    FScript: TfsScript;
    FScriptLanguage: String;
    FScriptText: TStrings;
    FFakeScriptText: TStrings; {fake object}
    FShowProgress: Boolean;
    FStoreInDFM: Boolean;
    FStyles: TfrxStyles;
    FSysVariables: TStrings;
    FTerminated: Boolean;
    FTimer: TTimer;
    FVariables: TfrxVariables;
    FVersion: String;
    FXMLSerializer: TObject;
    FStreamLoaded: Boolean;

    FOnAfterPrint: TfrxBeforePrintEvent;
    FOnAfterPrintReport: TNotifyEvent;
    FOnBeforeConnect: TfrxBeforeConnectEvent;
    FOnAfterDisconnect: TfrxAfterDisconnectEvent;
    FOnBeforePrint: TfrxBeforePrintEvent;
    FOnBeginDoc: TNotifyEvent;
    FOnClickObject: TfrxClickObjectEvent;
    FOnDblClickObject: TfrxClickObjectEvent;
    FOnEditConnection: TfrxEditConnectionEvent;
    FOnEndDoc: TNotifyEvent;
    FOnGetValue: TfrxGetValueEvent;
    FOnNewGetValue: TfrxNewGetValueEvent;
    FOnLoadTemplate: TfrxLoadTemplateEvent;
    FOnManualBuild: TfrxManualBuildEvent;
    FOnMouseOverObject: TfrxMouseOverObjectEvent;
    FOnPreview: TNotifyEvent;
    FOnPrintPage: TfrxPrintPageEvent;
    FOnPrintReport: TNotifyEvent;
    FOnProgressStart: TfrxProgressEvent;
    FOnProgress: TfrxProgressEvent;
    FOnProgressStop: TfrxProgressEvent;
    FOnRunDialogs: TfrxRunDialogsEvent;
    FOnSetConnection: TfrxSetConnectionEvent;
    FOnStartReport: TfrxNotifyEvent;
    FOnStopReport: TfrxNotifyEvent;
    FOnUserFunction: TfrxUserFunctionEvent;
    FOnClosePreview: TNotifyEvent;
    FOnReportPrint: TfrxNotifyEvent;
    FOnAfterScriptCompile: TNotifyEvent;

    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function DoGetValue(const Expr: String; var Value: Variant): Boolean;
    function GetScriptValue(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function SetScriptValue(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function DoUserFunction(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function GetDataSetName: String;
    function GetLocalValue: Variant;
    function GetSelfValue: TfrxView;
    function GetPages(Index: Integer): TfrxPage;
    function GetPagesCount: Integer;
    function GetCaseSensitive: Boolean;
    function GetScriptText: TStrings;
    procedure AncestorNotFound(Reader: TReader; const ComponentName: string;
      ComponentClass: TPersistentClass; var Component: TComponent);
    procedure DoClear;
    procedure DoGetAncestor(const Name: String; var Ancestor: TPersistent);
    procedure DoLoadFromStream;
    procedure OnTimer(Sender: TObject);
    procedure ReadDatasets(Reader: TReader);
    procedure ReadStyle(Reader: TReader);
    procedure ReadVariables(Reader: TReader);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    procedure SetEngineOptions(const Value: TfrxEngineOptions);
    procedure SetSelfValue(const Value: TfrxView);
    procedure SetLocalValue(const Value: Variant);
    procedure SetParentReport(const Value: String);
    procedure SetPreviewOptions(const Value: TfrxPreviewOptions);
    procedure SetPrintOptions(const Value: TfrxPrintOptions);
    procedure SetReportOptions(const Value: TfrxReportOptions);
    procedure SetScriptText(const Value: TStrings);
    procedure SetStyles(const Value: TfrxStyles);
    procedure SetTerminated(const Value: Boolean);
    procedure SetCaseSensitive(const Value: Boolean);
    procedure WriteDatasets(Writer: TWriter);
    procedure WriteStyle(Writer: TWriter);
    procedure WriteVariables(Writer: TWriter);
    procedure SetPreview(const Value: TfrxCustomPreview);
    procedure SetVersion(const Value: String);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DefineProperties(Filer: TFiler); override;
{$IFDEF FR_COM}
  public
    procedure EventSinkChanged(const Sink: IUnknown; Connecting: Boolean);

    procedure OnSetConnectionHandler(const ConnString: String);
    function OnEditConnectionHandler(const ConnString: String): String;

    { COM proxy event functions }
    procedure OnAfterPrintHandler(Sender: TfrxReportComponent);
    procedure OnBeforePrintHandler(Sender: TfrxReportComponent);
    procedure OnClickObjectHandler(Sender: TfrxView; Button: TMouseButton; Shift: TShiftState; var Modified: Boolean);
    function  OnUserFunctionHandler(const MethodName: String; var Params: Variant): Variant;
    procedure OnBeforeConnectHandler(Sender: TfrxCustomDatabase; var Connected: Boolean);
    procedure OnBeginDocHandler(Sender: TObject);
    procedure OnEndDocHandler(Sender: TObject);
    procedure OnPrintReportHandler(Sender: TObject);
    procedure OnAfterPrintReportHandler(Sender: TObject);
    procedure OnProgressHandler(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
    procedure OnProgressStartHandler(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
    procedure OnProgressStopHandler(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
    procedure OnRunDialogsEvent(Page: TfrxDialogPage);

    {IfrxReport}
    function LoadReportFromFile(const szFileName: WideString): HResult; stdcall;
    function SaveReportToFile(const FileName: WideString): HResult; stdcall;
    function LoadReportFromStream(const Stream: IUnknown): HResult; stdcall;
    function SaveReportToStream(const Stream: IUnknown): HResult; stdcall;
    function SavePreparedReportToStream(const Stream: IUnknown): HResult; stdcall;
    function LoadPreparedReportFromStream(const Stream: IUnknown): HResult; stdcall;

    function LoadPreparedReportFromFile(const szFileName: WideString): HResult; stdcall;
    function SavePreparedReportToFile(const szFileName: WideString): HResult; stdcall;
    function ClearReport: HResult; stdcall;
    function PrintReport: HResult; stdcall;
    function ExportReport(const Filter: IfrxCustomExportFilter): HResult; stdcall;

    function Get_Errors(out Value: WideString): HResult; stdcall;
    function Get_PreviewPages(out Value: IfrxCustomPreviewPages): HResult; stdcall;
    function Get_ReportOptions(out Value: IfrxReportOptions): HResult; stdcall;
    function Get_PreviewOptions(out Value: IfrxPreviewOptions): HResult; stdcall;
    function Get_EngineOptions(out Value: IfrxEngineOptions): HResult; stdcall;
    function Get_PrintOptions(out Value: IfrxPrintOptions): HResult; stdcall;
    function Get_ScriptLanguage(out Value: WideString): HResult; stdcall;
    function Set_ScriptLanguage(const Value: WideString): HResult; stdcall;
    function Get_ScriptText(out Value: WideString): HResult; stdcall;
    function Set_ScriptText(const Value: WideString): HResult; stdcall;
    function Get_DisableDialogs(out Value: WordBool): HResult; stdcall;
    function Set_DisableDialogs(Value: WordBool): HResult; stdcall;
    function SetVariable(const Index: WideString; Value: OleVariant): HResult; stdcall;
    function GetVariable(const Index: WideString; out Value: OleVariant): HResult; stdcall;
    function AddVariable(const Category: WideString; const Name: WideString; Value: OleVariant): HResult; stdcall;
    function DeleteCategory(const Name: WideString): HResult; stdcall;
    function DeleteVariable(const Name: WideString): HResult; stdcall;
    function SelectDataset(Selected: WordBool; const DataSet: IfrxDataSet): HResult; stdcall;
    function LoadLanguageResourcesFromFile(const FileName: WideString): HResult; stdcall;
    function GetResourceString(const ID: WideString; out ResourceString_: WideString): HResult; stdcall;
    function Set_MainWindowHandle(Value: Integer): HResult; stdcall;
    function Set_ShowProgress(Value: WordBool): HResult; stdcall;
    function CreateReportObject(const ParentObject: IfrxComponent; ObjectType: TGUID;
                                const Name: WideString; out GeneratedObject: IfrxComponent): HResult; stdcall;
    function Get_Resources(out Value: IfrxResources): HResult; stdcall;
    function AddFunction(const FuncName: WideString; const Category: WideString;
                         const Description: WideString): HResult; stdcall;
    function Get_Version(out Value: WideString): HResult; stdcall;
    function BindObject(const Value: IfrxPlugin): HResult; stdcall;
    function Get_Page(Index: Integer; out Value: IfrxPage): HResult; stdcall;
    function Get_PagesCount(out Value: Integer): HResult; stdcall;
    function CreateReportObjectEx(const ParentObject: IfrxComponent; const ObjectType: WideString;
                                  const Name: WideString; out GeneratedObject: IfrxComponent): HResult; stdcall;

    function ClearDatasets: HResult; stdcall;
    function FindCOMObject(const ObjectName: WideString; out Obj: IfrxComponent): HResult; stdcall;
    function FindObjectEx(const ObjectName: WideString; out Obj: IfrxComponent): HResult; stdcall;
    function IfrxReport.FindObject = FindCOMObject;
    function Get_OldStyleProgress(out Value: WordBool): HResult; stdcall;
    function Set_OldStyleProgress(Value: WordBool): HResult; stdcall;
    function Get_Engine(out Value: IfrxCustomEngine): HResult; stdcall;
    function Get_Script(out Value: IfsScript): HResult; stdcall;
    function Get_Print(out Value: WordBool): HResult; stdcall;
    function Set_UseDispatchableEvents(Value: WordBool): HResult; stdcall;
    function Get_FileName(out Value: WideString): HResult; stdcall;
    function Set_FileName(const Value: WideString): HResult; stdcall;
    function Get_ParentReport(out Value: WideString): HResult; stdcall;
    function Set_ParentReport(const Value: WideString): HResult; stdcall;
    function Set_Terminated(Value: WordBool): HResult; stdcall;
    function Get_Exports_(out Value: IfrxBuiltinExports): HResult; stdcall;
    function SetGlobalVariable(const Index: WideString; Value: OleVariant): HResult; stdcall;
    function InheritFromReport(const TemplateName: WideString; InheritMode: frxInheritMode): HResult; stdcall;
    function FindDatabase(const ObjectName: WideString; out Database: IfrxADODatabase): HResult; stdcall;
    function FindQuery(const ObjectName: WideString; out Query: IfrxADOQuery): HResult; stdcall;
    function FindTable(const ObjectName: WideString; out Table: IfrxADOTable): HResult; stdcall;
    function Get_DotMatrixInitString(out Value: WideString): HResult; stdcall;
    function Set_DotMatrixInitString(const Value: WideString): HResult; stdcall;
    function Get_DotMatrixEscModel(out Value: Integer): HResult; stdcall;
    function Set_DotMatrixEscModel(Value: Integer): HResult; stdcall;
    function Get_ExpandDrilldown(out Value:WordBool): HResult; stdcall;
    function Set_ExpandDrilldown(Value: WordBool): HResult; stdcall;
    function Get_ThreadSafe(out Value:WordBool): HResult; stdcall;
    function Set_ThreadSafe(Value: WordBool): HResult; stdcall;
    {IfrxBuiltinExports}
    function ExportToPDF(const FileName: WideString; Compressed: WordBool; EmbeddedFonts: WordBool;
                         PrintOptimized: WordBool; Background: WordBool;
                         const UserPassword: WideString; const OwnerPassword: WideString): HResult; overload; stdcall;
    function ExportToBMP(const FileName: WideString; Resolution: SYSINT; Monochrome, CropPages, SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToHTML(const FileName: WideString; Pictures, FixedWidth, Multipage, Navigator, PicsInSameFolder, Background: WordBool): HResult; overload; stdcall;
    function ExportToRTF(const FileName: WideString; Pictures, PageBreaks, WYSIWYG: WordBool): HResult; overload; stdcall;
    function ExportToTXT(const FileName: WideString; PageBreaks: WordBool; Frames: WordBool;
                         OEMCodepage: WordBool; EmptyLines: WordBool): HResult; overload; stdcall;
    function ExportToXLS(const szFileName: WideString; Pictures, PageBreaks, WYSIWYG, AsText, Background, EmptyLines: WordBool): HResult; overload; stdcall;
    function ExportToXML(const FileName: WideString; Styles, PageBreaks, WYSIWYG, Background, EmptyLines: WordBool): HResult; overload; stdcall;
    function ExportToJPEG(const FileName: WideString; Resolution, JpegQuality: SYSINT; Monochrome, CropPages, SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToTIFF(const FileName: WideString; Resolution: SYSINT; Monochrome, CropPages, SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToCSV(const FileName: WideString; const Separator: WideString; OEMCodepage: WordBool): HResult; overload; stdcall;
    function ExportToGIF(const FileName: WideString; Resolution: SYSINT; Monochrome, CropPages, SeparatePages: WordBool): HResult; overload; stdcall;
    function SendMail(const Server: WideString; Port: SYSINT; const User: WideString;
                      const Password: WideString; const From: WideString; const To_: WideString;
                      const Subject: WideString; const Text: WideString;
                      const FileName: WideString; const AttachName: WideString): HResult; stdcall;
    function ExportToDMP(const FileName: WideString): HResult; overload; stdcall;
    function ExportToOdf(const FileName: WideString; Emf: WordBool; Styles: WordBool;
                         PageBreaks: WordBool; Wysiwyg: WordBool; Background: WordBool;
                         EmptyLines: WordBool; const Language: WideString): HResult; overload; stdcall;
    function ExportToDbf(const FileName: WideString; OEMCodepage: WordBool): HResult; stdcall;
    {IfrxBuiltinExportsEx}
    function ExportToPDF(const Stream: IUnknown; Compressed: WordBool; EmbeddedFonts: WordBool; PrintOptimized: WordBool): HResult; overload; stdcall;
    function ExportToXML(const Stream: IUnknown; Styles: WordBool; PageBreaks: WordBool; WYSIWYG: WordBool; Background: WordBool): HResult; overload; stdcall;
    function ExportToRTF(const Stream: IUnknown; Pictures: WordBool; PageBreaks: WordBool; WYSIWYG: WordBool): HResult; overload; stdcall;
    function ExportToHTML(const Stream: IUnknown; Pictures: WordBool; FixedWidth: WordBool; Multipage: WordBool; Navigator: WordBool; PicsInSameFolder: WordBool; Background: WordBool): HResult; overload; stdcall;
    function ExportToXLS(const Stream: IUnknown; Pictures: WordBool; PageBreaks: WordBool; WYSIWYG: WordBool; AsText: WordBool; Background: WordBool): HResult; overload; stdcall;
    function ExportToBMP(const Stream: IUnknown; Resolution: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToJPEG(const Stream: IUnknown; Resolution: SYSINT; JpegQuality: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToTIFF(const Stream: IUnknown; Resolution: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToTXT(const Stream: IUnknown; PageBreaks: WordBool; Frames: WordBool; OEMCodepage: WordBool; EmptyLines: WordBool): HResult; overload; stdcall;
    function ExportToCSV(const Stream: IUnknown; const Separator: WideString; OEMCodepage: WordBool): HResult; overload; stdcall;
    function ExportToGIF(const Stream: IUnknown; Resolution: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; overload; stdcall;
    function ExportToDMP(const Stream: IUnknown): HResult; overload; stdcall;
    function ExportToODF(const Stream: IUnknown; Emf: WordBool; Styles: WordBool;
                         PageBreaks: WordBool; Wysiwyg: WordBool; Background: WordBool;
                         EmptyLines: WordBool; const Language: WideString): HResult; overload; stdcall;

    {IConnectionPointContainer}
    property ConnectionPoints: TConnectionPoints read FConnectionPoints implements IConnectionPointContainer;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    class function GetDescription: String; override;

    { internal methods }
    function Calc(const Expr: String; AScript: TfsScript = nil): Variant;
    function DesignPreviewPage: Boolean;
    function GetAlias(DataSet: TfrxDataSet): String;
    function GetDataset(const Alias: String): TfrxDataset;
    function GetIniFile: TCustomIniFile;
    function GetApplicationFolder: String;
    function PrepareScript: Boolean;
    function InheritFromTemplate(const templName: String; InheriteMode: TfrxInheriteMode = imDefault): Boolean;
    procedure DesignReport(IDesigner: {$IFDEF FPC}TObject{$ELSE}IUnknown{$ENDIF}; Editor: TObject); overload;
    procedure DoNotifyEvent(Obj: TObject; const EventName: String;
      RunAlways: Boolean = False);
    procedure DoParamEvent(const EventName: String; var Params: Variant;
      RunAlways: Boolean = False);
    procedure DoAfterPrint(c: TfrxReportComponent);
    procedure DoBeforePrint(c: TfrxReportComponent);
    procedure DoPreviewClick(v: TfrxView; Button: TMouseButton;
      Shift: TShiftState; var Modified: Boolean; DblClick: Boolean = False);
    procedure GetDatasetAndField(const ComplexName: String;
      var Dataset: TfrxDataset; var Field: String);
    procedure GetDataSetList(List: TStrings; OnlyDB: Boolean = False);
    procedure GetActiveDataSetList(List: TStrings);
    procedure InternalOnProgressStart(ProgressType: TfrxProgressType); virtual;
    procedure InternalOnProgress(ProgressType: TfrxProgressType; Progress: Integer); virtual;
    procedure InternalOnProgressStop(ProgressType: TfrxProgressType); virtual;
    procedure SelectPrinter;
    procedure SetProgressMessage(const Value: String; Ishint: Boolean = False);
    procedure CheckDataPage;

    { public methods }
    function LoadFromFile(const FileName: String;
      ExceptionIfNotFound: Boolean = False): Boolean;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
      SaveDefaultValues: Boolean = False; UseGetAncestor: Boolean = False); override;
{$IFNDEF FR_COM}
    procedure DesignReport(Modal: Boolean = True; MDIChild: Boolean = False); overload; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    function PrepareReport(ClearLastReport: Boolean = True): Boolean;
    procedure ShowPreparedReport; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    procedure ShowReport(ClearLastReport: Boolean = True); {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    procedure AddFunction(const FuncName: String; const Category: String = '';
      const Description: String = '');
{$ELSE}
    function DesignReport: HResult; overload; stdcall;
    function DesignReportEx(Modal: WordBool; MDIChild: WordBool; ParentWindowHandle: Integer): HResult; stdcall;
    function ShowReport: HResult; stdcall;
    function PrepareReport(ClearLastReport: WordBool = True): HResult; stdcall;
    function ShowPreparedReport: HResult; stdcall;

{$ENDIF}
    procedure DesignReportInPanel(Panel: TWinControl); 
    function Print: Boolean; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    function Export(Filter: TfrxCustomExportFilter): Boolean;

    { internals }
    property CurObject: String read FCurObject write FCurObject;
    property DrillState: TStrings read FDrillState;
    property LocalValue: Variant read GetLocalValue write SetLocalValue;
    property SelfValue: TfrxView read GetSelfValue write SetSelfValue;
    property PreviewForm: TForm read FPreviewForm;
    property XMLSerializer: TObject read FXMLSerializer;
    property Reloading: Boolean read FReloading write FReloading;

    { public }
    property DataSets: TfrxReportDataSets read FDataSets;
    property Designer: TfrxCustomDesigner read FDesigner write FDesigner;
    property EnabledDataSets: TfrxReportDataSets read FEnabledDataSets;
    property Engine: TfrxCustomEngine read FEngine;
    property Errors: TStrings read FErrors;
    property FileName: String read FFileName write FFileName;
    property Modified: Boolean read FModified write FModified;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages;
    property Pages[Index: Integer]: TfrxPage read GetPages;
    property PagesCount: Integer read GetPagesCount;
    property Script: TfsScript read FScript;
    property Styles: TfrxStyles read FStyles write SetStyles;
    property Terminated: Boolean read FTerminated write SetTerminated;
    property Variables: TfrxVariables read FVariables;
    property CaseSensitiveExpressions: Boolean read GetCaseSensitive write SetCaseSensitive;

    property OnEditConnection: TfrxEditConnectionEvent read FOnEditConnection write FOnEditConnection;
    property OnSetConnection: TfrxSetConnectionEvent read FOnSetConnection write FOnSetConnection;
  published
    property Version: String read FVersion write SetVersion;
    property ParentReport: String read FParentReport write SetParentReport;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property DotMatrixReport: Boolean read FDotMatrixReport write FDotMatrixReport;
    property EngineOptions: TfrxEngineOptions read FEngineOptions write SetEngineOptions;
    property IniFile: String read FIniFile write FIniFile;
    property OldStyleProgress: Boolean read FOldStyleProgress write FOldStyleProgress default False;
    property Preview: TfrxCustomPreview read FPreview write SetPreview;
    property PreviewOptions: TfrxPreviewOptions read FPreviewOptions write SetPreviewOptions;
    property PrintOptions: TfrxPrintOptions read FPrintOptions write SetPrintOptions;
    property ReportOptions: TfrxReportOptions read FReportOptions write SetReportOptions;
    property ScriptLanguage: String read FScriptLanguage write FScriptLanguage;
    property ScriptText: TStrings read GetScriptText write SetScriptText;
    property ShowProgress: Boolean read FShowProgress write FShowProgress default True;
    property StoreInDFM: Boolean read FStoreInDFM write FStoreInDFM default True;

    property OnAfterPrint: TfrxBeforePrintEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeforeConnect: TfrxBeforeConnectEvent read FOnBeforeConnect write FOnBeforeConnect;
    property OnAfterDisconnect: TfrxAfterDisconnectEvent read FOnAfterDisconnect write FOnAfterDisconnect;
    property OnBeforePrint: TfrxBeforePrintEvent read FOnBeforePrint write FOnBeforePrint;
    property OnBeginDoc: TNotifyEvent read FOnBeginDoc write FOnBeginDoc;
    property OnClickObject: TfrxClickObjectEvent read FOnClickObject write FOnClickObject;
    property OnDblClickObject: TfrxClickObjectEvent read FOnDblClickObject write FOnDblClickObject;
    property OnEndDoc: TNotifyEvent read FOnEndDoc write FOnEndDoc;
    property OnGetValue: TfrxGetValueEvent read FOnGetValue write FOnGetValue;
    property OnNewGetValue: TfrxNewGetValueEvent read FOnNewGetValue write FOnNewGetValue;
    property OnManualBuild: TfrxManualBuildEvent read FOnManualBuild write FOnManualBuild;
    property OnMouseOverObject: TfrxMouseOverObjectEvent read FOnMouseOverObject
      write FOnMouseOverObject;
    property OnPreview: TNotifyEvent read FOnPreview write FOnPreview;
    property OnPrintPage: TfrxPrintPageEvent read FOnPrintPage write FOnPrintPage;
    property OnPrintReport: TNotifyEvent read FOnPrintReport write FOnPrintReport;
    property OnAfterPrintReport: TNotifyEvent read FOnAfterPrintReport write FOnAfterPrintReport;
    property OnProgressStart: TfrxProgressEvent read FOnProgressStart write FOnProgressStart;
    property OnProgress: TfrxProgressEvent read FOnProgress write FOnProgress;
    property OnProgressStop: TfrxProgressEvent read FOnProgressStop write FOnProgressStop;
    property OnRunDialogs: TfrxRunDialogsEvent read FOnRunDialogs write FOnRunDialogs;
    property OnStartReport: TfrxNotifyEvent read FOnStartReport write FOnStartReport;
    property OnStopReport: TfrxNotifyEvent read FOnStopReport write FOnStopReport;
    property OnUserFunction: TfrxUserFunctionEvent read FOnUserFunction write FOnUserFunction;
    property OnLoadTemplate: TfrxLoadTemplateEvent read FOnLoadTemplate write FOnLoadTemplate;
    property OnClosePreview: TNotifyEvent read FOnClosePreview write FOnClosePreview;
    property OnReportPrint: TfrxNotifyEvent read FOnReportPrint write FOnReportPrint;
    property OnAfterScriptCompile: TNotifyEvent read FOnAfterScriptCompile write FOnAfterScriptCompile;
  end;

  TfrxCustomDesigner = class(TForm)
  private
    FReport: TfrxReport;
    FIsPreviewDesigner: Boolean;
    FMemoFontName: String;
    FMemoFontSize: Integer;
    FUseObjectFont: Boolean;
    FParentForm: TForm;
{$IFDEF FR_COM}
    FIsExpired: Boolean;
{$ENDIF}
  protected
    FModified: Boolean;
    FObjects: TList;
    FPage: TfrxPage;
    FSelectedObjects: TList;
    procedure SetModified(const Value: Boolean); virtual;
    procedure SetPage(const Value: TfrxPage); virtual;
    function GetCode: TStrings; virtual; abstract;
  public
    constructor CreateDesigner(AOwner: TComponent; AReport: TfrxReport;
      APreviewDesigner: Boolean = False);
    destructor Destroy; override;
    function InsertExpression(const Expr: String): String; virtual; abstract;
    procedure Lock; virtual; abstract;
    procedure ReloadPages(Index: Integer); virtual; abstract;
    procedure ReloadReport; virtual; abstract;
    procedure UpdateDataTree; virtual; abstract;
    procedure UpdatePage; virtual; abstract;
    property IsPreviewDesigner: Boolean read FIsPreviewDesigner;
    property Modified: Boolean read FModified write SetModified;
    property Objects: TList read FObjects;
    property Report: TfrxReport read FReport;
    property SelectedObjects: TList read FSelectedObjects;
    property Page: TfrxPage read FPage write SetPage;
    property Code: TStrings read GetCode;
    property UseObjectFont: Boolean read FUseObjectFont write FUseObjectFont;
    property MemoFontName: String read FMemoFontName write FMemoFontName;
    property MemoFontSize: Integer read FMemoFontSize write FMemoFontSize;
    property ParentForm: TForm read FParentForm write FParentForm;
{$IFDEF FR_COM}
    property IsExpired: Boolean read FIsExpired write FIsExpired;
{$ENDIF}
  end;

  TfrxDesignerClass = class of TfrxCustomDesigner;

{$IFDEF FR_COM}
  TfrxCustomExportFilter = class(TComponent, IfrxCustomExportFilter)
{$ELSE}
  TfrxCustomExportFilter = class(TComponent)
{$ENDIF}
  private
    FCurPage: Boolean;
    FExportNotPrintable: Boolean;
    FName: String;
    FNoRegister: Boolean;
    FPageNumbers: String;
    FReport: TfrxReport;
    FShowDialog: Boolean;
    FStream: TStream;
    FUseFileCache: Boolean;
    FDefaultPath: String;
    FSlaveExport: Boolean;
    FShowProgress: Boolean;
    FDefaultExt: String;
    FFilterDesc: String;
    FSuppressPageHeadersFooters: Boolean;
    FTitle: String;
    FOverwritePrompt: Boolean;
    FFIles: TStrings;
    FOnBeginExport: TNotifyEvent;
    FCreationTime: TDateTime;
    FDataOnly: Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNoRegister;
    destructor Destroy; override;
    class function GetDescription: String; virtual;
    function ShowModal: TModalResult; virtual;
    function Start: Boolean; virtual;
    procedure ExportObject(Obj: TfrxComponent); virtual; abstract;
    procedure Finish; virtual;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); virtual;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); virtual;

    property CurPage: Boolean read FCurPage write FCurPage;
    property PageNumbers: String read FPageNumbers write FPageNumbers;
    property Report: TfrxReport read FReport write FReport;
    property Stream: TStream read FStream write FStream;
    property SlaveExport: Boolean read FSlaveExport write FSlaveExport;
    property DefaultExt: String read FDefaultExt write FDefaultExt;
    property FilterDesc: String read FFilterDesc write FFilterDesc;
    property SuppressPageHeadersFooters: Boolean read FSuppressPageHeadersFooters
      write FSuppressPageHeadersFooters;
    property ExportTitle: String read FTitle write FTitle;
    property Files: TStrings read FFiles write FFiles;
  published
    property ShowDialog: Boolean read FShowDialog write FShowDialog default True;
    property FileName: String read FName write FName;
    property ExportNotPrintable: Boolean read FExportNotPrintable write FExportNotPrintable default False;
    property UseFileCache: Boolean read FUseFileCache write FUseFileCache;
    property DefaultPath: String read FDefaultPath write FDefaultPath;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    property OverwritePrompt: Boolean read FOverwritePrompt write FOverwritePrompt;
    property CreationTime: TDateTime read FCreationTime write FCreationTime;
    property DataOnly: Boolean read FDataOnly write FDataOnly;

    property OnBeginExport: TNotifyEvent read FOnBeginExport write FOnBeginExport;
  end;

  TfrxCustomWizard = class(TComponent)
  private
    FDesigner: TfrxCustomDesigner;
    FReport: TfrxReport;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; virtual;
    function Execute: Boolean; virtual; abstract;
    property Designer: TfrxCustomDesigner read FDesigner;
    property Report: TfrxReport read FReport;
  end;

  TfrxWizardClass = class of TfrxCustomWizard;

{$IFDEF FR_COM}
  TfrxCustomEngine = class(TDispatchablePersistent, IfrxCustomEngine)
{$ELSE}
  TfrxCustomEngine = class(TPersistent)
{$ENDIF}
  private
    FCurColumn: Integer;
    FCurVColumn: Integer;
    FCurLine: Integer;
    FCurLineThrough: Integer;
    FCurX: Extended;
    FCurY: Extended;
    FFinalPass: Boolean;
    FNotifyList: TList;
    FPageHeight: Extended;
    FPageWidth: Extended;
    FPreviewPages: TfrxCustomPreviewPages;
    FReport: TfrxReport;
    FRunning: Boolean;
    FStartDate: TDateTime;
    FStartTime: TDateTime;
    FTotalPages: Integer;
    FOnRunDialog: TfrxRunDialogEvent;
    FSecondScriptCall: Boolean;
    function GetDoublePass: Boolean;
  protected
{$IFDEF FR_COM}
    function Get_CurColumn(out Value: Integer): HResult; stdcall;
    function Set_CurColumn(Value: Integer): HResult; stdcall;
    function Get_CurVColumn(out Value: Integer): HResult; stdcall;
    function Set_CurVColumn(Value: Integer): HResult; stdcall;
    function Get_CurX(out Value: Double): HResult; stdcall;
    function Set_CurX(Value: Double): HResult; stdcall;
    function Get_CurY(out Value: Double): HResult; stdcall;
    function Set_CurY(Value: Double): HResult; stdcall;
    function Get_DoublePass(out Value: WordBool): HResult; stdcall;
    function Get_FinalPass(out Value: WordBool): HResult; stdcall;
    function Set_FinalPass(Value: WordBool): HResult; stdcall;
    function Get_PageHeight(out Value: Double): HResult; stdcall;
    function Set_PageHeight(Value: Double): HResult; stdcall;
    function Get_PageWidth(out Value: Double): HResult; stdcall;
    function Set_PageWidth(Value: Double): HResult; stdcall;
    function Get_StartDate(out Value: TDateTime): HResult; stdcall;
    function Set_StartDate(Value: TDateTime): HResult; stdcall;
    function Get_TotalPages(out Value: Integer): HResult; stdcall;
    function Set_TotalPages(Value: Integer): HResult; stdcall;
{$ENDIF}
  protected
    function GetPageHeight: Extended; virtual;
  public
    constructor Create(AReport: TfrxReport); virtual;
    destructor Destroy; override;
    procedure EndPage; virtual; abstract;
    procedure BreakAllKeep; virtual;
    procedure NewColumn; virtual; abstract;
    procedure NewPage; virtual; abstract;
    procedure ShowBand(Band: TfrxBand); overload; virtual; abstract;
    procedure ShowBand(Band: TfrxBandClass); overload; virtual; abstract;
    procedure ShowBandByName(const BandName: String);
    procedure StopReport;
    function HeaderHeight: Extended; virtual; abstract;
    function FooterHeight: Extended; virtual; abstract;
    function FreeSpace: Extended; virtual; abstract;
    function GetAggregateValue(const Name, Expression: String;
      Band: TfrxBand;  Flags: Integer): Variant; virtual; abstract;
    function Run: Boolean; virtual; abstract;

    property CurLine: Integer read FCurLine write FCurLine;
    property CurLineThrough: Integer read FCurLineThrough write FCurLineThrough;
    property NotifyList: TList read FNotifyList;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages;
    property Report: TfrxReport read FReport;
    property Running: Boolean read FRunning write FRunning;
    property OnRunDialog: TfrxRunDialogEvent read FOnRunDialog write FOnRunDialog;
  published
    property CurColumn: Integer read FCurColumn write FCurColumn;
    property CurVColumn: Integer read FCurVColumn write FCurVColumn;
    property CurX: Extended read FCurX write FCurX;
    property CurY: Extended read FCurY write FCurY;
    property DoublePass: Boolean read GetDoublePass;
    property FinalPass: Boolean read FFinalPass write FFinalPass;
    property PageHeight: Extended read GetPageHeight write FPageHeight;
    property PageWidth: Extended read FPageWidth write FPageWidth;
    property StartDate: TDateTime read FStartDate write FStartDate;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property TotalPages: Integer read FTotalPages write FTotalPages;
    property SecondScriptCall: Boolean read FSecondScriptCall write FSecondScriptCall;
  end;

  TfrxCustomOutline = class(TPersistent)
  private
    FCurItem: TfrxXMLItem;
    FPreviewPages: TfrxCustomPreviewPages;
  protected
    function GetCount: Integer; virtual; abstract;
  public
    constructor Create(APreviewPages: TfrxCustomPreviewPages); virtual;
    procedure AddItem(const Text: String; Top: Integer); virtual; abstract;
    procedure LevelDown(Index: Integer); virtual; abstract;
    procedure LevelRoot; virtual; abstract;
    procedure LevelUp; virtual; abstract;
    procedure GetItem(Index: Integer; var Text: String;
      var Page, Top: Integer); virtual; abstract;
    procedure ShiftItems(From: TfrxXMLItem; NewTop: Integer); virtual; abstract;
    function Engine: TfrxCustomEngine;
    function GetCurPosition: TfrxXMLItem; virtual; abstract;
    property Count: Integer read GetCount;
    property CurItem: TfrxXMLItem read FCurItem write FCurItem;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages;
  end;

{$IFDEF FR_COM}
  TfrxCustomPreviewPages = class(TAutoObject, IfrxCustomPreviewPages)
{$ELSE}
  TfrxCustomPreviewPages = class(TObject)
{$ENDIF}
  private
    FAddPageAction: TfrxAddPageAction; { used in the cross-tab renderer }
    FCurPage: Integer;
    FCurPreviewPage: Integer;
    FEngine: TfrxCustomEngine;
    FFirstPage: Integer;               {  used in the composite reports }
    FOutline: TfrxCustomOutline;
    FReport: TfrxReport;
  protected
    function GetCount: Integer; virtual; abstract;
    function GetPage(Index: Integer): TfrxReportPage; virtual; abstract;
    function GetPageSize(Index: Integer): TPoint; virtual; abstract;
{$IFDEF FR_COM}
    function IfrxCustomPreviewPages_AddObject(const Value: IfrxComponent): HResult; stdcall;
    function IfrxCustomPreviewPages_AddPage(const Value: IfrxReportPage): HResult; stdcall;
    function IfrxCustomPreviewPages_AddEmptyPage(Index: Integer): HResult; stdcall;
    function IfrxCustomPreviewPages_DeletePage(Index: Integer): HResult; stdcall;
    function IfrxCustomPreviewPages_Page(Index: Integer; out Value: IfrxReportPage): HResult; stdcall;
    function IfrxCustomPreviewPages.AddObject = IfrxCustomPreviewPages_AddObject;
    function IfrxCustomPreviewPages.AddPage = IfrxCustomPreviewPages_AddPage;
    function IfrxCustomPreviewPages.AddEmptyPage = IfrxCustomPreviewPages_AddEmptyPage;
    function IfrxCustomPreviewPages.DeletePage = IfrxCustomPreviewPages_DeletePage;
    function IfrxCustomPreviewPages.Page = IfrxCustomPreviewPages_Page;

    function Get_Count(out Value: Integer): HResult; stdcall;
    function Get_CurrentPage(out Value: Integer): HResult; stdcall;
    function Set_CurrentPage(Value: Integer): HResult; stdcall;
    function Get_CurPreviewPage(out Value: Integer): HResult; stdcall;
    function Set_CurPreviewPage(Value: Integer): HResult; stdcall;
    function PageModify(PageNo: Integer; const Page: IfrxReportPage): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AReport: TfrxReport); virtual;
    destructor Destroy; override;
    procedure Clear; virtual; abstract;
{$IFNDEF FR_COM}
    procedure Initialize; virtual; abstract;
{$ENDIF}

    procedure AddObject(Obj: TfrxComponent); virtual; abstract;
    procedure AddPage(Page: TfrxReportPage); virtual; abstract;
    procedure AddSourcePage(Page: TfrxReportPage); virtual; abstract;
    procedure AddToSourcePage(Obj: TfrxComponent); virtual; abstract;
    procedure BeginPass; virtual; abstract;
    procedure ClearFirstPassPages; virtual; abstract;
    procedure CutObjects(APosition: Integer); virtual; abstract;
    procedure Finish; virtual; abstract;
    procedure IncLogicalPageNumber; virtual; abstract;
    procedure ResetLogicalPageNumber; virtual; abstract;
    procedure PasteObjects(X, Y: Extended); virtual; abstract;
    procedure ShiftAnchors(From, NewTop: Integer); virtual; abstract;
    procedure AddPicture(Picture: TfrxPictureView); virtual; abstract;
    function BandExists(Band: TfrxBand): Boolean; virtual; abstract;
    function GetCurPosition: Integer; virtual; abstract;
    function GetAnchorCurPosition: Integer; virtual; abstract;
    function GetLastY(ColumnPosition: Extended = 0): Extended; virtual; abstract;
    function GetLogicalPageNo: Integer; virtual; abstract;
    function GetLogicalTotalPages: Integer; virtual; abstract;

    procedure AddEmptyPage(Index: Integer); virtual; abstract;
    procedure DeletePage(Index: Integer); virtual; abstract;
    procedure ModifyPage(Index: Integer; Page: TfrxReportPage); virtual; abstract;
    procedure DrawPage(Index: Integer; Canvas: TCanvas; ScaleX, ScaleY,
      OffsetX, OffsetY: Extended); virtual; abstract;
    procedure ObjectOver(Index: Integer; X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; Scale, OffsetX, OffsetY: Extended;
      Click: Boolean; var Cursor: TCursor; DBClick: Boolean = False); virtual; abstract;
    procedure AddFrom(Report: TfrxReport); virtual; abstract;

    procedure LoadFromStream(Stream: TStream;
      AllowPartialLoading: Boolean = False); virtual; abstract;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
    function LoadFromFile(const FileName: String;
      ExceptionIfNotFound: Boolean = False): Boolean; virtual; abstract;
    procedure SaveToFile(const FileName: String); virtual; abstract;
    function Print: Boolean; virtual; abstract;
    function Export(Filter: TfrxCustomExportFilter): Boolean; virtual; abstract;

    property AddPageAction: TfrxAddPageAction read FAddPageAction write FAddPageAction;
    property Count: Integer read GetCount;
    property CurPage: Integer read FCurPage write FCurPage;
    property CurPreviewPage: Integer read FCurPreviewPage write FCurPreviewPage;
    property Engine: TfrxCustomEngine read FEngine;
    property FirstPage: Integer read FFirstPage write FFirstPage;
    property Outline: TfrxCustomOutline read FOutline;
    property Page[Index: Integer]: TfrxReportPage read GetPage;
    property PageSize[Index: Integer]: TPoint read GetPageSize;
    property Report: TfrxReport read FReport;
  end;

  TfrxCustomPreview = class(TCustomControl)
  private
    FPreviewPages: TfrxCustomPreviewPages;
    FReport: TfrxReport;
    FUseReportHints: Boolean;
  public
    procedure Init; virtual; abstract;
    procedure Lock; virtual; abstract;
    procedure Unlock; virtual; abstract;
    procedure RefreshReport; virtual; abstract;
    procedure InternalOnProgressStart(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); virtual; abstract;
    procedure InternalOnProgress(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); virtual; abstract;
    procedure InternalOnProgressStop(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); virtual; abstract;

    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages write FPreviewPages;
    property Report: TfrxReport read FReport write FReport;
    property UseReportHints: Boolean read FUseReportHints write FUseReportHints;
  end;

  TfrxCompressorClass = class of TfrxCustomCompressor;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
{$IFDEF FR_COM}
  TfrxCustomCompressor = class(TComponent, IfrxCustomCompressor)
{$ELSE}
  TfrxCustomCompressor = class(TComponent)
{$ENDIF}
  private
    FIsFR3File: Boolean;
    FOldCompressor: TfrxCompressorClass;
    FReport: TfrxReport;
    FStream: TStream;
    FTempFile: String;
{$IFDEF FR_COM}
  protected
    function CompressStream(const InputStream: IUnknown; const OutputStream: IUnknown;
                            Compression_: Integer; const FileName: WideString): HResult; stdcall;
    function DecompressStream(const Stream: IUnknown): HResult; stdcall;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Decompress(Source: TStream): Boolean; virtual; abstract;
    procedure Compress(Dest: TStream); virtual; abstract;
    procedure CreateStream;
    property IsFR3File: Boolean read FIsFR3File write FIsFR3File;
    property Report: TfrxReport read FReport write FReport;
    property Stream: TStream read FStream write FStream;
  end;

  TfrxCrypterClass = class of TfrxCustomCrypter;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxCustomCrypter = class(TComponent)
  private
    FStream: TStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Decrypt(Source: TStream; const Key: AnsiString): Boolean; virtual; abstract;
    procedure Crypt(Dest: TStream; const Key: AnsiString); virtual; abstract;
    procedure CreateStream;
    property Stream: TStream read FStream write FStream;
  end;

  TfrxLoadEvent = function(Sender: TfrxReport; Stream: TStream): Boolean of object;
  TfrxGetScriptValueEvent = function(var Params: Variant): Variant of object;

  TfrxFR2Events = class(TObject)
  private
    FOnGetValue: TfrxGetValueEvent;
    FOnPrepareScript: TNotifyEvent;
    FOnLoad: TfrxLoadEvent;
    FOnGetScriptValue: TfrxGetScriptValueEvent;
    FFilter: String;
  public
    property OnGetValue: TfrxGetValueEvent read FOnGetValue write FOnGetValue;
    property OnPrepareScript: TNotifyEvent read FOnPrepareScript write FOnPrepareScript;
    property OnLoad: TfrxLoadEvent read FOnLoad write FOnLoad;
    property OnGetScriptValue: TfrxGetScriptValueEvent read FOnGetScriptValue write FOnGetScriptValue;
    property Filter: String read FFilter write FFilter;
  end;

  TfrxGlobalDataSetList = class(TList)
{$IFNDEF NO_CRITICAL_SECTION}
    FCriticalSection: TCriticalSection;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure Unlock;
  end;


function frxParentForm: TForm;
function frxFindDataSet(DataSet: TfrxDataSet; const Name: String;
  Owner: TComponent): TfrxDataSet;
procedure frxGetDataSetList(List: TStrings);

var
  frxDesignerClass: TfrxDesignerClass;
  frxDotMatrixExport: TfrxCustomExportFilter;
  frxCompressorClass: TfrxCompressorClass;
  frxCrypterClass: TfrxCrypterClass;
  frxCharset: Integer = DEFAULT_CHARSET;
  frxFR2Events: TfrxFR2Events;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS: TCriticalSection;
{$IFDEF FR_COM}
  frxADOCS: TCriticalSection;// ADO connection critical section
{$ENDIF}
{$ENDIF}
  frxGlobalVariables: TfrxVariables;
{$IFDEF FR_COM}
  rptcf: TComponentFactory;
  frxADO_RefCount: Integer;// ref count for def. connection
{$ENDIF}
const
  FR_VERSION = {$I frxVersion.inc};
  BND_COUNT = 18;
  frxBands: array[0..BND_COUNT - 1] of TfrxComponentClass =
    (TfrxReportTitle, TfrxReportSummary, TfrxPageHeader, TfrxPageFooter,
     TfrxHeader, TfrxFooter, TfrxMasterData, TfrxDetailData, TfrxSubdetailData,
     TfrxDataBand4, TfrxDataBand5, TfrxDataBand6, TfrxGroupHeader, TfrxGroupFooter,
     TfrxChild, TfrxColumnHeader, TfrxColumnFooter, TfrxOverlay);

{$IFDEF FPC}
  procedure Register;
{$ENDIF}

implementation

{$R *.res}
{$IFDEF FR_COM}
{$R frxDesgnIcon.res}
{$ENDIF}

uses
  {$IFNDEF FPC}Registry,{$ENDIF}
  frxEngine, frxPreviewPages, frxPreview, frxPrinter, frxUtils,
  frxPassw, frxGraphicUtils, frxDialogForm, frxXMLSerializer,
  {$IFNDEF FPC}frxAggregate,{$ENDIF}
  frxRes, frxDsgnIntf, frxrcClass, frxClassRTTI, frxInheritError, TypInfo,
  {$IFNDEF FS_SKIP_LANG_REG}fs_ipascal, fs_icpp, fs_ibasic, fs_ijs,{$ENDIF} fs_iclassesrtti,
  fs_igraphicsrtti, fs_iformsrtti, fs_idialogsrtti, fs_iinirtti, frxDMPClass,
  SysConst
{$IFDEF DELPHI12}
  , StrUtils
{$ENDIF}
{$IFNDEF FPC}
{$IFDEF JPEG}
, jpeg
{$ENDIF}
{$IFDEF PNG}
{$IFDEF Delphi12}
, pngimage
{$ELSE}
, frxpngimage
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$IFDEF FR_COM}
,
  {$IFNDEF FR_LITE}
  frxExportPDF,
  frxExportXML,
  frxExportXLS,
  frxExportHTML,
  frxDMPExport,
  frxExportImage,
  frxExportRTF,
  frxExportMail,
  frxCross,
  frxBarcode,
  frxRich,
  frxChart,
  frxDCtrl,
  frxOLE,
  frxGradient,
  frxExportBIFF,
  frxExportDBF,
  {$ENDIF}
  frxExportODF,
  frxExportText,
  frxExportCSV,
  frxChBox,
{$IFNDEF NODESIGNER}
  frxDesgn,
{$ENDIF}
  frxADOComponents,
  frxDBXComponents,
  frxBDEComponents,
  ADODB,
  frxGZIP,
  frxCrypt,
  frxNetDataTable
{$IFDEF FR_FIB}
 , frxFIBComponents
{$ENDIF}
{$IFDEF ACTIVATION}
  , ActivationReminder
  , ActivationForm
{$ENDIF}
{$ENDIF};

var
  FParentForm: TForm;
  DatasetList: TfrxGlobalDataSetList;
{$IFDEF FR_COM}
  frxADOComponent:      TfrxADOComponents = nil;
  frxDefaultConnection: TADOConnection = nil;
{$IFDEF FIBPLUS}
// Samuray
  frxFIBComponent:     TfrxFIBComponents = nil;
  frxDefaultFIBConnection: TfrxFIBDatabase = nil;
{$ENDIF}
  frxGZipCompressor:    TfrxGZipCompressor = nil;
  frxCrypt:             TfrxCrypt = nil;

{$IFNDEF EXT_EXPORTS}
  {$IFNDEF FR_LITE}
    Export2PDF:         TfrxPDFExport;
    Export2BMP:         TfrxBMPExport;
    Export2HTML:        TfrxHTMLExport;
    Export2RTF:         TfrxRTFExport;
    Export2XLS:         TfrxXLSExport;
    Export2XML:         TfrxXMLExport;
    Export2JPEG:        TfrxJPEGExport;
    Export2TIFF:        TfrxTIFFExport;
    Export2Mail:        TfrxMailExport;
    Export2Gif:         TfrxGifExport;
    Export2DMP:         TfrxDotMatrixExport;
    Export2BIFF:        TfrxBIFFExport;
  {$ENDIF}
  Export2ODS:         TfrxODSExport;
  Export2ODT:         TfrxODTExport;
  Export2CSV:         TfrxCSVExport;
  Export2TXT:         TfrxSimpleTextExport;
  Export2DBF:         TfrxDBFExport;
{$ENDIF}
  DispatchableComponentFactory: TComponentFactory;
  DatabaseComponentFactory:     TComponentFactory;
  ExportComponentFactory:       TComponentFactory;
  QueryComponentFactory:        TComponentFactory;
  TableComponentFactory:        TComponentFactory;
{$ENDIF}

const
  DefFontName = 'Arial';
  DefFontSize = 10;

type
  TByteSet = set of 0..7;
  PByteSet = ^TByteSet;

  THackControl = class(TControl);
  THackWinControl = class(TWinControl);
  THackPersistent = class(TPersistent);
  THackThread = class(TThread);
{$IFDEF PNG}
{$IFDEF Delphi12}
  TPNGObject = class(TPngImage);
{$ENDIF}
{$ENDIF}

  TParentForm = class(TForm)
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

procedure TParentForm.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_CREATEHANDLE:
      TWinControl(Message.WParam).HandleNeeded;
    WM_DESTROYHANDLE:
      THackWinControl(Message.WParam).DestroyHandle;
  else
    inherited;
  end;
end;

{$IFDEF FR_COM}
procedure CreateDefaultConnections;
begin
  frxADOCS.Enter;
  if not Assigned(frxDefaultConnection) then
  begin
    frxDefaultConnection := TADOConnection.Create(nil);
    frxDefaultConnection.Name := 'DefaultConnection';
    frxDefaultConnection.LoginPrompt := False;
    frxADOComponent.DefaultDatabase := frxDefaultConnection;
  end;
  Inc(frxADO_RefCount);
  frxADOCS.Leave;
{$IFDEF FIBPLUS}
/// Samuray
  if not Assigned(frxDefaultFIBConnection) then
  begin
    frxDefaultFIBConnection := TfrxFIBDatabase.Create(nil);
    frxDefaultFIBConnection.Database.Name := 'DefaultConnection';
    frxDefaultFIBConnection.LoginPrompt := False;
  end;
{$ENDIF}
/// Samuray
{$IFDEF FIBPLUS}
  if not Assigned(frxFIBComponent) then
  begin
    frxFIBComponent := TfrxFIBComponents.Create(nil);
    frxFIBComponent.DefaultDatabase := frxDefaultFIBConnection.Database;
  end;
{$ENDIF}
end;
{$ENDIF}

function Round8(e: Extended): Extended;
begin
  Result := Round(e * 100000000) / 100000000;
end;

function frxParentForm: TForm;
begin
  if FParentForm = nil then
  begin
    FParentForm := TParentForm.CreateNew(nil{$IFDEF FPC}, 1{$ENDIF});
    if not ModuleIsLib or ModuleIsPackage then // Access denied AV inside multithreaded (COM) environment
      FParentForm.HandleNeeded;
  end;
  Result := FParentForm;
end;

function frxFindDataSet(DataSet: TfrxDataSet; const Name: String;
  Owner: TComponent): TfrxDataSet;
var
  i: Integer;
  ds: TfrxDataSet;
begin
  Result := DataSet;
  if Name = '' then
  begin
    Result := nil;
    Exit;
  end;
  if Owner = nil then Exit;
  DatasetList.Lock;
  for i := 0 to DatasetList.Count - 1 do
  begin
    ds := DatasetList[i];
    if AnsiCompareText(ds.UserName, Name) = 0 then
      if not ((Owner is TfrxReport) and (ds.Owner is TfrxReport) and
        (ds.Owner <> Owner)) then
      begin
        Result := DatasetList[i];
        break;
      end;
  end;
  DatasetList.Unlock;
end;

procedure frxGetDataSetList(List: TStrings);
var
  i: Integer;
  ds: TfrxDataSet;
begin
  DatasetList.Lock;
  List.Clear;
  for i := 0 to DatasetList.Count - 1 do
  begin
    ds := DatasetList[i];
    if (ds <> nil) and (ds.UserName <> '') and ds.Enabled then
      List.AddObject(ds.UserName, ds);
  end;  
  DatasetList.Unlock;
end;

procedure EmptyParentForm;
begin
  while FParentForm.ControlCount > 0 do
    FParentForm.Controls[0].Parent := nil;
end;


function FloatDiff(const Val1, Val2: Extended): Boolean;
begin
  Result := Abs(Val1 - Val2) > 1e-4;
end;

function ShiftToByte(Value: TShiftState): Byte;
begin
  Result := Byte(PByteSet(@Value)^);
end;


{ TfrxDataset }

constructor TfrxDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := True;
  FOpenDataSource := True;
  FRangeBegin := rbFirst;
  FRangeEnd := reLast;
  DatasetList.Lock;
  DatasetList.Add(Self);
  DatasetList.Unlock;
end;

destructor TfrxDataSet.Destroy;
begin
  DatasetList.Lock;
  DatasetList.Remove(Self);
  inherited;
  DatasetList.Unlock;
end;

procedure TfrxDataSet.SetName(const NewName: TComponentName);
begin
  inherited;
  if NewName <> '' then
    if (FUserName = '') or (FUserName = Name) then
      UserName := NewName
end;

procedure TfrxDataSet.SetUserName(const Value: String);
begin
  if Trim(Value) = '' then
    raise Exception.Create(frxResources.Get('prInvProp'));
  FUserName := Value;
end;

procedure TfrxDataSet.Initialize;
begin
end;

procedure TfrxDataSet.Finalize;
begin
end;

procedure TfrxDataSet.Close;
begin
  if Assigned(FOnClose) then FOnClose(Self);
end;

procedure TfrxDataSet.Open;
begin
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TfrxDataSet.First;
begin
  FRecNo := 0;
  FEof := False;
  if Assigned(FOnFirst) then
    FOnFirst(Self);
end;

procedure TfrxDataSet.Next;
begin
  FEof := False;
  Inc(FRecNo);
  if not ((FRangeEnd = reCount) and (FRecNo >= FRangeEndCount)) then
  begin
    if Assigned(FOnNext) then
      FOnNext(Self);
  end
  else
  begin
    FRecNo := FRangeEndCount - 1;
    FEof := True;
  end;
end;

procedure TfrxDataSet.Prior;
begin
  Dec(FRecNo);
  if Assigned(FOnPrior) then
    FOnPrior(Self);
end;

function TfrxDataSet.Eof: Boolean;
begin
  Result := False;
  if FRangeEnd = reCount then
    if (FRecNo >= FRangeEndCount) or FEof then
      Result := True;
  if Assigned(FOnCheckEOF) then
    FOnCheckEOF(Self, Result);
end;

function TfrxDataSet.GetDisplayText(Index: String): WideString;
begin
  Result := '';
end;

function TfrxDataSet.GetDisplayWidth(Index: String): Integer;
begin
  Result := 10;
end;

procedure TfrxDataSet.GetFieldList(List: TStrings);
begin
  List.Clear;
end;

function TfrxDataSet.GetValue(Index: String): Variant;
begin
  Result := Null;
end;

function TfrxDataSet.HasField(const fName: String): Boolean;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  GetFieldList(sl);
  Result := sl.IndexOf(fName) <> -1;
  sl.Free;
end;

procedure TfrxDataSet.AssignBlobTo(const fName: String; Obj: TObject);
begin
// empty method
end;

function TfrxDataSet.IsBlobField(const fName: String): Boolean;
begin
  Result := False;
end;

function TfrxDataSet.FieldsCount: Integer;
begin
  Result := 0;
end;

function TfrxDataSet.GetFieldType(Index: String): TfrxFieldType;
begin
  Result := fftNumeric;
end;

function TfrxDataSet.RecordCount: Integer;
begin
  if (RangeBegin = rbFirst) and (RangeEnd = reCount) then
    Result := RangeEndCount
  else
    Result := 0;
end;

{$IFDEF FR_COM}
function TfrxDataSet.Get_UserName(out Value: WideString): HResult; stdcall;
begin
  Value := UserName;
  Result := S_OK;
end;

function TfrxDataSet.Set_UserName(const Value: WideString): HResult; stdcall;
begin
  UserName := Value;
  Result := S_OK;
end;

function TfrxDataSet.Get_RangeBegin(out Value: frxRangeBegin): HResult; stdcall;
begin
  Value := frxRangeBegin(RangeBegin);
  Result := S_OK;
end;

function TfrxDataSet.Set_RangeBegin(Value: frxRangeBegin): HResult; stdcall;
begin
  RangeBegin := TfrxRangeBegin(Value);
  Result := S_OK;
end;

function TfrxDataSet.Get_RangeEndCount(out Value: Integer): HResult; stdcall;
begin
  Value := RangeEndCount;
  Result := S_OK;
end;

function TfrxDataSet.Set_RangeEndCount(Value: Integer): HResult; stdcall;
begin
  RangeEndCount := Value;
  Result := S_OK;
end;

function TfrxDataSet.Get_RangeEnd(out Value: frxRangeEnd): HResult; stdcall;
begin
  Value := frxRangeEnd(RangeEnd);
  Result := S_OK;
end;

function TfrxDataSet.Set_RangeEnd(Value: frxRangeEnd): HResult; stdcall;
begin
  RangeEnd := TfrxRangeEnd(Value);
  Result := S_OK;
end;

function TfrxDataSet.Get_FieldsCount(out Value: Integer): HResult; stdcall;
begin
  Value := FieldsCount;
  Result := S_OK;
end;

function TfrxDataSet.Get_RecordsCount(out Value: Integer): HResult; stdcall;
begin
  value := RecordCount;
  Result := S_OK;
end;

function TfrxDataSet.ValueOfField(const FieldName: WideString; out Value: OleVariant): HResult; stdcall;
begin
  Value := Self.Value[FieldName];
  Result := S_OK;
end;

function TfrxDataSet.Get_CurrentRecordNo(out Value: Integer): HResult; stdcall;
begin
  Value := RecNo;
  Result := S_OK;
end;

function TfrxDataSet.GoFirst: HResult; stdcall;
begin
  First;
  Result := S_OK;
end;

function TfrxDataSet.GoNext: HResult; stdcall;
begin
  Next;
  Result := S_OK;
end;

function TfrxDataSet.GoPrior: HResult; stdcall;
begin
  Prior;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxUserDataSet }

constructor TfrxUserDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FFields := TStringList.Create;
{$IFDEF FR_COM}
  FEvent := nil;
  OnGetValue := COM_OnGetValueHandler;
  OnFirst := COM_OnFirstHandler;
  OnNext := COM_OnNextHandler;
  OnPrior := COM_OnPrevHandler;
  OnCheckEOF := COM_OnCheckEOFHandler;
  FConnectionPoints := TConnectionPoints.Create(Self);
  FConnectionPoints.CreateConnectionPoint( IfrxUserDataSetEvents, ckSingle, EventSinkChanged );
  FConnectionPoint := FConnectionPoints.CreateConnectionPoint(IfrxUserDataSetEventDispatcher, ckMulti, nil);
{$ENDIF}
end;

destructor TfrxUserDataSet.Destroy;
begin
{$IFDEF FR_COM}
  FConnectionPoint.Free;
  FConnectionPoints.Free;
{$ENDIF}
  FFields.Free;
  inherited;
end;

procedure TfrxUserDataSet.SetFields(const Value: TStrings);
begin
  FFields.Assign(Value);
end;

procedure TfrxUserDataSet.GetFieldList(List: TStrings);
begin
  List.Assign(FFields);
end;

function TfrxUserDataSet.FieldsCount: Integer;
begin
  Result := FFields.Count;
end;

function TfrxUserDataSet.GetDisplayText(Index: String): WideString;
var
  v: Variant;
begin
  Result := '';
  if Assigned(FOnGetValue) then
  begin
    v := Null;
    FOnGetValue(Index, v);
    Result := VarToWideStr(v);
  end;

  if Assigned(FOnNewGetValue) then
  begin
    v := Null;
    FOnNewGetValue(Self, Index, v);
    Result := VarToWideStr(v);
  end;
end;

function TfrxUserDataSet.GetValue(Index: String): Variant;
begin
  Result := Null;
  if Assigned(FOnGetValue) then
    FOnGetValue(Index, Result);
  if Assigned(FOnNewGetValue) then
    FOnNewGetValue(Self, Index, Result);
end;

{$IFDEF FR_COM}
procedure TfrxUserDataSet.EventSinkChanged(const Sink: IUnknown; Connecting: Boolean);
begin
  if Connecting then FEvent := Sink as IfrxUserDataSetEvents else FEvent := nil;
end;

function TfrxUserDataSet.IfrxUserDataSet_Get_Fields(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(String(Fields.GetText));
  Result := 0;
end;

function TfrxUserDataSet.IfrxUserDataSet_Set_Fields(const Value: WideString): HResult; stdcall;
begin
  Fields.SetText( PChar(Value) );
  Result := 0;
end;

function TfrxUserDataSet.IfrxUserDataSet_Get_Name(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(String(UserName));
  Result := 0;
end;

function TfrxUserDataSet.IfrxUserDataSet_Set_Name(const Value: WideString): HResult; stdcall;
begin
  UserName := ( PChar(Value) );
  Result := 0;
end;

procedure TfrxUserDataSet.COM_OnGetValueHandler(const VarName: String; var Value: Variant);
var
  OleVal : OleVariant;
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  if FEvent <> nil then
  begin
    FEvent.OnGetValue( OleVariant(VarName), OleVal);
    Value := OleVal;
  end
  else
  begin
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxUserDataSetEventDispatcher).OnGetValue(OleVariant(VarName), OleVal);
      ConnectData.pUnk := nil;
      if not VarIsEmpty(OleVal) then
      begin
        Value := OleVal;
        Break;
      end;
    end;
  end;
end;

procedure TfrxUserDataSet.COM_OnCheckEOFHandler(Sender: TObject; var EOF: Boolean);
var
  e : WordBool;
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  e := True;

  if FEvent <> nil then
  begin
    FEvent.OnCheckEOF(e);
    EOF := Boolean(e);
  end
  else
  begin
    EOF := False;
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxUserDataSetEventDispatcher).OnCheckEOF(e);
      ConnectData.pUnk := nil;
      EOF := EOF or Boolean(e);
    end;
  end;
end;

procedure TfrxUserDataSet.COM_OnFirstHandler(Sender: TObject);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  if FEvent <> nil then FEvent.OnFirst else
  begin
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxUserDataSetEventDispatcher).OnFirst;
      ConnectData.pUnk := nil;
    end;
  end;
end;

procedure TfrxUserDataSet.COM_OnNextHandler(Sender: TObject);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  if FEvent <> nil then FEvent.OnNext else
  begin
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxUserDataSetEventDispatcher).OnNext;
      ConnectData.pUnk := nil;
    end;
  end;
end;

procedure TfrxUserDataSet.COM_OnPrevHandler(Sender: TObject);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  if FEvent <> nil then FEvent.OnPrior else
  begin
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxUserDataSetEventDispatcher).OnPrior;
      ConnectData.pUnk := nil;
    end;
  end;
end;

{$ENDIF}

{ TfrxCustomDBDataSet }

constructor TfrxCustomDBDataset.Create(AOwner: TComponent);
begin
  FFields := TStringList.Create;
  FFields.Sorted := True;
  FFields.Duplicates := dupIgnore;
  FAliases := TStringList.Create;
  inherited;
end;

destructor TfrxCustomDBDataset.Destroy;
begin
  FFields.Free;
  FAliases.Free;
  inherited;
end;

procedure TfrxCustomDBDataset.SetFieldAliases(const Value: TStrings);
begin
  FAliases.Assign(Value);
end;

function TfrxCustomDBDataset.ConvertAlias(const fName: String): String;
var
  i: Integer;
  s: String;
begin
  Result := fName;
  for i := 0 to FAliases.Count - 1 do
  begin
    s := FAliases[i];
    if AnsiCompareText(Copy(s, Pos('=', s) + 1, MaxInt), fName) = 0 then
    begin
      Result := FAliases.Names[i];
      break;
    end;
  end;
end;

function TfrxCustomDBDataset.GetAlias(const fName: String): String;
var
  i: Integer;
begin
  Result := fName;
  for i := 0 to FAliases.Count - 1 do
    if AnsiCompareText(FAliases.Names[i], fName) = 0 then
    begin
      Result := FAliases[i];
      Result := Copy(Result, Pos('=', Result) + 1, MaxInt);
      break;
    end;
end;

function TfrxCustomDBDataset.FieldsCount: Integer;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    GetFieldList(sl);
  finally
    Result := sl.Count;
    sl.Free;
  end;
end;

{ TfrxDBComponents }

function TfrxDBComponents.GetDescription: String;
begin
  Result := '';
end;

{ TfrxCustomDatabase }

procedure TfrxCustomDatabase.BeforeConnect(var Value: Boolean);
begin
  if (Report <> nil) and Assigned(Report.OnBeforeConnect) then
    Report.OnBeforeConnect(Self, Value);
end;

procedure TfrxCustomDatabase.AfterDisconnect;
begin
  if (Report <> nil) and Assigned(Report.OnAfterDisconnect) then
    Report.OnAfterDisconnect(Self);
end;

function TfrxCustomDatabase.GetConnected: Boolean;
begin
  Result := False;
end;

function TfrxCustomDatabase.GetDatabaseName: String;
begin
  Result := '';
end;

function TfrxCustomDatabase.GetLoginPrompt: Boolean;
begin
  Result := False;
end;

function TfrxCustomDatabase.GetParams: TStrings;
begin
  Result := nil;
end;

procedure TfrxCustomDatabase.SetConnected(Value: Boolean);
begin
// empty
end;

procedure TfrxCustomDatabase.SetDatabaseName(const Value: String);
begin
// empty
end;

procedure TfrxCustomDatabase.FromString(const Connection: WideString);
begin
// empty
end;

function TfrxCustomDatabase.ToString: WideString;
begin
// empty
  Result := '';
end;


procedure TfrxCustomDatabase.SetLogin(const Login, Password: String);
begin
// empty
end;

procedure TfrxCustomDatabase.SetLoginPrompt(Value: Boolean);
begin
// empty
end;

procedure TfrxCustomDatabase.SetParams(Value: TStrings);
begin
// empty
end;


{ TfrxComponent }

constructor TfrxComponent.Create(AOwner: TComponent);
begin
  if AOwner is TfrxComponent then
    inherited Create(TfrxComponent(AOwner).Report)
  else
    inherited Create(AOwner);

  FComponentStyle := [csPreviewVisible];
  FBaseName := ClassName;
  Delete(FBaseName, Pos('Tfrx', FBaseName), 4);
  Delete(FBaseName, Pos('View', FBaseName), 4);
  FObjects := TList.Create;
  FAllObjects := TList.Create;

{$IFNDEF FR_COM}
  FFont := TFont.Create;
{$ELSE}
  FFont := TfrxFont.Create;
{$ENDIF}
  with FFont do
  begin
    PixelsPerInch := 96;
    Name := DefFontName;
    Size := DefFontSize;
    Color := clBlack;
    Charset := frxCharset;
    OnChange := FontChanged;
  end;

  FVisible := True;
  ParentFont := True;
  if AOwner is TfrxComponent then
    SetParent(TfrxComponent(AOwner));
end;

constructor TfrxComponent.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  FIsDesigning := True;
  Create(AOwner);
end;

destructor TfrxComponent.Destroy;
begin
  SetParent(nil);
  Clear;
  FFont.Free;
  FObjects.Free;
  FAllObjects.Free;
  inherited;
end;

procedure TfrxComponent.Assign(Source: TPersistent);
var
  s: TMemoryStream;
begin
  if Source is TfrxComponent then
  begin
    s := TMemoryStream.Create;
    try
      TfrxComponent(Source).SaveToStream(s, False, True);
      s.Position := 0;
      LoadFromStream(s);
    finally
      s.Free;
    end;
  end;
end;

procedure TfrxComponent.AssignAll(Source: TfrxComponent; Streaming: Boolean = False);
var
  s: TMemoryStream;
begin
  s := TMemoryStream.Create;
  try
    Source.SaveToStream(s, True, True, Streaming);
    s.Position := 0;
    LoadFromStream(s);
  finally
    s.Free;
  end;
end;

procedure TfrxComponent.LoadFromStream(Stream: TStream);
var
  Reader: TfrxXMLSerializer;
begin
  Clear;
  Reader := TfrxXMLSerializer.Create(Stream);
  if Report <> nil then
    Report.FXMLSerializer := Reader;

  try
    Reader.Owner := Report;
    if (Report <> nil) and Report.EngineOptions.EnableThreadSafe then
    begin
{$IFNDEF NO_CRITICAL_SECTION}
      frxCS.Enter;
{$ENDIF}
      try
        Reader.ReadRootComponent(Self, nil);
      finally
{$IFNDEF NO_CRITICAL_SECTION}
        frxCS.Leave;
{$ENDIF}
      end;
    end
    else
      Reader.ReadRootComponent(Self, nil);

    if Report <> nil then
      Report.Errors.AddStrings(Reader.Errors);

  finally
    Reader.Free;
    if Report <> nil then
      Report.FXMLSerializer := nil;
  end;
end;

procedure TfrxComponent.SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
  SaveDefaultValues: Boolean = False; Streaming: Boolean = False);
var
  Writer: TfrxXMLSerializer;
begin
  Writer := TfrxXMLSerializer.Create(Stream);

  try
    Writer.Owner := Report;
    Writer.SerializeDefaultValues := SaveDefaultValues;
    if Self is TfrxReport then
      Writer.OnGetAncestor := Report.DoGetAncestor;
    Writer.WriteRootComponent(Self, SaveChildren, nil, Streaming);
  finally
    Writer.Free;
  end;
end;

procedure TfrxComponent.Clear;
var
  i: Integer;
  c: TfrxComponent;
begin
  i := 0;
  while i < FObjects.Count do
  begin
    c := FObjects[i];
    if (csAncestor in c.ComponentState) then
    begin
      c.Clear;
      Inc(i);
    end
    else
      c.Free;
  end;
end;

procedure TfrxComponent.SetParent(AParent: TfrxComponent);
begin
  if FParent <> AParent then
  begin
    if FParent <> nil then
      FParent.FObjects.Remove(Self);
    if AParent <> nil then
      AParent.FObjects.Add(Self);
  end;

  FParent := AParent;
  if FParent <> nil then
    SetParentFont(FParentFont);
end;

procedure TfrxComponent.SetBounds(ALeft, ATop, AWidth, AHeight: Extended);
begin
  Left := ALeft;
  Top := ATop;
  Width := AWidth;
  Height := AHeight;
end;

function TfrxComponent.GetPage: TfrxPage;
var
  p: TfrxComponent;
begin
  if Self is TfrxPage then
  begin
    Result := TfrxPage(Self);
    Exit;
  end;

  Result := nil;
  p := Parent;
  while p <> nil do
  begin
    if p is TfrxPage then
    begin
      Result := TfrxPage(p);
      Exit;
    end;
    p := p.Parent;
  end;
end;

function TfrxComponent.GetReport: TfrxReport;
var
  p: TfrxComponent;
begin
  if Self is TfrxReport then
  begin
    Result := TfrxReport(Self);
    Exit;
  end;

  Result := nil;
  p := Parent;
  while p <> nil do
  begin
    if p is TfrxReport then
    begin
      Result := TfrxReport(p);
      Exit;
    end;
    p := p.Parent;
  end;
end;

function TfrxComponent.GetIsLoading: Boolean;
begin
  Result := FIsLoading or (csLoading in ComponentState);
end;

function TfrxComponent.GetAbsTop: Extended;
begin
  if (Parent <> nil) and not (Parent is TfrxDialogPage) then
    Result := Parent.AbsTop + Top else
    Result := Top;
end;

function TfrxComponent.GetAbsLeft: Extended;
begin
  if (Parent <> nil) and not (Parent is TfrxDialogPage) then
    Result := Parent.AbsLeft + Left else
    Result := Left;
end;

procedure TfrxComponent.SetLeft(Value: Extended);
begin
  if not IsDesigning or not (rfDontMove in FRestrictions) then
    FLeft := Value;
end;

procedure TfrxComponent.SetTop(Value: Extended);
begin
  if not IsDesigning or not (rfDontMove in FRestrictions) then
    FTop := Value;
end;

procedure TfrxComponent.SetWidth(Value: Extended);
begin
  if not IsDesigning or not (rfDontSize in FRestrictions) then
    FWidth := Value;
end;

procedure TfrxComponent.SetHeight(Value: Extended);
begin
  if not IsDesigning or not (rfDontSize in FRestrictions) then
    FHeight := Value;
end;

function TfrxComponent.IsFontStored: Boolean;
begin
  Result := not FParentFont;
end;

procedure TfrxComponent.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  FParentFont := False;
end;

procedure TfrxComponent.SetParentFont(const Value: Boolean);
begin
  if Value then
    if Parent <> nil then
      Font := Parent.Font;
  FParentFont := Value;
end;

procedure TfrxComponent.SetVisible(Value: Boolean);
begin
  FVisible := Value;
end;

procedure TfrxComponent.FontChanged(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
begin
  FParentFont := False;
  for i := 0 to FObjects.Count - 1 do
  begin
    c := FObjects[i];
    if c.ParentFont then
      c.ParentFont := True;
  end;
end;

function TfrxComponent.GetAllObjects: TList;

  procedure EnumObjects(c: TfrxComponent);
  var
    i: Integer;
  begin
    if c <> Self then
      FAllObjects.Add(c);
    for i := 0 to c.FObjects.Count - 1 do
      EnumObjects(c.FObjects[i]);
  end;

begin
  FAllObjects.Clear;
  EnumObjects(Self);
  Result := FAllObjects;
end;

procedure TfrxComponent.SetName(const AName: TComponentName);
var
  c: TfrxComponent;
begin
  if CompareText(AName, Name) = 0 then Exit;

  if (AName <> '') and (Report <> nil) then
  begin
    c := Report.FindObject(AName);
    if (c <> nil) and (c <> Self) then
      raise EDuplicateName.Create(frxResources.Get('prDupl'));
    if IsAncestor then
      raise Exception.CreateFmt(frxResources.Get('clCantRen'), [Name])
  end;
  inherited;
end;

procedure TfrxComponent.CreateUniqueName;
var
  i: Integer;
  l: TList;
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;

  if Report <> nil then
    l := Report.AllObjects else
    l := Parent.AllObjects;
  for i := 0 to l.Count - 1 do
    sl.Add(TfrxComponent(l[i]).Name);

  i := 1;
  while sl.IndexOf(String(FBaseName) + IntToStr(i)) <> -1 do
    Inc(i);

  Name := String(FBaseName) + IntToStr(i);
  sl.Free;
end;

function TfrxComponent.Diff(AComponent: TfrxComponent): String;
begin
  Result := InternalDiff(AComponent);
end;

function TfrxComponent.DiffFont(f1, f2: TFont; const Add: String): String;
var
  fs: Integer;
begin
  Result := '';

  if f1.Name <> f2.Name then
    Result := Result + Add + 'Font.Name="' + frxStrToXML(f1.Name) + '"';
  if f1.Size <> f2.Size then
    Result := Result + Add + 'Font.Size="' + IntToStr(f1.Size) + '"';
  if f1.Color <> f2.Color then
    Result := Result + Add + 'Font.Color="' + IntToStr(f1.Color) + '"';
  if f1.Style <> f2.Style then
  begin
    fs := 0;
    if fsBold in f1.Style then fs := 1;
    if fsItalic in f1.Style then fs := fs or 2;
    if fsUnderline in f1.Style then fs := fs or 4;
    if fsStrikeout in f1.Style then fs := fs or 8;
    Result := Result + Add + 'Font.Style="' + IntToStr(fs) + '"';
  end;
  if f1.Charset <> f2.Charset then
    Result := Result + Add + 'Font.Charset="' + IntToStr(f1.Charset) + '"';
end;

function TfrxComponent.InternalDiff(AComponent: TfrxComponent): String;
begin
  Result := '';

  if FloatDiff(FLeft, AComponent.FLeft) then
    Result := Result + ' l="' + FloatToStr(FLeft) + '"';
  if (Self is TfrxBand) or FloatDiff(FTop, AComponent.FTop) then
    Result := Result + ' t="' + FloatToStr(FTop) + '"';
  if not ((Self is TfrxCustomMemoView) and TfrxCustomMemoView(Self).FAutoWidth) then
    if FloatDiff(FWidth, AComponent.FWidth) then
      Result := Result + ' w="' + FloatToStr(FWidth) + '"';
  if FloatDiff(FHeight, AComponent.FHeight) then
    Result := Result + ' h="' + FloatToStr(FHeight) + '"';
  if FVisible <> AComponent.FVisible then
    Result := Result + ' Visible="' + frxValueToXML(FVisible) + '"';
  if not FParentFont then
    Result := Result + DiffFont(FFont, AComponent.FFont, ' ');
  if FParentFont <> AComponent.FParentFont then
    Result := Result + ' ParentFont="' + frxValueToXML(FParentFont) + '"';
  if Tag <> AComponent.Tag then
    Result := Result + ' Tag="' + IntToStr(Tag) + '"';
end;

function TfrxComponent.AllDiff(AComponent: TfrxComponent): String;
var
  s: TStringStream;
  Writer: TfrxXMLSerializer;
  i: Integer;
begin
{$IFDEF Delphi12}
  s := TStringStream.Create('', TEncoding.UTF8);
{$ELSE}
  s := TStringStream.Create('');
{$ENDIF}
  Writer := TfrxXMLSerializer.Create(s);
  Writer.Owner := Report;
  Writer.WriteComponent(Self);
  Writer.Free;

  Result := s.DataString;
  i := Pos(' ', Result);
  if i <> 0 then
  begin
    Delete(Result, 1, i);
    Delete(Result, Length(Result) - 1, 2);
  end
  else
    Result := '';
  if AComponent <> nil then
    Result := Result + ' ' + InternalDiff(AComponent);
  { cross bands and Keep mechanism fix }
  if (Self is TfrxNullBand) then
  begin
    Result := Result + ' l="' + FloatToStr(FLeft) + '"';
    Result := Result + ' t="' + FloatToStr(FTop) + '"';
  end;

  s.Free;
end;

procedure TfrxComponent.AddSourceObjects;
begin
// do nothing
end;
procedure TfrxComponent.AlignChildren;
var
  i: Integer;
  c: TfrxComponent;
  sl: TStringList;

  procedure DoAlign(v: TfrxView; n, dir: Integer);
  var
    i: Integer;
    c, c0: TfrxComponent;
  begin
    c0 := nil;
    i := n;
    while (i >= 0) and (i < sl.Count) do
    begin
      c := TfrxComponent(sl.Objects[i]);
      if c <> v then
        if (c.AbsTop < v.AbsTop + v.Height - 1e-4) and
          (v.AbsTop < c.AbsTop + c.Height - 1e-4) then
        begin
          { special case for baWidth }
          if (v.Align = baWidth) and
            (((dir = 1) and (c.Left > v.Left)) or
            ((dir = -1) and (c.Left + c.Width < v.Left + v.Width))) then
          begin
            Dec(i, dir);
            continue;
          end;
          c0 := c;
          break;
        end;
      Dec(i, dir);
    end;

    if (dir = 1) and (v.Align in [baLeft, baWidth]) then
      if c0 = nil then
        v.Left := 0 else
        v.Left := c0.Left + c0.Width;

    if v.Align = baRight then
      if c0 = nil then
        v.Left := Width - v.Width else
        v.Left := c0.Left - v.Width;

    if (dir = -1) and (v.Align = baWidth) then
      if c0 = nil then
        v.Width := Width - v.Left else
        v.Width := c0.Left - v.Left;
  end;

begin
  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupAccept;

  for i := 0 to FObjects.Count - 1 do
  begin
    c := FObjects[i];
    if c is TfrxView then
      if c.Left >= 0 then
        sl.AddObject('1' + Format('%9.2f', [c.Left]), c)
      else
        sl.AddObject('0' + Format('%9.2f', [-c.Left]), c);
  end;

  { process baLeft }

  for i := 0 to sl.Count - 1 do
  begin
    c := TfrxComponent(sl.Objects[i]);
    if c is TfrxView then
      if TfrxView(c).Align in [baLeft, baWidth] then
        DoAlign(TfrxView(c), i, 1);
  end;

  { process baRight }

  for i := sl.Count - 1 downto 0 do
  begin
    c := TfrxComponent(sl.Objects[i]);
    if c is TfrxView then
      if TfrxView(c).Align in [baRight, baWidth] then
        DoAlign(TfrxView(c), i, -1);
  end;

  { process others }

  for i := 0 to FObjects.Count - 1 do
  begin
    c := FObjects[i];
    if c is TfrxView then
      case TfrxView(c).Align of
        baCenter:
          c.Left := (Width - c.Width) / 2;

        baBottom:
          c.Top := Height - c.Height;

        baClient:
          begin
            c.Left := 0;
            c.Top := 0;
            c.Width := Width;
            c.Height := Height;
          end;
      end;
  end;

  sl.Free;
end;

function TfrxComponent.FindObject(const AName: String): TfrxComponent;
var
  i: Integer;
  l: TList;
begin
  Result := nil;
  l := AllObjects;
  for i := 0 to l.Count - 1 do
    if CompareText(AName, TfrxComponent(l[i]).Name) = 0 then
    begin
      Result := l[i];
      break;
    end;
end;

class function TfrxComponent.GetDescription: String;
begin
  Result := ClassName;
end;

function TfrxComponent.GetChildOwner: TComponent;
begin
  Result := Self;
end;

procedure TfrxComponent.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  if (Self is TfrxReport) and not TfrxReport(Self).StoreInDFM then
    Exit;
  for i := 0 to FObjects.Count - 1 do
    Proc(FObjects[i]);
end;

procedure TfrxComponent.BeforeStartReport;
begin
// do nothing
end;

procedure TfrxComponent.OnNotify(Sender: TObject);
begin
// do nothing
end;

procedure TfrxComponent.OnPaste;
begin
//
end;

function TfrxComponent.GetIsAncestor: Boolean;
begin
  Result := (csAncestor in ComponentState) or FAncestor;
end;

function TfrxComponent.FindDataSet(DataSet: TfrxDataSet; const DSName: String): TfrxDataSet;
var
  DSItem:TfrxDataSetItem;
  AReport: TfrxReport;
begin
  Result := nil;
  if Self is TfrxReport then
    AReport := TfrxReport(Self)
  else AReport := Report;
  if (AReport <> nil) and not AReport.EngineOptions.UseGlobalDataSetList then
  begin
    DSItem := AReport.EnabledDataSets.Find(DSName);
    if DSItem <> nil then Result := DSItem.FDataSet;
  end
  else
    Result := frxFindDataSet(DataSet, DSName, AReport);
end;

function TfrxComponent.GetContainerObjects: TList;
begin
  Result := FObjects;
end;

function TfrxComponent.ContainerAdd(Obj: TfrxComponent): Boolean;
begin
  Result := False;
end;

function TfrxComponent.ContainerMouseDown(Sender: TObject; X, Y: Integer): Boolean;
begin
  Result := False;
end;

procedure TfrxComponent.ContainerMouseMove(Sender: TObject; X, Y: Integer);
begin
end;

procedure TfrxComponent.ContainerMouseUp(Sender: TObject; X, Y: Integer);
begin
end;

{$IFDEF FR_COM}
function TfrxComponent.GetFont: TFont;
begin
  Result := FFont;
end;

{ IfrxComponent support }
function TfrxComponent.IfrxComponent_Get_Description: WideString; safecall;
begin
  Result := WideString(GetDescription);
end;

function TfrxComponent.IfrxComponent_Get_ObjectsCount: SYSINT; safecall;
begin
  Result := FObjects.Count;
end;

function TfrxComponent.IfrxComponent_GetObject(Index: Integer): IfrxComponent; safecall;
begin
  if (Index >= 0) and (Index < FObjects.Count) then
  begin
    Result := TfrxComponent(FObjects[Index]);
  end
  else
    Result := nil;
end;

function TfrxComponent.IfrxComponent_Get_BaseName: WideString; safecall;
begin
  Result := BaseName;
end;

function TfrxComponent.IfrxComponent_Get_AliasName: WideString; safecall;
begin
  Result := FAliasName;
end;

function TfrxComponent.IfrxComponent_Get_Name: WideString; safecall;
begin
  Result := Name;
end;

function TfrxComponent.IfrxComponent_Get_Left: Double; safecall;
begin
  Result := Left;
end;

procedure TfrxComponent.IfrxComponent_Set_Left(Value: Double); safecall;
begin
  Left := Value;
end;

function TfrxComponent.IfrxComponent_Get_Top: Double; safecall;
begin
  Result := Top;
end;

procedure TfrxComponent.IfrxComponent_Set_Top(Value: Double); safecall;
begin
  Top := Value;
end;

function TfrxComponent.IfrxComponent_Get_Width: Double; safecall;
begin
  Result := Width;
end;

procedure TfrxComponent.IfrxComponent_Set_Width(Value: Double); safecall;
begin
  Width := Value;
end;

function TfrxComponent.IfrxComponent_Get_Height: Double; safecall;
begin
  Result := Height;
end;

procedure TfrxComponent.IfrxComponent_Set_Height(Value: Double); safecall;
begin
  Height := Value;
end;

function TfrxComponent.IfrxComponent_FindObject(const ObjectName: WideString): IfrxComponent; safecall;
var
  i:        Integer;
  TempStr:  WideString;
begin
  Result := nil;
  TempStr := ObjectName;
  for i := 0 to length(ObjectName) - 1 do
    if ObjectName[i] = ' ' then TempStr[i] := '_';

  Result := FindObject(TempStr);
end;

function TfrxComponent.Get_Restrictions: frxRestrictions; safecall;
begin
  Result := PInteger( @Restrictions )^;
end;

procedure TfrxComponent.Set_Restrictions(Value: frxRestrictions); safecall;
type
  PfrxRestrictions = ^ TfrxRestrictions;
var
  dst: TfrxRestrictions;
  src:  Integer;
begin
  src := Value;
  dst := PfrxRestrictions(@src)^;
  Restrictions := dst;
end;

function TfrxComponent.Get_Visible: WordBool; safecall;
begin
  Result := Visible;
end;

procedure TfrxComponent.Set_Visible(Value: WordBool); safecall;
begin
  Visible := Value;
end;
{$ENDIF}


{ TfrxReportComponent }

constructor TfrxReportComponent.Create(AOwner: TComponent);
begin
  inherited;
  FShiftChildren := TList.Create;
end;

destructor TfrxReportComponent.Destroy;
begin
  FShiftChildren.Free;
  inherited;
end;

procedure TfrxReportComponent.GetData;
begin
// do nothing
end;

procedure TfrxReportComponent.BeforePrint;
begin
  FOriginalRect := frxRect(Left, Top, Width, Height);
end;

procedure TfrxReportComponent.AfterPrint;
begin
  with FOriginalRect do
    SetBounds(Left, Top, Right, Bottom);
end;

function TfrxReportComponent.GetComponentText: String;
begin
  Result := '';
end;

function TfrxReportComponent.GetRealBounds: TfrxRect;
begin
  Result := frxRect(AbsLeft, AbsTop, AbsLeft + Width, AbsTop + Height);
end;


{ TfrxDialogComponent }

constructor TfrxDialogComponent.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csPreviewVisible];
  Width := 28;
  Height := 28;
end;

destructor TfrxDialogComponent.Destroy;
begin
  if FComponent <> nil then
    FComponent.Free;
  FComponent := nil;
  inherited;
end;

procedure TfrxDialogComponent.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('pLeft', ReadLeft, WriteLeft, Report <> nil);
  Filer.DefineProperty('pTop', ReadTop, WriteTop, Report <> nil);
end;

procedure TfrxDialogComponent.ReadLeft(Reader: TReader);
begin
  Left := Reader.ReadInteger;
end;

procedure TfrxDialogComponent.ReadTop(Reader: TReader);
begin
  Top := Reader.ReadInteger;
end;

procedure TfrxDialogComponent.WriteLeft(Writer: TWriter);
begin
  Writer.WriteInteger(Round(Left));
end;

procedure TfrxDialogComponent.WriteTop(Writer: TWriter);
begin
  Writer.WriteInteger(Round(Top));
end;

procedure TfrxDialogComponent.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  r: TRect;
  i, w, ImageIndex: Integer;
  Item: TfrxObjectItem;
begin
  Width := 28;
  Height := 28;
  r := Rect(Round(Left), Round(Top), Round(Left + 28), Round(Top + 28));
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(r);
  DrawEdge(Canvas.Handle, r, EDGE_RAISED, BF_RECT);

  ImageIndex := -1;
  for i := 0 to frxObjects.Count - 1 do
  begin
    Item := frxObjects[i];
    if Item.ClassRef = ClassType then
    begin
      ImageIndex := Item.ButtonImageIndex;
      break;
    end;
  end;

  if ImageIndex <> -1 then
    frxResources.ObjectImages.Draw(Canvas, r.Left + 6, r.Top + 6, ImageIndex);

  Canvas.Font.Name := 'Tahoma';
  Canvas.Font.Size := 8;
  Canvas.Font.Color := clBlack;
  Canvas.Font.Style := [];
  w := Canvas.TextWidth(Name);
  Canvas.Brush.Color := clWindow;
  Canvas.TextOut(r.Left - (w - 28) div 2, r.Bottom + 4, Name);
end;


{ TfrxDialogControl }

constructor TfrxDialogControl.Create(AOwner: TComponent);
begin
  inherited;
  FBaseName := ClassName;
  Delete(FBaseName, Pos('Tfrx', FBaseName), 4);
  Delete(FBaseName, Pos('Control', FBaseName), 7);
end;

destructor TfrxDialogControl.Destroy;
begin
  inherited;
  if FControl <> nil then
    FControl.Free;
  FControl := nil;
end;

procedure TfrxDialogControl.InitControl(AControl: TControl);
begin
  FControl := AControl;
  with THackControl(FControl) do
  begin
    OnClick := DoOnClick;
    OnDblClick := DoOnDblClick;
    OnMouseDown := DoOnMouseDown;
    OnMouseMove := DoOnMouseMove;
    OnMouseUp := DoOnMouseUp;
  end;
  if FControl is TWinControl then
    with THackWinControl(FControl) do
    begin
      OnEnter := DoOnEnter;
      OnExit := DoOnExit;
      OnKeyDown := DoOnKeyDown;
      OnKeyPress := DoOnKeyPress;
      OnKeyUp := DoOnKeyUp;
    end;
  SetParent(Parent);
end;

procedure TfrxDialogControl.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  Bmp: TBitmap;
  MemDC: HDC;
  OldBitmap: HBITMAP;
begin
  Bmp := TBitmap.Create;
  Bmp.Width := Round(Width);
  Bmp.Height := Round(Height);
  Bmp.Canvas.Brush.Color := clBtnFace;
  Bmp.Canvas.FillRect(Rect(0, 0, Round(Width) + 1, Round(Height) + 1));

  Canvas.Lock;
  try
    {$IFDEF NONWINFPC}
    //some widgetsets like qt and carbon does not like such constructs
    //so we simple draw everyting onto Bmp.Canvas
    if FControl is TWinControl then
      TWinControl(FControl).PaintTo(Bmp.Canvas.Handle, 0, 0)
    else
    begin
      FControl.Perform(WM_ERASEBKGND, Bmp.Canvas.Handle, MakeLParam(Round(Left), Round(Top)));
      FControl.Perform(WM_PAINT, Bmp.Canvas.Handle, MakeLParam(Round(Left), Round(Top)));
    end;
    {$ELSE}

    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, Bmp.Handle);
    if FControl is TWinControl then
      TWinControl(FControl).PaintTo(MemDC, 0, 0)
    else
    begin
      FControl.Perform(WM_ERASEBKGND, MemDC, 0);
      FControl.Perform(WM_PAINT, MemDC, 0);
    end;
    SelectObject(MemDC, OldBitmap);
    DeleteDC(MemDC);
    {$ENDIF}
  finally
    Canvas.Unlock;
  end;

  Canvas.Draw(Round(AbsLeft), Round(AbsTop), Bmp);
  Bmp.Free;
end;

function TfrxDialogControl.GetCaption: String;
begin
  Result := THackControl(FControl).Caption;
end;

function TfrxDialogControl.GetColor: TColor;
begin
  Result := THackControl(FControl).Color;
end;

function TfrxDialogControl.GetEnabled: Boolean;
begin
  Result := FControl.Enabled;
end;

procedure TfrxDialogControl.SetLeft(Value: Extended);
begin
  inherited;
  FControl.Left := Round(Left);
end;

procedure TfrxDialogControl.SetTop(Value: Extended);
begin
  inherited;
  FControl.Top := Round(Top);
end;

procedure TfrxDialogControl.SetWidth(Value: Extended);
begin
  inherited;
  FControl.Width := Round(Width);
end;

procedure TfrxDialogControl.SetHeight(Value: Extended);
begin
  inherited;
  FControl.Height := Round(Height);
end;

procedure TfrxDialogControl.SetVisible(Value: Boolean);
begin
  inherited;
  FControl.Visible := Visible;
end;

procedure TfrxDialogControl.SetCaption(const Value: String);
begin
  THackControl(FControl).Caption := Value;
end;

procedure TfrxDialogControl.SetColor(const Value: TColor);
begin
  THackControl(FControl).Color := Value;
end;

procedure TfrxDialogControl.SetEnabled(const Value: Boolean);
begin
  FControl.Enabled := Value;
end;

function TfrxDialogControl.GetHint: String;
begin
  Result := FControl.Hint;
end;

procedure TfrxDialogControl.SetHint(const Value: String);
begin
  FControl.Hint := Value;
end;

function TfrxDialogControl.GetShowHint: Boolean;
begin
  Result := FControl.ShowHint;
end;

procedure TfrxDialogControl.SetShowHint(const Value: Boolean);
begin
  FControl.ShowHint := Value;
end;

function TfrxDialogControl.GetTabStop: Boolean;
begin
  Result := True;
  if FControl is TWinControl then
    Result := THackWinControl(FControl).TabStop;
end;

procedure TfrxDialogControl.SetTabStop(const Value: Boolean);
begin
  if FControl is TWinControl then
    THackWinControl(FControl).TabStop := Value;
end;

procedure TfrxDialogControl.FontChanged(Sender: TObject);
begin
  inherited;
  if FControl <> nil then
    THackControl(FControl).Font.Assign(Font);
end;

procedure TfrxDialogControl.SetParentFont(const Value: Boolean);
begin
  inherited;
  if FControl <> nil then
    THackControl(FControl).ParentFont := Value;
end;

procedure TfrxDialogControl.SetParent(AParent: TfrxComponent);
begin
  inherited;
  if FControl <> nil then
    if AParent is TfrxDialogControl then
      FControl.Parent := TWinControl(TfrxDialogControl(AParent).Control)
    else if AParent is TfrxDialogPage then
      FControl.Parent := TfrxDialogPage(AParent).DialogForm
    else
      FControl.Parent := frxParentForm;
end;

procedure TfrxDialogControl.SetName(const AName: TComponentName);
var
  ChangeText: Boolean;
begin
  ChangeText := (csSetCaption in FControl.ControlStyle) and (Name = Caption) and
    not IsLoading;
  inherited SetName(AName);
  if ChangeText then
    Caption := AName;
end;

procedure TfrxDialogControl.DoOnClick(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnClick, True);
end;

procedure TfrxDialogControl.DoOnDblClick(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnDblClick, True);
end;

procedure TfrxDialogControl.DoOnEnter(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnEnter, True);
end;

procedure TfrxDialogControl.DoOnExit(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnExit, True);
end;

procedure TfrxDialogControl.DoOnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Key, ShiftToByte(Shift)]);
  if (Report <> nil) and (FOnKeyDown <> '') then
  begin
    Report.DoParamEvent(FOnKeyDown, v, True);
    Key := v[1];
  end;
end;

procedure TfrxDialogControl.DoOnKeyPress(Sender: TObject; var Key: Char);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Key]);
  if (Report <> nil) and (FOnKeyPress <> '') then
  begin
    Report.DoParamEvent(FOnKeyPress, v, True);
    if VarToStr(v[1]) <> '' then
      Key := VarToStr(v[1])[1]
    else
      Key := Chr(0);
  end;
end;

procedure TfrxDialogControl.DoOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Key, ShiftToByte(Shift)]);
  if (Report <> nil) and (FOnKeyUp <> '') then
  begin
    Report.DoParamEvent(FOnKeyUp, v, True);
    Key := v[1];
  end;
end;

procedure TfrxDialogControl.DoOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Button, ShiftToByte(Shift), X, Y]);
  if Report <> nil then
    Report.DoParamEvent(FOnMouseDown, v, True);
end;

procedure TfrxDialogControl.DoOnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  v: Variant;
begin
  if (Report <> nil) and (Hint <> '') and ShowHint then
  begin
    Report.SetProgressMessage(GetLongHint(Self.Hint), True);
  end;
  v := VarArrayOf([frxInteger(Self), ShiftToByte(Shift), X, Y]);
  if Report <> nil then
    Report.DoParamEvent(FOnMouseMove, v, True);
end;

procedure TfrxDialogControl.DoOnMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Button, ShiftToByte(Shift), X, Y]);
  if Report <> nil then
    Report.DoParamEvent(FOnMouseUp, v, True);
end;


{ TfrxFrameLine }

constructor TfrxFrameLine.Create(AFrame: TfrxFrame);
begin
  FColor := clBlack;
  FStyle := fsSolid;
  FWidth := 1;
  FFrame := AFrame;
end;

procedure TfrxFrameLine.Assign(Source: TPersistent);
begin
  if Source is TfrxFrameLine then
  begin
    FColor := TfrxFrameLine(Source).Color;
    FStyle := TfrxFrameLine(Source).Style;
    FWidth := TfrxFrameLine(Source).Width;
  end;
end;

function TfrxFrameLine.IsColorStored: Boolean;
begin
  Result := FColor <> FFrame.Color;
end;

function TfrxFrameLine.IsStyleStored: Boolean;
begin
  Result := FStyle <> FFrame.Style;
end;

function TfrxFrameLine.IsWidthStored: Boolean;
begin
  Result := FWidth <> FFrame.Width;
end;

function TfrxFrameLine.Diff(ALine: TfrxFrameLine; const LineName: String;
  ColorChanged, StyleChanged, WidthChanged: Boolean): String;
begin
  Result := '';

  if (ColorChanged and IsColorStored) or (not ColorChanged and (FColor <> ALine.Color)) then
    Result := Result + ' ' + LineName + '.Color="' + IntToStr(FColor) + '"';
  if (StyleChanged and IsStyleStored) or (not StyleChanged and (FStyle <> ALine.Style)) then
    Result := Result + ' ' + LineName + '.Style="' + frxValueToXML(FStyle) + '"';
  if (WidthChanged and IsWidthStored) or (not WidthChanged and FloatDiff(FWidth, ALine.Width)) then
    Result := Result + ' ' + LineName + '.Width="' + FloatToStr(FWidth) + '"';
end;


{ TfrxFrame }

constructor TfrxFrame.Create;
begin
  FColor := clBlack;
  FShadowColor := clBlack;
  FShadowWidth := 4;
  FStyle := fsSolid;
  FTyp := [];
  FWidth := 1;

  FLeftLine := TfrxFrameLine.Create(Self);
  FTopLine := TfrxFrameLine.Create(Self);
  FRightLine := TfrxFrameLine.Create(Self);
  FBottomLine := TfrxFrameLine.Create(Self);
{$IFDEF FR_COM}
  inherited Create(IfrxFrame);
{$ENDIF}
end;

destructor TfrxFrame.Destroy;
begin
  FLeftLine.Free;
  FTopLine.Free;
  FRightLine.Free;
  FBottomLine.Free;
  inherited;
end;

procedure TfrxFrame.Assign(Source: TPersistent);
begin
  if Source is TfrxFrame then
  begin
    FColor := TfrxFrame(Source).Color;
    FDropShadow := TfrxFrame(Source).DropShadow;
    FShadowColor := TfrxFrame(Source).ShadowColor;
    FShadowWidth := TfrxFrame(Source).ShadowWidth;
    FStyle := TfrxFrame(Source).Style;
    FTyp := TfrxFrame(Source).Typ;
    FWidth := TfrxFrame(Source).Width;

    FLeftLine.Assign(TfrxFrame(Source).LeftLine);
    FTopLine.Assign(TfrxFrame(Source).TopLine);
    FRightLine.Assign(TfrxFrame(Source).RightLine);
    FBottomLine.Assign(TfrxFrame(Source).BottomLine);
  end;
end;

function TfrxFrame.IsShadowWidthStored: Boolean;
begin
  Result := FShadowWidth <> 4;
end;

function TfrxFrame.IsTypStored: Boolean;
begin
  Result := FTyp <> [];
end;

function TfrxFrame.IsWidthStored: Boolean;
begin
  Result := FWidth <> 1;
end;

procedure TfrxFrame.SetBottomLine(const Value: TfrxFrameLine);
begin
  FBottomLine.Assign(Value);
end;

procedure TfrxFrame.SetLeftLine(const Value: TfrxFrameLine);
begin
  FLeftLine.Assign(Value);
end;

procedure TfrxFrame.SetRightLine(const Value: TfrxFrameLine);
begin
  FRightLine.Assign(Value);
end;

procedure TfrxFrame.SetTopLine(const Value: TfrxFrameLine);
begin
  FTopLine.Assign(Value);
end;

procedure TfrxFrame.SetColor(const Value: TColor);
begin
  FColor := Value;
  FLeftLine.Color := Value;
  FTopLine.Color := Value;
  FRightLine.Color := Value;
  FBottomLine.Color := Value;
end;

procedure TfrxFrame.SetStyle(const Value: TfrxFrameStyle);
begin
  FStyle := Value;
  FLeftLine.Style := Value;
  FTopLine.Style := Value;
  FRightLine.Style := Value;
  FBottomLine.Style := Value;
end;

procedure TfrxFrame.SetWidth(const Value: Extended);
begin
  FWidth := Value;
  FLeftLine.Width := Value;
  FTopLine.Width := Value;
  FRightLine.Width := Value;
  FBottomLine.Width := Value;
end;

function TfrxFrame.Diff(AFrame: TfrxFrame): String;
var
  i: Integer;
  ColorChanged, StyleChanged, WidthChanged: Boolean;
begin
  Result := '';

  ColorChanged := FColor <> AFrame.Color;
  if ColorChanged then
    Result := Result + ' Frame.Color="' + IntToStr(FColor) + '"';
  if FDropShadow <> AFrame.DropShadow then
    Result := Result + ' Frame.DropShadow="' + frxValueToXML(FDropShadow) + '"';
  if FShadowColor <> AFrame.ShadowColor then
    Result := Result + ' Frame.ShadowColor="' + IntToStr(FShadowColor) + '"';
  if FloatDiff(FShadowWidth, AFrame.ShadowWidth) then
    Result := Result + ' Frame.ShadowWidth="' + FloatToStr(FShadowWidth) + '"';
  StyleChanged := FStyle <> AFrame.Style;
  if StyleChanged then
    Result := Result + ' Frame.Style="' + frxValueToXML(FStyle) + '"';
  if FTyp <> AFrame.Typ then
  begin
    i := 0;
    if ftLeft in FTyp then i := i or 1;
    if ftRight in FTyp then i := i or 2;
    if ftTop in FTyp then i := i or 4;
    if ftBottom in FTyp then i := i or 8;
    Result := Result + ' Frame.Typ="' + IntToStr(i) + '"';
  end;
  WidthChanged := FloatDiff(FWidth, AFrame.Width);
  if WidthChanged then
    Result := Result + ' Frame.Width="' + FloatToStr(FWidth) + '"';

  Result := Result + FLeftLine.Diff(AFrame.LeftLine, 'Frame.LeftLine',
    ColorChanged, StyleChanged, WidthChanged);
  Result := Result + FTopLine.Diff(AFrame.TopLine, 'Frame.TopLine',
    ColorChanged, StyleChanged, WidthChanged);
  Result := Result + FRightLine.Diff(AFrame.RightLine, 'Frame.RightLine',
    ColorChanged, StyleChanged, WidthChanged);
  Result := Result + FBottomLine.Diff(AFrame.BottomLine, 'Frame.BottomLine',
    ColorChanged, StyleChanged, WidthChanged);
end;

{$IFDEF FR_COM}
function TfrxFrame.Get_Color(out Value: Integer): HResult; stdcall;
begin
  Value := Color;
  Result := S_OK;
end;

function TfrxFrame.Set_Color(Value: Integer): HResult; stdcall;
begin
  Color := Value;
  Result := S_OK;
end;

function TfrxFrame.Get_DropShadow(out Value: WordBool): HResult; stdcall;
begin
  Value := DropShadow;
  Result := S_OK;
end;

function TfrxFrame.Set_DropShadow(Value: WordBool): HResult; stdcall;
begin
  DropShadow := Value;
  Result := S_OK;
end;

function TfrxFrame.Get_ShadowColor(out Value: Integer): HResult; stdcall;
begin
  Value := ShadowColor;
  Result := S_OK;
end;

function TfrxFrame.Set_ShadowColor(Value: Integer): HResult; stdcall;
begin
  ShadowColor := Value;
  Result := S_OK;
end;

function TfrxFrame.Get_ShadowWidth(out Value: Double): HResult; stdcall;
begin
  Value := ShadowWidth;
  Result := S_OK;
end;

function TfrxFrame.Set_ShadowWidth(Value: Double): HResult; stdcall;
begin
  ShadowWidth := Value;
  Result := S_OK;
end;

function TfrxFrame.Get_Style(out Value: frxFrameStyle): HResult; stdcall;
begin
  Value := frxFrameStyle(Style);
  Result := S_OK;
end;

function TfrxFrame.Set_Style(Value: frxFrameStyle): HResult; stdcall;
begin
  Style := TfrxFrameStyle(Value);
  Result := S_OK;
end;

function TfrxFrame.Get_FrameType(out Value: Integer): HResult; stdcall;
begin
  Value := PInteger(@Typ)^;
  Result := S_OK;
end;

function TfrxFrame.Set_FrameType(Value: Integer): HResult; stdcall;
type
  PfrxFrameTypes = ^ TfrxFrameTypes;
var
  dst: TfrxFrameTypes;
  src:  Integer;
begin
  src := Value;
  dst := PfrxFrameTypes(@src)^;
  Typ := dst;
  Result := S_OK;
end;

function TfrxFrame.Get_Width(out Value: Double): HResult; stdcall;
begin
  Value := Width;
  Result := S_OK;
end;

function TfrxFrame.Set_Width(Value: Double): HResult; stdcall;
begin
  Width := Value;
  Result := S_OK;
end;
{$ENDIF}


{ TfrxView }

constructor TfrxView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frComponentStyle := frComponentStyle + [csDefaultDiff];
  FAlign := baNone;
  FBrushStyle := bsSolid;
  FColor := clTransparent;
  FFrame := TfrxFrame.Create;
  FShiftMode := smAlways;
  FPrintable := True;
  FPlainText := False;
end;

destructor TfrxView.Destroy;
begin
  FFrame.Free;
  inherited;
end;

procedure TfrxView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

procedure TfrxView.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxView.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxView.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxView.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;

procedure TfrxView.BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  FCanvas := Canvas;
  FScaleX := ScaleX;
  FScaleY := ScaleY;
  FOffsetX := OffsetX;
  FOffsetY := OffsetY;
  FX := Round(AbsLeft * ScaleX + OffsetX);
  FY := Round(AbsTop * ScaleY + OffsetY);
  FX1 := Round((AbsLeft + Width) * ScaleX + OffsetX);
  FY1 := Round((AbsTop + Height) * ScaleY + OffsetY);

  if Frame.DropShadow then
  begin
    FX1 := FX1 - Round(Frame.ShadowWidth * ScaleX);
    FY1 := FY1 - Round(Frame.ShadowWidth * ScaleY);
  end;

  FDX := FX1 - FX;
  FDY := FY1 - FY;
  FFrameWidth := Round(Frame.Width * ScaleX);
end;

procedure TfrxView.DrawBackground;
var
  br, oldbr: HBRUSH;
begin
  with FCanvas do
  begin
    Brush.Style := FBrushStyle;
    if FColor <> clNone then
    begin
      Brush.Color := FColor;
      Brush.Style := bsSolid;
      FillRect(Rect(FX, FY, FX1, FY1));
    end;
    if FBrushStyle <> bsSolid then
    begin
      { Brush.Style := xxx does not work for some printers }
      {$IFDEF FPC}
      {$warning LCL: CreateHatchBrush() NOT IMPLEMENTED YET !}
      {TODO: CreateHatchBrush() implementation}
      br := LCLIntf.CreateSolidBrush(ColorToRGB(Self.Frame.Color));
      {$ELSE}
      br := CreateHatchBrush(Integer(FBrushStyle) - 2, ColorToRGB(Frame.Color));
      {$ENDIF}
      oldbr := SelectObject(Handle, br);
      Rectangle(FX, FY, FX1 + 1, FY1 + 1);
      SelectObject(Handle, oldbr);
      DeleteObject(br);
    end;
  end;
end;

procedure TfrxView.DrawLine(x, y, x1, y1, w: Integer);
var
  i, d: Integer;
begin
  with FCanvas do
  begin
    if w = 0 then
      w := 1;
    if w mod 2 = 0 then
      d := 1 else
      d := 0;

    for i := (-w div 2) to (w div 2 - d) do
    begin
      if Abs(x1 - x) > Abs(y1 - y) then
      begin
        MoveTo(x, y + i);
        LineTo(x1, y1 + i);
      end
      else
      begin
        MoveTo(x + i, y);
        LineTo(x1 + i, y1);
      end;
    end;
  end;
end;

procedure TfrxView.DrawFrame;
var
  d: Integer;

  procedure LineInt(x, y, x1, y1: Integer; Line: TfrxFrameLine;
    Typ: TfrxFrameType; gap1, gap2: Boolean);
  var
    g1, g2, g3, g4, fw: Integer;
    LG: LOGBRUSH;
    hP: HPEN;
    PenStyle: array[0..1] of DWORD;
    PenSt: Cardinal;
    OldPen: HGDIOBJ;
    TempCl: TColor;

    procedure Line1(x, y, x1, y1: Integer);
    begin
      FCanvas.MoveTo(x, y);
      FCanvas.LineTo(x1, y1);
    end;

    {back compatibility for win9x/ME}
    procedure DrawDotLine(x, y, x1, y1, w: Integer; Rounded:Boolean);
    var
      idX, idY, mWidth, mHeight, CpMode: Integer;
      Bcl: TColor;
      TmpBit: TBitmap;
    begin
      if w = 0 then
        w := 1;
      mHeight := y1 - y;
      mWidth := x1 - x;
      if mWidth = 0 then
        mWidth := w;
      if mHeight = 0 then
        mHeight := w;

      TmpBit := TBitmap.Create;
      TmpBit.Width := mWidth;
      TmpBit.Height := mHeight;
      TmpBit.Canvas.Brush.Color := clBlack;
      TmpBit.Canvas.Pen.Color := clBlack;
      Bcl := FCanvas.Brush.Color;
      FCanvas.Brush.Color := Line.Color;
      idX := 0;

      while (idX <= mWidth) do
      begin
        idY := 0;
        while (idY <= mHeight) do
        begin
          if w > 1 then
            if Rounded then
              TmpBit.Canvas.Ellipse(idX, idY, idX + w, idY + w)
            else
              TmpBit.Canvas.Rectangle(idX, idY, idX + w, idY + w)
          else
            TmpBit.Canvas.Pixels[idX, idY] := clBlack;
          idY := idY + w * 2;
        end;
        idX := idX +  w * 2;
      end;

      CpMode := FCanvas.CopyMode;
      FCanvas.CopyMode := $B8074A; {this mode copy all black pixels from source to dest with current brush color}
      FCanvas.Draw(x - (w div 2), y - (w div 2), TmpBit);
      {restore canvas state}
      FCanvas.Brush.Color := Bcl;
      FCanvas.CopyMode := CpMode;
      TmpBit.Free;
    end;

  begin
    fw := Round(Line.Width * FScaleX);

    if Line.Style in [fsSolid, fsDouble] then
    begin
      if gap1 then g1 := 0 else g1 := 1;
      if gap2 then g2 := 0 else g2 := 1;

      if Typ in [ftTop, ftBottom] then
      begin
        x := x + (fw * g1 div 2);
        x1 := x1 - (fw * g2 div 2);
      end
      else
      begin
        y := y + (fw * g1 div 2);
        y1 := y1 - (fw * g2 div 2);
      end;
    end;


    if Line.Style = fsSolid then
      begin
        LG.lbStyle := BS_SOLID;
        LG.lbColor := line.Color;
        LG.lbHatch := 0;
        PenSt := PS_GEOMETRIC or PS_ENDCAP_SQUARE;
        hP := ExtCreatePen(PenSt, fw, LG, 0, nil);
        if hP <> 0 then
        begin
          OldPen := SelectObject(FCanvas.Handle, Hp);
          Line1(x, y, x1, y1);
          SelectObject(FCanvas.Handle, OldPen);
          DeleteObject(hP);
        end
        else Line1(x, y, x1, y1)
      end
    else if Line.Style = fsDouble then
    begin
      if gap1 then
        g1 := fw else
        g1 := 0;
      if gap2 then
        g2 := fw else
        g2 := 0;
      g3 := -g1;
      g4 := -g2;

      if Typ in [ftLeft, ftTop] then
      begin
        g1 := -g1;
        g2 := -g2;
        g3 := -g3;
        g4 := -g4;
      end;

      if x = x1 then
        Line1(x - fw, y + g1, x1 - fw, y1 - g2) else
        Line1(x + g1, y - fw, x1 - g2, y1 - fw);
      if Color <> clNone then
      begin
        FCanvas.Pen.Color := Color;
        Line1(x, y, x1, y1);
      end;
      FCanvas.Pen.Color := Line.Color;
      if x = x1 then
        Line1(x + fw, y + g3, x1 + fw, y1 - g4) else
        Line1(x + g3, y + fw, x1 - g4, y1 + fw);
    end
    {real round dot line / Square dot line}
    else if Line.Style in [fsAltDot, fsSquare] then
    begin
      LG.lbStyle := BS_SOLID;
      LG.lbColor := line.Color;
      LG.lbHatch := 0;
      PenSt := PS_GEOMETRIC or PS_USERSTYLE;
      if fw <= 1 then
      begin
        PenStyle[0] := 1;
        PenStyle[1] := 1;
        PenSt := PenSt or PS_ENDCAP_FLAT;
      end
      else if Line.Style = fsSquare then
      begin
        PenStyle[0] := fw;
        PenStyle[1] := fw;
        PenSt := PenSt or PS_ENDCAP_FLAT;
      end
      else
      begin
        PenStyle[0] := 0;
        PenStyle[1] := fw * 2;
        PenSt := PenSt or PS_ENDCAP_ROUND;
      end;

      if Color <> clNone then
      begin
        TempCl := FCanvas.Pen.Color;
        FCanvas.Pen.Color := Color;
        DrawLine(x, y, x1, y1, fw);
        FCanvas.Pen.Color := TempCl;
      end;
      hP := ExtCreatePen(PenSt, fw, LG, 2, @PenStyle);
      if hP = 0 then
        DrawDotLine(x, y, x1, y1, fw, Line.Style = fsAltDot)
      else
      begin
        OldPen := SelectObject(FCanvas.Handle, Hp);
        Line1(x, y, x1, y1);
        SelectObject(FCanvas.Handle, OldPen);
        DeleteObject(hP);
      end;
    end
    else
      DrawLine(x, y, x1, y1, fw);
  end;

  procedure SetPen(ALine: TfrxFrameLine);
  begin
    with FCanvas do
    begin
      Pen.Color := ALine.Color;
      if ALine.Style in [fsSolid, fsDouble] then
      begin
        Pen.Style := psSolid;
        Pen.Width := Round(ALine.Width * FScaleX);
      end
      else
      begin
        Pen.Style := TPenStyle(ALine.Style);
        Pen.Width := 1;
      end;
    end;
  end;

begin
  if Frame.DropShadow then
    with FCanvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := Self.Frame.ShadowColor;
      d := Round(Self.Frame.ShadowWidth * FScaleX);
      DrawLine(FX1 + d div 2, FY + d, FX1 + d div 2, FY1, d);
      d := Round(Self.Frame.ShadowWidth * FScaleY);
      DrawLine(FX + d, FY1 + d div 2, FX1 + d, FY1 + d div 2, d);
    end;

  if (Frame.Typ <> []) and (Frame.Color <> clNone) and (Frame.Width <> 0) then
    with FCanvas do
    begin
      Brush.Style := bsSolid;
      if Self.Frame.Style <> fsSolid then
        if Color = clNone then
          Brush.Style := bsClear else
          Brush.Color := Color;
      if ftLeft in Self.Frame.Typ then
      begin
        SetPen(FFrame.LeftLine);
        if (Pen.Width = 2) and (Self.Frame.Style <> fsSolid) then
          d := 1 else
          d := 0;
        LineInt(FX, FY - d, FX, FY1, FFrame.LeftLine, ftLeft, ftTop in Self.Frame.Typ, ftBottom in Self.Frame.Typ);
      end;
      if ftRight in Self.Frame.Typ then
      begin
        SetPen(FFrame.RightLine);
        LineInt(FX1, FY, FX1, FY1, FFrame.RightLine, ftRight, ftTop in Self.Frame.Typ, ftBottom in Self.Frame.Typ);
      end;
      if ftTop in Self.Frame.Typ then
      begin
        SetPen(FFrame.TopLine);
        LineInt(FX, FY, FX1, FY, FFrame.TopLine, ftTop, ftLeft in Self.Frame.Typ, ftRight in Self.Frame.Typ);
      end;
      if ftBottom in Self.Frame.Typ then
      begin
        SetPen(FFrame.BottomLine);
        if (Pen.Width = 1) and (Self.Frame.Style <> fsSolid) then
          d := 1 else
          d := 0;
        LineInt(FX, FY1, FX1 + d, FY1, FFrame.BottomLine, ftBottom, ftLeft in Self.Frame.Typ, ftRight in Self.Frame.Typ);
      end;
    end;
end;

procedure TfrxView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  DrawBackground;
  DrawFrame;
end;

function TfrxView.Diff(AComponent: TfrxComponent): String;
var
  v: TfrxView;
begin
  Result := inherited Diff(AComponent);
  v := TfrxView(AComponent);

  if FBrushStyle <> v.FBrushStyle then
    Result := Result + ' BrushStyle="' + frxValueToXML(FBrushStyle) + '"';
  if FAlign <> v.FAlign then
    Result := Result + ' Align="' + frxValueToXML(FAlign) + '"';
  if FColor <> v.FColor then
    Result := Result + ' Color="' + IntToStr(FColor) + '"';
  Result := Result + FFrame.Diff(v.FFrame);
  if Cursor <> v.Cursor then
    Result := Result + ' Cursor="' + frxValueToXML(Cursor) + '"';
  if FPrintable <> v.FPrintable then
    Result := Result + ' Printable="' + frxValueToXML(FPrintable) + '"';
  if TagStr <> v.TagStr then
    Result := Result + ' TagStr="' + frxStrToXML(TagStr) + '"';
  if URL <> v.URL then
    Result := Result + ' URL="' + frxStrToXML(URL) + '"';
end;

function TfrxView.IsDataField: Boolean;
begin
  Result := (DataSet <> nil) and (Length(DataField) <> 0);
end;

procedure TfrxView.BeforePrint;
begin
  inherited;
  FTempTag := FTagStr;
  FTempURL := FURL;
  if Report <> nil then
  begin
//    Report.sel
    Report.SelfValue := Self;
  end;
end;

procedure TfrxView.ExpandVariables(var Expr: String);
var
  i, j: Integer;
  s: String;
begin
  i := 1;
  repeat
    while i < Length(Expr) do
      if isDBCSLeadByte(Byte(Expr[i])) then  { if DBCS then skip 2 bytes }
        Inc(i, 2)
      else if (Expr[i] <> '[') then
        Inc(i)
      else
        break;
{$IFDEF Delphi12}
    s := frxGetBrackedVariableW(Expr, '[', ']', i, j);
{$ELSE}
    s := frxGetBrackedVariable(Expr, '[', ']', i, j);
{$ENDIF}
    if i <> j then
    begin
      Delete(Expr, i, j - i + 1);
      s := VarToStr(Report.Calc(s));
      Insert(s, Expr, i);
      Inc(i, Length(s));
      j := 0;
    end;
  until i = j;
end;

procedure TfrxView.GetData;
begin
  if (FTagStr <> '') and (Pos('[', FTagStr) <> 0) then
    ExpandVariables(FTagStr);
  if (FURL <> '') and (Pos('[', FURL) <> 0) then
    ExpandVariables(FURL);
end;

procedure TfrxView.AfterPrint;
begin
  inherited;
  FTagStr := FTempTag;
  FURL := FTempURL;
end;

{$IFDEF FR_COM}
function TfrxView.Get_DataField(out Value: WideString): HResult; stdcall;
begin
  Value := FDataField;
  Result := S_OK;
end;

function TfrxView.Set_DataField(const Value: WideString): HResult; stdcall;
begin
  FDataField := Value;
  Result := S_OK;
end;

function TfrxView.Get_TagStr(out Value: WideString): HResult; stdcall;
begin
  Value := FTagStr;
  Result := S_OK;
end;

function TfrxView.Set_TagStr(const Value: WideString): HResult; stdcall;
begin
  FTagStr := Value;
  Result := S_OK;
end;

function TfrxView.Get_URL(out Value: WideString): HResult; stdcall;
begin
  Value := FURL;
  Result := S_OK;
end;

function TfrxView.Set_URL(const Value: WideString): HResult; stdcall;
begin
  FURL := Value;
  Result := S_OK;
end;

function TfrxView.Get_DataSetName(out Value: WideString): HResult; stdcall;
begin
  Value := GetDataSetName;
  Result := S_OK;
end;

function TfrxView.Set_DataSetName(const Value: WideString): HResult; stdcall;
begin
  SetDataSetName(Value);
  Result := S_OK;
end;

function TfrxView.Get_Name(out Value: WideString): HResult; stdcall;
begin
  Value := Name;
  Result := S_OK;
end;

function TfrxView.Get_Frame(out Value: IfrxFrame): HResult; stdcall;
begin
  Value := Frame as IfrxFrame;
  Result := S_OK;
end;

function TfrxView.Get_ShiftMode(out Value: frxShiftMode): HResult; stdcall;
begin
  Value := TOleEnum(ShiftMode);
  Result := S_OK;
end;

function TfrxView.Set_ShiftMode(Value: frxShiftMode): HResult; stdcall;
begin
  ShiftMode := TfrxShiftMode(Value);
  Result := S_OK;
end;

function TfrxView.Get_Align(out Value: frxAlign): HResult; stdcall;
begin
  Value := TOleEnum(Align);
  Result := S_OK;
end;

function TfrxView.Set_Align(Value: frxAlign): HResult; stdcall;
begin
  Align := TfrxAlign(Value);
  Result := S_OK;
end;

function TfrxView.Get_Visible(out Value: WordBool): HResult; stdcall;
begin
  Value := Self.Visible;
  Result := S_OK;
end;

function TfrxView.Set_Visible(Value: WordBool): HResult; stdcall;
begin
  Visible := Value;
  Result := S_OK;
end;

function TfrxView.Get_Printable(out Value: WordBool): HResult; stdcall;
begin
  Value := Printable;
  Result := S_OK;
end;

function TfrxView.Set_Printable(Value: WordBool): HResult; stdcall;
begin
  Printable := Value;
  Result := S_OK;
end;

function TfrxView.Get_Color(out Value: Integer): HResult; stdcall;
begin
  Value := Color;
  Result := S_OK;
end;

function TfrxView.Set_Color(Value: Integer): HResult; stdcall;
begin
  Color := Value;
  Result := S_OK;
end;

function TfrxView.Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
begin
  Value := DataSet as IfrxDataSet;
  Result := S_OK;
end;
  
function TfrxView.Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  Result := Value.QueryInterface( {IfrxComponentSelf} IInterfaceComponentReference, idsp);
  if Result = S_OK then
    DataSet := TfrxDataSet(idsp.GetComponent{Get_Object});
end;
{$ENDIF}

{ TfrxShapeView }

constructor TfrxShapeView.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csDefaultDiff];
end;

constructor TfrxShapeView.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  FShape := TfrxShapeKind(Flags);
end;

procedure TfrxShapeView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  SaveLeft, SaveTop, SaveWidth, SaveHeight: Extended;

  procedure DrawShape;
  var
    min: Integer;
  begin
    if FDY < FDX then
      min := FDY else
      min := FDX;

    with Canvas do
    case FShape of
      skRectangle:
        Rectangle(FX, FY, FX1 + 1, FY1 + 1);

      skRoundRectangle:
        begin
          if FCurve = 0 then
            min := min div 4
          else
            min := Round(FCurve * FScaleX * 10);
          RoundRect(FX, FY, FX1 + 1, FY1 + 1, min, min);
        end;

      skEllipse:
        Ellipse(FX, FY, FX1 + 1, FY1 + 1);

      skTriangle:
        Polygon([Point(FX1, FY1), Point(FX, FY1), Point(FX + FDX div 2, FY), Point(FX1, FY1)]);

      skDiamond:
        Polygon([Point(FX + FDX div 2, FY), Point(FX1, FY + FDY div 2),
          Point(FX + FDX div 2, FY1), Point(FX, FY + FDY div 2)]);

      skDiagonal1:
        DrawLine(FX, FY1, FX1, FY, FFrameWidth);

      skDiagonal2:
        DrawLine(FX, FY, FX1, FY1, FFrameWidth);
    end;
  end;

  procedure DoDraw;
  begin
    with Canvas do
    begin
      Pen.Color := Self.Frame.Color;
      Pen.Width := FFrameWidth;
      Brush.Style := bsSolid;
      SetBkMode(Handle, Opaque);

      if FBrushStyle = bsSolid then
      begin
        Pen.Style := TPenStyle(Self.Frame.Style);
        if Self.Frame.Color = clNone then
          Pen.Style := psClear;
        if FColor <> clNone then
          Brush.Color := FColor else
          Brush.Style := bsClear;
        DrawShape;
      end
      else
      begin
        Pen.Style := TPenStyle(Self.Frame.Style);
        if Self.Frame.Color = clNone then
          Pen.Style := psClear;
        if FColor <> clNone then
        begin
          Brush.Color := FColor;
          DrawShape;
        end;
        Brush.Style := FBrushStyle;
        Brush.Color := Self.Frame.Color;
        DrawShape;
      end;
    end;
  end;

begin
  if Frame.Style = fsDouble then
  begin
    Frame.Style := fsSolid;
    SaveLeft := Left;
    SaveTop := Top;
    SaveWidth := Width;
    SaveHeight := Height;

    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DoDraw;

    case FShape of
      skRectangle, skRoundRectangle, skEllipse:
        begin
          Left := Left + 2 * Frame.Width;
          Top := Top + 2 * Frame.Width;
          Width := Width - 4 * Frame.Width;
          Height := Height - 4 * Frame.Width;
        end;

      skTriangle:
        begin
          Left := Left + 4 * Frame.Width;
          Top := Top + 4 * Frame.Width;
          Width := Width - 8 * Frame.Width;
          Height := Height - 6 * Frame.Width;
        end;

      skDiamond:
        begin
          Left := Left + 3 * Frame.Width;
          Top := Top + 3 * Frame.Width;
          Width := Width - 6 * Frame.Width;
          Height := Height - 6 * Frame.Width;
        end;

      skDiagonal1, skDiagonal2:
        begin
          Left := Left + 2 * Frame.Width;
        end;
    end;

    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DoDraw;

    Frame.Style := fsDouble;
    Left := SaveLeft;
    Top := SaveTop;
    Width := SaveWidth;
    Height := SaveHeight;
  end
  else
  begin
    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DoDraw;
  end;
end;

function TfrxShapeView.Diff(AComponent: TfrxComponent): String;
begin
  Result := inherited Diff(AComponent);

  if FShape <> TfrxShapeView(AComponent).FShape then
    Result := Result + ' Shape="' + frxValueToXML(FShape) + '"';
end;

class function TfrxShapeView.GetDescription: String;
begin
  Result := frxResources.Get('obShape');
end;

{$IFDEF FR_COM}
function TfrxShapeView.Get_Curve(out Value: Integer): HResult; stdcall;
begin
  Value := Curve;
  Result := S_OK;
end;

function TfrxShapeView.Set_Curve(Value: Integer): HResult; stdcall;
begin
  Curve := Value;
  Result := S_OK;
end;

function TfrxShapeView.Get_ShapeType(out Value: frxShapeType): HResult; stdcall;
begin
  Value := frxShapeType(Shape);
  Result := S_OK;
end;

function TfrxShapeView.Set_ShapeType(Value: frxShapeType): HResult; stdcall;
begin
  Shape := TfrxShapeKind(Value);
  Result := S_OK;
end;
{$ENDIF}

{ TfrxHighlight }

constructor TfrxHighlight.Create;
begin
  FColor := clTransparent;
{$IFNDEF FR_COM}
  FFont := TFont.Create;
{$ELSE}
  inherited Create(IfrxHighlight);
  FFont := TfrxFont.Create;
{$ENDIF}
  with FFont do
  begin
    PixelsPerInch := 96;
    Name := DefFontName;
    Size := DefFontSize;
    Color := clRed;
    Charset := frxCharset;
  end;
end;

destructor TfrxHighlight.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TfrxHighlight.Assign(Source: TPersistent);
begin
  if Source is TfrxHighlight then
  begin
    FFont.Assign(TfrxHighlight(Source).Font);
    FColor := TfrxHighlight(Source).Color;
    FCondition := TfrxHighlight(Source).Condition;
  end;
end;

procedure TfrxHighlight.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

{$IFDEF FR_COM}
function TfrxHighlight.GetFont: TFont;
begin
  Result := FFont as TFont;
end;

function TfrxHighlight.Get_Active(out Value: WordBool): HResult; stdcall;
begin
  Value := Active;
  Result := S_OK;
end;

function TfrxHighlight.Set_Active(Value: WordBool): HResult; stdcall;
begin
  Active := Value;
  Result := S_OK;
end;

function TfrxHighlight.Get_Color(out Value: Integer): HResult; stdcall;
begin
  Value := Color;
  Result := S_OK;
end;

function TfrxHighlight.Set_Color(Value: Integer): HResult; stdcall;
begin
  Color := Value;
  Result := S_OK;
end;

function TfrxHighlight.Get_Font(out Value: IfrxFont): HResult; stdcall;
begin
  Value := FFont as IfrxFont;
  Value._AddRef();
  Result := S_OK;
end;
{$ENDIF}

{ TfrxFormat }

procedure TfrxFormat.Assign(Source: TPersistent);
begin
  if Source is TfrxFormat then
  begin
    FDecimalSeparator := TfrxFormat(Source).DecimalSeparator;
    FThousandSeparator := TfrxFormat(Source).ThousandSeparator;
    FFormatStr := TfrxFormat(Source).FormatStr;
    FKind := TfrxFormat(Source).Kind;
  end;
end;

{$IFDEF FR_COM}
constructor TfrxFormat.Create;
begin
  inherited Create(IfrxDisplayFormat);
end;

function TfrxFormat.Get_DecimalSeparator(out Value: WideString): HResult; stdcall;
begin
  Value := DecimalSeparator;
  Result := S_OK;
end;

function TfrxFormat.Set_DecimalSeparator(const Value: WideString): HResult; stdcall;
begin
  DecimalSeparator := Value;
  Result := S_OK;
end;

function TfrxFormat.Get_FormatStr(out Value: WideString): HResult; stdcall;
begin
  Value := FormatStr;
  Result := S_OK;
end;

function TfrxFormat.Set_FormatStr(const Value: WideString): HResult; stdcall;
begin
  FormatStr := Value;
  Result := S_OK;
end;

function TfrxFormat.Get_Kind(out Value: frxFormatKind): HResult; stdcall;
begin
  Value := frxFormatKind(Kind);
  Result := S_OK;
end;

function TfrxFormat.Set_Kind(Value: frxFormatKind): HResult; stdcall;
begin
  Kind := TfrxFormatKind(Value);
  Result := S_OK;
end;
{$ENDIF}

{ TfrxStretcheable }

constructor TfrxStretcheable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStretchMode := smDontStretch;
end;

function TfrxStretcheable.CalcHeight: Extended;
begin
  Result := Height;
end;

function TfrxStretcheable.DrawPart: Extended;
begin
  Result := 0;
end;

procedure TfrxStretcheable.InitPart;
begin
//
end;

function TfrxStretcheable.HasNextDataPart: Boolean;
begin
  Result := False;
end;

{$IFDEF FR_COM}
function TfrxStretcheable.Get_StretchMode(out Value: frxStretchMode): HResult; stdcall;
begin
  Value := frxStretchMode(StretchMode);
  Result := S_OK;
end;

function TfrxStretcheable.Set_StretchMode(Value: frxStretchMode): HResult; stdcall;
begin
  StretchMode := TfrxStretchMode(Value);
  Result := S_OK;
end;
{$ENDIF}

{ TfrxCustomMemoView }

constructor TfrxCustomMemoView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frComponentStyle := frComponentStyle - [csDefaultDiff];
  FHighlight := TfrxHighlight.Create;
  FDisplayFormat := TfrxFormat.Create;
{$IFDEF Delphi10}
  FMemo := TfrxWideStrings.Create;
{$ELSE}
  FMemo := TWideStrings.Create;
{$ENDIF}
  FAllowExpressions := True;
  FClipped := True;
  FExpressionDelimiters := '[,]';
  FGapX := 2;
  FGapY := 1;
  FHAlign := haLeft;
  FVAlign := vaTop;
  FLineSpacing := 2;
  ParentFont := True;
  FWordWrap := True;
  FWysiwyg := True;
  FLastValue := Null;
end;

destructor TfrxCustomMemoView.Destroy;
begin
  FHighlight.Free;
  FDisplayFormat.Free;
  FMemo.Free;
  inherited;
end;

class function TfrxCustomMemoView.GetDescription: String;
begin
  Result := frxResources.Get('obText');
end;

procedure TfrxCustomMemoView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FFlowTo) then
    FFlowTo := nil;
end;

function TfrxCustomMemoView.IsExprDelimitersStored: Boolean;
begin
  Result := FExpressionDelimiters <> '[,]';
end;

function TfrxCustomMemoView.IsLineSpacingStored: Boolean;
begin
  Result := FLineSpacing <> 2;
end;

function TfrxCustomMemoView.IsGapXStored: Boolean;
begin
  Result := FGapX <> 2;
end;

function TfrxCustomMemoView.IsGapYStored: Boolean;
begin
  Result := FGapY <> 1;
end;

function TfrxCustomMemoView.IsParagraphGapStored: Boolean;
begin
  Result := FParagraphGap <> 0;
end;

function TfrxCustomMemoView.IsCharSpacingStored: Boolean;
begin
  Result := FCharSpacing <> 0;
end;

function TfrxCustomMemoView.IsHighlightStored: Boolean;
begin
  Result := Trim(FHighlight.Condition) <> '';
end;

procedure TfrxCustomMemoView.SetRotation(Value: Integer);
begin
  FRotation := Value mod 360;
end;

procedure TfrxCustomMemoView.SetText(const Value: WideString);
begin
 { if (FFont.Charset <> DEFAULT_CHARSET) and (Report <> nil) then
    FMemo.Text := AnsiToUnicode(Value, FFont.Charset)
  else}
  FMemo.Text := Value;
end;

procedure TfrxCustomMemoView.SetAnsiText(const Value: AnsiString);
begin
  FMemo.Text := AnsiToUnicode(Value, FFont.Charset);
end;

function TfrxCustomMemoView.GetText: WideString;
begin
  Result := FMemo.Text;
end;

function TfrxCustomMemoView.GetAnsiText: AnsiString;
begin
  Result := _UnicodeToAnsi(FMemo.Text,FFont.Charset);
end;

procedure TfrxCustomMemoView.SetMemo(const Value: TWideStrings);
begin
  FMemo.Assign(Value);
end;

procedure TfrxCustomMemoView.SetHighlight(const Value: TfrxHighlight);
begin
  FHighlight.Assign(Value);
end;

procedure TfrxCustomMemoView.SetDisplayFormat(const Value: TfrxFormat);
begin
  FDisplayFormat.Assign(Value);
end;

procedure TfrxCustomMemoView.SetStyle(const Value: String);
begin
  FStyle := Value;
  if Report <> nil then
    ApplyStyle(Report.Styles.Find(FStyle));
end;

function TfrxCustomMemoView.AdjustCalcHeight: Extended;
begin
  Result := GapY * 2;
  if ftTop in Frame.Typ then
    Result := Result + (Frame.Width - 1) / 2;
  if ftBottom in Frame.Typ then
    Result := Result + Frame.Width / 2;
  if Frame.DropShadow then
    Result := Result + Frame.ShadowWidth;
end;

function TfrxCustomMemoView.AdjustCalcWidth: Extended;
begin
  Result := GapX * 2;
  if ftLeft in Frame.Typ then
    Result := Result + (Frame.Width - 1) / 2;
  if ftRight in Frame.Typ then
    Result := Result + Frame.Width / 2;
  if Frame.DropShadow then
    Result := Result + Frame.ShadowWidth;
end;

procedure TfrxCustomMemoView.BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  bx, by, bx1, by1, wx1, wx2, wy1, wy2, gx1, gy1: Integer;
begin
  inherited BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);

  wx1 := Round((Frame.Width * ScaleX - 1) / 2);
  wx2 := Round(Frame.Width * ScaleX / 2);
  wy1 := Round((Frame.Width * ScaleY - 1) / 2);
  wy2 := Round(Frame.Width * ScaleY / 2);

  bx := FX;
  by := FY;
  bx1 := FX1;
  by1 := FY1;
  if ftLeft in Frame.Typ then
    Inc(bx, wx1);
  if ftRight in Frame.Typ then
    Dec(bx1, wx2);
  if ftTop in Frame.Typ then
    Inc(by, wy1);
  if ftBottom in Frame.Typ then
    Dec(by1, wy2);
  gx1 := Round(GapX * ScaleX);
  gy1 := Round(GapY * ScaleY);

  FTextRect := Rect(bx + gx1, by + gy1, bx1 - gx1 + 1, by1 - gy1 + 1);
end;

procedure TfrxCustomMemoView.SetDrawParams(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  ScaledRect: TRect;
  SaveWidth: Extended;
  FDrawText: TfrxDrawText;
begin
  if Report <> nil then
    FDrawText := Report.FDrawText else
    FDrawText := frxDrawText;
  FDrawText.UseDefaultCharset := FUseDefaultCharset;

  if FHighlight.Active then
  begin
    FDrawText.SetFont(FHighlight.Font);
    FColor := FHighlight.Color;
  end
  else
    FDrawText.SetFont(FFont);
  FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
    FClipped, FWysiwyg, FRotation);
  FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);

  if not IsDesigning then
    if FAutoWidth then
    begin
      FDrawText.SetDimensions(1, 1, 1, Rect(0, 0, 10000, 10000), Rect(0, 0, 10000, 10000));
      FDrawText.SetText(FMemo);
      SaveWidth := Width;
      Width := FDrawText.CalcWidth + AdjustCalcWidth;
      if FHAlign = haRight then
        Left := Left + SaveWidth - Width
      else if FHAlign = haCenter then
        Left := Left + (SaveWidth - Width) / 2;
      if Parent <> nil then
        Parent.AlignChildren;
    end;

  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  ScaledRect := FTextRect;
  BeginDraw(Canvas, 1, 1, 0, 0);

  if not IsPrinting then
    FPrintScale := 1;
  FDrawText.SetDimensions(ScaleX, ScaleY, FPrintScale, FTextRect, ScaledRect);
  FDrawText.SetText(FMemo);
  FDrawText.SetParaBreaks(FFirstParaBreak, FLastParaBreak);
end;

procedure TfrxCustomMemoView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  SaveColor: TColor;
  FDrawText: TfrxDrawText;

  procedure DrawUnderlines;
  var
    dy, h: Extended;
  begin
    with Canvas do
    begin
      Pen.Color := Self.Frame.Color;
      Pen.Width := FFrameWidth;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
    end;

    h := FDrawText.LineHeight * ScaleY;
    dy := FY + h + (GapY - LineSpacing + 1) * ScaleY;
    while dy < FY1 do
    begin
      Canvas.MoveTo(FX, Round(dy));
      Canvas.LineTo(FX1, Round(dy));
      dy := dy + h;
    end;
  end;

begin
  if Report <> nil then
    FDrawText := Report.FDrawText else
    FDrawText := frxDrawText;
  FDrawText.UseDefaultCharset := FUseDefaultCharset;

  if not IsDesigning then
    ExtractMacros
  else if IsDataField then
    FMemo.Text := '[' + DataSet.UserName + '."' + DataField + '"]';

  SaveColor := FColor;

  FDrawText.Lock;
  try
    SetDrawParams(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    inherited Draw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);

    if FUnderlines and (FRotation = 0) then
      DrawUnderlines;
    FDrawText.DrawText(FCanvas, HAlign, VAlign);

  finally
    FDrawText.Unlock;
  end;

  FColor := SaveColor;
end;

function TfrxCustomMemoView.CalcHeight: Extended;
var
  FDrawText: TfrxDrawText;
begin
  if Report <> nil then
    FDrawText := Report.FDrawText else
    FDrawText := frxDrawText;

  FDrawText.Lock;
  try
    if FHighlight.Active then
      FDrawText.SetFont(FHighlight.Font) else
      FDrawText.SetFont(FFont);
    FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
      FClipped, FWysiwyg, FRotation);
    FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);

    if FAutoWidth then
      FDrawText.SetDimensions(1, 1, 1, Rect(0, 0, 10000, 10000), Rect(0, 0, 10000, 10000))
    else
    begin
      BeginDraw(nil, 1, 1, 0, 0);
      FDrawText.SetDimensions(1, 1, 1, FTextRect, FTextRect);
    end;

    FDrawText.SetText(FMemo);
    Result := Round(FDrawText.CalcHeight + AdjustCalcHeight);

  finally
    FDrawText.Unlock;
  end;
end;

function TfrxCustomMemoView.CalcWidth: Extended;
var
  FDrawText: TfrxDrawText;
begin
  if Report <> nil then
    FDrawText := Report.FDrawText else
    FDrawText := frxDrawText;

  FDrawText.Lock;
  try
    if FHighlight.Active then
      FDrawText.SetFont(FHighlight.Font) else
      FDrawText.SetFont(FFont);
    FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
      FClipped, FWysiwyg, FRotation);
    FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);

    FDrawText.SetDimensions(1, 1, 1, Rect(0, 0, 10000, 10000), Rect(0, 0, 10000, 10000));
    FDrawText.SetText(FMemo);
    Result := Round(FDrawText.CalcWidth + AdjustCalcWidth);

  finally
    FDrawText.Unlock;
  end;
end;

procedure TfrxCustomMemoView.InitPart;
begin
  FPartMemo := FMemo.Text;
  FFirstParaBreak := False;
  FLastParaBreak := False;
end;

function TfrxCustomMemoView.DrawPart: Extended;
var
  SaveColor: TColor;
  FDrawText: TfrxDrawText;
  ParaBreak: Boolean;
begin
  if Report <> nil then
    FDrawText := Report.FDrawText else
    FDrawText := frxDrawText;

  SaveColor := FColor;

  FDrawText.Lock;
  try
    FMemo.Text := FPartMemo;
    SetDrawParams(nil, 1, 1, 0, 0);
    FPartMemo := FDrawText.GetOutBoundsText(ParaBreak);
    FMemo.Text := FDrawText.GetInBoundsText;
    FLastParaBreak := ParaBreak;

    Result := FDrawText.UnusedSpace;
    if Result = 0 then
      Result := Height;

  finally
    FDrawText.Unlock;
  end;

  FColor := SaveColor;
end;

function TfrxCustomMemoView.Diff(AComponent: TfrxComponent): String;
var
  m: TfrxCustomMemoView;
  s: WideString;
  c: Integer;
begin
  Result := inherited Diff(AComponent);
  m := TfrxCustomMemoView(AComponent);

  if FAutoWidth <> m.FAutoWidth then
    Result := Result + ' AutoWidth="' + frxValueToXML(FAutoWidth) + '"';
  if FloatDiff(FCharSpacing, m.FCharSpacing) then
    Result := Result + ' CharSpacing="' + FloatToStr(FCharSpacing) + '"';
  if FloatDiff(FGapX, m.FGapX) then
    Result := Result + ' GapX="' + FloatToStr(FGapX) + '"';
  if FloatDiff(FGapY, m.FGapY) then
    Result := Result + ' GapY="' + FloatToStr(FGapY) + '"';
  if FHAlign <> m.FHAlign then
    Result := Result + ' HAlign="' + frxValueToXML(FHAlign) + '"';
  if FHighlight.Active <> m.FHighlight.Active then
    Result := Result + ' Highlight.Active="' + frxValueToXML(FHighlight.Active) + '"';
  if FloatDiff(FLineSpacing, m.FLineSpacing) then
    Result := Result + ' LineSpacing="' + FloatToStr(FLineSpacing) + '"';
  if FUseDefaultCharset <> m.UseDefaultCharset then
    Result := Result + ' UseDefaultCharset="' + frxValueToXML(UseDefaultCharset) + '"';

  c := FMemo.Count;
  if c = 0 then
    Result := Result + ' u=""'
  else
  begin
    if c = 1 then
{$IFDEF Delphi12}
      Result := Result + ' u="' + frxStrToXML(FMemo[0]) + '"'
{$ELSE}
      Result := Result + ' u="' + frxStrToXML(Utf8Encode(FMemo[0])) + '"'
{$ENDIF}
    else
    begin
      s := Text;
      SetLength(s, Length(s) - 2);
{$IFDEF delphi12}
      Result := Result + ' u="' + frxStrToXML(s) + '"';
{$ELSE}
      Result := Result + ' u="' + frxStrToXML(Utf8Encode(s)) + '"';
{$ENDIF}
    end;
  end;

  if FloatDiff(FParagraphGap, m.FParagraphGap) then
    Result := Result + ' ParagraphGap="' + FloatToStr(FParagraphGap) + '"';
  if FRotation <> m.FRotation then
    Result := Result + ' Rotation="' + IntToStr(FRotation) + '"';
  if FRTLReading <> m.FRTLReading then
    Result := Result + ' RTLReading="' + frxValueToXML(FRTLReading) + '"';
  if FUnderlines <> m.FUnderlines then
    Result := Result + ' Underlines="' + frxValueToXML(FUnderlines) + '"';
  if FVAlign <> m.FVAlign then
    Result := Result + ' VAlign="' + frxValueToXML(FVAlign) + '"';
  if FWordWrap <> m.FWordWrap then
    Result := Result + ' WordWrap="' + frxValueToXML(FWordWrap) + '"';

  { formating }
  if FDisplayFormat.FKind <> m.FDisplayFormat.FKind then
    Result := Result + ' DisplayFormat.Kind="' + frxValueToXML(FDisplayFormat.FKind) + '"';
  if FDisplayFormat.FDecimalSeparator <> m.FDisplayFormat.FDecimalSeparator then
    Result := Result + ' DisplayFormat.DecimalSeparator="' + frxStrToXML(FDisplayFormat.FDecimalSeparator) + '"';
  if FDisplayFormat.FThousandSeparator <> m.FDisplayFormat.FThousandSeparator then
    Result := Result + ' DisplayFormat.ThousandSeparator="' + frxStrToXML(FDisplayFormat.FThousandSeparator) + '"';
  if FDisplayFormat.FFormatStr <> m.FDisplayFormat.FFormatStr then
    Result := Result + ' DisplayFormat.FormatStr="' + frxStrToXML(FDisplayFormat.FFormatStr) + '"';

  if FFirstParaBreak then
    Result := Result + ' FirstParaBreak="1"';
  if FLastParaBreak then
    Result := Result + ' LastParaBreak="1"';

  FFirstParaBreak := FLastParaBreak;
  FLastParaBreak := False;
end;

procedure TfrxCustomMemoView.BeforePrint;
begin
  inherited;
  if not IsDataField then
    FTempMemo := FMemo.Text;
end;

procedure TfrxCustomMemoView.AfterPrint;
begin
  if not IsDataField then
    FMemo.Text := FTempMemo;
  inherited;
end;

procedure TfrxCustomMemoView.GetData;
var
  i, j: Integer;
  s, s1, s2, dc1, dc2: WideString;
  ThLocale: Cardinal;
  LocCharset: Boolean;
begin
  inherited;
  ThLocale := 0;
  LocCharset := ((Font.Charset <> DEFAULT_CHARSET) and  not FUseDefaultCharset);
  if IsDataField then
  begin
    if DataSet.IsBlobField(DataField) then
    begin
      {$IFNDEF FPC}
      if LocCharset then
      begin
        ThLocale := GetThreadLocale;
        SetThreadLocale(GetLocalByCharSet(Font.Charset));
      end;
      {$ENDIF}
      DataSet.AssignBlobTo(DataField, FMemo);
      {$IFNDEF FPC}
      if LocCharset then
        SetThreadLocale(ThLocale);
      {$ENDIF}
    end
    else
    begin
      FValue := DataSet.Value[DataField];
      if FDisplayFormat.Kind = fkText then
      begin
        if LocCharset then
          FMemo.Text := AnsiToUnicode(AnsiString(DataSet.DisplayText[DataField]), Font.Charset) else
          FMemo.Text := DataSet.DisplayText[DataField];
      end
      else FMemo.Text := FormatData(FValue);
      if FHideZeros and (TVarData(FValue).VType <> varString) and
      {$IFDEF Delphi12}(TVarData(FValue).VType <> varUString) and{$ENDIF}
        (TVarData(FValue).VType <> varOleStr) and (FValue = 0) then
        FMemo.Text := '';
    end;
  end
  else if AllowExpressions then
  begin
    s := FMemo.Text;
    i := 1;
    dc1 := FExpressionDelimiters;
    dc2 := Copy(dc1, Pos(',', dc1) + 1, 255);
    dc1 := Copy(dc1, 1, Pos(',', dc1) - 1);

    if Pos(dc1, s) <> 0 then
    begin
      repeat
        while (i < Length(s)) and (Copy(s, i, Length(dc1)) <> dc1) do Inc(i);

        s1 := frxGetBrackedVariableW(s, dc1, dc2, i, j);
        if i <> j then
        begin
          Delete(s, i, j - i + 1);
          s2 := CalcAndFormat(s1);
          Insert(s2, s, i);
          Inc(i, Length(s2));
          j := 0;
        end;
      until i = j;

      FMemo.Text := s;
    end;
  end;
  
  Report.LocalValue := FValue;
  FHighlight.Active := False;
  if FHighlight.Condition <> '' then
    FHighlight.Active := Report.Calc(FHighlight.Condition);

  if FSuppressRepeated then
  begin
    if FLastValue = FMemo.Text then
      FMemo.Text := '' else
      FLastValue := FMemo.Text;
  end;

  if FFlowTo <> nil then
  begin
    InitPart;
    DrawPart;
    FFlowTo.Text := FPartMemo;
    FFlowTo.AllowExpressions := False;
  end;
end;

procedure TfrxCustomMemoView.ResetSuppress;
begin
  FLastValue := '';
end;

function TfrxCustomMemoView.CalcAndFormat(const Expr: WideString): WideString;
var
  i: Integer;
  ExprStr, FormatStr: WideString;
  Format: TfrxFormat;
begin
  Result := '';
  Format := nil;
  i := Pos(WideString(' #'), Expr);
  if i <> 0 then
  begin
    ExprStr := Copy(Expr, 1, i - 1);
    FormatStr := Copy(Expr, i + 2, Length(Expr) - i - 1);
    if Pos(')', FormatStr) = 0 then
    begin
      Format := TfrxFormat.Create;

{$IFDEF Delphi12}
      if CharInSet(FormatStr[1], [WideChar('N'), WideChar('n')]) then
{$ELSE}
      if FormatStr[1] in [WideChar('N'), WideChar('n')] then
{$ENDIF}
      begin
        Format.Kind := fkNumeric;
        for i := 1 to Length(FormatStr) do
{$IFDEF Delphi12}
          if CharInSet(FormatStr[i], [WideChar(','), WideChar('.'), WideChar('-')]) then
{$ELSE}
          if FormatStr[i] in [WideChar(','), WideChar('.'), WideChar('-')] then
{$ENDIF}
          begin
            Format.DecimalSeparator := FormatStr[i];
            FormatStr[i] := '.';
          end;
      end
{$IFDEF Delphi12}
      else if  CharInSet(FormatStr[1], [WideChar('D'), WideChar('T'), WideChar('d'), WideChar('t')]) then
{$ELSE}
      else if FormatStr[1] in [WideChar('D'), WideChar('T'), WideChar('d'), WideChar('t')] then
{$ENDIF}
        Format.Kind := fkDateTime
{$IFDEF Delphi12}
      else if CharInSet(FormatStr[1], [WideChar('B'), WideChar('b')]) then
{$ELSE}
      else if FormatStr[1] in [WideChar('B'), WideChar('b')] then
{$ENDIF}
        Format.Kind := fkBoolean;

      Format.FormatStr := Copy(FormatStr, 2, 255);
    end
    else
      ExprStr := Expr;
  end
  else
    ExprStr := Expr;

  try
    if CompareText(ExprStr, 'TOTALPAGES#') = 0 then
      FValue := '[TotalPages#]'
    else if CompareText(ExprStr, 'COPYNAME#') = 0 then
      FValue := '[CopyName#]'
    else
    begin
    if (Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset then
      FValue := Report.Calc(String(_UnicodeToAnsi(ExprStr, Font.Charset))) else
      FValue := Report.Calc(ExprStr)
    end;
    if FHideZeros and (TVarData(FValue).VType <> varString) and
      (TVarData(FValue).VType <> varOleStr){$IFDEF Delphi12} and (TVarData(FValue).VType <> varUString){$ENDIF}  and (FValue = 0) then
      Result := '' else
      Result := FormatData(FValue, Format);
  finally
    if Format <> nil then
      Format.Free;
  end;
end;

function TfrxCustomMemoView.FormatData(const Value: Variant;
  AFormat: TfrxFormat = nil): WideString;
var
  i, DecSepPos: Integer;
  LocCharset: Boolean;
begin
  DecSepPos := 0;
  LocCharset := ((Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset);
  if AFormat = nil then
    AFormat := FDisplayFormat;
  if VarIsNull(Value) then
    Result := ''
  else if AFormat.Kind = fkText then
    if LocCharset then
      Result := AnsiToUnicode(AnsiString(VarToStr(Value)), Font.Charset)
    else Result := VarToWideStr(Value)
  else
  try
    case AFormat.Kind of
      fkNumeric:
        begin
          if (Pos('#', AFormat.FormatStr) <> 0) or (Pos('0', AFormat.FormatStr) = 1) then
            Result := FormatFloat(AFormat.FormatStr, Extended(Value))
          else if (Pos('d', AFormat.FormatStr) <> 0) or (Pos('u', AFormat.FormatStr) <> 0) then
            Result := Format(AFormat.FormatStr, [Integer(Value)])
          else
            Result := Format(AFormat.FormatStr, [Extended(Value)]);
          if (Length(AFormat.DecimalSeparator) = 1) and
{$IFDEF Delphi16}
                  (FormatSettings.DecimalSeparator <> AFormat.DecimalSeparator[1]) then
            for i := Length(Result) downto 1 do
              if Result[i] = WideChar(FormatSettings.DecimalSeparator) then
{$ELSE}
                  (DecimalSeparator <> AFormat.DecimalSeparator[1]) then
            for i := Length(Result) downto 1 do
              if Result[i] = WideChar(DecimalSeparator) then
{$ENDIF}

              begin
                DecSepPos := i; // save dec seporator pos
                break;
              end;

          if (Length(AFormat.ThousandSeparator) = 1) and
{$IFDEF Delphi16}
            (FormatSettings.ThousandSeparator <> AFormat.ThousandSeparator[1]) then
            for i := 1 to Length(Result) do
              if Result[i] = WideChar(FormatSettings.ThousandSeparator) then
                Result[i] := WideChar(AFormat.ThousandSeparator[1]);
{$ELSE}
            (ThousandSeparator <> AFormat.ThousandSeparator[1]) then
            for i := 1 to Length(Result) do
              if Result[i] = WideChar(ThousandSeparator) then
                Result[i] := WideChar(AFormat.ThousandSeparator[1]);
{$ENDIF}

          if DecSepPos > 0 then // replace dec seporator
            Result[DecSepPos] := WideChar(AFormat.DecimalSeparator[1]);
        end;

      fkDateTime:
        Result := FormatDateTime(AFormat.FormatStr, Value);

      fkBoolean:
        if Value = True then
           Result := Copy(AFormat.FormatStr, Pos(',', AFormat.FormatStr) + 1, 255) else
           Result := Copy(AFormat.FormatStr, 1, Pos(',', AFormat.FormatStr) - 1);
      else
        Result := VarToWideStr(Value)
    end;
  except
    if LocCharset then
      Result := AnsiToUnicode(AnsiString(VarToStr(Value)), Font.Charset)
    else Result := VarToWideStr(Value)
  end;
end;

function TfrxCustomMemoView.GetComponentText: String;
var
  i: Integer;
begin
  Result := FMemo.Text;
  if FAllowExpressions then   { extract TOTALPAGES macro if any }
  begin
    i := Pos('[TOTALPAGES]', UpperCase(Result));
    if i <> 0 then
    begin
      Delete(Result, i, 12);
      Insert(IntToStr(FTotalPages), Result, i);
    end;
  end;
end;

procedure TfrxCustomMemoView.ApplyStyle(Style: TfrxStyleItem);
begin
  if Style <> nil then
  begin
    Color := Style.Color;
    Font := Style.Font;
    Frame := Style.Frame;
  end;
end;

function TfrxCustomMemoView.WrapText(WrapWords: Boolean): WideString;
var
  TempBMP: TBitmap;
  FDrawText: TfrxDrawText;
begin
  Result := '';
  TempBMP := TBitmap.Create;
  if Report <> nil then
    FDrawText := Report.FDrawText else
    FDrawText := frxDrawText;

  FDrawText.Lock;
  try
    SetDrawParams(TempBMP.Canvas, 1, 1, 0, 0);
    if WrapWords then
      Result := FDrawText.WrappedText
    else
      Result := FDrawText.DeleteTags(Text);
  finally
    FDrawText.Unlock;
    TempBMP.Free;
  end;
end;

procedure TfrxCustomMemoView.ExtractMacros;

{$IFNDEF DELPHI12}
function PosExW(const SubStr, S: WideString; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;
{$ENDIF}
var
  s, s1: WideString;
  j, i, slen: Integer;
  bChanged: Boolean;
begin
  if FAllowExpressions then
  begin
    s := FMemo.Text;
    bChanged := False;
    
    i := Pos('[TOTALPAGES#]', UpperCase(s));
    //if i <> 0 then
    while (i > 0) do
    begin
      Delete(s, i, 13);
      Insert(IntToStr(FTotalPages), s, i);
{$IFNDEF DELPHI12}
      i := PosExW('[TOTALPAGES#]', UpperCase(s), i);
{$ELSE}
      i := PosEx('[TOTALPAGES#]', UpperCase(s), i);
{$ENDIF}
     bChanged := True;
    end;

    i := Pos('[COPYNAME#]', UpperCase(s));
    //if i <> 0 then
    while (i > 0) do
    begin
      j := frxGlobalVariables.IndexOf('CopyName' + IntToStr(FCopyNo));
      if j <> -1 then
        s1 := VarToStr(frxGlobalVariables.Items[j].Value)
      else
        s1 := '';
      Delete(s, i, 11);
      Insert(s1, s, i);
      slen := length(s1);
{$IFNDEF DELPHI12}
      i := PosExW('[COPYNAME#]', UpperCase(s), i + slen);
{$ELSE}
      i := PosEx('[COPYNAME#]', UpperCase(s), i + slen);
{$ENDIF}
      bChanged := True;
    end;

    if bChanged then FMemo.Text := s;
  end;
end;

{$IFDEF FR_COM}
function TfrxCustomMemoView.IfrxCustomMemoView_Get_Text(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(FMemo.Text);
  Result := 0;
end;

function TfrxCustomMemoView.IfrxCustomMemoView_Set_Text(const Value: WideString): HResult; stdcall;
begin
  FMemo.Text := String(Value);
  Result := 0;
end;
{$ENDIF}

{$IFDEF FR_COM}
{ TfrxMemoView }
function TfrxMemoView.Get_AutoWidth(out Value: WordBool): HResult; stdcall;
begin
  Value := AutoWidth;
  Result := S_OK;
end;

function TfrxMemoView.Set_AutoWidth(Value: WordBool): HResult; stdcall;
begin
  AutoWidth := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_AllowExpressions(out Value: WordBool): HResult; stdcall;
begin
  Value := AllowExpressions;
  Result := S_OK;
end;

function TfrxMemoView.Set_AllowExpressions(Value: WordBool): HResult; stdcall;
begin
  AllowExpressions := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_AllowHTMLTags(out Value: WordBool): HResult; stdcall;
begin
  Value := AllowHTMLTags;
  Result := S_OK;
end;

function TfrxMemoView.Set_AllowHTMLTags(Value: WordBool): HResult; stdcall;
begin
  AllowHTMLTags := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_BrushStyle(out Value: frxBrushStyle): HResult; stdcall;
begin
  Value := frxBrushStyle(BrushStyle);
  Result := S_OK;
end;

function TfrxMemoView.Set_BrushStyle(Value: frxBrushStyle): HResult; stdcall;
begin
  BrushStyle := TBrushStyle(Value);
  Result := S_OK;
end;

function TfrxMemoView.Get_CharSpacing(out Value: Double): HResult; stdcall;
begin
  Value := CharSpacing;
  Result := S_OK;
end;

function TfrxMemoView.Set_CharSpacing(Value: Double): HResult; stdcall;
begin
  CharSpacing := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Clipped(out Value: WordBool): HResult; stdcall;
begin
  Value := Clipped;
  Result := S_OK;
end;

function TfrxMemoView.Set_Clipped(Value: WordBool): HResult; stdcall;
begin
  Clipped := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Color(out Value: Integer): HResult; stdcall;
begin
  Value := Color;
  Result := S_OK;
end;

function TfrxMemoView.Set_Color(Value: Integer): HResult; stdcall;
begin
  Color := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_DataField(out Value: WideString): HResult; stdcall;
begin
  Value := DataField;
  Result := S_OK;
end;

function TfrxMemoView.Set_DataField(const Value: WideString): HResult; stdcall;
begin
  DataField := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
begin
  Value := DataSet as IfrxDataSet;
  Result := S_OK;
end;

function TfrxMemoView.Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  Result := Value.QueryInterface( {IfrxComponentSelf} IInterfaceComponentReference, idsp);
  if Result = S_OK then
    DataSet := TfrxDataSet(idsp.GetComponent{Get_Object});
end;

function TfrxMemoView.Get_DataSetName(out Value: WideString): HResult; stdcall;
begin
  Value := DataSetName;
  Result := S_OK;
end;

function TfrxMemoView.Set_DataSetName(const Value: WideString): HResult; stdcall;
begin
  DataSetName := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_DisplayFormat(out Value: IfrxDisplayFormat): HResult; stdcall;
begin
  Value := DisplayFormat as IfrxDisplayFormat;
  Result := S_OK;
end;

function TfrxMemoView.Get_ExpressionDelimiters(out Value: WideString): HResult; stdcall;
begin
  Value := ExpressionDelimiters;
  Result := S_OK;
end;

function TfrxMemoView.Set_ExpressionDelimiters(const Value: WideString): HResult; stdcall;
begin
  ExpressionDelimiters := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_FlowTo(out Value: IfrxCustomMemoView): HResult; stdcall;
begin
  Value := FlowTo as IfrxCustomMemoView;
  Result := S_OK;
end;

function TfrxMemoView.Set_FlowTo(const Value: IfrxCustomMemoView): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  Result := Value.QueryInterface({IfrxComponentSelf} IInterfaceComponentReference, idsp);
  if Result = S_OK then
    FlowTo := TfrxCustomMemoView(idsp.GetComponent{Get_Object});
end;

function TfrxMemoView.Get_Font(out Value: IfrxFont): HResult; stdcall;
begin
  Result := S_OK;
  Value := FFont as IfrxFont;
  Value._AddRef();
end;

function TfrxMemoView.Get_Frame(out Value: IfrxFrame): HResult; stdcall;
begin
  Value := Frame as IfrxFrame;
  Result := S_OK;
end;

function TfrxMemoView.Get_GapX(out Value: Double): HResult; stdcall;
begin
  Value := GapX;
  Result := S_OK;
end;

function TfrxMemoView.Set_GapX(Value: Double): HResult; stdcall;
begin
  GapX := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_GapY(out Value: Double): HResult; stdcall;
begin
  Value := GapY;
  Result := S_OK;
end;

function TfrxMemoView.Set_GapY(Value: Double): HResult; stdcall;
begin
  GapY := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_HAlign(out Value: frxHAlign): HResult; stdcall;
begin
  Value := TOleEnum(HAlign);
  Result := S_OK;
end;

function TfrxMemoView.Set_HAlign(Value: frxHAlign): HResult; stdcall;
begin
  HAlign := TfrxHAlign(Value);
  Result := S_OK;
end;

function TfrxMemoView.Get_HideZeros(out Value: WordBool): HResult; stdcall;
begin
  Value := HideZeros;
  Result := S_OK;
end;

function TfrxMemoView.Set_HideZeros(Value: WordBool): HResult; stdcall;
begin
  HideZeros := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Highlight(out Value: IfrxHighlight): HResult; stdcall;
begin
  Value := Highlight as IfrxHighlight;
  Result := S_OK;
end;

function TfrxMemoView.Get_LineSpacing(out Value: Double): HResult; stdcall;
begin
  Value := LineSpacing;
  Result := S_OK;
end;

function TfrxMemoView.Set_LineSpacing(Value: Double): HResult; stdcall;
begin
  LineSpacing := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Memo(out Value: WideString): HResult; stdcall;
begin
  Value := Memo.Text;
  Result := S_OK;
end;

function TfrxMemoView.Set_Memo(const Value: WideString): HResult; stdcall;
begin
  Memo.Text := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_ParagraphGap(out Value: Double): HResult; stdcall;
begin
  Value := ParagraphGap;
  Result := S_OK;
end;

function TfrxMemoView.Set_ParagraphGap(Value: Double): HResult; stdcall;
begin
  ParagraphGap := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_ParentFont(out Value: WordBool): HResult; stdcall;
begin
  Value := ParentFont;
  Result := S_OK;
end;

function TfrxMemoView.Set_ParentFont(Value: WordBool): HResult; stdcall;
begin
  ParentFont := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Rotation(out Value: Integer): HResult; stdcall;
begin
  Value := Rotation;
  Result := S_OK;
end;

function TfrxMemoView.Set_Rotation(Value: Integer): HResult; stdcall;
begin
  Rotation := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_RTLReading(out Value: WordBool): HResult; stdcall;
begin
  Value := RTLReading;
  Result := S_OK;
end;

function TfrxMemoView.Set_RTLReading(Value: WordBool): HResult; stdcall;
begin
  RTLReading := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Style(out Value: WideString): HResult; stdcall;
begin
  Value := Style;
  Result := S_OK;
end;

function TfrxMemoView.Set_Style(const Value: WideString): HResult; stdcall;
begin
  Style := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_SuppressRepeated(out Value: WordBool): HResult; stdcall;
begin
  Value := SuppressRepeated;
  Result := S_OK;
end;

function TfrxMemoView.Set_SuppressRepeated(Value: WordBool): HResult; stdcall;
begin
  SuppressRepeated := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_Underlines(out Value: WordBool): HResult; stdcall;
begin
  Value := Underlines;
  Result := S_OK;
end;

function TfrxMemoView.Set_Underlines(Value: WordBool): HResult; stdcall;
begin
  Underlines := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_WordBreak(out Value: WordBool): HResult; stdcall;
begin
  Value := WordBreak;
  Result := S_OK;
end;

function TfrxMemoView.Set_WordBreak(Value: WordBool): HResult; stdcall;
begin
  WordBreak := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_WordWrap(out Value: WordBool): HResult; stdcall;
begin
  Value := WordWrap;
  Result := S_OK;
end;

function TfrxMemoView.Set_WordWrap(Value: WordBool): HResult; stdcall;
begin
  WordWrap := Value;
  Result := S_OK;
end;

function TfrxMemoView.Get_VAlign(out Value: frxVAlign): HResult; stdcall;
begin
  Value := TOleEnum(VAlign);
  Result := S_OK;
end;

function TfrxMemoView.Set_VAlign(Value: frxVAlign): HResult; stdcall;
begin
  VAlign := TfrxVAlign(Value);
  Result := S_OK;
end;
{$ENDIF}

{ TfrxSysMemoView }

class function TfrxSysMemoView.GetDescription: String;
begin
  Result := frxResources.Get('obSysText');
end;


{ TfrxCustomLineView }

constructor TfrxCustomLineView.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csDefaultDiff];
  FArrowWidth := 5;
  FArrowLength := 20;
end;

constructor TfrxCustomLineView.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  FDiagonal := Flags <> 0;
  FArrowEnd := Flags in [2, 4];
  FArrowStart := Flags in [3, 4];
end;

procedure TfrxCustomLineView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  if not FDiagonal then
  begin
    if Width > Height then
    begin
      Height := 0;
      Frame.Typ := [ftTop];
    end
    else
    begin
      Width := 0;
      Frame.Typ := [ftLeft];
    end;
  end;

  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  if not FDiagonal then
  begin
    DrawFrame;
    if FArrowStart then
      DrawArrow(FX1, FY1, FX, FY);
    if FArrowEnd then
      DrawArrow(FX, FY, FX1, FY1);
  end
  else
    DrawDiagonalLine;
end;

procedure TfrxCustomLineView.DrawArrow(x1, y1, x2, y2: Extended);
var
  k1, a, b, c, D: Double;
  xp, yp, x3, y3, x4, y4, wd, ld: Extended;
begin
  wd := FArrowWidth * FScaleX;
  ld := FArrowLength * FScaleX;
  if abs(x2 - x1) > 8 then
  begin
    k1 := (y2 - y1) / (x2 - x1);
    a := Sqr(k1) + 1;
    b := 2 * (k1 * ((x2 * y1 - x1 * y2) / (x2 - x1) - y2) - x2);
    c := Sqr(x2) + Sqr(y2) - Sqr(ld) + Sqr((x2 * y1 - x1 * y2) / (x2 - x1)) -
      2 * y2 * (x2 * y1 - x1 * y2) / (x2 - x1);
    D := Sqr(b) - 4 * a * c;
    xp := (-b + Sqrt(D)) / (2 * a);
    if (xp > x1) and (xp > x2) or (xp < x1) and (xp < x2) then
      xp := (-b - Sqrt(D)) / (2 * a);
    yp := xp * k1 + (x2 * y1 - x1 * y2) / (x2 - x1);
    if y2 <> y1 then
    begin
      x3 := xp + wd * sin(ArcTan(k1));
      y3 := yp - wd * cos(ArcTan(k1));
      x4 := xp - wd * sin(ArcTan(k1));
      y4 := yp + wd * cos(ArcTan(k1));
    end
    else
    begin
      x3 := xp;
      y3 := yp - wd;
      x4 := xp;
      y4 := yp + wd;
    end;
  end
  else
  begin
    xp := x2;
    yp := y2 - ld;
    if (yp > y1) and (yp > y2) or (yp < y1) and (yp < y2) then
      yp := y2 + ld;
    x3 := xp - wd;
    y3 := yp;
    x4 := xp + wd;
    y4 := yp;
  end;

  if FArrowSolid then
  begin
    FCanvas.Brush.Color := Frame.Color;
    FCanvas.Polygon([Point(Round(x2), Round(y2)),
      Point(Round(x3), Round(y3)), Point(Round(x4), Round(y4)),
      Point(Round(x2), Round(y2))])
  end
  else
  begin
    FCanvas.Pen.Width := Round(FFrame.Width * FScaleX);
    FCanvas.Polyline([Point(Round(x3), Round(y3)),
      Point(Round(x2), Round(y2)), Point(Round(x4), Round(y4))]);
  end;
end;

procedure TfrxCustomLineView.DrawDiagonalLine;
begin
  if (Frame.Color = clNone) or (Frame.Width = 0) then exit;
  with FCanvas do
  begin
    Brush.Style := bsSolid;
    if Color = clNone then
      Brush.Style := bsClear else
      Brush.Color := Color;
    Pen.Color := Self.Frame.Color;
    Pen.Width := 1;
    if Self.Frame.Style <> fsDouble then
      Pen.Style := TPenStyle(Self.Frame.Style) else
      Pen.Style := psSolid;

    DrawLine(FX, FY, FX1, FY1, FFrameWidth);

    if FArrowStart then
      DrawArrow(FX1, FY1, FX, FY);
    if FArrowEnd then
      DrawArrow(FX, FY, FX1, FY1);
  end;
end;


{ TfrxLineView }

class function TfrxLineView.GetDescription: String;
begin
  Result := frxResources.Get('obLine');
end;

{$IFDEF FR_COM}
function TfrxLineView.Get_ArrowEnd(out Value: WordBool): HResult; stdcall;
begin
  Value := ArrowEnd;
  Result := S_OK;
end;

function TfrxLineView.Set_ArrowEnd(Value: WordBool): HResult; stdcall;
begin
  ArrowEnd := Value;
  Result := S_OK;
end;

function TfrxLineView.Get_ArrowLength(out Value: Integer): HResult; stdcall;
begin
  Value := ArrowLength;
  Result := S_OK;
end;

function TfrxLineView.Set_ArrowLength(Value: Integer): HResult; stdcall;
begin
  ArrowLength := Value;
  Result := S_OK;
end;

function TfrxLineView.Get_ArrowSolid(out Value: WordBool): HResult; stdcall;
begin
  Value := ArrowSolid;
  Result := S_OK;
end;

function TfrxLineView.Set_ArrowSolid(Value: WordBool): HResult; stdcall;
begin
  ArrowSolid := Value;
  Result := S_OK;
end;

function TfrxLineView.Get_ArrowStart(out Value: WordBool): HResult; stdcall;
begin
  Value := ArrowStart;
  Result := S_OK;
end;

function TfrxLineView.Set_ArrowStart(Value: WordBool): HResult; stdcall;
begin
  ArrowStart := Value;
  Result := S_OK;
end;

function TfrxLineView.Get_ArrowWidth(out Value: Integer): HResult; stdcall;
begin
  Value := ArrowWidth;
  Result := S_OK;
end;

function TfrxLineView.Set_ArrowWidth(Value: Integer): HResult; stdcall;
begin
  ArrowWidth := Value;
  Result := S_OK;
end;

function TfrxLineView.Get_Frame(out Value: IfrxFrame): HResult; stdcall;
begin
  Value := Frame as IfrxFrame;
  Result := S_OK;
end;

function TfrxLineView.Get_Diagonal(out Value: WordBool): HResult; stdcall;
begin
  Value := Diagonal;
  Result := S_OK;
end;

function TfrxLineView.Set_Diagonal(Value: WordBool): HResult; stdcall;
begin
  Diagonal := Value;
  Result := S_OK;
end;
{$ENDIF}


{ TfrxPictureView }

constructor TfrxPictureView.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csDefaultDiff];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FKeepAspectRatio := True;
  FStretched := True;
  FColor := clWhite;
  FTransparentColor := clWhite;
  FIsPictureStored := True;
end;

destructor TfrxPictureView.Destroy;
begin
  FPicture.Free;
  inherited;
end;

class function TfrxPictureView.GetDescription: String;
begin
  Result := frxResources.Get('obPicture');
end;

procedure TfrxPictureView.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TfrxPictureView.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  if FTransparent then
    FColor := clNone
  else FColor := clWhite;
end;

procedure TfrxPictureView.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize and not (FPicture.Graphic = nil) then
  begin
    FWidth := FPicture.Width;
    FHeight := FPicture.Height;
  end;
end;

procedure TfrxPictureView.PictureChanged(Sender: TObject);
begin
  AutoSize := FAutoSize;
  FPictureChanged := True;
end;

procedure TfrxPictureView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  r: TRect;
  kx, ky: Extended;
  rgn: HRGN;

  procedure PrintGraphic(Canvas: TCanvas; DestRect: TRect; aGraph: TGraphic);
  begin
    frxDrawGraphic(Canvas, DestRect, aGraph, IsPrinting, HightQuality, FTransparent, FTransparentColor);
  end;

begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);

  with Canvas do
  begin
    DrawBackground;

    r := Rect(FX, FY, FX1, FY1);

    if (FPicture.Graphic = nil) or FPicture.Graphic.Empty then
    begin
      if IsDesigning then
        frxResources.ObjectImages.Draw(Canvas, FX + 1, FY + 2, 3);
    end
    else
    begin
      if FStretched then
      begin
        if FKeepAspectRatio then
        begin
          kx := FDX / FPicture.Width;
          ky := FDY / FPicture.Height;
          if kx < ky then
            r.Bottom := r.Top + Round(FPicture.Height * kx) else
            r.Right := r.Left + Round(FPicture.Width * ky);

          if FCenter then
            OffsetRect(r, (FDX - (r.Right - r.Left)) div 2,
                          (FDY - (r.Bottom - r.Top)) div 2);
        end;

        PrintGraphic(Canvas, r, FPicture.Graphic);
      end
      else
      begin
        rgn := CreateRectRgn(0, 0, 10000, 10000);
        GetClipRgn(Canvas.Handle, rgn);
        IntersectClipRect(Canvas.Handle,
          Round(FX),
          Round(FY),
          Round(FX1),
          Round(FY1));

        if FCenter then
          OffsetRect(r, (FDX - Round(ScaleX * FPicture.Width)) div 2,
                        (FDY - Round(ScaleY * FPicture.Height)) div 2);
        r.Right := r.Left + Round(FPicture.Width * ScaleX);
        r.Bottom := r.Top + Round(FPicture.Height * ScaleY);
        PrintGraphic(Canvas, r, Picture.Graphic);

        SelectClipRgn(Canvas.Handle, rgn);
        DeleteObject(rgn);
      end;
    end;

    DrawFrame;
  end;
end;

function TfrxPictureView.Diff(AComponent: TfrxComponent): String;
begin
  if FPictureChanged then
  begin
    Report.PreviewPages.AddPicture(Self);
    FPictureChanged := False;
  end;

  Result := ' ' + inherited Diff(AComponent) + ' ImageIndex="' +
    IntToStr(FImageIndex) + '"';
  if Transparent then
    Result := Result + ' Transparent="' + frxValueToXML(FTransparent) + '"';
  if TransparentColor <> clWhite then
    Result := Result + ' TransparentColor="' + intToStr(FTransparentColor) + '"';
end;

{$IFDEF FR_COM}
function TfrxPictureView.Get_Picture(out Value: OLE_HANDLE): HResult; stdcall;
begin
  Value := FPicture.Bitmap.Handle;
  Result := S_OK;
end;

function TfrxPictureView.Set_Picture(Value: OLE_HANDLE): HResult; stdcall;
begin
  FPicture.Bitmap.Handle := Value;
  Result := S_OK;
end;

function TfrxPictureView.Get_Metafile(out Value: OLE_HANDLE): HResult; stdcall;
begin
  Value := FPicture.Metafile.Handle;
  Result := S_OK;
end;

function TfrxPictureView.Set_Metafile(Value: OLE_HANDLE): HResult; stdcall;
begin
  FPicture.Metafile.Handle := Value;
  Result := S_OK;
end;

function TfrxPictureView.LoadViewFromStream(const Stream: IUnknown): HResult; stdcall;
var
  ComStream: IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  try
    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      LoadPictureFromStream(OleStream);
      OleStream.Free;
      ComStream := nil;
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        LoadPictureFromStream(ClrStream);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxPictureView.SaveViewToStream(const Stream: IUnknown): HResult; stdcall;
var
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  try
    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      FPicture.Bitmap.SaveToStream(OleStream);
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        FPicture.Bitmap.SaveToStream(ClrStream);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxPictureView.Get_FileLink(out Value: WideString): HResult; stdcall;
begin
  Value := FileLink;
  Result := S_OK;
end;

function TfrxPictureView.Set_FileLink(const Value: WideString): HResult; stdcall;
begin
  FileLink := Value;
  Result := S_OK;
end;

{$ENDIF}

const
  WMFKey = Integer($9AC6CDD7);
  WMFWord = $CDD7;
  rc3_StockIcon = 0;
  rc3_Icon = 1;
  rc3_Cursor = 2;

type
  TGraphicHeader = record
    Count: Word;
    HType: Word;
    Size: Longint;
  end;

  TMetafileHeader = packed record
    Key: Longint;
    Handle: SmallInt;
    Box: TSmallRect;
    Inch: Word;
    Reserved: Longint;
    CheckSum: Word;
  end;

  TCursorOrIcon = packed record
    Reserved: Word;
    wType: Word;
    Count: Word;
  end;

const
  OriginalPngHeader: array[0..7] of AnsiChar = (#137, #80, #78, #71, #13, #10, #26, #10);

function TfrxPictureView.LoadPictureFromStream(s: TStream; ResetStreamPos: Boolean): Hresult;
var
  pos: Integer;
  Header: TGraphicHeader;
  BMPHeader: TBitmapFileHeader;
{$IFDEF JPEG}
  JPEGHeader: array[0..1] of Byte;
{$ENDIF}
{$IFDEF PNG}
  PNGHeader: array[0..7] of AnsiChar;
{$ENDIF}
  {$IFNDEF FPC}
  EMFHeader: TEnhMetaHeader;
  {$ENDIF}
  WMFHeader: TMetafileHeader;
  ICOHeader: TCursorOrIcon;
  NewGraphic: TGraphic;
  bOK : Boolean;
begin
{$IFDEF FPC}
  Result := E_INVALIDARG;
  if ResetStreamPos then
    pos := 0
  else
    pos := s.Position;
  s.Position := pos;
  try
    FPicture.LoadFromStream(S);
  except
    on E:Exception do
    begin
      FPicture.Assign(nil);
      {$IFDEF DEBUGFR4}
      DebugLn('Error in TfrxPictureView.LoadPictureFromStream: '+E.Message);
      {$ENDIF}
    end;
  end;

  if FPicture.Graphic = nil then
    Result := E_INVALIDARG
  else
    Result := S_OK;
{$ELSE}

  NewGraphic := nil;
  if ResetStreamPos then
    pos := 0
  else
    pos := s.Position;

  s.Position := pos;

  if s.Size > 0 then
  begin
    // skip Delphi blob-image header
    if s.Size >= SizeOf(TGraphicHeader) then
    begin
      s.Read(Header, SizeOf(Header));
      if (Header.Count <> 1) or (Header.HType <> $0100) or
        (Header.Size <> s.Size - SizeOf(Header)) then
          s.Position := pos;
    end;
    pos := s.Position;

    bOK := False;

    if (s.Size-pos) >= SizeOf(BMPHeader) then
    begin
      // try bmp header
      s.ReadBuffer(BMPHeader, SizeOf(BMPHeader));
      s.Position := pos;
      if BMPHeader.bfType = $4D42 then
      begin
        NewGraphic := TBitmap.Create;
        bOK := True;
      end;
    end;

    {$IFDEF JPEG}
    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(JPEGHeader) then
      begin
        // try jpeg header
        s.ReadBuffer(JPEGHeader, SizeOf(JPEGHeader));
        s.Position := pos;
        if (JPEGHeader[0] = $FF) and (JPEGHeader[1] = $D8) then
        begin
          NewGraphic := TJPEGImage.Create;
          bOK := True;
        end;
      end;
    end;
    {$ENDIF}

    {$IFDEF PNG}
    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(PNGHeader) then
      begin
        // try png header
        s.ReadBuffer(PNGHeader, SizeOf(PNGHeader));
        s.Position := pos;
        if PNGHeader = OriginalPngHeader then
        begin
          NewGraphic := TPngObject.Create;
          bOK := True;
        end;
      end;
    end;
    {$ENDIF}

    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(WMFHeader) then
      begin
        // try wmf header
        s.ReadBuffer(WMFHeader, SizeOf(WMFHeader));
        s.Position := pos;
        if WMFHeader.Key = WMFKEY then
        begin
          NewGraphic := TMetafile.Create;
          bOK := True;
        end;
      end;
    end;

    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(EMFHeader) then
      begin
        // try emf header
        s.ReadBuffer(EMFHeader, SizeOf(EMFHeader));
        s.Position := pos;
        if EMFHeader.dSignature = ENHMETA_SIGNATURE then
        begin
          NewGraphic := TMetafile.Create;
          bOK := True;
        end;
      end;
    end;

    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(ICOHeader) then
      begin
        // try icon header
        s.ReadBuffer(ICOHeader, SizeOf(ICOHeader));
        s.Position := pos;
        if ICOHeader.wType in [RC3_STOCKICON, RC3_ICON] then
          NewGraphic := TIcon.Create;
      end;
    end;
  end;

  if NewGraphic <> nil then
  begin
    FPicture.Graphic := NewGraphic;
    NewGraphic.Free;
    FPicture.Graphic.LoadFromStream(s);
    Result := S_OK;
  end
  else
  begin
    FPicture.Assign(nil);
    Result := E_INVALIDARG;
  end;
// workaround pngimage bug
{$IFDEF PNG}
  if FPicture.Graphic is TPngObject then
    PictureChanged(nil);
{$ENDIF}
{$ENDIF} // fpc
end;

procedure TfrxPictureView.GetData;
var
  m: TMemoryStream;
  s: String;
begin
  inherited;
  if FFileLink <> '' then
  begin
    s := FFileLink;
    if Pos('[', s) <> 0 then
      ExpandVariables(s);
    if FileExists(s) then
      FPicture.LoadFromFile(s)
    else
      FPicture.Assign(nil);
  end
  else if IsDataField and DataSet.IsBlobField(DataField) then
  begin
    m := TMemoryStream.Create;
    try
      DataSet.AssignBlobTo(DataField, m);
      LoadPictureFromStream(m);
    finally
      m.Free;
    end;
  end;
end;


{ TfrxBand }

constructor TfrxBand.Create(AOwner: TComponent);
begin
  inherited;
  FSubBands := TList.Create;
  FOriginalObjectsCount := -1;
end;

destructor TfrxBand.Destroy;
begin
  FSubBands.Free;
  inherited;
end;

procedure TfrxBand.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FChild) then
    FChild := nil;
end;

procedure TfrxBand.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
end;

function TfrxBand.GetBandName: String;
begin
  Result := ClassName;
  Delete(Result, Pos('Tfrx', Result), 4);
  Delete(Result, Pos('Band', Result), 4);
end;

function TfrxBand.BandNumber: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to BND_COUNT - 1 do
    if Self is frxBands[i] then
      Result := i;
end;

class function TfrxBand.GetDescription: String;
begin
  Result := frxResources.Get('obBand');
end;

procedure TfrxBand.SetLeft(Value: Extended);
begin
  if Parent is TfrxDMPPage then
    Value := Round(Value / fr1CharX) * fr1CharX;
  inherited;
end;

procedure TfrxBand.SetTop(Value: Extended);
begin
  if Parent is TfrxDMPPage then
    Value := Round(Value / fr1CharY) * fr1CharY;
  inherited;
end;

procedure TfrxBand.SetVertical(const Value: Boolean);
begin
{$IFDEF RAD_ED}
  FVertical := False;
{$ELSE}
  FVertical := Value;
{$ENDIF}
end;

procedure TfrxBand.SetHeight(Value: Extended);
begin
  if Parent is TfrxDMPPage then
    Value := Round(Value / fr1CharY) * fr1CharY;
  inherited;
end;

procedure TfrxBand.SetChild(Value: TfrxChild);
var
  b: TfrxBand;
begin
  b := Value;
  while b <> nil do
  begin
    b := b.Child;
    if b = Self then
      raise Exception.Create(frxResources.Get('clCirRefNotAllow'));
  end;
  FChild := Value;
end;

{$IFDEF FR_COM}
function TfrxBand.IfrxBand_Get_AllowSplit(out Value: WordBool): HResult; stdcall;
begin
  Value := FAllowSplit;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_AllowSplit(Value: WordBool): HResult; stdcall;
begin
  FAllowSplit := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_KeepChild(out Value: WordBool): HResult; stdcall;
begin
  Value := FKeepChild;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_KeepChild(Value: WordBool): HResult; stdcall;
begin
  FKeepChild := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_OutlineText(out Value: WideString): HResult; stdcall;
begin
  Value := FOutlineText;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_OutlineText(const Value: WideString): HResult; stdcall;
begin
  FOutlineText := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_Overflow(out Value: WordBool): HResult; stdcall;
begin
  Value := FOverflow;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_Overflow(Value: WordBool): HResult; stdcall;
begin
  FOverflow := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_StartNewPage(out Value: WordBool): HResult; stdcall;
begin
  Value := FStartNewPage;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_StartNewPage(Value: WordBool): HResult; stdcall;
begin
  FStartNewPage := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_Stretched(out Value: WordBool): HResult; stdcall;
begin
  Value := FStretched;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_Stretched(Value: WordBool): HResult; stdcall;
begin
  FStretched := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_PrintChildIfInvisible(out Value: WordBool): HResult; stdcall;
begin
  Value := FPrintChildIfInvisible;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_PrintChildIfInvisible(Value: WordBool): HResult; stdcall;
begin
  FPrintChildIfInvisible := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_Vertical(out Value: WordBool): HResult; stdcall;
begin
  Value := FVertical;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Set_Vertical(Value: WordBool): HResult; stdcall;
begin
  FVertical := Value;
  Result := S_OK;
end;

function TfrxBand.IfrxBand_Get_BandName(out Value: WideString): HResult; stdcall;
begin
  Value := GetBandName;
  Result := S_OK;
end;

function TfrxBand.Get_Child(out Value: IfrxChild): HResult; stdcall;
begin
  Value := Child;
  Result := S_OK;
end;

function TfrxBand.Set_Child(const Value: IfrxChild): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  Result := Value.QueryInterface( {IfrxComponentSelf} IInterfaceComponentReference, idsp);
  if Result = S_OK then
    Child := TfrxChild(idsp.GetComponent {Get_Object});
end;

{ TfrxHeader }

function TfrxHeader.Get_ReprintOnNewPage(out Value: WordBool): HResult; stdcall;
begin
  Value := ReprintOnNewPage;
  Result := S_OK;
end;

function TfrxHeader.Set_ReprintOnNewPage(Value: WordBool): HResult; stdcall;
begin
  ReprintOnNewPage := Value;
  Result := S_OK;
end;

{ TfrxPageHeader }

function TfrxPageHeader.Get_PrintOnFirstPage(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintOnFirstPage;
  Result := S_OK;
end;

function TfrxPageHeader.Set_PrintOnFirstPage(Value: WordBool): HResult; stdcall;
begin
  PrintOnFirstPage := Value;
  Result := S_OK;
end;

{ TfrxPageFooter }

function TfrxPageFooter.Get_PrintOnFirstPage(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintOnFirstPage;
  Result := S_OK;
end;

function TfrxPageFooter.Set_PrintOnFirstPage(Value: WordBool): HResult; stdcall;
begin
  PrintOnFirstPage := Value;
  Result := S_OK;
end;

function TfrxPageFooter.Get_PrintOnLastPage(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintOnLastPage;
  Result := S_OK;
end;

function TfrxPageFooter.Set_PrintOnLastPage(Value: WordBool): HResult; stdcall;
begin
  PrintOnLastPage := Value;
  Result := S_OK;
end;

{ TfrxGroupHeader }

function TfrxGroupHeader.Get_Condition: WideString; safecall;
begin
  Result := Condition;
end;

procedure TfrxGroupHeader.Set_Condition(const Value: WideString); safecall;
begin
  Condition := Value;
end;

function TfrxGroupHeader.Get_KeepTogether: WordBool; safecall;
begin
  Result := KeepTogether;
end;

procedure TfrxGroupHeader.Set_KeepTogether(Value: WordBool); safecall;
begin
  KeepTogether := Value;
end;

function TfrxGroupHeader.Get_ReprintOnNewPage: WordBool; safecall;
begin
  Result := ReprintOnNewPage;
end;

procedure TfrxGroupHeader.Set_ReprintOnNewPage(Value: WordBool); safecall;
begin
  ReprintOnNewPage := Value;
end;

function TfrxGroupHeader.Get_LastValue: OleVariant; safecall;
begin
  Result := FLastValue;
end;

{ TfrxGroupFooter }

function TfrxGroupFooter.Get_HideIfSingledatarecord(out Value: WordBool): HResult; stdcall;
begin
  Value := HideIfSingledatarecord;
  Result := S_OK;
end;

function TfrxGroupFooter.Set_HideIfSingledatarecord(Value: WordBool): HResult; stdcall;
begin
  HideIfSingledatarecord := Value;
  Result := S_OK;
end;
{$ENDIF}
{ TfrxDataBand }

constructor TfrxDataBand.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF FPC}
  FDataSet := nil;
  FDataSetName := '';
{$ENDIF}
  FVirtualDataSet := TfrxUserDataSet.Create(nil);
  FVirtualDataSet.RangeEnd := reCount;
end;

destructor TfrxDataBand.Destroy;
begin
  FVirtualDataSet.Free;
  inherited;
end;

class function TfrxDataBand.GetDescription: String;
begin
  Result := frxResources.Get('obDataBand');
end;

procedure TfrxDataBand.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

procedure TfrxDataBand.SetCurColumn(Value: Integer);
begin
  if Value > FColumns then
    Value := 1;
  FCurColumn := Value;
  if FCurColumn = 1 then
    FMaxY := 0;
  FLeft := (FCurColumn - 1) * (FColumnWidth + FColumnGap);
end;

procedure TfrxDataBand.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxDataBand.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxDataBand.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxDataBand.SetRowCount(const Value: Integer);
begin
  FRowCount := Value;
  FVirtualDataSet.RangeEndCount := Value;
end;

{$IFDEF FR_COM}
function TfrxDataBand.Get_ColumnGap(out Value: Double): HResult; stdcall;
begin
  Value := ColumnGap;
  Result := S_OK;
end;

function TfrxDataBand.Set_ColumnGap(Value: Double): HResult; stdcall;
begin
  ColumnGap := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_ColumnWidth(out Value: Double): HResult; stdcall;
begin
  Value := ColumnWidth;
  Result := S_OK;
end;

function TfrxDataBand.Set_ColumnWidth(Value: Double): HResult; stdcall;
begin
  ColumnWidth := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_ColumnsCount(out Value: Integer): HResult; stdcall;
begin
  Value := Columns;
  Result := S_OK;
end;

function TfrxDataBand.Set_ColumnsCount(Value: Integer): HResult; stdcall;
begin
  Columns := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_CurrentColumn(out Value: Integer): HResult; stdcall;
begin
  Value := CurColumn;
  Result := S_OK;
end;

function TfrxDataBand.Set_CurrentColumn(Value: Integer): HResult; stdcall;
begin
  CurColumn := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
begin
  Value := DataSet as IfrxDataSet;
  Result := S_OK;
end;

function TfrxDataBand.Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  Result := Value.QueryInterface( {IfrxComponentSelf} IInterfaceComponentReference, idsp);
  if Result = S_OK then
    DataSet := TfrxDataSet(idsp.GetComponent {Get_Object} );
end;

function TfrxDataBand.Get_FooterAfterEach(out Value: WordBool): HResult; stdcall;
begin
  Value := FooterAfterEach;
  Result := S_OK;
end;

function TfrxDataBand.Set_FooterAfterEach(Value: WordBool): HResult; stdcall;
begin
  FooterAfterEach := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_KeepFooter(out Value: WordBool): HResult; stdcall;
begin
  Value := KeepFooter;
  Result := S_OK;
end;

function TfrxDataBand.Set_KeepFooter(Value: WordBool): HResult; stdcall;
begin
  KeepFooter := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_KeepHeader(out Value: WordBool): HResult; stdcall;
begin
  Value := KeepHeader;
  Result := S_OK;
end;

function TfrxDataBand.Set_KeepHeader(Value: WordBool): HResult; stdcall;
begin
  KeepHeader := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_KeepTogether(out Value: WordBool): HResult; stdcall;
begin
  Value := KeepTogether;
  Result := S_OK;
end;

function TfrxDataBand.Set_KeepTogether(Value: WordBool): HResult; stdcall;
begin
  KeepTogether := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_PrintIfDetailEmpty(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintIfDetailEmpty;
  Result := S_OK;
end;

function TfrxDataBand.Set_PrintIfDetailEmpty(Value: WordBool): HResult; stdcall;
begin
  PrintIfDetailEmpty := Value;
  Result := S_OK;
end;

function TfrxDataBand.Get_RowCount(out Value: Integer): HResult; stdcall;
begin
  Value := RowCount;
  Result := S_OK;
end;

function TfrxDataBand.Set_RowCount(Value: Integer): HResult; stdcall;
begin
  RowCount := Value;
  Result := S_OK;
end;

function TfrxDataBand.ResetDataSet: HResult; stdcall;
begin
  Self.FDataSet := nil;
  Result := S_OK;
end;

{$ENDIF}

{ TfrxPageHeader }

constructor TfrxPageHeader.Create(AOwner: TComponent);
begin
  inherited;
  FPrintOnFirstPage := True;
end;


{ TfrxPageFooter }

constructor TfrxPageFooter.Create(AOwner: TComponent);
begin
  inherited;
  FPrintOnFirstPage := True;
  FPrintOnLastPage := True;
end;


{ TfrxGroupHeader }

function TfrxGroupHeader.Diff(AComponent: TfrxComponent): String;
begin
  Result := inherited Diff(AComponent);
 if FDrillDown then
  Result := Result + ' DrillName="' + FDrillName + '"';
end;


{ TfrxSubreport }

constructor TfrxSubreport.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csPreviewVisible];
  FFrame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  FFont.Name := 'Tahoma';
  FFont.Size := 8;
  FColor := clSilver;
end;

destructor TfrxSubreport.Destroy;
begin
  if FPage <> nil then
    FPage.FSubReport := nil;
  inherited;
end;

procedure TfrxSubreport.SetPage(const Value: TfrxReportPage);
begin
  FPage := Value;
  if FPage <> nil then
    FPage.FSubReport := Self;
end;

procedure TfrxSubreport.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  inherited;

  with Canvas do
  begin
    Font.Assign(FFont);
    TextOut(FX + 2, FY + 2, Name);
  end;
end;

class function TfrxSubreport.GetDescription: String;
begin
  Result := frxResources.Get('obSubRep');
end;


{$IFDEF FR_COM}
function TfrxSubreport.Get_Page(out Value: IfrxReportPage): HResult; stdcall;
begin
  Value := Page;
  Result := S_OK;
end;

function TfrxSubreport.Set_Page(const Value: IfrxReportPage): HResult; stdcall;
begin
  Page := (Value as {IfrxComponentSelf} IInterfaceComponentReference).GetComponent{Get_Object} as TfrxReportPage;
  Result := S_OK;
end;

function TfrxSubreport.Get_PrintOnparent(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintOnParent;
  Result := S_OK;
end;

function TfrxSubreport.Set_PrintOnparent(Value: WordBool): HResult; stdcall;
begin
  PrintOnParent := Value;
  Result := S_OK;
end;

{ TfrxOverlay }
function TfrxOverlay.Get_PrintOnTop(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintOnTop;
  Result := S_OK;
end;

function TfrxOverlay.Set_PrintOnTop(Value: WordBool): HResult; stdcall;
begin
  PrintOnTop := Value;
  Result := S_OK;
end;


{ TfrxPage }

function TfrxPage.Get_Visible(out Value: WordBool): HResult; stdcall;
begin
  Value := Visible;
  Result := S_OK;
end;

function TfrxPage.Set_Visible(Value: WordBool): HResult; stdcall;
begin
  Visible := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxDialogPage }

constructor TfrxDialogPage.Create(AOwner: TComponent);
var
  FSaveTag: Integer;
begin
  inherited;
  FSaveTag := Tag;
  if (Report <> nil) and Report.EngineOptions.EnableThreadSafe then
    Tag := 318
  else
    Tag := 0;
  FForm := TfrxDialogForm.Create(Self);
  Tag := FSaveTag;
  FForm.KeyPreview := True;
  Font.Name := 'Tahoma';
  Font.Size := 8;
  BorderStyle := bsSizeable;
  Position := poScreenCenter;
  WindowState := wsNormal;
  Color := clBtnFace;
  FForm.ShowHint := True;
  FClientWidth := 0;
  FClientHeight := 0;
end;

destructor TfrxDialogPage.Destroy;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS.Enter;
{$ENDIF}
  try
    inherited;
    FForm.Free;
  finally
{$IFNDEF NO_CRITICAL_SECTION}
    frxCS.Leave;
{$ENDIF}
  end;
end;

class function TfrxDialogPage.GetDescription: String;
begin
  Result := frxResources.Get('obDlgPage');
end;

procedure TfrxDialogPage.SetLeft(Value: Extended);
begin
  inherited;
  FForm.Left := Round(Value);
end;

procedure TfrxDialogPage.SetTop(Value: Extended);
begin
  inherited;
  FForm.Top := Round(Value);
end;

procedure TfrxDialogPage.SetWidth(Value: Extended);
begin
  inherited;
  if IsLoading and (FClientWidth <> 0) then Exit;
  FForm.Width := Round(Value);
end;

procedure TfrxDialogPage.SetHeight(Value: Extended);
begin
  inherited;
  if IsLoading and (FClientHeight <> 0) then Exit;
  FForm.Height := Round(Value);
end;

procedure TfrxDialogPage.SetClientWidth(Value: Extended);
begin
  FForm.ClientWidth := Round(Value);
  FClientWidth := Value;
  inherited SetWidth(FForm.Width);
end;

procedure TfrxDialogPage.SetClientHeight(Value: Extended);
begin
  FForm.ClientHeight := Round(Value);
  FClientHeight := Value;
  inherited SetHeight(FForm.Height);
end;

function TfrxDialogPage.GetClientWidth: Extended;
begin
  Result := FForm.ClientWidth;
end;

function TfrxDialogPage.GetClientHeight: Extended;
begin
  Result := FForm.ClientHeight;
end;

procedure TfrxDialogPage.SetBorderStyle(const Value: TFormBorderStyle);
begin
  FBorderStyle := Value;
end;

procedure TfrxDialogPage.SetCaption(const Value: String);
begin
  FCaption := Value;
  FForm.Caption := Value;
end;

procedure TfrxDialogPage.SetColor(const Value: TColor);
begin
  FColor := Value;
  FForm.Color := Value;
end;

function TfrxDialogPage.GetModalResult: TModalResult;
begin
  Result := FForm.ModalResult;
end;

procedure TfrxDialogPage.SetModalResult(const Value: TModalResult);
begin
  FForm.ModalResult := Value;
end;

procedure TfrxDialogPage.FontChanged(Sender: TObject);
begin
  inherited;
  FForm.Font := Font;
end;

procedure TfrxDialogPage.DoInitialize;
begin
  if FForm.Visible then
    FForm.Hide;
  FForm.Position := FPosition;
  FForm.WindowState := FWindowState;
  FForm.OnActivate := DoOnActivate;
  FForm.OnClick := DoOnClick;
  FForm.OnCloseQuery := DoOnCloseQuery;
  FForm.OnDeactivate := DoOnDeactivate;
  FForm.OnHide := DoOnHide;
  FForm.OnKeyDown := DoOnKeyDown;
  FForm.OnKeyPress := DoOnKeyPress;
  FForm.OnKeyUp := DoOnKeyUp;
  FForm.OnShow := DoOnShow;
  FForm.OnResize := DoOnResize;
  FForm.OnMouseMove := DoOnMouseMove;
end;

procedure TfrxDialogPage.Initialize;
begin
{$IFNDEF FR_COM}
//  if (Report <> nil) and (Report.EngineOptions.ReportThread <> nil) then
//    THackThread(Report.EngineOptions.ReportThread).Synchronize(DoInitialize) else
{$ENDIF}
    DoInitialize;
end;

function TfrxDialogPage.ShowModal: TModalResult;
begin
  Initialize;
  FForm.BorderStyle := FBorderStyle;
  FForm.FormStyle := fsNormal;
  try
    TfrxDialogForm(FForm).OnModify := DoModify;
    Result := FForm.ShowModal;
  finally
    FForm.FormStyle := fsStayOnTop;
  end;
end;

procedure TfrxDialogPage.DoModify(Sender: TObject);
begin
  FLeft := FForm.Left;
  FTop := FForm.Top;
  FWidth := FForm.Width;
  FHeight := FForm.Height;
end;

procedure TfrxDialogPage.DoOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (Report <> nil) then
  begin
    Report.SetProgressMessage('', True);
  end;
end;

procedure TfrxDialogPage.DoOnActivate(Sender: TObject);
var
  i: Integer;
begin
  DoModify(nil);
  if Report <> nil then
    Report.DoNotifyEvent(Sender, FOnActivate, True);
  for i := 0 to AllObjects.Count - 1 do
  begin
    if (TObject(AllObjects[i]) is TfrxDialogControl) and
    Assigned(TfrxDialogControl(AllObjects[i]).OnActivate) then
      TfrxDialogControl(AllObjects[i]).OnActivate(Self);
  end;
end;

procedure TfrxDialogPage.DoOnClick(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnClick, True);
end;

procedure TfrxDialogPage.DoOnCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), CanClose]);
  Report.DoParamEvent(FOnCloseQuery, v, True);
  CanClose := v[1];
end;

procedure TfrxDialogPage.DoOnDeactivate(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnDeactivate, True);
end;

procedure TfrxDialogPage.DoOnHide(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnHide, True);
end;

procedure TfrxDialogPage.DoOnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), Key, ShiftToByte(Shift)]);
  if Report <> nil then
    Report.DoParamEvent(FOnKeyDown, v, True);
  Key := v[1];
end;

procedure TfrxDialogPage.DoOnKeyPress(Sender: TObject; var Key: Char);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), Key]);
  if Report <> nil then
    Report.DoParamEvent(FOnKeyPress, v, True);
  if VarToStr(v[1]) <> '' then
    Key := VarToStr(v[1])[1]
  else
    Key := Chr(0);
end;

procedure TfrxDialogPage.DoOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), Key, ShiftToByte(Shift)]);
  if Report <> nil then
    Report.DoParamEvent(FOnKeyUp, v, True);
  Key := v[1];
end;

procedure TfrxDialogPage.DoOnShow(Sender: TObject);
begin
  FForm.Perform(CM_FOCUSCHANGED, 0, frxInteger(FForm.ActiveControl));
  Report.DoNotifyEvent(Sender, FOnShow, True);
end;

procedure TfrxDialogPage.DoOnResize(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnResize, True);
end;


{ TfrxReportPage }

constructor TfrxReportPage.Create(AOwner: TComponent);
begin
  inherited;
  FBackPicture := TfrxPictureView.Create(nil);
  FBackPicture.Color := clTransparent;
  FBackPicture.KeepAspectRatio := False;
  FColumnPositions := TStringList.Create;
  FOrientation := poPortrait;
  PaperSize := DMPAPER_A4;
  FBin := DMBIN_AUTO;
  FBinOtherPages := DMBIN_AUTO;
  FBaseName := 'Page';
  FSubBands := TList.Create;
  FVSubBands := TList.Create;
  FHGuides := TStringList.Create;
  FVGuides := TStringList.Create;
  FPrintIfEmpty := True;
  FTitleBeforeHeader := True;
  FBackPictureVisible := True;
  FBackPicturePrintable := True;
  FPageCount := 1;
end;

destructor TfrxReportPage.Destroy;
begin
  FColumnPositions.Free;
  FBackPicture.Free;
  FSubBands.Free;
  FVSubBands.Free;
  FHGuides.Free;
  FVGuides.Free;
  if FSubReport <> nil then
    FSubReport.FPage := nil;
  inherited;
end;

class function TfrxReportPage.GetDescription: String;
begin
  Result := frxResources.Get('obRepPage');
end;

procedure TfrxReportPage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

procedure TfrxReportPage.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxReportPage.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxReportPage.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxReportPage.SetPaperHeight(const Value: Extended);
begin
  FPaperHeight := Round8(Value);
  FPaperSize := 256;
  UpdateDimensions;
end;

procedure TfrxReportPage.SetPaperWidth(const Value: Extended);
begin
  FPaperWidth := Round8(Value);
  FPaperSize := 256;
  UpdateDimensions;
end;

procedure TfrxReportPage.SetPaperSize(const Value: Integer);
var
  e: Extended;
begin
  FPaperSize := Value;
  if FPaperSize < DMPAPER_USER then
  begin
    if frxGetPaperDimensions(FPaperSize, FPaperWidth, FPaperHeight) then
      if FOrientation = poLandscape then
      begin
        e := FPaperWidth;
        FPaperWidth := FPaperHeight;
        FPaperHeight := e;
      end;
    UpdateDimensions;
  end;
end;

procedure TfrxReportPage.SetSizeAndDimensions(ASize: Integer; AWidth,
  AHeight: Extended);
begin
  FPaperSize := ASize;
  FPaperWidth := Round8(AWidth);
  FPaperHeight := Round8(AHeight);
  UpdateDimensions;
end;

procedure TfrxReportPage.SetColumns(const Value: Integer);
begin
  FColumns := Value;
  FColumnPositions.Clear;
  if FColumns <= 0 then exit;

  FColumnWidth := (FPaperWidth - FLeftMargin - FRightMargin) / FColumns;
  while FColumnPositions.Count < FColumns do
    FColumnPositions.Add(FloatToStr(FColumnPositions.Count * FColumnWidth));
end;

procedure TfrxReportPage.SetPageCount(const Value: Integer);
begin
  if Value > 0 then
    FPageCount := Value; 
end;

procedure TfrxReportPage.SetOrientation(Value: TPrinterOrientation);
var
  e, m1, m2, m3, m4: Extended;
begin
  if FOrientation <> Value then
  begin
    e := FPaperWidth;
    FPaperWidth := FPaperHeight;
    FPaperHeight := e;

    m1 := FLeftMargin;
    m2 := FRightMargin;
    m3 := FTopMargin;
    m4 := FBottomMargin;

    if Value = poLandscape then
    begin
      FLeftMargin := m3;
      FRightMargin := m4;
      FTopMargin := m2;
      FBottomMargin := m1;
    end
    else
    begin
      FLeftMargin := m4;
      FRightMargin := m3;
      FTopMargin := m1;
      FBottomMargin := m2;
    end;
    UpdateDimensions;
  end;

  FOrientation := Value;
end;

procedure TfrxReportPage.UpdateDimensions;
begin
  Width := Round(FPaperWidth * fr01cm);
  Height := Round(FPaperHeight * fr01cm);
end;

procedure TfrxReportPage.ClearGuides;
begin
  FHGuides.Clear;
  FVGuides.Clear;
end;

procedure TfrxReportPage.SetHGuides(const Value: TStrings);
begin
  FHGuides.Assign(Value);
end;

procedure TfrxReportPage.SetVGuides(const Value: TStrings);
begin
  FVGuides.Assign(Value);
end;

function TfrxReportPage.FindBand(Band: TfrxBandClass): TfrxBand;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FObjects.Count - 1 do
    if TObject(FObjects[i]) is Band then
    begin
      Result := FObjects[i];
      break;
    end;
end;

function TfrxReportPage.IsSubReport: Boolean;
begin
  Result := SubReport <> nil;
end;

procedure TfrxReportPage.SetColumnPositions(const Value: TStrings);
begin
  FColumnPositions.Assign(Value);
end;

function TfrxReportPage.GetFrame: TfrxFrame;
begin
  Result := FBackPicture.Frame;
end;

procedure TfrxReportPage.SetFrame(const Value: TfrxFrame);
begin
  FBackPicture.Frame := Value;
end;

function TfrxReportPage.GetColor: TColor;
begin
  Result := FBackPicture.Color;
end;

procedure TfrxReportPage.SetColor(const Value: TColor);
begin
  FBackPicture.Color := Value;
end;

function TfrxReportPage.GetBackPicture: TPicture;
begin
  Result := FBackPicture.Picture;
end;

procedure TfrxReportPage.SetBackPicture(const Value: TPicture);
begin
  FBackPicture.Picture := Value;
end;

procedure TfrxReportPage.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  FBackPicture.Width := (FPaperWidth - FLeftMargin - FRightMargin) * fr01cm;
  FBackPicture.Height := (FPaperHeight - FTopMargin - FBottomMargin) * fr01cm;
  if FBackPictureVisible and (not IsPrinting or FBackPicturePrintable) then
    FBackPicture.Draw(Canvas, ScaleX, ScaleY,
      OffsetX + FLeftMargin * fr01cm * ScaleX,
      OffsetY + FTopMargin * fr01cm * ScaleY);
end;

procedure TfrxReportPage.SetDefaults;
begin
  FLeftMargin := 10;
  FRightMargin := 10;
  FTopMargin := 10;
  FBottomMargin := 10;
  FPaperSize := frxPrinters.Printer.DefPaper;
  FPaperWidth := frxPrinters.Printer.DefPaperWidth;
  FPaperHeight := frxPrinters.Printer.DefPaperHeight;
  FOrientation := frxPrinters.Printer.DefOrientation;
  UpdateDimensions;
end;

procedure TfrxReportPage.AlignChildren;
var
  i: Integer;
  c: TfrxComponent;
begin
  Width := (FPaperWidth - FLeftMargin - FRightMargin) * fr01cm;
  Height := (FPaperHeight - FTopMargin - FBottomMargin) * fr01cm;
  inherited;
  for i := 0 to Objects.Count - 1 do
  begin
    c := Objects[i];
    if c is TfrxBand then
    begin
      if TfrxBand(c).Vertical then
        c.Height := (FPaperHeight - FTopMargin - FBottomMargin) * fr01cm - c.Top
      else
        if (Columns > 1) and not((c is TfrxNullBand) or (c is TfrxReportSummary) or
          (c is TfrxPageHeader) or (c is TfrxPageFooter) or
          (c is TfrxReportTitle) or (c is TfrxOverlay)) then
          c.Width := ColumnWidth * fr01cm
        else       
          c.Width := Width - c.Left;
      c.AlignChildren;
    end;
  end;
  UpdateDimensions;
end;

{$IFDEF FR_COM}
function TfrxReportPage.IfrxReportPage_SetDefaults: HResult; stdcall;
begin
  SetDefaults;
  Result := 0;
end;

function TfrxReportPage.IfrxReportPage_Get_Bin(out Value: SYSINT): HResult; stdcall;
begin
  Value := Bin;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_Bin(Value: SYSINT): HResult; stdcall;
begin
  Bin := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_BinOtherPages(out Value: SYSINT): HResult; stdcall;
begin
  Value := BinOtherPages;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_BinOtherPages(Value: SYSINT): HResult; stdcall;
begin
  BinOtherPages := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_BottomMargin(out Value: Double): HResult; stdcall;
begin
  Value := BottomMargin;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_BottomMargin(Value: Double): HResult; stdcall;
begin
  BottomMargin := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_Columns(out Value: SYSINT): HResult; stdcall;
begin
  Value := Columns;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_Columns(Value: SYSINT): HResult; stdcall;
begin
  Columns := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_ColumnWidth(out Value: Double): HResult; stdcall;
begin
  Value := ColumnWidth;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_ColumnWidth(Value: Double): HResult; stdcall;
begin
  ColumnWidth := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_ColumnPosition(out Value: WideString): HResult; stdcall;
begin
  Value := ColumnPositions.GetText;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_ColumnPosition(const Value: WideString): HResult; stdcall;
begin
  ColumnPositions.SetText(PChar(Value));
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
begin
  if FDataSet <> nil then
    Value := DataSet;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
  comp:   TfrxComponent;
begin
  Result := Value.QueryInterface({IfrxComponentSelf} IInterfaceComponentReference, idsp);
  if Result = S_OK then
  begin
    comp := TfrxComponent(idsp.GetComponent {Get_Object});
    DataSet := TfrxDataSet(comp);
    comp.Parent := Self;
  end;
end;

function TfrxReportPage.IfrxReportPage_Get_Duplex(out Value: frxDuplexMode): HResult; stdcall;
begin
  Value := frxDuplexMode(Duplex);
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_Duplex(Value: frxDuplexMode): HResult; stdcall;
begin
  Duplex := TfrxDuplexMode(Value);
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_HGuides(out Value: WideString): HResult; stdcall;
begin
  Value := HGuides.GetText;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_HGuides(const Value: WideString): HResult; stdcall;
begin
  HGuides.SetText(PChar(Value));
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_LargeDesignHeight(out Value: WordBool): HResult; stdcall;
begin
  Value := LargeDesignHeight;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_LargeDesignHeight(Value: WordBool): HResult; stdcall;
begin
  LargeDesignHeight := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_LeftMargin(out Value: Double): HResult; stdcall;
begin
  Value := LeftMargin;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_LeftMargin(Value: Double): HResult; stdcall;
begin
  LeftMargin := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_MirrorMargins(out Value: WordBool): HResult; stdcall;
begin
  Value := MirrorMargins;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_MirrorMargins(Value: WordBool): HResult; stdcall;
begin
  MirrorMargins := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_Orientation(out Value: frxPrinterOrientation): HResult; stdcall;
begin
  Value := frxPrinterOrientation(Orientation);
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_Orientation(Value: frxPrinterOrientation): HResult; stdcall;
begin
  Orientation := TPrinterOrientation(Value);
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_OutlineText(out Value: WideString): HResult; stdcall;
begin
  Value := OutlineText;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_OutlineText(const Value: WideString): HResult; stdcall;
begin
  OutlineText := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_PrintIfEmpty(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintIfEmpty;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_PrintIfEmpty(Value: WordBool): HResult; stdcall;
begin
  PrintIfEmpty := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_PrintOnPreviousPage(out Value: WordBool): HResult; stdcall;
begin
  Value := PrintOnPreviousPage;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_PrintOnPreviousPage(Value: WordBool): HResult; stdcall;
begin
  PrintOnPreviousPage := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_RightMargin(out Value: Double): HResult; stdcall;
begin
  Value := RightMargin;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_RightMargin(Value: Double): HResult; stdcall;
begin
  RightMargin := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_SubReport(out Value: IfrxSubreport): HResult; stdcall;
begin
  Value := Subreport;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_SubReport(const Value: IfrxSubreport): HResult; stdcall;
begin
  Value.Set_Page(Self);
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_TitleBeforeHeader(out Value: WordBool): HResult; stdcall;
begin
  Value := FTitleBeforeHeader;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_TitleBeforeHeader(Value: WordBool): HResult; stdcall;
begin
  FTitleBeforeHeader := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_TopMargin(out Value: Double): HResult; stdcall;
begin
  Value := FTopMargin;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_TopMargin(Value: Double): HResult; stdcall;
begin
  FTopMargin := Value;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_VGuides(out Value: WideString): HResult; stdcall;
begin
  Value := FVGuides.GetText;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_VGuides(const Value: WideString): HResult; stdcall;
begin
  FVGuides.SetText(PChar(Value));
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Get_BackPickture(out Value: OLE_HANDLE): HResult; stdcall;
begin
  Value := BackPicture.Bitmap.Handle;
  Result := S_OK;
end;

function TfrxReportPage.IfrxReportPage_Set_BackPickture(Value: OLE_HANDLE): HResult; stdcall;
begin
  BackPicture.Bitmap.Handle := Value;
  Result := S_OK;
end;

function TfrxReportPage.Get_PaperWidth(out Value: Double): HResult; stdcall;
begin
  Value := PaperWidth;
  Result := S_OK;
end;

function TfrxReportPage.Set_PaperWidth(Value: Double): HResult; stdcall;
begin
  PaperWidth := Value;
  Result := S_OK;
end;

function TfrxReportPage.Get_PaperHeight(out Value: Double): HResult; stdcall;
begin
  Value := PaperHeight;
  Result := S_OK;
end;

function TfrxReportPage.Set_PaperHeight(Value: Double): HResult; stdcall;
begin
  PaperHeight := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxDataPage }

constructor TfrxDataPage.Create(AOwner: TComponent);
begin
  inherited;
  Width := 1000;
  Height := 1000;
end;

class function TfrxDataPage.GetDescription: String;
begin
  Result := frxResources.Get('obDataPage');
end;


{ TfrxEngineOptions }

constructor TfrxEngineOptions.Create;
begin
  Clear;
  FMaxMemSize := 10;
  FPrintIfEmpty := True;
  FSilentMode := simMessageBoxes;
  FEnableThreadSafe := False;
  FTempDir := '';
  FUseGlobalDataSetList := True;
{$IFDEF FR_COM}
  inherited Create(IfrxEngineOptions);
  FUseFileCache := True;
{$ELSE}
  FUseFileCache := False;
{$ENDIF}
  FDestroyForms := True;
end;

procedure TfrxEngineOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxEngineOptions then
  begin
    FConvertNulls := TfrxEngineOptions(Source).ConvertNulls;
    FDoublePass := TfrxEngineOptions(Source).DoublePass;
    FMaxMemSize := TfrxEngineOptions(Source).MaxMemSize;
    FPrintIfEmpty := TfrxEngineOptions(Source).PrintIfEmpty;
    NewSilentMode := TfrxEngineOptions(Source).NewSilentMode;
    FTempDir := TfrxEngineOptions(Source).TempDir;
    FUseFileCache := TfrxEngineOptions(Source).UseFileCache;
    FIgnoreDevByZero := TfrxEngineOptions(Source).IgnoreDevByZero;
  end;
end;

procedure TfrxEngineOptions.Clear;
begin
  FConvertNulls := True;
  FIgnoreDevByZero := False;
  FDoublePass := False;
end;

procedure TfrxEngineOptions.SetSilentMode(Mode: Boolean);
begin
  if Mode = True then
    FSilentMode := simSilent
  else
    FSilentMode := simMessageBoxes;
end;

function TfrxEngineOptions.GetSilentMode: Boolean;
begin
  if FSilentMode = simSilent then
    Result := True
  else
    Result := False;
end;

{$IFDEF FR_COM}
function TfrxEngineOptions.IfrxEngineOptions_Get_ConvertNulls(out Value: WordBool): HResult; stdcall;
begin
  Value := FConvertNulls;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_ConvertNulls(Value: WordBool): HResult; stdcall;
begin
  FConvertNulls := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_DestroyForms(out Value: WordBool): HResult; stdcall;
begin
  Value := FDestroyForms;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_DestroyForms(Value: WordBool): HResult; stdcall;
begin
  FDestroyForms := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_DoublePass(out Value: WordBool): HResult; stdcall;
begin
  Value := FDoublePass;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_DoublePass(Value: WordBool): HResult; stdcall;
begin
  FDoublePass := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_MaxMemSize(out Value: SYSINT): HResult; stdcall;
begin
  Value := FMaxMemSize;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_MaxMemSize(Value: SYSINT): HResult; stdcall;
begin
  FMaxMemSize := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_PrintIfEmpty(out Value: WordBool): HResult; stdcall;
begin
  Value := FPrintIfEmpty;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_PrintIfEmpty(Value: WordBool): HResult; stdcall;
begin
  FPrintIfEmpty := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_SilentMode(out Value: frxSilentMode): HResult; stdcall;
begin
  Value := frxSilentMode(FSilentMode);
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_SilentMode(Value: frxSilentMode): HResult; stdcall;
begin
  FSilentMode := TfrxSilentMode(Value);
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_TempDir(out Value: WideString): HResult; stdcall;
begin
  Value := FTempDir;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_TempDir(const Value: WideString): HResult; stdcall;
begin
  FTempDir := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Get_UseFilecache(out Value: WordBool): HResult; stdcall;
begin
  Value := FUseFilecache;
  Result := S_OK;
end;

function TfrxEngineOptions.IfrxEngineOptions_Set_UseFilecache(Value: WordBool): HResult; stdcall;
begin
  FUseFilecache := Value;
  Result := S_OK;
end;

function TfrxEngineOptions.Get_UseGlobalDatasetList(out Value: WordBool): HResult; stdcall;
begin
  Value := FUseGlobalDataSetList;
  Result := S_OK;
end;

function TfrxEngineOptions.Set_UseGlobalDatasetList(Value: WordBool): HResult; stdcall;
begin
  FUseGlobalDataSetList := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxPreviewOptions }

constructor TfrxPreviewOptions.Create;
begin
  Clear;
  FAllowEdit := True;
  FButtons := [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind,
    pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick];
  FDoubleBuffered := True;
  FMaximized := True;
  FMDIChild := False;
  FModal := True;
  FPagesInCache := 50;
  FShowCaptions := False;
  FZoom := 1;
  FZoomMode := zmDefault;
  FPictureCacheInFile := False;
{$IFDEF FR_COM}
  inherited Create(IfrxPreviewOptions);
{$ENDIF}
end;

procedure TfrxPreviewOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxPreviewOptions then
  begin
    FAllowEdit := TfrxPreviewOptions(Source).AllowEdit;
    FButtons := TfrxPreviewOptions(Source).Buttons;
    FDoubleBuffered := TfrxPreviewOptions(Source).DoubleBuffered;
    FMaximized := TfrxPreviewOptions(Source).Maximized;
    FMDIChild := TfrxPreviewOptions(Source).MDIChild;
    FModal := TfrxPreviewOptions(Source).Modal;
    FOutlineExpand := TfrxPreviewOptions(Source).OutlineExpand;
    FOutlineVisible := TfrxPreviewOptions(Source).OutlineVisible;
    FOutlineWidth := TfrxPreviewOptions(Source).OutlineWidth;
    FPagesInCache := TfrxPreviewOptions(Source).PagesInCache;
    FShowCaptions := TfrxPreviewOptions(Source).ShowCaptions;
    FThumbnailVisible := TfrxPreviewOptions(Source).ThumbnailVisible;
    FZoom := TfrxPreviewOptions(Source).Zoom;
    FZoomMode := TfrxPreviewOptions(Source).ZoomMode;
    FPictureCacheInFile := TfrxPreviewOptions(Source).PictureCacheInFile;
    FRTLPreview := TfrxPreviewOptions(Source).RTLPreview;
  end;
end;

procedure TfrxPreviewOptions.Clear;
begin
  FOutlineExpand := True;
  FOutlineVisible := False;
  FOutlineWidth := 120;
  FPagesInCache := 50;
  FThumbnailVisible := False;
end;

{$IFDEF FR_COM}
function TfrxPreviewOptions.Get_AllowEdit(out Value: WordBool): HResult; stdcall;
begin
  Value := FAllowEdit;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_AllowEdit(Value: WordBool): HResult; stdcall;
begin
  FAllowEdit := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_Buttons(out Value: frxPreviewButtons): HResult; stdcall;
begin
  Value := TOleEnum(PInteger(@Buttons)^);
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_Buttons(Value: frxPreviewButtons): HResult; stdcall;
type
  PfrxPreviewButtons = ^ TfrxPreviewButtons;
begin
  Buttons := PfrxPreviewButtons(@Value)^;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_DoubleBuffered(out Value: WordBool): HResult; stdcall;
begin
  Value := FDoubleBuffered;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_DoubleBuffered(Value: WordBool): HResult; stdcall;
begin
  FDoubleBuffered := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_Maximized(out Value: WordBool): HResult; stdcall;
begin
  Value := FMaximized;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_Maximized(Value: WordBool): HResult; stdcall;
begin
  FMaximized := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_MDIChild(out Value: WordBool): HResult; stdcall;
begin
  Value := FMDIChild;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_MDIChild(Value: WordBool): HResult; stdcall;
begin
  FMDIChild := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_Modal(out Value: WordBool): HResult; stdcall;
begin
  Value := FModal;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_Modal(Value: WordBool): HResult; stdcall;
begin
  FModal := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_OutlineExpand(out Value: WordBool): HResult; stdcall;
begin
  Value := FOutlineExpand;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_OutlineExpand(Value: WordBool): HResult; stdcall;
begin
  FOutlineExpand := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_OutlineVisible(out Value: WordBool): HResult; stdcall;
begin
  Value := FOutlineVisible;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_OutlineVisible(Value: WordBool): HResult; stdcall;
begin
  FOutlineVisible := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_OutlineWidth(out Value: SYSINT): HResult; stdcall;
begin
  Value := FOutlineWidth;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_OutlineWidth(Value: SYSINT): HResult; stdcall;
begin
  FOutlineWidth := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_ShowCaptions(out Value: WordBool): HResult; stdcall;
begin
  Value := FShowCaptions;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_ShowCaptions(Value: WordBool): HResult; stdcall;
begin
  FShowCaptions := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_Zoom(out Value: Double): HResult; stdcall;
begin
  Value := FZoom;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_Zoom(Value: Double): HResult; stdcall;
begin
  FZoom := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_ZoomMode(out Value: frxZoomMode): HResult; stdcall;
begin
  Value := frxZoomMode(FZoomMode);
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_ZoomMode(Value: frxZoomMode): HResult; stdcall;
begin
  FZoomMode := TfrxZoomMode(Value);
  Result := S_OK;
end;
function TfrxPreviewOptions.Get_PictureCacheInFile(out Value: WordBool): HResult; stdcall;
begin
  Value := PictureCacheInFile;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_PictureCacheInFile(Value: WordBool): HResult; stdcall;
begin
  PictureCacheInFile := Value;
  Result := S_OK;
end;

function TfrxPreviewOptions.Get_RTLPreview(out Value: WordBool): HResult; stdcall;
begin
  Value := RTLPreview;
  Result := S_OK;
end;

function TfrxPreviewOptions.Set_RTLPreview(Value: WordBool): HResult; stdcall;
begin
  RTLPreview := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxPrintOptions }

constructor TfrxPrintOptions.Create;
begin
{$IFDEF FR_COM}
  inherited Create(IfrxPrintOptions);
{$ENDIF}
  Clear;
end;

{$IFDEF FR_COM}
destructor TfrxPrintOptions.Destroy;
begin
  inherited Destroy;
end;
{$ENDIF}

procedure TfrxPrintOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxPrintOptions then
  begin
    FCopies := TfrxPrintOptions(Source).Copies;
    FCollate := TfrxPrintOptions(Source).Collate;
    FPageNumbers := TfrxPrintOptions(Source).PageNumbers;
    FPrinter := TfrxPrintOptions(Source).Printer;
    FPrintMode := TfrxPrintOptions(Source).PrintMode;
    FPrintOnSheet := TfrxPrintOptions(Source).PrintOnSheet;
    FPrintPages := TfrxPrintOptions(Source).PrintPages;
    FReverse := TfrxPrintOptions(Source).Reverse;
    FShowDialog := TfrxPrintOptions(Source).ShowDialog;
    FSplicingLine := TfrxPrintOptions(Source).SplicingLine;
  end;
end;

procedure TfrxPrintOptions.Clear;
begin
  FCopies := 1;
  FCollate := True;
  FPageNumbers := '';
  FPagesOnSheet := 0;
  FPrinter := frxResources.Get('prDefault');
  FPrintMode := pmDefault;
  FPrintOnSheet := 0;
  FPrintPages := ppAll;
  FReverse := False;
  FShowDialog := True;
  FSplicingLine := 3;
  FDuplex := dmNone;
end;

{$IFDEF FR_COM}
function TfrxPrintOptions.Get_Copies(out Value: SYSINT): HResult; stdcall;
begin
  Value := Copies;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_Copies(Value: SYSINT): HResult; stdcall;
begin
  Copies := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_Collate(out Value: WordBool): HResult; stdcall;
begin
  Value := Collate;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_Collate(Value: WordBool): HResult; stdcall;
begin
  Collate := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_PageNumbers(out Value: WideString): HResult; stdcall;
begin
  Value := PageNumbers;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_PageNumbers(const Value: WideString): HResult; stdcall;
begin
  PageNumbers := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_Printer(out Value: WideString): HResult; stdcall;
begin
  Value := Printer;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_Printer(const Value: WideString): HResult; stdcall;
begin
  Printer := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_PrintPages(out Value: frxPrintPages): HResult; stdcall;
begin
  Value := frxPrintPages(PrintPages);
  Result := S_OK;
end;

function TfrxPrintOptions.Set_PrintPages(Value: frxPrintPages): HResult; stdcall;
begin
  PrintPages := TfrxPrintPages(Value);
  Result := S_OK;
end;

function TfrxPrintOptions.Get_Reverse(out Value: WordBool): HResult; stdcall;
begin
  Value := Reverse;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_Reverse(Value: WordBool): HResult; stdcall;
begin
  Reverse := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_ShowDialog(out Value: WordBool): HResult; stdcall;
begin
  Value := ShowDialog;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_ShowDialog(Value: WordBool): HResult; stdcall;
begin
  ShowDialog := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_PrintMode(out Value: frxPrintMode): HResult; stdcall;
begin
  Value := frxPrintMode(PrintMode);
  Result := S_OK;
end;

function TfrxPrintOptions.Set_PrintMode(Value: frxPrintMode): HResult; stdcall;
begin
  PrintMode := TfrxPrintMode(Value);
  Result := S_OK;
end;

function TfrxPrintOptions.Get_PrintOnSheet(out Value: Integer): HResult; stdcall;
begin
  Value := PrintOnSheet;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_PrintOnSheet(Value: Integer): HResult; stdcall;
begin
  PrintOnSheet := Value;
  Result := S_OK;
end;

function TfrxPrintOptions.Get_PrnOutFilename(out Value: WideString): HResult; stdcall;
begin
  Value := PrnOutFilename;
  Result := S_OK;
end;

function TfrxPrintOptions.Set_PrnOutFilename(const Value: WideString): HResult; stdcall;
begin
  PrnOutFilename := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxReportOptions }

constructor TfrxReportOptions.Create;
begin
  FDescription := TStringList.Create;
  FPicture := TPicture.Create;
  FCreateDate := Now;
  FLastChange := Now;
  FPrevPassword := '';
  FInfo := False;
{$IFDEF FR_COM}
  inherited Create(IfrxReportOptions);
{$ENDIF}
end;

destructor TfrxReportOptions.Destroy;
begin
  FDescription.Free;
  FPicture.Free;
  inherited;
end;

procedure TfrxReportOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxReportOptions then
  begin
    FAuthor := TfrxReportOptions(Source).Author;
    FCompressed := TfrxReportOptions(Source).Compressed;
    FConnectionName := TfrxReportOptions(Source).ConnectionName;
    FCreateDate := TfrxReportOptions(Source).CreateDate;
    Description := TfrxReportOptions(Source).Description;
    FInitString := TfrxReportOptions(Source).InitString;
    FLastChange := TfrxReportOptions(Source).LastChange;
    FName := TfrxReportOptions(Source).Name;
    FPassword := TfrxReportOptions(Source).Password;
    Picture := TfrxReportOptions(Source).Picture;
    FVersionBuild := TfrxReportOptions(Source).VersionBuild;
    FVersionMajor := TfrxReportOptions(Source).VersionMajor;
    FVersionMinor := TfrxReportOptions(Source).VersionMinor;
    FVersionRelease := TfrxReportOptions(Source).VersionRelease;
  end;
end;

procedure TfrxReportOptions.Clear;
begin
  if not FInfo then
  begin
    FAuthor := '';
    FCompressed := False;
    FCreateDate := Now;
    FDescription.Clear;
    FLastChange := Now;
    FPicture.Assign(nil);
    FVersionBuild := '';
    FVersionMajor := '';
    FVersionMinor := '';
    FVersionRelease := '';
  end;
  FConnectionName := '';
  FInitString := '';
  FName := '';
  FPassword := '';
  FPrevPassword := '';
end;

procedure TfrxReportOptions.SetDescription(const Value: TStrings);
begin
  FDescription.Assign(Value);
end;

procedure TfrxReportOptions.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

function TfrxReportOptions.CheckPassword: Boolean;
begin
  Result := True;
  if (FPassword <> '') and (FPassword <> FPrevPassword) and (FPassword <> HiddenPassword) then
    with TfrxPasswordForm.Create(Application) do
    begin
      if (ShowModal <> mrOk) or (FPassword <> PasswordE.Text) then
      begin
        Result := False;
        FReport.Errors.Add(frxResources.Get('Invalid password'));
        frxCommonErrorHandler(FReport, frxResources.Get('clErrors') + #13#10 + FReport.Errors.Text);
      end
      else
        FPrevPassword := FPassword;
      Free;
    end;
end;

procedure TfrxReportOptions.SetConnectionName(const Value: String);
{$IFNDEF FPC}
var
  ini: TRegistry;
  conn: String;
{$ENDIF}
begin
  FConnectionName := Value;
  {$IFNDEF FPC}
  if Value <> '' then
    if Assigned(FReport.OnSetConnection) then
    begin
      ini := TRegistry.Create;
      try
        ini.RootKey := HKEY_LOCAL_MACHINE;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS) then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection( conn );
          ini.CloseKey;
        end;
        ini.RootKey := HKEY_CURRENT_USER;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS) then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection(conn);
          ini.CloseKey;
        end;
// Samuray
        ini.RootKey := HKEY_LOCAL_MACHINE;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS+'FIB') then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection( conn );
          ini.CloseKey;
        end;
        ini.RootKey := HKEY_CURRENT_USER;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS+'FIB') then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection(conn);
          ini.CloseKey;
        end;
      finally
        ini.Free;
      end;
    end;
  {$ENDIF}
end;


{$IFDEF FR_COM}
function TfrxReportOptions.IfrxReportOptions_Get_Author(out Value: WideString): HResult; stdcall;
begin
  Value := FAuthor;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_Author(const Value: WideString): HResult; stdcall;
begin
  FAuthor := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_Compressed(out Value: WordBool): HResult; stdcall;
begin
  Value := FCompressed;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_Compressed(Value: WordBool): HResult; stdcall;
begin
  FCompressed := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_ConnectionName(out Value: WideString): HResult; stdcall;
begin
  Value := ConnectionName;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_ConnectionName(const Value: WideString): HResult; stdcall;
begin
  ConnectionName := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_CreationDate(out Value: TDateTime): HResult; stdcall;
begin
  Value := FCreateDate;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_CreationDate(Value: TDateTime): HResult; stdcall;
begin
  FCreateDate := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_Description(out Value: WideString): HResult; stdcall;
begin
  Value := FDescription.GetText;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_Description(const Value: WideString): HResult; stdcall;
begin
  FDescription.SetText(PChar(Value));
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_InitString(out Value: WideString): HResult; stdcall;
begin
  Value := FInitString;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_InitString(const Value: WideString): HResult; stdcall;
begin
  FInitString := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_Name(out Value: WideString): HResult; stdcall;
begin
  Value := FName;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_Name(const Value: WideString): HResult; stdcall;
begin
  FName := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_LastChange(out Value: TDateTime): HResult; stdcall;
begin
  Value := FLastChange;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_LastChange(Value: TDateTime): HResult; stdcall;
begin
  FLastChange := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_Password(out Value: WideString): HResult; stdcall;
begin
  Value := FPassword;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_Password(const Value: WideString): HResult; stdcall;
begin
  FPassword := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_Picture(out Value: IUnknown): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TfrxReportOptions.IfrxReportOptions_Set_Picture(const Value: IUnknown): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TfrxReportOptions.IfrxReportOptions_Get_VersionBuild(out Value: WideString): HResult; stdcall;
begin
  Value := FVersionBuild;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_VersionBuild(const Value: WideString): HResult; stdcall;
begin
  FVersionBuild := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_VersionMajor(out Value: WideString): HResult; stdcall;
begin
  Value := FVersionMajor;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_VersionMajor(const Value: WideString): HResult; stdcall;
begin
  FVersionMajor := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_VersionMinor(out Value: WideString): HResult; stdcall;
begin
  Value := FVersionMinor;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_VersionMinor(const Value: WideString): HResult; stdcall;
begin
  FVersionMinor := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_VersionRelease(out Value: WideString): HResult; stdcall;
begin
  Value := FVersionRelease;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_VersionRelease(const Value: WideString): HResult; stdcall;
begin
  FVersionRelease := Value;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Get_HiddenPassword(out Value: WideString): HResult; stdcall;
begin
  Value := FHiddenPassword;
  Result := S_OK;
end;

function TfrxReportOptions.IfrxReportOptions_Set_HiddenPassword(const Value: WideString): HResult; stdcall;
begin
  FHiddenPassword := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxDataSetItem }

procedure TfrxDataSetItem.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxDataSetItem.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  if FDataSetName = '' then
    FDataSet := nil
  else if TfrxReportDataSets(Collection).FReport <> nil then
    FDataSet := TfrxReportDataSets(Collection).FReport.FindDataSet(FDataSet, FDataSetName);
end;

function TfrxDataSetItem.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;


{ TfrxReportDatasets }

constructor TfrxReportDatasets.Create(AReport: TfrxReport);
begin
  inherited Create(TfrxDatasetItem);
  FReport := AReport;
end;

procedure TfrxReportDataSets.Initialize;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
    begin
      Items[i].DataSet.ReportRef := FReport;
      Items[i].DataSet.Initialize;
    end;
end;

procedure TfrxReportDataSets.Finalize;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
      Items[i].DataSet.Finalize;
end;

procedure TfrxReportDatasets.Add(ds: TfrxDataSet);
begin
  TfrxDatasetItem(inherited Add).DataSet := ds;
end;

function TfrxReportDatasets.GetItem(Index: Integer): TfrxDatasetItem;
begin
  Result := TfrxDatasetItem(inherited Items[Index]);
end;

function TfrxReportDatasets.Find(ds: TfrxDataSet): TfrxDatasetItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].DataSet = ds then
    begin
      Result := Items[i];
      Exit;
    end;
end;

function TfrxReportDatasets.Find(const Name: String): TfrxDatasetItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
      if CompareText(Items[i].DataSet.UserName, Name) = 0 then
      begin
        Result := Items[i];
        Exit;
      end;
end;

procedure TfrxReportDatasets.Delete(const Name: String);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
      if CompareText(Items[i].DataSet.UserName, Name) = 0 then
      begin
        Items[i].Free;
        Exit;
      end;
end;

{ TfrxStyleItem }

constructor TfrxStyleItem.Create(Collection: TCollection);
begin
  inherited;
  FColor := clNone;
  FFont := TFont.Create;
  with FFont do
  begin
    Name := DefFontName;
    Size := DefFontSize;
    Charset := frxCharset;
  end;
  FFrame := TfrxFrame.Create;
end;

destructor TfrxStyleItem.Destroy;
begin
  FFont.Free;
  FFrame.Free;
  inherited;
end;

procedure TfrxStyleItem.Assign(Source: TPersistent);
begin
  if Source is TfrxStyleItem then
  begin
    FName := TfrxStyleItem(Source).Name;
    FColor := TfrxStyleItem(Source).Color;
    FFont.Assign(TfrxStyleItem(Source).Font);
    FFrame.Assign(TfrxStyleItem(Source).Frame);
  end;
end;

procedure TfrxStyleItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TfrxStyleItem.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;

procedure TfrxStyleItem.SetName(const Value: String);
var
  Item: TfrxStyleItem;
begin
  Item := TfrxStyles(Collection).Find(Value);
  if (Item = nil) or (Item = Self) then
    FName := Value else
    raise Exception.Create(frxResources.Get('clDupName'));
end;

procedure TfrxStyleItem.CreateUniqueName;
var
  i: Integer;
begin
  i := 1;
  while TfrxStyles(Collection).Find('Style' + IntToStr(i)) <> nil do
    Inc(i);
  Name := 'Style' + IntToStr(i);
end;


{ TfrxStyles }

constructor TfrxStyles.Create(AReport: TfrxReport);
begin
  inherited Create(TfrxStyleItem);
  FReport := AReport;
end;

function TfrxStyles.Add: TfrxStyleItem;
begin
  Result := TfrxStyleItem(inherited Add);
end;

function TfrxStyles.Find(const Name: String): TfrxStyleItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TfrxStyles.GetItem(Index: Integer): TfrxStyleItem;
begin
  Result := TfrxStyleItem(inherited Items[Index]);
end;

procedure TfrxStyles.GetList(List: TStrings);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to Count - 1 do
    List.Add(Items[i].Name);
end;

procedure TfrxStyles.LoadFromXMLItem(Item: TfrxXMLItem; OldXMLFormat: Boolean);
var
  xs: TfrxXMLSerializer;
  i: Integer;
begin
  Clear;
  xs := TfrxXMLSerializer.Create(nil);
  try
    xs.OldFormat := OldXMLFormat;
    Name := Item.Prop['Name'];
    for i := 0 to Item.Count - 1 do
{$IFDEF Delphi12}
//      if AnsiStrIComp(PAnsiChar(Item[i].Name), PAnsiChar(AnsiString('item'))) = 0 then
      if CompareText(Item[i].Name, 'item') = 0 then
{$ELSE}
      if CompareText(Item[i].Name, 'item') = 0 then
{$ENDIF}
        xs.XMLToObj(Item[i].Text, Add);
  finally
    xs.Free;
  end;

  Apply;
end;

procedure TfrxStyles.SaveToXMLItem(Item: TfrxXMLItem);
var
  xi: TfrxXMLItem;
  xs: TfrxXMLSerializer;
  i: Integer;
begin
  xs := TfrxXMLSerializer.Create(nil);
  try
    Item.Name := 'style';
    Item.Prop['Name'] := Name;
    for i := 0 to Count - 1 do
    begin
      xi := Item.Add;
      xi.Name := 'item';
      xi.Text := xs.ObjToXML(Items[i]);
    end;
  finally
    xs.Free;
  end;
end;

procedure TfrxStyles.LoadFromFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyles.LoadFromStream(Stream: TStream);
var
  x: TfrxXMLDocument;
begin
  Clear;
  x := TfrxXMLDocument.Create;
  try
    x.LoadFromStream(Stream);
{$IFDEF Delphi12}
//    if AnsiStrIComp(PAnsiChar(x.Root.Name), PansiChar(AnsiString('style'))) = 0 then
    if CompareText(x.Root.Name, 'style') = 0 then
{$ELSE}
    if CompareText(x.Root.Name, 'style') = 0 then
{$ENDIF}
      LoadFromXMLItem(x.Root, x.OldVersion);
  finally
    x.Free;
  end;
end;

procedure TfrxStyles.SaveToFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyles.SaveToStream(Stream: TStream);
var
  x: TfrxXMLDocument;
begin
  x := TfrxXMLDocument.Create;
  x.AutoIndent := True;
  try
    x.Root.Name := 'style';
    SaveToXMLItem(x.Root);
    x.SaveToStream(Stream);
  finally
    x.Free;
  end;
end;

procedure TfrxStyles.Apply;
var
  i: Integer;
  l: TList;
begin
  if FReport <> nil then
  begin
    l := FReport.AllObjects;
    for i := 0 to l.Count - 1 do
      if TObject(l[i]) is TfrxCustomMemoView then
        if Find(TfrxCustomMemoView(l[i]).Style) = nil then
          TfrxCustomMemoView(l[i]).Style := ''
        else
          TfrxCustomMemoView(l[i]).Style := TfrxCustomMemoView(l[i]).Style;
  end;
end;


{ TfrxStyleSheet }

constructor TfrxStyleSheet.Create;
begin
  FItems := TList.Create;
end;

destructor TfrxStyleSheet.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TfrxStyleSheet.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

procedure TfrxStyleSheet.Delete(Index: Integer);
begin
  Items[Index].Free;
  FItems.Delete(Index);
end;

function TfrxStyleSheet.Add: TfrxStyles;
begin
  Result := TfrxStyles.Create(nil);
  FItems.Add(Result);
end;

function TfrxStyleSheet.Count: Integer;
begin
  Result := FItems.Count;
end;

function TfrxStyleSheet.GetItems(Index: Integer): TfrxStyles;
begin
  Result := FItems[Index];
end;

function TfrxStyleSheet.Find(const Name: String): TfrxStyles;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TfrxStyleSheet.IndexOf(const Name: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := i;
      break;
    end;
end;

procedure TfrxStyleSheet.GetList(List: TStrings);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to Count - 1 do
    List.Add(Items[i].Name);
end;

procedure TfrxStyleSheet.LoadFromFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyleSheet.LoadFromStream(Stream: TStream);
var
  x: TfrxXMLDocument;
  i: Integer;
begin
  Clear;
  x := TfrxXMLDocument.Create;
  try
    x.LoadFromStream(Stream);
{$IFDEF Delphi12}
//    if AnsiStrIComp(PAnsiChar(x.Root.Name), PAnsiChar(AnsiString('stylesheet'))) = 0 then
    if CompareText(x.Root.Name, 'stylesheet') = 0 then
{$ELSE}
    if CompareText(x.Root.Name, 'stylesheet') = 0 then
{$ENDIF}
      for i := 0 to x.Root.Count - 1 do
{$IFDEF Delphi12}
//        if AnsiStrIComp(PAnsiChar(x.Root[i].Name), PAnsiChar(AnsiString('style'))) = 0 then
        if CompareText(x.Root[i].Name, 'style') = 0 then
{$ELSE}
        if CompareText(x.Root[i].Name, 'style') = 0 then
{$ENDIF}
          Add.LoadFromXMLItem(x.Root[i], x.OldVersion);
  finally
    x.Free;
  end;
end;

procedure TfrxStyleSheet.SaveToFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyleSheet.SaveToStream(Stream: TStream);
var
  x: TfrxXMLDocument;
  i: Integer;
begin
  x := TfrxXMLDocument.Create;
  x.AutoIndent := True;
  try
    x.Root.Name := 'stylesheet';
    for i := 0 to Count - 1 do
      Items[i].SaveToXMLItem(x.Root.Add);

    x.SaveToStream(Stream);
  finally
    x.Free;
  end;
end;


{ TfrxReport }

constructor TfrxReport.Create(AOwner: TComponent);
begin
  inherited;
  FVersion := FR_VERSION;
  {$IFDEF FPC}
  { create parent form for OLE and RICH controls in the main thread }
  frxParentForm;
  {$ENDIF}
  FDatasets := TfrxReportDatasets.Create(Self);
  FVariables := TfrxVariables.Create;
  FScript := TfsScript.Create(nil);
  FScript.ExtendedCharset := True;
  FScript.AddRTTI;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 50;
  FTimer.Enabled := False;
  FTimer.OnTimer := OnTimer;

  FEngineOptions := TfrxEngineOptions.Create;
  FPreviewOptions := TfrxPreviewOptions.Create;
  FPrintOptions := TfrxPrintOptions.Create;
  FReportOptions := TfrxReportOptions.Create(Self);
  FReportOptions.FReport := Self;

  FIniFile := '\Software\Fast Reports';
  FScriptText := TStringList.Create;
  FFakeScriptText := TStringList.Create;
  FExpressionCache := TfrxExpressionCache.Create(FScript);
  FErrors := TStringList.Create;
  TStringList(FErrors).Sorted := True;
  TStringList(FErrors).Duplicates := dupIgnore;
  FStyles := TfrxStyles.Create(Self);
  FSysVariables := TStringList.Create;
  FEnabledDataSets := TfrxReportDataSets.Create(Self);
  FShowProgress := True;
  FStoreInDFM := True;

  FEngine := TfrxEngine.Create(Self);
  FPreviewPages := TfrxPreviewPages.Create(Self);
  FEngine.FPreviewPages := FPreviewPages;
  FPreviewPages.FEngine := FEngine;
  FDrawText := TfrxDrawText.Create;
  FDrillState := TStringList.Create;
  Clear;
{$IFDEF FR_COM}
  { initialize connection }
  CreateDefaultConnections;
  FUseDispatchableEvents := False;
  EngineOptions.DestroyForms := False;
  Name := 'Report';

  OnSetConnection := OnSetConnectionHandler;
  OnEditConnection := OnEditConnectionHandler;

  OnAfterPrint := OnAfterPrintHandler;
  OnBeforePrint := OnBeforePrintHandler;
  OnClickObject := OnClickObjectHandler;
  OnUserFunction := OnUserFunctionHandler;
  OnBeginDoc := OnBeginDocHandler;
  OnEndDoc := OnEndDocHandler;
  OnPrintReport := OnPrintReportHandler;
  OnAfterPrintReport := OnAfterPrintReportHandler;
  OnBeforeConnect := OnBeforeConnectHandler;

  OnProgress := OnProgressHandler;
  OnProgressStart := OnProgressStartHandler;
  OnProgressStop := OnProgressStopHandler;

//  Engine.OnRunDialog := OnRunDialogsEvent;

  FConnectionPoints := TConnectionPoints.Create(Self);
  FConnectionPoint :=  FConnectionPoints.CreateConnectionPoint( IfrxReportEventDispatcher, ckMulti, nil );
  FEvent := nil;
  FConnectionPoints.CreateConnectionPoint( IfrxReportEvents, ckSingle, EventSinkChanged );
{$ENDIF}
end;

destructor TfrxReport.Destroy;
begin
  inherited;
  if FPreviewForm <> nil then
    FPreviewForm.Close;
  Preview := nil;
  if FParentReportObject <> nil then
    FParentReportObject.Free;
  FDatasets.Free;
  FEngineOptions.Free;
  FPreviewOptions.Free;
  FPrintOptions.Free;
  FReportOptions.Free;
  FExpressionCache.Free;
  FScript.Free;
  FScriptText.Free;
  FFakeScriptText.Free;
  FVariables.Free;
  FEngine.Free;
  FPreviewPages.Free;
  FErrors.Free;
  FStyles.Free;
  FSysVariables.Free;
  FEnabledDataSets.Free;
  FTimer.Free;
{$IFNDEF FR_COM}
  TObject(FDrawText).Free;
{$ELSE}
  TfrxDrawText(FDrawText).Free;
{$ENDIF}
  FDrillState.Free;

  if FParentForm <> nil then
  begin
    FParentForm.Free;
	FParentForm := nil;
  end;
{$IFDEF FR_COM}
  FConnectionPoint.Free;
  FConnectionPoints.Free;
  frxADOCS.Enter;
  if Assigned(frxDefaultConnection) then
  begin
    { Destroy connection when delete last instance of TfrxReport }
    if frxADO_RefCount = 1 then
    begin
      frxDefaultConnection.Connected := false;
      frxDefaultConnection.Free;
      frxDefaultConnection := nil;
    end;
  end;
  Dec(frxADO_RefCount);
  frxADOCS.Leave;
{$ENDIF}
end;

class function TfrxReport.GetDescription: String;
begin
  Result := frxResources.Get('obReport');
end;

procedure TfrxReport.DoClear;
begin
  inherited Clear;
  FDataSets.Clear;
  FVariables.Clear;
  FEngineOptions.Clear;
  FPreviewOptions.Clear;
  FPrintOptions.Clear;
  FReportOptions.Clear;
  FStyles.Clear;
  FDataSet := nil;
  FDataSetName := '';
  FDotMatrixReport := False;
  ParentReport := '';

  FScriptLanguage := 'PascalScript';
  with FScriptText do
  begin
    Clear;
    Add('begin');
    Add('');
    Add('end.');
  end;

  with FSysVariables do
  begin
    Clear;
    Add('Date');
    Add('Time');
    Add('Page');
    Add('Page#');
    Add('TotalPages');
    Add('TotalPages#');
    Add('Line');
    Add('Line#');
    Add('CopyName#');
  end;

  FOnRunDialogs := '';
  FOnStartReport := '';
  FOnStopReport := '';
end;

procedure TfrxReport.Clear;
begin
{$IFNDEF FR_COM}
//  if FEngineOptions.ReportThread <> nil then
//    THackThread(FEngineOptions.ReportThread).Synchronize(DoClear) else
{$ENDIF}
    DoClear;
end;

procedure TfrxReport.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent is TfrxDataSet then
    begin
      if FDataSets.Find(TfrxDataSet(AComponent)) <> nil then
        FDataSets.Find(TfrxDataSet(AComponent)).Free;
      if FDataset = AComponent then
        FDataset := nil;
      if Designer <> nil then
        Designer.UpdateDataTree;
    end
//    else if AComponent is TfrxPreviewForm then
//      FPreviewForm := nil
    else if AComponent is TfrxCustomPreview then
      if FPreview = AComponent then
        FPreview := nil;
end;

procedure TfrxReport.AncestorNotFound(Reader: TReader; const ComponentName: string;
  ComponentClass: TPersistentClass; var Component: TComponent);
begin
  Component := FindObject(ComponentName);
end;

procedure TfrxReport.DefineProperties(Filer: TFiler);
begin
  inherited;
  if (csWriting in ComponentState) and not FStoreInDFM then Exit;

  Filer.DefineProperty('Datasets', ReadDatasets, WriteDatasets, True);
  Filer.DefineProperty('Variables', ReadVariables, WriteVariables, True);
  Filer.DefineProperty('Style', ReadStyle, WriteStyle, True);
  if Filer is TReader then
    TReader(Filer).OnAncestorNotFound := AncestorNotFound;
end;

procedure TfrxReport.ReadDatasets(Reader: TReader);
begin
  frxReadCollection(FDatasets, Reader, Self);
end;

procedure TfrxReport.ReadStyle(Reader: TReader);
begin
  frxReadCollection(FStyles, Reader, Self);
end;

procedure TfrxReport.ReadVariables(Reader: TReader);
begin
  frxReadCollection(FVariables, Reader, Self);
end;

procedure TfrxReport.WriteDatasets(Writer: TWriter);
begin
  frxWriteCollection(FDatasets, Writer, Self);
end;

procedure TfrxReport.WriteStyle(Writer: TWriter);
begin
  frxWriteCollection(FStyles, Writer, Self);
end;

procedure TfrxReport.WriteVariables(Writer: TWriter);
begin
  frxWriteCollection(FVariables, Writer, Self);
end;

function TfrxReport.GetPages(Index: Integer): TfrxPage;
begin
  Result := TfrxPage(Objects[Index]);
end;

function TfrxReport.GetPagesCount: Integer;
begin
  Result := Objects.Count;
end;

procedure TfrxReport.SetScriptText(const Value: TStrings);
begin
  FScriptText.Assign(Value);
end;

procedure TfrxReport.SetEngineOptions(const Value: TfrxEngineOptions);
begin
  FEngineOptions.Assign(Value);
end;

procedure TfrxReport.SetParentReport(const Value: String);
var
  i: Integer;
  list: TList;
  c: TfrxComponent;
  fName, SaveFileName: String;
  SaveXMLSerializer: TObject;
begin
  FParentReport := Value;
  if FParentReportObject <> nil then
  begin
    FParentReportObject.Free;
    FParentReportObject := nil;
  end;
  if Value = '' then
  begin
    list := AllObjects;
    for i := 0 to list.Count - 1 do
    begin
      c := list[i];
      c.FAncestor := False;
    end;

    FAncestor := False;
    Exit;
  end;

  SaveFileName := FFileName;
  SaveXMLSerializer := FXMLSerializer;
  if Assigned(FOnLoadTemplate) then
    FOnLoadTemplate(Self, Value)
  else
  begin
    fName := Value;
    { check relative path, exclude network path }
    if (Length(fName) > 1) and (fName[2] <> ':')
{$IFDEF FPC}
      and not ((fName[1] = PathDelim) and (fName[2] = PathDelim)) then
{$ELSE}
      and not ((fName[1] = '\') and (fName[2] = '\')) then
{$ENDIF}
      begin
        fName := ExtractFilePath(SaveFileName) + Value;
        if not FileExists(fName) then
          fName := GetApplicationFolder + Value;
      end;
    LoadFromFile(fName);
  end;

  if FParentReportObject <> nil then
    FParentReportObject.Free;
  FParentReportObject := TfrxReport.Create(nil);
  FParentReportObject.FileName := FFileName;
  if Assigned(FOnLoadTemplate) then
    FParentReportObject.OnLoadTemplate := FOnLoadTemplate;
  FParentReportObject.AssignAll(Self);
  FFileName := SaveFileName;

  for i := 0 to FParentReportObject.Objects.Count - 1 do
    if TObject(FParentReportObject.Objects[i]) is TfrxReportPage then
      TfrxReportPage(FParentReportObject.Objects[i]).PaperSize := 256;

  { set ancestor flag for parent objects }
  list := AllObjects;
  for i := 0 to list.Count - 1 do
  begin
    c := list[i];
    c.FAncestor := True;
  end;

  FAncestor := True;
  FParentReport := Value;
  FXMLSerializer := SaveXMLSerializer;
end;

function TfrxReport.InheritFromTemplate(const templName: String; InheriteMode: TfrxInheriteMode = imDefault): Boolean;
var
  tempReport: TfrxReport;
  Ref: TObject;
  i: Integer;
  DS: TfrxDataSet;
  lItem: TfrxFixupItem;
  l, FixupList: TList;
  c: TfrxComponent;
  found, DeleteDuplicates: Boolean;
  saveScript, OpenQuote, CloseQuote: String;
  fn1, fn2: String;

  procedure FixNames(OldName, NewName: String);
  var
    i: Integer;
  begin
    for i := 0 to FixupList.Count - 1 do
      with TfrxFixupItem(FixupList[i]) do
      begin
        if Value = OldName then Value := NewName;
      end;
  end;

  procedure EnumObjects(ToParent, FromParent: TfrxComponent);
  var
    xs: TfrxXMLSerializer;
    s, OldName: String;
    i: Integer;
    cFrom, cTo, tObj: TfrxComponent;
    cFromSubPage, cToSubPage: TfrxReportPage;
  begin
    xs := TfrxXMLSerializer.Create(nil);
    { don't serialize ParentReport property! }
    xs.SerializeDefaultValues := not (ToParent is TfrxReport);
    if FromParent.Owner is TfrxComponent then
      xs.Owner := TfrxComponent(FromParent.Owner);
    s := xs.ObjToXML(FromParent);
    if ToParent.Owner is TfrxComponent then
      xs.Owner := TfrxComponent(ToParent.Owner);
    xs.XMLToObj(s, ToParent);
    xs.CopyFixupList(FixupList);
    xs.Free;
    i := 0;
    while (i < FromParent.Objects.Count) do
    begin
      cFrom := FromParent.Objects[i];
//      cTo := ToParent.Report.FindObject(cFrom.Name);
      cTo := Self.FindObject(cFrom.Name);
      inc(i);

      if (cTo <> nil) and not (cTo is TfrxPage) then
      begin
        { skip duplicate object }
        if DeleteDuplicates then continue;
        { set empty name for duplicate object, rename later }
        OldName := cFrom.Name;
        cFrom.Name := '';
        cTo := nil;
      end;

      if cTo = nil then
      begin
        cTo := TfrxComponent(cFrom.NewInstance);
        cTo.Create(ToParent);
        if cFrom.Name = '' then
        begin
          cTo.CreateUniqueName;
          tObj := tempReport.FindObject(cTo.Name);
          if tObj <> nil then
          begin
            tObj.Name := '';
            cFrom.Name := cTo.Name;
            tObj.CreateUniqueName;
          end
          else cFrom.Name := cTo.Name;
          FixNames(OldName, cTo.Name);
          if cFrom is TfrxDataSet then
          begin
            TfrxDataSet(cFrom).UserName := cFrom.Name;
            Self.DataSets.Add(TfrxDataSet(cTo));
          end;
        end
        else
          cTo.Name := cFrom.Name;

        if cFrom is TfrxSubreport then
        begin
          cFromSubPage := TfrxSubreport(cFrom).Page;
          TfrxSubreport(cTo).Page := TfrxReportPage.Create(Self);
          cToSubPage := TfrxSubreport(cTo).Page;
          cToSubPage.Assign(cFromSubPage);
          cToSubPage.CreateUniqueName;
          EnumObjects(cToSubPage, cFromSubPage);
          tempReport.Objects.Remove(cFromSubPage);
        end
      end;
      EnumObjects(cTo, cFrom);
    end;
  end;

begin
  Result := True;
{$IFDEF FPC}
  if (Length(FileName) > 1) and ((FileName[1] = '.') or (FileName[1] = PathDelim)) then
{$ELSE}
  if (Length(FileName) > 1) and ((FileName[1] = '.') or (FileName[1] = '\')) then
{$ENDIF}
    fn1 := ExpandFileName(FileName)
  else
    fn1 := FileName;

{$IFDEF FPC}
  if (Length(templName) > 1) and ((templName[1] = '.') or (templName[1] = PathDelim)) then
{$ELSE}
  if (Length(templName) > 1) and ((templName[1] = '.') or (templName[1] = '\')) then
{$ENDIF}
    fn2 := ExpandFileName(templName)
  else
    fn2 := templName;

  if fn1 = fn2 then
  begin
    Result := False;
    Exit;
  end;

  tempReport := TfrxReport.Create(nil);
  FixupList := TList.Create;
  tempReport.AssignAll(Self);
  { load the template }
  ParentReport := ExtractRelativePath(ExtractFilePath(FileName), templName);
  { find duplicate objects }
  found := False;
  l := tempReport.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if not (c is TfrxPage) and (FindObject(c.Name) <> nil) then
    begin
      found := True;
      break;
    end;
  end;

  deleteDuplicates := False;
  if (found) and (InheriteMode = imDefault) then
  begin
    with TfrxInheritErrorForm.Create(nil) do
    begin
      Result := ShowModal = mrOk;
      if Result then
        deleteDuplicates := DeleteRB.Checked;
      Free;
    end;
  end
  else
    deleteDuplicates := (InheriteMode = imDelete);

  if Result then
  begin
    saveScript := ScriptText.Text;
    EnumObjects(Self, tempReport);

    if (Script.SyntaxType = 'C++Script') or (Script.SyntaxType = 'JScript') then
    begin
      OpenQuote := '/*';
      CloseQuote := '*/';
    end
    else if (Script.SyntaxType = 'BasicScript') then
    begin
      OpenQuote := '/\';
      CloseQuote := '/\';
    end
    else if (Script.SyntaxType = 'PascalScript') then
    begin
      OpenQuote := '{';
      CloseQuote := '}';
    end;

    ScriptText.Add(OpenQuote);
    ScriptText.Add('**********Script from parent report**********');
    ScriptText.Text := ScriptText.Text + saveScript;
    ScriptText.Add(CloseQuote);

    { fixup datasets }
    for i := 0 to Self.DataSets.Count - 1 do
//      if DataSets[i].DataSet = nil then
      begin
        DS := Self.FindDataSet(nil, DataSets[i].DataSetName);
        DataSets[i].DataSet := DS;
      end;

    { fixup properties}
    while FixupList.Count > 0 do
    begin
      lItem := TfrxFixupItem(FixupList[0]);
      Ref := Self.FindObject(lItem.Value);
      if Ref = nil then
        Ref := frxFindComponent(Self, lItem.Value);
      if Ref <> nil then
        SetOrdProp(lItem.Obj, lItem.PropInfo, frxInteger(Ref));
      lItem.Free;
      FixupList.Delete(0);
    end;
  end
  else
    AssignAll(tempReport);

  FixupList.Free;
  tempReport.Free;
end;

procedure TfrxReport.SetPreviewOptions(const Value: TfrxPreviewOptions);
begin
  FPreviewOptions.Assign(Value);
end;

procedure TfrxReport.SetPrintOptions(const Value: TfrxPrintOptions);
begin
  FPrintOptions.Assign(Value);
end;

procedure TfrxReport.SetReportOptions(const Value: TfrxReportOptions);
begin
  FReportOptions.Assign(Value);
end;

procedure TfrxReport.SetStyles(const Value: TfrxStyles);
begin
  if Value <> nil then
  begin
    FStyles.Assign(Value);
    FStyles.Apply;
  end
  else
    FStyles.Clear;
end;

procedure TfrxReport.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxReport.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxReport.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

function TfrxReport.Calc(const Expr: String; AScript: TfsScript = nil): Variant;
{$IFDEF FPC}
const
  SZeroDivide = 'Division by zero.';
  {$warning HARDCODED CONST SZeroDivide}
{$ENDIF}

var
  ErrorMsg: String;
  CalledFromScript: Boolean;
begin
  CalledFromScript := False;
  if frxInteger(AScript) = 1 then
  begin
    AScript := FScript;
    CalledFromScript := True;
  end;
  if AScript = nil then
    AScript := FScript;
  if not DoGetValue(Expr, Result) then
  begin
    Result := FExpressionCache.Calc(Expr, ErrorMsg, AScript);
    if (ErrorMsg <> '') and
     not ((ErrorMsg = SZeroDivide) and FEngineOptions.IgnoreDevByZero) then
    begin
      if not CalledFromScript then
      begin
        if FCurObject <> '' then
          ErrorMsg := FCurObject + ': ' + ErrorMsg;
        FErrors.Add(ErrorMsg);
      end
      else ErrorMsg := frxResources.Get('clErrorInExp') + ErrorMsg;
      raise Exception.Create(ErrorMsg);
    end;
  end;
end;

function TfrxReport.GetAlias(DataSet: TfrxDataSet): String;
var
  ds: TfrxDataSetItem;
begin
  if DataSet = nil then
  begin
    Result := '';
    Exit;
  end;

  ds := DataSets.Find(DataSet);
  if ds <> nil then
    Result := ds.DataSet.UserName else
    Result := frxResources.Get('clDSNotIncl');
end;

function TfrxReport.GetDataset(const Alias: String): TfrxDataset;
var
  ds: TfrxDataSetItem;
begin
  ds := DataSets.Find(Alias);
  if ds <> nil then
    Result := ds.DataSet else
    Result := nil;
end;

procedure TfrxReport.GetDatasetAndField(const ComplexName: String;
  var DataSet: TfrxDataSet; var Field: String);
var
  i: Integer;
  s: String;
begin
  DataSet := nil;
  Field := '';

  { ComplexName has format: dataset name."field name"
    Spaces are allowed in both parts of the complex name }
  i := Pos('."', ComplexName);
  if i <> 0 then
  begin
    s := Copy(ComplexName, 1, i - 1); { dataset name }
    DataSet := GetDataSet(s);
    Field := Copy(ComplexName, i + 2, Length(ComplexName) - i - 2);
  end;
end;

procedure TfrxReport.GetDataSetList(List: TStrings; OnlyDB: Boolean = False);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to DataSets.Count - 1 do
    if Datasets[i].DataSet <> nil then
      if not OnlyDB or not (DataSets[i].DataSet is TfrxUserDataSet) then
        List.AddObject(DataSets[i].DataSet.UserName, DataSets[i].DataSet);
end;

procedure TfrxReport.GetActiveDataSetList(List: TStrings);
var
  i: Integer;
  ds: TfrxDataSet;
begin
  if EngineOptions.FUseGlobalDataSetList then
    frxGetDataSetList(List)
  else
  begin
    List.Clear;
    for i := 0 to EnabledDataSets.Count - 1 do
    begin
      ds := EnabledDataSets[i].DataSet;
      if ds <> nil then
        List.AddObject(ds.UserName, ds);
    end;
  end;
end;

procedure TfrxReport.DoLoadFromStream;
var
  SaveLeftTop: Longint;
  Loaded: Boolean;
begin
  SaveLeftTop := DesignInfo;
  Loaded := False;

  if Assigned(frxFR2Events.OnLoad) then
    Loaded := frxFR2Events.OnLoad(Self, FLoadStream);

  if not Loaded then
    inherited LoadFromStream(FLoadStream);

  DesignInfo := SaveLeftTop;
end;

procedure TfrxReport.CheckDataPage;
var
  i, x: Integer;
  l: TList;
  hasDataPage, hasDataObjects: Boolean;
  p: TfrxDataPage;
  c: TfrxComponent;
begin
  { check if report has datapage and datacomponents }
  hasDataPage := False;
  hasDataObjects := False;
  l := AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxDataPage then
      hasDataPage := True;
    if c is TfrxDialogComponent then
      hasDataObjects := True;
  end;

  if not hasDataPage then
  begin
    { create the datapage }
    p := TfrxDataPage.Create(Self);
    if FindObject('Data') = nil then
      p.Name := 'Data'
    else
      p.CreateUniqueName;

    { make it the first page }
    Objects.Delete(Objects.Count - 1);
    Objects.Insert(0, p);

    { move existing datacomponents to this page }
    if hasDataObjects then
    begin
      x := 60;
      for i := 0 to l.Count - 1 do
      begin
        c := l[i];
        if c is TfrxDialogComponent then
        begin
          c.Parent := p;
          c.Left := x;
          c.Top := 20;
          Inc(x, 64);
        end;
      end;
    end;
  end;
end;

procedure TfrxReport.LoadFromStream(Stream: TStream);
var
  Compressor: TfrxCustomCompressor;
  Crypter: TfrxCustomCrypter;
  SaveEngineOptions: TfrxEngineOptions;
  SavePreviewOptions: TfrxPreviewOptions;
  SaveConvertNulls: Boolean;
  SaveIgnoreDevByZero: Boolean;
  SaveDoublePass: Boolean;
  SaveOutlineVisible, SaveOutlineExpand: Boolean;
  SaveOutlineWidth, SavePagesInCache: Integer;
  SaveIni: String;
  SavePreview: TfrxCustomPreview;
  SaveOldStyleProgress, SaveShowProgress, SaveStoreInDFM: Boolean;
  Crypted, SaveThumbnailVisible: Boolean;

  function DecodePwd(const s: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Length(s) do
      Result := Result + Chr(Ord(s[i]) + 10);
  end;

begin
  FErrors.Clear;

  Compressor := nil;
  if frxCompressorClass <> nil then
  begin
    Compressor := TfrxCustomCompressor(frxCompressorClass.NewInstance);
    Compressor.Create(nil);
    Compressor.Report := Self;
    Compressor.IsFR3File := True;
    try
      Compressor.CreateStream;
      if Compressor.Decompress(Stream) then
        Stream := Compressor.Stream;
    except
      Compressor.Free;
      FErrors.Add(frxResources.Get('clDecompressError'));
      frxCommonErrorHandler(Self, frxResources.Get('clErrors') + #13#10 + FErrors.Text);
      Exit;
    end;
  end;

  ReportOptions.Password := ReportOptions.HiddenPassword;
  Crypter := nil;
  Crypted := False;
  if frxCrypterClass <> nil then
  begin
    Crypter := TfrxCustomCrypter(frxCrypterClass.NewInstance);
    Crypter.Create(nil);
    try
      Crypter.CreateStream;
{$IFDEF Delphi12}
      Crypted := Crypter.Decrypt(Stream, AnsiString(ReportOptions.Password));
{$ELSE}
      Crypted := Crypter.Decrypt(Stream, ReportOptions.Password);
{$ENDIF}
      if Crypted then
        Stream := Crypter.Stream;
    except
      Crypter.Free;
      FErrors.Add(frxResources.Get('clDecryptError'));
      frxCommonErrorHandler(Self, frxResources.Get('clErrors') + #13#10 + FErrors.Text);
      Exit;
    end;
  end;

  SaveEngineOptions := TfrxEngineOptions.Create;
  SaveEngineOptions.Assign(FEngineOptions);
  SavePreviewOptions := TfrxPreviewOptions.Create;
  SavePreviewOptions.Assign(FPreviewOptions);
  SaveIni := FIniFile;
  SavePreview := FPreview;
  SaveOldStyleProgress := FOldStyleProgress;
  SaveShowProgress := FShowProgress;
  SaveStoreInDFM := FStoreInDFM;
  FStreamLoaded := True;
  try
    FLoadStream := Stream;
{$IFNDEF FR_COM}
//    if FEngineOptions.ReportThread <> nil then
//      THackThread(FEngineOptions.ReportThread).Synchronize(DoLoadFromStream) else
{$ENDIF}
    try
      DoLoadFromStream;
    except
      on E: Exception do
      begin
        FStreamLoaded := False;
        if (E is TfrxInvalidXMLException) and Crypted then
          FErrors.Add('Invalid password')
       else
         FErrors.Add(E.Message)
      end;
    end;
  finally
    if Compressor <> nil then
      Compressor.Free;
    if Crypter <> nil then
      Crypter.Free;

    CheckDataPage;

    SaveConvertNulls := FEngineOptions.ConvertNulls;
    SaveIgnoreDevByZero := FEngineOptions.IgnoreDevByZero;
    SaveDoublePass := FEngineOptions.DoublePass;
    FEngineOptions.Assign(SaveEngineOptions);
    FEngineOptions.ConvertNulls := SaveConvertNulls;
    FEngineOptions.IgnoreDevByZero := SaveIgnoreDevByZero; 
    FEngineOptions.DoublePass := SaveDoublePass;
    SaveEngineOptions.Free;

    SaveOutlineVisible := FPreviewOptions.OutlineVisible;
    SaveOutlineWidth := FPreviewOptions.OutlineWidth;
    SaveOutlineExpand := FPreviewOptions.OutlineExpand;
    SavePagesInCache := FPreviewOptions.PagesInCache;
    SaveThumbnailVisible := FPreviewOptions.ThumbnailVisible;
    FPreviewOptions.Assign(SavePreviewOptions);
    FPreviewOptions.OutlineVisible := SaveOutlineVisible;
    FPreviewOptions.OutlineWidth := SaveOutlineWidth;
    FPreviewOptions.OutlineExpand := SaveOutlineExpand;
    FPreviewOptions.PagesInCache := SavePagesInCache;
    FPreviewOptions.ThumbnailVisible := SaveThumbnailVisible;
    SavePreviewOptions.Free;
{$IFDEF FR_COM}
  {$IFDEF FR_FIB}
      frxDefaultFIBConnection.Connected := true;
  {$ENDIF}
{$ENDIF}
    FIniFile := SaveIni;
    FPreview := SavePreview;
    FOldStyleProgress := SaveOldStyleProgress;
    FShowProgress := SaveShowProgress;
    FStoreInDFM := SaveStoreInDFM;
    if not Crypted then
      ReportOptions.Password := DecodePwd(ReportOptions.Password);

    if ReportOptions.Info or ((not FReloading) and
{$IFNDEF FR_COM}
       (not FEngineOptions.EnableThreadSafe) and
{$ENDIF}
       (not Crypted and not FReportOptions.CheckPassword)) then

      Clear
    else if (FErrors.Count > 0) then
      frxCommonErrorHandler(Self, frxResources.Get('clErrors') + #13#10 + FErrors.Text);
  end;
end;

procedure TfrxReport.SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
  SaveDefaultValues: Boolean = False; UseGetAncestor: Boolean = False);
var
  Compressor: TfrxCustomCompressor;
  Crypter: TfrxCustomCrypter;
  StreamTo: TStream;
  SavePwd: String;
  SavePreview: TfrxCustomPreview;

  function EncodePwd(const s: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Length(s) do
      Result := Result + Chr(Ord(s[i]) - 10);
  end;

begin
  StreamTo := Stream;

  Compressor := nil;
  if FReportOptions.Compressed and (frxCompressorClass <> nil) then
  begin
    Compressor := TfrxCustomCompressor(frxCompressorClass.NewInstance);
    Compressor.Create(nil);
    Compressor.Report := Self;
    Compressor.IsFR3File := True;
    Compressor.CreateStream;
    StreamTo := Compressor.Stream;
  end;

  Crypter := nil;
  if (FReportOptions.Password <> '') and (frxCrypterClass <> nil) then
  begin
    Crypter := TfrxCustomCrypter(frxCrypterClass.NewInstance);
    Crypter.Create(nil);
    Crypter.CreateStream;
    StreamTo := Crypter.Stream;
  end;

  SavePwd := ReportOptions.Password;
  ReportOptions.PrevPassword := SavePwd;
  if Crypter = nil then
    ReportOptions.Password := EncodePwd(SavePwd);
  SavePreview := FPreview;
  FPreview := nil;

  try
    inherited SaveToStream(StreamTo, SaveChildren, SaveDefaultValues);
  finally
    FPreview := SavePreview;
    ReportOptions.Password := SavePwd;
    { crypt }
    if Crypter <> nil then
    begin
      try
        if Compressor <> nil then
{$IFDEF Delphi12}
          Crypter.Crypt(Compressor.Stream, UTF8Encode(ReportOptions.Password))
{$ELSE}
          Crypter.Crypt(Compressor.Stream, ReportOptions.Password)
{$ENDIF}
        else
{$IFDEF Delphi12}
          Crypter.Crypt(Stream, UTF8Encode(ReportOptions.Password));
{$ELSE}
          Crypter.Crypt(Stream, ReportOptions.Password);
{$ENDIF}
      finally
        Crypter.Free;
      end;
    end;
    { compress }
    if Compressor <> nil then
    begin
      try
        Compressor.Compress(Stream);
      finally
        Compressor.Free;
      end;
    end;
  end;
end;

function TfrxReport.LoadFromFile(const FileName: String;
  ExceptionIfNotFound: Boolean = False): Boolean;
var
  f: TFileStream;
begin
  Clear;
  FFileName := '';
  Result := FileExists(FileName);
  if Result or ExceptionIfNotFound then
  begin
    f := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      FFileName := FileName;
      LoadFromStream(f);

    finally
      f.Free;
    end;
  end;
end;

procedure TfrxReport.SaveToFile(const FileName: String);
var
  f: TFileStream;
begin
  //fix up ParentReport property
  if (Length(FParentReport) > 1) and (FParentReport[2] = ':') then
    FParentReport := ExtractRelativePath(ExtractFilePath(FileName), FParentReport);
  f := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

function TfrxReport.GetIniFile: TCustomIniFile;
begin
  {$IFNDEF FPC}
  if Pos('\Software\', FIniFile) = 1 then
    Result := TRegistryIniFile.Create(FIniFile)
  else
  {$ENDIF}
    Result := TIniFile.Create(FIniFile);
end;

function TfrxReport.GetApplicationFolder: String;
begin
  if csDesigning in ComponentState then
{$IFDEF FPC}
    Result := GetCurrentDir + PathDelim
{$ELSE}
    Result := GetCurrentDir + '\'
{$ENDIF}
  else
    Result := ExtractFilePath(Application.ExeName);
end;

procedure TfrxReport.SelectPrinter;
begin
  if frxPrinters.IndexOf(FPrintOptions.Printer) <> -1 then
    frxPrinters.PrinterIndex := frxPrinters.IndexOf(FPrintOptions.Printer);
end;

procedure TfrxReport.DoNotifyEvent(Obj: TObject; const EventName: String;
  RunAlways: Boolean = False);
begin
{$IFNDEF FR_VER_BASIC}
  if FEngine.Running or RunAlways then
    if EventName <> '' then
      FScript.CallFunction(EventName, VarArrayOf([frxInteger(Obj)]));
{$ENDIF}
end;

procedure TfrxReport.DoParamEvent(const EventName: String; var Params: Variant;
  RunAlways: Boolean = False);
begin
{$IFNDEF FR_VER_BASIC}
  if FEngine.Running or RunAlways then
    if EventName <> '' then
      FScript.CallFunction1(EventName, Params);
{$ENDIF}
end;

procedure TfrxReport.DoBeforePrint(c: TfrxReportComponent);
begin
  if Assigned(FOnBeforePrint) then
    FOnBeforePrint(c);
  DoNotifyEvent(c, c.OnBeforePrint);
end;

procedure TfrxReport.DoAfterPrint(c: TfrxReportComponent);
begin
  if Assigned(FOnAfterPrint) then
    FOnAfterPrint(c);
  DoNotifyEvent(c, c.OnAfterPrint);
end;

procedure TfrxReport.DoPreviewClick(v: TfrxView; Button: TMouseButton;
  Shift: TShiftState; var Modified: Boolean; DblClick: Boolean);
var
  arr: Variant;
begin
  arr := VarArrayOf([frxInteger(v), Button, ShiftToByte(Shift), Modified]);
  if DblClick then
    DoParamEvent(v.OnPreviewDblClick, arr, True)
  else
    DoParamEvent(v.OnPreviewClick, arr, True);
  Modified := arr[3];
  if DblClick then
  begin
    if Assigned(FOnDblClickObject) then
      FOnDblClickObject(v, Button, Shift, Modified)
  end
  else
    if Assigned(FOnClickObject) then
      FOnClickObject(v, Button, Shift, Modified);
end;

procedure TfrxReport.DoGetAncestor(const Name: String; var Ancestor: TPersistent);
begin
  if FParentReportObject <> nil then
  begin
    if Name = Self.Name then
      Ancestor := FParentReportObject
    else
      Ancestor := FParentReportObject.FindObject(Name);
  end;
end;

function TfrxReport.DoGetValue(const Expr: String; var Value: Variant): Boolean;
var
  i: Integer;
  ds: TfrxDataSet;
  fld: String;
  val: Variant;
  v: TfsCustomVariable;
begin
  Result := False;
  Value := Null;

  if Assigned(frxFR2Events.OnGetValue) then
  begin
    TVarData(val).VType := varEmpty;
    frxFR2Events.OnGetValue(Expr, val);
    if TVarData(val).VType <> varEmpty then
    begin
      Value := val;
      Result := True;
      Exit;
    end;
  end;

  { maybe it's a dataset/field? }
  GetDataSetAndField(Expr, ds, fld);
  if (ds <> nil) and (fld <> '') then
  begin
    Value := ds.Value[fld];
    if FEngineOptions.ConvertNulls and (Value = Null) then
      case ds.FieldType[fld] of
        fftNumeric:
          Value := 0;
        fftString:
          Value := '';
        fftBoolean:
          Value := False;
      end;
    Result := True;
    Exit;
  end;

  { searching in the sys variables }
  i := FSysVariables.IndexOf(Expr);
  if i <> -1 then
  begin
    case i of
      0: Value := FEngine.StartDate;  { Date }
      1: Value := FEngine.StartTime;  { Time }
      2: Value := FPreviewPages.GetLogicalPageNo; { Page }
      3: Value := FPreviewPages.CurPage + 1;  { Page# }
      4: Value := FPreviewPages.GetLogicalTotalPages;  { TotalPages }
      5: Value := FEngine.TotalPages;  { TotalPages# }
      6: Value := FEngine.CurLine;  { Line }
      7: Value := FEngine.CurLineThrough; { Line# }
      8: Value := frxGlobalVariables['CopyName0'];
    end;
    Result := True;
    Exit;
  end;

  { value supplied by OnGetValue event }
  TVarData(val).VType := varEmpty;
  if Assigned(FOnGetValue) then
    FOnGetValue(Expr, val);
  if Assigned(FOnNewGetValue) then
    FOnNewGetValue(Self, Expr, val);
  if TVarData(val).VType <> varEmpty then
  begin
    Value := val;
    Result := True;
    Exit;
  end;

  { searching in the variables }
  i := FVariables.IndexOf(Expr);
  if i <> -1 then
  begin
    val := FVariables.Items[i].Value;
    if (TVarData(val).VType = varString) or (TVarData(val).VType = varOleStr){$IFDEF Delphi12} or (TVarData(val).VType = varUString){$ENDIF} then
    begin
      if Pos(#13#10, val) <> 0 then
        Value := val
      else
        Value := Calc(val);
    end
    else
      Value := val;
    Result := True;
    Exit;
  end;

  { searching in the global variables }
  i := frxGlobalVariables.IndexOf(Expr);
  if i <> -1 then
  begin
    Value := frxGlobalVariables.Items[i].Value;
    Result := True;
    Exit;
  end;

  if not Assigned(frxFR2Events.OnGetScriptValue) then
  begin
    { searching in the script }
    v := FScript.FindLocal(Expr);
    if (v <> nil) and
      not ((v is TfsProcVariable) or (v is TfsMethodHelper)) then
    begin
      Value := v.Value;
      Result := True;
      Exit;
    end;
  end;
end;

function TfrxReport.GetScriptValue(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  i: Integer;
  s: String;
begin
  if not DoGetValue(Params[0], Result) then
  begin
    { checking aggregate functions }
    s := VarToStr(Params[0]);
    i := Pos('(', s);
    if i <> 0 then
    begin
      s := UpperCase(Trim(Copy(s, 1, i - 1)));
      if (s = 'SUM') or (s = 'MIN') or (s = 'MAX') or
         (s = 'AVG') or (s = 'COUNT') then
      begin
        Result := Calc(Params[0]);
        Exit;
      end;
    end;

    if Assigned(frxFR2Events.OnGetScriptValue) then
      Result := frxFR2Events.OnGetScriptValue(Params)
    else
      FErrors.Add(frxResources.Get('clUnknownVar') + ' ' + VarToStr(Params[0]));
  end;
end;

function TfrxReport.SetScriptValue(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  FVariables[Params[0]] := Params[1];
end;

function TfrxReport.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  p1, p2, p3: Variant;
begin
  if MethodName = 'IIF' then
  begin
    p1 := Params[0];
    p2 := Params[1];
    p3 := Params[2];
    try
      if Calc(p1, FScript.ProgRunning) = True then
        Result := Calc(p2, FScript.ProgRunning) else
        Result := Calc(p3, FScript.ProgRunning);
    except
    end;
  end
  else if (MethodName = 'SUM') or (MethodName = 'AVG') or
    (MethodName = 'MIN') or (MethodName = 'MAX') then
  begin
    p2 := Params[1];
    if Trim(VarToStr(p2)) = '' then
      p2 := 0
    else
      p2 := Calc(p2, FScript.ProgRunning);
    p3 := Params[2];
    if Trim(VarToStr(p3)) = '' then
      p3 := 0
    else
      p3 := Calc(p3, FScript.ProgRunning);
    Result := FEngine.GetAggregateValue(MethodName, Params[0],
      TfrxBand(frxInteger(p2)), p3);
  end
  else if MethodName = 'COUNT' then
  begin
    p1 := Params[0];
    if Trim(VarToStr(p1)) = '' then
      p1 := 0
    else
      p1 := Calc(p1, FScript.ProgRunning);
    p2 := Params[1];
    if Trim(VarToStr(p2)) = '' then
      p2 := 0
    else
      p2 := Calc(p2, FScript.ProgRunning);
    Result := FEngine.GetAggregateValue(MethodName, '',
      TfrxBand(frxInteger(p1)), p2);
  end
end;

function TfrxReport.DoUserFunction(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if Assigned(FOnUserFunction) then
    Result := FOnUserFunction(MethodName, Params);
end;

function TfrxReport.PrepareScript: Boolean;
var
  i: Integer;
  l: TList;
  c: TfrxComponent;
begin
  FExpressionCache.Clear;
  FExpressionCache.FScriptLanguage := FScriptLanguage;
  FEngine.NotifyList.Clear;

  FScript.ClearItems(Self);
  FScript.AddedBy := Self;
  FScript.MainProg := True;
  try
    l := AllObjects;
    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      c.IsDesigning := False;
      c.BeforeStartReport;
      if c is TfrxPictureView then
        TfrxPictureView(c).FPictureChanged := True;
      FScript.AddObject(c.Name, c);
    end;

    FScript.AddObject('Report', Self);
    FScript.AddObject('Engine', FEngine);
    FScript.AddObject('Outline', FPreviewPages.Outline);
    FScript.AddVariable('Value', 'Variant', Null);
    FScript.AddVariable('Self', 'TfrxView', Null);
    FScript.AddMethod('function Get(Name: String): Variant', GetScriptValue);
    FScript.AddMethod('procedure Set(Name: String; Value: Variant)', SetScriptValue);
    FScript.AddMethod('macrofunction IIF(Expr: Boolean; TrueValue, FalseValue: Variant): Variant',
      CallMethod);
    FScript.AddMethod('macrofunction SUM(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      CallMethod);
    FScript.AddMethod('macrofunction AVG(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      CallMethod);
    FScript.AddMethod('macrofunction MIN(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      CallMethod);
    FScript.AddMethod('macrofunction MAX(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      CallMethod);
    FScript.AddMethod('macrofunction COUNT(Band: Variant = 0; Flags: Integer = 0): Variant',
      CallMethod);

    if Assigned(frxFR2Events.OnPrepareScript) then
      frxFR2Events.OnPrepareScript(Self);
    FLocalValue := FScript.Find('Value');
    FSelfValue := FScript.Find('Self');
    FScript.Lines := FScriptText;
    FScript.SyntaxType := FScriptLanguage;
  {$IFNDEF FR_VER_BASIC}
    Result := FScript.Compile;
    if not Result then
      FErrors.Add(Format(frxResources.Get('clScrError'),
        [FScript.ErrorPos, FScript.ErrorMsg]));
  {$ELSE}
    Result := True;
  {$ENDIF}
  finally
    FScript.AddedBy := nil;
  end;
end;

{$IFDEF FR_COM}
procedure TfrxReport.EventSinkChanged(const Sink: IUnknown; Connecting: Boolean);
begin
  if Connecting
    then FEvent := Sink as IfrxReportEvents
  else
    FEvent := nil;
end;

function TfrxReport.PrepareReport(ClearLastReport: WordBool = True): HResult; stdcall;
var
  TempStream: TStream;
  ErrorsText: String;
  ErrorMessage: String;

begin

  if ClearLastReport then PreviewPages.Clear;

  FErrors.Clear;
  FTerminated := False;
//  FFinished := False;
  Result := S_OK + 1;

  if FEngineOptions.DestroyForms then
  begin
    TempStream := TMemoryStream.Create;
    SaveToStream(TempStream);
  end
  else TempStream := nil;

  try
    if Assigned(FOnBeginDoc) then FOnBeginDoc(Self);

    if PrepareScript then
    begin
      if FScript.Statement.Count > 0 then FScript.Execute;
      if FEngine.Run then
      begin
        if Assigned(FOnEndDoc) then  FOnEndDoc(Self);
        Result := S_OK;
      end
      else if FPreviewForm <> nil then FPreviewForm.Close;
    end;

  except
      on e: Exception do FErrors.Add(e.Message);
  end;

  if TempStream <> nil then
  begin
    ErrorsText := FErrors.Text;
    TempStream.Position := 0;
    FReloading := True;
    try
      LoadFromStream(TempStream);
    finally
        FReloading := False;
    end;
    TempStream.Free;
    FErrors.Text := ErrorsText;
  end;

  if FErrors.Text <> '' then
  begin
    Result := E_FAIL;
    ErrorMessage := frxResources.Get('clErrors') + #13#10 + FErrors.Text;
    frxCommonErrorHandler(Self, ErrorMessage);
  end;

end;

{$ELSE} // FR_COM

function TfrxReport.PrepareReport(ClearLastReport: Boolean = True): Boolean;
var
  TempStream: TStream;
  ErrorsText: String;
  ErrorMessage: String;
  SavePwd: String;
  SaveSplisLine: Integer;
  TmpFile: String;
  EngineRun: Boolean;

  function CheckDatasets: Boolean;
  var
    i: Integer;
  begin
    for i := 0 to FDataSets.Count - 1 do
      if FDatasets[i].DataSet = nil then
        FErrors.Add(Format(frxResources.Get('clDSNotExist'), [FDatasets[i].DataSetName]));
    Result := FErrors.Count = 0;
  end;

begin
  if ClearLastReport then
    PreviewPages.Clear;
  SaveSplisLine := 0;
  FErrors.Clear;
  FTerminated := False;
  Result := False;
  EngineRun := False;

  if CheckDatasets then
  begin
    TempStream := nil;
    SavePwd := ReportOptions.Password;

    { save the report state }
    if FEngineOptions.DestroyForms then
    begin
      if EngineOptions.UseFileCache then
      begin
        TmpFile := frxCreateTempFile(EngineOptions.TempDir);
        TempStream := TFileStream.Create(TmpFile, fmCreate);
      end
      else TempStream := TMemoryStream.Create;

      ReportOptions.Password := '';
      SaveSplisLine := PrintOptions.SplicingLine;
      SaveToStream(TempStream);
    end;

    try
      if Assigned(FOnBeginDoc) then
        FOnBeginDoc(Self);
      if PrepareScript then
      begin
{$IFNDEF FR_VER_BASIC}
        if Assigned(FOnAfterScriptCompile) then FOnAfterScriptCompile(Self);
        if FScript.Statement.Count > 0 then
          FScript.Execute;
{$ENDIF}
        if not Terminated then
          EngineRun := FEngine.Run;
        if EngineRun then
        begin
          if Assigned(FOnEndDoc) then
            FOnEndDoc(Self);
          Result := True
        end
        else if FPreviewForm <> nil then
          FPreviewForm.Close;
      end;
    except
      on e: Exception do
        FErrors.Add(e.Message);
    end;

    if FEngineOptions.DestroyForms then
    begin
      ErrorsText := FErrors.Text;
      TempStream.Position := 0;
      FReloading := True;
      try
//        if FEngineOptions.ReportThread = nil then
          LoadFromStream(TempStream);
      finally
        FReloading := False;
        ReportOptions.Password := SavePwd;
        PrintOptions.SplicingLine := SaveSplisLine;
      end;
      TempStream.Free;
      if EngineOptions.UseFileCache then
        SysUtils.DeleteFile(TmpFile);
      FErrors.Text := ErrorsText;
    end;
  end;

  if FErrors.Text <> '' then
  begin
    Result := False;
    ErrorMessage := frxResources.Get('clErrors') + #13#10 + FErrors.Text;
    frxCommonErrorHandler(Self, ErrorMessage);
  end;
end;

{$ENDIF}  // FR_COM

{$IFDEF FR_COM}
function TfrxReport.ShowPreparedReport: HResult; stdcall;
{$ELSE}
procedure TfrxReport.ShowPreparedReport;
{$ENDIF}
var
  WndExStyles: Integer;
  i:Integer;
  fLockDesignerB:Boolean;
begin
  // если есть такой параметр, тогда блокируем корректировку
  if Variables['isLockDesignerB'] <> null
  then if AnsiUpperCase(Variables['isLockDesignerB']) = AnsiUpperCase('True') then fLockDesignerB:= true;
  //
  //
  FPreviewForm := nil;
  if FPreview <> nil then
  begin
    FPreview.FReport := Self;
    FPreview.FPreviewPages := FPreviewPages;
    FPreview.Init;
  end
  else
  begin
    FPreviewForm := TfrxPreviewForm.Create(Application);
    with TfrxPreviewForm(FPreviewForm) do
    begin
      if fLockDesignerB = true then DesignerB.OnClick:= DesignerBClick2;
      ///
      Preview.FReport := Self;
      Preview.FPreviewPages := FPreviewPages;
      FPreview := Preview;
      Init;
      if Assigned(FOnPreview) then
        FOnPreview(Self);
      if PreviewOptions.Maximized then
        Position := poDesigned;
      if FPreviewOptions.Modal then
      begin
        ShowModal;
        Free;
        FPreviewForm := nil;
      end
      else
      begin
        if not FPreviewOptions.MDIChild then
        begin
          WndExStyles := GetWindowLong(Handle, GWL_EXSTYLE);
          SetWindowLong(Handle, GWL_EXSTYLE, WndExStyles or WS_EX_APPWINDOW);
        end;
        FreeOnClose := True;
        Show;
      end;
    end;
  end;
{$IFDEF FR_COM}
    Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxReport.ShowReport: HResult; stdcall;
const ClearLastReport: Boolean = True;
{$ELSE}
procedure TfrxReport.ShowReport(ClearLastReport: Boolean = True);
{$ENDIF}
begin
  if ClearLastReport then
    PreviewPages.Clear;

  if FOldStyleProgress then
  begin
{$IFNDEF FR_COM}
    if PrepareReport(False) then
      ShowPreparedReport;
{$ELSE}
    Result := PrepareReport(False);
    if Result = S_OK then
      Result := ShowPreparedReport;
{$ENDIF}
  end
  else
  begin
    FTimer.Enabled := True;
{$IFNDEF FR_COM}
    ShowPreparedReport;
{$ELSE}
    Result := ShowPreparedReport;
{$ENDIF}
  end;
end;

procedure TfrxReport.OnTimer(Sender: TObject);
begin
  FTimer.Enabled := False;
  PrepareReport(False);
end;

{$HINTS OFF}

{$UNDEF FR_RUN_DESIGNER}

{$IFDEF FR_LITE}
  {$DEFINE FR_RUN_DESIGNER}
{$ENDIF}

{$IFNDEF FR_VER_BASIC}
  {$DEFINE FR_RUN_DESIGNER}
{$ENDIF}

{$IFDEF FR_COM}
function TfrxReport.DesignReport: HResult; stdcall;
begin
  Result := DesignReportEx( True, False, Application.Handle );
end;

function TfrxReport.DesignReportEx(Modal: WordBool; MDIChild: WordBool; ParentWindowHandle: Integer): HResult; stdcall;
const
  CLASS_E_NOTLICENSED = HRESULT($80040112);
  ModeName       : PAnsiChar   = '';

var
  {$IFDEF ACTIVATION}
  UserKey        : PAnsiChar;
  UserName       : PAnsiChar;
  TrialDaysTotal : Longword;
  TrialDaysLeft  : Longword;
  ModeStatus     : TModeStatus;
  ini            : TRegistry;
  {$ENDIF}
{$ELSE}
procedure TfrxReport.DesignReport(Modal: Boolean = True; MDIChild: Boolean = False);
var
{$ENDIF}
  l: TList;
  i: Integer;
  c: TfrxComponent;
  WndExStyles: Integer;
begin
{$IFDEF FR_COM}
  Result := S_OK;
  Application.Handle := HWND(ParentWindowHandle);
  {$IFDEF ACTIVATION}
  {$I include\UserPolyBuffer.inc}
  //{$I include\DelphiEnvelopeCheck.inc}
    TrialDaysTotal := Longword(-1);
    TrialDaysLeft  := Longword(-1);
    UserKey        := nil;
    UserName       := nil;
    ModeName       := nil;
    // Get current activation mode and call remainder if mode is TRIAL
    GetModeInformation( 0, ModeName, ModeStatus );
    if ModeStatus.ModeID = 1 then
    begin
    {------------------}
      ini := TRegistry.Create;
      try
        ini.RootKey := HKEY_CURRENT_USER;
        if ini.OpenKeyReadOnly(DEF_REG_SERIAL) then
        begin
          if ini.ValueExists('Serial') then
          begin
            Remainder := TRemainder.Create(nil);
            Remainder.ShowModal;
            Remainder.Free;
          end;
          ini.CloseKey;
        end;
      finally
        ini.Free;
      end;
    {------------------}
    end;
  {$ENDIF}
{$ENDIF}
{$IFDEF FR_RUN_DESIGNER}
  if FDesigner <> nil then Exit;
  if frxDesignerClass <> nil then
  begin
    FScript.ClearItems(Self);
    l := AllObjects;
    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if c is TfrxCustomDBDataset then
        c.BeforeStartReport;
    end;

    FModified := False;
    FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
    FDesigner.CreateDesigner(nil, Self);
{$IFDEF FR_COM}
  {$IFDEF ACTIVATION_BYE}
    FDesigner.IsExpired := True;

    GetModeInformation( 0, ModeName, ModeStatus );
    {$I include\DelphiEnvelopeCheck.inc}
    if ModeStatus.ModeID = 2 then
    begin
  //    {$I include\aspr_crypt_begin1.inc}
      if ModeStatus.IsWrongHardwareID or ModeStatus.IsBlackListedKey then
      begin
        Result := CLASS_E_NOTLICENSED;
        Exit;
      end;
      FDesigner.IsExpired := False;
  //    {$I include\aspr_crypt_end1.inc}
    end
    else if GetTrialDays( 0, TrialDaysTotal, TrialDaysLeft ) then
      If TrialDaysLeft <> 0 then FDesigner.IsExpired := False;
  {$ELSE}
  FDesigner.IsExpired := False;
  {$ENDIF}

{$ENDIF}

    if MDIChild then
      FDesigner.FormStyle := fsMDIChild;
    PostMessage(FDesigner.Handle, WM_USER + 1, 0, 0);
    if Modal then
    begin
      FDesigner.ShowModal;
      FDesigner.Free;
      Application.ProcessMessages;
      FDesigner := nil;
    end
    else
    begin
      {if window not modal show it in taskbar}
      WndExStyles := GetWindowLong(FDesigner.Handle, GWL_EXSTYLE);
      SetWindowLong(FDesigner.Handle, GWL_EXSTYLE, WndExStyles or WS_EX_APPWINDOW);
      FDesigner.Show;
    end;
  end
  {$IFNDEF FR_COM}
  ;
  {$ELSE}
  else Result := E_NOINTERFACE;
  {$ENDIF}
{$ENDIF}
end;
{$HINTS ON}

procedure TfrxReport.DesignReportInPanel(Panel: TWinControl);
{$IFDEF FR_RUN_DESIGNER}
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
  ct: TControl;
  cp: TWinControl;
{$ENDIF}
begin
{$IFDEF FR_RUN_DESIGNER}
  if FDesigner <> nil then Exit;
  if frxDesignerClass <> nil then
  begin
    FScript.ClearItems(Self);
    l := AllObjects;
    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if c is TfrxCustomDBDataset then
        c.BeforeStartReport;
    end;

    FModified := False;
    FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
    FDesigner.CreateDesigner(nil, Self);
    cp := Panel.Parent;
    while cp <> nil do
    begin
      if cp is TForm then
        FDesigner.ParentForm := TForm(cp);
      cp:= cp.Parent;
    end;
    PostMessage(FDesigner.Handle, WM_USER + 1, 0, 0);
    FDesigner.OnShow(FDesigner);

    while FDesigner.ControlCount > 0 do
    begin
      ct := FDesigner.Controls[0];
      ct.Parent := Panel;
    end;
  end;
{$ENDIF}
end;


procedure TfrxReport.DesignReport(IDesigner: {$IFDEF FPC}TObject{$ELSE}IUnknown{$ENDIF}; Editor: TObject);
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
begin
  if FDesigner <> nil then
  begin
    FDesigner.Activate;
    Exit;
  end;
  if (IDesigner = nil) or (Editor.ClassName <> 'TfrxReportEditor') then Exit;

  l := AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxCustomDBDataset then
      c.BeforeStartReport;
  end;

  FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
  FDesigner.CreateDesigner(nil, Self);
  FDesigner.ShowModal;
end;

{$HINTS OFF}
function TfrxReport.DesignPreviewPage: Boolean;
begin
  Result := False;
{$IFNDEF FR_VER_BASIC}
  if FDesigner <> nil then Exit;
  if frxDesignerClass <> nil then
  begin
    FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
    FDesigner.CreateDesigner(nil, Self, True);
    FDesigner.ShowModal;
    Result := FModified;
  end;
{$ENDIF}
end;
{$HINTS ON}

function TfrxReport.Export(Filter: TfrxCustomExportFilter): Boolean;
begin
  Result := FPreviewPages.Export(Filter);
end;

function TfrxReport.Print: Boolean;
begin
  Result := FPreviewPages.Print;
end;

{$IFDEF FR_COM}
function TfrxReport.AddFunction(
  const FuncName: WideString;
  const Category: WideString;
  const Description: WideString): HResult; stdcall;
{$ELSE}
procedure TfrxReport.AddFunction(const FuncName: String;
  const Category: String = ''; const Description: String = '');
{$ENDIF}
begin
  FScript.AddedBy := nil;
  FScript.AddMethod(FuncName, DoUserFunction, Category, Description);
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

function TfrxReport.GetLocalValue: Variant;
begin
  Result := FLocalValue.Value;
end;

function TfrxReport.GetSelfValue: TfrxView;
begin
  Result := TfrxView(frxInteger(FSelfValue.Value));
end;

procedure TfrxReport.SetLocalValue(const Value: Variant);
begin
  FLocalValue.Value := Value;
end;

procedure TfrxReport.SetSelfValue(const Value: TfrxView);
begin
  FSelfValue.Value := frxInteger(Value);
end;

procedure TfrxReport.SetTerminated(const Value: Boolean);
begin
  FTerminated := Value;
  if Value then
    FScript.Terminate;
end;

procedure TfrxReport.SetPreview(const Value: TfrxCustomPreview);
begin
  if (FPreview <> nil) and (Value = nil) then
  begin
    FPreview.FReport := nil;
    FPreview.FPreviewPages := nil;
    FPreviewForm := nil;
  end;

  FPreview := Value;

  if FPreview <> nil then
  begin
    FPreview.FReport := Self;
    FPreview.FPreviewPages := FPreviewPages;
    FPreview.Init;
  end;
end;

function TfrxReport.GetCaseSensitive: Boolean;
begin
{$IFDEF Delphi6}
  Result := FExpressionCache.CaseSensitive;
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TfrxReport.GetScriptText: TStrings;
begin
  if (csWriting in ComponentState) and not FStoreInDFM then
    Result := FFakeScriptText
   else Result := FScriptText;
end;

procedure TfrxReport.SetCaseSensitive(const Value: Boolean);
begin
{$IFDEF Delphi6}
  FExpressionCache.CaseSensitive := Value;
{$ENDIF}
end;

procedure TfrxReport.InternalOnProgressStart(ProgressType: TfrxProgressType);
begin
{$IFNDEF FR_COM}
  if (FEngineOptions.EnableThreadSafe) then Exit; //(FEngineOptions.ReportThread <> nil) or
{$ENDIF}

  if Assigned(FOnProgressStart) then
    FOnProgressStart(Self, ProgressType, 0);

  if OldStyleProgress or (ProgressType <> ptRunning) then
  begin
    if FShowProgress then
    begin
      if FProgress <> nil then
        FProgress.Free;
      FProgress := TfrxProgress.Create(nil);
      FProgress.Execute(0, '', True, False);
    end;
  end;

  if (FPreview <> nil) and (ProgressType = ptRunning) then
    FPreview.InternalOnProgressStart(Self, ProgressType, 0);
  Application.ProcessMessages;
end;

procedure TfrxReport.InternalOnProgress(ProgressType: TfrxProgressType;
  Progress: Integer);
begin
{$IFNDEF FR_COM}
  if FEngineOptions.EnableThreadSafe then Exit;
//  if FEngineOptions.ReportThread <> nil then Exit;
{$ENDIF}

  if Assigned(FOnProgress) then
    FOnProgress(Self, ProgressType, Progress);

  if OldStyleProgress or (ProgressType <> ptRunning) then
  begin
    if FShowProgress then
    begin
      case ProgressType of
        ptRunning:
          if not Engine.FinalPass then
            FProgress.Message := Format(frxResources.Get('prRunningFirst'), [Progress])
          else
            FProgress.Message := Format(frxResources.Get('prRunning'), [Progress]);
        ptPrinting:
          FProgress.Message := Format(frxResources.Get('prPrinting'), [Progress]);
        ptExporting:
          FProgress.Message := Format(frxResources.Get('prExporting'), [Progress]);
      end;
      if FProgress.Terminated then
        Terminated := True;
    end;
  end;

  if (FPreview <> nil) and (ProgressType = ptRunning) then
    FPreview.InternalOnProgress(Self, ProgressType, Progress - 1);
  Application.ProcessMessages;
end;

procedure TfrxReport.InternalOnProgressStop(ProgressType: TfrxProgressType);
begin
{$IFNDEF FR_COM}
  if FEngineOptions.EnableThreadSafe then Exit;
//  if FEngineOptions.ReportThread <> nil then Exit;
{$ENDIF}

  if Assigned(FOnProgressStop) then
    FOnProgressStop(Self, ProgressType, 0);

  if OldStyleProgress or (ProgressType <> ptRunning) then
  begin
    if FShowProgress then
    begin
      FProgress.Free;
      FProgress := nil;
    end;
  end;

  if (FPreview <> nil) and (ProgressType = ptRunning) then
    FPreview.InternalOnProgressStop(Self, ProgressType, 0);
  Application.ProcessMessages;
end;

procedure TfrxReport.SetProgressMessage(const Value: String; IsHint: Boolean);
begin
{$IFNDEF FR_COM}
  if FEngineOptions.EnableThreadSafe then Exit;
//  if FEngineOptions.ReportThread <> nil then Exit;
{$ENDIF}

  if OldStyleProgress and Engine.Running then
  begin
    if FShowProgress then
      FProgress.Message := Value
  end;

  if FPreviewForm <> nil then
    TfrxPreviewForm(FPreviewForm).SetMessageText(Value, IsHint);
  Application.ProcessMessages;
end;

procedure TfrxReport.SetVersion(const Value: String);
begin
  FVersion := FR_VERSION;
end;

{$IFDEF FR_COM}
procedure TfrxReport.OnSetConnectionHandler(const ConnString: String);
begin
  frxDefaultConnection.Connected := False;
  frxDefaultConnection.ConnectionString := ConnString;

{$IFDEF FIBPLUS}
/// Samuray
  frxDefaultFIBConnection.Database.Connected := False;
  frxDefaultFIBConnection.FromString(ConnString);

{$ENDIF}
end;

function TfrxReport.OnEditConnectionHandler(const ConnString: String): String;
begin
  Result := PromptDataSource(0, ConnString);
end;

procedure TfrxReport.OnAfterPrintHandler(Sender: TfrxReportComponent);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
  Obj:  IfrxComponent;
begin
  if FEvent <> nil then
  begin
    if FUseDispatchableEvents = True then
    begin
      Obj := DispatchableComponentFactory.CreateComObject(Sender) as IfrxComponent;
      FEvent.OnAfterPrint(Obj);
      Obj._Release;
    end
    else
      FEvent.OnAfterPrint(Sender)
  end
  else
  begin
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxReportEventDispatcher).OnAfterPrint(Sender);
      ConnectData.pUnk := nil;
    end;
    Enum := nil;
  end;
end;

procedure TfrxReport.OnBeforePrintHandler(Sender: TfrxReportComponent);
var
  Enum :        IEnumConnections;
  ConnectData : TConnectData;
  Fetched :     Longint;
  Obj:          IfrxComponent;
begin
  if FEvent <> nil then
  begin
    if FUseDispatchableEvents = True then
    begin
      Obj := DispatchableComponentFactory.CreateComObject(Sender) as IfrxComponent;
      FEvent.OnBeforePrint(Obj);
      Obj._Release;
    end
    else
      FEvent.OnBeforePrint(Sender);
  end
  else
  begin
    OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
    while Enum.Next (1, ConnectData, @Fetched) = S_OK do
    begin
      (ConnectData.pUnk as IfrxReportEventDispatcher).OnBeforePrint(Sender);
      ConnectData.pUnk := nil;
    end;
    Enum := nil;
  end;
end;

procedure TfrxReport.OnClickObjectHandler(Sender: TfrxView; Button: TMouseButton; Shift: TShiftState; var Modified: Boolean);
var
  Enum :        IEnumConnections;
  ConnectData : TConnectData;
  Fetched :     Longint;
  Obj:          IfrxView;
begin
  try
    if FEvent <> nil then
    begin
      if FUseDispatchableEvents = True then
      begin
        Obj := DispatchableComponentFactory.CreateComObject(Sender) as IfrxView;
        FEvent.OnClickObject( Obj, Integer(Button));
        Obj._Release;
      end
      else
        FEvent.OnClickObject(Sender as IfrxView, Integer(Button))
    end
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnClickObject(Sender as IfrxView, Integer(Button));
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally
  end;
end;

function TfrxReport.OnUserFunctionHandler(const MethodName: String; var Params: Variant): Variant;
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
  ResultValue : OleVariant;
begin
  try
    if FEvent <> nil then
    begin
      FEvent.OnUserFunction(MethodName, Params, ResultValue);
    end
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnUserFunction(MethodName, Params, ResultValue);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally 
    Result := ResultValue;
  end;
end;

procedure TfrxReport.OnBeginDocHandler(Sender: TObject);
var
  Component:    IfrxComponent;
  Enum :        IEnumConnections;
  ConnectData : TConnectData;
  Fetched :     Longint;
//  Obj:          IfrxComponent;
begin
  try
    Sender.GetInterface(IfrxComponent, Component);
    if FEvent <> nil then
    begin
{
      if FUseDispatchableEvents = True then
      begin
        Obj := DispatchableComponentFactory.CreateComObject(Component) as IfrxComponent;
        FEvent.OnBeginDoc(Obj);
        Obj._Release;
      end
      else
}
        FEvent.OnBeginDoc( Component )
    end
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnBeginDoc(Component);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally
    Component := nil;
  end;
end;

procedure TfrxReport.OnBeforeConnectHandler(Sender: TfrxCustomDatabase; var Connected: Boolean);
var
  Database: IfrxADODatabase;
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    Sender.GetInterface( IfrxADODatabase, Database );
    if FEvent <> nil then
      FEvent.OnBeforeConnect( Database, Connected )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnBeforeConnect( Database, Connected );
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally
    Database := nil;
  end;
end;

procedure TfrxReport.OnEndDocHandler(Sender: TObject);
var
  Component: IfrxComponent;
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    Sender.GetInterface(IfrxComponent, Component);
    if FEvent <> nil then
      FEvent.OnEndDoc( Component )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnEndDoc(Component);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally
    Component := nil;
  end;
end;

procedure TfrxReport.OnPrintReportHandler(Sender: TObject);
var
  Component: IfrxComponent;
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    Sender.GetInterface(IfrxComponent, Component);
    if FEvent <> nil then
      FEvent.OnEndDoc( Component )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnPrintReport(Component);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally
    Component := nil;
  end;
end;

procedure TfrxReport.OnAfterPrintReportHandler(Sender: TObject);
var
  Component: IfrxComponent;
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    Sender.GetInterface(IfrxComponent, Component);
    if FEvent <> nil then
      FEvent.OnAfterPrintReport( Component )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnAfterPrintReport(Component);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  finally
    Component := nil;
  end;
end;

procedure TfrxReport.OnProgressHandler(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    if FEvent <> nil then
      FEvent.OnProgress( Sender, Integer(ProgressType), Progress )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnProgress(Sender, Integer(ProgressType), Progress);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end
  except
  end;
end;

procedure TfrxReport.OnProgressStartHandler(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    if FEvent <> nil then
      FEvent.OnProgressStart( )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnProgressStart();
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end
  except
  end;
end;

procedure TfrxReport.OnProgressStopHandler(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    if FEvent <> nil then
      FEvent.OnProgressStop( )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnProgressStop();
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  except end;
end;

procedure TfrxReport.OnRunDialogsEvent(Page: TfrxDialogPage);
var
  Enum : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Longint;
begin
  try
    if FEvent <> nil then
      FEvent.OnRunDialogs( Page )
    else
    begin
      OleCheck((FConnectionPoint as IConnectionPoint).EnumConnections(Enum));
      while Enum.Next (1, ConnectData, @Fetched) = S_OK do
      begin
        (ConnectData.pUnk as IfrxReportEventDispatcher).OnRunDialogs(Page);
        ConnectData.pUnk := nil;
      end;
      Enum := nil;
    end;
  except
  end;
end;

function TfrxReport.LoadReportFromFile(const szFileName: WideString): HResult;
begin
  Result := S_OK;
  try
    if LoadFromFile(szFileName, False) <> True then
      Result := E_INVALIDARG;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.SaveReportToFile(const FileName: WideString): HResult;
begin
  try
    SaveToFile(FileName);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.LoadReportFromStream(const Stream: IUnknown): HResult;
var
  ComStream: IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  try
    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      LoadFromStream(OleStream);
      OleStream.Free;
      ComStream := nil;
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        LoadFromStream(ClrStream);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
  // Result value now depends on errors count
  if (FErrors.Count > 0) then Result := CONVERT10_E_OLESTREAM_FMT;

end;

function TfrxReport.SaveReportToStream(const Stream: IUnknown): HResult;
var
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  try
    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      SaveToStream(OleStream, True, False);
      OleStream.Free;
      ComStream := nil;
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        SaveToStream(ClrStream, True, False);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.LoadPreparedReportFromFile(const szFileName: WideString): HResult;
begin
  try
    Result := S_OK;
    if PreviewPages.LoadFromFile( szFileName ) <> True then Result := E_FAIL;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.SavePreparedReportToFile(const szFileName: WideString): HResult;
begin
  try
    PreviewPages.SaveToFile( szFileName );
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.SavePreparedReportToStream(const Stream: IUnknown): HResult;
var
  S:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
//  c: Integer;
begin
  try
    Result := Stream.QueryInterface(IStream, S);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(S);
      PreviewPages.SaveToStream(OleStream);
      OleStream.Free;
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        PreviewPages.SaveToStream(ClrStream);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.LoadPreparedReportFromStream(const Stream: IUnknown): HResult; stdcall;
var
  S:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
//  c: Integer;
begin
  try
    Result := Stream.QueryInterface(IStream, S);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(S);
      PreviewPages.LoadFromStream(OleStream);
      OleStream.Free;
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        PreviewPages.LoadFromStream(ClrStream);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.ClearReport: HResult;
begin
  try
    Clear;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.PrintReport: HResult;
var
  printers: TfrxPrinters;
begin
  try
    printers := frxPrinters;
    if printers.HasPhysicalPrinters then
    begin
      Print;
      Result := S_OK;
    end else begin
      Errors.Add('There is no printer on system');
      Result := E_FAIL;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.ExportReport(const Filter: IfrxCustomExportFilter): HResult;
begin
   Result := E_NOTIMPL;
end;

function TfrxReport.Get_Errors(out Value: WideString): HResult;
begin
  try
    if Errors <> nil then
      Value := Errors.GetText
    else
      Value := '';
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.Get_EngineOptions(out Value: IfrxEngineOptions): HResult;
begin
  Value := EngineOptions as IfrxEngineOptions;
  Result := S_OK;
end;

function TfrxReport.Get_Script(out Value: IfsScript): HResult; stdcall;
begin
  Value := Script as IfsScript;
  Result := S_OK;
end;

function TfrxReport.Get_Print(out Value: WordBool): HResult; stdcall;
begin
  Value := Print;
  Result := S_OK;
end;

function TfrxReport.Set_UseDispatchableEvents(Value: WordBool): HResult; stdcall;
begin
  FUseDispatchableEvents := Value;
  Result := S_OK;
end;

function TfrxReport.Get_FileName(out Value: WideString): HResult; stdcall;
begin
  Value := FileName;
  Result := S_OK;
end;

function TfrxReport.Set_FileName(const Value: WideString): HResult; stdcall;
begin
  FileName := Value;
  Result := S_OK;
end;

function TfrxReport.Get_ParentReport(out Value: WideString): HResult; stdcall;
begin
  Value := ParentReport;
  Result := S_OK;
end;

function TfrxReport.Set_ParentReport(const Value: WideString): HResult; stdcall;
begin
  ParentReport := Value;
  Result := S_OK;
end;

function TfrxReport.Set_Terminated(Value: WordBool): HResult; stdcall;
begin
  Terminated := True;
  Result := S_OK;
end;

function TfrxReport.Set_ThreadSafe(Value: WordBool): HResult;
begin
  EngineOptions.EnableThreadSafe := Value;
  Result := S_OK;
end;

function TfrxReport.SetGlobalVariable(const Index: WideString; Value: OleVariant): HResult; stdcall;
begin
  try
    frxGlobalVariables[Index] := Value;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.InheritFromReport(const TemplateName: WideString; InheritMode: frxInheritMode): HResult; stdcall;
begin
  if Self.InheritFromTemplate(TemplateName, TfrxInheriteMode(InheritMode) ) then Result := S_OK else Result := S_FALSE;
end;

function TfrxReport.Get_PreviewPages(out Value: IfrxCustomPreviewPages): HResult; stdcall;
begin
  Value := PreviewPages as IfrxCustomPreviewPages;
  Value._AddRef;
  Result := S_OK;
end;

function TfrxReport.Get_ReportOptions(out Value: IfrxReportOptions): HResult;
begin
  Value := ReportOptions as IfrxReportOptions;
  Result := S_OK;
end;

function TfrxReport.Get_PreviewOptions(out Value: IfrxPreviewOptions): HResult;
begin
  Value := PreviewOptions as IfrxPreviewOptions;
  Result := S_OK;
end;

function TfrxReport.Get_PrintOptions( out Value: IfrxPrintOptions): HResult;
begin
  Value := PrintOptions as IfrxPrintOptions;
  Result := S_OK;
end;

function TfrxReport.Get_ScriptLanguage(out Value: WideString): HResult;
begin
  try
    Value:= ScriptLanguage;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.Set_ScriptLanguage(const Value: WideString): HResult;
begin
  try
    ScriptLanguage := Value;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.Get_ScriptText(out Value: WideString): HResult;
begin
  try
    Value := ScriptText.GetText;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.Get_ThreadSafe(out Value: WordBool): HResult;
begin
  try
    Value := EngineOptions.EnableThreadSafe;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.Set_ScriptText(const Value: WideString): HResult;
begin
  try
    ScriptText.SetText(PChar(Value));
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.Get_DisableDialogs(out Value: WordBool): HResult; stdcall;
begin
  if Assigned(Engine.OnRunDialog) then Value := True else Value := False;
  Result := S_OK;
end;

function TfrxReport.Set_DisableDialogs(Value: WordBool): HResult; stdcall;
begin
  if Value = True then
    Engine.OnRunDialog := nil
  else
    Engine.OnRunDialog := OnRunDialogsEvent;
  Result := S_OK;
end;

function TfrxReport.SetVariable(const Index: WideString; Value: OleVariant): HResult; stdcall;
begin
  try
    Variables[Index] := Variant(Value);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.GetVariable(const Index: WideString; out Value: OleVariant): HResult; stdcall;
var
  TempVal: Variant;
begin
  try
{$IFDEF OLD_GETVALUE}
    DoGetValue(Index, TempVal);
{$ELSE}
  TempVal := Self.Variables[Index];
{$ENDIF}
    Value := TempVal;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.AddVariable(const Category: WideString; const Name: WideString; Value: OleVariant): HResult; stdcall;
var
  i: Integer;
  v: TfrxVariable;
begin
  try
    i := Variables.IndexOf(' ' + Category);
    if i = -1 then
    begin
      v := Variables.Add();
      v.Name := ' ' + Category;
    end;
    Variables.AddVariable(Category, Name, Value);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.DeleteCategory(const Name: WideString): HResult; stdcall;
begin
  try
    Variables.DeleteCategory(Name);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.DeleteVariable(const Name: WideString): HResult; stdcall;
begin
  try
    Variables.DeleteVariable(Name);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.SelectDataset(Selected: WordBool;
  const DataSet: IfrxDataSet): HResult;
var
  found:    Boolean;
  ds:       TfrxDataSet;
  UserName: WideString;
  i:        Integer;
  dsList:   TStringList;
begin
  try
  dsList := TStringList.Create;
  GetActiveDataSetList(dsList);

  found := False;
  
  DataSet.Get_UserName( UserName );

  for i := 0 to dsList.Count - 1 do
  begin
    ds := TfrxDataSet(dsList.Objects[i]);
    if ds.UserName = UserName then
    begin
      found := True;
      if Selected then
      begin
        DataSet._AddRef;
        Datasets.Add(ds);
      end
      else
      begin
        Datasets.Delete(UserName);
        DataSet._Release;
      end;
    end;
  end;
  
  if not found then 
  begin
    if Selected then 
    begin 
      DataSet._AddRef; 
      ds := TfrxDataSet( (DataSet as IInterfaceComponentReference).GetComponent );
      if EngineOptions.FUseGlobalDataSetList then
      begin
        DatasetList.Lock;
        DatasetList.Add( ds );
        DatasetList.Unlock;
      end
      else
      begin
        EnabledDataSets.Add(ds);
      end;
      Datasets.Add( ds ); 
    end 
    else 
    begin
      Datasets.Delete(UserName);
      DataSet._Release;
    end;
  end;
  dsList.Free;

  Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.BindObject(const Value: IfrxPlugin): HResult; stdcall;
var
  PluginType: frxPluginType;
  ds: TfrxNetDataTable;
begin
  try
    Result := Value.Get_PluginType(PluginType);
    if Result = S_OK then case PluginType of
    ptDataSet:
      begin
      ds := TfrxNetDataTable.Create( nil );
      Result := ds.SetRemoteObject( Value );
      end
    else
      // put your plugin implementation here
      Result := E_NOINTERFACE;
    end;

  except
    Result := E_NOINTERFACE;
  end;
end;

function TfrxReport.Set_ShowProgress(Value: WordBool): HResult; stdcall;
begin
  try
    ShowProgress := Value;
    Result := S_OK;
  except
    Result := E_FAIL;
  end
end;

function TfrxReport.CreateReportObject(
  const ParentObject:   IfrxComponent;
  ObjectType:           TGUID;
  const Name:           WideString;
  out GeneratedObject:  IfrxComponent): HResult; stdcall;
var
  Obj:        TfrxComponent;
  ParentObj:  TfrxComponent;
  idsp:       IInterfaceComponentReference;
  i:          Integer;
  TempStr:    WideString;
begin
  try
    obj := nil;
    Result := ParentObject.QueryInterface( IInterfaceComponentReference, idsp);
    if Result = S_OK then
    begin
      ParentObj := TfrxComponent( idsp.GetComponent );
      if IsEqualGUID(ObjectType, IfrxReportPage) then obj := TfrxReportPage.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxReportTitle) then obj := TfrxReportTitle.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxMemoView) then obj := TfrxMemoView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxReportSummary) then obj := TfrxReportSummary.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDataBand) then obj := TfrxMasterData.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxPictureView) then obj := TfrxPictureView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxShapeView) then obj := TfrxShapeView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxSubreport) then obj := TfrxSubreport.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxHeader) then obj := TfrxHeader.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxFooter) then obj := TfrxFooter.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxMasterData) then obj := TfrxMasterData.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDetailData) then obj := TfrxDetailData.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxSubdetailData) then obj := TfrxSubdetailData.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDataBand4) then obj := TfrxDataBand4.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDataBand5) then obj := TfrxDataBand5.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDataBand6) then obj := TfrxDataBand6.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxPageHeader) then obj := TfrxPageHeader.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxPageFooter) then obj := TfrxPageFooter.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxColumnHeader) then obj := TfrxColumnHeader.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxColumnFooter) then obj := TfrxColumnFooter.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxGroupHeader) then obj := TfrxGroupHeader.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxGroupFooter) then obj := TfrxGroupFooter.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxChild) then obj := TfrxChild.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxOverlay) then obj := TfrxOverlay.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxCrossView) then obj := TfrxCrossView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDBCrossView) then obj := TfrxDBCrossView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxRichView) then obj := TfrxRichView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxBarCodeView) then obj := TfrxBarCodeView.Create(ParentObj)

      else if IsEqualGUID(ObjectType, IfrxADODatabase) then obj := TfrxADODatabase.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxADOTable) then obj := TfrxADOTable.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxADOQuery) then obj := TfrxADOQuery.Create(ParentObj)

      else if IsEqualGUID(ObjectType, IfrxDMPPage) then obj := TfrxDMPPage.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDMPCommand) then obj := TfrxDMPCommand.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDMPMemoView) then obj := TfrxDMPMemoView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxDMPLineView) then obj := TfrxDMPLineView.Create(ParentObj)
      else if IsEqualGUID(ObjectType, IfrxCheckBoxView) then obj := TfrxCheckBoxView.Create(ParentObj)

      else if IsEqualGUID(ObjectType, IfrxLineView) then obj := TfrxLineView.Create(ParentObj)

{$IFNDEF FR_LITE}
      else if IsEqualGUID(ObjectType, IfrxChartView) then obj := TfrxChartView.Create(ParentObj)
{$ENDIF}
      else Result := E_INVALIDARG;
    end;

    if Result = S_OK then
    begin
      TempStr := Name;
      for i := 0 to length(Name) - 1 do
        if Name[i] = ' ' then TempStr[i] := '_';
      obj.Name := String(TempStr);
      GeneratedObject := obj as IfrxComponent;
    end;
  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.CreateReportObjectEx(
  const ParentObject: IfrxComponent;
  const ObjectType:   WideString;
  const Name:         WideString;
  out GeneratedObject: IfrxComponent): HResult; stdcall;
begin
  try
    if ObjectType = 'TfrxPage' then
      Result := CreateReportObject(ParentObject, IfrxReportPage, Name, GeneratedObject )
    else if ObjectType = 'TfrxMemoView' then
      Result := CreateReportObject(ParentObject, IfrxMemoView, Name, GeneratedObject )
    else if ObjectType = 'TfrxReportTitle' then
      Result := CreateReportObject(ParentObject, IfrxReportTitle, Name, GeneratedObject )
    else if ObjectType = 'TfrxReportSummary' then
      Result := CreateReportObject(ParentObject, IfrxReportSummary, Name, GeneratedObject )
    else if ObjectType = 'TfrxDataBand' then
      Result := CreateReportObject(ParentObject, IfrxDataBand, Name, GeneratedObject )
    else if ObjectType = 'TfrxPictureView' then
      Result := CreateReportObject(ParentObject, IfrxPictureView, Name, GeneratedObject )
    else if ObjectType = 'TfrxShapeView' then
      Result := CreateReportObject(ParentObject, IfrxShapeView, Name, GeneratedObject )
    else if ObjectType = 'TfrxChartView' then
      Result := CreateReportObject(ParentObject, IfrxChartView, Name, GeneratedObject )
    else if ObjectType = 'TfrxSubreport' then
      Result := CreateReportObject(ParentObject, IfrxSubreport, Name, GeneratedObject )
    else if ObjectType = 'TfrxHeader' then
      Result := CreateReportObject(ParentObject, IfrxHeader, Name, GeneratedObject )
    else if ObjectType = 'TfrxFooter' then
      Result := CreateReportObject(ParentObject, IfrxFooter, Name, GeneratedObject )
    else if ObjectType = 'TfrxMasterData' then
      Result := CreateReportObject(ParentObject, IfrxMasterData, Name, GeneratedObject )
    else if ObjectType = 'TfrxDetailData' then
      Result := CreateReportObject(ParentObject, IfrxDetailData, Name, GeneratedObject )
    else if ObjectType = 'TfrxSubdetailData' then
      Result := CreateReportObject(ParentObject, IfrxSubdetailData, Name, GeneratedObject )
    else if ObjectType = 'TfrxDataBand4' then
      Result := CreateReportObject(ParentObject, IfrxDataBand4, Name, GeneratedObject )
    else if ObjectType = 'TfrxDataBand5' then
      Result := CreateReportObject(ParentObject, IfrxDataBand5, Name, GeneratedObject )
    else if ObjectType = 'TfrxDataBand6' then
      Result := CreateReportObject(ParentObject, IfrxDataBand6, Name, GeneratedObject )
    else if ObjectType = 'TfrxPageHeader' then
      Result := CreateReportObject(ParentObject, IfrxPageHeader, Name, GeneratedObject )
    else if ObjectType = 'TfrxPageFooter' then
      Result := CreateReportObject(ParentObject, IfrxPageFooter, Name, GeneratedObject )
    else if ObjectType = 'TfrxColumnHeader' then
      Result := CreateReportObject(ParentObject, IfrxColumnHeader, Name, GeneratedObject )
    else if ObjectType = 'TfrxColumnFooter' then
      Result := CreateReportObject(ParentObject, IfrxColumnFooter, Name, GeneratedObject )
    else if ObjectType = 'TfrxGroupHeader' then
      Result := CreateReportObject(ParentObject, IfrxGroupHeader, Name, GeneratedObject )
    else if ObjectType = 'TfrxGroupFooter' then
      Result := CreateReportObject(ParentObject, IfrxGroupFooter, Name, GeneratedObject )
    else if ObjectType = 'TfrxChild' then
      Result := CreateReportObject(ParentObject, IfrxChild, Name, GeneratedObject )
    else if ObjectType = 'TfrxOverlay' then
      Result := CreateReportObject(ParentObject, IfrxOverlay, Name, GeneratedObject )
    else if ObjectType = 'TfrxCrossView' then
      Result := CreateReportObject(ParentObject, IfrxCrossView, Name, GeneratedObject )
    else if ObjectType = 'TfrxDBCrossView' then
      Result := CreateReportObject(ParentObject, IfrxDBCrossView, Name, GeneratedObject )
    else if ObjectType = 'TfrxRichView' then
      Result := CreateReportObject(ParentObject, IfrxRichView, Name, GeneratedObject )
    else if ObjectType = 'TfrxBarCodeView' then
      Result := CreateReportObject(ParentObject, IfrxBarCodeView, Name, GeneratedObject )
{ Modified February, 2, 2007 }
    else if ObjectType = 'TfrxADODatabase' then
      Result := CreateReportObject(ParentObject, IfrxADODatabase, Name, GeneratedObject )
    else if ObjectType = 'TfrxADOTable' then
      Result := CreateReportObject(ParentObject, IfrxADOTable, Name, GeneratedObject )
    else if ObjectType = 'TfrxADOQuery' then
      Result := CreateReportObject(ParentObject, IfrxADOQuery, Name, GeneratedObject )
{ Added October, 05, 2006 }
    else if ObjectType = 'TfrxDMPPage' then
      Result := CreateReportObject(ParentObject, IfrxDMPPage, Name, GeneratedObject )
    else if ObjectType = 'TfrxDMPCommand' then
      Result := CreateReportObject(ParentObject, IfrxDMPCommand, Name, GeneratedObject )
    else if ObjectType = 'TfrxDMPMemoView' then
      Result := CreateReportObject(ParentObject, IfrxDMPMemoView, Name, GeneratedObject )
    else if ObjectType = 'TfrxDMPLineView' then
      Result := CreateReportObject(ParentObject, IfrxDMPLineView, Name, GeneratedObject )
{ Added March, 27, 2008 }
    else if ObjectType = 'TfrxCheckBoxView' then
      Result := CreateReportObject(ParentObject, IfrxCheckBoxView, Name, GeneratedObject )
{ Added November, 21, 2008 }
    else if ObjectType = 'TfrxLineView' then
      Result := CreateReportObject(ParentObject, IfrxLineView, Name, GeneratedObject )
    else
      Result := E_INVALIDARG;

    if Result = S_OK then
    begin
      //GeneratedObject := DispatchableComponentFactory.CreateComObject(GeneratedObject) as IfrxComponent;
    end

  except
    Result := E_FAIL;
  end;
end;

function TfrxReport.FindCOMObject(const ObjectName: WideString; out Obj: IfrxComponent): HResult; stdcall;
begin
  try
    obj := (Self as IfrxComponent).FindObject(ObjectName);
//    Result := (Self as IfrxComponent).FindObject(ObjectName, obj);
    Result := S_OK;
  except
    Result := E_FAIL;
  end
end;

function TfrxReport.FindObjectEx(const ObjectName: WideString; out Obj: IfrxComponent): HResult; stdcall;
begin
{
  try
    Result := (Self as IfrxComponent).FindObject(ObjectName, obj);
    obj := DispatchableComponentFactory.CreateComObject(obj) as IfrxComponent;
  except
    Result := E_FAIL;
  end
}
  Result := FindCOMObject( ObjectName, Obj);
end;

function TfrxReport.Get_Exports_(out Value: IfrxBuiltinExports): HResult; stdcall;
begin
  try
    Value := ExportComponentFactory.CreateComObject(Self) as IfrxBuiltinExports;
    Result := S_OK;
  except
    Result := E_FAIL;
  end
end;

function TfrxReport.FindDatabase(const ObjectName: WideString; out Database: IfrxADODatabase): HResult; stdcall;
var
  obj: IfrxComponent;
begin
  try
    Result := S_OK;
    //Result := Self.IfrxComponent_FindObject( ObjectName, obj );
    obj := Self.IfrxComponent_FindObject( ObjectName );
    Database := DatabaseComponentFactory.CreateComObject(obj) as IfrxADODatabase;
  except
    Result := E_FAIL;
  end
end;

function TfrxReport.FindQuery(const ObjectName: WideString; out Query: IfrxADOQuery): HResult; stdcall;
var
  obj: IfrxComponent;
begin
  try
    Result := S_OK;
//    Result := Self.IfrxComponent_FindObject( ObjectName, obj );
    obj := Self.IfrxComponent_FindObject( ObjectName );
    Query := QueryComponentFactory.CreateComObject(obj) as IfrxADOQuery;
  except
    Result := E_FAIL;
  end
end;

function TfrxReport.FindTable(const ObjectName: WideString; out Table: IfrxADOTable): HResult; stdcall;
var
  obj: IfrxComponent;
begin
  try
    Result := S_OK;
    //Result := Self.IfrxComponent_FindObject( ObjectName, obj );
    obj := Self.IfrxComponent_FindObject( ObjectName );
    Table := TableComponentFactory.CreateComObject(obj) as IfrxADOTable;
  except
    Result := E_FAIL;
  end
end;

function TfrxReport.Get_DotMatrixInitString(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(Export2DMP.InitString);
  Result := S_OK;
end;

function TfrxReport.Set_DotMatrixInitString(const Value: WideString): HResult; stdcall;
begin
  Export2DMP.InitString := AnsiString(Value);
  Result := S_OK;
end;

function TfrxReport.Set_DotMatrixEscModel(Value: Integer): HResult; stdcall;
begin
  Export2DMP.EscModel := Value;
  Result := S_OK;
end;

function TfrxReport.Get_DotMatrixEscModel(out Value: Integer): HResult; stdcall;
begin
  Value := Export2DMP.EscModel;
  Result := S_OK;
end;


function TfrxReport.ClearDatasets: HResult; stdcall;
begin
  Datasets.Clear;
  DatasetList.Destroy;
  DatasetList := TfrxGlobalDataSetList.Create;
  Result := S_OK;
end;

function TfrxReport.Get_ExpandDrilldown(out Value:WordBool): HRESULT; stdcall;
begin
  Value := TRUE;
  Result := S_OK;
end;

function TfrxReport.Set_ExpandDrilldown(Value:WordBool): HRESULT stdcall;
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
begin
  if (Preview = nil) or (Engine.Running) then
  begin
    Result := 7;
    Exit;
  end;

  Preview.Lock;
  l := AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if (c is TfrxGroupHeader) and TfrxGroupHeader(c).DrillDown then
      TfrxGroupHeader(c).ExpandDrillDown := Boolean(Value);
  end;

  DrillState.Clear;
  Preview.RefreshReport;
  if Boolean(Value) = FALSE then TfrxPreview(Preview).SetPosition(0,0);
  Result := S_OK;
end;

function TfrxReport.LoadLanguageResourcesFromFile(const FileName: WideString): HResult; stdcall;
begin
  Application.MessageBox(
    PChar('Deprecated Method. Use LoadLanguageResourcesFromFile method of IfrxResources interface.'),
    'Beta version message');
    Result := E_NOTIMPL;
end;

function TfrxReport.GetResourceString(const ID: WideString; out ResourceString_: WideString): HResult; stdcall;
begin
  Application.MessageBox(
    PChar('Deprecated Method. Use LoadLanguageResourcesFromFile method of IfrxResources interface.'),
    'Beta version message');
    Result := E_NOTIMPL;
end;

function TfrxReport.Set_MainWindowHandle(Value: Integer): HResult; stdcall;
begin
  Application.Handle := HWND(Value);
//  Application.CreateHandle
  Result := S_OK;
end;

function TfrxReport.Get_Resources(out Value: IfrxResources): HResult; stdcall;
begin
  Value := frxResources;
  Result := S_OK;
end;

function TfrxReport.Get_Version(out Value: WideString): HResult; stdcall;
begin
  Value := Version;
  Result := S_OK;
end;

function TfrxReport.Get_Page(Index: Integer; out Value: IfrxPage): HResult; stdcall;
begin
  Value := Pages[Index];
  Result := S_OK;
end;

function TfrxReport.Get_PagesCount(out Value: Integer): HResult; stdcall;
begin
  Value := PagesCount;
  Result := S_OK;
end;

function TfrxReport.ExportToOdf(const FileName: WideString; Emf: WordBool; Styles: WordBool;
      PageBreaks: WordBool; Wysiwyg: WordBool; Background: WordBool;
      EmptyLines: WordBool; const Language: WideString): HResult; stdcall;
var
  Export2ODF:         TfrxODFExport;
  rp:                 TfrxReport;
  idsp:               IInterfaceComponentReference;
begin
  Export2ODF := TfrxODFExport.Create(nil);
  try
    Export2ODF.FileName := String(FileName);
    Export2ODF.ShowDialog := false;
//    Export2ODF.ExportEMF := EMF;
    Export2ODF.ExportStyles := Styles;
    Export2ODF.ExportPageBreaks := PageBreaks;
    Export2ODF.Wysiwyg := Wysiwyg;
    Export2ODF.Background := Background;
    Export2ODF.EmptyLines := EmptyLines;
    Export2ODF.Language := String(Language); {default 'en'}
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2ODF)
    end
    else Export(Export2ODF);
    Result := S_OK;
  finally
    Export2ODF.Free;
  end;
end;

function TfrxReport.ExportToODF(const Stream: IUnknown; Emf: WordBool; Styles: WordBool;
      PageBreaks: WordBool; Wysiwyg: WordBool; Background: WordBool;
      EmptyLines: WordBool; const Language: WideString): HResult; stdcall;
var
  Export2ODF:         TfrxODFExport;
  ComStream:          IStream;
  OleStream:          TOleStream;

  NetStream:          _Stream;
  ClrStream:          TClrStream;
begin
  Export2ODF := TfrxODFExport.Create(nil);
  try
    Export2ODF.FileName := '';
    Export2ODF.ShowDialog := false;
//    Export2ODF.ExportEMF := EMF;
    Export2ODF.ExportStyles := Styles;
    Export2ODF.ExportPageBreaks := PageBreaks;
    Export2ODF.Wysiwyg := Wysiwyg;
    Export2ODF.Background := Background;
    Export2ODF.EmptyLines := EmptyLines;
    Export2ODF.Language := String(Language); {default 'en'}


    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2PDF.Stream := OleStream;
      Export( Export2ODF );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2PDF.Stream := ClrStream;
        Export( Export2ODF );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;

    Result := S_OK;
  finally
    Export2ODF.Free;
  end;
end;

function TfrxReport.ExportToPDF(
      const FileName: WideString; Compressed: WordBool; EmbeddedFonts: WordBool;
      PrintOptimized: WordBool; Background: WordBool;
      const UserPassword: WideString; const OwnerPassword: WideString): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2PDF:         TfrxPDFExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2PDF := TfrxPDFExport.Create(nil);
  try
    Export2PDF.FileName := String(FileName);
    Export2PDF.ShowDialog := False;
    Export2PDF.Compressed := Compressed;
    Export2PDF.EmbeddedFonts := EmbeddedFonts;
    Export2PDF.PrintOptimized := PrintOptimized;
    Export2PDF.ShowProgress := ShowProgress;
    Export2PDF.Background := Background;
    Export2PDF.FPageNumbers := Self.PrintOptions.FPageNumbers;
    Export2PDF.OwnerPassword := AnsiString(OwnerPassword);
    Export2PDF.UserPassword := AnsiString(UserPassword);
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2PDF)
    end
    else Export(Export2PDF);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2PDF.Free;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToPDF(const Stream: IUnknown; Compressed,  EmbeddedFonts, PrintOptimized: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2PDF:         TfrxPDFExport;

  ComStream:          IStream;
  OleStream:          TOleStream;

  NetStream:          _Stream;
  ClrStream:          TClrStream;
begin
  Export2PDF := TfrxPDFExport.Create(nil);
  try
    Export2PDF.FileName := '';
    Export2PDF.ShowDialog := False;
    Export2PDF.Compressed := Compressed;
    Export2PDF.EmbeddedFonts := EmbeddedFonts;
    Export2PDF.PrintOptimized := PrintOptimized;
    Export2PDF.ShowProgress := ShowProgress;
    Export2PDF.FPageNumbers := Self.PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2PDF.Stream := OleStream;
      Export( Export2PDF );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2PDF.Stream := ClrStream;
        Export( Export2PDF );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;

    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2PDF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToBMP( const FileName: WideString;
  Resolution: SYSINT; Monochrome, CropPages, SeparatePages: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2BMP:         TfrxBMPExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2BMP := TfrxBMPExport.Create(nil);
  try
    Export2BMP.FileName := FileName;
    Export2BMP.ShowDialog := False;
    Export2BMP.Resolution := Resolution;
    Export2BMP.Monochrome := Monochrome;
    Export2BMP.CropImages := CropPages;
    Export2BMP.SeparateFiles := SeparatePages;
    Export2BMP.ShowProgress := ShowProgress;
    Export2BMP.FPageNumbers := Self.PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2BMP)
    end
    else Export(Export2BMP);
    Result := S_OK;

  except
    Result := E_FAIL;
  end;
  Export2BMP.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToBMP( const Stream: IUnknown;
  Resolution: SYSINT; Monochrome, CropPages, SeparatePages: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2BMP:         TfrxBMPExport;

  ComStream:          IStream;
  OleStream:          TOleStream;

  NetStream:          _Stream;
  ClrStream:          TClrStream;
begin
  Export2BMP := TfrxBMPExport.Create(nil);
  try
    Export2BMP.FileName := '';
    Export2BMP.ShowDialog := False;
    Export2BMP.Resolution := Resolution;
    Export2BMP.Monochrome := Monochrome;
    Export2BMP.CropImages := CropPages;
    Export2BMP.SeparateFiles := SeparatePages;
    Export2BMP.ShowProgress := ShowProgress;
    Export2BMP.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2BMP.Stream := OleStream;
      Export( Export2BMP );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2BMP.Stream := ClrStream;
        Export( Export2BMP );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;

    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2BMP.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToHTML(const FileName: WideString; Pictures,
  FixedWidth, Multipage, Navigator, PicsInSameFolder,
  Background: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2HTML:        TfrxHTMLExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2HTML := TfrxHTMLExport.Create(nil);
  try
    Export2HTML.FileName := String(FileName);
    Export2HTML.ShowDialog := False;
    Export2HTML.ExportPictures := Pictures;
    Export2HTML.FixedWidth := FixedWidth;
    Export2HTML.Multipage := Multipage;
    Export2HTML.Navigator := Navigator;
    Export2HTML.PicsInSameFolder := PicsInSameFolder;
    Export2HTML.Background := Background;
    Export2HTML.ShowProgress := ShowProgress;
    Export2HTML.FPageNumbers := Self.PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2HTML)
    end
    else Export(Export2HTML);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2HTML.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToHTML(const Stream: IUnknown; Pictures,
  FixedWidth, Multipage, Navigator, PicsInSameFolder,
  Background: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2HTML:        TfrxHTMLExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2HTML := TfrxHTMLExport.Create(nil);
  try
    Export2HTML.FileName := '';
    Export2HTML.ShowDialog := False;
    Export2HTML.ExportPictures := Pictures;
    Export2HTML.FixedWidth := FixedWidth;
    Export2HTML.Multipage := Multipage;
    Export2HTML.Navigator := Navigator;
    Export2HTML.PicsInSameFolder := PicsInSameFolder;
    Export2HTML.Background := Background;
    Export2HTML.ShowProgress := ShowProgress;
    Export2HTML.FPageNumbers := Self.PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2HTML.Stream := OleStream;
      Export( Export2HTML );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2HTML.Stream := ClrStream;
        Export( Export2HTML );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2HTML.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToRTF(const Stream: IUnknown; Pictures: WordBool; PageBreaks: WordBool; WYSIWYG: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2RTF:         TfrxRTFExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2RTF := TfrxRTFExport.Create(nil);
  try
    Export2RTF.FileName := '';
    Export2RTF.ShowDialog := False;
    Export2RTF.ExportPictures := Pictures;
    Export2RTF.ExportPageBreaks := PageBreaks;
    Export2RTF.Wysiwyg := WYSIWYG;
    Export2RTF.ShowProgress := ShowProgress;
    Export2RTF.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2RTF.Stream := OleStream;
      Export( Export2RTF );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2RTF.Stream := ClrStream;
        Export( Export2RTF );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2RTF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToRTF(const FileName: WideString; Pictures, PageBreaks, WYSIWYG: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2RTF:         TfrxRTFExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2RTF := TfrxRTFExport.Create(nil);
  try
    Export2RTF.FileName := String(FileName);
    Export2RTF.ShowDialog := False;
    Export2RTF.ExportPictures := Pictures;
    Export2RTF.ExportPageBreaks := PageBreaks;
    Export2RTF.Wysiwyg := WYSIWYG;
    Export2RTF.ShowProgress := ShowProgress;
    Export2RTF.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2RTF)
    end
    else Export(Export2RTF);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2RTF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToTXT(const Stream: IUnknown; PageBreaks: WordBool; Frames: WordBool; OEMCodepage: WordBool; EmptyLines: WordBool): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TfrxReport.ExportToTXT(
  const FileName: WideString;
  PageBreaks: WordBool;
  Frames: WordBool;
  OEMCodepage: WordBool;
  EmptyLines: WordBool): HResult; stdcall;
var
  Export2TXT:         TfrxSimpleTextExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2TXT := TfrxSimpleTextExport.Create(nil);
  try
    Export2TXT.FileName := String(FileName);
    Export2TXT.ShowDialog := False;
    Export2TXT.ShowProgress := ShowProgress;
    Export2TXT.PageBreaks := PageBreaks;
    Export2TXT.Frames := Frames;
    Export2TXT.OEMCodepage := OEMCodepage;
    Export2TXT.EmptyLines := EmptyLines;
    Export2TXT.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2TXT)
    end
    else Export(Export2TXT);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2TXT.Destroy;
end;

function TfrxReport.ExportToXLS(const Stream: IUnknown; Pictures: WordBool; PageBreaks: WordBool; WYSIWYG: WordBool; AsText: WordBool; Background: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2XLS:         TfrxXLSExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  try
    Export2XLS := TfrxXLSExport.Create(nil);
    Export2XLS.FileName := '';
    Export2XLS.ShowDialog := False;
    Export2XLS.ExportPictures := Pictures;
    Export2XLS.PageBreaks := PageBreaks;
    Export2XLS.Wysiwyg := WYSIWYG;
    Export2XLS.AsText := AsText;
    Export2XLS.Background := Background;
    Export2XLS.ShowProgress := ShowProgress;
    Export2XLS.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2XLS.Stream := OleStream;
      Export( Export2XLS );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2XLS.Stream := ClrStream;
        Export( Export2XLS );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2RTF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToXLS(const szFileName: WideString; Pictures,
  PageBreaks, WYSIWYG, AsText, Background, EmptyLines: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2XLS:         TfrxXLSExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2XLS := TfrxXLSExport.Create(nil);
  try
    Export2XLS.FileName := String(szFileName);
    Export2XLS.ShowDialog := False;
    Export2XLS.ExportPictures := Pictures;
    Export2XLS.PageBreaks := PageBreaks;
    Export2XLS.Wysiwyg := WYSIWYG;
    Export2XLS.AsText := AsText;
    Export2XLS.Background := Background;
    Export2XLS.ShowProgress := ShowProgress;
    Export2XLS.PageNumbers := PrintOptions.FPageNumbers;
    Export2XLS.EmptyLines := EmptyLines;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2XLS)
    end
    else Export(Export2XLS);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2XLS.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToXML(const Stream: IUnknown; Styles: WordBool; PageBreaks: WordBool; WYSIWYG: WordBool; Background: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2XML:         TfrxXMLExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2XML := TfrxXMLExport.Create(nil);
  try
    Export2XML.FileName := '';
    Export2XML.ShowDialog := False;
    Export2XML.ExportStyles := Styles;
    Export2XML.ExportPageBreaks := PageBreaks;
    Export2XML.Wysiwyg := WYSIWYG;
    Export2XML.Background := Background;
    Export2XML.ShowProgress := ShowProgress;
    Export2XML.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2XML.Stream := OleStream;
      Export( Export2XML );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2XML.Stream := ClrStream;
        Export( Export2XML );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2XML.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToXML(const FileName: WideString; Styles, PageBreaks, WYSIWYG, Background, EmptyLines: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2XML:         TfrxXMLExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2XML := TfrxXMLExport.Create(nil);
  try
    Export2XML.FileName := String(FileName);
    Export2XML.ShowDialog := False;
    Export2XML.ExportStyles := Styles;
    Export2XML.ExportPageBreaks := PageBreaks;
    Export2XML.Wysiwyg := WYSIWYG;
    Export2XML.Background := Background;
    Export2XML.ShowProgress := ShowProgress;
    Export2XML.PageNumbers := PrintOptions.FPageNumbers;
    Export2XML.EmptyLines := EmptyLines;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2XML)
    end
    else Export(Export2XML);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2XML.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToJPEG(const Stream: IUnknown; Resolution: SYSINT; JpegQuality: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2JPEG:        TfrxJPEGExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2JPEG := TfrxJPEGExport.Create(nil);
  try
    Export2JPEG.FileName := String(FileName);
    Export2JPEG.ShowDialog := False;
    Export2JPEG.Resolution := Resolution;
    Export2JPEG.JPEGQuality := JpegQuality;
    Export2JPEG.Monochrome := Monochrome;
    Export2JPEG.CropImages := CropPages;
    Export2JPEG.SeparateFiles := SeparatePages;
    Export2JPEG.ShowProgress := ShowProgress;
    Export2JPEG.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2JPEG.Stream := OleStream;
      Export( Export2JPEG );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2JPEG.Stream := ClrStream;
        Export( Export2JPEG );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2JPEG.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToJPEG(const FileName: WideString; Resolution, JpegQuality: SYSINT; Monochrome, CropPages,
  SeparatePages: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2JPEG:        TfrxJPEGExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2JPEG := TfrxJPEGExport.Create(nil);
  try
    Export2JPEG.FileName := String(FileName);
    Export2JPEG.ShowDialog := False;
    Export2JPEG.Resolution := Resolution;
    Export2JPEG.JPEGQuality := JpegQuality;
    Export2JPEG.Monochrome := Monochrome;
    Export2JPEG.CropImages := CropPages;
    Export2JPEG.SeparateFiles := SeparatePages;
    Export2JPEG.ShowProgress := ShowProgress;
    Export2JPEG.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2JPEG)
    end
    else Export(Export2JPEG);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2JPEG.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToTIFF(const Stream: IUnknown; Resolution: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2TIFF:        TfrxTIFFExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2TIFF := TfrxTIFFExport.Create(nil);
  try
    Export2TIFF.FileName := FileName;
    Export2TIFF.ShowDialog := False;
    Export2TIFF.Resolution := Resolution;
    Export2TIFF.Monochrome := Monochrome;
    Export2TIFF.CropImages := CropPages;
    Export2TIFF.SeparateFiles := SeparatePages;
    Export2TIFF.ShowProgress := ShowProgress;
    Export2TIFF.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2TIFF.Stream := OleStream;
      Export( Export2TIFF );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2TIFF.Stream := ClrStream;
        Export( Export2TIFF );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2TIFF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToTIFF(const FileName: WideString;
  Resolution: SYSINT; Monochrome, CropPages,
  SeparatePages: WordBool): HResult;
{$IFNDEF FR_LITE}
var
  Export2TIFF:        TfrxTIFFExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2TIFF := TfrxTIFFExport.Create(nil);
  try
    Export2TIFF.FileName := FileName;
    Export2TIFF.ShowDialog := False;
    Export2TIFF.Resolution := Resolution;
    Export2TIFF.Monochrome := Monochrome;
    Export2TIFF.CropImages := CropPages;
    Export2TIFF.SeparateFiles := SeparatePages;
    Export2TIFF.ShowProgress := ShowProgress;
    Export2TIFF.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2TIFF)
    end
    else Export(Export2TIFF);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2TIFF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToGIF(const Stream: IUnknown; Resolution: SYSINT; Monochrome: WordBool; CropPages: WordBool; SeparatePages: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2GIF:       TfrxGIFExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2GIF := TfrxGIFExport.Create(nil);
  try
    Export2GIF.FileName := FileName;
    Export2GIF.ShowDialog := False;
    Export2GIF.Resolution := Resolution;
    Export2GIF.Monochrome := Monochrome;
    Export2GIF.CropImages := CropPages;
    Export2GIF.SeparateFiles := SeparatePages;
    Export2GIF.ShowProgress := ShowProgress;
    Export2GIF.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2GIF.Stream := OleStream;
      Export( Export2GIF );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2GIF.Stream := ClrStream;
        Export( Export2GIF );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2GIF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToGIF(const FileName: WideString; Resolution: SYSINT;
  Monochrome, CropPages, SeparatePages: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2GIF:       TfrxGIFExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2GIF := TfrxGIFExport.Create(nil);
  try
    Export2GIF.FileName := FileName;
    Export2GIF.ShowDialog := False;
    Export2GIF.Resolution := Resolution;
    Export2GIF.Monochrome := Monochrome;
    Export2GIF.CropImages := CropPages;
    Export2GIF.SeparateFiles := SeparatePages;
    Export2GIF.ShowProgress := ShowProgress;
    Export2GIF.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2GIF)
    end
    else Export(Export2GIF);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2GIF.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToCSV(const Stream: IUnknown; const Separator: WideString; OEMCodepage: WordBool): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  Export2CSV:       TfrxCSVExport;
  ComStream:  IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  Export2CSV := TfrxCSVExport.Create(nil);
  try
    Export2CSV.FileName := FileName;
    Export2GIF.ShowDialog := False;
    Export2CSV.Separator := Separator;
    Export2CSV.OEMCodepage := OEMCodepage;
    Export2CSV.ShowProgress := ShowProgress;
    Export2CSV.PageNumbers := PrintOptions.FPageNumbers;

    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Export2CSV.Stream := OleStream;
      Export( Export2CSV );
      OleStream.Free;
      ComStream._Release();
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Export2CSV.Stream := ClrStream;
        Export( Export2CSV );
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2CSV.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToCSV(const FileName: WideString;
  const Separator: WideString; OEMCodepage: WordBool): HResult; stdcall;
var
  Export2CSV:       TfrxCSVExport;
  rp:                 TfrxReport;
  idsp :              IInterfaceComponentReference;
begin
  Export2CSV := TfrxCSVExport.Create(nil);
  try
    Export2CSV.FileName := FileName;
    Export2CSV.ShowDialog := False;
    Export2CSV.Separator := Separator;
    Export2CSV.OEMCodepage := OEMCodepage;
    Export2CSV.ShowProgress := ShowProgress;
    Export2CSV.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(Export2CSV)
    end
    else Export(Export2CSV);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  Export2CSV.Destroy;
end;

function TfrxReport.SendMail(const Server: WideString; Port: SYSINT; const User: WideString;
                      const Password: WideString; const From: WideString; const To_: WideString;
                      const Subject: WideString; const Text: WideString;
                      const FileName: WideString; const AttachName: WideString): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  List: TStringList;
  Error: String;
begin
  Result := E_FAIL;
  Export2Mail.ShowProgress := ShowProgress;
  List := TStringList.Create;
  try
    List.Add(String(FileName) + '=' + String(AttachName));
    Error := Export2Mail.Mail(Server, Port, User, Password, From, To_, Subject, '', Text, List);
    if Error = '' then Result := S_OK else Self.Errors.Add(Error);    
  finally
    List.Free
  end;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToDMP(const Stream: IUnknown): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TfrxReport.ExportToDMP(const FileName: WideString): HResult; stdcall;
{$IFNDEF FR_LITE}
var
  ExportDMP:        TfrxDotMatrixExport;
  rp:               TfrxReport;
  idsp :            IInterfaceComponentReference;
begin
  ExportDMP := TfrxDotMatrixExport.Create(nil);
  try
    ExportDMP.FileName := FileName;
    ExportDMP.ShowDialog := False;
    ExportDMP.SaveToFile := True;
    ExportDMP.InitString := Export2DMP.InitString;
    ExportDMP.EscModel := Export2DMP.EscModel;
    ExportDMP.PageNumbers := PrintOptions.FPageNumbers;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(ExportDMP)
    end
    else Export(ExportDMP);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  ExportDMP.Destroy;
end;
{$ELSE}
begin
  Result := E_NOTIMPL;
end;
{$ENDIF}

function TfrxReport.ExportToDbf(const FileName: WideString; OEMCodepage: WordBool): HResult; stdcall;
var
  ExportDBF:        TfrxDBFExport;
  rp:               TfrxReport;
  idsp :            IInterfaceComponentReference;
begin
  ExportDBF := TfrxDBFExport.Create(nil);
  try
    ExportDBF.FileName := FileName;
    ExportDBF.OEMCodepage := OEMCodepage;
    if Assigned( VCLComObject ) then
    begin
      idsp := IVCLComObject(VCLComObject) as IInterfaceComponentReference;
      rp := TfrxReport( idsp.GetComponent );
      rp.Export(ExportDBF)
    end
    else Export(ExportDBF);
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
  ExportDBF.Free;
end;

function TfrxReport.Get_OldStyleProgress(out Value: WordBool): HResult; stdcall;
begin
  Value := OldStyleProgress;
  Result := S_OK;
end;

function TfrxReport.Set_OldStyleProgress(Value: WordBool): HResult; stdcall;
begin
  OldStyleProgress := Value;
  Result := S_OK;
end;

function TfrxReport.Get_Engine(out Value: IfrxCustomEngine): HResult; stdcall;
begin
  Value := Engine;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxCustomDesigner }

constructor TfrxCustomDesigner.CreateDesigner(AOwner: TComponent;
  AReport: TfrxReport; APreviewDesigner: Boolean);
begin
  inherited Create(AOwner);
{$IFDEF FR_COM}
  FIsExpired := False;
{$ENDIF}
  FReport := AReport;
  FIsPreviewDesigner := APreviewDesigner;
  FObjects := TList.Create;
  FSelectedObjects := TList.Create;
end;

destructor TfrxCustomDesigner.Destroy;
begin
  FObjects.Free;
  FSelectedObjects.Free;
  inherited;
end;

procedure TfrxCustomDesigner.SetModified(const Value: Boolean);
begin
  FModified := Value;
  if Value then
    FReport.Modified := True;
end;

procedure TfrxCustomDesigner.SetPage(const Value: TfrxPage);
begin
  FPage := Value;
end;


{ TfrxCustomEngine }

procedure TfrxCustomEngine.BreakAllKeep;
begin
// do nothing
end;

constructor TfrxCustomEngine.Create(AReport: TfrxReport);
begin
  FReport := AReport;
  FNotifyList := TList.Create;
{$IFDEF FR_COM}
  inherited Create(IfrxCustomEngine);
{$ENDIF}
end;

destructor TfrxCustomEngine.Destroy;
begin
  FNotifyList.Free;
  inherited;
end;

function TfrxCustomEngine.GetDoublePass: Boolean;
begin
  Result := FReport.EngineOptions.DoublePass;
end;

procedure TfrxCustomEngine.ShowBandByName(const BandName: String);
begin
  ShowBand(TfrxBand(Report.FindObject(BandName)));
end;

procedure TfrxCustomEngine.StopReport;
begin
  Report.Terminated := True;
end;

function TfrxCustomEngine.GetPageHeight: Extended;
begin
  Result := FPageHeight;
end;

{$IFDEF FR_COM}
function TfrxCustomEngine.Get_CurColumn(out Value: Integer): HResult; stdcall;
begin
  Value := CurColumn;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_CurColumn(Value: Integer): HResult; stdcall;
begin
  CurColumn := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_CurVColumn(out Value: Integer): HResult; stdcall;
begin
  Value := CurVColumn;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_CurVColumn(Value: Integer): HResult; stdcall;
begin
  CurVColumn := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_CurX(out Value: Double): HResult; stdcall;
begin
  Value := CurX;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_CurX(Value: Double): HResult; stdcall;
begin
  CurX := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_CurY(out Value: Double): HResult; stdcall;
begin
  Value := CurY;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_CurY(Value: Double): HResult; stdcall;
begin
  CurY := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_DoublePass(out Value: WordBool): HResult; stdcall;
begin
  Value := DoublePass;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_FinalPass(out Value: WordBool): HResult; stdcall;
begin
  Value := FinalPass;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_FinalPass(Value: WordBool): HResult; stdcall;
begin
  FinalPass := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_PageHeight(out Value: Double): HResult; stdcall;
begin
  Value := PageHeight;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_PageHeight(Value: Double): HResult; stdcall;
begin
  PageHeight := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_PageWidth(out Value: Double): HResult; stdcall;
begin
  Value := PageWidth;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_PageWidth(Value: Double): HResult; stdcall;
begin
  PageWIdth := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_StartDate(out Value: TDateTime): HResult; stdcall;
begin
  Value := StartDate;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_StartDate(Value: TDateTime): HResult; stdcall;
begin
  StartDate := Value;
  Result := S_OK;
end;

function TfrxCustomEngine.Get_TotalPages(out Value: Integer): HResult; stdcall;
begin
  Value := TotalPages;
  Result := S_OK;
end;

function TfrxCustomEngine.Set_TotalPages(Value: Integer): HResult; stdcall;
begin
  TotalPages := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxCustomOutline }

constructor TfrxCustomOutline.Create(APreviewPages: TfrxCustomPreviewPages);
begin
  FPreviewPages := APreviewPages;
end;

function TfrxCustomOutline.Engine: TfrxCustomEngine;
begin
  Result := FPreviewPages.Engine;
end;

{ TfrxCustomPreviewPages }

constructor TfrxCustomPreviewPages.Create(AReport: TfrxReport);
begin
  FReport := AReport;
  FOutline := TfrxOutline.Create(Self);
end;

destructor TfrxCustomPreviewPages.Destroy;
begin
  FOutline.Free;
  inherited;
end;

{$IFDEF FR_COM}
function TfrxCustomPreviewPages.IfrxCustomPreviewPages_AddObject(const Value: IfrxComponent): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  try
    Result := Value.QueryInterface( {IfrxComponentSelf} IInterfaceComponentReference, idsp);
    if Result = S_OK then AddObject( TfrxComponent(idsp.GetComponent) {Get_Object} );
  except
    Result := E_FAIL;
  end;
end;

function TfrxCustomPreviewPages.IfrxCustomPreviewPages_AddPage(const Value: IfrxReportPage): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  try
    Result := Value.QueryInterface( {IfrxComponentSelf} IInterfaceComponentReference, idsp);
    if Result = S_OK then AddPage( TfrxReportPage(idsp.GetComponent {Get_Object}) );
  except
    Result := E_FAIL;
  end;
end;

function TfrxCustomPreviewPages.IfrxCustomPreviewPages_AddEmptyPage(Index: Integer): HResult; stdcall;
begin
  AddEmptyPage(Index);
  Result := S_OK;
end;

function TfrxCustomPreviewPages.IfrxCustomPreviewPages_DeletePage(Index: Integer): HResult; stdcall;
begin
  DeletePage(Index);
  Result := S_OK;
end;

function TfrxCustomPreviewPages.Get_Count(out Value: Integer): HResult; stdcall;
begin
  Value := Count;
  Result := S_OK;
end;

function TfrxCustomPreviewPages.Get_CurrentPage(out Value: Integer): HResult; stdcall;
begin
  Value := CurPage;
  Result := S_OK;
end;

function TfrxCustomPreviewPages.Set_CurrentPage(Value: Integer): HResult; stdcall;
begin
  CurPage := Value;
  Result := S_OK;
end;

function TfrxCustomPreviewPages.Get_CurPreviewPage(out Value: Integer): HResult; stdcall;
begin
  Value := CurPreviewPage;
  Result := S_OK;
end;

function TfrxCustomPreviewPages.Set_CurPreviewPage(Value: Integer): HResult; stdcall;
begin
  CurPreviewPage := Value;
  Result := S_OK;
end;

function TfrxCustomPreviewPages.IfrxCustomPreviewPages_Page(Index: Integer; out Value: IfrxReportPage): HResult; stdcall;
begin
  Value := Page[Index] as IfrxReportPage;
  Result := S_OK;
end;

function TfrxCustomPreviewPages.PageModify(PageNo: Integer; const Page: IfrxReportPage): HResult; stdcall;
var
  idsp:   IInterfaceComponentReference;
  report_page: TfrxReportPage;
begin
  Result := Page.QueryInterface( IInterfaceComponentReference, idsp);
  if Result = S_OK then
  begin
    report_page := TfrxReportPage( idsp.GetComponent );
    ModifyPage( PageNo, report_page )
  end;
end;
{$ENDIF}

{ TfrxExpressionCache }

constructor TfrxExpressionCache.Create(AScript: TfsScript);
begin
  FExpressions := TStringList.Create;
  FExpressions.Sorted := True;
  FScript := TfsScript.Create(nil);
  FScript.ExtendedCharset := True;
  FMainScript := AScript;
end;

destructor TfrxExpressionCache.Destroy;
begin
  FExpressions.Free;
  FScript.Free;
  inherited;
end;

procedure TfrxExpressionCache.Clear;
begin
  FExpressions.Clear;
  FScript.Clear;
end;

function TfrxExpressionCache.Calc(const Expression: String;
  var ErrorMsg: String; AScript: TfsScript): Variant;
var
  i: Integer;
  v: TfsProcVariable;
  Compiled: Boolean;
begin
  ErrorMsg := '';
  FScript.Parent := AScript;
  i := FExpressions.IndexOf(Expression);
  if i = -1 then
  begin
    i := FExpressions.Count;
    FScript.SyntaxType := FScriptLanguage;
    if CompareText(FScriptLanguage, 'PascalScript') = 0 then
      FScript.Lines.Text := 'function fr3f' + IntToStr(i) + ': Variant; begin ' +
        'Result := ' + Expression + ' end; begin end.'
    else if CompareText(FScriptLanguage, 'C++Script') = 0 then
      FScript.Lines.Text := 'Variant fr3f' + IntToStr(i) + '() { ' +
        'return ' + Expression + '; } {}'
    else if CompareText(FScriptLanguage, 'BasicScript') = 0 then
      FScript.Lines.Text := 'function fr3f' + IntToStr(i) + #13#10 +
        'return ' + Expression + #13#10 + 'end function'
    else if CompareText(FScriptLanguage, 'JScript') = 0 then
      FScript.Lines.Text := 'function fr3f' + IntToStr(i) + '() { ' +
        'return ' + Expression + '; }';

    Compiled := FScript.Compile;
    v := TfsProcVariable(FScript.Find('fr3f' + IntToStr(i)));

    if not Compiled then
    begin
      if v <> nil then
      begin
        v.Free;
        FScript.Remove(v);
      end;
      ErrorMsg := frxResources.Get('clExprError') + ' ''' + Expression + ''': ' +
        FScript.ErrorMsg;
      Result := Null;
      Exit;
    end;

    FExpressions.AddObject(Expression, v);
  end
  else
    v := TfsProcVariable(FExpressions.Objects[i]);
  FMainScript.MainProg := False;
  try
    try
      Result := v.Value;
    except
      on e: Exception do
        ErrorMsg := e.Message;
    end;
  finally
    FMainScript.MainProg := True;
  end;
end;

function TfrxExpressionCache.GetCaseSensitive: Boolean;
begin
{$IFDEF Delphi6}
  Result := FExpressions.CaseSensitive;
{$ELSE}
  Result := False;
{$ENDIF}
end;

procedure TfrxExpressionCache.SetCaseSensitive(const Value: Boolean);
begin
{$IFDEF Delphi6}
  FExpressions.CaseSensitive := Value;
{$ENDIF}
end;


{ TfrxCustomExportFilter }

constructor TfrxCustomExportFilter.Create(AOwner: TComponent);
begin
  inherited;
  if not FNoRegister then
    frxExportFilters.Register(Self);
  FShowDialog := True;
  FUseFileCache := True;
  FDefaultPath := '';
  FShowProgress := True;
  FSlaveExport := False;
  FOverwritePrompt := False;
  FFiles := nil;
end;

constructor TfrxCustomExportFilter.CreateNoRegister;
begin
  FNoRegister := True;
  Create(nil);
end;

destructor TfrxCustomExportFilter.Destroy;
begin
  if not FNoRegister then
    frxExportFilters.Unregister(Self);
  if FFiles <> nil then
    FFiles.Free;
  inherited;
end;

class function TfrxCustomExportFilter.GetDescription: String;
begin
  Result := '';
end;

procedure TfrxCustomExportFilter.Finish;
begin
//
end;

procedure TfrxCustomExportFilter.FinishPage(Page: TfrxReportPage;
  Index: Integer);
begin
//
end;

function TfrxCustomExportFilter.ShowModal: TModalResult;
begin
  Result := mrOk;
end;

function TfrxCustomExportFilter.Start: Boolean;
begin
  Result := True;
end;

procedure TfrxCustomExportFilter.StartPage(Page: TfrxReportPage;
  Index: Integer);
begin
//
end;


{ TfrxCustomWizard }

constructor TfrxCustomWizard.Create(AOwner: TComponent);
begin
  inherited;
  FDesigner := TfrxCustomDesigner(AOwner);
  FReport := FDesigner.Report;
end;

class function TfrxCustomWizard.GetDescription: String;
begin
  Result := '';
end;


{ TfrxCustomCompressor }

constructor TfrxCustomCompressor.Create(AOwner: TComponent);
begin
  inherited;
  FOldCompressor := frxCompressorClass;
  frxCompressorClass := TfrxCompressorClass(ClassType);
end;

destructor TfrxCustomCompressor.Destroy;
begin
  frxCompressorClass := FOldCompressor;
  if FStream <> nil then
    FStream.Free;
  if FTempFile <> '' then
    SysUtils.DeleteFile(FTempFile);
  inherited;
end;

procedure TfrxCustomCompressor.CreateStream;
begin
  if FIsFR3File or not FReport.EngineOptions.UseFileCache then
    FStream := TMemoryStream.Create
  else
  begin
    FTempFile := frxCreateTempFile(FReport.EngineOptions.TempDir);
    FStream := TFileStream.Create(FTempFile, fmCreate);
  end;
end;

{$IFDEF FR_COM}
function TfrxCustomCompressor.CompressStream(
  const InputStream: IUnknown;
  const OutputStream: IUnknown;
  Compression_: Integer;
  const FileName: WideString): HResult; stdcall;
var
  ComStream:        IStream;
  OleInputStream:   TOleStream;
  OleOutputStream:  TOleStream;

  NetStream:        _Stream;
  ClrInputStream:   TClrStream;
  ClrOutputStream:  TClrStream;


begin
  try
    Result := InputStream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleInputStream := TOleStream.Create(ComStream);
      OleOutputStream := TOleStream.Create(OutputStream as IStream);
      frxCompressStream(OleInputStream, OleOutputStream, gzMax, FileName);
      OleInputStream.Free;
      OleOutputStream.Free;
      ComStream := nil;
    end
    else
    begin
      Result := InputStream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrInputStream := TClrStream.Create(NetStream);
        ClrOutputStream := TClrStream.Create(OutputStream as _Stream);
        frxCompressStream(ClrInputStream, ClrOutputStream, gzMax, FileName);
        ClrInputStream.Free;
        ClrOutputStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
  if FStream <> nil then
    FStream.Free;
  if FTempFile <> '' then
    SysUtils.DeleteFile(FTempFile);
end;

function TfrxCustomCompressor.DecompressStream(const Stream: IUnknown): HResult; stdcall;
var
  ComStream: IStream;
  OleStream: TOleStream;

  NetStream:  _Stream;
  ClrStream: TClrStream;
begin
  try
    Result := Stream.QueryInterface(IStream, ComStream);
    if Result = S_OK then
    begin
      OleStream := TOleStream.Create(ComStream);
      Decompress(OleStream);
      OleStream.Free;
      ComStream := nil;
    end
    else
    begin
      Result := Stream.QueryInterface(_Stream, NetStream);
      if Result = S_OK then
      begin
        ClrStream := TClrStream.Create(NetStream);
        Decompress(ClrStream);
        ClrStream.Free;
        NetStream._Release();
      end;
    end;
  except
    Result := E_FAIL;
  end;
end;
{$ENDIF}


{ TfrxCustomCrypter }

constructor TfrxCustomCrypter.Create(AOwner: TComponent);
begin
  inherited;
  frxCrypterClass := TfrxCrypterClass(ClassType);
end;

destructor TfrxCustomCrypter.Destroy;
begin
  if FStream <> nil then
    FStream.Free;
  inherited;
end;

procedure TfrxCustomCrypter.CreateStream;
begin
  FStream := TMemoryStream.Create;
end;


{ TfrxGlobalDataSetList }

constructor TfrxGlobalDataSetList.Create;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  FCriticalSection := TCriticalSection.Create;
{$ENDIF}
  inherited;
end;

destructor TfrxGlobalDataSetList.Destroy;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  FCriticalSection.Free;
  FCriticalSection := nil;
{$ENDIF}
  inherited;
end;

procedure TfrxGlobalDataSetList.Lock;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  if FCriticalSection <> nil then
    FCriticalSection.Enter;
{$ENDIF}
end;

procedure TfrxGlobalDataSetList.Unlock;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  if FCriticalSection <> nil then
    FCriticalSection.Leave;
{$ENDIF}
end;

{$IFDEF FPC}
procedure RegisterUnitfrxClass;
begin
  RegisterComponents('FR4Controls',[TfrxReport, TfrxUserDataSet]);
end;

procedure Register;
begin
  RegisterUnit('frxClass',@RegisterUnitfrxClass);
end;
{$ENDIF}

initialization
{$IFDEF PNG}
{$IFDEF Delphi12}
  TPicture.RegisterFileFormat('PNG_OLD', 'Portable Network Graphics', TPNGObject);
{$ENDIF}
{$ENDIF}
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxComponent, TControl);
  GroupDescendentsWith(TfrxDBComponents, TControl);
  GroupDescendentsWith(TfrxCustomCrypter, TControl);
  GroupDescendentsWith(TfrxCustomCompressor, TControl);
  GroupDescendentsWith(TfrxCustomExportFilter, TControl);
  GroupDescendentsWith(TfrxFrame, TControl);
  GroupDescendentsWith(TfrxHighlight, TControl);
  GroupDescendentsWith(TfrxStyleItem, TControl);

{$ENDIF}
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS := TCriticalSection.Create;
{$ENDIF}
  DatasetList := TfrxGlobalDataSetList.Create;
  frxGlobalVariables := TfrxVariables.Create;
  { create parent form for OLE and RICH controls in the main thread }
  {$IFNDEF FPC}
  frxParentForm;
  {$ENDIF}
  Screen.Cursors[crHand] := LoadCursor(hInstance, 'frxHAND');
  Screen.Cursors[crZoom] := LoadCursor(hInstance, 'frxZOOM');
  Screen.Cursors[crFormat] := LoadCursor(hInstance, 'frxFORMAT');

  RegisterClasses([
    TfrxChild, TfrxColumnFooter, TfrxColumnHeader, TfrxCustomMemoView, TfrxMasterData,
    TfrxDetailData, TfrxSubDetailData, TfrxDataBand4, TfrxDataBand5, TfrxDataBand6,
    TfrxDialogPage, TfrxFooter, TfrxFrame, TfrxGroupFooter, TfrxGroupHeader,
    TfrxHeader, TfrxHighlight, TfrxLineView, TfrxMemoView, TfrxOverlay, TfrxPageFooter,
    TfrxPageHeader, TfrxPictureView, TfrxReport, TfrxReportPage, TfrxReportSummary,
    TfrxReportTitle, TfrxShapeView, TfrxSubreport, TfrxSysMemoView, TfrxStyleItem,
    TfrxNullBand, TfrxCustomLineView, TfrxDataPage]);


  frxResources.UpdateFSResources;
  frxFR2Events := TfrxFR2Events.Create;
{$IFDEF FR_COM}
{$IFNDEF NO_CRITICAL_SECTION}
  frxADOCS := TCriticalSection.Create;
{$ENDIF}
  frxADO_RefCount := 0;
  frxGZipCompressor := TfrxGZipCompressor.Create(nil);
  frxCrypt := TfrxCrypt.Create(nil);
  frxADOComponent := TfrxADOComponents.Create(nil);

{$IFNDEF EXT_EXPORTS}
  {$IFNDEF FR_LITE}
  Export2PDF := TfrxPDFExport.Create(nil);
  Export2XLS := TfrxXLSExport.Create(nil);
  Export2XML := TfrxXMLExport.Create(nil);
  Export2RTF := TfrxRTFExport.Create(nil);
  Export2HTML := TfrxHTMLExport.Create(nil);
  Export2BMP := TfrxBMPExport.Create(nil);
  Export2JPEG := TfrxJPEGExport.Create(nil);
  Export2TIFF := TfrxTIFFExport.Create(nil);
  Export2GIF := TfrxGIFExport.Create(nil);
  Export2Mail := TfrxMailExport.Create(nil);
  Export2DMP := TfrxDotMatrixExport.Create(nil);
  Export2BIFF := TfrxBIFFExport.Create(nil);
  Export2DBF  := TfrxDBFExport.Create(nil);
  {$ENDIF}
  Export2TXT := TfrxSimpleTextExport.Create(nil);
  Export2CSV := TfrxCSVExport.Create(nil);
  Export2ODS := TfrxODSExport.Create(nil);
  Export2ODT := TfrxODTExport.Create(nil);
{$ENDIF}

try
  rptcf := TComponentFactory.Create(ComServer, TfrxReport, Class_TfrxReport, ciMultiInstance, tmApartment);
  TComponentFactory.Create(ComServer, TfrxUserDataSet, CLASS_TfrxUserDataSet, ciMultiInstance, tmApartment);
  TComponentFactory.Create(ComServer, TfrxGZipCompressor, CLASS_TfrxGZipCompressor, ciMultiInstance, tmApartment);
  TComponentFactory.Create(ComServer, TfsScript, CLASS_TFastScript, ciMultiInstance, tmApartment);

  DispatchableComponentFactory := TComponentFactory.Create(ComServer, TfrxComponent, CLASS_TfrxDispatchableComponent, ciMultiInstance, tmApartment);
  DatabaseComponentFactory := TComponentFactory.Create(ComServer, TfrxADODatabase, CLASS_TfrxADODatabase, ciMultiInstance, tmApartment);
  ExportComponentFactory := TComponentFactory.Create(ComServer, TfrxReport, CLASS_TfrxDispatchableExports, ciMultiInstance, tmApartment);
  QueryComponentFactory :=  TComponentFactory.Create(ComServer, TfrxADOQuery, CLASS_TfrxADOQuery, ciMultiInstance, tmApartment);
  TableComponentFactory :=  TComponentFactory.Create(ComServer, TfrxADOTable, CLASS_TfrxADOTable, ciMultiInstance, tmApartment);


except
end;
{$ENDIF}


finalization
{$IFDEF PNG}
{$IFDEF Delphi12}
  TPicture.UnregisterGraphicClass(TPNGObject);
{$ENDIF}
{$ENDIF}
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS.Free;
{$ENDIF}

{$IFDEF FR_COM}
  if Assigned(frxADOComponent) then frxADOComponent.Free;



  if Assigned(DispatchableComponentFactory) then DispatchableComponentFactory.Free;
  if Assigned(DatabaseComponentFactory) then DatabaseComponentFactory.Free;
  if Assigned(QueryComponentFactory) then QueryComponentFactory.Free;
  if Assigned(TableComponentFactory) then TableComponentFactory.Free;

{$IFNDEF EXT_EXPORTS}
  {$IFNDEF FR_LITE}
  Export2Gif.Free;
  Export2Mail.Free;
  Export2TIFF.Free;
  Export2JPEG.Free;
  Export2XML.Free;
  Export2XLS.Free;
  Export2RTF.Free;
  Export2HTML.Free;
  Export2BMP.Free;
  Export2PDF.Free;
  Export2DMP.Free;
  Export2BIFF.Free;
  Export2DBF.Free;
  {$ENDIF}
  Export2CSV.Free;
  Export2TXT.Free;
  Export2ODS.Free;
  Export2ODT.Free;
{$ENDIF}

{$IFDEF FR_FIB}
  if Assigned(frxDefaultFIBConnection) then
  begin
    frxDefaultFIBConnection.Connected := false;
    frxDefaultFIBConnection.Free;
  end;
{$ENDIF}

  if frxGZipCompressor <> nil then frxGZipCompressor.Destroy;
  if frxCrypt <> nil then frxCrypt.Destroy;

{$IFNDEF NO_CRITICAL_SECTION}
  frxADOCS.Free;
{$ENDIF}

{$ENDIF}

  frxGlobalVariables.Free;
  DatasetList.Free;
  if FParentForm <> nil then
  begin
    EmptyParentForm;
    FParentForm.Free;
  end;
  FParentForm := nil;
  frxFR2Events.Free;
end.




//c867a8a91754a886c862cfc0bd9c73c8