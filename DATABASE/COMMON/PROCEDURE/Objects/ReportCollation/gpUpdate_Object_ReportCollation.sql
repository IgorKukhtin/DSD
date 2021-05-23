-- Function: gpUpdate_Object_ReportCollation(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Buh (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation(
    IN inBarCode             TVarChar  , -- штрихкод документа продажи 
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId Integer;
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());

     -- только в этом случае - ничего не делаем, т.к. из дельфи вызывается "лишний" раз
     IF COALESCE (TRIM (inBarCode), '') = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;

     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- Проверка
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- по штрих коду Акт сверки
     vbId:= (SELECT Object.Id
             FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS Id) AS tmp
                 INNER JOIN Object ON Object.Id = tmp.Id
                                  AND Object.DescId = zc_Object_ReportCollation()
                                  AND Object.isErased = False
             WHERE CHAR_LENGTH (inBarCode) >= 13
            UNION
             SELECT Object.Id
             FROM (SELECT zfConvert_StringToNumber (inBarCode) AS BarCode ) AS tmp
                  INNER JOIN Object ON Object.ObjectCode = tmp.BarCode
                                   AND Object.DescId = zc_Object_ReportCollation()
                                   AND Object.isErased = FALSE
             WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13
             );

     -- Проверка
     IF COALESCE (vbId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Акт сверки с № <%> не найден.', inBarCode;
     END IF;

                     
     -- сохранили свойство <Дата Сдали в бухгалтерию>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Buh(), vbId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (Сдали в бухгалтерию)>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Buh(), vbId, vbMemberId_user);
     -- сохранили свойство <Сдали в бухгалтерию>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReportCollation_Buh(), vbId, TRUE);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= FALSE);


if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin - Errr _end <%>', inBarCode;
    -- 'Повторите действие через 3 мин.'
end if;

   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.01.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ReportCollation(inBarCode := '201000923136' ,  inSession := '5');
