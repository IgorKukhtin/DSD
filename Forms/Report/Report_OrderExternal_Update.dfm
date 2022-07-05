inherited Report_OrderExternal_UpdateForm: TReport_OrderExternal_UpdateForm
  Caption = #1054#1090#1095#1077#1090' <'#1047#1072#1103#1074#1082#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' - '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077'>'
  ClientHeight = 590
  ClientWidth = 928
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 944
  ExplicitHeight = 629
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 928
    Height = 317
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 928
    ExplicitHeight = 317
    ClientRectBottom = 317
    ClientRectRight = 928
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 928
      ExplicitHeight = 317
      inherited cxGrid: TcxGrid
        Width = 928
        Height = 317
        ExplicitWidth = 928
        ExplicitHeight = 317
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = RouteName
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'DayOfWeekName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 250
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_CarInfo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'OperDate_CarInfo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1092#1072#1082#1090
            Options.Editing = False
            Width = 80
          end
          object DayOfWeekName_CarInfo: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DayOfWeekName_CarInfo'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1092#1072#1082#1090
            Options.Editing = False
            Width = 70
          end
          object Days: TcxGridDBColumn
            Caption = #1086#1090#1082#1083'. '#1076#1085'. +/-'
            DataBinding.FieldName = 'Days'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1082#1083#1086#1085#1077#1085#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1086#1090' '#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095#1077#1090
            Width = 70
          end
          object Times: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103
            DataBinding.FieldName = 'Times'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1092#1072#1082#1090
            Width = 70
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'OperDatePartner'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095#1077#1090
            Options.Editing = False
            Width = 70
          end
          object DayOfWeekName_Partner: TcxGridDBColumn
            Caption = '***'#1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DayOfWeekName_Partner'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095#1077#1090
            Options.Editing = False
            Width = 70
          end
          object CarInfoName: TcxGridDBColumn
            Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1076#1083#1103' '#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'CarInfoName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenChoiceCarInfoForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 138
          end
          object CarComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'CarComment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object ToName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075'.'#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object PartnerTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1058#1058
            DataBinding.FieldName = 'PartnerTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CountPartner: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1058#1058'/'#1044#1086#1082'.'
            DataBinding.FieldName = 'CountPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1058#1058'/'#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
            Options.Editing = False
            Width = 80
          end
          object AmountWeight: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSh: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086',  '#1096#1090' '
            DataBinding.FieldName = 'AmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object StartWeighing: TcxGridDBColumn
            Caption = #1057#1090#1072#1088#1090
            DataBinding.FieldName = 'StartWeighing'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1088#1090' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object EndWeighing: TcxGridDBColumn
            Caption = #1060#1080#1085#1080#1096
            DataBinding.FieldName = 'EndWeighing'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1085#1080#1096' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object DayOfWeekName_StartW: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1089#1090#1072#1088#1090
            DataBinding.FieldName = 'DayOfWeekName_StartW'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1089#1090#1072#1088#1090' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object DayOfWeekName_EndW: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1092#1080#1085#1080#1096
            DataBinding.FieldName = 'DayOfWeekName_EndW'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1092#1080#1085#1080#1096' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object Hours_EndW: TcxGridDBColumn
            Caption = #1063#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours_EndW'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1076#1083#1103' '#1089#1073#1086#1088#1082#1080' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object Hours_real: TcxGridDBColumn
            Caption = '***'#1063#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours_real'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1087#1086#1079#1078#1077' '#1095#1077#1084' '#1055#1083#1072#1085
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 928
    Height = 33
    ExplicitWidth = 928
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 94
      EditValue = 44562d
      Properties.SaveTime = False
      ExplicitLeft = 94
      ExplicitWidth = 82
      Width = 82
    end
    inherited deEnd: TcxDateEdit
      Left = 834
      EditValue = 44562d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 834
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel1: TcxLabel
      Left = 2
      ExplicitLeft = 2
    end
    inherited cxLabel2: TcxLabel
      Left = 778
      Top = 8
      Visible = False
      ExplicitLeft = 778
      ExplicitTop = 8
    end
    object edIsDate_CarInfo: TcxCheckBox
      Left = 791
      Top = 5
      Action = actRefresh_Car
      TabOrder = 4
      Visible = False
      Width = 115
    end
    object cbisGoods: TcxCheckBox
      Left = 197
      Top = 5
      Action = actRefresh_Goods
      TabOrder = 5
      Width = 82
    end
  end
  object edTo: TcxButtonEdit [2]
    Left = 353
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 275
  end
  object cxLabel8: TcxLabel [3]
    Left = 310
    Top = 6
    Caption = #1057#1082#1083#1072#1076':'
  end
  object cxSplitter1: TcxSplitter [4]
    Left = 0
    Top = 376
    Width = 928
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = grChart
  end
  object grChart: TcxGrid [5]
    Left = 0
    Top = 384
    Width = 928
    Height = 206
    Align = alBottom
    TabOrder = 9
    ExplicitTop = 376
    object grChartDBChartView1: TcxGridDBChartView
      DataController.DataSource = MasterDS
      DiagramArea.Values.LineWidth = 2
      DiagramLine.Active = True
      DiagramLine.Values.LineWidth = 2
      ToolBox.CustomizeButton = True
      ToolBox.DiagramSelector = True
      object dgOperDate_CarInfo_str: TcxGridDBChartDataGroup
        DataBinding.FieldName = 'OperDate_CarInfo_str'
        DisplayText = #1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080
      end
      object grDayOfWeekName_CarInfo: TcxGridDBChartDataGroup
        DataBinding.FieldName = 'DayOfWeekName_CarInfo'
        DisplayText = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
      end
      object serCount_Partner: TcxGridDBChartSeries
        DataBinding.FieldName = 'Count_Partner'
        DisplayText = #1048#1090#1086#1075#1086' '#1058#1058
      end
      object serCount_Doc: TcxGridDBChartSeries
        DataBinding.FieldName = 'Count_Doc'
        DisplayText = #1048#1090#1086#1075#1086' '#1044#1086#1082'.'
      end
      object serAmountWeight: TcxGridDBChartSeries
        DataBinding.FieldName = 'AmountWeight'
        DisplayText = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086', '#1074#1077#1089
      end
    end
    object grChartLevel1: TcxGridLevel
      GridView = grChartDBChartView1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesTo
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 519
    Top = 231
    object actRefresh_Goods: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1090#1086#1074#1072#1088#1072#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh_Car: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1076#1072#1090#1077' '#1086#1090#1075#1088#1091#1079#1082#1080
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_OrderExternal_UpdateDialogForm'
      FormNameParam.Value = 'TReport_OrderExternal_UpdateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDate_CarInfo'
          Value = Null
          Component = edIsDate_CarInfo
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbisGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'TOrderExternalForm'
      FormNameParam.Value = 'TOrderExternalForm'
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementCheck: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementCheck
      StoredProcList = <
        item
          StoredProc = getMovementCheck
        end>
      Caption = 'actMovementCheck'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementCheck
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      ImageIndex = 28
    end
    object actOpenChoiceCarInfoForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'CarInfoForm'
      FormName = 'TCarInfoForm'
      FormNameParam.Value = 'TCarInfoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CarInfoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CarInfoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdate_CarInfo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_CarInfo_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082'?'
      InfoAfterExecute = #1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082
      ImageIndex = 30
    end
    object macUpdate_CarInfo_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CarInfo
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_CarInfo_list'
    end
    object actUpdate_CarInfo_grid: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CarInfo_grid
      StoredProcList = <
        item
          StoredProc = spUpdate_CarInfo_grid
        end>
      Caption = 'actUpdate_CarInfo'
    end
    object actUpdate_CarInfo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CarInfo
      StoredProcList = <
        item
          StoredProc = spUpdate_CarInfo
        end>
      Caption = 'actUpdate_CarInfo'
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CarInfo_grid
      StoredProcList = <
        item
          StoredProc = spUpdate_CarInfo_grid
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actOrderExternal_byReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      FormName = 'TOrderExternalJournal_byReportForm'
      FormNameParam.Value = 'TOrderExternalJournal_byReportForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDatePartner'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inToId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRouteId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoods
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoods
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077'>'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077'>'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = HeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'GroupPrint'
        end
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;OperDate_CarInfo;RouteName;RetailName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_Update'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = Null
        Component = edIsDate_CarInfo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = Null
        Component = cbisGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 408
    Top = 272
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOrderExternal_byReport'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_CarInfo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = mactOpenDocument
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
    end
    object bbUpdate_CarInfo: TdxBarButton
      Action = macUpdate_CarInfo
      Category = 0
    end
    object bbOrderExternal_byReport: TdxBarButton
      Action = actOrderExternal_byReport
      Category = 0
      ImageIndex = 26
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintGoods: TdxBarButton
      Action = actPrintGoods
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 696
    Top = 136
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 240
    Top = 65528
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
        Component = GuidesTo
      end
      item
      end
      item
      end
      item
      end>
    Left = 592
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = 'TOrderExternalForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 178
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 671
    Top = 12
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 288
    Top = 256
  end
  object ItemsCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 288
    Top = 312
  end
  object getMovementCheck: TdsdStoredProc
    StoredProcName = 'gpGet_MovementCheck'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 248
  end
  object spUpdate_CarInfo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_CarInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Days'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTimes'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Times'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarInfoName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarInfoName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 304
  end
  object spUpdate_CarInfo_grid: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_CarInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate_CarInfo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_CarInfo'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDayName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DayOfWeekName_CarInfo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Days'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTimes'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Times'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarInfoName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarInfoName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 232
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdatePrint'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = ItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = ''
        Component = edIsDate_CarInfo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 832
    Top = 184
  end
  object spSelectPrintGoods: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsPrint'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsDate_CarInfo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 832
    Top = 240
  end
end
