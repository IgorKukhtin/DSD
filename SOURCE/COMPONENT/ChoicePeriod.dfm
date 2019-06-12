object PeriodChoiceForm: TPeriodChoiceForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1077#1088#1080#1086#1076#1072
  ClientHeight = 233
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxDateEnd: TcxDateEdit
    Left = 200
    Top = 44
    Properties.DateButtons = [btnClear, btnToday]
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.WeekNumbers = True
    TabOrder = 0
    Width = 121
  end
  object cxDateStart: TcxDateEdit
    Left = 200
    Top = 16
    Properties.DateButtons = [btnClear, btnToday]
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 1
    Width = 121
  end
  object cbMonth: TcxComboBox
    Left = 200
    Top = 98
    Properties.OnChange = cbMonthPropertiesChange
    TabOrder = 2
    OnEnter = cbMonthEnter
    Width = 121
  end
  object cbQuarter: TcxComboBox
    Left = 200
    Top = 127
    Properties.Items.Strings = (
      'I '#1082#1074#1072#1088#1090#1072#1083
      'II '#1082#1074#1072#1088#1090#1072#1083
      'III '#1082#1074#1072#1088#1090#1072#1083
      'IV '#1082#1074#1072#1088#1090#1072#1083)
    Properties.OnChange = cbQuarterPropertiesChange
    TabOrder = 3
    OnEnter = cbQuarterEnter
    Width = 121
  end
  object cxLabel1: TcxLabel
    Left = 104
    Top = 18
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072':'
  end
  object seYear: TcxSpinEdit
    Left = 200
    Top = 156
    Properties.OnChange = seYearPropertiesChange
    TabOrder = 5
    OnEnter = seYearEnter
    Width = 121
  end
  object cxLabel3: TcxLabel
    Left = 156
    Top = 100
    Caption = #1052#1077#1089#1103#1094':'
  end
  object cxLabel4: TcxLabel
    Left = 144
    Top = 129
    Caption = #1050#1074#1072#1088#1090#1072#1083':'
  end
  object cxLabel5: TcxLabel
    Left = 168
    Top = 158
    Caption = #1043#1086#1076':'
  end
  object cbWeek: TcxComboBox
    Left = 200
    Top = 70
    Properties.OnChange = cbWeekPropertiesChange
    TabOrder = 9
    OnEnter = cbWeekEnter
    Width = 121
  end
  object cxLabel2: TcxLabel
    Left = 110
    Top = 46
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072':'
  end
  object cxLabel6: TcxLabel
    Left = 149
    Top = 72
    Caption = #1053#1077#1076#1077#1083#1103':'
  end
  object bbOk: TcxButton
    Left = 54
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 12
  end
  object bbCancel: TcxButton
    Left = 190
    Top = 192
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 13
  end
  object rbDay: TcxRadioButton
    Left = 8
    Top = 34
    Width = 65
    Height = 17
    Caption = #1044#1077#1085#1100
    Checked = True
    TabOrder = 14
    TabStop = True
  end
  object rbWeek: TcxRadioButton
    Left = 8
    Top = 72
    Width = 113
    Height = 17
    Caption = #1053#1077#1076#1077#1083#1103
    TabOrder = 15
    OnClick = rbWeekClick
  end
  object rbMonth: TcxRadioButton
    Left = 8
    Top = 100
    Width = 113
    Height = 17
    Caption = #1052#1077#1089#1103#1094
    TabOrder = 16
    OnClick = rbMonthClick
  end
  object rbQuater: TcxRadioButton
    Left = 8
    Top = 129
    Width = 113
    Height = 17
    Caption = #1050#1074#1072#1088#1090#1072#1083
    TabOrder = 17
    OnClick = rbQuaterClick
  end
  object rbYear: TcxRadioButton
    Left = 8
    Top = 158
    Width = 113
    Height = 17
    Caption = #1043#1086#1076
    TabOrder = 18
    OnClick = rbYearClick
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'ChoicePeriod.ini'
    Left = 120
    Top = 144
  end
end
