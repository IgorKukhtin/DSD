inherited DialogMovementDescForm: TDialogMovementDescForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' <'#1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
  ClientHeight = 681
  ClientWidth = 667
  Font.Charset = RUSSIAN_CHARSET
  Font.Height = -13
  Font.Name = 'Tahoma'
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  ExplicitWidth = 683
  ExplicitHeight = 716
  PixelsPerInch = 96
  TextHeight = 16
  inherited bbPanel: TPanel
    Top = 640
    Width = 667
    TabOrder = 2
    ExplicitTop = 640
    ExplicitWidth = 667
    inherited bbOk: TBitBtn
      Visible = False
    end
  end
  object InfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 667
    Height = 71
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 25
      Width = 192
      Height = 46
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 0
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 192
        Height = 46
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 0
        object ScaleLabel: TLabel
          Left = 1
          Top = 1
          Width = 190
          Height = 16
          Align = alTop
          Caption = '  '#1050#1086#1076' '#1086#1087#1077#1088#1072#1094#1080#1080' / '#8470' '#1086#1089#1085#1086#1074#1072#1085#1080#1103
          ExplicitWidth = 183
        end
        object EditBarCode: TEdit
          Left = 8
          Top = 19
          Width = 176
          Height = 24
          TabOrder = 0
          Text = 'EditBarCode'
          OnChange = EditBarCodeChange
          OnEnter = EditBarCodeEnter
          OnExit = EditBarCodeExit
        end
      end
    end
    object infoPanelPartner: TPanel
      Left = 192
      Top = 25
      Width = 475
      Height = 46
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 115
        Height = 46
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
        Width = 360
        Height = 46
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 1
        object Label3: TLabel
          Left = 1
          Top = 1
          Width = 358
          Height = 16
          Align = alTop
          Caption = '  '#1053#1072#1079#1074#1072#1085#1080#1077
          ExplicitWidth = 64
        end
        object PanelPartnerName: TPanel
          Left = 1
          Top = 17
          Width = 358
          Height = 28
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
    object MessagePanel: TPanel
      Left = 0
      Top = 0
      Width = 667
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      Caption = 
        #1058#1077#1082#1091#1097#1077#1077' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1085#1077' '#1079#1072#1082#1088#1099#1090#1086'.'#1041#1091#1076#1077#1090' '#1089#1086#1079#1076#1072#1085#1086' <'#1053#1086#1074#1086#1077'> '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077 +
        '.'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object GridPanel: TPanel
    Left = 0
    Top = 71
    Width = 667
    Height = 569
    Align = alClient
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 1
    object DBGrid: TDBGrid
      Left = 0
      Top = 0
      Width = 667
      Height = 569
      Align = alClient
      DataSource = DataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
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
      OnDblClick = DBGridDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'MovementDescName'
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
