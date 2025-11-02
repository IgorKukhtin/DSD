 -- Function: gpInsertUpdate_Object_PersonalServiceList_Member_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList_Member_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList_Member_Load(
    IN inPersonalServiceListCode  Integer ,
    IN inPersonalServiceListName  TVarChar,
    IN inMemberName_main          TVarChar, --
    IN inMemberName_1             TVarChar,
    IN inMemberName_2             TVarChar,
    IN inMemberName_3             TVarChar,
    IN inMemberName_4             TVarChar,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
           vbPersonalServiceListId Integer;
           vbMemberId_main         Integer;
           vbMemberId_1            Integer;
           vbMemberId_2            Integer;
           vbMemberId_3            Integer;
           vbMemberId_4            Integer;

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


     IF TRIM (COALESCE (inMemberName_main,'')) <> ''
     THEN
         -- поиск - main
         vbMemberId_main:= (SELECT Object.Id
                            FROM Object
                            WHERE TRIM (Object.ValueData) ILIKE TRIM (inMemberName_main)
                              AND Object.DescId     = zc_Object_Member()
                           );
         -- Проверка
         IF COALESCE (vbMemberId_main, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_main;
         END IF;

     ELSE
         RAISE EXCEPTION 'Ошибка.Не определено физ.лицо - Пользователь (ведомость) .', inMemberName_main;
     END IF;


     IF TRIM (COALESCE (inMemberName_1,'')) <> ''
     THEN
         -- поиск - 1
         vbMemberId_1:= (SELECT Object.Id
                         FROM Object
                         WHERE TRIM (Object.ValueData) ILIKE TRIM (inMemberName_1)
                           AND Object.DescId     = zc_Object_Member()
                        );
         -- Проверка
         IF COALESCE (vbMemberId_1, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо-1 <%> .', inMemberName_1;
         END IF;

     END IF;

     --
     IF TRIM (COALESCE (inMemberName_2,'')) <> ''
     THEN
         -- поиск - 2
         vbMemberId_2:= (SELECT Object.Id
                         FROM Object
                         WHERE TRIM (Object.ValueData) ILIKE TRIM (inMemberName_2)
                           AND Object.DescId     = zc_Object_Member()
                        );
         -- Проверка
         IF COALESCE (vbMemberId_2, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо-2 <%> .', inMemberName_2;
         END IF;

     END IF;

     IF COALESCE (inMemberName_3,'') <> ''
     THEN
         -- поиск - 3
         vbMemberId_3:= (SELECT Object.Id
                         FROM Object
                         WHERE TRIM (Object.ValueData) ILIKE  TRIM (inMemberName_3)
                           AND Object.DescId     = zc_Object_Member()
                        );
         -- Проверка
         IF COALESCE (vbMemberId_3, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_3;
         END IF;

     END IF;

     IF COALESCE (inMemberName_4,'') <> ''
     THEN
         -- поиск - 4
         vbMemberId_4:= (SELECT Object.Id
                         FROM Object
                         WHERE TRIM (Object.ValueData) ILIKE TRIM (inMemberName_4)
                           AND Object.DescId     = zc_Object_Member()
                        );
         -- Проверка
         IF COALESCE (vbMemberId_4, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдено физ.лицо <%> .', inMemberName_4;
         END IF;

     END IF;


     -- main
     IF vbMemberId_main > 0
     THEN
         -- сохранили
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), vbPersonalServiceListId, vbMemberId_main);
         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (vbPersonalServiceListId, vbUserId);

     END IF;


     -- ищем - 1 в MemberPersonalServiceList
     IF vbMemberId_1 > 0 AND vbMemberId_1 NOT IN (COALESCE (vbMemberId_main, 0))
        AND NOT EXISTS (SELECT 1
                        FROM Object AS Object_MemberPersonalServiceList
                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                                   ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                  AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_1

                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                                   ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId      = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                        WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                       )
     THEN
         -- сохранили св-во
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_1
                                                              ,  ioIsAll                  := FALSE
                                                              ,  inComment                := ''
                                                              ,  inSession                := inSession
                                                                );
     END IF;


     -- ищем - 2 в MemberPersonalServiceList
     IF vbMemberId_2 > 0 AND vbMemberId_2 NOT IN (COALESCE (vbMemberId_main, 0), COALESCE (vbMemberId_1, 0))
        AND NOT EXISTS (SELECT 1
                        FROM Object AS Object_MemberPersonalServiceList
                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                                   ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                  AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_2

                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                                   ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId      = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                        WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                       )
     THEN
         -- сохранили св-во
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_2
                                                              ,  ioIsAll                  := FALSE
                                                              ,  inComment                := ''
                                                              ,  inSession                := inSession
                                                                );
     END IF;


     -- ищем - 3 в MemberPersonalServiceList
     IF vbMemberId_3 > 0 AND vbMemberId_3 NOT IN (COALESCE (vbMemberId_main, 0), COALESCE (vbMemberId_1, 0), COALESCE (vbMemberId_2, 0))
        AND NOT EXISTS (SELECT 1
                        FROM Object AS Object_MemberPersonalServiceList
                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                                   ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                  AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_3

                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                                   ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId      = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                        WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                       )
     THEN
         -- сохранили св-во
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_3
                                                              ,  ioIsAll                  := FALSE
                                                              ,  inComment                := ''
                                                              ,  inSession                := inSession
                                                                );
     END IF;


     -- ищем - 4 в MemberPersonalServiceList
     IF vbMemberId_4 > 0 AND vbMemberId_4 NOT IN (COALESCE (vbMemberId_main, 0), COALESCE (vbMemberId_1, 0), COALESCE (vbMemberId_2, 0), COALESCE (vbMemberId_3, 0))
        AND NOT EXISTS (SELECT 1
                        FROM Object AS Object_MemberPersonalServiceList
                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                                   ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                  AND ObjectLink_MemberPersonalServiceList_Member.ChildObjectId = vbMemberId_4

                             INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                                   ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId      = Object_MemberPersonalServiceList.Id
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                                  AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                        WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                       )
     THEN
         -- сохранили св-во
         PERFORM gpInsertUpdate_Object_MemberPersonalServiceList(ioId                     := 0
                                                              ,  inPersonalServiceListId  := vbPersonalServiceListId
                                                              ,  inMemberId               := vbMemberId_4
                                                              ,  ioIsAll                  := FALSE
                                                              ,  inComment                := ''
                                                              ,  inSession                := inSession
                                                                );
     END IF;


     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION 'Тест. Ок. <%> / <%>', vbPersonalServiceListId, vbMemberId_main;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.25         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PersonalServiceList_Member_Load (inPersonalServiceListCode := 169 , inPersonalServiceListName := 'Відомість ф. Київ ІТП' , inMemberName_main := 'Іванова Світлана Сергіївна' , inMemberName_1 := 'Брикова Вікторія Валеріївна' , inMemberName_2 := 'Глотова Олена Станіславівна' , inMemberName_3 := 'Іванова Світлана Сергіївна' , inMemberName_4 := '' ,  inSession := '5');
