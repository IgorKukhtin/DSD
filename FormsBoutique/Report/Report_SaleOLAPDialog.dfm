object Report_SaleOLAPDialogForm: TReport_SaleOLAPDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1054#1051#1040#1055')>'
  ClientHeight = 409
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 110
    Top = 365
    Width = 75
    Height = 24
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 239
    Top = 365
    Width = 75
    Height = 24
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 125
    Top = 30
    EditValue = 42736d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 85
  end
  object deStart: TcxDateEdit
    Left = 25
    Top = 30
    EditValue = 42736d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 85
  end
  object cxLabel6: TcxLabel
    Left = 25
    Top = 10
    Caption = #1055#1077#1088#1080#1086#1076' '#1089' ...'
  end
  object cxLabel7: TcxLabel
    Left = 125
    Top = 10
    Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' ...'
  end
  object cxLabel4: TcxLabel
    Left = 25
    Top = 175
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
  end
  object edPartner: TcxButtonEdit
    Left = 25
    Top = 195
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 7
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
    Width = 350
  end
  object cxLabel1: TcxLabel
    Left = 25
    Top = 85
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
  end
  object edBrand: TcxButtonEdit
    Left = 25
    Top = 103
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1084#1072#1088#1082#1091'>'
    Width = 350
  end
  object cxLabel2: TcxLabel
    Left = 25
    Top = 130
    Caption = #1057#1077#1079#1086#1085' :'
  end
  object edPeriod: TcxButtonEdit
    Left = 25
    Top = 150
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1077#1079#1086#1085'>'
    Width = 350
  end
  object cxLabel5: TcxLabel
    Left = 230
    Top = 10
    Caption = #1043#1086#1076' '#1089' ...'
  end
  object edStartYear: TcxCurrencyEdit
    Left = 230
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 13
    Width = 70
  end
  object edEndYear: TcxCurrencyEdit
    Left = 305
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 14
    Width = 70
  end
  object cxLabel8: TcxLabel
    Left = 305
    Top = 10
    Caption = #1043#1086#1076' '#1087#1086' ...'
  end
  object cbSize: TcxCheckBox
    Left = 25
    Top = 325
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1056#1072#1079#1084#1077#1088#1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
    Width = 85
  end
  object cbGoods: TcxCheckBox
    Left = 25
    Top = 300
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1058#1086#1074#1072#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1058#1086#1074#1072#1088#1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 17
    Width = 85
  end
  object cbPeriodAll: TcxCheckBox
    Left = 64
    Top = 55
    Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
    ParentShowHint = False
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 18
    Width = 105
  end
  object cbYear: TcxCheckBox
    Left = 239
    Top = 55
    Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    Width = 130
  end
  object cxLabel3: TcxLabel
    Left = 25
    Top = 220
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1043#1088#1091#1087#1087#1072':'
  end
  object edUnit: TcxButtonEdit
    Left = 25
    Top = 240
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 21
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Width = 350
  end
  object cbClient_doc: TcxCheckBox
    Left = 140
    Top = 300
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 22
    Width = 100
  end
  object cbOperPrice: TcxCheckBox
    Left = 140
    Top = 325
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1062#1077#1085#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1062#1077#1085#1072' '#1074#1093'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    Width = 100
  end
  object cbOperDate_doc: TcxCheckBox
    Left = 270
    Top = 300
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1043#1086#1076' / '#1052#1077#1089#1103#1094' '#1055#1088#1086#1076#1072#1078#1080' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1043#1086#1076' / '#1052#1077#1089#1103#1094
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
    Width = 100
  end
  object cbDay_doc: TcxCheckBox
    Left = 270
    Top = 325
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1055#1088#1086#1076#1072#1078#1080' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
    Width = 100
  end
  object cbDiscount: TcxCheckBox
    Left = 25
    Top = 275
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' % '#1089#1082#1080#1076#1082#1080' ('#1044#1072'/'#1053#1077#1090')'
    Caption = '% '#1057#1082#1080#1076#1082#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
    Width = 75
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 161
    Top = 49
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 287
    Top = 214
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
    Left = 329
    Top = 358
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
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Component = edStartYear
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndYear'
        Value = Null
        Component = edEndYear
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isYear'
        Value = Null
        Component = cbYear
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPeriodAll'
        Value = Null
        Component = cbPeriodAll
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSize'
        Value = Null
        Component = cbSize
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClient_doc'
        Value = Null
        Component = cbClient_doc
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOperDate_doc'
        Value = Null
        Component = cbOperDate_doc
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDay_doc'
        Value = Null
        Component = cbDay_doc
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOperPrice'
        Value = Null
        Component = cbOperPrice
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscount'
        Value = Null
        Component = cbDiscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 47
    Top = 352
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
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
      end
      item
        Name = 'MasterUnitId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 169
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
    Left = 223
    Top = 95
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
    Left = 183
    Top = 139
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
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
      end
      item
        Name = 'MasterUnitId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 209
    Top = 233
  end
end
