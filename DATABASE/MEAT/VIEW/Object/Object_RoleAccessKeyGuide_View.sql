-- View: Object_RoleAccessKeyGuide_View

DROP VIEW IF EXISTS Object_RoleAccessKeyGuide_View;

CREATE OR REPLACE VIEW Object_RoleAccessKeyGuide_View AS

   SELECT tmpAccessKey.UserId
        , tmpAccessKey.AccessKeyId_Guide
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
         FROM Object_RoleAccessKey_View 
         GROUP BY UserId
        ) AS tmpAccessKey;

ALTER TABLE Object_RoleAccessKeyGuide_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.09.14                                        *
*/

-- тест
-- SELECT * FROM Object_RoleAccessKeyGuide_View
