inherited Report_ConductedSalesMobileForm: TReport_ConductedSalesMobileForm
  Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1093' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1076#1085#1103#1084
  ClientHeight = 575
  ClientWidth = 1058
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1076
  ExplicitHeight = 622
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 51
    Width = 1058
    Height = 524
    TabOrder = 3
    ExplicitTop = 51
    ExplicitWidth = 1058
    ExplicitHeight = 524
    ClientRectBottom = 524
    ClientRectRight = 1058
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1090#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1058
      ExplicitHeight = 500
      inherited cxGrid: TcxGrid
        Width = 352
        Height = 500
        ExplicitWidth = 352
        ExplicitHeight = 500
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0; ;'
              Kind = skSum
              Column = CountCheck
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = '+,0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
              Column = TotalCount
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY (DDD)'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 82
          end
          object CountCheck: TcxGridDBColumn
            Caption = #1063#1077#1082#1086#1074
            DataBinding.FieldName = 'CountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 60
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1086#1074' '#1074' '#1095#1077#1082#1072#1093
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 82
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 95
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 352
        Top = 0
        Width = 8
        Height = 500
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salRight
        Control = grChart
      end
      object grChart: TcxGrid
        Left = 360
        Top = 0
        Width = 698
        Height = 500
        Align = alRight
        TabOrder = 2
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramColumn.Active = True
          Legend.Position = cppNone
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object serPlanAmount: TcxGridDBChartSeries
            DataBinding.FieldName = 'TotalSumm'
            DisplayText = #1057#1091#1084#1084#1072
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1058
    Height = 25
    Visible = False
    ExplicitWidth = 1058
    ExplicitHeight = 25
    inherited deStart: TcxDateEdit
      Left = 60
      Top = 1
      Properties.AssignedValues.EditFormat = True
      Properties.DisplayFormat = 'MMMM YYYY'
      ExplicitLeft = 60
      ExplicitTop = 1
      ExplicitWidth = 141
      Width = 141
    end
    inherited deEnd: TcxDateEdit
      Left = 47
      Top = 32
      Visible = False
      ExplicitLeft = 47
      ExplicitTop = 32
      ExplicitWidth = 98
      Width = 98
    end
    inherited cxLabel1: TcxLabel
      Left = 15
      Top = 2
      Caption = #1052#1077#1089#1103#1094':'
      ExplicitLeft = 15
      ExplicitTop = 2
      ExplicitWidth = 39
    end
    inherited cxLabel2: TcxLabel
      Left = 33
      Top = 33
      Caption = '-'
      ExplicitLeft = 33
      ExplicitTop = 33
      ExplicitWidth = 8
    end
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      TabSheet = tsMain
    end
    object actReport_InfoMobileAppChech: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077' '#1095#1077#1082#1080' '#1087#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1102' '
      Hint = #1055#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077' '#1095#1077#1082#1080' '#1087#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1102' '
      ImageIndex = 42
      FormName = 'TReport_InfoMobileAppChechForm'
      FormNameParam.Value = 'TReport_InfoMobileAppChechForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 128
  end
  inherited MasterCDS: TClientDataSet
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ConductedSalesMobile'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 128
  end
  inherited BarManager: TdxBarManager
    Top = 128
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbQuasiSchedule: TdxBarButton
      Caption = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      Category = 0
      Hint = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      Visible = ivAlways
      ImageIndex = 40
    end
    object bbGridToExcelPivot: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object dxBarContainerItem1: TdxBarContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarControlContainerItem6: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarControlContainerItem7: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deStart
    end
    object dxBarButton1: TdxBarButton
      Action = actReport_InfoMobileAppChech
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 24
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = deStart
      end>
    Left = 88
    Top = 176
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 272
  end
end
