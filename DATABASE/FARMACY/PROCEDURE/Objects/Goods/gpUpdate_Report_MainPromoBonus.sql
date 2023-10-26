 -- Function: gpUpdate_Goods_MainPromoBonus()

DROP FUNCTION IF EXISTS gpUpdate_Report_MainPromoBonus (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Report_MainPromoBonus(
    IN inGoodsId            Integer  ,  -- Подразделение
    IN inMakerID            Integer,    -- 
    IN inPromoBonus         TFloat,     -- Промо бонус
    IN inPriceSip           TFloat,     -- 
    IN inChangePercentPromo TFloat,     -- Промо бонус
    IN inPriceSipPromo      TFloat,     -- 
    IN inSumma              TFloat,     -- 
    IN inAmount             TFloat,     -- 
   OUT outSommaBonus        TFloat,     -- Сумма бонуса 
   OUT outChangePercent     TFloat,     -- Промо бонус
   OUT outPriceSip          TFloat,     -- Цена сип
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCourseReport TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE (inMakerID, 0) = 0
    THEN
      outChangePercent := Null;
      outPriceSip := Null;
      outSommaBonus := Null; 
      Return;
    END IF;


    SELECT COALESCE(ObjectFloat_CashSettings_CourseReport.ValueData, 0)                          AS CourseReport
    INTO vbCourseReport
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_CourseReport
                               ON ObjectFloat_CashSettings_CourseReport.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_CourseReport.DescId = zc_ObjectFloat_CashSettings_CourseReport()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1; 
    
        
    IF COALESCE(inPriceSip, 0) <> COALESCE((SELECT Object_Goods_Main.PriceSip FROM Object_Goods_Retail 
                                            INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                            WHERE Object_Goods_Retail.Id = inGoodsId), inPriceSipPromo)
    THEN
      IF COALESCE(vbCourseReport, 0) NOT IN (0, 1) AND inMakerID IN (4827921, 3279710, 2336620, 5590994, 4585745, 6819977, 2336653, 2336658)
      THEN
        inPriceSip := Round(inPriceSip * vbCourseReport, 2);
      END IF;
      
      IF COALESCE(inPriceSip, 0) <> COALESCE((SELECT Object_Goods_Main.PriceSip FROM Object_Goods_Retail 
                                              INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                              WHERE Object_Goods_Retail.Id = inGoodsId), -1)
      THEN
        PERFORM gpUpdate_Goods_MainPriceSip(inGoodsId, inMakerID, inPriceSip, inSession);
      END IF;
    END IF;
    
    IF COALESCE(inPromoBonus, 0) <> COALESCE((SELECT Object_Goods_Main.PromoBonus FROM Object_Goods_Retail 
                                              INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                              WHERE Object_Goods_Retail.Id = inGoodsId), inChangePercentPromo)
    THEN
      PERFORM gpUpdate_Goods_MainPromoBonus(inGoodsId, inMakerID, inPromoBonus, inSession);
    END IF;

    outChangePercent := inPromoBonus;
    
    outPriceSip := inPriceSip;
    
    outSommaBonus := CASE WHEN COALESCE (inMakerID, 0) = 0
                          THEN Null 
                          WHEN COALESCE(outPriceSip, 0) = 0
                          THEN inSumma * outChangePercent / 100
                          ELSE outPriceSip * inAmount * outChangePercent / 100 END :: TFloat;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.10.23                                                       *
*/

-- тест
-- select * from gpUpdate_Report_MainPromoBonus(inGoodsId := 1490286 , inPromoBonus := 10 , inisPromo := 'True' , inPriceSip := 0 , inSumma := 18.7036 , inAmount := 1 ,  inSession := '3');