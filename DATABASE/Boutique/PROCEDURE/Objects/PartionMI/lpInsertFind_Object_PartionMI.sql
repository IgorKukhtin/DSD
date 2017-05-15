-- Function: lpInsertFind_Object_PartionMovement (Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionMI (Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMI(
    IN inMovementItemId  Integer -- ������ �� ������� ���������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionMI_Id Integer;
BEGIN
   
   -- 
   IF COALESCE (inMovementItemId, 0) = 0
      THEN vbPartionMI_Id:= 0; -- !!!����� ��� ������, � ������� � ������ ������� �� ���������!!!
   ELSE
       -- ������� 
       vbPartionMI_Id:= (SELECT Id FROM Object WHERE ObjectCode = inMovementItemId AND DescId = zc_Object_PartionMI());

       IF COALESCE (vbPartionMI_Id, 0) = 0
       THEN
           -- ��������� <������>
           vbPartionMI_Id := lpInsertUpdate_Object (vbPartionMI_Id, zc_Object_PartionMI(), inMovementItemId, '');

       END IF;
   END IF;

   -- ���������� ��������
   RETURN (vbPartionMI_Id);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.05.17         *
 27.05.15                          *
 04.05.15                          *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionMI (inMovementItemId:= 123)