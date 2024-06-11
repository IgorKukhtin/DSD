unit ChoicePeriod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, dsdCommon,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGroupBox, cxRadioGroup, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxLabel, cxSpinEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxPropertiesStore,
  dxSkinsCore, dxSkinsDefaultPainters;

type

  // Компонент выбора периода
  TPeriodChoice = class(TdsdComponent)
  private
    FDateStart: TcxDateEdit;
    FDateEnd: TcxDateEdit;
    FDateEndDblClick, FDateStartDblClick: TNotifyEvent;
    FDateEndChange, FDateStartChange: TNotifyEvent;
    FonChange: TNotifyEvent;
    FUpdateDateEdit: boolean;
    FOnShow: TNotifyEvent;
    procedure SetDateEnd(const Value: TcxDateEdit);
    procedure SetDateStart(const Value: TcxDateEdit);
    procedure OnDblClick(Sender: TObject);
    procedure OnShow(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property onChange: TNotifyEvent read FonChange write FonChange;
    procedure Execute;
    constructor Create(AOwner: TComponent); override;
  published
    property DateStart: TcxDateEdit read FDateStart write SetDateStart;
    property DateEnd: TcxDateEdit read FDateEnd write SetDateEnd;
  end;

  TPeriodChoiceForm = class(TForm)
    cxDateEnd: TcxDateEdit;
    cxDateStart: TcxDateEdit;
    cbMonth: TcxComboBox;
    cbQuarter: TcxComboBox;
    cxLabel1: TcxLabel;
    seYear: TcxSpinEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cbWeek: TcxComboBox;
    cxLabel2: TcxLabel;
    cxLabel6: TcxLabel;
    bbOk: TcxButton;
    bbCancel: TcxButton;
    cxPropertiesStore: TcxPropertiesStore;
    rbDay: TcxRadioButton;
    rbWeek: TcxRadioButton;
    rbMonth: TcxRadioButton;
    rbQuater: TcxRadioButton;
    rbYear: TcxRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure seYearPropertiesChange(Sender: TObject);
    procedure rbWeekClick(Sender: TObject);
    procedure cbWeekEnter(Sender: TObject);
    procedure cbWeekPropertiesChange(Sender: TObject);
    procedure rbMonthClick(Sender: TObject);
    procedure cbMonthPropertiesChange(Sender: TObject);
    procedure rbQuaterClick(Sender: TObject);
    procedure cbMonthEnter(Sender: TObject);
    procedure cbQuarterEnter(Sender: TObject);
    procedure cbQuarterPropertiesChange(Sender: TObject);
    procedure seYearEnter(Sender: TObject);
    procedure rbYearClick(Sender: TObject);
  private
    WeekList: TList;
  public
    { Public declarations }
  end;

  procedure Register;

implementation

{$R *.dfm}

uses DateUtils, ParentForm, UtilConst;

type
  TWeek = class
    DateStart, DateEnd: TDateTime;
    constructor Create(DateStart, DateEnd: TDateTime);
  end;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TPeriodChoice]);
end;

procedure TPeriodChoiceForm.cbMonthEnter(Sender: TObject);
begin
  rbMonth.Checked := true;
end;

procedure TPeriodChoiceForm.cbMonthPropertiesChange(Sender: TObject);
begin
  rbMonth.OnClick(Sender);
end;

procedure TPeriodChoiceForm.cbQuarterEnter(Sender: TObject);
begin
  rbQuater.Checked := true
end;

procedure TPeriodChoiceForm.cbQuarterPropertiesChange(Sender: TObject);
begin
  rbQuater.OnClick(Sender)
end;

procedure TPeriodChoiceForm.cbWeekEnter(Sender: TObject);
begin
  rbWeek.Checked := true
end;

procedure TPeriodChoiceForm.cbWeekPropertiesChange(Sender: TObject);
begin
  rbWeek.OnClick(Sender);
end;

procedure TPeriodChoiceForm.FormCreate(Sender: TObject);
var i: integer;
begin
  for i := 1 to 12 do
    cbMonth.Properties.Items.Add(FormatSettings.LongMonthNames[i]);
  // Заполняем недели
  WeekList := TList.Create;

  for i := 1 to WeeksInYear(Now) do begin
    WeekList.Add(TWeek.Create(EncodeDateWeek(YearOf(Now), i, 1), EncodeDateWeek(YearOf(Now), i, 7)));
    with TWeek(WeekList[WeekList.Count-1]) do
      cbWeek.Properties.Items.Add(IntToStr(i) + '   ' + FormatDateTime('dd.mm', DateStart) + '-' + FormatDateTime('dd.mm', DateEnd));
  end;
end;

