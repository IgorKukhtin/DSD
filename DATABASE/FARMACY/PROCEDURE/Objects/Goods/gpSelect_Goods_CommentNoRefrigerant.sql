-- Function: gpSelect_Goods_CommentNoRefrigerant()

DROP FUNCTION IF EXISTS gpSelect_Goods_CommentNoRefrigerant (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Goods_CommentNoRefrigerant(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsMainId Integer, GoodsCode Integer, GoodsName TVarChar
             , ConditionsKeepName TVarChar
             , isColdSUNCK boolean, isColdSUN boolean
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.OperDate
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       WHERE MovementDate_Insert.ValueData BETWEEN inStartDate AND inEndDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Send())
     , tmpResult AS (SELECT DISTINCT MovementItem.ObjectId                                                          AS GoodsID
                     FROM tmpMovement AS Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                           ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                          LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                            ON MIFloat_PriceFrom.MovementItemId = MovementItem.ID
                                                           AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()

                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                    ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                    ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                                    ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v4()
                     WHERE COALESCE (MILinkObject_CommentSend.ObjectId , 0) = 14957072
                     )
                          
  SELECT Object_Goods.GoodsMainId
       , Object_Goods_Main.ObjectCode                              AS GoodsCode
       , Object_Goods_Main.Name                                    AS GoodsName
       , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
       , COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE)         AS isColdSUNCK
       , Object_Goods_Main.isColdSUN                               AS isColdSUN
  FROM tmpResult

       LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsID

       LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

       LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
       LEFT JOIN ObjectBoolean AS ObjectBoolean_ColdSUN
                               ON ObjectBoolean_ColdSUN.ObjectId = Object_Goods_Main.ConditionsKeepId
                              AND ObjectBoolean_ColdSUN.DescId = zc_ObjectBoolean_ConditionsKeep_ColdSUN()

  ORDER BY Object_Goods_Main.ObjectCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Goods_CommentNoRefrigerant (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.02.22                                                       *
*/

-- тест
-- 
select * from gpSelect_Goods_CommentNoRefrigerant(inStartDate := ('31.01.2021')::TDateTime , inEndDate := ('02.02.2022')::TDateTime ,  inSession := '3');