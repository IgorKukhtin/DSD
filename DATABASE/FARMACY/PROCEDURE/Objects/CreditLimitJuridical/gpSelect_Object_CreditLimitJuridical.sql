-- Function: gpSelect_Object_CreditLimitJuridical (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CreditLimitJuridical (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CreditLimitJuridical(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer 
             , ProviderId Integer, ProviderName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , CreditLimit TFloat
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Fiscal());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
     SELECT  Object_CreditLimitJuridical.Id            AS Id
           , Object_CreditLimitJuridical.ObjectCode    AS Code
           
         
           , Object_Provider.Id                        AS ProviderId
           , Object_Provider.ValueData                 AS ProviderName 
           
           , Object_Juridical.Id                       AS JuridicalId
           , Object_Juridical.ValueData                AS JuridicalName 
           
           , ObjectFloat_CreditLimit.ValueData         AS CreditLimit 

           , Object_CreditLimitJuridical.isErased      AS isErased
           
     FROM Object AS Object_CreditLimitJuridical
                                                           
          LEFT JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Provider
                               ON ObjectLink_CreditLimitJuridical_Provider.ObjectId = Object_CreditLimitJuridical.Id 
                              AND ObjectLink_CreditLimitJuridical_Provider.DescId = zc_ObjectLink_CreditLimitJuridical_Provider()
          LEFT JOIN Object AS Object_Provider ON Object_Provider.Id = ObjectLink_CreditLimitJuridical_Provider.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Juridical
                               ON ObjectLink_CreditLimitJuridical_Juridical.ObjectId = Object_CreditLimitJuridical.Id 
                              AND ObjectLink_CreditLimitJuridical_Juridical.DescId = zc_ObjectLink_CreditLimitJuridical_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CreditLimitJuridical_Juridical.ChildObjectId
      
          LEFT JOIN ObjectFloat AS ObjectFloat_CreditLimit
                                 ON ObjectFloat_CreditLimit.ObjectId = Object_CreditLimitJuridical.Id 
                                AND ObjectFloat_CreditLimit.DescId = zc_ObjectFloat_CreditLimitJuridical_CreditLimit()

     WHERE Object_CreditLimitJuridical.DescId = zc_Object_CreditLimitJuridical()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.06.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_CreditLimitJuridical (zfCalc_UserAdmin())
