-- Function: gpUpdate_Object_ReportCollationErased(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollationErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollationErased(
    IN inId             Integer  , -- 
    IN inSession        TVarChar
)
RETURNS VOID 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());

     -- только в этом случае - ничего не делаем, 
     IF COALESCE (inId, 0) = 0
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

                     
     -- сохранили свойство <Дата Сдали в бухгалтерию>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Buh(), inId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (Сдали в бухгалтерию)>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Buh(), inId, vbMemberId_user);
     -- сохранили свойство <Сдали в бухгалтерию>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReportCollation_Buh(), inId, False);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.01.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ReportCollationErased(inBarCode := '201000923136' ,  inSession := '5');
