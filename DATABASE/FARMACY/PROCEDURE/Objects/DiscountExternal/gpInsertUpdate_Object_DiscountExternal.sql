-- Function: gpInsertUpdate_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternal(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inName                          TVarChar  , -- значение
    IN inURL                           TVarChar  , --
    IN inService                       TVarChar  , -- 
    IN inPort                          TVarChar  , -- 
    IN inisGoodsForProject             Boolean   , -- Товар только для проекта (дисконтные карты)
    IN inisOneSupplier                 Boolean   , -- В чек товар одного поставщика
    IN inisTwoPackages                 Boolean   , -- 2 упаковки по карте со скидкой на вторую продажу
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternal());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_DiscountExternal());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternal(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_URL(), ioId, inURL);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_Service(), ioId, inService);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_Port(), ioId, inPort);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_GoodsForProject(), ioId, inisGoodsForProject);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_OneSupplier(), ioId, inisOneSupplier);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_TwoPackages(), ioId, inisTwoPackages);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternal (ioId:=0, inCode:=0, inValue:='КУКУ', inDiscountExternalKindId:=0, inSession:='2')
-- Function: gpGet_Object_DiscountExternal_Unit()