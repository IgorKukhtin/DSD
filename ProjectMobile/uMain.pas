unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, FMX.TabControl, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.Rtti,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Grid, FMX.Objects, FMX.ExtCtrls, FMX.ListView.Types, FMX.ListView,
  System.Sensors, System.Sensors.Components, FMX.WebBrowser, FMX.Memo,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ScrollBox,
  FMX.Platform, FMX.TMSWebGMaps, System.Math.Vectors, FMX.TMSWebGMapsGeocoding,
  FMX.TMSWebGMapsCommon, FMX.TMSWebGMapsReverseGeocoding, FMX.ListBox,
  FMX.DateTimeCtrls, FMX.Controls3D, FMX.Layers3D, FMX.Menus, Generics.Collections,
  FMX.Gestures, System.Actions, FMX.ActnList, System.ImageList, FMX.ImgList,
  FMX.Grid.Style
  {$IFDEF ANDROID}
  ,FMX.Helpers.Android, Androidapi.Helpers,
  Androidapi.JNI.Location, Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes
  {$ENDIF};

const
  LatitudeRatio = '111.194926645';
  LongitudeRatio = '70.158308514';

type
  TOrderItemActionType = (otAdd, otDelete);

  TOrderItem = record
    GoodsName : string;
    Count : integer;
    ActionType : TOrderItemActionType;
    Price : currency;
  end;

  TFormStackItem = record
    PageIndex: Integer;
    Data: TObject;
  end;

  TfrmMain = class(TForm)
    tcMain: TTabControl;
    tiStart: TTabItem;
    LoginPanel: TPanel;
    LoginScaledLayout: TScaledLayout;
    Layout1: TLayout;
    LoginEdit: TEdit;
    Layout2: TLayout;
    Label2: TLabel;
    Layout3: TLayout;
    PasswordLabel: TLabel;
    Layout4: TLayout;
    PasswordEdit: TEdit;
    Layout5: TLayout;
    LogInButton: TButton;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    tiMain: TTabItem;
    WebServerLayout1: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout2: TLayout;
    WebServerEdit: TEdit;
    SyncLayout: TLayout;
    SyncCheckBox: TCheckBox;
    Layout21: TLayout;
    lButton1: TLayout;
    lButton2: TLayout;
    Layout23: TLayout;
    lButton5: TLayout;
    Layout22: TLayout;
    lButton3: TLayout;
    lButton4: TLayout;
    lButton6: TLayout;
    tiRoutes: TTabItem;
    VertScrollBox1: TVertScrollBox;
    tiPartners: TTabItem;
    pBack: TPanel;
    sbBack: TSpeedButton;
    Panel5: TPanel;
    lDayInfo: TLabel;
    lCaption: TLabel;
    blMain: TBindingsList;
    tiPartnerInfo: TTabItem;
    Panel7: TPanel;
    Memo1: TMemo;
    tiSync: TTabItem;
    imLogo: TImage;
    bSync: TButton;
    Image3: TImage;
    Label8: TLabel;
    bRelogin: TButton;
    Image4: TImage;
    Label9: TLabel;
    bReport: TButton;
    Image6: TImage;
    Label7: TLabel;
    bInfo: TButton;
    Image5: TImage;
    Label6: TLabel;
    bHandBook: TButton;
    Image1: TImage;
    Label1: TLabel;
    bVisit: TButton;
    Image2: TImage;
    Label5: TLabel;
    pMap: TPanel;
    WebGMapsReverseGeocoder: TTMSFMXWebGMapsReverseGeocoding;
    WebGMapsGeocoder: TTMSFMXWebGMapsGeocoding;
    vsbMain: TVertScrollBox;
    bMonday: TButton;
    bFriday: TButton;
    bThursday: TButton;
    bWednesday: TButton;
    bTuesday: TButton;
    bSaturday: TButton;
    bAllDays: TButton;
    bSunday: TButton;
    lMondayCount: TLabel;
    lAllDaysCount: TLabel;
    lFridayCount: TLabel;
    lSaturdayCount: TLabel;
    lSundayCount: TLabel;
    lThursdayCount: TLabel;
    lTuesdayCount: TLabel;
    lWednesdayCount: TLabel;
    Image7: TImage;
    tcPartnerInfo: TTabControl;
    tiInfo: TTabItem;
    tiDocuments: TTabItem;
    tiCredit: TTabItem;
    aiWait: TAniIndicator;
    sbPartnerMenu: TSpeedButton;
    Image8: TImage;
    ppPartner: TPopup;
    lbPartnerMenu: TListBox;
    ibiNewPartner: TListBoxItem;
    lbiSummery: TListBoxItem;
    lbiShowAllOnMap: TListBoxItem;
    lbiReports: TListBoxItem;
    tiMap: TTabItem;
    gmPartnerInfo: TGestureManager;
    acMain: TActionList;
    ChangePartnerInfoLeft: TChangeTabAction;
    ChangePartnerInfoRight: TChangeTabAction;
    ChangeMainPage: TChangeTabAction;
    tiHandbook: TTabItem;
    VertScrollBox2: TVertScrollBox;
    bPriceList: TButton;
    sbMain: TStyleBook;
    bRoute: TButton;
    bPartners: TButton;
    tiPriceList: TTabItem;
    lwPriceList: TListView;
    ilOrder: TImageList;
    bsPriceList: TBindSourceDB;
    LinkFillControlToField2: TLinkFillControlToField;
    Image9: TImage;
    tiPriceListItems: TTabItem;
    lwGoods: TListView;
    bsGoods: TBindSourceDB;
    pGoodsInfo: TPopup;
    Panel2: TPanel;
    lGoodsName: TLabel;
    Label10: TLabel;
    lGoodsCode: TLabel;
    lGoodsCategory: TLabel;
    Label13: TLabel;
    lGoodsGroup: TLabel;
    Label15: TLabel;
    lGoodsType: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    lGoodsWeight: TLabel;
    Label20: TLabel;
    lGoodsDateEnd: TLabel;
    Label22: TLabel;
    lGoodsPrice: TLabel;
    pPartnerActions: TPanel;
    bOrderExternal: TButton;
    bStartVisit: TButton;
    tiOrderExternal: TTabItem;
    VertScrollBox3: TVertScrollBox;
    sgOrderExternal: TStringGrid;
    gcName: TStringColumn;
    gcTotalPrice: TCurrencyColumn;
    gcButton: TGlyphColumn;
    tiOrderItems: TTabItem;
    gcCount: TCurrencyColumn;
    Panel3: TPanel;
    bCancelOI: TButton;
    bSaveOI: TButton;
    Panel4: TPanel;
    lwOrderItems: TListView;
    lwPartner: TListView;
    LinkListControlToField1: TLinkListControlToField;
    bsPartner: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    ilPartners: TImageList;
    BindSourceDB1: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    gcGoodsId: TStringColumn;
    gcKindId: TStringColumn;
    gcPrice: TStringColumn;
    Panel6: TPanel;
    lTotalPrice: TLabel;
    Panel8: TPanel;
    bSaveOrderExternal: TButton;
    procedure LogInButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bReloginClick(Sender: TObject);
    procedure bVisitClick(Sender: TObject);
    procedure sbBackClick(Sender: TObject);
    procedure lwPartnerItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure bMondayClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tcPartnerInfoChange(Sender: TObject);
    procedure sbPartnerMenuClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure lbiShowAllOnMapClick(Sender: TObject);
    procedure ChangePartnerInfoLeftUpdate(Sender: TObject);
    procedure ChangePartnerInfoRightUpdate(Sender: TObject);
    procedure ChangeMainPageUpdate(Sender: TObject);
    procedure bHandBookClick(Sender: TObject);
    procedure bRouteClick(Sender: TObject);
    procedure bPartnersClick(Sender: TObject);
    procedure bPriceListClick(Sender: TObject);
    procedure lwPriceListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwGoodsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bOrderExternalClick(Sender: TObject);
    procedure ImageColumn1Tap(Sender: TObject; const Point: TPointF);
    procedure sgOrderExternalSelectCell(Sender: TObject; const ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure lwOrderItemsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderItemsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bCancelOIClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure LinkFillControlToField2FilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure bSaveOIClick(Sender: TObject);
    procedure sgOrderExternalEditingDone(Sender: TObject; const ACol,
      ARow: Integer);
    procedure Action1Execute(Sender: TObject);
    procedure bSaveOrderExternalClick(Sender: TObject);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FMapLoaded: Boolean;
    FWebGMap: TTMSFMXWebGMaps;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    FCurCoordinatesSet : boolean;
    FCurCoordinates: TLocationCoord2D;

    FCheckedOI: TList<String>;

    procedure BackResult(const AResult: TModalResult);
    procedure ShowGoods(AValue : string);
    procedure ShowAddedRow;

    procedure UpdateKBBounds;
    procedure RestorePosition;
    function PrependIfNotEmpty(const Prefix, Subject: string): string;
    function GetAddress(const Latitude, Longitude: Double): string;
    //function GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
    procedure WebGMapDownloadFinish(Sender: TObject);
    procedure WebGMapAllPartnerDownloadFinish(Sender: TObject);
    procedure WebGMapMarkerDragEnd(Sender: TObject; MarkerTitle: string;
      IdMarker: Integer; Latitude, Longitude: Double);

    procedure Wait(AWait: Boolean);
    procedure CheckDataBase;
    procedure GetVistDays;
    procedure ShowPartners(Day : integer; Caption : string);
    procedure ShowPartnerInfo;
    procedure ShowAllPartnersOnMap;
    procedure ShowPriceLists;
    procedure ShowPriceListItems(PriceListId : integer);
    procedure RecalculateTotalPrice;
    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    function ReturnPriorForm(const OmitOnChange: Boolean = False): TObject;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uConstants, System.IOUtils, Authentication, Storage, CommonData, uDM, CursorUtils;

{$R *.fmx}
procedure TfrmMain.FormCreate(Sender: TObject);
var
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
  r : integer;
begin
  {$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetScreenOrientation(OrientSet);
  end;
  {$ENDIF}
  FFormsStack:= TStack<TFormStackItem>.Create;
  FCheckedOI := TList<String>.Create;
  FCurCoordinatesSet := false;
  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(tcMain);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FFormsStack.Free;
  FCheckedOI.Free;
end;

procedure TfrmMain.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfrmMain.lbiShowAllOnMapClick(Sender: TObject);
begin
  SwitchToForm(tiMap, nil);

  ppPartner.IsOpen := False;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  lButton1.Width := frmMain.Width div 2;
  lButton2.Width := frmMain.Width div 2;
  lButton3.Width := frmMain.Width div 2;
  lButton4.Width := frmMain.Width div 2;
  lButton5.Width := frmMain.Width div 2;
  lButton6.Width := frmMain.Width div 2;
end;

procedure TfrmMain.LinkFillControlToField2FilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  (AEditor.CurrentObject as TListViewItem).Tag := DM.qryPriceList.FieldByName('id').AsInteger;
end;

procedure TfrmMain.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  SwitchToForm(tiPartnerInfo, nil);
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  LoginOk : boolean;
begin
  LoginOk := false;

  if assigned(gc_User) then  { Проверяем только с данными из локальной БД }
  begin
    {$IFDEF NotCheckLogin}
    if (LoginEdit.Text = gc_User.Login) or (PasswordEdit.Text = gc_User.Password) then
    {$ELSE}
    if true then
    {$ENDIF}
    begin
      LoginOk := true;
    end
    else
    begin
      ShowMessage('Wrong login or password');
      exit;
    end;
  end;

  if (not LoginOk) or SyncCheckBox.IsChecked then
  begin
    Wait(True);

    try
      if gc_WebService = '' then
        gc_WebService := WebServerEdit.Text;

      ErrorMessage := TAuthentication.CheckLogin(TStorageFactory.GetStorage, LoginEdit.Text, PasswordEdit.Text, gc_User);

      if ErrorMessage = '' then
      begin
        ErrorMessage := DM.SynchronizeWithMainDatabase;

        Wait(False);

        if ErrorMessage = '' then
          LoginOk := true
        else
          ShowMessage(ErrorMessage);
      end
      else
      begin
        Wait(False);

        if LoginOk then
          ShowMessage('Ошибка синхронизации (' + ErrorMessage + '). Робота будет продолжена с локальными данными')
        else
          ShowMessage(ErrorMessage);
      end;
    except
    on E: Exception do
      begin
        Wait(False);
        ShowMessage(E.Message);
        exit;
      end;
    end;
  end;

  if LoginOk then
    SwitchToForm(tiMain, nil);
end;

procedure TfrmMain.lwGoodsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  lGoodsName.Text := DM.qryGoods.FieldByName('GoodsName').AsString;
  lGoodsCode.Text := DM.qryGoods.FieldByName('OBJECTCODE').AsString;
  lGoodsCategory.Text := '-';
  lGoodsGroup.Text := DM.qryGoods.FieldByName('GroupName').AsString;
  lGoodsType.Text := '-';
  lGoodsWeight.Text := DM.qryGoods.FieldByName('weight').AsString + ' ' + DM.qryGoods.FieldByName('MeasureName').AsString;
  lGoodsDateEnd.Text := DM.qryGoods.FieldByName('EndDate').AsString;
  lGoodsPrice.Text := DM.qryGoods.FieldByName('Price').AsString;

  pGoodsInfo.IsOpen := true;
end;

procedure TfrmMain.lwOrderItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwOrderItemsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if AItem.Objects.AccessoryObject.Visible then
  begin
    AItem.Objects.AccessoryObject.Visible := False;
    FCheckedOI.Remove(AItem.Detail);
  end
  else
  begin
    AItem.Objects.AccessoryObject.Visible := True;
    FCheckedOI.Add(AItem.Detail);
  end;
end;

procedure TfrmMain.lwOrderItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // In order for text to be truncated properly, shorten text object
  AItem.Objects.TextObject.Width := AItem.Objects.TextObject.Width - (5 + AItem.Objects.AccessoryObject.Width);
  // Restore checked state when device is rotated.
  // When listview is resized because of rotation, accessory properties will be reset to default values
  AItem.Objects.AccessoryObject.Visible := FCheckedOI.Contains(AItem.Detail);
end;

procedure TfrmMain.lwPartnerItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  SwitchToForm(tiPartnerInfo, nil);
end;

procedure TfrmMain.lwPriceListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  SwitchToForm(tiPriceListItems, nil);
end;

procedure TfrmMain.Action1Execute(Sender: TObject);
begin
 //
end;

procedure TfrmMain.BackResult(const AResult: TModalResult);
begin
  if AResult = mrYes then
    ReturnPriorForm;
end;

procedure TfrmMain.sbBackClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiOrderExternal then
    MessageDlg('Удалить эту заявку?',
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               BackResult)
  else
    ReturnPriorForm;
end;

procedure TfrmMain.sbPartnerMenuClick(Sender: TObject);
var
  FP: TPointF;
begin
  FP := sbPartnerMenu.LocalToAbsolute(FP);

  {with ppPartner.PlacementRectangle do
  begin
   Top := 10;
   Bottom := Top + ppPartner.Height;
   Left := FP.X - 190;
   Right := Left + ppPartner.Width;
  end;}
  ppPartner.IsOpen := true;
  lbPartnerMenu.ItemIndex := -1;
end;

procedure TfrmMain.ShowGoods(AValue : string);
var
  ArrValue : TArray<string>;
begin
  ArrValue := AValue.Split([';']);

  sgOrderExternal.Cells[0, sgOrderExternal.RowCount - 1] := ArrValue[0]; // GoodsId
  sgOrderExternal.Cells[1, sgOrderExternal.RowCount - 1] := ArrValue[1]; // KindId
  sgOrderExternal.Cells[2, sgOrderExternal.RowCount - 1] := ArrValue[3]; // цена
  sgOrderExternal.Cells[3, sgOrderExternal.RowCount - 1] := ArrValue[2]; // название товара
  sgOrderExternal.Cells[4, sgOrderExternal.RowCount - 1] := '1'; // количество по умолчанию
  sgOrderExternal.Cells[5, sgOrderExternal.RowCount - 1] := ArrValue[3]; // общая цена
  sgOrderExternal.Cells[6, sgOrderExternal.RowCount - 1] := '1'; // кнопка удалить
end;

procedure TfrmMain.ShowAddedRow;
begin
  sgOrderExternal.Cells[0, sgOrderExternal.RowCount - 1] := '';
  sgOrderExternal.Cells[1, sgOrderExternal.RowCount - 1] := '';
  sgOrderExternal.Cells[2, sgOrderExternal.RowCount - 1] := '';
  sgOrderExternal.Cells[3, sgOrderExternal.RowCount - 1] := '';
  sgOrderExternal.Cells[4, sgOrderExternal.RowCount - 1] := '';
  sgOrderExternal.Cells[5, sgOrderExternal.RowCount - 1] := '';
  sgOrderExternal.Cells[6, sgOrderExternal.RowCount - 1] := '0';
end;

procedure TfrmMain.sgOrderExternalEditingDone(Sender: TObject; const ACol,
  ARow: Integer);
begin
  if sgOrderExternal.Col = 4 then { количество товаров }
  begin
    sgOrderExternal.Cells[5, sgOrderExternal.Row] := CurrToStr((StrToInt(sgOrderExternal.Cells[4, sgOrderExternal.Row]) * StrToCurr(sgOrderExternal.Cells[2, sgOrderExternal.Row])));

    RecalculateTotalPrice;
  end;
end;

procedure TfrmMain.sgOrderExternalSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  i : integer;
begin
  if ACol = 6 then {button column}
  begin
    if ARow = sgOrderExternal.RowCount - 1 then {add new goods}
    begin
      DM.qryOrderItems.ParamByName('PRICELISTID').AsInteger := DM.qryPartner.FieldByName('PRICELISTID').AsInteger;
      DM.qryOrderItems.Open;
      SwitchToForm(tiOrderItems, nil);
    end
    else
    begin {remove goods}
      for i := ARow + 1 to sgOrderExternal.RowCount - 1 do
      begin
        sgOrderExternal.Cells[0, i - 1] := sgOrderExternal.Cells[0, i];
        sgOrderExternal.Cells[1, i - 1] := sgOrderExternal.Cells[1, i];
        sgOrderExternal.Cells[2, i - 1] := sgOrderExternal.Cells[2, i];
        sgOrderExternal.Cells[3, i - 1] := sgOrderExternal.Cells[3, i];
        sgOrderExternal.Cells[4, i - 1] := sgOrderExternal.Cells[4, i];
        sgOrderExternal.Cells[5, i - 1] := sgOrderExternal.Cells[5, i];
        sgOrderExternal.Cells[6, i - 1] := sgOrderExternal.Cells[6, i];
      end;

      sgOrderExternal.RowCount := sgOrderExternal.RowCount - 1;
    end;

    CanSelect := false;
  end;
end;

procedure TfrmMain.bCancelOIClick(Sender: TObject);
begin
  FCheckedOI.Clear;
  DM.qryOrderItems.Close;

  ReturnPriorForm;
end;

procedure TfrmMain.bHandBookClick(Sender: TObject);
begin
  pPartnerActions.Visible := false;
  SwitchToForm(tiHandbook, nil);
end;

procedure TfrmMain.bMondayClick(Sender: TObject);
begin
  ShowPartners(TButton(Sender).Tag, TButton(Sender).Text);
  SwitchToForm(tiPartners, nil);
end;

procedure TfrmMain.bOrderExternalClick(Sender: TObject);
begin
  sgOrderExternal.RowCount := 1;
  ShowAddedRow;
  RecalculateTotalPrice;

  SwitchToForm(tiOrderExternal, nil);
end;

procedure TfrmMain.bPartnersClick(Sender: TObject);
begin
  ShowPartners(8, 'Все ТТ');
  SwitchToForm(tiPartners, nil);
end;

procedure TfrmMain.bPriceListClick(Sender: TObject);
begin
  SwitchToForm(tiPriceList, nil);
end;

procedure TfrmMain.bReloginClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

procedure TfrmMain.bRouteClick(Sender: TObject);
begin
  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.bSaveOIClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to FCheckedOI.Count - 1 do
  begin
    ShowGoods(FCheckedOI[i]);
    sgOrderExternal.RowCount := sgOrderExternal.RowCount + 1;
  end;
  ShowAddedRow;
  RecalculateTotalPrice;

  FCheckedOI.Clear;
  ReturnPriorForm;
end;

procedure TfrmMain.bSaveOrderExternalClick(Sender: TObject);
var
  GlobalOrderId : TGUID;
  MovementId : integer;
begin
  { Generate alias for opened database }
  CreateGUID(GlobalOrderId);

  DM.conMain.StartTransaction;
  try
    DM.tblMovement_OrderExternal.Open;

    DM.tblMovement_OrderExternal.Append;

    DM.tblMovement_OrderExternalGUID.AsString := GUIDToString(GlobalOrderId);
    DM.tblMovement_OrderExternalOperDate.AsDateTime := Now();
    DM.tblMovement_OrderExternalPartnerId.AsInteger := DM.qryPartnerId.AsInteger;
    DM.tblMovement_OrderExternalContractId.AsInteger := DM.qryPartnerCONTRACTID.AsInteger;
    DM.tblMovement_OrderExternalPriceListId.AsInteger := DM.qryPartnerPRICELISTID.AsInteger;
    DM.tblMovement_OrderExternalInsertDate.AsDateTime := Now();

    DM.tblMovement_OrderExternal.Post;

    MovementId := DM.tblMovement_OrderExternalId.AsInteger;



    DM.conMain.Commit;
  except
    on E : Exception do
    begin
      DM.conMain.Rollback;
      ShowMessage(E.Message);
    end;
  end;



end;

procedure TfrmMain.bVisitClick(Sender: TObject);
begin
  pPartnerActions.Visible := true;
  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.tcPartnerInfoChange(Sender: TObject);
begin
  if tcPartnerInfo.ActiveTab = tiInfo then
    FWebGMap.Visible := true
  else
    FWebGMap.Visible := false;
end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TfrmMain.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbMain.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      tcMain.Align := TAlignLayout.Horizontal;
      vsbMain.RealignContent;
      Application.ProcessMessages;
      vsbMain.ViewportPosition :=
        PointF(vsbMain.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

procedure TfrmMain.RestorePosition;
begin
  vsbMain.ViewportPosition := PointF(vsbMain.ViewportPosition.X, 0);
  tcMain.Align := TAlignLayout.Client;
  vsbMain.RealignContent;
end;

function TfrmMain.PrependIfNotEmpty(const Prefix, Subject: string): string;
begin
  if Subject.IsEmpty then
    Result := ''
  else
    Result := Prefix+Subject;
end;

function TfrmMain.GetAddress(const Latitude, Longitude: Double): string;
begin
  try
    WebGMapsReverseGeocoder.Latitude := Latitude;
    WebGMapsReverseGeocoder.Longitude := Longitude;
    if WebGMapsReverseGeocoder.LaunchReverseGeocoding = erOk then
      begin
        Result := UTF8ToString({BytesOf}(WebGMapsReverseGeocoder.ResultAddress.Street+
                                       PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.StreetNumber)+
                                       PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.City)+
                                       PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.Region)+
                                       PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.Country)));
      end
    else
      Result :=  FormatFloat('0.000000', Latitude)+'N '+FormatFloat('0.000000', Longitude)+'E';
  except
    Result :=  FormatFloat('0.000000', Latitude)+'N '+FormatFloat('0.000000', Longitude)+'E';
  end;
