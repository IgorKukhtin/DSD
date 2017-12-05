-- Function: gpGet_Object_WorkTimeKind (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_WorkTimeKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_WorkTimeKind(
    IN inId             Integer ,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , Tax       TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_WorkTimeKind());

IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             0 :: Integer         AS Id
           , lfGet_ObjectCode(0, zc_Object_WorkTimeKind()) AS Code
           , '' :: TVarChar       AS Name
           , '' :: TVarChar       AS ShortName
           , 0  :: Tfloat         AS Tax 
           , FALSE :: Boolean     AS isErased
         ;
   ELSE
   
       RETURN QUERY
       SELECT
            Object_WorkTimeKind.Id           AS Id 
          , Object_WorkTimeKind.ObjectCode   AS Code
          , Object_WorkTimeKind.ValueData    AS Name
          
          , ObjectString_ShortName.ValueData AS ShortName 
          , ObjectFloat_Tax.ValueData        AS Tax
          , Object_WorkTimeKind.isErased     AS isErased
          
       FROM OBJECT AS Object_WorkTimeKind
       
            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = Object_WorkTimeKind.Id
                                  AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
    
            LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                                  ON ObjectFloat_Tax.ObjectId = Object_WorkTimeKind.Id
                                 AND ObjectFloat_Tax.DescId = zc_ObjectFloat_WorkTimeKind_Tax()
                                   
       WHERE Object_WorkTimeKind.DescId = zc_Object_WorkTimeKind()
         AND Object_WorkTimeKind.Id = inId;
   END IF;
     
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_WorkTimeKind(0,'2')
