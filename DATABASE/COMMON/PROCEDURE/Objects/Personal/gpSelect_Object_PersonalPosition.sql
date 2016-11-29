-- Function: gpSelect_Object_PersonalPosition (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalPosition (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalPosition(
    IN inPositionId   Integer , --
    IN inIsShowAll    Boolean,    --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MemberCode Integer, MemberName TVarChar, DriverCertificate TVarChar, Card TVarChar,
               PositionId Integer, PositionCode Integer, PositionName TVarChar,
               PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar,
               PersonalServiceListId Integer, PersonalServiceListName TVarChar,
               PersonalServiceListOfficialId Integer, PersonalServiceListOfficialName TVarChar,
               InfoMoneyId Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               DateIn TDateTime, DateOut TDateTime, isDateOut Boolean, isMain Boolean, isOfficial Boolean, isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbObjectId_Constraint Integer;

   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY 
     SELECT 
           Object_Personal_View.PersonalId   AS Id
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Card.ValueData              AS Card

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionCode
         , Object_Personal_View.PositionName

         , Object_Personal_View.PositionLevelId
         , Object_Personal_View.PositionLevelCode
         , Object_Personal_View.PositionLevelName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitCode
         , Object_Personal_View.UnitName

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupCode
         , Object_Personal_View.PersonalGroupName

         , Object_PersonalServiceList.Id           AS PersonalServiceListId 
         , Object_PersonalServiceList.ValueData    AS PersonalServiceListName 

         , Object_PersonalServiceListOfficial.Id           AS PersonalServiceListOfficialId 
         , Object_PersonalServiceListOfficial.ValueData    AS PersonalServiceListOfficialName 

         , vbInfoMoneyId       AS InfoMoneyId
         , vbInfoMoneyName     AS InfoMoneyName
         , vbInfoMoneyName_all AS InfoMoneyName_all
 
         , COALESCE (Object_SheetWorkTime.Id, COALESCE (Object_Position_SheetWorkTime.Id, COALESCE (Object_Unit_SheetWorkTime.Id, 0)) )  AS SheetWorkTimeId 
         , COALESCE (Object_SheetWorkTime.ValueData, COALESCE ('* '||Object_Position_SheetWorkTime.ValueData, COALESCE ('** '||Object_Unit_SheetWorkTime.ValueData, '')) ) ::TVarChar     AS SheetWorkTimeName

         , Object_Personal_View.DateIn
         , Object_Personal_View.DateOut_user AS DateOut
         , Object_Personal_View.isDateOut
         , Object_Personal_View.isMain
         , Object_Personal_View.isOfficial
         
         , Object_Personal_View.isErased
     FROM Object_Personal_View
       
          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Personal_View.MemberId 
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Personal_View.MemberId 
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
      
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                               ON ObjectLink_Personal_SheetWorkTime.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Position_SheetWorkTime
                               ON ObjectLink_Position_SheetWorkTime.ObjectId = Object_Personal_View.PositionId
                              AND ObjectLink_Position_SheetWorkTime.DescId = zc_ObjectLink_Position_SheetWorkTime()
          LEFT JOIN Object AS Object_Position_SheetWorkTime ON Object_Position_SheetWorkTime.Id = ObjectLink_Position_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                               ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Personal_View.UnitId
                              AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
          LEFT JOIN Object AS Object_Unit_SheetWorkTime ON Object_Unit_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId

     WHERE (Object_Personal_View.isErased = FALSE OR (Object_Personal_View.isErased = TRUE AND inIsShowAll = TRUE))
       AND Object_Personal_View.PositionId IN (SELECT inPositionId UNION SELECT 81178 /*экспедитор*/  WHERE inPositionId = 8466 /*водитель*/)
/*           
    UNION ALL
        SELECT
           0   AS Id
         , 0 AS MemberCode
         , CAST ('УДАЛИТЬ' as TVarChar)  AS MemberName
         , CAST ('' as TVarChar) AS DriverCertificate
         , CAST ('' as TVarChar) AS Card
         , 0 AS PositionId
         , 0 AS PositionCode
         , CAST ('' as TVarChar) AS PositionName
         , 0 AS PositionLevelId
         , 0 AS PositionLevelCode
         , CAST ('' as TVarChar) AS PositionLevelName
         , 0 AS UnitId
         , 0 AS UnitCode
         , CAST ('' as TVarChar) AS UnitName
         , 0 AS PersonalGroupId
         , 0 AS PersonalGroupCode
         , CAST ('' as TVarChar) AS PersonalGroupName
         , 0 AS PersonalServiceListId 
         , CAST ('' as TVarChar) AS PersonalServiceListName 
         , 0 AS PersonalServiceListOfficialId 
         , CAST ('' as TVarChar) AS PersonalServiceListOfficialName 
         , 0 AS InfoMoneyId
         , CAST ('' as TVarChar) AS InfoMoneyName
         , CAST ('' as TVarChar) AS InfoMoneyName_all
         , 0 AS SheetWorkTimeId 
         , CAST ('' as TVarChar)    AS SheetWorkTimeName
         , CAST (NULL as TDateTime) AS DateIn
         , CAST (NULL as TDateTime) AS DateOut
         , FALSE AS isDateOut
         , FALSE AS isMain
         , FALSE AS isOfficial
         , FALSE AS isErased*/
    ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.16         *
*/
-- тест
-- SELECT * FROM gpSelect_Object_PersonalPosition (inPositionId:= 8944, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
