-- Function: gpSelect_Object_GoodsListIncome_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsListIncome (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsListIncome(
    IN inRetailId      Integer , -- торговая сеть
    IN inContractId    Integer , -- договор
    IN inJuridicalId   Integer , -- юр. лицо
    IN inShowAll       Boolean , -- показать удаленные Да/нет
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , Amount TFloat, AmountChoice TFloat
             , RetailId Integer, RetailName TVarChar
             , ContractId Integer, ContractCode Integer, InvNumber TVarChar

             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , PartnerId Integer, PartnerName TVarChar             
             , PaidKindId Integer, PaidKindName TVarChar

             , ContractTagId Integer, ContractTagName TVarChar
             , GoodsKindId_List TVarChar, GoodsKindName_List TVarChar
                          
             , OKPO TVarChar

             , UpdateDate TDateTime
             , LastDate TDateTime
             , isLast Boolean
             , isDefault Boolean, isDefaultOut Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean

             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsKindId TVarChar;
   DECLARE vbIndex Integer;
   DECLARE cur1 CURSOR FOR SELECT _tmpWord_Split_to.WordList FROM _tmpWord_Split_to;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsListIncome());
     vbUserId:= lpGetUserBySession (inSession);
  

    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList) 
            SELECT DISTINCT ObjectString_GoodsKind.ValueData AS WordList
            FROM ObjectString AS ObjectString_GoodsKind
            WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListIncome_GoodsKind()
              AND ObjectString_GoodsKind.ValueData <> ''
           ;
    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);

  
     -- Результат
     RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
       , tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, STRING_AGG (Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                          FROM _tmpWord_Split_to 
                              LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                          GROUP BY _tmpWord_Split_to.WordList
                         )
          -- Результат
          SELECT 
             Object_GoodsListIncome.Id          AS Id

           , Object_Goods.Id         AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName

           , Object_GoodsKind.Id         AS GoodsKindId
           , Object_GoodsKind.ObjectCode AS GoodsKindCode
           , Object_GoodsKind.ValueData  AS GoodsKindName

           , Object_GoodsGroup.ValueData AS GoodsGroupName 
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , ObjectFloat_GoodsListIncome_Amount.ValueData AS Amount
           , ObjectFloat_GoodsListIncome_AmountChoice.ValueData AS AmountChoice

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

           , ObjectString_GoodsKind.ValueData  AS GoodsKindId_List
           , tmpGoodsKind.GoodsKindName_List :: TVarChar  AS GoodsKindName_List

           , ObjectHistory_JuridicalDetails_View.OKPO

           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , ObjectDate_GoodsListIncome_Last.ValueData          ::TDateTime AS LastDate 
           , COALESCE (ObjectBoolean_GoodsListIncome_Last.ValueData, False) AS isLast

           , COALESCE (ObjectBoolean_Default.ValueData, False)      AS isDefault
           , COALESCE (ObjectBoolean_DefaultOut.ValueData, False)   AS isDefaultOut
           , COALESCE (ObjectBoolean_Standart.ValueData, False)     AS isStandart

           , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
           , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
 
           , Object_GoodsListIncome.isErased      AS isErased
       
    FROM tmpIsErased
        INNER JOIN Object AS Object_GoodsListIncome 
                          ON Object_GoodsListIncome.isErased = tmpIsErased.isErased 
                         AND Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()

        LEFT JOIN ObjectLink AS GoodsListIncome_Contract
                             ON GoodsListIncome_Contract.ObjectId = Object_GoodsListIncome.Id
                            AND GoodsListIncome_Contract.DescId = zc_ObjectLink_GoodsListIncome_Contract()
        
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                             ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_GoodsListIncome_Juridical.ChildObjectId
            
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                             AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = GoodsListIncome_Contract.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                             ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsListIncome_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_GoodsKind
                             ON ObjectLink_GoodsListIncome_GoodsKind.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_GoodsKind.DescId = zc_ObjectLink_GoodsListIncome_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsListIncome_GoodsKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                             ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
        LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_GoodsListIncome_Partner.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListIncome_Amount
                              ON ObjectFloat_GoodsListIncome_Amount.ObjectId = Object_GoodsListIncome.Id
                             AND ObjectFloat_GoodsListIncome_Amount.DescId = zc_ObjectFloat_GoodsListIncome_Amount()
        LEFT JOIN ObjectFloat AS ObjectFloat_GoodsListIncome_AmountChoice
                              ON ObjectFloat_GoodsListIncome_AmountChoice.ObjectId = Object_GoodsListIncome.Id
                             AND ObjectFloat_GoodsListIncome_AmountChoice.DescId = zc_ObjectFloat_GoodsListIncome_AmountChoice()

        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

        LEFT JOIN ObjectDate AS ObjectDate_GoodsListIncome_Last
                             ON ObjectDate_GoodsListIncome_Last.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectDate_GoodsListIncome_Last.DescId = zc_ObjectDate_GoodsListIncome_Last()

        LEFT JOIN ObjectString AS ObjectString_GoodsKind
                               ON ObjectString_GoodsKind.ObjectId = Object_GoodsListIncome.Id
                              AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListIncome_GoodsKind()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsListIncome_Last
                                ON ObjectBoolean_GoodsListIncome_Last.ObjectId = Object_GoodsListIncome.Id
                               AND ObjectBoolean_GoodsListIncome_Last.DescId = zc_ObjectBoolean_GoodsListIncome_Last()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                                ON ObjectBoolean_DefaultOut.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_DefaultOut.DescId = zc_ObjectBoolean_Contract_DefaultOut()

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

        LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = ObjectString_GoodsKind.ValueData
        --
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                             ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

    WHERE (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
       AND (ObjectLink_GoodsListIncome_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
       AND (GoodsListIncome_Contract.ChildObjectId = inContractId OR inContractId = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.19         * DefaultOut
 05.05.17         *
 30.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsListIncome (0, 0, 0, FALSE, zfCalc_UserAdmin())
