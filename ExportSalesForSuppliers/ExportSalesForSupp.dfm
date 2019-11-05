object ExportSalesForSuppForm: TExportSalesForSuppForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 543
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 909
    Height = 543
    ActivePage = tsYuriFarm
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
        Height = 350
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
        Top = 381
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
        Height = 484
        Align = alClient
        Focusable = False
        TabOrder = 0
        Properties.ActivePage = tsMain
        Properties.CustomButtons.Buttons = <>
        ClientRectBottom = 484
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
            Height = 275
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
          object grBaDM_byU: TcxGrid
            Left = 0
            Top = 275
            Width = 901
            Height = 209
            Align = alBottom
            TabOrder = 1
            object grtvBaDM_byU: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = dsReport_Upload_BaDM_byUnit
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
              object GoodsName: TcxGridDBColumn
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                DataBinding.FieldName = 'GoodsName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 155
              end
              object GoodsCode: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'GoodsCode'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 53
              end
              object Amount_Sale1: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 1) '
                DataBinding.FieldName = 'Amount_Sale1'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd1: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 1) '
                DataBinding.FieldName = 'RemainsEnd1'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale2: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 2) '
                DataBinding.FieldName = 'Amount_Sale2'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd2: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 2) '
                DataBinding.FieldName = 'RemainsEnd2'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale3: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 3) '
                DataBinding.FieldName = 'Amount_Sale3'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd3: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 3) '
                DataBinding.FieldName = 'RemainsEnd3'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale4: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 4) '
                DataBinding.FieldName = 'Amount_Sale4'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd4: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 4) '
                DataBinding.FieldName = 'RemainsEnd4'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale5: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 5) '
                DataBinding.FieldName = 'Amount_Sale5'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd51: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 5) '
                DataBinding.FieldName = 'RemainsEnd5'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale6: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 6) '
                DataBinding.FieldName = 'Amount_Sale6'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd6: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 6) '
                DataBinding.FieldName = 'RemainsEnd6'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale7: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 7) '
                DataBinding.FieldName = 'Amount_Sale7'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd7: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 7) '
                DataBinding.FieldName = 'RemainsEnd7'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale8: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 8) '
                DataBinding.FieldName = 'Amount_Sale8'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd8: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 8) '
                DataBinding.FieldName = 'RemainsEnd8'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale9: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 9) '
                DataBinding.FieldName = 'Amount_Sale9'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd9: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 9) '
                DataBinding.FieldName = 'RemainsEnd9'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale10: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 10) '
                DataBinding.FieldName = 'Amount_Sale10'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd10: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 10) '
                DataBinding.FieldName = 'RemainsEnd10'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale11: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 11) '
                DataBinding.FieldName = 'Amount_Sale11'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd11: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 11) '
                DataBinding.FieldName = 'RemainsEnd11'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale12: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 12) '
                DataBinding.FieldName = 'Amount_Sale12'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd12: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 12) '
                DataBinding.FieldName = 'RemainsEnd12'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale13: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 13) '
                DataBinding.FieldName = 'Amount_Sale13'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd13: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 13) '
                DataBinding.FieldName = 'RemainsEnd13'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale14: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 14) '
                DataBinding.FieldName = 'Amount_Sale14'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd14: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 14) '
                DataBinding.FieldName = 'RemainsEnd14'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale15: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 15) '
                DataBinding.FieldName = 'Amount_Sale15'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd15: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 15) '
                DataBinding.FieldName = 'RemainsEnd15'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale16: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 16) '
                DataBinding.FieldName = 'Amount_Sale16'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd16: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 16) '
                DataBinding.FieldName = 'RemainsEnd16'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale17: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 17) '
                DataBinding.FieldName = 'Amount_Sale17'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd17: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 17) '
                DataBinding.FieldName = 'RemainsEnd17'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale18: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 18) '
                DataBinding.FieldName = 'Amount_Sale18'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd18: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 18) '
                DataBinding.FieldName = 'RemainsEnd18'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale19: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 19) '
                DataBinding.FieldName = 'Amount_Sale19'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd19: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 19) '
                DataBinding.FieldName = 'RemainsEnd19'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale20: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 20) '
                DataBinding.FieldName = 'Amount_Sale20'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd20: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 20) '
                DataBinding.FieldName = 'RemainsEnd20'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale21: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 21) '
                DataBinding.FieldName = 'Amount_Sale21'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd21: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 21) '
                DataBinding.FieldName = 'RemainsEnd21'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale22: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 22) '
                DataBinding.FieldName = 'Amount_Sale22'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd22: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 22) '
                DataBinding.FieldName = 'RemainsEnd22'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale23: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 23) '
                DataBinding.FieldName = 'Amount_Sale23'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd23: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 23) '
                DataBinding.FieldName = 'RemainsEnd23'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale24: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 24) '
                DataBinding.FieldName = 'Amount_Sale24'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd24: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 24) '
                DataBinding.FieldName = 'RemainsEnd24'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale25: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 25) '
                DataBinding.FieldName = 'Amount_Sale25'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd25: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 25) '
                DataBinding.FieldName = 'RemainsEnd25'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale26: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 26) '
                DataBinding.FieldName = 'Amount_Sale26'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd26: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 26) '
                DataBinding.FieldName = 'RemainsEnd26'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale27: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 27) '
                DataBinding.FieldName = 'Amount_Sale27'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd27: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 27) '
                DataBinding.FieldName = 'RemainsEnd27'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale28: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 28) '
                DataBinding.FieldName = 'Amount_Sale28'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd28: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 28) '
                DataBinding.FieldName = 'RemainsEnd28'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale29: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 29) '
                DataBinding.FieldName = 'Amount_Sale29'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd29: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 29) '
                DataBinding.FieldName = 'RemainsEnd29'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
              object Amount_Sale30: TcxGridDBColumn
                Caption = #1056#1077#1072#1083#1080#1079', '#1096#1090' ('#1055#1086#1076#1088'. 30) '
                DataBinding.FieldName = 'Amount_Sale30'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 77
              end
              object RemainsEnd30: TcxGridDBColumn
                Caption = #1050#1086#1085'.'#1086#1089#1090'., '#1096#1090' ('#1055#1086#1076#1088'. 30) '
                DataBinding.FieldName = 'RemainsEnd30'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 85
              end
            end
            object grlBaDM_byU: TcxGridLevel
              GridView = grtvBaDM_byU
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
    object tsTeva: TTabSheet
      Caption = #1058#1077#1074#1072
      ImageIndex = 2
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 901
        Height = 31
        Align = alTop
        TabOrder = 0
        object btnTevaSendMail: TButton
          Left = 782
          Top = 0
          Width = 113
          Height = 25
          Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' Email'
          TabOrder = 0
          OnClick = btnTevaSendMailClick
        end
        object edtTevaEMail: TEdit
          Left = 583
          Top = 4
          Width = 193
          Height = 21
          TabOrder = 1
          Text = 'teva.reports@proximaresearch.com'
        end
        object btnTevaExport: TButton
          Left = 519
          Top = 0
          Width = 58
          Height = 25
          Caption = #1069#1082#1089#1087#1086#1088#1090
          TabOrder = 2
          OnClick = btnTevaExportClick
        end
        object btnTevaExecute: TButton
          Left = 423
          Top = 0
          Width = 90
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 3
          OnClick = btnTevaExecuteClick
        end
        object btnTevaAll: TButton
          Left = 359
          Top = 0
          Width = 58
          Height = 25
          Caption = #1042#1089#1105'!'
          TabOrder = 4
          OnClick = btnTevaAllClick
        end
        object TevaID: TcxSpinEdit
          Left = 272
          Top = 4
          Properties.SpinButtons.Visible = False
          TabOrder = 5
          Value = 59610
          Width = 81
        end
        object cxLabel5: TcxLabel
          Left = 182
          Top = 8
          Caption = 'ID '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072':'
        end
        object TevaDate: TcxDateEdit
          Left = 85
          Top = 4
          EditValue = 42339d
          Properties.ShowTime = False
          TabOrder = 7
          Width = 85
        end
        object cxLabel6: TcxLabel
          Left = 6
          Top = 8
          Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072':'
        end
      end
      object grTeva: TcxGrid
        Left = 0
        Top = 31
        Width = 901
        Height = 484
        Align = alClient
        TabOrder = 1
        object grtvTeva: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsReport_Upload_Teva
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object grtvTevaoperdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'operdate'
            Width = 80
          end
          object grtvTevaokpo: TcxGridDBColumn
            Caption = #1045#1044#1056#1055#1054#1059
            DataBinding.FieldName = 'okpo'
            Width = 100
          end
          object grtvTevaunitname: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'unitname'
            Width = 200
          end
          object grtvTevaunitaddress: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'unitaddress'
            Width = 200
          end
          object grtvTevagoodsname: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'goodsname'
            Width = 200
          end
          object grtvTevaamount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'amount'
          end
          object grtvTevasumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'summ'
          end
          object grtvTevaprice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'price'
          end
        end
        object grTevaLevel1: TcxGridLevel
          GridView = grtvTeva
        end
      end
    end
    object tsADV: TTabSheet
      Caption = 'ADV '#1082#1091#1087#1086#1085
      ImageIndex = 3
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 901
        Height = 31
        Align = alTop
        TabOrder = 0
        object AVDDate: TcxDateEdit
          Left = 85
          Top = 4
          EditValue = 42339d
          Properties.ShowTime = False
          TabOrder = 0
          Width = 85
        end
        object cxLabel7: TcxLabel
          Left = 6
          Top = 6
          Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072':'
        end
        object btnADVExecute: TButton
          Left = 384
          Top = 0
          Width = 113
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 2
          OnClick = btnADVExecuteClick
        end
        object btnADVExport: TButton
          Left = 503
          Top = 0
          Width = 113
          Height = 25
          Caption = #1069#1082#1089#1087#1086#1088#1090
          TabOrder = 3
          OnClick = btnADVExportClick
        end
        object btnADVSend: TButton
          Left = 783
          Top = 0
          Width = 113
          Height = 25
          Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' FTP'
          TabOrder = 4
          OnClick = btnADVSendClick
        end
      end
      object grAVD: TcxGrid
        Left = 0
        Top = 31
        Width = 901
        Height = 484
        Align = alClient
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsReport_Upload_ADV
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object cxGridDBTableView1Column1: TcxGridDBColumn
            DataBinding.FieldName = 'retailName'
            Width = 70
          end
          object cxGridDBTableView1Column2: TcxGridDBColumn
            DataBinding.FieldName = 'city'
            Width = 70
          end
          object cxGridDBTableView1Column3: TcxGridDBColumn
            DataBinding.FieldName = 'address'
            Width = 70
          end
          object cxGridDBTableView1Column4: TcxGridDBColumn
            DataBinding.FieldName = 'checkID'
            Width = 70
          end
          object cxGridDBTableView1Column5: TcxGridDBColumn
            DataBinding.FieldName = 'sale_date'
            Width = 70
          end
          object cxGridDBTableView1Column6: TcxGridDBColumn
            DataBinding.FieldName = 'sale_time'
            Width = 70
          end
          object cxGridDBTableView1Column7: TcxGridDBColumn
            DataBinding.FieldName = 'itemBC'
            Width = 70
          end
          object cxGridDBTableView1Column8: TcxGridDBColumn
            DataBinding.FieldName = 'couponBC'
            Width = 70
          end
          object cxGridDBTableView1Column9: TcxGridDBColumn
            DataBinding.FieldName = 'nameBC'
            Width = 70
          end
          object cxGridDBTableView1Column10: TcxGridDBColumn
            DataBinding.FieldName = 'price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.00'
            Width = 70
          end
          object cxGridDBTableView1Column11: TcxGridDBColumn
            DataBinding.FieldName = 'sum_price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.00'
            Width = 70
          end
          object cxGridDBTableView1Column12: TcxGridDBColumn
            DataBinding.FieldName = 'sum_couponsale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.00'
            Width = 70
          end
          object cxGridDBTableView1Column13: TcxGridDBColumn
            DataBinding.FieldName = 'discount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.00'
            Width = 70
          end
          object cxGridDBTableView1Column14: TcxGridDBColumn
            DataBinding.FieldName = 'discount_rel'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.00'
            Width = 70
          end
          object cxGridDBTableView1Column15: TcxGridDBColumn
            DataBinding.FieldName = 'sum_discount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.00'
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
    object tsYuriFarm: TTabSheet
      Caption = #1070#1088#1080#1103'-'#1060#1072#1088#1084
      ImageIndex = 4
      object grYuriFarm: TcxGrid
        Left = 0
        Top = 249
        Width = 901
        Height = 266
        Align = alClient
        TabOrder = 0
        object grYuriFarmDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsReport_Upload_YuriFarm
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object grYuriFarmLevel: TcxGridLevel
          GridView = grYuriFarmDBTableView
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 901
        Height = 31
        Align = alTop
        TabOrder = 1
        object YuriFarmDate: TcxDateEdit
          Left = 85
          Top = 4
          EditValue = 42339d
          Properties.ShowTime = False
          TabOrder = 0
          Width = 85
        end
        object cxLabel8: TcxLabel
          Left = 6
          Top = 6
          Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072':'
        end
        object btnYuriFarmExecute: TButton
          Left = 440
          Top = 0
          Width = 113
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 2
          OnClick = btnYuriFarmExecuteClick
        end
        object btnYuriFarmSend: TButton
          Left = 783
          Top = 0
          Width = 113
          Height = 25
          Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' HTTPS'
          TabOrder = 3
          OnClick = btnYuriFarmSendClick
        end
        object btnYuriFarmUnitExecute: TButton
          Left = 256
          Top = 0
          Width = 113
          Height = 25
          Caption = #1057#1087#1080#1089#1086#1082' '#1072#1087#1090#1077#1082
          TabOrder = 4
          OnClick = btnYuriFarmUnitExecuteClick
        end
      end
      object grYuriFarmUnit: TcxGrid
        Left = 0
        Top = 31
        Width = 901
        Height = 218
        Align = alTop
        TabOrder = 2
        object grYuriFarmUnitDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsReport_Upload_YuriFarm_Unit
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          object grYuriFarmUnit_ID: TcxGridDBColumn
            DataBinding.FieldName = 'ID'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object grYuriFarmUnit_UnitName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 251
          end
          object grYuriFarmUnit_OKPO: TcxGridDBColumn
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object grYuriFarmUnit_UnitAddress: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'UnitAddress'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 304
          end
        end
        object grYuriFarmUnitLevel: TcxGridLevel
          GridView = grYuriFarmUnitDBTableView
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
    Left = 232
    Top = 200
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
    Left = 304
    Top = 168
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
  object qryReport_Upload_BaDM_byUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'Select * from gpReport_Badm (:inDate,:inDate,'#39'3'#39');')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = '01.12.2015'
      end>
    Left = 448
    Top = 152
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = '01.12.2015'
      end>
  end
  object dsReport_Upload_BaDM_byUnit: TDataSource
    DataSet = qryReport_Upload_BaDM_byUnit
    Left = 624
    Top = 152
  end
  object qryBadm_byUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'SELECT Name, Num_byReportBadm FROM gpSelect_Object_Unit (FALSE, ' +
        #39'3'#39') AS tmp WHERE Num_byReportBadm > 0 ORDER BY Num_byReportBadm')
    Params = <>
    Left = 408
    Top = 248
  end
  object qryReport_Upload_Teva: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'SELECT * FROM gpReport_Upload_Teva (:inDate, :inObjectId, zfCalc' +
        '_UserAdmin())')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end
      item
        DataType = ftInteger
        Name = 'inObjectId'
        ParamType = ptInput
        Value = 59610
      end>
    Left = 588
    Top = 232
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end
      item
        DataType = ftInteger
        Name = 'inObjectId'
        ParamType = ptInput
        Value = 59610
      end>
    object qryReport_Upload_Tevaoperdate: TDateTimeField
      FieldName = 'operdate'
      ReadOnly = True
    end
    object qryReport_Upload_Tevaokpo: TWideStringField
      FieldName = 'okpo'
      ReadOnly = True
      Size = 510
    end
    object qryReport_Upload_Tevaunitname: TWideStringField
      FieldName = 'unitname'
      ReadOnly = True
      Size = 510
    end
    object qryReport_Upload_Tevaunitaddress: TWideStringField
      FieldName = 'unitaddress'
      ReadOnly = True
      Size = 510
    end
    object qryReport_Upload_Tevagoodsname: TWideStringField
      FieldName = 'goodsname'
      ReadOnly = True
      Size = 510
    end
    object qryReport_Upload_Tevaamount: TFloatField
      FieldName = 'amount'
      ReadOnly = True
    end
    object qryReport_Upload_Tevasumm: TFloatField
      FieldName = 'summ'
      ReadOnly = True
    end
    object qryReport_Upload_Tevaprice: TFloatField
      FieldName = 'price'
      ReadOnly = True
    end
  end
  object dsReport_Upload_Teva: TDataSource
    DataSet = qryReport_Upload_Teva
    Left = 584
    Top = 304
  end
  object dsReport_Upload_ADV: TDataSource
    DataSet = qryReport_Upload_ADV
    Left = 720
    Top = 304
  end
  object qryReport_Upload_ADV: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM gpReport_Upload_ADV (:inDate, zfCalc_UserAdmin())')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end>
    Left = 716
    Top = 232
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end>
  end
  object dsReport_Upload_YuriFarm: TDataSource
    DataSet = qryReport_Upload_YuriFarm
    Left = 576
    Top = 448
  end
  object qryReport_Upload_YuriFarm: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'SELECT * FROM gpReport_Upload_YuriFarm (:inDate, :inUnitID, zfCa' +
        'lc_UserAdmin())')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end
      item
        DataType = ftInteger
        Name = 'inUnitID'
        ParamType = ptUnknown
      end>
    Left = 580
    Top = 376
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end
      item
        DataType = ftInteger
        Name = 'inUnitID'
        ParamType = ptUnknown
      end>
  end
  object dsReport_Upload_YuriFarm_Unit: TDataSource
    DataSet = qryReport_Upload_YuriFarm_Unit
    Left = 744
    Top = 448
  end
  object qryReport_Upload_YuriFarm_Unit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'SELECT * FROM gpReport_Upload_YuriFarm_Unit (:inDate, zfCalc_Use' +
        'rAdmin())')
    Params = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end>
    Left = 740
    Top = 376
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'inDate'
        ParamType = ptInput
        Value = 42773d
      end>
  end
end
