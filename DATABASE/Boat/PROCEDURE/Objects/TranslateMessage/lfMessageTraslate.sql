-- Function: lfMessageTraslate (TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS lfMessageTraslate (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION lfMessageTraslate(
    IN inMessage        TVarChar  ,
    IN inProcedureName  TVarChar  ,
    IN inParam1         TVarChar  ,
    IN inParam2         TVarChar  ,
    IN inParam3         TVarChar  ,
    IN inParam4         TVarChar  ,
    IN inParam5         TVarChar  ,
    IN inParam6         TVarChar  ,
    IN inParam7         TVarChar  ,
    IN inParam8         TVarChar  ,
    IN inParam9         TVarChar  ,
    IN inParam10        TVarChar  ,
   OUT outMessage       TVarChar  ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbLanguageId1 Integer;
   DECLARE vbvbLanguageId_user Integer;
   DECLARE vbposition Integer;
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TranslateWord());
   vbUserId:= lpGetUserBySession (inSession);


   -- Нашли главный Язык, он первый
   vbLanguageId1:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language()) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 1);
   -- определяем язык пользователя
   vbvbLanguageId_user := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbUserId AND OL.DescId = zc_ObjectLink_User_Language());


   -- Находим гл. элемент сообщене на рус. языке , ключ - vbLanguageId1 + inName + inProcedureName
   vbId :=(SELECT Object_TranslateMessage.Id
           FROM ObjectString AS ObjectString_Name
                INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                      ON ObjectLink_TranslateMessage_Language.ObjectId      = ObjectString_Name.ObjectId
                                     AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                     AND ObjectLink_TranslateMessage_Language.ChildObjectId = vbLanguageId1
                INNER JOIN Object AS Object_TranslateMessage
                                  ON Object_TranslateMessage.Id = ObjectString_Name.ObjectId
                                 AND Object_TranslateMessage.DescId = zc_Object_TranslateMessage()
                                 AND Object_TranslateMessage.ValueData ILIKE inMessage
           WHERE ObjectString_Name.DescId    = zc_ObjectString_TranslateMessage_Name()
             AND ObjectString_Name.ValueData ILIKE inProcedureName
            );

   -- перевод сообщения на языке пользователя
   outMessage := COALESCE ((SELECT Object_TranslateMessage.ValueData       
                  FROM Object AS Object_TranslateMessage
                      INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                            ON ObjectLink_TranslateMessage_Language.ObjectId = Object_TranslateMessage.Id
                                           AND ObjectLink_TranslateMessage_Language.DescId = zc_ObjectLink_TranslateMessage_Language()
                                           AND ObjectLink_TranslateMessage_Language.ChildObjectId = vbvbLanguageId_user

                      INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                            ON ObjectLink_TranslateMessage_Parent.ObjectId = Object_TranslateMessage.Id
                                           AND ObjectLink_TranslateMessage_Parent.DescId = zc_ObjectLink_TranslateMessage_Parent()
                                           AND ObjectLink_TranslateMessage_Parent.ChildObjectId = vbId
                  WHERE Object_TranslateMessage.DescId = zc_Object_TranslateMessage() )
                 , inMessage
                  );
                  
   -- подменяем значения <%> конкретніе значения
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam1,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam1  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam2,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam2  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam3,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam3  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam4,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam4  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam5,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam5  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam6,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam6  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam7,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam7  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam8,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam8  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam9,'')  ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam9  from vbposition for 3) END;
   vbposition := position('<%>' IN outMessage); outMessage  := CASE WHEN COALESCE (inParam10,'') ='' OR vbposition=0 THEN outMessage ELSE overlay (outMessage PLACING inParam10 from vbposition for 3) END;


   -- составляем строку сообщения вместе с параметрами
 /*  outMessage := (''''||outMessage||''''|| CASE WHEN COALESCE (inParam1,'') <> '' THEN ', '||inParam1  ELSE '' END
                                        || CASE WHEN COALESCE (inParam2,'') <> '' THEN ', '||inParam2  ELSE '' END
                                        || CASE WHEN COALESCE (inParam3,'') <> '' THEN ', '||inParam3  ELSE '' END
                                        || CASE WHEN COALESCE (inParam4,'') <> '' THEN ', '||inParam4  ELSE '' END
                                        || CASE WHEN COALESCE (inParam5,'') <> '' THEN ', '||inParam5  ELSE '' END
                                        || CASE WHEN COALESCE (inParam6,'') <> '' THEN ', '||inParam6  ELSE '' END
                                        || CASE WHEN COALESCE (inParam7,'') <> '' THEN ', '||inParam7  ELSE '' END
                                        || CASE WHEN COALESCE (inParam8,'') <> '' THEN ', '||inParam8  ELSE '' END
                                        || CASE WHEN COALESCE (inParam9,'') <> '' THEN ', '||inParam9  ELSE '' END
                                        || CASE WHEN COALESCE (inParam10,'')<> '' THEN ', '||inParam10 ELSE '' END
                  );*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


--
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.12.20          *
*/

-- тест
-- 
/*select * from lfMessageTraslate (inMessage:= 'Ошибка.Значение <УП статья назначения> не найдена для группы <%>.' ::TVarChar, inProcedureName:= 'gpInsertUpdate_Object_Goods'::TVarChar,
 inParam1:= 'inParam1'::TVarChar, inParam2:= 'inParam2'::TVarChar, inParam3:= 'inParam3'::TVarChar, inParam4:= 'inParam4'::TVarChar, inParam5:= 'inParam5'::TVarChar
, inParam6:= 'inParam6', inParam7:= 'inParam7', inParam8:= 'inParam8', inParam9:= '', inParam10:= 'inParam10', inSession := '2020'); --zfCalc_UserAdmin()
*/