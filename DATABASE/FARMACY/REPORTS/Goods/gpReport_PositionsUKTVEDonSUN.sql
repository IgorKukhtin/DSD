-- Function: gpReport_PositionsUKTVEDonSUN()

DROP FUNCTION IF EXISTS gpReport_PositionsUKTVEDonSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PositionsUKTVEDonSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumbr TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , UnitCodeTo Integer, UnitNameTo TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE curMovement refcursor;
  DECLARE vbId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- 1. ��������� ������
  CREATE TEMP TABLE _tmpResult  (Id Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;


  OPEN curMovement FOR
    SELECT Movement.ID
    FROM Movement
         INNER JOIN MovementBoolean AS MovementBoolean_SUN
                 ON MovementBoolean_SUN.MovementId = Movement.Id
                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                AND MovementBoolean_SUN.ValueData = TRUE
    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
      AND Movement.DescId = zc_Movement_Send()
      AND Movement.StatusId <> zc_Enum_Status_Complete();


   -- ������ ����� �� �������1
   LOOP
      -- ������ �� �������1
      FETCH curMovement INTO vbId;
      -- ���� ������ �����������, ����� �����
      IF NOT FOUND THEN EXIT; END IF;

      INSERT INTO _tmpResult (Id, GoodsId, Amount)
      SELECT vbId, MI.GoodsId, MI.Amount
      FROM gpSelect_MovementItem_Send_Child (inMovementId:= vbId, inSession:= inSession) AS MI
      WHERE MI.Amount > 0 AND MI.Color_calc = zc_Color_Red();


  END LOOP; -- ����� ����� �� �������1
  CLOSE curMovement; -- ������� ������1

  -- ���������
  RETURN QUERY
  SELECT Movement.Id
       , Movement.InvNumber
       , Movement.OperDate
       , Object_From.ObjectCode                                                         AS UnitCode
       , Object_From.ValueData                                                          AS UnitName
       , Object_To.ObjectCode                                                           AS UnitCodeTo
       , Object_To.ValueData                                                            AS UnitNameTo
       , tmpResult.GoodsId                                                              AS GoodsId
       , Object_Goods.ObjectCode                                                        AS GoodsCode
       , Object_Goods.ValueData                                                         AS GoodsName
       , tmpResult.Amount                                                               AS Amount

  FROM _tmpResult AS tmpResult

       LEFT JOIN Movement ON Movement.ID = tmpResult.Id

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = tmpResult.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                    ON MovementLinkObject_To.MovementId = tmpResult.Id
                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
       LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId

  ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PercentageOverdueSUN (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.12.19                                                       *
*/

-- ����
--
SELECT * FROM gpReport_PositionsUKTVEDonSUN (inStartDate:= '01.07.2020', inEndDate:= '30.07.2020', inSession:= '3')
