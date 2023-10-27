 -- Function: gpSelect_MovementItem_ConvertRemains()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ConvertRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ConvertRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , Number        Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat  

             , PriceWithVAT  TFloat  
             , Summa         TFloat  
             , VAT           TFloat  

             , Measure       TVarChar
             , UKTZED        TVarChar

             , Color_Code    Integer
             , Color_UKTZED  Integer

             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ConvertRemains());
    vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE tmpCodeUKTZED ON COMMIT DROP AS
    SELECT DISTINCT Object_UKTZED.ValueData    AS UKTZED
    FROM Object AS Object_UKTZED
    WHERE Object_UKTZED.DescId = zc_Object_UKTZED()
      AND Object_UKTZED.isErased = FALSE;
                            
    ANALYSE tmpCodeUKTZED;

    CREATE TEMP TABLE tmpGoodsUKTZED ON COMMIT DROP AS
    SELECT Object_Goods_Juridical.GoodsMainId
         , string_agg(DISTINCT REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), ''), ',')::TVarChar AS UKTZED
         , max(CASE WHEN COALESCE (tmpCodeUKTZED.UKTZED, '') <> '' THEN 1 ELSE 0 END) AS RegUKTZED        
    FROM Object_Goods_Juridical
         LEFT JOIN tmpCodeUKTZED ON tmpCodeUKTZED.UKTZED ILIKE REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')
    WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
      AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) >= 4
      AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
      AND Object_Goods_Juridical.GoodsMainId <> 0
    GROUP BY Object_Goods_Juridical.GoodsMainId;

    ANALYSE tmpGoodsUKTZED;
    
    RETURN QUERY
       SELECT MovementItem.Id
            , MIFloat_Number.ValueData::Integer                     AS Number
            , MovementItem.ObjectId
            , Object_Goods_Main.ObjectCode
            , COALESCE(Object_Goods_Main.NameUkr, 
                       Object_Goods_Main.Name, 
                       MIString_GoodsName.ValueData)                AS GoodsName
            , MovementItem.Amount

            , MIFloat_PriceWithVAT.ValueData                        AS PriceWithVAT
            , Round(MIFloat_PriceWithVAT.ValueData * MovementItem.Amount, 2)::TFloat AS Summa
            , MIFloat_VAT.ValueData                                 AS VAT

            , MIString_Measure.ValueData                            AS Measure
            
            , Object_Goods_Main.CodeUKTZED                          AS UKTZED
            
            , CASE WHEN COALESCE (Object_Goods_Main.ObjectCode, 0) = 0
                   THEN zc_Color_Red()
                   ELSE zc_Color_White()
                   END::Integer                                     AS Color_Code
                   
            , CASE WHEN COALESCE (Object_Goods_Main.ObjectCode, 0) = 0
                   THEN zc_Color_Red()
                   WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                    AND COALESCE (tmpGoodsUKTZED.UKTZED, '') = '' 
                     OR COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                    AND COALESCE (tmpGoodsUKTZED.UKTZED, '') <> '' 
                    AND tmpGoodsUKTZED.RegUKTZED = 1
                   THEN zfCalc_Color (255, 165, 0) 
                   WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') <> ''
                    AND COALESCE (tmpCodeUKTZED.UKTZED, '') = ''
                     OR COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                    AND COALESCE (tmpGoodsUKTZED.UKTZED, '') <> '' 
                    AND tmpGoodsUKTZED.RegUKTZED = 0
                   THEN zfCalc_Color (255, 0, 255) 
                   ELSE zc_Color_White()
                   END::Integer                                     AS Color_UKTZED

            , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
       FROM MovementItem
                         
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id  = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

            LEFT JOIN MovementItemFloat AS MIFloat_Number
                                        ON MIFloat_Number.MovementItemId = MovementItem.Id
                                       AND MIFloat_Number.DescId = zc_MIFloat_Number()  
            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()  
            LEFT JOIN MovementItemFloat AS MIFloat_VAT
                                        ON MIFloat_VAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_VAT.DescId = zc_MIFloat_VAT()

            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
            LEFT JOIN MovementItemString AS MIString_Measure
                                         ON MIString_Measure.MovementItemId = MovementItem.Id
                                        AND MIString_Measure.DescId = zc_MIString_Measure()
                                        
            LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId

            LEFT JOIN tmpCodeUKTZED ON tmpCodeUKTZED.UKTZED ILIKE Object_Goods_Main.CodeUKTZED

       WHERE MovementItem.DescId = zc_MI_Master()
         AND MovementItem.MovementId = inMovementId
         AND (MovementItem.isErased = FALSE AND MovementItem.Amount > 0  OR inIsErased = TRUE)
       ORDER BY MIFloat_Number.ValueData
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
*/

--ТЕСТ
-- 
SELECT * FROM gpSelect_MovementItem_ConvertRemains (inMovementId:= 33817411 , inShowAll:= False, inIsErased:= FALSE, inSession:= '3')