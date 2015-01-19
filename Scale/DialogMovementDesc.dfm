object DialogMovementDescForm: TDialogMovementDescForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' '#1086#1087#1077#1088#1072#1094#1080#1080
  ClientHeight = 702
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object gbPartnerAll: TGroupBox
    Left = 0
    Top = 0
    Width = 646
    Height = 55
    Align = alTop
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
    TabOrder = 0
    object PanelPartner: TPanel
      Left = 2
      Top = 15
      Width = 642
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object gbPartnerCode: TGroupBox
        Left = 0
        Top = 0
        Width = 67
        Height = 40
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
        Top = 0
        Width = 575
        Height = 40
        Align = alClient
        Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
        TabOrder = 1
        object PanelPartnerName: TPanel
          Left = 2
          Top = 15
          Width = 571
          Height = 23
          Align = alClient
          Alignment = taLeftJustify
          AutoSize = True
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
    Top = 55
    Width = 646
    Height = 647
    Align = alClient
    Caption = #1054#1087#1077#1088#1072#1094#1080#1080
    TabOrder = 1
    ExplicitTop = 140
    ExplicitHeight = 562
    object DBGrid: TDBGrid
      Left = 2
      Top = 15
      Width = 642
      Height = 630
      Align = alClient
      DataSource = DataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
          FieldName = 'guidename'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 600
          Visible = True
        end>
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 384
  end
  object DataSource: TDataSource
    DataSet = CDS
    Left = 336
    Top = 384
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ToolsWeighing_MovementDesc'
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 264
    Top = 296
  end
end
