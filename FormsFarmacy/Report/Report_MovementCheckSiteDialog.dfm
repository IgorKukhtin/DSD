object Report_MovementCheckSiteDialogForm: TReport_MovementCheckSiteDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1088#1086#1076#1072#1078#1080' '#1095#1077#1088#1077#1079' '#1089#1072#1081#1090'>'
  ClientHeight = 251
  ClientWidth = 336
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
    Left = 49
    Top = 214
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 223
    Top = 214
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
    Left = 8
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 305
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 52
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cbRegularSales: TcxCheckBox
    Left = 8
    Top = 99
    Hint = #1054#1073#1099#1095#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080
    Caption = #1054#1073#1099#1095#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080
    TabOrder = 8
    Width = 153
  end
  object cbVIP: TcxCheckBox
    Left = 8
    Top = 119
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = 'VIP '#1095#1077#1082#1080
    TabOrder = 9
    Width = 153
  end
  object cbSite: TcxCheckBox
    Left = 8
    Top = 140
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1063#1077#1082#1080' '#1089#1072#1081#1090#1072' "'#1053#1077' '#1073#1086#1083#1077#1081'"'
    TabOrder = 10
    Width = 165
  end
  object cbSiteTabletki: TcxCheckBox
    Left = 8
    Top = 161
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1063#1077#1082#1080' '#1089#1072#1081#1090#1072' "'#1058#1072#1073#1083#1077#1090#1082#1080'"'
    TabOrder = 11
    Width = 165
  end
  object cbSiteLiki24: TcxCheckBox
    Left = 8
    Top = 182
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1063#1077#1082#1080' '#1089#1072#1081#1090#1072' "Liki 24"'
    TabOrder = 12
    Width = 165
  end
  object cbMobileApplication: TcxCheckBox
    Left = 176
    Top = 99
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1058#1086#1083#1100#1082#1086' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088'.'
    TabOrder = 13
    Width = 152
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 175
    Top = 155
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 246
    Top = 89
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
    Left = 255
    Top = 159
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
        Name = 'IsRegularSales'
        Value = Null
        Component = cbRegularSales
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVIP'
        Value = Null
        Component = cbVIP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsSite'
        Value = Null
        Component = cbSite
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSiteTabletki'
        Value = Null
        Component = cbSiteTabletki
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSiteLiki24'
        Value = Null
        Component = cbSiteLiki24
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMobileApplication'
        Value = Null
        Component = cbMobileApplication
        MultiSelectSeparator = ','
      end>
    Left = 246
    Top = 25
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 158
    Top = 65
  end
end
