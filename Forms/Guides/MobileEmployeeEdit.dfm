object MobileEmployeeEditForm: TMobileEmployeeEditForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072'>'
  ClientHeight = 455
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  DesignSize = (
    347
    455)
  PixelsPerInch = 96
  TextHeight = 13
  object edPersonal: TcxButtonEdit
    Left = 8
    Top = 109
    Properties.Buttons = <
      item
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 1
    Width = 329
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 94
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'/'#1057#1086#1090#1088#1091#1076#1085#1080#1082'/'#1059#1095#1088#1077#1076#1080#1090#1077#1083#1100
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    Transparent = True
  end
  object cxButton1: TcxButton
    Left = 180
    Top = 419
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Anchors = [akRight, akBottom]
    Default = True
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    ModalResult = 8
    TabOrder = 3
    ExplicitTop = 346
  end
  object cxButton2: TcxButton
    Left = 262
    Top = 419
    Width = 75
    Height = 25
    Action = dsdFormClose
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    ModalResult = 8
    TabOrder = 4
    ExplicitTop = 346
  end
  object lblID: TcxLabel
    Left = 10
    Top = 12
    Caption = #1050#1086#1076
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    Transparent = True
  end
  object ceCode: TcxCurrencyEdit
    Left = 8
    Top = 28
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 6
    Width = 329
  end
  object edComment: TcxTextEdit
    Left = 8
    Top = 365
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 0
    Width = 329
  end
  object lblComments: TcxLabel
    Left = 10
    Top = 348
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    Transparent = True
  end
  object lblMobileNumber: TcxLabel
    Left = 10
    Top = 54
    Caption = #8470' '#1090#1077#1083#1077#1092#1086#1085#1072
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    Transparent = True
  end
  object ceMobileNumber: TcxTextEdit
    Left = 8
    Top = 70
    Properties.ReadOnly = False
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 9
    Width = 329
  end
  object edTariff: TcxButtonEdit
    Left = 8
    Top = 149
    Properties.Buttons = <
      item
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 10
    Width = 329
  end
  object lblTariff: TcxLabel
    Left = 10
    Top = 134
    Caption = #1058#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    Transparent = True
  end
  object cxGroupBox2: TcxGroupBox
    Left = 10
    Top = 182
    PanelStyle.Active = True
    Style.BorderStyle = ebsSingle
    Style.LookAndFeel.Kind = lfUltraFlat
    StyleDisabled.LookAndFeel.Kind = lfUltraFlat
    StyleFocused.LookAndFeel.Kind = lfUltraFlat
    StyleHot.LookAndFeel.Kind = lfUltraFlat
    TabOrder = 12
    Height = 67
    Width = 326
    object lblLimit: TcxLabel
      Left = 10
      Top = 12
      Caption = #1051#1080#1084#1080#1090', '#1075#1088#1085
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      Transparent = True
    end
    object ceLimit: TcxCurrencyEdit
      Left = 106
      Top = 11
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = '0.00'
      Properties.EditFormat = '0.00'
      Properties.Nullable = False
      Style.BorderStyle = ebsUltraFlat
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      Width = 77
    end
    object lblLimitDuty: TcxLabel
      Left = 10
      Top = 39
      Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1083#1080#1084#1080#1090
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      Transparent = True
    end
    object ceDutyLimit: TcxCurrencyEdit
      Left = 106
      Top = 38
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0.00####'
      Properties.EditFormat = '0.00####'
      Properties.Nullable = False
      Style.BorderStyle = ebsUltraFlat
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 3
      Width = 77
    end
    object lblNavigator: TcxLabel
      Left = 221
      Top = 15
      Caption = #1053#1072#1074#1080#1075#1072#1090#1086#1088
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      Transparent = True
    end
    object ceNavigator: TcxCurrencyEdit
      Left = 221
      Top = 38
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0.00####'
      Properties.EditFormat = '0.00####'
      Properties.Nullable = False
      Style.BorderStyle = ebsUltraFlat
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 5
      Width = 77
    end
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 256
    Caption = #1056#1077#1075#1080#1086#1085
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    Transparent = True
  end
  object edRegion: TcxButtonEdit
    Left = 8
    Top = 271
    Properties.Buttons = <
      item
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 14
    Width = 329
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 302
    Caption = #1055#1072#1082#1077#1090' '#1084#1086#1073'. '#1086#1087#1077#1088#1072#1090#1086#1088#1072
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    Transparent = True
  end
  object edMobilePack: TcxButtonEdit
    Left = 8
    Top = 317
    Properties.Buttons = <
      item
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.BorderStyle = ebsUltraFlat
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 16
    Width = 329
  end
  object ActionList: TActionList
    Left = 44
    Top = 5
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
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
    StoredProcName = 'gpInsertUpdate_Object_MobileEmployee2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'ID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ceMobileNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimit'
        Value = ''
        Component = ceLimit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDutyLimit'
        Value = ''
        Component = ceDutyLimit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNavigator'
        Value = ''
        Component = ceNavigator
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobileTariffId'
        Value = 0c
        Component = MobileTariffGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegionId'
        Value = Null
        Component = RegionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobilePackId'
        Value = Null
        Component = GuidesMobilePack
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 141
    Top = 3
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'ID'
        Value = 0
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 219
    Top = 65533
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MobileEmployee2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inid'
        Value = 0
        Component = dsdFormParams
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = ceMobileNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileTariffId'
        Value = 0
        Component = MobileTariffGuide
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileTariffName'
        Value = Null
        Component = MobileTariffGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileLimit'
        Value = Null
        Component = ceLimit
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DutyLimit'
        Value = 0.000000000000000000
        Component = ceDutyLimit
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Navigator'
        Value = Null
        Component = ceNavigator
        DataType = ftFloat
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
        Name = 'RegionId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionName'
        Value = Null
        Component = RegionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobilePackId'
        Value = Null
        Component = GuidesMobilePack
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobilePackName'
        Value = Null
        Component = GuidesMobilePack
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 281
    Top = 30
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 80
    Top = 3
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 204
    Top = 43
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    isShowModal = True
    Key = '0'
    FormNameParam.Value = 'TPersonalUnitFounder_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalUnitFounder_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 102
  end
  object MobileTariffGuide: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTariff
    isShowModal = True
    Key = '0'
    FormNameParam.Value = 'TMobileTariffForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMobileTariffForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = 0
        Component = MobileTariffGuide
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MobileTariffGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 124
  end
  object RegionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRegion
    isShowModal = True
    Key = '0'
    FormNameParam.Value = 'TRegionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRegionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = RegionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 268
  end
  object GuidesMobilePack: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMobilePack
    isShowModal = True
    Key = '0'
    FormNameParam.Value = 'TMobilePackForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMobilePackForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesMobilePack
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMobilePack
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 306
  end
end
