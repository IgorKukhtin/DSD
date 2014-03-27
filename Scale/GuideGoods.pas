unit GuideGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons;

type
  TGuideGoodsForm = class(TForm)
    GridPanel: TPanel;
    DBGrid1: TDBGrid;
    ParamsPanel: TPanel;
    TarePanel: TPanel;
    rgTare: TRadioGroup;
    SummPanel: TPanel;
    PriceListPanel: TPanel;
    rgPriceList: TRadioGroup;
    PanelTare: TPanel;
    gbTareCount: TGroupBox;
    EditTareCount: TEdit;
    gbTareCode: TGroupBox;
    EditTareCode: TEdit;
    gbPriceListCode: TGroupBox;
    EditPriceListCode: TEdit;
    DataSource: TDataSource;
    Query: TQuery;
    QueryMeasureName: TStringField;
    QueryGoodsCode: TIntegerField;
    QueryGroupsName: TStringField;
    QueryGoodsName: TStringField;
    QueryZakazCount1: TFloatField;
    QueryZakazCount2: TFloatField;
    QueryZakazChange: TFloatField;
    QueryZakazCount: TFloatField;
    QueryTotalZakazCount: TFloatField;
    QuerySaleCount: TFloatField;
    QueryOperCount: TFloatField;
    QueryDiffCount: TFloatField;
    QueryDiffCountMinus: TFloatField;
    QueryDiffCountPlus: TFloatField;
    GoodsPanel: TPanel;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsWieghtValue: TGroupBox;
    PanelGoodsWieghtValue: TPanel;
    DiscountPanel: TPanel;
    rgDiscount: TRadioGroup;
    gbDiscountCode: TGroupBox;
    EditDiscountCode: TEdit;
    ButtonPanel: TPanel;
    ButtonExit: TSpeedButton;
    ButtonRefresh: TSpeedButton;
    ButtonSaveAllItem: TSpeedButton;
    KindPackagePanel: TPanel;
    rgKindPackage: TRadioGroup;
    gbKindPackageCode: TGroupBox;
    EditKindPackageCode: TEdit;
    QueryKindPackageName: TStringField;
    QueryKindPackageId: TIntegerField;
    gbZakazDiffCount: TGroupBox;
    PanelZakazDiffCount: TPanel;
    gblZakazTotalCount: TGroupBox;
    PanelZakazTotalCount: TPanel;
    gbTareWeightEnter: TGroupBox;
    EditTareWeightEnter: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonSaveAllItemClick(Sender: TObject);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeExit(Sender: TObject);
    procedure EditGoodsNameExit(Sender: TObject);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure QueryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure EditTareCountKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareCountExit(Sender: TObject);
    procedure EditTareCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareCodeExit(Sender: TObject);
    procedure EditDiscountCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditDiscountCodeExit(Sender: TObject);
    procedure EditTareCodeChange(Sender: TObject);
    procedure EditDiscountCodeChange(Sender: TObject);
    procedure EditPriceListCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPriceListCodeExit(Sender: TObject);
    procedure EditPriceListCodeChange(Sender: TObject);
    procedure rgTareClick(Sender: TObject);
    procedure rgDiscountClick(Sender: TObject);
    procedure rgPriceListClick(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure EditTareCountEnter(Sender: TObject);
    procedure rgKindPackageClick(Sender: TObject);
    procedure EditKindPackageCodeChange(Sender: TObject);
    procedure EditKindPackageCodeExit(Sender: TObject);
    procedure EditKindPackageCodeKeyPress(Sender: TObject; var Key: Char);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure EditTareWeightEnterExit(Sender: TObject);
  private
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;
    function Checked: boolean;
    function myReplaceFloat(Value:String):String;
  public
    GoodsWeight:Double;
    function Execute(ClientId:Integer;BillDate:TDateTime): boolean;
  end;

var
  GuideGoodsForm: TGuideGoodsForm;

implementation

{$R *.dfm}

uses Util;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Execute(ClientId:Integer;BillDate:TDateTime): boolean;
begin
{
     with Query do
        if (not Active)
        begin
                  Close;
                  ParamByName('@UserId').AsInteger:=_beginUser;
                  ParamByName('@ClientId').AsInteger:=ClientId;
                  ParamByName('@BillDate').AsDateTime:=BillDate;
                  ParamByName('@isMinus').AsInteger:=zc_rvNo;
                  //if _isScale_byZeus=zc_rvYes
                  //then ParamByName('@isScale_byObvalka').AsInteger:=_isScale_byZeus
                  //else
                        ParamByName('@isScale_byObvalka').AsInteger:=_isScale_byObvalka;
                  ParamByName('@isAll').AsInteger:=zc_rvYes;
                  Open;
        end
        else Filtered:=false;
}
     result:=ShowModal=mrOk;
end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.myReplaceFloat(Value:String):String;
begin
     Result:=trim(Value);
     if (LengTh(Result)=0)or(Result='0')then exit;
     //
     if Result[LengTh(Result)]='0' then System.Delete(Result,LengTh(Result),1);
     if Result[LengTh(Result)]='.' then System.Delete(Result,LengTh(Result),1);
     //
     if (Result[LengTh(Result)]='0')or(Result[LengTh(Result)]='.') then Result:=myReplaceFloat(Result);
     //
     if Result[1]='.' then Result:='0'+Result;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormCreate(Sender: TObject);
var i:Integer;
begin
  FillAllList;
  //прайс-лист
  EditPriceListCode.Text:= GetDefaultValue('Scale_'+IntToStr(CurSetting.ScaleNum),'Default','PriceListCode','','1');
  for I := 0 to Length(PriceList)-1 do
    rgPriceList.Items.Add('('+IntToStr(PriceList[i].Num)+') '+ PriceList[i].Name);
  rgPriceList.ItemIndex:=  StrToInt(EditPriceListCode.Text)-1;
  //вес тары
  EditTareCode.Text:= GetDefaultValue('Scale_'+IntToStr(CurSetting.ScaleNum),'Default','WeightTareCode','','1');
  for I := 0 to Length(WeightTare)-1 do
    rgTare.Items.Add('('+IntToStr(WeightTare[i].Num)+') '+ WeightTare[i].Name + ' кг');
  rgTare.ItemIndex:=  StrToInt(EditTareCode.Text)-1;
  //Скидка по весу
  EditDiscountCode.Text:= GetDefaultValue('Scale_'+IntToStr(CurSetting.ScaleNum),'Default','ChangePercentCode','','1');
  for I := 0 to Length(ChangePercent)-1 do
    rgDiscount.Items.Add('('+IntToStr(ChangePercent[i].Num)+') '+ ChangePercent[i].Name+ ' %');
  rgDiscount.ItemIndex:=  StrToInt(EditDiscountCode.Text)-1;

  //код вида товара(упаковки)
  EditKindPackageCode.Text:= GetDefaultValue('Scale_'+IntToStr(CurSetting.ScaleNum),'Default','GoodsKindCode','','1');
  for I := 0 to Length(GoodsKindWeighing)-1 do
    rgKindPackage.Items.Add('('+IntToStr(GoodsKindWeighing[i].Num)+') '+ GoodsKindWeighing[i].Name);
  rgKindPackage.ItemIndex:=   GetListOrder_ByCode(StrToInt(EditKindPackageCode.Text), GoodsKindWeighing);

{
  for I := 0 to Length(GoodsKindWeighing)-1 do
   if IntToStr(GoodsKindWeighing[i].Num) = EditKindPackageCode.Text then
       rgKindPackage.ItemIndex:=  StrToInt(EditKindPackageCode.Text)-1;
}

     if Length(PriceList) >0
     then begin
            rgKindPackage.Columns:=2;
            rgPriceList.Columns:=1;
            PriceListPanel.Width:=PriceListPanel.Width-100;
            EditPriceListCode.Width:=EditPriceListCode.Width-100;
            KindPackagePanel.Width:=KindPackagePanel.Width+100;
     end;


{
     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;
     // Tare
     for i:=0 to _CountTare-1 do
        rgTare.Items.Add('('+IntToStr(i+1)+') '+myReplaceFloat(GetStringValue('select case when Tare_Weight=-1 then GoodsName else cast (Tare_Weight as TVarCharMedium)end AS RetV from dba.GoodsProperty where GoodsCode = '+IntToStr(_CodeStartTare+i+1)))+' кг');
     // TareWeight
     gbTareWeightEnter.Visible:=_CountTareWeightEnter>0;
     // TareWeightEnter
     EditTareWeightEnter.Text:='';
     // PriceList
     if _isCalcPriceList=zc_rvYes
     then begin
            rgKindPackage.Columns:=2;
            rgPriceList.Columns:=1;
            PriceListPanel.Width:=PriceListPanel.Width-100;
            EditPriceListCode.Width:=EditPriceListCode.Width-100;
            KindPackagePanel.Width:=KindPackagePanel.Width+100;
            rgPriceList.Items.Add('(1) '+_PriceListName_byCalc_new);
            rgPriceList.Items.Add('(2) '+_PriceListName_byCalc_old);
          end
     else
         for i:=0 to ParamsPriceList.Count-1 do
            rgPriceList.Items.Add('('+IntToStr(i+1)+') '+GetStringValue('select PriceListName AS RetV from dba.PriceList_byHistory where Id = '+ParamsPriceList.Items[i].AsString));
     // Discount
     for i:=0 to ParamsDiscount.Count-1 do
        rgDiscount.Items.Add('('+IntToStr(i+1)+') '+ParamsDiscount.Items[i].AsString+' %');
     // KindPackage
     for i:=0 to ParamsKindPackage.Count-1 do
        rgKindPackage.Items.Add('('+IntToStr(i+1)+') '+GetStringValue('select isnull((select KindPackageName AS RetV from dba.KindPackage where Id = '+ParamsKindPackage.Items[i].AsString+'),'+FormatToVarCharServer('-')+') AS RetV'));
      if rgKindPackage.Items.Count=1 then rgKindPackage.ItemIndex:=0;
      if rgPriceList.Items.Count=1 then rgPriceList.ItemIndex:=0;
}

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.ButtonRefreshClick(Sender: TObject);
var GoodsCode:String;
begin
{
    with Query do begin
        GoodsCode:= FieldByName('GoodsCode').AsString;
        Close;
        Open;
        if GoodsCode <> '' then
          Locate('GoodsCode',GoodsCode,[loCaseInsensitive]);
    end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.ButtonExitClick(Sender: TObject);
begin Close end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountEnter(Sender: TObject);
var Key:Word;
    findTareCode:Integer;
begin
{
      TEdit(Sender).SelectAll;
      Key:=13;
      //
      if (ActiveControl=EditKindPackageCode)and(rgKindPackage.ItemIndex>=0)and(rgKindPackage.Items.Count=1)then begin rgKindPackage.ItemIndex:=0;FormKeyDown(Sender,Key,[]);end;
      if (ActiveControl=EditPriceListCode)and(rgPriceList.ItemIndex>=0)and(rgPriceList.Items.Count=1)then FormKeyDown(Sender,Key,[]);
      //
      try findTareCode:=StrToInt(trim(EditTareCode.Text))+_CodeStartTare;except findTareCode:=0;end;
      if (ActiveControl=EditTareWeightEnter)and(FindParamName(ParamsCodeTareWeightEnter,IntToStr(findTareCode))='')then FormKeyDown(Sender,Key,[]);
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameEnter(Sender: TObject);
var GoodsCode:String;
begin
{
  GoodsCode:= Query.FieldByName('GoodsCode').AsString;
  //
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  Query.Filtered:=false;
  if EditGoodsName.Text<>'' then begin fEnterGoodsName:=true;Query.Filtered:=true;end;
  //
  if GoodsCode <> '' then
    Query.Locate('GoodsCode',GoodsCode,[loCaseInsensitive,loPartialKey]);
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
var findTareCode:Integer;
begin
{
    try findTareCode:=StrToInt(trim(EditTareCode.Text))+_CodeStartTare;except findTareCode:=0;end;
    //
    if Key=13 then
      if (ActiveControl=EditGoodsCode)or(ActiveControl=EditGoodsName) then ActiveControl:=EditKindPackageCode
      else if ActiveControl=EditKindPackageCode then ActiveControl:=EditTareCount
           else if ActiveControl=EditTareCount then ActiveControl:=EditTareCode
                else if ActiveControl=EditTareCode then if (rgTare.ItemIndex>0)and(FindParamName(ParamsCodeTareWeightEnter,IntToStr(findTareCode))<>'')
                                                        then ActiveControl:=EditTareWeightEnter
                                                        else ActiveControl:=EditDiscountCode
                     else if ActiveControl=EditTareWeightEnter then ActiveControl:=EditDiscountCode
                          else if ActiveControl=EditDiscountCode then ActiveControl:=EditPriceListCode
                               else if ActiveControl=EditPriceListCode then ButtonSaveAllItemClick(Self);
    //
    if Key=32 then
      if ActiveControl=EditGoodsCode then ActiveControl:=EditGoodsName
      else if ActiveControl=EditGoodsName then ActiveControl:=EditGoodsCode;
    //
    //if Key=27 then Close;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.ButtonSaveAllItemClick(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(rgKindPackage.ItemIndex>=0)and(rgTare.ItemIndex>=0)and(rgDiscount.ItemIndex>=0)and(rgPriceList.ItemIndex>=0);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then begin fEnterGoodsCode:=true;fEnterGoodsName:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then fEnterGoodsCode:=false;fEnterGoodsName:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeExit(Sender: TObject);
var GoodsCode:Integer;
begin fEnterGoodsCode:=false;
     //???if (EditGoodsCode.Text='') then exit;
     try GoodsCode:=StrToInt(EditGoodsCode.Text) except GoodsCode:=0;end;
{
     if (GoodsWeight<0.0001)and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode
     else
         if (ActiveControl<>EditGoodsName)and((GoodsCode<=0)or(GoodsCode<>Query.FieldByName('GoodsCode').AsInteger))
         then ActiveControl:=EditGoodsCode;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameExit(Sender: TObject);
var GoodsCode:Integer;
begin
{
     GoodsCode:=Query.FieldByName('GoodsCode').AsInteger;
     if (GoodsWeight<0.0001)and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode
     else
        if GoodsCode<=0 then ActiveControl:=EditGoodsName
        else EditGoodsCode.Text:=IntToStr(GoodsCode);
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeChange(Sender: TObject);
begin
{
     if fEnterGoodsCode then
       with Query do begin
           if EditGoodsCode.Text='' then Filtered:=false else Filtered:=true;
       end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameChange(Sender: TObject);
var GoodsCode:String;
begin
{
     if fEnterGoodsName then
       with Query do begin
           GoodsCode:= FieldByName('GoodsCode').AsString;
           if EditGoodsName.Text='' then Filtered:=false else Filtered:=true;
           if GoodsCode <> '' then Locate('GoodsCode',GoodsCode,[loCaseInsensitive,loPartialKey]);
       end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.QueryFilterRecord(DataSet: TDataSet;  var Accept: Boolean);
//var
//   KindPackageId:Integer;
begin
{
     if fEnterGoodsCode then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
       then Accept:=true else Accept:=false;
     if fEnterGoodsName then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)

       then Accept:=true else Accept:=false;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DBGrid1CellClick(Column: TColumn);
begin
{
     EditGoodsCode.Text:=Query.FieldByName('GoodsCode').AsString;
     ActiveControl:=EditGoodsCode;
     EditGoodsCode.SelectAll;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountKeyPress(Sender: TObject;var Key: Char);
var TareCountCode:Integer;
begin
{
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          try TareCountCode:=StrToInt(trim(EditTareCount.Text))+_CodeStartCountTare-1+1;except TareCountCode:=0;end;
          if (TareCountCode>=_CodeStartCountTare+_CountCountTare-1)or(TareCountCode<_CodeStartCountTare)
          then TareCountCode:=_CodeStartCountTare
          else TareCountCode:=TareCountCode+1;
          EditTareCount.Text:=IntToStr(TareCountCode-_CodeStartCountTare+1-1);
          EditTareCountExit(Self);
          //
          TEdit(Sender).SelectAll;
     end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountExit(Sender: TObject);
var TareCount:Integer;
begin
{
     try TareCount:=StrToInt(trim(EditTareCount.Text));except TareCount:=-1;end;
     //
     if FindParamName(ParamsCountTare,IntToStr(TareCount))=''
     then ActiveControl:=EditTareCount;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightEnterExit(Sender: TObject);
var TareWeight:Double;
begin
{
     if trim (EditTareWeightEnter.Text)='' then EditTareWeightEnter.Text:='0';
     //
     try TareWeight:=StrToFloat(trim(EditTareWeightEnter.Text));except TareWeight:=-1;end;
     //
     if TareWeight<0
     then ActiveControl:=EditTareWeightEnter;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCodeKeyPress(Sender: TObject;var Key: Char);
var TareCode:Integer;
begin
{
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          try TareCode:=StrToInt(trim(EditTareCode.Text))+_CodeStartTare-1;except TareCode:=0;end;
          if (TareCode>=_CodeStartTare+_CountTare-1)or(TareCode<_CodeStartTare)
          then TareCode:=_CodeStartTare
          else TareCode:=TareCode+1;
          EditTareCode.Text:=IntToStr(TareCode-_CodeStartTare+1);
          EditTareCodeExit(Self);
          //
          TEdit(Sender).SelectAll;
     end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCodeExit(Sender: TObject);
begin
     if rgTare.ItemIndex=-1 then ActiveControl:=EditTareCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditDiscountCodeKeyPress(Sender: TObject;var Key: Char);
var DiscountCode:Integer;
begin
{
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          try DiscountCode:=StrToInt(trim(EditDiscountCode.Text))+_CodeStartDiscount-1;except DiscountCode:=0;end;
          if (DiscountCode>=_CodeStartDiscount+_CountDiscount-1)or(DiscountCode<_CodeStartDiscount)
          then DiscountCode:=_CodeStartDiscount
          else DiscountCode:=DiscountCode+1;
          EditDiscountCode.Text:=IntToStr(DiscountCode-_CodeStartDiscount+1);
          EditDiscountCodeExit(Self);
          //
          TEdit(Sender).SelectAll;
     end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditKindPackageCodeKeyPress(Sender: TObject;var Key: Char);
var KindPackageCode:Integer;
begin
{
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          try KindPackageCode:=StrToInt(trim(EditKindPackageCode.Text));except KindPackageCode:=0;end;
          if (KindPackageCode>=rgKindPackage.Items.Count)or(KindPackageCode<1)
          then KindPackageCode:=1
          else KindPackageCode:=KindPackageCode+1;
          EditKindPackageCode.Text:=IntToStr(KindPackageCode);
          EditKindPackageCodeExit(Self);
          //
          TEdit(Sender).SelectAll;
     end;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditDiscountCodeExit(Sender: TObject);
begin if rgDiscount.ItemIndex=-1 then ActiveControl:=EditDiscountCode;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditKindPackageCodeExit(Sender: TObject);
begin if (rgKindPackage.ItemIndex=-1)and(trim(EditGoodsCode.Text)<>'') then ActiveControl:=EditKindPackageCode;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeKeyPress(Sender: TObject;var Key: Char);
var PriceListCode:Integer;
begin
{
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          try PriceListCode:=StrToInt(trim(EditPriceListCode.Text));except PriceListCode:=0;end;
          if (PriceListCode>=Length(PriceList)) or(PriceListCode<1)
          then PriceListCode:=1
          else PriceListCode:=PriceListCode+1;
          EditPriceListCode.Text:=IntToStr(PriceListCode);
          EditPriceListCodeExit(Self);
          //
          TEdit(Sender).SelectAll;
     end;
 }
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeExit(Sender: TObject);
begin if rgPriceList.ItemIndex=-1 then ActiveControl:=EditPriceListCode;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditKindPackageCodeChange(Sender: TObject);
var KindPackageCode:Integer;
begin
{
     try KindPackageCode:=StrToInt(EditKindPackageCode.Text) except KindPackageCode:=-1;end;
     if (rgKindPackage.Items.Count<KindPackageCode)or(KindPackageCode<0)
     then rgKindPackage.ItemIndex:=-1
     else rgKindPackage.ItemIndex:=KindPackageCode-1;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCodeChange(Sender: TObject);
var TareCode:Integer;
begin
{
     try TareCode:=StrToInt(EditTareCode.Text) except TareCode:=-1;end;
     if (rgTare.Items.Count<TareCode)or(TareCode<0) then rgTare.ItemIndex:=-1
     else rgTare.ItemIndex:=TareCode-1;
     if (rgTare.ItemIndex<0)or(FindParamName(ParamsCodeTareWeightEnter,IntToStr(TareCode+_CodeStartTare))='')
     then EditTareWeightEnter.Text:=''
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditDiscountCodeChange(Sender: TObject);
var DiscountCode:Integer;
begin
{
     try DiscountCode:=StrToInt(EditDiscountCode.Text) except DiscountCode:=-1;end;
     if (rgDiscount.Items.Count<DiscountCode)or(DiscountCode<0) then rgDiscount.ItemIndex:=-1
     else rgDiscount.ItemIndex:=DiscountCode-1;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeChange(Sender: TObject);
var PriceListCode:Integer;
begin
{
     try PriceListCode:=StrToInt(EditPriceListCode.Text) except PriceListCode:=-1;end;
     if (rgPriceList.Items.Count<PriceListCode)or(PriceListCode<0) then rgPriceList.ItemIndex:=-1
     else rgPriceList.ItemIndex:=PriceListCode-1;
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgTareClick(Sender: TObject);
begin
    EditTareCode.Text:=IntToStr(rgTare.ItemIndex+1);
    ActiveControl:=EditTareCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgDiscountClick(Sender: TObject);
begin
    EditDiscountCode.Text:=IntToStr(rgDiscount.ItemIndex+1);
    ActiveControl:=EditDiscountCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgPriceListClick(Sender: TObject);
begin
    EditPriceListCode.Text:=IntToStr(rgPriceList.ItemIndex+1);
    ActiveControl:=EditPriceListCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgKindPackageClick(Sender: TObject);
begin
    EditKindPackageCode.Text:=IntToStr(GoodsKindWeighing[rgKindPackage.ItemIndex].Num );
    ActiveControl:=EditKindPackageCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DataSourceDataChange(Sender: TObject;Field: TField);
begin
{     if Query.RecordCount=1 then
     begin
          PanelZakazDiffCount.Caption:=FormatFloat(_fmtFloat+' кг.',Query.FieldByName('DiffCount').AsFloat);
          PanelZakazTotalCount.Caption:=FormatFloat(_fmtFloat+' кг.',Query.FieldByName('TotalZakazCount').AsFloat);
     end
     else begin
               PanelZakazDiffCount.Caption:='???';
               PanelZakazTotalCount.Caption:='???';
          end;
//     if ((EditGoodsCode.Text<>'')or(EditGoodsName.Text<>''))and(rgKindPackage.ItemIndex)
}
end;
{------------------------------------------------------------------------------}

end.
