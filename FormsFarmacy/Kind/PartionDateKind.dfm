inherited PartionDateKindForm: TPartionDateKindForm
  Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
  ClientHeight = 328
  ClientWidth = 495
  ExplicitWidth = 511
  ExplicitHeight = 366
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
          object AmountMonth: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1084#1077#1089#1103#1094#1077#1074
            DataBinding.FieldName = 'AmountMonth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
          end
          object AmountDay: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountDay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
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
          Name = 'AmountDay'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountDay'
          DataType = ftFloat
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
    StoredProcName = 'gpSelect_Object_PartionDateKind'
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
    StoredProcName = 'gpUpdate_Object_PartionDateKind'
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
        Name = 'inDay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDay'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonth'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountMonth'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 96
  end
end
