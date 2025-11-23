inherited Report_StaffListRankingForm: TReport_StaffListRankingForm
  Caption = #1054#1090#1095#1077#1090' <'#1064#1090#1072#1090#1085#1072#1103' '#1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1072'>'
  ClientHeight = 401
  ClientWidth = 998
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1014
  ExplicitHeight = 440
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 79
    Width = 998
    Height = 322
    TabOrder = 3
    ExplicitTop = 79
    ExplicitWidth = 998
    ExplicitHeight = 322
    ClientRectBottom = 322
    ClientRectRight = 998
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 998
      ExplicitHeight = 322
      inherited cxGrid: TcxGrid
        Width = 998
        Height = 322
        ExplicitWidth = 998
        ExplicitHeight = 322
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountPlan
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountFact
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_diff
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = TotalPlan
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = TotalFact
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Total_diff
            end
            item
              Kind = skSum
              Column = AmountFact_add
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PositionName
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountPlan
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountFact
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_diff
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = TotalPlan
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = TotalFact
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Total_diff
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountFact_add
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.CellAutoHeight = True
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isTotal: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'isTotal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1088#1086#1082#1080' '#1080#1090#1086#1075#1086#1074' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 45
          end
          object DepartmentName: TcxGridDBColumn
            Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
            DataBinding.FieldName = 'DepartmentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 130
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 106
          end
          object PositionLevelName: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object PositionPropertyName: TcxGridDBColumn
            Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionPropertyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 131
          end
          object Vacancy: TcxGridDBColumn
            Caption = #1042#1072#1082#1072#1085#1089#1080#1103
            DataBinding.FieldName = 'Vacancy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taRightJustify
            Options.Editing = False
            Width = 72
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 215
          end
          object MemberName_add: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1089#1086#1074#1084'.)'
            DataBinding.FieldName = 'MemberName_add'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1048#1054' '#1089#1086#1074#1084#1077#1089#1090#1080#1090#1077#1083#1080' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Options.Editing = False
            Width = 215
          end
          object AmountPlan: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1064#1056
            DataBinding.FieldName = 'AmountPlan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1064#1056' ('#1087#1086' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1091')'
            Width = 99
          end
          object AmountFact: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1064#1056
            DataBinding.FieldName = 'AmountFact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object AmountFact_add: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1064#1056' +'#1089#1086#1074#1084'.'
            DataBinding.FieldName = 'AmountFact_add'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1064#1056' + '#1089#1086#1074#1084#1077#1089#1090#1080#1090#1077#1083#1080' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Width = 85
          end
          object Amount_diff: TcxGridDBColumn
            Caption = #1044#1077#1083#1100#1090#1072
            DataBinding.FieldName = 'Amount_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object TotalPlan: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1083#1072#1085
            DataBinding.FieldName = 'TotalPlan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object TotalFact: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'TotalFact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object Total_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1076#1077#1083#1100#1090#1072
            DataBinding.FieldName = 'Total_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object Persent_diff: TcxGridDBColumn
            Caption = '% '#1082#1086#1084#1083#1077#1082#1090#1072#1094#1080#1080
            DataBinding.FieldName = 'Persent_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1087#1086' '#1087#1077#1088#1089#1086#1085#1072#1083#1091
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 118
          end
          object StaffHoursDayName: TcxGridDBColumn
            Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'StaffHoursDayName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object StaffHoursName: TcxGridDBColumn
            Caption = #1063#1072#1089#1099' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'StaffHoursName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object Color_vacancy: TcxGridDBColumn
            DataBinding.FieldName = 'Color_vacancy'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_diff: TcxGridDBColumn
            DataBinding.FieldName = 'Color_diff'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_unit: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_unit'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_unit: TcxGridDBColumn
            DataBinding.FieldName = 'Color_unit'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object BoldRecord_unit: TcxGridDBColumn
            DataBinding.FieldName = 'BoldRecord_unit'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 998
    Height = 53
    ExplicitWidth = 998
    ExplicitHeight = 53
    inherited deStart: TcxDateEdit
      Left = 13
      Top = 23
      EditValue = 45658d
      ExplicitLeft = 13
      ExplicitTop = 23
      ExplicitWidth = 91
      Width = 91
    end
    inherited deEnd: TcxDateEdit
      Left = 857
      Top = 23
      EditValue = 45658d
      Visible = False
      ExplicitLeft = 857
      ExplicitTop = 23
      ExplicitWidth = 110
      Width = 110
    end
    inherited cxLabel1: TcxLabel
      Left = 13
      Caption = #1053#1072' '#1076#1072#1090#1091':'
      ExplicitLeft = 13
      ExplicitWidth = 49
    end
    inherited cxLabel2: TcxLabel
      Left = 857
      Visible = False
      ExplicitLeft = 857
    end
    object cxLabel4: TcxLabel
      Left = 114
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 114
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 256
    end
    object cxLabel5: TcxLabel
      Left = 383
      Top = 6
      Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103':'
    end
    object ceDepartment: TcxButtonEdit
      Left = 383
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 256
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
        Component = GuidesDepartment
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1062#1077#1093' '#1076#1077#1083#1080#1082'.'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1062#1077#1093' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxMasterCDS'
          IndexFieldNames = 'UnitId;PersonalServiceListId;MemberName'
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'dateEnd'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_1'
      ReportNameParam.Value = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1062#1077#1093' '#1089'/'#1082
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1062#1077#1093' '#1089'/'#1082')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxMasterCDS'
          IndexFieldNames = 
            'UnitId;PersonalServiceListId;PositionName;PositionLevelName;Memb' +
            'erName'
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'dateEnd'
          Value = 41395d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_2'
      ReportNameParam.Value = #1042#1077#1076#1086#1084#1086#1089#1090#1100'_'#1087#1086'_'#1079#1072#1088#1087#1083#1072#1090#1077'_2'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_StaffListRankingDialogForm'
      FormNameParam.Value = 'TReport_StaffListRankingDialogForm'
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
          Name = 'DepartmentId'
          Value = Null
          Component = GuidesDepartment
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DepartmentName'
          Value = Null
          Component = GuidesDepartment
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPersonalService: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spPersonalService
      StoredProcList = <
        item
          StoredProc = spPersonalService
        end>
      Caption = 'actPersonalService'
    end
    object macPersonalService: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPersonalService
        end>
      View = cxGridDBTableView
      Caption = 
        #1058#1086#1083#1100#1082#1086' '#1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087 +
        #1083#1072#1090#1099'>'
      Hint = 
        #1058#1086#1083#1100#1082#1086' '#1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087 +
        #1083#1072#1090#1099'>'
    end
    object actPersonalServiceErased: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spPersonalServiceErased
      StoredProcList = <
        item
          StoredProc = spPersonalServiceErased
        end>
      Caption = 'actPersonalService'
    end
    object macPersonalServiceErased: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPersonalServiceErased
        end>
      View = cxGridDBTableView
      Caption = #1058#1086#1083#1100#1082#1086' '#1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1058#1086#1083#1100#1082#1086' '#1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
    end
    object macPersonalServiceAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macPersonalServiceErased
        end
        item
          Action = macPersonalService
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085 +
        #1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'> '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      ImageIndex = 41
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 192
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 192
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_StaffListRanking'
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
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
        Name = 'inDepartmentId'
        Value = Null
        Component = GuidesDepartment
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 280
    Top = 192
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
    object dxBarButton1: TdxBarButton
      Action = actPrint1
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPersonalService: TdxBarButton
      Action = macPersonalServiceAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = MemberName
        ValueColumn = Color_vacancy
        ColorValueList = <>
      end
      item
        ColorColumn = Vacancy
        ValueColumn = Color_diff
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_diff
        ValueColumn = Color_diff
        ColorValueList = <>
      end
      item
        ColorColumn = DepartmentName
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = UnitName
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = AmountPlan
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = AmountFact
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = Amount_diff
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = TotalPlan
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = TotalFact
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = Total_diff
        ValueColumn = Color_unit
        ColorValueList = <>
        ValueBoldColumn = BoldRecord_unit
      end
      item
        ColorColumn = isTotal
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = DepartmentName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = PositionName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = PositionLevelName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = PositionPropertyName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = Vacancy
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = MemberName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = MemberName_add
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPlan
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = AmountFact
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = AmountFact_add
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_diff
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = Persent_diff
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = PersonalName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = StaffHoursDayName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = StaffHoursName
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = TotalPlan
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = TotalFact
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end
      item
        ColorColumn = Total_diff
        BackGroundValueColumn = ColorFon_unit
        ColorValueList = <>
      end>
    Left = 488
    Top = 272
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 928
    Top = 24
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
      end
      item
        Component = GuidesDepartment
      end>
    Left = 408
    Top = 200
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 344
    Top = 13
  end
  object GuidesDepartment: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDepartment
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDepartment
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDepartment
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 13
  end
  object spPersonalService: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Child_Auto'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalServiceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelServiceId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ModelServiceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffListSummKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffListSummKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountOnOneMember'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count_Member'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count_Day'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeHoursOne'
        Value = 30.000000000000000000
        Component = MasterCDS
        ComponentItem = 'SheetWorkTime_Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeHours'
        Value = 12.000000000000000000
        Component = MasterCDS
        ComponentItem = 'SUM_MemberHours'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHoursPlan'
        Value = Null
        Component = MasterCDS
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHoursDay'
        Value = Null
        Component = MasterCDS
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalCount'
        Value = Null
        Component = MasterCDS
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGrossOne'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GrossOnOneMember'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KoeffHoursWork_car'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 296
  end
  object spPersonalServiceErased: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Child_Erased'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalServiceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = GuidesDepartment
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 288
  end
end
