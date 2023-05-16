object OrderClientSummDialogForm: TOrderClientSummDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 147
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
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 105
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edSummReal: TcxCurrencyEdit
    Left = 176
    Top = 46
    Hint = ' '#9#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1092#1072#1082#1090' ('#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072')'
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 2
    Width = 115
  end
  object cxLabel37: TcxLabel
    Left = 176
    Top = 23
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    Caption = 'C'#1091#1084#1084#1072' '#1092#1072#1082#1090
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel36: TcxLabel
    Left = 29
    Top = 23
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    Caption = 'C'#1082'. '#1088#1091#1095#1085'., '#1075#1088#1085
    ParentShowHint = False
    ShowHint = True
  end
  object edSummTax: TcxCurrencyEdit
    Left = 29
    Top = 46
    Hint = #1057#1091#1084#1084#1072' '#1088#1091#1095#1085#1086#1081' '#1089#1082#1080#1076#1082#1080' ('#1073#1077#1079' '#1053#1044#1057')'
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 5
    Width = 110
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 172
    Top = 79
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
    Left = 13
    Top = 77
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
      end>
    Left = 103
    Top = 39
  end
  object ActionList: TActionList
    Left = 16
    Top = 107
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
