object Report_Goods_RemainsCurrent_onDateDialogForm: TReport_Goods_RemainsCurrent_onDateDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054#1089#1090#1072#1090#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1076#1072#1090#1091'>'
  ClientHeight = 395
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 59
    Top = 358
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 233
    Top = 358
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edUnit: TcxButtonEdit
    Left = 16
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 305
  end
  object cxLabel3: TcxLabel
    Left = 16
    Top = 94
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1043#1088#1091#1087#1087#1072':'
  end
  object cbPartion: TcxCheckBox
    Left = 33
    Top = 40
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Width = 130
  end
  object cbSize: TcxCheckBox
    Left = 33
    Top = 67
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Width = 120
  end
  object cbPartner: TcxCheckBox
    Left = 180
    Top = 40
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Width = 80
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 150
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
  end
  object edBrand: TcxButtonEdit
    Left = 16
    Top = 170
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 305
  end
  object cxLabel4: TcxLabel
    Left = 16
    Top = 246
    Caption = #1057#1077#1079#1086#1085' :'
  end
  object edPeriod: TcxButtonEdit
    Left = 16
    Top = 265
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 305
  end
  object cxLabel2: TcxLabel
    Left = 16
    Top = 201
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
  end
  object edPartner: TcxButtonEdit
    Left = 16
    Top = 220
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 305
  end
  object cxLabel5: TcxLabel
    Left = 16
    Top = 298
    Caption = #1043#1086#1076' '#1089' ...'
  end
  object cxLabel6: TcxLabel
    Left = 100
    Top = 298
    Caption = #1043#1086#1076' '#1087#1086' ...'
  end
  object cbYear: TcxCheckBox
    Left = 188
    Top = 318
    Hint = 'Visible = False '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
    Caption = 'Visible = False '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    Visible = False
    Width = 142
  end
  object edStartYear: TcxButtonEdit
    Left = 16
    Top = 318
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 80
  end
  object edEndYear: TcxButtonEdit
    Left = 100
    Top = 318
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 80
  end
  object cbRemains: TcxCheckBox
    Left = 180
    Top = 67
    Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084' = 0'
    Caption = #1054#1089#1090#1072#1090#1086#1082' = 0'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 18
    Width = 92
  end
  object cxLabel7: TcxLabel
    Left = 31
    Top = 8
    Caption = #1054#1089#1090#1072#1090#1082#1080' '#1085#1072':'
  end
  object deOperDate: TcxDateEdit
    Left = 103
    Top = 8
    EditValue = 42460d
    Properties.DateOnError = deToday
    Properties.DisplayFormat = 'dd.mm.yyyy'
    Properties.EditFormat = 'dd.mm.yyyy'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 20
    Width = 98
  end
  object PeriodChoice: TPeriodChoice
    Left = 269
    Top = 95
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 268
    Top = 247
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
    Left = 285
    Top = 134
  end
  object FormParams: TdsdFormParams
    Params = <
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
        Name = 'isPartion'
        Value = Null
        Component = cbPartion
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
        Name = 'isPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPeriodYear'
        Value = Null
        Component = cbYear
        DataType = ftBoolean
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
        Name = 'isRemains'
        Value = Null
        Component = cbRemains
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 164
    Top = 345
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
    Left = 212
    Top = 112
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
    Left = 116
    Top = 160
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
    Left = 132
    Top = 256
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
    Left = 244
    Top = 196
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
        Value = Null
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
    Left = 44
    Top = 312
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
        Value = Null
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
    Left = 116
    Top = 312
  end
  object spGet_Unit: TdsdStoredProc
    StoredProcName = 'gpGet_UnitbyUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 174
    Top = 214
  end
  object ActionList: TActionList
    Left = 153
    Top = 127
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Unit
      StoredProcList = <
        item
          StoredProc = spGet_Unit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Unit
      StoredProcList = <
        item
          StoredProc = spGet_Unit
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
