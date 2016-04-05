inherited MarginReportItemForm: TMarginReportItemForm
  Caption = #1069#1083#1077#1084#1077#1085#1090' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072' ('#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103')'
  ClientHeight = 359
  ClientWidth = 885
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
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 135
          end
          object colName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 195
          end
          object colPercent1: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 1-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colPercent2: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 2-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colPercent3: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 3-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colPercent4: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 4-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colPercent5: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 5-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colPercent6: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 6-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colPercent7: TcxGridDBColumn
            Caption = #1074#1080#1088#1090'. % '#1076#1083#1103' 7-'#1086#1075#1086' '#1087#1077#1088#1077#1076#1077#1083#1072
            DataBinding.FieldName = 'Percent7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
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
    object UnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'InfoMoneyChoiceForm'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'TextValue'
          Value = Null
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          ComponentItem = 'InfoMoneyCode'
        end
        item
          Name = 'InfoMoneyGroupId'
          Value = Null
          ComponentItem = 'InfoMoneyGroupId'
        end
        item
          Name = 'InfoMoneyGroupName'
          Value = Null
          ComponentItem = 'InfoMoneyGroupName'
          DataType = ftString
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MarginReportItem'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
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
      end
      item
        Name = 'inMarginReportId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MarginReportId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPercent1'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent1'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent2'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent2'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent3'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent3'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent4'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent4'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent5'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent5'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent6'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent6'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent7'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Percent7'
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 296
    Top = 88
  end
end
