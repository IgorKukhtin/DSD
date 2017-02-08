-- Function: lfGet_InvNumber (Integer, Integer)

-- DROP FUNCTION lfGet_InvNumber (Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_InvNumber(
    IN inInvNumber Integer, 
    IN inDescId Integer
)
RETURNS Integer
AS
$BODY$
  DECLARE vbInvNumber Integer;
BEGIN
     IF COALESCE (inInvNumber, 0) = 0
     THEN 
         SELECT COALESCE (MAX (zfConvert_StringToNumber(InvNumber) ), 0) + 1 INTO vbInvNumber FROM Movement WHERE DescId = inDescId;
     ELSE
         vbInvNumber:=inInvNumber;
     END IF;
     
     RETURN (vbInvNumber);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_InvNumber (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.09.13                                        *
*/

-- ����
-- SELECT * FROM lfGet_InvNumber (0, zc_Movement_Income())
