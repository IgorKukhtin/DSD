inherited PersonalGroupMovementForm: TPersonalGroupMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1087#1080#1089#1086#1082' '#1073#1088#1080#1075#1072#1076#1099'>'
  ClientHeight = 426
  ClientWidth = 915
  ExplicitWidth = 931
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 127
    Width = 915
    Height = 299
    ExplicitTop = 127
    ExplicitWidth = 915
    ExplicitHeight = 299
    ClientRectBottom = 299
    ClientRectRight = 915
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 915
      ExplicitHeight = 275
      inherited cxGrid: TcxGrid
        Width = 915
        Height = 275
        ExplicitWidth = 915
        ExplicitHeight = 275
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_Personal
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_Personal
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.Appending = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PersonalCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object PersonalName: TcxGridDBColumn [1]
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 277
          end
          object PositionName: TcxGridDBColumn [2]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPositionChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 213
          end
          object PositionLevelName: TcxGridDBColumn [3]
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
          object PersonalGroupName: TcxGridDBColumn [4]
            Caption = #8470' '#1073#1088#1080#1075#1072#1076#1099
            DataBinding.FieldName = 'PersonalGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object WorkTimeKindCode: TcxGridDBColumn [5]
            Caption = #1050#1086#1076' ('#1090#1080#1087' '#1088#1072#1073'. '#1074#1088#1077#1084#1077#1085#1080')'
            DataBinding.FieldName = 'WorkTimeKindCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object WorkTimeKindName: TcxGridDBColumn [6]
            Caption = #1058#1080#1087' '#1088#1072#1073'. '#1074#1088#1077#1084#1077#1085#1080
            DataBinding.FieldName = 'WorkTimeKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actWorkTimeKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1080#1087' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
            Width = 93
          end
          object Amount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Count_Personal: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086#1090#1088'.'
            DataBinding.FieldName = 'Count_Personal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
            Options.Editing = False
            Width = 55
          end
          object UnitName_inf: TcxGridDBColumn [9]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'UnitName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            Options.Editing = False
            Width = 92
          end
          object PositionName_inf: TcxGridDBColumn [10]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PositionName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            Options.Editing = False
            Width = 100
          end
          object Comment: TcxGridDBColumn [11]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object DateOut: TcxGridDBColumn [12]
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object isMain: TcxGridDBColumn [13]
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            Width = 80
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 915
    Height = 101
    TabOrder = 3
    ExplicitWidth = 915
    ExplicitHeight = 101
    inherited edInvNumber: TcxTextEdit
      Left = 9
      ExplicitLeft = 9
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 9
      ExplicitLeft = 9
    end
    inherited edOperDate: TcxDateEdit
      Left = 90
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 90
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel2: TcxLabel
      Left = 90
      ExplicitLeft = 90
    end
    inherited cxLabel15: TcxLabel
      Left = 9
      Top = 45
      ExplicitLeft = 9
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Left = 9
      Top = 62
      ExplicitLeft = 9
      ExplicitTop = 62
      ExplicitWidth = 161
      ExplicitHeight = 22
      Width = 161
    end
    object cxLabel3: TcxLabel
      Left = 320
      Top = 44
      Caption = #1042#1080#1076' '#1089#1084#1077#1085#1099
    end
    object edPairDay: TcxButtonEdit
      Left = 320
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 193
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 176
    Top = 5
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit [3]
    Left = 176
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 337
  end
  object cxLabel6: TcxLabel [4]
    Left = 176
    Top = 44
    Caption = #1041#1088#1080#1075#1072#1076#1072' '#8470
  end
  object edPersonalGroup: TcxButtonEdit [5]
    Left = 176
    Top = 62
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 137
  end
  object edInsertName: TcxButtonEdit [6]
    Left = 532
    Top = 62
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 185
  end
  object cxLabel7: TcxLabel [7]
    Left = 532
    Top = 44
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
  end
  object cxLabel8: TcxLabel [8]
    Left = 532
    Top = 5
    Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
  end
  object edInsertDate: TcxDateEdit [9]
    Left = 532
    Top = 23
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 130
  end
  object edUpdateName: TcxButtonEdit [10]
    Left = 723
    Top = 62
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 185
  end
  object cxLabel4: TcxLabel [11]
    Left = 723
    Top = 44
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
  end
  object edUpdateDate: TcxDateEdit [12]
    Left = 723
    Top = 23
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 130
  end
  object cxLabel9: TcxLabel [13]
    Left = 723
    Top = 5
    Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 779
    Top = 288
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 175
    object actRefreshMI: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spInsert_MI
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_PersonalGroup'
      ReportNameParam.Value = 'PrintMovement_PersonalGroup'
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actWorkTimeKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Partner_ObjectForm'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = 'TWorkTimeKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WorkTimeKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WorkTimeKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WorkTimeKindCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPositionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Partner_ObjectForm'
      FormName = 'TPositionMember_ObjectForm'
      FormNameParam.Value = 'TPositionMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterMemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterMemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPersonalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Partner_ObjectForm'
      FormName = 'TPersonalUnit_ObjectForm'
      FormNameParam.Value = 'TPersonalUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actPersonalChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082#1072'>'
      ShortCut = 45
      ImageIndex = 0
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 248
  end
  inherited MasterCDS: TClientDataSet
    Left = 72
    Top = 256
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PersonalGroup'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 159
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnEnterList = <
      item
        Column = PersonalName
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 808
    Top = 224
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 192
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PersonalGroup'
    Left = 40
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalGroup'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PairDayId'
        Value = ''
        Component = GuidesPairDay
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PairDayName'
        Value = ''
        Component = GuidesPairDay
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = 0.000000000000000000
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = edUpdateName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = Null
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 208
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PersonalGroup'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
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
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPairDayId'
        Value = Null
        Component = GuidesPairDay
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    AutoWidth = True
    Left = 258
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesUnit
      end
      item
        Guides = GuidesPersonalGroup
      end
      item
        Guides = GuidesPairDay
      end>
    Left = 152
    Top = 152
  end
  inherited HeaderSaver: THeaderSaver
    IdParam.Value = '0'
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edUnit
      end
      item
        Control = edPersonalGroup
      end
      item
        Control = edPairDay
      end>
    Left = 264
    Top = 321
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 352
    Top = 336
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PersonalGroup_SetErased'
    Left = 702
    Top = 192
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PersonalGroup_SetUnErased'
    Left = 638
    Top = 208
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PersonalGroup'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
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
        Name = 'inWorkTimeKindCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWorkTimeKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWorkTimeKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PersonalGroup'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescription'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'Description'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 612
    Top = 324
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
      end
      item
        Component = edPairDay
      end>
    Left = 364
    Top = 112
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 660
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalGroup_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 431
    Top = 168
  end
  object GuidesPersonalGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalGroup
    isShowModal = True
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 220
    Top = 64
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    isShowModal = True
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
    Left = 380
    Top = 16
  end
  object spInsert_MI: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_PersonalGroup'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 344
  end
  object GuidesPairDay: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPairDay
    isShowModal = True
    FormNameParam.Value = 'TPairDayForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPairDayForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPairDay
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPairDay
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 412
    Top = 56
  end
end
