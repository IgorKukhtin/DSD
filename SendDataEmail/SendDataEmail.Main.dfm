object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1086#1089#1090#1072#1090#1082#1086#1074
  ClientHeight = 441
  ClientWidth = 722
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LogMemo: TMemo
    Left = 0
    Top = 202
    Width = 722
    Height = 239
    Align = alClient
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCream
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'LogMemo')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 722
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      722
      31)
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 42125d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Visible = False
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 42125d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Visible = False
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
      Visible = False
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
      Visible = False
    end
    object StartButton: TcxButton
      Left = 594
      Top = 3
      Width = 58
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1087#1091#1089#1082
      TabOrder = 0
      OnClick = actStartEmailExecute
    end
    object StopButton: TcxButton
      Left = 656
      Top = 3
      Width = 61
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1089#1090#1072#1085#1086#1074#1082#1072
      TabOrder = 1
      OnClick = actStopEmailExecute
    end
  end
  object ExportXmlGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 722
    Height = 76
    Align = alTop
    TabOrder = 2
    Visible = False
    object ExportXmlGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ExportDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.Header = False
      object RowData: TcxGridDBColumn
        DataBinding.FieldName = 'RowData'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
    end
    object ExportXmlGridLevel: TcxGridLevel
      GridView = ExportXmlGridDBTableView
    end
  end
  object OptionsMemo: TMemo
    Left = 0
    Top = 107
    Width = 722
    Height = 95
    Align = alTop
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCream
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'OptionsMemo')
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
  end
  object TrayIcon: TTrayIcon
    Hint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1086#1089#1090#1072#1090#1082#1086#1074
    Visible = True
    OnClick = TrayIconClick
    Left = 360
    Top = 44
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 412
    Top = 44
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inFileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 108
    Top = 180
  end
  object ActionList: TActionList
    Left = 108
    Top = 252
    object actStartEmail: TAction
      Caption = #1047#1072#1087#1091#1089#1082
      OnExecute = actStartEmailExecute
      OnUpdate = actStartEmailUpdate
    end
    object actStopEmail: TAction
      Caption = #1054#1089#1090#1072#1085#1086#1074#1082#1072
      OnExecute = actStopEmailExecute
      OnUpdate = actStopEmailUpdate
    end
    object actGet_Export_FileName: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actSelect_Export: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_Export
      StoredProcList = <
        item
          StoredProc = spSelect_Export
        end>
      Caption = 'actSelect_Export'
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_file'
      MoveParams = <>
      ExportType = cxegExportToTextUTF8
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
    end
    object mactExport: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actGet_Export_Email
        end
        item
          Action = actSelect_Export
        end
        item
          Action = actExport_Grid
        end
        item
          Action = actSMTPFile
        end>
      Caption = 'mactExport'
      Hint = 'mactExport'
      ImageIndex = 53
    end
    object actGet_Export_Email: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email
        end>
      Caption = 'actGet_Export_Email'
    end
    object actSMTPFile: TdsdSMTPFileAction
      Category = 'Export_Email'
      MoveParams = <>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = ExportEmailCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = ExportEmailCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 80
    Top = 23
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 128
    Top = 23
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsRemains_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 7
  end
  object spSelect_Export: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsRemains_File'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 47
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 40
    Top = 72
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 80
    Top = 73
  end
  object spGet_Export_Email: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsRemains_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inFileName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 82
  end
end
