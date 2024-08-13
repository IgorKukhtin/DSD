inherited Report_UserProtocolForm: TReport_UserProtocolForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1087#1088#1086#1090#1086#1082#1086#1083#1091' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081'>'
  ClientHeight = 552
  ClientWidth = 1115
  ParentFont = True
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1131
  ExplicitHeight = 591
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 86
    Width = 1115
    Height = 466
    TabOrder = 3
    ExplicitTop = 86
    ExplicitWidth = 887
    ExplicitHeight = 466
    ClientRectBottom = 466
    ClientRectRight = 1115
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 887
      ExplicitHeight = 466
      inherited cxGrid: TcxGrid
        Width = 1115
        Height = 200
        ExplicitWidth = 887
        ExplicitHeight = 200
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Mov_Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MI_Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_Prog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_Work
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_status
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Mov_Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MI_Count
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UserName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_Prog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_Work
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_status
            end>
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object UserStatus: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1080#1085#1092#1086#1088#1084'.)'
            DataBinding.FieldName = 'UserStatus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' ('#1080#1085#1092#1086#1088#1084'.)'
            DataBinding.FieldName = 'DayOfWeekName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDate_Last: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1080#1085#1092#1086#1088#1084'.)'
            DataBinding.FieldName = 'OperDate_Last'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UserCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object UserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 149
          end
          object Time_Prog: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1095'. ('#1087#1086' '#1074#1093'/'#1074#1099#1093')'
            DataBinding.FieldName = 'Time_Prog'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DisplayFormat = 'hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1072#1073#1086#1095#1080#1093' '#1095#1072#1089#1086#1074' - '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1074#1093#1086#1076#1072' '#1080' '#1074#1099#1093#1086#1076#1072' '#1080#1079' ' +
              #1087#1088#1086#1075#1088#1072#1084#1084#1099
            Width = 75
          end
          object Time_Work: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1095'. ('#1087#1086' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'Time_Work'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DisplayFormat = 'hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1072#1073#1086#1095#1080#1093' '#1095#1072#1089#1086#1074' - '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1077#1088#1074#1086#1075#1086' '#1080' '#1087#1086#1089#1083#1077#1076#1085#1077 +
              #1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
            Width = 70
          end
          object Count_Prog: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1095'. ('#1087#1086' '#1074#1093'/'#1074#1099#1093')'
            DataBinding.FieldName = 'Count_Prog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1072#1073#1086#1095#1080#1093' '#1095#1072#1089#1086#1074' - '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1074#1093#1086#1076#1072' '#1080' '#1074#1099#1093#1086#1076#1072' '#1080#1079' ' +
              #1087#1088#1086#1075#1088#1072#1084#1084#1099
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object Count_Work: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1095'. ('#1087#1086' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'Count_Work'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1072#1073#1086#1095#1080#1093' '#1095#1072#1089#1086#1074' - '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1077#1088#1074#1086#1075#1086' '#1080' '#1087#1086#1089#1083#1077#1076#1085#1077 +
              #1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Count: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1081' ('#1073#1077#1079' '#1089#1090#1072#1090#1091#1089#1072')'
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1081' ('#1073#1077#1079' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1090#1072#1090#1091#1089#1072' '#1076#1086#1082')'
            Options.Editing = False
            Width = 70
          end
          object Count_status: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1081' ('#1089#1090#1072#1090#1091#1089')'
            DataBinding.FieldName = 'Count_status'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1081' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1076#1086#1082')'
            Options.Editing = False
            Width = 85
          end
          object Mov_Count: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082'.'
            DataBinding.FieldName = 'Mov_Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MI_Count: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
            DataBinding.FieldName = 'MI_Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
            Options.Editing = False
            Width = 55
          end
          object OperDate_Entry: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1074#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDate_Entry'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'hh:mm:ss'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_Exit: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1074#1099#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDate_Exit'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'hh:mm:ss'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_Start: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1087#1077#1088#1074#1086#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1103
            DataBinding.FieldName = 'OperDate_Start'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'hh:mm:ss'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_End: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1087#1086#1089#1083#1077#1076'. '#1076#1077#1081#1089#1090#1074#1080#1103
            DataBinding.FieldName = 'OperDate_End'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'hh:mm:ss'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 152
          end
          object MemberName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1100')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Color_Calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Calc'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
      object grChart: TcxGrid
        Left = 0
        Top = 208
        Width = 1115
        Height = 258
        Align = alBottom
        TabOrder = 1
        ExplicitWidth = 887
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramColumn.Active = True
          DiagramColumn.Legend.Border = lbNone
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgOperDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object dgUserName: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'UserName'
            DisplayText = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          end
          object serCount: TcxGridDBChartSeries
            DataBinding.FieldName = 'Count'
            DisplayText = #1048#1090#1086#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1081
          end
          object serCount_status: TcxGridDBChartSeries
            DataBinding.FieldName = 'Count_status'
            DisplayText = #1048#1079#1084'. '#1089#1090#1072#1090#1091#1089#1072' '#1076#1086#1082'.'
          end
          object serMov_Count: TcxGridDBChartSeries
            DataBinding.FieldName = 'Mov_Count'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
          end
          object serMI_Count: TcxGridDBChartSeries
            DataBinding.FieldName = 'MI_Count'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
          end
          object serCount_Prog: TcxGridDBChartSeries
            DataBinding.FieldName = 'Count_Prog'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' ('#1087#1086' '#1074#1093'/'#1074#1099#1093')'
          end
          object serCount_Work: TcxGridDBChartSeries
            DataBinding.FieldName = 'Count_Work'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' ('#1087#1086' '#1076#1086#1082'.)'
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 200
        Width = 1115
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
        ExplicitWidth = 887
      end
    end
  end
  inherited Panel: TPanel
    Width = 1115
    Height = 60
    ExplicitLeft = 24
    ExplicitTop = -15
    ExplicitWidth = 1115
    ExplicitHeight = 60
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 42614d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      EditValue = 42614d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 27
      ExplicitLeft = 27
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 217
      Top = 33
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 306
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 207
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 259
    Top = 6
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit [3]
    Left = 306
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 207
  end
  object cxLabel5: TcxLabel [4]
    Left = 531
    Top = 6
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
  end
  object edUser: TcxButtonEdit [5]
    Left = 612
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 218
  end
  object cbisDay: TcxCheckBox [6]
    Left = 531
    Top = 32
    Action = actRefreshIsDay
    TabOrder = 10
    Width = 70
  end
  object cbisShowAll: TcxCheckBox [7]
    Left = 610
    Top = 32
    Action = actRefreshShowAll
    TabOrder = 11
    Width = 98
  end
  object cxLabel6: TcxLabel [8]
    Left = 714
    Top = 33
    Caption = #1054#1090#1082#1083'. '#1084#1080#1085'.'
  end
  object ceDiff: TcxCurrencyEdit [9]
    Left = 774
    Top = 32
    EditValue = 10.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 13
    Width = 56
  end
  object cxLabel7: TcxLabel [10]
    Left = 837
    Top = 6
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
  end
  object edPosition: TcxButtonEdit [11]
    Left = 908
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 199
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
        Component = GuidesBranch
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUser
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbisDay
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbisShowAll
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    object actRefreshShowAll: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077
      Hint = #1087#1086' '#1044#1085#1103#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsDay: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_UserProtocolDialogForm'
      FormNameParam.Value = 'TReport_UserProtocolDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
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
          Name = 'BranchId'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
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
        end
        item
          Name = 'UserId'
          Value = Null
          Component = GuidesUser
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UserName'
          Value = Null
          Component = GuidesUser
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDay'
          Value = Null
          Component = cbisDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isShowAll'
          Value = Null
          Component = cbisShowAll
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Diff'
          Value = Null
          Component = ceDiff
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = GuidesPosition
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = GuidesPosition
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1076#1085#1103#1084
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1076#1085#1103#1084
      ImageIndex = 24
      FormName = 'TReport_UserProtocolViewForm'
      FormNameParam.Value = 'TReport_UserProtocolViewForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
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
          Name = 'BranchId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UserId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'UserId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UserName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDay'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_UserProtocol'
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
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay'
        Value = True
        Component = cbisDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = cbisShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiff'
        Value = Null
        Component = ceDiff
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'bbDialog'
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
          ItemName = 'bbOpenReport'
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
    object bbDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenReport: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = Color_Calc
        ColorValueList = <>
      end>
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 96
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesBranch
      end
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesUser
      end
      item
        Component = ceDiff
      end
      item
        Component = GuidesPosition
      end>
    Left = 216
    Top = 184
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
    Left = 392
    Top = 16
  end
  object GuidesUser: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUser_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUser_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 720
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 65527
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'BranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDay'
        Value = Null
        Component = cbisDay
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 488
    Top = 184
  end
  object GuidesPosition: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 968
    Top = 11
  end
end
