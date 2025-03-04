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

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideLviv()
                    -- THEN 257164 -- ���������� ����
                    THEN 280271 -- ���������� �����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideVinnica()
                    THEN 280276 -- ���������� ³�����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 257165 -- ���������� �������� (������)

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideOdessa()
                    THEN 257166 -- ���������� ������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideCherkassi()
                    THEN 257167 -- ���������� �������� (����������)

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_Guide()
               --      THEN 257168 -- ���������� ����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKrRog()
                    THEN 257169 -- ���������� ��.���

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDoneck()
                    THEN 257170 -- ���������� ������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKharkov()
                    THEN 257171 -- ���������� �������

               -- WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_()
               --      THEN 257172 -- ���������� ��������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideZaporozhye()
                    THEN 301805 -- ���������� ���������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideIrna()
                    THEN 8235255 -- ���������� ����

               ELSE 0
          END AS JuridicalGroupId

        , CASE WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideDnepr()
                    THEN 8380 -- ������ �����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideKiev()
                    THEN 8379 -- ������ ����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideLviv()
                    THEN 3080683 -- ������ �����

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideVinnica()
                    THEN 11920989 -- ������ �������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideNikolaev()
                    THEN 8373 -- ������ �������� (������)

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideOdessa()
                    THEN 8374 -- ������ ������

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

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideZaporozhye()
                    THEN 301310 -- ������ ���������

               WHEN tmpAccessKey.AccessKeyId_Guide = zc_Enum_Process_AccessKey_GuideIrna()
                    THEN 8109544 -- ������ ����

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
                                                                     AND (ProfitLossDirectionCode IN (20100 -- �������������������� ������� + ���������� ������������
                                                                                                    , 20200 -- �������������������� ������� + ���������� �������
                                                                                                    , 20300 -- �������������������� ������� + ���������� ����������
                                                                                                    , 20400 -- �������������������� ������� + ���������� �����
                                                                                                    , 30200 -- ���������������� ������� + ���������� ����������
                                                                                                     )
                                                                          OR UnitCode IN (22012 -- ����� ������������
                                                                                        , 21000 -- ��������� - ����
                                                                                         )
                                                                          OR (UnitCode NOT IN (11010 -- ���
                                                                                             , 11030 -- �����������
                                                                                             , 23010 -- ����� ����������
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

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServicePav()
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceOther()
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbitM()
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                                                     AND UnitCode NOT IN (23010) -- ����� ����������
                                                                     AND ProfitLossDirectionCode IN (40100 -- ������� �� ���� + ���������� ����������
                                                                                                   , 40200 -- ������� �� ���� + ���������� ��������
                                                                                                   , 40300 -- ������� �� ���� + �������������
                                                                                                    )
                                                                        )

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                                                     AND UnitCode IN (23010) -- ����� ����������
                                                                     AND ProfitLossDirectionCode IN (40300 -- ������� �� ���� + �������������
                                                                                                    )
                                                                        )

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSB()
                                                                     -- AND UnitCode IN (13000, 13010) -- ������ + ������ �������������
                                                                     AND ProfitLossDirectionCode IN (30300 -- ���������������� ������� + ���������� ������
                                                                                                    ))
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                                                        )

                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceKiev()
                                                                     AND BranchId IN (8379    -- ������ ����
                                                                                    , 3080683 -- ������ �����
                                                                                     )
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceLviv()
                                                                     AND BranchId = 3080683 -- ������ �����
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceVinnica()
                                                                     AND BranchId = 11920989 -- ������ �������
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceIrna()
                                                                     AND BranchId = 8109544 -- ������ ����
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceKrRog()
                                                                     AND BranchId = 8377 -- ������ ��.���
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceNikolaev()
                                                                     AND BranchId = 8373 -- ������ �������� (������)
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceKharkov()
                                                                     AND BranchId = 8381 -- ������ �������
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceCherkassi()
                                                                     AND BranchId = 8375 -- ������ �������� (����������)
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceDoneck()
                                                                     AND BranchId = 8378 -- ������ ������
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceOdessa()
                                                                     AND BranchId = 8374 -- ������ ������
                                                                        )
                                                                     OR (AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceZaporozhye()
                                                                     AND BranchId = 301310 -- ������ ���������
                                                                        )
                                                                       )
           ;

ALTER TABLE Object_RoleAccessKeyGuide_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.15                                        * add ...Odessa
 20.10.14                                        * add ...Zaporozhye
 23.09.14                                        * add AccessKeyId_PeriodClose
 17.09.14                                        *
 08.09.14                                        *
*/

-- ����
-- SELECT * FROM Object_RoleAccessKeyGuide_View
