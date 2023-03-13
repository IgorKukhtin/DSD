 -- Function: gpSelect_AsinoPharmaSPAllGoods_Cash()

DROP FUNCTION IF EXISTS gpSelect_AsinoPharmaSPAllGoods_Cash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AsinoPharmaSPAllGoods_Cash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId           Integer
             , IsAsinoMain       Boolean
             , IsAsinoPresent    Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());
    
    RETURN QUERY
    WITH
         -- Товары соц-проект
           tmpMovement AS (SELECT Movement.Id
                                , Movement.OperDate
                                , MovementDate_OperDateEnd.ValueData  AS OperDateEnd
                           FROM Movement

                                INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                        ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                       AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                       AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                        ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                       AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                       AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                           WHERE Movement.DescId = zc_Movement_AsinoPharmaSP()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                          )
       , tmpMIChild AS (SELECT DISTINCT Object_Goods.Id AS GoodsId
                        FROM tmpMovement 
                        
                             INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Child()
                                                    AND MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.isErased = FALSE 

                             LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId
                                                          AND Object_Goods.RetailId = vbRetailId

                        )
      ,  tmpMISecond AS (SELECT DISTINCT Object_Goods.Id AS GoodsId
                         FROM tmpMovement 
                        
                              INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Second()
                                                     AND MovementItem.MovementId = tmpMovement.Id
                                                     AND MovementItem.isErased = FALSE 

                             LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId
                                                          AND Object_Goods.RetailId = vbRetailId

                        )

        SELECT COALESCE (tmpMIChild.GoodsId, tmpMISecond.GoodsId) AS GoodsId
             , COALESCE (tmpMIChild.GoodsId, 0) = 0               AS IsAsinoMain
             , COALESCE (tmpMISecond.GoodsId, 0) = 0              AS IsAsinoPresent

        FROM tmpMIChild 

             FULL JOIN tmpMISecond ON tmpMISecond.GoodsId = tmpMIChild.GoodsId

        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.03.23                                                       *
*/

--ТЕСТ
-- 

select * from gpSelect_AsinoPharmaSPAllGoods_Cash(inSession := '3');