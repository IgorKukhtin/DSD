object DiscountPersentDialogForm: TDiscountPersentDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
  ClientHeight = 136
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 74
    Top = 88
    Width = 75
    Height = 22
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 178
    Top = 88
    Width = 75
    Height = 22
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object ceValue: TcxCurrencyEdit
    Left = 73
    Top = 47
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 2
    Width = 179
  end
  object edParamName: TcxTextEdit
    AlignWithMargins = True
    Left = 24
    Top = 17
    ParentCustomHint = False
    BeepOnEnter = False
    Enabled = False
    ParentFont = False
    Properties.HideSelection = False
    Properties.ReadOnly = True
    Style.Edges = []
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.Shadow = False
    Style.TextColor = clNone
    Style.IsFontAssigned = True
    StyleDisabled.BorderColor = clNone
    StyleDisabled.TextColor = clNone
    StyleFocused.BorderColor = clLime
    StyleHot.BorderColor = clSilver
    StyleHot.TextStyle = [fsBold]
    TabOrder = 3
    Text = 
      #1048#1079#1084#1077#1085#1080#1090#1100' '#1094#1077#1085#1099' '#1074#1093'. '#1080' '#1087#1088#1086#1076#1072#1078#1080' '#1085#1072' % '#1089#1082#1080#1076#1082#1080', '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077 +
      #1085#1090#1099
    Width = 260
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 22
    Top = 104
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
    Left = 271
    Top = 24
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ParamValue'
        Value = Null
        Component = ceValue
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParamName'
        Value = Null
        Component = edParamName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 14
    Top = 59
  end
  object ActionList: TActionList
    Left = 275
    Top = 89
    object actRefreshStart: TdsdDataSetRefresh
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
