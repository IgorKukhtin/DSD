object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1080' '#1079#1072#1075#1088#1091#1079#1082#1072' '#1076#1086#1085#1085#1099#1093' '#1076#1083#1103' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074
  ClientHeight = 470
  ClientWidth = 622
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
  object grReport: TcxGrid
    Left = 0
    Top = 53
    Width = 622
    Height = 417
    Align = alClient
    TabOrder = 0
    object grtvReport: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsExportPharmacists
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.Header = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      object colRowData: TcxGridDBColumn
        Caption = #1044#1072#1085#1085#1099#1077
        DataBinding.FieldName = 'RowData'
      end
    end
    object grlReport: TcxGridLevel
      GridView = grtvReport
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 622
    Height = 53
    Align = alTop
    TabOrder = 1
    object btnExportUser: TButton
      Left = 335
      Top = 15
      Width = 114
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1089#1087#1080#1089#1082#1072
      TabOrder = 0
      OnClick = btnExportUserClick
    end
    object btnLoadResult: TButton
      Left = 468
      Top = 15
      Width = 133
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074
      ModalResult = 1
      TabOrder = 1
      OnClick = btnLoadResultClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 40
    Top = 112
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Port = 5432
    Protocol = 'postgresql-9'
    Left = 120
    Top = 112
  end
  object dsExportPharmacists: TDataSource
    DataSet = qryExportPharmacists
    Left = 192
    Top = 416
  end
  object qryExportPharmacists: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Object_ExportPharmacists('#39'3'#39')')
    Params = <>
    Left = 80
    Top = 416
  end
  object qrygpInsertUpdateLoadTestingXML: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'SELECT * FROM gpInsertUpdate_Load_TestingXML(:OperDate, :XMLS, '#39 +
        '3'#39')')
    Params = <
      item
        DataType = ftUnknown
        Name = 'OperDate'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'XMLS'
        ParamType = ptUnknown
      end>
    Left = 328
    Top = 416
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OperDate'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'XMLS'
        ParamType = ptUnknown
      end>
  end
end
