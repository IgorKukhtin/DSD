-- Function: lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner1CLink(
    IN ioId                     Integer,    -- ключ объекта
    IN inCode                   Integer,    -- Код объекта
    IN inName                   TVarChar,   -- Название объекта
    IN inPartnerId              Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inBranchTopId            Integer,    -- 
    IN inContractId             Integer,    -- 
    IN inUserId                 Integer     -- Пользователь
)
  RETURNS Integer
AS
$BODY$
  DECLARE vbBranchId Integer;
BEGIN

   -- что-то
   IF COALESCE(inBranchId, 0) = 0 THEN
      vbBranchId := inBranchTopId;
   ELSE
      vbBranchId := inBranchId;
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner1CLink(), inCode, inName);

   
   -- IF COALESCE (inCode, 0) = 0 AND COALESCE (inName, '') = '' THEN
   --     RAISE EXCEPTION 'Ошибка.Не установлен <Код>.';
   -- END IF;

   -- проверка
   IF COALESCE (inName, '') = '' AND inCode <> 0 THEN
       RAISE EXCEPTION 'Ошибка.Не установлено <Название>.';
   END IF;
   -- проверка
   IF COALESCE (vbBranchId, 0) = 0 THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Филиал>.';
   END IF;
   

   -- проверка уникальность inCode для !!!одного!! Филиала
   IF inCode <> 0 
    AND EXISTS (SELECT ObjectLink.ChildObjectId
              FROM ObjectLink
                   JOIN Object ON Object.Id = ObjectLink.ObjectId
                              AND Object.ObjectCode = inCode
              WHERE ObjectLink.ChildObjectId = vbBranchId
                AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                AND ObjectLink.DescId = zc_ObjectLink_Partner1CLink_Branch())
   THEN
       RAISE EXCEPTION 'Ошибка. Код 1С <%> уже установлен у <%>. ', inCode, lfGet_Object_ValueData (vbBranchId);
   END IF;


   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Partner(), ioId, inPartnerId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Branch(), ioId, vbBranchId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Contract(), ioId, inContractId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        *
*/
