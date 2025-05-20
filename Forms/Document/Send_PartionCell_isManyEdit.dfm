object Send_PartionCell_isManyEditForm: TSend_PartionCell_isManyEditForm
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1053#1077#1089#1082#1086#1083#1100#1082#1086' '#1087#1072#1088#1090#1080#1081'>'
  ClientHeight = 449
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actGet
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 100
    Top = 80
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 110
  end
  object cxLabel1: TcxLabel
    Left = 100
    Top = 58
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 311
    Top = 410
    Width = 75
    Height = 25
    Action = actGet_check
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 431
    Top = 410
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 34
    Top = 58
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 32
    Top = 80
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 58
  end
  object cbisMany: TcxCheckBox
    Left = 216
    Top = 80
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 58
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 58
    Caption = #8470
  end
  object cxLabel5: TcxLabel
    Left = 9
    Top = 81
    Caption = '1.'
  end
  object cxLabel3: TcxLabel
    Left = 9
    Top = 108
    Caption = '2.'
  end
  object cxCurrencyEdit1: TcxCurrencyEdit
    Left = 32
    Top = 107
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 58
  end
  object cxTextEdit1: TcxTextEdit
    Left = 100
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 110
  end
  object cxCheckBox1: TcxCheckBox
    Left = 216
    Top = 107
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 12
    Width = 58
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 135
    Caption = '3.'
  end
  object cxCurrencyEdit2: TcxCurrencyEdit
    Left = 32
    Top = 134
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 58
  end
  object cxTextEdit2: TcxTextEdit
    Left = 100
    Top = 134
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 110
  end
  object cxCheckBox2: TcxCheckBox
    Left = 216
    Top = 134
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 16
    Width = 58
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 163
    Caption = '4.'
  end
  object cxCurrencyEdit3: TcxCurrencyEdit
    Left = 32
    Top = 162
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 58
  end
  object cxTextEdit3: TcxTextEdit
    Left = 100
    Top = 298
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 110
  end
  object cxCheckBox3: TcxCheckBox
    Left = 216
    Top = 162
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 20
    Width = 58
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 190
    Caption = '5.'
  end
  object cxCurrencyEdit4: TcxCurrencyEdit
    Left = 32
    Top = 189
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 58
  end
  object cxTextEdit4: TcxTextEdit
    Left = 100
    Top = 189
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 110
  end
  object cxCheckBox4: TcxCheckBox
    Left = 216
    Top = 189
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 24
    Width = 58
  end
  object cxLabel9: TcxLabel
    Left = 9
    Top = 217
    Caption = '6.'
  end
  object cxLabel10: TcxLabel
    Left = 9
    Top = 244
    Caption = '7.'
  end
  object cxLabel11: TcxLabel
    Left = 8
    Top = 271
    Caption = '8.'
  end
  object cxLabel12: TcxLabel
    Left = 8
    Top = 299
    Caption = '9.'
  end
  object cxLabel13: TcxLabel
    Left = 8
    Top = 326
    Caption = '10.'
  end
  object cxCurrencyEdit5: TcxCurrencyEdit
    Left = 32
    Top = 326
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 58
  end
  object cxCurrencyEdit6: TcxCurrencyEdit
    Left = 32
    Top = 298
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 58
  end
  object cxCurrencyEdit7: TcxCurrencyEdit
    Left = 32
    Top = 270
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 58
  end
  object cxCurrencyEdit8: TcxCurrencyEdit
    Left = 32
    Top = 243
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 33
    Width = 58
  end
  object cxCurrencyEdit9: TcxCurrencyEdit
    Left = 32
    Top = 216
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 34
    Width = 58
  end
  object cxTextEdit5: TcxTextEdit
    Left = 100
    Top = 216
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 110
  end
  object cxTextEdit6: TcxTextEdit
    Left = 100
    Top = 243
    Properties.ReadOnly = True
    TabOrder = 36
    Width = 110
  end
  object cxTextEdit7: TcxTextEdit
    Left = 100
    Top = 270
    Properties.ReadOnly = True
    TabOrder = 37
    Width = 110
  end
  object cxTextEdit8: TcxTextEdit
    Left = 100
    Top = 326
    Properties.ReadOnly = True
    TabOrder = 38
    Width = 110
  end
  object cxCheckBox5: TcxCheckBox
    Left = 216
    Top = 216
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 39
    Width = 58
  end
  object cxCheckBox6: TcxCheckBox
    Left = 216
    Top = 244
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 40
    Width = 58
  end
  object cxCheckBox7: TcxCheckBox
    Left = 216
    Top = 270
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 41
    Width = 58
  end
  object cxCheckBox8: TcxCheckBox
    Left = 216
    Top = 299
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 42
    Width = 58
  end
  object cxCheckBox9: TcxCheckBox
    Left = 216
    Top = 326
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 43
    Width = 58
  end
  object cxTextEdit9: TcxTextEdit
    Left = 100
    Top = 162
    Properties.ReadOnly = True
    TabOrder = 44
    Width = 110
  end
  object cxTextEdit10: TcxTextEdit
    Left = 396
    Top = 80
    Properties.ReadOnly = True
    TabOrder = 45
    Width = 110
  end
  object cxLabel14: TcxLabel
    Left = 396
    Top = 58
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxLabel15: TcxLabel
    Left = 328
    Top = 58
    Caption = #1050#1086#1076
  end
  object cxCurrencyEdit10: TcxCurrencyEdit
    Left = 328
    Top = 80
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 58
  end
  object cxCheckBox10: TcxCheckBox
    Left = 512
    Top = 80
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 49
    Width = 58
  end
  object cxLabel16: TcxLabel
    Left = 305
    Top = 58
    Caption = #8470
  end
  object cxLabel17: TcxLabel
    Left = 305
    Top = 81
    Caption = '12.'
  end
  object cxLabel18: TcxLabel
    Left = 305
    Top = 108
    Caption = '13.'
  end
  object cxCurrencyEdit11: TcxCurrencyEdit
    Left = 328
    Top = 107
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 53
    Width = 58
  end
  object cxTextEdit11: TcxTextEdit
    Left = 396
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 54
    Width = 110
  end
  object cxCheckBox11: TcxCheckBox
    Left = 512
    Top = 107
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 55
    Width = 58
  end
  object cxLabel19: TcxLabel
    Left = 304
    Top = 135
    Caption = '14.'
  end
  object cxCurrencyEdit12: TcxCurrencyEdit
    Left = 328
    Top = 134
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 58
  end
  object cxTextEdit12: TcxTextEdit
    Left = 396
    Top = 134
    Properties.ReadOnly = True
    TabOrder = 58
    Width = 110
  end
  object cxCheckBox12: TcxCheckBox
    Left = 512
    Top = 134
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 59
    Width = 58
  end
  object cxLabel20: TcxLabel
    Left = 304
    Top = 163
    Caption = '15.'
  end
  object cxCurrencyEdit13: TcxCurrencyEdit
    Left = 328
    Top = 162
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 61
    Width = 58
  end
  object cxTextEdit13: TcxTextEdit
    Left = 396
    Top = 298
    Properties.ReadOnly = True
    TabOrder = 62
    Width = 110
  end
  object cxCheckBox13: TcxCheckBox
    Left = 512
    Top = 162
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 63
    Width = 58
  end
  object cxLabel21: TcxLabel
    Left = 304
    Top = 190
    Caption = '16.'
  end
  object cxCurrencyEdit14: TcxCurrencyEdit
    Left = 328
    Top = 189
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 65
    Width = 58
  end
  object cxTextEdit14: TcxTextEdit
    Left = 396
    Top = 189
    Properties.ReadOnly = True
    TabOrder = 66
    Width = 110
  end
  object cxCheckBox14: TcxCheckBox
    Left = 512
    Top = 189
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 67
    Width = 58
  end
  object cxLabel22: TcxLabel
    Left = 305
    Top = 217
    Caption = '17.'
  end
  object cxLabel23: TcxLabel
    Left = 305
    Top = 244
    Caption = '18.'
  end
  object cxLabel24: TcxLabel
    Left = 305
    Top = 271
    Caption = '19.'
  end
  object cxLabel25: TcxLabel
    Left = 305
    Top = 299
    Caption = '20.'
  end
  object cxLabel26: TcxLabel
    Left = 305
    Top = 327
    Caption = '21.'
  end
  object cxCurrencyEdit15: TcxCurrencyEdit
    Left = 328
    Top = 326
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 73
    Width = 58
  end
  object cxCurrencyEdit16: TcxCurrencyEdit
    Left = 328
    Top = 298
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 74
    Width = 58
  end
  object cxCurrencyEdit17: TcxCurrencyEdit
    Left = 328
    Top = 270
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 75
    Width = 58
  end
  object cxCurrencyEdit18: TcxCurrencyEdit
    Left = 328
    Top = 243
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 76
    Width = 58
  end
  object cxCurrencyEdit19: TcxCurrencyEdit
    Left = 328
    Top = 216
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 77
    Width = 58
  end
  object cxTextEdit15: TcxTextEdit
    Left = 396
    Top = 216
    Properties.ReadOnly = True
    TabOrder = 78
    Width = 110
  end
  object cxTextEdit16: TcxTextEdit
    Left = 396
    Top = 243
    Properties.ReadOnly = True
    TabOrder = 79
    Width = 110
  end
  object cxTextEdit17: TcxTextEdit
    Left = 396
    Top = 270
    Properties.ReadOnly = True
    TabOrder = 80
    Width = 110
  end
  object cxTextEdit18: TcxTextEdit
    Left = 396
    Top = 326
    Properties.ReadOnly = True
    TabOrder = 81
    Width = 110
  end
  object cxCheckBox15: TcxCheckBox
    Left = 512
    Top = 216
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 82
    Width = 58
  end
  object cxCheckBox16: TcxCheckBox
    Left = 512
    Top = 243
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 83
    Width = 58
  end
  object cxCheckBox17: TcxCheckBox
    Left = 512
    Top = 270
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 84
    Width = 58
  end
  object cxCheckBox18: TcxCheckBox
    Left = 512
    Top = 299
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 85
    Width = 58
  end
  object cxCheckBox19: TcxCheckBox
    Left = 512
    Top = 326
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 86
    Width = 58
  end
  object cxTextEdit19: TcxTextEdit
    Left = 396
    Top = 162
    Properties.ReadOnly = True
    TabOrder = 87
    Width = 110
  end
  object cxLabel27: TcxLabel
    Left = 8
    Top = 355
    Caption = '11.'
  end
  object cxCurrencyEdit20: TcxCurrencyEdit
    Left = 32
    Top = 354
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 89
    Width = 58
  end
  object cxTextEdit20: TcxTextEdit
    Left = 100
    Top = 354
    Properties.ReadOnly = True
    TabOrder = 90
    Width = 110
  end
  object cxCheckBox20: TcxCheckBox
    Left = 216
    Top = 354
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 91
    Width = 58
  end
  object cxLabel28: TcxLabel
    Left = 305
    Top = 355
    Caption = '22.'
  end
  object cxCurrencyEdit21: TcxCurrencyEdit
    Left = 328
    Top = 354
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 93
    Width = 58
  end
  object cxTextEdit21: TcxTextEdit
    Left = 396
    Top = 354
    Properties.ReadOnly = True
    TabOrder = 94
    Width = 110
  end
  object cxCheckBox21: TcxCheckBox
    Left = 512
    Top = 354
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 95
    Width = 58
  end
  object cxLabel29: TcxLabel
    Left = 25
    Top = 5
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  end
  object ceGooods: TcxButtonEdit
    Left = 25
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 97
    Width = 249
  end
  object ceGooodsKind: TcxButtonEdit
    Left = 287
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 98
    Width = 80
  end
  object cxLabel30: TcxLabel
    Left = 287
    Top = 5
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object ActionList: TActionList
    Left = 64
    Top = 386
    object actGet: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_check: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMany_byReport
      StoredProcList = <
        item
          StoredProc = spUpdate_isMany_byReport
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spUpdate_isMany_byReport: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellNum'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany'
        Value = ''
        Component = cbisMany
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 408
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany'
        Value = Null
        Component = cbisMany
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellNum_last'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 386
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Send_PartionCell_MI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSW'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isLock_record'
        Value = Null
        Component = FormParams
        ComponentItem = 'ioIsLock_record'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 386
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 216
    Top = 392
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 128
    Top = 384
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooods
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptCode_user'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 129
    Top = 9
  end
  object GuidesGooodsKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsKind_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKind_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 313
    Top = 20
  end
end
