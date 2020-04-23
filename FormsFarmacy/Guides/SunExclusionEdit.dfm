object SunExclusionEditForm: TSunExclusionEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' <'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1057#1059#1053'>'
  ClientHeight = 286
  ClientWidth = 439
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
    Left = 87
    Top = 26
    TabOrder = 0
    Width = 331
  end
  object cxLabel1: TcxLabel
    Left = 87
    Top = 6
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 88
    Top = 251
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 238
    Top = 251
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 20
    Top = 6
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 20
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 61
  end
  object cbisv1: TcxCheckBox
    Left = 20
    Top = 153
    Caption = #1054#1090#1082#1083#1102#1095#1077#1085' '#1076#1083#1103' '#1057#1059#1053'-1'
    TabOrder = 6
    Width = 138
  end
  object cbisv2: TcxCheckBox
    Left = 170
    Top = 153
    Caption = #1054#1090#1082#1083#1102#1095#1077#1085' '#1076#1083#1103' '#1057#1059#1053'-2'
    TabOrder = 7
    Width = 143
  end
  object cbisMSC_in: TcxCheckBox
    Left = 20
    Top = 180
    Caption = #1054#1090#1082#1083#1102#1095#1077#1085', '#1077#1089#1083#1080' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1053#1058#1047' = 0 '#1076#1083#1103' '#1057#1059#1053'-2'
    TabOrder = 8
    Width = 341
  end
  object cxLabel4: TcxLabel
    Left = 20
    Top = 57
    Caption = #1054#1090' '#1082#1086#1075#1086
  end
  object edFrom: TcxButtonEdit
    Left = 20
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 398
  end
  object cxLabel2: TcxLabel
    Left = 20
    Top = 103
    Caption = #1050#1086#1084#1091
  end
  object edTo: TcxButtonEdit
    Left = 20
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 398
  end
  object cbisv3: TcxCheckBox
    Left = 20
    Top = 207
    Caption = #1054#1090#1082#1083#1102#1095#1077#1085' '#1076#1083#1103' '#1069'-'#1057#1059#1053
    TabOrder = 13
    Width = 138
  end
  object cbisv4: TcxCheckBox
    Left = 170
    Top = 207
    Caption = #1054#1090#1082#1083#1102#1095#1077#1085' '#1076#1083#1103' '#1057#1059#1053'2-'#1055#1048
    TabOrder = 14
    Width = 159
  end
  object ActionList: TActionList
    Left = 252
    Top = 20
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
    StoredProcName = 'gpInsertUpdate_Object_SunExclusion'
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
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv1'
        Value = Null
        Component = cbisv1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv2'
        Value = Null
        Component = cbisv2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv3'
        Value = Null
        Component = cbisv3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv4'
        Value = Null
        Component = cbisv4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMSC_in'
        Value = Null
        Component = cbisMSC_in
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 188
    Top = 56
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 364
    Top = 184
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_SunExclusion'
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
        Name = 'isV1'
        Value = Null
        Component = cbisv1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isV2'
        Value = Null
        Component = cbisv2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isV3'
        Value = Null
        Component = cbisv3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isV4'
        Value = Null
        Component = cbisv4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMSC_in'
        Value = Null
        Component = cbisMSC_in
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 324
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 188
    Top = 7
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
    Left = 324
    Top = 64
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_Area_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_Area_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 98
    Top = 57
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_Area_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_Area_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 146
    Top = 118
  end
end