end;
{
function TfrmMain.GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
begin
  try
    WebGMapsGeocoder.Address:= Address;
    if WebGMapsGeocoder.LaunchGeocoding = erOk then
      begin
        Coordinates := TLocationCoord2D.Create(WebGMapsGeocoder.ResultLatitude, WebGMapsGeocoder.ResultLongitude);
        Result := True;
      end
    else
      Result := False;
  except
    Result := False;
  end;
end;
}
procedure TfrmMain.WebGMapDownloadFinish(Sender: TObject);
begin
  if not FMapLoaded then
    begin
      if FWebGMap.Markers.Count = 0 then
        with FWebGMap.Markers.Add(FWebGMap.CurrentLocation.Latitude, FWebGMap.CurrentLocation.Longitude, GetAddress(FWebGMap.CurrentLocation.Latitude, FWebGMap.CurrentLocation.Longitude), '', True, True, False, True, False, 0, TMarkerIconColor.icDefault, -1, -1, -1, -1) do
          MapLabel.Text := Title;
      FWebGMap.MapPanTo(FWebGMap.Markers[0].Latitude, FWebGMap.Markers[0].Longitude);
      FMapLoaded := True;
    end;
end;

procedure TfrmMain.WebGMapAllPartnerDownloadFinish(Sender: TObject);
begin
  if not FMapLoaded then
    begin
      FWebGMap.Markers.Clear;

      with DM.qryPartner do
      begin
        DisableConstraints;
        First;

        while not EOF do
        begin
          with FWebGMap.Markers.Add(FieldByName('GPSN').AsFloat, FieldByName('GPSE').AsFloat, GetAddress(FieldByName('GPSN').AsFloat, FieldByName('GPSE').AsFloat), '', True, True, False, True, False, 0, TMarkerIconColor.icDefault, -1, -1, -1, -1) do
            MapLabel.Text := Title;

          Next;
        end;
        FWebGMap.MapPanTo(FWebGMap.Markers[0].Latitude, FWebGMap.Markers[0].Longitude);

        EnableConstraints;
      end;

      FMapLoaded := True;
    end;
