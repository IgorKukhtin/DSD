unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  Bde.DBTables, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdDB, Datasnap.DBClient, dxSkinsCore,
  dxSkinsDefaultPainters
 ,SysScalesLib_TLB;

type
  TMainForm = class(TForm)
    GridPanel: TPanel;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    ButtonDeleteItem: TSpeedButton;
    ButtonExit: TSpeedButton;
    ButtonRefresh: TSpeedButton;
    ButtonRefreshZakaz: TSpeedButton;
    ButtonChangeNumberTare: TSpeedButton;
    ButtonChangeNumberLevel: TSpeedButton;
    ButtonExportToMail: TSpeedButton;
    ButtonChangeMember: TSpeedButton;
    ButtonExportToEDI: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    gbRealWeight: TGroupBox;
    PanelRealWeight: TPanel;
    gbPanelWeightTare: TGroupBox;
    PanelWeightTare: TPanel;
    gbAmountPartnerWeight: TGroupBox;
    PanelAmountPartnerWeight: TPanel;
    gbTotalSumm: TGroupBox;
    PanelTotalSumm: TPanel;
    PanelSaveItem: TPanel;
    EnterGoodsCodeScanerPanel: TPanel;
    EnterGoodsCodeScanerLabel: TLabel;
    EnterGoodsCodeScanerEdit: TEdit;
    gbOperDate: TGroupBox;
    infoPanel_Scale: TPanel;
    ScaleLabel: TLabel;
    PanelWeight_Scale: TPanel;
    PanelInfoItem: TPanel;
    PanelProduction_Goods: TPanel;
    LabelProduction_Goods: TLabel;
    GBProduction_GoodsCode: TGroupBox;
    PanelProduction_GoodsCode: TPanel;
    EditProduction_GoodsCode: TEdit;
    GBProduction_Goods_Weight: TGroupBox;
    PanelProduction_Goods_Weight: TPanel;
    GBProduction_GoodsName: TGroupBox;
    PanelProduction_GoodsName: TPanel;
    PanelTare_Goods: TPanel;
    LabelTare_Goods: TLabel;
    GBTare_GoodsCode: TGroupBox;
    PanelTare_GoodsCode: TPanel;
    GBTare_Goods_Weight: TGroupBox;
    PanelTare_Goods_Weight: TPanel;
    GBTare_GoodsName: TGroupBox;
    PanelTare_GoodsName: TPanel;
    gbTare_Goods_Count: TGroupBox;
    PanelTare_Goods_Count: TPanel;
    PanelSpace1: TPanel;
    PanelSpace2: TPanel;
    infoPanelTotalWeight: TPanel;
    GBTotalWeight: TGroupBox;
    PanelTotalWeight: TPanel;
    GBDiscountWeight: TGroupBox;
    PanelDiscountWeight: TPanel;
    infoPanel_mastre: TPanel;
    PanelMovement: TPanel;
    PanelMovementDesc: TPanel;
    infoPanel: TPanel;
    infoPanelPartner: TPanel;
    LabelPartner: TLabel;
    PanelPartner: TPanel;
    infoPanelPriceList: TPanel;
    PriceListNameLabel: TLabel;
    PanelPriceList: TPanel;
    infoPanelOrderExternal: TPanel;
    LabelOrderExternal: TLabel;
    PanelOrderExternal: TPanel;
    PopupMenu: TPopupMenu;
    miPrintZakazMinus: TMenuItem;
    miPrintZakazAll: TMenuItem;
    miLine11: TMenuItem;
    miPrintBill_byInvNumber: TMenuItem;
    miPrintBill_andNaliog_byInvNumber: TMenuItem;
    miPrintBillTotal_byClient: TMenuItem;
    miPrintBillTotal_byFozzi: TMenuItem;
    miLine12: TMenuItem;
    miPrintSchet_byInvNumber: TMenuItem;
    miPrintBillTransport_byInvNumber: TMenuItem;
    miPrintBillTransportNew_byInvNumber: TMenuItem;
    miPrintBillKachestvo_byInvNumber: TMenuItem;
    miPrintBillNumberTare_byInvNumber: TMenuItem;
    miPrintBillNotice_byInvNumber: TMenuItem;
    miLine13: TMenuItem;
    miPrintSaleAll: TMenuItem;
    miPrint_Report_byTare: TMenuItem;
    miPrint_Report_byMemberProduction: TMenuItem;
    miLine14: TMenuItem;
    miScaleIni_DB: TMenuItem;
    miScaleIni_BI: TMenuItem;
    miScaleIni_Zeus: TMenuItem;
    miScaleIni_BI_R: TMenuItem;
    miLine15: TMenuItem;
    miScaleRun_DB: TMenuItem;
    miScaleRun_BI: TMenuItem;
    miScaleRun_Zeus: TMenuItem;
    miScaleRun_BI_R: TMenuItem;
    OperDateEdit: TcxDateEdit;
    spSelect: TdsdStoredProc;
    DataSource: TDataSource;
    CDS: TClientDataSet;
    infoPanelContract: TPanel;
    LabelContract: TLabel;
    PanelContract: TPanel;
    gbAmountWeight: TGroupBox;
    PanelAmountWeight: TPanel;
    rgScale: TRadioGroup;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure ButtonRefreshZakazClick(Sender: TObject);
    procedure PanelWeight_ScaleDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ButtonDeleteItemClick(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure rgScaleClick(Sender: TObject);
    procedure EnterGoodsCodeScanerEditChange(Sender: TObject);
  private
    Scale_BI: TCasBI;
    Scale_DB: TCasDB;

    function GetParams_MovementDesc(BarCode: String):Boolean;
    function GetParams_Goods(BarCode: String):Boolean;
    procedure Create_Scale;
    procedure Initialize_Scale;
    function fGetScale_CurrentWeight:Double;
    procedure RefreshDataSet;
    procedure WriteParamsMovement;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;


implementation
{$R *.dfm}
uses DMMainScale, UtilScale, UtilConst, DialogMovementDesc, GuideGoods,GuideGoodsMovement,UtilPrint;
//------------------------------------------------------------------------------------------------
function TMainForm.GetParams_MovementDesc(BarCode: String):Boolean;
begin
     if ParamsMovement.ParamByName('MovementDescId').AsInteger=0
     then ParamsMovement.ParamByName('MovementDescNumber').AsString:=GetArrayList_Value_byName(Default_Array,'MovementNumber')
     else if (ParamsMovement.ParamByName('MovementId').AsInteger<>0)and()
          then begin
               ShowMessage ('Ошибка.Документ взвешивания № <'+ParamsMovement.ParamByName('InvNumber').AsString+'>  от <'+DateToStr(ParamsMovement.ParamByName('OperDate_Movement').AsDateTime)+'> не закрыт.'+#10+#13+'Изменение параметров не возможно.');
               Result:=false;
               exit;
          end;
     //
     Result:=DialogMovementDescForm.Execute(BarCode);
     if Result then
     begin
          if ParamsMovement.ParamByName('MovementId').AsInteger<>0
          then DMMainScaleForm.gpInsertUpdate_Scale_Movement(ParamsMovement);
          //
          WriteParamsMovement;
     end;
     ActiveControl:=EnterGoodsCodeScanerEdit;
end;
{------------------------------------------------------------------------}
function TMainForm.GetParams_Goods(BarCode: String):Boolean;
var GoodsWeight_two,GoodsWeight_set:Double;
    calcClientId:Integer;
begin
     Result:=false;
     //
     if ParamsMovement.ParamByName('MovementDescId').asInteger=0
     then if GetParams_MovementDesc('')=false then exit;
     //
     if BarCode<>'' then
     begin
          DMMainScaleForm.gpGet_Scale_Goods(ParamsMI,BarCode);
          if ParamsMI.ParamByName('GoodsId').AsInteger=0 then
          begin
               ShowMessage('Ошибка.Товар не найден.');
               Result:=false;
               exit;
          end;
     end
     else EmptyValuesParams(ParamsMI);

     //
     ParamsMI.ParamByName('RealWeight_Get').AsFloat:=fGetScale_CurrentWeight;
     //
     if ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0
     then
         if GuideGoodsMovementForm.Execute(ParamsMovement)=true
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
                    CDS.First;
              end
         else
     else
         if GuideGoodsForm.Execute(ParamsMovement)=true
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
                    CDS.First;
              end;
     ActiveControl:=EnterGoodsCodeScanerEdit;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.ButtonRefreshClick(Sender: TObject);
begin
    RefreshDataSet;
    WriteParamsMovement;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.ButtonRefreshZakazClick(Sender: TObject);
begin
    PrintSale(StrToInt(EnterGoodsCodeScanerEdit.Text));
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.CDSAfterOpen(DataSet: TDataSet);
var bm: TBookmark;
    AmountPartnerWeight,AmountWeight,RealWeight,WeightTare: Double;
begin
  with DataSet do
    try
       //
       bm:=GetBookmark; DisableControls;
       First;
       AmountPartnerWeight:=0;
       AmountWeight:=0;
       RealWeight:=0;
       WeightTare:=0;
       while not EOF do begin
          if FieldByName('isErased').AsBoolean=false then
          begin
            AmountPartnerWeight:=AmountPartnerWeight+FieldByName('AmountPartnerWeight').AsFloat;
            AmountWeight:=AmountWeight+FieldByName('AmountWeight').AsFloat;
            RealWeight:=RealWeight+FieldByName('RealWeightWeight').AsFloat;
            WeightTare:=WeightTare+FieldByName('WeightTareTotal').AsFloat;
          end;
          //
          Next;
       end;
    finally
       GotoBookmark(bm);
       FreeBookmark(bm);
       EnableControls;
    end;
    PanelAmountPartnerWeight.Caption:=FormatFloat(',0.000#'+' кг.',AmountPartnerWeight);
    PanelAmountWeight.Caption:=FormatFloat(',0.000#'+' кг.',AmountWeight);
    PanelRealWeight.Caption:=FormatFloat(',0.000#'+' кг.',RealWeight);
    PanelWeightTare.Caption:=FormatFloat(',0.000#'+' кг.',WeightTare);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
     if CDS.FieldByName('isErased').AsBoolean=true then
     with (Sender as TDBGrid).Canvas do
     begin
          Font.Color:=clRed;
          FillRect(Rect);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EnterGoodsCodeScanerEditChange(Sender: TObject);
begin
     EnterGoodsCodeScanerEdit.Text:=trim(EnterGoodsCodeScanerEdit.Text);
     if Length(EnterGoodsCodeScanerEdit.Text)>=13
     then
         if Pos(zc_BarCodePref_Object,EnterGoodsCodeScanerEdit.Text)=1
         then begin
                   GetParams_Goods(EnterGoodsCodeScanerEdit.Text);
                   EnterGoodsCodeScanerEdit.Text:='';
              end
         else
             if Pos(zc_BarCodePref_Movement,EnterGoodsCodeScanerEdit.Text)=1
             then begin
                       GetParams_MovementDesc(EnterGoodsCodeScanerEdit.Text);
                       EnterGoodsCodeScanerEdit.Text:='';
                  end;

end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption:='Экспедиция - <'+DMMainScaleForm.gpGet_Scale_User+'>';
  EnterGoodsCodeScanerEdit.Text:='';
  //global Initialize
  gpInitialize_Const;
  //global Initialize Array
  Default_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'Default');
  Service_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'Service');

  PriceList_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'PriceList');
  TareCount_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'TareCount');
  TareWeight_Array:=    DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'TareWeight');
  ChangePercentAmount_Array:= DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'ChangePercentAmount');
  GoodsKind_Array:=     DMMainScaleForm.gpSelect_Scale_GoodsKindWeighing;
  //global Initialize
  Create_ParamsMI(ParamsMI);
  //global Initialize
  Create_Scale;
  //
  //local Movement Initialize
  OperDateEdit.Text:=DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime);
  //
  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_MI';
       OutputType:=otDataSet;
       Params.AddParam('inMovementId', ftInteger, ptInput,0);
  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.WriteParamsMovement;
