object MainForm: TMainForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1051#1080#1082#1099' 24'
  ClientHeight = 638
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object grReport: TcxGrid
    Left = 0
    Top = 33
    Width = 521
    Height = 605
    Align = alLeft
    TabOrder = 0
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsReport_Upload
      DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
      DataController.Filter.TranslateBetween = True
      DataController.Filter.TranslateIn = True
      DataController.Filter.TranslateLike = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      object isUrgently: TcxGridDBColumn
        Caption = #1057#1088#1086#1095#1085#1086
        DataBinding.FieldName = 'isUrgently'
        HeaderAlignmentHorz = taCenter
        Width = 99
      end
      object FromName: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        Width = 176
      end
      object ToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        Width = 203
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object Panel1: TPanel
    Left = 521
    Top = 33
    Width = 504
    Height = 605
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object grChatId: TcxGrid
      Left = 0
      Top = 250
      Width = 504
      Height = 355
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object grChatIdDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = BookingsBodyDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = quantity
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsBehavior.IncSearchItem = quantity
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 20
        OptionsView.Indicator = True
        object itemId: TcxGridDBColumn
          Caption = 'GUID'
          DataBinding.FieldName = 'itemId'
          HeaderAlignmentHorz = taCenter
          Width = 277
        end
        object productId: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'productId'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 77
        end
        object quantity: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'quantity'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####'
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 65
        end
        object price: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 52
        end
      end
      object grChatIdLevel: TcxGridLevel
        GridView = grChatIdDBTableView
      end
    end
    object cxGrid1: TcxGrid
      Left = 0
      Top = 0
      Width = 504
      Height = 250
      Align = alTop
      TabOrder = 1
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableView2: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = BookingsHeadDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = status
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsBehavior.IncSearchItem = status
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 20
        OptionsView.Indicator = True
        object bookingId: TcxGridDBColumn
          Caption = 'GUID'
          DataBinding.FieldName = 'bookingId'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 262
        end
        object status: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'status'
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 117
        end
        object pharmacyId: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'pharmacyId'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 90
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableView2
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 33
    Align = alTop
    TabOrder = 2
    object btnSendTelegram: TButton
      Left = 791
      Top = 0
      Width = 130
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      TabOrder = 3
    end
    object btnExport: TButton
      Left = 727
      Top = 0
      Width = 58
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 2
      OnClick = btnExportClick
    end
    object btnSaveBookings: TButton
      Left = 615
      Top = 0
      Width = 106
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1079#1072#1082#1072#1079
      TabOrder = 1
      OnClick = btnSaveBookingsClick
    end
    object btnAll: TButton
      Left = 16
      Top = 0
      Width = 97
      Height = 25
      Caption = #1042#1089#1077' '#1076#1077#1081#1089#1090#1074#1080#1103'!'
      TabOrder = 4
      OnClick = btnAllClick
    end
    object btnLoadBookings: TButton
      Left = 480
      Top = 0
      Width = 129
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1082#1072#1079#1099
      TabOrder = 0
      OnClick = btnLoadBookingsClick
    end
    object btnAddTest: TButton
      Left = 984
      Top = 2
      Width = 25
      Height = 25
      Caption = 'T'
      TabOrder = 5
      OnClick = btnAddTestClick
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
    Left = 120
    Top = 120
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 32
    Top = 112
  end
  object BookingsBodyDS: TDataSource
    Left = 560
    Top = 368
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Movement_SendDriverVIP (:Date, 0, '#39'3'#39');')
    Params = <
      item
        DataType = ftUnknown
        Name = 'Date'
        ParamType = ptUnknown
      end>
    Properties.Strings = (
      '')
    Left = 68
    Top = 352
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Date'
        ParamType = ptUnknown
      end>
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 176
    Top = 352
  end
  object BookingsHeadDS: TDataSource
    AutoEdit = False
    Left = 568
    Top = 120
  end
  object spInsertMovement: TZStoredProc
    Connection = ZConnection1
    Params = <
      item
        DataType = ftInteger
        Name = 'ioId'
        ParamType = ptInputOutput
      end
      item
        DataType = ftInteger
        Name = 'inUnitId'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inBookingId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inOrderId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
    StoredProcName = 'gpInsertUpdate_Movement_Check_Site_Liki24'
    Left = 64
    Top = 424
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ioId'
        ParamType = ptInputOutput
      end
      item
        DataType = ftInteger
        Name = 'inUnitId'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inBookingId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inOrderId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
  end
end
