-- Function: gpSelect_ShowPUSH_TechnicalRediscount(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_TechnicalRediscount(integer,integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_TechnicalRediscount(
    IN inMovementID   integer,          -- Id ���������
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

   IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementID)
   THEN
     outShowMessage := False;
     RETURN;
   END IF;
   
      outShowMessage := True;
      outPUSHType := 3;
      outText := '�������� ������ ��� ������ ���.�����ר��!!!
���� ��� ���������� ������� ����� ��� ������ �������, �� ������� ���.�������� � ����� (���� ����� ������� �������� ������ ����� �������)!
���� ��� ���������� ������� ����� �� �ר� �������� ���.��������������, �� ������� ��� ���������������!!! � ���.���������! ��� ���� � ������� "���������" � ������������ ������� ���������� �� ����� ������ ���� ������ �������!!!
���� �� ������������� �������/����� �������, �� � ������������ ������� �������������� ��������� � ��� (���� ����)!!!
��� ��������� � ������� ������ ���� ����������� ��������� �� ������� ����������!!!
������ ��� ��������� ��� ��������� ���������, ����������� ��������� ��� ����� � �����, �������� �������� ����� � ������ �����, � ������ ����.������!!!';

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.08.20                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_TechnicalRediscount(inMovementID := 19447685 , inSession := '3')


select * from gpSelect_ShowPUSH_TechnicalRediscount(inMovementID := 21332817 ,  inSession := '3999200');