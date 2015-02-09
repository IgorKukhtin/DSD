-- View: Object_Unit_View

DROP VIEW IF EXISTS Object_PartnerCode_View;

CREATE OR REPLACE VIEW Object_PartnerCode_View AS 

      SELECT 
          Object.Id,
          Object.ObjectCode AS Code,
          Object.ValueData  AS PartnerCodeName
        FROM
          (SELECT 
              Object_Juridical.Id AS Id
         FROM Object AS Object_Juridical
        WHERE Object_Juridical.DescId = zc_Object_Juridical()
          UNION SELECT zc_Enum_GlobalConst_BarCode()
          UNION SELECT zc_Enum_GlobalConst_Marion()
         ) AS DDD
         JOIN Object ON Object.Id = DDD.Id;

;

ALTER TABLE Object_Unit_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.14                        * 
*/

-- тест
-- SELECT * FROM Object_Unit_View
