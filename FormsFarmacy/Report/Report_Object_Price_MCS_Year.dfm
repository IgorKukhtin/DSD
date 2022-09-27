inherited Report_Object_Price_MCS_YearForm: TReport_Object_Price_MCS_YearForm
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1103' '#1053#1058#1047' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1089' '#1075#1086#1076#1086#1084' '#1085#1072#1079#1072#1076
  ClientHeight = 359
  ClientWidth = 820
  AddOnFormData.Params = FormParams
  ExplicitWidth = 836
  ExplicitHeight = 398
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 67
    Width = 820
    Height = 292
    TabOrder = 3
    ExplicitTop = 67
    ExplicitWidth = 683
    ExplicitHeight = 292
    ClientRectBottom = 292
    ClientRectRight = 820
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 683
      ExplicitHeight = 292
      inherited cxGrid: TcxGrid
        Width = 820
        Height = 292
        ExplicitWidth = 683
        ExplicitHeight = 292
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
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
              Column = Remains
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 248
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Remains: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1086#1089#1090#1072#1090#1086#1082')'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object MCSValue: TcxGridDBColumn
            Caption = #1053#1058#1047' '#1090#1077#1082#1091#1097#1080#1081
            DataBinding.FieldName = 'MCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1080
            Options.Editing = False
            Width = 82
          end
          object MCSValueYear: TcxGridDBColumn
            Caption = #1053#1058#1047' '#1075#1086#1076' '#1085#1072#1079#1072#1076
            DataBinding.FieldName = 'MCSValueYear'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MCSValueProc: TcxGridDBColumn
            Caption = '% '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'MCSValueProc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object MCSValueMax: TcxGridDBColumn
            Caption = #1053#1058#1047' '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'MCSValueMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object MCSValueNew: TcxGridDBColumn
            Caption = #1053#1086#1074#1086#1077' '#1053#1058#1047
            DataBinding.FieldName = 'MCSValueNew'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 820
    Height = 41
    ExplicitWidth = 683
    ExplicitHeight = 41
    inherited deStart: TcxDateEdit
      Left = 790
      Top = 1
      Visible = False
      ExplicitLeft = 790
      ExplicitTop = 1
      ExplicitWidth = 34
      Width = 34
    end
    inherited deEnd: TcxDateEdit
      Left = 790
      Top = 28
      Visible = False
      ExplicitLeft = 790
      ExplicitTop = 28
      ExplicitWidth = 33
      Width = 33
    end
    inherited cxLabel1: TcxLabel
      Left = 693
      Visible = False
      ExplicitLeft = 693
    end
    inherited cxLabel2: TcxLabel
      Left = 674
      Top = 29
      Visible = False
      ExplicitLeft = 674
      ExplicitTop = 29
    end
    object cxLabel4: TcxLabel
      Left = 15
      Top = 9
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 101
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 301
    end
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Object_Price_MCS_YearDialogForm'
      FormNameParam.Value = 'TReport_Object_Price_MCS_YearDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDetail'
          Value = Null
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object mactCopyMCSValueYear: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCopyMCSValueYear
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1075#1086#1076' '#1085#1072#1079#1076' '#1074' '#1085#1086#1074#1086#1077'?'
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1075#1086#1076' '#1085#1072#1079#1076' '#1074' '#1085#1086#1074#1086#1077
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1075#1086#1076' '#1085#1072#1079#1076' '#1074' '#1085#1086#1074#1086#1077
      ImageIndex = 30
    end
    object actCopyMCSValueYear: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'MCSValueYear'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'MCSValueNew'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      Caption = 'actCopyMCSValueYear'
      DefaultParams = <>
    end
    object mactUpdate_MCS_ReportDay: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_MCS_ReportDay
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1053#1058#1047' '#1085#1086#1074#1086#1077' '#1085#1072' '#1087#1077#1088#1080#1086#1076' - 7 '#1076#1085#1077#1081'?'
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1053#1058#1047' '#1085#1086#1074#1086#1077' '#1085#1072' '#1087#1077#1088#1080#1086#1076' - 7 '#1076#1085#1077#1081
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1053#1058#1047' '#1085#1086#1074#1086#1077' '#1085#1072' '#1087#1077#1088#1080#1086#1076' - 7 '#1076#1085#1077#1081
      ImageIndex = 78
    end
    object actUpdate_MCS_ReportDay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MCS_ReportDay
      StoredProcList = <
        item
          StoredProc = spUpdate_MCS_ReportDay
        end>
      Caption = 'actUpdate_MCS_ReportDay'
    end
  end
  inherited MasterDS: TDataSource
    Top = 136
  end
  inherited MasterCDS: TClientDataSet
    Top = 136
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Object_Price_MCS_Year'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 136
  end
  inherited BarManager: TdxBarManager
    Top = 136
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
    object bbOpenReportForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object dxBarButton1: TdxBarButton
      Action = mactCopyMCSValueYear
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = mactUpdate_MCS_ReportDay
      Caption = #1048#1079#1079#1084#1077#1085#1080#1090' '#1053#1058#1047' '#1085#1072' '#1085#1086#1074#1086#1077' '
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end
      item
      end>
    Left = 376
    Top = 144
  end
  inherited PopupMenu: TPopupMenu
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 200
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end>
    Left = 144
    Top = 200
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 8
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 144
  end
  object spUpdate_MCS_ReportDay: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Price_MCS_ReportDay'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSValueNew'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 232
  end
end
