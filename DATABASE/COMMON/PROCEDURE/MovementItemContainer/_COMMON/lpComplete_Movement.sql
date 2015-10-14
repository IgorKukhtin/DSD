-- Function: lpComplete_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement(
    IN inMovementId        Integer  , -- ���� ������� <��������>
    IN inDescId            Integer  , -- 
    IN inUserId            Integer    -- ������������
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbCloseDate TDateTime;
   DECLARE vbRoleId Integer;

   DECLARE vbAccessKeyId Integer;
BEGIN
  -- ��������
  /*IF EXISTS (SELECT MovementId FROM MovementItemContainer WHERE MovementId = inMovementId)
  THEN
      RAISE EXCEPTION '������.���������� ��������.���������� ����������.';
  END IF;*/

  -- 0. ��������
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION '������.�������� �� ��������.';
  END IF;

  -- ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = inDescId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  RETURNING OperDate, AccessKeyId INTO vbOperDate, vbAccessKeyId;


  -- �� ���� ���-��� !!!��� �������� �������!!!
  IF inDescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
  THEN

  -- ��� ������  - ��� �����
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- �������� ���� ��� <AccessKey>
  IF inDescId = zc_Movement_Sale()
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT MAX (ProcessId) FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- ������� �.�. !!!��������!!!
         AND inUserId <> 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
         AND inUserId <> 81707 -- ������ �.�.
         AND inUserId <> 131160 -- ������ �.�. !!!��������!!!
         -- AND inUserId <> 81241 -- ������� �.�. !!!��������!!!
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_ReturnIn()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_ReturnIn())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- ������� �.�. !!!��������!!!
         AND inUserId <> 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
         AND inUserId <> 81707 -- ������ �.�.
         AND inUserId <> 131160 -- ������ �.�. !!!��������!!!
         -- AND inUserId <> 81241 -- ������� �.�. !!!��������!!!
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� <%> � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� <%> � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;
  END IF;