end;

procedure TfrmMain.WebGMapMarkerDragEnd(Sender: TObject; MarkerTitle: string;
  IdMarker: Integer; Latitude, Longitude: Double);
begin
  FWebGMap.Markers[IdMarker].Title := GetAddress(Latitude, Longitude);
  FWebGMap.Markers[IdMarker].MapLabel.Text := FWebGMap.Markers[IdMarker].Title;
end;

procedure TfrmMain.Wait(AWait: Boolean);
begin
  LogInButton.Enabled := not AWait;
  LoginEdit.Enabled := not AWait;
  PasswordEdit.Enabled := not AWait;
  WebServerEdit.Enabled := not AWait;
  SyncCheckBox.Enabled := not AWait;

  if AWait then
    Screen_Cursor_crHourGlass
  else
    Screen_Cursor_crDefault;

  Application.ProcessMessages;
end;

procedure TfrmMain.ChangeMainPageUpdate(Sender: TObject);
begin
  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  { настройка панели возврата }
  if (tcMain.ActiveTab = tiStart) or (tcMain.ActiveTab = tiOrderItems) then
    pBack.Visible := false
  else
  begin
    pBack.Visible := true;
    if tcMain.ActiveTab = tiMain then
    begin
      imLogo.Visible := true;
      sbBack.Visible := false;
    end
    else
    begin
      imLogo.Visible := false;
      sbBack.Visible := true;
    end;

    if tcMain.ActiveTab = tiRoutes then
      lCaption.Text := 'Маршруты';
    if (tcMain.ActiveTab = tiPartners) or (tcMain.ActiveTab =  tiPartnerInfo) then
      lCaption.Text := 'Торговые точки';
    if tcMain.ActiveTab = tiHandbook then
      lCaption.Text := 'Справочники';
    if tcMain.ActiveTab = tiOrderExternal then
      lCaption.Text := 'Заявки сторонние';
  end;


  if tcMain.ActiveTab = tiPartners then
    sbPartnerMenu.Visible := true
  else
    sbPartnerMenu.Visible := false;

  if tcMain.ActiveTab = tiStart then
    CheckDataBase;

  if tcMain.ActiveTab = tiRoutes then
    GetVistDays;

  if tcMain.ActiveTab = tiPartnerInfo then
    ShowPartnerInfo;

  if tcMain.ActiveTab = tiMap then
    ShowAllPartnersonMap;

  if tcMain.ActiveTab = tiPriceList then
    ShowPriceLists;

  if tcMain.ActiveTab = tiPriceListItems then
    ShowPriceListItems((lwPriceList.Selected as TListViewItem).Tag);
