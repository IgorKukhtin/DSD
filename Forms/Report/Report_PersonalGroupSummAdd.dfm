inherited Report_PersonalGroupSummAddForm: TReport_PersonalGroupSummAddForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1077#1084#1080#1103' '#1051#1091#1095#1096#1077#1081' '#1073#1088#1080#1075#1072#1076#1099'>'
  ClientHeight = 319
  ClientWidth = 819
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 835
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 819
    Height = 262
    TabOrder = 3
    ExplicitWidth = 819
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 819
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 819
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 819
        Height = 262
        ExplicitWidth = 819
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = SummAdd
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Hour_work
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = SummAdd_PersonalService
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = SummAdd
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Hour_work
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = SummAdd_PersonalService
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 99
          end
          object MemberCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1092#1080#1079'. '#1083#1080#1094#1086')'
            DataBinding.FieldName = 'MemberCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 61
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1080#1079'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 199
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 152
          end
          object PositionLevelName: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1088#1103#1076
            Width = 80
          end
          object PersonalGroupName: TcxGridDBColumn
            Caption = #1041#1088#1080#1075#1072#1076#1072
            DataBinding.FieldName = 'PersonalGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object NormHour: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1074#1088#1077#1084#1077#1085#1080
            DataBinding.FieldName = 'NormHour'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1080#1079' '#1076#1086#1082'. '#1055#1088#1077#1084#1080#1080
            Options.Editing = False
            Width = 83
          end
          object isSkip: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1091#1083' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isSkip'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Hour_work: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'Hour_work'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1086#1090#1088#1072#1073#1086#1090#1072#1085#1085#1099#1093' '#1095#1072#1089#1086#1074
            Width = 80
          end
          object Day_skip: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1091#1083', '#1076#1085'.'
            DataBinding.FieldName = 'Day_skip'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1086#1075#1091#1083#1086#1074
            Width = 70
          end
          object SummAdd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'SummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumber_PersonalService: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'InvNumber_PersonalService'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 149
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' ('#1075#1083#1072#1074#1085#1072#1103')'
            DataBinding.FieldName = 'PersonalServiceListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 161
          end
          object SummAdd_PersonalService: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080' ('#1076#1086#1082'. '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'SummAdd_PersonalService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 819
    ExplicitWidth = 819
    inherited deStart: TcxDateEdit
      Left = 112
      EditValue = 45292d
      Properties.AssignedValues.EditFormat = True
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      ExplicitLeft = 112
      ExplicitWidth = 93
      Width = 93
    end
    inherited deEnd: TcxDateEdit
      Left = 886
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 886
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1083#1077#1085#1080#1081':'
      ExplicitWidth = 96
    end
    inherited cxLabel2: TcxLabel
      Left = 776
      Visible = False
      ExplicitLeft = 776
    end
    object cxLabel4: TcxLabel
      Left = 241
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 332
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 225
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PersonalGroupSummAddDialogForm'
      FormNameParam.Value = 'TReport_PersonalGroupSummAddDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenFormPersonalService: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
      ImageIndex = 26
      FormName = 'TPersonalServiceForm'
      FormNameParam.Value = 'TPersonalServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'MovementId_PersonalService'
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
          Name = 'inOperDate'
          Value = 42094d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateMISummAdd: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMISummAdd
      StoredProcList = <
        item
          StoredProc = spUpdateMISummAdd
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080' '#1074' '#1042#1077#1076#1086#1084#1086#1089#1090#1100
      ImageIndex = 30
    end
    object mactUpdateMISummAdd_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMISummAdd
        end>
      View = cxGridDBTableView
      Caption = 'mactUpdateMISummAdd_list'
      ImageIndex = 30
    end
    object mactUpdateMISummAdd: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdateMISummAdd_list
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1089#1090#1080' '#1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080' '#1074' '#1042#1077#1076#1086#1084#1086#1089#1090#1100'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = 'mactUpdateMISummAdd_list'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080' '#1074' '#1042#1077#1076#1086#1084#1086#1089#1090#1100
      ImageIndex = 30
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
    StoredProcName = 'gpReport_PersonalGroupSummAdd'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
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
          ItemName = 'bbUpdateMISummAdd'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormPersonalService'
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
    object bbOpenFormPersonalService: TdxBarButton
      Action = actOpenFormPersonalService
      Category = 0
    end
    object bbUpdateMISummAdd: TdxBarButton
      Action = mactUpdateMISummAdd
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 432
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end>
    Left = 184
    Top = 136
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
        DataType = ftString
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
    Left = 440
    Top = 8
  end
  object spUpdateMISummAdd: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_SummAdd'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MI_Id_PersonalService'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAdd'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'SummAdd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 498
    Top = 168
  end
end
