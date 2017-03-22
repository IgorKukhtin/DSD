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
  FMX.Grid.Style, FMX.Media, FMX.Surfaces, FMX.VirtualKeyboard, FMX.SearchBox, IniFiles
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
    ppGoodsInfo: TPopup;
    pGoodsInfo: TPanel;
    lGoodsName: TLabel;
    Label10: TLabel;
    lGoodsCode: TLabel;
    lGoodsType: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    lGoodsWeight: TLabel;
    Label22: TLabel;
    lGoodsPrice: TLabel;
    tiOrderExternal: TTabItem;
    VertScrollBox3: TVertScrollBox;
    tiGoodsItems: TTabItem;
    Panel3: TPanel;
    bCancelOI: TButton;
    bSaveOI: TButton;
    Panel4: TPanel;
    lwPartner: TListView;
    bsPartner: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    ilPartners: TImageList;
    pOrderTotals: TPanel;
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
    Panel11: TPanel;
    tiPhotos: TTabItem;
    Panel12: TPanel;
    Panel13: TPanel;
    bAddedPhotoGroup: TButton;
    bCapture: TButton;
    bSavePartnerPhoto: TButton;
    bClosePhoto: TButton;
    lwPartnerPhotoGroups: TListView;
    lwOrderExternalItems: TListView;
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
    lwGoodsItems: TListView;
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
    lwOrderExternalList: TListView;
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
    lwStoreRealList: TListView;
    Panel21: TPanel;
    bNewStoreReal: TButton;
    tiStoreReal: TTabItem;
    VertScrollBox5: TVertScrollBox;
    Panel23: TPanel;
    bSaveStoreReal: TButton;
    lwStoreRealItems: TListView;
    Panel24: TPanel;
    Label33: TLabel;
    eStoreRealComment: TEdit;
    bsStoreReals: TBindSourceDB;
    LinkListControlToField8: TLinkListControlToField;
    bAddStoreRealItem: TButton;
    Image14: TImage;
    bsStoreRealItems: TBindSourceDB;
    LinkListControlToField9: TLinkListControlToField;
    lPriceWithPercent: TLabel;
    Label13: TLabel;
    lGoodsMeasure: TLabel;
    bsGoodsForPriceList: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    pPhotoComment: TPanel;
    bSavePhoto: TButton;
    bCancelPhoto: TButton;
    ePhotoComment: TEdit;
    Label15: TLabel;
    lPromoPrice: TLabel;
    pShowOnlyPromo: TPanel;
    cbOnlyPromo: TCheckBox;
    lNoMap: TLabel;
    lwReturnInList: TListView;
    Panel2: TPanel;
    bNewReturnIn: TButton;
    tiReturnIn: TTabItem;
    lwReturnInItems: TListView;
    Panel6: TPanel;
    lReturnInPrice: TLabel;
    Label34: TLabel;
    bAddReturnInItem: TButton;
    Image9: TImage;
    Panel17: TPanel;
    bSaveReturnIn: TButton;
    Panel22: TPanel;
    Label35: TLabel;
    deReturnDate: TDateEdit;
    pReturnInTotals: TPanel;
    lTotalPriceReturn: TLabel;
    lTotalWeightReturn: TLabel;
    lPriceWithPercentReturn: TLabel;
    Panel26: TPanel;
    Label20: TLabel;
    eReturnComment: TEdit;
    bsReturnInItems: TBindSourceDB;
    LinkListControlToField10: TLinkListControlToField;
    bsReturnIn: TBindSourceDB;
    LinkListControlToField11: TLinkListControlToField;
    bSyncData: TButton;
    pProgress: TPanel;
    Layout6: TLayout;
    pieProgress: TPie;
    pieAllProgress: TPie;
    Pie3: TPie;
    lProgress: TLabel;
    lProgressName: TLabel;
    Pie1: TPie;
    Panel25: TPanel;
    Panel27: TPanel;
    cbLoadData: TCheckBox;
    cbUploadData: TCheckBox;
    tErrorMap: TTimer;
    bRefreshMapScreen: TButton;
    Image15: TImage;
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
    procedure lwGoodsItemsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwGoodsItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwGoodsItemsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bCancelOIClick(Sender: TObject);
    procedure bSaveOIClick(Sender: TObject);
    procedure bSaveOrderExternalClick(Sender: TObject);
    procedure bAddedPhotoGroupClick(Sender: TObject);
    procedure bCaptureClick(Sender: TObject);
    procedure bSavePartnerPhotoClick(Sender: TObject);
    procedure bClosePhotoClick(Sender: TObject);
    procedure bAddOrderItemClick(Sender: TObject);
    procedure lwOrderExternalItemsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure b0Click(Sender: TObject);
    procedure bClearAmountClick(Sender: TObject);
    procedure bEnterAmountClick(Sender: TObject);
    procedure bAddAmountClick(Sender: TObject);
    procedure lwOrderExternalItemsFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure bMinusAmountClick(Sender: TObject);
    procedure tMapToImageTimer(Sender: TObject);
    procedure lwOrderExternalListItemClickEx(const Sender: TObject;
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
    procedure lwOrderExternalItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderExternalListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPartnerUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPhotosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure bSavePhotoCommentClick(Sender: TObject);
    procedure lwStoreRealListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwStoreRealListItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwStoreRealItemsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure lwStoreRealItemsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lwStoreRealItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bNewStoreRealClick(Sender: TObject);
    procedure bSaveStoreRealClick(Sender: TObject);
    procedure bAddStoreRealItemClick(Sender: TObject);
    procedure lwPartnerPhotoGroupsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lwGoodsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure pGoodsInfoClick(Sender: TObject);
    procedure bSavePhotoClick(Sender: TObject);
    procedure bCancelPhotoClick(Sender: TObject);
    procedure cbOnlyPromoChange(Sender: TObject);
    procedure lwReturnInListItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwReturnInListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bAddReturnInItemClick(Sender: TObject);
    procedure bSaveReturnInClick(Sender: TObject);
    procedure bNewReturnInClick(Sender: TObject);
    procedure bSyncDataClick(Sender: TObject);
    procedure bSyncClick(Sender: TObject);
    procedure tErrorMapTimer(Sender: TObject);
    procedure bRefreshMapScreenClick(Sender: TObject);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;

    FCanEditPartner : boolean;

    FOldGoodsItemIndex : integer;

    FCurCoordinatesSet: boolean;
    FCurCoordinates: TLocationCoord2D;
    FMapLoaded: Boolean;
    FMarkerList: TList<TLocationCoord2D>;
    FWebGMap: TTMSFMXWebGMaps;

    FKBBounds: TRectF;
    FNeedOffset: Boolean;

    FCheckedGooodsItems: TList<String>;
    OldOrderExternalId : string;
    FDeletedOI: TList<Integer>;
    FOrderTotalCountKg : Currency;
    FOrderTotalPrice : Currency;
    OldStoreRealId : string;
    FDeletedSRI: TList<Integer>;
    OldReturnInId : string;
    FDeletedRI: TList<Integer>;
    FReturnInTotalCountKg : Currency;
    FReturnInTotalPrice : Currency;

    FCameraZoomDistance: Integer;
    CameraComponent : TCameraComponent;

    procedure OnCloseDialog(const AResult: TModalResult);
    procedure BackResult(const AResult: TModalResult);
    procedure DeleteOrderExtrernal(const AResult: TModalResult);
    procedure DeleteStoreReal(const AResult: TModalResult);
    procedure DeleteReturnIn(const AResult: TModalResult);
    procedure EditStoreReal(const AResult: TModalResult);
    procedure SetPartnerCoordinates(const AResult: TModalResult);

    procedure UpdateKBBounds;
    procedure RestorePosition;
    function PrependIfNotEmpty(const Prefix, Subject: string): string;

    function GetAddress(const Latitude, Longitude: Double): string;
    //function GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
    procedure WebGMapDownloadFinish(Sender: TObject);
    procedure ShowBigMap;
    procedure GetMapPartnerScreenshot(GPSN, GPSE: Double);

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
    procedure AddedNewStoreRealItems;
    procedure AddedNewOrderItems;
    procedure AddedNewReturnInItems;
    procedure RecalculateTotalPriceAndWeight;
    procedure RecalculateReturnInTotalPriceAndWeight;
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
  uConstants, System.IOUtils, Authentication, Storage, CommonData, uDM, CursorUtils,
  uNetwork;

{$R *.fmx}

resourcestring
  rstCapture = 'Capture';
  rstReturn = 'Return';

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
  r : integer;
  SettingsFile : TIniFile;
begin
  FormatSettings.DecimalSeparator := '.';

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create('settings.ini');
  {$ENDIF}
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');
  finally
    FreeAndNil(SettingsFile);
  end;

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
  FCheckedGooodsItems := TList<String>.Create;
  FDeletedOI := TList<Integer>.Create;
  FDeletedSRI := TList<Integer>.Create;
  FDeletedRI := TList<Integer>.Create;
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
  FCheckedGooodsItems.Free;
  FDeletedSRI.Free;
  FDeletedRI.Free;
  FDeletedOI.Free;
end;

procedure TfrmMain.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  if Key = vkHardwareBack then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      // Back button pressed, keyboard visible, so do nothing...
    end else
    begin
      Key := 0;

      if pNewPhotoGroup.Visible then
        bCanclePGClick(bCanclePG)
      else
      if pPhotoComment.Visible then
        bCancelPhotoClick(bCancelPhoto)
      else
      if tcMain.ActiveTab = tiStart then
        MessageDlg('Закрыть программу?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], -1, OnCloseDialog)
      else
      if tcMain.ActiveTab = tiGoodsItems then
        bCancelOIClick(bCancelOI)
      else
      if tcMain.ActiveTab = tiCamera then
        bClosePhotoClick(bClosePhoto)
      else
      if tcMain.ActiveTab = tiMain then
        bReloginClick(bRelogin)
      else
        sbBackClick(sbBack);
    end;
  end;
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

  lCaption.Text := 'Карта (Все ТТ)';
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

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  LoginOk : boolean;
  SettingsFile : TIniFile;
begin
  LoginOk := false;

  if assigned(gc_User) then  { Проверяем только с данными из локальной БД }
  begin
    {$IFNDEF NotCheckLogin}
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

      Wait(False);

      if ErrorMessage = '' then
      begin
        LoginOk := true;

        DM.SynchronizeWithMainDatabase;
      end
      else
      begin
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
  begin
    {$IF DEFINED(iOS) or DEFINED(ANDROID)}
    SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
    {$ELSE}
    SettingsFile := TIniFile.Create('settings.ini');
    {$ENDIF}
    try
      SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
    finally
      FreeAndNil(SettingsFile);
    end;

    SwitchToForm(tiMain, nil);
  end;
end;

procedure TfrmMain.lwGoodsFilter(Sender: TObject; const AFilter, AValue: string;
  var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwGoodsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if ppGoodsInfo.IsOpen then
  begin
    ppGoodsInfo.IsOpen := false;

    if FOldGoodsItemIndex = AItem.Index then
      exit;
  end;

  FOldGoodsItemIndex := AItem.Index;

  lGoodsName.Text := DM.qryGoodsForPriceListGoodsName.AsString;
  lGoodsCode.Text := DM.qryGoodsForPriceListOBJECTCODE.AsString;
  lGoodsType.Text := DM.qryGoodsForPriceListKindName.AsString;
  lGoodsMeasure.Text := DM.qryGoodsForPriceListMeasureName.AsString;
  lGoodsWeight.Text := DM.qryGoodsForPriceListWeight.AsString;
  lGoodsPrice.Text := DM.qryGoodsForPriceListOrderPrice.AsString;

  ppGoodsInfo.IsOpen := true;
end;

procedure TfrmMain.lwOrderExternalItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwOrderExternalItemsItemClickEx(const Sender: TObject;
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
  end
  else
  if (ItemObject.Name = 'Count') or (ItemObject.Name = 'Measure') then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsOrderItemsMeasure.AsString;

    ppEnterAmount.IsOpen := true;
  end;
end;

procedure TfrmMain.lwOrderExternalItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
end;

procedure TfrmMain.lwOrderExternalListItemClickEx(const Sender: TObject;
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
  end
  else
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

procedure TfrmMain.lwOrderExternalListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemImage(AItem.Objects.FindDrawable('EditButton')).ImageIndex := 1;
end;

procedure TfrmMain.lwGoodsItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
var
  GoodsName : string;
  IsPromo : boolean;
begin
  if copy(AValue, Length(AValue), 1) = '1' then
    IsPromo := true
  else
    IsPromo := false;

  if Trim(AFilter) <> '' then
  begin
    GoodsName := copy(AValue, 1, Length(AValue) - 2);
    Accept := GoodsName.ToUpper.Contains(AFilter.ToUpper);
  end
  else
    Accept := true;

  if cbOnlyPromo.Visible and cbOnlyPromo.IsChecked then
    Accept := Accept and IsPromo;
end;

procedure TfrmMain.lwGoodsItemsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible then
  begin
    (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := False;
    FCheckedGooodsItems.Remove((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
  end
  else
  begin
    (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := True;
    FCheckedGooodsItems.Add((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
  end;
end;

procedure TfrmMain.lwGoodsItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  (AItem.Objects.FindDrawable('PromoPrice') as TListItemDrawable).Visible := lPromoPrice.Visible;

  (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := FCheckedGooodsItems.Contains((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
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

procedure TfrmMain.lwPartnerPhotoGroupsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  AItem.ImageIndex := 0;
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
      DM.qryPhotos.Delete
    else
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

procedure TfrmMain.lwReturnInListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then
  begin
    MessageDlg('Удалить возврат на ' + FormatDateTime('DD.MM.YYYY', DM.cdsReturnInOperDate.AsDateTime) + '?',
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               DeleteReturnIn);
  end
  else
  if ItemObject.Name = 'EditButton' then
  begin
    if DM.qryPartnerPriceWithVAT.AsBoolean then
      lReturnInPrice.Text := 'Цена (с НДС)'
    else
      lReturnInPrice.Text := 'Цена (без НДС)';

    DM.LoadReturnInItems(DM.cdsReturnInId.AsInteger);
    FDeletedRI.Clear;

    RecalculateReturnInTotalPriceAndWeight;

    OldReturnInId := DM.cdsReturnInId.AsString;
    deReturnDate.Date := DM.cdsReturnInOperDate.AsDateTime;
    eReturnComment.Text := DM.cdsReturnInComment.AsString;

    SwitchToForm(tiReturnIn, nil);
  end;
end;

procedure TfrmMain.lwReturnInListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemImage(AItem.Objects.FindDrawable('EditButton')).ImageIndex := 1;
end;

procedure TfrmMain.lwStoreRealItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwStoreRealItemsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then
  begin
    if DM.cdsStoreRealItemsId.AsInteger <> -1 then
      FDeletedSRI.Add(DM.cdsStoreRealItemsId.AsInteger);
    DM.cdsStoreRealItems.Delete;


    RecalculateTotalPriceAndWeight;
  end
  else
  if (ItemObject.Name = 'Count') or (ItemObject.Name = 'Measure') then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsStoreRealItemsMeasure.AsString;

    ppEnterAmount.IsOpen := true;
  end;
end;

procedure TfrmMain.lwStoreRealListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then
  begin
    MessageDlg('Удалить остатки на ' + FormatDateTime('DD.MM.YYYY', DM.cdsStoreRealsOperDate.AsDateTime) + '?',
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               DeleteStoreReal);
  end
  else
  if ItemObject.Name = 'EditButton' then
  begin
    FDeletedSRI.Clear;
    FCheckedGooodsItems.Clear;

    OldStoreRealId := DM.cdsStoreRealsId.AsString;
    eStoreRealComment.Text := DM.cdsStoreRealsComment.AsString;

    DM.LoadStoreRealItems(DM.cdsStoreRealsId.AsInteger);

    SwitchToForm(tiStoreReal, nil);
  end;
end;

procedure TfrmMain.lwStoreRealListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemImage(AItem.Objects.FindDrawable('EditButton')).ImageIndex := 1;
end;

procedure TfrmMain.lwStoreRealItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemText(AItem.Objects.FindDrawable('Lable')).Text := 'Фактический остаток';
end;

procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  if lAmount.Text = '-0' then
    lAmount.Text := '-';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

procedure TfrmMain.pGoodsInfoClick(Sender: TObject);
begin
  ppGoodsInfo.IsOpen := false;
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

procedure TfrmMain.DeleteStoreReal(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.conMain.ExecSQL('update Movement_StoreReal set STATUSID = ' + DM.tblObject_ConstStatusId_Erased.AsString +
      ' where ID = ' + DM.cdsStoreRealsId.AsString);

    DM.cdsStoreReals.Delete;
  end;
end;

procedure TfrmMain.DeleteReturnIn(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.conMain.ExecSQL('update Movement_ReturnIn set STATUSID = ' + DM.tblObject_ConstStatusId_Erased.AsString +
      ' where ID = ' + DM.cdsReturnInId.AsString);

    DM.cdsReturnIn.Delete;
  end;
end;

procedure TfrmMain.EditStoreReal(const AResult: TModalResult);
begin
  if AResult = mrNone then
  begin
    FDeletedSRI.Clear;
    FCheckedGooodsItems.Clear;

    OldStoreRealId := '';
    eStoreRealComment.Text := '';
    DM.DefaultStoreRealItems;

    SwitchToForm(tiStoreReal, nil);
  end
  else
  if AResult = mrYes then
  begin
    FDeletedSRI.Clear;
    FCheckedGooodsItems.Clear;

    OldStoreRealId := DM.cdsStoreRealsId.AsString;
    eStoreRealComment.Text := DM.cdsStoreRealsComment.AsString;

    DM.LoadStoreRealItems(DM.cdsStoreRealsId.AsInteger);

    SwitchToForm(tiStoreReal, nil);
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

      GetMapPartnerScreenshot(FCurCoordinates.Latitude, FCurCoordinates.Longitude);
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
      Mes := 'Выйти без сохранения заявки?'
    else
      Mes := 'Выйти из редактирования без сохранения?';

    MessageDlg(Mes,
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               BackResult);
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    if OldStoreRealId = '' then
      Mes := 'Выйти без сохранения остатков?'
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
end;

procedure TfrmMain.bAddOrderItemClick(Sender: TObject);
begin
  DM.GenerateOrderExtrenalItemsList;

  lPromoPrice.Visible := true;
  pShowOnlyPromo.Visible := true;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

procedure TfrmMain.bAddReturnInItemClick(Sender: TObject);
begin
  DM.GenerateReturnInItemsList;

  lPromoPrice.Visible := false;
  pShowOnlyPromo.Visible := false;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

procedure TfrmMain.bAddStoreRealItemClick(Sender: TObject);
begin
  DM.GenerateStoreRealItemsList;

  lPromoPrice.Visible := false;
  pShowOnlyPromo.Visible := false;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

procedure TfrmMain.bCancelOIClick(Sender: TObject);
begin
  FCheckedGooodsItems.Clear;

  ReturnPriorForm;
end;

procedure TfrmMain.bCancelPhotoClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pPhotoComment.Visible := false;
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
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    DM.cdsOrderItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsOrderItems.Post;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    DM.cdsStoreRealItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    DM.cdsReturnInItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  ppEnterAmount.IsOpen := false;
end;

procedure TfrmMain.bAddAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsOrderItems.Post;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    DM.cdsStoreRealItemsCount.AsFloat := DM.cdsStoreRealItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    DM.cdsReturnInItemsCount.AsFloat := DM.cdsReturnInItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  ppEnterAmount.IsOpen := false;
end;

procedure TfrmMain.bMinusAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    if DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
      DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
    else
      DM.cdsOrderItemsCount.AsFloat := 0;
    DM.cdsOrderItems.Post;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    if DM.cdsStoreRealItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
      DM.cdsStoreRealItemsCount.AsFloat := DM.cdsStoreRealItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
    else
      DM.cdsStoreRealItemsCount.AsFloat := 0;
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    if DM.cdsReturnInItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
      DM.cdsReturnInItemsCount.AsFloat := DM.cdsReturnInItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
    else
      DM.cdsReturnInItemsCount.AsFloat := 0;
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  ppEnterAmount.IsOpen := false;
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
  FDeletedOI.Clear;
  FCheckedGooodsItems.Clear;

  deOperDate.Date := Date();
  DM.DefaultOrderExternalItems;

  SwitchToForm(tiOrderExternal, nil);
end;

procedure TfrmMain.bNewStoreRealClick(Sender: TObject);
var
  FindRec : boolean;
begin
  FindRec := false;
  if DM.cdsStoreReals.Locate('OperDate', Date(), []) then
    FindRec := true;

  if FindRec then
    MessageDlg('Остатки на сегодняшнее число уже введены. Перейти к их редактированию?',
               System.UITypes.TMsgDlgType.mtWarning, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
               EditStoreReal)
  else
    EditStoreReal(mrNone);
end;

procedure TfrmMain.bPartnersClick(Sender: TObject);
begin
  ShowPartners(8, 'Все ТТ');
end;

procedure TfrmMain.bPathonMapClick(Sender: TObject);
begin
  ShowPathOnMap;
end;

procedure TfrmMain.bPriceListClick(Sender: TObject);
begin
  ShowPriceLists;
end;

procedure TfrmMain.bRefreshMapScreenClick(Sender: TObject);
begin
  GetMapPartnerScreenshot(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat);
end;

procedure TfrmMain.bRefreshPathOnMapClick(Sender: TObject);
var
 i: integer;
 RouteQuery: TFDQuery;
begin
  FMarkerList.Clear;

  RouteQuery := TFDQuery.Create(nil);
  try
    RouteQuery.Connection := DM.conMain;
    try
      if not cbShowAllPath.IsChecked then
        RouteQuery.Open('select * from Movement_RouteMember')
      else
        RouteQuery.Open('select * from Movement_RouteMember where date(InsertDate) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', deDatePath.Date)));
    except
      on E: Exception do
        Showmessage(E.Message);
    end;

    RouteQuery.First;
    while not RouteQuery.EOF do
    begin
      FMarkerList.Add(TLocationCoord2D.Create(RouteQuery.FieldByName('GPSN').AsFloat, RouteQuery.FieldByName('GPSE').AsFloat));

      RouteQuery.Next;
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
  finally
    FreeAndNil(RouteQuery);
  end;
end;

procedure TfrmMain.bReloginClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

procedure TfrmMain.bRouteClick(Sender: TObject);
begin
  FCanEditPartner := false;

  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.bSaveOIClick(Sender: TObject);
begin
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
begin
  vsbMain.Enabled := false;
  pPhotoComment.Visible := true;
end;

procedure TfrmMain.bSavePGClick(Sender: TObject);
begin
  DM.SavePhotoGroup(ePhotoGroupName.Text);

  DM.qryPhotoGroups.Refresh;

  vsbMain.Enabled := true;
  pNewPhotoGroup.Visible := false;
end;

procedure TfrmMain.bSavePhotoClick(Sender: TObject);
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

        ShowMessage('Фотография успешно сохранена');

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

  vsbMain.Enabled := true;
  pPhotoComment.Visible := false;

  CameraFree;
  ReturnPriorForm;
end;

procedure TfrmMain.bSavePhotoCommentClick(Sender: TObject);
begin
  DM.qryPhotos.Edit;
  DM.qryPhotosComment.AsString := ePhotoCommentEdit.Text;
  DM.qryPhotos.Post;

  ReturnPriorForm;
end;

procedure TfrmMain.bSaveReturnInClick(Sender: TObject);
var
  i : integer;
  ErrMes: string;
  DelItems: string;
begin
   DelItems := '';
   if FDeletedRI.Count > 0 then
   begin
     DelItems := IntToStr(FDeletedRI[0]);
     for i := 1 to FDeletedRI.Count - 1 do
       DelItems := ',' + IntToStr(FDeletedRI[i]);
   end;

   if DM.SaveReturnIn(OldReturnInId, deReturnDate.Date, eReturnComment.Text,
     FReturnInTotalPrice, FReturnInTotalCountKg, DelItems, ErrMes) then
   begin
     ShowMessage('Сохранение заявки прошло успешно.');
     ReturnPriorForm;
   end
   else
     ShowMessage(ErrMes);
end;

procedure TfrmMain.bSaveStoreRealClick(Sender: TObject);
var
  i : integer;
  ErrMes: string;
  DelItems: string;
begin
   DelItems := '';
   if FDeletedSRI.Count > 0 then
   begin
     DelItems := IntToStr(FDeletedSRI[0]);
     for i := 1 to FDeletedSRI.Count - 1 do
       DelItems := ',' + IntToStr(FDeletedSRI[i]);
   end;

   if DM.SaveStoreReal(OldStoreRealId, eStoreRealComment.Text, DelItems, ErrMes) then
   begin
     ShowMessage('Сохранение остатков прошло успешно.');
     ReturnPriorForm;
   end
   else
     ShowMessage(ErrMes);
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
  lCaption.Text := 'Карта (' + DM.qryPartnerName.AsString + ')';

  ShowBigMap;
end;

procedure TfrmMain.bSyncClick(Sender: TObject);
begin
  SwitchToForm(tiSync, nil);
end;

procedure TfrmMain.bSyncDataClick(Sender: TObject);
begin
  DM.SynchronizeWithMainDatabase(cbLoadData.IsChecked, cbUploadData.IsChecked);
end;

procedure TfrmMain.bNewReturnInClick(Sender: TObject);
begin
  if DM.qryPartnerPriceWithVAT.AsBoolean then
    lReturnInPrice.Text := 'Цена (с НДС)'
  else
    lReturnInPrice.Text := 'Цена (без НДС)';

  OldReturnInId := '';
  FDeletedRI.Clear;
  FCheckedGooodsItems.Clear;

  deReturnDate.Date := Date();
  eReturnComment.Text := '';
  DM.DefaultReturnInItems;

  SwitchToForm(tiReturnIn, nil);
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

procedure TfrmMain.tErrorMapTimer(Sender: TObject);
begin
  tErrorMap.Enabled := false;

  vsbMain.Enabled := true;
  FMapLoaded := true;

  FWebGMap.Visible := false;
  FreeAndNil(FWebGMap);

  bRefreshMapScreen.Visible := true;
  lNoMap.Visible := true;
  lNoMap.Text := 'Не удалось загрузить карту с расположением ТТ';

  pMapScreen.Visible := false;
  pMap.Visible := true;
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

  vsbMain.Enabled := true;

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
  {FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;}
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  {FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;}
end;

procedure TfrmMain.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  {FNeedOffset := False;
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
    RestorePosition;}
end;

procedure TfrmMain.RestorePosition;
begin
  {vsbMain.ViewportPosition := PointF(vsbMain.ViewportPosition.X, 0);
  tcMain.Align := TAlignLayout.Client;
  vsbMain.RealignContent;}
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
    tErrorMap.Enabled := false;
    FMapLoaded := True;

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

procedure TfrmMain.GetMapPartnerScreenshot(GPSN, GPSE: Double);
var
  MobileNetworkStatus : TMobileNetworkStatus;
  isConnected : boolean;
  SetCordinate: boolean;
  Coordinates: TLocationCoord2D;
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  MobileNetworkStatus := TMobileNetworkStatus.Create;
  try
    isConnected := MobileNetworkStatus.isConnected;
  finally
    FreeAndNil(MobileNetworkStatus);
  end;
  {$ELSE}
  isConnected := true;
  {$ENDIF}

  if isConnected then
  begin
    SetCordinate := true;
    FMarkerList.Clear;

    if (GPSN <> 0) and (GPSE <> 0) then
    begin
      Coordinates := TLocationCoord2D.Create(GPSN, GPSE);
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

    bRefreshMapScreen.Visible := false;
    lNoMap.Visible := false;

    FMapLoaded := False;

    pMapScreen.Visible := false;
    pMap.Visible := true;
    FWebGMap := TTMSFMXWebGMaps.Create(Self);
    FWebGMap.Align := TAlignLayout.Client;
    FWebGMap.ControlsOptions.PanControl.Visible := false;
    FWebGMap.ControlsOptions.ZoomControl.Visible := false;
    FWebGMap.ControlsOptions.MapTypeControl.Visible := false;
    FWebGMap.ControlsOptions.ScaleControl.Visible := false;
    FWebGMap.ControlsOptions.StreetViewControl.Visible := false;
    FWebGMap.ControlsOptions.OverviewMapControl.Visible := false;
    FWebGMap.ControlsOptions.RotateControl.Visible := false;
    FWebGMap.MapOptions.ZoomMap := 18;
    FWebGMap.Parent := pMap;
    FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
    if SetCordinate then
    begin
      FWebGMap.CurrentLocation.Latitude := Coordinates.Latitude;
      FWebGMap.CurrentLocation.Longitude := Coordinates.Longitude;
    end;

    vsbMain.Enabled := false;
    tErrorMap.Enabled := true;
  end
  else
  begin
    bRefreshMapScreen.Visible := true;
    lNoMap.Visible := true;
    lNoMap.Text := 'Без соединения с интернет нельзя получить карту с расположением ТТ';

    pMapScreen.Visible := false;
    pMap.Visible := true;
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
var
  i : integer;
begin
  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  { настройка панели возврата }
  if (tcMain.ActiveTab = tiStart) or (tcMain.ActiveTab = tiGoodsItems) or (tcMain.ActiveTab = tiCamera)  then
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

    if tcMain.ActiveTab = tiPartnerInfo then
    begin
      lCaption.Text := DM.qryPartnerName.AsString;
    end
    else
    if tcMain.ActiveTab = tiRoutes then
      lCaption.Text := 'Маршруты'
    else
    if tcMain.ActiveTab = tiPartners then
      lCaption.Text := 'Торговые точки'
    else
    if tcMain.ActiveTab = tiHandbook then
      lCaption.Text := 'Справочники'
    else
    if tcMain.ActiveTab = tiPriceList then
      lCaption.Text := 'Прайс-лист'
    else
    if tcMain.ActiveTab = tiPathOnMap then
      lCaption.Text := 'Маршрут контрагента'
    else
    if tcMain.ActiveTab = tiSync then
      lCaption.Text := 'Синхронизация'
    else
    if tcMain.ActiveTab = tiOrderExternal then
      lCaption.Text := 'Заявки (' + DM.qryPartnerName.AsString + ')'
    else
    if tcMain.ActiveTab = tiStoreReal then
      lCaption.Text := 'Остатки (' + DM.qryPartnerName.AsString + ')'
    else
    if tcMain.ActiveTab = tiReturnIn then
      lCaption.Text := 'Возврат (' + DM.qryPartnerName.AsString + ')';
  end;

  if tcMain.ActiveTab = tiPartners then
    sbPartnerMenu.Visible := true
  else
    sbPartnerMenu.Visible := false;

  if tcMain.ActiveTab = tiStart then
    CheckDataBase;

  if tcMain.ActiveTab = tiRoutes then
    GetVistDays;

  if tcMain.ActiveTab = tiStoreReal then
    AddedNewStoreRealItems;

  if tcMain.ActiveTab = tiOrderExternal then
    AddedNewOrderItems;

  if tcMain.ActiveTab = tiReturnIn then
    AddedNewReturnInItems;

  if tcMain.ActiveTab = tiGoodsItems then
    for I := 0 to lwGoodsItems.Controls.Count-1 do
    if lwGoodsItems.Controls[I].ClassType = TSearchBox then
    begin
      TSearchBox(lwGoodsItems.Controls[I]).Text := '';
    end;
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

  if DM.tblObject_Const.Active then
    DM.tblObject_Const.Close;
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
    FreeAndNil(gc_User);
    gc_WebService := '';

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
    Open(BasePartnerQuery);

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

  sQuery := BasePartnerQuery;

  if Day < 8 then
    sQuery := sQuery + ' and lower(substr(P.SCHEDULE, ' + IntToStr(2 * Day - 1) + ', 1)) = ''t''';

  if FCurCoordinatesSet then
  begin
    CurGPSN := FloatToStr(FCurCoordinates.Latitude);
    CurGPSE := FloatToStr(FCurCoordinates.Longitude);
    CurGPSN := StringReplace(CurGPSN, ',', '.', [rfReplaceAll]);
    CurGPSE := StringReplace(CurGPSE, ',', '.', [rfReplaceAll]);

    sQuery := sQuery + ' order by ((IFNULL(P.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') * ' +
      '((IFNULL(P.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') + ' +
      '((IFNULL(P.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ') * ' +
      '((IFNULL(P.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ')';
  end;

  DM.qryPartner.Open(sQuery);

  SwitchToForm(tiPartners, DM.qryPartner);
end;

procedure TfrmMain.ShowPartnerInfo;
begin
  SwitchToForm(tiPartnerInfo, nil);
  tcPartnerInfo.ActiveTab := tiInfo;

  lPartnerName.Text := DM.qryPartnerName.AsString;
  lPartnerAddress.Text := DM.qryPartnerAddress.AsString;


  GetMapPartnerScreenshot(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat);

  DM.LoadStoreReal;

  DM.LoadOrderExternal;

  DM.LoadReturnIn;

  DM.LoadPhotoGroups;
end;

procedure TfrmMain.ShowPriceLists;
begin
  DM.qryPriceList.Open('select ID, VALUEDATA from OBJECT_PRICELIST where ISERASED = 0');

  SwitchToForm(tiPriceList, DM.qryPriceList);
end;

procedure TfrmMain.ShowPriceListItems;
begin
  FOldGoodsItemIndex := -1;

  DM.qryGoodsForPriceList.Open('select G.ID, G.OBJECTCODE, G.VALUEDATA GoodsName, G.WEIGHT, GK.VALUEDATA KindName, ' +
    'PLI.ORDERPRICE, PLI.SALEPRICE, M.VALUEDATA MeasureName, G.VALUEDATA || '' ('' || GK.VALUEDATA || '')'' FullName ' +
    'FROM OBJECT_GOODS G ' +
    'JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID AND GLK.ISERASED = 0 ' +
    'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID AND GK.ISERASED = 0 ' +
    'JOIN OBJECT_PRICELISTITEMS PLI ON PLI.GOODSID = G.ID ' +
    'JOIN OBJECT_PRICELIST PL ON PL.ID = PLI.PRICELISTID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'WHERE G.ISERASED = 0 and PLI.PRICELISTID = ' + DM.qryPriceListId.AsString);

  SwitchToForm(tiPriceListItems, DM.qryGoodsForPriceList);
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

procedure TfrmMain.AddedNewStoreRealItems;
var
  i: integer;
begin
  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToStoreReal(FCheckedGooodsItems[i]);

  FCheckedGooodsItems.Clear;
end;

procedure TfrmMain.AddedNewOrderItems;
var
  i: integer;
begin
  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToOrderExternal(FCheckedGooodsItems[i]);

  RecalculateTotalPriceAndWeight;

  FCheckedGooodsItems.Clear;
end;

procedure TfrmMain.AddedNewReturnInItems;
var
  i: integer;
begin
  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToReturnIn(FCheckedGooodsItems[i]);

  RecalculateReturnInTotalPriceAndWeight;

  FCheckedGooodsItems.Clear;
end;

procedure TfrmMain.RecalculateTotalPriceAndWeight;
var
 i : integer;
 TotalPriceWithPercent, PriceWithPercent : Currency;
 b : TBookmark;
begin
  TotalPriceWithPercent := 0;
  FOrderTotalPrice := 0;
  FOrderTotalCountKg := 0;

  DM.cdsOrderItems.DisableControls;
  b := DM.cdsOrderItems.Bookmark;
  try
    DM.cdsOrderItems.First;
    while not DM.cdsOrderItems.Eof do
    begin
      if DM.cdsOrderItemsisChangePercent.AsBoolean then
        PriceWithPercent := DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat *
          (100 + DM.qryPartnerChangePercent.AsCurrency) / 100
      else
        PriceWithPercent := DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat;

      TotalPriceWithPercent := TotalPriceWithPercent + PriceWithPercent;

      if DM.qryPartnerPriceWithVAT.AsBoolean then
        FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent
      else
        FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent * (100 + DM.qryPartnerVATPercent.AsCurrency) / 100;

      if FormatFloat('0.##', DM.cdsOrderItemsWeight.AsFloat) <> '0' then
        FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsWeight.AsFloat * DM.cdsOrderItemsCount.AsFloat
      else
        FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsCount.AsFloat;

      DM.cdsOrderItems.Next;
    end;
  finally
    DM.cdsOrderItems.GotoBookmark(b);
    DM.cdsOrderItems.EnableControls;
  end;

  if DM.qryPartnerChangePercent.AsCurrency = 0 then
  begin
    lPriceWithPercent.Visible := false;
    pOrderTotals.Height := 50;
  end
  else
  begin
    lPriceWithPercent.Visible := true;
    pOrderTotals.Height := 70;

    if DM.qryPartnerChangePercent.AsCurrency > 0 then
      lPriceWithPercent.Text := ' Стоимость с учетом наценки (' +
        FormatFloat('0.00', DM.qryPartnerChangePercent.AsCurrency) + '%) : ' + FormatFloat('0.00', TotalPriceWithPercent)
    else
      lPriceWithPercent.Text := ' Стоимость с учетом скидки (' +
        FormatFloat('0.00', -DM.qryPartnerChangePercent.AsCurrency) + '%) : ' + FormatFloat('0.00', TotalPriceWithPercent);
  end;

  lTotalPrice.Text := 'Общая стоимость (с учетом НДС) : ' + FormatFloat('0.00', FOrderTotalPrice);

  lTotalWeight.Text := 'Общий вес : ' + FormatFloat('0.00', FOrderTotalCountKg);
end;

procedure TfrmMain.RecalculateReturnInTotalPriceAndWeight;
var
 i : integer;
 TotalPriceWithPercent, PriceWithPercent : Currency;
 b : TBookmark;
begin
  TotalPriceWithPercent := 0;
  FReturnInTotalPrice := 0;
  FReturnInTotalCountKg := 0;

  DM.cdsReturnInItems.DisableControls;
  b := DM.cdsReturnInItems.Bookmark;
  try
    DM.cdsReturnInItems.First;
    while not DM.cdsReturnInItems.Eof do
    begin
      PriceWithPercent := DM.cdsReturnInItemsPrice.AsFloat * DM.cdsReturnInItemsCount.AsFloat *
        (100 + DM.qryPartnerChangePercent.AsCurrency) / 100;

      TotalPriceWithPercent := TotalPriceWithPercent + PriceWithPercent;

      if DM.qryPartnerPriceWithVAT.AsBoolean then
        FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent
      else
        FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent * (100 + DM.qryPartnerVATPercent.AsCurrency) / 100;

      if FormatFloat('0.##', DM.cdsReturnInItemsWeight.AsFloat) <> '0' then
        FReturnInTotalCountKg := FReturnInTotalCountKg + DM.cdsReturnInItemsWeight.AsFloat * DM.cdsReturnInItemsCount.AsFloat
      else
        FReturnInTotalCountKg := FReturnInTotalCountKg + DM.cdsReturnInItemsCount.AsFloat;

      DM.cdsReturnInItems.Next;
    end;
  finally
    DM.cdsReturnInItems.GotoBookmark(b);
    DM.cdsReturnInItems.EnableControls;
  end;

  if DM.qryPartnerChangePercent.AsCurrency = 0 then
  begin
    lPriceWithPercentReturn.Visible := false;
    pReturnInTotals.Height := 50;
  end
  else
  begin
    lPriceWithPercentReturn.Visible := true;
    pReturnInTotals.Height := 70;

    if DM.qryPartnerChangePercent.AsCurrency > 0 then
      lPriceWithPercentReturn.Text := ' Стоимость с учетом наценки (' +
        FormatFloat('0.00', DM.qryPartnerChangePercent.AsCurrency) + '%) : ' + FormatFloat('0.00', TotalPriceWithPercent)
    else
      lPriceWithPercentReturn.Text := ' Стоимость с учетом скидки (' +
        FormatFloat('0.00', -DM.qryPartnerChangePercent.AsCurrency) + '%) : ' + FormatFloat('0.00', TotalPriceWithPercent);
  end;

  lTotalPriceReturn.Text := 'Общая стоимость (с учетом НДС) : ' + FormatFloat('0.00', FReturnInTotalPrice);

  lTotalWeightReturn.Text := 'Общий вес : ' + FormatFloat('0.00', FReturnInTotalCountKg);
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

  try
    CameraComponent := TCameraComponent.Create(nil);
    CameraComponent.OnSampleBufferReady := CameraComponentSampleBufferReady;
    if CameraComponent.HasFlash then
      CameraComponent.FlashMode := FMX.Media.TFlashMode.AutoFlash;
    CameraComponent.Active := false;
    bCaptureClick(bCapture);
  except
    CameraFree;
    ShowMessage('Ошибка инициализации камеры. Повторите попытку');
  end;
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

procedure TfrmMain.cbOnlyPromoChange(Sender: TObject);
var
  i : integer;
  oldValue : string;
begin
  for I := 0 to lwGoodsItems.Controls.Count-1 do
    if lwGoodsItems.Controls[I].ClassType = TSearchBox then
    begin
      oldValue := TSearchBox(lwGoodsItems.Controls[I]).Text;
      TSearchBox(lwGoodsItems.Controls[I]).Text := '!';
      TSearchBox(lwGoodsItems.Controls[I]).Text := oldValue;
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
