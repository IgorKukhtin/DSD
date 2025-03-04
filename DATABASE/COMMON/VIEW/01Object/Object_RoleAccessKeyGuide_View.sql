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

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideLviv()
                    -- THEN 257164 -- покупатели Киев
                    THEN 280271 -- покупатели Львов

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideVinnica()
                    THEN 280276 -- покупатели Вінниця

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 257165 -- покупатели Николаев (Херсон)

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideOdessa()
                    THEN 257166 -- покупатели Одесса

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideCherkassi()
                    THEN 257167 -- покупатели Черкассы (Кировоград)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_Guide()
               --      THEN 257168 -- покупатели Крым

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKrRog()
                    THEN 257169 -- покупатели Кр.Рог

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDoneck()
                    THEN 257170 -- покупатели Донецк

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKharkov()
                    THEN 257171 -- покупатели Харьков

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257172 -- покупатели Никополь

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideZaporozhye()
                    THEN 301805 -- покупатели Запорожье

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideIrna()
                    THEN 8235255 -- покупатели Ирна

               ELSE 0
          END AS JuridicalGroupId

        , CASE WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDnepr()
                    THEN 8380 -- филиал Днепр

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKiev()
                    THEN 8379 -- филиал Киев

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideLviv()
                    THEN 3080683 -- филиал Львов

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideVinnica()
                    THEN 11920989 -- филиал Винница

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 8373 -- филиал Николаев (Херсон)

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideOdessa()
                    THEN 8374 -- филиал Одесса

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

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideZaporozhye()
                    THEN 301310 -- филиал Запорожье

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideIrna()
                    THEN 8109544 -- филиал Ирна

               ELSE 0
          END AS BranchId

        , tmpAccessKey.AccessKeyId_GuideCommerce
        , tmpAccessKey.AccessKeyId_GuideCommerceAll

        , tmpAccessKey.AccessKeyId_UserOrder

        , lfSelect_Object_Unit_byProfitLossDirection.UnitId AS UnitId_PersonalService

   FROM (SELECT UserId
              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_GuideDnepr()
                                             , zc_Enum_Process_AccessKey_GuideKiev()
                                             , zc_Enum_Process_AccessKey_GuideLviv()
                                             , zc_Enum_Process_AccessKey_GuideVinnica()
                                             , zc_Enum_Process_AccessKey_GuideKrRog()
                                             , zc_Enum_Process_AccessKey_GuideNikolaev()
                                             , zc_Enum_Process_AccessKey_GuideKharkov()
                                             , zc_Enum_Process_AccessKey_GuideCherkassi()
                                             , zc_Enum_Process_AccessKey_GuideDoneck()
                                             , zc_Enum_Process_AccessKey_GuideZaporozhye()
                                             , zc_Enum_Process_AccessKey_GuideOdessa()
                                             , zc_Enum_Process_AccessKey_GuideIrna()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_Guide

              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_GuideCommerce()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_GuideCommerce
              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_GuideCommerceAll()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_GuideCommerceAll

              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_UserOrder()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_UserOrder

              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                             , zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                             , zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                             , zc_Enum_Process_AccessKey_PersonalServiceSbitM()
                                             , zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                             , zc_Enum_Process_AccessKey_PersonalServiceSB()
                                             , zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                             , zc_Enum_Process_AccessKey_PersonalServicePav()
                                             , zc_Enum_Process_AccessKey_PersonalServiceOther()

                                             , zc_Enum_Process_AccessKey_PersonalServiceKiev()
                                             , zc_Enum_Process_AccessKey_PersonalServiceLviv()
                                             , zc_Enum_Process_AccessKey_PersonalServiceVinnica()
                                             , zc_Enum_Process_AccessKey_PersonalServiceKrRog()
                                             , zc_Enum_Process_AccessKey_PersonalServiceNikolaev()
                                             , zc_Enum_Process_AccessKey_PersonalServiceKharkov()
                                             , zc_Enum_Process_AccessKey_PersonalServiceCherkassi()
                                             , zc_Enum_Process_AccessKey_PersonalServiceDoneck()
                                             , zc_Enum_Process_AccessKey_PersonalServiceOdessa()
                                             , zc_Enum_Process_AccessKey_PersonalServiceZaporozhye()

                                             , zc_Enum_Process_AccessKey_PersonalServiceIrna()
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


              , MAX (CASE WHEN AccessKeyId IN (zc_Enum_Process_AccessKey_GuideAll()
                                              )
                               THEN AccessKeyId
                          ELSE 0
                     END) AS AccessKeyId_all


         FROM Object_RoleAccessKey_View
         WHERE AccessKeyId <> 0
         GROUP BY UserId
        ) AS tmpAccessKey
              LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect_Object_Unit_byProfitLossDirection
                                                                     ON AccessKeyId_all = 0
                                                                   AND ((AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                                                     AND (ProfitLossDirectionCode IN (20100 -- Общепроизводственные расходы + Содержание производства
                                                                                                    , 20200 -- Общепроизводственные расходы + Содержание складов
                                                                                                    , 20300 -- Общепроизводственные расходы + Содержание транспорта
                                                                                                    , 20400 -- Общепроизводственные расходы + Содержание Кухни
                                                                                                    , 30200 -- Административные расходы + Содержание транспорта
                                                                                                     )
                                                                          OR UnitCode IN (22012 -- Отдел экспедиторов
                                                                                        , 21000 -- Транспорт - сбыт
                                                                                         )
                                                                          OR (UnitCode NOT IN (11010 -- АУП
                                                                                             , 11030 -- Бухгалтерия
                                                                                             , 23010 -- Отдел Маркетинга
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

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServicePav()
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceOther()
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbitM()
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                                                     AND UnitCode NOT IN (23010) -- Отдел Маркетинга
                                                                     AND ProfitLossDirectionCode IN (40100 -- Расходы на сбыт + Содержание транспорта
                                                                                                   , 40200 -- Расходы на сбыт + Содержание филиалов
                                                                                                   , 40300 -- Расходы на сбыт + Общефирменные
                                                                                                    )
                                                                        )

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                                                     AND UnitCode IN (23010) -- Отдел Маркетинга
                                                                     AND ProfitLossDirectionCode IN (40300 -- Расходы на сбыт + Общефирменные
                                                                                                    )
                                                                        )

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSB()
                                                                     -- AND UnitCode IN (13000, 13010) -- Охрана + Служба безопастности
                                                                     AND ProfitLossDirectionCode IN (30300 -- Административные расходы + Содержание охраны
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                                                        )

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceKiev()
                                                                     AND BranchId IN (8379    -- филиал Киев
                                                                                    , 3080683 -- филиал Львов
                                                                                     )
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceLviv()
                                                                     AND BranchId = 3080683 -- филиал Львов
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceVinnica()
                                                                     AND BranchId = 11920989 -- Филиал Винница
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceIrna()
                                                                     AND BranchId = 8109544 -- филиал Ирна
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceKrRog()
                                                                     AND BranchId = 8377 -- филиал Кр.Рог
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceNikolaev()
                                                                     AND BranchId = 8373 -- филиал Николаев (Херсон)
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceKharkov()
                                                                     AND BranchId = 8381 -- филиал Харьков
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceCherkassi()
                                                                     AND BranchId = 8375 -- филиал Черкассы (Кировоград)
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceDoneck()
                                                                     AND BranchId = 8378 -- филиал Донецк
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceOdessa()
                                                                     AND BranchId = 8374 -- филиал Одесса
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceZaporozhye()
                                                                     AND BranchId = 301310 -- филиал Запорожье
                                                                        )
                                                                       )
           ;

ALTER TABLE Object_RoleAccessKeyGuide_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.15                                        * add ...Odessa
 20.10.14                                        * add ...Zaporozhye
 23.09.14                                        * add AccessKeyId_PeriodClose
 17.09.14                                        *
 08.09.14                                        *
*/

-- тест
-- SELECT * FROM Object_RoleAccessKeyGuide_View