end;

procedure TfrmMain.ChangePartnerInfoLeftUpdate(Sender: TObject);
begin
  if tcPartnerInfo.TabIndex < tcPartnerInfo.TabCount - 1 then
    ChangePartnerInfoLeft.Tab := tcPartnerInfo.Tabs[tcPartnerInfo.TabIndex + 1]
  else
    ChangePartnerInfoLeft.Tab := nil;
end;

procedure TfrmMain.ChangePartnerInfoRightUpdate(Sender: TObject);
begin
  if tcPartnerInfo.TabIndex > 0 then
    ChangePartnerInfoRight.Tab := tcPartnerInfo.Tabs[tcPartnerInfo.TabIndex - 1]
  else
    ChangePartnerInfoRight.Tab := nil;
end;

procedure TfrmMain.CheckDataBase;
begin
  if not DM.Connected then
  begin
    LogInButton.Enabled := false;
    ShowMessage('Ошибка соединения с локальной БД. Обратитесь к разработчику.');
    exit;
  end;

  DM.tblObject_Const.Open;
  if (DM.tblObject_Const.RecordCount > 0) and (DM.tblObject_ConstWebService.AsString <> '') then
  begin
    gc_User := TUser.Create(DM.tblObject_ConstUserLogin.AsString, DM.tblObject_ConstUserPassword.AsString);
    gc_WebService := DM.tblObject_ConstWebService.AsString;

    WebServerLayout1.Visible := false;
    WebServerLayout2.Visible := false;
    SyncLayout.Visible := true;
  end
  else
  begin
    WebServerLayout1.Visible := true;
    WebServerLayout2.Visible := true;
    SyncLayout.Visible := false;
  end;
