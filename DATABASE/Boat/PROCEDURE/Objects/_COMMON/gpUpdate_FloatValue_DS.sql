-- Function: gpUpdate_FloatValue_DS (TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_FloatValue_DS (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_FloatValue_DS(
    IN inValue    TFloat,       --
   OUT outValue   TFloat,       --
    IN inSession  TVarChar      -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
BEGIN

   -- ���������
   outValue:= inValue;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 24.02.18                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_FloatValue_DS (inSession := zfCalc_UserAdmin());
