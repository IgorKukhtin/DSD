-- Function: gpGet_Object_BarCodeBox (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_BarCodeBox (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BarCodeBox(
    IN inId             Integer,       -- ���� ������� <��������� �����>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , BarCode TVarChar
             , Weight TFloat
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_BarCodeBox());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_BarCodeBox()) AS Code
                      
           , CAST (0 as Integer)    AS BoxId 
           , CAST (0 as Integer)    AS BoxCode
           , CAST ('' as TVarChar)  AS BoxName                      

           , CAST ('' as TVarChar)  AS BarCode
           , CAST (0  as TFloat)    AS Weight

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_BarCodeBox.Id         AS Id
           , Object_BarCodeBox.ObjectCode AS Code
                      
           , Object_Box.Id         AS BoxId 
           , Object_Box.ObjectCode AS BoxCode
           , Object_Box.ValueData  AS BoxName            

           , ObjectString_BarCode.ValueData  AS BarCode
           , ObjectFloat_Weight.ValueData    AS Weight

           , Object_BarCodeBox.isErased   AS isErased
           
       FROM Object AS Object_BarCodeBox
            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box
                                 ON ObjectLink_BarCodeBox_Box.ObjectId = Object_BarCodeBox.Id
                                AND ObjectLink_BarCodeBox_Box.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_BarCodeBox_Box.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_BarCodeBox.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_BarCodeBox_Weight()

            LEFT JOIN ObjectString AS ObjectString_BarCode
                                   ON ObjectString_BarCode.ObjectId = Object_BarCodeBox.Id
                                  AND ObjectString_BarCode.DescId = zc_ObjectString_BarCodeBox_BarCode()
       WHERE Object_BarCodeBox.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.19          *         

*/

-- ����
-- SELECT * FROM gpGet_Object_BarCodeBox (2, '')
