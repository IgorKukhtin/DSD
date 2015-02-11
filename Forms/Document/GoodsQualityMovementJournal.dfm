inherited GoodsQualityMovementJournalForm: TGoodsQualityMovementJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077'>'
  ClientHeight = 649
  ClientWidth = 1014
  ExplicitWidth = 1022
  ExplicitHeight = 683
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1014
    Height = 590
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1020
    ExplicitHeight = 590
    ClientRectBottom = 586
    ClientRectRight = 1010
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitWidth = 1014
      ExplicitHeight = 584
      inherited cxGrid: TcxGrid
        Width = 1008
        Height = 584
        ExplicitWidth = 1014
        ExplicitHeight = 584
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 88
          end
          inherited colInvNumber: TcxGridDBColumn
            Visible = False
            Options.Editing = False
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 75
          end
          object OperDateCertificate: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. '#1076#1072#1090#1072
            DataBinding.FieldName = 'OperDateCertificate'
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CertificateNumber: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. '#8470
            DataBinding.FieldName = 'CertificateNumber'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CertificateSeries: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. '#1057#1077#1088#1110#1103
            DataBinding.FieldName = 'CertificateSeries'
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object CertificateSeriesNumber: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. '#1057#1077#1088#1110#1103' '#8470
            DataBinding.FieldName = 'CertificateSeriesNumber'
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object ExpertPrior: TcxGridDBColumn
            Caption = #1045#1082#1089#1087'. '#1074#1080#1089#1085#1086#1074#1086#1082
            DataBinding.FieldName = 'ExpertPrior'
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object ExpertLast: TcxGridDBColumn
            Caption = #1045#1082#1089#1087'. '#1074#1080#1089#1085#1086#1074#1086#1082' ('#1087#1072#1088#1072#1084#1077#1090#1088#1099')'
            DataBinding.FieldName = 'ExpertLast'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object QualityNumber: TcxGridDBColumn
            Caption = #1044#1077#1082#1083#1072#1088#1072#1094#1110#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072' '#8470
            DataBinding.FieldName = 'QualityNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Comment: TcxGridDBColumn
            Caption = #1054#1089#1086#1073#1083#1080#1074#1110' '#1074#1110#1076#1084#1110#1090#1082#1080
            DataBinding.FieldName = 'Comment'
            Visible = False
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object QualityName: TcxGridDBColumn
            Caption = #1050#1072#1095'. '#1091#1076#1086#1089#1090#1086#1074'.'
            DataBinding.FieldName = 'QualityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1014
    ExplicitWidth = 1020
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      FormName = 'TGoodsQualityMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TGoodsQualityMovementForm'
      FormNameParam.Value = 'TGoodsQualityMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      FormName = 'TGoodsQualityMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    object actReCompleteAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementReCompleteAll
      StoredProcList = <
        item
          StoredProc = spMovementReCompleteAll
        end>
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ImageIndex = 10
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076'?'
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099'.'
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_GoodsQuality'
    Left = 280
    Top = 384
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 128
    DockControlHeights = (
      0
      0
      28
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbReCompleteAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
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
    object bbReCompleteAll: TdxBarButton
      Action = actReCompleteAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 472
    Top = 248
  end
  inherited PopupMenu: TPopupMenu
    object N13: TMenuItem [1]
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 200
    Top = 120
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_GoodsQuality'
    Left = 816
    Top = 176
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_GoodsQuality'
    Left = 776
    Top = 296
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_GoodsQuality'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Left = 672
    Top = 208
  end
  inherited FormParams: TdsdFormParams
    Left = 384
    Top = 208
  end
  object spMovementReCompleteAll: TdsdStoredProc
    StoredProcName = 'gpCompletePeriod_Movement_GoodsQuality'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndtDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 272
    Top = 224
  end
end