procedure TPeriodChoiceForm.rbMonthClick(Sender: TObject);
begin
  cxDateStart.Date := EncodeDate(seYear.Value, cbMonth.ItemIndex + 1, 1);
  cxDateEnd.Date := EndOfTheMonth(cxDateStart.Date) - gc_Minute;
end;

procedure TPeriodChoiceForm.rbQuaterClick(Sender: TObject);
begin
  cxDateStart.Date := EncodeDate(seYear.Value, cbQuarter.ItemIndex * 3 + 1, 1);
  cxDateEnd.Date := EndOfTheMonth(EncodeDate(seYear.Value, cbQuarter.ItemIndex * 3 + 3, 1)) - gc_Minute;
end;

procedure TPeriodChoiceForm.rbWeekClick(Sender: TObject);
begin
  with TWeek(WeekList[cbWeek.ItemIndex]) do begin
    cxDateStart.Date := DateStart;
    cxDateEnd.Date := DateEnd;
  end;
end;

procedure TPeriodChoiceForm.rbYearClick(Sender: TObject);
begin
  cxDateStart.Date := EncodeDate(seYear.Value, 1, 1);
  cxDateEnd.Date := EndOfTheYear(cxDateStart.Date) - gc_Minute;
end;

procedure TPeriodChoiceForm.seYearEnter(Sender: TObject);
begin
  rbYear.Checked := true;
end;

procedure TPeriodChoiceForm.seYearPropertiesChange(Sender: TObject);
begin
  rbYear.OnClick(Sender);
end;

{ TPeriodChoice }

constructor TPeriodChoice.Create(AOwner: TComponent);
begin
  inherited;
  FUpdateDateEdit := false;
  if Assigned(Owner) then
     if Owner is TForm then begin
        FOnShow := (Owner as TForm).OnShow;
        (Owner as TForm).OnShow := OnShow;
     end;
end;

procedure TPeriodChoice.Execute;
begin
   with TPeriodChoiceForm.Create(nil) do
   begin
     try
       seYear.Value := YearOf(DateStart.Date);
       cbMonth.ItemIndex := MonthOf(DateStart.Date) - 1;
       cbQuarter.ItemIndex := (cbMonth.ItemIndex div 3);
       cbWeek.ItemIndex := WeekOf(DateStart.Date) - 1;
       cxDateStart.Date := DateStart.Date;
       cxDateEnd.Date := DateEnd.Date;
       rbDay.Checked := true;
       if ShowModal = mrOk then
       begin
         FUpdateDateEdit := true;
         try
           DateStart.Date := cxDateStart.Date;
           DateEnd.Date := trunc(cxDateEnd.Date);
           if Assigned(onChange) then
              onChange(Self);
         finally
           FUpdateDateEdit := false
         end;
       end;
     finally
       Free;
     end;
   end;
end;

procedure TPeriodChoice.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
    if Operation = opRemove then begin
      if AComponent = DateStart then begin
         FDateStartDblClick := nil;
         FDateStartChange := nil;
         DateStart := nil;
      end;
      if AComponent = DateEnd then begin
         FDateEndDblClick := nil;
         FDateEndChange := nil;
         DateEnd := nil;
      end;
    end;
end;

procedure TPeriodChoice.OnDblClick(Sender: TObject);
begin
  Execute;
  if (Sender = DateStart) and Assigned(FDateStartDblClick) then
     FDateStartDblClick(Sender);
  if (Sender = DateEnd) and Assigned(FDateEndDblClick) then
     FDateEndDblClick(Sender);
end;

procedure TPeriodChoice.OnShow(Sender: TObject);
begin
 if Assigned(FOnShow) then
    FOnShow(Sender);
 if Assigned(DateStart) then
    if DateStart.Date = -700000 then
       DateStart.Date := Date;
 if Assigned(DateEnd) then
    if DateEnd.Date = -700000 then
       DateEnd.Date := Date;
end;

procedure TPeriodChoice.SetDateEnd(const Value: TcxDateEdit);
begin
  FDateEnd := Value;
  if Assigned(FDateEnd) then begin
     FDateEndDblClick := FDateEnd.OnDblClick;
     FDateEnd.OnDblClick := OnDblClick;
  end;
end;

procedure TPeriodChoice.SetDateStart(const Value: TcxDateEdit);
begin
  FDateStart := Value;
  if Assigned(FDateStart) then begin
     FDateStartDblClick := FDateStart.OnDblClick;
     FDateStart.OnDblClick := OnDblClick;
  end;
end;

{ TWeek }

constructor TWeek.Create(DateStart, DateEnd: TDateTime);
begin
  inherited Create;
  Self.DateStart := DateStart;
  Self.DateEnd := DateEnd;
end;

end.
