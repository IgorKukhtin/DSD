-- Function: gpReport_MinPrice_byPromo()

DROP FUNCTION IF EXISTS gpReport_MinPrice_byPromo (Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MinPrice_byPromo(
    IN inMovementId    Integer,     -- Ид документа маркетинга
    IN inStartDate     TDateTime, 
    IN inEndDate       TDateTime,
    IN inPersent       TFloat,     -- процент отклонения
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsCode       Integer      --Код товара
              , GoodsName       TVarChar     --Наименование товара
              , MakerName       TVarChar     --Производитель
              , NDSKindName     TVarChar     --вид ндс
              , NDS             TFloat
              , JuridicalName   TVarChar     --
              , DateMinPrice    TDateTime
              , DateMaxPrice    TDateTime
              , OperDate        TDateTime
              , MinPrice        TFloat
              , MaxPrice        TFloat
              , MidPrice        TFloat
              , TodayPrice      TFloat     -- цена из прайса сегодня
              , Persent         TFloat     -- факт % отклонения миним цены из периода и ЦЕНЫ СЕГОДНЯ
              , OperDatePromo   TDateTime
              , invNumberPromo  TVarChar
              , StartPromo      TDateTime
              , EndPromo        TDateTime
              , ChangePercent   TFloat
              , Amount          TFloat
              , MakerNamePromo  TVarChar
              , PersonalName    TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);

     inEndDate := inEndDate + INTERVAL '1 DAY';

     
     CREATE TEMP TABLE _tmpPromo (MovementId_Promo Integer, OperDatePromo TDateTime, invNumberPromo TVarChar
                                , StartPromo TDateTime, EndPromo TDateTime, ChangePercent TFloat, Amount TFloat, MakerNamePromo TVarChar, PersonalName TVarChar) ON COMMIT DROP; 
                                
     INSERT INTO _tmpPromo (MovementId_Promo, OperDatePromo, InvNumberPromo, StartPromo, EndPromo, ChangePercent, Amount, MakerNamePromo, PersonalName)
            SELECT Movement.Id        
                 , Movement.OperDate  
                 , Movement.invNumber
                 
                 , MovementDate_StartPromo.ValueData                              AS StartPromo
                 , MovementDate_EndPromo.ValueData                                AS EndPromo 
                 , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat      AS ChangePercent
                 , COALESCE(MovementFloat_Amount.ValueData,0)::TFloat             AS Amount
                 , Object_Maker.ValueData                                         AS MakerName
                 , Object_Personal.ValueData                                      AS PersonalName 
            FROM Movement
                 LEFT JOIN MovementFloat AS MovementFloat_Amount
                                         ON MovementFloat_Amount.MovementId =  Movement.Id
                                        AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                 LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                         ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                        AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                 LEFT JOIN MovementDate AS MovementDate_StartPromo
                                        ON MovementDate_StartPromo.MovementId = Movement.Id
                                       AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                 LEFT JOIN MovementDate AS MovementDate_EndPromo
                                        ON MovementDate_EndPromo.MovementId = Movement.Id
                                       AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
         
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                              ON MovementLinkObject_Maker.MovementId = Movement.Id
                                             AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                 LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId
                 
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                              ON MovementLinkObject_Personal.MovementId = Movement.Id
                                             AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                 LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
        
            WHERE Movement.DescId = zc_Movement_Promo()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              AND (Movement.Id = inMovementId OR inMovementId = 0);
     
     --если заполнены поставщики в документе, то отчет строим по ним
     CREATE TEMP TABLE tmpJuridical (JuridicalId Integer) ON COMMIT DROP; 
     INSERT INTO tmpJuridical (JuridicalId)
            SELECT DISTINCT MovementLinkObject_Juridical.ObjectId    AS JuridicalId
            FROM _tmpPromo 
                 INNER JOIN Movement AS Movement_PromoPartner 
                                     ON Movement_PromoPartner.ParentId = _tmpPromo.MovementId_Promo
                                    AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                    AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()

                 JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement_PromoPartner.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            ;
              
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
      tmpGoodsPromoMI AS (SELECT DISTINCT MI_Goods.ObjectId    AS GoodsId
                               , _tmpPromo.MovementId_Promo
                          FROM _tmpPromo
                             INNER JOIN MovementItem AS MI_Goods 
                                                     ON MI_Goods.MovementId = _tmpPromo.MovementId_Promo
                                                    AND MI_Goods.DescId = zc_MI_Master()
                                                    AND MI_Goods.isErased = FALSE
                          )
    , tmpGoodsPromo AS (SELECT DISTINCT tmpGoodsPromoMI.GoodsId  AS GoodsId
                             , ObjectLink_Main.ChildObjectId     AS GoodsMainId
                             , tmpGoodsPromoMI.MovementId_Promo
                        FROM tmpGoodsPromoMI
                             -- получаем GoodsMainId
                             LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                                   ON ObjectLink_Child.ChildObjectId = tmpGoodsPromoMI.GoodsId
                                                  AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                             LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                   ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                  AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                          )
      -- выбираем прайсы с маркет. товарами
    , tmpDataAll AS (SELECT Movement.OperDate                 AS OperDate
                          , MI_Master.ObjectId                AS GoodsId   -- это GoodsMainId
                          , COALESCE(MIFloat_Price.ValueData,0)::TFloat  AS Price  
                          , tmpGoodsPromo.MovementId_Promo
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
 
    , tmpDataToday AS (SELECT tmp.*
                       FROM (SELECT tmpGoodsPromo.GoodsMainId     AS GoodsMainId
                                  , LoadPriceListItem.Price       AS Price
                                  , LoadPriceList.Operdate        AS OperDate
                                  , LoadPriceList.JuridicalId     AS JuridicalId
                                  , ROW_NUMBER() OVER (PARTITION BY LoadPriceListItem.goodsId ORDER BY LoadPriceList.Operdate desc, LoadPriceListItem.Price ) AS ord
                             FROM LoadPriceListItem 
                                  INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                                                          --AND LoadPriceList.Operdate <= CURRENT_DATE
                                  INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = LoadPriceList.JuridicalId
                                  
                                  --INNER JOIN tmpGoods ON tmpGoods.GoodsCode = LoadPriceListItem.GoodsCode
                                  INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsMainId = LoadPriceListItem.GoodsId                          
                             ) AS tmp
                        WHERE tmp.Ord = 1
                       )
    
                     
    , tmpData AS (SELECT tmp.GoodsId
                       , tmp.MinPrice
                       , tmp.MaxPrice
                       , tmp.MidPrice
                       , MAX (CASE WHEN tmp.Ord_Min = 1 THEN tmp.OperDate ELSE zc_DateStart() END) AS DateMinPrice
                       , MAX (CASE WHEN tmp.Ord_Max = 1 THEN tmp.OperDate ELSE zc_DateStart() END) AS DateMaxPrice
                       , tmp.MovementId_Promo
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
                              , tmp.MovementId_Promo
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
                         , tmpDataToday.OperDate                    AS OperDate
                         , tmpDataToday.JuridicalId                 AS JuridicalId
                         , tmpData.MovementId_Promo
                    FROM tmpData
                         INNER JOIN tmpDataToday ON tmpDataToday.GoodsMainId = tmpData.GoodsId   
                     )
 
      -- результат
      SELECT  Object_Goods.ObjectCode                  AS GoodsCode
            , Object_Goods.ValueData                   AS GoodsName
            , ObjectString_Goods_Maker.ValueData       AS MakerName
            , Object_NDSKind.ValueData                 AS NDSKindName
            , ObjectFloat_NDSKind_NDS.ValueData        AS NDS
            , Object_Juridical.ValueData               AS JuridicalName  -- поставщик цены сегодня
            
            , tmpData.DateMinPrice         ::TDateTime AS DateMinPrice
            , tmpData.DateMaxPrice         ::TDateTime AS DateMaxPrice
            , tmpData.OperDate             ::TDateTime AS OperDate       --дата прайса цены сегодня 
            , tmpData.MinPrice             ::TFloat    AS MinPrice    
            , tmpData.MaxPrice             ::TFloat    AS MaxPrice    
            , tmpData.MidPrice             ::TFloat    AS MidPrice    
            , tmpData.TodayPrice           ::TFloat    AS TodayPrice
            , tmpData.Persent              ::TFloat    AS Persent
           
            , _tmpPromo.OperDatePromo
            , _tmpPromo.InvNumberPromo
            , _tmpPromo.StartPromo
            , _tmpPromo.EndPromo
            , _tmpPromo.ChangePercent
            , _tmpPromo.Amount
            , _tmpPromo.MakerNamePromo
            , _tmpPromo.PersonalName
      FROM tmpResult AS tmpData
       
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
        
        LEFT JOIN (SELECT DISTINCT tmpGoodsPromo.GoodsId, tmpGoodsPromo.GoodsMainId FROM tmpGoodsPromo ) AS tmpGoodsPromo ON tmpGoodsPromo.GoodsMainId = tmpData.GoodsId
        
        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = tmpGoodsPromo.GoodsId
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() 
                              
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
        
        LEFT JOIN _tmpPromo ON _tmpPromo.MovementId_Promo = tmpData.MovementId_Promo

      WHERE tmpData.PricePersent <= tmpData.MinPrice OR inPersent = 0
      ORDER BY 2                                   
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.01.18         *
 14.11.16         *
*/

-- тест 
-- select * from gpReport_MinPrice_byPromo(inMovementId := 3854288, inStartDate := ('01.10.2017')::TDateTime , inEndDate := ('15.11.2017')::TDateTime , inPersent:= 0, inSession := '3');