end;

procedure TfrmMain.GetVistDays;
var
  i, Num : integer;
  DaysCount : array[1..8] of integer;
  Schedule : string;
begin
  for i := 1 to 8 do
   DaysCount[i] := 0;

  with DM.qryPartner do
  begin
    DM.qryPartner.Open('select P.Id, P.CONTRACTID, J.VALUEDATA Name, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, ' +
      'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, P.PRICELISTID, 0 imAddress, 1 imContract from OBJECT_PARTNER P ' +
      'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 ' +
      'JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID and C.ISERASED = 0 where P.ISERASED = 0');

    First;
    while not EOF do
    begin
      Schedule := FieldbyName('Schedule').AsString;
      if Schedule.Length <> 14 then
      begin
        ShowMessage('Ошибка в структуре поля Schedule');
        exit;
      end
      else
      begin
        for i := 1 to 7 do
          if Schedule[2 * i - 2 + Low(string)] = 't' then
            inc(DaysCount[i]);
      end;
      inc(DaysCount[8]);

      Next;
    end;
    Close;
  end;

  Num := 1;
  if DaysCount[1] > 0 then
  begin
    bMonday.Visible := true;
    bMonday.Text := '  ' + IntToStr(Num) + '. Понедельник';
    lMondayCount.Text := IntToStr(DaysCount[1]);
    inc(Num);
  end
  else
    bMonday.Visible := false;

  if DaysCount[2] > 0 then
  begin
    bTuesday.Visible := true;
    bTuesday.Text := '  ' + IntToStr(Num) + '. Вторник';
    lTuesdayCount.Text := IntToStr(DaysCount[2]);
    inc(Num);
  end
  else
    bTuesday.Visible := false;

  if DaysCount[3] > 0 then
  begin
    bWednesday.Visible := true;
    bWednesday.Text := '  ' + IntToStr(Num) + '. Среда';
    lWednesdayCount.Text := IntToStr(DaysCount[3]);
    inc(Num);
  end
  else
    bWednesday.Visible := false;

  if DaysCount[4] > 0 then
  begin
    bThursday.Visible := true;
    bThursday.Text := '  ' + IntToStr(Num) + '. Четверг';
    lThursdayCount.Text := IntToStr(DaysCount[4]);
    inc(Num);
  end
  else
    bThursday.Visible := false;

  if DaysCount[5] > 0 then
  begin
    bFriday.Visible := true;
    bFriday.Text := '  ' + IntToStr(Num) + '. Пятница';
    lFridayCount.Text := IntToStr(DaysCount[5]);
    inc(Num);
  end
  else
    bFriday.Visible := false;

  if DaysCount[6] > 0 then
  begin
    bSaturday.Visible := true;
    bSaturday.Text := '  ' + IntToStr(Num) + '. Суббота';
    lSaturdayCount.Text := IntToStr(DaysCount[6]);
    inc(Num);
  end
  else
    bSaturday.Visible := false;

  if DaysCount[7] > 0 then
  begin
    bSunday.Visible := true;
    bSunday.Text := '  ' + IntToStr(Num) + '. Воскресенье';
    lSundayCount.Text := IntToStr(DaysCount[7]);
  end
  else
    bSunday.Visible := false;

  lAllDaysCount.Text := IntToStr(DaysCount[8]);
