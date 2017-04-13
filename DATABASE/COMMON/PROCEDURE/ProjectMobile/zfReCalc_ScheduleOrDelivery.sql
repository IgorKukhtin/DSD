DROP FUNCTION IF EXISTS zfReCalc_ScheduleOrDelivery (TVarChar, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfReCalc_ScheduleOrDelivery (
    IN inSchedule   TVarChar, -- ������ ��������� ��, �� ����� ���� ������ - � ������� 7 �������� ����������� ";" t ������ true � f ������ false
    IN inDelivery   TVarChar, -- ������ ������ �� ��, �� ����� ���� ������ - � ������� 7 �������� ����������� ";" t ������ true � f ������ false
    IN inisDelivery Boolean   -- ���� true, ������� ������������� �������� ������� ������, ����� ������� �������� ������� ���������
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbSchedule TVarChar; 
   DECLARE vbDelivery TVarChar; 
   DECLARE vbisDelivery Boolean;
BEGIN
      vbisDelivery:= COALESCE (inisDelivery, false);
      vbSchedule:= CASE WHEN COALESCE (inSchedule, '') = '' THEN 'f;f;f;f;f;f;f' ELSE inSchedule END;
      vbDelivery:= COALESCE (inDelivery, '');

      IF vbDelivery = ''
      THEN -- ���� ������ ��������� �����, � ������ ������ �� �����, ����� ������������ ������ ������ �� ��������� 
           -- ������� ��������� �� ������� ������ �� ����
           vbDelivery:= CASE WHEN CHAR_LENGTH (vbSchedule) > 12 THEN SUBSTRING (vbSchedule FROM 13 FOR 1) || ';' ELSE 'f;' END || SUBSTRING (vbSchedule FROM 1 FOR 11);
      END IF;

      -- ��������� 
      RETURN CASE WHEN vbisDelivery THEN vbDelivery ELSE vbSchedule END;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 12.04.17                                                        *   
*/

-- ����
/* 
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= NULL, inDelivery:= NULL, inisDelivery:= false)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= '', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f;t;f', inDelivery:= '', inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f;t;f', inDelivery:= NULL, inisDelivery:= false)
*/