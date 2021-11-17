-- Function: gpUpdate_Goods_SetinHideOnTheSite()

DROP FUNCTION IF EXISTS gpUpdate_Goods_SetinHideOnTheSite(TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_SetinHideOnTheSite(
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN

  vbUserId := lpGetUserBySession (inSession);

  PERFORM gpUpdate_Goods_inHideOnTheSite(inGoodsMainId := T1.Id
                                       , inisHideOnTheSite := T1.isHideOnTheSite
                                       , inSession := inSession)
  FROM (WITH tmpPrice AS (SELECT  Movement.Id                          AS Id

                           FROM Movement 

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                             ON MovementLinkObject_Area.MovementId = Movement.Id
                                                            AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                                    
                         WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 YEAR' 
                           AND Movement.DescId = zc_Movement_PriceList()
                           AND (COALESCE(MovementLinkObject_Area.ObjectId, 0) = 0 OR MovementLinkObject_Area.ObjectId = zc_Area_Basis()))
          , tmpPriceList AS (SELECT DISTINCT  MovementItem.ObjectId
                             FROM tmpPrice AS Movement 

                                  INNER JOIN MovementItem AS MovementItem
                                                          ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.ObjectId IS NOT NULL

                              )
          , tmpRemains AS (SELECT DISTINCT Container.ObjectId
                           FROM Container
                           WHERE Container.DescId = zc_Container_Count()
                             AND Container.Amount > 0
                           )
          , tmpRemainsMain AS (SELECT DISTINCT Object_Goods_Retail.GoodsMainId AS ObjectId
                               FROM tmpRemains
                               
                                    INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpRemains.ObjectId
                                                                  AND Object_Goods_Retail.RetailID = 4
                           )
          , tmpNotHide AS (SELECT COALESCE(tmpRemainsMain.ObjectId, tmpPriceList.ObjectId) AS GoodsMainId 
                           FROM tmpPriceList 
           
                                FULL JOIN tmpRemainsMain ON tmpPriceList.ObjectId = tmpRemainsMain.ObjectId
                           )                     
                           
        SELECT Object_Goods_Main.Id
             , COALESCE(tmpNotHide.GoodsMainId, 0) = 0  AS isHideOnTheSite
        FROM Object_Goods_Main 
           
             LEFT JOIN tmpNotHide ON tmpNotHide.GoodsMainId = Object_Goods_Main.Id
           
        WHERE Object_Goods_Main.isHideOnTheSite <> (COALESCE(tmpNotHide.GoodsMainId, 0) = 0)) AS T1;
       

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.11.21                                                       *  

*/

-- тест
--
select * from gpUpdate_Goods_SetinHideOnTheSite(inSession := zfCalc_UserAdmin());  