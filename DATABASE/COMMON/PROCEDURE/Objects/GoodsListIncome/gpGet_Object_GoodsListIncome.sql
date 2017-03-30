-- Function: gpGet_Object_GoodsListIncome (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsListIncome (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsListIncome(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UpdateDate TDateTime
             , GoodsId Integer, GoodsName TVarChar
             , ContractId Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , GoodsKindId_List TVarChar, GoodsKindName_List TVarChar
             , isErased boolean
             ) AS
$BODY$

  DECLARE vbIndex Integer;
  DECLARE vbGoodsKindId TVarChar;

BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsListIncome());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
    
           , CAST (Null as TDateTime) AS UpdateDate

           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName

           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName  

           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName
           
           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST ('' as TVarChar)   AS GoodsKindId_List
           , CAST ('' as TVarChar)  AS GoodsKindName_List

           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE

     -- выбираем GoodsKinId
     vbGoodsKindId:= (SELECT ObjectString_GoodsKind.ValueData
                      FROM ObjectString AS ObjectString_GoodsKind
                      WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListIncome_GoodsKind()
                        AND ObjectString_GoodsKind.ObjectId = inId);
                                   

     CREATE TEMP TABLE tmp_List (GoodsKindId Integer) ON COMMIT DROP;
     -- парсим 
     vbIndex := 1;
     WHILE SPLIT_PART (vbGoodsKindId, ',', vbIndex) <> '' LOOP
         -- добавляем то что нашли
         INSERT INTO tmp_List (GoodsKindId) SELECT SPLIT_PART (vbGoodsKindId, ',', vbIndex) :: Integer;
         -- теперь следуюющий
         vbIndex := vbIndex + 1;
     END LOOP;


       RETURN QUERY 
       SELECT 
             Object_GoodsListIncome.Id          AS Id
          
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ValueData           AS GoodsName
                     
           , Object_Contract.Id               AS ContractId
           , Object_Contract.ValueData        AS ContractName

           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ValueData       AS JuridicalName

           , Object_Partner.Id                AS PartnerId
           , Object_Partner.ValueData         AS PartnerName

           , ObjectString_GoodsKind.ValueData AS GoodsKindId_List
           , tmp.GoodsKindName  :: TVarChar   AS GoodsKindName_List

           , Object_GoodsListIncome.isErased    AS isErased
           
       FROM Object AS Object_GoodsListIncome
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsListIncome.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

            LEFT JOIN ObjectString AS ObjectString_GoodsKind
                                   ON ObjectString_GoodsKind.ObjectId = Object_GoodsListIncome.Id
                                  AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListIncome_GoodsKind()

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                 ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsListIncome_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS GoodsListIncome_Contract
                                 ON GoodsListIncome_Contract.ObjectId = Object_GoodsListIncome.Id
                                AND GoodsListIncome_Contract.DescId = zc_ObjectLink_GoodsListIncome_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = GoodsListIncome_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                                 ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                                AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_GoodsListIncome_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                                 ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                                AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_GoodsListIncome_Partner.ChildObjectId

            LEFT JOIN (SELECT STRING_AGG (Object.ValueData :: TVarChar, ', ')  AS GoodsKindName
                       FROM tmp_List
                           LEFT JOIN Object ON Object.Id = tmp_List.GoodsKindId
                       ) AS tmp ON 1=1
       WHERE Object_GoodsListIncome.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.17       *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsListIncome (0, inSession := '5')