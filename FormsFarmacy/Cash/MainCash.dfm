inherited MainCashForm: TMainCashForm
  Caption = #1055#1088#1086#1076#1072#1078#1072
  ClientHeight = 412
  ClientWidth = 674
  ExplicitTop = -32
  ExplicitWidth = 682
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 674
    Height = 172
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 176
    ExplicitTop = -8
    ExplicitWidth = 250
    ExplicitHeight = 200
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object BottomPanel: TPanel [1]
    Left = 0
    Top = 216
    Width = 674
    Height = 196
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 176
    ExplicitWidth = 627
    object cxGrid2: TcxGrid
      Left = 0
      Top = 0
      Width = 421
      Height = 196
      Align = alClient
      TabOrder = 0
      ExplicitTop = -8
      ExplicitWidth = 250
      ExplicitHeight = 200
      object cxGrid2DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
      object cxGrid2Level1: TcxGridLevel
        GridView = cxGrid2DBTableView1
      end
    end
    object cxGrid3: TcxGrid
      Left = 424
      Top = 0
      Width = 250
      Height = 196
      Align = alRight
      TabOrder = 1
      ExplicitLeft = 448
      ExplicitTop = 16
      ExplicitHeight = 200
      object cxGrid3DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
      object cxGrid3Level1: TcxGridLevel
        GridView = cxGrid3DBTableView1
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 421
      Top = 0
      Width = 3
      Height = 196
      AlignSplitter = salRight
      ExplicitLeft = 374
      ExplicitTop = 1
      ExplicitHeight = 90
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 175
    Width = 674
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 2
    ExplicitLeft = 48
    ExplicitTop = 168
    ExplicitWidth = 185
  end
  object cxSplitter2: TcxSplitter [3]
    Left = 0
    Top = 172
    Width = 674
    Height = 3
    AlignSplitter = salBottom
    ExplicitTop = 171
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
end
