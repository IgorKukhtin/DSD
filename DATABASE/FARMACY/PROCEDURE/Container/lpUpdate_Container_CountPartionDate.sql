-- Function: lpUpdate_Container_CountPartionDate 

-- �������� ��� ����������� ������� �� �������� ������
DROP FUNCTION IF EXISTS lpUpdate_Container_CountPartionDate (Integer, TFloat);

CREATE OR REPLACE FUNCTION lpUpdate_Container_CountPartionDate(
    IN inContainerPDId    Integer  , -- ���������
    IN inDelta            TFloat     -- ����������
)
RETURNS Void AS
$BODY$
BEGIN

  update Container SET Amount = Amount + inDelta
  where  Container.DescId = zc_Container_CountPartionDate()
    and  Container.Id = inContainerPDId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.04.21                                                       *

*/

-- ����