-- Function: gpSelect_Object_ContractGoods_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractGoods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractGoods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code INTEGER
             , Price TFloat
             , ContractId Integer, InvNumber TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , isErased boolean
     
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_ContractGoods.Id          AS Id
           , Object_ContractGoods.ObjectCode  AS Code
           , ObjectFloat_Price.ValueData      AS Price
         
           , Object_Contract_View.ContractId  AS ContractId
           , Object_Contract_View.InvNumber   AS InvNumber

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName
       
           , Object_ContractGoods.isErased    AS isErased

    FROM Object AS Object_ContractGoods
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_ContractGoods.AccessKeyId
            LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                  ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                 AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price()          

            LEFT JOIN ObjectLink AS ContractGoods_Contract
                                 ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ContractGoods_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                 ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ContractGoods_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                 ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_ContractGoods_GoodsKind.ChildObjectId
             
     WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
       --AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractGoods (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.15         * 
        
*/

-- тест
--SELECT * FROM gpSelect_Object_ContractGoods (zfCalc_UserAdmin())