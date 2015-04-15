inherited MarginCategoryItemForm: TMarginCategoryItemForm
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
  ClientWidth = 453
  ExplicitWidth = 461
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 453
    ExplicitWidth = 360
    ClientRectRight = 453
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 360
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 453
        ExplicitWidth = 360
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colMinPice: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'MinPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Width = 145
          end
          object colMarginPercent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'MarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##'
            HeaderAlignmentVert = vaCenter
            Width = 265
          end
        end
      end
      object cxLabel1: TcxLabel
        Left = 104
        Top = 24
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
      end
      object ceMarginCategory: TcxButtonEdit
        Left = 176
        Top = 64
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 2
        Width = 209
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = MarginCategoryGuides
        Properties.Strings = (
          'Key'
          'TextValue')
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
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MarginCategoryItem'
    Params = <
      item
        Name = 'inMarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
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
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLabel'
        end
        item
          Visible = True
          ItemName = 'bbGuides'
        end>
    end
    object bbLabel: TdxBarControlContainerItem
      Caption = 'bbLabel'
      Category = 0
      Hint = 'bbLabel'
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbGuides: TdxBarControlContainerItem
      Caption = 'bbGuides'
      Category = 0
      Hint = 'bbGuides'
      Visible = ivAlways
      Control = ceMarginCategory
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MarginCategoryItem'
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
        Name = 'inMinPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinPrice'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inMarginPercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MarginPercent'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inMarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
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
  object MarginCategoryGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMarginCategory
    FormNameParam.Value = 'TMarginCategoryForm'
    FormNameParam.DataType = ftString
    FormName = 'TMarginCategoryForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 200
    Top = 48
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = MarginCategoryGuides
      end>
    Left = 200
    Top = 128
  end
end
