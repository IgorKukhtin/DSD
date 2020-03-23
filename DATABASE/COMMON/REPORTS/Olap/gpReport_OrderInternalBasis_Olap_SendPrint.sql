-- Function: gpReport_OrderInternalBasis_Olap ()

DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap_SendPrint (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalBasis_Olap_SendPrint (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inFromId             Integer   ,    -- �� ����
    IN inToId               Integer   ,    -- ���� 
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS SETOF refcursor   
AS
$BODY$
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN

    -- ����������� �� ������
    CREATE TEMP TABLE _tmpReport (InvNumber TVarChar, OperDate TDateTime, DayOfWeekName TVarChar, DayOfWeekNumber Integer
                                , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar
                                , Amount TFloat, AmountSendIn_or TFloat, AmountSendOut_or TFloat, AmountSend_or TFloat, AmountSend_diff TFloat) ON COMMIT DROP;
    
    INSERT INTO _tmpReport (InvNumber, OperDate, DayOfWeekName, DayOfWeekNumber, GoodsGroupNameFull, GoodsGroupName
                          , GoodsCode, GoodsName, GoodsKindId, GoodsKindName
                          , Amount, AmountSendIn_or, AmountSendOut_or, AmountSend_or, AmountSend_diff)
    
         SELECT tmpReport.InvNumber
              , tmpReport.OperDate
              , tmpReport.DayOfWeekName
              , tmpReport.DayOfWeekNumber
              , tmpReport.GoodsGroupNameFull
              , tmpReport.GoodsGroupName
              , tmpReport.GoodsCode
              , tmpReport.GoodsName
              , tmpReport.GoodsKindId
              , tmpReport.GoodsKindName
              , tmpReport.Amount
              , tmpReport.AmountSendIn_or
              , tmpReport.AmountSendOut_or
              , tmpReport.AmountSend_or
              , tmpReport.AmountSend_diff
         FROM gpReport_OrderInternalBasis_Olap (inStartDate, inEndDate, inGoodsGroupId, inGoodsId, inFromId, inToId, inSession) AS tmpReport
         WHERE COALESCE (tmpReport.Amount, 0) <> 0
            OR COALESCE (tmpReport.AmountSendIn_or, 0) <> 0
            OR COALESCE (tmpReport.AmountSendOut_or, 0) <> 0
            OR COALESCE (tmpReport.AmountSend_or, 0) <> 0
            OR COALESCE (tmpReport.AmountSend_diff, 0) <> 0
            ;
 
    -------

    OPEN Cursor1 FOR
    SELECT inStartDate AS StartDate
         , inEndDate   AS EndDate
         , COALESCE (SELECT Object.ValueData FROM Object WHERE Object.Id = inFromId, '') ::TVarChar AS FromName
         , COALESCE (SELECT Object.ValueData FROM Object WHERE Object.Id = inToId, '')   ::TVarChar AS ToName    
    ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
    SELECT _tmpReport.GoodsGroupNameFull
         , _tmpReport.GoodsGroupName
         , _tmpReport.GoodsCode
         , _tmpReport.GoodsName
         , SUM (_tmpReport.Amount)           :: TFloat AS Amount
         , SUM (_tmpReport.AmountSendIn_or)  :: TFloat AS AmountSendIn_or
         , SUM (_tmpReport.AmountSendOut_or) :: TFloat AS AmountSendOut_or
         , SUM (_tmpReport.AmountSend_or)    :: TFloat AS AmountSend_or
         , SUM (_tmpReport.AmountSend_diff)  :: TFloat AS AmountSend_diff

    FROM _tmpReport
    GROUP BY _tmpReport.GoodsGroupNameFull
           , _tmpReport.GoodsGroupName
           , _tmpReport.GoodsName
           , _tmpReport.GoodsCode
    ;
    
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.03.20         *
*/

-- ����
--