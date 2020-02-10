object BuyerEditForm: TBuyerEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
  ClientHeight = 385
  ClientWidth = 295
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
    Left = 8
    Top = 136
    TabOrder = 2
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 117
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048#1084#1103' '#1054#1090#1095#1077#1089#1090#1074#1086
  end
  object cxButton1: TcxButton
    Left = 41
    Top = 347
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 9
  end
  object cxButton2: TcxButton
    Left = 185
    Top = 347
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 10
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 29
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 201
    Caption = 'e-mail'
  end
  object edEmail: TcxTextEdit
    Left = 8
    Top = 221
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 63
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object edPhone: TcxMaskEdit
    Left = 8
    Top = 86
    Properties.EditMask = '!\(999\)000-0000;1;_'
    TabOrder = 1
    Text = '(   )   -    '
    Width = 273
  end
  object edAddress: TcxTextEdit
    Left = 8
    Top = 270
    TabOrder = 6
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 250
    Caption = #1040#1076#1088#1077#1089
  end
  object edComment: TcxTextEdit
    Left = 8
    Top = 318
    TabOrder = 7
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 298
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 157
    Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
  end
  object cxLabel8: TcxLabel
    Left = 159
    Top = 157
    Caption = #1055#1086#1083
  end
  object edDateBirth: TcxDateEdit
    Left = 8
    Top = 180
    EditValue = 42951d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 100
  end
  object edSex: TcxComboBox
    Left = 159
    Top = 180
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      #1052#1091#1078#1089#1082#1086#1081
      #1046#1077#1085#1089#1082#1080#1081)
    TabOrder = 4
    Width = 121
  end
  object ActionList: TActionList
    Left = 208
    Top = 88
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Buyer'
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
        Component = edCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = Null
        Component = edPhone
        DataType = ftString
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
        Name = 'inEmail'
        Value = Null
        Component = edEmail
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBirth'
        Value = 'NULL'
        Component = edDateBirth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSex'
        Value = Null
        Component = edSex
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 64
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Buyer'
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
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = edPhone
        DataType = ftString
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
        Name = 'Email'
        Value = Null
        Component = edEmail
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftString
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
        Name = 'DateBirth'
        Value = 'NULL'
        Component = edDateBirth
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Sex'
        Value = Null
        Component = edSex
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 185
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
    Left = 176
    Top = 184
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 248
    Top = 16
  end
end
