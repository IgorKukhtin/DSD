inherited Report_Protocol_ChangeStatusForm: TReport_Protocol_ChangeStatusForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1057#1090#1072#1090#1091#1089#1072' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074'>'
  ClientHeight = 552
  ClientWidth = 1029
  ParentFont = True
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1045
  ExplicitHeight = 591
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 85
    Width = 1029
    Height = 467
    TabOrder = 3
    ExplicitTop = 85
    ExplicitWidth = 1029
    ExplicitHeight = 467
    ClientRectBottom = 467
    ClientRectRight = 1029
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1029
      ExplicitHeight = 467
      inherited cxGrid: TcxGrid
        Width = 1029
        Height = 467
        ExplicitWidth = 1029
        ExplicitHeight = 467
        inherited cxGridDBTableView: TcxGridDBTableView
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
              Format = ',0.###'
              Kind = skSum
            end
            item
              Format = ',0.###'
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
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UserName_1
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
              Format = ',0.###'
              Kind = skSum
            end
            item
              Format = ',0.###'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object MovementId: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object StatusCode_Movement: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode_Movement'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object OperDate_Movement: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate_Movement'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Invnumber_Movement: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'Invnumber_Movement'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object DescName_Movement: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'DescName_Movement'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object StatusCode_1: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' 1'
            DataBinding.FieldName = 'StatusCode_1'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = '1'
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = '2'
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = '3'
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object StatusCode_2: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' 2'
            DataBinding.FieldName = 'StatusCode_2'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object OperDate_Protocol_1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1090#1086#1082#1086#1083' ('#1089#1090#1072#1090#1091#1089' 1)'
            DataBinding.FieldName = 'OperDate_Protocol_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object OperDate_Protocol_2: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1090#1086#1082#1086#1083' ('#1089#1090#1072#1090#1091#1089' 2)'
            DataBinding.FieldName = 'OperDate_Protocol_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UserName_1: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1090#1072#1090#1091#1089' 1)'
            DataBinding.FieldName = 'UserName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object UserName_2: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1090#1072#1090#1091#1089' 2)'
            DataBinding.FieldName = 'UserName_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object MemberName_1: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1089#1090#1072#1090#1091#1089' 1)'
            DataBinding.FieldName = 'MemberName_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object UnitName_1: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1086#1083#1100#1079'. '#1089#1090#1072#1090'.1)'
            DataBinding.FieldName = 'UnitName_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 152
          end
          object PositionName_1: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1087#1086#1083#1100#1079'. '#1089#1090#1072#1090'.1)'
            DataBinding.FieldName = 'PositionName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object MemberName_2: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1089#1090#1072#1090#1091#1089' 2)'
            DataBinding.FieldName = 'MemberName_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object UnitName_2: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1086#1083#1100#1079'. '#1089#1090#1072#1090'.2)'
            DataBinding.FieldName = 'UnitName_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 152
          end
          object PositionName_2: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1087#1086#1083#1100#1079'. '#1089#1090#1072#1090'.2)'
            DataBinding.FieldName = 'PositionName_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object Diff_minute: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072', '#1084#1080#1085'.'
            DataBinding.FieldName = 'Diff_minute'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1084#1077#1078#1076#1091' '#1044#1072#1090#1072#1084#1080' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1057#1090#1072#1090#1091#1089' 1 '#1080' '#1057#1090#1072#1090#1091#1089' 2'
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1029
    Height = 59
    ExplicitWidth = 1029
    ExplicitHeight = 59
    inherited deStart: TcxDateEdit
      Left = 179
      EditValue = 45292d
      Properties.SaveTime = False
      ExplicitLeft = 179
      ExplicitWidth = 80
      Width = 80
    end
    inherited deEnd: TcxDateEdit
      Left = 179
      Top = 32
      EditValue = 45292d
      Properties.SaveTime = False
      ExplicitLeft = 179
      ExplicitTop = 32
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel1: TcxLabel
      Left = 11
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1087#1088#1086#1090#1086#1082#1086#1083'):'
      ExplicitLeft = 11
      ExplicitWidth = 150
    end
    inherited cxLabel2: TcxLabel
      Left = 11
      Top = 32
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1087#1088#1086#1090#1086#1082#1086#1083'):'
      ExplicitLeft = 11
      ExplicitTop = 32
      ExplicitWidth = 169
    end
    object cxLabel4: TcxLabel
      Left = 274
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090'):'
    end
    object edStartDate_mov: TcxDateEdit
      Left = 444
      Top = 5
      EditValue = 45292d
      Properties.ShowTime = False
      TabOrder = 5
      Width = 80
    end
    object cxLabel3: TcxLabel
      Left = 274
      Top = 32
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090'):'
    end
    object edEndDate_mov: TcxDateEdit
      Left = 444
      Top = 32
      EditValue = 45292d
      Properties.ShowTime = False
      TabOrder = 7
      Width = 80
    end
    object cbIsComplete_yes: TcxCheckBox
      Left = 530
      Top = 5
      Caption = #1048#1079#1084#1077#1085#1080#1103' '#1074' '#1089#1090#1072#1090#1091#1089' '#1055#1088#1086#1074#1077#1076#1077#1085
      State = cbsChecked
      TabOrder = 8
      Width = 233
    end
    object cbIsComplete_from: TcxCheckBox
      Left = 530
      Top = 32
      Caption = #1048#1079#1084#1077#1085#1080#1103' '#1089#1086' '#1089#1090#1072#1090#1091#1089#1072' '#1055#1088#1086#1074#1077#1076#1077#1085
      TabOrder = 9
      Width = 233
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 328
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
        Component = edStartDate_mov
        Properties.Strings = (
          'Date')
      end
      item
        Component = edEndDate_mov
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
    Left = 143
    Top = 343
    object actRefreshIsMovement: TdsdDataSetRefresh [0]
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
      FormName = 'TReport_Protocol_ChangeStatusDialogForm'
      FormNameParam.Value = 'TReport_Protocol_ChangeStatusDialogForm'
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
          Name = 'StartDate_mov'
          Value = Null
          Component = edStartDate_mov
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate_mov'
          Value = Null
          Component = edEndDate_mov
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsComplete_yes'
          Value = Null
          Component = cbIsComplete_yes
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsComplete_from'
          Value = Null
          Component = cbIsComplete_from
          DataType = ftBoolean
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
    object actMovementForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actMovementForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenForm'
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate_Movement'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
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
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Invnumber_Movement'
          DataType = ftString
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
    StoredProcName = 'gpReport_Protocol_ChangeStatus'
    Params = <
      item
        Name = 'inStartDate_pr'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate_pr'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate_mov'
        Value = Null
        Component = edStartDate_mov
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate_mov'
        Value = Null
        Component = edEndDate_mov
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsComplete_yes'
        Value = True
        Component = cbIsComplete_yes
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsComplete_from'
        Value = False
        Component = cbIsComplete_from
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 240
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
          ItemName = 'bbOpenDocument'
        end
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
          ItemName = 'bbMovementProtocolOpenForm'
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
    object bbOpenDocument: TdxBarButton
      Action = macOpenDocument
      Category = 0
    end
    object bbMovementProtocolOpenForm: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 96
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 464
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 182
    Top = 184
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
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
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 216
  end
end
