-- Function: gpGet_Object_MemberExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberExternal(
    IN inId          Integer,        -- ���������� ���� 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DriverCertificate TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberExternal());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MemberExternal()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS DriverCertificate
      ;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_MemberExternal.Id         AS Id
         , Object_MemberExternal.ObjectCode AS Code
         , Object_MemberExternal.ValueData  AS Name
         , ObjectString_DriverCertificate.ValueData :: TVarChar AS DriverCertificate

     FROM Object AS Object_MemberExternal
           LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                  ON ObjectString_DriverCertificate.ObjectId = Object_MemberExternal.Id 
                                 AND ObjectString_DriverCertificate.DescId = zc_ObjectString_MemberExternal_DriverCertificate()
     WHERE Object_MemberExternal.Id = inId;
     
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.20         * add DriverCertificate
 28.03.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_MemberExternal (1, '2')
