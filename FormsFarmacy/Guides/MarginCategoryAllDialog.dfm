object MarginCategoryAllDialogForm: TMarginCategoryAllDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' %% '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080
  ClientHeight = 282
  ClientWidth = 266
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
    Left = 22
    Top = 242
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 153
    Top = 242
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel5: TcxLabel
    Left = 93
    Top = 21
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object cxLabel1: TcxLabel
    Left = 93
    Top = 51
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object cxLabel2: TcxLabel
    Left = 93
    Top = 81
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object cxLabel3: TcxLabel
    Left = 93
    Top = 111
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object cxLabel4: TcxLabel
    Left = 93
    Top = 141
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object cxLabel6: TcxLabel
    Left = 93
    Top = 171
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object cxLabel7: TcxLabel
    Left = 93
    Top = 201
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
  end
  object edVal1: TcxCurrencyEdit
    Left = 169
    Top = 20
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 9
    Width = 80
  end
  object cbVal1: TcxCheckBox
    Left = 9
    Top = 20
    Hint = '0-15'
    Caption = '0-100'
    ParentColor = False
    State = cbsChecked
    TabOrder = 10
    Width = 67
  end
  object cbVal2: TcxCheckBox
    Left = 9
    Top = 53
    Caption = '100-250'
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 11
    Width = 74
  end
  object cbVal3: TcxCheckBox
    Left = 9
    Top = 80
    Caption = '250-350'
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 12
    Width = 76
  end
  object cbVal4: TcxCheckBox
    Left = 9
    Top = 110
    Caption = '350-500'
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 13
    Width = 77
  end
  object cbVal5: TcxCheckBox
    Left = 9
    Top = 140
    Caption = '500-1000'
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 14
    Width = 77
  end
  object cbVal6: TcxCheckBox
    Left = 9
    Top = 170
    Caption = '1000-2000'
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 15
    Width = 81
  end
  object cbVal7: TcxCheckBox
    Left = 9
    Top = 200
    Caption = '> 2000'
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 16
    Width = 74
  end
  object edVal2: TcxCurrencyEdit
    Left = 169
    Top = 50
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 17
    Width = 80
  end
  object edVal3: TcxCurrencyEdit
    Left = 169
    Top = 80
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 18
    Width = 80
  end
  object edVal4: TcxCurrencyEdit
    Left = 169
    Top = 110
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 19
    Width = 80
  end
  object edVal5: TcxCurrencyEdit
    Left = 169
    Top = 140
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 20
    Width = 80
  end
  object edVal6: TcxCurrencyEdit
    Left = 169
    Top = 170
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 21
    Width = 80
  end
  object edVal7: TcxCurrencyEdit
    Left = 169
    Top = 200
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 22
    Width = 80
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 217
    Top = 74
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
    Left = 216
    Top = 117
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'isVal1'
        Value = Null
        Component = cbVal1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVal2'
        Value = Null
        Component = cbVal2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVal3'
        Value = Null
        Component = cbVal3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVal4'
        Value = Null
        Component = cbVal4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVal5'
        Value = Null
        Component = cbVal5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVal6'
        Value = Null
        Component = cbVal6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVal7'
        Value = Null
        Component = cbVal7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val1'
        Value = Null
        Component = edVal1
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val2'
        Value = Null
        Component = edVal2
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val3'
        Value = Null
        Component = edVal3
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val4'
        Value = Null
        Component = edVal4
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val5'
        Value = Null
        Component = edVal5
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val6'
        Value = Null
        Component = edVal6
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Val7'
        Value = Null
        Component = edVal7
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 111
    Top = 202
  end
end
