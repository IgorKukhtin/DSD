-- Function: lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner1CLink(
 INOUT ioId                     Integer,    -- ключ объекта
    IN inCode                   Integer,    -- Код объекта
    IN inName                   TVarChar,   -- Название объекта
    IN inPartnerId              Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inContractId             Integer,    -- 
    IN inUserId                 Integer     -- Пользователь
)
  RETURNS Integer
AS
$BODY$
BEGIN

   -- проверка
   -- IF COALESCE (inCode, 0) = 0 AND COALESCE (inName, '') = '' THEN
   --     RAISE EXCEPTION 'Ошибка.Не установлен <Код>.';
   -- END IF;

   -- проверка
   IF COALESCE (inName, '') = '' AND inCode <> 0 THEN
       RAISE EXCEPTION 'Ошибка.Не установлено <Название>.';
   END IF;
   -- проверка
   IF COALESCE (inBranchId, 0) = 0 THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Филиал>.';
   END IF;

   -- проверка уникальность inCode для !!!одного!! Филиала
   IF inCode <> 0 
    AND EXISTS (SELECT ObjectLink.ChildObjectId
              FROM ObjectLink
                   JOIN Object ON Object.Id = ObjectLink.ObjectId
                              AND Object.ObjectCode = inCode
              WHERE ObjectLink.ChildObjectId = inBranchId
                AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                AND ObjectLink.DescId = zc_ObjectLink_Partner1CLink_Branch())
   THEN
       RAISE EXCEPTION 'Ошибка. Код 1С <%> уже установлен у <%>. ', inCode, lfGet_Object_ValueData (inBranchId);
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner1CLink(), inCode, inName);

   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Partner(), ioId, inPartnerId);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Branch(), ioId, inBranchId);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Contract(), ioId, inContractId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);

   --
   -- RETURN ioId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        * set lp
 15.05.14                        * add lpInsert_ObjectProtocol
 07.04.14                        * add zc_ObjectBoolean_Partner1CLink_Contract
 15.02.14                                        * add zc_ObjectBoolean_Partner1CLink_Sybase
 11.02.14                        *
*/
