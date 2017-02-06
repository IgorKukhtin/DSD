-- Function: zfCalc_GoodsPropertyId

-- DROP FUNCTION IF EXISTS zfCalc_GoodsPropertyId (Integer, Integer);
DROP FUNCTION IF EXISTS zfCalc_GoodsPropertyId (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_GoodsPropertyId(
    IN inContractId                Integer,  -- 
    IN inJuridicalId               Integer,  -- 
    IN inPartnerId                 Integer   -- 
)
RETURNS Integer AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (SELECT COALESCE (ObjectLink_Partner_GoodsProperty.ChildObjectId
                  , COALESCE (ObjectLink_Contract_GoodsProperty.ChildObjectId
                  , COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId
                  , COALESCE (ObjectLink_Retail_GoodsProperty.ChildObjectId))))
                            -- , ObjectLink_JuridicalBasis_GoodsProperty.ChildObjectId))))
             FROM (SELECT inJuridicalId AS JuridicalId, inPartnerId AS PartnerId) AS tmp
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                                       ON ObjectLink_Partner_GoodsProperty.ObjectId = tmp.PartnerId
                                      AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                       ON ObjectLink_Juridical_GoodsProperty.ObjectId = tmp.JuridicalId
                                      AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                       ON ObjectLink_Contract_GoodsProperty.ObjectId = inContractId
                                      AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = tmp.JuridicalId
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                                       ON ObjectLink_Retail_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                      AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                  /*LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                                       ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                                      AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_GoodsPropertyId (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.15                                        *
*/

-- тест
-- SELECT * FROM zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)
