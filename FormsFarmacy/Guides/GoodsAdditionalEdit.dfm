﻿inherited GoodsAdditionalEditForm: TGoodsAdditionalEditForm
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'>'
  ClientHeight = 405
  ClientWidth = 689
  ExplicitWidth = 695
  ExplicitHeight = 434
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 96
    Top = 364
    TabOrder = 5
    ExplicitLeft = 96
    ExplicitTop = 364
  end
  inherited bbCancel: TcxButton
    Left = 498
    Top = 364
    TabOrder = 6
    ExplicitLeft = 498
    ExplicitTop = 364
  end
  object edName: TcxTextEdit [2]
    Left = 9
    Top = 60
    TabStop = False
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 332
  end
  object cxLabel1: TcxLabel [3]
    Left = 9
    Top = 43
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1088#1091#1089'. '#1103#1079#1099#1082#1077')'
  end
  object cxLabel2: TcxLabel [4]
    Left = 8
    Top = 82
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 9
    Top = 22
    TabStop = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 162
  end
  object Код: TcxLabel [6]
    Left = 9
    Top = 5
    Caption = #1050#1086#1076
  end
  object edMakerName: TcxButtonEdit [7]
    Left = 8
    Top = 101
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 332
  end
  object edNumberPlates: TcxCurrencyEdit [8]
    Left = 347
    Top = 143
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 109
  end
  object cxLabel3: TcxLabel [9]
    Left = 347
    Top = 126
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1089#1090#1080#1085' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object cxLabel7: TcxLabel [10]
    Left = 516
    Top = 126
    Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object ceQtyPackage: TcxCurrencyEdit [11]
    Left = 516
    Top = 143
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 109
  end
  object cbIsRecipe: TcxCheckBox [12]
    Left = 349
    Top = 307
    Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
    TabOrder = 12
    Width = 96
  end
  object edNameUkr: TcxTextEdit [13]
    Left = 347
    Top = 61
    TabStop = False
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 332
  end
  object cxLabel12: TcxLabel [14]
    Left = 347
    Top = 43
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1082#1088'. '#1103#1079#1099#1082#1077')'
  end
  object edFormDispensing: TcxButtonEdit [15]
    Left = 8
    Top = 143
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 332
  end
  object cxLabel14: TcxLabel [16]
    Left = 7
    Top = 126
    Caption = #1060#1086#1088#1084#1072' '#1086#1090#1087#1091#1089#1082#1072
  end
  object edMakerNameUkr: TcxTextEdit [17]
    Left = 347
    Top = 101
    TabOrder = 17
    Width = 332
  end
  object cxLabel4: TcxLabel [18]
    Left = 346
    Top = 82
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
  end
  object edDosage: TcxTextEdit [19]
    Left = 8
    Top = 184
    TabOrder = 19
    Width = 332
  end
  object cxLabel5: TcxLabel [20]
    Left = 8
    Top = 166
    Caption = #1044#1086#1079#1080#1088#1086#1074#1082#1072
  end
  object edVolume: TcxTextEdit [21]
    Left = 349
    Top = 184
    TabOrder = 21
    Width = 330
  end
  object cxLabel6: TcxLabel [22]
    Left = 349
    Top = 167
    Caption = #1054#1073#1098#1077#1084
  end
  object edGoodsMethodAppl: TcxButtonEdit [23]
    Left = 349
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 23
    Width = 332
  end
  object cxLabel9: TcxLabel [24]
    Left = 349
    Top = 210
    Caption = #1057#1087#1086#1089#1086#1073' '#1087#1088#1080#1084#1077#1085#1077#1085#1080#1103
  end
  object edGoodsSignOrigin: TcxButtonEdit [25]
    Left = 349
    Top = 280
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 332
  end
  object cxLabel10: TcxLabel [26]
    Left = 349
    Top = 262
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
  end
  object cblGoodsWhoCan: TcxCheckListBox [27]
    Left = 8
    Top = 228
    Width = 332
    Height = 109
    Columns = 2
    Items = <>
    TabOrder = 27
  end
  object cxLabel8: TcxLabel [28]
    Left = 8
    Top = 210
    Caption = #1050#1086#1084#1091' '#1084#1086#1078#1085#1086
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 34
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 34
  end
  inherited ActionList: TActionList
    Left = 175
    Top = 88
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect_GoodsWhoCan
      StoredProcList = <
        item
          StoredProc = spSelect_GoodsWhoCan
        end
        item
          StoredProc = spGet
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMainId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 97
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsAdditional'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerName'
        Value = ''
        Component = edMakerName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerNameUkr'
        Value = Null
        Component = edMakerNameUkr
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormDispensingId'
        Value = Null
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberPlates'
        Value = ''
        Component = edNumberPlates
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQtyPackage'
        Value = ''
        Component = ceQtyPackage
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDosage'
        Value = Null
        Component = edDosage
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVolume'
        Value = Null
        Component = edVolume
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsWhoCanList'
        Value = Null
        Component = CheckListBoxAddOnWhoCanGuides
        ComponentItem = 'KeyList'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsMethodApplId'
        Value = Null
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSignOriginId'
        Value = Null
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecipe'
        Value = Null
        Component = cbIsRecipe
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsAdditional'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMainId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMainId'
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
        Name = 'MakerName'
        Value = ''
        Component = edMakerName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerNameUkr'
        Value = Null
        Component = edMakerNameUkr
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NameUkr'
        Value = Null
        Component = edNameUkr
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = Null
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingName'
        Value = Null
        Component = FormDispensingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = edNumberPlates
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = ceQtyPackage
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dosage'
        Value = Null
        Component = edDosage
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Volume'
        Value = Null
        Component = edVolume
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsWhoCanList'
        Value = Null
        Component = CheckListBoxAddOnWhoCanGuides
        ComponentItem = 'KeyList'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMethodApplId'
        Value = Null
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMethodApplName'
        Value = Null
        Component = GoodsMethodApplGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSignOriginId'
        Value = Null
        Component = GoodsSignOriginGuides
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSignOriginName'
        Value = Null
        Component = GoodsSignOriginGuides
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecipe'
        Value = Null
        Component = cbIsRecipe
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 64
  end
  object GoodsMakerNameGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMakerName
    FormNameParam.Value = 'TGoodsMakerNameForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMakerNameForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        MultiSelectSeparator = ','
      end>
    Left = 560
    Top = 31
  end
  object FormDispensingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFormDispensing
    FormNameParam.Value = 'TFormDispensingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFormDispensingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 122
  end
  object GoodsSignOriginGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsSignOrigin
    Key = '0'
    FormNameParam.Value = 'TGoodsSignOriginForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsSignOriginForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsSignOriginGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 527
    Top = 269
  end
  object GoodsMethodApplGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsMethodAppl
    Key = '0'
    FormNameParam.Value = 'TGoodsMethodApplForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMethodApplForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMethodApplGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 535
    Top = 213
  end
  object CheckListBoxAddOnWhoCanGuides: TCheckListBoxAddOn
    CheckListBox = cblGoodsWhoCan
    DataSet = WhoCanGuidesCDS
    IdParam.Value = 'Id'
    IdParam.DataType = ftString
    IdParam.MultiSelectSeparator = ','
    NameParam.Value = 'Name'
    NameParam.DataType = ftString
    NameParam.MultiSelectSeparator = ','
    Left = 104
    Top = 256
  end
  object WhoCanGuidesCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 264
    Top = 288
  end
  object spSelect_GoodsWhoCan: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsWhoCan_Active'
    DataSet = WhoCanGuidesCDS
    DataSets = <
      item
        DataSet = WhoCanGuidesCDS
      end>
    Params = <>
    PackSize = 1
    Left = 264
    Top = 232
  end
end
