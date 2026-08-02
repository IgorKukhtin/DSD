-- Function: gpGet_Object_Partner_Commerc()

DROP FUNCTION IF EXISTS gpGet_Object_Partner_Commerc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner_Commerc(
    IN inId          Integer,        -- Контрагенты 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,               
               PersonalId_1 Integer, PersonalName_1 TVarChar,
               PersonalId_2 Integer, PersonalName_2 TVarChar,
               PersonalId_3 Integer, PersonalName_3 TVarChar,
               PersonalId_4 Integer, PersonalName_4 TVarChar,
               PersonalId_5 Integer, PersonalName_5 TVarChar,
               PersonalId_6 Integer, PersonalName_6 TVarChar,
               PositionId_1 Integer, PositionName_1 TVarChar,
               PositionId_2 Integer, PositionName_2 TVarChar,
               PositionId_3 Integer, PositionName_3 TVarChar,
               PositionId_4 Integer, PositionName_4 TVarChar,
               PositionId_5 Integer, PositionName_5 TVarChar,
               PositionId_6 Integer, PositionName_6 TVarChar
               )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

       RETURN QUERY 
       SELECT 
             Object_Partner.Id          :: Integer AS Id
           , Object_Partner.ObjectCode  :: Integer AS Code
           , Object_Partner.ValueData   :: TVarChar AS Name
           
           , 0 ::Integer         AS PersonalId_1
           , ''::TVarChar        AS PersonalName_1
           , 0 ::Integer         AS PersonalId_2
           , ''::TVarChar        AS PersonalName_2
           , 0 ::Integer         AS PersonalId_3
           , ''::TVarChar        AS PersonalName_3
           , 0 ::Integer         AS PersonalId_4
           , ''::TVarChar        AS PersonalName_4
           , 0 ::Integer         AS PersonalId_5
           , ''::TVarChar        AS PersonalName_5
           , 0 ::Integer         AS PersonalId_6
           , ''::TVarChar        AS PersonalName_6

           , 0 ::Integer         AS PositionId_1
           , ''::TVarChar        AS PositionName_1
           , 0 ::Integer         AS PositionId_2
           , ''::TVarChar        AS PositionName_2
           , 0 ::Integer         AS PositionId_3
           , ''::TVarChar        AS PositionName_3
           , 0 ::Integer         AS PositionId_4
           , ''::TVarChar        AS PositionName_4
           , 0 ::Integer         AS PositionId_5
           , ''::TVarChar        AS PositionName_5
           , 0 ::Integer         AS PositionId_6
           , ''::TVarChar        AS PositionName_6
         

          /* , Object_Personal.PersonalId         AS PersonalId
           , Object_Personal.PersonalName       AS PersonalName
         
           , Object_Position.PersonalId    AS PositionId
           , Object_Position.PersonalName  AS PositionName
            */
       FROM Object AS Object_Partner
       WHERE Object_Partner.Id = inId;
       
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.26         *
*/

-- тест
-- select * from gpGet_Object_Partner_Commerc (inId := 0 , inSession := '5');