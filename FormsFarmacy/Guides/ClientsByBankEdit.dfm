object ClientsByBankEditForm: TClientsByBankEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1083#1080#1077#1085#1090#1099' '#1087#1086' '#1073#1077#1079#1085#1072#1083#1091'>'
  ClientHeight = 475
  ClientWidth = 380
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
  object edName: TcxTextEdit
    Left = 41
    Top = 68
    TabOrder = 0
    Width = 294
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 52
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 87
    Top = 435
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 237
    Top = 435
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 41
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 294
  end
  object cxLabel2: TcxLabel
    Left = 41
    Top = 91
    Caption = #1054#1050#1055#1054
  end
  object edOKPO: TcxTextEdit
    Left = 41
    Top = 107
    TabOrder = 7
    Width = 121
  end
  object cxLabel3: TcxLabel
    Left = 41
    Top = 210
    Caption = #1040#1076#1088#1077#1089' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
  end
  object cxLabel5: TcxLabel
    Left = 41
    Top = 170
    Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
  end
  object cxLabel6: TcxLabel
    Left = 41
    Top = 251
    Caption = #1040#1076#1088#1077#1089' '#1086#1090#1087#1088#1072#1074#1082#1080
  end
  object cxLabel4: TcxLabel
    Left = 41
    Top = 130
    Caption = #1058#1077#1083#1077#1092#1086#1085#1099
  end
  object edPhone: TcxTextEdit
    Left = 41
    Top = 146
    TabOrder = 13
    Width = 294
  end
  object edComment: TcxTextEdit
    Left = 41
    Top = 400
    TabOrder = 22
    Width = 294
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 381
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxLabel8: TcxLabel
    Left = 41
    Top = 338
    Caption = #1058#1077#1083#1077#1092#1086#1085' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
  end
  object cxLabel9: TcxLabel
    Left = 41
    Top = 293
    Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1103
  end
  object edContactPerson: TcxTextEdit
    Left = 41
    Top = 189
    TabOrder = 16
    Width = 294
  end
  object edRegAddress: TcxTextEdit
    Left = 41
    Top = 229
    TabOrder = 17
    Width = 294
  end
  object edSendingAddress: TcxTextEdit
    Left = 41
    Top = 270
    TabOrder = 18
    Width = 294
  end
  object edAccounting: TcxTextEdit
    Left = 41
    Top = 314
    TabOrder = 19
    Width = 294
  end
  object edPhoneAccountancy: TcxTextEdit
    Left = 41
    Top = 357
    TabOrder = 20
    Width = 294
  end
  object edINN: TcxTextEdit
    Left = 175
    Top = 107
    TabOrder = 8
    Width = 160
  end
  object cxLabel10: TcxLabel
    Left = 175
    Top = 91
    Caption = #1048#1053#1053
  end
  object ActionList: TActionList
    Left = 272
    Top = 20
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
    StoredProcName = 'gpInsertUpdate_Object_ClientsByBank'
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
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOKPO'
        Value = ''
        Component = edOKPO
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inINN'
        Value = ''
        Component = edINN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = ''
        Component = edPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContactPerson'
        Value = ''
        Component = edContactPerson
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegAddress'
        Value = ''
        Component = edRegAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSendingAddress'
        Value = Null
        Component = edSendingAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccounting'
        Value = ''
        Component = edAccounting
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhoneAccountancy'
        Value = Null
        Component = edPhoneAccountancy
        DataType = ftString
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
    Left = 32
    Top = 425
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ClientsByBank'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OKPO'
        Value = ''
        Component = edOKPO
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN'
        Value = ''
        Component = edINN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = ''
        Component = edPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContactPerson'
        Value = ''
        Component = edContactPerson
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegAddress'
        Value = ''
        Component = edRegAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendingAddress'
        Value = ''
        Component = edSendingAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Accounting'
        Value = ''
        Component = edAccounting
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneAccountancy'
        Value = ''
        Component = edPhoneAccountancy
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 23
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
end
