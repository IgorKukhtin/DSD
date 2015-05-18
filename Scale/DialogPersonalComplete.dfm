inherited DialogPersonalCompleteForm: TDialogPersonalCompleteForm
  Left = 529
  Top = 238
  Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#8470
  ClientHeight = 250
  ClientWidth = 506
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  ExplicitWidth = 522
  ExplicitHeight = 285
  PixelsPerInch = 96
  TextHeight = 14
  inherited BottomPanel: TPanel
    Top = 209
    Width = 506
    TabOrder = 4
    ExplicitTop = 289
    ExplicitWidth = 506
    inherited bbOk: TBitBtn
      Left = 145
      Top = 9
      Default = False
      ExplicitLeft = 145
      ExplicitTop = 9
    end
    inherited bbCancel: TBitBtn
      Left = 229
      Top = 9
      ExplicitLeft = 229
      ExplicitTop = 9
    end
  end
  object infoPanelMember1: TPanel
    Left = 0
    Top = 0
    Width = 506
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object PanelPosition1: TPanel
      Left = 320
      Top = 0
      Width = 186
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 280
      ExplicitWidth = 226
      object LabelPositionName1: TLabel
        Left = 0
        Top = 0
        Width = 186
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
        ExplicitWidth = 79
      end
      object gbPositionName1: TGroupBox
        Left = 0
        Top = 13
        Width = 186
        Height = 39
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 3
        ExplicitTop = 7
        ExplicitWidth = 226
        object PanelPositionName1: TPanel
          Left = 2
          Top = 16
          Width = 182
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
          ExplicitWidth = 177
        end
      end
    end
    object PanelMember1: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelMemberName1: TLabel
        Left = 0
        Top = 0
        Width = 320
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
        ExplicitWidth = 108
      end
      object gbMemberCode1: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode1: TcxCurrencyEdit
          Left = 5
          Top = 15
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          TabOrder = 0
          Width = 55
        end
      end
      object gbMemberName1: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        ExplicitLeft = 66
        ExplicitTop = 7
        ExplicitWidth = 213
        object EditPersonalName1: TcxButtonEdit
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 0
          Text = 'EditPersonalName1'
          Width = 245
        end
      end
    end
  end
  object infoPanelMember2: TPanel
    Left = 0
    Top = 52
    Width = 506
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object PanelPosition2: TPanel
      Left = 320
      Top = 0
      Width = 186
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 280
      ExplicitWidth = 226
      object LabelPositionName2: TLabel
        Left = 0
        Top = 0
        Width = 186
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
        ExplicitWidth = 79
      end
      object gbPositionName2: TGroupBox
        Left = 0
        Top = 13
        Width = 186
        Height = 39
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 45
        ExplicitWidth = 181
        object PanelPositionName2: TPanel
          Left = 2
          Top = 16
          Width = 182
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
          ExplicitWidth = 177
        end
      end
    end
    object PanelMember2: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelMemberName2: TLabel
        Left = 0
        Top = 0
        Width = 320
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
        ExplicitWidth = 108
      end
      object gbMemberCode2: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode2: TcxCurrencyEdit
          Left = 5
          Top = 15
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          TabOrder = 0
          Width = 55
        end
      end
      object gbMemberName2: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        ExplicitWidth = 213
        object EditPersonalName2: TcxButtonEdit
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 0
          Text = 'EditPersonalName2'
          Width = 245
        end
      end
    end
  end
  object infoPanelMember3: TPanel
    Left = 0
    Top = 104
    Width = 506
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object PanelPosition3: TPanel
      Left = 320
      Top = 0
      Width = 186
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 280
      ExplicitWidth = 226
      object LabelPositionName3: TLabel
        Left = 0
        Top = 0
        Width = 186
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
        ExplicitWidth = 79
      end
      object gbPositionName3: TGroupBox
        Left = 0
        Top = 13
        Width = 186
        Height = 39
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 45
        ExplicitWidth = 181
        object PanelPositionName3: TPanel
          Left = 2
          Top = 16
          Width = 182
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
          ExplicitWidth = 177
        end
      end
    end
    object PanelMember3: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelMemberName3: TLabel
        Left = 0
        Top = 0
        Width = 320
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
        ExplicitWidth = 108
      end
      object gbMemberCode3: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode3: TcxCurrencyEdit
          Left = 5
          Top = 15
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          TabOrder = 0
          Width = 55
        end
      end
      object gbMemberName3: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        ExplicitWidth = 213
        object EditPersonalName3: TcxButtonEdit
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 0
          Text = 'EditPersonalName3'
          Width = 245
        end
      end
    end
  end
  object infoPanelMember4: TPanel
    Left = 0
    Top = 156
    Width = 506
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object PanelPosition4: TPanel
      Left = 320
      Top = 0
      Width = 186
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 280
      ExplicitWidth = 226
      object LabelPositionName4: TLabel
        Left = 0
        Top = 0
        Width = 186
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
        ExplicitWidth = 79
      end
      object gbPositionName4: TGroupBox
        Left = 0
        Top = 13
        Width = 186
        Height = 39
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 45
        ExplicitWidth = 181
        object PanelPositionName4: TPanel
          Left = 2
          Top = 16
          Width = 182
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
          ExplicitWidth = 177
        end
      end
    end
    object PanelMember4: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 52
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelMemberName4: TLabel
        Left = 0
        Top = 0
        Width = 320
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
        ExplicitWidth = 108
      end
      object gbMemberCode4: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 39
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPersonalCode4: TcxCurrencyEdit
          Left = 5
          Top = 15
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          TabOrder = 0
          Width = 55
        end
      end
      object gbMemberName4: TGroupBox
        Left = 67
        Top = 13
        Width = 253
        Height = 39
        Align = alClient
        Caption = #1060#1048#1054
        TabOrder = 1
        ExplicitWidth = 213
        object EditPersonalName4: TcxButtonEdit
          Left = 5
          Top = 14
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 0
          Text = 'EditPersonalName4'
          Width = 245
        end
      end
    end
  end
end
