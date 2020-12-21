inherited DivisionPartiesForm: TDivisionPartiesForm
  Caption = #1058#1080#1087#1099' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' '#1087#1072#1088#1090#1080#1081' '#1074' '#1082#1072#1089#1089#1077' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1080
  ClientHeight = 328
  ClientWidth = 495
  ExplicitWidth = 511
  ExplicitHeight = 367
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 495
    Height = 302
    ExplicitWidth = 495
    ExplicitHeight = 302
    ClientRectBottom = 302
    ClientRectRight = 495
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 495
      ExplicitHeight = 302
      inherited cxGrid: TcxGrid
        Width = 495
        Height = 302
        ExplicitWidth = 495
        ExplicitHeight = 302
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object isBanFiscalSale: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1077#1090' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'isBanFiscalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 75
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 136
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 167
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanFiscalSale'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isBanFiscalSale'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateObject
      StoredProcList = <
        item
          StoredProc = spUpdateObject
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_DivisionParties'
    Left = 184
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 104
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
          ItemName = 'bbChoice'
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
  end
  inherited PopupMenu: TPopupMenu
    Left = 200
    Top = 176
  end
  object spUpdateObject: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_DivisionParties'
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
        Name = 'inisBanFiscalSale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBanFiscalSale'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 96
  end
end
