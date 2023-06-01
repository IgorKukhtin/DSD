object OrderClientSummDialogForm: TOrderClientSummDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 243
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 64
    Top = 193
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 193
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edSummReal: TcxCurrencyEdit
    Left = 170
    Top = 136
    Hint = ' '#9#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1092#1072#1082#1090' ('#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072')'
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 2
    Width = 124
  end
  object cxLabel37: TcxLabel
    Left = 170
    Top = 118
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    Caption = 'C'#1091#1084#1084#1072' '#1092#1072#1082#1090
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel36: TcxLabel
    Left = 21
    Top = 118
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    Caption = 'C'#1082'. '#1088#1091#1095#1085'., '#1075#1088#1085
    ParentShowHint = False
    ShowHint = True
  end
  object edSummTax: TcxCurrencyEdit
    Left = 21
    Top = 136
    Hint = #1057#1091#1084#1084#1072' '#1088#1091#1095#1085#1086#1081' '#1089#1082#1080#1076#1082#1080' ('#1073#1077#1079' '#1053#1044#1057')'
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 5
    Width = 124
  end
  object cxLabel33: TcxLabel
    Left = 21
    Top = 15
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    Caption = '% '#1089#1082#1080#1076#1082#1080' '#1086#1089#1085'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 21
    Top = 38
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 7
    Width = 124
  end
  object cxLabel34: TcxLabel
    Left = 170
    Top = 15
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
    Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1086#1087'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edDiscountNextTax: TcxCurrencyEdit
    Left = 170
    Top = 38
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 9
    Width = 124
  end
  object cxLabel29: TcxLabel
    Left = 21
    Top = 69
    Caption = '% '#1053#1044#1057' :'
    ParentShowHint = False
    ShowHint = True
  end
  object edVATPercent: TcxCurrencyEdit
    Left = 21
    Top = 88
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 11
    Width = 124
  end
  object cxLabel27: TcxLabel
    Left = 170
    Top = 69
    Hint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
    Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090' :'
    ParentShowHint = False
    ShowHint = True
  end
  object edTransportSumm_load: TcxCurrencyEdit
    Left = 170
    Top = 88
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 13
    Width = 124
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 172
    Top = 167
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
    Top = 173
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SummReal'
        Value = 'NULL'
        Component = edSummReal
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTax'
        Value = Null
        Component = edSummTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransportSumm_load'
        Value = Null
        Component = edTransportSumm_load
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 103
    Top = 143
  end
  object ActionList: TActionList
    Left = 16
    Top = 195
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
