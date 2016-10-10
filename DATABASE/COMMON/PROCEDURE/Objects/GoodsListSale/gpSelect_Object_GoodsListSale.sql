-- Function: gpSelect_Object_GoodsListSale_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsListSale (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsListSale(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UpdateDate TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsListSale());
     vbUserId:= lpGetUserBySession (inSession);
 
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_GoodsListSale.Id          AS Id
         
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName

           , Object_Contract.Id  AS ContractId
           , Object_Contract.ObjectCode  AS ContractCode
           , Object_Contract.ValueData   AS ContractName

           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
       
           , Object_Partner.Id                AS PartnerId
           , Object_Partner.ObjectCode        AS PartnerCode
           , Object_Partner.ValueData         AS PartnerName

           , Object_GoodsListSale.isErased    AS isErased

    FROM Object AS Object_GoodsListSale
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsListSale.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                 ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsListSale_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS GoodsListSale_Contract
                                 ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                                AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = GoodsListSale_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                                 ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                                AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_GoodsListSale_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                 ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_GoodsListSale_Partner.ChildObjectId
     WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsListSale (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.16         *
        
*/

-- тест
--SELECT * FROM gpSelect_Object_GoodsListSale (zfCalc_UserAdmin())