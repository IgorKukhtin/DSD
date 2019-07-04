inherited DialogGoodsSeparateForm: TDialogGoodsSeparateForm
  Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1055#1040#1056#1058#1048#1048' '#1076#1083#1103' <'#1056#1040#1057#1061#1054#1044'>'
  ClientHeight = 294
  ClientWidth = 468
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 484
  ExplicitHeight = 329
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 253
    Width = 468
    ExplicitTop = 253
    ExplicitWidth = 468
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
    Width = 468
    Height = 253
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object NullPanel: TPanel
      Left = 0
      Top = 236
      Width = 468
      Height = 40
      Align = alTop
      TabOrder = 0
      ExplicitTop = 206
      object cbNull: TCheckBox
        Left = 20
        Top = 12
        Width = 180
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
      object NullEdit: TcxTextEdit
        Left = 200
        Top = 9
        Properties.ReadOnly = True
        TabOrder = 1
        Text = 'NullEdit'
        Width = 250
      end
    end
    object infoMsgPanel: TPanel
      Left = 0
      Top = 0
      Width = 468
      Height = 76
      Align = alTop
      TabOrder = 1
      object PartionLabel: TcxLabel
        Left = 1
        Top = 55
        Align = alClient
        Caption = #1048#1090#1086#1075#1086' '#1087#1088#1080#1093#1086#1076' :  321 '#1082#1075'.  / '#1056#1072#1089#1093#1086#1076' : 123 '#1082#1075'.'
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
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        ExplicitTop = 19
        ExplicitHeight = 26
        AnchorX = 234
        AnchorY = 65
      end
      object GoodsLabel: TcxLabel
        Left = 1
        Top = 37
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
        ExplicitTop = 1
        AnchorY = 46
      end
      object UnitLabel: TcxLabel
        Left = 1
        Top = 1
        Align = alTop
        AutoSize = False
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' : '
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
        Height = 36
        Width = 466
        AnchorY = 19
      end
      object cbUnit1_sep: TCheckBox
        Left = 281
        Top = 2
        Width = 180
        Height = 17
        Caption = #1052#1054' -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = cbUnit1_sepClick
      end
      object cbUnit2_sep: TCheckBox
        Left = 281
        Top = 19
        Width = 180
        Height = 17
        Caption = #1052#1054' -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = cbUnit2_sepClick
      end
    end
    object OBPanel: TPanel
      Left = 0
      Top = 116
      Width = 468
      Height = 40
      Align = alTop
      TabOrder = 2
      ExplicitTop = 86
      object cbOB: TCheckBox
        Left = 20
        Top = 12
        Width = 180
        Height = 17
        Caption = #1054#1041' - '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbOBClick
      end
      object OBEdit: TcxTextEdit
        Left = 200
        Top = 9
        Properties.ReadOnly = True
        TabOrder = 1
        Text = 'OBEdit'
        Width = 250
      end
    end
    object MOPanel: TPanel
      Left = 0
      Top = 76
      Width = 468
      Height = 40
      Align = alTop
      TabOrder = 3
      ExplicitTop = 46
      object cbMO: TCheckBox
        Left = 20
        Top = 12
        Width = 180
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
      object MOEdit: TcxTextEdit
        Left = 200
        Top = 9
        Properties.ReadOnly = True
        TabOrder = 1
        Text = 'MOEdit'
        Width = 250
      end
    end
    object PRPanel: TPanel
      Left = 0
      Top = 156
      Width = 468
      Height = 40
      Align = alTop
      TabOrder = 4
      ExplicitTop = 126
      object cbPR: TCheckBox
        Left = 20
        Top = 12
        Width = 180
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
      object PREdit: TcxTextEdit
        Left = 200
        Top = 9
        Properties.ReadOnly = True
        TabOrder = 1
        Text = 'MOEdit'
        Width = 250
      end
    end
    object PPanel: TPanel
      Left = 0
      Top = 196
      Width = 468
      Height = 40
      Align = alTop
      TabOrder = 5
      ExplicitTop = 166
      object cbP: TCheckBox
        Left = 20
        Top = 12
        Width = 180
        Height = 17
        Caption = #1055' -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbPClick
      end
      object PEdit: TcxTextEdit
        Left = 200
        Top = 9
        Properties.ReadOnly = True
        TabOrder = 1
        Text = 'PEdit'
        Width = 250
      end
    end
  end
end
