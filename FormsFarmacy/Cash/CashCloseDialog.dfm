inherited CashCloseDialogForm: TCashCloseDialogForm
  ActiveControl = edSalerCash
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1080#1072#1083#1086#1075' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1095#1077#1082#1072
  ClientHeight = 128
  ClientWidth = 655
  GlassFrame.Bottom = 60
  Position = poDesktopCenter
  OnKeyDown = ParentFormKeyDown
  ExplicitWidth = 661
  ExplicitHeight = 153
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 655
    Height = 87
    Align = alClient
    TabOrder = 0
    ExplicitTop = -1
    ExplicitWidth = 657
    ExplicitHeight = 99
    object cxGroupBox1: TcxGroupBox
      Left = 8
      Top = 8
      Caption = #1057#1091#1084#1084#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      TabOrder = 0
      Height = 73
      Width = 201
      object edSalerCash: TcxCurrencyEdit
        Left = 16
        Top = 19
        ParentFont = False
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
    object cxLabel1: TcxLabel
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
    object cxLabel2: TcxLabel
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
    object lblTotalSumma: TcxLabel
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
    object lblSdacha: TcxLabel
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
    object rgPaidType: TcxRadioGroup
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
        end>
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 5
      OnClick = edSalerCashPropertiesChange
      Height = 73
      Width = 217
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 87
    Width = 655
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 104
    ExplicitWidth = 376
    object btnCancel: TcxButton
      Left = 540
      Top = 7
      Width = 105
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072' (Esc)'
      ModalResult = 2
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 0
    end
    object btnOk: TcxButton
      Left = 415
      Top = 7
      Width = 105
      Height = 25
      Caption = 'Ok (Enter)'
      Default = True
      ModalResult = 1
      OptionsImage.ImageIndex = 7
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 80
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 80
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 79
  end
end
