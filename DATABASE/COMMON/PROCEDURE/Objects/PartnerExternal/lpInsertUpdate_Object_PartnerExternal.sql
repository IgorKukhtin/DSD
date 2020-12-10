-- Function: gpInsertUpdate_Object_PartnerExternal  ()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartnerExternal (Integer, Integer, TVarChar, TVarChar, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartnerExternal (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartnerExternal (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartnerExternal(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inObjectCode               TVarChar  ,    -- 
    IN inPartnerId                Integer   ,    --
    IN inPartnerRealId            Integer   ,    --
    IN inContractId               Integer   ,    --
    IN inRetailId                 Integer   ,    --
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer; 
BEGIN

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PartnerExternal()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartnerExternal(), vbCode_calc, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_PartnerExternal_ObjectCode(), ioId, inObjectCode);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_PartnerReal(), ioId, inPartnerRealId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Partner(), ioId, inPartnerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Retail(), ioId, inRetailId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.12.20         * add inPartnerRealId
 30.10.20         *
*/

-- тест
-- 