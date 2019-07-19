object Overdue_UpdateRangeCat5DialogForm: TOverdue_UpdateRangeCat5DialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1074#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1074' 5 '#1082#1072#1090#1077#1075#1086#1088#1080#1102
  ClientHeight = 233
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 26
    Top = 190
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 144
    Top = 190
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edPriceMin: TcxCurrencyEdit
    Left = 32
    Top = 40
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 2
    Width = 167
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 17
    Caption = #1053#1072#1095#1080#1085#1072#1103' '#1089' '#1094#1077#1085#1099' '#1074#1082#1083#1102#1095#1080#1090#1077#1083#1100#1085#1086
  end
  object edPriceMax: TcxCurrencyEdit
    Left = 32
    Top = 90
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 4
    Width = 167
  end
  object cxLabel9: TcxLabel
    Left = 32
    Top = 69
    Caption = #1047#1072#1082#1072#1085#1095#1080#1074#1072#1103' '#1094#1077#1085#1086#1081' '#1074#1082#1083#1102#1095#1080#1090#1077#1083#1100#1085#1086
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 198
    Top = 106
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
    Left = 127
    Top = 35
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PriceMax'
        Value = 0.000000000000000000
        Component = edPriceMax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceMin'
        Value = 0.000000000000000000
        Component = edPriceMin
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 142
    Top = 153
  end
  object ActionList: TActionList
    Left = 139
    Top = 106
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
  end
end