end;

procedure TfrmMain.ImageColumn1Tap(Sender: TObject; const Point: TPointF);
begin
  ShowMessage('Test');
end;

procedure TfrmMain.ShowPartners(Day : integer; Caption : string);
var
  sQuery, CurGPSN, CurGPSE : string;

  {$IFDEF ANDROID}
  LastLocation: JLocation;
  LocManagerObj: JObject;
  LocationManager: JLocationManager;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  //запрашиваем сервис Location
  LocManagerObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.LOCATION_SERVICE);
  if Assigned(LocManagerObj) then
  begin
    //получаем LocationManager
    LocationManager := TJLocationManager.Wrap((LocManagerObj as ILocalObject).GetObjectID);
    if Assigned(LocationManager) then
    begin
      //получаем последнее местоположение зафиксированное с помощью координат wi-fi и мобильных сетей
      LastLocation := LocationManager.getLastKnownLocation(TJLocationManager.JavaClass.NETWORK_PROVIDER);
      if Assigned(LastLocation) then
      begin
        FCurCoordinates := TLocationCoord2D.Create(LastLocation.getLatitude, LastLocation.getLongitude);
        FCurCoordinatesSet := true;
      end;
    end
    else
    begin
      //raise Exception.Create('Could not access Location Manager');
    end;
  end
  else
  begin
    //raise Exception.Create('Could not locate Location Service');
  end;
  {$ELSE}
  FCurCoordinatesSet := true;
  FCurCoordinates := TLocationCoord2D.Create(0, 0);
  {$ENDIF}
  lDayInfo.Text := 'МАРШРУТ: ' + Caption;
  DM.qryPartner.Close;

  sQuery := 'select P.Id, P.CONTRACTID, J.VALUEDATA Name, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, ' +
    'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, P.PRICELISTID, 0 imAddress, 1 imContract from OBJECT_PARTNER P ' +
    'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 ' +
    'JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID and C.ISERASED = 0 where P.ISERASED = 0';

  if Day < 8 then
    sQuery := sQuery + ' and lower(substr(P.SCHEDULE, ' + IntToStr(2 * Day - 1) + ', 1)) = ''t''';

  if FCurCoordinatesSet then
  begin
    CurGPSN := FloatToStr(FCurCoordinates.Latitude);
    CurGPSE := FloatToStr(FCurCoordinates.Longitude);
    CurGPSN := StringReplace(CurGPSN, ',', '.', [rfReplaceAll]);
    CurGPSE := StringReplace(CurGPSE, ',', '.', [rfReplaceAll]);

    sQuery := sQuery + ' order by ((P.GPSN - ' + CurGPSN + ') * ' + LatitudeRatio + ') * ' +
      '((P.GPSN - ' + CurGPSN + ') * ' + LatitudeRatio + ') + ' +
      '((P.GPSE - ' + CurGPSE + ') * ' + LongitudeRatio + ') * ' +
      '((P.GPSE - ' + CurGPSE + ') * ' + LongitudeRatio + ')';
  end;

  DM.qryPartner.Open(sQuery);
