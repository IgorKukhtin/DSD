-- Function: lfGet_ObjectCode_byEnum (TVarChar)

-- DROP FUNCTION lfGet_ObjectCode_byEnum (TVarChar);

CREATE OR REPLACE FUNCTION lfGet_ObjectCode_byEnum(
    IN inEnumName     TVarChar
)
RETURNS Integer AS
$BODY$
  DECLARE vbObjectCode Integer;
BEGIN
     -- ���������� ��� �� �������� inEnumName
     SELECT Object.ObjectCode INTO vbObjectCode
     FROM ObjectString AS ObjectString_Enum
          LEFT JOIN Object ON Object.Id = ObjectString_Enum.ObjectId
     WHERE ObjectString_Enum.ValueData = inEnumName
       AND ObjectString_Enum.DescId = zc_ObjectString_Enum();
     
     RETURN (vbObjectCode);

END;
$BODY$ LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_ObjectCode_byEnum (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.13                                        *

*/

-- ����
-- SELECT lfGet_ObjectCode_byEnum ('zc_Enum_Process_Select_Object_Goods')
-- SELECT lfGet_ObjectCode_byEnum ('zc_Enum_Status_UnComplete')
