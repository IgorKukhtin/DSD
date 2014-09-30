-- Function: gpSelect_Object_Partner1CLink_Excel(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner1CLink_Excel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner1CLink_Excel(
    IN inSession     TVarChar       -- сессия пользователя
)                                                                	
RETURNS TABLE (PartnerId integer, PartnerCode Integer, PartnerName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Partner1CLinkId Integer, ClientCode1C Integer, PartnerName1C TVarChar
             , OKPO1C TVarChar
             , OKPO TVarChar
             , INN1C TVarChar
             , INN TVarChar

             , isOKPO1C_OKPO Boolean
             , isOKPO1C_OKPOExcel Boolean
             , isOKPOExcel_OKPO Boolean


             , JuridicalNameExcel_find TVarChar
             , JuridicalNameExcel TVarChar
             , PartnerNameExcel TVarChar
             , OKPOExcel TVarChar
             , KodBranchExcel TVarChar
             , PartnerNameCalcExcel TVarChar

             , index tvarchar
             , citytype tvarchar
             , cityname tvarchar
             , regiontype tvarchar
             , region tvarchar
             , streettype tvarchar
             , streetname tvarchar
             , house tvarchar
             , house1 tvarchar
             , house2 tvarchar
             , house3 tvarchar
             , kontakt1name tvarchar
             , kontakt1tel tvarchar
             , kontakt1email tvarchar
             , kontakt2name tvarchar
             , kontakt2tel tvarchar
             , kontakt2email tvarchar
             , kontakt3name tvarchar
             , kontakt3tel tvarchar
             , kontakt3email tvarchar

             , BranchId Integer, BranchName TVarChar
             , AccountName_all TVarChar
             , ItemName TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner1CLink_Excel());
   
     RETURN QUERY 
       WITH tmpOborot    AS (SELECT ContainerLinkObject_Juridical.ObjectId      AS JuridicalId
                                  , Object_Account_View.AccountId
                                  , MIN (ContainerLinkObject_PaidKind.ObjectId) AS PaidKindId
                             FROM Object_Account_View
                                  INNER JOIN Container ON Container.ObjectId = Object_Account_View.AccountId
                                                      AND Container.DescId = zc_Container_Summ()
                                  INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                  AND MovementItemContainer.OperDate >= '01.01.2014' :: TDateTime
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                                 ON ContainerLinkObject_Juridical.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                AND ContainerLinkObject_Juridical.ObjectId > 0
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                 ON ContainerLinkObject_PaidKind.ContainerId = Container.Id
                                                                AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                AND ContainerLinkObject_PaidKind.ObjectId > 0
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = Container.Id
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                  INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
                                                                  AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30500() -- Прочие доходы
                             WHERE Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_30100() -- Дебиторы + покупатели
                             GROUP BY ContainerLinkObject_Juridical.ObjectId
                                    , Object_Account_View.AccountId
                            )
          , tmpJuridical AS (SELECT tmpJuridical.JuridicalId
                                  , tmpJuridical.PaidKindId
                                  , tmpJuridical.AccountId
                                  , ObjectLink_Partner_Juridical.ObjectId           AS PartnerId
                                  , TRIM (ObjectHistory_JuridicalDetails_View.OKPO) AS OKPO
                                  , TRIM (ObjectHistoryString_INN.ValueData)        AS INN
                             FROM (SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                        , tmpOborot.PaidKindId
                                        , tmpOborot.AccountId
                                   FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                        INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                              ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                                             AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                                             ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                            AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
                                        LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
                                        LEFT JOIN tmpOborot ON tmpOborot.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                   WHERE ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30101() -- "Готовая продукция"
                                     AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                   GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                                          , tmpOborot.PaidKindId
                                          , tmpOborot.AccountId
                                  UNION
                                   SELECT tmpOborot.JuridicalId, tmpOborot.PaidKindId, tmpOborot.AccountId FROM tmpOborot
                                  ) AS tmpJuridical
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = tmpJuridical.JuridicalId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = tmpJuridical.JuridicalId
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_INN
                                                                ON ObjectHistoryString_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails_View.ObjectHistoryId
                                                               AND ObjectHistoryString_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
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
                                , tmpOborot.PaidKindId
                                , tmpOborot.AccountId
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
                                LEFT JOIN tmpOborot ON tmpOborot.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
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
                                , tmpGuide1C.PaidKindId
                                , tmpGuide1C.AccountId
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
                                , tmpGuide1C.PaidKindId
                                , tmpGuide1C.AccountId
                           FROM tmpGuide1C
                                LEFT JOIN tmpData1C ON tmpGuide1C.ClientCode = tmpData1C.ClientCode
                                                   AND tmpGuide1C.BranchTopId = tmpData1C.BranchTopId
                           WHERE tmpData1C.ClientCode IS NULL
                          )
          , tmpExcel   AS (SELECT tmp.ClientCode
                                , tmp.JuridicalName
                                , tmp.ClientName
                                , tmp.ClientOKPO

                                , tmp.JuridicalName
                               || CASE WHEN tmp.cityname <> '' THEN ' ' || tmp.citytype || ' ' || tmp.cityname ELSE '' END
                               || CASE WHEN tmp.region <> '' AND tmp.regiontype <> '' AND tmp.citytype <> 'місто' THEN ' ' || tmp.regiontype || ' ' || tmp.region ELSE '' END
                               || CASE WHEN tmp.streetname <> '' THEN ' ' || tmp.streettype || ' ' || tmp.streetname ELSE '' END
                               || CASE WHEN tmp.house <> '' THEN ' ' || tmp.house || tmp.house1 ELSE '' END
                               || CASE WHEN tmp.house2 <> '' THEN '/' || tmp.house2 ELSE '' END
                               || CASE WHEN tmp.house3 <> '' THEN '/' || tmp.house3 ELSE '' END
                                  AS ClientNameCalc

                                , tmp.index
                                , tmp.citytype
                                , tmp.cityname
                                , tmp.regiontype
                                , tmp.region
                                , tmp.streettype
                                , tmp.streetname
                                , tmp.house
                                , tmp.house1
                                , tmp.house2
                                , tmp.house3
                                , tmp.kontakt1name
                                , tmp.kontakt1tel
                                , tmp.kontakt1email
                                , tmp.kontakt2name
                                , tmp.kontakt2tel
                                , tmp.kontakt2email
                                , tmp.kontakt3name
                                , tmp.kontakt3tel
                                , tmp.kontakt3email

                                , tmp.IsCode
                                , tmp.BranchTopId
                                , tmp.KodBranch
                           FROM
                          (SELECT CASE WHEN TRIM (PartnerAll.CodeTT1C) = '' THEN '0' ELSE TRIM (PartnerAll.CodeTT1C) END :: Integer AS ClientCode
                                , MAX (TRIM (PartnerAll.JuridicalName)) AS JuridicalName
                                , MAX (TRIM (PartnerAll.TTIn1C)) AS ClientName
                                , MAX (TRIM (PartnerAll.OKPO)) AS ClientOKPO

                                , MAX (TRIM (PartnerAll.index))      AS index
                                , MAX (TRIM (PartnerAll.citytype))   AS citytype
                                , MAX (TRIM (PartnerAll.cityname))   AS cityname
                                , MAX (CASE WHEN TRIM (PartnerAll.regiontype) <> '-' THEN TRIM (PartnerAll.regiontype) ELSE '' END)  AS regiontype
                                , MAX (TRIM (PartnerAll.region))     AS region
                                , MAX (TRIM (PartnerAll.streettype)) AS streettype
                                , MAX (TRIM (PartnerAll.streetname)) AS streetname
                                , MAX (CASE WHEN TRIM (PartnerAll.house) <> '-' THEN TRIM (PartnerAll.house) ELSE '' END)  AS house
                                , MAX (CASE WHEN TRIM (PartnerAll.house1) <> '-' THEN TRIM (PartnerAll.house1) ELSE '' END) AS house1
                                , MAX (CASE WHEN TRIM (PartnerAll.house2) <> '-' THEN TRIM (PartnerAll.house2) ELSE '' END) AS house2
                                , MAX (CASE WHEN TRIM (PartnerAll.house3) <> '-' THEN TRIM (PartnerAll.house3) ELSE '' END) AS house3
                                , MAX (TRIM (PartnerAll.kontakt1name))  AS kontakt1name
                                , MAX (TRIM (PartnerAll.kontakt1tel))   AS kontakt1tel
                                , MAX (TRIM (PartnerAll.kontakt1email)) AS kontakt1email
                                , MAX (TRIM (PartnerAll.kontakt2name))  AS kontakt2name
                                , MAX (TRIM (PartnerAll.kontakt2tel))   AS kontakt2tel
                                , MAX (TRIM (PartnerAll.kontakt2email)) AS kontakt2email
                                , MAX (TRIM (PartnerAll.kontakt3name))  AS kontakt3name
                                , MAX (TRIM (PartnerAll.kontakt3tel))   AS kontakt3tel
                                , MAX (TRIM (PartnerAll.kontakt3email)) AS kontakt3email

                                , MAX (CASE WHEN Object_BranchLink_View.Id :: TVarChar = KodBranch THEN 0 ELSE 1 END) AS IsCode
                                , Object_BranchLink_View.Id AS BranchTopId
                                , TRIM (PartnerAll.KodBranch) AS KodBranch
                           FROM PartnerAll
                                INNER JOIN Object_BranchLink_View ON (Object_BranchLink_View.Id = CASE KodBranch WHEN '01' THEN 257153 -- филиал Днепр
                                                                                                                 WHEN '1' THEN 257153 -- филиал Днепр
                                                                                                                        WHEN '02' THEN 257152 -- 2 филиал Киев";8379;"филиал Киев";3;"БН";"филиал Киев БН"
                                                                                                                        WHEN '2' THEN 257152 -- 2 филиал Киев";8379;"филиал Киев";3;"БН";"филиал Киев БН"
                                                                                                                        WHEN '03' THEN 257161 -- 3;"филиал Николаев (Херсон)";8373;"филиал Николаев (Херсон)";;"";"филиал Николаев (Херсон) "
                                                                                                                        WHEN '3' THEN 257161 -- 3;"филиал Николаев (Херсон)";8373;"филиал Николаев (Херсон)";;"";"филиал Николаев (Херсон) "
                                                                                                                        WHEN '04' THEN 257154 -- 4;"филиал Одесса";8374;"филиал Одесса";;"";"филиал Одесса "
                                                                                                                        WHEN '4'  THEN 257154 -- 4;"филиал Одесса";8374;"филиал Одесса";;"";"филиал Одесса "
                                                                                                                        WHEN '05' THEN 257155 -- 5;"филиал Черкассы ( Кировоград)";8375;"филиал Черкассы (Кировоград)";;"";"филиал Черкассы (Кировоград) "
                                                                                                                        WHEN '5' THEN 257155 -- 5;"филиал Черкассы ( Кировоград)";8375;"филиал Черкассы (Кировоград)";;"";"филиал Черкассы (Кировоград) "
                                                                                                                        WHEN '06' THEN 257156 -- 6;"филиал Крым";8376;"филиал Крым";;"";"филиал Крым "
                                                                                                                        WHEN '6' THEN 257156 -- 6;"филиал Крым";8376;"филиал Крым";;"";"филиал Крым "
                                                                                                                        WHEN '07' THEN 257157 -- 7;"филиал Кр.Рог";8377;"филиал Кр.Рог";;"";"филиал Кр.Рог "
                                                                                                                        WHEN '7' THEN 257157 -- 7;"филиал Кр.Рог";8377;"филиал Кр.Рог";;"";"филиал Кр.Рог "
                                                                                                                        WHEN '08' THEN 257158 -- 8;"филиал Донецк";8378;"филиал Донецк";;"";"филиал Донецк "
                                                                                                                        WHEN '8' THEN 257158 -- 8;"филиал Донецк";8378;"филиал Донецк";;"";"филиал Донецк "
                                                                                                                        WHEN '09' THEN 257159 -- 9;"филиал Харьков";8381;"филиал Харьков";;"";"филиал Харьков "
                                                                                                                        WHEN '9' THEN 257159 -- 9;"филиал Харьков";8381;"филиал Харьков";;"";"филиал Харьков "
                                                                                                                        -- WHEN '10' THEN 257160 -- 10;"филиал Никополь";18342;"филиал Никополь";;"";"филиал Никополь "
                                                                                                                        WHEN '222' THEN 257162 -- 2;"филиал Киев";8379;"филиал Киев";4;"Нал";"филиал Киев Нал"
                                                                                                              ELSE '0'
                                                                                                         END :: Integer
                                                                     )
                                                                   OR Object_BranchLink_View.Id :: TVarChar = KodBranch
                           GROUP BY CASE WHEN TRIM (PartnerAll.CodeTT1C) = '' THEN '0' ELSE TRIM (PartnerAll.CodeTT1C) END
                                  , Object_BranchLink_View.Id
                                  , TRIM (PartnerAll.KodBranch)
                          ) AS tmp
                          WHERE ClientCode <> 0
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
                                , tmpAll_1C.PaidKindId
                                , tmpAll_1C.AccountId
                           FROM tmpAll_1C
                          UNION
                           SELECT tmpJuridical.PartnerId AS ClientCode
                                , Object_Partner.ValueData AS ClientName
                                , tmpJuridical.OKPO AS ClientOKPO
                                , tmpJuridical.OKPO
                                , tmpJuridical.INN  AS ClientINN
                                , tmpJuridical.INN
                                , Object_Branch.Id AS BranchTopId
                                , 0 AS Partner1CLinkId
                                , tmpJuridical.PartnerId
                                , tmpJuridical.JuridicalId
                                , tmpJuridical.PaidKindId
                                , tmpJuridical.AccountId
                           FROM tmpJuridical
                                LEFT JOIN tmpAll_1C ON tmpAll_1C.PartnerId = tmpJuridical.PartnerId
                                LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = 257153 -- филиал Днепр
                                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpJuridical.PartnerId
                           WHERE tmpAll_1C.PartnerId IS NULL
                          )
       SELECT tmpAll.PartnerId                      AS PartnerId
            , Object_Partner.ObjectCode             AS PartnerCode
            , Object_Partner.ValueData              AS PartnerName
            , tmpAll.JuridicalId                    AS JuridicalId
            , Object_Juridical.ValueData            AS JuridicalName
            , Object_JuridicalGroup.ValueData       AS JuridicalGroupName
            , Object_PaidKind.Id                    AS PaidKindId
            , Object_PaidKind.ValueData             AS PaidKindName

            , tmpAll.Partner1CLinkId
            , COALESCE (tmpAll.ClientCode1C, tmpExcel.ClientCode) :: Integer AS ClientCode1C
            , tmpAll.PartnerName1C :: TVarChar      AS PartnerName1C

            , tmpAll.OKPO1C     :: TVarChar      AS OKPO1C
            , tmpAll.OKPO       :: TVarChar      AS OKPO
            , tmpAll.INN1C      :: TVarChar      AS INN1C
            , tmpAll.INN        :: TVarChar      AS INN

            , CASE WHEN ((tmpAll.OKPO1C <> '' AND SUBSTRING (tmpAll.OKPO1C, 3, 1) <> '-' AND SUBSTRING (tmpAll.OKPO1C, 3, 1) <> '*')
                      OR (tmpAll.OKPO <> '' AND SUBSTRING (tmpAll.OKPO, 3, 1) <> '-' AND SUBSTRING (tmpAll.OKPO, 3, 1) <> '*'))
                    AND COALESCE (tmpAll.OKPO1C, '') <> COALESCE (tmpAll.OKPO, '')
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isOKPO1C_OKPO

            , CASE WHEN ((tmpAll.OKPO1C <> '' AND SUBSTRING (tmpAll.OKPO1C, 3, 1) <> '-' AND SUBSTRING (tmpAll.OKPO1C, 3, 1) <> '*')
                      OR (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel) <> '' AND SUBSTRING (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel), 3, 1) <> '-' AND SUBSTRING (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel), 3, 1) <> '*'))
                    AND COALESCE (tmpAll.OKPO1C, '') <> COALESCE (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel), '')
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isOKPO1C_OKPOExcel

            , CASE WHEN ((COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel) <> '' AND SUBSTRING (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel), 3, 1) <> '-' AND SUBSTRING (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel), 3, 1) <> '*')
                      OR (tmpAll.OKPO <> '' AND SUBSTRING (tmpAll.OKPO, 3, 1) <> '-' AND SUBSTRING (tmpAll.OKPO, 3, 1) <> '*'))
                    AND COALESCE (COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel), '') <> COALESCE (tmpAll.OKPO, '')
                    AND COALESCE (tmpExcel.JuridicalName, tmpAll.JuridicalNameExcel) <> ''
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isOKPOExcel_OKPO

            , CASE WHEN JuridicalExcel_find.isOKPOVirt = TRUE THEN 'виртуальное ОКПО' ELSE Object_JuridicalExcel_find.ValueData END :: TVarChar AS JuridicalNameExcel_find
            , COALESCE (tmpExcel.JuridicalName, tmpAll.JuridicalNameExcel)  :: TVarChar AS JuridicalNameExcel
            , COALESCE (tmpExcel.ClientName, tmpAll.PartnerNameExcel)     :: TVarChar AS PartnerNameExcel
            , COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel)     :: TVarChar AS OKPOExcel
            , COALESCE (tmpExcel.KodBranch, tmpAll.KodBranchExcel)      :: TVarChar AS KodBranchExcel

            , COALESCE (tmpExcel.ClientNameCalc, tmpAll.PartnerNameCalcExcel) :: TVarChar AS PartnerNameCalcExcel
            , COALESCE (tmpExcel.index, tmpAll.index)          :: TVarChar AS index
            , COALESCE (tmpExcel.citytype, tmpAll.citytype)       :: TVarChar AS citytype
            , COALESCE (tmpExcel.cityname, tmpAll.cityname)       :: TVarChar AS cityname
            , COALESCE (tmpExcel.regiontype, tmpAll.regiontype)     :: TVarChar AS regiontype
            , COALESCE (tmpExcel.region, tmpAll.region)         :: TVarChar AS region
            , COALESCE (tmpExcel.streettype, tmpAll.streettype)     :: TVarChar AS streettype
            , COALESCE (tmpExcel.streetname, tmpAll.streetname)     :: TVarChar AS streetname
            , COALESCE (tmpExcel.house, tmpAll.house)          :: TVarChar AS house
            , COALESCE (tmpExcel.house1, tmpAll.house1)         :: TVarChar AS house1
            , COALESCE (tmpExcel.house2, tmpAll.house2)         :: TVarChar AS house2
            , COALESCE (tmpExcel.house3, tmpAll.house3)         :: TVarChar AS house3
            , COALESCE (tmpExcel.kontakt1name, tmpAll.kontakt1name)   :: TVarChar AS kontakt1name
            , COALESCE (tmpExcel.kontakt1tel, tmpAll.kontakt1tel)    :: TVarChar AS kontakt1tel
            , COALESCE (tmpExcel.kontakt1email, tmpAll.kontakt1email)  :: TVarChar AS kontakt1email
            , COALESCE (tmpExcel.kontakt2name, tmpAll.kontakt2name)   :: TVarChar AS kontakt2name
            , COALESCE (tmpExcel.kontakt2tel, tmpAll.kontakt2tel)    :: TVarChar AS kontakt2tel
            , COALESCE (tmpExcel.kontakt2email, tmpAll.kontakt2email)  :: TVarChar AS kontakt2email
            , COALESCE (tmpExcel.kontakt3name, tmpAll.kontakt3name)   :: TVarChar AS kontakt3name
            , COALESCE (tmpExcel.kontakt3tel, tmpAll.kontakt3tel)    :: TVarChar AS kontakt3tel
            , COALESCE (tmpExcel.kontakt3email, tmpAll.kontakt3email)  :: TVarChar AS kontakt3email

            , tmpAll.BranchTopId                    AS BranchId
            , Object_Branch.BranchLinkName          AS BranchName

            , Object_Account_View.AccountName_all
            , ObjectDesc.ItemName
       FROM (SELECT tmpAll.PartnerId                      AS PartnerId
                  , tmpAll.JuridicalId                    AS JuridicalId
                  , tmpAll.PaidKindId                     AS PaidKindId
                  , tmpAll.AccountId                      AS AccountId

                  , tmpAll.Partner1CLinkId
                  , COALESCE (tmpAll.ClientCode, tmpExcel.ClientCode) :: Integer AS ClientCode1C
                  -- , tmpAll.ClientCode
                  , tmpAll.ClientName :: TVarChar      AS PartnerName1C

                  , tmpAll.ClientOKPO :: TVarChar      AS OKPO1C
                  , tmpAll.OKPO       :: TVarChar      AS OKPO
                  , tmpAll.ClientINN  :: TVarChar      AS INN1C
                  , tmpAll.INN        :: TVarChar      AS INN

                 , tmpExcel.JuridicalName  :: TVarChar AS JuridicalNameExcel
                 , tmpExcel.ClientName     :: TVarChar AS PartnerNameExcel
                 , tmpExcel.ClientOKPO     :: TVarChar AS OKPOExcel
                 , tmpExcel.KodBranch      :: TVarChar AS KodBranchExcel

                 , tmpExcel.ClientNameCalc :: TVarChar AS PartnerNameCalcExcel
                 , tmpExcel.index          :: TVarChar AS index
                 , tmpExcel.citytype       :: TVarChar AS citytype
                 , tmpExcel.cityname       :: TVarChar AS cityname
                 , tmpExcel.regiontype     :: TVarChar AS regiontype
                 , tmpExcel.region         :: TVarChar AS region
                 , tmpExcel.streettype     :: TVarChar AS streettype
                 , tmpExcel.streetname     :: TVarChar AS streetname
                 , tmpExcel.house          :: TVarChar AS house
                 , tmpExcel.house1         :: TVarChar AS house1
                 , tmpExcel.house2         :: TVarChar AS house2
                 , tmpExcel.house3         :: TVarChar AS house3
                 , tmpExcel.kontakt1name   :: TVarChar AS kontakt1name
                 , tmpExcel.kontakt1tel    :: TVarChar AS kontakt1tel
                 , tmpExcel.kontakt1email  :: TVarChar AS kontakt1email
                 , tmpExcel.kontakt2name   :: TVarChar AS kontakt2name
                 , tmpExcel.kontakt2tel    :: TVarChar AS kontakt2tel
                 , tmpExcel.kontakt2email  :: TVarChar AS kontakt2email
                 , tmpExcel.kontakt3name   :: TVarChar AS kontakt3name
                 , tmpExcel.kontakt3tel    :: TVarChar AS kontakt3tel
                 , tmpExcel.kontakt3email  :: TVarChar AS kontakt3email

                 , COALESCE (tmpExcel.BranchTopId, tmpAll.BranchTopId)  AS BranchTopId

             FROM tmpAll
                  FULL JOIN (SELECT tmpExcel.* FROM tmpExcel WHERE tmpExcel.IsCode = 1
                            ) AS tmpExcel
                              ON tmpExcel.ClientCode = tmpAll.ClientCode
                             AND tmpExcel.BranchTopId = tmpAll.BranchTopId
            ) AS tmpAll
            FULL JOIN (SELECT tmpExcel.* FROM tmpExcel WHERE tmpExcel.IsCode = 0
                      ) AS tmpExcel ON tmpExcel.ClientCode = tmpAll.PartnerId



            LEFT JOIN (SELECT MAX (ObjectHistory_JuridicalDetails_View.JuridicalId) AS JuridicalId, ObjectHistory_JuridicalDetails_View.OKPO
                            , CASE WHEN ObjectHistory_JuridicalDetails_View.OKPO <> '' AND SUBSTRING (ObjectHistory_JuridicalDetails_View.OKPO, 3, 1) <> '-' AND SUBSTRING (ObjectHistory_JuridicalDetails_View.OKPO, 3, 1) <> '*' THEN FALSE ELSE TRUE END AS isOKPOVirt
                       FROM ObjectHistory_JuridicalDetails_View
                       GROUP BY ObjectHistory_JuridicalDetails_View.OKPO
                      ) AS JuridicalExcel_find ON JuridicalExcel_find.OKPO = COALESCE (tmpExcel.ClientOKPO, tmpAll.OKPOExcel)
            LEFT JOIN Object AS Object_JuridicalExcel_find ON Object_JuridicalExcel_find.Id = JuridicalExcel_find.JuridicalId

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpAll.PartnerId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpAll.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpAll.PaidKindId
            LEFT JOIN Object_BranchLink_View AS Object_Branch ON Object_Branch.Id = COALESCE (tmpExcel.BranchTopId, tmpAll.BranchTopId)

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpAll.AccountId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
      WHERE ObjectDesc.Id = zc_Object_Partner()
        AND Object_Account_View.AccountCode = 30101
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner1CLink_Excel (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.14                                        *
*/
/*
-- Table: partnerall

-- DROP TABLE partnerall;

CREATE TABLE partnerall
(
  kodbranch tvarchar,
  namebranch tvarchar,
  juridicalname tvarchar,
  okpo tvarchar,
  codett1c tvarchar,
  ttin1c tvarchar,
  index tvarchar,
  citytype tvarchar,
  cityname tvarchar,
  regiontype tvarchar,
  region tvarchar,
  streettype tvarchar,
  streetname tvarchar,
  house tvarchar,
  house1 tvarchar,
  house2 tvarchar,
  house3 tvarchar,
  kontakt1name tvarchar,
  kontakt1tel tvarchar,
  kontakt1email tvarchar,
  kontakt2name tvarchar,
  kontakt2tel tvarchar,
  kontakt2email tvarchar,
  kontakt3name tvarchar,
  kontakt3tel tvarchar,
  kontakt3email tvarchar,
  partnerid integer,
  partneroldid integer,
  contractoldid integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE partnerall
  OWNER TO postgres;
GRANT ALL ON TABLE partnerall TO postgres;
GRANT ALL ON TABLE partnerall TO project;
*/
-- тест
-- SELECT * FROM gpSelect_Object_Partner1CLink_Excel (zfCalc_UserAdmin()) AS tmp WHERE ClientCode1C = 1
