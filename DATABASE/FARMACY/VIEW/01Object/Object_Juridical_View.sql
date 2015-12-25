-- View: Object_Juridical_View

DROP VIEW IF EXISTS Object_Juridical_View CASCADE;

CREATE OR REPLACE VIEW Object_Juridical_View AS
    SELECT 
         Object_Juridical.Id                 AS Id
       , Object_Juridical.ObjectCode         AS Code
       , Object_Juridical.ValueData          AS Name
     
       , Object_Retail.Id                    AS RetailId
       , Object_Retail.ValueData             AS RetailName 

       , ObjectBoolean_isCorporate.ValueData AS isCorporate
       , ObjectFloat_PayOrder.ValueData      AS PayOrder
       
       , Object_Juridical.isErased           AS isErased
       
   FROM Object AS Object_Juridical
       LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                            ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
       LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

       LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                               ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                              AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
       LEFT JOIN ObjectFloat AS ObjectFloat_PayOrder
                               ON ObjectFloat_PayOrder.ObjectId = Object_Juridical.Id
                              AND ObjectFloat_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()
   WHERE Object_Juridical.DescId = zc_Object_Juridical();
ALTER TABLE Object_Juridical_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 24.12.15                                                          *
*/

-- тест
-- SELECT * FROM Object_Juridical_View