end;

procedure TfrmMain.ShowPartnerInfo;
var
  Coordinates: TLocationCoord2D;
begin
  Coordinates := TLocationCoord2D.Create(DM.qryPartner.FieldByName('GPSN').AsFloat, DM.qryPartner.FieldByName('GPSE').AsFloat);

  FMapLoaded := False;

  FWebGMap := TTMSFMXWebGMaps.Create(Self);
  FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
  FWebGMap.OnMarkerDragEnd := WebGMapMarkerDragEnd;
  FWebGMap.CurrentLocation.Latitude := Coordinates.Latitude;
  FWebGMap.CurrentLocation.Longitude := Coordinates.Longitude;
  FWebGMap.Align := TAlignLayout.Client;
  FWebGMap.MapOptions.ZoomMap := 18;
  FWebGMap.Parent := pMap;

  tcPartnerInfo.ActiveTab := tiInfo;
end;

procedure TfrmMain.ShowAllPartnersOnMap;
begin
  FMapLoaded := False;

  FWebGMap := TTMSFMXWebGMaps.Create(Self);
  FWebGMap.OnDownloadFinish := WebGMapAllPartnerDownloadFinish;
  FWebGMap.OnMarkerDragEnd := WebGMapMarkerDragEnd;
  FWebGMap.Align := TAlignLayout.Client;
  FWebGMap.MapOptions.ZoomMap := 18;
  FWebGMap.Parent := tiMap;
