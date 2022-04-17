inherited PeriodCloseForm: TPeriodCloseForm
  Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1083#1103' '#1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072')'
  ClientHeight = 306
  ClientWidth = 894
  ExplicitWidth = 910
  ExplicitHeight = 345
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 894
    Height = 248
    ExplicitTop = 58
    ExplicitWidth = 798
    ExplicitHeight = 248
    ClientRectBottom = 248
    ClientRectRight = 894
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      ExplicitHeight = 248
      inherited cxGrid: TcxGrid
        Width = 894
        Height = 248
        ExplicitWidth = 798
        ExplicitHeight = 248
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsCustomize.DataRowSizing = False
          OptionsData.Appending = True
          OptionsData.Inserting = True
          OptionsView.CellAutoHeight = True
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
          object Name: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object CloseDate: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1079#1072#1082#1088#1099#1090' '#1076#1086
            DataBinding.FieldName = 'CloseDate'
            PropertiesClassName = 'TcxDateEditProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CloseDate_store: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1079#1072#1082#1088#1099#1090' '#1076#1086' ('#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'CloseDate_store'
            PropertiesClassName = 'TcxDateEditProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object Period: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1079#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072', '#1082#1086#1083'-'#1074#1086' '#1076#1085'.'
            DataBinding.FieldName = 'Period'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object isUserName: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
            DataBinding.FieldName = 'isUserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UserCode_excl: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1083#1100#1079'. - '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'UserCode_excl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object UserName_excl: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' - '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'UserName_excl'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUserForm_excl
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object UserByGroupCode_excl: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1075#1088'.'#1087#1086#1083#1100#1079'. - '#1048#1089#1082#1083'.'
            DataBinding.FieldName = 'UserByGroupCode_excl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1043#1088#1091#1087#1087#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' - '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077
            Width = 80
          end
          object UserByGroupName_excl: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1083#1100#1079'. - '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'UserByGroupName_excl'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUserByGroupForm_excl
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' - '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077
            Width = 105
          end
          object CloseDate_excl: TcxGridDBColumn
            Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1089
            DataBinding.FieldName = 'CloseDate_excl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescId: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1042#1044
            DataBinding.FieldName = 'DescId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
          object DescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object DescId_excl: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1042#1044'-'#1048
            DataBinding.FieldName = 'DescId_excl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object DescName_excl: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' - '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'DescName_excl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UserName_list: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' - '#1055#1088#1086#1074#1077#1088#1082#1072
            DataBinding.FieldName = 'UserName_list'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object BranchCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092#1080#1083#1080#1072#1083#1072
            DataBinding.FieldName = 'BranchCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBranchForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PaidKindCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1060#1054
            DataBinding.FieldName = 'PaidKindCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1054
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPaidKindForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RoleCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1086#1083#1080' - '#1055#1088#1086#1074#1077#1088#1082#1072
            DataBinding.FieldName = 'RoleCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RoleName: TcxGridDBColumn
            Caption = #1056#1086#1083#1100' - '#1055#1088#1086#1074#1077#1088#1082#1072
            DataBinding.FieldName = 'RoleName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actRoleForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object UserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 894
    Height = 32
    Align = alTop
    TabOrder = 5
    ExplicitWidth = 798
    object deOperDate: TcxDateEdit
      Left = 183
      Top = 5
      EditValue = 42370d
      Properties.DateOnError = deToday
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 90
    end
    object cxLabel1: TcxLabel
      Left = 17
      Top = 6
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1042#1089#1077#1093' '#1076#1086' :'
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deOperDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actRoleForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actRoleForm'
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUserByGroupForm_excl: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUserByGroupForm'
      FormName = 'TUserByGroupForm'
      FormNameParam.Value = 'TUserByGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserByGroupId_excl'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserByGroupCode_excl'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserByGroupName_excl'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUserForm_excl: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserId_excl'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserCode_excl'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName_excl'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBranchForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitForm'
      FormName = 'TBranchForm'
      FormNameParam.Value = 'TBranchForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPaidKindForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitForm'
      FormName = 'TPaidKindForm'
      FormNameParam.Value = 'TPaidKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actUpdate_CloseDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CloseDate
      StoredProcList = <
        item
          StoredProc = spUpdate_CloseDate
        end>
      Caption = 'actUpdate_CloseDate'
      Hint = 'actUpdate_CloseDate'
    end
    object mactUpdate_CloseDate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CloseDate
        end
        item
          Action = actRefresh
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1082#1088#1099#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1042#1089#1077#1093' '#1076#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1076#1072#1090#1099'?'
      InfoAfterExecute = #1059#1088#1072'! '#1055#1077#1088#1080#1086#1076' '#1079#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1042#1089#1077#1093' '#1076#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1076#1072#1090#1099' '
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 38
    end
  end
  inherited MasterDS: TDataSource
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_PeriodClose'
    Left = 88
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Top = 64
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
          ItemName = 'bbUpdate_PeriodClose_all'
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
    object bbUpdate_PeriodClose_all: TdxBarButton
      Action = mactUpdate_CloseDate
      Category = 0
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_PeriodClose'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoleId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoleCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RoleCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserId_excl'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserCode_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserCode_excl'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserByGroupId_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserByGroupId_excl'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserByGroupCode_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserByGroupCode_excl'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DescId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescId_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DescId_excl'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Period'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CloseDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CloseDate_excl'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate_store'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CloseDate_store'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 152
  end
  object spUpdate_CloseDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_PeriodClose_CloseDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate'
        Value = Null
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 200
  end
end
