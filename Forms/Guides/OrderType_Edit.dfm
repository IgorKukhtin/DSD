object OrderType_EditForm: TOrderType_EditForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 335
  ClientWidth = 347
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
    Left = 37
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 195
    Top = 284
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edKoeff1: TcxCurrencyEdit
    Left = 17
    Top = 30
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 2
    Width = 56
  end
  object edKoeff2: TcxCurrencyEdit
    Left = 17
    Top = 70
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 3
    Width = 56
  end
  object cxLabel7: TcxLabel
    Left = 17
    Top = 15
    Caption = #1071#1085#1074#1072#1088#1100
  end
  object cxLabel1: TcxLabel
    Left = 17
    Top = 55
    Caption = #1060#1077#1074#1088#1072#1083#1100
  end
  object cxLabel2: TcxLabel
    Left = 17
    Top = 95
    Caption = #1052#1072#1088#1090
  end
  object edKoeff3: TcxCurrencyEdit
    Left = 17
    Top = 110
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 7
    Width = 56
  end
  object cbChange1: TcxCheckBox
    Left = 79
    Top = 30
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 8
    Width = 73
  end
  object cbСhange2: TcxCheckBox
    Left = 79
    Top = 70
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 9
    Width = 73
  end
  object cbСhange3: TcxCheckBox
    Left = 79
    Top = 110
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 10
    Width = 73
  end
  object cxLabel3: TcxLabel
    Left = 17
    Top = 135
    Caption = #1040#1087#1088#1077#1083#1100
  end
  object edKoeff4: TcxCurrencyEdit
    Left = 17
    Top = 150
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 12
    Width = 56
  end
  object cbСhange4: TcxCheckBox
    Left = 79
    Top = 150
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 13
    Width = 73
  end
  object cxLabel4: TcxLabel
    Left = 17
    Top = 175
    Caption = #1052#1072#1081
  end
  object edKoeff5: TcxCurrencyEdit
    Left = 17
    Top = 190
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 15
    Width = 56
  end
  object cbСhange5: TcxCheckBox
    Left = 79
    Top = 190
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 16
    Width = 73
  end
  object cxLabel5: TcxLabel
    Left = 17
    Top = 215
    Caption = #1048#1102#1085#1100
  end
  object edKoeff6: TcxCurrencyEdit
    Left = 17
    Top = 230
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 18
    Width = 56
  end
  object cbСhange6: TcxCheckBox
    Left = 79
    Top = 230
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 19
    Width = 73
  end
  object edKoeff7: TcxCurrencyEdit
    Left = 177
    Top = 30
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 20
    Width = 56
  end
  object edKoeff8: TcxCurrencyEdit
    Left = 177
    Top = 70
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 21
    Width = 56
  end
  object cxLabel6: TcxLabel
    Left = 177
    Top = 15
    Caption = #1048#1102#1083#1100
  end
  object cxLabel8: TcxLabel
    Left = 177
    Top = 55
    Caption = #1040#1074#1075#1091#1089#1090
  end
  object cxLabel9: TcxLabel
    Left = 177
    Top = 95
    Caption = #1057#1077#1085#1090#1103#1073#1088#1100
  end
  object edKoeff9: TcxCurrencyEdit
    Left = 177
    Top = 110
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 25
    Width = 56
  end
  object cbСhange7: TcxCheckBox
    Left = 239
    Top = 30
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 26
    Width = 73
  end
  object cbСhange8: TcxCheckBox
    Left = 239
    Top = 70
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 27
    Width = 73
  end
  object cbСhange9: TcxCheckBox
    Left = 239
    Top = 110
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 28
    Width = 73
  end
  object cxLabel10: TcxLabel
    Left = 177
    Top = 137
    Caption = #1054#1082#1090#1103#1073#1088#1100
  end
  object edKoeff10: TcxCurrencyEdit
    Left = 177
    Top = 150
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 30
    Width = 56
  end
  object cbСhange10: TcxCheckBox
    Left = 239
    Top = 150
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 31
    Width = 73
  end
  object cxLabel11: TcxLabel
    Left = 177
    Top = 175
    Caption = #1053#1086#1103#1073#1088#1100
  end
  object edKoeff11: TcxCurrencyEdit
    Left = 177
    Top = 190
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 33
    Width = 56
  end
  object cbСhange11: TcxCheckBox
    Left = 239
    Top = 190
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 34
    Width = 73
  end
  object cxLabel12: TcxLabel
    Left = 177
    Top = 215
    Caption = #1044#1077#1082#1072#1073#1088#1100
  end
  object edKoeff12: TcxCurrencyEdit
    Left = 177
    Top = 230
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 36
    Width = 56
  end
  object cbСhange12: TcxCheckBox
    Left = 239
    Top = 230
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 37
    Width = 73
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 281
    Top = 281
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
    Left = 312
    Top = 202
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inKoeff1'
        Value = Null
        Component = edKoeff1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff2'
        Value = Null
        Component = edKoeff2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff3'
        Value = Null
        Component = edKoeff3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff4'
        Value = Null
        Component = edKoeff4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff5'
        Value = Null
        Component = edKoeff5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff6'
        Value = Null
        Component = edKoeff6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff7'
        Value = Null
        Component = edKoeff7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff8'
        Value = Null
        Component = edKoeff8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff9'
        Value = Null
        Component = edKoeff9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff10'
        Value = Null
        Component = edKoeff10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff11'
        Value = Null
        Component = edKoeff11
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff12'
        Value = Null
        Component = edKoeff12
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange1'
        Value = Null
        Component = cbChange1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange2'
        Value = Null
        Component = cbСhange2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange3'
        Value = Null
        Component = cbСhange3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange4'
        Value = Null
        Component = cbСhange4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange5'
        Value = Null
        Component = cbСhange5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange6'
        Value = Null
        Component = cbСhange6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange7'
        Value = Null
        Component = cbСhange7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange8'
        Value = Null
        Component = cbСhange8
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange9'
        Value = Null
        Component = cbСhange9
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange10'
        Value = Null
        Component = cbСhange10
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange11'
        Value = Null
        Component = cbСhange11
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange12'
        Value = Null
        Component = cbСhange12
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 135
    Top = 282
  end
end
