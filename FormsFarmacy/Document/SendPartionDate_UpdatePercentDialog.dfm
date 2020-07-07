object SendPartionDate_UpdatePercentDialogForm: TSendPartionDate_UpdatePercentDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1086#1094#1077#1085#1090#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
  ClientHeight = 274
  ClientWidth = 342
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
    Left = 42
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 230
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 38
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 315
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 18
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edChangePercentMin: TcxCurrencyEdit
    Left = 8
    Top = 88
    EditValue = 100.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 4
    Width = 167
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 65
    Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1089#1088#1086#1082' '#1084#1077#1085#1100#1096#1077' 50 '#1076#1085'.)'
  end
  object edChangePercentLess: TcxCurrencyEdit
    Left = 8
    Top = 138
    EditValue = 50.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 167
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 117
    Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1089#1088#1086#1082' '#1086#1090' 50 '#1076#1086' 90 '#1076#1085'.)'
  end
  object edChangePercent: TcxCurrencyEdit
    Left = 8
    Top = 192
    EditValue = 20.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 167
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 171
    Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1089#1088#1086#1082' '#1086#1090' 90 '#1076#1086' 200 '#1076#1085'.)'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 286
    Top = 82
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
    Left = 215
    Top = 11
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = 0
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 100.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercentLess'
        Value = Null
        Component = edChangePercentLess
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercentMin'
        Value = 20.000000000000000000
        Component = edChangePercentMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 230
    Top = 129
  end
  object UnitGuides: TdsdGuides
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
        Value = 0
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 70
    Top = 41
  end
  object ActionList: TActionList
    Left = 227
    Top = 82
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
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
  end
end
