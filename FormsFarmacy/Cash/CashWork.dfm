object CashWorkForm: TCashWorkForm
  Left = 367
  Top = 319
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1082#1072#1089#1089#1086#1081
  ClientHeight = 167
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object laRest: TLabel
    Left = 14
    Top = 84
    Width = 3
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Gauge: TGauge
    Left = 15
    Top = 119
    Width = 125
    Height = 19
    Progress = 0
    Visible = False
  end
  object ceInputOutput: TcxCurrencyEdit
    Left = 10
    Top = 16
    Margins.Left = 1
    Margins.Top = 1
    AutoSize = False
    Properties.DisplayFormat = ',0.00'
    TabOrder = 0
    Height = 21
    Width = 121
  end
  object Button1: TButton
    Left = 135
    Top = 14
    Width = 90
    Height = 25
    Caption = #1042#1085#1077#1089#1090#1080' '#1089#1091#1084#1084#1091
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 246
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Z - '#1086#1090#1095#1077#1090
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 96
    Top = 45
    Width = 75
    Height = 25
    Caption = '0 '#1095#1077#1082
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 180
    Top = 45
    Width = 141
    Height = 25
    Caption = #1042#1085#1077#1089#1090#1080' '#1074#1089#1077' '#1072#1088#1090#1080#1082#1091#1083#1099
    TabOrder = 4
    Visible = False
    OnClick = Button4Click
  end
  object BitBtn1: TBitBtn
    Left = 142
    Top = 116
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 5
  end
  object Button5: TButton
    Left = 14
    Top = 45
    Width = 75
    Height = 25
    Caption = 'X - '#1086#1090#1095#1077#1090
    TabOrder = 6
    OnClick = Button5Click
  end
  object btDeleteAllArticul: TButton
    Left = 14
    Top = 80
    Width = 127
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1072#1088#1090#1080#1082#1091#1083#1099
    TabOrder = 7
    OnClick = btDeleteAllArticulClick
  end
  object Button6: TButton
    Left = 150
    Top = 80
    Width = 75
    Height = 25
    Caption = #1042#1088#1077#1084#1103
    TabOrder = 8
    OnClick = Button6Click
  end
  object Button7: TButton
    Tag = 1
    Left = 231
    Top = 14
    Width = 90
    Height = 25
    Caption = #1042#1099#1085#1077#1089#1090#1080' '#1089#1091#1084#1084#1091
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button8: TButton
    Left = 246
    Top = 80
    Width = 75
    Height = 25
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
    TabOrder = 10
    OnClick = Button8Click
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 112
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Properties.Strings = (
          'Width')
      end
      item
        Properties.Strings = (
          'Height')
      end
      item
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Properties.Strings = (
          'Height')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 24
    Top = 112
  end
  object spGet_Money_CashRegister: TdsdStoredProc
    StoredProcName = 'gpGet_Money_CashRegister'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCashRegisterName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckOut'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckIn'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummsCash'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 57
    Top = 11
  end
end
