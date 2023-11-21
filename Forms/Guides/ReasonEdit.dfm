object ReasonEditForm: TReasonEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1088#1080#1095#1080#1085#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' / '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103'>'
  ClientHeight = 412
  ClientWidth = 294
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
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 49
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 42
    Top = 376
    Width = 75
    Height = 29
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 186
    Top = 376
    Width = 75
    Height = 29
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 25
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 96
  end
  object cxLabel11: TcxLabel
    Left = 10
    Top = 148
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1074#1086#1079#1074#1088#1072#1090#1072
  end
  object ceReturnKind: TcxButtonEdit
    Left = 10
    Top = 119
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object cbisReturnIn: TcxCheckBox
    Left = 8
    Top = 200
    Caption = #1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1076#1083#1103' '#1042#1086#1079#1074#1088#1072#1090#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
    TabOrder = 8
    Width = 258
  end
  object cbisSendOnPrice: TcxCheckBox
    Left = 15
    Top = 227
    Caption = #1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1076#1083#1103' '#1042#1086#1079#1074#1088#1072#1090#1072' '#1089' '#1092#1080#1083#1080#1072#1083#1072
    TabOrder = 9
    Width = 258
  end
  object edComment: TcxTextEdit
    Left = 10
    Top = 342
    TabOrder = 10
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 321
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edPeriodTax: TcxCurrencyEdit
    Left = 193
    Top = 290
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 90
  end
  object cxLabel4: TcxLabel
    Left = 15
    Top = 291
    Caption = #1055#1077#1088#1080#1086#1076' '#1074' % '#1086#1090' "'#1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080'"'
  end
  object edPeriodDays: TcxCurrencyEdit
    Left = 193
    Top = 256
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 90
  end
  object cxLabel5: TcxLabel
    Left = 15
    Top = 257
    Caption = #1055#1077#1088#1080#1086#1076' '#1074' '#1076#1085'. '#1086#1090' "'#1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080'"'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 100
    Caption = #1058#1080#1087' '#1074#1086#1079#1074#1088#1072#1090#1072
  end
  object edReturnDescKind: TcxButtonEdit
    Left = 10
    Top = 167
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 112
    Top = 8
    Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
  end
  object edShort: TcxTextEdit
    Left = 116
    Top = 25
    TabOrder = 19
    Width = 167
  end
  object ActionList: TActionList
    Left = 152
    Top = 56
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
    StoredProcName = 'gpInsertUpdate_Object_Reason'
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
        Component = edCode
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
        Name = 'inShort'
        Value = Null
        Component = edShort
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnKindId'
        Value = Null
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnDescKindId'
        Value = Null
        Component = GuidesReturnDescKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodDays'
        Value = Null
        Component = edPeriodDays
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodTax'
        Value = Null
        Component = edPeriodTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReturnIn'
        Value = Null
        Component = cbisReturnIn
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSendOnPrice'
        Value = Null
        Component = cbisSendOnPrice
        DataType = ftBoolean
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
      end>
    PackSize = 1
    Left = 112
    Top = 8
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 48
    Top = 64
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Reason'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'ReturnKindId'
        Value = Null
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnKindName'
        Value = Null
        Component = GuidesReturnKind
        ComponentItem = 'TextValue'
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
        Name = 'isReturnIn'
        Value = Null
        Component = cbisReturnIn
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSendOnPrice'
        Value = Null
        Component = cbisSendOnPrice
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodDays'
        Value = Null
        Component = edPeriodDays
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodTax'
        Value = Null
        Component = edPeriodTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnDescKindId'
        Value = Null
        Component = GuidesReturnDescKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnDescKindName'
        Value = Null
        Component = GuidesReturnDescKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Short'
        Value = Null
        Component = edShort
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 16
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
    Left = 200
    Top = 88
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 48
    Top = 40
  end
  object GuidesReturnKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceReturnKind
    FormNameParam.Value = 'TReturnKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 112
  end
  object GuidesReturnDescKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReturnDescKind
    FormNameParam.Value = 'TReturnDescKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnDescKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReturnDescKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReturnDescKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 151
  end
end
