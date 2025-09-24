inherited Report_StaffListMember_byPersonalForm: TReport_StaffListMember_byPersonalForm
  Caption = #1054#1090#1095#1077#1090'  <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077'/'#1084#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')>'
  ClientHeight = 401
  ClientWidth = 998
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
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 130
          end
          object DateIn: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object DateSend: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1074#1086#1076#1072
            DataBinding.FieldName = 'DateSend'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DateOut: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object isDateOut: TcxGridDBColumn
            Caption = #1059#1074#1086#1083#1077#1085
            DataBinding.FieldName = 'isDateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            Options.Editing = False
            Width = 90
          end
          object PositionLevelName: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object UnitName_old: TcxGridDBColumn
            Caption = '***'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072
            Options.Editing = False
            Width = 106
          end
          object PositionName_old: TcxGridDBColumn
            Caption = '***'#1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072
            Options.Editing = False
            Width = 90
          end
          object PositionLevelName_old: TcxGridDBColumn
            Caption = '***'#1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080' '#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072
            Options.Editing = False
            Width = 80
          end
          object isOfficial: TcxGridDBColumn
            Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object isMain: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 130
          end
          object StaffListKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103' '#1074' '#1096#1090#1072#1090
            DataBinding.FieldName = 'StaffListKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
      Left = 893
      Top = 17
      Visible = False
      ExplicitLeft = 893
      ExplicitTop = 17
      ExplicitWidth = 91
      Width = 91
    end
    inherited deEnd: TcxDateEdit
      Left = 939
      Top = 23
      Visible = False
      ExplicitLeft = 939
      ExplicitTop = 23
      ExplicitWidth = 97
      Width = 97
    end
    inherited cxLabel1: TcxLabel
      Left = 893
      Top = 0
      Visible = False
      ExplicitLeft = 893
      ExplicitTop = 0
    end
    inherited cxLabel2: TcxLabel
      Left = 939
      Visible = False
      ExplicitLeft = 939
    end
    object cxLabel3: TcxLabel
      Left = 25
      Top = 0
      Caption = #1060#1080#1079'.'#1051#1080#1094#1086
    end
    object ceMember: TcxButtonEdit
      Left = 25
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 256
    end
    object cbErased: TcxCheckBox
      Left = 303
      Top = 17
      Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      ParentShowHint = False
      ShowHint = False
      State = cbsChecked
      TabOrder = 6
      Visible = False
      Width = 140
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
        Component = GuidesMember
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
      FormName = 'TReport_StaffListDialogForm'
      FormNameParam.Value = 'TReport_StaffListDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelServiceId'
          Value = Null
          Component = GuidesMember
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelServiceName'
          Value = Null
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
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
      StoredProcList = <
        item
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
    StoredProcName = 'gpReport_StaffListMember_byPersonal'
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = cbErased
        DataType = ftBoolean
        ParamType = ptInput
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
  inherited PeriodChoice: TPeriodChoice
    Left = 168
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end
      item
        Component = GuidesMember
      end
      item
      end>
    Left = 408
    Top = 200
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 5
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 288
  end
end
