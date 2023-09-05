-- Function: gpInsertUpdate_Object_GoodsQuality()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsQuality (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsQuality (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsQuality (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsQuality(
 INOUT ioId	          Integer   ,    -- ключ объекта <>
    IN inCode             Integer   ,    -- код объекта <>
    IN inGoodsQualityName TVarChar  ,    -- Название объекта <Значение ГОСТ, ДСТУ,ТУ, колонка 17>
    IN inValue1           TVarChar  ,    --
    IN inValue2           TVarChar  ,    --
    IN inValue3           TVarChar  ,    --
    IN inValue4           TVarChar  ,    --
    IN inValue5           TVarChar  ,    --
    IN inValue6           TVarChar  ,    --
    IN inValue7           TVarChar  ,    --
    IN inValue8           TVarChar  ,    --
    IN inValue9           TVarChar  ,    --
    IN inValue10          TVarChar  ,    --
    IN inGoodsId          Integer   ,    -- товар
    IN inQualityId        Integer   ,    -- Качественное удостоверение
    IN inisKlipsa         Boolean   ,    -- клипсованный товар
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsQuality());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка
     IF COALESCE (inQualityId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Качественное удостоверение>.';
     END IF;

     -- проверка уникальности товара
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Товар>.';
     ELSE
         IF exists (SELECT ChildObjectId FROM ObjectLink where DescId = zc_ObjectLink_GoodsQuality_Goods() and ChildObjectId = inGoodsId AND coalesce (ObjectId,0) <> coalesce (ioId,0))
         THEN
             RAISE EXCEPTION 'Ошибка. Значение <%> уже есть в справочнике.', lfGet_Object_ValueData (vbGoodsId);
         END IF;
     END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_GoodsQuality());

   -- проверка прав уникальности для свойства <Наименование >
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsQuality(), inGoodsQualityName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsQuality(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsQuality(), inCode, inGoodsQualityName);
                                --, inAccessKeyId:= (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId));

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value1(), ioId, inValue1);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value2(), ioId, inValue2);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value3(), ioId, inValue3);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value4(), ioId, inValue4);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value5(), ioId, inValue5);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value6(), ioId, inValue6);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value7(), ioId, inValue7);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value8(), ioId, inValue8);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value9(), ioId, inValue9);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value10(), ioId, inValue10);
   --
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsQuality_Goods(), ioId, inGoodsId);
   --
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsQuality_Quality(), ioId, inQualityId);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsQuality_Klipsa(), ioId, inisKlipsa);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsQuality (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,Integer, Integer,TVarChar) OWNER TO postgres;

 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.20         * add inisKlipsa
 09.02.15         * add inQualityId
 08.12.14         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsQuality()
