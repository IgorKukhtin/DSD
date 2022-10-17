-- Function: gpSelect_Object_GoodsPromo()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPromo (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPromo(
    IN inOperDate    TDateTime    , --
    IN inRetailId    Integer      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber_Full TVarChar
             , MakerId Integer, MakerName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar, isNotUseSUN Boolean
             , MainGoodsId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , ChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

        -- Результат другой
        RETURN QUERY
        WITH
        tmpGoodsPromoMain AS (SELECT DISTINCT tmp.* 
                              FROM lpSelect_MovementItem_Promo_onDate(inOperDate:= inOperDate) AS tmp
                              )

      -- товары сети 
      , tmpGoodsPromo AS (SELECT tmpGoodsPromoMain.*, ObjectLink_Child_retail.ChildObjectId AS GoodsId_retail
                          FROM tmpGoodsPromoMain
                               INNER JOIN ObjectLink AS ObjectLink_Child
                                                     ON ObjectLink_Child.ChildObjectId = tmpGoodsPromoMain.GoodsId
                                                    AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                               INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                        AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                               INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                              AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                               INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                               AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                              
                               INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                     ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                    AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                    AND ObjectLink_Goods_Object.ChildObjectId = inRetailId
                          )

      , tmpMLO_Maker AS (SELECT MovementLinkObject.*
                         FROM MovementLinkObject
                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpGoodsPromo.MovementId FROM tmpGoodsPromo)
                           AND MovementLinkObject.DescId = zc_MovementLinkObject_Maker()
                         )
                           
         SELECT tmpGoodsPromo.MovementId
              , ('№ ' || Movement_Promo.InvNumber || ' от ' || Movement_Promo.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Full
              , Object_Maker.Id                 AS MakerId
              , Object_Maker.ValueData          AS MakerName
              , Object_Juridical.Id             AS JuridicalId
              , Object_Juridical.ValueData      AS JuridicalName
              , tmpGoodsPromo.isNotUseSUN       AS isNotUseSUN
              , tmpGoodsPromo.GoodsId           AS MainGoodsId
              , tmpGoodsPromo.GoodsId_retail    AS GoodsId
              , Object_Goods.ObjectCode         AS GoodsCode
              , Object_Goods.ValueData          AS GoodsName
              , tmpGoodsPromo.ChangePercent :: TFloat

         FROM tmpGoodsPromo
              LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = tmpGoodsPromo.MovementId

              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpGoodsPromo.JuridicalId
              
              LEFT JOIN tmpMLO_Maker AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement_Promo.Id
              LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsPromo.GoodsId_retail 
         ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 17.05.19         *
*/

--
select * from gpSelect_Object_GoodsPromo(inOperDate := CURRENT_DATE , inRetailId := 4 , inSession := '3');