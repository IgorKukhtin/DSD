-- �������� �������� �������
-- Function: lpCheckPeriodClose_local()

DROP FUNCTION IF EXISTS lpCheckPeriodClose_local (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose_local(
    IN inOperDate        TDateTime , -- 
    IN inMovementId      Integer   , -- 
    IN inMovementDescId  Integer   , -- 
    IN inUserId          Integer     -- ������������
)
RETURNS VOID
AS
$BODY$  
BEGIN
     -- !!!������ �������������� �/� - ��� �����������!!!
     IF inUserId IN (zc_Enum_Process_Auto_PrimeCost()
                   --, zc_Enum_Process_Auto_ReComplete()
                   --, zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_PartionClose()
                   -- , zc_Enum_Process_Auto_Defroster()
                   -- , zfCalc_UserAdmin() :: Integer -- ��������: !!!��� ������ - ��� �����������!!!
                    )
        AND 1=0
     THEN
          RETURN; -- !!!�����!!!
     END IF;


     -- �������� �.�.
     IF (inUserId IN (9031170)
        -- ����������� 7 ���� ��-�� (��������)
        OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
        )
        AND inOperDate < CURRENT_DATE - INTERVAL '7 DAY'
     THEN
         RAISE EXCEPTION '������.���� ��������� = <%>.��������� �������������� ��������� � <%>.'
                       , zfConvert_DateToString (inOperDate)
                       , zfConvert_DateToString (CURRENT_DATE - INTERVAL '7 DAY')
                        ;
     END IF;


     IF inMovementDescId IN (zc_Movement_Cash()) AND inOperDate < CURRENT_DATE
        AND (EXTRACT (HOUR FROM CURRENT_TIMESTAMP) >= 8 OR inOperDate < CURRENT_DATE - INTERVAL '1 DAY')
        AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE inUserId <> 5 AND Object_RoleAccessKey_View.UserId = inUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Cash())
      --AND (inUserId NOT IN (409393, 3183549) --  ����� �.�.
      --  OR inOperDate < '06.10.2023')
     THEN
         RAISE EXCEPTION '������.��� ��������� <%> �� <%> ������ ������ �� <%>.(%)'
                        , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Cash())
                        , zfConvert_DateToString (inOperDate)
                        , CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) < 8
                               THEN zfConvert_DateToString (CURRENT_DATE - INTERVAL '2 DAY')
                               ELSE zfConvert_DateToString (CURRENT_DATE - INTERVAL '1 DAY')
                          END
                        , inUserId
                         ;
     END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.16                                        * ALL
 25.02.14                        *
*/

-- ����
-- SELECT lpCheckPeriodClose_local (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inUserId:= 9031170), Movement.* FROM Movement WHERE Id = 3091408
