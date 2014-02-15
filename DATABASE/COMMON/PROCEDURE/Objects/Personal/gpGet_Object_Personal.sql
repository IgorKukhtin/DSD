-- Function: gpGet_Object_Personal(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- ���������� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (MemberId Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar,
               PositionLevelId Integer, PositionLevelName TVarChar,
               UnitId Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupName TVarChar,
               DateIn TDateTime, DateOut TDateTime) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Personal());
  
   IF COALESCE (inId, 0) = 0
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

           , CURRENT_DATE :: TDateTime AS DateIn
           , CURRENT_DATE :: TDateTime AS DateOut;
   ELSE
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
 
         , Object_Personal_View.DateIn
         , Object_Personal_View.DateOut
     FROM Object_Personal_View
    WHERE Object_Personal_View.PersonalId = inId;

  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Personal(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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