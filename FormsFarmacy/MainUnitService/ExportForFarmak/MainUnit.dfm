object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1060#1072#1088#1084#1072#1082' '
  ClientHeight = 524
  ClientWidth = 909
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grReportUnit: TcxGrid
    Left = 0
    Top = 235
    Width = 909
    Height = 289
    Align = alClient
    TabOrder = 1
    object grtvUnit: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsReport_Upload
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.CellTextMaxLineCount = 100
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
    end
    object grReportUnitLevel1: TcxGridLevel
      GridView = grtvUnit
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 909
    Height = 31
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 104
      Top = 8
      Width = 68
      Height = 13
      Caption = #1054#1090#1087#1088'. '#1089' '#1076#1072#1090#1099
    end
    object btnSendEmail: TButton
      Left = 803
      Top = 0
      Width = 106
      Height = 25
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' EMAIL'
      TabOrder = 5
      OnClick = btnSendEmailClick
    end
    object btnExecuteWhReceipt: TButton
      Left = 614
      Top = 0
      Width = 70
      Height = 25
      Caption = #1055#1088#1080#1093#1086#1076#1099
      TabOrder = 4
      OnClick = btnExecuteWhReceiptClick
    end
    object btnExecuteBalance: TButton
      Left = 538
      Top = 0
      Width = 70
      Height = 25
      Caption = #1054#1089#1090#1072#1090#1082#1080
      TabOrder = 3
      OnClick = btnExecuteBalanceClick
    end
    object btnAll: TButton
      Left = 6
      Top = 0
      Width = 75
      Height = 25
      Caption = #1042#1089#1077' !'
      TabOrder = 6
      OnClick = btnAllClick
    end
    object btnExecuteGoods: TButton
      Left = 462
      Top = 0
      Width = 70
      Height = 25
      Caption = #1058#1086#1074#1072#1088#1099
      TabOrder = 2
      OnClick = btnExecuteGoodsClick
    end
    object btnExecuteUnit: TButton
      Left = 386
      Top = 0
      Width = 70
      Height = 25
      Caption = #1040#1087#1090#1077#1082#1080
      TabOrder = 1
      OnClick = btnExecuteUnitClick
    end
    object btnExecuteDespatch: TButton
      Left = 690
      Top = 0
      Width = 70
      Height = 25
      Caption = #1056#1072#1089#1093#1086#1076#1099
      TabOrder = 7
      OnClick = btnExecuteDespatchClick
    end
    object DateStart: TcxDateEdit
      Left = 184
      Top = 4
      EditValue = 42339d
      Properties.ShowTime = False
      TabOrder = 8
      Width = 85
    end
    object btnExecuteClient: TButton
      Left = 310
      Top = 0
      Width = 70
      Height = 25
      Caption = #1050#1083#1080#1077#1085#1090#1099
      TabOrder = 0
      OnClick = btnExecuteClientClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 909
    Height = 204
    Align = alTop
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsUnit
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = UnitName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object UnitId: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacyId'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
      object Phones: TcxGridDBColumn
        DataBinding.FieldName = 'CompanyId'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object UnitName: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacyName'
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 168
      end
      object Address: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacyAddress'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 251
      end
      object PharmacistId: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacistId'
        Options.Editing = False
      end
      object PharmacistName: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacistName'
        Options.Editing = False
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 5432
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 136
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 136
  end
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      ' SELECT * FROM gpSelect_Farmak_CRMPharmacy('#39'3'#39')')
    Params = <>
    Left = 144
    Top = 384
  end
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 224
    Top = 384
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      '')
    Params = <>
    Left = 556
    Top = 336
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 680
    Top = 336
  end
  object qryMailParam: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT'
      '    zc_Mail_From() AS Mail_From,'
      '    zc_Mail_Host() AS Mail_Host,'
      '    zc_Mail_Port() AS Mail_Port,'
      '    zc_Mail_User() AS Mail_User,'
      '    zc_Mail_Password() AS Mail_Password')
    Params = <>
    Left = 144
    Top = 328
  end
end