begin
  with ParamsMovement do begin

    if ParamByName('MovementId').AsInteger=0
    then PanelMovement.Caption:='Документ не сохранен.'
    else PanelMovement.Caption:='Документ № <'+ParamByName('InvNumber').AsString+'>  от <'+DateToStr(ParamByName('OperDate_Movement').AsDateTime)+'>';

    PanelMovementDesc.Caption:=ParamByName('MovementDescName_master').asString;
    PanelPriceList.Caption:=ParamByName('PriceListName').asString;

    if ParamByName('calcPartnerId').AsInteger<>0
    then PanelPartner.Caption:='  ('+IntToStr(ParamByName('calcPartnerCode').asInteger)+') '+ParamByName('calcPartnerName').asString
    else PanelPartner.Caption:='';

    if ParamByName('ContractId').AsInteger<>0
    then PanelContract.Caption:=' № '+ParamByName('ContractNumber').asString
                               +' '+ParamByName('ContractTagName').asString
                               +'  ('+ParamByName('ContractCode').asString+')'
                               //+'  ('+ParamByName('PaidKindName').asString+')'
    else PanelContract.Caption:='';

    if ParamByName('ChangePercent').AsFloat<=0
    then LabelPartner.Caption:='Контрагент - скидка <'+FloatToStr(-1*ParamByName('ChangePercent').asFloat)+'%>'
    else LabelPartner.Caption:='Контрагент - наценка <'+FloatToStr(ParamByName('ChangePercent').asFloat)+'%>';


    PanelTotalSumm.Caption:=FormatFloat(',0.00##',ParamByName('TotalSumm').asFloat);

    if ParamByName('OrderExternalId').AsInteger<>0
    then PanelOrderExternal.Caption:='  '+ParamByName('OrderExternalName_master').asString
    else PanelOrderExternal.Caption:='';

  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.RefreshDataSet;
