-- Function: lpCheck_Movement_PersonalReport (Integer)

DROP FUNCTION IF EXISTS lpCheck_Movement_PersonalReport (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_PersonalReport(
    IN inMovementId  Integer  , -- ���� ������� <��������>
    IN inComment     TVarChar , -- 
    IN inUserId      Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN

          -- ��������
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Cash())
             OR EXISTS (SELECT 1 WHERE -1 * inMovementId = zc_Object_Cash())
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� % ������ ����� <�����, ������/������>.', inComment;
          END IF;
          -- ��������
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_BankAccount())
             OR EXISTS (SELECT 1 WHERE -1 * inMovementId = zc_Object_BankAccount())
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� % ������ ����� <��������� ����, ������/������>.', inComment;
          END IF;
          -- ��������
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PersonalSendCash())
             OR EXISTS (SELECT 1 WHERE -1 * inMovementId = zc_Object_Member())
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� % ������ ����� <�������� ����� � ��������� �� ��������>.', inComment;
          END IF;
          -- ��������
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PersonalAccount())
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� % ������ ����� <������� ��������� � ��.�����>.', inComment;
          END IF;
          -- ��������
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income())
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� % ������ ����� <������ (�������� ����)>.', inComment;
          END IF;
          -- ��������
          IF NOT EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PersonalReport())
             AND inMovementId > 0
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� % ������ ����� <�� ���������>.', inComment;
          END IF;
          -- ��������
          IF inMovementId < 0
             AND -1 * inMovementId <> zc_Object_Juridical()
             AND -1 * inMovementId <> zc_Object_Partner()
          THEN
              RAISE EXCEPTION '������.�������� ��� <%> �� ����� ���� %.', (SELECT ItemName FROM ObjectDesc WHERE Id = -1 * inMovementId), inComment;
          END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheck_Movement_PersonalReport (Integer, TVarChar, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.15                                        *
*/

-- ����
-- SELECT * FROM lpCheck_Movement_PersonalReport (inMovementId:= 55, inComment:= '', inUserId:= zfCalc_UserAdmin() :: Integer)
