inherited MarginCategoryForm: TMarginCategoryForm
  Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1086#1082
  ClientHeight = 338
  ClientWidth = 579
  ExplicitWidth = 595
  ExplicitHeight = 373
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 579
    Height = 312
    ExplicitWidth = 480
    ExplicitHeight = 312
    ClientRectBottom = 312
    ClientRectRight = 579
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 480
      ExplicitHeight = 312
      inherited cxGrid: TcxGrid
        Width = 579
        Height = 312
        ExplicitWidth = 480
        ExplicitHeight = 312
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object colName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 265
          end
          object colPercent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' "'#1086#1073#1097#1080#1081'"'
            DataBinding.FieldName = 'Percent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colisSite: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1089#1072#1081#1090#1072' '#1087#1086' '#1059#1082#1088#1072#1080#1085#1077
            DataBinding.FieldName = 'isSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
      end
    end
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
    StoredProcName = 'gpSelect_Object_MarginCategory'
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
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MarginCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
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
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
      end
      item
        Name = 'Code'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
      end
      item
        Name = 'inPercent'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inisSite'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSite'
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 296
    Top = 88
  end
end
