inherited MarginCategoryLinkForm: TMarginCategoryLinkForm
  Caption = #1057#1074#1103#1079#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1086#1082
  ClientWidth = 507
  ExplicitWidth = 515
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 507
    ExplicitWidth = 507
    ClientRectRight = 507
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 507
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 507
        ExplicitWidth = 507
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colMarginCategoryName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'MarginCategoryName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceMarginCategory
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 145
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceUnit
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 176
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1074#1077#1094
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceJuridical
                Default = True
                Kind = bkEllipsis
              end>
            Width = 133
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
    object actInsertUpdate: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actInsertUpdate'
      DataSource = MasterDS
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1081
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceMarginCategory'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceJuridical: TOpenChoiceForm
      Category = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1081
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceMarginCategory'
      FormName = 'TJuridicalForm'
      FormNameParam.Value = 'TJuridicalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceMarginCategory: TOpenChoiceForm
      Category = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1081
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceMarginCategory'
      FormName = 'TMarginCategoryForm'
      FormNameParam.Value = 'TMarginCategoryForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MarginCategoryId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MarginCategoryName'
          DataType = ftString
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MarginCategoryLink'
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MarginCategoryLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMarginCategoryId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MarginCategoryId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
      end>
    PackSize = 1
    Left = 296
    Top = 88
  end
end
