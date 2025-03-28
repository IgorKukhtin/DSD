object ProdOptItemsEditForm: TProdOptItemsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090#1099' '#1054#1087#1094#1080#1081' ('#1051#1086#1076#1082#1072')>'
  ClientHeight = 429
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 10
    Top = 54
    Caption = #1069#1083#1077#1084#1077#1085#1090
  end
  object cxButton1: TcxButton
    Left = 32
    Top = 394
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 176
    Top = 394
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 4
    Width = 130
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 285
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 10
    Top = 305
    TabOrder = 6
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 239
    Caption = #1062#1077#1085#1072', '#1074#1093'.'
  end
  object edPriceIn: TcxCurrencyEdit
    Left = 10
    Top = 259
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 8
    Width = 130
  end
  object cxLabel71: TcxLabel
    Left = 153
    Top = 239
    Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
  end
  object edPriceOut: TcxCurrencyEdit
    Left = 153
    Top = 260
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 10
    Width = 130
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 99
    Caption = #8470' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076'.'
  end
  object edPartNumber: TcxCurrencyEdit
    Left = 10
    Top = 119
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 12
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 10
    Top = 147
    Caption = #1051#1086#1076#1082#1072
  end
  object edProduct: TcxButtonEdit
    Left = 10
    Top = 166
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 193
    Caption = #1054#1087#1094#1080#1103
  end
  object edProdOptions: TcxButtonEdit
    Left = 10
    Top = 212
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 196
  end
  object edProdOptPattern: TcxButtonEdit
    Left = 10
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 176
    Top = 8
    Caption = '% '#1089#1082#1080#1076#1082#1080
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 176
    Top = 30
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 19
    Width = 107
  end
  object cxLabel8: TcxLabel
    Left = 217
    Top = 193
    Hint = #1050#1086#1083'. '#1086#1087#1094#1080#1081' '
    Caption = 'Amount Opt.'
    Properties.WordWrap = True
    Width = 66
  end
  object edAmount: TcxCurrencyEdit
    Left = 217
    Top = 212
    Hint = #1050#1086#1083'. '#1086#1087#1094#1080#1081' '
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    ShowHint = True
    TabOrder = 21
    Width = 66
  end
  object cxLabel9: TcxLabel
    Left = 10
    Top = 331
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1086#1087#1094#1080#1103')'
  end
  object edCommentOpt: TcxTextEdit
    Left = 10
    Top = 351
    TabOrder = 23
    Width = 273
  end
  object ActionList: TActionList
    Left = 152
    Top = 56
    object actDataSetRefresh: TdsdDataSetRefresh
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
    object actInsertUpdateGuides: TdsdInsertUpdateGuides
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
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptionsId'
        Value = Null
        Component = GuidesProdOptions
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptPatternId'
        Value = Null
        Component = GuidesProdOptPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = edAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = edPriceIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOut'
        Value = Null
        Component = edPriceOut
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = edPartNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentOpt'
        Value = Null
        Component = edCommentOpt
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProdOptItems'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdOptionsId'
        Value = Null
        Component = GuidesProdOptions
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdOptionsName'
        Value = Null
        Component = GuidesProdOptions
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceIn'
        Value = Null
        Component = edPriceIn
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceOut'
        Value = Null
        Component = edPriceOut
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartNumber'
        Value = Null
        Component = edPartNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentOpt'
        Value = Null
        Component = edCommentOpt
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdOptPatternId'
        Value = Null
        Component = GuidesProdOptPattern
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdOptPatternName'
        Value = Null
        Component = GuidesProdOptPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = edAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 24
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
    Left = 32
    Top = 277
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 256
    Top = 352
  end
  object GuidesProduct: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProduct
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 94
    Top = 165
  end
  object GuidesProdOptions: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdOptions
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdOptions
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdOptions
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 70
    Top = 203
  end
  object GuidesProdOptPattern: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdOptPattern
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdOptPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdOptPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 190
    Top = 95
  end
end
