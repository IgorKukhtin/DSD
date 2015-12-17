object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 521
  ClientWidth = 909
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
    Width = 909
    Height = 521
    ActivePage = tsOptima
    Align = alClient
    TabOrder = 0
    object tsOptima: TTabSheet
      Caption = #1054#1087#1090#1080#1084#1072
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 901
        Height = 31
        Align = alTop
        TabOrder = 0
        object OptimaDate: TcxDateEdit
          Left = 85
          Top = 4
          EditValue = 42339d
          Properties.ShowTime = False
          TabOrder = 0
          Width = 85
        end
        object cxLabel3: TcxLabel
          Left = 6
          Top = 8
          Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072':'
        end
        object btnOptimaExecute: TButton
          Left = 439
          Top = 0
          Width = 90
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 2
          OnClick = btnOptimaExecuteClick
        end
        object OptimaId: TcxSpinEdit
          Left = 288
          Top = 4
          Properties.SpinButtons.Visible = False
          TabOrder = 3
          Value = 59611
          Width = 81
        end
        object cxLabel4: TcxLabel
          Left = 198
          Top = 8
          Caption = 'ID '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072':'
        end
        object btnOptimaExport: TButton
          Left = 535
          Top = 0
          Width = 58
          Height = 25
          Caption = #1069#1082#1089#1087#1086#1088#1090
          TabOrder = 5
          OnClick = btnOptimaExportClick
        end
        object btnOptimaAll: TButton
          Left = 375
          Top = 0
          Width = 58
          Height = 25
          Caption = #1042#1089#1105'!'
          TabOrder = 6
          OnClick = btnOptimaAllClick
        end
        object btnOptimaSendMail: TButton
          Left = 782
          Top = 0
          Width = 113
          Height = 25
          Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' Email'
          TabOrder = 7
          OnClick = btnOptimaSendMailClick
        end
        object edtOptimaEMail: TEdit
          Left = 616
          Top = 4
          Width = 160
          Height = 21
          TabOrder = 8
          Text = 'sqlmail2@optimapharm.ua'
        end
      end
      object grUnit: TcxGrid
        Left = 0
        Top = 31
        Width = 901
        Height = 328
        Align = alClient
        TabOrder = 1
        object grtvUnit: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsUnit
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object colUnitId: TcxGridDBColumn
            Caption = #1048#1044
            DataBinding.FieldName = 'UnitId'
            Visible = False
          end
          object cxGridDBColumn1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            Width = 47
          end
          object colUnitCodePartner: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'UnitCodePartner'
            Width = 96
          end
          object cxGridDBColumn2: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Width = 239
          end
        end
        object grlUnit: TcxGridLevel
          GridView = grtvUnit
        end
      end
      object grOptima: TcxGrid
        Left = 0
        Top = 359
        Width = 901
        Height = 134
        Align = alBottom
        TabOrder = 2
        object grtvOptima: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsReport_Upload_Optima
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
        object grlOptima: TcxGridLevel
          GridView = grtvOptima
        end
      end
    end
    object tsBaDM: TTabSheet
      Caption = #1041#1072#1044#1052
      ImageIndex = 1
      object PageControl: TcxPageControl
        Left = 0
        Top = 31
        Width = 901
        Height = 462
        Align = alClient
        Focusable = False
        TabOrder = 0
        Properties.ActivePage = tsMain
        Properties.CustomButtons.Buttons = <>
        ClientRectBottom = 462
        ClientRectRight = 901
        ClientRectTop = 0
        object tsMain: TcxTabSheet
          Caption = 'tsMain'
          ImageIndex = 0
          TabVisible = False
          object grBaDM: TcxGrid
            Left = 0
            Top = 0
            Width = 901
            Height = 462
            Align = alClient
            TabOrder = 0
            object grtvBaDM: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = dsReport_Upload_BaDM
              DataController.Filter.Options = [fcoCaseInsensitive]
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsBehavior.GoToNextCellOnEnter = True
              OptionsBehavior.FocusCellOnCycle = True
              OptionsCustomize.ColumnFiltering = False
              OptionsCustomize.ColumnMoving = False
              OptionsCustomize.DataRowSizing = True
              OptionsData.CancelOnExit = False
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsView.GroupByBox = False
              OptionsView.GroupSummaryLayout = gslAlignWithColumns
              OptionsView.HeaderAutoHeight = True
              OptionsView.Indicator = True
              object colOperDate: TcxGridDBColumn
                Caption = #1044#1072#1090#1072
                DataBinding.FieldName = 'OperDate'
                HeaderHint = 
                  #1076#1072#1090#1072' '#1086#1087#1077#1088#1072#1094#1080#1086#1085#1085#1086#1075#1086' '#1076#1085#1103' '#1082' '#1082#1086#1090#1086#1088#1086#1081' '#1086#1090#1085#1086#1089#1080#1090#1089#1103' '#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1085#1072#1103' '#1086#1087#1077#1088#1072#1094#1080 +
                  #1103
                Width = 55
              end
              object colJuridicalCode: TcxGridDBColumn
                Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
                DataBinding.FieldName = 'JuridicalCode'
                HeaderHint = 
                  #1082#1086#1076' '#1102#1088'.'#1083#1080#1094#1072' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1041#1072#1044#1052', '#1082' '#1082#1086#1090#1086#1088#1086#1084#1091' '#1086#1090#1085#1086#1089#1080#1090#1089#1103' '#1072#1087#1090#1077#1082#1072',' +
                  ' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1103#1077#1090#1089#1103' '#1041#1072#1044#1052' '#1087#1088#1080' '#1087#1086#1089#1090#1088#1086#1077#1085#1080#1080' '#1089#1080#1089#1090#1077#1084#1099
                Width = 76
              end
              object colUnitCode: TcxGridDBColumn
                Caption = #1050#1086#1076' '#1089#1082#1083#1072#1076#1072
                DataBinding.FieldName = 'UnitCode'
                HeaderHint = #1082#1086#1076' '#1072#1087#1090#1077#1082#1080' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090#1072
                Width = 56
              end
              object colUnitName: TcxGridDBColumn
                Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1082#1083#1072#1076#1072
                DataBinding.FieldName = 'UnitName'
                HeaderHint = #1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1072#1087#1090#1077#1082#1080' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090#1072
                Width = 182
              end
              object colGoodsCode: TcxGridDBColumn
                Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
                DataBinding.FieldName = 'GoodsCode'
                HeaderHint = 
                  #1082#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090'. '#1057#1086#1086#1090#1085#1077#1089#1077#1085#1080#1077' '#1082#1086#1076#1086#1074' ' +
                  #1090#1086#1074#1072#1088' '#1082#1086#1084#1087#1072#1085#1080#1081' '#1050#1083#1080#1077#1085#1090' '#1080' '#1041#1072#1044#1052' '#1086#1089#1091#1097#1077#1089#1090#1074#1083#1103#1077#1090#1089#1103' '#1085#1072' '#1089#1090#1086#1088#1086#1085#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' ' +
                  #1041#1072#1044#1052
                Width = 52
              end
              object colGoodsName: TcxGridDBColumn
                Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
                DataBinding.FieldName = 'GoodsName'
                HeaderHint = #1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090#1072
                Width = 153
              end
              object colOperCode: TcxGridDBColumn
                Caption = #1058#1080#1087' '#1086#1087#1077#1088#1072#1094#1080#1080
                DataBinding.FieldName = 'OperCode'
                HeaderHint = 
                  #1082#1086#1076' '#1090#1086#1074#1072#1088#1085#1086#1081' '#1086#1087#1077#1088#1072#1094#1080#1080' '#1074' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1080' '#1089' '#1090#1072#1073#1083#1080#1094#1077#1081' '#1090#1080#1087#1086#1074' '#1086#1087#1077#1088#1072#1094#1080#1081#13#10 +
                  '1     '#1047#1072#1087#1072#1089' '#1090#1086#1074#1072#1088#1072' ('#1085#1072' '#1082#1086#1085#1077#1094' '#1076#1085#1103') ('#1096#1090')'#13#10'10    '#1055#1088#1086#1076#1072#1078#1072' '#1090#1086#1074#1072#1088#1072'  ('#1096 +
                  #1090')'
                Width = 33
              end
              object colAmount: TcxGridDBColumn
                Caption = #1047#1085#1072#1095#1077#1085#1080#1077
                DataBinding.FieldName = 'Amount'
                HeaderHint = #1095#1080#1089#1083#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
                Width = 42
              end
              object colSegment1: TcxGridDBColumn
                Caption = #1057#1077#1075#1084#1077#1085#1090' 1'
                DataBinding.FieldName = 'Segment1'
                HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
                Width = 30
              end
              object colSegment2: TcxGridDBColumn
                Caption = #1057#1077#1075#1084#1077#1085#1090' 2'
                DataBinding.FieldName = 'Segment2'
                HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
                Width = 30
              end
              object colSegment3: TcxGridDBColumn
                Caption = #1057#1077#1075#1084#1077#1085#1090' 3'
                DataBinding.FieldName = 'Segment3'
                HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
                Width = 30
              end
              object colSegment4: TcxGridDBColumn
                Caption = #1057#1077#1075#1084#1077#1085#1090' 4'
                DataBinding.FieldName = 'Segment4'
                HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
                Width = 30
              end
              object colSegment5: TcxGridDBColumn
                Caption = #1057#1077#1075#1084#1077#1085#1090' 5'
                DataBinding.FieldName = 'Segment5'
                HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
                Width = 30
              end
            end
            object grlBaDM: TcxGridLevel
              GridView = grtvBaDM
            end
          end
        end
      end
      object Panel: TPanel
        Left = 0
        Top = 0
        Width = 901
        Height = 31
        Align = alTop
        TabOrder = 1
        object BaDMDate: TcxDateEdit
          Left = 85
          Top = 5
          EditValue = 42339d
          Properties.ShowTime = False
          TabOrder = 0
          Width = 85
        end
        object cxLabel1: TcxLabel
          Left = 6
          Top = 8
          Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072':'
        end
        object btnBaDMExecute: TButton
          Left = 384
          Top = 0
          Width = 113
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 2
          OnClick = btnBaDMExecuteClick
        end
        object BaDMID: TcxSpinEdit
          Left = 288
          Top = 4
          Properties.SpinButtons.Visible = False
          TabOrder = 3
          Value = 59610
          Width = 81
        end
        object cxLabel2: TcxLabel
          Left = 198
          Top = 8
          Caption = 'ID '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072':'
        end
        object btnBaDMExport: TButton
          Left = 503
          Top = 0
          Width = 113
          Height = 25
          Caption = #1069#1082#1089#1087#1086#1088#1090
          TabOrder = 5
          OnClick = btnBaDMExportClick
        end
        object btnBaDMSendFTP: TButton
          Left = 783
          Top = 0
          Width = 113
          Height = 25
          Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' FTP'
          TabOrder = 6
          OnClick = btnBaDMSendFTPClick
        end
      end
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Port = 5432
    Protocol = 'postgresql-9'
    Left = 120
    Top = 112
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 128
  end
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'Select * from gpSelect_Object_UnitForUpload(:inObjectId,:inSelec' +
        'tAll,'#39'3'#39');')
    Params = <
      item
        DataType = ftUnknown
        Name = 'inObjectId'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inSelectAll'
        ParamType = ptUnknown
      end>
    Left = 216
    Top = 296
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'inObjectId'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inSelectAll'
        ParamType = ptUnknown
      end>
  end
  object qryReport_Upload_BaDM: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'Select * from gpReport_Upload_BaDM(:inDate,:inObjectId,'#39'3'#39');')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42339d
      end
      item
        DataType = ftInteger
        Name = 'inObjectId'
        ParamType = ptInput
        Value = 59610
      end>
    Left = 224
    Top = 192
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42339d
      end
      item
        DataType = ftInteger
        Name = 'inObjectId'
        ParamType = ptInput
        Value = 59610
      end>
  end
  object dsReport_Upload_BaDM: TDataSource
    DataSet = qryReport_Upload_BaDM
    Left = 264
    Top = 192
  end
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 256
    Top = 296
  end
  object qryReport_Upload_Optima: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'Select * from gpReport_Upload_Optima(:inDate,:inObjectId,:inUnit' +
        'Id,'#39'3'#39');')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42339d
      end
      item
        DataType = ftInteger
        Name = 'inObjectId'
        ParamType = ptInput
        Value = 59610
      end
      item
        DataType = ftInteger
        Name = 'inUnitId'
        ParamType = ptInput
        Value = 0
      end>
    Left = 216
    Top = 416
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42339d
      end
      item
        DataType = ftInteger
        Name = 'inObjectId'
        ParamType = ptInput
        Value = 59610
      end
      item
        DataType = ftInteger
        Name = 'inUnitId'
        ParamType = ptInput
        Value = 0
      end>
  end
  object dsReport_Upload_Optima: TDataSource
    DataSet = qryReport_Upload_Optima
    Left = 256
    Top = 416
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
    Left = 400
    Top = 416
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
    Left = 768
    Top = 128
  end
end
