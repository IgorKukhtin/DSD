-- Function: lpUpdate_Object_PartionGoods_Movement

DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_Movement (Integer, Integer, Integer, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_PartionGoods_Movement(
    IN inMovementId             Integer,       -- ���� ���������
    IN inPartnerId              Integer,       -- ��c������
    IN inUnitId                 Integer,       -- �������������(�������)
    IN inOperDate               TDateTime,     -- ���� �������
    IN inCurrencyId             Integer,       -- ������ ��� ���� �������
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN

       -- �������� �� ���� ������� ������ - ������ ���������
       UPDATE Object_PartionGoods SET PartnerId            = inPartnerId
                                    , UnitId               = inUnitId
                                    , OperDate             = inOperDate
                                    , CurrencyId           = inCurrencyId
       WHERE Object_PartionGoods.MovementId = inMovementId;
                                     
END;                                 
$BODY$                               
  LANGUAGE plpgsql VOLATILE;           
                                     
/*------------------------------     -------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
06.06.17                                         *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_PartionGoods_Movement()
