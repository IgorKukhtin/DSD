inherited PeriodClose_UserForm: TPeriodClose_UserForm
  Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1083#1103' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103')'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUserForm
                Default = True
                Kind = bkEllipsis
              end>
            Options.Editing = False
            Width = 65
          end
          object colRoleName: TcxGridDBColumn
            Caption = #1056#1086#1083#1100
            DataBinding.FieldName = 'RoleName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actRoleForm
                Default = True
                Kind = bkEllipsis
              end>
            Options.Editing = False
            Width = 65
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUnitForm
                Default = True
                Kind = bkEllipsis
              end>
            Options.Editing = False
            Width = 65
          end
          object colCloseDate: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1079#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'CloseDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Width = 65
          end
          object colPeriod: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Period'
            Width = 65
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actUserForm: TOpenChoiceForm
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
          ComponentItem = 'UserId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RoleName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnitForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitForm'
      FormName = 'TUnitForm'
      FormNameParam.Value = 'TUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserId'
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
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
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
      end>
    PackSize = 1
    Left = 152
    Top = 112
  end
end
