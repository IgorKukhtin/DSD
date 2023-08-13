object AssetEditForm: TAssetEditForm
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086
  ClientHeight = 524
  ClientWidth = 380
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
    Top = 64
    TabOrder = 0
    Width = 184
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 46
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 71
    Top = 485
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 485
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
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 68
  end
  object ceInvNumber: TcxTextEdit
    Left = 40
    Top = 153
    TabOrder = 6
    Width = 138
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 134
    Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1085#1099#1081' '#1085#1086#1084#1077#1088
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 260
    Caption = #1043#1088#1091#1087#1087#1099' '#1086#1089#1085#1086#1074#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074
  end
  object ceAssetGroup: TcxButtonEdit
    Left = 40
    Top = 279
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 43
    Top = 178
    Caption = #1047#1072#1074#1086#1076#1089#1082#1086#1081' '#1085#1086#1084#1077#1088
  end
  object ceSerialNumber: TcxTextEdit
    Left = 40
    Top = 197
    TabOrder = 11
    Width = 138
  end
  object cxLabel5: TcxLabel
    Left = 212
    Top = 134
    Caption = #1044#1072#1090#1072' '#1074#1099#1087#1091#1089#1082#1072
  end
  object edRelease: TcxDateEdit
    Left = 212
    Top = 153
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 189
    Top = 178
    Caption = #1053#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072
  end
  object cePassportNumber: TcxTextEdit
    Left = 189
    Top = 197
    TabOrder = 15
    Width = 147
  end
  object cxLabel7: TcxLabel
    Left = 43
    Top = 89
    Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1054#1057
  end
  object ceFullName: TcxTextEdit
    Left = 40
    Top = 108
    TabOrder = 17
    Width = 296
  end
  object cxLabel8: TcxLabel
    Left = 189
    Top = 220
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 189
    Top = 238
    TabOrder = 19
    Width = 147
  end
  object cxLabel9: TcxLabel
    Left = 41
    Top = 304
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  end
  object ceJuridical: TcxButtonEdit
    Left = 40
    Top = 322
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 296
  end
  object ceMaker: TcxButtonEdit
    Left = 40
    Top = 362
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 296
  end
  object cxLabel10: TcxLabel
    Left = 43
    Top = 345
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' ('#1054#1057')'
  end
  object edPeriodUse: TcxCurrencyEdit
    Left = 118
    Top = 21
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 24
    Width = 106
  end
  object cxLabel11: TcxLabel
    Left = 118
    Top = 3
    Hint = #1055#1077#1088#1080#1086#1076' '#1101#1082#1089#1087#1083#1091#1072#1090#1072#1094#1080#1080' ('#1083#1077#1090')'
    Caption = #1055#1077#1088#1080#1086#1076' '#1101#1082#1089#1087#1083'. ('#1083#1077#1090')'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel12: TcxLabel
    Left = 43
    Top = 388
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object edCar: TcxButtonEdit
    Left = 40
    Top = 404
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 296
  end
  object cxLabel13: TcxLabel
    Left = 235
    Top = 3
    Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076'-'#1090#1100', '#1082#1075
    ParentShowHint = False
    ShowHint = True
  end
  object edProduction: TcxCurrencyEdit
    Left = 235
    Top = 21
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 29
    Width = 101
  end
  object cxLabel14: TcxLabel
    Left = 41
    Top = 433
    Caption = #1058#1080#1087' '#1054#1057
  end
  object edAssetType: TcxButtonEdit
    Left = 40
    Top = 454
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 183
  end
  object cxLabel15: TcxLabel
    Left = 235
    Top = 46
    Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
    Caption = #1052#1086#1097#1085#1086#1089#1090#1100', '#1082#1042#1090
    ParentShowHint = False
    ShowHint = True
  end
  object edKW: TcxCurrencyEdit
    Left = 235
    Top = 64
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 33
    Width = 101
  end
  object cbisDocGoods: TcxCheckBox
    Left = 242
    Top = 448
    Hint = #1042#1099#1073#1086#1088' '#1074' '#1090#1086#1074#1072#1088#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093
    Caption = #1042#1099#1073#1086#1088' '#1074' '#1090#1086#1074'. '#1076#1086#1082'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 34
    Width = 117
  end
  object edPartionModel: TcxButtonEdit
    Left = 40
    Top = 238
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 138
  end
  object cxLabel16: TcxLabel
    Left = 43
    Top = 224
    Caption = #1052#1086#1076#1077#1083#1100' ('#1087#1072#1088#1090#1080#1103')'
  end
  object ActionList: TActionList
    Left = 344
    Top = 204
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
    StoredProcName = 'gpInsertUpdate_Object_Asset'
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
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRelease'
        Value = 0d
        Component = edRelease
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = ceInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFullName'
        Value = ''
        Component = ceFullName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSerialNumber'
        Value = ''
        Component = ceSerialNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassportNumber'
        Value = ''
        Component = cePassportNumber
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
        Name = 'inAssetGroupId'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerId'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarId'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetTypeId'
        Value = Null
        Component = GuidesAssetType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionModelIn'
        Value = Null
        Component = GuidesPartionModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodUse'
        Value = Null
        Component = edPeriodUse
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProduction'
        Value = Null
        Component = edProduction
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKW'
        Value = Null
        Component = edKW
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDocGoods'
        Value = Null
        Component = cbisDocGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 160
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Asset'
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
        Name = 'Release'
        Value = 0d
        Component = edRelease
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = ceInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FullName'
        Value = ''
        Component = ceFullName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SerialNumber'
        Value = ''
        Component = ceSerialNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PassportNumber'
        Value = ''
        Component = cePassportNumber
        DataType = ftString
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
        Name = 'AssetGroupId'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssetGroupName'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerId'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerName'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodUse'
        Value = Null
        Component = edPeriodUse
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Production'
        Value = Null
        Component = edProduction
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'KW'
        Value = Null
        Component = edKW
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssetTypeId'
        Value = Null
        Component = GuidesAssetType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssetTypeName'
        Value = Null
        Component = GuidesAssetType
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDocGoods'
        Value = Null
        Component = cbisDocGoods
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionModelId'
        Value = Null
        Component = GuidesPartionModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionModelName'
        Value = Null
        Component = GuidesPartionModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 255
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
    Left = 344
    Top = 64
  end
  object AssetGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAssetGroup
    FormNameParam.Value = 'TAssetGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 266
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 8
    Top = 330
  end
  object MakerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMaker
    FormNameParam.Value = 'TMakerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMakerForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 338
  end
  object GuidesCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCar_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCar_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 396
  end
  object GuidesAssetType: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAssetType
    FormNameParam.Value = 'TAssetTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetTypeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAssetType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAssetType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 161
    Top = 448
  end
  object GuidesPartionModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartionModel
    FormNameParam.Value = 'TPartionModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartionModelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartionModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartionModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 230
  end
end
