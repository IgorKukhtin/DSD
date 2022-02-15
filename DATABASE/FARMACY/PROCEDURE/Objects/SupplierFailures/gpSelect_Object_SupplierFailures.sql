-- Function: gpSelect_Object_SupplierFailures()

DROP FUNCTION IF EXISTS gpSelect_Object_SupplierFailures(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SupplierFailures(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean
             , GoodsJuridicalCode TVarChar, GoodsJuridicalName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , ContractCode Integer, ContractName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
             , DateUpdate TDateTime, UserUpdate TVarChar
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   WITH tmpProtocol AS (SELECT Object_SupplierFailures.Id                        AS Id 
                             , ObjectProtocol.OperDate
                             , ObjectProtocol.UserId
                             , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.Id DESC) AS Ord
                        FROM Object AS Object_SupplierFailures
                        
                             INNER JOIN ObjectProtocol ON ObjectProtocol.ObjectId = Object_SupplierFailures.Id    
                              
                        WHERE Object_SupplierFailures.DescId = zc_Object_SupplierFailures()
                          AND (Object_SupplierFailures.isErased = FALSE OR inIsErased = TRUE)
                       )
   
   SELECT Object_SupplierFailures.Id                        AS Id 
        , Object_SupplierFailures.ObjectCode                AS Code
        , Object_SupplierFailures.ValueData                 AS Name
        , Object_SupplierFailures.isErased                  AS isErased
        
        , Object_Goods.Code                                 AS GoodsJuridicalCode
        , Object_Goods.Name                                 AS GoodsJuridicalName
        
        , Object_Goods_Main.ObjectCode                      AS GoodsCode
        , Object_Goods_Main.Name                            AS GoodsName

        , Object_Juridical.ObjectCode                       AS JuridicalCode
        , Object_Juridical.ValueData                        AS JuridicalName
        
        , Object_Contract.ObjectCode                        AS ContractCode
        , Object_Contract.ValueData                         AS ContractName
        
        , Object_Area.Id                                    AS AreaId
        , Object_Area.ObjectCode                            AS AreaCode
        , Object_Area.ValueData                             AS AreaName
        
        , tmpProtocol.OperDate                              AS DateUpdate
        , Object_User.ValueData                             AS UserUpdate
   FROM Object AS Object_SupplierFailures
        
        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Goods
                             ON ObjectLink_BankAccount_Goods.ObjectId = Object_SupplierFailures.Id
                            AND ObjectLink_BankAccount_Goods.DescId = zc_ObjectLink_SupplierFailures_Goods()
        LEFT JOIN Object_Goods_Juridical AS Object_Goods ON Object_Goods.Id = ObjectLink_BankAccount_Goods.ChildObjectId
        LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
        
        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Juridical
                             ON ObjectLink_BankAccount_Juridical.ObjectId = Object_SupplierFailures.Id
                            AND ObjectLink_BankAccount_Juridical.DescId = zc_ObjectLink_SupplierFailures_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_BankAccount_Juridical.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Contract
                             ON ObjectLink_BankAccount_Contract.ObjectId = Object_SupplierFailures.Id
                            AND ObjectLink_BankAccount_Contract.DescId = zc_ObjectLink_SupplierFailures_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_BankAccount_Contract.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Area
                             ON ObjectLink_BankAccount_Area.ObjectId = Object_SupplierFailures.Id
                            AND ObjectLink_BankAccount_Area.DescId = zc_ObjectLink_SupplierFailures_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_BankAccount_Area.ChildObjectId
        
        LEFT JOIN tmpProtocol ON tmpProtocol.ID = Object_SupplierFailures.Id
                             AND tmpProtocol.Ord = 1

        LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId
        
   WHERE Object_SupplierFailures.DescId = zc_Object_SupplierFailures()
     AND (Object_SupplierFailures.isErased = FALSE OR inIsErased = TRUE);
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_SupplierFailures(Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_SupplierFailures(False, '3')