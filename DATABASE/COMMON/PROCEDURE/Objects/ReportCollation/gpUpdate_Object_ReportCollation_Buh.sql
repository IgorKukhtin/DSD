-- Function: gpUpdate_Object_ReportCollation_Buh (Integer, TDateTime, Boolean TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Buh (Integer, TDateTime, Boolean , TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Buh (Integer, Boolean , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation_Buh(
    In inId                 Integer   ,
    IN inIsBuh              Boolean   ,
    IN inSession            TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());

     -- Проверка
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Акт сверки не сохранен.';
     END IF;

        
     -- сохранили свойство <Сдали в бухгалтерию>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReportCollation_Buh(), inId, inIsBuh);
     
     -- если признак сдали в бух = True , тогда записіваем дату и пользователя
     IF inIsBuh = TRUE     
     THEN
         -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
         vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                           (SELECT ObjectLink_User_Member.ChildObjectId
                            FROM ObjectLink AS ObjectLink_User_Member
                            WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                              AND ObjectLink_User_Member.ObjectId = vbUserId)
                           END ;
         -- Проверка
         IF COALESCE (vbMemberId_user, 0) = 0
         THEN 
              RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
         END IF;

         -- сохранили свойство <Пользователь (Сдали в бухгалтерию)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Buh(), inId, vbMemberId_user);

         -- сохранили свойство <Дата Сдали в бухгалтерию>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Buh(), inId, CURRENT_TIMESTAMP);
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= FALSE);
   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.18         *
*/

-- тест
-- 