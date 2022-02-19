inherited ChoiceListDiffForm: TChoiceListDiffForm
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1042#1080#1076#1072' '#1086#1090#1082#1072#1079#1072
  ClientHeight = 276
  ClientWidth = 491
  Position = poScreenCenter
  ExplicitWidth = 507
  ExplicitHeight = 315
  PixelsPerInch = 96
  TextHeight = 13
  object ListDiffGrid: TcxGrid [0]
    Left = 0
    Top = 41
    Width = 491
    Height = 194
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 398
    object ListDiffGridDBTableView: TcxGridDBTableView
      OnDblClick = ListDiffGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListDiffDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 286
      end
      object colMaxOrderAmount: TcxGridDBColumn
        Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072
        DataBinding.FieldName = 'MaxOrderAmount'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 89
      end
      object colPackages: TcxGridDBColumn
        Caption = #1052#1072#1082#1089'. '#1082#1086#1083'-'#1074#1086' '#1091#1087'.'
        DataBinding.FieldName = 'Packages'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
    end
    object ListDiffGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListDiffGridDBTableView
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 235
    Width = 491
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 398
    object bbCancel: TcxButton
      Left = 221
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 63
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 491
    Height = 41
    Align = alTop
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 2
    ExplicitWidth = 398
    object Label6: TLabel
      Left = 1
      Top = 17
      Width = 489
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = #1053#1077' '#1089#1090#1072#1074#1100#1090#1077' '#1074#1089#1077' '#1087#1086#1076#1088#1103#1076' - '#1087#1086#1076' '#1082#1083#1080#1077#1085#1090#1072'!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 280
    end
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 489
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = #1050#1086#1083#1083#1077#1075#1080', '#1080#1089#1087#1086#1083#1100#1079#1091#1081#1090#1077' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080' '#1087#1086' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1102'!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 391
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 104
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 256
    Top = 104
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 167
    Top = 103
  end
  object ListDiffDS: TDataSource
    Left = 40
    Top = 32
  end
end
