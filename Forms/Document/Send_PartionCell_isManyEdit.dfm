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
  object edName1: TcxTextEdit
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
  object edCode1: TcxCurrencyEdit
    Left = 32
    Top = 80
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 58
  end
  object cbisMany1: TcxCheckBox
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
  object edCode2: TcxCurrencyEdit
    Left = 32
    Top = 107
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 58
  end
  object edName2: TcxTextEdit
    Left = 100
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 110
  end
  object cbisMany2: TcxCheckBox
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
  object edCode3: TcxCurrencyEdit
    Left = 32
    Top = 134
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 58
  end
  object edName3: TcxTextEdit
    Left = 100
    Top = 134
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 110
  end
  object cbisMany3: TcxCheckBox
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
  object edCode4: TcxCurrencyEdit
    Left = 32
    Top = 162
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 58
  end
  object edName9: TcxTextEdit
    Left = 100
    Top = 298
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 110
  end
  object cbisMany4: TcxCheckBox
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
  object edCode5: TcxCurrencyEdit
    Left = 32
    Top = 189
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 58
  end
  object edName5: TcxTextEdit
    Left = 100
    Top = 189
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 110
  end
  object cbisMany5: TcxCheckBox
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
    Left = 9
    Top = 299
    Caption = '9.'
  end
  object cxLabel13: TcxLabel
    Left = 8
    Top = 327
    Caption = '10.'
  end
  object edCode10: TcxCurrencyEdit
    Left = 32
    Top = 326
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 58
  end
  object edCode9: TcxCurrencyEdit
    Left = 32
    Top = 298
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 58
  end
  object edCode8: TcxCurrencyEdit
    Left = 32
    Top = 270
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 58
  end
  object edCode7: TcxCurrencyEdit
    Left = 32
    Top = 243
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 33
    Width = 58
  end
  object edCode6: TcxCurrencyEdit
    Left = 32
    Top = 216
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 34
    Width = 58
  end
  object edName6: TcxTextEdit
    Left = 100
    Top = 216
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 110
  end
  object edName7: TcxTextEdit
    Left = 100
    Top = 243
    Properties.ReadOnly = True
    TabOrder = 36
    Width = 110
  end
  object edName8: TcxTextEdit
    Left = 100
    Top = 270
    Properties.ReadOnly = True
    TabOrder = 37
    Width = 110
  end
  object edName10: TcxTextEdit
    Left = 100
    Top = 326
    Properties.ReadOnly = True
    TabOrder = 38
    Width = 110
  end
  object cbisMany6: TcxCheckBox
    Left = 216
    Top = 216
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 39
    Width = 58
  end
  object cbisMany7: TcxCheckBox
    Left = 216
    Top = 243
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 40
    Width = 58
  end
  object cbisMany8: TcxCheckBox
    Left = 216
    Top = 270
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 41
    Width = 58
  end
  object cbisMany9: TcxCheckBox
    Left = 216
    Top = 298
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 42
    Width = 58
  end
  object cbisMany10: TcxCheckBox
    Left = 216
    Top = 326
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 43
    Width = 58
  end
  object edName4: TcxTextEdit
    Left = 100
    Top = 162
    Properties.ReadOnly = True
    TabOrder = 44
    Width = 110
  end
  object edName12: TcxTextEdit
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
  object edCode12: TcxCurrencyEdit
    Left = 328
    Top = 80
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 58
  end
  object cbisMany12: TcxCheckBox
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
  object edCode13: TcxCurrencyEdit
    Left = 328
    Top = 107
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 53
    Width = 58
  end
  object edName13: TcxTextEdit
    Left = 396
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 54
    Width = 110
  end
  object cbisMany13: TcxCheckBox
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
  object edCode14: TcxCurrencyEdit
    Left = 328
    Top = 134
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 58
  end
  object edName14: TcxTextEdit
    Left = 396
    Top = 134
    Properties.ReadOnly = True
    TabOrder = 58
    Width = 110
  end
  object cbisMany14: TcxCheckBox
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
  object edCode15: TcxCurrencyEdit
    Left = 328
    Top = 162
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 61
    Width = 58
  end
  object edName20: TcxTextEdit
    Left = 396
    Top = 298
    Properties.ReadOnly = True
    TabOrder = 62
    Width = 110
  end
  object cbisMany15: TcxCheckBox
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
  object edCode16: TcxCurrencyEdit
    Left = 328
    Top = 189
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 65
    Width = 58
  end
  object edName16: TcxTextEdit
    Left = 396
    Top = 189
    Properties.ReadOnly = True
    TabOrder = 66
    Width = 110
  end
  object cbisMany16: TcxCheckBox
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
  object edCode21: TcxCurrencyEdit
    Left = 328
    Top = 326
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 73
    Width = 58
  end
  object edCode20: TcxCurrencyEdit
    Left = 328
    Top = 298
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 74
    Width = 58
  end
  object edCode19: TcxCurrencyEdit
    Left = 328
    Top = 270
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 75
    Width = 58
  end
  object edCode18: TcxCurrencyEdit
    Left = 328
    Top = 243
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 76
    Width = 58
  end
  object edCode17: TcxCurrencyEdit
    Left = 328
    Top = 216
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 77
    Width = 58
  end
  object edName17: TcxTextEdit
    Left = 396
    Top = 216
    Properties.ReadOnly = True
    TabOrder = 78
    Width = 110
  end
  object edName18: TcxTextEdit
    Left = 396
    Top = 243
    Properties.ReadOnly = True
    TabOrder = 79
    Width = 110
  end
  object edName19: TcxTextEdit
    Left = 396
    Top = 270
    Properties.ReadOnly = True
    TabOrder = 80
    Width = 110
  end
  object edName21: TcxTextEdit
    Left = 396
    Top = 326
    Properties.ReadOnly = True
    TabOrder = 81
    Width = 110
  end
  object cbisMany17: TcxCheckBox
    Left = 512
    Top = 216
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 82
    Width = 58
  end
  object cbisMany18: TcxCheckBox
    Left = 512
    Top = 243
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 83
    Width = 58
  end
  object cbisMany19: TcxCheckBox
    Left = 512
    Top = 270
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 84
    Width = 58
  end
  object cbisMany20: TcxCheckBox
    Left = 512
    Top = 298
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 85
    Width = 58
  end
  object cbisMany21: TcxCheckBox
    Left = 512
    Top = 326
    Hint = #1076#1072'/'#1085#1077#1090
    Caption = #1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 86
    Width = 58
  end
  object edName15: TcxTextEdit
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
  object edCode11: TcxCurrencyEdit
    Left = 32
    Top = 354
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 89
    Width = 58
  end
  object edName11: TcxTextEdit
    Left = 100
    Top = 354
    Properties.ReadOnly = True
    TabOrder = 90
    Width = 110
  end
  object cbisMany11: TcxCheckBox
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
  object edCode22: TcxCurrencyEdit
    Left = 328
    Top = 354
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 93
    Width = 58
  end
  object edName22: TcxTextEdit
    Left = 396
    Top = 354
    Properties.ReadOnly = True
    TabOrder = 94
    Width = 110
  end
  object cbisMany22: TcxCheckBox
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
    Width = 332
  end
  object ceGooodsKind: TcxButtonEdit
    Left = 365
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 98
    Width = 87
  end
  object cxLabel30: TcxLabel
    Left = 365
    Top = 5
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel31: TcxLabel
    Left = 458
    Top = 5
    Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
  end
  object cePartionGoods: TcxTextEdit
    Left = 458
    Top = 25
    TabOrder = 101
    Width = 110
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
      StoredProc = spUpdate_isMany_byReport_all
      StoredProcList = <
        item
          StoredProc = spUpdate_isMany_byReport_all
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spUpdate_isMany_byReport_all: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Send_isMany_byReport_all'
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
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGooodsKindId'
        Value = Null
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = cePartionGoods
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_6'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_7'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_7'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_8'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_8'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_9'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_9'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_10'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_10'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_11'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_11'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_12'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_12'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_13'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_13'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_14'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_14'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_15'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_15'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_16'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_16'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_17'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_17'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_18'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_18'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_19'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_19'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_20'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_20'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_21'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_21'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_22'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_22'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_1'
        Value = ''
        Component = cbisMany1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_2'
        Value = ''
        Component = cbisMany2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_3'
        Value = ''
        Component = cbisMany3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_4'
        Value = ''
        Component = cbisMany4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_5'
        Value = ''
        Component = cbisMany5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_6'
        Value = ''
        Component = cbisMany6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_7'
        Value = ''
        Component = cbisMany7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_8'
        Value = ''
        Component = cbisMany8
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_9'
        Value = ''
        Component = cbisMany9
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_10'
        Value = ''
        Component = cbisMany10
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_11'
        Value = ''
        Component = cbisMany11
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_13'
        Value = ''
        Component = cbisMany12
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_13'
        Value = ''
        Component = cbisMany13
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_14'
        Value = ''
        Component = cbisMany14
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_15'
        Value = ''
        Component = cbisMany15
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_16'
        Value = ''
        Component = cbisMany16
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_17'
        Value = ''
        Component = cbisMany17
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_18'
        Value = ''
        Component = cbisMany18
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_19'
        Value = ''
        Component = cbisMany19
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_20'
        Value = ''
        Component = cbisMany20
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_21'
        Value = ''
        Component = cbisMany21
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMany_22'
        Value = ''
        Component = cbisMany22
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 400
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionGoodsDate'
        Value = Null
        Component = cePartionGoods
        DataType = ftDateTime
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
      end
      item
        Name = 'GoodsKindId'
        Value = Null
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = Null
        Component = GuidesGooodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 386
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Send_PartionCell_isManyAll'
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
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_1'
        Value = Null
        Component = edCode1
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_1'
        Value = ''
        Component = edName1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_1'
        Value = Null
        Component = cbisMany1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_2'
        Value = Null
        Component = edCode2
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_2'
        Value = ''
        Component = edName2
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_2'
        Value = Null
        Component = cbisMany2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_3'
        Value = Null
        Component = edCode3
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_3'
        Value = ''
        Component = edName3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_3'
        Value = Null
        Component = cbisMany3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_4'
        Value = Null
        Component = edCode4
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_4'
        Value = ''
        Component = edName4
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_4'
        Value = Null
        Component = cbisMany4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_5'
        Value = Null
        Component = edCode5
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_5'
        Value = ''
        Component = edName5
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_5'
        Value = Null
        Component = cbisMany5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_6'
        Value = Null
        Component = edCode6
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_6'
        Value = ''
        Component = edName6
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_6'
        Value = Null
        Component = cbisMany6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_7'
        Value = Null
        Component = edCode7
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_7'
        Value = ''
        Component = edName7
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_7'
        Value = Null
        Component = cbisMany7
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_8'
        Value = Null
        Component = edCode8
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_8'
        Value = ''
        Component = edName8
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_8'
        Value = Null
        Component = cbisMany8
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_9'
        Value = Null
        Component = edCode9
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_9'
        Value = ''
        Component = edName9
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_9'
        Value = Null
        Component = cbisMany9
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_10'
        Value = Null
        Component = edCode10
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_10'
        Value = ''
        Component = edName10
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_10'
        Value = Null
        Component = cbisMany10
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_11'
        Value = Null
        Component = edCode11
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_11'
        Value = ''
        Component = edName11
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_11'
        Value = Null
        Component = cbisMany11
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_12'
        Value = Null
        Component = edCode12
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_12'
        Value = ''
        Component = edName12
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_12'
        Value = Null
        Component = cbisMany12
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_13'
        Value = Null
        Component = edCode13
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_13'
        Value = ''
        Component = edName13
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_13'
        Value = Null
        Component = cbisMany13
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_14'
        Value = Null
        Component = edCode14
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_14'
        Value = ''
        Component = edName14
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_14'
        Value = Null
        Component = cbisMany14
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_15'
        Value = Null
        Component = edCode15
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_15'
        Value = ''
        Component = edName15
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_15'
        Value = Null
        Component = cbisMany15
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_16'
        Value = Null
        Component = edCode16
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_16'
        Value = ''
        Component = edName16
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_16'
        Value = Null
        Component = cbisMany16
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_17'
        Value = Null
        Component = edCode17
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_17'
        Value = ''
        Component = edName17
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_17'
        Value = Null
        Component = cbisMany17
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_18'
        Value = Null
        Component = edCode18
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_18'
        Value = ''
        Component = edName18
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_18'
        Value = Null
        Component = cbisMany18
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_19'
        Value = Null
        Component = edCode19
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_19'
        Value = ''
        Component = edName19
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_19'
        Value = Null
        Component = cbisMany19
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_20'
        Value = Null
        Component = edCode20
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_20'
        Value = ''
        Component = edName20
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_20'
        Value = Null
        Component = cbisMany20
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_21'
        Value = Null
        Component = edCode21
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_21'
        Value = ''
        Component = edName21
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_21'
        Value = Null
        Component = cbisMany21
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellCode_22'
        Value = Null
        Component = edCode22
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName_22'
        Value = ''
        Component = edName22
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMany_22'
        Value = Null
        Component = cbisMany22
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_1'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_2'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_3'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_4'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_5'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_6'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_6'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_7'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_7'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_8'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_8'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_9'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_9'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_10'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_10'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_11'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_11'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_12'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_12'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_13'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_13'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_14'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_14'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_15'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_15'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_16'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_16'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_17'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_17'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_18'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_18'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_19'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_19'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_20'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_20'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_21'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_21'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId_22'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_22'
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
    Left = 398
    Top = 20
  end
end
