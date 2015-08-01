-- Function: lpInsertFind_Object_PartionMovement (Integer)

-- DROP FUNCTION lpInsertFind_Object_PartionMovement (Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovement(
    IN inMovementId  Integer     -- ������ �� �������� ������ �� ���������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionMovementId Integer;
BEGIN
   
   -- ������� 
   SELECT Id INTO vbPartionMovementId FROM Object 
    WHERE ObjectCode = inMovementId AND DescId = zc_Object_PartionMovement();

   IF COALESCE (vbPartionMovementId, 0) = 0
   THEN
           -- ��������� <������>
           vbPartionMovementId := lpInsertUpdate_Object (vbPartionMovementId, zc_Object_PartionMovement(), inMovementId, CAST (inMovementId AS TVarChar));

   END IF;
   -- ���������� ��������
   RETURN (vbPartionMovementId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionMovement (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.15                         * 

*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionMovement (inMovementId:= 123)