begin
  with spSelect do
  begin
       Params.ParamByName('inMovementId').Value:=ParamsMovement.ParamByName('MovementId').AsInteger;
       Execute;
  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Create_Scale;
var i:Integer;
    number:Integer;
begin
  Scale_DB:=TCasDB.Create(self);
  Scale_BI:=TCasBI.Create(self);
  SettingMain.IndexScale_old:=-1;

  number:=-1;
  for i := 0 to Length(Scale_Array)-1 do
  begin
    if Scale_Array[i].COMPort>=0
    then rgScale.Items.Add(Scale_Array[i].ScaleName+' : COM' +IntToStr(Scale_Array[i].COMPort))
    else rgScale.Items.Add(Scale_Array[i].ScaleName+' : COM?');
    if Scale_Array[i].COMPort=SettingMain.DefaultCOMPort then number:=i;
  end;
  rgScale.ItemIndex:=number;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_Scale;
begin
     //Close prior
     if SettingMain.IndexScale_old>=0
     then begin
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stBI then Scale_BI.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stDB then Scale_DB.Active := 0;
          end;
     MyDelay_two(200);

     ScaleLabel.Caption:='Scale-All Error';
     //
     if Scale_Array[rgScale.ItemIndex].ScaleType = stBI
     then
          // !!! SCALE BI !!!
          try
             Scale_BI.Active := 0;
             Scale_BI.CommPort:='COM' + IntToStr(Scale_Array[rgScale.ItemIndex].ComPort);
             Scale_BI.CommSpeed := 9600;//NEW!!!
             Scale_BI.Active := 1;//NEW!!!
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='BI.Active = OK'
             else ScaleLabel.Caption:='BI.Active = Error';
          except
               ScaleLabel.Caption:='BI.Active = Error-ALL';
          end;

     if Scale_Array[rgScale.ItemIndex].ScaleType = stDB
     then try
             // !!! SCALE DB !!!
             Scale_DB.Active:=0;
             Scale_DB.CommPort:='COM' + IntToStr(Scale_Array[rgScale.ItemIndex].ComPort);
             Scale_DB.Active := 1;
             //
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='DB.Active = OK'
             else ScaleLabel.Caption:='DB.Active = Error';
          except
             ScaleLabel.Caption:='DB.Active = Error-ALL';
         end;

     //
     PanelWeight_Scale.Caption:='';
     //
     SettingMain.IndexScale_old:=rgScale.ItemIndex;
     //
     MyDelay_two(500);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.rgScaleClick(Sender: TObject);
