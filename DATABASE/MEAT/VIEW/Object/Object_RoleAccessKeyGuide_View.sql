-- View: Object_RoleAccessKeyGuide_View

-- DROP VIEW IF EXISTS Object_RoleAccessKeyGuide_View;

CREATE OR REPLACE VIEW Object_RoleAccessKeyGuide_View AS

   SELECT tmpAccessKey.UserId
        , tmpAccessKey.AccessKeyId_Guide
        , tmpAccessKey.AccessKeyId_PersonalService
        , tmpAccessKey.AccessKeyId_PeriodClose

        , CASE WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDnepr()
                    THEN 257163 -- покупатели Днепр

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKiev()
                    THEN 257164 -- покупатели Киев

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 257165 -- покупатели Николаев (Херсон)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257166 -- покупатели Одесса

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideCherkassi()
                    THEN 257167 -- покупатели Черкассы (Кировоград)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257168 -- покупатели Крым

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKrRog()
                    THEN 257169 -- покупатели Кр.Рог

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDoneck()
                    THEN 257170 -- покупатели Донецк

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKharkov()
                    THEN 257171 -- покупатели Харьков

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257172 -- покупатели Никополь

               ELSE 0
          END AS JuridicalGroupId

        , CASE WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDnepr()
                    THEN 8380 -- филиал Днепр

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKiev()
                    THEN 8379 -- филиал Киев

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 8373 -- филиал Николаев (Херсон)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 8374 -- филиал Одесса

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideCherkassi()
                    THEN 8375 -- филиал Черкассы (Кировоград)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 8376 -- филиал Крым

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKrRog()
                    THEN 8377 -- филиал Кр.Рог

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDoneck()
                    THEN 8378 -- филиал Донецк

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKharkov()
                    THEN 8381 -- филиал Харьков

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 18342 -- филиал Никополь

               ELSE 0
          END AS BranchId

        , lfSelect_Object_Unit_byProfitLossDirection.UnitId AS UnitId_PersonalService

   FROM (SELECT UserId
              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_GuideDnepr()
                                             , zc_Enum_Process_AccessKey_GuideKiev()
                                             , zc_Enum_Process_AccessKey_GuideKrRog()
                                             , zc_Enum_Process_AccessKey_GuideNikolaev()
                                             , zc_Enum_Process_AccessKey_GuideKharkov()
                                             , zc_Enum_Process_AccessKey_GuideCherkassi()
                                             , zc_Enum_Process_AccessKey_GuideDoneck()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_Guide
              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                             , zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                             , zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                             , zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                             , zc_Enum_Process_AccessKey_PersonalServiceSB()
                                             , zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_PersonalService
              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_PeriodCloseAll()
                                             , zc_Enum_Process_AccessKey_PeriodCloseTax()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_PeriodClose
         FROM Object_RoleAccessKey_View
         WHERE AccessKeyId <> 0
         GROUP BY UserId
        ) AS tmpAccessKey
              LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect_Object_Unit_byProfitLossDirection
                                                                     ON (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                                                     AND (ProfitLossDirectionCode IN (20100 -- Общепроизводственные расходы + Содержание производства
                                                                                                    , 20200 -- Общепроизводственные расходы + Содержание складов
                                                                                                    , 20300 -- Общепроизводственные расходы + Содержание транспорта
                                                                                                    , 20400 -- Общепроизводственные расходы + Содержание Кухни
                                                                                                    , 30200 -- Административные расходы + Содержание транспорта
                                                                                                     )
                                                                          OR (UnitCode NOT IN (11010 -- АУП
                                                                                             , 11030 -- Бухгалтерия
                                                                                             , 23010 -- Отдел Маркетинга
                                                                                             , 23020 -- Отдел логистики
                                                                                             , 23040 -- Отдел коммерции (общефирменный)
                                                                                              )
                                                                              AND ProfitLossDirectionCode IN (30100 -- Административные расходы + Содержание админ
                                                                                                            , 40300 -- Расходы на сбыт + Общефирменные
                                                                                                             )
                                                                             )
                                                                         )
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin()
--                                                                     AND ProfitLossDirectionCode IN (30100 -- Административные расходы + Содержание админ
--                                                                                                   , 30200 -- Административные расходы + Содержание транспорта
--                                                                                                    )
                                                                                                     )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                                                     AND UnitCode NOT IN (23010) -- Отдел Маркетинга
                                                                     AND ProfitLossDirectionCode IN (40300 -- Расходы на сбыт + Общефирменные
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                                                     AND UnitCode IN (23010) -- Отдел Маркетинга
                                                                     AND ProfitLossDirectionCode IN (40300 -- Расходы на сбыт + Общефирменные
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSB()
                                                                     -- AND UnitCode IN (13000, 13010) -- Охрана + Служба безопастности
                                                                     AND ProfitLossDirectionCode IN (30300 -- Административные расходы + Содержание охраны
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                                                                                    )
           ;

ALTER TABLE Object_RoleAccessKeyGuide_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.14                                        * add AccessKeyId_PeriodClose
 17.09.14                                        *
 08.09.14                                        *
*/

-- тест
-- SELECT * FROM Object_RoleAccessKeyGuide_View
