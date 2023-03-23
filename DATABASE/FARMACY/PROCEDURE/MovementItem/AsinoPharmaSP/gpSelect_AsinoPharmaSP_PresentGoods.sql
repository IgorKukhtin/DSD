 -- Function: gpSelect_AsinoPharmaSP_PresentGoods()

DROP FUNCTION IF EXISTS gpSelect_AsinoPharmaSP_PresentGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AsinoPharmaSP_PresentGoods(
    IN inUnitId      Integer    ,   -- подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId           Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
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
      ,  tmpMISecond AS (SELECT DISTINCT Object_Goods.Id AS GoodsId
                         FROM tmpMovement 
                        
                              INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Second()
                                                     AND MovementItem.MovementId = tmpMovement.Id
                                                     AND MovementItem.isErased = FALSE 

                             LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId
                                                          AND Object_Goods.RetailId = vbRetailId

                        )

        SELECT DISTINCT tmpMISecond.GoodsId AS GoodsId
        FROM tmpMISecond 
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

select * from gpSelect_AsinoPharmaSP_PresentGoods(inUnitId := 375627, inSession := '3')
inner join object on object.id = GoodsId;