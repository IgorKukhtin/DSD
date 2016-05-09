-- �������� �������� �������
-- Function: lpCheckPeriodClose()

DROP FUNCTION IF EXISTS lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose(
    IN inOperDate        TDateTime , -- 
    IN inMovementId      Integer   , -- 
    IN inMovementDescId  Integer   , -- 
    IN inAccessKeyId     Integer   , -- 
    IN inUserId          Integer     -- ������������
)
RETURNS VOID
AS
$BODY$  
   DECLARE vbBranchId          Integer;
   DECLARE vbPeriodCloseId     Integer;
   DECLARE vbPeriodCloseId_two Integer;
   DECLARE vbCloseDate         TDateTime;
BEGIN
     -- !!!������ �������������� �/� - ��� �����������!!! + ��������: !!!��� ������  - ��� �����������!!!
     IF inUserId IN (zc_Enum_Process_Auto_PrimeCost()
                   /*, zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Defroster(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_PartionClose()*/
                   /*, zfCalc_UserAdmin() :: Integer*/
                    )
        -- OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
          RETURN; -- !!!�����!!!
     END IF;
     -- �� ���� ���-��� !!!��� �������� �������!!!
     IF inMovementDescId IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
     THEN
          RETURN; -- !!!�����!!!
     END IF;
     -- ���� ������ ���, ����� ����� ����� - !!!�� ��� PeriodClose.Period �� ����� ��������!!!
     IF NOT EXISTS (SELECT 1 FROM PeriodClose WHERE PeriodClose.CloseDate > inOperDate)
     THEN
          RETURN; -- !!!�����!!!
     END IF;


     -- ����������� ������
     vbBranchId:= CASE WHEN inAccessKeyId > 0 THEN zfGet_Branch_AccessKey (inAccessKeyId) ELSE zc_Branch_Basis() END;

     -- !!!������ ��� �����!!!
     -- IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPeriodClose')) THEN DROP TABLE _tmpPeriodClose; END IF;
     -- !!!������ ��� �����!!!

     -- ���� ��� - �������, ����� - !!!�.�. ���������� "������" �����!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPeriodClose'))
     THEN
         -- �������
         CREATE TEMP TABLE _tmpPeriodClose (PeriodCloseId Integer, Code Integer, Name TVarChar, CloseDate TDateTime, UserId Integer, UserId_excl Integer, MovementDescId Integer, MovementDescId_excl Integer, BranchId Integer, PaidKindId Integer, CloseDate_excl TDateTime) ON COMMIT DROP;
         -- �������� ��� ������ �� PeriodClose
         WITH tmpDesc AS (SELECT tmp.DescId, tmp.MovementDescId FROM lpSelect_PeriodClose_Desc (inUserId:= inUserId) AS tmp
                         )
            , tmpTable AS (SELECT tmp.*
                                , CASE WHEN tmp.Date1 > tmp.Date2 THEN tmp.Date1 ELSE tmp.Date2 END AS CloseDate_calc
                                , COALESCE (tmpDesc.MovementDescId, 0)      AS MovementDescId
                                , COALESCE (tmpDesc_excl.MovementDescId, 0) AS MovementDescId_excl
                           FROM (SELECT PeriodClose.*
                                        -- ��� ��� "������ ������ ��"
                                      , CASE WHEN PeriodClose.Period =  INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END AS Date1
                                        -- ��� ��� "���� �������� �������, ���-�� ��."
                                      , CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - PeriodClose.Period :: INTERVAL ELSE zc_DateStart() END AS Date2
                                 FROM PeriodClose
                                ) AS tmp
                                LEFT JOIN tmpDesc ON tmpDesc.DescId = tmp.DescId
                                LEFT JOIN tmpDesc AS tmpDesc_excl ON tmpDesc_excl.DescId = tmp.DescId_excl
                          )
            , tmpData AS (SELECT tmpTable.*
                               , COALESCE (ObjectLink_UserRole_User.ChildObjectId, 0) AS UserId_calc
                          FROM tmpTable
                               LEFT JOIN ObjectLink AS ObjectLink_UserRole_Role
                                                    ON ObjectLink_UserRole_Role.ChildObjectId = tmpTable.RoleId
                                                   AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                               LEFT JOIN ObjectLink AS ObjectLink_UserRole_User
                                                    ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                                   AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                          )
         -- ���������
         INSERT INTO _tmpPeriodClose (PeriodCloseId, Code, Name, CloseDate, UserId, UserId_excl, MovementDescId, MovementDescId_excl, BranchId, PaidKindId, CloseDate_excl)
            SELECT tmpData.Id
                 , tmpData.Code
                 , tmpData.Name
                 , tmpData.CloseDate_calc AS CloseDate
                 , tmpData.UserId_calc    AS UserId
                 , tmpData.UserId_excl
                 , tmpData.MovementDescId
                 , tmpData.MovementDescId_excl
                 , COALESCE (tmpData.BranchId, 0)
                 , COALESCE (tmpData.PaidKindId, 0)
                 , tmpData.CloseDate_excl
            FROM tmpData;
     END IF;


     -- 1.1. ����� ��� "��������������"
     SELECT MAX (_tmpPeriodClose.PeriodCloseId) AS PeriodCloseId, MIN (_tmpPeriodClose.PeriodCloseId) AS vbPeriodCloseId_two, MAX (_tmpPeriodClose.CloseDate) AS CloseDate
            INTO vbPeriodCloseId, vbPeriodCloseId_two, vbCloseDate
     FROM _tmpPeriodClose
          LEFT JOIN (SELECT DISTINCT ObjectId AS PaidKindId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom(), zc_MovementLinkObject_PaidKindTo())
                    ) AS tmp1 ON tmp1.PaidKindId = _tmpPeriodClose.PaidKindId
          LEFT JOIN (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                     FROM MovementItem
                          JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                     AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = FALSE
                    ) AS tmp2 ON tmp2.PaidKindId = _tmpPeriodClose.PaidKindId
          LEFT JOIN (SELECT zc_Enum_PaidKind_FirstForm() AS PaidKindId WHERE inMovementDescId = zc_Movement_BankAccount()
                    UNION
                     SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE inMovementDescId <> zc_Movement_BankAccount()
                    ) AS tmp3 ON tmp3.PaidKindId = _tmpPeriodClose.PaidKindId
                             AND tmp1.PaidKindId IS NULL AND tmp2.PaidKindId IS NULL
     WHERE _tmpPeriodClose.MovementDescId = inMovementDescId AND _tmpPeriodClose.UserId = inUserId
       AND (_tmpPeriodClose.BranchId   = 0 OR _tmpPeriodClose.BranchId = vbBranchId)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp1.PaidKindId > 0 OR tmp2.PaidKindId > 0 OR tmp3.PaidKindId > 0);
     -- ��������
     IF vbPeriodCloseId <> vbPeriodCloseId_two
     THEN
        RAISE EXCEPTION '������1.��� ������������ <%> � ��� ��������� <%> �� ���������� �������� ������� <%> ��� <%>.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId_two)
                       ;
     END IF;

     -- �������� ��� "��������������"
     IF vbPeriodCloseId > 0
     THEN
         -- 1.2. ����������
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE _tmpPeriodClose.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose.UserId_excl = inUserId AND _tmpPeriodClose.CloseDate_excl <= inOperDate)
         THEN -- !!!���������!!!
              RETURN;
         END IF;

         -- 1.3. ��������
         IF inOperDate < vbCloseDate
         THEN 
             RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> �� <%> ������ ������ <%>.'
                           , (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                           , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                           , DATE (inOperDate)
                           , lfGet_Object_ValueData (inUserId)
                           , DATE (vbCloseDate)
                           , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                            ;
         END IF;

         -- 1.4. !!!�������� ������ �������!!!
         RETURN;

     END IF; -- �������� ��� "��������������"
     

     -- ������ �� ������
     IF vbBranchId = zc_Branch_Basis()
     THEN
     -- 2.1. ����� ��� "�����"
     SELECT MAX (_tmpPeriodClose.PeriodCloseId) AS PeriodCloseId, MIN (_tmpPeriodClose.PeriodCloseId) AS vbPeriodCloseId_two, MAX (_tmpPeriodClose.CloseDate) AS CloseDate
            INTO vbPeriodCloseId, vbPeriodCloseId_two, vbCloseDate
     FROM _tmpPeriodClose
          LEFT JOIN (SELECT DISTINCT ObjectId AS PaidKindId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom(), zc_MovementLinkObject_PaidKindTo())
                    ) AS tmp1 ON tmp1.PaidKindId = _tmpPeriodClose.PaidKindId
          LEFT JOIN (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                     FROM MovementItem
                          JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                     AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = FALSE
                    ) AS tmp2 ON tmp2.PaidKindId = _tmpPeriodClose.PaidKindId
          LEFT JOIN (SELECT zc_Enum_PaidKind_FirstForm() AS PaidKindId WHERE inMovementDescId = zc_Movement_BankAccount()
                    UNION
                     SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE inMovementDescId <> zc_Movement_BankAccount()
                    ) AS tmp3 ON tmp3.PaidKindId = _tmpPeriodClose.PaidKindId
                             AND tmp1.PaidKindId IS NULL AND tmp2.PaidKindId IS NULL
     WHERE _tmpPeriodClose.MovementDescId = 0 AND _tmpPeriodClose.UserId = 0 AND _tmpPeriodClose.MovementDescId_excl <> inMovementDescId
       AND (_tmpPeriodClose.BranchId   = 0)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp1.PaidKindId > 0 OR tmp2.PaidKindId > 0 OR tmp3.PaidKindId > 0);
     -- �������� - 1
     IF vbPeriodCloseId <> vbPeriodCloseId_two
     THEN
        RAISE EXCEPTION '������2.��� ������������ <%> � ��� ��������� <%> �� ���������� �������� ������� <%> ��� <%>.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId_two)
                       ;
     END IF;
     -- �������� - 2
     IF COALESCE (vbPeriodCloseId, 0) = 0
     THEN
        RAISE EXCEPTION '������2.��� ������������ <%> � ��� ��������� <%> �� ������� �������� �������.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                       ;
     END IF;

     -- �������� ��� "�����"
     IF vbPeriodCloseId > 0
     THEN
         -- 2.2. ����������
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE _tmpPeriodClose.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose.UserId_excl = inUserId AND _tmpPeriodClose.CloseDate_excl <= inOperDate)
         THEN -- !!!���������!!!
              RETURN;
         END IF;

         -- 2.3. ��������
         IF inOperDate < vbCloseDate
         THEN 
             RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> �� <%> ������ ������ <%>.'
                           , (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                           , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                           , DATE (inOperDate)
                           , lfGet_Object_ValueData (inUserId)
                           , DATE (vbCloseDate)
                           , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                            ;
         END IF;

         -- 2.4. !!!�������� ������ �������!!!
         -- RETURN;

     END IF; -- �������� ��� "�����"

     END IF; -- vbBranchId = zc_Branch_Basis() - ������ �� ������


     -- !!!�����, �.�. �� ������!!!
     IF vbBranchId = zc_Branch_Basis()
     THEN
          RETURN; -- !!!�����!!!
     END IF;


     -- �� ������ ������
     vbPeriodCloseId:= 0; vbPeriodCloseId_two:= 0;

     -- 3.1. ����� ��� "������"
     SELECT MAX (_tmpPeriodClose.PeriodCloseId) AS PeriodCloseId, MIN (_tmpPeriodClose.PeriodCloseId) AS vbPeriodCloseId_two, MAX (_tmpPeriodClose.CloseDate) AS CloseDate
            INTO vbPeriodCloseId, vbPeriodCloseId_two, vbCloseDate
     FROM _tmpPeriodClose
          LEFT JOIN (SELECT DISTINCT ObjectId AS PaidKindId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom(), zc_MovementLinkObject_PaidKindTo())
                    ) AS tmp1 ON tmp1.PaidKindId = _tmpPeriodClose.PaidKindId
          LEFT JOIN (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                     FROM MovementItem
                          JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                     AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = FALSE
                    ) AS tmp2 ON tmp2.PaidKindId = _tmpPeriodClose.PaidKindId
          LEFT JOIN (SELECT zc_Enum_PaidKind_FirstForm() AS PaidKindId WHERE inMovementDescId = zc_Movement_BankAccount()
                    UNION
                     SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE inMovementDescId <> zc_Movement_BankAccount()
                    ) AS tmp3 ON tmp3.PaidKindId = _tmpPeriodClose.PaidKindId
                             AND tmp1.PaidKindId IS NULL AND tmp2.PaidKindId IS NULL
     WHERE _tmpPeriodClose.MovementDescId = 0 AND _tmpPeriodClose.UserId = 0 AND _tmpPeriodClose.MovementDescId_excl <> inMovementDescId
       AND (_tmpPeriodClose.BranchId   = vbBranchId)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp1.PaidKindId > 0 OR tmp2.PaidKindId > 0 OR tmp3.PaidKindId > 0);
     -- �������� - 1
     IF vbPeriodCloseId <> vbPeriodCloseId_two
     THEN
        RAISE EXCEPTION '������3.��� ������������ <%> � ��� ��������� <%> �� ���������� �������� ������� <%> ��� <%>.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId_two)
                       ;
     END IF;
     -- �������� - 2
     IF COALESCE (vbPeriodCloseId, 0) = 0
     THEN
        RAISE EXCEPTION '������3.��� ������������ <%> � ��� ��������� <%> �� ������� �������� �������.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                       ;
     END IF;

     -- �������� ��� "������"
     IF vbPeriodCloseId > 0
     THEN
         -- 3.2. ����������
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE _tmpPeriodClose.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose.UserId_excl = inUserId AND _tmpPeriodClose.CloseDate_excl <= inOperDate)
         THEN -- !!!���������!!!
              RETURN;
         END IF;

         -- 3.3. ��������
         IF inOperDate < vbCloseDate
         THEN 
             RAISE EXCEPTION '������.��������� � ��������� <%> � <%> �� <%> �� ��������. ��� ������������ <%> �� <%> ������ ������ <%>.'
                           , (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                           , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                           , DATE (inOperDate)
                           , lfGet_Object_ValueData (inUserId)
                           , DATE (vbCloseDate)
                           , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                            ;
         END IF;

         -- 3.4. !!!�������� ������ �������!!!
         -- RETURN;

     END IF; -- �������� ��� "������"

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.16                                        * ALL
 25.02.14                        *
*/

-- ����
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3091408 -- ��������� ����� - ������� �.�.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3067578 -- ���� �� - ������� �.�.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 300547), Movement.* FROM Movement WHERE Id = 3424050 -- ���� �� - �������� �.�.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 76913), Movement.* FROM Movement WHERE Id = 2802779  -- ���������� ��������� - �������� �.�
