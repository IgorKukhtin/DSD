-- Function: zfGetBranchFromUnitId

DROP FUNCTION IF EXISTS zfGetPaidKindFrom1CType (TVarChar);

CREATE OR REPLACE FUNCTION zfGetPaidKindFrom1CType(in1CTypeId TVarChar)
RETURNS Integer AS
$BODY$
BEGIN
  RETURN (SELECT CASE in1CTypeId 
                          WHEN '1' THEN zc_Enum_PaidKind_FirstForm()
                          WHEN '2' THEN zc_Enum_PaidKind_SecondForm()
                          WHEN '3' THEN zc_Enum_PaidKind_SecondForm()
                          WHEN '4' THEN zc_Enum_PaidKind_FirstForm()
                     END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGetPaidKindFrom1CType (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.08.14                        *  
 03.02.14                        *  
*/

-- ����
-- SELECT * FROM zfGetBranchFromUnitId (1)
