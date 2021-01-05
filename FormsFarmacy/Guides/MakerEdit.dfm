object MakerEditForm: TMakerEditForm
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1099#1081' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
  ClientHeight = 517
  ClientWidth = 372
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
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 50
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 81
    Top = 472
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 227
    Top = 472
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
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 296
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 98
    Caption = #1057#1090#1088#1072#1085#1072
  end
  object ceCountry: TcxButtonEdit
    Left = 40
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 296
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 146
    Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
  end
  object edContactPerson: TcxButtonEdit
    Left = 40
    Top = 165
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 296
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 194
    Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
  end
  object edSendPlan: TcxDateEdit
    Left = 40
    Top = 212
    EditValue = 42370d
    Properties.Kind = ckDateTime
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 145
  end
  object cxLabel3: TcxLabel
    Left = 191
    Top = 194
    Caption = #1059#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1086
  end
  object edSendReal: TcxDateEdit
    Left = 191
    Top = 212
    EditValue = 42370d
    Properties.Kind = ckDateTime
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 145
  end
  object cbReport1: TcxCheckBox
    Left = 40
    Top = 282
    Caption = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Width = 270
  end
  object cbReport2: TcxCheckBox
    Left = 40
    Top = 302
    Caption = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    Width = 270
  end
  object cbReport3: TcxCheckBox
    Left = 40
    Top = 322
    Hint = ' '#9#1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1072#1084#1080' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072'"'
    Caption = ' '#9#1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090'. '#1085#1072' '#1082#1086#1085'. '#1087#1077#1088#1080#1086#1076#1072'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
    Width = 329
  end
  object cbReport4: TcxCheckBox
    Left = 40
    Top = 342
    Hint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
    Caption = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 17
    Width = 270
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 237
    Caption = #1055#1077#1088#1080#1086#1076'-'#1089#1090#1100' '#1086#1090#1087#1088'. '#1074' '#1076#1085#1103#1093
  end
  object edAmountDay: TcxCurrencyEdit
    Left = 40
    Top = 255
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 19
    Width = 145
  end
  object cxLabel6: TcxLabel
    Left = 191
    Top = 237
    Caption = #1055#1077#1088#1080#1086#1076'-'#1089#1090#1100' '#1086#1090#1087#1088'. '#1074' '#1084#1077#1089#1103#1094#1072#1093
  end
  object edAmountMonth: TcxCurrencyEdit
    Left = 191
    Top = 255
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 21
    Width = 145
  end
  object cbQuarter: TcxCheckBox
    Left = 40
    Top = 423
    Hint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
    Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1082#1074#1072#1088#1090#1072#1083#1100#1085#1099#1077' '#1086#1090#1095#1077#1090#1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 22
    Width = 296
  end
  object cb4Month: TcxCheckBox
    Left = 40
    Top = 443
    Hint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
    Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1095#1077#1090#1099' '#1079#1072' 4 '#1084#1077#1089#1103#1094#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    Width = 296
  end
  object cbReport5: TcxCheckBox
    Left = 40
    Top = 362
    Hint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
    Caption = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1089#1088#1086#1082#1072#1084'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
    Width = 270
  end
  object cbReport6: TcxCheckBox
    Left = 40
    Top = 383
    Hint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1085#1072' '#1074#1080#1088#1090#1091#1072#1083#1100#1085#1086#1084' '#1089#1082#1083#1072#1076#1077'"'
    Caption = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1085#1072' '#1074#1080#1088#1090#1091#1072#1083#1100#1085#1086#1084' '#1089#1082#1083#1072#1076#1077'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
    Width = 324
  end
  object cbReport7: TcxCheckBox
    Left = 40
    Top = 403
    Hint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1086#1087#1083#1072#1090#1077' '#1087#1088#1080#1093#1086#1076#1086#1074'"'
    Caption = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1086#1087#1083#1072#1090#1077' '#1087#1088#1080#1093#1086#1076#1086#1074'"'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
    Width = 324
  end
  object ActionList: TActionList
    Left = 272
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
    StoredProcName = 'gpInsertUpdate_Object_Maker'
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
        Name = 'inCountryId'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContactPersonId'
        Value = Null
        Component = GuidesContactPerson
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSendPlan'
        Value = Null
        Component = edSendPlan
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSendReal'
        Value = Null
        Component = edSendReal
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = edAmountDay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonth'
        Value = Null
        Component = edAmountMonth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport1'
        Value = Null
        Component = cbReport1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport2'
        Value = Null
        Component = cbReport2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport3'
        Value = Null
        Component = cbReport3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport4'
        Value = Null
        Component = cbReport4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport5'
        Value = Null
        Component = cbReport5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport6'
        Value = Null
        Component = cbReport6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport7'
        Value = Null
        Component = cbReport7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis4Month'
        Value = Null
        Component = cb4Month
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisQuarter'
        Value = Null
        Component = cbQuarter
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
    Left = 272
    Top = 72
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Maker'
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
        Name = 'CountryId'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountryName'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContactPersonId'
        Value = Null
        Component = GuidesContactPerson
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContactPersonName'
        Value = Null
        Component = GuidesContactPerson
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendPlan'
        Value = Null
        Component = edSendPlan
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendReal'
        Value = Null
        Component = edSendReal
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDay'
        Value = Null
        Component = edAmountDay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountMonth'
        Value = Null
        Component = edAmountMonth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport1'
        Value = Null
        Component = cbReport1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport2'
        Value = Null
        Component = cbReport2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport3'
        Value = Null
        Component = cbReport3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport4'
        Value = Null
        Component = cbReport4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport5'
        Value = Null
        Component = cbReport5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport6'
        Value = Null
        Component = cbReport6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReport7'
        Value = Null
        Component = cbReport7
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isQuarter'
        Value = Null
        Component = cbQuarter
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'is4Month'
        Value = Null
        Component = cb4Month
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
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
    Left = 344
    Top = 64
  end
  object GuidesCountry: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCountry
    FormNameParam.Value = 'TCountryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCountryForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 108
  end
  object GuidesContactPerson: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContactPerson
    FormNameParam.Value = 'TContactPersonForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContactPersonForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContactPerson
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContactPerson
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 140
  end
end
