object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1072#1087#1090#1077#1082#1072#1084
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
      DataController.DataSource = dsReport
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
    object btnExecute: TButton
      Left = 524
      Top = 2
      Width = 90
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 0
      OnClick = btnExecuteClick
    end
    object cxProgressBarUnit: TcxProgressBar
      Left = 16
      Top = 27
      TabOrder = 1
      Width = 502
    end
    object UnitName: TStaticText
      Left = 16
      Top = 8
      Width = 45
      Height = 17
      Caption = #1040#1087#1090#1077#1082#1072':'
      TabOrder = 2
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
  object qryReport: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'Select * from gpSelect_GoodsOnUnitRemains_ForTabletki(:inUnitId,' +
        #39'3'#39');')
    Params = <
      item
        DataType = ftInteger
        Name = 'inUnitId'
        ParamType = ptInput
        Value = 0
      end>
    Left = 200
    Top = 416
    ParamData = <
      item
        DataType = ftInteger
        Name = 'inUnitId'
        ParamType = ptInput
        Value = 0
      end>
  end
  object dsReport: TDataSource
    DataSet = qryReport
    Left = 256
    Top = 416
  end
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Object_Unit_ExportPriceForSite ('#39'3'#39')')
    Params = <>
    Left = 144
    Top = 416
  end
end
