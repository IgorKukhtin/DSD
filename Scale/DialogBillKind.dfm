object DialogBillKindForm: TDialogBillKindForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' '#1086#1087#1077#1088#1072#1094#1080#1080
  ClientHeight = 702
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbPartnerAll: TGroupBox
    Left = 0
    Top = 0
    Width = 548
    Height = 73
    Align = alTop
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
    TabOrder = 0
    ExplicitWidth = 882
    object PanelPartner: TPanel
      Left = 2
      Top = 15
      Width = 270
      Height = 56
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 48
      object LabelPartner: TLabel
        Left = 0
        Top = 0
        Width = 270
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 71
      end
      object gbPartnerCode: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 43
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        ExplicitHeight = 185
        object EditPartnerCode: TEdit
          Left = 6
          Top = 15
          Width = 55
          Height = 21
          TabOrder = 0
          Text = 'EditPartnerCode'
        end
      end
      object gbPartnerName: TGroupBox
        Left = 67
        Top = 13
        Width = 203
        Height = 43
        Align = alClient
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        TabOrder = 1
        ExplicitHeight = 185
        object PanelPartnerName: TPanel
          Left = 2
          Top = 15
          Width = 199
          Height = 26
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelPartnerName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitHeight = 168
        end
      end
    end
    object PanelRouteUnit: TPanel
      Left = 272
      Top = 15
      Width = 271
      Height = 56
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 270
      ExplicitTop = 0
      ExplicitHeight = 48
      object LabelRouteUnit: TLabel
        Left = 0
        Top = 0
        Width = 271
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1047#1072#1103#1074#1082#1072')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 108
      end
      object gbRouteUnitCode: TGroupBox
        Left = 0
        Top = 13
        Width = 67
        Height = 43
        Align = alLeft
        Caption = #1050#1086#1076
        TabOrder = 0
        ExplicitHeight = 185
        object EditRouteUnitCode: TEdit
          Left = 6
          Top = 15
          Width = 55
          Height = 21
          TabOrder = 0
          Text = 'EditRouteUnitCode'
        end
      end
      object gbRouteUnitName: TGroupBox
        Left = 67
        Top = 13
        Width = 204
        Height = 43
        Align = alClient
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        TabOrder = 1
        ExplicitHeight = 185
        object PanelRouteUnitName: TPanel
          Left = 2
          Top = 15
          Width = 200
          Height = 26
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelRouteUnitName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitHeight = 168
        end
      end
    end
  end
end