begin
     Initialize_Scale;
     ActiveControl:=EnterGoodsCodeScanerEdit;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.PanelWeight_ScaleDblClick(Sender: TObject);
begin
   fGetScale_CurrentWeight;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.fGetScale_CurrentWeight:Double;
begin
     // открываем ВЕСЫ, только когда НУЖЕН вес
     //Initialize_Scale_DB;
     // считывание веса
     try
        if Scale_Array[rgScale.ItemIndex].ScaleType = stBI
        then Result:=Scale_BI.Weight
             else if Scale_Array[rgScale.ItemIndex].ScaleType = stDB
                  then Result:=Scale_DB.Weight
                  else Result:=0;
     except Result:=0;end;
     // закрываем ВЕСЫ
     // Scale_DB.Active:=0;
     //
//*****
     if (System.Pos('ves=',ParamStr(1))>0)and(Result=0)
     then Result:=StrToFloat(Copy(ParamStr(1), 5, LengTh(ParamStr(1))-5));
     if (System.Pos('ves=',ParamStr(2))>0)and(Result=0)
     then Result:=StrToFloat(Copy(ParamStr(2), 5, LengTh(ParamStr(2))-5));
//*****
     PanelWeight_Scale.Caption:=FloatToStr(Result);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = VK_F2 then GetParams_MovementDesc('');
     if Key = VK_SPACE then GetParams_Goods('');
     //
     if ShortCut(Key, Shift) = 24659 then
     begin
          gc_isDebugMode := not gc_isDebugMode;
          if gc_isDebugMode
          then ShowMessage('Установлен режим отладки')
          else ShowMessage('Снят режим отладки');
     end;
