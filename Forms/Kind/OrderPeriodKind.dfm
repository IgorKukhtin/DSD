inherited OrderPeriodKindForm: TOrderPeriodKindForm
  Caption = #1042#1080#1076' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
  ClientHeight = 376
  ClientWidth = 514
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 530
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 514
    Height = 350
    TabOrder = 0
    ExplicitWidth = 514
    ExplicitHeight = 350
    ClientRectBottom = 350
    ClientRectRight = 514
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 514
      ExplicitHeight = 350
      inherited cxGrid: TcxGrid
        Width = 514
        Height = 350
        ExplicitWidth = 514
        ExplicitHeight = 350
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Editing = False
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 282
          end
          object Week: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1085#1077#1076#1077#1083#1100
            DataBinding.FieldName = 'Week'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1085#1077#1076#1077#1083#1100
            Width = 158
          end
          object EnumName: TcxGridDBColumn
            Caption = 'Enum'
            DataBinding.FieldName = 'EnumName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 279
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
          Name = 'Week'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Week'
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
    Left = 56
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_OrderPeriodKind'
    Left = 96
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 104
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
          ItemName = 'bbChoice'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 216
    Top = 256
  end
  object spUpdateObject: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_OrderPeriodKind'
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
        Name = 'inWeek'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Week'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 216
    Top = 40
  end
end
