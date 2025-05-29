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

               -- Режим охранника Да/нет
             , isNumSecurity    Boolean
               -- Кол-во охранников
             , CountSecurity    Integer
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

           -- Режим охранника Да/нет
         , CASE WHEN -- vbUserId = 5 OR
                     EXISTS (SELECT 1
                             FROM ObjectLink AS ObjectLink_User_Member
                                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                      AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId  = ObjectLink_Personal_Member.ObjectId
                                                          AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Personal_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                                  INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                        ON ObjectLink_Personal_PersonalServiceList.ObjectId      = ObjectLink_Personal_Member.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceList.DescId        = zc_ObjectLink_Personal_PersonalServiceList()
                                                       -- Відомість Охорона
                                                       AND ObjectLink_Personal_PersonalServiceList.ChildObjectId = 301885
                             WHERE ObjectLink_User_Member.ObjectId = vbUserId
                               AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                            )
                THEN TRUE
                ELSE FALSE
           END :: Boolean AS isNumSecurity

           -- Кол-во охранников
         , 3 :: Integer AS CountSecurity
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
