inherited DialogPersonalCompleteForm: TDialogPersonalCompleteForm
  Left = 529
  Top = 238
  Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#8470
  ClientHeight = 516
  ClientWidth = 530
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  ExplicitWidth = 546
  ExplicitHeight = 555
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 475
    Width = 530
    TabOrder = 4
    ExplicitTop = 475
    ExplicitWidth = 530
    inherited bbOk: TBitBtn
      Default = False
    end
  end
  object infoPanelPersona1: TPanel
    Left = 0
    Top = 0
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object PanelPosition1: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPositionName1: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPositionName1: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName1: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelPersonal1: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelPersonalName1: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode1: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode1: TcxCurrencyEdit
          Tag = 1
          Left = 5
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName1: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName1: TcxButtonEdit
          Tag = 1
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName1'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona2: TPanel
    Left = 0
    Top = 52
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object PanelPosition2: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPositionName2: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPositionName2: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName2: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelPersonal2: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelPersonalName2: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode2: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode2: TcxCurrencyEdit
          Tag = 2
          Left = 5
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName2: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName2: TcxButtonEdit
          Tag = 2
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName2'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona3: TPanel
    Left = 0
    Top = 104
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object PanelPosition3: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPositionName3: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPositionName3: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName3: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelPersonal3: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelPersonalName3: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode3: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode3: TcxCurrencyEdit
          Tag = 3
          Left = 5
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName3: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName3: TcxButtonEdit
          Tag = 3
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName3'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona4: TPanel
    Left = 0
    Top = 156
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object PanelPosition4: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPositionName4: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPositionName4: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName4: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName4'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelPersonal4: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabePersonalName4: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode4: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode4: TcxCurrencyEdit
          Tag = 4
          Left = 6
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName4: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName4: TcxButtonEdit
          Tag = 4
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName4'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona5: TPanel
    Left = 0
    Top = 208
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object PanelPosition5: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPositionName5: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPositionName5: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName5: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName5'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelPersonal5: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabePersonalName5: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode5: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode5: TcxCurrencyEdit
          Tag = 5
          Left = 6
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName5: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName5: TcxButtonEdit
          Tag = 5
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName5'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersonaStick1: TPanel
    Left = 0
    Top = 423
    Width = 530
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object PanelPositionStick1: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPositionStickName1: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPositionStickName1: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionStickName1: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionStickName1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelPersonalStick1: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelPersonalStickName1: TLabel
        Left = 0
        Top = 0
        Width = 92
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'C'#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalStickCode1: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalStickCode1: TcxCurrencyEdit
          Tag = 11
          Left = 6
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalStickName1: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalStickName1: TcxButtonEdit
          Tag = 11
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalStickName1'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona8: TPanel
    Left = 0
    Top = 364
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    object Panel2: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName8: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName8'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode8: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode8: TcxCurrencyEdit
          Tag = 8
          Left = 6
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName8: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName8: TcxButtonEdit
          Tag = 8
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName8'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona7: TPanel
    Left = 0
    Top = 312
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    object Panel6: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName7: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName7'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode7: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode7: TcxCurrencyEdit
          Tag = 7
          Left = 6
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName7: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName7: TcxButtonEdit
          Tag = 7
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName7'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
  object infoPanelPersona6: TPanel
    Left = 0
    Top = 260
    Width = 530
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 9
    object Panel10: TPanel
      Left = 320
      Top = 0
      Width = 210
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label5: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' 6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 13
        Width = 210
        Height = 39
        Align = alClient
        TabOrder = 0
        object PanelPositionName6: TPanel
          Left = 2
          Top = 16
          Width = 206
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPositionName6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object Panel12: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 108
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbPersonalCode6: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode6: TcxCurrencyEdit
          Tag = 6
          Left = 6
          Top = 14
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditPersonalCode1PropertiesChange
          TabOrder = 0
          OnExit = EditPersonalCode1Exit
          OnKeyDown = EditPersonalCode1KeyDown
          Width = 55
        end
      end
      object gbPersonalName6: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        object EditPersonalName6: TcxButtonEdit
          Tag = 6
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPersonalName1PropertiesButtonClick
          TabOrder = 0
          Text = 'EditPersonalName6'
          OnKeyDown = EditPersonalName1KeyDown
          Width = 245
        end
      end
    end
  end
end
