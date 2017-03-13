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
  FMX.Grid.Style, FMX.Media, FMX.Surfaces
  {$IFDEF ANDROID}
  ,FMX.Helpers.Android, Androidapi.Helpers,
  Androidapi.JNI.Location, Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  AndroidApi.JNI.WebKit
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
    pPartnerInfo: TPanel;
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
    pMapScreen: TPanel;
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
    tiOrders: TTabItem;
    tiStoreReals: TTabItem;
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
    tiOrderExternal: TTabItem;
    VertScrollBox3: TVertScrollBox;
    tiOrderItems: TTabItem;
    Panel3: TPanel;
    bCancelOI: TButton;
    bSaveOI: TButton;
    Panel4: TPanel;
    lwPartner: TListView;
    LinkListControlToField1: TLinkListControlToField;
    bsPartner: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    ilPartners: TImageList;
    Panel6: TPanel;
    lTotalPrice: TLabel;
    Panel8: TPanel;
    bSaveOrderExternal: TButton;
    Panel9: TPanel;
    Label11: TLabel;
    deOperDate: TDateEdit;
    lTotalWeight: TLabel;
    tiCamera: TTabItem;
    Panel10: TPanel;
    imgCameraPreview: TImage;
    Panel17: TPanel;
    lPlate: TLabel;
    ePhotoComment: TEdit;
    Panel11: TPanel;
    tiPhotos: TTabItem;
    Panel12: TPanel;
    Panel13: TPanel;
    bAddedPhotoGroup: TButton;
    bCapture: TButton;
    bSavePartnerPhoto: TButton;
    bClosePhoto: TButton;
    lwPartnerPhotoGroups: TListView;
    lwNewOrderExternal: TListView;
    bsSelectedOrderItems: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    Panel14: TPanel;
    lOrderPrice: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label21: TLabel;
    bAddOrderItem: TButton;
    Image10: TImage;
    ppEnterAmount: TPopup;
    pEnterAmount: TPanel;
    lAmount: TLabel;
    b7: TButton;
    b8: TButton;
    b9: TButton;
    b4: TButton;
    b5: TButton;
    b6: TButton;
    b1: TButton;
    b2: TButton;
    b3: TButton;
    b0: TButton;
    bDot: TButton;
    bEnterAmount: TButton;
    bAddAmount: TButton;
    bClearAmount: TButton;
    lMeasure: TLabel;
    lwOrderItems: TListView;
    Popup1: TPopup;
    Panel15: TPanel;
    Label12: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Label23: TLabel;
    Panel16: TPanel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    bsOrderItems: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    bMinusAmount: TButton;
    VertScrollBox4: TVertScrollBox;
    Label19: TLabel;
    Label28: TLabel;
    lPartnerAddress: TLabel;
    lPartnerName: TLabel;
    tMapToImage: TTimer;
    iPartnerMap: TImage;
    lwOrderExternal: TListView;
    LinkListControlToField4: TLinkListControlToField;
    bsPriceList: TBindSourceDB;
    LinkListControlToField5: TLinkListControlToField;
    pNewOrderExternal: TPanel;
    bNewOrderExternal: TButton;
    bSetPartnerCoordinate: TButton;
    Image11: TImage;
    pMap: TPanel;
    bShowBigMap: TButton;
    Image12: TImage;
    tSavePath: TTimer;
    bPathonMap: TButton;
    tiPathOnMap: TTabItem;
    Panel18: TPanel;
    Label26: TLabel;
    deDatePath: TDateEdit;
    pPathOnMap: TPanel;
    cbShowAllPath: TCheckBox;
    bRefreshPathOnMap: TButton;
    Image13: TImage;
    tiReturnIns: TTabItem;
    tiPhotosList: TTabItem;
    lwPhotos: TListView;
    Panel7: TPanel;
    bAddedPhoto: TButton;
    pNewPhotoGroup: TPanel;
    bSavePG: TButton;
    bCanclePG: TButton;
    ePhotoGroupName: TEdit;
    Label29: TLabel;
    bsPhotoGroups: TBindSourceDB;
    LinkListControlToField6: TLinkListControlToField;
    bsPhotos: TBindSourceDB;
    LinkListControlToField7: TLinkListControlToField;
    bsOrderExternal: TBindSourceDB;
    tiPhotoEdit: TTabItem;
    Panel19: TPanel;
    bSavePhotoComment: TButton;
    Panel20: TPanel;
    Label30: TLabel;
    ePhotoCommentEdit: TEdit;
    imPhoto: TImage;
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
    procedure bNewOrderExternalClick(Sender: TObject);
    procedure lwOrderItemsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderItemsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bCancelOIClick(Sender: TObject);
    procedure bSaveOIClick(Sender: TObject);
    procedure bSaveOrderExternalClick(Sender: TObject);
    procedure bAddedPhotoGroupClick(Sender: TObject);
    procedure bCaptureClick(Sender: TObject);
    procedure bSavePartnerPhotoClick(Sender: TObject);
    procedure bClosePhotoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bAddOrderItemClick(Sender: TObject);
    procedure lwNewOrderExternalItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure b0Click(Sender: TObject);
    procedure bClearAmountClick(Sender: TObject);
    procedure bEnterAmountClick(Sender: TObject);
    procedure bAddAmountClick(Sender: TObject);
    procedure lwNewOrderExternalFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure bMinusAmountClick(Sender: TObject);
    procedure tMapToImageTimer(Sender: TObject);
    procedure lwOrderExternalItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure bSetPartnerCoordinateClick(Sender: TObject);
    procedure bShowBigMapClick(Sender: TObject);
    procedure tSavePathTimer(Sender: TObject);
    procedure cbShowAllPathChange(Sender: TObject);
    procedure bRefreshPathOnMapClick(Sender: TObject);
    procedure bPathonMapClick(Sender: TObject);
    procedure bAddedPhotoClick(Sender: TObject);
    procedure bCanclePGClick(Sender: TObject);
    procedure bSavePGClick(Sender: TObject);
    procedure lwPartnerPhotoGroupsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwPhotosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure LinkListControlToField6FilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure lwNewOrderExternalUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderExternalUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPartnerUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPhotosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure bSavePhotoCommentClick(Sender: TObject);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;

    FCanEditPartner : boolean;

    FCurCoordinatesSet: boolean;
    FCurCoordinates: TLocationCoord2D;
    FMapLoaded: Boolean;
    FMarkerList: TList<TLocationCoord2D>;
    FWebGMap: TTMSFMXWebGMaps;

    FKBBounds: TRectF;
    FNeedOffset: Boolean;

    OldOrderExternalId : string;
    FCheckedOI: TList<String>;
    FDeletedOI: TList<Integer>;
    FOrderTotalCountKg : Currency;
    FOrderTotalPrice : Currency;

    FCameraZoomDistance: Integer;
    CameraComponent : TCameraComponent;

    procedure BackResult(const AResult: TModalResult);
    procedure DeleteOrderExtrernal(const AResult: TModalResult);
    procedure SetPartnerCoordinates(const AResult: TModalResult);

    procedure UpdateKBBounds;
    procedure RestorePosition;
    function PrependIfNotEmpty(const Prefix, Subject: string): string;

    function GetAddress(const Latitude, Longitude: Double): string;
    //function GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
    procedure WebGMapDownloadFinish(Sender: TObject);
    procedure ShowBigMap;
    procedure GetMapPartnerScreenshot(SetCordinate: boolean; Coordinates: TLocationCoord2D);

    procedure Wait(AWait: Boolean);
    procedure CheckDataBase;
    procedure GetVistDays;
    procedure ShowPartners(Day : integer; Caption : string);
    procedure ShowPartnerInfo;
    procedure ShowPriceLists;
    procedure ShowPriceListItems;
    procedure ShowPathOnmap;
    procedure ShowPhotos;
    procedure ShowPhoto;
    procedure RecalculateTotalPriceAndWeight;
    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);


    procedure PrepareCamera;
    procedure CameraFree;
    procedure ScaleImage(const Margins: Integer);
    procedure GetImage;
    procedure PlayAudio;
    procedure CameraComponentSampleBufferReady(Sender: TObject; const ATime: TMediaTime);

    procedure GetCurrentCoordinates;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uConstants, System.IOUtils, Authentication, Storage, CommonData, uDM, CursorUtils;

