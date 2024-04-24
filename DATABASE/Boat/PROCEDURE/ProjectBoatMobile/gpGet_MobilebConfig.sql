-- Function: gpGet_MobilebConfig()

DROP FUNCTION IF EXISTS gpGet_MobilebConfig (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MobilebConfig(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (BarCodePref         TVarChar
             , DocBarCodePref      TVarChar
             , ItemBarCodePref     TVarChar
 
             , ArticleSeparators   TVarChar  
             
             -- ***** Настройки сканера
             -- Для сканирования использовать True - Сканер штрихкода, False - Камеру устройства
             -- Работает только когда зебра со сканером
             , isCameraScanerSet Boolean 
             , isCameraScaner    Boolean 

             -- Открывать сканер при изменении режима сканирования
             , isOpenScanChangingModeSet Boolean 
             , isOpenScanChangingMode    Boolean 

             -- Скрывать кнопку сканирования когда есть боковые
             , isHideScanButtonSet Boolean 
             , isHideScanButton    Boolean 

             -- Скрывать кнопку подсветки
             , isHideIlluminationButtonSet Boolean 
             , isHideIlluminationButton    Boolean 

             -- Поссветка включена при старте сканирования
             , isilluminationModeSet Boolean 
             , isilluminationMode    Boolean 

             -- ***** Фильтр в справочкике комплектующих
             -- Артикул
             , isDictGoodsArticleSet Boolean 
             , isDictGoodsArticle    Boolean 
             -- Interne Nr
             , isDictGoodsCodeSet    Boolean 
             , isDictGoodsCode       Boolean 
             -- EAN
             , isDictGoodsEANSet     Boolean 
             , isDictGoodsEAN        Boolean 
             
             -- ***** Фильтр в остальных справочкиках
             -- Interne Nr
             , isDictCodeSet    Boolean 
             , isDictCode       Boolean 

              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
     
    -- Результат такой
    RETURN QUERY
    SELECT zc_BarCodePref_Object()::TVarChar   AS BarCodePref
         , zc_BarCodePref_Movement()::TVarChar AS DocBarCodePref
         , zc_BarCodePref_Mi()::TVarChar       AS ItemBarCodePref
         , ' ,-'::TVarChar                     AS ArticleSeparators
         -- ***** Настройки сканера
         -- Для сканирования использовать True - Сканер штрихкода, False - Камеру устройства
         -- Работает только когда зебра со сканером
         , FALSE   AS isCameraScanerSet 
         , FALSE   AS isCameraScaner 

         -- Открывать сканер при изменении режима сканирования
         , FALSE   AS isOpenScanChangingModeSet 
         , FALSE   AS isOpenScanChangingMode 

         -- Скрывать кнопку сканирования когда есть боковые
         , FALSE   AS isHideScanButtonSet 
         , FALSE   AS isHideScanButton 

         -- Скрывать кнопку подсветки
         , FALSE   AS isHideIlluminationButtonSet 
         , FALSE   AS isHideIlluminationButton 

         -- Поссветка включена при старте сканирования
         , FALSE   AS isIlluminationModeSet 
         , TRUE    AS isIlluminationMode 

         -- ***** Фильтр в справочкике комплектующих
         -- Артикул
         , FALSE   AS isDictGoodsArticleSet 
         , TRUE    AS isDictGoodsArticle 
         -- Interne Nr
         , FALSE   AS isDictGoodsCodeSet 
         , FALSE   AS isDictGoodsCode 
         -- EAN
         , FALSE   AS isDictGoodsEANSet 
         , FALSE    AS isDictGoodsEAN 
             
         -- ***** Фильтр в остальных справочкиках
         -- Interne Nr
         , FALSE   AS isDictCodeSet 
         , FALSE   AS isDictCode 
     ; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.04.24                                                       *
*/

-- тест
-- select * from gpGet_MobilebConfig(inSession := '5');