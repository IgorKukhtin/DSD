object GoodsGroupEditForm: TGoodsGroupEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1043#1088#1091#1087#1087#1091' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 512
  ClientWidth = 298
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
    Left = 8
    Top = 111
    TabOrder = 1
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 95
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 50
    Top = 484
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 193
    Top = 484
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 137
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit
    Left = 8
    Top = 28
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 117
  end
  object Код: TcxLabel
    Left = 8
    Top = 7
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit
    Left = 8
    Top = 155
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 182
    Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  end
  object ceGroupStat: TcxButtonEdit
    Left = 8
    Top = 203
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 135
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 274
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object ceTradeMark: TcxButtonEdit
    Left = 8
    Top = 292
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 135
  end
  object cxLabel5: TcxLabel
    Left = 146
    Top = 274
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsTag: TcxButtonEdit
    Left = 146
    Top = 292
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 135
  end
  object cxLabel6: TcxLabel
    Left = 146
    Top = 183
    Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
  end
  object ceGoodsGroupAnalyst: TcxButtonEdit
    Left = 146
    Top = 203
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 135
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 325
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
  end
  object ceGoodsPlatform: TcxButtonEdit
    Left = 8
    Top = 344
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 229
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 8
    Top = 248
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 19
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 144
    Top = 7
    Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
  end
  object ceCodeUKTZED: TcxTextEdit
    Left = 144
    Top = 28
    TabOrder = 21
    Width = 137
  end
  object cxLabel10: TcxLabel
    Left = 8
    Top = 377
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1080#1084#1087#1086#1088#1090'.'#1090#1086#1074#1072#1088#1072
  end
  object ceTaxImport: TcxTextEdit
    Left = 8
    Top = 396
    TabOrder = 23
    Width = 135
  end
  object cxLabel11: TcxLabel
    Left = 146
    Top = 377
    Caption = #1059#1089#1083#1091#1075#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1044#1050#1055#1055
  end
  object ceDKPP: TcxTextEdit
    Left = 146
    Top = 396
    TabOrder = 25
    Width = 135
  end
  object cxLabel12: TcxLabel
    Left = 8
    Top = 422
    Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1076#1077#1103#1090'. '#1089'.-'#1093'. '#1087#1088#1086#1080#1079#1074'.'
  end
  object ceTaxAction: TcxTextEdit
    Left = 8
    Top = 444
    TabOrder = 27
    Width = 152
  end
  object ceisAsset: TcxCheckBox
    Left = 189
    Top = 444
    Caption = #1055#1088#1080#1079#1085#1072#1082' - '#1054#1057
    TabOrder = 28
    Width = 92
  end
  object cxLabel13: TcxLabel
    Left = 144
    Top = 55
    Caption = #1053#1086#1074#1099#1081' '#1082#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
  end
  object ceCodeUKTZED_new: TcxTextEdit
    Left = 144
    Top = 73
    TabOrder = 30
    Width = 137
  end
  object cxLabel14: TcxLabel
    Left = 8
    Top = 55
    Caption = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074'. '#1059#1050#1058' '#1047#1045#1044
  end
  object edDateUKTZED_new: TcxDateEdit
    Left = 8
    Top = 73
    Hint = #1076#1072#1090#1072' '#1089' '#1082#1086#1090#1086#1088#1086#1081' '#1076#1077#1081#1089#1090#1074#1091#1077#1090' '#1085#1086#1074#1099#1081' '#1050#1086#1076' '#1059#1050#1058' '#1047#1045#1044
    EditValue = 44927d
    ParentShowHint = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    ShowHint = True
    TabOrder = 32
    Width = 117
  end
  object ActionList: TActionList
    Left = 72
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsGroup'
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
        Name = 'inCodeUKTZED'
        Value = Null
        Component = ceCodeUKTZED
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxImport'
        Value = Null
        Component = ceTaxImport
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDKPP'
        Value = Null
        Component = ceDKPP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxAction'
        Value = Null
        Component = ceTaxAction
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeUKTZED_new'
        Value = Null
        Component = ceCodeUKTZED_new
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateUKTZED_new'
        Value = Null
        Component = edDateUKTZED_new
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = GoodsGroupGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTagId'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPlatformId'
        Value = Null
        Component = GoodsPlatformGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAsset'
        Value = Null
        Component = ceisAsset
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 104
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 112
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsGroup'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'ParentId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupStatName'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkName'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTagId'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTagName'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPlatformId'
        Value = Null
        Component = GoodsPlatformGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPlatformName'
        Value = Null
        Component = GoodsPlatformGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CodeUKTZED'
        Value = Null
        Component = ceCodeUKTZED
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DKPP'
        Value = Null
        Component = ceDKPP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxAction'
        Value = Null
        Component = ceTaxAction
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxImport'
        Value = Null
        Component = ceTaxImport
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAsset'
        Value = Null
        Component = ceisAsset
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CodeUKTZED_new'
        Value = Null
        Component = ceCodeUKTZED_new
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateUKTZED_new'
        Value = Null
        Component = edDateUKTZED_new
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 152
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 24
    Top = 65528
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
    Top = 112
  end
  object GoodsGroupStatGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGroupStat
    FormNameParam.Value = 'TGoodsGroupStatForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupStatForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 200
  end
  object TradeMarkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 286
  end
  object GoodsTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsTag
    FormNameParam.Value = 'TGoodsTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 270
  end
  object GoodsGroupAnalystGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsGroupAnalyst
    FormNameParam.Value = 'TGoodsGroupAnalystForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupAnalystForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 200
  end
  object GoodsPlatformGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsPlatform
    FormNameParam.Value = 'TGoodsPlatformForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPlatformForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsPlatformGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsPlatformGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 318
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 227
  end
end
