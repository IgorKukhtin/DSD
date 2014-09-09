-- View: Object_RoleAccessKeyGuide_View

DROP VIEW IF EXISTS Object_RoleAccessKeyGuide_View;

CREATE OR REPLACE VIEW Object_RoleAccessKeyGuide_View AS

   SELECT tmpAccessKey.UserId
        , tmpAccessKey.AccessKeyId_Guide
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.09.14                                        *
*/

-- ����
-- SELECT * FROM Object_RoleAccessKeyGuide_View
