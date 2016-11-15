-- Function: gpSelect_Object_GoodsListSale_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsListSale (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsListSale(
    IN inRetailId      Integer , -- торговая сеть
    IN inContractId    Integer , -- договор
    IN inJuridicalId   Integer , -- юр. лицо
    IN inShowAll       Boolean , -- показать удаленные Да/нет
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount Tfloat
             , RetailId Integer, RetailName TVarChar
             , ContractId Integer, ContractCode Integer, InvNumber TVarChar

             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , PartnerId Integer, PartnerName TVarChar             
             , PaidKindId Integer, PaidKindName TVarChar

             , ContractTagId Integer, ContractTagName TVarChar
                          
             , OKPO TVarChar
            
             , UpdateDate TDateTime
             , isDefault Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean

             , isErased boolean         
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsListSale());
     vbUserId:= lpGetUserBySession (inSession);
  
     -- Результат
     RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

          SELECT 
             Object_GoodsListSale.Id          AS Id

           , Object_Goods.Id         AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName

           , ObjectFloat_GoodsListSale_Amount.ValueData ::Tfloat AS Amount

           , Object_Retail.Id                AS RetailId
           , Object_Retail.ValueData         AS RetailName
          
           , Object_Contract_View.ContractId    AS ContractId
           , Object_Contract_View.ContractCode  AS ContractCode
           , Object_Contract_View.InvNumber     AS InvNumber
          
           , Object_ContractKind.Id          AS ContractKindId
           , Object_ContractKind.ValueData   AS ContractKindName
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ObjectCode     AS JuridicalCode
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_JuridicalGroup.ValueData AS JuridicalGroupName

           , Object_JuridicalBasis.Id        AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName

           , Object_Partner.Id              AS PartnerId
           , Object_Partner.ValueData       AS PartnerName

           , Object_PaidKind.Id              AS PaidKindId
           , Object_PaidKind.ValueData       AS PaidKindName

           , Object_Contract_View.ContractTagId
           , Object_Contract_View.ContractTagName

           , ObjectHistory_JuridicalDetails_View.OKPO

           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , COALESCE (ObjectBoolean_Default.ValueData, False)  AS isDefault
           , COALESCE (ObjectBoolean_Standart.ValueData, False) AS isStandart

           , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
           , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
 
           , Object_GoodsListSale.isErased      AS isErased
       
    FROM tmpIsErased
        INNER JOIN Object AS Object_GoodsListSale 
                          ON Object_GoodsListSale.isErased = tmpIsErased.isErased 
                         AND Object_GoodsListSale.DescId = zc_Object_GoodsListSale()

        LEFT JOIN ObjectLink AS GoodsListSale_Contract
                              ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                             AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
        
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                              ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                             AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_GoodsListSale_Juridical.ChildObjectId
            
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                             AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = GoodsListSale_Contract.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                             ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsListSale_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                             ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
        LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_GoodsListSale_Partner.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListSale_Amount
                              ON ObjectFloat_GoodsListSale_Amount.ObjectId = Object_GoodsListSale.Id
                             AND ObjectFloat_GoodsListSale_Amount.DescId = zc_ObjectFloat_GoodsListSale_Amount()

        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsListSale.Id
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                                ON ObjectBoolean_Standart.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                                ON ObjectBoolean_Personal.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                                ON ObjectBoolean_Unique.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
        LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
          
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

     WHERE (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
       AND (ObjectLink_GoodsListSale_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
       AND (GoodsListSale_Contract.ChildObjectId = inContractId OR inContractId = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsListSale (0, 0, 0, FALSE, zfCalc_UserAdmin())
