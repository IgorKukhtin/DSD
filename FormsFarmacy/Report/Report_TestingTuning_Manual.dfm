inherited Report_TestingTuning_ManualForm: TReport_TestingTuning_ManualForm
  Caption = #1052#1077#1090#1086#1076#1080#1095#1082#1072
  ClientHeight = 483
  ClientWidth = 795
  AddOnFormData.Params = FormParams
  ExplicitWidth = 811
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 795
    Height = 424
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 795
    ExplicitHeight = 424
    ClientRectBottom = 424
    ClientRectRight = 795
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 795
      ExplicitHeight = 424
      inherited cxGrid: TcxGrid
        Width = 795
        Height = 424
        ExplicitWidth = 795
        ExplicitHeight = 424
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Question
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.CellEndEllipsis = True
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object TopicsTestingTuningName: TcxGridDBColumn
            Caption = #1058#1077#1084#1072
            DataBinding.FieldName = 'TopicsTestingTuningName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 94
          end
          object Orders: TcxGridDBColumn
            Caption = #8470' '#1074#1086#1087#1088#1086#1089#1072
            DataBinding.FieldName = 'Orders'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 65
          end
          object Question: TcxGridDBColumn
            Caption = #1042#1086#1087#1088#1086#1089
            DataBinding.FieldName = 'Question'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 276
          end
          object PossibleAnswer: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090
            DataBinding.FieldName = 'PossibleAnswer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 319
          end
          object PropertiesId: TcxGridDBColumn
            DataBinding.FieldName = 'PropertiesId'
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 795
    Height = 33
    Visible = False
    ExplicitWidth = 795
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Visible = False
    end
    inherited deEnd: TcxDateEdit
      Visible = False
    end
    inherited cxLabel1: TcxLabel
      Visible = False
    end
    inherited cxLabel2: TcxLabel
      Visible = False
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actPreparePictures
    end
    inherited actGridToExcel: TdsdGridToExcel
      Enabled = False
      ShortCut = 0
    end
    object actFormClose1: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actFormClose1'
      ShortCut = 16451
    end
    object actFormClose2: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'dsdFormClose1'
      ShortCut = 16429
    end
    object actPreparePictures: TdsdPreparePicturesAction
      Category = 'DSDLib'
      MoveParams = <>
      DataSet = MasterCDS
      PictureFields.Strings = (
        'PossibleAnswer')
      Caption = 'actPreparePictures'
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
    StoredProcName = 'gpSelect_TestingTuning_Manual'
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
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
          ItemName = 'dxBarStatic'
        end>
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    PropertiesCellList = <
      item
        Column = PossibleAnswer
        ValueColumn = PropertiesId
        EditRepository = erPossibleAnswer
      end>
  end
  inherited PopupMenu: TPopupMenu
    inherited Excel1: TMenuItem
      Visible = False
    end
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
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
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
  object erPossibleAnswer: TcxEditRepository
    Left = 288
    Top = 272
    object erPossibleAnswerBlobItem1: TcxEditRepositoryBlobItem
      Properties.BlobEditKind = bekMemo
      Properties.BlobPaintStyle = bpsText
      Properties.ReadOnly = True
    end
    object erPossibleAnswerBlobItem2: TcxEditRepositoryImageItem
      Properties.GraphicClassName = 'TJPEGImage'
      Properties.ReadOnly = True
    end
  end
end
