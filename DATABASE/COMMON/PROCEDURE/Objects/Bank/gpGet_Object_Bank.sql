-- Function: gpGet_Object_Bank(Integer,TVarChar)

--DROP FUNCTION gpGet_Object_Bank(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Bank(
    IN inId          Integer,       -- ���� ������� <�����>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               JuridicalId Integer, JuridicalName TVarChar, MFO TVarChar) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   IF COALESCE (inId, 0) = 0
   THEN
   RETURN QUERY 
       SELECT
             CAST (0 as Integer)              AS Id
           , lfGet_ObjectCode(0, zc_Object_Bank()) AS Code
           , CAST ('' as TVarChar)            AS Name
           , CAST (NULL AS Boolean)           AS isErased
           , CAST (0  as Integer)             AS JuridicalId
           , CAST ('' as TVarChar)            AS JuridicalName
           , CAST ('' as TVarChar)            AS MFO;
   ELSE
       RETURN QUERY 
       SELECT
             Object_Bank.Id             AS Id
           , Object_Bank.ObjectCode     AS Code
           , Object_Bank.ValueData      AS Name
           , Object_Bank.isErased       AS isErased
           , Object_Juridical.Id        AS JuridicalId
           , Object_Juridical.ValueData AS JuridicalName
           , ObjectString_MFO.ValueData AS MFO
       FROM Object AS Object_Bank
        LEFT JOIN ObjectLink AS ObjectLink_Bank_Juridical
                 ON ObjectLink_Bank_Juridical.ObjectId = Object_Bank.Id
                AND ObjectLink_Bank_Juridical.DescId = zc_ObjectLink_Bank_Juridical()
        LEFT JOIN ObjectString AS ObjectString_MFO
                 ON ObjectString_MFO.ObjectId = Object_Bank.Id
                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Bank_Juridical.ChildObjectId
       WHERE Object_Bank.Id = inId;
   END IF;
     
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Bank (Integer� TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.14                                        * Cyr-1251
 10.06.13          *
*/

-- ����
-- SELECT * FROM  gpGet_Object_Bank (2, '')
