object InternetRepairEditForm: TInternetRepairEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1056#1077#1084#1086#1085#1090' '#1080#1085#1090#1077#1088#1085#1077#1090#1072
  ClientHeight = 369
  ClientWidth = 707
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
  object ceContractNumber: TcxTextEdit
    Left = 24
    Top = 181
    TabOrder = 0
    Width = 296
  end
  object ctContractNumber: TcxLabel
    Left = 24
    Top = 158
    Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxButton1: TcxButton
    Left = 51
    Top = 322
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 229
    Top = 322
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 24
    Top = 3
    Caption = #8470' '#1087'/'#1087
  end
  object ceCode: TcxCurrencyEdit
    Left = 24
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 115
  end
  object cxLabel10: TcxLabel
    Left = 24
    Top = 54
    Caption = #1040#1087#1090#1077#1082#1072
  end
  object ceUnit: TcxButtonEdit
    Left = 24
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 296
  end
  object ceProvider: TcxTextEdit
    Left = 24
    Top = 125
    TabOrder = 8
    Width = 296
  end
  object cxLabel5: TcxLabel
    Left = 24
    Top = 107
    Caption = #1055#1088#1086#1074#1072#1081#1076#1077#1088
  end
  object cxLabel2: TcxLabel
    Left = 24
    Top = 206
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object cePhone: TcxTextEdit
    Left = 24
    Top = 229
    TabOrder = 11
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 24
    Top = 262
    Caption = #1050#1090#1086' '#1086#1092#1086#1088#1084#1080#1083' '#1076#1086#1075#1086#1074#1086#1088
  end
  object ceWhoSignedContract: TcxTextEdit
    Left = 24
    Top = 285
    TabOrder = 13
    Width = 296
  end
  object Panel: TPanel
    Left = 342
    Top = 0
    Width = 365
    Height = 369
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 14
    ExplicitWidth = 406
    object cxLabel4: TcxLabel
      Left = 1
      Top = 1
      Align = alTop
      Caption = #1055#1086#1084#1077#1090#1082#1080
      Properties.Alignment.Horz = taCenter
      ExplicitLeft = 40
      ExplicitTop = 54
      ExplicitWidth = 47
      AnchorX = 183
    end
    object cmNote: TcxMemo
      Left = 1
      Top = 18
      Align = alClient
      Lines.Strings = (
        'cmNote')
      TabOrder = 1
      ExplicitLeft = 168
      ExplicitTop = 144
      ExplicitWidth = 185
      ExplicitHeight = 89
      Height = 350
      Width = 363
    end
  end
  object ActionList: TActionList
    Left = 280
    Top = 84
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
    StoredProcName = 'gpInsertUpdate_Object_InternetRepair'
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
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProvider'
        Value = Null
        Component = ceProvider
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractNumber'
        Value = Null
        Component = ceContractNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = Null
        Component = cePhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWhoSignedContract'
        Value = Null
        Component = ceWhoSignedContract
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNotes'
        Value = Null
        Component = cmNote
        DataType = ftWideString
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
    Left = 248
    Top = 152
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InternetRepair'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'Provider'
        Value = Null
        Component = ceProvider
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractNumber'
        Value = Null
        Component = ceContractNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = cePhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'WhoSignedContract'
        Value = Null
        Component = ceWhoSignedContract
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Notes'
        Value = Null
        Component = cmNote
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 88
    Top = 143
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
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
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
    Left = 104
    Top = 60
  end
end
