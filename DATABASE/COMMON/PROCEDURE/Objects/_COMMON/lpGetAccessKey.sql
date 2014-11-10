-- Function: lpGetAccessKey()

DROP FUNCTION IF EXISTS lpGetAccessKey (Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetAccessKey(
    IN inUserId      Integer      , -- 
    IN inProcessId   Integer        -- 
 )
RETURNS Integer
AS
$BODY$
  DECLARE vbValueId Integer;
BEGIN

  -- ��� ������  - ��� �����
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN
      -- Transport
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Transport()
                       , zc_Enum_Process_Get_Movement_Transport()
                       , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                       , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                       , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                       , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                       , zc_Enum_Process_Get_Movement_TransportService()
                       , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 24)); -- ��������� �����
      ELSE
      -- Document
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Income()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                       , zc_Enum_Process_InsertUpdate_Movement_Sale()
                       , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                       , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                       , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                       , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()
                       , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                       , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 104)); -- ��������� �������� ����� (������ ���������)
      ELSE
      -- Service
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                       , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 44)); -- ���������� �����
      ELSE
      -- Cash
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                       , zc_Enum_Process_Get_Movement_Cash()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM ObjectLink_UserRole_View WHERE RoleId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 54)); -- ����� �����
      ELSE
      -- PersonalService - 
      IF inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService()
                        )
      THEN
           inUserId := (SELECT MAX (UserId) FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin());
      ELSE
          RAISE EXCEPTION '������.� ���� <%> ������ ���������� �������� ��� ������� ���������.', lfGet_Object_ValueData (zc_Enum_Role_Admin());

      END IF;
      END IF;
      END IF;
      END IF;
      END IF;
  END IF;

  -- �������� - ������ ���� ������ "����" ������� (������ ���������)
  IF EXISTS (SELECT 1 FROM (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId NOT IN (zc_Enum_Process_AccessKey_TrasportAll()
                                                                                                                            , zc_Enum_Process_AccessKey_GuideAll()
                                                                                                                             )
                                                                             AND RoleCode NOT IN (22 -- ���������-�������� ���� ����������
                                                                                                , 32 -- ���������� ���������-�������� ���� ����������
                                                                                                , 42 -- ����������-�������� ���� ����������
                                                                                                , 48 -- ����������(�.�.)-�������� ���� ����������
                                                                                                , 52 -- �����-�������� ���� ����������
                                                                                                , 102 -- ������/������� ���������-�������� ���� ����������
                                                                                                , 122 -- �������/������� ����������-�������� ���� ����������
--                                                                                                , 1101 -- ����
                                                                                                 )
                                                                             AND ((RoleCode BETWEEN 40 and 49
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                               OR (NOT RoleCode BETWEEN 40 and 49
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                 , zc_Enum_Process_Get_Movement_Cash()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                 , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                  )
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                         , zc_Enum_Process_Get_Movement_Cash()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                         , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                          )
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                                 )
             GROUP BY AccessKeyId) AS tmp
             HAVING Count(*) = 1)
  THEN
      vbValueId := (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId NOT IN (zc_Enum_Process_AccessKey_TrasportAll()
                                                                                                                    , zc_Enum_Process_AccessKey_GuideAll()
                                                                                                                     )
                                                                             AND RoleCode NOT IN (22 -- ���������-�������� ���� ����������
                                                                                                , 32 -- ���������� ���������-�������� ���� ����������
                                                                                                , 42 -- ����������-�������� ���� ����������
                                                                                                , 48 -- ����������(�.�.)-�������� ���� ����������
                                                                                                , 52 -- �����-�������� ���� ����������
                                                                                                , 102 -- ������/������� ���������-�������� ���� ����������
                                                                                                , 122 -- �������/������� ����������-�������� ���� ����������
--                                                                                                , 1101 -- ����
                                                                                                 )
                                                                             AND ((RoleCode BETWEEN 40 and 49
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                               OR (NOT RoleCode BETWEEN 40 and 49
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Service()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ProfitLossService())
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                 , zc_Enum_Process_Get_Movement_Cash()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                 , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                 , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                   )
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = inProcessId)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                                                                                         , zc_Enum_Process_Get_Movement_Cash()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                                                                                         , zc_Enum_Process_Get_Movement_TransportService()
                                                                                                         , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                                                                                          )
                                                                                  )
                                                                                 )
                                                                             AND ((AccessKeyId IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                               AND inProcessId IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                               OR (AccessKeyId NOT IN (SELECT AccessKeyId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PersonalService <> 0)
                                                                                   AND inProcessId NOT IN (zc_Enum_Process_InsertUpdate_Movement_PersonalService())
                                                                                  )
                                                                                 )
             GROUP BY AccessKeyId
            );
  ELSE
      RAISE EXCEPTION '������.� ������������ <%> ������ ���������� �������� ��� ������� ���������.', lfGet_Object_ValueData (inUserId);
  END IF;  
  

  IF COALESCE (vbValueId, 0) = 0
  THEN
      RAISE EXCEPTION '������.� ������������ <%> ������ ���������� �������� ��� ������� ���������.', lfGet_Object_ValueData (inUserId);
  ELSE RETURN vbValueId;
  END IF;  


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpGetAccessKey (Integer, Integer)  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.10.14                                        * add Object_RoleAccessKeyDocument_View
 25.08.14                                        * add zc_Enum_Process_InsertUpdate_Movement_OrderExternal() and zc_Enum_Process_InsertUpdate_Movement_OrderInternal()
 08.05.14                                        * add 1101 -- ����
 06.03.14                                        * add RoleCode
 10.02.14                                        * add Document...
 13.01.14                                        * ���������� ����� ������ :-)
 15.12.13                                        * add zc_Enum_Process_AccessKey_TrasportAll
 07.12.13                                        *
*/

-- ����
-- SELECT * FROM lpGetAccessKey (zfCalc_UserAdmin() :: Integer, null)
