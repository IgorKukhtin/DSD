inherited Report_Check_NumberChecksForm: TReport_Check_NumberChecksForm
  Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
  ClientHeight = 375
  ClientWidth = 706
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 722
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 706
    Height = 292
    TabOrder = 3
    ExplicitTop = 77
    ExplicitWidth = 654
    ExplicitHeight = 298
    ClientRectBottom = 292
    ClientRectRight = 706
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 654
      ExplicitHeight = 298
      inherited cxGrid: TcxGrid
        Width = 706
        Height = 292
        ExplicitWidth = 654
        ExplicitHeight = 298
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
              Position = spFooter
              Column = NumberChecks
            end
            item
              Format = ',0;-,0;'
              Kind = skSum
              Column = NumberChecks
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
              Column = NumberChecks
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 91
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 408
          end
          object NumberChecks: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1082#1086#1074
            DataBinding.FieldName = 'NumberChecks'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 129
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 706
    Height = 57
    ExplicitWidth = 706
    ExplicitHeight = 57
    object edRetail: TcxButtonEdit
      Left = 49
      Top = 28
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 346
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1057#1077#1090#1100':'
    end
    object ceSummaMax: TcxCurrencyEdit
      Left = 492
      Top = 28
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 6
      Width = 121
    end
    object cxLabel4: TcxLabel
      Left = 492
      Top = 6
      Caption = #1044#1086' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072' (0 '#1073#1077#1079' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103')'
    end
    object ceSummaMin: TcxCurrencyEdit
      Left = 401
      Top = 28
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 8
      Width = 85
    end
    object cxLabel5: TcxLabel
      Left = 401
      Top = 6
      Caption = #1054#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = RetailGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_NumberChecksDialogForm'
      FormNameParam.Value = 'TReport_Check_NumberChecksDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = ''
          Component = RetailGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = ''
          Component = RetailGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummaMin'
          Value = Null
          Component = ceSummaMin
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummaMax'
          Value = Null
          Component = ceSummaMax
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGet_MovementFormClass: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MovementFormClass
      StoredProcList = <
        item
          StoredProc = spGet_MovementFormClass
        end>
      Caption = 'actGet_MovementFormClass'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_MovementFormClass
        end
        item
          Action = actOpenDocument
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 1
    end
    object actOpenDocument: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Name = 'FormClass'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormClass'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 296
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 192
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_NumberChecks'
    Params = <
      item
        Name = 'inDateStart'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaMin'
        Value = Null
        Component = ceSummaMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaMax'
        Value = Null
        Component = ceSummaMax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 448
    Top = 168
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'dxBarButton1'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 80
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormClass'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 264
  end
  object spGet_MovementFormClass: TdsdStoredProc
    StoredProcName = 'gpGet_MovementFormClass'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFormClass'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormClass'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 216
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    Key = '0'
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = RetailGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 206
    Top = 14
  end
end
