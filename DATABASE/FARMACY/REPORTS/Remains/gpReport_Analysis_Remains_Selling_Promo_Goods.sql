-- Function:  gpReport_Analysis_Remains_Selling_Promo_Goods()

DROP FUNCTION IF EXISTS gpReport_Analysis_Remains_Selling_Promo_Goods (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Analysis_Remains_Selling_Promo_Goods (
  inSession TVarChar
)
RETURNS TABLE (
  PromoID TVarChar,
  GoodsID Integer
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   SELECT DISTINCT
       Movement.InvNumber AS PromoID
     , Object_Goods.ObjectCode AS GoodsID
   FROM Movement
     INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                        AND MI_Goods.DescId = zc_MI_Master()
                                        AND MI_Goods.isErased = FALSE
     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Goods.ObjectId
   WHERE Movement.StatusId = zc_Enum_Status_Complete()
     AND Movement.DescId = zc_Movement_Promo();


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.04.18        *                                                                         *

*/

-- тест
-- select * from gpReport_Analysis_Remains_Selling_Promo_Goods ('3')

