-- Function: lpComplete_Movement_All_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_All_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_All_CreateTemp ()
RETURNS VOID
AS
$BODY$
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         DELETE FROM _tmpMIContainer_insert;
     ELSE
         -- ������� - ��������
         CREATE TEMP TABLE _tmpMIContainer_insert (Id             BigInt
                                                 , DescId         Integer
                                                 , MovementDescId Integer -- ��� ���������
                                                 , MovementId     Integer
                                                 , MovementItemId Integer
                                                 , ContainerId    Integer
                                                 , ParentId       BigInt

                                                 , AccountId               Integer -- ����
                                                 , AnalyzerId              Integer -- ���� �������� (��������)
                                                 , ObjectId_Analyzer       Integer -- MovementItem.ObjectId
                                                 , PartionId               Integer -- MovementItem.PartionId
                                                 , WhereObjectId_Analyzer  Integer -- ����� �����

                                                 , AccountId_Analyzer      Integer -- ���� - �������������

                                                 , ContainerId_Analyzer    Integer -- ��������� ���� - ������ ����
                                                 , ContainerIntId_Analyzer Integer -- ��������� - �������������

                                                 , ObjectIntId_Analyzer    Integer -- ������������� ���������� (������, �� ������ ��� ���-�� ��������� - �.�. ��� �� ��� �� ��������� � ��������� ����)
                                                 , ObjectExtId_Analyzer    Integer -- ������������� ���������� (������������� - �������������, ������������� ��, ���, ���������� � �.�. - �.�. ��� �� ��� �� ��������� � ��������� ����)

                                                 , Amount         TFloat
                                                 , OperDate       TDateTime
                                                 , IsActive       Boolean
                                                  ) ON COMMIT DROP;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
