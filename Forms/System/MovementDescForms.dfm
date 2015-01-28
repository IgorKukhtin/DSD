inherited MovementDescDataForm: TMovementDescDataForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDocumentDesc: TcxGridDBColumn
            Caption = 'Desc'
            DataBinding.FieldName = 'DocumentDesc'
          end
          object colDocumentName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DocumentName'
          end
          object colFormName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072
            DataBinding.FieldName = 'FormName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenMovementForm
                Default = True
                Kind = bkEllipsis
              end>
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actOpenMovementForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenMovementForm'
      FormName = 'TFormsForm'
      FormNameParam.Value = 'TFormsForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FormId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FormName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actInsertUpdateForm: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = InsertUpdateForm
      StoredProcList = <
        item
          StoredProc = InsertUpdateForm
        end>
      Caption = 'actInsertUpdateForm'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementDesc'
    Left = 112
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 96
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object InsertUpdateForm: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementDesc'
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
        Name = 'inFormId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 160
    Top = 168
  end
end
