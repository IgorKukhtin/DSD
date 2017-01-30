object MobileTariffEdit2Form: TMobileTariffEdit2Form
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1072#1088#1080#1092'>'
  ClientHeight = 346
  ClientWidth = 346
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
    346
    346)
  PixelsPerInch = 96
  TextHeight = 13
  object edTariffName: TcxTextEdit
    Left = 10
    Top = 72
    Anchors = [akLeft, akTop, akRight]
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 0
    Width = 327
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
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
    Left = 179
    Top = 310
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
    Top = 310
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
  object lblCode: TcxLabel
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
    Left = 10
    Top = 28
    Anchors = [akLeft, akTop, akRight]
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
    Width = 327
  end
  object edComments: TcxTextEdit
    Left = 8
    Top = 277
    Anchors = [akLeft, akTop, akRight]
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
  object cxLabel21: TcxLabel
    Left = 8
    Top = 260
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
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
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 181
    Caption = #1042#1085#1077' '#1087#1072#1082#1077#1090#1072
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 8
    Height = 73
    Width = 329
    object ceMinuteCost: TcxCurrencyEdit
      Left = 95
      Top = 14
      EditValue = 0c
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0.00####'
      Properties.EditFormat = '0.00####'
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Width = 77
    end
    object ceSMSCost: TcxCurrencyEdit
      Left = 95
      Top = 41
      EditValue = 0c
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0.00####'
      Properties.EditFormat = '0.00####'
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
    object ceInetCost: TcxCurrencyEdit
      Left = 244
      Top = 41
      EditValue = 0c
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0.00####'
      Properties.EditFormat = '0.00####'
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 2
      Width = 77
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 18
      Caption = '1 '#1052#1080#1085#1091#1090#1072
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
    object cxLabel4: TcxLabel
      Left = 10
      Top = 41
      Caption = '1 SMS'
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
    object cxLabel5: TcxLabel
      Left = 244
      Top = 18
      Caption = #1048#1085#1090#1077#1088#1085#1077#1090' 1'#1052#1041
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
  end
  object cxGroupBox2: TcxGroupBox
    Left = 8
    Top = 99
    Caption = #1042' '#1087#1072#1082#1077#1090#1077
    Style.LookAndFeel.Kind = lfOffice11
    Style.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.Kind = lfOffice11
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfOffice11
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfOffice11
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 9
    Height = 76
    Width = 329
    object cxLabel2: TcxLabel
      Left = 10
      Top = 20
      Caption = #1040#1073#1086#1085#1087#1083#1072#1090#1072', '#1075#1088#1085
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
    object ceMonthly: TcxCurrencyEdit
      Left = 95
      Top = 19
      EditValue = 0c
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0.00####'
      Properties.EditFormat = '0.00####'
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
    object cxLabel15: TcxLabel
      Left = 10
      Top = 47
      Caption = #1052#1080#1085#1091#1090
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
    object cePocketMinutes: TcxCurrencyEdit
      Left = 95
      Top = 46
      EditValue = 0
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0'
      Properties.EditFormat = '0'
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
    object cxLabel16: TcxLabel
      Left = 180
      Top = 20
      Caption = 'SMS'
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
    object cePocketSMS: TcxCurrencyEdit
      Left = 244
      Top = 19
      EditValue = 0
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0'
      Properties.EditFormat = '0'
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
    object cxLabel17: TcxLabel
      Left = 180
      Top = 47
      Caption = #1048#1085#1090#1077#1088#1085#1077#1090
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
    object cePocketInet: TcxCurrencyEdit
      Left = 244
      Top = 46
      EditValue = 0
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = '0'
      Properties.EditFormat = '0'
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
  object ActionList: TActionList
    Left = 114
    Top = 60
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
    StoredProcName = 'gpInsertUpdate_dirMobileTariff'
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
        Name = 'inTariffName'
        Value = ''
        Component = edTariffName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonthly'
        Value = 0c
        Component = ceMonthly
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPocketMinutes'
        Value = ''
        Component = cePocketMinutes
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPocketSMS'
        Value = ''
        Component = cePocketSMS
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPocketInet'
        Value = ''
        Component = cePocketInet
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinuteCost'
        Value = ''
        Component = ceMinuteCost
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSMSCost'
        Value = ''
        Component = ceSMSCost
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInetCost'
        Value = ''
        Component = ceInetCost
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComments'
        Value = ''
        Component = edComments
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 13
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'ID'
        Value = Null
        Component = ceCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 270
    Top = 10
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_dirMobileTariff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'intariffid'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'ID'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TariffName'
        Value = ''
        Component = edTariffName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Monthly'
        Value = ''
        Component = ceMonthly
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PocketMinutes'
        Value = ''
        Component = cePocketMinutes
        MultiSelectSeparator = ','
      end
      item
        Name = 'PocketSMS'
        Value = ''
        Component = cePocketSMS
        MultiSelectSeparator = ','
      end
      item
        Name = 'PocketInet'
        Value = ''
        Component = cePocketInet
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinuteCost'
        Value = ''
        Component = ceMinuteCost
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SMSCost'
        Value = ''
        Component = ceSMSCost
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InetCost'
        Value = ''
        Component = ceInetCost
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
    Left = 161
    Top = 61
  end
  object cxPropertiesStore: TcxPropertiesStore
    Active = False
    Components = <
      item
        Component = Owner
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 55
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 161
    Top = 13
  end
end
