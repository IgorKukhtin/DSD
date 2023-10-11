-- Function: gpSelect_GoodsOnUnitRemains_Data

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_UKTZED (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_UKTZED(
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (ObjectCode    Integer
             , GoodsName     TVarChar
             , Remains       TFloat
             , UKTZED        TVarChar
             , FromGoodsCode TVarChar
             , FromGoodsName TVarChar
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , FromName      TVarChar
             , CodeUKTZED    TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

-- raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
    SELECT Container.ObjectId
         , sum(Container.Amount)::TFloat    AS Amount
    FROM Container
    WHERE Container.DescId        = zc_Container_Count()
      AND Container.Amount        <> 0
      AND Container.WhereObjectId IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp)
    GROUP BY Container.ObjectId;
                       
    ANALYSE tmpContainer;
    
    RETURN QUERY
    WITH
         tmpGoodsUKTZED AS (SELECT Object_Goods_Juridical.GoodsMainId
                                 , Object_Goods_Juridical.UKTZED
                                 , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Juridical.GoodsMainId
                                                ORDER BY COALESCE(Object_Goods_Juridical.AreaId, 0), Object_Goods_Juridical.JuridicalId) AS Ord
                            FROM Object_Goods_Juridical
                            WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
                              AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) >= 4
                              AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                              AND Object_Goods_Juridical.GoodsMainId <> 0
                            ),
         tmpMovementItemString AS (SELECT MovementItemString.MovementItemId
                                        , MovementItemString.ValueData          AS CodeUKTZED
                          FROM MovementItemString
                          WHERE MovementItemString.descid = zc_MIString_FEA()
                            AND length(REPLACE(REPLACE(REPLACE(MovementItemString.valuedata, ' ', ''), '.', ''), Chr(160), '')) >= 4
                            AND length(REPLACE(REPLACE(REPLACE(MovementItemString.valuedata, ' ', ''), '.', ''), Chr(160), '')) <= 10
                            AND MovementItemString.valuedata <> ''),
         tmpGoods AS (SELECT MovementItem.id
                           , MovementItem.Movementid
                           , MovementItem.objectid
                           , MovementItemString.CodeUKTZED
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.objectid ORDER BY MovementItem.id DESC) AS Ord
                      FROM tmpMovementItemString AS MovementItemString
                           INNER JOIN MovementItem ON MovementItem.Id = MovementItemString.MovementItemId
                           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.id = MovementItem.objectid
                                                         AND Object_Goods_Retail.RetailId = 4),
         tmpGoodsIncome AS (SELECT tmpGoods.objectid                AS GoodsId
                                 , tmpGoodsjuridical.Code           AS FromGoodsCode
                                 , tmpGoodsjuridical.name           AS FromGoodsName
                                 , Movement_Income.InvNumber
                                 , Movement_Income.OperDate
                                 , Object_From.ValueData            AS FromName
                                 , tmpGoods.CodeUKTZED
                                -- , gpUpdate_Goods_CodeUKTZED (tmpGoods.objectid, tmpGoods.ValueData, '3')
                            FROM tmpGoods
                                 LEFT JOIN Object_Goods_Retail AS tmpGoodsRetail ON tmpGoodsRetail.Id = tmpGoods.objectid
                                 LEFT JOIN Object_Goods_Main AS tmpGoodsMain ON tmpGoodsMain.Id = tmpGoodsRetail.GoodsMainId
                                 LEFT JOIN Movement AS Movement_Income
                                                    ON Movement_Income.Id = tmpGoods.MovementId
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = tmpGoods.MovementId
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                 LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                                                  ON MILO_Goods.MovementItemId = tmpGoods.Id
                                                                 AND MILO_Goods.DescId = zc_MILinkObject_Goods()
                                 LEFT JOIN object_goods_juridical AS tmpGoodsjuridical ON tmpGoodsjuridical.Id = MILO_Goods.ObjectId
                            WHERE tmpGoods.Ord = 1)

    SELECT Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name AS GoodsName
         , tmpContainer.Amount
         , tmpGoodsUKTZED.UKTZED

         , tmpGoodsIncome.FromGoodsCode
         , tmpGoodsIncome.FromGoodsName
         , tmpGoodsIncome.InvNumber
         , tmpGoodsIncome.OperDate
         , tmpGoodsIncome.FromName
         , tmpGoodsIncome.CodeUKTZED
         
    FROM tmpContainer

         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId
         INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

         LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Main.Id
                                 AND tmpGoodsUKTZED.Ord = 1
                                 
         LEFT JOIN tmpGoodsIncome ON tmpGoodsIncome.GoodsId = tmpContainer.ObjectId 
                                 
    ORDER BY Object_Goods_Main.ObjectCode
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_Data (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.23                                                       *
*/

-- тест
--

SELECT * FROM gpSelect_GoodsOnUnitRemains_UKTZED ('3')