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
    Properties.ShowTime = False
    Properties.WeekNumbers = True
    TabOrder = 0
    Width = 121
  end
  object cxDateStart: TcxDateEdit
    Left = 200
    Top = 16
    Properties.DateButtons = [btnClear, btnToday]
    Properties.ShowTime = False
    TabOrder = 1
    Width = 121
  end
  object cxRadioGroup: TcxRadioGroup
    Left = 0
    Top = 0
    Caption = #1055#1077#1088#1080#1086#1076
    Properties.Items = <
      item
        Caption = #1044#1077#1085#1100
      end
      item
        Caption = #1053#1077#1076#1077#1083#1103
      end
      item
        Caption = #1052#1077#1089#1103#1094
      end
      item
        Caption = #1050#1074#1072#1088#1090#1072#1083
      end
      item
        Caption = #1043#1086#1076
      end>
    ItemIndex = 0
    Style.BorderStyle = ebsNone
    TabOrder = 2
    OnClick = cxRadioGroupClick
    Height = 186
    Width = 81
  end
  object cbMonth: TcxComboBox
    Left = 200
    Top = 98
    Properties.OnChange = seYearPropertiesChange
    TabOrder = 3
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
    Properties.OnChange = seYearPropertiesChange
    TabOrder = 4
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
    TabOrder = 6
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
    Properties.OnChange = seYearPropertiesChange
    TabOrder = 10
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
    TabOrder = 13
  end
  object bbCancel: TcxButton
    Left = 190
    Top = 192
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 14
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 120
    Top = 144
  end
end
