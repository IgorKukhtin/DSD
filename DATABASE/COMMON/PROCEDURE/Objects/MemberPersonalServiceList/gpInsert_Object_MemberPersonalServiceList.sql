-- Function: gpInsert_Object_MemberPersonalServiceList()

DROP FUNCTION IF EXISTS gpInsert_Object_MemberPersonalServiceList (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_Object_MemberPersonalServiceList(
    IN inMemberId                      Integer   ,     -- Физические лица
    IN inSession                       TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberPersonalServiceList());


   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Физ.лицо> не выбрано.';
   END IF;
   
   -- добавляем все ведлмости , кроме тех что уже есть
   PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                        ,  inPersonalServiceListId  := PersonalServiceList.Id
                                                        ,  inMemberId               := inMemberId
                                                        ,  ioIsAll                  := FALSE   :: Boolean
                                                        ,  inComment                := ''      :: TVarChar
                                                        ,  inSession                := inSession
                                                          )
   FROM Object AS PersonalServiceList
   WHERE PersonalServiceList.DescId = zc_Object_PersonalServiceList() 
     AND PersonalServiceList.isErased = FALSE
     AND PersonalServiceList.Id NOT IN (SELECT ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId AS  PersonalServiceListId
                                        FROM Object AS Object_MemberPersonalServiceList
                                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                                                   ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                                                  AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                                  AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = inMemberId

                                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                                                   ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                                                  AND COALESCE (ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId,0) <> 0
                                        WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                                        )
   ;



END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.04.20         *
*/

-- тест
-- 