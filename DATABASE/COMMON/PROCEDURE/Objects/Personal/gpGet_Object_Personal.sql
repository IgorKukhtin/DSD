-- Function: gpGet_Object_Personal(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- Сотрудники
    IN inMaskId      Integer   ,    -- id для копирования
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MemberId Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar,
               PositionLevelId Integer, PositionLevelName TVarChar,
               UnitId Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupName TVarChar,
               PersonalServiceListId Integer, PersonalServiceListName TVarChar,
               PersonalServiceListOfficialId Integer, PersonalServiceListOfficialName TVarChar,
               PersonalServiceListCardSecondId Integer, PersonalServiceListCardSecondName TVarChar,
               ServiceListId_AvanceF2 Integer, ServiceListName_AvanceF2 TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               StorageLineId Integer, StorageLineName TVarChar,
               DateIn TDateTime, DateOut TDateTime, DateSend TDateTime
             , isDateOut Boolean, isDateSend Boolean, isMain Boolean
             , Member_ReferId Integer
             , Member_ReferCode Integer
             , Member_ReferName TVarChar
             , Member_MentorId Integer
             , Member_MentorCode Integer
             , Member_MentorName TVarChar
             , ReasonOutId Integer
             , ReasonOutCode Integer
             , ReasonOutName TVarChar
             , Comment TVarChar
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Personal());
   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) <> 0))
   THEN
     RETURN QUERY
     SELECT
           Object_Personal_View.MemberId     AS MemberId
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionName

         , Object_Personal_View.PositionLevelId
         , Object_Personal_View.PositionLevelName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitName

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupName

         , Object_PersonalServiceList.Id           AS PersonalServiceListId 
         , Object_PersonalServiceList.ValueData    AS PersonalServiceListName 

         , COALESCE (Object_PersonalServiceListOfficial.Id, CAST (0 as Integer))            AS PersonalServiceListOfficialId 
         , COALESCE (Object_PersonalServiceListOfficial.ValueData, CAST ('' as TVarChar))   AS PersonalServiceListOfficialName 
         
         , COALESCE (Object_PersonalServiceListCardSecond.Id, CAST (0 as Integer))          AS PersonalServiceListCardSecondId
         , COALESCE (Object_PersonalServiceListCardSecond.ValueData, CAST ('' as TVarChar)) AS PersonalServiceListCardSecondName         

         , COALESCE (Object_PersonalServiceListAvance_F2.Id, CAST (0 as Integer))           AS ServiceListId_AvanceF2
         , COALESCE (Object_PersonalServiceListAvance_F2.ValueData, CAST ('' as TVarChar))  AS ServiceListName_AvanceF2

         , Object_SheetWorkTime.Id           AS SheetWorkTimeId 
         , Object_SheetWorkTime.ValueData    AS SheetWorkTimeName

         , Object_Personal_View.StorageLineId
         , Object_Personal_View.StorageLineName

         , Object_Personal_View.DateIn
         -- , Object_Personal_View.DateOut
         , CASE WHEN Object_Personal_View.isErased = TRUE THEN Object_Personal_View.DateOut 
                WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE
                ELSE Object_Personal_View.DateOut_user
           END :: TDateTime AS DateOut
         , Object_Personal_View.DateSend  ::TDateTime
         
         , Object_Personal_View.isDateOut
         , Object_Personal_View.isDateSend ::Boolean
         -- , Object_Personal_View.isMain
         , FALSE :: Boolean AS isMain

         , Object_Personal_View.Member_ReferId
         , Object_Personal_View.Member_ReferCode
         , Object_Personal_View.Member_ReferName
         , Object_Personal_View.Member_MentorId
         , Object_Personal_View.Member_MentorCode
         , Object_Personal_View.Member_MentorName
         , Object_Personal_View.ReasonOutId
         , Object_Personal_View.ReasonOutCode
         , Object_Personal_View.ReasonOutName
         , Object_Personal_View.Comment
    FROM Object_Personal_View
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                               ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
          LEFT JOIN Object AS Object_PersonalServiceListCardSecond ON Object_PersonalServiceListCardSecond.Id = ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                               ON ObjectLink_Personal_SheetWorkTime.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                               ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
          LEFT JOIN Object AS Object_PersonalServiceListAvance_F2 ON Object_PersonalServiceListAvance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId

    WHERE Object_Personal_View.PersonalId = inMaskId;
   END IF;

   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) = 0))
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)   AS MemberId
           , CAST (0 as Integer)   AS MemberCode
           , CAST ('' as TVarChar) AS MemberName

           , CAST (0 as Integer)   AS PositionId
           , CAST ('' as TVarChar) AS PositionName

           , CAST (0 as Integer)   AS PositionLevelId
           , CAST ('' as TVarChar) AS PositionLevelName

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS PersonalGroupId
           , CAST ('' as TVarChar) AS PersonalGroupName

           , CAST (0 as Integer)   AS PersonalServiceListId 
           , CAST ('' as TVarChar) AS PersonalServiceListName

           , CAST (0 as Integer)   AS PersonalServiceListOfficialId 
           , CAST ('' as TVarChar) AS PersonalServiceListOfficialName

           , CAST (0 as Integer)   AS PersonalServiceListCardSecondId 
           , CAST ('' as TVarChar) AS PersonalServiceListCardSecondName
           
           , 0                      AS ServiceListId_AvanceF2
           , CAST ('' as TVarChar)  AS ServiceListName_AvanceF2

           , CAST (0 as Integer)   AS SheetWorkTimeId 
           , CAST ('' as TVarChar) AS SheetWorkTimeName

           , CAST (0 as Integer)   AS StorageLineId
           , CAST ('' as TVarChar) AS StorageLineName

           , CURRENT_DATE :: TDateTime AS DateIn
           , CURRENT_DATE :: TDateTime AS DateOut
           , CAST (NULL as TDateTime) AS DateSend
           
           , FALSE AS isDateOut
           , FALSE AS isDateSend
           -- , TRUE  AS isMain
           , FALSE  AS isMain
           , 0                        AS Member_ReferId
           , 0                        AS Member_ReferCode
           , CAST ('' as TVarChar)    AS Member_ReferName
           , 0                        AS Member_MentorId
           , 0                        AS Member_MentorCode
           , CAST ('' as TVarChar)    AS Member_MentorName
           , 0                        AS ReasonOutId
           , 0                        AS ReasonOutCode
           , CAST ('' as TVarChar)    AS ReasonOutName
           , CAST ('' as TVarChar)    AS Comment           
           ;
  END IF;

  IF COALESCE (inId, 0) <> 0
   THEN
     RETURN QUERY
     SELECT
           Object_Personal_View.MemberId     AS MemberId
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionName

         , Object_Personal_View.PositionLevelId
         , Object_Personal_View.PositionLevelName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitName

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupName

         , Object_PersonalServiceList.Id           AS PersonalServiceListId 
         , Object_PersonalServiceList.ValueData    AS PersonalServiceListName 

         , COALESCE (Object_PersonalServiceListOfficial.Id, CAST (0 as Integer))            AS PersonalServiceListOfficialId 
         , COALESCE (Object_PersonalServiceListOfficial.ValueData, CAST ('' as TVarChar))   AS PersonalServiceListOfficialName 

         , COALESCE (Object_PersonalServiceListCardSecond.Id, CAST (0 as Integer))          AS PersonalServiceListCardSecondId
         , COALESCE (Object_PersonalServiceListCardSecond.ValueData, CAST ('' as TVarChar)) AS PersonalServiceListCardSecondName
         
         , COALESCE (Object_PersonalServiceListAvance_F2.Id, CAST (0 as Integer))           AS ServiceListId_AvanceF2
         , COALESCE (Object_PersonalServiceListAvance_F2.ValueData, CAST ('' as TVarChar))  AS ServiceListName_AvanceF2 
 
         , Object_SheetWorkTime.Id           AS SheetWorkTimeId 
         , Object_SheetWorkTime.ValueData    AS SheetWorkTimeName

         , Object_Personal_View.StorageLineId
         , Object_Personal_View.StorageLineName

         , Object_Personal_View.DateIn
         -- , Object_Personal_View.DateOut
         , CASE WHEN Object_Personal_View.isErased = TRUE THEN Object_Personal_View.DateOut 
                WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE
                ELSE Object_Personal_View.DateOut_user
           END :: TDateTime AS DateOut
         , Object_Personal_View.DateSend ::TDateTime

         , Object_Personal_View.isDateOut
         , Object_Personal_View.isDateSend
         , Object_Personal_View.isMain

         , Object_Personal_View.Member_ReferId
         , Object_Personal_View.Member_ReferCode
         , Object_Personal_View.Member_ReferName
         , Object_Personal_View.Member_MentorId
         , Object_Personal_View.Member_MentorCode
         , Object_Personal_View.Member_MentorName
         , Object_Personal_View.ReasonOutId
         , Object_Personal_View.ReasonOutCode
         , Object_Personal_View.ReasonOutName
         , Object_Personal_View.Comment
    FROM Object_Personal_View
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                               ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
          LEFT JOIN Object AS Object_PersonalServiceListCardSecond ON Object_PersonalServiceListCardSecond.Id = ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                               ON ObjectLink_Personal_SheetWorkTime.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                               ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
          LEFT JOIN Object AS Object_PersonalServiceListAvance_F2 ON Object_PersonalServiceListAvance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId

    WHERE Object_Personal_View.PersonalId = inId;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_Personal (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.04.23         * DateSend
 06.08.21         * 
 13.07.17         * add PersonalServiceListCardSecond
 25.05.17         * add StorageLine
 16.11.16         * add SheetWorkTime
 07.05.15         * add ObjectLink_Personal_PersonalServiceList
 15.09.14                                                        *
 12.09.14                                        * add isDateOut and isOfficial
 21.05.14                         * add Official
 21.11.13                                         * add PositionLevel...
 28.10.13                         * return memberid
 30.09.13                                        * add Object_Personal_View
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business
 03.09.14                        *
 19.07.13         *    rename zc_ObjectDate...
 01.07.13         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Personal (100,0, '2')