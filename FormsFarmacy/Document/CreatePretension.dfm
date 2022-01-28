inherited CreatePretensionForm: TCreatePretensionForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' <'#1055#1088#1077#1090#1077#1085#1079#1080#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>'
  ClientHeight = 538
  ClientWidth = 855
  ExplicitWidth = 871
  ExplicitHeight = 577
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 199
    Width = 855
    Height = 339
    ExplicitTop = 199
    ExplicitWidth = 855
    ExplicitHeight = 339
    ClientRectBottom = 339
    ClientRectRight = 855
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 855
      ExplicitHeight = 315
      inherited cxGrid: TcxGrid
        Width = 855
        Height = 315
        ExplicitWidth = 855
        ExplicitHeight = 315
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = '+,0.###;-0.###; ;'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentVert = vaCenter
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'actChoiceGoods'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 186
          end
          object PartnerGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object PartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Options.Editing = False
            Width = 63
          end
          object ReasonDifferencesName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
            DataBinding.FieldName = 'ReasonDifferencesName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ChoiceReasonDifferences
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 126
          end
          object AmountIncome: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090#1072#1074'.'
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object AmountManual: TcxGridDBColumn
            Caption = #1060#1072#1082#1090'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountManual'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object AmountDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+0.###;-0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 855
    Height = 173
    TabOrder = 3
    ExplicitWidth = 855
    ExplicitHeight = 173
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Enabled = False
      Properties.ReadOnly = False
      ExplicitLeft = 8
      ExplicitWidth = 105
      Width = 105
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 114
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 114
    end
    inherited cxLabel2: TcxLabel
      Left = 114
      ExplicitLeft = 114
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      Enabled = False
      TabOrder = 7
      ExplicitTop = 63
      ExplicitWidth = 158
      ExplicitHeight = 22
      Width = 158
    end
    object cxLabel3: TcxLabel
      Left = 8
      Top = 87
      Caption = #1054#1090' '#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076
    end
    object edFrom: TcxButtonEdit
      Left = 8
      Top = 104
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 206
    end
    object edTo: TcxButtonEdit
      Left = 8
      Top = 144
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 206
    end
    object cxLabel4: TcxLabel
      Left = 8
      Top = 126
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxmComment: TcxMemo
      Left = 232
      Top = 24
      TabOrder = 10
      Height = 141
      Width = 609
    end
    object cxLabel5: TcxLabel
      Left = 232
      Top = 5
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    end
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc [2]
    Params = <
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [3]
    Left = 155
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore [4]
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
    Left = 40
    Top = 432
  end
  inherited spSelect: TdsdStoredProc [5]
    StoredProcName = 'gpSelect_MovementItem_Income_CreatePretension'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited ActionList: TActionList [6]
    Left = 39
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      ShortCut = 0
      DataSource = nil
    end
    inherited actMISetUnErased: TdsdUpdateErased
      ShortCut = 0
      DataSource = nil
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      Enabled = False
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
        end>
      DataSource = nil
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1072#1089#1093#1086#1076#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = #1056#1072#1089#1093#1086#1076#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProc = nil
      StoredProcList = <
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProc = nil
      StoredProcList = <
        item
        end>
    end
    inherited actDeleteMovement: TChangeGuidesStatus
      StoredProc = nil
      StoredProcList = <>
    end
    object actGoodsKindChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactCreatePretension: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = mactChechPretension
      ActionList = <
        item
          Action = actPUSHNewPretension
        end
        item
          Action = actInsertMovementPretension
        end
        item
          Action = mactCreateMIPretension
        end
        item
          Action = actGet_ExistsPretension
        end
        item
          Action = actOpenPretensionForm
        end
        item
          Action = actFormClose
        end>
      QuestionBeforeExecute = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1077#1090#1077#1085#1079#1080#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>?'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1077#1090#1077#1085#1079#1080#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1077#1090#1077#1085#1079#1080#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>'
      ImageIndex = 30
    end
    object actInsertMovementPretension: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMovementPretension
      StoredProcList = <
        item
          StoredProc = spInsertMovementPretension
        end>
      Caption = 'actInsertMovementPretension'
    end
    object mactCreateMIPretension: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertMIPretension
        end>
      View = cxGridDBTableView
      Caption = 'mactCreateMIPretension'
    end
    object actInsertMIPretension: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMIPretension
      StoredProcList = <
        item
          StoredProc = spInsertMIPretension
        end>
      Caption = 'actInsertMIPretension'
    end
    object actOpenPretensionForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenPretensionForm'
      FormName = 'TPretensionForm'
      FormNameParam.Value = 'TPretensionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'PretensionId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ChoiceReasonDifferences: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1095#1080#1085#1099' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
      FormName = 'TReasonDifferencesForm'
      FormNameParam.Value = 'TReasonDifferencesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChechPretension: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spChechPretension
      StoredProcList = <
        item
          StoredProc = spChechPretension
        end>
      Caption = 'actChechPretension'
    end
    object mactChechPretension: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChechPretension
        end>
      View = cxGridDBTableView
      Caption = 'mactChechPretension'
    end
    object actGet_ExistsPretension: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpGet_ExistsPretension
      StoredProcList = <
        item
          StoredProc = gpGet_ExistsPretension
        end>
      Caption = 'actGet_ExistsPretension'
    end
    object actDataToJson: TdsdDataToJsonAction
      Category = 'DSDLib'
      MoveParams = <>
      DataSource = MasterDS
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'Json'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'Id'
        end
        item
          FieldName = 'GoodsId'
          PairName = 'GoodsId'
        end
        item
          FieldName = 'ReasonDifferencesId'
          PairName = 'ReasonDifferencesId'
        end
        item
          FieldName = 'Amount'
          PairName = 'Amount'
        end>
      Caption = 'actDataToJson'
    end
    object actPUSHNewPretension: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actDataToJson
      StoredProc = spPUSHNewPretension
      StoredProcList = <
        item
          StoredProc = spPUSHNewPretension
        end
        item
        end
        item
        end>
      Caption = 'actPUSHNewPretension'
    end
  end
  inherited BarManager: TdxBarManager [7]
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarStatic'
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
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object dxBarButton1: TdxBarButton
      Caption = 'actPrintForManager'
      Category = 0
      Visible = ivNever
      ImageIndex = 16
    end
    object dxBarButton2: TdxBarButton
      Action = mactCreatePretension
      Category = 0
    end
    object bbisDocument: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1088#1080#1075#1080#1085#1072#1083' '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1088#1080#1075#1080#1085#1072#1083' '#1044#1072'/'#1053#1077#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbPrintSticker_notPrice: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080' '#1073#1077#1079' '#1094#1077#1085#1099
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080' '#1073#1077#1079' '#1094#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 19
    end
    object dxBarButton3: TdxBarButton
      Caption = 
        #1063#1072#1089#1090#1080#1095#1085#1086#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1087#1086#1079#1080#1094#1080#1081' '#1089' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1084' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1084' '#1082#1086#1083#1080#1095#1077#1089#1090#1074 +
        #1086#1084
      Category = 0
      Hint = 
        #1063#1072#1089#1090#1080#1095#1085#1086#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1087#1086#1079#1080#1094#1080#1081' '#1089' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1084' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1084' '#1082#1086#1083#1080#1095#1077#1089#1090#1074 +
        #1086#1084
      Visible = ivAlways
      ImageIndex = 12
    end
    object dxBarButton4: TdxBarButton
      Caption = 
        #1054#1090#1084#1077#1085#1072' '#1095#1072#1089#1090#1080#1095#1085#1086#1075#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1087#1086#1079#1080#1094#1080#1081' '#1089' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1084' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1084' '#1082 +
        #1086#1083#1080#1095#1077#1089#1090#1074#1086#1084
      Category = 0
      Hint = 
        #1054#1090#1084#1077#1085#1072' '#1095#1072#1089#1090#1080#1095#1085#1086#1075#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1087#1086#1079#1080#1094#1080#1081' '#1089' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1084' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1084' '#1082 +
        #1086#1083#1080#1095#1077#1089#1090#1074#1086#1084
      Visible = ivAlways
      ImageIndex = 11
    end
    object dxBarStatic1: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton5: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077' '#1090#1086#1074#1072#1088#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077' '#1090#1086#1074#1072#1088#1072
      Visible = ivAlways
      ImageIndex = 47
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [8]
    Left = 502
    Top = 409
  end
  inherited PopupMenu: TPopupMenu [9]
    Left = 512
    Top = 344
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams [10]
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = cxmComment
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PretensionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Json'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 416
  end
  inherited StatusGuides: TdsdGuides [11]
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc [12]
    Left = 80
    Top = 88
  end
  inherited spGet: TdsdStoredProc [13]
    StoredProcName = 'gpGet_Movement_Income'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaymentDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchDate'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberBranch'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDocument'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRegistered'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isConduct'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc [14]
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = ''
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller [15]
    GuidesList = <
      item
      end
      item
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver [16]
    ControlList = <
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn [17]
    FormName = 'TCreatePretensionJournal'
    DataSet = 'MasterCDS'
    Left = 616
    Top = 280
  end
  inherited MasterDS: TDataSource [18]
    Top = 368
  end
  inherited MasterCDS: TClientDataSet [19]
    Left = 96
    Top = 280
  end
  inherited spErasedMIMaster: TdsdStoredProc [20]
    StoredProcName = ''
    Left = 390
    Top = 408
  end
  inherited spUnErasedMIMaster: TdsdStoredProc [21]
    StoredProcName = ''
    Left = 390
    Top = 328
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 360
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Summ'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummMVAT'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPVAT'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 380
    Top = 268
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
      end>
    Left = 504
    Top = 280
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 80
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 128
  end
  object spInsertMIPretension: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Pretension'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PretensionId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMIParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferencesId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountIncome'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountIncome'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 344
  end
  object spInsertMovementPretension: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Pretension'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PretensionId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = cxmComment
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 714
    Top = 288
  end
  object spChechPretension: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ChechPretension'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferencesId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferencesName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 400
  end
  object gpGet_ExistsPretension: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ExistsPretension'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PretensionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 248
  end
  object spPUSHNewPretension: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PUSHCreatePretension'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJSON'
        Value = Null
        Component = FormParams
        ComponentItem = 'Json'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSpecialLighting'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTextColor'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outColor'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBold'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 594
    Top = 384
  end
end
