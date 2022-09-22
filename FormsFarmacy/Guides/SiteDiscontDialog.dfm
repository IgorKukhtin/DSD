object SiteDiscontDialogForm: TSiteDiscontDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1089#1072#1081#1090#1072
  ClientHeight = 247
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 74
    Top = 209
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object cxButton2: TcxButton
    Left = 215
    Top = 209
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object ceDiscontPercentSite: TcxCurrencyEdit
    Left = 41
    Top = 114
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.0000'
    TabOrder = 2
    Width = 128
  end
  object cxLabel6: TcxLabel
    Left = 41
    Top = 91
    Caption = '% '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
  end
  object ceDiscontAmountSite: TcxCurrencyEdit
    Left = 205
    Top = 114
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 3
    Width = 128
  end
  object cxLabel1: TcxLabel
    Left = 205
    Top = 91
    Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1089#1072#1081#1090#1072
  end
  object deEnd: TcxDateEdit
    Left = 205
    Top = 53
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 1
    Width = 85
  end
  object cxLabel2: TcxLabel
    Left = 205
    Top = 30
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1082#1080#1076#1082#1080
  end
  object deStart: TcxDateEdit
    Left = 41
    Top = 53
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 0
    Width = 85
  end
  object cxLabel3: TcxLabel
    Left = 41
    Top = 30
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1086' '#1089#1082#1080#1076#1082#1080
  end
  object ceMultiplicityDiscontSite: TcxCurrencyEdit
    Left = 41
    Top = 170
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###; ;'
    TabOrder = 10
    Width = 128
  end
  object cxLabel4: TcxLabel
    Left = 41
    Top = 147
    Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077' (0 '#1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1100#1089#1103')'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 295
    Top = 106
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
    StorageType = stStream
    Left = 200
    Top = 69
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'DiscontSiteStart'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteEnd'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontPercentSite'
        Value = Null
        Component = ceDiscontPercentSite
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontAmountSite'
        Value = Null
        Component = ceDiscontAmountSite
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MultiplicityDiscontSite'
        Value = Null
        Component = ceMultiplicityDiscontSite
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 29
    Top = 74
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 120
    Top = 100
  end
end
