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
   DECLARE vbOperDate        TDateTime;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbDescId          Integer;
   DECLARE vbCloseDate       TDateTime;
   DECLARE vbAccessKeyId     Integer;
   DECLARE vbStatusId        Integer;
   DECLARE vbUserId_save     Integer;
   DECLARE vbStatusId_old    Integer;
 --DECLARE vbRoleName TVarChar;
BEGIN

  -- ���������
  vbUserId_save:= inUserId;
  -- ��������
  inUserId:= ABS (inUserId);
  
  -- !!!������ �������� �������!!!
  PERFORM lpCheckPeriodClose_auditor (NULL, NULL, inMovementId, NULL, NULL, inUserId);

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

  -- 1.0.1.
  vbStatusId_old:= (SELECT StatusId FROM Movement WHERE Id = inMovementId);

  -- ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete(), StatusId_next = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  RETURNING OperDate, DescId, AccessKeyId, StatusId INTO vbOperDate, vbDescId, vbAccessKeyId, vbStatusId;

  -- !!! zc_Enum_Process_Auto_PrimeCost
  IF vbStatusId_old = zc_Enum_Status_Erased() AND vbDescId = zc_Movement_Transport() AND inUserId = zc_Enum_Process_Auto_PrimeCost()
  THEN
      RAISE EXCEPTION '������.Complete zc_Movement_Transport AND zc_Enum_Process_Auto_PrimeCost where MovementId = <%>', inMovementId;
  END IF;

  -- 1.0.
  vbOperDatePartner:= (SELECT MovementDate.ValueData
                       FROM MovementDate
                       WHERE MovementDate.MovementId = inMovementId
                         AND MovementDate.DescId     = zc_MovementDate_OperDatePartner()
                         AND vbDescId                <> zc_Movement_Service()
                      );


  -- �������� - �������� �.�.
  IF inUserId IN (9031170) OR vbDescId = zc_Movement_Cash()
     -- ����������� 7 ���� ��-�� (��������)
     OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
  THEN
      PERFORM lpCheckPeriodClose_local (vbOperDate, inMovementId, vbDescId, inUserId);
  END IF;


  -- 1.1. ��������
  IF COALESCE (vbDescId, -1) <> COALESCE (inDescId, -2)
  THEN
      RAISE EXCEPTION '������.��� ��������� �� ���������.<%><%>.% �������� � <%> �� <%> � ������� <%>.'
                         , vbDescId
                         , inDescId
                         , CHR (13)
                         , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                         , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                         , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                          ;
  END IF;
  -- 1.2. ��������
  /*IF COALESCE (vbStatusId, 0) NOT IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  THEN
      RAISE EXCEPTION '������.��������� � <%> �� <%> ��� ��������.<%><%>', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbStatusId, inMovementId;
  END IF;*/


  -- �� ���� ���-��� !!!��� �������� �������!!!
  IF inDescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
  THEN

  -- ��� ������  - ��� �����
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- �������� ���� ��� <AccessKey>
  IF inDescId = zc_Movement_Sale() AND vbUserId_save > 0
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT MAX (ProcessId) FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- ���������� ���������� - ��� �������� �� �������
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;

  ELSE
  IF inDescId = zc_Movement_ReturnIn() AND NOT (lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) = zc_Enum_Process_AccessKey_DocumentDnepr() AND vbAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKrRog(), zc_Enum_Process_AccessKey_DocumentZaporozhye()))
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_ReturnIn())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- ���������� ���������� - ��� �������� �� �������
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
         -- ���������� ������� - ��� �������
         AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11539194)
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- ���������� ���������� - ��� �������� �� �������
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
         -- ���������� ������� - ��� �������
         AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11539194)
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� <%> � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- ���������� ���������� - ��� �������� �� �������
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
         -- ���������� ������� - ��� �������
         AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11539194)
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ���������� ��������� <%> � <%> �� <%> ������ <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;
  END IF;


  IF vbUserId_save > 0 OR COALESCE (vbDescId, 0) <> zc_Movement_PersonalService()
  THEN
      -- !!!����� ����� �������� - �������� ������!!!
      PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                                , inMovementId    := inMovementId
                                , inMovementDescId:= inDescId
                                , inAccessKeyId   := vbAccessKeyId
                                , inUserId        := inUserId
                                 );
    
      -- ���� ���� ��� ����, ����� ��� ���
      IF vbOperDatePartner IS NOT NULL
      THEN
          -- !!!����� ����� �������� - �������� ������!!!
          PERFORM lpCheckPeriodClose (inOperDate      := vbOperDatePartner
                                    , inMovementId    := inMovementId
                                    , inMovementDescId:= inDescId
                                    , inAccessKeyId   := vbAccessKeyId
                                    , inUserId        := inUserId
                                     );
      END IF;

  END IF;

  -- ���� !!!����� ����� �������� - �������� ������!!!, ������� ��� ��� ������ - �� ����
  /*
  -- !!!��������!!!
  IF inUserId NOT IN (-1 -- 128491 -- ������� �.�. !!!��������!!!
                    -- , 5
                    -- , zc_Enum_Process_Auto_Pack()
                     )
  THEN
  -- !!!�������� ���� �� ���������� ���������!!!
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = 82392) -- ����������(�.�.)-���� ����������
     AND inDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 7 -- �� ���������� ���������
           ) AS tmp;
      -- 3.2. �������� <�������� �������>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� � <%> �� <%> �� ��������. ��� ���� <%> ������ ������ �� <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbRoleName, DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
  -- !!!�������� ���� ������ ��� + ��!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!������ �������� �����!!!
     AND inUserId <> 12120 -- ��������� �.�. !!!��������!!!
     AND (EXISTS (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
          OR vbAccessKeyId <> zc_Enum_Process_AccessKey_DocumentDnepr()
         )
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                           AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 5 -- �������� ������� ������ ��� + ��
           ) AS tmp;
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!�������� ���� ���������!!!
  IF inDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
  THEN
      -- 3.1. ������������ ���� ��� <�������� �������>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                           AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 3 -- ��������� + �������������
           ) AS tmp;

      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
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
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 4 -- �������� ������� ���� ���
           ) AS tmp;
      -- 3.2. �������� <�������� �������>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
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
           , tmp.RoleName                                                                           AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT (CASE WHEN PeriodClose.Period  = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate)                ELSE zc_DateStart() END) AS CloseDate
                 , (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , (PeriodClose.Name) AS RoleName
            FROM PeriodClose
                 INNER JOIN ObjectLink_UserRole_View AS View_UserRole
                                                     ON View_UserRole.RoleId = PeriodClose.RoleId
                                                    AND View_UserRole.UserId = inUserId
            -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = inDescId)
            WHERE PeriodClose.Id <= 7
            ORDER BY 1 DESC, 2 DESC
            LIMIT 1
           ) AS tmp;
      -- 3.2. �������� ���� ��� <�������� �������>
      IF vbOperDate < vbCloseDate
      THEN 
          -- RAISE EXCEPTION '������.��������� � ��������� � <%> �� <%> �� ��������.��� ���� <%> ������ ������ �� <%>.(%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), TO_CHAR (vbOperDate, 'DD.MM.YYYY'), vbRoleName, TO_CHAR (vbCloseDate, 'DD.MM.YYYY'), inMovementId;
          RAISE EXCEPTION '������.��������� � ��������� � <%> �� <%> �� ��������. ��� ���� <%> ������ ������ �� <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbRoleName, DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
         IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!������ �������� �����!!!
         THEN
             -- !!!�������� ���� ��� �� ���!!!
             -- 3.1. ������������ ���� ��� <�������� �������>
             SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
                  , tmp.RoleName                                                                           AS RoleName
                    INTO vbCloseDate, vbRoleName
             FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                        , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                        , MAX (PeriodClose.Name) AS RoleName
                   FROM PeriodClose
                   WHERE PeriodClose.Id = 6 -- �������� ������� ���� ��
                  ) AS tmp;
             -- 3.2. �������� ���� ��� <�������� �������>
             IF vbOperDate < vbCloseDate
             THEN 
                 RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> ������ ������ �� <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
             END IF;
         END IF;

  END IF; -- !!!�������� ���� ������ ��� + ��!!!
  END IF; -- !!!�������� ���� ���������!!!
  END IF; -- !!!�������� ���� ��� ���!!!
  END IF; -- !!!�������� ���� �� ���������� ���������!!!
  END IF; -- !!!�������� ���� �� ���!!! ELSE !!!�������� ���� ��� �� ���!!!

  END IF; -- !!!��������!!!
  */

  END IF; -- �� ���� ���-��� !!!��� �������� �������!!!


  -- ��������� ��������
  IF inUserId <> 5 OR 1=1
  THEN
      PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);
  END IF;

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
