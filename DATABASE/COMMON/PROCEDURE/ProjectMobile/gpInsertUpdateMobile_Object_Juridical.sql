-- Function: gpInsertUpdateMobile_Object_Juridical

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Juridical (Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Juridical (Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Object_Juridical (
 INOUT ioId               Integer  , -- ключ объекта <Юридическое лицо>
    IN inGUID             TVarChar , -- Глобальный уникальный идентификатор
    IN inName             TVarChar , -- Название объекта <Юридическое лицо>
    -- IN inJuridicalGroupId Integer  , -- Группа юридических лиц
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);


      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;


      IF COALESCE (inGUID, '') = ''
      THEN
           RAISE EXCEPTION 'Ошибка. Не задан глобальный уникальный идентификатор';
      END IF;
   
      -- ищем юр. лицо по значению глобального уникального идентификатора
      SELECT ObjectString_Juridical_GUID.ObjectId
      INTO vbId
      FROM ObjectString AS ObjectString_Juridical_GUID
           JOIN Object AS Object_Juridical
                       ON Object_Juridical.Id = ObjectString_Juridical_GUID.ObjectId
                      AND Object_Juridical.DescId = zc_Object_Juridical()
      WHERE ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
        AND ObjectString_Juridical_GUID.ValueData = inGUID;

      -- сохраняем юр. лицо
      ioId:= gpInsertUpdate_Object_Juridical (ioId               := COALESCE (vbId, 0)        -- ключ объекта <Юридическое лицо>
                                            , inCode             := 0                         -- свойство <Код Юридического лица>
                                            , inName             := inName                    -- Название объекта <Юридическое лицо>
                                            , inGLNCode          := NULL                      -- Код GLN
                                            , inisCorporate      := false                     -- Признак наша ли собственность это юридическое лицо
                                            , inisTaxSummary     := false                     -- Признак сводная налоговая
                                            , inisDiscountPrice  := false                     -- Печать в накладной цену со скидкой
                                            , inisPriceWithVAT   := false                     -- Печать в накладной цену с НДС (да/нет)
                                            , inDayTaxSummary    := 0                         -- Кол-во дней для сводной налоговой
                                            , inJuridicalGroupId := 8362                      -- Группы юридических лиц (03-ПОКУПАТЕЛИ)
                                            , inGoodsPropertyId  := 0                         -- Классификаторы свойств товаров
                                            , inRetailId         := 0                         -- Торговая сеть
                                            , inRetailReportId   := 0                         -- Торговая сеть(отчет)
                                            , inInfoMoneyId      := zc_Enum_InfoMoney_30101() -- Статьи назначения (Готовая продукция)
                                            , inPriceListId      := 0                         -- Прайс-лист
                                            , inPriceListPromoId := 0                         -- Прайс-лист(Акционный)
                                            , inStartPromo       := NULL                      -- Дата начала акции
                                            , inEndPromo         := NULL                      -- Дата окончания акции
                                            , inSession          := inSession                 -- текущий пользователь
                                             );

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_GUID(), ioId, inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 05.04.17                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdateMobile_Object_Juridical (ioId:= 0, inGUID:= '{CCCCEF83-D391-4CDB-A471-AF9DD07AC7D9}', inName:= 'Юр. лицо с моб. устройства', inSession:= zfCalc_UserAdmin())