{$R *.fmx}

resourcestring
  rstCapture = 'Capture';
  rstReturn = 'Return';

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
  r : integer;
begin
  FormatSettings.DecimalSeparator := '.';

  {$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetScreenOrientation(OrientSet);
  end;
  {$ENDIF}

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  bAddedPhoto.Enabled := true;
  bSetPartnerCoordinate.Enabled := true;
  {$ELSE}
  bAddedPhoto.Enabled := false;
  bSetPartnerCoordinate.Enabled := false;
  {$ENDIF}

  FFormsStack := TStack<TFormStackItem>.Create;
  FMarkerList := TList<TLocationCoord2D>.Create;
  FCheckedOI := TList<String>.Create;
  FDeletedOI := TList<Integer>.Create;
  FCurCoordinatesSet := false;

  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(tcMain);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  FFormsStack.Free;
  FMarkerList.Free;
  FCheckedOI.Free;
  FDeletedOI.Free;
end;

procedure TfrmMain.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfrmMain.lbiShowAllOnMapClick(Sender: TObject);
begin
  FMarkerList.Clear;

  with DM.qryPartner do
  begin
    DisableConstraints;
    First;

    while not EOF do
    begin
       if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
         FMarkerList.Add(TLocationCoord2D.Create(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat));

      Next;
    end;

    EnableConstraints;
  end;

  ShowBigMap;

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

procedure TfrmMain.LinkListControlToField6FilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  lwPartnerPhotoGroups.Items[AEditor.CurrentIndex].ImageIndex := 0;
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
  lGoodsName.Text := DM.qryGoodsGoodsName.AsString;
  lGoodsCode.Text := DM.qryGoodsOBJECTCODE.AsString;
  lGoodsCategory.Text := '-';
  lGoodsGroup.Text := DM.qryGoodsGroupName.AsString;
  lGoodsType.Text := '-';
  lGoodsWeight.Text := DM.qryGoodsweight.AsString + ' ' + DM.qryGoodsMeasureName.AsString;
  lGoodsDateEnd.Text := DM.qryGoodsEndDate.AsString;
  lGoodsPrice.Text := DM.qryGoodsPrice.AsString;

  pGoodsInfo.IsOpen := true;
end;

procedure TfrmMain.lwNewOrderExternalFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwNewOrderExternalItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then
  begin
    if DM.cdsOrderItemsId.AsInteger <> -1 then
      FDeletedOI.Add(DM.cdsOrderItemsId.AsInteger);
    DM.cdsOrderItems.Delete;


    RecalculateTotalPriceAndWeight;
  end;

  if (ItemObject.Name = 'Count') or (ItemObject.Name = 'Measure') then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsOrderItemsMeasure.AsString;

    ppEnterAmount.IsOpen := true;
  end;
end;

procedure TfrmMain.lwNewOrderExternalUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
end;

procedure TfrmMain.lwOrderExternalItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then
  begin
    MessageDlg('Удалить заявку на ' + FormatDateTime('DD.MM.YYYY', DM.cdsOrderExternalOperDate.AsDateTime) + '?',
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               DeleteOrderExtrernal);
  end;

  if ItemObject.Name = 'EditButton' then
  begin
    if DM.qryPartnerPriceWithVAT.AsBoolean then
      lOrderPrice.Text := 'Цена (с НДС)'
    else
      lOrderPrice.Text := 'Цена (без НДС)';

    DM.LoadOrderExtrenalItems(DM.cdsOrderExternalId.AsInteger);
    FDeletedOI.Clear;

    RecalculateTotalPriceAndWeight;

    OldOrderExternalId := DM.cdsOrderExternalId.AsString;
    deOperDate.Date := DM.cdsOrderExternalOperDate.AsDateTime;

    SwitchToForm(tiOrderExternal, nil);
  end;
end;

procedure TfrmMain.lwOrderExternalUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemImage(AItem.Objects.FindDrawable('EditButton')).ImageIndex := 1;
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
  if (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible then
  begin
    (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := False;
    FCheckedOI.Remove((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
  end
  else
  begin
    (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := True;
    FCheckedOI.Add((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
  end;
end;

procedure TfrmMain.lwOrderItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := FCheckedOI.Contains((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
end;

procedure TfrmMain.lwPartnerItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ShowPartnerInfo;
end;

procedure TfrmMain.lwPartnerPhotoGroupsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'I') then
  begin
    DM.qryPhotoGroups.Edit;
    DM.qryPhotoGroupsStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.qryPhotoGroups.Post;

    DM.qryPhotoGroups.Refresh;
  end
  else
  begin
    ShowPhotos;
  end;
end;

procedure TfrmMain.lwPartnerUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('imAddress')).ImageIndex := 2;
  TListItemImage(AItem.Objects.FindDrawable('imContact')).ImageIndex := 3;
end;

procedure TfrmMain.lwPhotosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) then
  begin
    if ItemObject.Name = 'DeleteButton' then
      DM.qryPhotos.Delete;

    if ItemObject.Name = 'EditButton' then
      ShowPhoto;
  end;
end;

procedure TfrmMain.lwPhotosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemImage(AItem.Objects.FindDrawable('EditButton')).ImageIndex := 1;
end;

procedure TfrmMain.lwPriceListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ShowPriceListItems;
end;

procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  if lAmount.Text = '-0' then
    lAmount.Text := '-';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

procedure TfrmMain.BackResult(const AResult: TModalResult);
begin
  if AResult = mrYes then
    ReturnPriorForm;
end;

procedure TfrmMain.DeleteOrderExtrernal(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.conMain.ExecSQL('update MOVEMENT_ORDEREXTERNAL set STATUSID = ' + DM.tblObject_ConstStatusId_Erased.AsString +
      ' where ID = ' + DM.cdsOrderExternalId.AsString);

    DM.cdsOrderExternal.Delete;
  end;
end;

procedure TfrmMain.SetPartnerCoordinates(const AResult: TModalResult);
var
  Id, ContractId : integer;
begin
  if AResult = mrYes then
  begin
    GetCurrentCoordinates;
    if FCurCoordinatesSet then
    begin
      DM.conMain.ExecSQL('update OBJECT_PARTNER set GPSN = ' + FloatToStr(FCurCoordinates.Latitude) +
        ', GPSE = ' + FloatToStr(FCurCoordinates.Longitude) +
        ' where ID = ' + DM.qryPartnerId.AsString + ' and CONTRACTID = ' + DM.qryPartnerCONTRACTID.AsString);
      Id := DM.qryPartnerId.AsInteger;
      ContractId := DM.qryPartnerCONTRACTID.AsInteger;
      DM.qryPartner.Refresh;
      DM.qryPartner.Locate('Id;ContractId', VarArrayOf([Id, ContractId]), []);

      FMarkerList.Clear;
      FMarkerList.Add(FCurCoordinates);
      GetMapPartnerScreenshot(true, FCurCoordinates);
    end
    else
      ShowMessage('Не удалось получить текущие координаты');
  end;
end;

procedure TfrmMain.sbBackClick(Sender: TObject);
var
  Mes : string;
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    if OldOrderExternalId = '' then
      Mes := 'Удалить эту заявку?'
    else
      Mes := 'Выйти из редактирования без сохранения?';

    MessageDlg(Mes,
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               BackResult);
  end
  else
    ReturnPriorForm;
end;

procedure TfrmMain.sbPartnerMenuClick(Sender: TObject);
begin
  ppPartner.IsOpen := true;
  lbPartnerMenu.ItemIndex := -1;
end;

procedure TfrmMain.bAddedPhotoClick(Sender: TObject);
begin
  PrepareCamera;
end;

procedure TfrmMain.bAddedPhotoGroupClick(Sender: TObject);
begin
  vsbMain.Enabled := false;
  pNewPhotoGroup.Visible := true;
  ePhotoComment.SetFocus;
end;

procedure TfrmMain.bAddOrderItemClick(Sender: TObject);
begin
  DM.qryOrderItems.ParamByName('PRICELISTID').AsInteger := DM.qryPartner.FieldByName('PRICELISTID').AsInteger;
  DM.qryOrderItems.Open;
  SwitchToForm(tiOrderItems, DM.qryOrderItems);
end;

procedure TfrmMain.bCancelOIClick(Sender: TObject);
begin
  FCheckedOI.Clear;
  DM.qryOrderItems.Close;

  ReturnPriorForm;
end;

procedure TfrmMain.bCanclePGClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pNewPhotoGroup.Visible := false;
end;

procedure TfrmMain.bClearAmountClick(Sender: TObject);
begin
  lAmount.Text := '0';
end;

procedure TfrmMain.bEnterAmountClick(Sender: TObject);
begin
  DM.cdsOrderItems.Edit;
  DM.cdsOrderItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
  DM.cdsOrderItems.Post;

  ppEnterAmount.IsOpen := false;
  RecalculateTotalPriceAndWeight;
end;

procedure TfrmMain.bAddAmountClick(Sender: TObject);
begin
  DM.cdsOrderItems.Edit;
  DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
  DM.cdsOrderItems.Post;

  ppEnterAmount.IsOpen := false;
  RecalculateTotalPriceAndWeight;
end;

procedure TfrmMain.bMinusAmountClick(Sender: TObject);
begin
  DM.cdsOrderItems.Edit;
  if DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
    DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
  else
    DM.cdsOrderItemsCount.AsFloat := 0;
  DM.cdsOrderItems.Post;

  ppEnterAmount.IsOpen := false;
  RecalculateTotalPriceAndWeight;
end;

procedure TfrmMain.bHandBookClick(Sender: TObject);
begin
  FCanEditPartner := false;

  SwitchToForm(tiHandbook, nil);
end;

procedure TfrmMain.bMondayClick(Sender: TObject);
begin
  ShowPartners(TButton(Sender).Tag, TButton(Sender).Text);
end;

procedure TfrmMain.bNewOrderExternalClick(Sender: TObject);
begin
  if DM.qryPartnerPriceWithVAT.AsBoolean then
    lOrderPrice.Text := 'Цена (с НДС)'
  else
    lOrderPrice.Text := 'Цена (без НДС)';

  OldOrderExternalId := '';
  deOperDate.Date := Date();
  DM.DefaultOrderExternal;
  FDeletedOI.Clear;

  RecalculateTotalPriceAndWeight;

  SwitchToForm(tiOrderExternal, nil);
end;

procedure TfrmMain.bPartnersClick(Sender: TObject);
begin
  ShowPartners(8, 'Все ТТ');
  SwitchToForm(tiPartners, nil);
end;

procedure TfrmMain.bPathonMapClick(Sender: TObject);
begin
  ShowPathOnMap;
end;

procedure TfrmMain.bPriceListClick(Sender: TObject);
begin
  ShowPriceLists;
end;

procedure TfrmMain.bRefreshPathOnMapClick(Sender: TObject);
var
 i : integer;
begin
  FMarkerList.Clear;

  with DM.tblMovement_RouteMember do
  begin
    if not cbShowAllPath.IsChecked then
    begin
      Filter := 'date(InsertDate) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', deDatePath.Date));
      Filtered := true;
    end;
    Open;
    First;

    while not EOF do
    begin
       if (DM.tblMovement_RouteMemberGPSN.AsFloat <> 0) and (DM.tblMovement_RouteMemberGPSE.AsFloat <> 0) then
         FMarkerList.Add(TLocationCoord2D.Create(DM.tblMovement_RouteMemberGPSN.AsFloat, DM.tblMovement_RouteMemberGPSE.AsFloat));

      Next;
    end;

    Close;
    Filter := '';
    Filtered := false;
  end;

  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  FMapLoaded := False;

  FWebGMap := TTMSFMXWebGMaps.Create(Self);
  FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
  FWebGMap.Align := TAlignLayout.Client;
  FWebGMap.MapOptions.ZoomMap := 14;
  FWebGMap.Parent := pPathOnMap;
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
  i: integer;
begin
  for i := 0 to FCheckedOI.Count - 1 do
    DM.AddedGoodsToOrderExternal(FCheckedOI[i]);

  RecalculateTotalPriceAndWeight;

  FCheckedOI.Clear;
  ReturnPriorForm;
end;

procedure TfrmMain.bSaveOrderExternalClick(Sender: TObject);
var
  i : integer;
  ErrMes: string;
  DelItems: string;
begin
   DelItems := '';
   if FDeletedOI.Count > 0 then
   begin
     DelItems := IntToStr(FDeletedOI[0]);
     for i := 1 to FDeletedOI.Count - 1 do
       DelItems := ',' + IntToStr(FDeletedOI[i]);
   end;

   if DM.SaveOrderExternal(OldOrderExternalId, deOperDate.Date, FOrderTotalPrice, FOrderTotalCountKg, DelItems, ErrMes) then
   begin
     ShowMessage('Сохранение заявки прошло успешно.');
     ReturnPriorForm;
   end
   else
     ShowMessage(ErrMes);
end;

procedure TfrmMain.bCaptureClick(Sender: TObject);
begin
  if CameraComponent.Active then
  begin
    CameraComponent.Active := False;
    PlayAudio;
    TSpeedButton(Sender).Text := rstReturn;
    bSavePartnerPhoto.Enabled := true;
  end
  else
  begin
    ScaleImage(0);
    CameraComponent.Active := True;
    TSpeedButton(Sender).Text := rstCapture;
    bSavePartnerPhoto.Enabled := false;
  end;
end;

procedure TfrmMain.bSavePartnerPhotoClick(Sender: TObject);
var
  BlobStream : TMemoryStream;
  Surf : TBitmapSurface;
  qrySavePhoto : TFDQuery;
  GlobalId : TGUID;
begin
  // Save displayed photo
  try
    BlobStream := TMemoryStream.Create;
    aiWait.Visible := true;
    aiWait.Enabled := true;
    Application.ProcessMessages;

    Surf := TBitmapSurface.Create;
    try
      Surf.Assign(imgCameraPreview.Bitmap);

      if not TBitmapCodecManager.SaveToStream( BlobStream, Surf, '.jpg') then
        raise EBitmapSavingFailed.Create('Error saving Bitmap to jpg');

      BlobStream.Seek(0, 0);

      qrySavePhoto := TFDQuery.Create(nil);
      try
        qrySavePhoto.Connection := DM.conMain;

        qrySavePhoto.SQL.Text := 'Insert into MovementItem_Visit (MovementId, GUID, Photo, Comment, InsertDate) Values (:MovementId, :GUID, :Photo, :Comment, :InsertDate)';
        qrySavePhoto.Params[0].Value := DM.qryPhotoGroupsId.AsInteger;
        CreateGUID(GlobalId);
        qrySavePhoto.Params[1].Value := GUIDToString(GlobalId);
        qrySavePhoto.Params[2].LoadFromStream(BlobStream, ftBlob);
        qrySavePhoto.Params[3].Value := ePhotoComment.Text;
        qrySavePhoto.Params[4].Value := Now();

        qrySavePhoto.ExecSQL;

        ShowMessage('Фото успешно сохранено');

        DM.qryPhotos.Refresh;
      finally
        FreeAndNil(qrySavePhoto);
      end;
    finally
      aiWait.Visible := false;
      aiWait.Enabled := false;
      Application.ProcessMessages;
      FreeAndNil(BlobStream);
      Surf.Free;
    end;
  Except
    on E: Exception do
      Showmessage(E.Message);
  end;

  CameraFree;
  ReturnPriorForm;
end;

procedure TfrmMain.bSavePGClick(Sender: TObject);
begin
  DM.SavePhotoGroup(ePhotoGroupName.Text);

  DM.qryPhotoGroups.Refresh;

  vsbMain.Enabled := true;
  pNewPhotoGroup.Visible := false;
end;

procedure TfrmMain.bSavePhotoCommentClick(Sender: TObject);
begin
  DM.qryPhotos.Edit;
  DM.qryPhotosComment.AsString := ePhotoCommentEdit.Text;
  DM.qryPhotos.Post;

  ReturnPriorForm;
end;

procedure TfrmMain.bSetPartnerCoordinateClick(Sender: TObject);
var
  Mes : string;
begin
  if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
    Mes := 'Изменить прежние координаты ТТ на текущие?'
  else
    Mes := 'Назназить ТТ текущие координаты?';

  MessageDlg(Mes, System.UITypes.TMsgDlgType.mtWarning,
    [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0, SetPartnerCoordinates);
end;

procedure TfrmMain.bShowBigMapClick(Sender: TObject);
begin
  ShowBigMap;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  DM.qryPartnerPhotos.Close;

  DM.qryPartnerPhotos.ParamByName('PartnerId').AsInteger := DM.qryPartnerId.AsInteger;
  DM.qryPartnerPhotos.ParamByName('ContractId').AsInteger := DM.qryPartnerCONTRACTID.AsInteger;

  DM.qryPartnerPhotos.Open;
end;

procedure TfrmMain.bClosePhotoClick(Sender: TObject);
begin
  CameraFree;
  ReturnPriorForm;
end;

procedure TfrmMain.bVisitClick(Sender: TObject);
begin
  FCanEditPartner := true;

  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.tMapToImageTimer(Sender: TObject);
{$IFDEF ANDROID}
var
  pic: JPicture;
  bmp: JBitmap;
  c: JCanvas;
  fos: JFileOutputStream;
  fn: string;
{$ENDIF}
begin
  tMapToImage.Enabled := false;

  {$IFDEF ANDROID}
  fn := TPath.Combine(TPath.GetDocumentsPath, 'mapscreen.jpg');
  pic := TJWebView.Wrap(FWebGMap.NativeBrowser).capturePicture;
  bmp := TJBitmap.JavaClass.createBitmap(pic.getWidth, pic.getHeight, TJBitmap_Config.JavaClass.ARGB_8888);
  c := TJCanvas.JavaClass.init(bmp);
  pic.draw(c);
  fos := TJFileOutputStream.JavaClass.init(StringToJString(fn));
  if Assigned(fos) then
  begin
    bmp.compress(TJBitmap_CompressFormat.JavaClass.JPEG, 100, fos);
    fos.close;
  end;
  iPartnerMap.Bitmap.LoadFromFile(fn);
  {$ELSE}
  iPartnerMap.Bitmap.Assign(FWebGMap.MakeScreenshot);
  {$ENDIF}

  pMap.Visible := false;
  pMapScreen.Visible := true;
  FWebGMap.Visible := false;
  FreeAndNil(FWebGMap);
end;

procedure TfrmMain.tSavePathTimer(Sender: TObject);
var
  GlobalId : TGUID;
begin
  tSavePath.Enabled := false;
  try
    GetCurrentCoordinates;
    if FCurCoordinatesSet then
    begin
      DM.tblMovement_RouteMember.Open;

      DM.tblMovement_RouteMember.Append;
      CreateGUID(GlobalId);
      DM.tblMovement_RouteMemberGUID.AsString := GUIDToString(GlobalId);
      DM.tblMovement_RouteMemberGPSN.AsFloat := FCurCoordinates.Latitude;
      DM.tblMovement_RouteMemberGPSE.AsFloat := FCurCoordinates.Longitude;
      DM.tblMovement_RouteMemberInsertDate.AsDateTime := Now();
      DM.tblMovement_RouteMemberisSync.AsBoolean := false;
      DM.tblMovement_RouteMember.Post;

      DM.tblMovement_RouteMember.Close;
    end;
  finally
    tSavePath.Enabled := true;
  end;
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
var
  i : integer;
begin
  if not FMapLoaded then
  begin
    FWebGMap.Markers.Clear;

    if FMarkerList.Count > 0 then
    begin
      for i := 0 to FMarkerList.Count - 1 do
      begin
        with FWebGMap.Markers.Add(FMarkerList[i].Latitude, FMarkerList[i].Longitude, GetAddress(FMarkerList[i].Latitude, FMarkerList[i].Longitude), '', True, True, False, True, False, 0, TMarkerIconColor.icDefault, -1, -1, -1, -1) do
          if tcMain.ActiveTab = tiPathOnMap then
            MapLabel.Text := IntToStr(i + 1)
          else
            MapLabel.Text := Title;
      end;

      FWebGMap.MapPanTo(FWebGMap.Markers[0].Latitude, FWebGMap.Markers[0].Longitude);
    end;

    FMapLoaded := True;

    if tcMain.ActiveTab = tiPartnerInfo then
      tMapToImage.Enabled := true;
  end;
end;

procedure TfrmMain.ShowBigMap;
begin
  SwitchToForm(tiMap, nil);

  FMapLoaded := False;

  FWebGMap := TTMSFMXWebGMaps.Create(Self);
  FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
  FWebGMap.Align := TAlignLayout.Client;
  FWebGMap.MapOptions.ZoomMap := 18;
  FWebGMap.Parent := tiMap;
end;

procedure TfrmMain.GetMapPartnerScreenshot(SetCordinate: boolean; Coordinates: TLocationCoord2D);
begin
  FMapLoaded := False;

  pMapScreen.Visible := false;
  pMap.Visible := true;
  FWebGMap := TTMSFMXWebGMaps.Create(Self);
  FWebGMap.Align := TAlignLayout.Client;
  FWebGMap.MapOptions.ZoomMap := 18;
  FWebGMap.Parent := pMap;
  FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
  if SetCordinate then
  begin
    FWebGMap.CurrentLocation.Latitude := Coordinates.Latitude;
    FWebGMap.CurrentLocation.Longitude := Coordinates.Longitude;
  end;
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
  if (tcMain.ActiveTab = tiStart) or (tcMain.ActiveTab = tiOrderItems) or (tcMain.ActiveTab = tiCamera)  then
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
      'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, P.PRICELISTID, C.PAIDKINDID, C.CHANGEPERCENT, PL.PRICEWITHVAT, PL.VATPERCENT ' +
      'from OBJECT_PARTNER P ' +
      'JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID and J.ISERASED = 0 ' +
      'JOIN Object_PriceList PL ON PL.ID = P.PRICELISTID and PL.ISERASED = 0 ' +
      'JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID and C.ISERASED = 0 where P.ISERASED = 0');

    First;
    while not EOF do
    begin
      Schedule := FieldbyName('Schedule').AsString;
      if Schedule.Length <> 13 then
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

procedure TfrmMain.ShowPartners(Day : integer; Caption : string);
var
  sQuery, CurGPSN, CurGPSE : string;
begin
  GetCurrentCoordinates;

  lDayInfo.Text := 'МАРШРУТ: ' + Caption;
  DM.qryPartner.Close;

  sQuery := 'select P.Id, P.CONTRACTID, J.VALUEDATA Name, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, ' +
    'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, P.PRICELISTID, C.PAIDKINDID, C.CHANGEPERCENT, PL.PRICEWITHVAT, PL.VATPERCENT ' +
    'from OBJECT_PARTNER P ' +
    'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 ' +
    'JOIN Object_PriceList PL ON PL.ID = P.PRICELISTID and PL.ISERASED = 0 ' +
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

  SwitchToForm(tiPartners, DM.qryPartner);
end;

procedure TfrmMain.ShowPartnerInfo;
var
  SetCordinate : boolean;
  Coordinates: TLocationCoord2D;
begin
  SwitchToForm(tiPartnerInfo, nil);
  tcPartnerInfo.ActiveTab := tiInfo;

  lPartnerName.Text := DM.qryPartnerName.AsString;
  lPartnerAddress.Text := DM.qryPartnerAddress.AsString;

  SetCordinate := true;
  FMarkerList.Clear;

  if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
  begin
    Coordinates := TLocationCoord2D.Create(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat);
    FMarkerList.Add(Coordinates);
  end
  else
  begin
    GetCurrentCoordinates;
    if FCurCoordinatesSet then
      Coordinates := TLocationCoord2D.Create(FCurCoordinates.Latitude, FCurCoordinates.Longitude)
    else
      SetCordinate := false;
  end;

  GetMapPartnerScreenshot(SetCordinate, Coordinates);

  DM.LoadOrderExternal;

  DM.LoadPhotoGroups;
end;

procedure TfrmMain.ShowPriceLists;
begin
  DM.qryPriceList.Open('select ID, VALUEDATA from OBJECT_PRICELIST where ISERASED = 0');

  SwitchToForm(tiPriceList, DM.qryPriceList);
end;

procedure TfrmMain.ShowPriceListItems;
begin
  DM.qryGoods.Open('select G.ID, G.VALUEDATA GoodsName, G.WEIGHT, G.OBJECTCODE, PLI.PRICE, PLI.ENDDATE, ' +
    'GG.VALUEDATA GroupName, M.VALUEDATA MeasureName from OBJECT_GOODS G ' +
    'JOIN OBJECT_PRICELISTITEMS PLI ON PLI.GOODSID = G.ID JOIN OBJECT_PRICELIST PL ON PL.ID = PLI.PRICELISTID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'LEFT JOIN OBJECT_GOODSGROUP GG ON GG.ID = G.GOODSGROUPID where G.ISERASED = 0 and PLI.PRICELISTID = ' + DM.qryPriceListId.AsString);

  SwitchToForm(tiPriceListItems, DM.qryGoods);
end;

procedure TfrmMain.ShowPathOnmap;
begin
  deDatePath.Date := Date();

  SwitchToForm(tiPathOnMap, nil);

  bRefreshPathOnMapClick(nil);
end;

procedure TfrmMain.ShowPhotos;
begin
  DM.qryPhotos.Open('select Id, Photo, Comment from MovementItem_Visit where MovementId = ' + DM.qryPhotoGroupsId.AsString);

  SwitchToForm(tiPhotosList, DM.qryPhotos);
end;

procedure TfrmMain.ShowPhoto;
var
  BlobStream: TStream;
begin
  ePhotoCommentEdit.Text := DM.qryPhotosComment.AsString;

  BlobStream := DM.qryPhotos.CreateBlobStream(DM.qryPhotosPhoto, TBlobStreamMode.bmRead);
  try
    imPhoto.Bitmap.LoadFromStream(BlobStream);
  finally
    BlobStream.Free;
  end;

  SwitchToForm(tiPhotoEdit, nil);
end;

procedure TfrmMain.RecalculateTotalPriceAndWeight;
var
 i : integer;
begin
  DM.cdsOrderItems.DisableControls;

  FOrderTotalPrice := 0;
  FOrderTotalCountKg := 0;

  DM.cdsOrderItems.First;
  while not DM.cdsOrderItems.Eof do
  begin
    if DM.qryPartnerPriceWithVAT.AsBoolean then
      FOrderTotalPrice := FOrderTotalPrice + DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat *
        (100 + DM.qryPartnerChangePercent.AsCurrency) / 100
    else
      FOrderTotalPrice := FOrderTotalPrice + DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat *
        ((100 + DM.qryPartnerChangePercent.AsCurrency) / 100) * ((100 + DM.qryPartnerVATPercent.AsCurrency) / 100);

    if FormatFloat('0.##', DM.cdsOrderItemsWeight.AsFloat) <> '0' then
      FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsWeight.AsFloat * DM.cdsOrderItemsCount.AsFloat
    else
      FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsCount.AsFloat;

    DM.cdsOrderItems.Next;
  end;

  DM.cdsOrderItems.EnableControls;

  lTotalPrice.Text := 'Общая стоимость (с учетом НДС) : ' + FormatFloat('0.00', FOrderTotalPrice);



  lTotalWeight.Text := 'Общий вес : ' + FormatFloat('0.00', FOrderTotalCountKg);
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

procedure TfrmMain.ReturnPriorForm(const OmitOnChange: Boolean);
var
  Item: TFormStackItem;
  OnChange: TNotifyEvent;
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.EmptyDataSet;
    DM.cdsOrderItems.Close;
  end;

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

      try
        if Item.Data <> nil then
          TFDQuery(Item.Data).Close;
      except
      end;
    end
  else
    raise Exception.Create('Forms stack underflow');
end;

procedure TfrmMain.PrepareCamera;
begin
  SwitchToForm(tiCamera, nil);

  FCameraZoomDistance := 0;

  CameraComponent := TCameraComponent.Create(nil);
  CameraComponent.OnSampleBufferReady := CameraComponentSampleBufferReady;
  if CameraComponent.HasFlash then
    CameraComponent.FlashMode := FMX.Media.TFlashMode.AutoFlash;
  CameraComponent.Active := false;
  bCaptureClick(bCapture);
end;

procedure TfrmMain.CameraFree;
begin
  try
    if Assigned(CameraComponent) then
    begin
      CameraComponent.Active := False;
      FreeAndNil(CameraComponent);
    end;
  except
    On E: Exception do
      Showmessage(E.Message);
  end;
end;

procedure TfrmMain.cbShowAllPathChange(Sender: TObject);
begin
  deDatePath.Enabled := not cbShowAllPath.IsChecked;
end;

procedure TfrmMain.GetImage;
begin
  CameraComponent.SampleBufferToBitmap(imgCameraPreview.Bitmap, True);
end;

procedure TfrmMain.ScaleImage(const Margins: Integer);
begin
  imgCameraPreview.Margins.Left := 5 + Margins;
  imgCameraPreview.Margins.Right := 5 + Margins;
  imgCameraPreview.Margins.Top := 5 + Margins;
  imgCameraPreview.Margins.Bottom := 5 + Margins;
end;

procedure TfrmMain.PlayAudio;
var
  MediaPlayer: TMediaPlayer;
  TmpFile: string;
begin
 { MediaPlayer := TMediaPlayer.Create(nil);
  try
    TmpFile := TPath.Combine(TPath.GetDocumentsPath, 'CameraClick.3gp');
    MediaPlayer.FileName := TmpFile;

    if MediaPlayer.Media <> nil then
      MediaPlayer.Play
    else
    begin
      TmpFile := TPath.Combine(TPath.GetDocumentsPath, 'CameraClick.mp3');
      MediaPlayer.FileName := TmpFile;
      if MediaPlayer.Media <> nil then
        MediaPlayer.Play
    end;
    sleep(1000);
    MediaPlayer.Stop;
    MediaPlayer.Clear;
  finally
    FreeAndNil(MediaPlayer);
  end; }
end;

procedure TfrmMain.CameraComponentSampleBufferReady
  (Sender: TObject; const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, GetImage);
  if (imgCameraPreview.Width = 0) or (imgCameraPreview.Height = 0) then
    Showmessage('Image is zero!');
end;

procedure TfrmMain.GetCurrentCoordinates;
{$IFDEF ANDROID}
var
  LastLocation: JLocation;
  LocManagerObj: JObject;
  LocationManager: JLocationManager;
{$ENDIF}
begin
  FCurCoordinatesSet := false;

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
  {$ENDIF}
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
