-- Function: gpGet_Object_CommentMoveMoney()

DROP FUNCTION IF EXISTS gpGet_Object_CommentMoveMoney (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommentMoveMoney(
    IN inId          Integer,       --  
    IN inSession     TVarChar       -- ������ ������������ 
    )
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CommentMoveMoney());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as Integer)    AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (FALSE AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT Object.Id          AS Id
            , Object.ObjectCode  AS Code
            , Object.ValueData   AS Name
            , Object.isErased    AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_CommentMoveMoney()
         AND Object.Id = inId;
   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.22          *        
*/

-- ����
-- SELECT * FROM gpGet_Object_CommentMoveMoney(2,'2')