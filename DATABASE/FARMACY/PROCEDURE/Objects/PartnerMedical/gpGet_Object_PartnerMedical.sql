-- Function: gpGet_Object_PartnerMedical()

DROP FUNCTION IF EXISTS gpGet_Object_PartnerMedical(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartnerMedical(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PartnerMedical());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PartnerMedical()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)   AS JuridicalId
           , CAST (0 as Integer)   AS JuridicalCode
           , CAST ('' as TVarChar) AS JuridicalName

           , CAST (NULL AS Boolean) AS isErased
;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PartnerMedical.Id          AS Id
           , Object_PartnerMedical.ObjectCode  AS Code
           , Object_PartnerMedical.ValueData   AS Name
           
           , Object_Juridical.Id    AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName

           , Object_PartnerMedical.isErased AS isErased
           
       FROM Object AS Object_PartnerMedical
       
           LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                               ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id 
                              AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PartnerMedical_Juridical.ChildObjectId              

       WHERE Object_PartnerMedical.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PartnerMedical(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.16         * 

*/

-- ����
-- SELECT * FROM gpGet_Object_PartnerMedical (2, '')
