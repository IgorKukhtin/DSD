unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, System.JSON,
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure,
  dxDateRanges, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, dsdAction, System.Actions, dsdDB, cxDateUtils,
  Datasnap.DBClient, DataModul;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    btnAll: TButton;
    btnSelect_UpdateOrdersSite: TButton;
    Panel3: TPanel;
    spSite_Param: TdsdStoredProc;
    ActionList: TActionList;
    actSite_Param: TdsdExecStoredProc;
    FormParams: TdsdFormParams;
    deStartDate: TcxDateEdit;
    spSelect_UpdateOrdersSite: TdsdStoredProc;
    actSelect_UpdateOrdersSite: TdsdExecStoredProc;
    cxGridUpdateOrdersSiteDBTableView1: TcxGridDBTableView;
    cxGridUpdateOrdersSiteLevel1: TcxGridLevel;
    cxGridUpdateOrdersSite: TcxGrid;
    UpdateOrdersSiteCDS: TClientDataSet;
    UpdateOrdersSiteDS: TDataSource;
    cxGridUpdateOrdersSite_Id: TcxGridDBColumn;
    cxGridUpdateOrdersSite_InvNumber: TcxGridDBColumn;
    cxGridUpdateOrdersSite_OperDate: TcxGridDBColumn;
    cxGridUpdateOrdersSite_InvNumberOrder: TcxGridDBColumn;
    cxGridUpdateOrdersSite_UnitId: TcxGridDBColumn;
    cxGridUpdateOrdersSite_UnitName: TcxGridDBColumn;
    maDo: TMultiAction;
    btnDo: TButton;
    actDo: TAction;
    PharmOrdersDS: TDataSource;
    PharmOrdersCDS: TClientDataSet;
    actOpenGrid: TAction;
    btnOpen: TButton;
    actPharmOrders: TdsdForeignData;
    cxGridPharmOrders: TcxGrid;
    cxGridPharmOrdersDBTableView1: TcxGridDBTableView;
    cxGridPharmOrdersLevel1: TcxGridLevel;
    cxGridPharmOrders_id: TcxGridDBColumn;
    cxGridPharmOrders_pharmacy_order_id: TcxGridDBColumn;
    cxGridPharmOrders_name: TcxGridDBColumn;
    cxGridPharmOrders_phone: TcxGridDBColumn;
    cxGridPharmOrders_inDateComing: TcxGridDBColumn;
    PharmOrderProductsDS: TDataSource;
    PharmOrderProductsCDS: TClientDataSet;
    cxGridPharmOrderProducts: TcxGrid;
    cxGridPharmOrderProductsDBTableView1: TcxGridDBTableView;
    cxGridPharmOrderProductsLevel1: TcxGridLevel;
    cxGridPharmOrderProducts_id: TcxGridDBColumn;
    cxGridPharmOrderProducts_postgres_drug_id: TcxGridDBColumn;
    cxGridPharmOrderProducts_drug_name: TcxGridDBColumn;
    cxGridPharmOrderProducts_type_order: TcxGridDBColumn;
    cxGridPharmOrderProducts_price: TcxGridDBColumn;
    cxGridPharmOrderProducts_quantity: TcxGridDBColumn;
    actPharmOrderProducts: TdsdForeignData;
    cxGridUpdateOrdersSite_isMobileApplication: TcxGridDBColumn;
    cxGridUpdateOrdersSite_DateComing: TcxGridDBColumn;
    UpdateOrdersSiteMIDS: TDataSource;
    UpdateOrdersSiteMICDS: TClientDataSet;
    spSelect_MI_UpdateOrdersSite: TdsdStoredProc;
    actSelect_MI_UpdateOrdersSite: TdsdExecStoredProc;
    cxGridUpdateOrdersSiteMI: TcxGrid;
    cxGridUpdateOrdersSiteMIDBTableView1: TcxGridDBTableView;
    cxGridUpdateOrdersSiteMI_Id: TcxGridDBColumn;
    cxGridUpdateOrdersSiteMI_GoodsId: TcxGridDBColumn;
    cxGridUpdateOrdersSiteMI_GoodsName: TcxGridDBColumn;
    cxGridUpdateOrdersSiteMI_AmountOrder: TcxGridDBColumn;
    cxGridUpdateOrdersSiteMI_Price: TcxGridDBColumn;
    cxGridUpdateOrdersSiteMI_Amount: TcxGridDBColumn;
    cxGridUpdateOrdersSiteMILevel1: TcxGridLevel;
    btnDoone: TButton;
    actUpdatePharmOrderProducts: TdsdForeignData;
    cxGridPharmOrderBonuses: TcxGrid;
    cxGridPharmOrderBonusesView: TcxGridDBTableView;
    cxGridDB_pharmacy_order_id: TcxGridDBColumn;
    cxGridDB_user_id: TcxGridDBColumn;
    cxGridDB_bonus: TcxGridDBColumn;
    cxGridDB_bonus_used: TcxGridDBColumn;
    cxGridPharmOrderBonusesLevel: TcxGridLevel;
    PharmOrderBonusesDS: TDataSource;
    PharmOrderBonusesCDS: TClientDataSet;
    btnPharmOrderBonuses: TButton;
    actPharmOrderBonuses: TdsdForeignData;
    spInsertUpdate_MovementSiteBonus: TdsdStoredProc;
    btnInsertUpdate_MovementSiteBonus: TButton;
    mactInsertUpdate_MovementSiteBonus: TMultiAction;
    actInsertUpdate_MovementSiteBonus: TdsdExecStoredProc;
    MobileFirstOrderCDS: TClientDataSet;
    spUpdate_MobileFirstOrder: TdsdStoredProc;
    actPharmMobileFirstOrder: TdsdForeignData;
    mactUpdate_MobileFirstOrder: TMultiAction;
    actUpdate_MobileFirstOrder: TdsdExecStoredProc;
    MobileFirstOrderDS: TDataSource;
    mactUpdate_BuyerForSiteBonus: TMultiAction;
    actUpdate_BuyerForSiteBonus: TdsdExecStoredProc;
    actPharmUsersProfile: TdsdForeignData;
    PharmUsersProfileCDS: TClientDataSet;
    PharmUsersProfileDS: TDataSource;
    spUpdate_BuyerForSite_Bonus: TdsdStoredProc;
    spSelect_BuyerForSite_BonusAdd: TdsdStoredProc;
    BuyerForSiteBonusAddDS: TDataSource;
    BuyerForSiteBonusAddCDS: TClientDataSet;
    actSelect_BuyerForSite_BonusAdd: TdsdExecStoredProc;
    actUpdatePharmUsersProfile: TdsdForeignData;
    mactUpdatePharmUsersProfile: TMultiAction;
    spUpdate_BuyerForSite_BonusAdded: TdsdStoredProc;
    actUpdate_BuyerForSite_BonusAdded: TdsdExecStoredProc;
    procedure btnAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDoExecute(Sender: TObject);
    procedure actOpenGridExecute(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.actOpenGridExecute(Sender: TObject);
begin
  try
    if actSite_Param.Execute then
    begin

      // Заказ с сайта
      if not actPharmOrders.Execute then Exit;

      // Содержимое заказа с сайта
      if not actPharmOrderProducts.Execute then Exit;

      // Содержимое заказа с фармаси
      if not actSelect_MI_UpdateOrdersSite.Execute then Exit;

    end;
  except
    on E:Exception do
    begin
        Add_Log('Ошибка: ' + E.Message);
    end;
  end;
end;

procedure TMainForm.Add_Log(AMessage: String);
var
  F: TextFile;

begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    if Pos('----', AMessage) > 0 then Writeln(F, AMessage)
    else Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.btnAllClick(Sender: TObject);
var ini: TIniFile; DateStart : TDateTime;
begin
  Add_Log('-----------------');
  Add_Log('Запуск обработки заазов.');

  DateStart := Now;

  if actSelect_UpdateOrdersSite.Execute then maDo.Execute;

  Add_Log('Загрузка бонусов.');

  if actPharmOrderBonuses.Execute then mactInsertUpdate_MovementSiteBonus.Execute;

  Add_Log('Загрузка "Первая покупка мобильном приложением".');

  if actPharmMobileFirstOrder.Execute then mactUpdate_MobileFirstOrder.Execute;

  Add_Log('Загрузка "Загрузка остатка бонуса по покупателю".');

  if actPharmUsersProfile.Execute then mactUpdate_BuyerForSiteBonus.Execute;

  Add_Log('Загрузка "Коректировка бонуса покупателей".');

  if actSelect_BuyerForSite_BonusAdd.Execute then mactUpdatePharmUsersProfile.Execute;

  Add_Log('Выполнено.');

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try

    ini.WriteDateTime('Data','DataUpdate', DateStart);
    deStartDate.Date := ini.ReadDateTime('Data', 'DataUpdate', DateStart);

  finally
    ini.free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var ini: TIniFile;
begin

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try

    deStartDate.Date := ini.ReadDateTime('Data', 'DataUpdate', Date);
    ini.WriteDateTime('Data','DataUpdate',deStartDate.Date);

  finally
    ini.free;
  end;

  actPharmOrderBonuses.SQLParam.Value := 'select T1.pharmacy_order_id, MAX(T1.user_id) AS user_id,  SUM(T1.bonus) AS bonus, SUM(T1.bonus_used) AS bonus_used '#13 +
                                         'from '#13 +
                                         '(select pharm_orders.pharmacy_order_id, pharm_orders.user_id, pharm_order_bonuses.bonus, CAST(0 as double) AS bonus_used '#13 +
                                         'from pharm_order_bonuses '#13 +
                                         '     INNER JOIN pharm_orders ON pharm_orders.id = pharm_order_bonuses.order_id '#13 +
                                         'where  pharm_orders.user_id is not Null and pharm_orders.created_at > CURRENT_DATE() - 10 '#13 +
                                         'UNION ALL '#13 +
                                         'select pharm_orders.pharmacy_order_id, pharm_orders.user_id, 0 AS bonus, pharm_orders.bonus_used '#13 +
                                         'from pharm_orders '#13 +
                                         'where pharm_orders.user_id is not Null and pharm_orders.bonus_used <> 0 and pharm_orders.created_at > CURRENT_DATE() - 10) AS T1 '#13 +
                                         'GROUP BY T1.pharmacy_order_id';

  actPharmMobileFirstOrder.SQLParam.Value := 'select pharm_orders.pharmacy_order_id '#13 +
                                             'from pharm_orders'#13 +
                                             'where pharm_orders.promo_code = ''MOBILE-FIRST-ORDER'' and pharm_orders.created_at > CURRENT_DATE() - 1';

  actPharmUsersProfile.SQLParam.Value := 'WITH tmpUserAll AS (select pharm_orders.user_id '#13 +
                                         '                    from pharm_order_bonuses '#13 +
                                         '                         INNER JOIN pharm_orders ON pharm_orders.id = pharm_order_bonuses.order_id '#13 +
                                         '                    where  pharm_orders.user_id is not Null and pharm_orders.created_at > CURRENT_DATE() - 5 '#13 +
                                         '                    UNION ALL '#13 +
                                         '                    select pharm_orders.user_id '#13 +
                                         '                    from pharm_orders '#13 +
                                         '                    where pharm_orders.user_id is not Null and pharm_orders.bonus_used <> 0 and pharm_orders.created_at > CURRENT_DATE() - 5) '#13 +
                                         '             , tmpUser AS (SELECT DISTINCT tmpUserAll.user_id FROM tmpUserAll) '#13 +
                                         'select users_profile.user_id, users_profile.bonus_amount '#13 +
                                         'from users_profile '#13 +
                                         '     left join tmpUser ON tmpUser.user_id =  users_profile.user_id '#13 +
                                         'where COALESCE (tmpUser.user_id, 0) <> 0';


  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    Application.ShowMainForm := False;
    btnAll.Enabled := false;
    btnSelect_UpdateOrdersSite.Enabled := false;
    btnDo.Enabled := false;
    btnDoone.Enabled := false;
    btnOpen.Enabled := false;
    Timer1.Enabled := true;
  end;


end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    Timer1.Enabled := False;
    btnAllClick(Sender);
  finally
    Close;
  end;
end;

procedure TMainForm.actDoExecute(Sender: TObject);
  var bGo : boolean; S : string; FormatSettings: TFormatSettings;
begin
  try

    if not UpdateOrdersSiteCDS.FieldByName('DateComing').IsNull then Exit;

    // Содержимое заказа с сайта
    if not actPharmOrderProducts.Execute then Exit;

    bGo := False;
    PharmOrderProductsCDS.First;
    while not PharmOrderProductsCDS.Eof do
    begin
      if PharmOrderProductsCDS.FieldByName('type_order').AsString = 'at_provider' then
      begin
        bGo := True;
        Break;
      end;
      PharmOrderProductsCDS.Next;
    end;
    if not bGo then Exit;
    // Содержимое заказа с фармаси
    if not actSelect_MI_UpdateOrdersSite.Execute then Exit;

    FormatSettings.DecimalSeparator := '.';

    PharmOrderProductsCDS.First;
    while not PharmOrderProductsCDS.Eof do
    begin
      UpdateOrdersSiteMICDS.Locate('GoodsId', PharmOrderProductsCDS.FieldByName('postgres_drug_id').AsInteger, []);
      if (PharmOrderProductsCDS.FieldByName('type_order').AsString = 'at_provider') or
        (PharmOrderProductsCDS.FieldByName('postgres_drug_id').AsInteger = UpdateOrdersSiteMICDS.FieldByName('GoodsId').AsInteger) and
        (PharmOrderProductsCDS.FieldByName('quantity').AsCurrency > UpdateOrdersSiteMICDS.FieldByName('Amount').AsCurrency) then
      begin

        if (PharmOrderProductsCDS.FieldByName('postgres_drug_id').AsInteger = UpdateOrdersSiteMICDS.FieldByName('GoodsId').AsInteger) and
          (PharmOrderProductsCDS.FieldByName('quantity').AsCurrency > UpdateOrdersSiteMICDS.FieldByName('Amount').AsCurrency) then
        begin
          S := S + 'update pharm_orders set ext_changed = 1 where pharmacy_order_id = ' + UpdateOrdersSiteCDS.FieldByName('id').AsString;
          Add_Log('SQL ' + S);
          actUpdatePharmOrderProducts.SQLParam.Value := S;
          actUpdatePharmOrderProducts.Execute;
        end;

        S := 'update pharm_order_products set type_order = ''in_site''';

        if (PharmOrderProductsCDS.FieldByName('postgres_drug_id').AsInteger = UpdateOrdersSiteMICDS.FieldByName('GoodsId').AsInteger) and
          (PharmOrderProductsCDS.FieldByName('quantity').AsCurrency > UpdateOrdersSiteMICDS.FieldByName('Amount').AsCurrency) then
        begin
          S := S + ', quantity = ' + CurrToStr(UpdateOrdersSiteMICDS.FieldByName('Amount').AsCurrency, FormatSettings) +
                   ', amount = ' + CurrToStr(RoundTo(UpdateOrdersSiteMICDS.FieldByName('Amount').AsCurrency * PharmOrderProductsCDS.FieldByName('price').AsCurrency, -2), FormatSettings);
        end;

        S := S + ' where id = ' + PharmOrderProductsCDS.FieldByName('id').AsString;
        Add_Log('SQL ' + S);
        actUpdatePharmOrderProducts.SQLParam.Value := S;
        actUpdatePharmOrderProducts.Execute;
      end;
      PharmOrderProductsCDS.Next;
    end;

  except
    on E:Exception do
    begin
        Add_Log('Ошибка: ' + E.Message);
    end;
  end;
end;



end.
