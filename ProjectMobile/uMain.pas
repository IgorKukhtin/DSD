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
  FMX.DateTimeCtrls, FMX.Controls3D, FMX.Layers3D, FMX.Menus
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
    tiVisit: TTabItem;
    VertScrollBox1: TVertScrollBox;
    tiPartners: TTabItem;
    lwPartner: TListView;
    pBack: TPanel;
    sbBack: TSpeedButton;
    Panel5: TPanel;
    lDayInfo: TLabel;
    Label10: TLabel;
    bsPartner: TBindSourceDB;
    blPartner: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
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
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    procedure LogInButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bReloginClick(Sender: TObject);
    procedure tcMainChange(Sender: TObject);
    procedure bVisitClick(Sender: TObject);
    procedure sbBackClick(Sender: TObject);
    procedure LinkFillControlToField1FillingListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
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
  private
    { Private declarations }
    FMapLoaded: Boolean;
    FWebGMap: TTMSFMXWebGMaps;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    FCurCoordinatesSet : boolean;
    FCurCoordinates: TLocationCoord2D;

    procedure lbPartnerMenuItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);

    procedure UpdateKBBounds;
    procedure RestorePosition;
    function PrependIfNotEmpty(const Prefix, Subject: string): string;
    function GetAddress(const Latitude, Longitude: Double): string;
    function GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
    procedure WebGMapDownloadFinish(Sender: TObject);
    procedure WebGMapMarkerDragEnd(Sender: TObject; MarkerTitle: string;
      IdMarker: Integer; Latitude, Longitude: Double);

    procedure Wait(AWait: Boolean);
    procedure CheckDataBase;
    procedure GetVistDays;
    procedure ShowPartners(Day : integer; Caption : string);
    procedure ShowPartnerInfo(PartnerId : integer);

    function GetImage(const AImageName: string): TBitmap;
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
begin
  {$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetScreenOrientation(OrientSet);
  end;
  {$ENDIF}
  FCurCoordinatesSet := false;
  tcMain.ActiveTab := tiStart;
  tcMainChange(tcMain);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  lbPartnerMenu := nil;
end;

procedure TfrmMain.lbPartnerMenuItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  ppPartner.IsOpen := False;
  ShowMessage(Item.Text);
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

procedure TfrmMain.LinkFillControlToField1FillingListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  (AEditor.CurrentObject as TListViewItem).Tag := DM.qryPartner.FieldByName('id').AsInteger;
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  LoginOk : boolean;
begin
  LoginOk := false;

  if assigned(gc_User) then  { Проверяем только с данными из локальной БД }
  begin
    if true{(LoginEdit.Text = gc_User.Login) or (PasswordEdit.Text = gc_User.Password)} then
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
        DM.SynchronizeWithMainDatabase;
        LoginOk := true;
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
    tcMain.ActiveTab := tiMain;
end;

procedure TfrmMain.lwPartnerItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  tcMain.ActiveTab := tiPartnerInfo;
end;

procedure TfrmMain.sbBackClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiVisit then
  begin
    tcMain.ActiveTab := tiMain;
    exit;
  end;

  if tcMain.ActiveTab = tiPartners then
  begin
    tcMain.ActiveTab := tiVisit;
    exit;
  end;

  if tcMain.ActiveTab = tiPartnerInfo then
  begin
    tcMain.ActiveTab := tiPartners;
    exit;
  end;

  if tcMain.ActiveTab = tiSync then
  begin
    tcMain.ActiveTab := tiMain;
    exit;
  end;
end;

procedure TfrmMain.sbPartnerMenuClick(Sender: TObject);
var
  FP: TPointF;
begin
  FP := sbPartnerMenu.LocalToAbsolute(FP);

  with ppPartner.PlacementRectangle do
  begin
   Top := 10;
   Bottom := Top + ppPartner.Height;
   Left := FP.X - 190;
   Right := Left + ppPartner.Width;
  end;
  ppPartner.IsOpen := true;
  lbPartnerMenu.ItemIndex := -1;
end;

procedure TfrmMain.bMondayClick(Sender: TObject);
begin
  ShowPartners(TSpeedButton(Sender).Tag, TSpeedButton(Sender).Text);
  tcMain.ActiveTab := tiPartners;
end;

procedure TfrmMain.bReloginClick(Sender: TObject);
begin
  tcMain.ActiveTab := tiStart;
end;

procedure TfrmMain.bVisitClick(Sender: TObject);
begin
  tcMain.ActiveTab := tiVisit;
end;

procedure TfrmMain.tcMainChange(Sender: TObject);
begin
  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  if tcMain.ActiveTab = tiStart then
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
  end;

  if tcMain.ActiveTab = tiPartners then
    sbPartnerMenu.Visible := true
  else
    sbPartnerMenu.Visible := false;

  if tcMain.ActiveTab = tiStart then
    CheckDataBase;

  if tcMain.ActiveTab = tiVisit then
    GetVistDays;

  if tcMain.ActiveTab = tiPartnerInfo then
    ShowPartnerInfo((lwPartner.Selected as TListViewItem).Tag)
end;

procedure TfrmMain.tcPartnerInfoChange(Sender: TObject);
begin
  //
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
    DM.qryPartner.Open('select P.ID, J.VALUEDATA Name, P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE from OBJECT_PARTNER P ' +
      'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 ' +
      'where P.ISERASED = 0');

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
    inc(Num);
  end
  else
    bSunday.Visible := false;

  lAllDaysCount.Text := IntToStr(DaysCount[8]);
end;

procedure TfrmMain.ShowPartners(Day : integer; Caption : string);
var
  sQuery, CurGPSN, CurGPSE : string;

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
  LocManagerObj := SharedActivityContext.getSystemService(TJContext.JavaClass.LOCATION_SERVICE);
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

  sQuery := 'select P.Id, J.VALUEDATA Name, P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE from OBJECT_PARTNER P ' +
    'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 where P.ISERASED = 0';

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

procedure TfrmMain.ShowPartnerInfo(PartnerId : integer);
var
  Coordinates: TLocationCoord2D;
begin
  DM.qryPartner.Locate('Id', PartnerId);
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



function TfrmMain.GetImage(const AImageName: string): TBitmap;
var
  StyleObject: TFmxObject;
  Image: TImage;
begin
  {StyleObject := ImageBook.Style.FindStyleResource(AImageName);
  if (StyleObject <> nil) and (StyleObject is TImage) then
  begin
    try
      Image := StyleObject as TImage;
      Result := Image.Bitmap;
    except
      Result := nil;
    end;
  end
  else
    Result := nil; }
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
