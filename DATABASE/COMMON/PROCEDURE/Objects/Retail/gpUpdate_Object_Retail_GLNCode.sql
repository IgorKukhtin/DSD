-- Function: gpUpdate_Object_Retail_GLNCode()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_GLNCode(
 INOUT ioId                    Integer   ,  -- ключ объекта <Торговая сеть> 
    IN inGLNCode               TVarChar  ,  -- Код GLN - Получатель
    IN inGLNCodeCorporate      TVarChar  ,  -- Код GLN - Поставщик 
    IN inOKPO                  TVarChar  ,  -- ОКПО для налог. документов
    IN inGoodsPropertyId       Integer   ,  -- Классификаторы свойств товаров
    IN inPersonalMarketingId   Integer   ,     -- Сотрудник (Ответственный представитель маркетингового отдела)
    IN inPersonalTradeId       Integer   ,     -- Сотрудник (Ответственный представитель коммерческого отдела)
    IN inSession               TVarChar     -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка
   IF  inGLNCode <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Retail_GLNCode() AND OS.ObjectId = ioId), '')
    OR inGLNCodeCorporate <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Retail_GLNCodeCorporate() AND OS.ObjectId = ioId), '')
    OR inOKPO <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Retail_OKPO() AND OS.ObjectId = ioId), '')
    OR inGoodsPropertyId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectString_Retail_OKPO() AND OL.ObjectId = ioId), 0)
   THEN
       -- проверка прав пользователя на вызов процедуры
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_GLNCode());

       -- сохранили св-во <Код GLN - Получатель>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
       -- сохранили св-во <Код GLN - Поставщик>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCodeCorporate(), ioId, inGLNCodeCorporate);

       -- сохранили связь с <Классификаторы свойств товаров>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_GoodsProperty(), ioId, inGoodsPropertyId);   

       IF inOKPO = ''
       THEN
           -- сохранили св-во <>
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, NULL);
       ELSE
           -- сохранили св-во <>
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, inOKPO);
       END IF;

   ELSE 
       vbUserId := lpGetUserBySession (inSession);

   END IF;


   -- сохранили связь с <Сотрудник (Ответственный представитель маркетингового отдела)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalMarketing(), ioId, inPersonalMarketingId);  
   -- сохранили связь с <Сотрудник (Ответственный представитель коммерческого отдела)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalTrade(), ioId, inPersonalTradeId);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   

   --RAISE EXCEPTION 'Ошибка.OK';

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.19         *
 18.03.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Retail_GLNCode(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')