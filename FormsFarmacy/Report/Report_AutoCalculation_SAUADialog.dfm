object Report_AutoCalculation_SAUADialogForm: TReport_AutoCalculation_SAUADialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1088#1072#1089#1095#1077#1090' '#1057#1059#1040'>'
  ClientHeight = 404
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 42
    Top = 358
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 358
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 8
    Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
    Caption = #1040#1087#1090#1077#1082#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
  end
  object edRecipient: TcxTextEdit
    Left = 8
    Top = 30
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 338
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 57
    Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
    Caption = #1040#1087#1090#1077#1082#1080' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
  end
  object edAssortment: TcxMemo
    Left = 8
    Top = 80
    Properties.ReadOnly = True
    TabOrder = 5
    Height = 65
    Width = 338
  end
  object deEnd: TcxDateEdit
    Left = 165
    Top = 173
    EditValue = 44197d
    Properties.ReadOnly = True
    Properties.ShowTime = False
    TabOrder = 6
    Width = 85
  end
  object deStart: TcxDateEdit
    Left = 165
    Top = 151
    EditValue = 44197d
    Properties.ReadOnly = True
    Properties.ShowTime = False
    TabOrder = 7
    Width = 85
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 174
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078':'
  end
  object cxLabel3: TcxLabel
    Left = 9
    Top = 152
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078':'
  end
  object ceCountPharmacies: TcxCurrencyEdit
    Left = 190
    Top = 236
    Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
    EditValue = 1.000000000000000000
    ParentShowHint = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 10
    Width = 60
  end
  object ceDaysStock: TcxCurrencyEdit
    Left = 190
    Top = 216
    EditValue = 10.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 60
  end
  object ceThreshold: TcxCurrencyEdit
    Left = 190
    Top = 196
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 60
  end
  object cxLabel7: TcxLabel
    Left = 9
    Top = 237
    Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
    Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel4: TcxLabel
    Left = 9
    Top = 217
    Caption = #1044#1085#1077#1081' '#1079#1072#1087#1072#1089#1072' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103':'
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 197
    Caption = #1055#1086#1088#1086#1075' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1093' '#1087#1088#1086#1076#1072#1078':'
  end
  object cbNeedRound: TcxCheckBox
    Left = 8
    Top = 312
    Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100' '#1086#1082#1088#1091#1075#1083#1103#1090#1100' '#1087#1086' '#1084#1072#1090' '#1087#1088#1080#1085#1094#1080#1087#1091
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 234
  end
  object cbAssortmentRound: TcxCheckBox
    Left = 8
    Top = 329
    Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1086#1082#1088#1091#1075#1083#1103#1090#1100' '#1087#1086' '#1084#1072#1090' '#1087#1088#1080#1085#1094#1080#1087#1091
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 234
  end
  object cbNotCheckNoMCS: TcxCheckBox
    Left = 8
    Top = 294
    Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1055#1088#1086#1076#1072#1078#1080' '#1085#1077' '#1076#1083#1103' '#1053#1058#1047
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 217
  end
  object cbMCSIsClose: TcxCheckBox
    Left = 8
    Top = 277
    Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1059#1073#1080#1090' '#1082#1086#1076' '
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 201
  end
  object cbGoodsClose: TcxCheckBox
    Left = 8
    Top = 260
    Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1047#1072#1082#1088#1099#1090' '#1082#1086#1076
    Properties.ReadOnly = True
    State = cbsChecked
    TabOrder = 20
    Width = 167
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 110
    Top = 69
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
    Left = 111
    Top = 14
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'DateStart'
        Value = 44198d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEnd'
        Value = 44198d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitRecipient'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortment'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = edRecipient
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortmentName'
        Value = Null
        Component = edAssortment
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Threshold'
        Value = Null
        Component = ceThreshold
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaysStock'
        Value = Null
        Component = ceDaysStock
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountPharmacies'
        Value = Null
        Component = ceCountPharmacies
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsClose'
        Value = Null
        Component = cbGoodsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMCSIsClose'
        Value = Null
        Component = cbMCSIsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotCheckNoMCS'
        Value = Null
        Component = cbNotCheckNoMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAssortmentRound'
        Value = Null
        Component = cbAssortmentRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNeedRound'
        Value = Null
        Component = cbNeedRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 262
    Top = 20
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_AutoCalculation_SAUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'DateStart'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEnd'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = edRecipient
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortmentName'
        Value = Null
        Component = edAssortment
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Threshold'
        Value = 1.000000000000000000
        Component = ceThreshold
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaysStock'
        Value = 10.000000000000000000
        Component = ceDaysStock
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountPharmacies'
        Value = 1.000000000000000000
        Component = ceCountPharmacies
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsClose'
        Value = True
        Component = cbGoodsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMCSIsClose'
        Value = False
        Component = cbMCSIsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotCheckNoMCS'
        Value = False
        Component = cbNotCheckNoMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAssortmentRound'
        Value = False
        Component = cbAssortmentRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNeedRound'
        Value = False
        Component = cbNeedRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitRecipient'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitRecipient'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortment'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitAssortment'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 88
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 272
    Top = 152
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 279
    Top = 255
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
