inherited DialogGoodsSeparateForm: TDialogGoodsSeparateForm
  Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1055#1040#1056#1058#1048#1048' '#1076#1083#1103' <'#1056#1040#1057#1061#1054#1044'>'
  ClientHeight = 280
  ClientWidth = 357
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 373
  ExplicitHeight = 315
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 239
    Width = 357
    ExplicitTop = 175
    ExplicitWidth = 374
    inherited bbOk: TBitBtn
      Left = 51
      Top = 9
      Default = False
      ExplicitLeft = 51
      ExplicitTop = 9
    end
    inherited bbCancel: TBitBtn
      Left = 135
      Top = 9
      ExplicitLeft = 135
      ExplicitTop = 9
    end
  end
  object PanelValue: TPanel
    Left = 0
    Top = 0
    Width = 357
    Height = 239
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object NullPanel: TPanel
      Left = 0
      Top = 46
      Width = 357
      Height = 40
      Align = alTop
      TabOrder = 0
      object cbNull: TCheckBox
        Left = 70
        Top = 12
        Width = 55
        Height = 17
        Caption = #1087#1091#1089#1090#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbNullClick
      end
      object NullEdit: TcxCurrencyEdit
        Left = 144
        Top = 9
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 1
        Width = 121
      end
    end
    object infoMsgPanel: TPanel
      Left = 0
      Top = 0
      Width = 357
      Height = 46
      Align = alTop
      TabOrder = 1
      object PartionLabel: TcxLabel
        Left = 1
        Top = 19
        Align = alClient
        Caption = #1055#1072#1088#1090#1080#1103' :'
        ParentColor = False
        ParentFont = False
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebsSingle
        Style.Color = clBtnFace
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Arial Narrow'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        ExplicitTop = 22
        ExplicitHeight = 23
        AnchorY = 32
      end
      object GoodsLabel: TcxLabel
        Left = 1
        Top = 1
        Align = alTop
        Caption = #1058#1086#1074#1072#1088' : '
        ParentFont = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.HotTrack = False
        Style.Shadow = False
        Style.IsFontAssigned = True
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        AnchorY = 10
      end
    end
    object OBPanel: TPanel
      Left = 0
      Top = 126
      Width = 357
      Height = 40
      Align = alTop
      TabOrder = 2
      ExplicitTop = 128
      object cbOB: TCheckBox
        Left = 70
        Top = 12
        Width = 55
        Height = 17
        Caption = #1054#1041' -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbOBClick
      end
      object OBEdit: TcxCurrencyEdit
        Left = 144
        Top = 9
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 1
        Width = 121
      end
    end
    object MOPanel: TPanel
      Left = 0
      Top = 86
      Width = 357
      Height = 40
      Align = alTop
      TabOrder = 3
      ExplicitTop = 87
      object cbMO: TCheckBox
        Left = 70
        Top = 12
        Width = 55
        Height = 17
        Caption = #1052#1054' -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbMOClick
      end
      object MOEdit: TcxCurrencyEdit
        Left = 144
        Top = 9
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 1
        Width = 121
      end
    end
    object PRPanel: TPanel
      Left = 0
      Top = 166
      Width = 357
      Height = 40
      Align = alTop
      TabOrder = 4
      ExplicitTop = 169
      object cbPR: TCheckBox
        Left = 70
        Top = 12
        Width = 55
        Height = 17
        Caption = #1055#1056' -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbPRClick
      end
      object PREdit: TcxCurrencyEdit
        Left = 144
        Top = 9
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 1
        Width = 121
      end
    end
  end
end
