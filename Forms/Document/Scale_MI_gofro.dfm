object Scale_MI_gofroForm: TScale_MI_gofroForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' <'#1043#1086#1092#1088#1086'>'
  ClientHeight = 568
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 177
    Top = 535
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 321
    Top = 535
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 14
    Caption = #1050#1086#1076' '#1087#1086#1076#1076#1086#1085
    Style.TextColor = clBlue
  end
  object edCodeGofro_pd: TcxCurrencyEdit
    Left = 8
    Top = 32
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 101
  end
  object cxLabel3: TcxLabel
    Left = 122
    Top = 14
    Caption = #1055#1086#1076#1076#1086#1085
    Style.TextColor = clBlue
    Style.TextStyle = [fsBold]
  end
  object edGofro_pd: TcxButtonEdit
    Left = 122
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 303
  end
  object edAmount_gofro_pd: TcxCurrencyEdit
    Left = 439
    Top = 32
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 6
    Width = 111
  end
  object cxLabel12: TcxLabel
    Left = 439
    Top = 14
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1076#1076#1086#1085
    Style.TextColor = clBlue
  end
  object cxLabel1: TcxLabel
    Left = 439
    Top = 58
    Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082
    Style.TextColor = clPurple
  end
  object edAmount_gofro_box: TcxCurrencyEdit
    Left = 439
    Top = 76
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 9
    Width = 111
  end
  object cxLabel4: TcxLabel
    Left = 122
    Top = 58
    Caption = #1071#1097#1080#1082
    Style.TextColor = clPurple
    Style.TextStyle = [fsBold]
  end
  object edgofro_box: TcxButtonEdit
    Left = 122
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 303
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 58
    Caption = #1050#1086#1076' '#1103#1097#1080#1082
    Style.TextColor = clPurple
  end
  object edCodegofro_box: TcxCurrencyEdit
    Left = 8
    Top = 76
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 13
    Width = 101
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 106
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-'#1091#1075#1086#1083#1086#1082
    Style.BorderColor = clWindowFrame
    Style.TextColor = clGreen
    Style.TextStyle = []
  end
  object edCodegofro_ugol: TcxCurrencyEdit
    Left = 8
    Top = 124
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 15
    Width = 101
  end
  object edgofro_ugol: TcxButtonEdit
    Left = 122
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 303
  end
  object cxLabel7: TcxLabel
    Left = 122
    Top = 106
    Caption = #1043#1086#1092#1088#1086'-'#1091#1075#1086#1083#1086#1082
    Style.TextColor = clGreen
    Style.TextStyle = [fsBold]
  end
  object edAmount_gofro_ugol: TcxCurrencyEdit
    Left = 439
    Top = 124
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 18
    Width = 111
  end
  object cxLabel8: TcxLabel
    Left = 439
    Top = 106
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1076#1076#1086#1085
    Style.TextColor = clGreen
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 173
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-1'
  end
  object edCodegofro_1: TcxCurrencyEdit
    Left = 8
    Top = 191
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 21
    Width = 101
  end
  object edgofro_1: TcxButtonEdit
    Left = 122
    Top = 191
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 303
  end
  object cxLabel10: TcxLabel
    Left = 122
    Top = 173
    Caption = #1043#1086#1092#1088#1086'-1'
  end
  object edAmount_gofro_1: TcxCurrencyEdit
    Left = 439
    Top = 186
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 24
    Width = 111
  end
  object cxLabel11: TcxLabel
    Left = 439
    Top = 173
    Caption = #1050#1086#1083'-'#1074#1086' - 1'
  end
  object cxLabel13: TcxLabel
    Left = 8
    Top = 213
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-2'
  end
  object edCodegofro_2: TcxCurrencyEdit
    Left = 8
    Top = 228
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 27
    Width = 101
  end
  object edgofro_2: TcxButtonEdit
    Left = 122
    Top = 231
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 303
  end
  object cxLabel14: TcxLabel
    Left = 122
    Top = 213
    Caption = #1043#1086#1092#1088#1086'-2'
  end
  object edAmount_gofro_2: TcxCurrencyEdit
    Left = 439
    Top = 231
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 30
    Width = 111
  end
  object cxLabel15: TcxLabel
    Left = 439
    Top = 213
    Caption = #1050#1086#1083'-'#1074#1086' - 2'
  end
  object cxLabel16: TcxLabel
    Left = 8
    Top = 255
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-3'
  end
  object edCodegofro_3: TcxCurrencyEdit
    Left = 8
    Top = 273
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 33
    Width = 101
  end
  object edgofro_3: TcxButtonEdit
    Left = 122
    Top = 273
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 34
    Width = 303
  end
  object cxLabel17: TcxLabel
    Left = 122
    Top = 255
    Caption = #1043#1086#1092#1088#1086'-3'
  end
  object edAmount_gofro_3: TcxCurrencyEdit
    Left = 439
    Top = 273
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 36
    Width = 111
  end
  object cxLabel18: TcxLabel
    Left = 439
    Top = 255
    Caption = #1050#1086#1083'-'#1074#1086' - 3'
  end
  object cxLabel19: TcxLabel
    Left = 8
    Top = 295
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-4'
  end
  object edCodegofro_4: TcxCurrencyEdit
    Left = 8
    Top = 313
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 39
    Width = 101
  end
  object edgofro_4: TcxButtonEdit
    Left = 122
    Top = 313
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 40
    Width = 303
  end
  object cxLabel20: TcxLabel
    Left = 122
    Top = 295
    Caption = #1043#1086#1092#1088#1086'-4'
  end
  object edAmount_gofro_4: TcxCurrencyEdit
    Left = 439
    Top = 313
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 42
    Width = 111
  end
  object cxLabel21: TcxLabel
    Left = 439
    Top = 295
    Caption = #1050#1086#1083'-'#1074#1086' - 4'
  end
  object cxLabel22: TcxLabel
    Left = 8
    Top = 336
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-5'
  end
  object edCodegofro_5: TcxCurrencyEdit
    Left = 8
    Top = 353
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 45
    Width = 101
  end
  object edgofro_5: TcxButtonEdit
    Left = 122
    Top = 353
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 46
    Width = 303
  end
  object cxLabel23: TcxLabel
    Left = 122
    Top = 336
    Caption = #1043#1086#1092#1088#1086'-5'
  end
  object edAmount_gofro_5: TcxCurrencyEdit
    Left = 439
    Top = 353
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 48
    Width = 111
  end
  object cxLabel24: TcxLabel
    Left = 439
    Top = 336
    Caption = #1050#1086#1083'-'#1074#1086' - 5'
  end
  object cxLabel25: TcxLabel
    Left = 8
    Top = 377
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-6'
  end
  object edCodegofro_6: TcxCurrencyEdit
    Left = 8
    Top = 394
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 51
    Width = 101
  end
  object edgofro_6: TcxButtonEdit
    Left = 122
    Top = 394
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 52
    Width = 303
  end
  object cxLabel26: TcxLabel
    Left = 122
    Top = 377
    Caption = #1043#1086#1092#1088#1086'-6'
  end
  object edAmount_gofro_6: TcxCurrencyEdit
    Left = 439
    Top = 394
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 54
    Width = 111
  end
  object cxLabel27: TcxLabel
    Left = 439
    Top = 377
    Caption = #1050#1086#1083'-'#1074#1086' - 6'
  end
  object cxLabel28: TcxLabel
    Left = 8
    Top = 417
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-7'
  end
  object edCodegofro_7: TcxCurrencyEdit
    Left = 8
    Top = 435
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 57
    Width = 101
  end
  object edgofro_7: TcxButtonEdit
    Left = 122
    Top = 434
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 58
    Width = 303
  end
  object cxLabel29: TcxLabel
    Left = 122
    Top = 417
    Caption = #1043#1086#1092#1088#1086'-7'
  end
  object edAmount_gofro_7: TcxCurrencyEdit
    Left = 439
    Top = 434
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 60
    Width = 111
  end
  object cxLabel30: TcxLabel
    Left = 439
    Top = 417
    Caption = #1050#1086#1083'-'#1074#1086' - 7'
  end
  object cxLabel31: TcxLabel
    Left = 8
    Top = 461
    Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-8'
  end
  object edCodegofro_8: TcxCurrencyEdit
    Left = 8
    Top = 478
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 63
    Width = 101
  end
  object edgofro_8: TcxButtonEdit
    Left = 122
    Top = 478
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 64
    Width = 303
  end
  object cxLabel32: TcxLabel
    Left = 122
    Top = 461
    Caption = #1043#1086#1092#1088#1086'-8'
  end
  object edAmount_gofro_8: TcxCurrencyEdit
    Left = 439
    Top = 478
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    TabOrder = 66
    Width = 111
  end
  object cxLabel33: TcxLabel
    Left = 439
    Top = 461
    Caption = #1050#1086#1083'-'#1074#1086' - 8'
  end
  object ActionList: TActionList
    Left = 112
    Top = 519
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Scale_MI_gofro'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_pd'
        Value = 0.000000000000000000
        Component = GuidesGofro_pd
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_pd'
        Value = ''
        Component = edAmount_gofro_pd
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_box'
        Value = Null
        Component = Guidesgofro_box
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_box'
        Value = Null
        Component = edAmount_gofro_box
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_ugol'
        Value = Null
        Component = Guidesgofro_ugol
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_ugol'
        Value = Null
        Component = edAmount_gofro_ugol
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_1'
        Value = Null
        Component = Guidesgofro_1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_1'
        Value = Null
        Component = edAmount_gofro_1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_2'
        Value = Null
        Component = Guidesgofro_2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_2'
        Value = Null
        Component = edAmount_gofro_2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_3'
        Value = Null
        Component = Guidesgofro_3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_3'
        Value = Null
        Component = edAmount_gofro_3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_4'
        Value = Null
        Component = Guidesgofro_4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_4'
        Value = Null
        Component = edAmount_gofro_4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_5'
        Value = Null
        Component = Guidesgofro_5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_5'
        Value = Null
        Component = edAmount_gofro_5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_6'
        Value = Null
        Component = Guidesgofro_6
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_6'
        Value = Null
        Component = edAmount_gofro_6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_7'
        Value = Null
        Component = Guidesgofro_7
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_7'
        Value = Null
        Component = edAmount_gofro_7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_gofro_8'
        Value = Null
        Component = Guidesgofro_8
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_gofro_8'
        Value = Null
        Component = edAmount_gofro_8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchCode'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'BranchCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 496
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParnerId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 513
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Scale_MI_Goods_gofro'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParnerId'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'ParnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchCode'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'BranchCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_pd'
        Value = Null
        Component = edCodeGofro_pd
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_pd'
        Value = Null
        Component = GuidesGofro_pd
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_pd'
        Value = Null
        Component = GuidesGofro_pd
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_pd'
        Value = Null
        Component = edAmount_gofro_pd
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_box'
        Value = Null
        Component = edCodegofro_box
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_box'
        Value = Null
        Component = Guidesgofro_box
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_box'
        Value = Null
        Component = Guidesgofro_box
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_box'
        Value = Null
        Component = edAmount_gofro_box
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_ugol'
        Value = Null
        Component = edCodegofro_ugol
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_ugol'
        Value = Null
        Component = Guidesgofro_ugol
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_ugol'
        Value = Null
        Component = Guidesgofro_ugol
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_ugol'
        Value = Null
        Component = edAmount_gofro_ugol
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_1'
        Value = Null
        Component = edCodegofro_1
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_1'
        Value = Null
        Component = Guidesgofro_1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_1'
        Value = Null
        Component = Guidesgofro_1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_1'
        Value = Null
        Component = edAmount_gofro_1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_2'
        Value = Null
        Component = edCodegofro_2
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_2'
        Value = Null
        Component = Guidesgofro_2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_2'
        Value = Null
        Component = Guidesgofro_2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_2'
        Value = Null
        Component = edAmount_gofro_2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_3'
        Value = Null
        Component = edCodegofro_3
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_3'
        Value = Null
        Component = Guidesgofro_3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_3'
        Value = Null
        Component = Guidesgofro_3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_3'
        Value = Null
        Component = edAmount_gofro_3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_4'
        Value = Null
        Component = edCodegofro_4
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_4'
        Value = Null
        Component = Guidesgofro_4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_4'
        Value = Null
        Component = Guidesgofro_4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_4'
        Value = Null
        Component = edAmount_gofro_4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_5'
        Value = Null
        Component = edCodegofro_5
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_5'
        Value = Null
        Component = Guidesgofro_5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_5'
        Value = Null
        Component = Guidesgofro_5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_5'
        Value = Null
        Component = edAmount_gofro_5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_6'
        Value = Null
        Component = edCodegofro_6
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_6'
        Value = Null
        Component = Guidesgofro_6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_6'
        Value = Null
        Component = Guidesgofro_6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_6'
        Value = Null
        Component = edAmount_gofro_6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_7'
        Value = Null
        Component = edCodegofro_7
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_7'
        Value = Null
        Component = Guidesgofro_7
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_7'
        Value = Null
        Component = Guidesgofro_7
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_7'
        Value = Null
        Component = edAmount_gofro_7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode_gofro_8'
        Value = Null
        Component = edCodegofro_8
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId_gofro_8'
        Value = Null
        Component = Guidesgofro_8
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName_gofro_8'
        Value = Null
        Component = Guidesgofro_8
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_gofro_8'
        Value = Null
        Component = edAmount_gofro_8
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 496
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
    Left = 208
    Top = 257
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 376
    Top = 234
  end
  object GuidesGofro_pd: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edGofro_pd
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGofro_pd
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGofro_pd
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodeGofro_pd
        MultiSelectSeparator = ','
      end>
    Left = 249
    Top = 15
  end
  object Guidesgofro_ugol: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_ugol
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_ugol
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_ugol
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_ugol
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 99
  end
  object Guidesgofro_1: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_1
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_1
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 166
  end
  object Guidesgofro_2: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_2
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_2
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 206
  end
  object Guidesgofro_3: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_3
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_3
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 249
  end
  object Guidesgofro_4: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_4
    Key = '0'
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_4
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_4
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 288
  end
  object Guidesgofro_5: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_5
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_5
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_5
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 328
  end
  object Guidesgofro_6: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_6
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_6
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_6
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_6
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 368
  end
  object Guidesgofro_7: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_7
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_7
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_7
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCodegofro_7
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 409
  end
  object Guidesgofro_8: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_8
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_8
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_8
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_8
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 453
  end
  object Guidesgofro_box: TdsdGuides
    KeyField = 'GuideId'
    LookupControl = edgofro_box
    FormNameParam.Value = 'TScale_GofroForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScale_GofroForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guidesgofro_box
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guidesgofro_box
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edCodegofro_box
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 67
  end
end
