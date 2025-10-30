 -- Function: gpInsertUpdate_Object_PersonalServiceList_Member_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList_Member_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList_Member_Load(
    IN inPersonalServiceListCode  Integer ,
    IN inPersonalServiceListName  TVarChar,
    IN inMemberName_1             TVarChar, -- 
    IN inMemberName_2             TVarChar,
    IN inMemberName_3             TVarChar,
    IN inMemberName_4             TVarChar,
    IN inMemberName_5             TVarChar,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
           vbPersonalServiceListId Integer;
           vbMemberId_1 Integer;
           vbMemberId_2 Integer;
           vbMemberId_3 Integer;
           vbMemberId_4 Integer;
           vbMemberId_5 Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустое Подразделение  - Пропустили!!!
     IF COALESCE (inPersonalServiceListCode, 0) = 0 THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;

     -- !!!поиск ИД ведомости!!!
     vbPersonalServiceListId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = inPersonalServiceListCode
                                  AND Object.DescId     = zc_Object_PersonalServiceList()
                               );

      -- Проверка
     IF COALESCE (vbPersonalServiceListId, 0) = 0 THEN
       -- RETURN;
        RAISE EXCEPTION 'Ошибка.Не найдена ведомость (<%>) <%> .', inPersonalServiceListCode, inPersonalServiceListName;
     END IF;

     IF COALESCE (inMemberName_1,'') <> ''
     THEN
         -- !!!поиск ИД ФИЗ лица!!!
         vbMemberId_1:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_1))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_1,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_1;
         END IF;
         
         -- сохранили св-во 
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), vbPersonalServiceListId, vbMemberId_1);       
     END IF;

     IF COALESCE (inMemberName_2,'') <> ''
     THEN
         -- !!!поиск ИД ФИЗ лица!!!
         vbMemberId_2:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_2))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_2,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_2;
         END IF;
         
         --проверка
         IF vbMemberId_2 = vbMemberId_1
         THEN
             RETURN;
         END IF;

         --ищем уже сохраненные в MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_2

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- сохранили св-во 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_2
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;

     --
     IF COALESCE (inMemberName_3,'') <> ''
     THEN
         -- !!!поиск ИД ФИЗ лица!!!
         vbMemberId_3:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_3))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_3,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_3;
         END IF;
         
         --проверка
         IF (vbMemberId_3 = vbMemberId_1) OR (vbMemberId_3 = vbMemberId_2)
         THEN
             RETURN;
         END IF;

         --ищем уже сохраненные в MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_3

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- сохранили св-во 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_3
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;

     IF COALESCE (inMemberName_4,'') <> ''
     THEN
         -- !!!поиск ИД ФИЗ лица!!!
         vbMemberId_4:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_4))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_4,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_4;
         END IF;
         
         --проверка
         IF (vbMemberId_4 = vbMemberId_1) OR (vbMemberId_4 = vbMemberId_2) OR (vbMemberId_4 = vbMemberId_3)
         THEN
             RETURN;
         END IF;

         --ищем уже сохраненные в MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_4

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- сохранили св-во 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_4
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;
     
     IF COALESCE (inMemberName_5,'') <> ''
     THEN
         -- !!!поиск ИД ФИЗ лица!!!
         vbMemberId_5:= (SELECT Object.Id
                         FROM Object
                         WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inMemberName_5))
                           AND Object.DescId     = zc_Object_Member()
                        );
         IF COALESCE (vbMemberId_5,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_5;
         END IF;
         
         --проверка
         IF (vbMemberId_5 = vbMemberId_1) OR (vbMemberId_5 = vbMemberId_2) OR (vbMemberId_5 = vbMemberId_3) OR (vbMemberId_5 = vbMemberId_4)
         THEN
             RETURN;
         END IF;

         --ищем уже сохраненные в MemberPersonalServiceList
         IF EXISTS (SELECT 1
                    FROM Object AS Object_MemberPersonalServiceList
                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                               ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                              AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_5

                         INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                               ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                              AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                    WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList())
         THEN
             RETURN;
         END IF; 
         
         -- сохранили св-во 
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0       :: Integer
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_5
                                                              ,  ioIsAll                  := FALSE   :: Boolean
                                                              ,  inComment                := ''      :: TVarChar
                                                              ,  inSession                := inSession
                                                                );       
     END IF;
  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION 'Тест. Ок. <%> / <%>', vbPersonalServiceListId, vbMemberId_1; 
     END IF;   

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbPersonalServiceListId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.25         *
*/

-- тест
--