/*
  -- !!!��������!!!
  IF inUserId IN (128491 -- ������� �.�. !!!��������!!!
                , 442559 -- ���������� �.�. -- 409618 -- �������� �.�. !!!��������!!!
                 )
  THEN RETURN;
  END IF;
*/
  -- !!!�������� ���� ������ ��� + ��!!!
  IF EXISTS (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
     OR vbAccessKeyId <> zc_Enum_Process_AccessKey_DocumentDnepr()
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleId                                                                            AS RoleId
             INTO vbCloseDate, vbRoleId
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.RoleId) AS RoleId
            FROM PeriodClose
            WHERE PeriodClose.Id = 5 -- �������� ������� ������ ��� + ��
           ) AS tmp;
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), lfGet_Object_ValueData (vbRoleId), inMovementId;
      END IF;

  ELSE
  -- !!!�������� ���� ���������!!!
  IF inDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleId                                                                            AS RoleId
             INTO vbCloseDate, vbRoleId
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.RoleId) AS RoleId
            FROM PeriodClose
            WHERE PeriodClose.Id = 3 -- ��������� + �������������
           ) AS tmp;

      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), lfGet_Object_ValueData (vbRoleId), inMovementId;
      END IF;

  ELSE
  -- !!!�������� ���� ��� ���!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!������ �������� �����!!!
     AND (EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom(), zc_MovementLinkObject_PaidKindTo()) AND ObjectId = zc_Enum_PaidKind_SecondForm())
       OR inDescId IN (zc_Movement_Cash(), zc_Movement_FounderService(), zc_Movement_PersonalAccount(), zc_Movement_PersonalReport(), zc_Movement_PersonalSendCash(), zc_Movement_PersonalService()
                     , zc_Movement_Inventory(), zc_Movement_Loss(), zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion(), zc_Movement_Send(), zc_Movement_SendOnPrice()
                     , zc_Movement_Transport(), zc_Movement_TransportService())
       OR EXISTS (SELECT MovementItem.MovementId
                  FROM MovementItem
                       JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                                  AND MovementItemLinkObject.ObjectId = zc_Enum_PaidKind_SecondForm()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.isErased = FALSE
                 )
         )
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleId                                                                            AS RoleId
             INTO vbCloseDate, vbRoleId
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.RoleId) AS RoleId
            FROM PeriodClose
            WHERE PeriodClose.Id = 4 -- �������� ������� ���� ���
           ) AS tmp;
      -- 3.2. �������� <�������� �������>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), lfGet_Object_ValueData (vbRoleId), inMovementId;
      END IF;

  ELSE
  -- !!!�������� ���� �� ���������� ���������!!!
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = 82392) -- ����������(�.�.)-���� ����������
     AND inDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleId                                                                            AS RoleId
             INTO vbCloseDate, vbRoleId
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.RoleId) AS RoleId
            FROM PeriodClose
            WHERE PeriodClose.Id = 7 -- �� ���������� ���������
           ) AS tmp;
      -- 3.2. �������� <�������� �������>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� � <%> �� <%> �� ��������. ��� ���� <%> ������ ������ �� <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (vbRoleId), DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
  -- !!!�������� ���� �� ���!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!������ �������� �����!!!
     AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind() AND ObjectId = zc_Enum_PaidKind_SecondForm())
     AND EXISTS (SELECT 1 FROM PeriodClose JOIN ObjectLink_UserRole_View AS View_UserRole ON View_UserRole.RoleId = PeriodClose.RoleId AND View_UserRole.UserId = inUserId
                 -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = inDescId)
                )
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleId                                                                            AS RoleId
             INTO vbCloseDate, vbRoleId
      FROM (SELECT (CASE WHEN PeriodClose.Period  = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate)                ELSE zc_DateStart() END) AS CloseDate
                 , (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , (PeriodClose.RoleId) AS RoleId
            FROM PeriodClose
                 INNER JOIN ObjectLink_UserRole_View AS View_UserRole
                                                     ON View_UserRole.RoleId = PeriodClose.RoleId
                                                    AND View_UserRole.UserId = inUserId
            -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = inDescId)
            ORDER BY 1 DESC, 2 DESC
            LIMIT 1
           ) AS tmp;
      -- 3.2. �������� ���� ��� <�������� �������>
      IF vbOperDate < vbCloseDate
      THEN 
          -- RAISE EXCEPTION '������.��������� � ��������� � <%> �� <%> �� ��������.��� ���� <%> ������ ������ �� <%>.(%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), TO_CHAR (vbOperDate, 'DD.MM.YYYY'), lfGet_Object_ValueData (vbRoleId), TO_CHAR (vbCloseDate, 'DD.MM.YYYY'), inMovementId;
          RAISE EXCEPTION '������.��������� � ��������� � <%> �� <%> �� ��������. ��� ���� <%> ������ ������ �� <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (vbRoleId), DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
         IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!������ �������� �����!!!
         THEN
             -- !!!�������� ���� ��� �� ���!!!
             -- 3.1. ������������ ���� ��� <�������� �������>
             SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
                  , tmp.RoleId                                                                            AS RoleId
                    INTO vbCloseDate, vbRoleId
             FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                        , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                        , MAX (PeriodClose.RoleId) AS RoleId
                   FROM PeriodClose
                   WHERE PeriodClose.Id = 6 -- �������� ������� ���� ��
                  ) AS tmp;
             -- 3.2. �������� ���� ��� <�������� �������>
             IF vbOperDate < vbCloseDate
             THEN 
                 RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), lfGet_Object_ValueData (vbRoleId), inMovementId;
             END IF;
         END IF;

  END IF; -- !!!�������� ���� ������ ��� + ��!!!
  END IF; -- !!!�������� ���� ���������!!!
  END IF; -- !!!�������� ���� ��� ���!!!
  END IF; -- !!!�������� ���� �� ���������� ���������!!!
  END IF; -- !!!�������� ���� �� ���!!! ELSE !!!�������� ���� ��� �� ���!!!

  END IF; -- �� ���� ���-��� !!!��� �������� �������!!!


  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpComplete_Movement (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.14                                        * add vbAccessKeyId
 20.10.14                                        * add !!!�������� ���� �� ���!!!
 23.09.14                                        * add Object_Role_MovementDesc_View
 25.05.14                                        * add �������� ���� ��� <�������� �������>
 10.05.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement (inMovementId:= 55, inUserId:= 2)
