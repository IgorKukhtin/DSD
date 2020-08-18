-- Function: gpSelect_Object_CommentTRSend()

DROP FUNCTION IF EXISTS gpSelect_Object_CommentTRSend(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentTRSend(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isExplanation Boolean
             , isResort Boolean
             , isDifferenceSum Boolean
             , DifferenceSum TFloat
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_CommentTR.Id                             AS Id 
        , Object_CommentTR.ObjectCode                     AS Code
        , Object_CommentTR.ValueData                      AS Name
        , ObjectBoolean_CommentTR_Explanation.ValueData   AS isExplanation
        , ObjectBoolean_CommentTR_Resort.ValueData        AS isResort
        , ObjectBoolean_CommentTR_DifferenceSum.ValueData AS isDifferenceSum
        , ObjectFloat_DifferenceSum.ValueData             AS DifferenceSum
        , Object_CommentTR.isErased                       AS isErased
   FROM Object AS Object_CommentTR

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Explanation
                                ON ObjectBoolean_CommentTR_Explanation.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_Explanation.DescId = zc_ObjectBoolean_CommentTR_Explanation()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Resort
                                ON ObjectBoolean_CommentTR_Resort.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_Resort.DescId = zc_ObjectBoolean_CommentTR_Resort()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_DifferenceSum
                                ON ObjectBoolean_CommentTR_DifferenceSum.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_DifferenceSum.DescId = zc_ObjectBoolean_CommentTR_DifferenceSum()

        LEFT JOIN ObjectFloat AS ObjectFloat_DifferenceSum
                              ON ObjectFloat_DifferenceSum.ObjectId = Object_CommentTR.Id 
                             AND ObjectFloat_DifferenceSum.DescId = zc_ObjectFloat_CommentTR_DifferenceSum()

   WHERE Object_CommentTR.DescId = zc_Object_CommentTR()
     AND Object_CommentTR.isErased  = FALSE
     AND Object_CommentTR.ObjectCode IN (3, 5, 10);
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CommentTRSend(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.02.20                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_CommentTRSend('3')