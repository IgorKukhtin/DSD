inherited MarginReportItemForm: TMarginReportItemForm
  Caption = #1069#1083#1077#1084#1077#1085#1090' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072' ('#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103')'
  ClientHeight = 359
  ClientWidth = 885
  AddOnFormData.Params = FormParams
  ExplicitWidth = 901
  ExplicitHeight = 397
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 885
    Height = 333
    ExplicitWidth = 885
    ExplicitHeight = 333
    ClientRectBottom = 333
    ClientRectRight = 885
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 885
      ExplicitHeight = 333
      inherited cxGrid: TcxGrid
        Width = 885
        Height = 333
        ExplicitWidth = 885
        ExplicitHeight = 333
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object MarginReportName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'MarginReportName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = UnitChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 135
          end
          object Percent1: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 1-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Percent2: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 2-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Percent3: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 3-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Percent4: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 4-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Percent5: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 5-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Percent6: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 6-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Percent7: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 7-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
        end
      end
    end
  end
  object ceMarginReport: TcxButtonEdit [1]
    Left = 464
    Top = 144
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 209
  end
  object cxLabel1: TcxLabel [2]
    Left = 464
    Top = 121
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MarginReportId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MarginReportName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MarginReportId'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MarginReportName'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
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
    object UnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoiceForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
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
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MarginReportItem'
    Params = <
      item
        Name = 'inMarginReportId'
        Value = Null
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        end
        item
          Visible = True
          ItemName = 'textMarginReport'
        end
        item
          Visible = True
          ItemName = 'bbMarginReport'
        end>
    end
    object textMarginReport: TdxBarControlContainerItem
      Caption = 'textMarginReport'
      Category = 0
      Hint = 'textMarginReport'
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbMarginReport: TdxBarControlContainerItem
      Caption = 'MarginReport'
      Category = 0
      Hint = 'MarginReport'
      Visible = ivAlways
      Control = ceMarginReport
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MarginReportItem'
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
        Name = 'inMarginReportId'
        Value = Null
        Component = MarginReportGuides
        ComponentItem = 'Key'
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
        Name = 'inPercent1'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent2'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent3'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent4'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent5'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent6'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent7'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 88
  end
  object MarginReportGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMarginReport
    FormNameParam.Value = 'TMarginReportForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMarginReportForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 568
    Top = 120
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = MarginReportGuides
      end>
    Left = 200
    Top = 128
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MarginReportId'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginReportName'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 759
    Top = 110
  end
end
