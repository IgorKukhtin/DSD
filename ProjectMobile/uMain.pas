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
  FMX.Grid, FMX.Objects, FMX.ExtCtrls, FMX.ListView.Types, FMX.ListView;

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
    aiCheck: TAniIndicator;
    tiMain: TTabItem;
    WebServerLayout1: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout2: TLayout;
    WebServerEdit: TEdit;
    SyncLayout: TLayout;
    SyncCheckBox: TCheckBox;
    Panel2: TPanel;
    Layout21: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    sbHandBook: TSpeedButton;
    Image1: TImage;
    sbVisit: TSpeedButton;
    Image2: TImage;
    Layout23: TLayout;
    Layout10: TLayout;
    sbSync: TSpeedButton;
    Image3: TImage;
    Layout22: TLayout;
    Layout13: TLayout;
    sbInfo: TSpeedButton;
    Image5: TImage;
    Layout14: TLayout;
    sbReport: TSpeedButton;
    Image6: TImage;
    Layout6: TLayout;
    sbRelogin: TSpeedButton;
    Image4: TImage;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    tiVisit: TTabItem;
    Panel3: TPanel;
    sbBack: TSpeedButton;
    VertScrollBox1: TVertScrollBox;
    sbMonday: TSpeedButton;
    sbTuesday: TSpeedButton;
    sbWednesday: TSpeedButton;
    sbThursday: TSpeedButton;
    sbFriday: TSpeedButton;
    sbSaturday: TSpeedButton;
    sbSunday: TSpeedButton;
    sbAllDays: TSpeedButton;
    lMondayCount: TLabel;
    lTuesdayCount: TLabel;
    lAllDaysCount: TLabel;
    lFridayCount: TLabel;
    lSaturdayCount: TLabel;
    lWednesdayCount: TLabel;
    lThursdayCount: TLabel;
    lSundayCount: TLabel;
    ImageViewer1: TImageViewer;
    tiPartners: TTabItem;
    lwPartner: TListView;
    Panel4: TPanel;
    sbBacktoVisit: TSpeedButton;
    Panel5: TPanel;
    lDayInfo: TLabel;
    Label10: TLabel;
    bsPartner: TBindSourceDB;
    blPartner: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    tiPartnerInfo: TTabItem;
    Panel6: TPanel;
    SpeedButton1: TSpeedButton;
    Label11: TLabel;
    procedure LogInButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbReloginClick(Sender: TObject);
    procedure tcMainChange(Sender: TObject);
    procedure sbVisitClick(Sender: TObject);
    procedure sbBackClick(Sender: TObject);
    procedure sbBacktoVisitClick(Sender: TObject);
    procedure sbMondayClick(Sender: TObject);
  private
    { Private declarations }
    procedure Wait(AWait: Boolean);
    procedure CheckDataBase;
    procedure GetVistDays;
    procedure ShowPartners(Day : integer; Caption : string);

    function GetImage(const AImageName: string): TBitmap;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uConstants, System.IOUtils, Authentication, Storage, CommonData, uDM;

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  tcMain.ActiveTab := tiStart;
  tcMainChange(tcMain);
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  LoginOk : boolean;
  bmp : TBitmap;
begin
  LoginOk := false;

  if assigned(gc_User) then  { Проверяем только с данными из локальной БД }
  begin
    if (LoginEdit.Text = gc_User.Login) or (PasswordEdit.Text = gc_User.Password) then
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
    try
      Wait(True);

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
  begin
    {
    bmp := GetImage('logotype');
    if Assigned(bmp) then
      imLogotype.Bitmap.Assign(bmp);}

    tcMain.ActiveTab := tiMain;
  end;
end;

procedure TfrmMain.sbBackClick(Sender: TObject);
begin
  tcMain.ActiveTab := tiMain;
end;

procedure TfrmMain.sbBacktoVisitClick(Sender: TObject);
begin
  tcMain.ActiveTab := tiVisit;
end;

procedure TfrmMain.sbMondayClick(Sender: TObject);
begin
  ShowPartners(TSpeedButton(Sender).Tag, TSpeedButton(Sender).Text);
  tcMain.ActiveTab := tiPartners;
end;

procedure TfrmMain.sbReloginClick(Sender: TObject);
begin
  tcMain.ActiveTab := tiStart;
end;

procedure TfrmMain.sbVisitClick(Sender: TObject);
begin
  tcMain.ActiveTab := tiVisit;