end;
{------------------------------------------------------------------------}
procedure TMainForm.FormShow(Sender: TObject);
begin
     RefreshDataSet;
     WriteParamsMovement;
     ActiveControl:=EnterGoodsCodeScanerEdit;
end;
{------------------------------------------------------------------------}
procedure TMainForm.ButtonDeleteItemClick(Sender: TObject);
begin
     if CDS.FieldByName('isErased').AsBoolean=false
     then
         if MessageDlg('Действительно удалить? ('+CDS.FieldByName('GoodsName').AsString+' '+CDS.FieldByName('GoodsKindName').AsString+') вес=('+CDS.FieldByName('RealWeight').AsString+')'
                ,mtConfirmation,mbYesNoCancel,0) <> 6
         then exit
         else begin
                   DMMainScaleForm.gpUpdate_Scale_MI_Erased(CDS.FieldByName('MovementItemId').AsInteger,true);
                   RefreshDataSet;
                   WriteParamsMovement;
              end
     else
         if MessageDlg('Действительно воостановить? ('+CDS.FieldByName('GoodsName').AsString+' '+CDS.FieldByName('GoodsKindName').AsString+') вес=('+CDS.FieldByName('RealWeight').AsString+')'
                ,mtConfirmation,mbYesNoCancel,0) <> 6
         then exit
         else begin
                   DMMainScaleForm.gpUpdate_Scale_MI_Erased(CDS.FieldByName('MovementItemId').AsInteger,false);
                   RefreshDataSet;
                   WriteParamsMovement;
              end
end;
{------------------------------------------------------------------------}
procedure TMainForm.ButtonExitClick(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------}
end.
