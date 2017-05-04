-- Function: gpUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderIncomeSnab (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderIncomeSnab(
    IN inMovementId         Integer   , -- ���� ������� <��������>
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- ������������� �����
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId_From Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

    -- ���������� ����. �� ���������
    vbJuridicalId_From := (SELECT MovementLinkObject_From.ObjectId AS JuridicalId_From
                           FROM MovementLinkObject AS MovementLinkObject_From
                           WHERE MovementLinkObject_From.MovementId = inMovementId
                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_Juridical());


    -- �������� - �������� ������ ���� �����������
    IF COALESCE (vbJuridicalId_From, 0) = 0 THEN
       RAISE EXCEPTION '������.�� ����������� �������� <��.���� (���������)>.';
    END IF;

    -- ���������� ������
    PERFORM lpInsertUpdate_MI_OrderIncomeSnab_Property
                                                   (inId              := tmpData.MovementItemId
                                                  , inMovementId      := inMovementId
                                                  , inGoodsId         := tmpData.GoodsId
                                                  , inMeasureId       := ObjectLink_Goods_Measure.ChildObjectId
                                                  , inRemainsStart    := COALESCE (tmpData.RemainsStart, 0)
                                                  , inBalanceStart    := COALESCE (tmpData.RemainsStart_Oth, 0)
                                                  , inBalanceEnd      := COALESCE (tmpData.RemainsEnd_Oth, 0)
                                                  , inIncome          := COALESCE (tmpData.CountIncome, 0)
                                                  , inAmountForecast  := COALESCE (tmpData.CountProductionOut, 0)
                                                  , inAmountIn        := COALESCE (tmpData.CountIn_oth, 0)
                                                  , inAmountOut       := COALESCE (tmpData.CountOut_oth, 0)
                                                  , inAmountOrder     := COALESCE (tmpData.CountOrder, 0)
                                                  , inUserId          := vbUserId
                                                    )
      FROM (WITH tmpMI AS (SELECT MovementItem.Id              AS MovementItemId
                                , MILinkObject_Goods.ObjectId  AS GoodsId
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
           , tmpReport AS (SELECT gpReport.GoodsId
                                , gpReport.RemainsStart
                                , gpReport.RemainsStart_Oth
                                , gpReport.RemainsEnd_Oth 
                                , gpReport.CountIncome
                                , gpReport.CountProductionOut
                                , gpReport.CountIn_oth
                                , gpReport.CountOut_oth
                                , gpReport.CountOrder
                           FROM gpReport_SupplyBalance (inStartDate   := inStartDate
                                                      , inEndDate     := inEndDate
                                                      , inUnitId      := 8455
                                                      , inGoodsGroupId:= 0
                                                      , inJuridicalId := vbJuridicalId_From
                                                      , inSession     := inSession
                                                       ) AS gpReport
                          )
            -- ���������
            SELECT tmpMI.MovementItemId
                  , COALESCE (tmpMI.GoodsId, tmpReport.GoodsId) AS GoodsId
                  , tmpReport.RemainsStart
                  , tmpReport.RemainsStart_Oth
                  , tmpReport.RemainsEnd_Oth 
                  , tmpReport.CountIncome
                  , tmpReport.CountProductionOut
                  , tmpReport.CountIn_oth
                  , tmpReport.CountOut_oth
                  , tmpReport.CountOrder
            FROM tmpMI
                 FULL JOIN tmpReport ON tmpReport.GoodsId = tmpMI.GoodsId
           ) AS tmpData
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                               AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.05.17         *
 18.04.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_OrderIncomeSnab(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('21.12.2016')::TDateTime , inUnitId := 8455 , inGoodsGroupId := 1917 ,  inSession := '5');
