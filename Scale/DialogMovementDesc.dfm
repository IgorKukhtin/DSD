object DialogMovementDescForm: TDialogMovementDescForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' <'#1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
  ClientHeight = 702
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 16
  object InfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 63
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label4: TLabel
      Left = 0
      Top = 0
      Width = 651
      Height = 16
      Align = alTop
      Alignment = taCenter
      ExplicitWidth = 4
    end
    object Panel1: TPanel
      Left = 0
      Top = 16
      Width = 173
      Height = 47
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 0
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 178
        Height = 47
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 0
        object ScaleLabel: TLabel
          Left = 1
          Top = 1
          Width = 176
          Height = 16
          Align = alTop
          Caption = '  '#1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080' / '#1050#1086#1076' '#1086#1087#1077#1088#1072#1094#1080#1080
          ExplicitWidth = 183
        end
        object EdiBarCode: TEdit
          Left = 7
          Top = 19
          Width = 160
          Height = 24
          TabOrder = 0
          Text = 'EdiBarCode'
          OnChange = EdiBarCodeChange
          OnEnter = EdiBarCodeEnter
          OnExit = EdiBarCodeExit
        end
      end
    end
    object Panel2: TPanel
      Left = 173
      Top = 16
      Width = 478
      Height = 47
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 115
        Height = 47
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 0
        object Label2: TLabel
          Left = 1
          Top = 1
          Width = 113
          Height = 16
          Align = alTop
          Caption = '  '#1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
          ExplicitWidth = 105
        end
        object EditPartnerCode: TcxButtonEdit
          Left = 6
          Top = 19
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          Properties.OnButtonClick = EditPartnerCodePropertiesButtonClick
          TabOrder = 0
          Text = 'EditPartnerCode'
          OnEnter = EditPartnerCodeEnter
          OnExit = EditPartnerCodeExit
          OnKeyDown = EditPartnerCodeKeyDown
          Width = 102
        end
      end
      object Panel4: TPanel
        Left = 115
        Top = 0
        Width = 363
        Height = 47
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 1
        object Label3: TLabel
          Left = 1
          Top = 1
          Width = 361
          Height = 16
          Align = alTop
          Caption = '  '#1053#1072#1079#1074#1072#1085#1080#1077
          ExplicitWidth = 64
        end
        object PanelPartnerName: TPanel
          Left = 1
          Top = 17
          Width = 361
          Height = 29
          Align = alClient
          Alignment = taLeftJustify
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'PanelPartnerName'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 63
    Width = 651
    Height = 639
    Align = alClient
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 1
    object DBGrid: TDBGrid
      Left = 0
      Top = 0
      Width = 651
      Height = 639
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
          FieldName = 'MovementDescName'
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
