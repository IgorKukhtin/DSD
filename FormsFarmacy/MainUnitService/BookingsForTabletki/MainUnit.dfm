object MainForm: TMainForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1079#1072#1082#1072#1079#1086#1074'  tabletki.ua'
  ClientHeight = 638
  ClientWidth = 1025
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 33
    Align = alTop
    TabOrder = 0
    object btnSaveBookings: TButton
      Left = 479
      Top = 2
      Width = 106
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1079#1072#1082#1072#1079
      TabOrder = 1
    end
    object btnAll: TButton
      Left = 16
      Top = 2
      Width = 97
      Height = 25
      Caption = #1042#1089#1077' '#1076#1077#1081#1089#1090#1074#1080#1103'!'
      TabOrder = 2
    end
    object btnLoadBookings: TButton
      Left = 344
      Top = 2
      Width = 129
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1082#1072#1079#1099
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 1025
    Height = 605
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 1
    object cxGrid1: TcxGrid
      Left = 1
      Top = 1
      Width = 1023
      Height = 603
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView4: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsUnit
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
        object UnitId: TcxGridDBColumn
          Caption = 'ID'
          DataBinding.FieldName = 'Id'
          HeaderAlignmentHorz = taCenter
          Width = 67
        end
        object UnitName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'Name'
          HeaderAlignmentHorz = taCenter
          Width = 313
        end
        object UnitSerialNumber: TcxGridDBColumn
          Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
          DataBinding.FieldName = 'SerialNumber'
          HeaderAlignmentHorz = taCenter
          Width = 103
        end
      end
      object cxGridLevel4: TcxGridLevel
        GridView = cxGridDBTableView4
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
    Top = 80
  end
  object Timer1: TTimer
    Enabled = False
    Left = 32
    Top = 80
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
        Name = 'inBayer'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inBayerPhone'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'inCode'
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
    StoredProcName = 'gpInsertUpdate_Movement_Check_Site_Tabletki'
    Left = 40
    Top = 256
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
        Name = 'inBayer'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'inBayerPhone'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'inCode'
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
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 112
    Top = 184
  end
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpSelect_Object_Unit_BookingsForTabletki('#39'3'#39')')
    Params = <>
    Properties.Strings = (
      '')
    Left = 28
    Top = 184
  end
end
