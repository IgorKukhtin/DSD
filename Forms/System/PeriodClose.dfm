inherited PeriodCloseForm: TPeriodCloseForm
  Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1083#1103' '#1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072')'
  ExplicitWidth = 591
  ExplicitHeight = 343
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
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
      Caption = 'actUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'UserId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actRoleForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actRoleForm'
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'RoleId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'RoleName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actUnitForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actUnitForm'
      FormName = 'TUnitForm'
      FormNameParam.Value = 'TUnitForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
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
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_PeriodClose'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inUserId'
        Component = MasterCDS
        ComponentItem = 'UserId'
        ParamType = ptInput
      end
      item
        Name = 'inRoleId'
        Component = MasterCDS
        ComponentItem = 'RoleId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inPeriod'
        Component = MasterCDS
        ComponentItem = 'Period'
        ParamType = ptInput
      end
      item
        Name = 'inCloseDate'
        Component = MasterCDS
        ComponentItem = 'CloseDate'
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 152
    Top = 112
  end
end
