object Report_Sale_AnalysisDialogForm: TReport_Sale_AnalysisDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1040#1085#1072#1083#1080#1079' '#1087#1088#1080#1093#1086#1076' / '#1087#1088#1086#1076#1072#1078#1072'>'
  ClientHeight = 369
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 38
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 212
    Top = 334
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 121
    Top = 27
    EditValue = 42400d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 10
    Top = 27
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object edUnit: TcxButtonEdit
    Left = 14
    Top = 83
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 14
    Top = 63
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 7
    Caption = #1055#1077#1088#1080#1086#1076' '#1089' ...'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' ...'
  end
  object cxLabel1: TcxLabel
    Left = 14
    Top = 119
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
  end
  object edBrand: TcxButtonEdit
    Left = 14
    Top = 139
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 197
  end
  object cxLabel2: TcxLabel
    Left = 222
    Top = 120
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
  end
  object edPartner: TcxButtonEdit
    Left = 222
    Top = 139
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 141
  end
  object cxLabel5: TcxLabel
    Left = 14
    Top = 172
    Caption = #1057#1077#1079#1086#1085' :'
  end
  object edPeriod: TcxButtonEdit
    Left = 14
    Top = 191
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 197
  end
  object cxLabel8: TcxLabel
    Left = 222
    Top = 171
    Caption = #1043#1086#1076' '#1089' ...'
  end
  object cxLabel9: TcxLabel
    Left = 298
    Top = 171
    Caption = #1043#1086#1076' '#1087#1086' ...'
  end
  object edStartYear: TcxButtonEdit
    Left = 222
    Top = 191
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Text = '2012'
    Width = 65
  end
  object edEndYear: TcxButtonEdit
    Left = 298
    Top = 191
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 65
  end
  object cbPeriodAll: TcxCheckBox
    Left = 223
    Top = 27
    Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
    ParentShowHint = False
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 18
    Width = 105
  end
  object cbUnit: TcxCheckBox
    Left = 293
    Top = 83
    Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1087#1086' '#1057#1087#1080#1089#1082#1091
    ParentShowHint = False
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 19
    Width = 76
  end
  object cbIsAmount: TcxCheckBox
    Left = 14
    Top = 237
    Caption = #1044#1083#1103' % '#1055#1088#1086#1076'. '#1082#1086#1083'.'
    ParentShowHint = False
    Properties.ReadOnly = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 20
    Width = 119
  end
  object cbIsSumm: TcxCheckBox
    Left = 14
    Top = 264
    Caption = #1044#1083#1103' % '#1055#1088#1086#1076'. '#1089#1091#1084#1084'.'
    ParentShowHint = False
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 21
    Width = 119
  end
  object cbIsProf: TcxCheckBox
    Left = 14
    Top = 292
    Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1044#1083#1103' % '#1055#1088#1080#1073#1099#1083#1080
    ParentShowHint = False
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 22
    Width = 119
  end
  object cxLabel4: TcxLabel
    Left = 139
    Top = 238
    Caption = '% '#1087#1088#1077#1076#1077#1083' 1:'
  end
  object cxLabel10: TcxLabel
    Left = 139
    Top = 268
    Caption = '% '#1087#1088#1077#1076#1077#1083' 1:'
  end
  object cxLabel13: TcxLabel
    Left = 139
    Top = 295
    Caption = '% '#1087#1088#1077#1076#1077#1083' 1:'
  end
  object cxLabel11: TcxLabel
    Left = 234
    Top = 238
    Caption = '% '#1087#1088#1077#1076#1077#1083' 2:'
  end
  object cxLabel12: TcxLabel
    Left = 234
    Top = 268
    Caption = '% '#1087#1088#1077#1076#1077#1083' 2:'
  end
  object cxLabel14: TcxLabel
    Left = 234
    Top = 295
    Caption = '% '#1087#1088#1077#1076#1077#1083' 2:'
  end
  object edPresent1: TcxCurrencyEdit
    Left = 205
    Top = 237
    EditValue = '50'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 29
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 25
  end
  object edPresent2: TcxCurrencyEdit
    Left = 302
    Top = 237
    EditValue = '20'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 30
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 25
  end
  object edPresent1_Summ: TcxCurrencyEdit
    Left = 205
    Top = 267
    EditValue = 120.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 31
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 25
  end
  object edPresent2_Summ: TcxCurrencyEdit
    Left = 302
    Top = 267
    EditValue = 100.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 32
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 25
  end
  object edPresent1_Prof: TcxCurrencyEdit
    Left = 205
    Top = 294
    EditValue = '50'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 33
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 25
  end
  object edPresent2_Prof: TcxCurrencyEdit
    Left = 302
    Top = 294
    EditValue = '20'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 34
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 25
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 115
    Top = 9
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 289
    Top = 12
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 163
    Top = 314
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodId'
        Value = Null
        Component = GuidesPeriod
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodName'
        Value = Null
        Component = GuidesPeriod
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartYear'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartYearText'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndYear'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndYearText'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsPeriodAll'
        Value = Null
        Component = cbPeriodAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUnit'
        Value = Null
        Component = cbUnit
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Present1_Prof'
        Value = Null
        Component = edPresent1_Prof
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Present2_Prof'
        Value = Null
        Component = edPresent2_Prof
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Present1_Summ'
        Value = Null
        Component = edPresent1_Summ
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Present2_Summ'
        Value = Null
        Component = edPresent2_Summ
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsAmount'
        Value = Null
        Component = cbIsAmount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsProf'
        Value = Null
        Component = cbIsProf
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsSumm'
        Value = Null
        Component = cbIsSumm
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 66
    Top = 189
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 105
    Top = 60
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    Key = '0'
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesBrand
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 114
    Top = 132
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 290
    Top = 116
  end
  object GuidesPeriod: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPeriod
    Key = '0'
    FormNameParam.Value = 'TPeriodForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPeriod
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPeriod
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 146
    Top = 176
  end
  object GuidesStartYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStartYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 238
    Top = 161
  end
  object GuidesEndYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEndYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesEndYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 313
    Top = 171
  end
end
