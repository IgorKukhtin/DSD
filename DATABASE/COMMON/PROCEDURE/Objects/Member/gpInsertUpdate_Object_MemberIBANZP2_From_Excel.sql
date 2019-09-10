-- Function: gpInsertUpdate_Object_MemberIBANZP2_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIBANZP2_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIBANZP2_From_Excel(
    IN inINN                 TVarChar  ,    -- Код ИНН
    IN inCardSecond          TVarChar  ,    -- № карточного счета ЗП ф2
    IN inCardIBANSecond      TVarChar  ,    -- № карточного счета IBAN ЗП ф2
    IN inName                TVarChar  ,    -- Название объекта <
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());


   -- сначала ищем по инн, если не нашли или пустое - ищем по № карты и если не нашли или он тоже пустой - выдается ошибка, если нашли - апдейт этого св-ва
   IF COALESCE (inINN, '') <> ''
   THEN
   -- пытаемся найти физ. лицо по ИНН
   vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                  FROM ObjectString
                  WHERE ObjectString.DescId = zc_ObjectString_Member_INN()
                    AND TRIM (ObjectString.ValueData) = TRIM (inINN)
                  );
   END IF;

   IF COALESCE (inCardSecond, '') <> ''
   THEN
       -- пытаемся найти физ. лицо по inCard
       vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                      FROM ObjectString
                      WHERE ObjectString.DescId = zc_ObjectString_Member_CardSecond()
                        AND TRIM (ObjectString.ValueData) = TRIM (inCardSecond)
                      );
   END IF;

   -- если не нашли физ лицо , тогда ошибка
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
       RAISE EXCEPTION 'Ошибка.<%>, код ИНН <%> или номер карты <%> не найдены.', inName, TRIM (inINN), TRIM (inCardSecond);
   ELSE
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecond(), vbMemberId, inCardIBANSecond);

      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (vbMemberId, vbUserId);
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.19         *
*/
