object MobileNumbersEmployeeEdit2Form: TMobileNumbersEmployeeEdit2Form
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085'>'
  ClientHeight = 340
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
    340)
  PixelsPerInch = 96
  TextHeight = 13
  object edEmployeeName: TcxButtonEdit
    Left = 8
    Top = 70
    Properties.Buttons = <
      item
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
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
  object cxLabel1: TcxLabel
    Left = 10
    Top = 55
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
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
    Top = 304
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Anchors = [akRight, akBottom]
    Default = True
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 262
    Top = 304
    Width = 75
    Height = 25
    Action = dsdFormClose
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    ModalResult = 8
    TabOrder = 3
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
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 5
    Width = 329
  end
  object edComments: TcxTextEdit
    Left = 8
    Top = 273
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
  object lblComments: TcxLabel
    Left = 10
    Top = 256
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    Transparent = True
  end
  object cxGroupBox2: TcxGroupBox
    Left = 8
    Top = 183
    PanelStyle.Active = True
    Style.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.Kind = lfOffice11
    TabOrder = 8
    Height = 67
    Width = 329
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
      Left = 85
      Top = 11
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = '0.00'
      Properties.EditFormat = '0.00'
      Properties.Nullable = False
      Style.BorderStyle = ebsOffice11
      Style.Edges = [bBottom]
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      Style.Shadow = False
      Style.TransparentBorder = True
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
      Caption = '...'#1089#1083#1091#1078#1077#1073#1085#1099#1081
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
    object ceLimitDuty: TcxCurrencyEdit
      Left = 85
      Top = 38
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = '0.00'
      Properties.EditFormat = '0.00'
      Properties.Nullable = False
      Style.Edges = [bBottom]
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
    object lblOverLimit: TcxLabel
      Left = 180
      Top = 12
      Caption = #1055#1077#1088#1077#1083#1080#1084#1080#1090
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
    object ceOverLimit: TcxCurrencyEdit
      Left = 244
      Top = 12
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = '0.00'
      Properties.EditFormat = '0.00'
      Properties.Nullable = False
      Style.Edges = [bBottom]
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
    object lblNavigator: TcxLabel
      Left = 180
      Top = 39
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
      Left = 244
      Top = 38
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = '0.00'
      Properties.EditFormat = '0.00'
      Properties.Nullable = False
      Style.Edges = [bBottom]
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 7
      Width = 77
    end
  end
  object lblMobileNumber: TcxLabel
    Left = 10
    Top = 97
    Caption = #1053#1086#1084#1077#1088' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1090#1077#1083#1077#1092#1086#1085#1072
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
    Top = 113
    Properties.ReadOnly = False
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
  object edTariff: TcxButtonEdit
    Left = 8
    Top = 155
    Properties.Buttons = <
      item
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 11
    Width = 329
  end
  object lblTariff: TcxLabel
    Left = 10
    Top = 140
    Caption = #1058#1072#1088#1080#1092
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
    StoredProcName = 'gpInsertUpdate_dirMobileNumbersEmployee'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inID'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'ID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobileTariffID'
        Value = 0c
        Component = MobileTariffGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLim'
        Value = ''
        Component = ceLimit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitDuty'
        Value = ''
        Component = ceLimitDuty
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
        Name = 'inOverLimit'
        Value = ''
        Component = ceOverLimit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmployeeID'
        Value = ''
        Component = EmployeeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComms'
        Value = ''
        Component = edComments
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobileNum'
        Value = Null
        Component = ceMobileNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 117
    Top = 3
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'ID'
        Value = 0
        Component = ceCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 195
    Top = 5
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_dirMobileNumbersEmployee'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inid'
        Value = 0
        Component = dsdFormParams
        ComponentItem = 'ID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmployeeID'
        Value = Null
        Component = EmployeeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmployeeName'
        Value = ''
        Component = EmployeeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileTariffID'
        Value = 0
        Component = MobileTariffGuide
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TariffName'
        Value = Null
        Component = MobileTariffGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileNum'
        Value = Null
        Component = ceMobileNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Lim'
        Value = Null
        Component = ceLimit
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDuty'
        Value = '0'
        Component = ceLimitDuty
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OverLimit'
        Value = ''
        Component = ceOverLimit
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
        Name = 'Comms'
        Value = ''
        Component = edComments
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 241
    Top = 6
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
    Left = 156
    Top = 3
  end
  object EmployeeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEmployeeName
    isShowModal = True
    Key = '0'
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = EmployeeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = EmployeeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 59
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
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpGet_dirMobileNumbersEmployee'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inid'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'ID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmployeeID'
        Value = '0'
        Component = EmployeeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmployeeName'
        Value = ''
        Component = EmployeeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileTariffID'
        Value = '0'
        Component = MobileTariffGuide
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TariffName'
        Value = ''
        Component = MobileTariffGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobileNum'
        Value = ''
        Component = ceMobileNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Lim'
        Value = 0.000000000000000000
        Component = ceLimit
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDuty'
        Value = 0.000000000000000000
        Component = ceLimitDuty
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OverLimit'
        Value = 0.000000000000000000
        Component = ceOverLimit
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Navigator'
        Value = 0.000000000000000000
        Component = ceNavigator
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comms'
        Value = ''
        Component = edComments
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 286
    Top = 1
  end
end