end;

procedure TfrmMain.tcMainChange(Sender: TObject);
begin
  if tcMain.ActiveTab = tiStart then
    CheckDataBase;

  if tcMain.ActiveTab = tiVisit then
    GetVistDays;
end;

procedure TfrmMain.Wait(AWait: Boolean);
begin
  aiCheck.Visible := AWait;
  aiCheck.Enabled := AWait;
  LogInButton.Enabled := not AWait;
  LoginEdit.Enabled := not AWait;
  PasswordEdit.Enabled := not AWait;
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
  DaysCount : array[1..7] of integer;
  Schedule : string;
begin
  with DM.qryPartner do
  begin
    DM.qryPartner.Open('select J.VALUEDATA Name, P.ADDRESS, P.GPS, P.SCHEDULE from OBJECT_PARTNER P ' +
      'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 ' +
      'where P.ISERASED = 0');

    First;
    while not EOF do
    begin
      Schedule := FieldbyName('Schedule').AsString;
      if Length(Schedule) <> 14 then
      begin
        ShowMessage('Ошибка в структуре поля Schedule');
        exit;
      end
      else
      begin
        for i := 1 to 7 do
          if LowerCase(Schedule[2 * i - 1]) = 't' then
            inc(DaysCount[i]);
      end;

      Next;
    end;
    Close;
  end;

  Num := 1;
  if DaysCount[1] > 0 then
  begin
    sbMonday.Visible := true;
    sbMonday.Text := IntToStr(Num) + '. Понедельник';
    lMondayCount.Text := IntToStr(DaysCount[1]);
    inc(Num);
  end
  else
    sbMonday.Visible := false;

  if DaysCount[2] > 0 then
  begin
    sbTuesday.Visible := true;
    sbTuesday.Text := IntToStr(Num) + '. Вторник';
    lTuesdayCount.Text := IntToStr(DaysCount[2]);
    inc(Num);
  end
  else
    sbTuesday.Visible := false;

  if DaysCount[3] > 0 then
  begin
    sbWednesday.Visible := true;
    sbWednesday.Text := IntToStr(Num) + '. Среда';
    lWednesdayCount.Text := IntToStr(DaysCount[3]);
    inc(Num);
  end
  else
    sbWednesday.Visible := false;

  if DaysCount[4] > 0 then
  begin
    sbThursday.Visible := true;
    sbThursday.Text := IntToStr(Num) + '. Четверг';
    lThursdayCount.Text := IntToStr(DaysCount[4]);
    inc(Num);
  end
  else
    sbThursday.Visible := false;

  if DaysCount[5] > 0 then
  begin
    sbFriday.Visible := true;
    sbFriday.Text := IntToStr(Num) + '. Пятница';
    lFridayCount.Text := IntToStr(DaysCount[5]);
    inc(Num);
  end
  else
    sbFriday.Visible := false;

  if DaysCount[6] > 0 then
  begin
    sbSaturday.Visible := true;
    sbSaturday.Text := IntToStr(Num) + '. Суббота';
    lSaturdayCount.Text := IntToStr(DaysCount[6]);
    inc(Num);
  end
  else
    sbSaturday.Visible := false;

  if DaysCount[7] > 0 then
  begin
    sbSunday.Visible := true;
    sbSunday.Text := IntToStr(Num) + '. Воскресенье';
    lSundayCount.Text := IntToStr(DaysCount[7]);
    inc(Num);
  end
  else
    sbSunday.Visible := false;

  lAllDaysCount.Text := IntToStr(DaysCount[1] + DaysCount[2] + DaysCount[3] +
    DaysCount[4] + DaysCount[5] + DaysCount[6] + DaysCount[7]);
end;

procedure TfrmMain.ShowPartners(Day : integer; Caption : string);
begin
  lDayInfo.Text := 'МАРШРУТ: ' + Caption;
  DM.qryPartner.Close;
  DM.qryPartner.Open('select J.VALUEDATA Name, P.ADDRESS, P.GPS, P.SCHEDULE from OBJECT_PARTNER P ' +
   'JOIN OBJECT_JURIDICAL J ON J.ID=P.JURIDICALID and J.ISERASED = 0 ' +
   'where lower(substr(P.SCHEDULE, ' + IntToStr(2 * Day - 1) + ', 1)) = ''t'' and P.ISERASED = 0');
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
