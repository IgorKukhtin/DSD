-- Function: lfGet_ObjectCode (Integer, Integer)

-- DROP FUNCTION lfGet_ObjectCode (Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_ObjectCode(
    IN inObjectCode Integer, 
    IN inDescId Integer
)
RETURNS Integer AS
$BODY$
  DECLARE vbObjectCode Integer;
BEGIN
     IF COALESCE (inObjectCode, 0) = 0
     THEN 
         SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO vbObjectCode FROM Object WHERE DescId = inDescId;
     ELSE
         vbObjectCode:=inObjectCode;
     END IF;
     
     RETURN (vbObjectCode);

END;
$BODY$ LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_ObjectCode (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.13                                        * rename vbObjectCode
 20.06.13          *                             *

*/

-- ����
-- SELECT * FROM lfGet_ObjectCode (0, zc_Object_Goods())
