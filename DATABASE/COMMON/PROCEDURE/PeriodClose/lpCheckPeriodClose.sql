-- �������� �������� �������
-- Function: gpSelect_Object_Process()

DROP FUNCTION IF EXISTS lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose(
    IN inOperDate        TDateTime
    IN inMovementId      Integer
    IN inMovementDescId  Integer
    IN inAccessKeyId     Integer
    IN inUserId          Integer      , -- ������������
)
RETURNS VOID
AS
$BODY$  
   DECLARE vbBranchId Integer;
BEGIN
     -- !!!�������������� �/� - ��� �����������!!!
     IF inUserId IN (zc_Enum_Process_Auto_PrimeCost()
     THEN -- !!!�����!!!
          RETURN;
     END IF;
     -- �� ���� ���-��� !!!��� �������� �������!!!
     IF inMovementDescId IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
     THEN -- !!!�����!!!
          RETURN;
     END IF;
     -- !!!��� ������  - ��� �����������!!!
     IF inUserId = 5 -- EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE inUserId = 5 AND ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
     THEN -- !!!�����!!!
          RETURN;
     END IF;
     -- ���� ������ ���, ����� ����� ����� - !!!�� ��� PeriodClose.Period �� ����� ��������!!!
     IF NOT EXISTS (SELECT 1 FROM PeriodClose WHERE PeriodClose.CloseDate > inOperDate)
     THEN -- !!!�����!!!
          RETURN;
     END IF;


     -- ����������� ������
     vbBranchId:= zfGet_Branch_AccessKey (inAccessKeyId);


     -- ���� ��� - �������, ����� - !!!���������� "������" �����!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPeriodClose')
     THEN
         -- �������
         CREATE TEMP TABLE _tmpPeriodClose (Id BigInt, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
         -- �������� ��� ������ �� PeriodClose
         WITH tmpDesc AS (SELECT tmp.DescId
                              , STRING_AGG (tmp.DescName, '; ') :: TVarChar AS DescName
                         FROM lpSelect_PeriodClose_Desc (inSession:= inSession) AS tmp
                         GROUP BY tmp.DescId
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
         INSERT INTO _tmpPeriodClose (CloseDate, UserId, UserId_excl, MovementDescId, MovementDescId_excl, BranchId, PaidKindId, CloseDate_excl)
            SELECT tmpData.CloseDate_calc AS CloseDate
                 , tmpData.UserId_calc    AS UserId
                 , tmpData.UserId_excl
                 , tmpData.DescId
                 , tmpData.DescId_excl
                 , tmpData.BranchId
                 , tmpData.PaidKindId
                 , tmpData.CloseDate_excl
            FROM tmpData
     END IF;


     -- 1. ����������

     -- 1-�� ��� DescId
     IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE MovementDescId = inMovementDescId AND UserId_excl = inUserId AND CloseDate_excl <= inOperDate)
     THEN -- !!!���������!!!
          RETURN;
     END IF;
     -- 2-�� ��� BranchId = 0
     IF vbBranchId = zc_Branch_Basis()
     THEN
         -- ��� "��������" ������� - ���� ���� ������������ �������� � ������� "��� ����"
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE MovementDescId = 0 AND MovementDescId_excl <> inMovementDescId AND UserId_excl = inUserId AND CloseDate_excl <= inOperDate AND BranchId = 0)
         THEN -- !!!���������!!!
              RETURN;
         END IF;
     ELSE
         IF -- ��� "��������" ������� - ���� ���� ������������ �������� � ������� "��� ����"
            EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE MovementDescId = 0 AND MovementDescId_excl <> inMovementDescId AND UserId_excl = inUserId AND CloseDate_excl <= inOperDate AND BranchId = 0)
         OR (-- ��� "��������" ������� - ���� ��� ��������� �� ������ � "�������" �������
             EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE CloseDate <= inOperDate AND MovementDescId = 0 AND MovementDescId_excl <> inMovementDescId AND BranchId = 0)
             -- ��� "��������" ������� - ���� ���� ������������ �������� � ������� vbBranchId
         AND EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE MovementDescId = 0 AND MovementDescId_excl <> inMovementDescId AND UserId_excl = inUserId AND CloseDate_excl <= inOperDate AND BranchId = vbBranchId)
            )
         THEN -- !!!���������!!!
              RETURN;
         END IF;
     END IF;


     -- 1-�� ����� ��� 3-� ����������: inUserId + inMovementDescId + 
     PeriodClose

     

  THEN
     RAISE EXCEPTION '������ ������';
  END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckPeriodClose (Integer, Integer)  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.14                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Process('2')

