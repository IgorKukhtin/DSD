-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractChoice (Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractChoice(
    IN inPaidKindId     Integer,       -- Форма оплаты
    IN inShowAll        Boolean,       --
    IN inJuridicalId    Integer,       -- Юр лицо
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractStateKindCode Integer
             , ContractComment TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , isErased Boolean 
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());

   --
   CREATE TEMP TABLE _tmpPaidKind (PaidKindId Integer, PaidKindName TVarChar) ON COMMIT DROP;
   IF COALESCE (inPaidKindId,0) <> 0 
   THEN 
       INSERT INTO _tmpPaidKind (PaidKindId, PaidKindName)
          SELECT Object.Id, Object.ValueData FROM Object WHERE Object.Id = inPaidKindId;
   ELSE 
       INSERT INTO _tmpPaidKind (PaidKindId, PaidKindName)
          SELECT Object.Id, Object.ValueData FROM Object WHERE Object.DescId = zc_Object_PaidKind();
   END IF;


   IF inShowAll= TRUE THEN
   
   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Contract_View.ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment 

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent

       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

       , Object_Contract_View.isErased
       
   FROM _tmpPaidKind
        INNER JOIN Object_Contract_View ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
                                       AND Object_Contract_View.isErased = FALSE
                                       AND (Object_Contract_View.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

 	LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

 	LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

   ;

   ELSE
   
   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Contract_View.ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment 

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent


       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

       , Object_Contract_View.isErased
       
   FROM _tmpPaidKind
        INNER JOIN Object_Contract_View ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                       AND Object_Contract_View.isErased = FALSE
                                       AND (Object_Contract_View.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

 	LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

 	LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

   ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractChoice (Integer, Boolean, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.08.14                                        * add ContractComment
 20.05.14                                        * !!!ContractKindName - всегда!!!
 06.05.14                                        * add ChangePercent TFloat
 25.04.14                                        * add ContractTagName
 27.03.14                         * add inJuridicalId
 27.02.14         * add inPaidKindId,inShowAll
 13.02.14                                         * add zc_Enum_ContractStateKind_Close
 13.02.14                                         * change Object_Contract_View.ContractStateKindCode
 06.01.14                                         * add OKPO
 18.11.13                         *                
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractChoice (inPaidKindId:=NULL, inShowAll:= true, inJuridicalId:=1, inSession := zfCalc_UserAdmin())
