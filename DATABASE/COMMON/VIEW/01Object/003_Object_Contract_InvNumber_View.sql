-- View: Object_Contract_InvNumber_View

CREATE OR REPLACE VIEW Object_Contract_InvNumber_View
AS
  SELECT Object_Contract.Id                            AS ContractId
       , Object_Contract.ObjectCode                    AS ContractCode  
       -- , CAST(CASE WHEN Object_Contract.ValueData <> '' THEN Object_Contract.ValueData ELSE '**ÛÔ' || CAST (Object_InfoMoney.ObjectCode AS TVarChar) END AS TVarChar) AS InvNumber
       , Object_Contract.ValueData                     AS InvNumber
       , ObjectLink_Contract_InfoMoney.ChildObjectId   AS InfoMoneyId
       , Object_ContractTagGroup.Id                    AS ContractTagGroupId
       , Object_ContractTagGroup.ObjectCode            AS ContractTagGroupCode
       , Object_ContractTagGroup.ValueData             AS ContractTagGroupName
       , Object_ContractTag.Id                         AS ContractTagId
       , Object_ContractTag.ObjectCode                 AS ContractTagCode
       , Object_ContractTag.ValueData                  AS ContractTagName
       , COALESCE (Object_ContractStateKind.Id, 0)     AS ContractStateKindId
       , Object_ContractStateKind.ObjectCode           AS ContractStateKindCode
       , Object_ContractStateKind.ValueData            AS ContractStateKindName
       , Object_Contract.isErased                      AS isErased
  FROM Object AS Object_Contract
       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
       -- LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                            ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = Object_ContractTag.Id
                           AND ObjectLink_ContractTag_ContractTagGroup.DescId = zc_ObjectLink_ContractTag_ContractTagGroup()
       LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = ObjectLink_ContractTag_ContractTagGroup.ChildObjectId  

       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                            ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
       LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId

  WHERE Object_Contract.DescId = zc_Object_Contract();


ALTER TABLE Object_Contract_InvNumber_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 14.01.15                                        * add ContractTagGroup...
 21.07.14                                        * no calc InvNumber
 26.04.14                                        * del ContractKeyId
 25.04.14                                        * add ContractKeyId
 24.04.14                                        * all
 14.01.14                                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Contract_InvNumber_View