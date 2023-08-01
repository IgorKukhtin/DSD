inherited CashCloseDialogForm: TCashCloseDialogForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1080#1072#1083#1086#1075' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1095#1077#1082#1072
  ClientHeight = 176
  ClientWidth = 655
  GlassFrame.Bottom = 60
  Position = poScreenCenter
  OnKeyDown = ParentFormKeyDown
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.Params = nil
  ExplicitWidth = 661
  ExplicitHeight = 205
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 215
    Top = 104
    ExplicitLeft = 215
    ExplicitTop = 104
  end
  inherited bbCancel: TcxButton
    Left = 338
    Top = 104
    ModalResult = 2
    ExplicitLeft = 338
    ExplicitTop = 104
  end
  object cxGroupBox1: TcxGroupBox [2]
    Left = 8
    Top = 8
    Caption = #1057#1091#1084#1084#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
    TabOrder = 2
    Height = 73
    Width = 201
    object edSalerCash: TcxCurrencyEdit
      Left = 16
      Top = 19
      ParentFont = False
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = ',0.00'
      Properties.OnChange = edSalerCashPropertiesChange
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -29
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 177
    end
  end
  object cxLabel1: TcxLabel [3]
    Left = 215
    Top = 13
    Caption = #1057#1091#1084#1084#1072' '#1074' '#1095#1077#1082#1077':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel2: TcxLabel [4]
    Left = 278
    Top = 46
    Caption = #1057#1076#1072#1095#1072':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lblSdacha: TcxLabel [5]
    Left = 382
    Top = 46
    Caption = '0.00'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.Shadow = False
    Style.TextColor = clRed
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taRightJustify
    AnchorX = 422
  end
  object lblTotalSumma: TcxLabel [6]
    Left = 382
    Top = 13
    Caption = '0.00'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.Shadow = False
    Style.TextColor = clBlue
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taRightJustify
    AnchorX = 422
  end
  object rgPaidType: TcxRadioGroup [7]
    Left = 428
    Top = 8
    Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
    ParentFont = False
    Properties.Items = <
      item
        Caption = '[ / ] '#1054#1087#1083#1072#1090#1072' '#1085#1072#1083#1080#1095#1085#1099#1084#1080
        Value = 0
      end
      item
        Caption = '[ * ] '#1054#1087#1083#1072#1090#1072' '#1082#1072#1088#1090#1086#1081
        Value = 1
      end
      item
        Caption = '[ ** ] '#1057#1084#1077#1096#1077#1085#1085#1072#1103' '#1086#1087#1083#1072#1090#1072
        Value = '2'
      end>
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 8
    OnClick = edSalerCashPropertiesChange
    Height = 105
    Width = 217
  end
  object cxGroupBox2: TcxGroupBox [8]
    Left = 8
    Top = 80
    Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1099' '#1085#1072#1083#1080#1095#1085#1099#1084#1080
    TabOrder = 3
    Height = 73
    Width = 201
    object edSalerCashAdd: TcxCurrencyEdit
      Left = 16
      Top = 19
      ParentFont = False
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = ',0.00'
      Properties.OnChange = edSalerCashPropertiesChange
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -29
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 177
    end
  end
  object cbNoPayPos: TcxCheckBox [9]
    Left = 8
    Top = 151
    Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1073#1072#1085#1082#1086#1074#1089#1082#1080#1081' '#1090#1077#1088#1084#1080#1085#1072#1083
    TabOrder = 9
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Active = False
    Left = 291
    Top = 128
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 256
    Top = 128
  end
  inherited ActionList: TActionList
    Left = 327
    Top = 127
  end
  inherited FormParams: TdsdFormParams
    Left = 368
    Top = 128
  end
end
