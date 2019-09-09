-- Function: gpInsertUpdate_Object_MemberZP1_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIBANZP1_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIBANZP1_From_Excel(
    IN inINN                 TVarChar  ,    -- Код ИНН
    IN inCard                TVarChar  ,    -- № карточного счета ЗП ф1
    IN inCardIBAN            TVarChar  ,    -- № карточного счета IBAN ЗП ф1
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

   IF COALESCE (inCard, '') <> ''
   THEN
       -- пытаемся найти физ. лицо по inCard
       vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                      FROM ObjectString
                      WHERE ObjectString.DescId = zc_ObjectString_Member_Card()
                        AND TRIM (ObjectString.ValueData) = TRIM (inCard)
                      );
   END IF;

   -- если не нашли физ лицо , тогда ошибка
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
       RAISE EXCEPTION 'Ошибка. Код ИНН <%> не найден <%>.', TRIM (inINN), inName;
   ELSE
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBAN(), vbMemberId, inCardIBAN);

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
