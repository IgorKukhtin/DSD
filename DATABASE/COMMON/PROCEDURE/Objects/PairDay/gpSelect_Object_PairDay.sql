-- Function: gpSelect_Object_PairDay()

DROP FUNCTION IF EXISTS gpSelect_Object_PairDay(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PairDay(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PairDay());

     RETURN QUERY 
     SELECT 
           Object_PairDay.Id              AS Id
         , Object_PairDay.ObjectCode      AS Code
         , Object_PairDay.ValueData       AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_PairDay.isErased        AS isErased
     FROM Object AS Object_PairDay
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_PairDay.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_PairDay_Comment()  
     WHERE Object_PairDay.DescId = zc_Object_PairDay()

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
         , '<�����>' :: TVarChar AS Name
         , ''        :: TVarChar AS Comment
         , FALSE                 AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PairDay (zfCalc_UserAdmin())