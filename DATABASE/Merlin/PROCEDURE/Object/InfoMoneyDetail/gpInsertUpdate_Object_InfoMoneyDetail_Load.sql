--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoneyDetail_Load (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyDetail_Load(
    IN inCode                Integer,       -- код 
    IN inName                TVarChar,      -- Название 
    IN inInfoMoneyKindName   TVarChar,      -- Название типа
    IN inisUserAll           TVarChar,      -- Доступ всем
    IN inUserId              Integer,       -- Id пользователя
    IN inisErased            Integer,       -- удален
    IN inProtocolDate        TDateTime,     -- дата протокола
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbInfoMoneyDetailId      Integer;
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

   IF COALESCE (inCode,0) <> 0
   THEN
       -- поиск в спр. 
       vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyDetail() AND Object.ObjectCode = inCode);

       -- Eсли не нашли записываем
       --IF COALESCE (vbInfoMoneyDetailId,0) = 0
       --THEN
          -- сохранили <Объект>
           vbInfoMoneyDetailId := lpInsertUpdate_Object(COALESCE (vbInfoMoneyDetailId,0), zc_Object_InfoMoneyDetail(), inCode ::Integer, TRIM (inName) ::TVarChar);
        
           -- сохранили
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoneyDetail_InfoMoneyKind(), vbInfoMoneyDetailId, CASE WHEN TRIM (inInfoMoneyKindName) = 'Приход' THEN zc_Enum_InfoMoney_In()
                                                                                                                       WHEN TRIM (inInfoMoneyKindName) = 'Расход' THEN zc_Enum_InfoMoney_Out()
                                                                                                                       ELSE NULL
                                                                                                                  END :: Integer );

           -- сохранили свойство <>
           PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_InfoMoneyDetail_UserAll(), vbInfoMoneyDetailId, CASE WHEN TRIM (inisUserAll) = 'Да' THEN TRUE ELSE FALSE END);

           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbInfoMoneyDetailId, inProtocolDate ::TDateTime);
           -- сохранили свойство <Пользователь (создание)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbInfoMoneyDetailId, vbUserProtocolId);

           --если удален да
           IF inisErased = 1
           THEN
                UPDATE Object SET isErased = TRUE WHERE Id = vbInfoMoneyDetailId;
           END IF;

       --END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21          *
*/

-- тест
--