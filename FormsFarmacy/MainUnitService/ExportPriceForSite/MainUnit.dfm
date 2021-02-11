object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1072#1087#1090#1077#1082#1072#1084
  ClientHeight = 470
  ClientWidth = 620
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
    Top = 253
    Width = 620
    Height = 217
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 622
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
    Width = 620
    Height = 81
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 622
    object btnExecute: TButton
      Left = 16
      Top = 1
      Width = 90
      Height = 25
      Caption = #1042#1089#1077
      TabOrder = 0
      OnClick = btnExecuteClick
    end
    object cxProgressBarUnit: TcxProgressBar
      Left = 16
      Top = 51
      TabOrder = 1
      Width = 585
    end
    object UnitName: TStaticText
      Left = 16
      Top = 32
      Width = 45
      Height = 17
      Caption = #1040#1087#1090#1077#1082#1072':'
      TabOrder = 2
    end
    object btnForm: TButton
      Left = 319
      Top = 1
      Width = 90
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 3
      OnClick = btnFormClick
    end
    object btnExport: TButton
      Left = 415
      Top = 1
      Width = 90
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090' '
      TabOrder = 4
      OnClick = btnExportClick
    end
    object btnSendFTP: TButton
      Left = 511
      Top = 1
      Width = 90
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      TabOrder = 5
      OnClick = btnSendFTPClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 81
    Width = 620
    Height = 172
    Align = alTop
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitWidth = 622
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsUnit
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 53
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 336
      end
      object RegNumber: TcxGridDBColumn
        Caption = '"'#1052#1086#1103' '#1072#1087#1090#1077#1082#1072'"'
        DataBinding.FieldName = 'RegNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'"'
        Options.Editing = False
        Width = 84
      end
      object isReport2: TcxGridDBColumn
        Caption = #1058#1072#1073#1083#1077#1090#1082#1080
        DataBinding.FieldName = 'SerialNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 'SerialNumber'
        Options.Editing = False
        Width = 79
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
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
    Left = 200
    Top = 352
  end
  object qryRest_Group: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (0, '#39 +
        '3'#39')')
    Params = <>
    Left = 200
    Top = 296
  end
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 264
    Top = 352
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    Host = 'ftp:\\ooobadm.dp.ua'
    Passive = True
    Password = 'FsT3469Dv'
    Username = 'K_shapiro'
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    ServerHOST = 'ftp:\\ooobadm.dp.ua'
    Left = 240
    Top = 112
  end
end
