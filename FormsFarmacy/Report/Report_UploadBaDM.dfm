inherited Report_UploadBaDMForm: TReport_UploadBaDMForm
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' (CSV)'
  ClientHeight = 405
  ClientWidth = 855
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 871
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 855
    Height = 348
    TabOrder = 3
    ExplicitWidth = 855
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 855
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 855
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 855
        Height = 348
        ExplicitWidth = 855
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnHiding = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnsQuickCustomization = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderHint = 
              #1076#1072#1090#1072' '#1086#1087#1077#1088#1072#1094#1080#1086#1085#1085#1086#1075#1086' '#1076#1085#1103' '#1082' '#1082#1086#1090#1086#1088#1086#1081' '#1086#1090#1085#1086#1089#1080#1090#1089#1103' '#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1085#1072#1103' '#1086#1087#1077#1088#1072#1094#1080 +
              #1103
            Width = 55
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'JuridicalCode'
            HeaderHint = 
              #1082#1086#1076' '#1102#1088'.'#1083#1080#1094#1072' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1041#1072#1044#1052', '#1082' '#1082#1086#1090#1086#1088#1086#1084#1091' '#1086#1090#1085#1086#1089#1080#1090#1089#1103' '#1072#1087#1090#1077#1082#1072',' +
              ' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1103#1077#1090#1089#1103' '#1041#1072#1044#1052' '#1087#1088#1080' '#1087#1086#1089#1090#1088#1086#1077#1085#1080#1080' '#1089#1080#1089#1090#1077#1084#1099
            Width = 76
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1082#1083#1072#1076#1072
            DataBinding.FieldName = 'UnitCode'
            HeaderHint = #1082#1086#1076' '#1072#1087#1090#1077#1082#1080' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090#1072
            Width = 56
          end
          object lUnitName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1082#1083#1072#1076#1072
            DataBinding.FieldName = 'UnitName'
            HeaderHint = #1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1072#1087#1090#1077#1082#1080' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090#1072
            Width = 182
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderHint = 
              #1082#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090'. '#1057#1086#1086#1090#1085#1077#1089#1077#1085#1080#1077' '#1082#1086#1076#1086#1074' ' +
              #1090#1086#1074#1072#1088' '#1082#1086#1084#1087#1072#1085#1080#1081' '#1050#1083#1080#1077#1085#1090' '#1080' '#1041#1072#1044#1052' '#1086#1089#1091#1097#1077#1089#1090#1074#1083#1103#1077#1090#1089#1103' '#1085#1072' '#1089#1090#1086#1088#1086#1085#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' ' +
              #1041#1072#1044#1052
            Width = 52
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderHint = #1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1091#1095#1077#1090#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1077' '#1082#1086#1084#1087#1072#1085#1080#1080' '#1050#1083#1080#1077#1085#1090#1072
            Width = 153
          end
          object OperCode: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1077#1088#1072#1094#1080#1080
            DataBinding.FieldName = 'OperCode'
            HeaderHint = 
              #1082#1086#1076' '#1090#1086#1074#1072#1088#1085#1086#1081' '#1086#1087#1077#1088#1072#1094#1080#1080' '#1074' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1080' '#1089' '#1090#1072#1073#1083#1080#1094#1077#1081' '#1090#1080#1087#1086#1074' '#1086#1087#1077#1088#1072#1094#1080#1081#13#10 +
              '1     '#1047#1072#1087#1072#1089' '#1090#1086#1074#1072#1088#1072' ('#1085#1072' '#1082#1086#1085#1077#1094' '#1076#1085#1103') ('#1096#1090')'#13#10'10    '#1055#1088#1086#1076#1072#1078#1072' '#1090#1086#1074#1072#1088#1072'  ('#1096 +
              #1090')'
            Width = 33
          end
          object Amount: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'Amount'
            HeaderHint = #1095#1080#1089#1083#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            Width = 42
          end
          object Segment1: TcxGridDBColumn
            Caption = #1057#1077#1075#1084#1077#1085#1090' 1'
            DataBinding.FieldName = 'Segment1'
            HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
            Width = 30
          end
          object Segment2: TcxGridDBColumn
            Caption = #1057#1077#1075#1084#1077#1085#1090' 2'
            DataBinding.FieldName = 'Segment2'
            HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
            Width = 30
          end
          object Segment3: TcxGridDBColumn
            Caption = #1057#1077#1075#1084#1077#1085#1090' 3'
            DataBinding.FieldName = 'Segment3'
            HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
            Width = 30
          end
          object Segment4: TcxGridDBColumn
            Caption = #1057#1077#1075#1084#1077#1085#1090' 4'
            DataBinding.FieldName = 'Segment4'
            HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
            Width = 30
          end
          object Segment5: TcxGridDBColumn
            Caption = #1057#1077#1075#1084#1077#1085#1090' 5'
            DataBinding.FieldName = 'Segment5'
            HeaderHint = #1076#1083#1103' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1083#1102#1086#1081' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
            Width = 30
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 855
    ExplicitWidth = 855
    inherited deStart: TcxDateEdit
      Left = 85
      ExplicitLeft = 85
    end
    inherited deEnd: TcxDateEdit
      Left = 686
      TabOrder = 4
      Visible = False
      ExplicitLeft = 686
    end
    object cxLabel3: TcxLabel [2]
      Left = 186
      Top = 6
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edJuridical: TcxButtonEdit [3]
      Left = 248
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Width = 297
    end
    inherited cxLabel1: TcxLabel
      Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072':'
      ExplicitWidth = 73
    end
    inherited cxLabel2: TcxLabel
      Left = 568
      Visible = False
      ExplicitLeft = 568
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = JuridicalGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      HideHeader = True
    end
    object GridToCSV: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = cxGrid
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' CSV'
      Hint = #1069#1082#1089#1087#1086#1088#1090' '#1074' CSV'
      ImageIndex = 30
      ShortCut = 16472
      OpenAfterCreate = False
      DefaultFileName = 'BaDM'
      HideHeader = True
      Separator = ';'
      DefaultFileExt = 'csv'
      EncodingANSI = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 128
  end
  inherited MasterCDS: TClientDataSet
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Upload_BaDM'
    Params = <
      item
        Name = 'inDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = 41395d
        Component = JuridicalGuides
        ComponentItem = 'Key'
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
          ItemName = 'dxBarButton1'
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
    object dxBarButton1: TdxBarButton
      Action = GridToCSV
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 160
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Top = 168
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 8
  end
end
