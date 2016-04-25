inherited PeriodCloseForm: TPeriodCloseForm
  Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1083#1103' '#1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072')'
  ClientWidth = 798
  ExplicitLeft = -8
  ExplicitWidth = 814
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 798
    ExplicitWidth = 798
    ClientRectRight = 798
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 798
        ExplicitWidth = 798
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
          object Period: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1079#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072', '#1082#1086#1083'-'#1074#1086' '#1076#1085'.'
            DataBinding.FieldName = 'Period'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object isUserName: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1042#1057#1045#1061' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
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
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleName'
          DataType = ftString
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserId_excl'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserCode_excl'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName_excl'
          DataType = ftString
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
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
      end
      item
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inRoleId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
      end
      item
        Name = 'inRoleCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RoleCode'
        ParamType = ptInput
      end
      item
        Name = 'inUserId_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserId_excl'
        ParamType = ptInput
      end
      item
        Name = 'inUserCode_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserCode_excl'
        ParamType = ptInput
      end
      item
        Name = 'inDescId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DescId'
        ParamType = ptInput
      end
      item
        Name = 'inDescId_excl'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DescId_excl'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchCode'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindCode'
        ParamType = ptInput
      end
      item
        Name = 'inPeriod'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Period'
        ParamType = ptInput
      end
      item
        Name = 'inCloseDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'CloseDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inCloseDate_excl'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'CloseDate_excl'
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 152
    Top = 112
  end
end
