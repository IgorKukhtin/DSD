inherited TaxForm: TTaxForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
  ClientHeight = 668
  ClientWidth = 1067
  ExplicitWidth = 1083
  ExplicitHeight = 706
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 163
    Width = 1067
    Height = 505
    ExplicitTop = 163
    ExplicitWidth = 1067
    ExplicitHeight = 505
    ClientRectBottom = 505
    ClientRectRight = 1067
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1067
      ExplicitHeight = 481
      inherited cxGrid: TcxGrid
        Width = 1067
        Height = 481
        ExplicitWidth = 1067
        ExplicitHeight = 481
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Kind = skSum
              Column = Price
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
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
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object GoodsCodeUKTZED: TcxGridDBColumn [3]
            Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
            DataBinding.FieldName = 'GoodsCodeUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object GoodsName: TcxGridDBColumn [4]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price: TcxGridDBColumn [8]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountForPrice: TcxGridDBColumn [9]
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object AmountSumm: TcxGridDBColumn [10]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1067
    Height = 137
    TabOrder = 3
    ExplicitWidth = 1067
    ExplicitHeight = 137
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 164
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 164
      ExplicitWidth = 97
      Width = 97
    end
    inherited cxLabel2: TcxLabel
      Left = 164
      ExplicitLeft = 164
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 151
      ExplicitHeight = 22
      Width = 151
    end
    object cxLabel3: TcxLabel
      Left = 269
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 265
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 157
    end
    object edTo: TcxButtonEdit
      Left = 427
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 177
    end
    object cxLabel4: TcxLabel
      Left = 427
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edContract: TcxButtonEdit
      Left = 617
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 118
    end
    object cxLabel9: TcxLabel
      Left = 617
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 571
      Top = 85
      Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 571
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Width = 237
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 427
      Top = 62
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 14
      Width = 130
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 564
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 15
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 564
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edDateRegistered: TcxDateEdit
      Left = 164
      Top = 63
      EditValue = 42247d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 17
      Width = 97
    end
    object cxLabel10: TcxLabel
      Left = 164
      Top = 45
      Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
    end
    object edIsChecked: TcxCheckBox
      Left = 617
      Top = 62
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 19
      Width = 118
    end
    object cxLabel12: TcxLabel
      Left = 86
      Top = 5
      Caption = #8470' '#1085#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 86
      Top = 23
      TabOrder = 21
      Width = 73
    end
    object edIsDocument: TcxCheckBox
      Left = 746
      Top = 63
      Caption = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 22
      Width = 124
    end
    object edIsElectron: TcxCheckBox
      Left = 265
      Top = 64
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 157
    end
    object edPartner: TcxButtonEdit
      Left = 746
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 24
      Text = ' '
      Width = 237
    end
    object cxLabel5: TcxLabel
      Left = 746
      Top = 5
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
    end
    object cxLabel8: TcxLabel
      Left = 901
      Top = 45
      Caption = #1053#1086#1084#1077#1088' '#1092#1080#1083#1080#1072#1083#1072
    end
    object edInvNumberBranch: TcxTextEdit
      Left = 901
      Top = 63
      TabOrder = 27
      Width = 82
    end
    object cxLabel16: TcxLabel
      Left = 9
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 9
      Top = 103
      TabOrder = 29
      Width = 252
    end
    object cxLabel26: TcxLabel
      Left = 265
      Top = 85
      Caption = #1042#1080#1079#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
    end
    object edReestrKind: TcxButtonEdit
      Left = 265
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 176
    end
    object cbINN: TcxCheckBox
      Left = 959
      Top = 103
      Properties.ReadOnly = True
      TabOrder = 32
      Width = 24
    end
  end
  object cxLabel22: TcxLabel [2]
    Left = 447
    Top = 85
    Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
  end
  object edStartDateTax: TcxDateEdit [3]
    Left = 447
    Top = 103
    EditValue = 42181d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 118
  end
  object cxLabel11: TcxLabel [4]
    Left = 821
    Top = 85
    Caption = #1048#1053#1053
  end
  object edINN: TcxTextEdit [5]
    Left = 821
    Top = 103
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 132
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AncestorDocumentForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 32
    Top = 576
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint_Tax: TMultiAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxProcName
        end
        item
          Action = actPrintTax
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 16
    end
    object actPrintTax: TdsdPrintAction [10]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      DataSets = <>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object actGoodsKindChoice: TOpenChoiceForm [15]
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
    object actPrintTax_Us: TdsdPrintAction [18]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectTax_Us
      StoredProcList = <
        item
          StoredProc = spSelectTax_Us
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsSverkaCDS
          UserName = 'frxDBDSverka'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actInsertMaskMulti: TMultiAction [19]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertMaskDoc
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077' '#1076#1086#1073#1072#1074#1083#1077#1085
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 27
    end
    object actPrintTax_Client: TdsdPrintAction [20]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsSverkaCDS
          UserName = 'frxDBDSverka'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actInsertMaskDoc: TdsdInsertUpdateAction [22]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ShortCut = 16429
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = 'True'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    inherited actAddMask: TdsdExecStoredProc
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
    end
    object actTax: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTax
      StoredProcList = <
        item
          StoredProc = spTax
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 41
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>.'
    end
    object mactPrint_Tax_Us: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxProcName
        end
        item
          Action = actPrintTax_Us
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 16
    end
    object mactPrint_Tax_Client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxProcName
        end
        item
          Action = actPrintTax_Client
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object actSPPrintTaxProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTax
      StoredProcList = <
        item
          StoredProc = spGetReporNameTax
        end>
      Caption = 'actSPPrintTaxProcName'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object macUpdateINN: TMultiAction
      Category = 'INN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogINN
        end
        item
          Action = actUpdateINN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      ImageIndex = 76
    end
    object MedocAction: TMedocAction
      Category = 'TaxLib'
      MoveParams = <>
      HeaderDataSet = PrintHeaderCDS
      ItemsDataSet = PrintItemsCDS
    end
    object actUpdateINN: TdsdDataSetRefresh
      Category = 'INN'
      MoveParams = <>
      StoredProc = spUpdate_INN
      StoredProcList = <
        item
          StoredProc = spUpdate_INN
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object mactMeDoc: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMedocProcedure
        end
        item
          Action = MedocAction
        end
        item
          Action = actUpdateIsMedoc
        end>
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      ImageIndex = 30
    end
    object actMedocProcedure: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = 'actMedocProcedure'
    end
    object actUpdateIsMedoc: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIsMedoc
      StoredProcList = <
        item
          StoredProc = spUpdateIsMedoc
        end>
      Caption = 'actUpdateIsMedoc'
    end
    object ExecuteDialogINN: TExecuteDialog
      Category = 'INN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      ImageIndex = 26
      FormName = 'TMovementString_INNEditForm'
      FormNameParam.Value = 'TMovementString_INNEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inINN'
          Value = ''
          Component = edINN
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Tax'
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
        Name = 'delme'
        Value = ''
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbInsertUpdateMovement'
        end
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
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbTax'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateINN'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'bbMeDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Us'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    object bbPrint_Us: TdxBarButton [4]
      Action = mactPrint_Tax_Us
      Category = 0
    end
    inherited bbPrint: TdxBarButton
      Action = mactPrint_Tax_Client
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object bbTax: TdxBarButton
      Action = actTax
      Category = 0
    end
    object bbMeDoc: TdxBarButton
      Action = mactMeDoc
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMaskMulti
      Category = 0
    end
    object bbUpdateINN: TdxBarButton
      Action = macUpdateINN
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 2
      end>
    Left = 830
    Top = 265
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
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
        Name = 'ReportNameSale'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = '0'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 552
  end
  inherited StatusGuides: TdsdGuides
    Left = 48
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Tax'
    Left = 88
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Tax'
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
        Name = 'inMask'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
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
        Name = 'Checked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Document'
        Value = 'False'
        Component = edIsDocument
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isElectron'
        Value = 'False'
        Component = edIsElectron
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateRegistered'
        Value = 0d
        Component = edDateRegistered
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
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
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberBranch'
        Value = ''
        Component = edInvNumberBranch
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDateTax'
        Value = 'NULL'
        Component = edStartDateTax
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDateTax'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReestrKindId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReestrKindName'
        Value = Null
        Component = edReestrKind
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN_To'
        Value = Null
        Component = edINN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isINN'
        Value = Null
        Component = cbINN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Tax'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberBranch'
        Value = ''
        Component = edInvNumberBranch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocument'
        Value = 'False'
        Component = edIsDocument
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesTo
      end
      item
        Guides = DocumentTaxKindGuides
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumberPartner
      end
      item
        Control = edInvNumberBranch
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edContract
      end
      item
        Control = edDocumentTaxKind
      end
      item
        Control = edIsChecked
      end
      item
        Control = edIsDocument
      end
      item
        Control = edPartner
      end
      item
        Control = ceComment
      end>
    Top = 241
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Tax_SetErased'
    Left = 718
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Tax_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Tax'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'del8'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'del9'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'del10'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'del11'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'del12'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'del13'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Tax'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
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
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = '0'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 424
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 428
    Top = 188
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
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
    Left = 296
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 16
  end
  object DocumentTaxKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTaxKind
    FormNameParam.Value = 'TDocumentTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 648
    Top = 88
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 672
    Top = 8
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportName'
    DataSets = <>
    OutputType = otResult
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
        Name = 'gpGet_Movement_Sale_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSale'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 392
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <>
    Left = 464
    Top = 96
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 193
  end
  object spGetReporNameTax: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Tax_ReportName'
    DataSets = <>
    OutputType = otResult
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
        Name = 'gpGet_Movement_Tax_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTax'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 384
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 246
  end
  object HeaderSaver2: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_Params
    ControlList = <
      item
      end
      item
      end>
    GetStoredProc = spGet
    Left = 280
    Top = 257
  end
  object spInsertUpdateMovement_Params: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Tax_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateRegistered'
        Value = 0d
        Component = edDateRegistered
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegistered'
        Value = 'False'
        Component = edIsElectron
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 417
    Top = 480
  end
  object spSelectTax_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
      end>
    OutputType = otMultiDataSet
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
        Name = 'inisClientCopy'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 311
    Top = 336
  end
  object spSelectTax_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
      end>
    OutputType = otMultiDataSet
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
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 311
    Top = 280
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 484
    Top = 326
  end
  object spTax: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Tax_From_Kind'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = 'NULL'
        Component = edStartDateTax
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumberPartner_Master'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 232
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TContractChoicePartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoicePartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 800
    Top = 16
  end
  object spUpdateIsMedoc: TdsdStoredProc
    StoredProcName = 'gpUpdate_IsMedoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 456
  end
  object spUpdate_INN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_INN'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inINN'
        Value = ''
        Component = edINN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisINN'
        Value = Null
        Component = cbINN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 594
    Top = 280
  end
end