end;

procedure TfrmMain.ShowPriceLists;
begin
  DM.qryPriceList.Open('select ID, VALUEDATA from OBJECT_PRICELIST where ISERASED = 0');
end;

procedure TfrmMain.ShowPriceListItems(PriceListId : integer);
begin
  DM.qryGoods.Open('select G.ID, G.VALUEDATA GoodsName, G.WEIGHT, G.OBJECTCODE, PLI.PRICE, PLI.ENDDATE, ' +
    'GG.VALUEDATA GroupName, M.VALUEDATA MeasureName from OBJECT_GOODS G ' +
    'JOIN OBJECT_PRICELISTITEMS PLI ON PLI.GOODSID = G.ID JOIN OBJECT_PRICELIST PL ON PL.ID = PLI.PRICELISTID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'LEFT JOIN OBJECT_GOODSGROUP GG ON GG.ID = G.GOODSGROUPID where G.ISERASED = 0 and PLI.PRICELISTID = ' + IntToStr(PriceListId));
end;

procedure TfrmMain.RecalculateTotalPrice;
var
 i : integer;
 TotalPrice : Currency;
begin
  TotalPrice := 0;
  for i := 0 to sgOrderExternal.RowCount - 2 do
    TotalPrice := TotalPrice + StrToCurr(sgOrderExternal.Cells[5, i]);

  lTotalPrice.Text := 'Общая стоимость : ' + CurrToStr(TotalPrice);
end;


procedure TfrmMain.SwitchToForm(const TabItem: TTabItem; const Data: TObject);
var
  Item: TFormStackItem;
begin
  Item.PageIndex := tcMain.ActiveTab.Index;
  Item.Data := Data;
  FFormsStack.Push(Item);
  tcMain.ActiveTab := TabItem;
end;

function TfrmMain.ReturnPriorForm(const OmitOnChange: Boolean): TObject;
var
  Item: TFormStackItem;
  OnChange: TNotifyEvent;
begin
  if FFormsStack.Count > 0 then
    begin
      Item:= FFormsStack.Pop;

      OnChange := tcMain.OnChange;
      if OmitOnChange then tcMain.OnChange := nil;
      try
        tcMain.ActiveTab:= tcMain.Tabs[Item.PageIndex];
      finally
        tcMain.OnChange := OnChange;
      end;

      Result:= Item.Data;
    end
  else
    raise Exception.Create('Forms stack underflow');
end;

end.


(*
  {$IFDEF ANDROID}
    LastLocation: JLocation;
    LocManagerObj: JObject;
    LocationManager: JLocationManager;
    Geocoder: JGeocoder;
    Address: JAddress;
    AddressList: JList;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  //запрашиваем сервис Location
  LocManagerObj:=SharedActivityContext.getSystemService(TJContext.JavaClass.LOCATION_SERVICE);
  if not Assigned(LocManagerObj) then
    raise Exception.Create('Could not locate Location Service');
  //получаем LocationManager
  LocationManager:=TJLocationManager.Wrap((LocManagerObj as ILocalObject).GetObjectID);
  if not Assigned(LocationManager) then
    raise Exception.Create('Could not access Location Manager');
  //получаем последнее местоположение зафиксированное с помощью координат wi-fi и мобильных сетей
  LastLocation:=LocationManager.getLastKnownLocation(TJLocationManager.JavaClass.NETWORK_PROVIDER);
  if Assigned(LastLocation) then
    begin
      geocoder:= TJGeocoder.JavaClass.init(SharedActivityContext);
      if not Assigned(geocoder) then
         raise Exception.Create('Could not access Geocoder');
      //пробуем определить 1 возможный адрес местоположения
      AddressList:=geocoder.getFromLocation(LastLocation.getLatitude, LastLocation.getLongitude,1);
      Coordinates := TLocationCoord2D.Create(LastLocation.getLatitude, LastLocation.getLongitude);
     if AddressList.size > 0 then
     begin
       Address:=TJAddress.Wrap((AddressList.get(0) as ILocalObject).GetObjectID);
       if not Assigned(Address) then
         raise Exception.Create('Could not access Address');
       //выводим данные в memo
       Memo1.Lines.Add('City: '+JStringToString(Address.getAddressLine(1)));
       Memo1.Lines.Add('Street: '+JStringToString(Address.getAddressLine(0)));
       Memo1.Lines.Add('PostalCode: '+JStringToString(Address.getAddressLine(4)));
       Memo1.Lines.Add(FormatFloat('0.000000', LastLocation.getLatitude)+'N '+FormatFloat('0.000000', LastLocation.getLongitude)+'E');
     end;
    end;
  {$ELSE}
  Coordinates := TLocationCoord2D.Create(0,0);
  {$ENDIF}
*)
