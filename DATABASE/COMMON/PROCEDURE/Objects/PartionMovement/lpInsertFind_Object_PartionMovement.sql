-- Function: lpInsertFind_Object_PartionMovement (Integer)

-- DROP FUNCTION lpInsertFind_Object_PartionMovement (Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovement(
    IN inMovementId  Integer -- ������ �� ��������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionMovementId Integer;
BEGIN
   
   -- 
   IF COALESCE (inMovementId, 0) = 0
   THEN vbPartionMovementId:= 0; -- !!!����� ��� ������, � ������� � ������ ������� �� ���������!!!
   ELSE
       -- ������� 
       vbPartionMovementId:= (SELECT ObjectId FROM ObjectFloat WHERE ValueData = inMovementId AND DescId = zc_ObjectFloat_PartionMovement_MovementId());

       IF COALESCE (vbPartionMovementId, 0) = 0
       THEN
           -- ��������� <������>
           vbPartionMovementId := lpInsertUpdate_Object (vbPartionMovementId, zc_Object_PartionMovement(), 0, inMovementId :: TVarChar);
           -- ���������
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionMovement_MovementId(), vbPartionMovementId, inMovementId :: TFloat);

       END IF;
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
 26.05.15                                        * all
 13.02.14                                        * !!!����� ��� ������!!! �� �� �������
 27.09.13                                        * !!!����� ��� ������!!!
 02.07.13                                        * ������� Find, ����� ���� ���� Insert
 02.07.13          *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionMovement (inMovementId:= 123)