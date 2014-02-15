-- Function: gpGet_Object_CardFuel (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_CardFuel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CardFuel(
    IN inId             Integer,       -- ���� ������� <��������� �����>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CardFuelLimit TFloat
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , CarId Integer, CarName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_CardFuel());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_CardFuel()) AS Code
           , CAST ('' as TVarChar)  AS Name
                      
           , 0 :: TFloat AS CardFuelLimit

           , CAST (0 as Integer)   AS PersonalDriverId 
           , CAST ('' as TVarChar) AS PersonalDriverName

           , CAST (0 as Integer)   AS CarId 
           , CAST ('' as TVarChar) AS CarName

           , CAST (0 as Integer)   AS PaidKindId 
           , CAST ('' as TVarChar) AS PaidKindName
           
           , CAST (0 as Integer)   AS JuridicalId 
           , CAST ('' as TVarChar) AS JuridicalName

           , CAST (0 as Integer)   AS GoodsId 
           , CAST ('' as TVarChar) AS GoodsName                      
            
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_CardFuel.Id         AS Id
           , Object_CardFuel.ObjectCode AS Code
           , Object_CardFuel.ValueData  AS NAME
                      
           , ObjectFloat_CardFuel_Limit.ValueData AS CardFuelLimit

           , View_PersonalDriver.PersonalId   AS PersonalDriverId 
           , View_PersonalDriver.PersonalName AS PersonalDriverName

           , Object_Car.Id         AS CarId 
           , Object_Car.ValueData  AS CarName
           
           , Object_PaidKind.Id         AS PaidKindId 
           , Object_PaidKind.ValueData  AS PaidKindName
                       
           , Object_Juridical.Id         AS JuridicalId 
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Goods.Id         AS GoodsId 
           , Object_Goods.ValueData  AS GoodsName            
            
           , Object_CardFuel.isErased   AS isErased
           
       FROM Object AS Object_CardFuel

            LEFT JOIN ObjectFloat AS ObjectFloat_CardFuel_Limit ON ObjectFloat_CardFuel_Limit.ObjectId = Object_CardFuel.Id
                                                               AND ObjectFloat_CardFuel_Limit.DescId = zc_ObjectFloat_CardFuel_Limit()

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PersonalDriver ON ObjectLink_CardFuel_PersonalDriver.ObjectId = Object_CardFuel.Id
                                                                      AND ObjectLink_CardFuel_PersonalDriver.DescId = zc_ObjectLink_CardFuel_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = ObjectLink_CardFuel_PersonalDriver.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Car ON ObjectLink_CardFuel_Car.ObjectId = Object_CardFuel.Id
                                                           AND ObjectLink_CardFuel_Car.DescId = zc_ObjectLink_CardFuel_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_CardFuel_Car.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PaidKind ON ObjectLink_CardFuel_PaidKind.ObjectId = Object_CardFuel.Id
                                                                AND ObjectLink_CardFuel_PaidKind.DescId = zc_ObjectLink_CardFuel_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_CardFuel_PaidKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                                 AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Goods ON ObjectLink_CardFuel_Goods.ObjectId = Object_CardFuel.Id
                                                             AND ObjectLink_CardFuel_Goods.DescId = zc_ObjectLink_CardFuel_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_CardFuel_Goods.ChildObjectId
            
       WHERE Object_CardFuel.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CardFuel (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.13                                        * add CardFuelLimit
 14.10.13          *
*/

-- ����
-- SELECT * FROM gpGet_Object_CardFuel (2, '')
