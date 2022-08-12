
{******************************************}
{                                          }
{             FastReport v4.0              }
{             Report preview               }
{                                          }
{         Copyright (c) 1998-2008          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPreview;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, StdCtrls, Menus, ComCtrls, ImgList, frxCtrls, frxDock,
{$IFDEF FR_COM}
  FastReport_TLB,
{$ENDIF}
  ToolWin, frxPreviewPages, frxClass
{$IFDEF FPC}
  , LResources, LCLType, LCLProc, LCLIntf, LazHelper, lmf4
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


const
  WM_UPDATEZOOM = WM_USER + 1;

type
  TfrxPreview = class;
  TfrxPreviewWorkspace = class;
  TfrxPageList = class;

  TfrxPreviewTool = (ptHand, ptZoom); // not implemented, backw compatibility only
  TfrxPageChangedEvent = procedure(Sender: TfrxPreview; PageNo: Integer) of object;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
{$IFDEF FR_COM}
  TfrxPreview = class(TfrxCustomPreview, IfrxPreview)
{$ELSE}
  TfrxPreview = class(TfrxCustomPreview)
{$ENDIF}
  private
    FAllowF3: Boolean;
    {$IFNDEF FPC}
    FBorderStyle: TBorderStyle;
    {$ENDIF}
    FCancelButton: TButton;
    FLocked: Boolean;
    FMessageLabel: TLabel;
    FMessagePanel: TPanel;
    FOnPageChanged: TfrxPageChangedEvent;
    FOutline: TTreeView;
    FOutlineColor: TColor;
    FOutlinePopup: TPopupMenu;
    FPageNo: Integer;
    FRefreshing: Boolean;
    FRunning: Boolean;
    FScrollBars: TScrollStyle;
    FSplitter: TSplitter;
    FThumbnail: TfrxPreviewWorkspace;
    FTick: Cardinal;
    FTool: TfrxPreviewTool;
    FWorkspace: TfrxPreviewWorkspace;
    FZoom: Extended;
    FZoomMode: TfrxZoomMode;
    function GetActiveFrameColor: TColor;
    function GetBackColor: TColor;
    function GetFrameColor: TColor;
    function GetOutlineVisible: Boolean;
    function GetOutlineWidth: Integer;
    function GetPageCount: Integer;
    function GetThumbnailVisible: Boolean;
    function GetOnMouseDown: TMouseEvent;
    procedure EditTemplate;
    procedure OnCancel(Sender: TObject);
    procedure OnCollapseClick(Sender: TObject);
    procedure OnExpandClick(Sender: TObject);
    procedure OnMoveSplitter(Sender: TObject);
    procedure OnOutlineClick(Sender: TObject);
    procedure SetActiveFrameColor(const Value: TColor);
    procedure SetBackColor(const Value: TColor);
    {$IFNDEF FPC}
    procedure SetBorderStyle(Value: TBorderStyle);
    {$ENDIF}
    procedure SetFrameColor(const Value: TColor);
    procedure SetOutlineColor(const Value: TColor);
    procedure SetOutlineWidth(const Value: Integer);
    procedure SetOutlineVisible(const Value: Boolean);
    procedure SetPageNo(Value: Integer);
    procedure SetThumbnailVisible(const Value: Boolean);
    procedure SetZoom(const Value: Extended);
    procedure SetZoomMode(const Value: TfrxZoomMode);
    procedure SetOnMouseDown(const Value: TMouseEvent);
    procedure UpdateOutline;
    procedure UpdatePages;
    procedure UpdatePageNumbers;
    procedure WMEraseBackground(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Lock; override;
    procedure Unlock; override;
    procedure RefreshReport; override;
    procedure InternalOnProgressStart(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); override;
    procedure InternalOnProgress(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); override;
    procedure InternalOnProgressStop(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); override;

{$IFDEF FR_COM}
    function AddPage: HResult; stdcall;
    function DeletePage: HResult; stdcall;
    function Print: HResult; stdcall;
    function Edit: HResult; stdcall;
    function First: HResult; stdcall;
    function Next: HResult; stdcall;
    function Prior: HResult; stdcall;
    function Last: HResult; stdcall;
    function PageSetupDlg: HResult; stdcall;
    function Find: HResult; stdcall;
    function FindNext: HResult; stdcall;
    function Cancel: HResult; stdcall;
    function Clear: HResult; stdcall;
    function SetPosition(PageN, Top: Integer): HResult; stdcall;
    function ShowMessage(const s: WideString): HResult; stdcall;
    function HideMessage: HResult; stdcall;
    function MouseWheelScroll(Delta: Integer; Horz: WordBool; Zoom: WordBool): HResult; stdcall;
    function Get_PageCount(out Value: Integer): HResult; stdcall;
    function Get_PageNo(out Value: Integer): HResult; stdcall;
    function Set_PageNo(Value: Integer): HResult; stdcall;
    function Get_Tool(out Value: frxPreviewTool): HResult; stdcall;
    function Set_Tool(Value: frxPreviewTool): HResult; stdcall;
    function Get_Zoom(out Value: Double): HResult; stdcall;
    function Set_Zoom(Value: Double): HResult; stdcall;
    function Get_ZoomMode(out Value: frxZoomMode): HResult; stdcall;
    function Set_ZoomMode(Value: frxZoomMode): HResult; stdcall;
    function Get_OutlineVisible(out Value: WordBool): HResult; stdcall;
    function Set_OutlineVisible(Value: WordBool): HResult; stdcall;
    function Get_OutlineWidth(out Value: Integer): HResult; stdcall;
    function Set_OutlineWidth(Value: Integer): HResult; stdcall;
    function Get_Enabled(out Value: WordBool): HResult; stdcall;
    function Set_Enabled(Value: WordBool): HResult; stdcall;
    function LoadPreparedReportFromFile(const FileName: WideString): HResult; stdcall;
    function SavePreparedReportToFile(const FileName: WideString): HResult; stdcall;
    function Get_FullScreen(out Value: WordBool): HResult; stdcall;
    function Set_FullScreen(Value: WordBool): HResult; stdcall;
    function Get_ToolBarVisible(out Value: WordBool): HResult; stdcall;
    function Set_ToolBarVisible(Value: WordBool): HResult; stdcall;
    function Get_StatusBarVisible(out Value: WordBool): HResult; stdcall;
    function Set_StatusBarVisible(Value: WordBool): HResult; stdcall;
{$ELSE}
    procedure AddPage;
    procedure DeletePage;
    procedure Print;
    procedure Edit;
    procedure First;
    procedure Next;
    procedure Prior;
    procedure Last;
    procedure PageSetupDlg;
    procedure Find;
    procedure FindNext;
    procedure Cancel;
    procedure Clear;
    procedure SetPosition(PageN, Top: Integer);
    procedure ShowMessage(const s: String);
    procedure HideMessage;
    procedure MouseWheelScroll(Delta: Integer; Horz: Boolean = False;
      Zoom: Boolean = False);
{$ENDIF}
    function  GetTopPosition: Integer;
    procedure LoadFromFile; overload;
    procedure LoadFromFile(FileName: String); overload;
    procedure SaveToFile; overload;
    procedure SaveToFile(FileName: String); overload;
    procedure Export(Filter: TfrxCustomExportFilter);
    function FindText(SearchString: String; FromTop, IsCaseSensitive: Boolean): Boolean;
    function FindTextFound: Boolean;
    procedure FindTextClear;

    property PageCount: Integer read GetPageCount;
    property PageNo: Integer read FPageNo write SetPageNo;
    // not implemented, backw compatibility only
    property Tool: TfrxPreviewTool read FTool write FTool;
    property Zoom: Extended read FZoom write SetZoom;
    property ZoomMode: TfrxZoomMode read FZoomMode write SetZoomMode;
    property  Locked: Boolean read FLocked;
    property OutlineTree: TTreeView read FOutline;
    property Splitter: TSplitter read FSplitter;
    property Thumbnail: TfrxPreviewWorkspace read FThumbnail;
    property Workspace: TfrxPreviewWorkspace read FWorkspace;
  published
    property Align;
    property ActiveFrameColor: TColor read GetActiveFrameColor write SetActiveFrameColor default $804020;
    property BackColor: TColor read GetBackColor write SetBackColor default clGray;
    {$IFDEF FPC}
    property BorderStyle;
    {$ELSE}
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    {$ENDIF}
    property BorderWidth;
    property FrameColor: TColor read GetFrameColor write SetFrameColor default clBlack;
    property OutlineColor: TColor read FOutlineColor write SetOutlineColor default clWindow;
    property OutlineVisible: Boolean read GetOutlineVisible write SetOutlineVisible;
    property OutlineWidth: Integer read GetOutlineWidth write SetOutlineWidth;
    property PopupMenu;
    property ThumbnailVisible: Boolean read GetThumbnailVisible write SetThumbnailVisible;
    property OnClick;
    property OnDblClick;
    property OnPageChanged: TfrxPageChangedEvent read FOnPageChanged write FOnPageChanged;
    property OnMouseDown: TMouseEvent read GetOnMouseDown write SetOnMouseDown;
    property Anchors;
    property UseReportHints;
  end;

  TfrxPreviewForm = class(TForm)
    ToolBar: TToolBar;
    OpenB: TToolButton;
    SaveB: TToolButton;
    PrintB: TToolButton;
    ExportB: TToolButton;
    FindB: TToolButton;
    PageSettingsB: TToolButton;
    Sep3: TfrxTBPanel;
    ZoomCB: TfrxComboBox;
    Sep1: TToolButton;
    Sep2: TToolButton;
    FirstB: TToolButton;
    PriorB: TToolButton;
    Sep4: TfrxTBPanel;
    PageE: TEdit;
    NextB: TToolButton;
    LastB: TToolButton;
    StatusBar: TStatusBar;
    ZoomMinusB: TToolButton;
    Sep5: TToolButton;
    ZoomPlusB: TToolButton;
    DesignerB: TToolButton;
    frTBPanel1: TfrxTBPanel;
    CancelB: TSpeedButton;
    ExportPopup: TPopupMenu;
    HiddenMenu: TPopupMenu;
    Showtemplate1: TMenuItem;
    RightMenu: TPopupMenu;
    FullScreenBtn: TToolButton;
    EmailB: TToolButton;
    PdfB: TToolButton;
    OutlineB: TToolButton;
    ThumbB: TToolButton;
    N1: TMenuItem;
    ExpandMI: TMenuItem;
    CollapseMI: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ZoomMinusBClick(Sender: TObject);
    procedure ZoomCBClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FirstBClick(Sender: TObject);
    procedure PriorBClick(Sender: TObject);
    procedure NextBClick(Sender: TObject);
    procedure LastBClick(Sender: TObject);
    procedure PageEClick(Sender: TObject);
    procedure PrintBClick(Sender: TObject);
    procedure OpenBClick(Sender: TObject);
    procedure SaveBClick(Sender: TObject);
    procedure FindBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DesignerBClick(Sender: TObject);
    procedure DesignerBClick2(Sender: TObject);
    procedure NewPageBClick(Sender: TObject);
    procedure DelPageBClick(Sender: TObject);
    procedure CancelBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageSettingsBClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DesignerBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Showtemplate1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FullScreenBtnClick(Sender: TObject);
    procedure PdfBClick(Sender: TObject);
    procedure EmailBClick(Sender: TObject);
    procedure ZoomPlusBClick(Sender: TObject);
    procedure OutlineBClick(Sender: TObject);
    procedure ThumbBClick(Sender: TObject);
    procedure CollapseAllClick(Sender: TObject);
    procedure ExpandAllClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FFreeOnClose: Boolean;
    FPreview: TfrxPreview;
    FOldBS: TFormBorderStyle;
    FOldState: TWindowState;
    FFullScreen: Boolean;
    FPDFExport: TfrxCustomExportFilter;
    FEmailExport: TfrxCustomExportFilter;
    {$IFNDEF FPC}
    FStatusBarOldWindowProc: TWndMethod;
    {$ENDIF}
    procedure ExportMIClick(Sender: TObject);
    procedure OnPageChanged(Sender: TfrxPreview; PageNo: Integer);
    procedure OnPreviewDblClick(Sender: TObject);
    procedure UpdateControls;
    procedure UpdateZoom;
    procedure WMUpdateZoom(var Message: TMessage); message WM_UPDATEZOOM;
    procedure WMActivateApp(var Msg: TWMActivateApp); message WM_ACTIVATEAPP;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure StatusBarWndProc(var Message: TMessage);
    function GetReport: TfrxReport;
  public
    procedure Init;
    procedure SetMessageText(const Value: String; IsHint: Boolean = False);
    procedure SwitchToFullScreen;
    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose;
    property Preview: TfrxPreview read FPreview;
    property Report: TfrxReport read GetReport;
  end;

  TfrxPreviewWorkspace = class(TfrxScrollWin)
  private
    FActiveFrameColor: TColor;
    FBackColor: TColor;
    FDefaultCursor: TCursor;
    FDisableUpdate: Boolean;
    FDown: Boolean;
    FEMFImage: TMetafile;
    FEMFImagePage: Integer;
    FFrameColor: TColor;
    FIsThumbnail: Boolean;
    FLastFoundPage: Integer;
    FLastPoint: TPoint;
    FLocked: Boolean;
    FOffset: TPoint;
    FTimeOffset: Cardinal;
    FPageList: TfrxPageList;
    FPageNo: Integer;
    FPreview: TfrxPreview;
    FPreviewPages: TfrxCustomPreviewPages;
    FZoom: Extended;
    FRTLLanguage: Boolean;
    procedure DrawPages(BorderOnly: Boolean);
    procedure FindText;
    procedure SetToPageNo(PageNo: Integer);
    procedure UpdateScrollBars;
  protected
    procedure PrevDblClick(Sender: TObject);
    procedure MouseDown(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure OnHScrollChange(Sender: TObject); override;
    procedure Resize; override;
    procedure OnVScrollChange(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure SetPosition(PageN, Top: Integer);
    function GetTopPosition: Integer;
    { page list }
    procedure AddPage(AWidth, AHeight: Integer);
    procedure ClearPageList;
    procedure CalcPageBounds(ClientWidth: Integer);

    property ActiveFrameColor: TColor read FActiveFrameColor write FActiveFrameColor default $804020;
    property BackColor: TColor read FBackColor write FBackColor default clGray;
    property FrameColor: TColor read FFrameColor write FFrameColor default clBlack;
    property IsThumbnail: Boolean read FIsThumbnail write FIsThumbnail;
    property Locked: Boolean read FLocked write FLocked;
    property PageNo: Integer read FPageNo write FPageNo;
    property Preview: TfrxPreview read FPreview write FPreview;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages
      write FPreviewPages;
    property Zoom: Extended read FZoom write FZoom;
    property RTLLanguage: Boolean read FRTLLanguage write FRTLLanguage;
    property OnDblClick;
  end;

  TfrxPageItem = class(TCollectionItem)
  public
    Height: Integer;
    Width: Integer;
    OffsetX: Integer;
    OffsetY: Integer;
  end;

  TfrxPageList = class(TCollection)
  private
    FMaxWidth: Integer;
    function GetItems(Index: Integer): TfrxPageItem;
  public
    constructor Create;
    property Items[Index: Integer]: TfrxPageItem read GetItems; default;
    procedure AddPage(AWidth, AHeight: Integer; Zoom: Extended);
    procedure CalcBounds(ClientWidth: Integer);
    function FindPage(OffsetY: Integer; OffsetX: Integer = 0): Integer;
    function GetPageBounds(Index, ClientWidth: Integer; Scale: Extended; RTL: Boolean): TRect;
    function GetMaxBounds: TPoint;
  end;


implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}
{$R *.res}

uses
  {$IFNDEF FPC}Printers,{$ENDIF} frxPrinter, frxSearchDialog, frxUtils, frxRes, frxDsgnIntf,
  frxPreviewPageSettings, frxDMPClass;

{$IFNDEF FPC}
type
  THackControl = class(TWinControl);
{$ENDIF}

{ search given string in a metafile }

var
  TextToFind: String;
  TextFound: Boolean;
  TextBounds: TRect;
  RecordNo: Integer;
  LastFoundRecord: Integer;
  CaseSensitive: Boolean;

{$IFDEF FPC}
// we are using lmf implementation
procedure FindInLmf(ALmf: TlmfImage; ARect: TRect);
var
  s: String;
  i: integer;
  AText: TlmfText;
  R: TRect;
  // ACount: integer;
  // SFound: String;
  STextToFind: String;
begin
  {$IFDEF FPC}
  // ACount := ALmf.list.ComponentCount;
  // DebugLn('ALmf count ', dbgs(ACount),' find me ',TextToFind);
  {$ENDIF}
  if not CaseSensitive then
    STextToFind := UTF8UpperCase(TextToFind)
  else
    STextToFind := TextToFind;
  for i := 0 to ALmf.List.ComponentCount - 1 do
  begin
    {$IFDEF FPCUSELMFFOREMF}
    // writeln('ALmf class ',ALmf.list.Components[i].ClassName);
    {$ENDIF}
    if ALmf.List.Components[i] is TlmfText then
    begin
      AText := TlmfText(ALmf.List.Components[i]);
      s := AText.Text;
      if not CaseSensitive then s := UTF8UpperCase(s);
      TextFound := UTF8Pos(STextToFind, s) <> 0;
      if TextFound and (RecordNo > LastFoundRecord) then
      begin
        R := AText.StrBounds;
        // SFound :=  S;
        TextBounds := R;
        LastFoundRecord := RecordNo;
        Inc(RecordNo);
        break;
      end else
        TextFound := False;
    end;
    Inc(RecordNo);
  end;
end;
{$ELSE}
function EnumEMFRecordsProc(DC: HDC; HandleTable: PHandleTable;
  EMFRecord: PEnhMetaRecord; nObj: Integer; OptData: Pointer): Bool; stdcall;
var
  Typ: Byte;
  s: String;
  t: TEMRExtTextOut;
  Found: Boolean;
begin
  Result := True;
  Typ := EMFRecord^.iType;
  if Typ in [83, 84] then
  begin
    t := PEMRExtTextOut(EMFRecord)^;
    s := WideCharLenToString(PWideChar(PAnsiChar(EMFRecord) + t.EMRText.offString),
      t.EMRText.nChars);
    if CaseSensitive then
      Found := Pos(TextToFind, s) <> 0 else
      Found := Pos(AnsiUpperCase(TextToFind), AnsiUpperCase(s)) <> 0;
    if Found and (RecordNo > LastFoundRecord) then
    begin
      TextFound := True;
      TextBounds := t.rclBounds;
      LastFoundRecord := RecordNo;
      Result := False;
    end;
  end;
  Inc(RecordNo);
end;
{$ENDIF}

{ TfrxPageList }

constructor TfrxPageList.Create;
begin
  inherited Create(TfrxPageItem);
end;

function TfrxPageList.GetItems(Index: Integer): TfrxPageItem;
begin
  Result := TfrxPageItem(inherited Items[Index]);
end;

procedure TfrxPageList.AddPage(AWidth, AHeight: Integer; Zoom: Extended);
begin
  with TfrxPageItem(Add) do
  begin
    Width := Round(AWidth * Zoom);
    Height := Round(AHeight * Zoom);
  end;
end;

procedure TfrxPageList.CalcBounds(ClientWidth: Integer);
var
  i, j, CurX, CurY, MaxY, offs: Integer;
  Item: TfrxPageItem;
begin
  FMaxWidth := 0;
  CurY := 10;
  i := 0;
  while i < Count do
  begin
    j := i;
    CurX := 0;
    MaxY := 0;
    { find series of pages that will fit in the clientwidth }
    { also calculate max height of series }
    while j < Count do
    begin
      Item := Items[j];
      { check the width, allow at least one iteration }
      if (CurX > 0) and (CurX + Item.Width > ClientWidth) then break;
      Item.OffsetX := CurX;
      Item.OffsetY := CurY;
      Inc(CurX, Item.Width + 10);
      if Item.Height > MaxY then
        MaxY := Item.Height;
      Inc(j);
    end;

    if CurX > FMaxWidth then
      FMaxWidth := CurX;

    { center series horizontally }
    offs := (ClientWidth - CurX + 10) div 2;
    if offs < 0 then
      offs := 0;
    Inc(offs, 10);
    while (i < j) do
    begin
      Inc(Items[i].OffsetX, offs);
      Inc(i);
    end;

    Inc(CurY, MaxY + 10);
  end;
end;

function TfrxPageList.FindPage(OffsetY: Integer; OffsetX: Integer = 0): Integer;
var
  i, i0, i1, c, add: Integer;
  Item: TfrxPageItem;
begin
  i0 := 0;
  i1 := Count - 1;

  while i0 <= i1 do
  begin
    i := (i0 + i1) div 2;
    if OffsetX <> 0 then
      add := 0 else
      add := Round(Items[i].Height / 5);
    if Items[i].OffsetY <= OffsetY + add then
      c := -1 else
      c := 1;

    if c < 0 then
      i0 := i + 1 else
      i1 := i - 1;
  end;

  { find exact page }
  if OffsetX <> 0 then
  begin
    for i := i1 - 20 to i1 + 20 do
    begin
      if (i < 0) or (i >= Count) then continue;
      Item := Items[i];
      if PtInRect(Rect(Item.OffsetX, Item.OffsetY,
        Item.OffsetX + Item.Width, Item.OffsetY + Item.Height),
        Point(OffsetX, OffsetY)) then
      begin
        i1 := i;
        break;
      end;
    end;
  end;

  Result := i1;
end;

function TfrxPageList.GetPageBounds(Index, ClientWidth: Integer;
  Scale: Extended; RTL: Boolean): TRect;
var
  ColumnOffs: Integer;
  Item: TfrxPageItem;
begin
  if (Index >= Count) or (Index < 0) then
  begin
    if 794 * Scale > ClientWidth then
      ColumnOffs := 10 else
      ColumnOffs := Round((ClientWidth - 794 * Scale) / 2);
    Result.Left := ColumnOffs;
    Result.Top := Round(10 * Scale);
    Result.Right := Result.Left + Round(794 * Scale);
    Result.Bottom := Result.Top + Round(1123 * Scale);
  end
  else
  begin
    Item := Items[Index];
    if RTL then
      Result.Left := ClientWidth - Item.Width - Item.OffsetX
    else
      Result.Left := Item.OffsetX;
    Result.Top := Item.OffsetY;
    Result.Right := Result.Left + Item.Width;
    Result.Bottom := Result.Top + Item.Height;
  end;
end;

function TfrxPageList.GetMaxBounds: TPoint;
begin
  if Count = 0 then
    Result := Point(0, 0)
  else
  begin
    Result.X := FMaxWidth;
    Result.Y := Items[Count - 1].OffsetY + Items[Count - 1].Height;
  end;
end;


{ TfrxPreviewWorkspace }

constructor TfrxPreviewWorkspace.Create(AOwner: TComponent);
begin
  inherited;
  FPageList := TfrxPageList.Create;
  OnDblClick := PrevDblClick;

  FBackColor := clGray;
  FFrameColor := clBlack;
  FActiveFrameColor := $804020;
  FZoom := 1;
  FDefaultCursor := crHand;

  LargeChange := 300;
  SmallChange := 8;
end;

destructor TfrxPreviewWorkspace.Destroy;
begin
  if FEMFImage <> nil then
    FEMFImage.Free;
  FPageList.Free;
  inherited;
end;

procedure TfrxPreviewWorkspace.OnHScrollChange(Sender: TObject);
var
  pp: Integer;
  r: TRect;
begin
  pp := FOffset.X - HorzPosition;
  FOffset.X := HorzPosition;
  r := Rect(0, 0, ClientWidth, ClientHeight);
  ScrollWindowEx(Handle, pp, 0, @r, @r, 0, nil, SW_ERASE + SW_INVALIDATE);
end;

procedure TfrxPreviewWorkspace.OnVScrollChange(Sender: TObject);
var
  i, pp: Integer;
  r: TRect;
begin
  pp := FOffset.Y - VertPosition;
  FOffset.Y := VertPosition;
  r := Rect(0, 0, ClientWidth, ClientHeight);
  ScrollWindowEx(Handle, 0, pp, @r, @r, 0, nil, SW_ERASE + SW_INVALIDATE);

  if not FIsThumbnail then
  begin
    i := FPageList.FindPage(FOffset.Y);
    FDisableUpdate := True;
    Preview.PageNo := i + 1;
    FDisableUpdate := False;
  end;
end;

procedure TfrxPreviewWorkspace.DrawPages(BorderOnly: Boolean);
var
  i, n: Integer;
  PageBounds: TRect;
  h: HRGN;

  function PageVisible: Boolean;
  begin
    if (PageBounds.Top > ClientHeight) or (PageBounds.Bottom < 0) then
      Result := False
    else
      Result := RectVisible(Canvas.Handle, PageBounds);
  end;

  procedure DrawPage(Index: Integer);
  var
    i: Integer;
    TxtBounds: TRect;
    {$IFDEF LCLCarbon}
    SavedPenColor: TColor;
    {$ENDIF}
  begin
    with Canvas, PageBounds do
    begin
      Pen.Color := FrameColor;
      Pen.Width := 1;
      Pen.Mode := pmCopy;
      Pen.Style := psSolid;
      Brush.Color := clWhite;
      Brush.Style := bsSolid;
      Dec(Bottom);
      Rectangle(Left, Top, Right, Bottom);
    end;

    PreviewPages.DrawPage(Index, Canvas, Zoom, Zoom, PageBounds.Left, PageBounds.Top);

    if FIsThumbnail then
      with Canvas do
      begin
        Font.Name := 'Arial';
        Font.Size := 8;
        Font.Style := [];
        Font.Color := clWhite;
        Brush.Style := bsSolid;
        Brush.Color := BackColor;
        TextOut(PageBounds.Left + 1, PageBounds.Top + 1, ' ' + IntToStr(Index + 1) + ' ');
      end;

    { highlight text found }
    TxtBounds := Rect(Round(TextBounds.Left * Zoom),
      Round(TextBounds.Top * Zoom),
      Round(TextBounds.Right * Zoom),
      Round(TextBounds.Bottom * Zoom));
    if TextFound and (Index = FLastFoundPage) then
      with Canvas, TxtBounds do
      begin
        Pen.Width := 1;
        Pen.Style := psSolid;
        {$IFDEF LCLCarbon}
        // no raster ops under carbon, so we'll draw an rect around text
        SavedPenColor := Pen.Color;
        Pen.Width := 2;
        Pen.Mode := pmCopy;
        Pen.Color := clHighLight;
        Rectangle(PageBounds.Left + Left - 1, PageBounds.Top + Top - 1, PageBounds.Left + Right + 1,
          PageBounds.Top + Bottom + 1);
        Pen.Color := SavedPenColor;
        Pen.Width := 1;
        {$ELSE}
        Pen.Mode := pmXor;
        Pen.Color := clWhite;
        for i := 0 to Bottom - Top do
        begin
          MoveTo(PageBounds.Left + Left - 1, PageBounds.Top + Top + i);
          LineTo(PageBounds.Left + Right + 1, PageBounds.Top + Top + i);
        end;
        {$ENDIF}
        Pen.Mode := pmCopy;
      end;
  end;

begin
  if not Visible then Exit;

  if Locked or (FPageList.Count = 0) then
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
    Exit;
  end;

  if PreviewPages = nil then Exit;

  h := CreateRectRgn(0, 0, ClientWidth, ClientHeight);
  GetClipRgn(Canvas.Handle, h);

  { index of first visible page }
  n := FPageList.FindPage(FOffset.Y);

  { exclude page areas to prevent flickering }
  for i := n - 60 to n + 340 do
  begin
    if i < 0 then continue;
    if i >= FPageList.Count then break;

    PageBounds := FPageList.GetPageBounds(i, ClientWidth, Zoom, FRTLLanguage);
    OffsetRect(PageBounds, -FOffset.X, -FOffset.Y);
    if PageVisible then
      with PageBounds do
        ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
  end;

  { now draw background on the non-clipped area}
  with Canvas do
  begin
    Brush.Color := BackColor;
    Brush.Style := bsSolid;
    FillRect(Rect(0, 0, ClientWidth, ClientHeight));
  end;

  { restore clipregion }
  SelectClipRgn(Canvas.Handle, h);

  { draw border around the active page }
  PageBounds := FPageList.GetPageBounds(PageNo - 1, ClientWidth, Zoom, FRTLLanguage);
  OffsetRect(PageBounds, -FOffset.X, -FOffset.Y);
  with Canvas, PageBounds do
  begin
    Pen.Color := ActiveFrameColor;
    Pen.Width := 2;
    Pen.Mode := pmCopy;
    Pen.Style := psSolid;
    Polyline([Point(Left - 1, Top - 1),
              Point(Right + 1, Top - 1),
              Point(Right + 1, Bottom + 1),
              Point(Left - 1, Bottom + 1),
              Point(Left - 1, Top - 2)]);
  end;
  if not BorderOnly then
  begin
    { draw visible pages }
    for i := n - 60 to n + 340 do
    begin
      if i < 0 then continue;
      if i >= FPageList.Count then break;

      PageBounds := FPageList.GetPageBounds(i, ClientWidth, Zoom, FRTLLanguage);
      OffsetRect(PageBounds, -FOffset.X, -FOffset.Y);
      Inc(PageBounds.Bottom);
      if PageVisible then
        DrawPage(i);
    end;
  end;

  DeleteObject(h);
end;

procedure TfrxPreviewWorkspace.Paint;
begin
  DrawPages(False);
end;

procedure TfrxPreviewWorkspace.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnMouseDown) then
    OnMouseDown(Self, Button, Shift, X, Y);
  if (FPageList.Count = 0) or Locked then Exit;

  if Button = mbLeft then
  begin
    FDown := True;
    FLastPoint.X := X;
    FLastPoint.Y := Y;
  end;
end;

procedure TfrxPreviewWorkspace.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  PageNo: Integer;
  PageBounds: TRect;
  Cur: TCursor;
begin
  if (FPageList.Count = 0) or Locked or FIsThumbnail then Exit;

  if FDown then
  begin
    HorzPosition := HorzPosition - (X - FLastPoint.X);
    VertPosition := VertPosition - (Y - FLastPoint.Y);
    FLastPoint.X := X;
    FLastPoint.Y := Y;
  end
  else
  begin
    PageNo := FPageList.FindPage(FOffset.Y + Y, FOffset.X + X);
    PageBounds := FPageList.GetPageBounds(PageNo, ClientWidth, Zoom, FRTLLanguage);
    Cur := FDefaultCursor;
    PreviewPages.ObjectOver(PageNo, X, Y, mbLeft, [], Zoom,
      PageBounds.Left - FOffset.X, PageBounds.Top - FOffset.Y, False, Cur);
    Cursor := Cur;
  end;
end;

procedure TfrxPreviewWorkspace.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  PageNo: Integer;
  PageBounds: TRect;
  Cur: TCursor;
  XOffSet: Integer;
begin
  if not FIsThumbnail and Assigned(Preview.OnClick) then
    Preview.OnClick(Preview);
  if (FPageList.Count = 0) or Locked then Exit;

  FDown := False;
  if FRTLLanguage then
    XOffSet := ClientWidth - (FOffset.X + X)
  else
    XOffSet := FOffset.X + X;

  PageNo := FPageList.FindPage(FOffset.Y + Y, XOffSet);
  FDisableUpdate := True;
  Preview.PageNo := PageNo + 1;
  FDisableUpdate := False;

  if not FIsThumbnail and (Button <> mbRight) then
  begin
    PageBounds := FPageList.GetPageBounds(PageNo, ClientWidth, Zoom, FRTLLanguage);
    if (GetTickCount - FTimeOffset <= GetDoubleClickTime) then
    begin
      FTimeOffset := 0;
      PreviewPages.ObjectOver(PageNo, X, Y, Button, Shift, Zoom,
      PageBounds.Left - FOffset.X, PageBounds.Top - FOffset.Y, True, Cur, True);
    end
    else
    begin
      FTimeOffset := GetTickCount;
      PreviewPages.ObjectOver(PageNo, X, Y, Button, Shift, Zoom,
      PageBounds.Left - FOffset.X, PageBounds.Top - FOffset.Y, True, Cur);
    end;
  end;
end;

procedure TfrxPreviewWorkspace.FindText;
var
  EMFCanvas: TMetafileCanvas;
  PageBounds, TxtBounds: TRect;
begin
  TextFound := False;

  while FLastFoundPage < FPageList.Count do
  begin
    if (FEMFImage = nil) or (FEMFImagePage <> FLastFoundPage) then
    begin
      if FEMFImage <> nil then
        FEMFImage.Free;
      FEMFImage := TMetafile.Create;
      EMFCanvas := TMetafileCanvas.Create(FEMFImage, 0);
      {$IFDEF FPC}
      EMFCanvas.FCreateOnlyText := True;
      {$ENDIF}
      PreviewPages.DrawPage(FLastFoundPage, EMFCanvas, 1, 1, 0, 0);
      EMFCanvas.Free;
    end;

    FEMFImagePage := FLastFoundPage;
    RecordNo := 0;
    {$IFDEF FPC}
    FindInLmf(FEMFImage, Rect(0, 0, 0, 0));
    {$ELSE}
    EnumEnhMetafile(0, FEMFImage.Handle, @EnumEMFRecordsProc, nil, Rect(0, 0, 0, 0));
    {$ENDIF}

    if TextFound then
    begin
      PageBounds := FPageList.GetPageBounds(FLastFoundPage, ClientWidth, Zoom, FRTLLanguage);
      TxtBounds := Rect(Round(TextBounds.Left * Zoom),
        Round(TextBounds.Top * Zoom),
        Round(TextBounds.Right * Zoom),
        Round(TextBounds.Bottom * Zoom));

      if (PageBounds.Top + TxtBounds.Top < FOffset.Y) or
        (PageBounds.Top + TxtBounds.Bottom > FOffset.Y + ClientHeight) then
        VertPosition := PageBounds.Top + TxtBounds.Bottom - ClientHeight + 20;
      if (PageBounds.Left + TxtBounds.Left < FOffset.X) or
        (PageBounds.Left + TxtBounds.Right > FOffset.X + ClientWidth) then
        HorzPosition := PageBounds.Left + TxtBounds.Right - ClientWidth + 20;
      Repaint;
      break;
    end;

    LastFoundRecord := -1;
    Inc(FLastFoundPage);
  end;
  if not TextFound then ShowMessage(frxResources.Get('clStrNotFound'));
end;

procedure TfrxPreviewWorkspace.Resize;
begin
  inherited;
  HorzPage := ClientWidth;
  VertPage := ClientHeight;
end;

procedure TfrxPreviewWorkspace.SetToPageNo(PageNo: Integer);
begin
  if FDisableUpdate then Exit;
  VertPosition :=
    FPageList.GetPageBounds(PageNo - 1, ClientWidth, Zoom, FRTLLanguage).Top - 10;
end;

procedure TfrxPreviewWorkspace.UpdateScrollBars;
var
  MaxSize: TPoint;
begin
  MaxSize := FPageList.GetMaxBounds;
  HorzRange := MaxSize.X + 10;
  VertRange := MaxSize.Y + 10;
end;

procedure TfrxPreviewWorkspace.SetPosition(PageN, Top: Integer);
var
  Pos: Integer;
  Page: TfrxReportPage;
begin
  Page := PreviewPages.Page[PageN - 1];
  if Page = nil then
    exit;
  if Top = 0 then
    Pos := 0
  else
    Pos := Round((Top + Page.TopMargin * fr01cm) * Zoom);

  VertPosition := FPageList.GetPageBounds(PageN - 1, ClientWidth, Zoom, FRTLLanguage).Top - 10 + Pos;
end;

function TfrxPreviewWorkspace.GetTopPosition: Integer;
var
  Page: TfrxReportPage;
begin
  Result := 0;
  Page := PreviewPages.Page[Preview.PageNo - 1];
  if Page <> nil then
    Result := Round((VertPosition - FPageList.GetPageBounds(Preview.PageNo - 1,ClientWidth, Zoom, FRTLLanguage).Top + 10)/ Zoom - Page.TopMargin * fr01cm);
end;

procedure TfrxPreviewWorkspace.AddPage(AWidth, AHeight: Integer);
begin
  FPageList.AddPage(AWidth, AHeight, Zoom);
end;

procedure TfrxPreviewWorkspace.CalcPageBounds(ClientWidth: Integer);
begin
  FPageList.CalcBounds(ClientWidth);
end;

procedure TfrxPreviewWorkspace.ClearPageList;
begin
  FPageList.Clear;
end;


procedure TfrxPreviewWorkspace.PrevDblClick(Sender: TObject);
begin
  if not IsThumbnail and Assigned(FPreview.OnDblClick) then
    FPreview.OnDblClick(Sender);
end;

{ TfrxPreview }

constructor TfrxPreview.Create(AOwner: TComponent);
var
  m: TMenuItem;
begin
  inherited;

  FOutlinePopup := TPopupMenu.Create(Self);
  FOutlinePopup.Images := frxResources.PreviewButtonImages;
  m := TMenuItem.Create(FOutlinePopup);
  FOutlinePopup.Items.Add(m);
  m.Caption := frxGet(601);
  m.ImageIndex := 13;
  m.OnClick := OnCollapseClick;
  m := TMenuItem.Create(FOutlinePopup);
  FOutlinePopup.Items.Add(m);
  m.Caption := frxGet(600);
  m.ImageIndex := 14;
  m.OnClick := OnExpandClick;

  FOutline := TTreeView.Create(Self);
  with FOutline do
  begin
    Parent := Self;
    Align := alLeft;
    HideSelection := False;
{$IFDEF UseTabset}
    BorderStyle := bsNone;
    BevelKind := bkFlat;
{$ELSE}
    BorderStyle := bsSingle;
{$ENDIF}
    OnClick := OnOutlineClick;
    PopupMenu := FOutlinePopup;
  end;

  FThumbnail := TfrxPreviewWorkspace.Create(Self);
  FThumbnail.Parent := Self;
  FThumbnail.Align := alLeft;
  FThumbnail.Visible := False;
  FThumbnail.Zoom := 0.1;
  FThumbnail.IsThumbnail := True;
  FThumbnail.Preview := Self;

  FSplitter := TSplitter.Create(Self);
  FSplitter.Parent := Self;
  FSplitter.Align := alLeft;
  FSplitter.Width := 4;
  FSplitter.Left := FOutline.Width + 1;
  FSplitter.OnMoved := OnMoveSplitter;

  FWorkspace := TfrxPreviewWorkspace.Create(Self);
  FWorkspace.Parent := Self;
  FWorkspace.Align := alClient;
  FWorkspace.Preview := Self;

  FMessagePanel := TPanel.Create(Self);
  FMessagePanel.Parent := Self;
  FMessagePanel.Visible := False;
  FMessagePanel.SetBounds(0, 0, 0, 0);

  FMessageLabel := TLabel.Create(FMessagePanel);
  FMessageLabel.Parent := FMessagePanel;
  FMessageLabel.AutoSize := False;
  FMessageLabel.Alignment := taCenter;
  FMessageLabel.SetBounds(4, 20, 255, 20);

  FCancelButton := TButton.Create(FMessagePanel);
  FCancelButton.Parent := FMessagePanel;
  FCancelButton.SetBounds(92, 44, 75, 25);
  FCancelButton.Caption := frxResources.Get('clCancel');
  FCancelButton.Visible := False;
  FCancelButton.OnClick := OnCancel;
  {$IFNDEF FPC}
  FBorderStyle := bsSingle;
  {$ENDIF}
  FPageNo := 1;
  FScrollBars := ssBoth;
  FZoom := 1;
  FZoomMode := zmDefault;
  FOutlineColor := clWindow;
  UseReportHints := True;

  Width := 100;
  Height := 100;
end;

destructor TfrxPreview.Destroy;
begin
  if Report <> nil then
    Report.Preview := nil;
  inherited;
end;

procedure TfrxPreview.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    {$IFNDEF FPC}
    Style := Style or BorderStyles[FBorderStyle];
    {$ENDIF}
    if {$IFNDEF FPC}Ctl3D and {$ENDIF} NewStyleControls and (BorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

procedure TfrxPreview.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if AComponent = Report then
    begin
      Clear;
      Report := nil;
      PreviewPages := nil;
    end;
end;

procedure TfrxPreview.Init;
begin
  FWorkspace.PreviewPages := PreviewPages;
  FThumbnail.PreviewPages := PreviewPages;
  TextFound := False;
  FWorkspace.FLastFoundPage := 0;
  LastFoundRecord := -1;
  FAllowF3 := False;

  FWorkspace.DoubleBuffered := True;
  OutlineWidth := Report.PreviewOptions.OutlineWidth;
  OutlineVisible := Report.PreviewOptions.OutlineVisible;
  ThumbnailVisible := Report.PreviewOptions.ThumbnailVisible;
  FZoomMode := Report.PreviewOptions.ZoomMode;
  Fzoom := Report.PreviewOptions.Zoom;
 if not(Owner is TfrxPreviewForm) and UseRightToLeftAlignment then
    FlipChildren(True);
  UpdatePages;
  UpdateOutline;
  First;
end;

procedure TfrxPreview.WMEraseBackground(var Message: TMessage);
begin
end;

procedure TfrxPreview.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TfrxPreview.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = vk_Up then
    FWorkspace.VertPosition := FWorkspace.VertPosition - 8
  else if Key = vk_Down then
    FWorkspace.VertPosition := FWorkspace.VertPosition + 8
  else if Key = vk_Left then
    FWorkspace.HorzPosition := FWorkspace.HorzPosition - 8
  else if Key = vk_Right then
    FWorkspace.HorzPosition := FWorkspace.HorzPosition + 8
  else if Key = vk_Prior then
    if ssCtrl in Shift then
      PageNo := PageNo - 1
    else
      FWorkspace.VertPosition := FWorkspace.VertPosition - 300
  else if Key = vk_Next then
    if ssCtrl in Shift then
      PageNo := PageNo + 1
    else
      FWorkspace.VertPosition := FWorkspace.VertPosition + 300
  else if Key = vk_Home then
    PageNo := 1
  else if Key = vk_End then
    PageNo := PageCount
  else if (Key = vk_F3) and (pbFind in Report.PreviewOptions.Buttons) then
    FindNext
  else if ssCtrl in Shift then
  begin
    if (Key = Ord('P')) and (pbPrint in Report.PreviewOptions.Buttons) then
      Print
    else if (Key = Ord('S')) and (pbSave in Report.PreviewOptions.Buttons) then
      SaveToFile
    else if (Key = Ord('F')) and (pbFind in Report.PreviewOptions.Buttons) then
      Find
    else if (Key = Ord('O')) and (pbLoad in Report.PreviewOptions.Buttons) then
      LoadFromFile
  end;
end;

procedure TfrxPreview.Resize;
begin
  inherited;
  if PreviewPages <> nil then
    UpdatePages;
end;

procedure TfrxPreview.OnMoveSplitter(Sender: TObject);
begin
  UpdatePages;
end;

procedure TfrxPreview.OnCollapseClick(Sender: TObject);
begin
  FOutline.FullCollapse;
  FWorkspace.SetFocus;
end;

procedure TfrxPreview.OnExpandClick(Sender: TObject);
begin
  FOutline.FullExpand;
  if FOutline.Items.Count > 0 then
    FOutline.TopItem := FOutline.Items[0];
  FWorkspace.SetFocus;
end;

procedure TfrxPreview.SetZoom(const Value: Extended);
begin
  FZoom := Value;
  if FZoom < 0.25 then
    FZoom := 0.25;

  FZoomMode := zmDefault;
  UpdatePages;
end;

procedure TfrxPreview.SetZoomMode(const Value: TfrxZoomMode);
begin
  FZoomMode := Value;
  UpdatePages;
end;

function TfrxPreview.GetOutlineVisible: Boolean;
begin
  Result := FOutline.Visible;
end;

procedure TfrxPreview.SetOutlineVisible(const Value: Boolean);
var
  NeedChange: Boolean;
begin
  NeedChange := Value <> FOutline.Visible;

  FSplitter.Visible := Value or ThumbnailVisible;
  FOutline.Visible := Value;

  if UseRightToLeftAlignment then
      FOutline.Left := Width;

  if Value then
    FThumbnail.Visible := False;

  if Owner is TfrxPreviewForm then
    TfrxPreviewForm(Owner).OutlineB.Down := Value;
  if NeedChange then
    UpdatePages;
end;

function TfrxPreview.GetThumbnailVisible: Boolean;
begin
  Result := FThumbnail.Visible;
end;

procedure TfrxPreview.SetThumbnailVisible(const Value: Boolean);
var
  NeedChange: Boolean;
begin
  NeedChange := Value <> FThumbnail.Visible;

  FSplitter.Visible := Value or OutlineVisible;
  FThumbnail.Visible := Value;
  
  if UseRightToLeftAlignment then
    FThumbnail.Left := Width;

  if Value then
    FOutline.Visible := False;

  if Value then
  begin
    FThumbnail.HorzPosition := FThumbnail.HorzPosition;
    FThumbnail.VertPosition := FThumbnail.VertPosition;
  end;
  if Owner is TfrxPreviewForm then
    TfrxPreviewForm(Owner).ThumbB.Down := Value;
  if NeedChange then
    UpdatePages;
end;

function TfrxPreview.GetOutlineWidth: Integer;
begin
  Result := FOutline.Width;
end;

procedure TfrxPreview.SetOutlineWidth(const Value: Integer);
begin
  FOutline.Width := Value;
  if not (csDesigning in ComponentState) then
    FThumbnail.Width := Value;
end;

procedure TfrxPreview.SetOutlineColor(const Value: TColor);
begin
  FOutlineColor := Value;
  FOutline.Color := Value;
end;

procedure TfrxPreview.SetPageNo(Value: Integer);
var
  ActivePageChanged: Boolean;
begin
  if Value < 1 then
    Value := 1;
  if Value > PageCount then
    Value := PageCount;
  ActivePageChanged := FPageNo <> Value;
  FPageNo := Value;
  FWorkspace.PageNo := Value;
  FThumbnail.PageNo := Value;

  if ActivePageChanged then
  begin
    FWorkspace.DrawPages(True);
    FThumbnail.DrawPages(True);
  end;
  FWorkspace.SetToPageNo(FPageNo);
  FThumbnail.SetToPageNo(FPageNo);
  UpdatePageNumbers;
end;

function TfrxPreview.GetActiveFrameColor: TColor;
begin
  Result := FWorkspace.ActiveFrameColor;
end;

function TfrxPreview.GetBackColor: TColor;
begin
  Result := FWorkspace.BackColor;
end;

function TfrxPreview.GetFrameColor: TColor;
begin
  Result := FWorkspace.FrameColor;
end;

procedure TfrxPreview.SetActiveFrameColor(const Value: TColor);
begin
  FWorkspace.ActiveFrameColor := Value;
end;

procedure TfrxPreview.SetBackColor(const Value: TColor);
begin
  FWorkspace.BackColor := Value;
end;

procedure TfrxPreview.SetFrameColor(const Value: TColor);
begin
  FWorkspace.FrameColor := Value;
end;

{$IFNDEF FPC}
procedure TfrxPreview.SetBorderStyle(Value: TBorderStyle);
begin
  if BorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;
{$ENDIF}

procedure TfrxPreview.UpdatePageNumbers;
begin
  if Assigned(FOnPageChanged) then
    FOnPageChanged(Self, FPageNo);
end;

function TfrxPreview.GetPageCount: Integer;
begin
  if PreviewPages <> nil then
    Result := PreviewPages.Count
  else
    Result := 0;
end;

function TfrxPreview.GetOnMouseDown: TMouseEvent;
begin
  Result := FWorkspace.OnMouseDown;
end;

procedure TfrxPreview.SetOnMouseDown(const Value: TMouseEvent);
begin
  FWorkspace.OnMouseDown := Value; 
end;

{$IFDEF FR_COM}
function TfrxPreview.ShowMessage(const s: WideString): HResult;
{$ELSE}
procedure TfrxPreview.ShowMessage(const s: String);
{$ENDIF}
begin
  FMessagePanel.SetBounds((Width - 260) div 2, (Height - 75) div 3, 260, 75);
  FMessageLabel.Caption := s;
  FMessagePanel.Show;
  FMessagePanel.Update;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.HideMessage: HResult;
{$ELSE}
procedure TfrxPreview.HideMessage;
{$ENDIF}
begin
  FMessagePanel.Hide;
  FCancelButton.Hide;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.First: HResult;
{$ELSE}
procedure TfrxPreview.First;
{$ENDIF}
begin
  PageNo := 1;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.Next: HResult;
{$ELSE}
procedure TfrxPreview.Next;
{$ENDIF}
begin
  PageNo := PageNo + 1;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.Prior: HResult;
{$ELSE}
procedure TfrxPreview.Prior;
{$ENDIF}
begin
  PageNo := PageNo - 1;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.Last: HResult;
{$ELSE}
procedure TfrxPreview.Last;
{$ENDIF}
begin
  PageNo := PageCount;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.Print: HResult;
begin
  if not FRunning then
  begin
    try
      PreviewPages.CurPreviewPage := PageNo;
      PreviewPages.Print;
      Result := S_OK;
    except
      Result := E_FAIL;
    end;
    Unlock;
  end else
    Result := RPC_E_SERVERCALL_RETRYLATER;
end;
{$ELSE}
procedure TfrxPreview.Print;
begin
  if FRunning then Exit;
  try
    PreviewPages.CurPreviewPage := PageNo;
    PreviewPages.Print;
  finally
    Unlock;
  end;
end;
{$ENDIF}

procedure TfrxPreview.SaveToFile;
var
  SaveDlg: TSaveDialog;
begin
  if FRunning then Exit;
  SaveDlg := TSaveDialog.Create(Application);
  try
    SaveDlg.Options := SaveDlg.Options + [ofNoChangeDir];
    SaveDlg.Filter := frxResources.Get('clFP3files') + ' (*.fp3)|*.fp3';
    if SaveDlg.Execute then
    begin
      FWorkspace.Repaint;
      SaveToFile(ChangeFileExt(SaveDlg.FileName, '.fp3'));
    end;
  finally
    SaveDlg.Free;
  end;
end;

procedure TfrxPreview.SaveToFile(FileName: String);
begin
  if FRunning then Exit;
  try
    Lock;
    ShowMessage(frxResources.Get('clSaving'));
    PreviewPages.SaveToFile(FileName);
  finally
    Unlock;
  end;
end;

procedure TfrxPreview.LoadFromFile;
var
  OpenDlg: TOpenDialog;
begin
  if FRunning then Exit;
  OpenDlg := TOpenDialog.Create(nil);
  try
    OpenDlg.Options := [ofHideReadOnly, ofNoChangeDir];
    OpenDlg.Filter := frxResources.Get('clFP3files') + ' (*.fp3)|*.fp3';
    if OpenDlg.Execute then
    begin
      FWorkspace.Repaint;
      LoadFromFile(OpenDlg.FileName);
    end;
  finally
    OpenDlg.Free;
  end;
end;

procedure TfrxPreview.LoadFromFile(FileName: String);
begin
  if FRunning then Exit;
  try
    Lock;
    ShowMessage(frxResources.Get('clLoading'));
    PreviewPages.LoadFromFile(FileName);
  finally
    PageNo := 1;
    UpdateOutline;
    Unlock;
  end;
end;

procedure TfrxPreview.Export(Filter: TfrxCustomExportFilter);
begin
  if FRunning then Exit;
  try
    PreviewPages.CurPreviewPage := PageNo;
    if Report.DotMatrixReport and (frxDotMatrixExport <> nil) and
      (Filter.ClassName = 'TfrxTextExport') then
      Filter := frxDotMatrixExport;
    PreviewPages.Export(Filter);
  finally
    Unlock;
  end;
end;

function TfrxPreview.FindText(SearchString: String; FromTop, IsCaseSensitive: Boolean): Boolean;
begin
  TextToFind := SearchString;
  CaseSensitive := IsCaseSensitive;
  if FromTop then
    FWorkspace.FLastFoundPage := 0 
  else
    FWorkspace.FLastFoundPage := PageNo - 1;
  LastFoundRecord := -1;

  FWorkspace.FindText;

  FAllowF3 := True;
  Result := TextFound;
end;

function TfrxPreview.FindTextFound: Boolean;
begin
  Result := TextFound;
end;

procedure TfrxPreview.FindTextClear;
begin
  LastFoundRecord := -1;
  FWorkspace.FLastFoundPage := 0; 
  TextFound := False;
  Invalidate;
end;

{$IFDEF FR_COM}
function TfrxPreview.PageSetupDlg: HResult;
{$ELSE}
procedure TfrxPreview.PageSetupDlg;
{$ENDIF}
var
  APage: TfrxReportPage;

  procedure UpdateReport;
  var
    i: Integer;
  begin
    for i := 0 to Report.PagesCount - 1 do
      if Report.Pages[i] is TfrxReportPage then
        with TfrxReportPage(Report.Pages[i]) do
        begin
          Orientation := APage.Orientation;
          PaperWidth := APage.PaperWidth;
          PaperHeight := APage.PaperHeight;
          PaperSize := APage.PaperSize;

          LeftMargin := APage.LeftMargin;
          RightMargin := APage.RightMargin;
          TopMargin := APage.TopMargin;
          BottomMargin := APage.BottomMargin;
        end;
  end;

begin
{$IFDEF FR_COM}
  if FRunning then Result := RPC_E_SERVERCALL_RETRYLATER else
  begin
{$ELSE}
  if FRunning then Exit;
{$ENDIF}
  APage := PreviewPages.Page[PageNo - 1];

  if Assigned(APage) then with TfrxPageSettingsForm.Create(Application) do
  begin
    Page := APage;
    Report := Self.Report;
    if ShowModal = mrOk then
    begin
      if NeedRebuild then
      begin
        UpdateReport;
        Self.Report.PrepareReport;
      end
      else
      begin
        try
          Lock;
          PreviewPages.ModifyPage(PageNo - 1, Page);
        finally
          Unlock;
        end;
      end;
    end;
    Free;
  end;
{$IFDEF FR_COM}
  Result := S_OK;
  end;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.Find: HResult;
{$ELSE}
procedure TfrxPreview.Find;
{$ENDIF}
begin
  with TfrxSearchDialog.Create(Application) do
  begin
    if ShowModal = mrOk then
    begin
      TextToFind := TextE.Text;
      CaseSensitive := CaseCB.Checked;
      if TopCB.Checked then
        FWorkspace.FLastFoundPage := 0
      else
        FWorkspace.FLastFoundPage := PageNo - 1;
      LastFoundRecord := -1;
      FWorkspace.FindText;
    end;
    Free;
  end;

  FAllowF3 := True;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.FindNext: HResult;
{$ELSE}
procedure TfrxPreview.FindNext;
{$ENDIF}
begin
  if FAllowF3 then
    FWorkspace.FindText;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.Edit: HResult;
{$ELSE}
procedure TfrxPreview.Edit;
{$ENDIF}
var
  r: TfrxReport;
  p: TfrxReportPage;
  SourcePage: TfrxPage;

  procedure RemoveBands;
  var
    i: Integer;
    l: TList;
    c: TfrxComponent;
  begin
    l := p.AllObjects;

    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if c is TfrxView then
      begin
        TfrxView(c).DataField := '';
        TfrxView(c).DataSet := nil;
        TfrxView(c).Restrictions := [];
      end;

      if c.Parent <> p then
      begin
        c.Left := c.AbsLeft;
        c.Top := c.AbsTop;
        c.ParentFont := False;
        c.Parent := p;
        if (c is TfrxView) and (TfrxView(c).Align in [baBottom, baClient]) then
          TfrxView(c).Align := baNone;
      end;
    end;

    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if c is TfrxBand then
        c.Free;
    end;
  end;

begin
  SourcePage := PreviewPages.Page[PageNo - 1];
  r := nil;
  if Assigned(SourcePage) then
  try

    if SourcePage is TfrxDMPPage then
      p := TfrxDMPPage.Create(nil) else
      p := TfrxReportPage.Create(nil);
    r := TfrxReport.Create(nil);
    p.AssignAll(SourcePage);
    p.Parent := r;
    RemoveBands;
    if r.DesignPreviewPage then
      try
        Lock;
        PreviewPages.ModifyPage(PageNo - 1, TfrxReportPage(r.Pages[0]));
      finally
        Unlock;
      end;
  except
  end;
  if r <> nil then
    r.Free;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

procedure TfrxPreview.EditTemplate;
var
  r: TfrxReport;
  i: Integer;
begin
  r := TfrxReport.Create(nil);
  try
    for i := 0 to TfrxPreviewPages(PreviewPages).SourcePages.Count - 1 do
      r.Objects.Add(TfrxPreviewPages(PreviewPages).SourcePages[i]);
    r.DesignReport;
  finally
    r.Objects.Clear;
    r.Free;
  end;
end;

{$IFDEF FR_COM}
function TfrxPreview.Clear: HResult;
begin
  if FRunning then Result := RPC_E_SERVERCALL_RETRYLATER else
  begin
{$ELSE}
procedure TfrxPreview.Clear;
begin
  if FRunning then Exit;
{$ENDIF}
  Lock;
  try
    PreviewPages.Clear;
  finally
    Unlock;
  end;

  FWorkspace.ClearPageList;
  FThumbnail.ClearPageList;
  UpdateOutline;
  PageNo := 1;
  with FWorkspace do
  begin
    HorzRange := 0;
    VertRange := 0;
  end;
  if ThumbnailVisible then
  with FThumbnail do
  begin
    HorzRange := 0;
    VertRange := 0;
  end;
{$IFDEF FR_COM}
  Result := S_OK;
  end;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.AddPage: HResult;
begin
  if FRunning then  Result := RPC_E_SERVERCALL_RETRYLATER else
  begin
{$ELSE}
procedure TfrxPreview.AddPage;
begin
  if FRunning then Exit;
{$ENDIF}
  PreviewPages.AddEmptyPage(PageNo - 1);
  UpdatePages;
  PageNo := PageNo;
{$IFDEF FR_COM}
  Result := S_OK;
  end;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.DeletePage: HResult;
begin
  if FRunning then  Result := RPC_E_SERVERCALL_RETRYLATER else
  begin
{$ELSE}
procedure TfrxPreview.DeletePage;
begin
  if FRunning then Exit;
{$ENDIF}
  PreviewPages.DeletePage(PageNo - 1);
  if PageNo >= PageCount then
    PageNo := PageNo - 1;
  UpdatePages;
  UpdatePageNumbers;
{$IFDEF FR_COM}
  Result := S_OK;
  end;
{$ENDIF}
end;

procedure TfrxPreview.Lock;
begin
  FLocked := True;
  FWorkspace.Locked := True;
  FThumbnail.Locked := True;
end;

procedure TfrxPreview.Unlock;
begin
  HideMessage;
  FLocked := False;
  FWorkspace.Locked := False;
  FThumbnail.Locked := False;
  UpdatePages;
  FWorkspace.Repaint;
  FThumbnail.Repaint;
end;

{$IFDEF FR_COM}
function TfrxPreview.SetPosition(PageN, Top: Integer): HResult;
{$ELSE}
procedure TfrxPreview.SetPosition(PageN, Top: Integer);
{$ENDIF}
begin
  if PageN > PageCount then
    PageN := PageCount;
  if PageN <= 0 then
    PageN := 1;
  FWorkspace.SetPosition(PageN, Top);
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

function  TfrxPreview.GetTopPosition: Integer;
begin
  Result := FWorkspace.GetTopPosition;
end;

procedure TfrxPreview.RefreshReport;
var
  hpos, vpos, pno: Integer;
begin
  if not Assigned(Report) then exit;
  
  hpos := FWorkspace.FOffset.X;
  vpos := FWorkspace.FOffset.Y;
  pno := FPageNo;

  Lock;
  FRefreshing := True;
  try
    Report.PrepareReport;
    FLocked := False;
    FThumbnail.Locked := False;
    if pno <= PageCount then
      FPageNo := pno
    else
      FPageNo := 1;
    UpdatePages;
    UpdateOutline;
  finally
    FRefreshing := False;
  end;

  FWorkspace.FOffset.X := hpos;
  FWorkspace.FOffset.Y := vpos;
  FWorkspace.Locked := False;
  FWorkspace.Repaint;
  FThumbnail.Repaint;
  if pno > PageCount then
    PageNo := 1;
end;

procedure TfrxPreview.UpdatePages;
var
  PageSize: TPoint;
  i: Integer;
begin
  if FLocked or (PageCount = 0) then Exit;

  { clear find settings }
  FAllowF3 := False;
  FWorkspace.FEMFImagePage := -1;

  { calc zoom if not zmDefault}
  PageSize := PreviewPages.PageSize[PageNo - 1];
  if PageSize.Y = 0 then Exit;
  case FZoomMode of
    zmWholePage:
      begin
        if PageSize.Y/ClientHeight < PageSize.X/ClientWidth then
          FZoom := (FWorkspace.Width - GetSystemMetrics(SM_CXVSCROLL) - 26) / PageSize.X
        else
          FZoom := (FWorkspace.Height - 26) / PageSize.Y;
        SetPosition(PageNo, 0);
      end;
    zmPageWidth:
      FZoom := (FWorkspace.Width - GetSystemMetrics(SM_CXVSCROLL) - 26) / PageSize.X
  end;

  FThumbnail.DoubleBuffered := True;
  { fill page list and calc bounds }
  FWorkspace.Zoom := FZoom;
  FThumbnail.Zoom := 0.1;
  FWorkspace.ClearPageList;
  FThumbnail.ClearPageList;
  for i := 0 to PageCount - 1 do
  begin
    PageSize := PreviewPages.PageSize[i];
    FWorkspace.AddPage(PageSize.X, PageSize.Y);
    if not FRunning then
      FThumbnail.AddPage(PageSize.X, PageSize.Y);
  end;

  FWorkspace.CalcPageBounds(FWorkspace.Width - GetSystemMetrics(SM_CXVSCROLL) - 26);
  if not FRunning then
    FThumbnail.CalcPageBounds(FThumbnail.Width - GetSystemMetrics(SM_CXVSCROLL) - 26);

  FWorkspace.UpdateScrollBars;
  FThumbnail.UpdateScrollBars;
  { avoid positioning errors when resizing }
  FWorkspace.HorzPosition := FWorkspace.HorzPosition;
  FWorkspace.VertPosition := FWorkspace.VertPosition;

  if not FRefreshing then
  begin
    FWorkspace.Repaint;
    FThumbnail.Repaint;
  end;

  if Owner is TfrxPreviewForm then
    TfrxPreviewForm(Owner).UpdateZoom;
  FThumbnail.DoubleBuffered := False;
end;

procedure TfrxPreview.UpdateOutline;
var
  Outline: TfrxCustomOutline;

  procedure DoUpdate(RootNode: TTreeNode);
  var
    i, n: Integer;
    Node: TTreeNode;
    Page, Top: Integer;
    Text: String;
  begin
    n := Outline.Count;
    for i := 0 to n - 1 do
    begin
      Outline.GetItem(i, Text, Page, Top);
      Node := FOutline.Items.AddChild(RootNode, Text);
      Node.ImageIndex := Page + 1;
      Node.StateIndex := Top;

      Outline.LevelDown(i);
      DoUpdate(Node);
      Outline.LevelUp;
    end;
  end;

begin
  FOutline.Items.BeginUpdate;
  FOutline.Items.Clear;
  Outline := Report.PreviewPages.Outline;
  Outline.LevelRoot;
  DoUpdate(nil);
  if Report.PreviewOptions.OutlineExpand then
    FOutline.FullExpand;
  if FOutline.Items.Count > 0 then
    FOutline.TopItem := FOutline.Items[0];
  FOutline.Items.EndUpdate;
end;

procedure TfrxPreview.OnOutlineClick(Sender: TObject);
var
  Node: TTreeNode;
  PageN, Top: Integer;
begin
  Node := FOutline.Selected;
  if Node = nil then Exit;

  PageN := Node.ImageIndex;
  Top := Node.StateIndex;

  SetPosition(PageN, Top);
  SetFocus;
end;

procedure TfrxPreview.InternalOnProgressStart(Sender: TfrxReport;
  ProgressType: TfrxProgressType; Progress: Integer);
begin
  if FRefreshing then Exit;

  Clear;
  Report.DrillState.Clear;
  FRunning := True;
  if Owner is TfrxPreviewForm then
    TfrxPreviewForm(Owner).UpdateControls;
end;

procedure TfrxPreview.InternalOnProgress(Sender: TfrxReport;
  ProgressType: TfrxProgressType; Progress: Integer);
var
  PageSize: TPoint;
begin
  if FRefreshing then
  begin
    UpdatePageNumbers;
    Exit;
  end;

  if Report.Engine.FinalPass then
  begin
    PageSize := Report.PreviewPages.PageSize[Progress];
    if Progress < 50 then
    begin
      FWorkspace.AddPage(PageSize.X, PageSize.Y);
      FWorkspace.CalcPageBounds(FWorkspace.Width - GetSystemMetrics(SM_CXVSCROLL) - 26);
    end;
  end;

  if Progress = 0 then
  begin
    PageNo := 1;
    if Report.Engine.FinalPass then
      UpdatePages;
    if Owner is TfrxPreviewForm then
      TfrxPreviewForm(Owner).CancelB.Caption := frxResources.Get('clCancel');
    FTick := GetTickCount;
  end
  else if Progress = 1 then
  begin
    FTick := GetTickCount - FTick;
    if FTick < 5 then
      FTick := 50
    else if FTick < 10 then
      FTick := 20
    else
      FTick := 5;
    PageNo := 1;
    if Report.Engine.FinalPass then
      UpdatePages;
  end
  else if Progress mod Integer(FTick) = 0 then
  begin
    UpdatePageNumbers;
    if Report.Engine.FinalPass then
      FWorkspace.UpdateScrollBars;
  end;

  Application.ProcessMessages;
end;

procedure TfrxPreview.InternalOnProgressStop(Sender: TfrxReport;
  ProgressType: TfrxProgressType; Progress: Integer);
begin
  if FRefreshing then Exit;

  FRunning := False;
  UpdatePageNumbers;
  FWorkspace.UpdateScrollBars;
  FThumbnail.UpdateScrollBars;
  UpdatePages;
  UpdateOutline;
  if Owner is TfrxPreviewForm then
  begin
    TfrxPreviewForm(Owner).CancelB.Caption := frxResources.Get('clClose');
    TfrxPreviewForm(Owner).StatusBar.Panels[1].Text := '';
    TfrxPreviewForm(Owner).UpdateControls;
  end;
end;

procedure TfrxPreview.OnCancel(Sender: TObject);
begin
  Report.Terminated := True;
end;

{$IFDEF FR_COM}
function TfrxPreview.Cancel: HResult;
{$ELSE}
procedure TfrxPreview.Cancel;
{$ENDIF}
begin
  if FRunning then
    OnCancel(Self);
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.MouseWheelScroll(Delta: Integer; Horz: WordBool; Zoom: WordBool): HResult; stdcall;
{$ELSE}
procedure TfrxPreview.MouseWheelScroll(Delta: Integer; Horz: Boolean = False;
  Zoom: Boolean = False);
{$ENDIF}
begin
  if Delta <> 0 then
    if Zoom then
    begin
      FZoom := FZoom + Round(Delta / Abs(Delta)) / 10;
      if FZoom < 0.3 then
        FZoom := 0.3;
      SetZoom(FZoom);
    end
    else
    begin
      with FWorkspace do
      begin
        if Horz then
          HorzPosition := HorzPosition + Round(-Delta / Abs(Delta)) * 20
        else
          VertPosition := VertPosition + Round(-Delta / Abs(Delta)) * 20;
      end;
    end;
{$IFDEF FR_COM}
  Result := S_OK;
{$ENDIF}
end;

{$IFDEF FR_COM}
function TfrxPreview.LoadPreparedReportFromFile(const FileName: WideString): HResult; stdcall;
begin
  Result := S_OK;
  try
    LoadFromFile(FileName);
  except
    Result := E_INVALIDARG;
  end;
end;

function TfrxPreview.SavePreparedReportToFile(const FileName: WideString): HResult; stdcall;
begin
  Result := S_OK;
  try
    SaveToFile(FileName);
  except
    Result := E_INVALIDARG;
  end;
end;

function TfrxPreview.Get_FullScreen(out Value: WordBool): HResult; stdcall;
begin
  if Owner is TfrxPreviewForm then
  begin
    Value := TfrxPreviewForm(Owner).FFullScreen;
    Result := S_OK;
  end else Result := E_FAIL;
end;

function TfrxPreview.Set_FullScreen(Value: WordBool): HResult; stdcall;
begin
  if Owner is TfrxPreviewForm then
  begin
    if TfrxPreviewForm(Owner).FFullScreen <> Value then
      TfrxPreviewForm(Owner).SwitchToFullScreen;
    Result := S_OK;
  end
  else
    Result := E_FAIL;
end;

function TfrxPreview.Get_ToolBarVisible(out Value: WordBool): HResult; stdcall;
begin
  if Owner is TfrxPreviewForm then
  begin
    Value := TfrxPreviewForm(Owner).ToolBar.Visible;
    Result := S_OK;
  end
  else
    Result := E_FAIL;
end;

function TfrxPreview.Set_ToolBarVisible(Value: WordBool): HResult; stdcall;
begin
  if Owner is TfrxPreviewForm then
  begin
    TfrxPreviewForm(Owner).ToolBar.Visible := Value;
    Result := S_OK;
  end
  else
    Result := E_FAIL;
end;

function TfrxPreview.Get_StatusBarVisible(out Value: WordBool): HResult; stdcall;
begin
  if Owner is TfrxPreviewForm then
  begin
    Value := TfrxPreviewForm(Owner).StatusBar.Visible;
    Result := S_OK;
  end
  else
    Result := E_FAIL;
end;

function TfrxPreview.Set_StatusBarVisible(Value: WordBool): HResult; stdcall;
begin
  if Owner is TfrxPreviewForm then
  begin
    TfrxPreviewForm(Owner).StatusBar.Visible := Value;
    Result := S_OK;
  end
  else
    Result := E_FAIL;
end;


function TfrxPreview.Get_PageCount(out Value: Integer): HResult; stdcall;
begin
  Value := PageCount;
  Result := S_OK;
end;

function TfrxPreview.Get_PageNo(out Value: Integer): HResult; stdcall;
begin
  Value := PageNo;
  Result := S_OK;
end;

function TfrxPreview.Set_PageNo(Value: Integer): HResult; stdcall;
begin
  PageNo := Value;
  Result := S_OK;
end;

function TfrxPreview.Get_Tool(out Value: frxPreviewTool): HResult; stdcall;
begin
  Value := frxPreviewTool(Tool);
  Result := S_OK;
end;

function TfrxPreview.Set_Tool(Value: frxPreviewTool): HResult; stdcall;
begin
  Tool := TfrxPreviewTool(Value);
  Result := S_OK;
end;

function TfrxPreview.Get_Zoom(out Value: Double): HResult; stdcall;
begin
  Value := Zoom;
  Result := S_OK;
end;

function TfrxPreview.Set_Zoom(Value: Double): HResult; stdcall;
begin
  Zoom := Value;
  Result := S_OK;
end;

function TfrxPreview.Get_ZoomMode(out Value: frxZoomMode): HResult; stdcall;
begin
  Value := frxZoomMode(ZoomMode);
  Result := S_OK;
end;

function TfrxPreview.Set_ZoomMode(Value: frxZoomMode): HResult; stdcall;
begin
  ZoomMode := TfrxZoomMode(Value);
  Result := S_OK;
end;

function TfrxPreview.Get_OutlineVisible(out Value: WordBool): HResult; stdcall;
begin
  Value := OutlineVisible;
  Result := S_OK;
end;

function TfrxPreview.Set_OutlineVisible(Value: WordBool): HResult; stdcall;
begin
  OutlineVisible := Value;
  Result := S_OK;
end;

function TfrxPreview.Get_OutlineWidth(out Value: Integer): HResult; stdcall;
begin
  Value := OutlineWidth;
  Result := S_OK;
end;

function TfrxPreview.Set_OutlineWidth(Value: Integer): HResult; stdcall;
begin
  OutlineWidth := Value;
  Result := S_OK;
end;

function TfrxPreview.Get_Enabled(out Value: WordBool): HResult; stdcall;
begin
  Value := Enabled;
  Result := S_OK;
end;

function TfrxPreview.Set_Enabled(Value: WordBool): HResult; stdcall;
begin
  Enabled := Value;
  Result := S_OK;
end;
{$ENDIF}


{ TfrxPreviewForm }

procedure TfrxPreviewForm.FormCreate(Sender: TObject);
begin
{$IFDEF FR_COM}
  Icon.Handle := LoadIcon(hInstance, 'SDESGNICON');
{$ENDIF}
  {$IFNDEF FPC}
  FStatusBarOldWindowProc := StatusBar.WindowProc;
  StatusBar.WindowProc := StatusBarWndProc;
  {$ENDIF}
  Caption := frxGet(100);
  PrintB.Caption := frxGet(101);
  PrintB.Hint := frxGet(102);
  OpenB.Caption := frxGet(103);
  OpenB.Hint := frxGet(104);
  SaveB.Caption := frxGet(105);
  SaveB.Hint := frxGet(106);
  ExportB.Caption := frxGet(107);
  ExportB.Hint := frxGet(108);
  FindB.Caption := frxGet(109);
  FindB.Hint := frxGet(110);
  ZoomCB.Hint := frxGet(119);
  PageSettingsB.Caption := frxGet(120);
  PageSettingsB.Hint := frxGet(121);
  DesignerB.Caption := frxGet(132);
  DesignerB.Hint := frxGet(133);
  {$IFDEF FR_LITE}
    DesignerB.Hint := DesignerB.Hint + #13#10 + 'This feature is not available in FreeReport';
  {$ENDIF}
  FirstB.Caption := frxGet(134);
  FirstB.Hint := frxGet(135);
  PriorB.Caption := frxGet(136);
  PriorB.Hint := frxGet(137);
  NextB.Caption := frxGet(138);
  NextB.Hint := frxGet(139);
  LastB.Caption := frxGet(140);
  LastB.Hint := frxGet(141);
  CancelB.Caption := frxResources.Get('clClose');
  PageE.Hint := frxGet(142);
  FullScreenBtn.Hint := frxGet(150);
  PdfB.Hint := frxGet(151);
  EmailB.Hint := frxGet(152);
  ZoomPlusB.Caption := frxGet(124);
  ZoomPlusB.Hint := frxGet(125);
  ZoomMinusB.Caption := frxGet(126);
  ZoomMinusB.Hint := frxGet(127);
  OutlineB.Caption := frxGet(128);
  OutlineB.Hint := frxGet(129);
  ThumbB.Caption := frxGet(130);
  ThumbB.Hint := frxGet(131);
  ZoomCB.Items.Clear;
  ZoomCB.Items.Add('25%');
  ZoomCB.Items.Add('50%');
  ZoomCB.Items.Add('75%');
  ZoomCB.Items.Add('100%');
  ZoomCB.Items.Add('150%');
  ZoomCB.Items.Add('200%');
  ZoomCB.Items.Add(frxResources.Get('zmPageWidth'));
  ZoomCB.Items.Add(frxResources.Get('zmWholePage'));
  Toolbar.Images := frxResources.PreviewButtonImages;
  ExpandMI.Caption := frxGet(600);
  CollapseMI.Caption := frxGet(601);

  FPreview := TfrxPreview.Create(Self);
  FPreview.Parent := Self;
  FPreview.Align := alClient;
  FPreview.BorderStyle := bsNone;
  {$IFNDEF FPC}
  FPreview.BevelKind := bkNone;
  {$ENDIF}
  FPreview.OnPageChanged := OnPageChanged;
  FPreview.OnDblClick := OnPreviewDblClick;
  ActiveControl := FPreview;
  SetWindowLong(PageE.Handle, GWL_STYLE, GetWindowLong(PageE.Handle, GWL_STYLE)
    {$IFNDEF FPC}or ES_NUMBER{$ENDIF});
{$IFDEF Delphi10}
  frTBPanel1.ParentBackground := False;
  Sep3.ParentBackground := False;
  Sep4.ParentBackground := False;
{$ENDIF}

  if Screen.PixelsPerInch > 96 then
    StatusBar.Height := 24;

  FFullScreen := False;
  FPDFExport := nil;
  FEmailExport := nil;
end;

procedure TfrxPreviewForm.Init;
var
  i, j, k: Integer;
  m, e: TMenuItem;
begin
  FPreview.Init;
  with Report.PreviewOptions do
  begin
    if Maximized then
      WindowState := wsMaximized;
    if MDIChild then
      FormStyle := fsMDIChild;
    FPreview.Zoom := Zoom;
    FPreview.ZoomMode := ZoomMode;

    {$IFDEF FR_LITE}
      DesignerB.Enabled := False;
    {$ELSE}
      DesignerB.Enabled := AllowEdit;
    {$ENDIF}
    Preview.Workspace.RTLLanguage := RTLPreview;
    PrintB.Visible := pbPrint in Buttons;
    OpenB.Visible := pbLoad in Buttons;
    SaveB.Visible := pbSave in Buttons;
    ExportB.Visible := pbExport in Buttons;
    FindB.Visible := pbFind in Buttons;
    PdfB.Visible := False;
    EmailB.Visible := False;

    ZoomPlusB.Visible := pbZoom in Buttons;
    ZoomMinusB.Visible := pbZoom in Buttons;
    Sep3.Visible := pbZoom in Buttons;
    FullScreenBtn.Visible := (pbZoom in Buttons) and not (pbNoFullScreen in Buttons);
    if not (pbZoom in Buttons) then
      Sep1.Visible := False;

    OutlineB.Visible := pbOutline in Buttons;
    ThumbB.Visible := pbOutline in Buttons;
    PageSettingsB.Visible := pbPageSetup in Buttons;
    DesignerB.Visible := pbEdit in Buttons;
    if not (PageSettingsB.Visible or DesignerB.Visible) then
      Sep2.Visible := False;

    FirstB.Visible := pbNavigator in Buttons;
    PriorB.Visible := pbNavigator in Buttons;
    NextB.Visible := pbNavigator in Buttons;
    LastB.Visible := pbNavigator in Buttons;
    Sep4.Visible := pbNavigator in Buttons;
    if not (pbNavigator in Buttons) then
      Sep5.Visible := False;

    CancelB.Visible := not (pbNoClose in Buttons);

    Toolbar.ShowCaptions := ShowCaptions;
  end;

  if (frxExportFilters.Count = 0) or
     ((frxExportFilters.Count = 1) and (frxExportFilters[0].Filter = frxDotMatrixExport)) then
    ExportB.Visible := False;

  for i := 0 to frxExportFilters.Count - 1 do
  begin
    if frxExportFilters[i].Filter = frxDotMatrixExport then
      continue;
    m := TMenuItem.Create(ExportPopup);
    ExportPopup.Items.Add(m);
    m.Caption := TfrxCustomExportFilter(frxExportFilters[i].Filter).GetDescription + '...';
    m.Tag := i;
    m.OnClick := ExportMIClick;
    if TfrxCustomExportFilter(frxExportFilters[i].Filter).ClassName = 'TfrxPDFExport' then
    begin
      FPDFExport := TfrxCustomExportFilter(frxExportFilters[i].Filter);
      PdfB.Visible := pbExportQuick in Report.PreviewOptions.Buttons;
    end;
    if not (pbNoEmail in Report.PreviewOptions.Buttons) then
    begin
      if TfrxCustomExportFilter(frxExportFilters[i].Filter).ClassName = 'TfrxMailExport' then
      begin
        FEmailExport := TfrxCustomExportFilter(frxExportFilters[i].Filter);
        EmailB.Visible := pbExportQuick in Report.PreviewOptions.Buttons;
      end;
    end
    else EmailB.Visible := False; 
  end;

  if Report.ReportOptions.Name <> '' then
    Caption := Report.ReportOptions.Name;

  k := 0;

  RightMenu.Images := ToolBar.Images;
  for i := 0 to ToolBar.ButtonCount - 1 do
  begin
    if (ToolBar.Buttons[i].Style <> tbsCheck) and
       (ToolBar.Buttons[i].Visible) and
       (ToolBar.Buttons[i].Hint <> '') then
    begin
      m := TMenuItem.Create(RightMenu);
      RightMenu.Items.Add(m);
      ToolBar.Buttons[i].Tag := frxInteger(m);
      m.Caption := ToolBar.Buttons[i].Hint;
      m.OnClick := ToolBar.Buttons[i].OnClick;
      m.ImageIndex := ToolBar.Buttons[i].ImageIndex;
      if Assigned(ToolBar.Buttons[i].DropdownMenu) then
        for j := 0 to ToolBar.Buttons[i].DropdownMenu.Items.Count - 1 do
        begin
          e := TMenuItem.Create(m);
          e.Caption := ToolBar.Buttons[i].DropdownMenu.Items[j].Caption;
          e.Tag := ToolBar.Buttons[i].DropdownMenu.Items[j].Tag;
          e.OnClick := ToolBar.Buttons[i].DropdownMenu.Items[j].OnClick;
          m.Add(e);
        end;
    end;
    if ToolBar.Buttons[i].Style = tbsSeparator then
    begin
      if k = 1 then
        break;
      m := TMenuItem.Create(RightMenu);
      RightMenu.Items.Add(m);
      m.Caption := '-';
      Inc(k);
    end;
  end;

  if UseRightToLeftAlignment then
    FlipChildren(True);
    
  UpdateControls;
  PopupMenu := RightMenu;
end;

procedure TfrxPreviewForm.UpdateControls;

  function HasDrillDown: Boolean;
  var
    l: TList;
    i: Integer;
    c: TfrxComponent;
  begin
    Result := False;
    l := Report.AllObjects;
    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if (c is TfrxGroupHeader) and TfrxGroupHeader(c).DrillDown then
      begin
        Result := True;
        break;
      end;
    end;
  end;

  procedure EnableControls(cAr: array of TObject; Enabled: Boolean);
  var
    i: Integer;
  begin
    for i := 0 to High(cAr) do
    begin
      if cAr[i] is TMenuItem then
        TMenuItem(cAr[i]).Visible := Enabled
      else if cAr[i] is TToolButton then
      begin
        TToolButton(cAr[i]).Enabled := Enabled;
        TToolButton(cAr[i]).Down := False;
        {$IFDEF FPC}
        {$warning casting TMenuItem from Tag produces crash on 64bit}
        {$ELSE}
        if TToolButton(cAr[i]).Tag <> 0 then
          TMenuItem(TToolButton(cAr[i]).Tag).Enabled := Enabled;
        {$ENDIF}
      end;
    end;
  end;

begin
  EnableControls([PrintB, OpenB, SaveB, ExportB, PdfB, EmailB, FindB, PageSettingsB],
    (not FPreview.FRunning) and (FPreview.PageCount > 0));
  EnableControls([DesignerB],
    not FPreview.FRunning and Report.PreviewOptions.AllowEdit);
  EnableControls([ExpandMI, CollapseMI, N1],
    not FPreview.FRunning and HasDrillDown);
end;

procedure TfrxPreviewForm.PrintBClick(Sender: TObject);
begin
  FPreview.Print;
  Enabled := True;
end;

procedure TfrxPreviewForm.OpenBClick(Sender: TObject);
begin
  FPreview.LoadFromFile;
  if Report.ReportOptions.Name <> '' then
    Caption := Report.ReportOptions.Name
  else
    Caption := frxGet(100);
end;

procedure TfrxPreviewForm.SaveBClick(Sender: TObject);
begin
  FPreview.SaveToFile;
end;

procedure TfrxPreviewForm.FindBClick(Sender: TObject);
begin
  FPreview.Find;
end;

procedure TfrxPreviewForm.ZoomPlusBClick(Sender: TObject);
begin
  FPreview.Zoom := FPreview.Zoom + 0.25;
end;

procedure TfrxPreviewForm.ZoomMinusBClick(Sender: TObject);
begin
  FPreview.Zoom := FPreview.Zoom - 0.25;
end;

function TfrxPreviewForm.GetReport: TfrxReport;
begin
  Result := Preview.Report;
end;

procedure TfrxPreviewForm.UpdateZoom;
begin
  ZoomCB.Text := IntToStr(Round(FPreview.Zoom * 100)) + '%';
end;

procedure TfrxPreviewForm.ZoomCBClick(Sender: TObject);
var
  s: String;
begin
  FPreview.SetFocus;

  if ZoomCB.ItemIndex = 6 then
    FPreview.ZoomMode := zmPageWidth
  else if ZoomCB.ItemIndex = 7 then
    FPreview.ZoomMode := zmWholePage
  else
  begin
    s := ZoomCB.Text;

    if Pos('%', s) <> 0 then
      s[Pos('%', s)] := ' ';
    while Pos(' ', s) <> 0 do
      Delete(s, Pos(' ', s), 1);

    if s <> '' then
      FPreview.Zoom := frxStrToFloat(s) / 100;
  end;

  PostMessage(Handle, WM_UPDATEZOOM, 0, 0);
end;

procedure TfrxPreviewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    CancelBClick(Self);
  if Key = VK_F11 then
    SwitchToFullScreen;
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxPreviewForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if ActiveControl = ZoomCB then
      ZoomCBClick(nil);
    if ActiveControl = PageE then
      PageEClick(nil);
  end;
end;

procedure TfrxPreviewForm.WMUpdateZoom(var Message: TMessage);
begin
  UpdateZoom;
end;

procedure TfrxPreviewForm.PageSettingsBClick(Sender: TObject);
begin
  FPreview.PageSetupDlg;
end;

procedure TfrxPreviewForm.OnPageChanged(Sender: TfrxPreview; PageNo: Integer);
var
  FirstPass: Boolean;
begin
  FirstPass := False;
  if FPreview.PreviewPages <> nil then
    FirstPass := not FPreview.PreviewPages.Engine.FinalPass;

  if FirstPass and FPreview.FRunning then
    StatusBar.Panels[0].Text := frxResources.Get('clFirstPass') + ' ' +
      IntToStr(FPreview.PageCount)
  else
    StatusBar.Panels[0].Text := Format(frxResources.Get('clPageOf'),
      [PageNo, FPreview.PageCount]);
  PageE.Text := IntToStr(PageNo);
end;

procedure TfrxPreviewForm.PageEClick(Sender: TObject);
begin
  FPreview.PageNo := StrToInt(PageE.Text);
  FPreview.SetFocus;
end;

procedure TfrxPreviewForm.FirstBClick(Sender: TObject);
begin
  FPreview.First;
end;

procedure TfrxPreviewForm.PriorBClick(Sender: TObject);
begin
  FPreview.Prior;
end;

procedure TfrxPreviewForm.NextBClick(Sender: TObject);
begin
  FPreview.Next;
end;

procedure TfrxPreviewForm.LastBClick(Sender: TObject);
begin
  FPreview.Last;
end;

procedure TfrxPreviewForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  FPreview.MouseWheelScroll(WheelDelta, False, ssCtrl in Shift);
end;

procedure TfrxPreviewForm.DesignerBClick(Sender: TObject);
begin
  FPreview.Edit;
end;
procedure TfrxPreviewForm.DesignerBClick2(Sender: TObject);
begin
 ShowMessage('Ошибка.Нет прав для корректировки.')
end;

procedure TfrxPreviewForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not FPreview.FRunning;
end;

procedure TfrxPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FFreeOnClose then
    Action := caFree;
  if (Report <> nil) and (Assigned(Report.OnClosePreview)) then
    Report.OnClosePreview(Self);
end;

procedure TfrxPreviewForm.NewPageBClick(Sender: TObject);
begin
  FPreview.AddPage;
end;

procedure TfrxPreviewForm.DelPageBClick(Sender: TObject);
begin
  FPreview.DeletePage;
end;

procedure TfrxPreviewForm.CancelBClick(Sender: TObject);
begin
  if FPreview.FRunning then
    FPreview.Cancel else
    Close;
end;

procedure TfrxPreviewForm.ExportMIClick(Sender: TObject);
begin
  FPreview.Export(TfrxCustomExportFilter(frxExportFilters[TMenuItem(Sender).Tag].Filter));
  Enabled := True;
end;

procedure TfrxPreviewForm.DesignerBMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  pt := DesignerB.ClientToScreen(Point(0, 0));
  if Button = mbRight then
    HiddenMenu.Popup(pt.X, pt.Y);
end;

procedure TfrxPreviewForm.Showtemplate1Click(Sender: TObject);
begin
  FPreview.EditTemplate;
end;

procedure TfrxPreviewForm.SetMessageText(const Value: String; IsHint: Boolean);
begin
  if IsHint then
  begin
    if not ((Value = '') and (StatusBar.Panels[2].Text = '')) then
      StatusBar.Panels[2].Text := Value;
  end
  else
    StatusBar.Panels[1].Text := Value;
  Application.ProcessMessages;
end;

procedure TfrxPreviewForm.SwitchToFullScreen;
begin
  if not FFullScreen then
  begin
    StatusBar.Visible := False;
    ToolBar.Visible := False;
    FOldBS := BorderStyle;
    FOldState := WindowState;
    BorderStyle := bsNone;
    WindowState := {$IFDEF FPC}wsFullScreen {$ELSE}wsMaximized{$ENDIF};
    FFullScreen := True;
  end
  else
  begin
    WindowState := FOldState;
    BorderStyle := FOldBS;
    FFullScreen := False;
    StatusBar.Visible := True;
    ToolBar.Visible := True;
  end;
end;

procedure TfrxPreviewForm.FullScreenBtnClick(Sender: TObject);
begin
  SwitchToFullScreen;
end;

procedure TfrxPreviewForm.PdfBClick(Sender: TObject);
begin
  if Assigned(FPDFExport) then
    FPreview.Export(FPDFExport);
end;

procedure TfrxPreviewForm.EmailBClick(Sender: TObject);
begin
  if Assigned(FEmailExport) then
    FPreview.Export(FEmailExport);
end;

procedure TfrxPreviewForm.WMActivateApp(var Msg: TWMActivateApp);
begin
  {$IFDEF FPC}
  {$note FIXME TfrxPreviewForm.WMActivateApp}
  //if IsIconic(Application.MainForm.Handle) then
  begin
    // ShowWindow(Application.MainForm.Handle, SW_RESTORE);
    // SetActiveWindow(Handle);
  end;
  {$ELSE}
  if IsIconic(Application.Handle) then
  begin
    ShowWindow(Application.Handle, SW_RESTORE);
    SetActiveWindow(Handle);
  end;
  {$ENDIF}
  inherited;
end;

procedure TfrxPreviewForm.WMSysCommand(var Msg: TWMSysCommand);
begin
  {$IFNDEF FPC}
  if Msg.CmdType = SC_MINIMIZE then
    if not Report.PreviewOptions.MDIChild and Report.PreviewOptions.Modal  then
      ShowWindow(Application.Handle, SW_MINIMIZE)
    else
      inherited
  else
  {$ENDIF}
    inherited;
end;

procedure TfrxPreviewForm.StatusBarWndProc(var Message: TMessage);
begin
  {$IFNDEF FPC}
  if Message.Msg = WM_SYSCOLORCHANGE then
    DefWindowProc(StatusBar.Handle,Message.Msg,Message.WParam,Message.LParam)
  else
    FStatusBarOldWindowProc(Message);
  {$ENDIF}
end;

procedure TfrxPreviewForm.OutlineBClick(Sender: TObject);
begin
  FPreview.OutlineVisible := OutlineB.Down;
end;

procedure TfrxPreviewForm.ThumbBClick(Sender: TObject);
begin
  FPreview.ThumbnailVisible := ThumbB.Down;
end;

procedure TfrxPreviewForm.OnPreviewDblClick(Sender: TObject);
begin
  if FFullScreen then
    SwitchToFullScreen;
end;

procedure TfrxPreviewForm.CollapseAllClick(Sender: TObject);
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
begin
  FPreview.Lock;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if (c is TfrxGroupHeader) and TfrxGroupHeader(c).DrillDown then
      TfrxGroupHeader(c).ExpandDrillDown := False;
  end;
  Report.DrillState.Clear;
  Preview.RefreshReport;
  Preview.SetPosition(0,0);
end;

procedure TfrxPreviewForm.ExpandAllClick(Sender: TObject);
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
begin
  FPreview.Lock;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if (c is TfrxGroupHeader) and TfrxGroupHeader(c).DrillDown then
      TfrxGroupHeader(c).ExpandDrillDown := True;
  end;
  Report.DrillState.Clear;
  Preview.RefreshReport;
end;

procedure TfrxPreviewForm.FormResize(Sender: TObject);
var
  Sz: Integer;
begin
  Sz := Round((Self.ClientWidth  -   StatusBar.Panels[0].Width)/2);
  StatusBar.Panels[1].Width := Sz;
  StatusBar.Panels[2].Width := Sz;
end;

end.


//c867a8a91754a886c862cfc0bd9c73c8