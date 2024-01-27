object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 435
  ClientWidth = 636
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 636
    Height = 435
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 628
        Height = 407
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource1
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = clGoodsName
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellEndEllipsis = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 67
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 292
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            Properties.MinValue = 0.010000000000000000
            HeaderAlignmentHorz = taCenter
            Width = 76
          end
          object clDateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1080#1079#1084'. '#1094#1077#1085#1099
            DataBinding.FieldName = 'DateChange'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 76
          end
          object clMCSValue: TcxGridDBColumn
            AlternateCaption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Width = 74
          end
          object clMCSDateChange: TcxGridDBColumn
            AlternateCaption = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1085#1077#1089#1085#1080#1078#1072#1077#1084#1086#1075#1086' '#1090#1086#1074#1072#1088#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1080#1079#1084'. '#1053#1058#1047
            DataBinding.FieldName = 'MCSDateChange'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1085#1077#1089#1085#1080#1078#1072#1077#1084#1086#1075#1086' '#1090#1086#1074#1072#1088#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
            Options.Editing = False
            Width = 112
          end
          object clisErased: TcxGridDBColumn
            AlternateCaption = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Caption = #1061
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 27
          end
          object clMCSIsClose: TcxGridDBColumn
            Caption = #1059#1073#1080#1090#1100' '#1082#1086#1076
            DataBinding.FieldName = 'MCSIsClose'
            HeaderAlignmentHorz = taCenter
            Width = 62
          end
          object clMCSNotRecalc: TcxGridDBColumn
            Caption = #1057#1087#1077#1094#1082#1086#1085#1090#1088#1086#1083#1100' '#1082#1086#1076#1072
            DataBinding.FieldName = 'MCSNotRecalc'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1053#1077' '#1087#1077#1088#1077#1089#1095#1080#1090#1099#1074#1072#1090#1100' '#1053#1058#1047
            Width = 80
          end
          object colRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            Options.Editing = False
            Width = 71
          end
          object colFix: TcxGridDBColumn
            AlternateCaption = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072
            Caption = #1060#1080#1082#1089'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'Fix'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072
            Width = 73
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 628
        Height = 407
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsJuridicalPrice
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellEndEllipsis = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076#1058#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 67
          end
          object colName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 292
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            Width = 76
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    HostName = '91.210.37.210'
    Port = 5432
    Database = 'farmacy'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    LibraryLocation = 'C:\POLAK\test\SavePriceToXls\Win32\Debug\libpq.dll'
    Left = 136
    Top = 48
  end
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Object_Unit_SaveToXls ('#39'3'#39')')
    Params = <>
    Left = 216
    Top = 48
  end
  object DataSource1: TDataSource
    DataSet = qryPrice
    Left = 288
    Top = 40
  end
  object qryPrice: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'Select * from gpSelect_Object_Price_SaveToXls(:UnitId, 0, False,' +
        'False,'#39'3'#39');')
    Params = <
      item
        DataType = ftInteger
        Name = 'UnitId'
        ParamType = ptInput
        Value = 0
      end>
    Left = 216
    Top = 104
    ParamData = <
      item
        DataType = ftInteger
        Name = 'UnitId'
        ParamType = ptInput
        Value = 0
      end>
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 128
  end
  object qryJuridical: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Object_Juridical_ForUnloadPrice ('#39'3'#39');')
    Params = <>
    Left = 440
    Top = 56
  end
  object dsJuridicalPrice: TDataSource
    DataSet = qryJuridicalPrice
    Left = 512
    Top = 48
  end
  object qryJuridicalPrice: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'Select * from gpSelect_LastPriceOut(:JuridicalId,'#39'3'#39');')
    Params = <
      item
        DataType = ftInteger
        Name = 'JuridicalId'
        ParamType = ptInput
      end>
    Left = 440
    Top = 112
    ParamData = <
      item
        DataType = ftInteger
        Name = 'JuridicalId'
        ParamType = ptInput
      end>
  end
end
