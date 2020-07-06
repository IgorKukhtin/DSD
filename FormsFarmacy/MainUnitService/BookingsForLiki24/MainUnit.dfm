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
  object Panel1: TPanel
    Left = 529
    Top = 33
    Width = 496
    Height = 605
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object grBookingsBody: TcxGrid
      Left = 0
      Top = 378
      Width = 496
      Height = 227
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object grBookingsBodyDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = BookingsBodyDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = itemId
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
      object grBookingsBodyLevel: TcxGridLevel
        GridView = grBookingsBodyDBTableView
      end
    end
    object grBookingsHead: TcxGrid
      Left = 0
      Top = 0
      Width = 496
      Height = 378
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
            Column = bookingId
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
    TabOrder = 1
    object btnUpdateStaus: TButton
      Left = 839
      Top = 2
      Width = 130
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1090#1072#1090#1091#1089#1099
      TabOrder = 2
      OnClick = btnUpdateStausClick
    end
    object btnSaveBookings: TButton
      Left = 479
      Top = 2
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
      TabOrder = 3
      OnClick = btnAllClick
    end
    object btnLoadBookings: TButton
      Left = 344
      Top = 2
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
      TabOrder = 4
      OnClick = btnAddTestClick
    end
    object btnOpenBooking: TButton
      Left = 641
      Top = 2
      Width = 192
      Height = 25
      Caption = #1047#1072#1082#1072#1079#1099' '#1076#1083#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1090#1072#1090#1091#1089#1072
      TabOrder = 5
      OnClick = btnOpenBookingClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 529
    Height = 605
    Align = alLeft
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 2
    object grCheckBody: TcxGrid
      Left = 1
      Top = 384
      Width = 527
      Height = 220
      Align = alBottom
      TabOrder = 0
      object cxGridDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsCheckBody
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
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        object cbGoodsId: TcxGridDBColumn
          Caption = 'ID'
          DataBinding.FieldName = 'GoodsId'
          HeaderAlignmentHorz = taCenter
          Width = 68
        end
        object cbGoodsName: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          Width = 176
        end
        object cbAmount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'Amount'
          HeaderAlignmentHorz = taCenter
          Width = 68
        end
        object cbPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object cbItemId: TcxGridDBColumn
          Caption = 'Id '#1089#1090#1088#1086#1082#1080' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'ItemId'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 116
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
    object grCheckHead: TcxGrid
      Left = 1
      Top = 1
      Width = 527
      Height = 383
      Align = alClient
      TabOrder = 1
      object cxGridDBTableView3: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsCheckHead
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
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        object chBookingId: TcxGridDBColumn
          Caption = 'ID '#1079#1072#1082#1072#1079#1072
          DataBinding.FieldName = 'BookingId'
          HeaderAlignmentHorz = taCenter
          Width = 87
        end
        object chInvNumber: TcxGridDBColumn
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          Width = 85
        end
        object chBookingStatus: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'BookingStatus'
          HeaderAlignmentHorz = taCenter
          Width = 134
        end
        object chBookingStatusNew: TcxGridDBColumn
          Caption = #1053#1086#1074#1099#1081' '#1089#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'BookingStatusNew'
          HeaderAlignmentHorz = taCenter
          Width = 88
        end
        object chOperDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          Width = 96
        end
      end
      object cxGridLevel3: TcxGridLevel
        GridView = cxGridDBTableView3
      end
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
    Top = 112
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 32
    Top = 112
  end
  object BookingsBodyDS: TDataSource
    Left = 576
    Top = 480
  end
  object qryCheckHead: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Movement_Check_Booking_Liki24 ('#39'3'#39');')
    Params = <>
    Properties.Strings = (
      '')
    Left = 52
    Top = 248
  end
  object dsCheckHead: TDataSource
    DataSet = qryCheckHead
    Left = 192
    Top = 248
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
        Name = 'inBookingStatus'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
    StoredProcName = 'gpInsertUpdate_Movement_Check_Site_Liki24'
    Left = 568
    Top = 184
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
        Name = 'inBookingStatus'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
  end
  object spInsertMovementItem: TZStoredProc
    Connection = ZConnection1
    Params = <
      item
        DataType = ftInteger
        Name = 'ioId'
        ParamType = ptInputOutput
      end
      item
        DataType = ftInteger
        Name = 'inMovementId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inItemId'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'inGoodsId'
        ParamType = ptInput
      end
      item
        DataType = ftCurrency
        Name = 'inAmount'
        ParamType = ptInput
      end
      item
        DataType = ftCurrency
        Name = 'inPrice'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
    StoredProcName = 'gpInsertUpdate_MovementItem_Check_Site_Liki24'
    Left = 568
    Top = 256
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ioId'
        ParamType = ptInputOutput
      end
      item
        DataType = ftInteger
        Name = 'inMovementId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inItemId'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'inGoodsId'
        ParamType = ptInput
      end
      item
        DataType = ftCurrency
        Name = 'inAmount'
        ParamType = ptInput
      end
      item
        DataType = ftCurrency
        Name = 'inPrice'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
  end
  object dsCheckBody: TDataSource
    DataSet = qryCheckBody
    Left = 176
    Top = 480
  end
  object qryCheckBody: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_MovementItem_Check_Booking_Liki24 ('#39'3'#39');')
    Params = <>
    Properties.Strings = (
      '')
    MasterFields = 'Id'
    MasterSource = dsCheckHead
    LinkedFields = 'MovementId'
    Left = 36
    Top = 480
  end
  object spUpdateMovementStatus: TZStoredProc
    Connection = ZConnection1
    Params = <
      item
        DataType = ftInteger
        Name = 'inMovementId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inBookingStatus'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
    StoredProcName = 'gpUpdate_Movement_Check_Site_Liki24_Status'
    Left = 568
    Top = 312
    ParamData = <
      item
        DataType = ftInteger
        Name = 'inMovementId'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inBookingStatus'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inSession'
        ParamType = ptInput
      end>
  end
end
