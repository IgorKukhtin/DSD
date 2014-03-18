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
  OnCreate = FormCreate
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
    object PanelPartner: TPanel
      Left = 2
      Top = 15
      Width = 270
      Height = 56
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
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
        object EditPartnerCode: TEdit
          Left = 6
          Top = 15
          Width = 55
          Height = 21
          TabOrder = 0
          OnExit = EditPartnerCodeExit
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
        object PanelPartnerName: TPanel
          Left = 2
          Top = 15
          Width = 199
          Height = 26
          Align = alClient
          BevelOuter = bvNone
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
    object PanelRouteUnit: TPanel
      Left = 272
      Top = 15
      Width = 271
      Height = 56
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
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
        object EditRouteUnitCode: TEdit
          Left = 6
          Top = 15
          Width = 55
          Height = 21
          TabOrder = 0
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
        object PanelRouteUnitName: TPanel
          Left = 2
          Top = 15
          Width = 200
          Height = 26
          Align = alClient
          BevelOuter = bvNone
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
  end
  object gbGrid: TGroupBox
    Left = 0
    Top = 73
    Width = 548
    Height = 629
    Align = alClient
    Caption = #1054#1087#1077#1088#1072#1094#1080#1080
    TabOrder = 1
    object DBGrid: TDBGrid
      Left = 2
      Top = 15
      Width = 544
      Height = 612
      Align = alClient
      DataSource = DataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = DBGridCellClick
      OnDrawColumnCell = DBGridDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'DisplayName'
          Title.Caption = #1054#1087#1077#1088#1072#1094#1080#1103
          Width = 501
          Visible = True
        end>
    end
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 384
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 336
    Top = 384
  end
  object spData: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ToolsWeighing_Guide'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inRootId'
        Value = 77
        ParamType = ptInput
      end>
    Left = 264
    Top = 296
  end
end
