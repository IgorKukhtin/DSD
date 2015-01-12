object GoodsGroupEditForm: TGoodsGroupEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1043#1088#1091#1087#1087#1091' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 379
  ClientWidth = 300
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
    Top = 71
    TabOrder = 1
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 34
    Top = 344
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 178
    Top = 344
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 97
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit
    Left = 8
    Top = 28
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 273
  end
  object Код: TcxLabel
    Left = 8
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit
    Left = 8
    Top = 115
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
    Top = 142
    Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  end
  object ceGroupStat: TcxButtonEdit
    Left = 8
    Top = 163
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 232
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object ceTradeMark: TcxButtonEdit
    Left = 8
    Top = 250
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 278
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsTag: TcxButtonEdit
    Left = 8
    Top = 297
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 189
    Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
  end
  object ceGoodsGroupAnalyst: TcxButtonEdit
    Left = 8
    Top = 209
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 273
  end
  object ActionList: TActionList
    Left = 208
    Top = 56
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
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
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
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = GoodsGroupGuides
        ParamType = ptInput
      end
      item
        Name = 'inGroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inTradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsTagId'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 208
    Top = 8
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 152
    Top = 8
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
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GroupStatName'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'TradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TradeMarkName'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsTagId'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsTagName'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 160
    Top = 48
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 112
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 104
    Top = 8
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
    Left = 64
    Top = 8
  end
  object GoodsGroupStatGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGroupStat
    FormNameParam.Value = 'TGoodsGroupStatForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupStatForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 112
    Top = 160
  end
  object TradeMarkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 176
    Top = 241
  end
  object GoodsTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsTag
    FormNameParam.Value = 'TGoodsTagForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 128
    Top = 281
  end
  object GoodsGroupAnalystGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsGroupAnalyst
    FormNameParam.Value = 'TGoodsGroupAnalystForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupAnalystForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 200
    Top = 192
  end
end
