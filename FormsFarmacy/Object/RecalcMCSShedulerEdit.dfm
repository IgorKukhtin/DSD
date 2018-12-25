object RecalcMCSShedulerEditForm: TRecalcMCSShedulerEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1083#1072#1085#1080#1088#1086#1074#1097#1080#1082' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1053#1058#1047'>'
  ClientHeight = 376
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 49
    Top = 343
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 21
  end
  object cxButton2: TcxButton
    Left = 294
    Top = 343
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 22
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
    TabOrder = 0
    Width = 84
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 55
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel2: TcxLabel
    Left = 128
    Top = 103
    Caption = #1044#1085#1077#1081' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 293
    Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' '#1087#1086#1076' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1084
  end
  object ceUser: TcxButtonEdit
    Left = 32
    Top = 316
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 20
    Width = 377
  end
  object cbIsClose: TcxCheckBox
    Left = 256
    Top = 26
    Caption = #1053#1077' '#1074#1099#1087#1086#1083#1085#1103#1090#1100' '#1087#1077#1088#1077#1097#1077#1090
    TabOrder = 1
    Width = 158
  end
  object edUnitName: TcxTextEdit
    Left = 40
    Top = 76
    TabOrder = 3
    Width = 377
  end
  object cxLabel1: TcxLabel
    Left = 294
    Top = 103
    Caption = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1053#1058#1047
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 127
    Caption = #1055#1088#1072#1079#1076#1085#1080#1082
  end
  object cePeriod: TcxCurrencyEdit
    Left = 128
    Top = 126
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 84
  end
  object ceDay: TcxCurrencyEdit
    Left = 294
    Top = 126
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 84
  end
  object ceDay1: TcxCurrencyEdit
    Left = 294
    Top = 146
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 7
    Width = 84
  end
  object cePeriod1: TcxCurrencyEdit
    Left = 128
    Top = 146
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 84
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 147
    Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
  end
  object ceDay2: TcxCurrencyEdit
    Left = 294
    Top = 166
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 9
    Width = 84
  end
  object cePeriod2: TcxCurrencyEdit
    Left = 128
    Top = 166
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 8
    Width = 84
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 167
    Caption = #1042#1090#1086#1088#1085#1080#1082
  end
  object ceDay3: TcxCurrencyEdit
    Left = 294
    Top = 186
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 11
    Width = 84
  end
  object cePeriod3: TcxCurrencyEdit
    Left = 128
    Top = 186
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 10
    Width = 84
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 187
    Caption = #1057#1088#1077#1076#1072
  end
  object ceDay4: TcxCurrencyEdit
    Left = 294
    Top = 206
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 13
    Width = 84
  end
  object cePeriod4: TcxCurrencyEdit
    Left = 128
    Top = 206
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 12
    Width = 84
  end
  object cxLabel9: TcxLabel
    Left = 40
    Top = 207
    Caption = #1063#1077#1090#1074#1077#1088#1075
  end
  object ceDay5: TcxCurrencyEdit
    Left = 294
    Top = 226
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 15
    Width = 84
  end
  object cePeriod5: TcxCurrencyEdit
    Left = 128
    Top = 226
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 14
    Width = 84
  end
  object cxLabel10: TcxLabel
    Left = 40
    Top = 227
    Caption = #1055#1103#1090#1085#1080#1094#1072
  end
  object ceDay6: TcxCurrencyEdit
    Left = 294
    Top = 246
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 17
    Width = 84
  end
  object cePeriod6: TcxCurrencyEdit
    Left = 128
    Top = 246
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 16
    Width = 84
  end
  object cxLabel11: TcxLabel
    Left = 40
    Top = 247
    Caption = #1057#1091#1073#1073#1086#1090#1072
  end
  object ceDay7: TcxCurrencyEdit
    Left = 294
    Top = 266
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 19
    Width = 84
  end
  object cePeriod7: TcxCurrencyEdit
    Left = 128
    Top = 266
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 18
    Width = 84
  end
  object cxLabel12: TcxLabel
    Left = 40
    Top = 267
    Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
  end
  object cbPharmacyItem: TcxCheckBox
    Left = 256
    Top = 49
    Caption = #1040#1087#1090#1077#1095#1085#1099#1081' '#1087#1091#1085#1082#1090
    TabOrder = 2
    Width = 158
  end
  object ActionList: TActionList
    Left = 16
    Top = 32
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
    object dsdFormClose1: TdsdFormClose
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
    StoredProcName = 'gpInsertUpdate_Object_RecalcMCSSheduler'
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
        Value = Null
        Component = ceCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPharmacyItem'
        Value = Null
        Component = cbPharmacyItem
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod'
        Value = Null
        Component = cePeriod
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod1'
        Value = Null
        Component = cePeriod1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod2'
        Value = Null
        Component = cePeriod2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod3'
        Value = Null
        Component = cePeriod3
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod4'
        Value = Null
        Component = cePeriod4
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod5'
        Value = Null
        Component = cePeriod5
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod6'
        Value = Null
        Component = cePeriod6
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod7'
        Value = Null
        Component = cePeriod7
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = ceDay
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay1'
        Value = Null
        Component = ceDay1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay2'
        Value = Null
        Component = ceDay2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay3'
        Value = Null
        Component = ceDay3
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay4'
        Value = Null
        Component = ceDay4
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay5'
        Value = Null
        Component = ceDay5
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay6'
        Value = Null
        Component = ceDay6
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay7'
        Value = Null
        Component = ceDay7
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = ''
        Component = UserGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClose'
        Value = ''
        Component = cbIsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 72
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitID'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 16
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_RecalcMCSSheduler'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitID'
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
        Name = 'UnitName'
        Value = ''
        Component = edUnitName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PharmacyItem'
        Value = Null
        Component = cbPharmacyItem
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period'
        Value = Null
        Component = cePeriod
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period1'
        Value = Null
        Component = cePeriod1
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period2'
        Value = Null
        Component = cePeriod2
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period3'
        Value = Null
        Component = cePeriod3
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period4'
        Value = Null
        Component = cePeriod4
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period5'
        Value = Null
        Component = cePeriod5
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period6'
        Value = Null
        Component = cePeriod6
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period7'
        Value = Null
        Component = cePeriod7
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day'
        Value = Null
        Component = ceDay
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day1'
        Value = Null
        Component = ceDay1
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day2'
        Value = Null
        Component = ceDay2
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day3'
        Value = Null
        Component = ceDay3
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day4'
        Value = Null
        Component = ceDay4
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day5'
        Value = Null
        Component = ceDay5
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day6'
        Value = Null
        Component = ceDay6
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day7'
        Value = Null
        Component = ceDay7
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsErased'
        Value = ''
        Component = cbIsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
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
    Left = 16
    Top = 64
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 16
    Top = 104
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUser
    FormNameParam.Value = 'TUserNickForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserNickForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 173
  end
end
