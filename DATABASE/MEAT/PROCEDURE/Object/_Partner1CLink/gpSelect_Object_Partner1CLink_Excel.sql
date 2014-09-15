-- Function: gpSelect_Object_Partner1CLink_Excel(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner1CLink_Excel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner1CLink_Excel(
    IN inSession     TVarChar       -- сессия пользователя
)                                                                	
RETURNS TABLE (PartnerId integer, PartnerCode Integer, PartnerName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , Partner1CLinkId Integer, ClientCode1C Integer, PartnerName1C TVarChar
             , OKPO1C TVarChar
             , OKPO TVarChar
             , INN1C TVarChar
             , INN TVarChar
             , BranchId Integer, BranchName TVarChar
             , ItemName TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner1CLink_Excel());
   
     RETURN QUERY 
       WITH tmpJuridical AS (SELECT ObjectLink_Contract_Juridical.ChildObjectId     AS JuridicalId
                                  , ObjectLink_Partner_Juridical.ObjectId           AS PartnerId
                                  , TRIM (ObjectHistory_JuridicalDetails_View.OKPO) AS OKPO
                                  , TRIM (ObjectHistoryString_INN.ValueData)        AS INN
                             FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                  INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                        ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                                       AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_INN
                                                                ON ObjectHistoryString_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails_View.ObjectHistoryId
                                                               AND ObjectHistoryString_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
                             WHERE ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30101() -- "Готовая продукция"
                               AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                                    , ObjectLink_Partner_Juridical.ObjectId
                                  , TRIM (ObjectHistory_JuridicalDetails_View.OKPO)
                                  , TRIM (ObjectHistoryString_INN.ValueData)
                            )
          , tmpData1C  AS (SELECT Sale1C.ClientCode
                                , MAX (TRIM (Sale1C.ClientName)) AS ClientName
                                , MAX (TRIM (Sale1C.ClientOKPO)) AS ClientOKPO
                                , MAX (TRIM (Sale1C.ClientINN))  AS ClientINN
                                , zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc)) AS BranchTopId
                           FROM Sale1C
                           WHERE Sale1C.ClientCode <> 0
                           GROUP BY Sale1C.ClientCode -- , Sale1C.ClientName, Sale1C.ClientOKPO, Sale1C.ClientINN
                                  , zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
                          )
          , tmpGuide1C AS (SELECT Object_Partner1CLink.Id                         AS Partner1CLinkId
                                , Object_Partner1CLink.ObjectCode                 AS ClientCode
                                , TRIM (Object_Partner1CLink.ValueData)           AS ClientName
                                , TRIM (ObjectHistory_JuridicalDetails_View.OKPO) AS OKPO
                                , TRIM (ObjectHistoryString_INN.ValueData)        AS INN
                                , ObjectLink_Partner1CLink_Branch.ChildObjectId   AS BranchTopId
                                , ObjectLink_Partner1CLink_Partner.ChildObjectId  AS PartnerId
                                , ObjectLink_Partner_Juridical.ChildObjectId      AS JuridicalId
                           FROM Object AS Object_Partner1CLink
                                LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                                     ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                                    AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                                LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                                     ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                                    AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                LEFT JOIN ObjectHistoryString AS ObjectHistoryString_INN
                                                              ON ObjectHistoryString_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails_View.ObjectHistoryId
                                                             AND ObjectHistoryString_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
                           WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink()
                             AND Object_Partner1CLink.ObjectCode <> 0
                          )
          , tmpAll_1C  AS (SELECT tmpData1C.ClientCode
                                , tmpData1C.ClientName
                                , tmpData1C.ClientOKPO
                                , tmpGuide1C.OKPO
                                , tmpData1C.ClientINN
                                , tmpGuide1C.INN
                                , tmpData1C.BranchTopId
                                , tmpGuide1C.Partner1CLinkId
                                , tmpGuide1C.PartnerId
                                , tmpGuide1C.JuridicalId
                           FROM tmpData1C
                                LEFT JOIN tmpGuide1C ON tmpGuide1C.ClientCode = tmpData1C.ClientCode
                                                    AND tmpGuide1C.BranchTopId = tmpData1C.BranchTopId
                          UNION
                           SELECT tmpGuide1C.ClientCode
                                , tmpGuide1C.ClientName
                                , tmpGuide1C.OKPO AS ClientOKPO
                                , tmpGuide1C.OKPO
                                , tmpGuide1C.INN  AS ClientINN
                                , tmpGuide1C.INN
                                , tmpGuide1C.BranchTopId
                                , tmpGuide1C.Partner1CLinkId
                                , tmpGuide1C.PartnerId
                                , tmpGuide1C.JuridicalId
                           FROM tmpGuide1C
                                LEFT JOIN tmpData1C ON tmpGuide1C.ClientCode = tmpData1C.ClientCode
                                                   AND tmpGuide1C.BranchTopId = tmpData1C.BranchTopId
                           WHERE tmpData1C.ClientCode IS NULL
                          )
          , tmpAll     AS (SELECT tmpAll_1C.ClientCode
                                , tmpAll_1C.ClientName
                                , tmpAll_1C.ClientOKPO
                                , tmpAll_1C.OKPO
                                , tmpAll_1C.ClientINN
                                , tmpAll_1C.INN
                                , tmpAll_1C.BranchTopId
                                , tmpAll_1C.Partner1CLinkId
                                , tmpAll_1C.PartnerId
                                , tmpAll_1C.JuridicalId
                           FROM tmpAll_1C
                          UNION
                           SELECT tmpJuridical.JuridicalId AS ClientCode
                                , Object_Partner.ValueData AS ClientName
                                , tmpJuridical.OKPO AS ClientOKPO
                                , tmpJuridical.OKPO
                                , tmpJuridical.INN  AS ClientINN
                                , tmpJuridical.INN
                                , Object_Branch.Id AS BranchTopId
                                , 0 AS Partner1CLinkId
                                , tmpJuridical.PartnerId
                                , tmpJuridical.JuridicalId
                           FROM tmpJuridical
                                LEFT JOIN tmpAll_1C ON tmpAll_1C.PartnerId = tmpJuridical.PartnerId
                                LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = 8380 -- филиал Днепр
                                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpJuridical.PartnerId
                           WHERE tmpAll_1C.PartnerId IS NULL
                          )
       SELECT tmpAll.PartnerId                      AS PartnerId
            , Object_Partner.ObjectCode             AS PartnerCode
            , Object_Partner.ValueData              AS PartnerName
            , tmpAll.JuridicalId                    AS JuridicalId
            , Object_Juridical.ValueData            AS JuridicalName
            , Object_JuridicalGroup.ValueData       AS JuridicalGroupName

            , tmpAll.Partner1CLinkId
            , tmpAll.ClientCode :: Integer       AS ClientCode1C
            , tmpAll.ClientName :: TVarChar      AS PartnerName1C

            , tmpAll.ClientOKPO :: TVarChar      AS OKPO1C
            , tmpAll.OKPO       :: TVarChar      AS OKPO
            , tmpAll.ClientINN  :: TVarChar      AS INN1C
            , tmpAll.INN        :: TVarChar      AS INN

            , tmpAll.BranchTopId                    AS BranchId
            , Object_Branch.BranchLinkName          AS BranchName

            , ObjectDesc.ItemName
       FROM tmpAll
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpAll.PartnerId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpAll.JuridicalId
            LEFT JOIN Object_BranchLink_View AS Object_Branch ON Object_Branch.Id = tmpAll.BranchTopId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner1CLink_Excel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.14                                        * add ItemName
*/
-- тест
-- SELECT * FROM gpSelect_Object_Partner1CLink_Excel (zfCalc_UserAdmin()) WHERE ClientCode1C = 1
