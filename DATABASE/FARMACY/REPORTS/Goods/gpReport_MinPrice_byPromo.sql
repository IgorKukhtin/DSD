-- Function: gpReport_MinPrice_byPromo()

DROP FUNCTION IF EXISTS gpReport_MinPrice_byPromo (Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MinPrice_byPromo(
    IN inMovementId    Integer,     -- Ид документа маркетинга
    IN inStartDate     TDateTime, 
    IN inEndDate       TDateTime,
    IN inPersent       TFloat,     -- процент отклонения
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsCode     Integer      --Код товара
              , GoodsName     TVarChar     --Наименование товара
              , MakerName     TVarChar     --Производитель
              , NDSKindName   TVarChar     --вид ндс
              , DateMinPrice  TDateTime
              , DateMaxPrice  TDateTime
              , MinPrice      TFloat
              , MaxPrice      TFloat
              , MidPrice      TFloat
              , TodayPrice    TFloat     -- цена из прайса сегодня
              , Persent       TFloat     -- факт % отклонения миним цены из периода и ЦЕНЫ СЕГОДНЯ
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
/*
    IF DATE_TRUNC('Month', inStartDate) <> DATE_TRUNC('Month', inEndDate) 
    THEN
         RAISE EXCEPTION 'Ошибка. Даты периода должны быть в пределе одного месяца.';
    END IF;
*/
     inEndDate := inEndDate + INTERVAL '1 DAY';
     
     --если заполнены поставщики в документе, то отчет строим по ним
     CREATE TEMP TABLE tmpJuridical (JuridicalId Integer) ON COMMIT DROP; 
     INSERT INTO tmpJuridical (JuridicalId)
            SELECT MovementLinkObject_Juridical.ObjectId    AS JuridicalId
            FROM Movement 
                 JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            WHERE Movement.ParentId = inMovementId
              AND Movement.DescId = zc_Movement_PromoPartner()
              AND Movement.StatusId <> zc_Enum_Status_Erased();
              
     -- если поставщики не выбраны, заполняем таблицу всеми поставщиками
     IF NOT EXISTS (SELECT JuridicalId FROM tmpJuridical) 
     THEN 
         INSERT INTO tmpJuridical (JuridicalId)
            SELECT Object.Id AS JuridicalId
            FROM Object
            WHERE Object.DescId = zc_Object_Juridical();
     END IF;

    RETURN QUERY
    WITH 
    -- товары тек.документа маркетинга
      tmpGoodsPromo AS (SELECT DISTINCT MI_Goods.ObjectId    AS GoodsId
                             , ObjectLink_Main.ChildObjectId AS GoodsMainId
                        FROM MovementItem AS MI_Goods
                             -- получаем GoodsMainId
                             LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                                   ON ObjectLink_Child.ChildObjectId = MI_Goods.ObjectId
                                                  AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                             LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                   ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                  AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                        WHERE MI_Goods.MovementId = inMovementId
                          AND MI_Goods.DescId = zc_MI_Master()
                          AND MI_Goods.isErased = FALSE
                         )

      -- выбираем прайсы с маркет. товарами
    , tmpDataAll AS (SELECT Movement.OperDate                 AS OperDate
                          , MI_Master.ObjectId                AS GoodsId
                          , COALESCE(MIFloat_Price.ValueData,0)::TFloat  AS Price  
                          
                     FROM Movement 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                          INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                                  
                          INNER JOIN MovementItem AS MI_Master 
                                                  ON MI_Master.MovementId = Movement.Id
                                                 AND MI_Master.DescId = zc_MI_Master()
                                                 AND MI_Master.IsErased = FALSE
                          
                          INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsMainId = MI_Master.ObjectId  -- главный товар
                          
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MI_Master.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
  
                     WHERE Movement.DescId = zc_Movement_PriceList()
                       AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                     )
 
     , tmpDataToday AS (SELECT MI_Master.ObjectId                                  AS GoodsId
                             , MAX (COALESCE(MIFloat_Price.ValueData,0)) ::TFloat  AS Price  
                             
                        FROM Movement 
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                          ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                         AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                             INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                                     
                             INNER JOIN MovementItem AS MI_Master 
                                                     ON MI_Master.MovementId = Movement.Id
                                                    AND MI_Master.DescId = zc_MI_Master()
                                                    AND MI_Master.IsErased = FALSE
                             
                             INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsMainId = MI_Master.ObjectId  -- главный товар
                             
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MI_Master.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
     
                        WHERE Movement.DescId = zc_Movement_PriceList()
                          AND Movement.OperDate >= CURRENT_DATE AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                        GROUP BY MI_Master.ObjectId
                        )
                     
    , tmpData AS (SELECT tmp.GoodsId
                       , tmp.MinPrice
                       , tmp.MaxPrice
                       , tmp.MidPrice
                       , MAX (CASE WHEN tmp.Ord_Min = 1 THEN tmp.OperDate ELSE zc_DateStart() END) AS DateMinPrice
                       , MAX (CASE WHEN tmp.Ord_Max = 1 THEN tmp.OperDate ELSE zc_DateStart() END) AS DateMaxPrice
                  FROM (              
                       SELECT *
                            , MIN (tmpDataAll.Price)  OVER (PARTITION BY tmpDataAll.GoodsId ORDER BY tmpDataAll.GoodsId)                   AS MinPrice
                            , MAX (tmpDataAll.Price)  OVER (PARTITION BY tmpDataAll.GoodsId ORDER BY tmpDataAll.GoodsId)                   AS MaxPrice
                            , AVG (tmpDataAll.Price)  OVER (PARTITION BY tmpDataAll.GoodsId ORDER BY tmpDataAll.GoodsId )                  AS MidPrice
                            , row_number() OVER (PARTITION BY tmpDataAll.GoodsId ORDER BY tmpDataAll.Price DESC, tmpDataAll.OperDate DESC) AS Ord_Max   --посл.дата макс
                            , row_number() OVER (PARTITION BY tmpDataAll.GoodsId ORDER BY tmpDataAll.Price, tmpDataAll.OperDate DESC)      AS Ord_Min   --посл.дата мин
                       FROM  tmpDataAll
                       ORDER BY tmpDataAll.Price
                       ) AS tmp
                       WHERE tmp.Ord_Min = 1 OR tmp.Ord_Max = 1
                       GROUP BY tmp.GoodsId
                              , tmp.minPrice, tmp.MaxPrice, tmp.MidPrice
                  )
                  
    , tmpResult AS (SELECT tmpData.GoodsId
                         , tmpData.DateMinPrice         ::TDateTime AS DateMinPrice
                         , tmpData.DateMaxPrice         ::TDateTime AS DateMaxPrice
                         , tmpData.MinPrice             ::TFloat    AS MinPrice    
                         , tmpData.MaxPrice             ::TFloat    AS MaxPrice    
                         , tmpData.MidPrice             ::TFloat    AS MidPrice    
                         , tmpDataToday.Price           ::TFloat    AS TodayPrice
                         , CASE WHEN COALESCE(tmpDataToday.Price, 0) <> 0 THEN 100 - (tmpData.MinPrice * 100 / tmpDataToday.Price) ELSE 0 END  ::TFloat AS Persent
                         , (COALESCE(tmpDataToday.Price, 0) + (COALESCE(tmpDataToday.Price, 0)/100 * inPersent))                               ::TFloat AS PricePersent
                    FROM tmpData
                         LEFT JOIN tmpDataToday ON tmpDataToday.GoodsId = tmpData.GoodsId   
                     )
 
      -- результат
      SELECT  Object_Goods.ObjectCode                  AS GoodsCode
            , Object_Goods.ValueData                   AS GoodsName
            , ObjectString_Goods_Maker.ValueData       AS MakerName
            , Object_NDSKind.ValueData                 AS NDSKindName
            
            , tmpData.DateMinPrice         ::TDateTime AS DateMinPrice
            , tmpData.DateMaxPrice         ::TDateTime AS DateMaxPrice
            , tmpData.MinPrice             ::TFloat    AS MinPrice    
            , tmpData.MaxPrice             ::TFloat    AS MaxPrice    
            , tmpData.MidPrice             ::TFloat    AS MidPrice    
            , tmpData.TodayPrice           ::TFloat    AS TodayPrice
            , tmpData.Persent              ::TFloat    AS Persent
            
      FROM tmpResult AS tmpData
       
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
        
        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = tmpData.GoodsId
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() 
                              
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
      WHERE tmpData.PricePersent <= tmpData.MinPrice OR inPersent = 0
      ORDER BY 2                                   
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 14.11.16         *
*/

-- тест 
-- select * from gpReport_MinPrice_byPromo(inMovementId := 3854288, inStartDate := ('01.10.2017')::TDateTime , inEndDate := ('15.11.2017')::TDateTime , inPersent:= 0, inSession := '3');