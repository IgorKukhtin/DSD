-- Function: gpGet_Object_Unit(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- �������������
    IN inSession     TVarChar       -- ������ ������������
) 
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GroupNameFull TVarChar, Phone TVarChar
             , Comment TVarChar
             , ParentId Integer, ParentName TVarChar
 ) 
AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                          AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit())  AS Code
           , '' :: TVarChar                         AS Name
           , '' :: TVarChar                         AS GroupNameFull
           , '' :: TVarChar                         AS Phone
           , '' :: TVarChar                         AS Comment
           ,  0 :: Integer                          AS ParentId         
           , '' :: TVarChar                         AS ParentName       
  
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , ObjectString_GroupNameFull.ValueData  AS GroupNameFull
           , ObjectString_Phone.ValueData    AS Phone
           , ObjectString_Comment.ValueData  AS Comment
           , Object_Parent.Id                AS ParentId
           , Object_Parent.ValueData         AS ParentName
       FROM Object AS Object_Unit
            LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                                   ON ObjectString_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_Unit.Id
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Unit.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Unit_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
      WHERE Object_Unit.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.22         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Unit(1,'2')