 -- Function: gpReport_EntryGoodsMovement()

DROP FUNCTION IF EXISTS gpReport_EntryGoodsMovement (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_EntryGoodsMovement(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inUnitId           Integer  ,  -- �������������
    IN inGoodsId          Integer  ,  -- �����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (ID  Integer
             , InvNumber  TVarChar
             , OperDate TDateTime
             , StatusName TVarChar
             , DescId Integer
             , MovementName TVarChar
             , UnitName TVarChar
             , Amount TFloat
             , isErased boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
    SELECT Movement.ID
         , Movement.InvNumber
         , Movement.OperDate
         , (Object_Status.ValueData||CASE WHEN COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                                               AND Movement.DescId not in (zc_Movement_Check()) THEN ' �������' ELSE '' END)::TVarChar
         , Movement.DescId
         , MovementDesc.ItemName
         , Object_Unit.ValueData
         , MovementItem.Amount
         , MovementItem.IsErased
    FROM MovementItem

       INNER JOIN Movement ON Movement.ID = MovementItem.movementid
--                          AND Movement.DescId not in (zc_Movement_Reprice())
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       INNER JOIN MovementDesc ON MovementDesc.id = Movement.DescId
       INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_Unit(), zc_MovementLinkObject_From() , zc_MovementLinkObject_To())
                                    AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
       INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                 ON MovementBoolean_Deferred.MovementId = Movement.Id
                                AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

    WHERE MovementItem.ObjectId IN
          (SELECT Object_Goods_Retail.ID FROM Object_Goods_Retail WHERE Object_Goods_Retail.GoodsMainId =
            (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId))
    ORDER BY Movement.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.03.20                                                       *
*/

-- ����
-- select * from gpReport_EntryGoodsMovement(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('30.04.2021')::TDateTime , inUnitId := 1529734 , inGoodsId := 1267302 ,  inSession := '3');

