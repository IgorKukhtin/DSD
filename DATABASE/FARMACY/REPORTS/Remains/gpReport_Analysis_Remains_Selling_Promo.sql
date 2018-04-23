-- Function:  gpReport_Analysis_Remains_Selling_Promo()

DROP FUNCTION IF EXISTS gpReport_Analysis_Remains_Selling_Promo (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Analysis_Remains_Selling_Promo (
  inSession TVarChar
)
RETURNS TABLE (
  PromoID TVarChar,
  MakerName TVarChar
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
     , Object_Maker.valuedata AS MakerName
   FROM Movement
     INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                   ON MovementLinkObject_Maker.MovementId = Movement.Id
                                  AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
     LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId
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
-- select * from gpReport_Analysis_Remains_Selling_Promo ('3')

