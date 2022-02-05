--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash_Load (Integer, Integer, TVarChar, Integer, Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash_Load(
    IN inCode                Integer,       -- код статьи
    IN inParentCode          Integer,       -- код группы
    IN inName                TVarChar,      -- Название статьи
    IN inUserId              Integer,       -- Id пользователя
    IN inisErased            Integer,       -- удален
    IN inProtocolDate        TDateTime,     -- дата протокола
    IN inValuta              TVarChar ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbParentId         Integer;
  DECLARE vbCashId           Integer;
  DECLARE vbCurrencyId       Integer;
  DECLARE vbGroupNameFull TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;


--RAISE EXCEPTION 'Ошибка. <%>   .', vbUserProtocolId ;

   IF COALESCE (inParentCode,0) <> 0
   THEN
       vbParentId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inParentCode);
       
       
       IF COALESCE (vbParentId,0) = 0
       THEN
           -- если не нашли группу  - создаем 
           vbParentId :=  lpInsertUpdate_Object (COALESCE (vbParentId,0), zc_Object_Cash(), inParentCode::Integer, (inParentCode||' Группа'):: TVarChar);
       END IF;
   END IF;

   vbCurrencyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Currency() AND Object.ValueData = TRIM(inValuta));

   IF COALESCE (inCode,0) <> 0
   THEN
       -- поиск в спр. 
       vbCashId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inCode);

               -- сохранили <Объект>
           vbCashId := lpInsertUpdate_Object (COALESCE (vbCashId,0), zc_Object_Cash(), inCode, inName);
        
           -- расчетно свойство <Полное название группы>
           vbGroupNameFull:= lfGet_Object_TreeNameFull (vbParentId, zc_ObjectLink_Cash_Parent());
        
           -- сохранили группа
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Cash_GroupNameFull(), vbCashId, vbGroupNameFull);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Cash_ShortName(), vbCashId, inName);
           -- сохранили
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Cash_NPP(), vbCashId, inCode);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Currency(), vbCashId, vbCurrencyId);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Parent(), vbCashId, vbParentId);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_PaidKind(), vbCashId, 40409);
     
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbCashId, inProtocolDate ::TDateTime);
           -- сохранили свойство <Пользователь (создание)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbCashId, vbUserProtocolId);

           --если удален да
           IF inisErased = 1
           THEN
               UPDATE Object SET isErased = TRUE WHERE Id = vbCashId;
           END IF;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21          *
*/

-- тест
--