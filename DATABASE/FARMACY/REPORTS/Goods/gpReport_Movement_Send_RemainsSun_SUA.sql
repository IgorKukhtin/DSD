-- Function: gpReport_Movement_Send_RemainsSun_SUA

DROP FUNCTION IF EXISTS  gpReport_Movement_Send_RemainsSun_SUA(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_SUA(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId_From Integer, UnitName_From TVarChar
             , Remains_From TFloat, Layout_From TFloat, PromoUnit_From TFloat

             , UnitId_To Integer, UnitName_To TVarChar
             , Remains_To TFloat
             , Amount TFloat
             , Summa_From TFloat
             , Summa_To TFloat
              )
AS
$BODY$
  DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;
     
    RETURN QUERY    
    SELECT
           Result.GoodsId
         , Result.GoodsCode
         , Result.GoodsName
         , Result.UnitId_From 
         , Result.UnitName_From 
         , Result.PromoUnit_From
         , Result.Layout_From
         , Result.PromoUnit_From

         , Result.UnitId_To 
         , Result.UnitName_To 
         , Result.Remains_To 
         , Result.Amount 
         , Round(Result.Amount * Result.Price_From, 2)::TFloat 
         , Round(Result.Amount * Result.Price_To, 2)::TFloat 

    FROM lpInsert_Movement_Send_RemainsSun_SUA(inOperDate, 0, vbUserId) AS Result;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ 0.�.
 15.02.21                                                     *
*/

-- SELECT * FROM gpReport_Movement_Send_RemainsSun_SUA (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= '3');

SELECT * FROM gpReport_Movement_Send_RemainsSun_SUA (inOperDate:= CURRENT_DATE + INTERVAL '1 DAY', inSession:= '3');