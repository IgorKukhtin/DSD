-- Function: gpGet_Object_ProdEngine()

DROP FUNCTION IF EXISTS gpGet_Object_ProdEngine(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdEngine(
    IN inId          Integer,       -- �������� �������� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Power TFloat
             , Comment TVarChar
             ) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdEngine());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdEngine())   AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 AS TFloat)     AS Power
           , CAST ('' AS TVarChar)  AS Comment
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ProdEngine.Id             AS Id 
         , Object_ProdEngine.ObjectCode     AS Code
         , Object_ProdEngine.ValueData      AS Name

         , ObjectFloat_Power.ValueData    AS Power
         , ObjectString_Comment.ValueData  AS Comment
        
     FROM Object AS Object_ProdEngine
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdEngine.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdEngine_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()

       WHERE Object_ProdEngine.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ProdEngine(0, '2')