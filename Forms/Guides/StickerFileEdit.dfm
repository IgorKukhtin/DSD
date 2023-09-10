object StickerFileEditForm: TStickerFileEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1064#1040#1041#1051#1054#1053'>'
  ClientHeight = 401
  ClientWidth = 652
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
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 51
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 75
    Top = 359
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 211
    Top = 359
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 8
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 42
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 78
  end
  object cxLabel2: TcxLabel
    Left = 354
    Top = 105
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 352
    Top = 121
    TabOrder = 7
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 354
    Top = 52
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object edTradeMark: TcxButtonEdit
    Left = 352
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 296
  end
  object edJuridical: TcxButtonEdit
    Left = 40
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 296
  end
  object cxLabel5: TcxLabel
    Left = 352
    Top = 8
    Caption = #1071#1079#1099#1082
  end
  object edLanguage: TcxButtonEdit
    Left = 352
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 296
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 105
    Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100': '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' / '#1070#1088'. '#1083#1080#1094#1086' / '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object cbisDefault: TcxCheckBox
    Left = 130
    Top = 26
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    TabOrder = 14
    Width = 97
  end
  object cxLabel16: TcxLabel
    Left = 30
    Top = 162
    Caption = #1064#1080#1088#1080#1085#1072' '#1089#1090#1088#1086#1082#1080
  end
  object cxLabel7: TcxLabel
    Left = 43
    Top = 185
    Caption = '1-'#1086#1081
  end
  object ceWidth1: TcxCurrencyEdit
    Left = 43
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 18
    Width = 45
  end
  object cxLabel11: TcxLabel
    Left = 43
    Top = 225
    Caption = '6-'#1086#1081
  end
  object ceWidth6: TcxCurrencyEdit
    Left = 43
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 22
    Width = 45
  end
  object ceWidth7: TcxCurrencyEdit
    Left = 95
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 23
    Width = 45
  end
  object cxLabel12: TcxLabel
    Left = 95
    Top = 225
    Caption = '7-'#1086#1081
  end
  object cxLabel4: TcxLabel
    Left = 95
    Top = 185
    Caption = '2-'#1086#1081
  end
  object cxLabel8: TcxLabel
    Left = 148
    Top = 185
    Caption = '3-'#1086#1081
  end
  object ceWidth3: TcxCurrencyEdit
    Left = 148
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 33
    Width = 45
  end
  object ceWidth4: TcxCurrencyEdit
    Left = 201
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 35
    Width = 45
  end
  object ceWidth2: TcxCurrencyEdit
    Left = 95
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 36
    Width = 45
  end
  object cxLabel10: TcxLabel
    Left = 253
    Top = 185
    Caption = '5-'#1086#1081
  end
  object cxLabel9: TcxLabel
    Left = 201
    Top = 185
    Caption = '4-'#1086#1081
  end
  object ceWidth5: TcxCurrencyEdit
    Left = 253
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 43
    Width = 45
  end
  object cxLabel15: TcxLabel
    Left = 253
    Top = 225
    Caption = '10-'#1086#1081
  end
  object ceWidth10: TcxCurrencyEdit
    Left = 253
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 45
    Width = 45
  end
  object ceWidth9: TcxCurrencyEdit
    Left = 201
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 46
    Width = 45
  end
  object cxLabel14: TcxLabel
    Left = 201
    Top = 225
    Caption = '9-'#1086#1081
  end
  object ceWidth8: TcxCurrencyEdit
    Left = 148
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 48
    Width = 45
  end
  object cxLabel13: TcxLabel
    Left = 148
    Top = 225
    Caption = '8-'#1086#1081
  end
  object cxLabel17: TcxLabel
    Left = 42
    Top = 290
    Caption = '1-'#1099#1081
  end
  object ceLevel1: TcxCurrencyEdit
    Left = 42
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 51
    Width = 45
  end
  object ceLevel2: TcxCurrencyEdit
    Left = 94
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 52
    Width = 45
  end
  object cxLabel18: TcxLabel
    Left = 94
    Top = 290
    Caption = '2-'#1086#1081
  end
  object cxLabel19: TcxLabel
    Left = 200
    Top = 290
    Caption = #1074' 1-'#1086#1081
  end
  object ceLeft1: TcxCurrencyEdit
    Left = 200
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 55
    Width = 50
  end
  object ceLeft2: TcxCurrencyEdit
    Left = 258
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 56
    Width = 50
  end
  object cxLabel7_70_70: TcxLabel
    Left = 368
    Top = 185
    Caption = '1-'#1086#1081
  end
  object ceWidth1_70_70: TcxCurrencyEdit
    Left = 369
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 17
    Width = 45
  end
  object cxLabel11_70_70: TcxLabel
    Left = 368
    Top = 225
    Caption = '6-'#1086#1081
  end
  object ceWidth6_70_70: TcxCurrencyEdit
    Left = 368
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 19
    Width = 45
  end
  object ceWidth7_70_70: TcxCurrencyEdit
    Left = 420
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 20
    Width = 45
  end
  object cxLabel12_70_70: TcxLabel
    Left = 420
    Top = 225
    Caption = '7-'#1086#1081
  end
  object cxLabel4_70_70: TcxLabel
    Left = 94
    Top = 185
    Caption = '2-'#1086#1081
  end
  object cxLabel8_70: TcxLabel
    Left = 473
    Top = 185
    Caption = '3-'#1086#1081
  end
  object ceWidth3_70_70: TcxCurrencyEdit
    Left = 473
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 24
    Width = 45
  end
  object ceWidth4_70_70: TcxCurrencyEdit
    Left = 527
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 25
    Width = 45
  end
  object ceWidth2_70_70: TcxCurrencyEdit
    Left = 420
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 26
    Width = 45
  end
  object cxLabel10_70_70: TcxLabel
    Left = 578
    Top = 185
    Caption = '5-'#1086#1081
  end
  object cxLabel9_70: TcxLabel
    Left = 201
    Top = 185
    Caption = '4-'#1086#1081
  end
  object ceWidth5_70_70: TcxCurrencyEdit
    Left = 578
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 29
    Width = 45
  end
  object cxLabel15_70_70: TcxLabel
    Left = 578
    Top = 225
    Caption = '10-'#1086#1081
  end
  object ceWidth10_70_70: TcxCurrencyEdit
    Left = 578
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 31
    Width = 45
  end
  object ceWidth9_70_70: TcxCurrencyEdit
    Left = 526
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 32
    Width = 45
  end
  object cxLabel14_70_70: TcxLabel
    Left = 526
    Top = 225
    Caption = '9-'#1086#1081
  end
  object ceWidth8_70_70: TcxCurrencyEdit
    Left = 473
    Top = 244
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 34
    Width = 45
  end
  object cxLabel13_70_70: TcxLabel
    Left = 473
    Top = 225
    Caption = '8-'#1086#1081
  end
  object cxLabel17_70_70: TcxLabel
    Left = 42
    Top = 290
    Caption = '1-'#1099#1081
  end
  object ceLevel1_70_70: TcxCurrencyEdit
    Left = 367
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 37
    Width = 45
  end
  object ceLevel2_70_70: TcxCurrencyEdit
    Left = 419
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 38
    Width = 45
  end
  object cxLabel18_70_70: TcxLabel
    Left = 419
    Top = 290
    Caption = '2-'#1086#1081
  end
  object cxLabel19_70_70: TcxLabel
    Left = 527
    Top = 290
    Caption = #1074' 1-'#1086#1081
  end
  object ceLeft1_70_70: TcxCurrencyEdit
    Left = 527
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 41
    Width = 50
  end
  object ceLeft2_70_70: TcxCurrencyEdit
    Left = 583
    Top = 309
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 42
    Width = 50
  end
  object cxLabel20: TcxLabel
    Left = 583
    Top = 290
    Caption = #1074#1086' 2-'#1086#1081
  end
  object cxLabel21: TcxLabel
    Left = 37
    Top = 271
    Caption = #1064#1080#1088#1080#1085#1072' '#1091#1088#1086#1074#1085#1103
  end
  object cxLabel22: TcxLabel
    Left = 198
    Top = 271
    Caption = #1054#1090#1089#1090#1091#1087' '#1089#1083#1077#1074#1072' '#1074' '#1089#1090#1088#1086#1082#1072#1093
  end
  object cxLabel23: TcxLabel
    Left = 352
    Top = 162
    Caption = #1064#1080#1088#1080#1085#1072' '#1089#1090#1088#1086#1082#1080' (70*70)'
  end
  object cxLabel24: TcxLabel
    Left = 361
    Top = 271
    Caption = #1064#1080#1088#1080#1085#1072' '#1091#1088#1086#1074#1085#1103
  end
  object cxLabel25: TcxLabel
    Left = 522
    Top = 271
    Caption = #1054#1090#1089#1090#1091#1087' '#1089#1083#1077#1074#1072' '#1074' '#1089#1090#1088#1086#1082#1072#1093
  end
  object cxLabel26: TcxLabel
    Left = 367
    Top = 290
    Caption = '1-'#1099#1081
  end
  object cxLabel27: TcxLabel
    Left = 527
    Top = 185
    Caption = '4-'#1086#1081
  end
  object cxLabel28: TcxLabel
    Left = 420
    Top = 185
    Caption = '2-'#1086#1081
  end
  object cxLabel29: TcxLabel
    Left = 258
    Top = 290
    Caption = #1074#1086' 2-'#1086#1081
  end
  object cbisSize70: TcxCheckBox
    Left = 239
    Top = 26
    Caption = #1056#1072#1079#1084#1077#1088' 70x70'
    TabOrder = 80
    Width = 97
  end
  object ActionList: TActionList
    Top = 100
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
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StickerFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTradeMarkId'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageName'
        Value = ''
        Component = edLanguage
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth1'
        Value = Null
        Component = ceWidth1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth2'
        Value = Null
        Component = ceWidth2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth3'
        Value = Null
        Component = ceWidth3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth4'
        Value = Null
        Component = ceWidth4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth5'
        Value = Null
        Component = ceWidth5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth6'
        Value = Null
        Component = ceWidth6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth7'
        Value = Null
        Component = ceWidth7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth8'
        Value = Null
        Component = ceWidth8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth9'
        Value = Null
        Component = ceWidth9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth10'
        Value = Null
        Component = ceWidth10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLevel1'
        Value = Null
        Component = ceLevel1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLevel2'
        Value = Null
        Component = ceLevel2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLeft1'
        Value = Null
        Component = ceLeft1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLeft2'
        Value = Null
        Component = ceLeft2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth1_70_70'
        Value = Null
        Component = ceWidth1_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth2_70_70'
        Value = Null
        Component = ceWidth2_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth3_70_70'
        Value = Null
        Component = ceWidth3_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth4_70_70'
        Value = Null
        Component = ceWidth4_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth5_70_70'
        Value = Null
        Component = ceWidth5_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth6_70_70'
        Value = Null
        Component = ceWidth6_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth7_70_70'
        Value = Null
        Component = ceWidth7_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth8_70_70'
        Value = Null
        Component = ceWidth8_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth9_70_70'
        Value = Null
        Component = ceWidth9_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth10_70_70'
        Value = Null
        Component = ceWidth10_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLevel1_70_70'
        Value = Null
        Component = ceLevel1_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLevel2_70_70'
        Value = Null
        Component = ceLevel2_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLeft1_70_70'
        Value = Null
        Component = ceLeft1_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLeft2_70_70'
        Value = Null
        Component = ceLeft2_70_70
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDefault'
        Value = Null
        Component = cbisDefault
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSize70'
        Value = Null
        Component = cbisSize70
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 349
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 98
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_StickerFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
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
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageId'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageName'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkId'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkName'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDefault'
        Value = Null
        Component = cbisDefault
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width1'
        Value = Null
        Component = ceWidth1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width2'
        Value = Null
        Component = ceWidth2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width3'
        Value = Null
        Component = ceWidth3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width4'
        Value = Null
        Component = ceWidth4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width5'
        Value = Null
        Component = ceWidth5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width6'
        Value = Null
        Component = ceWidth6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width7'
        Value = Null
        Component = ceWidth7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width8'
        Value = Null
        Component = ceWidth8
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width9'
        Value = Null
        Component = ceWidth9
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width10'
        Value = Null
        Component = ceWidth10
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Level1'
        Value = Null
        Component = ceLevel1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Level2'
        Value = Null
        Component = ceLevel2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Left1'
        Value = Null
        Component = ceLeft1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Left2'
        Value = Null
        Component = ceLeft2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width1_70_70'
        Value = Null
        Component = ceWidth1_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width2_70_70'
        Value = Null
        Component = ceWidth2_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width3_70_70'
        Value = Null
        Component = ceWidth3_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width4_70_70'
        Value = Null
        Component = ceWidth4_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width5_70_70'
        Value = Null
        Component = ceWidth5_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width6_70_70'
        Value = Null
        Component = ceWidth6_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width7_70_70'
        Value = Null
        Component = ceWidth7_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width8_70_70'
        Value = Null
        Component = ceWidth8_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width9_70_70'
        Value = Null
        Component = ceWidth9_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width10_70_70'
        Value = Null
        Component = ceWidth10_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Level1_70_70'
        Value = Null
        Component = ceLevel1_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Level2_70_70'
        Value = Null
        Component = ceLevel2_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Left1_70_70'
        Value = Null
        Component = ceLeft1_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Left2_70_70'
        Value = Null
        Component = ceLeft2_70_70
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSize70'
        Value = Null
        Component = cbisSize70
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 344
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 216
    Top = 63
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
    Left = 8
    Top = 40
  end
  object GuidesTradeMark: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 57
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalRetailPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalRetailPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 122
  end
  object GuidesLanguage: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 11
  end
end
