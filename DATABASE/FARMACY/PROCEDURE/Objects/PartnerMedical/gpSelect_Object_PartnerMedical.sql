-- Function: gpSelect_Object_PartnerMedical()

DROP FUNCTION IF EXISTS gpSelect_Object_PartnerMedical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerMedical(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartnerMedical());

     RETURN QUERY  
       SELECT 
             Object_PartnerMedical.Id          AS Id
           , Object_PartnerMedical.ObjectCode  AS Code
           , Object_PartnerMedical.ValueData   AS Name
           
           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName
          
           , Object_PartnerMedical.isErased AS isErased
           
       FROM Object AS Object_PartnerMedical
   
           LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id 
                                                           AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PartnerMedical_Juridical.ChildObjectId              

     WHERE Object_PartnerMedical.DescId = zc_Object_PartnerMedical();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PartnerMedical(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PartnerMedical('2')