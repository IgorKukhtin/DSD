-- Function: gpGet_Object_Personal(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- ����������
    IN inMaskId      Integer   ,    -- id ��� �����������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (MemberId Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar,
               PositionLevelId Integer, PositionLevelName TVarChar,
               UnitId Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupName TVarChar,
               PersonalServiceListId Integer, PersonalServiceListName TVarChar,
               PersonalServiceListOfficialId Integer, PersonalServiceListOfficialName TVarChar,
               DateIn TDateTime, DateOut TDateTime, isDateOut Boolean, isMain Boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
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

         , COALESCE (Object_PersonalServiceListOfficial.Id, CAST (0 as Integer))           AS PersonalServiceListOfficialId 
         , COALESCE (Object_PersonalServiceListOfficial.ValueData, CAST ('' as TVarChar))  AS PersonalServiceListOfficialName 

         , Object_Personal_View.DateIn
         -- , Object_Personal_View.DateOut
         , CASE WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE ELSE Object_Personal_View.DateOut_user END :: TDateTime AS DateOut

         , Object_Personal_View.isDateOut
         , Object_Personal_View.isMain

    FROM Object_Personal_View
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

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

           , CURRENT_DATE :: TDateTime AS DateIn
           , CURRENT_DATE :: TDateTime AS DateOut
           , FALSE AS isDateOut
           , TRUE  AS isMain;
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

         , COALESCE (Object_PersonalServiceListOfficial.Id, CAST (0 as Integer))           AS PersonalServiceListOfficialId 
         , COALESCE (Object_PersonalServiceListOfficial.ValueData, CAST ('' as TVarChar))  AS PersonalServiceListOfficialName 

         , Object_Personal_View.DateIn
         -- , Object_Personal_View.DateOut
         , CASE WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE ELSE Object_Personal_View.DateOut_user END :: TDateTime AS DateOut

         , Object_Personal_View.isDateOut
         , Object_Personal_View.isMain

    FROM Object_Personal_View
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

    WHERE Object_Personal_View.PersonalId = inId;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Personal (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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

-- ����
-- SELECT * FROM gpGet_Object_Personal (100, '2')