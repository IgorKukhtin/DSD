-- Function: gpUpdate_Unit_StartTest()

DROP FUNCTION IF EXISTS gpUpdate_Unit_StartTest (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_StartTest(
   
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbPositionCode Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TestingTuning());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;
   
     IF inSession <> '3'
     THEN
       SELECT COALESCE(Object_Position.ObjectCode, 1)
       INTO vbPositionCode
       FROM Object AS Object_User

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                                             
       WHERE Object_User.Id = vbUserId
         AND Object_User.DescId = zc_Object_User();
     ELSE
       vbPositionCode := 2;
     END IF;
             
     IF vbPositionCode = 1
     THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Exam(), vbUnitId, CURRENT_TIMESTAMP);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Unit_StartTest(TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 35.10.21                                                                     *  
*/

-- тест
-- select * from gpUpdate_Unit_StartTest(inSession:= '3');