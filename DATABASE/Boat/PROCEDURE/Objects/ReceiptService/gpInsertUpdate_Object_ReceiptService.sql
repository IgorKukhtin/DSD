--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TVarChar,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar,TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptService(
 INOUT ioId                           Integer,       -- Ключ объекта < >
 INOUT ioCode                         Integer,       -- Код Объекта < >
    IN inName                         TVarChar,      -- Название объекта <>
    IN inArticle                      TVarChar,      --
    IN inNumReplace                   TVarChar,
    IN inComment                      TVarChar,      -- Краткое название
    IN inTaxKindId                    Integer ,      -- НДС
    IN inPartnerId                    Integer ,      -- Поставщик услуг
    IN inReceiptServiceGroupId        Integer , --
    IN inEKPrice                      TFloat  ,      -- Вх. цена без ндс
    IN inSalePrice                    TFloat  ,      -- Цена продажи без ндс
    IN inNPP                          TFloat  ,
    IN inReceiptServiceModelName      TVarChar,
    IN inReceiptServiceMaterialName   TVarChar,
    IN inSession                      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbReceiptServiceModelId Integer;
   DECLARE vbReceiptServiceMaterialId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReceiptService());

   -- проверка уникальности для свойства <Наименование Страна>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReceiptService(), inName ::TVarChar, vbUserId);
   -- проверка уникальности для свойства <Код Страна>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReceiptService(), ioCode, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptService(), ioCode, inName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptService_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptService_NumReplace(), ioId, inNumReplace);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_EKPrice(), ioId, inEKPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_SalePrice(), ioId, inSalePrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_NPP(), ioId, inNPP);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_TaxKind(), ioId, inTaxKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_Partner(), ioId, inPartnerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_ReceiptServiceGroup(), ioId, inReceiptServiceGroupId);

   --пробуем найти ReceiptServiceModel если нет создаем
   IF TRIM (COALESCE (inReceiptServiceModelName, '')) <> ''
   THEN
       -- пробуем найти
       vbReceiptServiceModelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptServiceModel() AND UPPER ( TRIM (Object.ValueData)) = UPPER ( TRIM (inReceiptServiceModelName)) );
       --если не нашли создаем
       IF COALESCE (vbReceiptServiceModelId,0) = 0
       THEN
            --RAISE EXCEPTION 'Ошибка.';
            vbReceiptServiceModelId := (SELECT tmp.ioId
                                        FROM gpInsertUpdate_Object_ReceiptServiceModel (ioId       := 0         :: Integer
                                                                                      , ioCode     := 0         :: Integer
                                                                                      , inName     := CAST (TRIM (inReceiptServiceModelName) AS TVarChar) ::TVarChar
                                                                                      , inComment  := ''        :: TVarChar
                                                                                      , inSession  := inSession :: TVarChar
                                                                                       ) AS tmp);

       END IF;
   END IF;

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_ReceiptServiceModel(), ioId, vbReceiptServiceModelId);


   -- пробуем найти ReceiptServiceMaterial если нет создаем
   IF TRIM (COALESCE (inReceiptServiceMaterialName, '')) <> ''
   THEN
       -- пробуем найти
       vbReceiptServiceMaterialId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptServiceMaterial() AND UPPER ( TRIM (Object.ValueData)) = UPPER ( TRIM (inReceiptServiceMaterialName)) );
       --если не нашли создаем
       IF COALESCE (vbReceiptServiceMaterialId,0) = 0
       THEN
            --RAISE EXCEPTION 'Ошибка.';
            vbReceiptServiceMaterialId := (SELECT tmp.ioId
                                        FROM gpInsertUpdate_Object_ReceiptServiceMaterial (ioId       := 0         :: Integer
                                                                                         , ioCode     := 0         :: Integer
                                                                                         , inName     := CAST (TRIM (inReceiptServiceMaterialName) AS TVarChar) ::TVarChar
                                                                                         , inComment  := ''        :: TVarChar
                                                                                         , inSession  := inSession :: TVarChar
                                                                                          ) AS tmp);

       END IF;
   END IF;

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_ReceiptServiceMaterial(), ioId, vbReceiptServiceMaterialId);


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
20.03.24          *
24.07.23          * Partner
22.12.20          *
11.12.20          *
*/

-- тест
--