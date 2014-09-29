-- View: Object_RoleAccessKeyGuide_View

-- DROP VIEW IF EXISTS Object_RoleAccessKeyGuide_View;

CREATE OR REPLACE VIEW Object_RoleAccessKeyGuide_View AS

   SELECT tmpAccessKey.UserId
        , tmpAccessKey.AccessKeyId_Guide
        , tmpAccessKey.AccessKeyId_PersonalService
        , tmpAccessKey.AccessKeyId_PeriodClose

        , CASE WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDnepr()
                    THEN 257163 -- ���������� �����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKiev()
                    THEN 257164 -- ���������� ����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 257165 -- ���������� �������� (������)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257166 -- ���������� ������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideCherkassi()
                    THEN 257167 -- ���������� �������� (����������)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257168 -- ���������� ����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKrRog()
                    THEN 257169 -- ���������� ��.���

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDoneck()
                    THEN 257170 -- ���������� ������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKharkov()
                    THEN 257171 -- ���������� �������

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257172 -- ���������� ��������

               ELSE 0
          END AS JuridicalGroupId

        , CASE WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDnepr()
                    THEN 8380 -- ������ �����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKiev()
                    THEN 8379 -- ������ ����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 8373 -- ������ �������� (������)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 8374 -- ������ ������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideCherkassi()
                    THEN 8375 -- ������ �������� (����������)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 8376 -- ������ ����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKrRog()
                    THEN 8377 -- ������ ��.���

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDoneck()
                    THEN 8378 -- ������ ������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKharkov()
                    THEN 8381 -- ������ �������

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 18342 -- ������ ��������

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
                                                                     AND (ProfitLossDirectionCode IN (20100 -- �������������������� ������� + ���������� ������������
                                                                                                    , 20200 -- �������������������� ������� + ���������� �������
                                                                                                    , 20300 -- �������������������� ������� + ���������� ����������
                                                                                                    , 20400 -- �������������������� ������� + ���������� �����
                                                                                                    , 30200 -- ���������������� ������� + ���������� ����������
                                                                                                     )
                                                                          OR (UnitCode NOT IN (11010 -- ���
                                                                                             , 11030 -- �����������
                                                                                             , 23010 -- ����� ����������
                                                                                             , 23020 -- ����� ���������
                                                                                             , 23040 -- ����� ��������� (�������������)
                                                                                              )
                                                                              AND ProfitLossDirectionCode IN (30100 -- ���������������� ������� + ���������� �����
                                                                                                            , 40300 -- ������� �� ���� + �������������
                                                                                                             )
                                                                             )
                                                                         )
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin()
--                                                                     AND ProfitLossDirectionCode IN (30100 -- ���������������� ������� + ���������� �����
--                                                                                                   , 30200 -- ���������������� ������� + ���������� ����������
--                                                                                                    )
                                                                                                     )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                                                     AND UnitCode NOT IN (23010) -- ����� ����������
                                                                     AND ProfitLossDirectionCode IN (40300 -- ������� �� ���� + �������������
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                                                     AND UnitCode IN (23010) -- ����� ����������
                                                                     AND ProfitLossDirectionCode IN (40300 -- ������� �� ���� + �������������
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSB()
                                                                     -- AND UnitCode IN (13000, 13010) -- ������ + ������ �������������
                                                                     AND ProfitLossDirectionCode IN (30300 -- ���������������� ������� + ���������� ������
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                                                                                    )
           ;

ALTER TABLE Object_RoleAccessKeyGuide_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.14                                        * add AccessKeyId_PeriodClose
 17.09.14                                        *
 08.09.14                                        *
*/

-- ����
-- SELECT * FROM Object_RoleAccessKeyGuide_View
